    .text
    .arch armv8.2-a+sha3
    .align 4
    .global f1600
    .global _f1600

    .macro round_single
        eor3 v25.16b, v0.16b,  v5.16b,  v10.16b
        eor3 v26.16b, v1.16b,  v6.16b,  v11.16b
        eor3 v27.16b, v2.16b,  v7.16b,  v12.16b
        eor3 v28.16b, v3.16b,  v8.16b,  v13.16b
        eor3 v29.16b, v4.16b,  v9.16b,  v14.16b

        eor3 v25.16b, v25.16b, v15.16b, v20.16b
        eor3 v26.16b, v26.16b, v16.16b, v21.16b
        eor3 v27.16b, v27.16b, v17.16b, v22.16b
        eor3 v28.16b, v28.16b, v18.16b, v23.16b
        eor3 v29.16b, v29.16b, v19.16b, v24.16b

        rax1 v30.2d, v29.2d, v26.2d
        rax1 v29.2d, v27.2d, v29.2d
        rax1 v27.2d, v25.2d, v27.2d
        rax1 v25.2d, v28.2d, v25.2d
        rax1 v28.2d, v26.2d, v28.2d

        eor v0.16b, v0.16b, v30.16b
        mov v31.8b, v1.8b
        xar v1.2d,  v6.2d,  v27.2d, #20
        xar v6.2d,  v9.2d,  v25.2d, #44
        xar v9.2d,  v22.2d, v28.2d, #3
        xar v22.2d, v14.2d, v25.2d, #25
        xar v14.2d, v20.2d, v30.2d, #46
        xar v20.2d, v2.2d,  v28.2d, #2
        xar v2.2d,  v12.2d, v28.2d, #21
        xar v12.2d, v13.2d, v29.2d, #39
        xar v13.2d, v19.2d, v25.2d, #56
        xar v19.2d, v23.2d, v29.2d, #8
        xar v23.2d, v15.2d, v30.2d, #23
        xar v15.2d, v4.2d,  v25.2d, #37
        xar v4.2d,  v24.2d, v25.2d, #50
        xar v24.2d, v21.2d, v27.2d, #62
        xar v21.2d, v8.2d,  v29.2d, #9
        xar v8.2d,  v16.2d, v27.2d, #19
        xar v16.2d, v5.2d,  v30.2d, #28
        xar v5.2d,  v3.2d,  v29.2d, #36
        xar v3.2d,  v18.2d, v29.2d, #43
        xar v18.2d, v17.2d, v28.2d, #49
        xar v17.2d, v11.2d, v27.2d, #54
        xar v11.2d, v7.2d,  v28.2d, #58
        xar v7.2d,  v10.2d, v30.2d, #61
        xar v10.2d, v31.2d, v27.2d, #63

        bcax v25.16b, v0.16b,  v2.16b,  v1.16b
        bcax v26.16b, v1.16b,  v3.16b,  v2.16b
        bcax v2.16b,  v2.16b,  v4.16b,  v3.16b
        bcax v3.16b,  v3.16b,  v0.16b,  v4.16b
        bcax v4.16b,  v4.16b,  v1.16b,  v0.16b
        mov v0.8b, v25.8b
        mov v1.8b, v26.8b

        bcax v25.16b, v5.16b,  v7.16b,  v6.16b
        bcax v26.16b, v6.16b,  v8.16b,  v7.16b
        bcax v7.16b,  v7.16b,  v9.16b,  v8.16b
        bcax v8.16b,  v8.16b,  v5.16b,  v9.16b
        bcax v9.16b,  v9.16b,  v6.16b,  v5.16b
        mov v5.8b, v25.8b
        mov v6.8b, v26.8b

        bcax v25.16b, v10.16b, v12.16b, v11.16b
        bcax v26.16b, v11.16b, v13.16b, v12.16b
        bcax v12.16b, v12.16b, v14.16b, v13.16b
        bcax v13.16b, v13.16b, v10.16b, v14.16b
        bcax v14.16b, v14.16b, v11.16b, v10.16b
        mov v10.8b, v25.8b
        mov v11.8b, v26.8b

        bcax v25.16b, v15.16b, v17.16b, v16.16b
        bcax v26.16b, v16.16b, v18.16b, v17.16b
        bcax v17.16b, v17.16b, v19.16b, v18.16b
        bcax v18.16b, v18.16b, v15.16b, v19.16b
        bcax v19.16b, v19.16b, v16.16b, v15.16b
        mov v15.8b, v25.8b
        mov v16.8b, v26.8b

        bcax v25.16b, v20.16b, v22.16b, v21.16b
        bcax v26.16b, v21.16b, v23.16b, v22.16b
        bcax v22.16b, v22.16b, v24.16b, v23.16b
        bcax v23.16b, v23.16b, v20.16b, v24.16b
        bcax v24.16b, v24.16b, v21.16b, v20.16b
        mov v20.8b, v25.8b
        mov v21.8b, v26.8b

        ld1r {v25.2d}, [x1], #8
        eor v0.8b, v0.8b, v25.8b
    .endm

f1600:
_f1600:
    mov x2, x0
    mov x3, #6

    // Load state
    ldr d0,  [x0, #0]
    ldr d1,  [x0, #8]
    ldr d2,  [x0, #16]
    ldr d3,  [x0, #24]
    ldr d4,  [x0, #32]
    ldr d5,  [x0, #40]
    ldr d6,  [x0, #48]
    ldr d7,  [x0, #56]
    ldr d8,  [x0, #64]
    ldr d9,  [x0, #72]
    ldr d10, [x0, #80]
    ldr d11, [x0, #88]
    ldr d12, [x0, #96]
    ldr d13, [x0, #104]
    ldr d14, [x0, #112]
    ldr d15, [x0, #120]
    ldr d16, [x0, #128]
    ldr d17, [x0, #136]
    ldr d18, [x0, #144]
    ldr d19, [x0, #152]
    ldr d20, [x0, #160]
    ldr d21, [x0, #168]
    ldr d22, [x0, #176]
    ldr d23, [x0, #184]
    ldr d24, [x0, #192]

loop:
    round_single
    round_single
    round_single
    round_single

    subs x3, x3, #1
    cbnz x3, loop

    mov x0, x2

    str d0,  [x0, #0]
    str d1,  [x0, #8]
    str d2,  [x0, #16]
    str d3,  [x0, #24]
    str d4,  [x0, #32]
    str d5,  [x0, #40]
    str d6,  [x0, #48]
    str d7,  [x0, #56]
    str d8,  [x0, #64]
    str d9,  [x0, #72]
    str d10, [x0, #80]
    str d11, [x0, #88]
    str d12, [x0, #96]
    str d13, [x0, #104]
    str d14, [x0, #112]
    str d15, [x0, #120]
    str d16, [x0, #128]
    str d17, [x0, #136]
    str d18, [x0, #144]
    str d19, [x0, #152]
    str d20, [x0, #160]
    str d21, [x0, #168]
    str d22, [x0, #176]
    str d23, [x0, #184]
    str d24, [x0, #192]

    ret
