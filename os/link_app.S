    .align 4
    .section .data
    .global _app_num
_app_num:
    .quad 15
    .quad app_0_start
    .quad app_1_start
    .quad app_2_start
    .quad app_3_start
    .quad app_4_start
    .quad app_5_start
    .quad app_6_start
    .quad app_7_start
    .quad app_8_start
    .quad app_9_start
    .quad app_10_start
    .quad app_11_start
    .quad app_12_start
    .quad app_13_start
    .quad app_14_start
    .quad app_14_end

    .global _app_names
_app_names:
   .string "ch2b_exit"
   .string "ch2b_hello_world"
   .string "ch2b_power"
   .string "ch3_taskinfo"
   .string "ch3b_sleep"
   .string "ch3b_sleep1"
   .string "ch3b_yield0"
   .string "ch3b_yield1"
   .string "ch3b_yield2"
   .string "ch4_mmap0"
   .string "ch4_mmap1"
   .string "ch4_mmap2"
   .string "ch4_mmap3"
   .string "ch4_unmap0"
   .string "ch4_unmap1"

    .section .data.app0
    .global app_0_start
app_0_start:
    .incbin "./user/target/bin/ch2b_exit"

    .section .data.app1
    .global app_1_start
app_1_start:
    .incbin "./user/target/bin/ch2b_hello_world"

    .section .data.app2
    .global app_2_start
app_2_start:
    .incbin "./user/target/bin/ch2b_power"

    .section .data.app3
    .global app_3_start
app_3_start:
    .incbin "./user/target/bin/ch3_taskinfo"

    .section .data.app4
    .global app_4_start
app_4_start:
    .incbin "./user/target/bin/ch3b_sleep"

    .section .data.app5
    .global app_5_start
app_5_start:
    .incbin "./user/target/bin/ch3b_sleep1"

    .section .data.app6
    .global app_6_start
app_6_start:
    .incbin "./user/target/bin/ch3b_yield0"

    .section .data.app7
    .global app_7_start
app_7_start:
    .incbin "./user/target/bin/ch3b_yield1"

    .section .data.app8
    .global app_8_start
app_8_start:
    .incbin "./user/target/bin/ch3b_yield2"

    .section .data.app9
    .global app_9_start
app_9_start:
    .incbin "./user/target/bin/ch4_mmap0"

    .section .data.app10
    .global app_10_start
app_10_start:
    .incbin "./user/target/bin/ch4_mmap1"

    .section .data.app11
    .global app_11_start
app_11_start:
    .incbin "./user/target/bin/ch4_mmap2"

    .section .data.app12
    .global app_12_start
app_12_start:
    .incbin "./user/target/bin/ch4_mmap3"

    .section .data.app13
    .global app_13_start
app_13_start:
    .incbin "./user/target/bin/ch4_unmap0"

    .section .data.app14
    .global app_14_start
app_14_start:
    .incbin "./user/target/bin/ch4_unmap1"
app_14_end:

