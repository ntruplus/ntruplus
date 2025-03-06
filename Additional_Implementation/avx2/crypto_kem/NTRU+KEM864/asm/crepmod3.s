.global poly_crepmod3
poly_crepmod3:
    vmovdqa     _16xq(%rip), %ymm0       
    vmovdqa     _16xqm1div2(%rip), %ymm1 
    vmovdqa     _16xqp1div2(%rip), %ymm2 
    vmovdqa     _16x255(%rip), %ymm3     
    vmovdqa     _16x15(%rip), %ymm4      
    vmovdqa     _16x3(%rip), %ymm5       
    vmovdqa     _16x1(%rip), %ymm6       

    lea         1728(%rsi), %rax         

.p2align 5
_loop_poly_crepmod3:
    vmovdqa     (%rsi), %ymm7
    vmovdqa     32(%rsi), %ymm8
    vmovdqa     64(%rsi), %ymm9

    vpsraw      $15, %ymm7, %ymm10
    vpsraw      $15, %ymm8, %ymm11
    vpsraw      $15, %ymm9, %ymm12

    vpand       %ymm0, %ymm10, %ymm10
    vpand       %ymm0, %ymm11, %ymm11
    vpand       %ymm0, %ymm12, %ymm12

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vpsubw      %ymm1, %ymm7, %ymm7
    vpsubw      %ymm1, %ymm8, %ymm8
    vpsubw      %ymm1, %ymm9, %ymm9

    vpsraw      $15, %ymm7, %ymm10
    vpsraw      $15, %ymm8, %ymm11
    vpsraw      $15, %ymm9, %ymm12

    vpand       %ymm0, %ymm10, %ymm10
    vpand       %ymm0, %ymm11, %ymm11
    vpand       %ymm0, %ymm12, %ymm12

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vpsubw      %ymm2, %ymm7, %ymm7
    vpsubw      %ymm2, %ymm8, %ymm8
    vpsubw      %ymm2, %ymm9, %ymm9

    vpsraw      $8, %ymm7, %ymm10
    vpsraw      $8, %ymm8, %ymm11
    vpsraw      $8, %ymm9, %ymm12

    vpand       %ymm3, %ymm7, %ymm7
    vpand       %ymm3, %ymm8, %ymm8
    vpand       %ymm3, %ymm9, %ymm9

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vpsraw      $4, %ymm7, %ymm10
    vpsraw      $4, %ymm8, %ymm11
    vpsraw      $4, %ymm9, %ymm12

    vpand       %ymm4, %ymm7, %ymm7
    vpand       %ymm4, %ymm8, %ymm8
    vpand       %ymm4, %ymm9, %ymm9

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vpsraw      $2, %ymm7, %ymm10
    vpsraw      $2, %ymm8, %ymm11
    vpsraw      $2, %ymm9, %ymm12

    vpand       %ymm5, %ymm7, %ymm7
    vpand       %ymm5, %ymm8, %ymm8
    vpand       %ymm5, %ymm9, %ymm9

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vpsraw      $2, %ymm7, %ymm10
    vpsraw      $2, %ymm8, %ymm11
    vpsraw      $2, %ymm9, %ymm12

    vpand       %ymm5, %ymm7, %ymm7
    vpand       %ymm5, %ymm8, %ymm8
    vpand       %ymm5, %ymm9, %ymm9

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vpsubw      %ymm5, %ymm7, %ymm7
    vpsubw      %ymm5, %ymm8, %ymm8
    vpsubw      %ymm5, %ymm9, %ymm9

    vpaddw      %ymm6, %ymm7, %ymm10
    vpaddw      %ymm6, %ymm8, %ymm11
    vpaddw      %ymm6, %ymm9, %ymm12

    vpsraw      $15, %ymm10, %ymm10
    vpsraw      $15, %ymm11, %ymm11
    vpsraw      $15, %ymm12, %ymm12

    vpand       %ymm5, %ymm10, %ymm10
    vpand       %ymm5, %ymm11, %ymm11
    vpand       %ymm5, %ymm12, %ymm12

    vpaddw      %ymm10, %ymm7, %ymm7
    vpaddw      %ymm11, %ymm8, %ymm8
    vpaddw      %ymm12, %ymm9, %ymm9

    vmovdqa     %ymm7, (%rdi)
    vmovdqa     %ymm8, 32(%rdi)
    vmovdqa     %ymm9, 64(%rdi)

    add         $96, %rsi
    add         $96, %rdi
    cmp         %rax, %rsi
    jb          _loop_poly_crepmod3

    ret
