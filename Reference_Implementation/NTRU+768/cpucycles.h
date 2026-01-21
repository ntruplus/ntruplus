#ifndef CPUCYCLE_H
#define CPUCYCLE_H

unsigned long long cyclegap;
#define TEST_LOOP_CPUCYCLE 100000

#if __APPLE__
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <dlfcn.h>

#define lib_path_kperf     "/System/Library/PrivateFrameworks/kperf.framework/kperf"
#define lib_path_kperfdata "/System/Library/PrivateFrameworks/kperfdata.framework/kperfdata"

#ifndef KPC_MAX_COUNTERS
#define KPC_MAX_COUNTERS 32
#endif

#define KPC_CLASS_CONFIGURABLE      (1u)
#define KPC_CLASS_CONFIGURABLE_MASK (1u << KPC_CLASS_CONFIGURABLE)

typedef uint32_t u32;
typedef uint64_t u64;

typedef struct kpep_db kpep_db;
typedef struct kpep_config kpep_config;
typedef struct kpep_event kpep_event;

static int (*kpc_set_counting)(u32 classes);
static int (*kpc_set_thread_counting)(u32 classes);
static int (*kpc_set_config)(u32 classes, u64 *config);
static int (*kpc_get_thread_counters)(u32 tid, u32 buf_count, u64 *buf);
static int (*kpc_force_all_ctrs_set)(int val);
static int (*kpc_force_all_ctrs_get)(int *val_out);

static int  (*kpep_db_create)(const char *name, kpep_db **db_ptr);
static void (*kpep_db_free)(kpep_db *db);
static int  (*kpep_db_event)(kpep_db *db, const char *name, kpep_event **ev_ptr);

static int  (*kpep_config_create)(kpep_db *db, kpep_config **cfg_ptr);
static void (*kpep_config_free)(kpep_config *cfg);
static int  (*kpep_config_force_counters)(kpep_config *cfg);
static int  (*kpep_config_add_event)(kpep_config *cfg, kpep_event **ev_ptr, u32 flag, u32 *err);
static int  (*kpep_config_kpc_classes)(kpep_config *cfg, u32 *classes_ptr);
static int  (*kpep_config_kpc_count)(kpep_config *cfg, size_t *count_ptr);
static int  (*kpep_config_kpc_map)(kpep_config *cfg, size_t *buf, size_t buf_size);
static int  (*kpep_config_kpc)(kpep_config *cfg, u64 *buf, size_t buf_size);

typedef struct { const char *name; void **impl; } sym_t;
#define SYM(x) { #x, (void**)&(x) }

static void *h_kperf = NULL;
static void *h_kpep  = NULL;

static size_t counter_map[KPC_MAX_COUNTERS];
static u64 regs[KPC_MAX_COUNTERS];
static u64 ctrs[KPC_MAX_COUNTERS];

static bool g_inited = false;

static int load_syms(void) {
    static const sym_t kperf_syms[] = {
        SYM(kpc_set_counting),
        SYM(kpc_set_thread_counting),
        SYM(kpc_set_config),
        SYM(kpc_get_thread_counters),
        SYM(kpc_force_all_ctrs_set),
        SYM(kpc_force_all_ctrs_get),
    };
    static const sym_t kpep_syms[] = {
        SYM(kpep_db_create),
        SYM(kpep_db_free),
        SYM(kpep_db_event),
        SYM(kpep_config_create),
        SYM(kpep_config_free),
        SYM(kpep_config_force_counters),
        SYM(kpep_config_add_event),
        SYM(kpep_config_kpc_classes),
        SYM(kpep_config_kpc_count),
        SYM(kpep_config_kpc_map),
        SYM(kpep_config_kpc),
    };

    h_kperf = dlopen(lib_path_kperf, RTLD_LAZY);
    if (!h_kperf) return -1;

    h_kpep = dlopen(lib_path_kperfdata, RTLD_LAZY);
    if (!h_kpep) return -1;

    for (size_t i = 0; i < sizeof(kperf_syms)/sizeof(kperf_syms[0]); i++) {
        *kperf_syms[i].impl = dlsym(h_kperf, kperf_syms[i].name);
        if (!*kperf_syms[i].impl) return -1;
    }
    for (size_t i = 0; i < sizeof(kpep_syms)/sizeof(kpep_syms[0]); i++) {
        *kpep_syms[i].impl = dlsym(h_kpep, kpep_syms[i].name);
        if (!*kpep_syms[i].impl) return -1;
    }
    return 0;
}

static kpep_event* find_cycles_event(kpep_db *db) {
    /* Apple Silicon / Intel fallback names */
    const char *names[] = {
        "FIXED_CYCLES",
        "CPU_CLK_UNHALTED.THREAD",
        "CPU_CLK_UNHALTED.CORE",
        NULL
    };
    for (int i = 0; names[i]; i++) {
        kpep_event *ev = NULL;
        if (kpep_db_event(db, names[i], &ev) == 0) return ev;
    }
    return NULL;
}

static inline uint64_t cpucycles(void)
{
    /* tid=0 : current thread */
    if (kpc_get_thread_counters(0, KPC_MAX_COUNTERS, ctrs)) return 0;
    return ctrs[counter_map[0]];
}

static int setup_rdtsc(void)
{
    if (g_inited) return 0;
    if (load_syms() != 0) {
        fprintf(stderr, "kperf/kpep symbol load failed\n");
        return -1;
    }

    int force = 0;
    if (kpc_force_all_ctrs_get(&force)) {
        fprintf(stderr, "Permission denied: kpc requires root privileges.\n");
        return -1;
    }

    kpep_db *db = NULL;
    if (kpep_db_create(NULL, &db)) return -1;

    kpep_config *cfg = NULL;
    if (kpep_config_create(db, &cfg)) { kpep_db_free(db); return -1; }
    if (kpep_config_force_counters(cfg)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }

    kpep_event *ev = find_cycles_event(db);
    if (!ev) {
        fprintf(stderr, "Cannot find cycles event in kpep db\n");
        kpep_config_free(cfg);
        kpep_db_free(db);
        return -1;
    }

    if (kpep_config_add_event(cfg, &ev, 0, NULL)) {
        kpep_config_free(cfg);
        kpep_db_free(db);
        return -1;
    }

    u32 classes = 0;
    size_t reg_count = 0;
    if (kpep_config_kpc_classes(cfg, &classes)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }
    if (kpep_config_kpc_count(cfg, &reg_count)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }
    if (kpep_config_kpc_map(cfg, counter_map, sizeof(counter_map))) { kpep_config_free(cfg); kpep_db_free(db); return -1; }
    if (kpep_config_kpc(cfg, regs, sizeof(regs))) { kpep_config_free(cfg); kpep_db_free(db); return -1; }

    /* push config into kernel */
    if (kpc_force_all_ctrs_set(1)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }
    if ((classes & KPC_CLASS_CONFIGURABLE_MASK) && reg_count) {
        if (kpc_set_config(classes, regs)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }
    }
    if (kpc_set_counting(classes)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }
    if (kpc_set_thread_counting(classes)) { kpep_config_free(cfg); kpep_db_free(db); return -1; }

    kpep_config_free(cfg);
    kpep_db_free(db);

    /* measure cyclegap */
    cyclegap = 0;
    for (int i = 0; i < TEST_LOOP_CPUCYCLE; i++) {
        uint64_t c1 = cpucycles();
        uint64_t c2 = cpucycles();
        cyclegap += (c2 - c1);
    }
    cyclegap /= TEST_LOOP_CPUCYCLE;

    g_inited = true;
    return 0;
}

#elif defined(__x86_64__) || defined(__i386__)

#include <stdint.h>

static inline uint64_t cpucycles(void)
{
    uint64_t result;
    __asm__ volatile ("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
                      : "=a" (result)
                      :
                      : "%rdx");
    return result;
}

static inline void setup_rdtsc(void)
{
    cyclegap = 0;  
    for (int i = 0; i < TEST_LOOP_CPUCYCLE; i++)
    {
      unsigned long long cycle1;
      unsigned long long cycle2;
  
      cycle1 = cpucycles();
      cycle2 = cpucycles();
      cyclegap += cycle2 - cycle1;
    }
    cyclegap = cyclegap / TEST_LOOP_CPUCYCLE;
}

#else
#include <stdint.h>
static inline void setup_rdtsc(void)
{
	return;
}

static inline uint64_t cpucycles(void)
{
	uint64_t t;
	asm volatile("mrs %0, PMCCNTR_EL0":"=r"(t));
	return t;
}
#endif
#endif
