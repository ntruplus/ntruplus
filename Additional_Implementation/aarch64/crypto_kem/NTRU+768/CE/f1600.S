    .text
    .align 4
    .global f1600
    .global _f1600

    .macro round_single
        eor3.16b v25, v0,  v5,  v10
        eor3.16b v26, v1,  v6,  v11
        eor3.16b v27, v2,  v7,  v12
        eor3.16b v28, v3,  v8,  v13
        eor3.16b v29, v4,  v9,  v14

        eor3.16b v25, v25, v15, v20
        eor3.16b v26, v26, v16, v21
        eor3.16b v27, v27, v17, v22
        eor3.16b v28, v28, v18, v23
        eor3.16b v29, v29, v19, v24

        rax1.2d v30, v29, v26
        rax1.2d v29, v27, v29
        rax1.2d v27, v25, v27
        rax1.2d v25, v28, v25
        rax1.2d v28, v26, v28

        eor.16b v0, v0, v30
        mov.8b v31, v1
        xar.2d v1,  v6,  v27, 20
        xar.2d v6,  v9,  v25, 44
        xar.2d v9,  v22, v28, 3
        xar.2d v22, v14, v25, 25
        xar.2d v14, v20, v30, 46
        xar.2d v20, v2,  v28, 2
        xar.2d v2,  v12, v28, 21
        xar.2d v12, v13, v29, 39
        xar.2d v13, v19, v25, 56
        xar.2d v19, v23, v29, 8
        xar.2d v23, v15, v30, 23
        xar.2d v15, v4,  v25, 37
        xar.2d v4,  v24, v25, 50
        xar.2d v24, v21, v27, 62
        xar.2d v21, v8,  v29, 9
        xar.2d v8,  v16, v27, 19
        xar.2d v16, v5,  v30, 28
        xar.2d v5,  v3,  v29, 36
        xar.2d v3,  v18, v29, 43
        xar.2d v18, v17, v28, 49
        xar.2d v17, v11, v27, 54
        xar.2d v11, v7,  v28, 58
        xar.2d v7,  v10, v30, 61
        xar.2d v10, v31, v27, 63

        bcax.16b v25, v0,  v2,  v1
        bcax.16b v26, v1,  v3,  v2
        bcax.16b v2,  v2,  v4,  v3
        bcax.16b v3,  v3,  v0,  v4
        bcax.16b v4,  v4,  v1,  v0
        mov.8b v0, v25
        mov.8b v1, v26

        bcax.16b v25, v5,  v7,  v6
        bcax.16b v26, v6,  v8,  v7
        bcax.16b v7,  v7,  v9,  v8
        bcax.16b v8,  v8,  v5,  v9
        bcax.16b v9,  v9,  v6,  v5
        mov.8b v5, v25
        mov.8b v6, v26

        bcax.16b v25, v10, v12, v11
        bcax.16b v26, v11, v13, v12
        bcax.16b v12, v12, v14, v13
        bcax.16b v13, v13, v10, v14
        bcax.16b v14, v14, v11, v10
        mov.8b v10, v25
        mov.8b v11, v26

        bcax.16b v25, v15, v17, v16
        bcax.16b v26, v16, v18, v17
        bcax.16b v17, v17, v19, v18
        bcax.16b v18, v18, v15, v19
        bcax.16b v19, v19, v16, v15
        mov.8b v15, v25
        mov.8b v16, v26

        bcax.16b v25, v20, v22, v21
        bcax.16b v26, v21, v23, v22
        bcax.16b v22, v22, v24, v23
        bcax.16b v23, v23, v20, v24
        bcax.16b v24, v24, v21, v20
        mov.8b v20, v25
        mov.8b v21, v26

        ld1r {v25.2d}, [x1], #8
        eor.8b v0, v0, v25
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
