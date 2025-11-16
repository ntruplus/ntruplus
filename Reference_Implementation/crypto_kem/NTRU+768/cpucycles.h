#ifndef CPUCYCLE_H
#define CPUCYCLE_H

unsigned long long cyclegap;
#define TEST_LOOP_CPUCYCLE 100000

#if __APPLE__
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <stdint.h>
#include <stddef.h>

#define lib_path_kperf "/System/Library/PrivateFrameworks/kperf.framework/kperf"
#define lib_path_kperfdata                                                     \
  "/System/Library/PrivateFrameworks/kperfdata.framework/kperfdata"



typedef uint8_t u8;  
typedef int32_t i32;
typedef uint32_t u32;
typedef uint64_t u64;


#define KPC_MAX_COUNTERS 32

#define KPC_CLASS_CONFIGURABLE (1)
#define KPC_CLASS_CONFIGURABLE_MASK (1u << KPC_CLASS_CONFIGURABLE) // 2

typedef struct kpep_event {
  const char *name; ///< Unique name of a event, such as "INST_RETIRED.ANY".
  const char *description; ///< Description for this event.
  const char *errata;      ///< Errata, currently NULL.
  const char *alias;       ///< Alias name, such as "Instructions", "Cycles".
  const char *fallback;    ///< Fallback event name for fixed counter.
  u32 mask;
  u8 number;
  u8 umask;
  u8 reserved;
  u8 is_fixed;
} kpep_event;

typedef struct kpep_db
{
  const char *name;           ///< Database name, such as "haswell".
  const char *cpu_id;         ///< Plist name, such as "cpu_7_8_10b282dc".
  const char *marketing_name; ///< Marketing name, such as "Intel Haswell".
  void *plist_data;           ///< Plist data (CFDataRef), currently NULL.
  void *event_map; ///< All events (CFDict<CFSTR(event_name), kpep_event *>).
  kpep_event *event_arr; ///< Event struct buffer (sizeof(kpep_event) * events_count).
  kpep_event **fixed_event_arr; ///< Fixed counter events (sizeof(kpep_event *)
                                ///< * fixed_counter_count)
  void *alias_map; ///< All aliases (CFDict<CFSTR(event_name), kpep_event *>).
  size_t reserved_1;
  size_t reserved_2;
  size_t reserved_3;
  size_t event_count; ///< All events count.
  size_t alias_count;
  size_t fixed_counter_count;
  size_t config_counter_count;
  size_t power_counter_count;
  u32 archtecture; ///< see `KPEP CPU archtecture constants` above.
  u32 fixed_counter_bits;
  u32 config_counter_bits;
  u32 power_counter_bits;
} kpep_db;

typedef struct kpep_config {
  kpep_db *db;
  kpep_event **ev_arr; ///< (sizeof(kpep_event *) * counter_count), init NULL
  size_t *ev_map;       ///< (sizeof(size_t *) * counter_count), init 0
  size_t *ev_idx;       ///< (sizeof(size_t *) * counter_count), init -1
  u32 *flags;          ///< (sizeof(u32 *) * counter_count), init 0
  u64 *kpc_periods;    ///< (sizeof(u64 *) * counter_count), init 0
  size_t event_count;   /// kpep_config_events_count()
  size_t counter_count;
  u32 classes; ///< See `class mask constants` above.
  u32 config_counter;
  u32 power_counter;
  u32 reserved;
} kpep_config;

#define KPC_MAX_COUNTERS 32
static int (*kpc_set_counting)(u32 classes);
static int (*kpc_set_thread_counting)(u32 classes);
static int (*kpc_set_config)(u32 classes, u64 *config);
static int (*kpc_get_thread_counters)(u32 tid, u32 buf_count, u64 *buf);
static int (*kpc_force_all_ctrs_set)(int val);
static int (*kpc_force_all_ctrs_get)(int *val_out);

static int (*kpep_config_create)(kpep_db *db, kpep_config **cfg_ptr);
static void (*kpep_config_free)(kpep_config *cfg);
static int (*kpep_config_add_event)(kpep_config *cfg, kpep_event **ev_ptr, u32 flag, u32 *err);
static int (*kpep_config_remove_event)(kpep_config *cfg, size_t idx);
static int (*kpep_config_force_counters)(kpep_config *cfg);
static int (*kpep_config_events_count)(kpep_config *cfg, size_t *count_ptr);
static int (*kpep_config_events)(kpep_config *cfg, kpep_event **buf, size_t buf_size);
static int (*kpep_config_kpc)(kpep_config *cfg, u64 *buf, size_t buf_size);
static int (*kpep_config_kpc_count)(kpep_config *cfg, size_t *count_ptr);
static int (*kpep_config_kpc_classes)(kpep_config *cfg, u32 *classes_ptr);
static int (*kpep_config_kpc_map)(kpep_config *cfg, size_t *buf, size_t buf_size);
static int (*kpep_db_create)(const char *name, kpep_db **db_ptr);
static void (*kpep_db_free)(kpep_db *db);
static int (*kpep_db_event)(kpep_db *db, const char *name, kpep_event **ev_ptr);

typedef struct {
  const char *name;
  void **impl;
} lib_symbol;

#define lib_nelems(x) (sizeof(x) / sizeof((x)[0]))
#define lib_symbol_def(name)                                                   \
  {                                                                            \
#name, (void **)&name                                                      \
  }

static const lib_symbol lib_symbols_kperf[] = {
    lib_symbol_def(kpc_set_counting),
    lib_symbol_def(kpc_set_thread_counting),
    lib_symbol_def(kpc_set_config),
    lib_symbol_def(kpc_get_thread_counters),
    lib_symbol_def(kpc_force_all_ctrs_set),
    lib_symbol_def(kpc_force_all_ctrs_get)
};

static const lib_symbol lib_symbols_kperfdata[] = {
    lib_symbol_def(kpep_config_create),
    lib_symbol_def(kpep_config_free),
    lib_symbol_def(kpep_config_add_event),
    lib_symbol_def(kpep_config_remove_event),
    lib_symbol_def(kpep_config_force_counters),
    lib_symbol_def(kpep_config_events_count),
    lib_symbol_def(kpep_config_events),
    lib_symbol_def(kpep_config_kpc),
    lib_symbol_def(kpep_config_kpc_count),
    lib_symbol_def(kpep_config_kpc_classes),
    lib_symbol_def(kpep_config_kpc_map),
    lib_symbol_def(kpep_db_create),
    lib_symbol_def(kpep_db_free),
    lib_symbol_def(kpep_db_event)
};

static void *lib_handle_kperf = NULL;
static void *lib_handle_kperfdata = NULL;

#define EVENT_NAME_MAX 8
typedef struct {
  const char *alias;                 /// name for print
  const char *names[EVENT_NAME_MAX]; /// name from pmc db
} event_alias;

static const event_alias profile_events[] = {
    {"cycles",
     {
         "FIXED_CYCLES", // Apple A7-A15
         "CPU_CLK_UNHALTED.THREAD", // Intel Core 1th-10th
         "CPU_CLK_UNHALTED.CORE",   // Intel Yonah, Merom
     }},
    {"instructions",
     {
         "FIXED_INSTRUCTIONS", // Apple A7-A15
         "INST_RETIRED.ANY" // Intel Yonah, Merom, Core 1th-10th
     }},
    {"branches",
     {
         "INST_BRANCH",                  // Apple A7-A15
         "BR_INST_RETIRED.ALL_BRANCHES", // Intel Core 1th-10th
         "INST_RETIRED.ANY",             // Intel Yonah, Merom
     }},
    {"branch-misses",
     {
         "BRANCH_MISPRED_NONSPEC",       // Apple A7-A15, since iOS 15, macOS 12
         "BRANCH_MISPREDICT",            // Apple A7-A14
         "BR_MISP_RETIRED.ALL_BRANCHES", // Intel Core 2th-10th
         "BR_INST_RETIRED.MISPRED",      // Intel Yonah, Merom
     }},
};

static kpep_event *get_event(kpep_db *db, const event_alias *alias) {
  for (size_t j = 0; j < EVENT_NAME_MAX; j++) {
    const char *name = alias->names[j];
    if (!name)
      break;
    kpep_event *ev = NULL;
    if (kpep_db_event(db, name, &ev) == 0) {
      return ev;
    }
  }
  return NULL;
}

u64 regs[KPC_MAX_COUNTERS] = {0};
size_t counter_map[KPC_MAX_COUNTERS] = {0};
u64 counters_0[KPC_MAX_COUNTERS] = {0};
u64 counters_1[KPC_MAX_COUNTERS] = {0};
static const size_t ev_count = sizeof(profile_events) / sizeof(profile_events[0]);

bool init = false;
bool worked = false;

static inline unsigned long long int cpucycles(void)
{
    if (kpc_get_thread_counters(0, KPC_MAX_COUNTERS, counters_0))
    {
        printf("Failed get thread counters\n");
        return 1;
    }

    return counters_0[counter_map[0]];    
}

static int setup_rdtsc(void)
{
    lib_handle_kperf = dlopen(lib_path_kperf, RTLD_LAZY);
    if (!lib_handle_kperf) {
        fprintf(stderr, "Failed to open kperf\n");
        return -1;
    }

    lib_handle_kperfdata = dlopen(lib_path_kperfdata, RTLD_LAZY);
    if (!lib_handle_kperfdata) {
        fprintf(stderr, "Failed to load kperfdata\n");
        return -1;
    }

    for (size_t i = 0; i < lib_nelems(lib_symbols_kperf); i++) {
        const lib_symbol *symbol = &lib_symbols_kperf[i];
        *symbol->impl = dlsym(lib_handle_kperf, symbol->name);
        if (!*symbol->impl) {
            fprintf(stderr, "Failed to load kperf function: %s\n", symbol->name);
            return -1;
        }
    }
    for (size_t i = 0; i < lib_nelems(lib_symbols_kperfdata); i++) {
        const lib_symbol *symbol = &lib_symbols_kperfdata[i];
        *symbol->impl = dlsym(lib_handle_kperfdata, symbol->name);
        if (!*symbol->impl) {
            fprintf(stderr, "Failed to load kperfdata function: %s\n", symbol->name);
            return -1;
        }
    }

    // check permission
    int force_ctrs = 0;
    if (kpc_force_all_ctrs_get(&force_ctrs)) {
      printf("Permission denied, xnu/kpc requires root privileges.\n");
      return -1;
    }
    int ret;
    // load pmc db
    kpep_db *db = NULL;
    if ((ret = kpep_db_create(NULL, &db))) {
      printf("Error: cannot load pmc database: %d.\n", ret);
      return -1;
    }

    // create a config
    kpep_config *cfg = NULL;
    if ((ret = kpep_config_create(db, &cfg))) {
      printf("Failed to create kpep config\n");
        return -1;
    }
    if ((ret = kpep_config_force_counters(cfg))) {
      printf("Failed to force counters\n");
             return -1;
    }

    // get events
    kpep_event *ev_arr[ev_count] = {0};
    for (size_t i = 0; i < ev_count; i++) {
      const event_alias *alias = profile_events + i;
      ev_arr[i] = get_event(db, alias);
      if (!ev_arr[i]) {
        printf("Cannot find event: %s.\n", alias->alias);
        return -1;
      }
    }

    // add event to config
    for (size_t i = 0; i < ev_count; i++) {
      kpep_event *ev = ev_arr[i];
      if ((ret = kpep_config_add_event(cfg, &ev, 0, NULL))) {
        printf("Failed to add event\n");
               return -1;
      }
    }

    // prepare buffer and config
    u32 classes = 0;
    size_t reg_count = 0;
    if ((ret = kpep_config_kpc_classes(cfg, &classes))) {
      printf("Failed get kpc classes\n");
             return -1;
    }
    if ((ret = kpep_config_kpc_count(cfg, &reg_count))) {
      printf("Failed get kpc count\n");
             return -1;
    }
    if ((ret = kpep_config_kpc_map(cfg, counter_map, sizeof(counter_map)))) {
      printf("Failed get kpc map\n");
             return -1;
    }
    if ((ret = kpep_config_kpc(cfg, regs, sizeof(regs)))) {
      printf("Failed get kpc registers\n");
             return -1;
    }

    // set config to kernel
    if ((ret = kpc_force_all_ctrs_set(1))) {
      printf("Failed force all ctrs: %d.\n", ret);
      return -1;
    }
    if ((classes & KPC_CLASS_CONFIGURABLE_MASK) && reg_count) {
      if ((ret = kpc_set_config(classes, regs))) {
        printf("Failed set kpc config: %d.\n", ret);
        return -1;
      }
    }

    // start counting
    if ((ret = kpc_set_counting(classes))) {
      printf("Failed set counting: %d.\n", ret);
      return -1;
    }
    if ((ret = kpc_set_thread_counting(classes))) {
      printf("Failed set thread counting: %d.\n", ret);
      return -1;
    }

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
