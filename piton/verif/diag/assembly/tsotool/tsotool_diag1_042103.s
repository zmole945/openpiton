// Modified by Princeton University on June 9th, 2015
/*
* ========== Copyright Header Begin ==========================================
* 
* OpenSPARC T1 Processor File: tsotool_diag1_042103.s
* Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
* DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
* 
* The above named program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License version 2 as published by the Free Software Foundation.
* 
* The above named program is distributed in the hope that it will be 
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
* 
* You should have received a copy of the GNU General Public
* License along with this work; if not, write to the Free Software
* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
* 
* ========== Copyright Header End ============================================
*/
! no tsotool postprocessing
! TSOTOOL.PROCESSOR niagara.rtl
! TSOTOOL.MODE GEN
! TSOTOOL.BATCH Y
! TSOTOOL.VERBOSE Y
! TSOTOOL.TEST_NAME diag
! TSOTOOL.N_PROCS 8
! GEN.N_INSTR_PER_PROC 1000
! GEN.AVG_LOOP_SIZE 512
! GEN.AVG_LOOP_ITER 10
! GEN.SEED 68
! ADMAP.REGION_SIZE 64
! ADMAP.REGION_OFFSETS 0-4-12-32-64,76-80-84-256-512,32-64,0-64-128-192
! ADMAP.ATTRIBUTES CV=0111,CP=1111 0x1
! ADMAP.N_ALIASES 0
! ADMAP.ALIAS_FREQUENCY 64
! ADMAP.ALIAS_OFFSET 8388608
! WT.PCT_FP_INSTR 10
! WT.PCT_LOADS_NF 0
! WT.PCT_NFS_FAULT 0
! WT.PCT_PREFETCH_FAULT 0
! WT.PCT_PREFETCH_UNIMP 0
! WT.REPLACEMENT 10
! WT.LD 10
! WT.BLD 0
! WT.DWLD 10
! WT.QWLD 0
! WT.ST 10
! WT.BST 0
! WT.BSTC 0
! WT.DWST 10
! WT.QWST 0
! WT.SWAP 3
! WT.CAS 5
! WT.CASX 5
! WT.ASI_L2_FLUSH 0
! WT.FLUSHI 0
! WT.MEMBAR 5
! WT.PREFETCH 10
! WT.NOP 1
! DBG.GRAPH_TRAVERSAL_DEPTH 25
! DBG.WRITE_RESULTS_FILE Y
! ADV.L2_WAYS 4
! ADV.TEST_ITERATIONS 1
! ADV.RESULTS_TO_MEM N
! ADV.BST_MEMBARS Y
! ADV.BLD_MEMBARS Y
! ADV.PREFETCH_FCNS fcn_1=5 


#define ENABLE_T0_Fp_exception_ieee_754_0x21
#define ENABLE_T0_Fp_exception_other_0x22
#define ENABLE_T0_Fp_disabled_0x20
#define ENABLE_T0_Illegal_instruction_0x10
#define ENABLE_T0_Clean_Window_0x24
#include "custom_page1.h"

#define N_CPUS  8
#define REGION_SIZE_RTL (64 * 1024)
!====#define RESULTS_BUF_SIZE_PER_CPU_RTL 1048576
#define RESULTS_BUF_SIZE_PER_CPU_RTL 1024
#define FUNC_TABLE_BUF_SIZE_RTL 1024
#define SYNC_BUF_SIZE_RTL 1024
#define PRIVATE_DATA_AREA_PER_CPU_RTL 64

#define ALIGN_PAGE_8K .align 8192


.seg "data"
ALIGN_PAGE_8K
user_data_start:
	.word 0x0
user_data_end:



.seg "data"
ALIGN_PAGE_8K
SHARED_DATA_START:
function_table:
	.word func0
	.word func1
	.word func2
	.word func3
	.word func4
	.word func5
	.word func6
	.word func7
	.skip FUNC_TABLE_BUF_SIZE_RTL
res_buf_p_0:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_1:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_2:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_3:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_4:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_5:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_6:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
res_buf_p_7:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL
sync_buf:
	.skip SYNC_BUF_SIZE_RTL
private_data_p0:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p1:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p2:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p3:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p4:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p5:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p6:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p7:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL

SHARED_DATA_END:


!4 shared memory regions
.seg"data"
ALIGN_PAGE_8K
REGION0_START_ALIAS0:
	.skip REGION_SIZE_RTL
REGION0_END_ALIAS0:
REGION1_START_ALIAS0:
	.skip REGION_SIZE_RTL
REGION1_END_ALIAS0:
REGION2_START_ALIAS0:
	.skip REGION_SIZE_RTL
REGION2_END_ALIAS0:
REGION3_START_ALIAS0:
	.skip REGION_SIZE_RTL
	.skip 4 * REGION_SIZE_RTL	 ! replacement area
REGION3_END_ALIAS0:


.seg "data"
ALIGN_PAGE_8K
stackarea_data_start:
	.skip 16
stack_start0:
	.skip 2048
stack_start1:
	.skip 2048
stack_start2:
	.skip 2048
stack_start3:
	.skip 2048
stack_start4:
	.skip 2048
stack_start5:
	.skip 2048
stack_start6:
	.skip 2048
stack_start7:
	.skip 2048

stackarea_data_end:



.seg "data"
ALIGN_PAGE_8K
sync_results_buf:
	.skip 64
sync_results_buf_end:


.seg "text"
ALIGN_PAGE_8K
user_text_start:
	ba main
nop
user_text_end:



.seg "text"
ALIGN_PAGE_8K
mymod_text_start:
.global main


main:

	set     SHARED_DATA_START, %o0
	mov     0, %o1
#define B_TRAP T_BAD_TRAP
#define G_TRAP T_GOOD_TRAP

check_cpu_id: 

	wr	%g0, 0x4, %fprs         /* make sure fef is 1 */
	mov 	THREAD_STRIDE, %l2
	th_fork(thread,%l0)

thread_0:
	mov 	0, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
	
thread_1:
	mov 	1, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_2:
	mov 	2, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_3:
	mov 	3, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_4:
	mov 	4, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_5:
	mov 	5, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_6:
	mov 	6, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_7:
	mov 	7, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_8:
	mov 	8, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_9:
	mov 	9, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_10:
	mov 	10, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_11:
	mov 	11, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_12:
	mov 	12, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_13:
	mov 	13, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_14:
	mov 	14, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_15:
	mov 	15, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_16:
	mov 	16, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_17:
	mov 	17, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_18:
	mov 	18, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_19:
	mov 	19, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_20:
	mov 	20, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_21:
	mov 	21, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_22:
	mov 	22, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_23:
	mov 	23, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_24:
	mov 	24, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_25:
	mov 	25, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_26:
	mov 	26, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
	
thread_27:
	mov 	27, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_28:
	mov 	28, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_29:
	mov 	29, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_30:
	mov 	30, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop
	
thread_31:
	mov 	31, %g1 
        udivx 	%g1, %l2, %g1
	ba	entry_point; nop

entry_point:
	
	add     %g1, 0, %o2
	mov     N_CPUS, %o3
	cmp     %g1, 0x7
	be      stack_setup7
	nop
	cmp     %g1, 0x6
	be      stack_setup6
	nop
	cmp     %g1, 0x5
	be      stack_setup5
	nop
	cmp     %g1, 0x4
	be      stack_setup4
	nop
	cmp     %g1, 0x3
	be      stack_setup3
	nop
	cmp     %g1, 0x2
	be      stack_setup2
	nop
	cmp     %g1, 0x1
	be      stack_setup1
	nop
	cmp     %g1, 0x0
	be      stack_setup0
	nop
	ta      B_TRAP

stack_setup0:
	set     stack_start0, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func0, %o4
	ba      common_code
	nop

stack_setup1:
	set     stack_start1, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func1, %o4
	ba      common_code
	nop

stack_setup2:
	set     stack_start2, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func2, %o4
	ba      common_code
	nop

stack_setup3:
	set     stack_start3, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func3, %o4
	ba      common_code
	nop

stack_setup4:
	set     stack_start4, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func4, %o4
	ba      common_code
	nop

stack_setup5:
	set     stack_start5, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func5, %o4
	ba      common_code
	nop

stack_setup6:
	set     stack_start6, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func6, %o4
	ba      common_code
	nop

stack_setup7:
	set     stack_start7, %l1
	mulx    %g1, 1024, %g2
	add     %g2, 512, %g2
	add     %l1, %g2, %sp
	set     func7, %o4
	ba      common_code
	nop
common_code:
	call dispatch_asm
	nop
	ta   G_TRAP



.align 32
dispatch_asm:
dispatch:

	save    %sp,-104,%sp
	st      %i4,[%fp+84]
	st      %i3,[%fp+80]
	st      %i2,[%fp+76]
	st      %i1,[%fp+72]
	st      %i0,[%fp+68]

	ld      [%fp+68],%l3		! shared_area_begin
	ld      [%fp+76], %l2		! cpuid
	sll     %l2, 2, %l1
	add     %l3, %l1, %l0
	ld      [%l0-4], %l4
	set     REGION0_START_ALIAS0, %o0	! shared address 0
	set     REGION1_START_ALIAS0, %o1	! shared address 1
	set     REGION2_START_ALIAS0, %o2	! shared address 2
	set     REGION3_START_ALIAS0, %o3	! shared address 3
	add     %l3,FUNC_TABLE_BUF_SIZE_RTL,%l3
	sethi   %hi(RESULTS_BUF_SIZE_PER_CPU_RTL),%l6
	or      %l6,%lo(RESULTS_BUF_SIZE_PER_CPU_RTL),%l6
	mulx    %l2,%l6,%l5
	add     %l3,%l5,%o4		! o4 = res_area for cpu
	mov     1,%l5
	mulx    %l5,N_CPUS,%l5
	mulx    %l5,%l6,%l5
	add     %l5,%l3,%o5
	add     %o5,SYNC_BUF_SIZE_RTL,%o6	! o6 = o5 + sync_buf_area
	jmpl    %i4,%o7
	nop
	jmp     %i7+8
	restore


! register allocation - 
! %i0-%i3 for the read/write addresses, 
! %i4 for pointer to results area (NOT USED for RTL) 
! %i5 pointer to temp mem location (used by swaps, alignment) 
! %i6 Not used by RTL
! %l0-%l7 for the results, 
! %l4- pointer to temp storage for value read by atomic before being xferred to fp regs


!-----------------



func0:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1024, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x00deade1), %l7
or    %l7, %lo(0x00deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x800001), %l4
or    %l4, %lo(0x800001), %l4

! Initialize FP counter 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P1: !DWLD [13] (Int)
ldx [%i3 + 64], %o0
! move %o0(upper) -> %o0(upper)

P2: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4: !ST [11] (maybe <- 0x800001) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P5: !DWST [9] (maybe <- 0x800002) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P6: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P7: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P8: !DWST [7] (maybe <- 0x800003) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P9: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P10: !CAS [1] (maybe <- 0x800005) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P11: !MEMBAR (Int)
membar #StoreLoad

P12: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P13: !DWST [3] (maybe <- 0x800006) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P14: !ST [13] (maybe <- 0x800007) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P15: !MEMBAR (Int)
membar #StoreLoad

P16: !LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P17: !MEMBAR (Int)
membar #StoreLoad

P18: !ST [15] (maybe <- 0x800008) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P19: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P20: !MEMBAR (Int)
membar #StoreLoad

P21: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P22: !ST [5] (maybe <- 0x800009) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P23: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P24: !DWST [7] (maybe <- 0x80000a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P25: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P26: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P27: !DWST [0] (maybe <- 0x80000c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P28: !DWST [0] (maybe <- 0x80000e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P29: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P30: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P31: !LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P32: !DWST [8] (maybe <- 0x800010) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P33: !ST [8] (maybe <- 0x800011) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P34: !NOP (Int)
nop

P35: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P36: !CASX [3] (maybe <- 0x800012) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P37: !CASX [6] (maybe <- 0x800013) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P38: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P39: !CAS [2] (maybe <- 0x800015) (Int)
add %i0, 12, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P40: !LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P41: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P42: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P43: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P44: !ST [14] (maybe <- 0x800016) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P45: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P46: !MEMBAR (Int)
membar #StoreLoad

P47: !DWLD [8] (Int)
ldx [%i1 + 256], %o2
! move %o2(upper) -> %o2(upper)

P48: !DWST [6] (maybe <- 0x800017) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P49: !DWST [5] (maybe <- 0x800019) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P50: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P51: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P52: !DWST [9] (maybe <- 0x80001a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P53: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P54: !ST [7] (maybe <- 0x80001b) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P55: !CAS [15] (maybe <- 0x80001c) (Int)
add %i3, 192, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P56: !MEMBAR (Int)
membar #StoreLoad

P57: !LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P58: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P59: !LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P60: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P61: !LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P62: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P63: !MEMBAR (Int)
membar #StoreLoad

P64: !CASX [12] (maybe <- 0x80001d) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P65: !CASX [11] (maybe <- 0x80001e) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P66: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P67: !CASX [10] (maybe <- 0x80001f) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P68: !ST [15] (maybe <- 0x800020) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P69: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P70: !ST [2] (maybe <- 0x800021) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P71: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P72: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P73: !DWLD [13] (FP)
! case fp 
ldd  [%i3 + 64], %f0
! 1 addresses covered

P74: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P75: !LD [4] (FP)
ld [%i0 + 64], %f1
! 1 addresses covered

P76: !CASX [9] (maybe <- 0x800022) (Int)
add %i1, 512, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P77: !MEMBAR (Int)
membar #StoreLoad

P78: !DWLD [3] (Int)
ldx [%i0 + 32], %o0
! move %o0(upper) -> %o0(upper)

P79: !DWST [7] (maybe <- 0x800023) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P80: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P81: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P82: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P83: !LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P84: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P85: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P86: !ST [6] (maybe <- 0x800025) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P87: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P88: !CASX [8] (maybe <- 0x800026) (Int)
add %i1, 256, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P89: !ST [10] (maybe <- 0x800027) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P90: !SWAP [1] (maybe <- 0x800028) (Int)
mov %l4, %o4
swap  [%i0 + 4], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P91: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P92: !DWLD [13] (Int)
ldx [%i3 + 64], %o0
! move %o0(upper) -> %o0(upper)

P93: !MEMBAR (Int)
membar #StoreLoad

P94: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P95: !LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P96: !DWST [9] (maybe <- 0x800029) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P97: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P98: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P99: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2

P100: !LD [2] (FP)
ld [%i0 + 12], %f2
! 1 addresses covered

P101: !DWST [14] (maybe <- 0x80002a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P102: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P103: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P104: !MEMBAR (Int)
membar #StoreLoad

P105: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P106: !CASX [14] (maybe <- 0x80002b) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P107: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P108: !ST [15] (maybe <- 0x3f800000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P109: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P110: !CAS [7] (maybe <- 0x80002c) (Int)
add %i1, 84, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P111: !ST [2] (maybe <- 0x80002d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P112: !DWST [6] (maybe <- 0x80002e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P113: !SWAP [8] (maybe <- 0x800030) (Int)
mov %l4, %o2
swap  [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P114: !ST [11] (maybe <- 0x800031) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P115: !DWST [7] (maybe <- 0x800032) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P116: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P117: !ST [8] (maybe <- 0x800034) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P118: !ST [5] (maybe <- 0x800035) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P119: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P120: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P121: !ST [0] (maybe <- 0x800036) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P122: !CAS [0] (maybe <- 0x800037) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P123: !MEMBAR (Int)
membar #StoreLoad

P124: !CASX [8] (maybe <- 0x800038) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P125: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P126: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P127: !DWST [14] (maybe <- 0x800039) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P128: !DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P129: !DWST [13] (maybe <- 0x80003a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P130: !ST [13] (maybe <- 0x80003b) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P131: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P132: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P133: !CASX [15] (maybe <- 0x80003c) (Int)
add %i3, 192, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P134: !ST [5] (maybe <- 0x80003d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P135: !DWLD [12] (Int)
ldx [%i3 + 0], %o0
! move %o0(upper) -> %o0(upper)

P136: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P137: !DWST [11] (maybe <- 0x80003e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P138: !DWST [10] (maybe <- 0x80003f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P139: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P140: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P141: !DWST [10] (maybe <- 0x800040) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P142: !MEMBAR (Int)
membar #StoreLoad

P143: !ST [13] (maybe <- 0x800041) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P144: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P145: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P146: !DWST [1] (maybe <- 0x800042) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P147: !DWLD [12] (Int)
ldx [%i3 + 0], %o1
! move %o1(upper) -> %o1(upper)

P148: !DWST [7] (maybe <- 0x800044) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P149: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P150: !DWST [0] (maybe <- 0x800046) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P151: !LD [8] (FP)
ld [%i1 + 256], %f3
! 1 addresses covered

P152: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P153: !CAS [1] (maybe <- 0x800048) (Int)
add %i0, 4, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P154: !LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P155: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P156: !MEMBAR (Int)
membar #StoreLoad

P157: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P158: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P159: !ST [3] (maybe <- 0x800049) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P160: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P161: !ST [4] (maybe <- 0x80004a) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P162: !ST [2] (maybe <- 0x80004b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P163: !MEMBAR (Int)
membar #StoreLoad

P164: !ST [6] (maybe <- 0x80004c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P165: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P166: !MEMBAR (Int)
membar #StoreLoad

P167: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P168: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P169: !NOP (Int)
nop

P170: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P171: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P172: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P173: !DWST [7] (maybe <- 0x40000000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P174: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P175: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P176: !LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P177: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P178: !DWST [2] (maybe <- 0x40800000) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P179: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P180: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P181: !ST [5] (maybe <- 0x80004d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P182: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P183: !DWST [0] (maybe <- 0x80004e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P184: !CAS [12] (maybe <- 0x800050) (Int)
add %i3, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P185: !CAS [7] (maybe <- 0x800051) (Int)
add %i1, 84, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P186: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P187: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P188: !ST [6] (maybe <- 0x800052) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P189: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P190: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P191: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P192: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P193: !SWAP [4] (maybe <- 0x800053) (Int)
mov %l4, %o3
swap  [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P194: !DWST [7] (maybe <- 0x800054) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P195: !DWST [6] (maybe <- 0x800056) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P196: !DWST [4] (maybe <- 0x800058) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P197: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P198: !ST [14] (maybe <- 0x800059) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P199: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P200: !ST [13] (maybe <- 0x40a00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P201: !ST [3] (maybe <- 0x80005a) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P202: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P203: !LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P204: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P205: !DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P206: !CASX [0] (maybe <- 0x80005b) (Int)
add %i0, 0, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P207: !CAS [5] (maybe <- 0x80005d) (Int)
add %i1, 76, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P208: !MEMBAR (Int)
membar #StoreLoad

P209: !CAS [3] (maybe <- 0x80005e) (Int)
add %i0, 32, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P210: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P211: !DWLD [1] (FP)
! case fp 
ldd  [%i0 + 0], %f4
! 2 addresses covered

P212: !LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P213: !ST [9] (maybe <- 0x80005f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P214: !DWST [8] (maybe <- 0x800060) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P215: !CAS [13] (maybe <- 0x800061) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P216: !DWST [9] (maybe <- 0x800062) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P217: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P218: !NOP (Int)
nop

P219: !CAS [15] (maybe <- 0x800063) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P220: !ST [4] (maybe <- 0x800064) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P221: !ST [9] (maybe <- 0x800065) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P222: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P223: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P224: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P225: !SWAP [15] (maybe <- 0x800066) (Int)
mov %l4, %o3
swap  [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P226: !DWST [12] (maybe <- 0x800067) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P227: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P228: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P229: !CAS [0] (maybe <- 0x800068) (Int)
add %i0, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P230: !LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P231: !CASX [4] (maybe <- 0x800069) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P232: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P233: !LD [9] (FP)
ld [%i1 + 512], %f6
! 1 addresses covered

P234: !CAS [11] (maybe <- 0x80006a) (Int)
add %i2, 64, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P235: !MEMBAR (Int)
membar #StoreLoad

P236: !LD [4] (Int)
lduw [%i0 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P237: !ST [0] (maybe <- 0x80006b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P238: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P239: !ST [12] (maybe <- 0x80006c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P240: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P241: !CASX [7] (maybe <- 0x80006d) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P242: !DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P243: !ST [0] (maybe <- 0x80006f) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P244: !ST [15] (maybe <- 0x800070) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P245: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P246: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P247: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P248: !LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P249: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P250: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P251: !ST [7] (maybe <- 0x800071) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P252: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P253: !LD [12] (Int)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P254: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P255: !MEMBAR (Int)
membar #StoreLoad

P256: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P257: !ST [7] (maybe <- 0x800072) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P258: !CAS [8] (maybe <- 0x800073) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P259: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P260: !CASX [12] (maybe <- 0x800074) (Int)
add %i3, 0, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P261: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P262: !CASX [1] (maybe <- 0x800075) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P263: !CASX [13] (maybe <- 0x800077) (Int)
add %i3, 64, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P264: !DWLD [14] (Int)
ldx [%i3 + 128], %o3
! move %o3(upper) -> %o3(upper)

P265: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P266: !ST [15] (maybe <- 0x800078) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P267: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P268: !CASX [15] (maybe <- 0x800079) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P269: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P270: !SWAP [12] (maybe <- 0x80007a) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P271: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P272: !CAS [0] (maybe <- 0x80007b) (Int)
add %i0, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P273: !ST [15] (maybe <- 0x80007c) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P274: !CAS [13] (maybe <- 0x80007d) (Int)
add %i3, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P275: !CAS [0] (maybe <- 0x80007e) (Int)
add %i0, 0, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P276: !CASX [5] (maybe <- 0x80007f) (Int)
add %i1, 72, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P277: !CAS [11] (maybe <- 0x800080) (Int)
add %i2, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P278: !DWLD [15] (Int)
ldx [%i3 + 192], %o2
! move %o2(upper) -> %o2(upper)

P279: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P280: !CAS [6] (maybe <- 0x800081) (Int)
add %i1, 80, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P281: !NOP (Int)
nop

P282: !DWST [1] (maybe <- 0x800082) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P283: !ST [0] (maybe <- 0x800084) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P284: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P285: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P286: !ST [7] (maybe <- 0x800085) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P287: !CAS [11] (maybe <- 0x800086) (Int)
add %i2, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P288: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P289: !DWST [14] (maybe <- 0x40c00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P290: !LD [3] (Int)
lduw [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P291: !ST [7] (maybe <- 0x800087) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P292: !SWAP [4] (maybe <- 0x800088) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P293: !DWST [9] (maybe <- 0x40e00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P294: !DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P295: !DWST [10] (maybe <- 0x800089) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P296: !MEMBAR (Int)
membar #StoreLoad

P297: !ST [12] (maybe <- 0x80008a) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P298: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P299: !ST [8] (maybe <- 0x80008b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P300: !ST [0] (maybe <- 0x80008c) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P301: !DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P302: !DWST [9] (maybe <- 0x80008d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P303: !DWST [1] (maybe <- 0x80008e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P304: !CAS [8] (maybe <- 0x800090) (Int)
add %i1, 256, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P305: !ST [0] (maybe <- 0x800091) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P306: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f18
! 1 addresses covered
fmovs %f18, %f7

P307: !LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P308: !MEMBAR (Int)
membar #StoreLoad

P309: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P310: !DWST [14] (maybe <- 0x41000000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P311: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P312: !DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P313: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P314: !CAS [14] (maybe <- 0x800092) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P315: !ST [12] (maybe <- 0x800093) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P316: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P317: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P318: !CASX [8] (maybe <- 0x800094) (Int)
add %i1, 256, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P319: !MEMBAR (Int)
membar #StoreLoad

P320: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P321: !CASX [14] (maybe <- 0x800095) (Int)
add %i3, 128, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P322: !MEMBAR (Int)
membar #StoreLoad

P323: !DWLD [8] (Int)
ldx [%i1 + 256], %o1
! move %o1(upper) -> %o1(upper)

P324: !ST [12] (maybe <- 0x800096) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P325: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1

P326: !DWST [12] (maybe <- 0x800097) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P327: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P328: !MEMBAR (Int)
membar #StoreLoad

P329: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P330: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P331: !ST [7] (maybe <- 0x800098) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P332: !DWST [9] (maybe <- 0x800099) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P333: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2

P334: !DWST [4] (maybe <- 0x41100000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P335: !SWAP [7] (maybe <- 0x80009a) (Int)
mov %l4, %o3
swap  [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P336: !DWST [10] (maybe <- 0x80009b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P337: !SWAP [15] (maybe <- 0x80009c) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P338: !LD [9] (Int)
lduw [%i1 + 512], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P339: !ST [12] (maybe <- 0x80009d) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P340: !SWAP [12] (maybe <- 0x80009e) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P341: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P342: !MEMBAR (Int)
membar #StoreLoad

P343: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P344: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P345: !SWAP [5] (maybe <- 0x80009f) (Int)
mov %l4, %o0
swap  [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P346: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P347: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P348: !CASX [1] (maybe <- 0x8000a0) (Int)
add %i0, 0, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P349: !CAS [1] (maybe <- 0x8000a2) (Int)
add %i0, 4, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P350: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P351: !CASX [11] (maybe <- 0x8000a3) (Int)
add %i2, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P352: !CAS [8] (maybe <- 0x8000a4) (Int)
add %i1, 256, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P353: !MEMBAR (Int)
membar #StoreLoad

P354: !ST [14] (maybe <- 0x41200000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P355: !ST [2] (maybe <- 0x8000a5) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P356: !ST [13] (maybe <- 0x8000a6) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P357: !ST [3] (maybe <- 0x8000a7) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P358: !MEMBAR (Int)
membar #StoreLoad

P359: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P360: !DWST [11] (maybe <- 0x8000a8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P361: !DWST [3] (maybe <- 0x8000a9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P362: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P363: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P364: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P365: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P366: !MEMBAR (Int)
membar #StoreLoad

P367: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P368: !SWAP [1] (maybe <- 0x8000aa) (Int)
mov %l4, %o4
swap  [%i0 + 4], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P369: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P370: !MEMBAR (Int)
membar #StoreLoad

P371: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P372: !ST [7] (maybe <- 0x8000ab) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P373: !DWST [13] (maybe <- 0x8000ac) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P374: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P375: !DWLD [2] (Int)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P376: !DWST [10] (maybe <- 0x8000ad) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P377: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P378: !DWST [12] (maybe <- 0x8000ae) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P379: !LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P380: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P381: !DWST [9] (maybe <- 0x8000af) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P382: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P383: !DWST [10] (maybe <- 0x8000b0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P384: !MEMBAR (Int)
membar #StoreLoad

P385: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P386: !DWST [15] (maybe <- 0x8000b1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P387: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P388: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P389: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P390: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P391: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P392: !DWST [0] (maybe <- 0x8000b2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P393: !DWST [2] (maybe <- 0x8000b4) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P394: !ST [10] (maybe <- 0x8000b5) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P395: !LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P396: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P397: !DWST [7] (maybe <- 0x8000b6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P398: !DWST [11] (maybe <- 0x8000b8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P399: !DWLD [13] (FP)
! case fp 
ldd  [%i3 + 64], %f8
! 1 addresses covered

P400: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P401: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P402: !DWST [1] (maybe <- 0x8000b9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P403: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P404: !DWLD [0] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P405: !DWLD [0] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P406: !DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P407: !DWST [9] (maybe <- 0x8000bb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P408: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P409: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P410: !ST [11] (maybe <- 0x41300000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P411: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f18
! 1 addresses covered
fmovs %f18, %f9

P412: !DWST [8] (maybe <- 0x8000bc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P413: !ST [12] (maybe <- 0x8000bd) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P414: !CASX [6] (maybe <- 0x8000be) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P415: !ST [7] (maybe <- 0x8000c0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P416: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P417: !DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P418: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P419: !CASX [4] (maybe <- 0x8000c1) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P420: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P421: !ST [0] (maybe <- 0x8000c2) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P422: !MEMBAR (Int)
membar #StoreLoad

P423: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P424: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P425: !ST [13] (maybe <- 0x8000c3) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P426: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P427: !LD [0] (Int)
lduw [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P428: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P429: !SWAP [12] (maybe <- 0x8000c4) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P430: !CASX [5] (maybe <- 0x8000c5) (Int)
add %i1, 72, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P431: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f10
! 1 addresses covered

P432: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P433: !CASX [9] (maybe <- 0x8000c6) (Int)
add %i1, 512, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P434: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P435: !DWST [8] (maybe <- 0x8000c7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P436: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P437: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P438: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P439: !LD [4] (Int)
lduw [%i0 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P440: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P441: !MEMBAR (Int)
membar #StoreLoad

P442: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P443: !ST [2] (maybe <- 0x41400000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P444: !LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P445: !DWST [7] (maybe <- 0x8000c8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P446: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P447: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P448: !DWLD [0] (FP)
! case fp 
ldd  [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f11
fmovs %f19, %f12

P449: !DWST [4] (maybe <- 0x8000ca) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P450: !ST [7] (maybe <- 0x41500000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P451: !DWST [12] (maybe <- 0x8000cb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P452: !ST [8] (maybe <- 0x8000cc) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P453: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P454: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P455: !MEMBAR (Int)
membar #StoreLoad

P456: !SWAP [14] (maybe <- 0x8000cd) (Int)
mov %l4, %o1
swap  [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P457: !DWST [4] (maybe <- 0x8000ce) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P458: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P459: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P460: !LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P461: !SWAP [11] (maybe <- 0x8000cf) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P462: !LD [10] (Int)
lduw [%i2 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P463: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P464: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P465: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P466: !DWST [7] (maybe <- 0x8000d0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P467: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P468: !ST [8] (maybe <- 0x41600000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P469: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P470: !DWST [12] (maybe <- 0x8000d2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P471: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P472: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P473: !DWST [0] (maybe <- 0x8000d3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P474: !DWST [12] (maybe <- 0x8000d5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P475: !LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P476: !DWST [9] (maybe <- 0x8000d6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P477: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P478: !ST [0] (maybe <- 0x8000d7) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P479: !LD [12] (Int)
lduw [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P480: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P481: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P482: !MEMBAR (Int)
membar #StoreLoad

P483: !LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P484: !ST [12] (maybe <- 0x8000d8) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P485: !ST [13] (maybe <- 0x8000d9) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P486: !CAS [4] (maybe <- 0x8000da) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P487: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P488: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P489: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P490: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P491: !LD [12] (Int)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P492: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P493: !ST [6] (maybe <- 0x8000db) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P494: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P495: !NOP (Int)
nop

P496: !MEMBAR (Int)
membar #StoreLoad

P497: !DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P498: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P499: !ST [12] (maybe <- 0x8000dc) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P500: !CASX [11] (maybe <- 0x8000dd) (Int)
add %i2, 64, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P501: !CAS [13] (maybe <- 0x8000de) (Int)
add %i3, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P502: !MEMBAR (Int)
membar #StoreLoad

P503: !DWST [6] (maybe <- 0x8000df) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P504: !DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P505: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P506: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P507: !SWAP [3] (maybe <- 0x8000e1) (Int)
mov %l4, %o1
swap  [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P508: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P509: !LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P510: !CASX [12] (maybe <- 0x8000e2) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P511: !CASX [9] (maybe <- 0x8000e3) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P512: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P513: !ST [15] (maybe <- 0x8000e4) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P514: !MEMBAR (Int)
membar #StoreLoad

P515: !MEMBAR (Int)
membar #StoreLoad

P516: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P517: !DWST [11] (maybe <- 0x8000e5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P518: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P519: !ST [15] (maybe <- 0x8000e6) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P520: !DWST [0] (maybe <- 0x8000e7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P521: !ST [13] (maybe <- 0x8000e9) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P522: !LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P523: !CAS [6] (maybe <- 0x8000ea) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P524: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P525: !ST [9] (maybe <- 0x8000eb) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P526: !DWST [0] (maybe <- 0x8000ec) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P527: !CASX [6] (maybe <- 0x8000ee) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P528: !MEMBAR (Int)
membar #StoreLoad

P529: !ST [8] (maybe <- 0x8000f0) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P530: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P531: !CAS [2] (maybe <- 0x8000f1) (Int)
add %i0, 12, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P532: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P533: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P534: !CAS [10] (maybe <- 0x8000f2) (Int)
add %i2, 32, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P535: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P536: !LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P537: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P538: !DWST [5] (maybe <- 0x8000f3) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P539: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P540: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P541: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P542: !DWST [0] (maybe <- 0x8000f4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P543: !ST [3] (maybe <- 0x41700000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P544: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P545: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P546: !ST [3] (maybe <- 0x41800000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P547: !MEMBAR (Int)
membar #StoreLoad

P548: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P549: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P550: !SWAP [13] (maybe <- 0x8000f6) (Int)
mov %l4, %o1
swap  [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P551: !MEMBAR (Int)
membar #StoreLoad

P552: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P553: !LD [6] (FP)
ld [%i1 + 80], %f13
! 1 addresses covered

P554: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P555: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P556: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P557: !LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P558: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P559: !ST [7] (maybe <- 0x8000f7) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P560: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P561: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P562: !DWST [5] (maybe <- 0x8000f8) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P563: !CASX [4] (maybe <- 0x8000f9) (Int)
add %i0, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P564: !ST [4] (maybe <- 0x8000fa) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P565: !CASX [12] (maybe <- 0x8000fb) (Int)
add %i3, 0, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P566: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P567: !MEMBAR (Int)
membar #StoreLoad

P568: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P569: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P570: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P571: !DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P572: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P573: !CASX [8] (maybe <- 0x8000fc) (Int)
add %i1, 256, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P574: !ST [5] (maybe <- 0x8000fd) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P575: !SWAP [9] (maybe <- 0x8000fe) (Int)
mov %l4, %o1
swap  [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P576: !CAS [6] (maybe <- 0x8000ff) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P577: !CAS [0] (maybe <- 0x800100) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P578: !ST [7] (maybe <- 0x800101) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P579: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P580: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P581: !CAS [13] (maybe <- 0x800102) (Int)
add %i3, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P582: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P583: !DWST [12] (maybe <- 0x800103) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P584: !MEMBAR (Int)
membar #StoreLoad

P585: !CASX [3] (maybe <- 0x800104) (Int)
add %i0, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P586: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P587: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P588: !MEMBAR (Int)
membar #StoreLoad

P589: !ST [5] (maybe <- 0x41880000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P590: !DWST [8] (maybe <- 0x800105) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P591: !ST [10] (maybe <- 0x41900000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P592: !MEMBAR (Int)
membar #StoreLoad

P593: !SWAP [0] (maybe <- 0x800106) (Int)
mov %l4, %o2
swap  [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P594: !ST [7] (maybe <- 0x800107) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P595: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P596: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P597: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P598: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P599: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P600: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P601: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P602: !CASX [7] (maybe <- 0x800108) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P603: !DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P604: !SWAP [11] (maybe <- 0x80010a) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P605: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P606: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P607: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P608: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P609: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P610: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P611: !CASX [15] (maybe <- 0x80010b) (Int)
add %i3, 192, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P612: !DWST [9] (maybe <- 0x80010c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P613: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P614: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P615: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P616: !DWST [6] (maybe <- 0x80010d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P617: !DWST [11] (maybe <- 0x80010f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P618: !CASX [6] (maybe <- 0x800110) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P619: !LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P620: !ST [11] (maybe <- 0x800112) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P621: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P622: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f14
! 1 addresses covered

P623: !SWAP [1] (maybe <- 0x800113) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P624: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P625: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P626: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P627: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P628: !DWST [1] (maybe <- 0x800114) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P629: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P630: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P631: !DWLD [6] (FP)
! case fp 
ldd  [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f15
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovs %f19, %f0

P632: !DWST [2] (maybe <- 0x800116) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P633: !DWLD [7] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P634: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P635: !ST [2] (maybe <- 0x800117) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P636: !ST [14] (maybe <- 0x800118) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P637: !DWST [5] (maybe <- 0x800119) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P638: !DWLD [2] (Int)
ldx [%i0 + 8], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P639: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P640: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P641: !LD [0] (Int)
lduw [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P642: !ST [15] (maybe <- 0x80011a) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P643: !ST [12] (maybe <- 0x80011b) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P644: !DWST [5] (maybe <- 0x80011c) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P645: !ST [8] (maybe <- 0x80011d) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P646: !ST [12] (maybe <- 0x80011e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P647: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P648: !CAS [13] (maybe <- 0x80011f) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P649: !ST [4] (maybe <- 0x800120) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P650: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P651: !DWST [4] (maybe <- 0x800121) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P652: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P653: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P654: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P655: !MEMBAR (Int)
membar #StoreLoad

P656: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P657: !CASX [0] (maybe <- 0x800122) (Int)
add %i0, 0, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P658: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P659: !LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P660: !ST [10] (maybe <- 0x800124) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P661: !DWST [8] (maybe <- 0x800125) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P662: !MEMBAR (Int)
membar #StoreLoad

P663: !MEMBAR (Int)
membar #StoreLoad

P664: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P665: !DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P666: !CASX [14] (maybe <- 0x800126) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P667: !DWST [1] (maybe <- 0x41980000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P668: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P669: !ST [3] (maybe <- 0x800127) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P670: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P671: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P672: !DWST [3] (maybe <- 0x800128) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P673: !NOP (Int)
nop

P674: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P675: !MEMBAR (Int)
membar #StoreLoad

P676: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P677: !LD [6] (Int)
lduw [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P678: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P679: !ST [1] (maybe <- 0x800129) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P680: !CAS [10] (maybe <- 0x80012a) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P681: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P682: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P683: !ST [15] (maybe <- 0x41a80000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P684: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P685: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P686: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P687: !LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P688: !CASX [2] (maybe <- 0x80012b) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P689: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P690: !DWST [2] (maybe <- 0x80012c) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P691: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P692: !ST [9] (maybe <- 0x80012d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P693: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P694: !DWST [2] (maybe <- 0x80012e) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P695: !LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P696: !ST [11] (maybe <- 0x80012f) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P697: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P698: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P699: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P700: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P701: !ST [8] (maybe <- 0x41b00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P702: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P703: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P704: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P705: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P706: !ST [15] (maybe <- 0x800130) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P707: !DWST [13] (maybe <- 0x800131) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P708: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P709: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P710: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P711: !SWAP [9] (maybe <- 0x800132) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P712: !SWAP [2] (maybe <- 0x800133) (Int)
mov %l4, %o0
swap  [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P713: !CASX [0] (maybe <- 0x800134) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P714: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P715: !DWST [9] (maybe <- 0x800136) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P716: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P717: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P718: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P719: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P720: !LD [1] (FP)
ld [%i0 + 4], %f1
! 1 addresses covered

P721: !DWST [9] (maybe <- 0x41b80000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P722: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P723: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P724: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P725: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P726: !CASX [2] (maybe <- 0x800137) (Int)
add %i0, 8, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P727: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P728: !CASX [14] (maybe <- 0x800138) (Int)
add %i3, 128, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P729: !CASX [3] (maybe <- 0x800139) (Int)
add %i0, 32, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P730: !ST [15] (maybe <- 0x80013a) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P731: !CASX [14] (maybe <- 0x80013b) (Int)
add %i3, 128, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P732: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P733: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P734: !ST [9] (maybe <- 0x80013c) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P735: !LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P736: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P737: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P738: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P739: !CAS [12] (maybe <- 0x80013d) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P740: !ST [3] (maybe <- 0x80013e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P741: !DWLD [9] (FP)
! case fp 
ldd  [%i1 + 512], %f2
! 1 addresses covered

P742: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P743: !DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P744: !CAS [4] (maybe <- 0x80013f) (Int)
add %i0, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P745: !DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P746: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P747: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P748: !SWAP [14] (maybe <- 0x800140) (Int)
mov %l4, %o2
swap  [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P749: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P750: !DWLD [14] (Int)
ldx [%i3 + 128], %o3
! move %o3(upper) -> %o3(upper)

P751: !MEMBAR (Int)
membar #StoreLoad

P752: !CAS [6] (maybe <- 0x800141) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P753: !MEMBAR (Int)
membar #StoreLoad

P754: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P755: !DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P756: !ST [1] (maybe <- 0x800142) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P757: !CAS [10] (maybe <- 0x800143) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P758: !MEMBAR (Int)
membar #StoreLoad

P759: !ST [9] (maybe <- 0x800144) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P760: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P761: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P762: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P763: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P764: !DWLD [9] (FP)
! case fp 
ldd  [%i1 + 512], %f18
! 1 addresses covered
fmovs %f18, %f3

P765: !MEMBAR (Int)
membar #StoreLoad

P766: !DWLD [15] (Int)
ldx [%i3 + 192], %o2
! move %o2(upper) -> %o2(upper)

P767: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2

P768: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P769: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P770: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P771: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P772: !DWST [13] (maybe <- 0x800145) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P773: !DWST [1] (maybe <- 0x800146) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P774: !DWST [7] (maybe <- 0x800148) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P775: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P776: !MEMBAR (Int)
membar #StoreLoad

P777: !CASX [3] (maybe <- 0x80014a) (Int)
add %i0, 32, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P778: !ST [10] (maybe <- 0x80014b) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P779: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P780: !ST [1] (maybe <- 0x41c00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P781: !ST [12] (maybe <- 0x80014c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P782: !DWLD [2] (FP)
! case fp 
ldd  [%i0 + 8], %f4
! 1 addresses covered
fmovs %f5, %f4

P783: !DWLD [9] (Int)
ldx [%i1 + 512], %o1
! move %o1(upper) -> %o1(upper)

P784: !SWAP [9] (maybe <- 0x80014d) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P785: !CAS [5] (maybe <- 0x80014e) (Int)
add %i1, 76, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P786: !ST [11] (maybe <- 0x80014f) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P787: !ST [12] (maybe <- 0x800150) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P788: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P789: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P790: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P791: !DWST [3] (maybe <- 0x800151) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P792: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P793: !SWAP [9] (maybe <- 0x800152) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P794: !ST [13] (maybe <- 0x800153) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P795: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P796: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P797: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P798: !DWST [8] (maybe <- 0x800154) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P799: !DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P800: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P801: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P802: !CASX [3] (maybe <- 0x800155) (Int)
add %i0, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P803: !LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P804: !ST [13] (maybe <- 0x800156) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P805: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P806: !DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P807: !LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P808: !CAS [4] (maybe <- 0x800157) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P809: !DWST [12] (maybe <- 0x800158) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P810: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P811: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P812: !DWST [1] (maybe <- 0x800159) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P813: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P814: !DWLD [5] (Int)
ldx [%i1 + 72], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P815: !CAS [14] (maybe <- 0x80015b) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P816: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P817: !ST [8] (maybe <- 0x80015c) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P818: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P819: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P820: !ST [13] (maybe <- 0x41c80000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P821: !DWST [7] (maybe <- 0x80015d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P822: !NOP (Int)
nop

P823: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P824: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P825: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P826: !ST [12] (maybe <- 0x80015f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P827: !CAS [0] (maybe <- 0x800160) (Int)
add %i0, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P828: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P829: !CASX [7] (maybe <- 0x800161) (Int)
add %i1, 80, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P830: !ST [6] (maybe <- 0x800163) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P831: !CASX [8] (maybe <- 0x800164) (Int)
add %i1, 256, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P832: !DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P833: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P834: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P835: !CAS [14] (maybe <- 0x800165) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P836: !DWLD [15] (FP)
! case fp 
ldd  [%i3 + 192], %f18
! 1 addresses covered
fmovs %f18, %f5

P837: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P838: !CAS [7] (maybe <- 0x800166) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P839: !MEMBAR (Int)
membar #StoreLoad

P840: !SWAP [6] (maybe <- 0x800167) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P841: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P842: !DWLD [11] (Int)
ldx [%i2 + 64], %o4
! move %o4(upper) -> %o4(upper)

P843: !DWST [13] (maybe <- 0x800168) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P844: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P845: !DWLD [6] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P846: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P847: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P848: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P849: !DWLD [9] (Int)
ldx [%i1 + 512], %o1
! move %o1(upper) -> %o1(upper)

P850: !CASX [0] (maybe <- 0x800169) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P851: !DWST [11] (maybe <- 0x80016b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P852: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P853: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P854: !CAS [10] (maybe <- 0x80016c) (Int)
add %i2, 32, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P855: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P856: !CASX [6] (maybe <- 0x80016d) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P857: !ST [10] (maybe <- 0x80016f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P858: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P859: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P860: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P861: !ST [15] (maybe <- 0x41d00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P862: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P863: !DWST [9] (maybe <- 0x800170) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P864: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P865: !ST [3] (maybe <- 0x800171) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P866: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P867: !ST [3] (maybe <- 0x800172) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P868: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P869: !CASX [11] (maybe <- 0x800173) (Int)
add %i2, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P870: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P871: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P872: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P873: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P874: !DWST [11] (maybe <- 0x800174) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P875: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P876: !MEMBAR (Int)
membar #StoreLoad

P877: !NOP (Int)
nop

P878: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P879: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P880: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P881: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P882: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P883: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P884: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P885: !LD [1] (FP)
ld [%i0 + 4], %f6
! 1 addresses covered

P886: !ST [12] (maybe <- 0x800175) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P887: !DWST [6] (maybe <- 0x800176) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P888: !ST [8] (maybe <- 0x800178) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P889: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P890: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P891: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P892: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P893: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P894: !DWST [14] (maybe <- 0x800179) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P895: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P896: !CASX [8] (maybe <- 0x80017a) (Int)
add %i1, 256, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P897: !DWLD [5] (Int)
ldx [%i1 + 72], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P898: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P899: !ST [10] (maybe <- 0x80017b) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P900: !DWST [15] (maybe <- 0x80017c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P901: !MEMBAR (Int)
membar #StoreLoad

P902: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P903: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P904: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P905: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P906: !LD [2] (Int)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P907: !ST [13] (maybe <- 0x41d80000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P908: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P909: !LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P910: !ST [13] (maybe <- 0x80017d) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P911: !ST [5] (maybe <- 0x41e00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P912: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P913: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P914: !LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P915: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P916: !DWST [2] (maybe <- 0x80017e) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P917: !ST [10] (maybe <- 0x80017f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P918: !DWST [4] (maybe <- 0x800180) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P919: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P920: !CAS [10] (maybe <- 0x800181) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P921: !SWAP [0] (maybe <- 0x800182) (Int)
mov %l4, %l6
swap  [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P922: !ST [11] (maybe <- 0x800183) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P923: !LD [15] (FP)
ld [%i3 + 192], %f7
! 1 addresses covered

P924: !MEMBAR (Int)
membar #StoreLoad

P925: !CASX [12] (maybe <- 0x800184) (Int)
add %i3, 0, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P926: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P927: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P928: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P929: !SWAP [8] (maybe <- 0x800185) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P930: !ST [2] (maybe <- 0x800186) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P931: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f8
! 1 addresses covered

P932: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P933: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P934: !CAS [4] (maybe <- 0x800187) (Int)
add %i0, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P935: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P936: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P937: !LD [10] (Int)
lduw [%i2 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P938: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P939: !DWST [1] (maybe <- 0x800188) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P940: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P941: !CASX [12] (maybe <- 0x80018a) (Int)
add %i3, 0, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P942: !CAS [2] (maybe <- 0x80018b) (Int)
add %i0, 12, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P943: !ST [6] (maybe <- 0x80018c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P944: !CASX [9] (maybe <- 0x80018d) (Int)
add %i1, 512, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P945: !DWLD [8] (Int)
ldx [%i1 + 256], %o4
! move %o4(upper) -> %o4(upper)

P946: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P947: !ST [12] (maybe <- 0x80018e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P948: !ST [10] (maybe <- 0x80018f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P949: !DWLD [12] (Int)
ldx [%i3 + 0], %o0
! move %o0(upper) -> %o0(upper)

P950: !CAS [1] (maybe <- 0x800190) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P951: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P952: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P953: !LD [6] (FP)
ld [%i1 + 80], %f9
! 1 addresses covered

P954: !ST [13] (maybe <- 0x800191) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P955: !DWLD [11] (FP)
! case fp 
ldd  [%i2 + 64], %f10
! 1 addresses covered

P956: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P957: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P958: !DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P959: !ST [3] (maybe <- 0x800192) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P960: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P961: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P962: !CASX [11] (maybe <- 0x800193) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P963: !DWLD [10] (FP)
! case fp 
ldd  [%i2 + 32], %f18
! 1 addresses covered
fmovs %f18, %f11

P964: !ST [15] (maybe <- 0x800194) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P965: !DWST [10] (maybe <- 0x800195) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P966: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P967: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P968: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P969: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P970: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P971: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P972: !ST [9] (maybe <- 0x800196) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P973: !ST [10] (maybe <- 0x800197) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P974: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P975: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P976: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P977: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P978: !MEMBAR (Int)
membar #StoreLoad

P979: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P980: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P981: !ST [11] (maybe <- 0x800198) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P982: !DWST [8] (maybe <- 0x41e80000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P983: !DWLD [6] (FP)
! case fp 
ldd  [%i1 + 80], %f12
! 2 addresses covered

P984: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P985: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P986: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P987: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P988: !MEMBAR (Int)
membar #StoreLoad

P989: !DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P990: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P991: !MEMBAR (Int)
membar #StoreLoad

P992: !DWST [5] (maybe <- 0x800199) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P993: !DWLD [12] (Int)
ldx [%i3 + 0], %o4
! move %o4(upper) -> %o4(upper)

P994: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P995: !CASX [6] (maybe <- 0x80019a) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P996: !ST [2] (maybe <- 0x80019c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P997: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P998: !CASX [10] (maybe <- 0x80019d) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P999: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1000: !ST [12] (maybe <- 0x80019e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1001: !MEMBAR (Int)
membar #StoreLoad

P1002: !LD [0] (FP)
ld [%i0 + 0], %f14
! 1 addresses covered

P1003: !LD [1] (FP)
ld [%i0 + 4], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P1004: !LD [2] (FP)
ld [%i0 + 12], %f0
! 1 addresses covered

P1005: !LD [3] (FP)
ld [%i0 + 32], %f1
! 1 addresses covered

P1006: !LD [4] (FP)
ld [%i0 + 64], %f2
! 1 addresses covered

P1007: !LD [5] (FP)
ld [%i1 + 76], %f3
! 1 addresses covered

P1008: !LD [6] (FP)
ld [%i1 + 80], %f4
! 1 addresses covered

P1009: !LD [7] (FP)
ld [%i1 + 84], %f5
! 1 addresses covered

P1010: !LD [8] (FP)
ld [%i1 + 256], %f6
! 1 addresses covered

P1011: !LD [9] (FP)
ld [%i1 + 512], %f7
! 1 addresses covered

P1012: !LD [10] (FP)
ld [%i2 + 32], %f8
! 1 addresses covered

P1013: !LD [11] (FP)
ld [%i2 + 64], %f9
! 1 addresses covered

P1014: !LD [12] (FP)
ld [%i3 + 0], %f10
! 1 addresses covered

P1015: !LD [13] (FP)
ld [%i3 + 64], %f11
! 1 addresses covered

P1016: !LD [14] (FP)
ld [%i3 + 128], %f12
! 1 addresses covered

P1017: !LD [15] (FP)
ld [%i3 + 192], %f13
! 1 addresses covered
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30

restore
retl
nop
!-----------------



func1:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1088, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x01deade1), %l7
or    %l7, %lo(0x01deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x810001), %l4
or    %l4, %lo(0x810001), %l4

! Initialize FP counter 
sethi %hi(0x47800000), %l7
or    %l7, %lo(0x47800000), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P1018: !CASX [8] (maybe <- 0x810001) (Int)
add %i1, 256, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1019: !CASX [0] (maybe <- 0x810002) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1020: !ST [10] (maybe <- 0x810004) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1021: !ST [3] (maybe <- 0x810005) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1022: !CASX [6] (maybe <- 0x810006) (Int)
add %i1, 80, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1023: !LD [2] (FP)
ld [%i0 + 12], %f0
! 1 addresses covered

P1024: !NOP (Int)
nop

P1025: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1026: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1027: !DWST [10] (maybe <- 0x810008) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1028: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1029: !CAS [13] (maybe <- 0x810009) (Int)
add %i3, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1030: !SWAP [1] (maybe <- 0x81000a) (Int)
mov %l4, %o2
swap  [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1031: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P1032: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1033: !MEMBAR (Int)
membar #StoreLoad

P1034: !DWST [7] (maybe <- 0x81000b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1035: !DWST [2] (maybe <- 0x47800000) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P1036: !ST [5] (maybe <- 0x81000d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1037: !MEMBAR (Int)
membar #StoreLoad

P1038: !LD [0] (Int)
lduw [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1039: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1040: !SWAP [11] (maybe <- 0x81000e) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1041: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1042: !ST [2] (maybe <- 0x81000f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1043: !CAS [13] (maybe <- 0x810010) (Int)
add %i3, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1044: !ST [7] (maybe <- 0x810011) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1045: !DWLD [6] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1046: !LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1047: !CASX [4] (maybe <- 0x810012) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1048: !ST [12] (maybe <- 0x810013) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1049: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1050: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1051: !LD [11] (Int)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1052: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1053: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1054: !LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1055: !LD [0] (FP)
ld [%i0 + 0], %f1
! 1 addresses covered

P1056: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1057: !LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1058: !DWST [9] (maybe <- 0x810014) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1059: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P1060: !DWST [7] (maybe <- 0x810015) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1061: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1062: !LD [14] (FP)
ld [%i3 + 128], %f2
! 1 addresses covered

P1063: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1064: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1065: !SWAP [5] (maybe <- 0x810017) (Int)
mov %l4, %o2
swap  [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1066: !MEMBAR (Int)
membar #StoreLoad

P1067: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1068: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1069: !DWLD [11] (Int)
ldx [%i2 + 64], %o3
! move %o3(upper) -> %o3(upper)

P1070: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P1071: !SWAP [11] (maybe <- 0x810018) (Int)
mov %l4, %o4
swap  [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1072: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1073: !ST [1] (maybe <- 0x810019) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1074: !CAS [9] (maybe <- 0x81001a) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1075: !DWST [12] (maybe <- 0x81001b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1076: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1077: !DWST [3] (maybe <- 0x81001c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1078: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1079: !ST [5] (maybe <- 0x81001d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1080: !LD [3] (Int)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1081: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1082: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1083: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1084: !DWST [11] (maybe <- 0x81001e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1085: !CASX [12] (maybe <- 0x81001f) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1086: !MEMBAR (Int)
membar #StoreLoad

P1087: !MEMBAR (Int)
membar #StoreLoad

P1088: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1089: !DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P1090: !CAS [11] (maybe <- 0x810020) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1091: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1092: !CAS [12] (maybe <- 0x810021) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1093: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1094: !ST [5] (maybe <- 0x810022) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1095: !DWST [3] (maybe <- 0x810023) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1096: !ST [6] (maybe <- 0x810024) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1097: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1098: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1099: !ST [3] (maybe <- 0x810025) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1100: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1101: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1102: !ST [8] (maybe <- 0x810026) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1103: !CAS [6] (maybe <- 0x810027) (Int)
add %i1, 80, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1104: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1105: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1106: !DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P1107: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1108: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1109: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1110: !DWST [0] (maybe <- 0x810028) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1111: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1112: !CAS [11] (maybe <- 0x81002a) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1113: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1114: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1115: !ST [5] (maybe <- 0x81002b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1116: !LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1117: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1118: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1119: !ST [10] (maybe <- 0x81002c) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1120: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1121: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1122: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1123: !ST [14] (maybe <- 0x81002d) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1124: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1125: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1126: !DWLD [9] (Int)
ldx [%i1 + 512], %o4
! move %o4(upper) -> %o4(upper)

P1127: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1128: !MEMBAR (Int)
membar #StoreLoad

P1129: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1130: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1131: !DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1132: !DWST [10] (maybe <- 0x81002e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1133: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1134: !CAS [2] (maybe <- 0x81002f) (Int)
add %i0, 12, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1135: !CASX [4] (maybe <- 0x810030) (Int)
add %i0, 64, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1136: !CAS [13] (maybe <- 0x810031) (Int)
add %i3, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1137: !ST [12] (maybe <- 0x47800080) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P1138: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1139: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1140: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1141: !ST [9] (maybe <- 0x810032) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1142: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1143: !MEMBAR (Int)
membar #StoreLoad

P1144: !CAS [1] (maybe <- 0x810033) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1145: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1146: !SWAP [15] (maybe <- 0x810034) (Int)
mov %l4, %o3
swap  [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1147: !DWST [6] (maybe <- 0x47800100) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P1148: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1149: !DWLD [3] (Int)
ldx [%i0 + 32], %o4
! move %o4(upper) -> %o4(upper)

P1150: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1151: !MEMBAR (Int)
membar #StoreLoad

P1152: !DWST [5] (maybe <- 0x810035) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1153: !SWAP [0] (maybe <- 0x810036) (Int)
mov %l4, %l6
swap  [%i0 + 0], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1154: !ST [4] (maybe <- 0x810037) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1155: !DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1156: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1157: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1158: !DWST [13] (maybe <- 0x810038) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1159: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1160: !CASX [9] (maybe <- 0x810039) (Int)
add %i1, 512, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1161: !LD [1] (Int)
lduw [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1162: !DWST [4] (maybe <- 0x81003a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1163: !DWST [9] (maybe <- 0x81003b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1164: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1165: !DWST [1] (maybe <- 0x81003c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1166: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1167: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1168: !DWST [5] (maybe <- 0x81003e) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1169: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1170: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1171: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1172: !DWLD [4] (Int)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)

P1173: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P1174: !SWAP [2] (maybe <- 0x81003f) (Int)
mov %l4, %o1
swap  [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1175: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1176: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1177: !CAS [9] (maybe <- 0x810040) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1178: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1179: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1180: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1181: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1182: !DWST [6] (maybe <- 0x810041) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1183: !DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P1184: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1185: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1186: !DWST [9] (maybe <- 0x810043) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1187: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1188: !SWAP [2] (maybe <- 0x810044) (Int)
mov %l4, %o0
swap  [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1189: !MEMBAR (Int)
membar #StoreLoad

P1190: !SWAP [6] (maybe <- 0x810045) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P1191: !DWST [0] (maybe <- 0x810046) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1192: !DWST [4] (maybe <- 0x810048) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1193: !ST [6] (maybe <- 0x810049) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1194: !DWST [11] (maybe <- 0x81004a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1195: !ST [1] (maybe <- 0x81004b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1196: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P1197: !DWST [12] (maybe <- 0x81004c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1198: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P1199: !CASX [10] (maybe <- 0x81004d) (Int)
add %i2, 32, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1200: !CAS [12] (maybe <- 0x81004e) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1201: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1202: !CASX [9] (maybe <- 0x81004f) (Int)
add %i1, 512, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1203: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1204: !DWLD [0] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1205: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P1206: !ST [13] (maybe <- 0x810050) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1207: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1208: !CASX [4] (maybe <- 0x810051) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1209: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1210: !ST [13] (maybe <- 0x810052) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1211: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1212: !DWST [15] (maybe <- 0x810053) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1213: !DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P1214: !CAS [1] (maybe <- 0x810054) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1215: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P1216: !DWLD [11] (Int)
ldx [%i2 + 64], %o3
! move %o3(upper) -> %o3(upper)

P1217: !ST [12] (maybe <- 0x810055) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1218: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1219: !DWST [3] (maybe <- 0x810056) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1220: !SWAP [14] (maybe <- 0x810057) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1221: !ST [6] (maybe <- 0x810058) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1222: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1223: !DWST [1] (maybe <- 0x810059) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1224: !DWST [7] (maybe <- 0x81005b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1225: !CAS [2] (maybe <- 0x81005d) (Int)
add %i0, 12, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1226: !ST [10] (maybe <- 0x81005e) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1227: !MEMBAR (Int)
membar #StoreLoad

P1228: !ST [10] (maybe <- 0x81005f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1229: !DWST [4] (maybe <- 0x810060) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1230: !ST [1] (maybe <- 0x810061) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1231: !LD [12] (FP)
ld [%i3 + 0], %f3
! 1 addresses covered

P1232: !ST [13] (maybe <- 0x810062) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1233: !LD [0] (Int)
lduw [%i0 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1234: !NOP (Int)
nop

P1235: !CASX [14] (maybe <- 0x810063) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1236: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1237: !LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1238: !ST [11] (maybe <- 0x810064) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1239: !MEMBAR (Int)
membar #StoreLoad

P1240: !ST [5] (maybe <- 0x810065) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1241: !DWST [1] (maybe <- 0x810066) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1242: !SWAP [7] (maybe <- 0x810068) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1243: !MEMBAR (Int)
membar #StoreLoad

P1244: !CASX [3] (maybe <- 0x810069) (Int)
add %i0, 32, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1245: !DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1246: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1247: !CASX [3] (maybe <- 0x81006a) (Int)
add %i0, 32, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1248: !ST [7] (maybe <- 0x47800200) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P1249: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1250: !DWST [6] (maybe <- 0x81006b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1251: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1252: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1253: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1254: !DWST [11] (maybe <- 0x81006d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1255: !LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1256: !ST [13] (maybe <- 0x81006e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1257: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1258: !LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1259: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1260: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1261: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P1262: !MEMBAR (Int)
membar #StoreLoad

P1263: !CAS [15] (maybe <- 0x81006f) (Int)
add %i3, 192, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1264: !LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1265: !DWST [0] (maybe <- 0x810070) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1266: !NOP (Int)
nop

P1267: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1268: !ST [14] (maybe <- 0x810072) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1269: !CAS [7] (maybe <- 0x810073) (Int)
add %i1, 84, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1270: !ST [5] (maybe <- 0x810074) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1271: !DWLD [2] (Int)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1272: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1273: !LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1274: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1275: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P1276: !ST [15] (maybe <- 0x810075) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1277: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1278: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1279: !CASX [15] (maybe <- 0x810076) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1280: !CAS [2] (maybe <- 0x810077) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1281: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1282: !DWST [11] (maybe <- 0x810078) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1283: !ST [13] (maybe <- 0x810079) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1284: !LD [0] (FP)
ld [%i0 + 0], %f4
! 1 addresses covered

P1285: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1286: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1287: !DWST [15] (maybe <- 0x81007a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1288: !MEMBAR (Int)
membar #StoreLoad

P1289: !CAS [1] (maybe <- 0x81007b) (Int)
add %i0, 4, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1290: !ST [10] (maybe <- 0x81007c) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1291: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P1292: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1293: !ST [3] (maybe <- 0x81007d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1294: !DWST [14] (maybe <- 0x81007e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1295: !CASX [13] (maybe <- 0x81007f) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1296: !ST [9] (maybe <- 0x810080) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1297: !DWST [2] (maybe <- 0x810081) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1298: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1299: !CAS [4] (maybe <- 0x810082) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1300: !SWAP [6] (maybe <- 0x810083) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P1301: !DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1302: !MEMBAR (Int)
membar #StoreLoad

P1303: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1304: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P1305: !DWST [4] (maybe <- 0x810084) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1306: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1307: !DWST [14] (maybe <- 0x810085) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1308: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1309: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1310: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1311: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1312: !CAS [7] (maybe <- 0x810086) (Int)
add %i1, 84, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1313: !DWLD [0] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1314: !DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1315: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P1316: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1317: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1318: !LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1319: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1320: !SWAP [13] (maybe <- 0x810087) (Int)
mov %l4, %l6
swap  [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1321: !LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1322: !ST [13] (maybe <- 0x810088) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1323: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1324: !SWAP [5] (maybe <- 0x810089) (Int)
mov %l4, %o3
swap  [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1325: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1326: !SWAP [11] (maybe <- 0x81008a) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1327: !CASX [13] (maybe <- 0x81008b) (Int)
add %i3, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1328: !DWST [13] (maybe <- 0x47800280) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P1329: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1330: !LD [15] (Int)
lduw [%i3 + 192], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1331: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1332: !CAS [1] (maybe <- 0x81008c) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1333: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1334: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1335: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1336: !CAS [8] (maybe <- 0x81008d) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1337: !SWAP [6] (maybe <- 0x81008e) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1338: !LD [0] (Int)
lduw [%i0 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1339: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1340: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1341: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1342: !LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1343: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f18
! 1 addresses covered
fmovs %f18, %f5

P1344: !NOP (Int)
nop

P1345: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1346: !DWST [11] (maybe <- 0x81008f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1347: !DWST [2] (maybe <- 0x810090) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1348: !CAS [12] (maybe <- 0x810091) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1349: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1350: !MEMBAR (Int)
membar #StoreLoad

P1351: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1352: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1353: !CASX [10] (maybe <- 0x810092) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1354: !DWST [8] (maybe <- 0x810093) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1355: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1356: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1357: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1358: !DWST [9] (maybe <- 0x810094) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1359: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1360: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1361: !LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1362: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1363: !CAS [1] (maybe <- 0x810095) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1364: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1365: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1366: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1367: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1368: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1369: !ST [9] (maybe <- 0x810096) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1370: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P1371: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P1372: !CASX [12] (maybe <- 0x810097) (Int)
add %i3, 0, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1373: !LD [0] (FP)
ld [%i0 + 0], %f6
! 1 addresses covered

P1374: !DWST [15] (maybe <- 0x810098) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1375: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1376: !DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1377: !SWAP [13] (maybe <- 0x810099) (Int)
mov %l4, %l6
swap  [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1378: !LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1379: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1380: !ST [10] (maybe <- 0x81009a) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1381: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1382: !MEMBAR (Int)
membar #StoreLoad

P1383: !MEMBAR (Int)
membar #StoreLoad

P1384: !DWST [1] (maybe <- 0x81009b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1385: !CASX [11] (maybe <- 0x81009d) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1386: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1387: !CAS [12] (maybe <- 0x81009e) (Int)
add %i3, 0, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P1388: !ST [12] (maybe <- 0x81009f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1389: !CAS [9] (maybe <- 0x8100a0) (Int)
add %i1, 512, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1390: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1391: !ST [15] (maybe <- 0x47800300) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P1392: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1393: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1394: !ST [2] (maybe <- 0x8100a1) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1395: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1396: !MEMBAR (Int)
membar #StoreLoad

P1397: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1398: !DWST [1] (maybe <- 0x8100a2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1399: !CASX [0] (maybe <- 0x8100a4) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1400: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1401: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1402: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1403: !ST [5] (maybe <- 0x8100a6) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1404: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1405: !SWAP [10] (maybe <- 0x8100a7) (Int)
mov %l4, %o0
swap  [%i2 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1406: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1407: !CASX [9] (maybe <- 0x8100a8) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1408: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1409: !DWST [11] (maybe <- 0x8100a9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1410: !DWST [1] (maybe <- 0x8100aa) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1411: !DWST [13] (maybe <- 0x8100ac) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1412: !CASX [14] (maybe <- 0x8100ad) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1413: !ST [11] (maybe <- 0x8100ae) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1414: !DWST [5] (maybe <- 0x8100af) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1415: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1416: !MEMBAR (Int)
membar #StoreLoad

P1417: !CASX [4] (maybe <- 0x8100b0) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1418: !NOP (Int)
nop

P1419: !ST [0] (maybe <- 0x8100b1) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1420: !CAS [2] (maybe <- 0x8100b2) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1421: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1422: !ST [9] (maybe <- 0x8100b3) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1423: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1424: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1425: !MEMBAR (Int)
membar #StoreLoad

P1426: !ST [9] (maybe <- 0x8100b4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1427: !DWST [1] (maybe <- 0x8100b5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1428: !NOP (Int)
nop

P1429: !CAS [7] (maybe <- 0x8100b7) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1430: !ST [13] (maybe <- 0x8100b8) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1431: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1432: !DWST [15] (maybe <- 0x47800380) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P1433: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1434: !MEMBAR (Int)
membar #StoreLoad

P1435: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1436: !DWST [9] (maybe <- 0x8100b9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1437: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1438: !DWST [2] (maybe <- 0x8100ba) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1439: !MEMBAR (Int)
membar #StoreLoad

P1440: !DWLD [2] (FP)
! case fp 
ldd  [%i0 + 8], %f18
! 1 addresses covered
fmovs %f19, %f7

P1441: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1442: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1443: !ST [14] (maybe <- 0x8100bb) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1444: !CAS [0] (maybe <- 0x8100bc) (Int)
add %i0, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1445: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1446: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1447: !DWST [7] (maybe <- 0x8100bd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1448: !LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1449: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1450: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1451: !MEMBAR (Int)
membar #StoreLoad

P1452: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P1453: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P1454: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1455: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1456: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1457: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1458: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1459: !ST [8] (maybe <- 0x8100bf) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1460: !DWST [10] (maybe <- 0x8100c0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1461: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1462: !NOP (Int)
nop

P1463: !MEMBAR (Int)
membar #StoreLoad

P1464: !LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1465: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1466: !DWST [5] (maybe <- 0x8100c1) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1467: !CASX [4] (maybe <- 0x8100c2) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1468: !DWST [5] (maybe <- 0x8100c3) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1469: !CASX [2] (maybe <- 0x8100c4) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1470: !MEMBAR (Int)
membar #StoreLoad

P1471: !CASX [12] (maybe <- 0x8100c5) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1472: !MEMBAR (Int)
membar #StoreLoad

P1473: !MEMBAR (Int)
membar #StoreLoad

P1474: !ST [7] (maybe <- 0x8100c6) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1475: !DWST [4] (maybe <- 0x8100c7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1476: !CASX [4] (maybe <- 0x8100c8) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1477: !CAS [15] (maybe <- 0x8100c9) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1478: !DWLD [10] (FP)
! case fp 
ldd  [%i2 + 32], %f8
! 1 addresses covered

P1479: !ST [14] (maybe <- 0x8100ca) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1480: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1481: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P1482: !DWST [1] (maybe <- 0x8100cb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1483: !CASX [0] (maybe <- 0x8100cd) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1484: !LD [0] (FP)
ld [%i0 + 0], %f9
! 1 addresses covered

P1485: !DWLD [0] (Int)
ldx [%i0 + 0], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1486: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1487: !ST [9] (maybe <- 0x8100cf) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1488: !ST [4] (maybe <- 0x47800400) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P1489: !CASX [13] (maybe <- 0x8100d0) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1490: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1491: !SWAP [1] (maybe <- 0x8100d1) (Int)
mov %l4, %o0
swap  [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1492: !DWST [14] (maybe <- 0x8100d2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1493: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1494: !DWST [1] (maybe <- 0x8100d3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1495: !ST [4] (maybe <- 0x8100d5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1496: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1497: !DWST [5] (maybe <- 0x8100d6) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1498: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1499: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1500: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1501: !DWST [11] (maybe <- 0x47800480) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P1502: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1503: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1504: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1505: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1506: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1507: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P1508: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1509: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1510: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1511: !ST [10] (maybe <- 0x8100d7) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1512: !ST [10] (maybe <- 0x8100d8) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1513: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1514: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1515: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1516: !DWST [5] (maybe <- 0x8100d9) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1517: !DWST [7] (maybe <- 0x8100da) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1518: !LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1519: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1520: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1521: !DWST [3] (maybe <- 0x8100dc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1522: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1523: !LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1524: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1525: !ST [3] (maybe <- 0x8100dd) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1526: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1527: !DWLD [12] (Int)
ldx [%i3 + 0], %o1
! move %o1(upper) -> %o1(upper)

P1528: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1529: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1530: !CAS [10] (maybe <- 0x8100de) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1531: !ST [3] (maybe <- 0x8100df) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1532: !SWAP [11] (maybe <- 0x8100e0) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1533: !CAS [2] (maybe <- 0x8100e1) (Int)
add %i0, 12, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1534: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1535: !CAS [4] (maybe <- 0x8100e2) (Int)
add %i0, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1536: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1537: !CASX [11] (maybe <- 0x8100e3) (Int)
add %i2, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1538: !CASX [1] (maybe <- 0x8100e4) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1539: !DWST [10] (maybe <- 0x8100e6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1540: !DWLD [15] (FP)
! case fp 
ldd  [%i3 + 192], %f10
! 1 addresses covered

P1541: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1542: !MEMBAR (Int)
membar #StoreLoad

P1543: !DWLD [0] (FP)
! case fp 
ldd  [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f11
fmovs %f19, %f12

P1544: !MEMBAR (Int)
membar #StoreLoad

P1545: !CAS [13] (maybe <- 0x8100e7) (Int)
add %i3, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1546: !ST [11] (maybe <- 0x47800500) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1547: !ST [14] (maybe <- 0x8100e8) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1548: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1549: !SWAP [5] (maybe <- 0x8100e9) (Int)
mov %l4, %o0
swap  [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1550: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1551: !LD [3] (Int)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1552: !NOP (Int)
nop

P1553: !DWST [15] (maybe <- 0x8100ea) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1554: !DWST [13] (maybe <- 0x8100eb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1555: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1556: !CAS [6] (maybe <- 0x8100ec) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1557: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1558: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1559: !MEMBAR (Int)
membar #StoreLoad

P1560: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1561: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1562: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1563: !DWLD [8] (Int)
ldx [%i1 + 256], %o3
! move %o3(upper) -> %o3(upper)

P1564: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1565: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P1566: !ST [10] (maybe <- 0x8100ed) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1567: !DWST [12] (maybe <- 0x8100ee) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1568: !DWLD [4] (Int)
ldx [%i0 + 64], %o4
! move %o4(upper) -> %o4(upper)

P1569: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1570: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1571: !DWST [5] (maybe <- 0x47800580) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P1572: !MEMBAR (Int)
membar #StoreLoad

P1573: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1574: !ST [6] (maybe <- 0x8100ef) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1575: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1576: !CASX [15] (maybe <- 0x8100f0) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1577: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1578: !SWAP [15] (maybe <- 0x8100f1) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1579: !MEMBAR (Int)
membar #StoreLoad

P1580: !ST [8] (maybe <- 0x8100f2) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1581: !CASX [15] (maybe <- 0x8100f3) (Int)
add %i3, 192, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1582: !ST [15] (maybe <- 0x8100f4) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1583: !ST [15] (maybe <- 0x47800600) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P1584: !LD [6] (Int)
lduw [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1585: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1586: !CAS [11] (maybe <- 0x8100f5) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1587: !ST [15] (maybe <- 0x8100f6) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1588: !CASX [14] (maybe <- 0x8100f7) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1589: !CAS [0] (maybe <- 0x8100f8) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1590: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1591: !CASX [13] (maybe <- 0x8100f9) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1592: !LD [4] (FP)
ld [%i0 + 64], %f13
! 1 addresses covered

P1593: !ST [2] (maybe <- 0x8100fa) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1594: !DWST [3] (maybe <- 0x8100fb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1595: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1596: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1597: !ST [4] (maybe <- 0x8100fc) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1598: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1599: !DWST [8] (maybe <- 0x8100fd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1600: !ST [10] (maybe <- 0x8100fe) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1601: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1602: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1603: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P1604: !DWST [4] (maybe <- 0x8100ff) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1605: !LD [14] (FP)
ld [%i3 + 128], %f14
! 1 addresses covered

P1606: !LD [6] (FP)
ld [%i1 + 80], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P1607: !DWST [14] (maybe <- 0x810100) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1608: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1609: !MEMBAR (Int)
membar #StoreLoad

P1610: !CAS [1] (maybe <- 0x810101) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1611: !CAS [3] (maybe <- 0x810102) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1612: !DWST [13] (maybe <- 0x810103) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1613: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1614: !NOP (Int)
nop

P1615: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1616: !CAS [0] (maybe <- 0x810104) (Int)
add %i0, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1617: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1618: !LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1619: !DWST [5] (maybe <- 0x810105) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1620: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1621: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1622: !CASX [6] (maybe <- 0x810106) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1623: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1624: !DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1625: !ST [7] (maybe <- 0x810108) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1626: !CASX [2] (maybe <- 0x810109) (Int)
add %i0, 8, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %l4, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1627: !DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1628: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1629: !DWST [4] (maybe <- 0x81010a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1630: !ST [2] (maybe <- 0x81010b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1631: !CASX [2] (maybe <- 0x81010c) (Int)
add %i0, 8, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %l4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1632: !LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1633: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1634: !DWST [2] (maybe <- 0x81010d) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1635: !DWST [13] (maybe <- 0x81010e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1636: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1637: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1638: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P1639: !DWST [8] (maybe <- 0x81010f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1640: !DWST [14] (maybe <- 0x810110) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1641: !ST [14] (maybe <- 0x810111) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1642: !DWST [2] (maybe <- 0x810112) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1643: !DWLD [2] (Int)
ldx [%i0 + 8], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1644: !DWST [11] (maybe <- 0x810113) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1645: !DWST [1] (maybe <- 0x810114) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1646: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1647: !DWST [7] (maybe <- 0x47800680) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P1648: !ST [1] (maybe <- 0x810116) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1649: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1650: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1651: !DWST [0] (maybe <- 0x810117) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1652: !DWST [12] (maybe <- 0x810119) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1653: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1654: !CASX [15] (maybe <- 0x81011a) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1655: !DWST [14] (maybe <- 0x81011b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1656: !CAS [4] (maybe <- 0x81011c) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1657: !ST [6] (maybe <- 0x81011d) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1658: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1659: !ST [0] (maybe <- 0x81011e) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1660: !LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1661: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1662: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P1663: !LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1664: !ST [5] (maybe <- 0x81011f) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1665: !ST [7] (maybe <- 0x810120) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1666: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1667: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1668: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1669: !CASX [7] (maybe <- 0x810121) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1670: !MEMBAR (Int)
membar #StoreLoad

P1671: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1672: !CASX [2] (maybe <- 0x810123) (Int)
add %i0, 8, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %l4, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1673: !ST [0] (maybe <- 0x810124) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1674: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1675: !DWST [2] (maybe <- 0x810125) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1676: !LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1677: !DWST [13] (maybe <- 0x810126) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1678: !DWST [8] (maybe <- 0x810127) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1679: !DWST [4] (maybe <- 0x47800780) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P1680: !DWST [15] (maybe <- 0x810128) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1681: !DWST [9] (maybe <- 0x810129) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1682: !CAS [10] (maybe <- 0x81012a) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1683: !DWST [2] (maybe <- 0x81012b) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1684: !DWST [13] (maybe <- 0x81012c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P1685: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1686: !DWST [4] (maybe <- 0x81012d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1687: !DWST [0] (maybe <- 0x81012e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1688: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1689: !CASX [1] (maybe <- 0x810130) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1690: !CASX [2] (maybe <- 0x810132) (Int)
add %i0, 8, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %l4, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1691: !DWST [15] (maybe <- 0x810133) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1692: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1693: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1694: !DWLD [0] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1695: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1696: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1697: !CAS [15] (maybe <- 0x810134) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1698: !ST [12] (maybe <- 0x810135) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1699: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P1700: !SWAP [9] (maybe <- 0x810136) (Int)
mov %l4, %o2
swap  [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1701: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1702: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1703: !LD [11] (Int)
lduw [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1704: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1705: !CAS [2] (maybe <- 0x810137) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1706: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1707: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1708: !DWST [5] (maybe <- 0x810138) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1709: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1710: !CASX [4] (maybe <- 0x810139) (Int)
add %i0, 64, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1711: !LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1712: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1713: !DWST [5] (maybe <- 0x81013a) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1714: !ST [1] (maybe <- 0x81013b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1715: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1716: !SWAP [0] (maybe <- 0x81013c) (Int)
mov %l4, %o4
swap  [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1717: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1718: !LD [5] (FP)
ld [%i1 + 76], %f0
! 1 addresses covered

P1719: !CAS [2] (maybe <- 0x81013d) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1720: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1721: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1722: !ST [12] (maybe <- 0x81013e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1723: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1724: !ST [0] (maybe <- 0x81013f) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1725: !DWLD [8] (FP)
! case fp 
ldd  [%i1 + 256], %f18
! 1 addresses covered
fmovs %f18, %f1

P1726: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1727: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f2
! 1 addresses covered

P1728: !CAS [11] (maybe <- 0x810140) (Int)
add %i2, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1729: !DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P1730: !CAS [1] (maybe <- 0x810141) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1731: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f18
! 1 addresses covered
fmovs %f18, %f3

P1732: !DWST [6] (maybe <- 0x47800800) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P1733: !ST [5] (maybe <- 0x810142) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1734: !ST [11] (maybe <- 0x810143) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1735: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1736: !DWST [1] (maybe <- 0x810144) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1737: !NOP (Int)
nop

P1738: !LD [4] (FP)
ld [%i0 + 64], %f4
! 1 addresses covered

P1739: !DWST [12] (maybe <- 0x810146) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1740: !CASX [3] (maybe <- 0x810147) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1741: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1742: !DWST [14] (maybe <- 0x810148) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1743: !SWAP [4] (maybe <- 0x810149) (Int)
mov %l4, %o1
swap  [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1744: !DWST [7] (maybe <- 0x81014a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1745: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P1746: !DWST [7] (maybe <- 0x81014c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1747: !ST [3] (maybe <- 0x81014e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1748: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1749: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1750: !ST [12] (maybe <- 0x81014f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1751: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1752: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1753: !SWAP [2] (maybe <- 0x810150) (Int)
mov %l4, %o3
swap  [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1754: !CAS [6] (maybe <- 0x810151) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1755: !MEMBAR (Int)
membar #StoreLoad

P1756: !SWAP [8] (maybe <- 0x810152) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1757: !CAS [6] (maybe <- 0x810153) (Int)
add %i1, 80, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P1758: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1759: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1760: !LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1761: !NOP (Int)
nop

P1762: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1763: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P1764: !DWST [4] (maybe <- 0x47800900) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P1765: !CAS [10] (maybe <- 0x810154) (Int)
add %i2, 32, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1766: !ST [9] (maybe <- 0x810155) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1767: !CAS [2] (maybe <- 0x810156) (Int)
add %i0, 12, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1768: !CASX [9] (maybe <- 0x810157) (Int)
add %i1, 512, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1769: !ST [6] (maybe <- 0x810158) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1770: !ST [12] (maybe <- 0x810159) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1771: !CASX [2] (maybe <- 0x81015a) (Int)
add %i0, 8, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %l4, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1772: !ST [10] (maybe <- 0x81015b) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1773: !ST [12] (maybe <- 0x81015c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1774: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1775: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1776: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1777: !CAS [1] (maybe <- 0x81015d) (Int)
add %i0, 4, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1778: !DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1779: !DWST [8] (maybe <- 0x81015e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1780: !ST [1] (maybe <- 0x81015f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1781: !DWST [13] (maybe <- 0x47800980) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P1782: !ST [14] (maybe <- 0x47800a00) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P1783: !NOP (Int)
nop

P1784: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1785: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1786: !CASX [10] (maybe <- 0x810160) (Int)
add %i2, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1787: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1788: !CAS [9] (maybe <- 0x810161) (Int)
add %i1, 512, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1789: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1790: !MEMBAR (Int)
membar #StoreLoad

P1791: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1792: !DWST [11] (maybe <- 0x810162) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1793: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P1794: !CASX [13] (maybe <- 0x810163) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1795: !CAS [8] (maybe <- 0x810164) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1796: !ST [12] (maybe <- 0x810165) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1797: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1798: !DWST [12] (maybe <- 0x810166) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1799: !ST [4] (maybe <- 0x47800a80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P1800: !CASX [11] (maybe <- 0x810167) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1801: !ST [10] (maybe <- 0x810168) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1802: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1803: !ST [1] (maybe <- 0x810169) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1804: !ST [7] (maybe <- 0x81016a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1805: !NOP (Int)
nop

P1806: !DWLD [12] (Int)
ldx [%i3 + 0], %o4
! move %o4(upper) -> %o4(upper)

P1807: !CAS [14] (maybe <- 0x81016b) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1808: !DWST [15] (maybe <- 0x81016c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1809: !CASX [9] (maybe <- 0x81016d) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1810: !CASX [1] (maybe <- 0x81016e) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1811: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1812: !MEMBAR (Int)
membar #StoreLoad

P1813: !CAS [3] (maybe <- 0x810170) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1814: !DWST [10] (maybe <- 0x810171) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1815: !ST [1] (maybe <- 0x810172) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1816: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1817: !DWST [10] (maybe <- 0x47800b00) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P1818: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1819: !ST [1] (maybe <- 0x810173) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1820: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1821: !MEMBAR (Int)
membar #StoreLoad

P1822: !SWAP [13] (maybe <- 0x810174) (Int)
mov %l4, %l6
swap  [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1823: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1824: !SWAP [13] (maybe <- 0x810175) (Int)
mov %l4, %o2
swap  [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1825: !CASX [3] (maybe <- 0x810176) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1826: !ST [14] (maybe <- 0x810177) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1827: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1828: !LD [10] (Int)
lduw [%i2 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1829: !DWST [10] (maybe <- 0x810178) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1830: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1831: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1832: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1833: !DWST [10] (maybe <- 0x810179) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1834: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1835: !MEMBAR (Int)
membar #StoreLoad

P1836: !CAS [1] (maybe <- 0x81017a) (Int)
add %i0, 4, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1837: !SWAP [15] (maybe <- 0x81017b) (Int)
mov %l4, %o2
swap  [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1838: !ST [11] (maybe <- 0x81017c) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1839: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1840: !ST [11] (maybe <- 0x81017d) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1841: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1842: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1843: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1844: !ST [0] (maybe <- 0x47800b80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1845: !LD [8] (Int)
lduw [%i1 + 256], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1846: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1847: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1848: !MEMBAR (Int)
membar #StoreLoad

P1849: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1850: !MEMBAR (Int)
membar #StoreLoad

P1851: !ST [10] (maybe <- 0x81017e) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1852: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1853: !DWST [14] (maybe <- 0x81017f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1854: !DWST [7] (maybe <- 0x810180) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1855: !CASX [12] (maybe <- 0x810182) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1856: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1857: !LD [3] (Int)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1858: !NOP (Int)
nop

P1859: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P1860: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1861: !CAS [11] (maybe <- 0x810183) (Int)
add %i2, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1862: !DWLD [6] (FP)
! case fp 
ldd  [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f5
fmovs %f19, %f6

P1863: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1864: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1865: !LD [2] (Int)
lduw [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1866: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1867: !DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1868: !SWAP [5] (maybe <- 0x810184) (Int)
mov %l4, %l6
swap  [%i1 + 76], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1869: !DWLD [11] (Int)
ldx [%i2 + 64], %o0
! move %o0(upper) -> %o0(upper)

P1870: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1871: !SWAP [6] (maybe <- 0x810185) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P1872: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1873: !DWST [1] (maybe <- 0x810186) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1874: !ST [4] (maybe <- 0x810188) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1875: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1876: !CAS [6] (maybe <- 0x810189) (Int)
add %i1, 80, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1877: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1878: !ST [2] (maybe <- 0x47800c00) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1879: !ST [11] (maybe <- 0x81018a) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1880: !DWLD [6] (FP)
! case fp 
ldd  [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f7
fmovs %f19, %f8

P1881: !DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P1882: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1883: !SWAP [14] (maybe <- 0x81018b) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1884: !DWLD [2] (FP)
! case fp 
ldd  [%i0 + 8], %f18
! 1 addresses covered
fmovs %f19, %f9

P1885: !CASX [12] (maybe <- 0x81018c) (Int)
add %i3, 0, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1886: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1887: !NOP (Int)
nop

P1888: !LD [3] (FP)
ld [%i0 + 32], %f10
! 1 addresses covered

P1889: !SWAP [2] (maybe <- 0x81018d) (Int)
mov %l4, %o2
swap  [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1890: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1891: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1892: !CASX [8] (maybe <- 0x81018e) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1893: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1894: !DWST [8] (maybe <- 0x81018f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1895: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1896: !LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1897: !CASX [14] (maybe <- 0x810190) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1898: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1899: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1900: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P1901: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1902: !LD [2] (Int)
lduw [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1903: !DWST [5] (maybe <- 0x810191) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1904: !DWST [11] (maybe <- 0x810192) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1905: !DWST [7] (maybe <- 0x810193) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P1906: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1907: !DWST [5] (maybe <- 0x810195) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P1908: !ST [5] (maybe <- 0x810196) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1909: !MEMBAR (Int)
membar #StoreLoad

P1910: !ST [3] (maybe <- 0x810197) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1911: !SWAP [11] (maybe <- 0x810198) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1912: !NOP (Int)
nop

P1913: !LD [5] (Int)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1914: !MEMBAR (Int)
membar #StoreLoad

P1915: !MEMBAR (Int)
membar #StoreLoad

P1916: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1917: !CASX [5] (maybe <- 0x810199) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P1918: !DWST [0] (maybe <- 0x81019a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P1919: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1920: !CASX [6] (maybe <- 0x81019c) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1921: !CASX [3] (maybe <- 0x81019e) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1922: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P1923: !MEMBAR (Int)
membar #StoreLoad

P1924: !MEMBAR (Int)
membar #StoreLoad

P1925: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1926: !CAS [4] (maybe <- 0x81019f) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1927: !MEMBAR (Int)
membar #StoreLoad

P1928: !MEMBAR (Int)
membar #StoreLoad

P1929: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1930: !LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1931: !CAS [13] (maybe <- 0x8101a0) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1932: !ST [0] (maybe <- 0x8101a1) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1933: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1934: !MEMBAR (Int)
membar #StoreLoad

P1935: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P1936: !NOP (Int)
nop

P1937: !ST [6] (maybe <- 0x8101a2) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1938: !LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1939: !CASX [2] (maybe <- 0x8101a3) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1940: !ST [6] (maybe <- 0x8101a4) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1941: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1942: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1943: !NOP (Int)
nop

P1944: !CAS [12] (maybe <- 0x8101a5) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P1945: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1946: !DWST [4] (maybe <- 0x8101a6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1947: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1948: !DWST [15] (maybe <- 0x8101a7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1949: !MEMBAR (Int)
membar #StoreLoad

P1950: !DWLD [4] (Int)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)

P1951: !CAS [4] (maybe <- 0x8101a8) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1952: !DWST [2] (maybe <- 0x8101a9) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P1953: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1954: !ST [4] (maybe <- 0x8101aa) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1955: !ST [7] (maybe <- 0x8101ab) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1956: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P1957: !ST [4] (maybe <- 0x47800c80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P1958: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1959: !ST [4] (maybe <- 0x8101ac) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1960: !SWAP [1] (maybe <- 0x8101ad) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1961: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1962: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P1963: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1964: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P1965: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1966: !CASX [0] (maybe <- 0x8101ae) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P1967: !DWST [12] (maybe <- 0x8101b0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1968: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1969: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1970: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1971: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P1972: !DWLD [8] (Int)
ldx [%i1 + 256], %o2
! move %o2(upper) -> %o2(upper)

P1973: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1974: !DWST [3] (maybe <- 0x8101b1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1975: !DWST [11] (maybe <- 0x8101b2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1976: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2

P1977: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1978: !LD [0] (Int)
lduw [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1979: !ST [4] (maybe <- 0x47800d00) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P1980: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1981: !SWAP [6] (maybe <- 0x8101b3) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1982: !DWST [4] (maybe <- 0x8101b4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1983: !ST [7] (maybe <- 0x8101b5) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1984: !DWLD [4] (Int)
ldx [%i0 + 64], %o4
! move %o4(upper) -> %o4(upper)

P1985: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1986: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P1987: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P1988: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1989: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P1990: !DWST [14] (maybe <- 0x8101b6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1991: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1992: !MEMBAR (Int)
membar #StoreLoad

P1993: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1994: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1995: !CASX [1] (maybe <- 0x8101b7) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P1996: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1997: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P1998: !ST [11] (maybe <- 0x8101b9) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1999: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2000: !DWST [13] (maybe <- 0x8101ba) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2001: !ST [11] (maybe <- 0x8101bb) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2002: !MEMBAR (Int)
membar #StoreLoad

P2003: !SWAP [8] (maybe <- 0x8101bc) (Int)
mov %l4, %o4
swap  [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2004: !DWST [11] (maybe <- 0x8101bd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2005: !DWST [3] (maybe <- 0x8101be) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2006: !MEMBAR (Int)
membar #StoreLoad

P2007: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2008: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2009: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2010: !ST [11] (maybe <- 0x8101bf) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2011: !CAS [7] (maybe <- 0x8101c0) (Int)
add %i1, 84, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2012: !ST [11] (maybe <- 0x8101c1) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2013: !DWLD [8] (Int)
ldx [%i1 + 256], %o1
! move %o1(upper) -> %o1(upper)

P2014: !ST [6] (maybe <- 0x8101c2) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2015: !DWST [15] (maybe <- 0x47800d80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P2016: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P2017: !ST [14] (maybe <- 0x8101c3) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2018: !MEMBAR (Int)
membar #StoreLoad

P2019: !LD [0] (FP)
ld [%i0 + 0], %f11
! 1 addresses covered

P2020: !LD [1] (FP)
ld [%i0 + 4], %f12
! 1 addresses covered

P2021: !LD [2] (FP)
ld [%i0 + 12], %f13
! 1 addresses covered

P2022: !LD [3] (FP)
ld [%i0 + 32], %f14
! 1 addresses covered

P2023: !LD [4] (FP)
ld [%i0 + 64], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P2024: !LD [5] (FP)
ld [%i1 + 76], %f0
! 1 addresses covered

P2025: !LD [6] (FP)
ld [%i1 + 80], %f1
! 1 addresses covered

P2026: !LD [7] (FP)
ld [%i1 + 84], %f2
! 1 addresses covered

P2027: !LD [8] (FP)
ld [%i1 + 256], %f3
! 1 addresses covered

P2028: !LD [9] (FP)
ld [%i1 + 512], %f4
! 1 addresses covered

P2029: !LD [10] (FP)
ld [%i2 + 32], %f5
! 1 addresses covered

P2030: !LD [11] (FP)
ld [%i2 + 64], %f6
! 1 addresses covered

P2031: !LD [12] (FP)
ld [%i3 + 0], %f7
! 1 addresses covered

P2032: !LD [13] (FP)
ld [%i3 + 64], %f8
! 1 addresses covered

P2033: !LD [14] (FP)
ld [%i3 + 128], %f9
! 1 addresses covered

P2034: !LD [15] (FP)
ld [%i3 + 192], %f10
! 1 addresses covered
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30

restore
retl
nop
!-----------------



func2:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1152, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x02deade1), %l7
or    %l7, %lo(0x02deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x820001), %l4
or    %l4, %lo(0x820001), %l4

! Initialize FP counter 
sethi %hi(0x47ffff80), %l7
or    %l7, %lo(0x47ffff80), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P2035: !LD [13] (Int) (Loop entry) (Loop exit)
sethi %hi(0x1), %l2
or %l2, %lo(0x1),  %l2
loop_entry_2_0:
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2036: !CASX [0] (maybe <- 0x820001) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2037: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2038: !DWST [11] (maybe <- 0x820003) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2039: !CASX [2] (maybe <- 0x820004) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2040: !LD [3] (FP)
ld [%i0 + 32], %f0
! 1 addresses covered

P2041: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2042: !DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P2043: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2044: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2045: !LD [9] (FP)
ld [%i1 + 512], %f1
! 1 addresses covered

P2046: !ST [14] (maybe <- 0x820005) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2047: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2048: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2049: !LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2050: !DWST [0] (maybe <- 0x820006) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2051: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2052: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2053: !SWAP [15] (maybe <- 0x820008) (Int)
mov %l4, %o2
swap  [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2054: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2055: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2056: !DWST [8] (maybe <- 0x820009) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2057: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2058: !CAS [15] (maybe <- 0x82000a) (Int)
add %i3, 192, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2059: !NOP (Int)
nop

P2060: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2061: !DWST [13] (maybe <- 0x82000b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2062: !DWST [1] (maybe <- 0x82000c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2063: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2064: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2065: !DWST [6] (maybe <- 0x82000e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P2066: !ST [0] (maybe <- 0x820010) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2067: !DWLD [4] (Int)
ldx [%i0 + 64], %o4
! move %o4(upper) -> %o4(upper)

P2068: !ST [2] (maybe <- 0x820011) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2069: !CAS [7] (maybe <- 0x820012) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2070: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P2071: !ST [0] (maybe <- 0x820013) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2072: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2073: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2074: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2075: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2076: !DWST [9] (maybe <- 0x820014) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2077: !MEMBAR (Int)
membar #StoreLoad

P2078: !CAS [10] (maybe <- 0x820015) (Int)
add %i2, 32, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2079: !DWST [8] (maybe <- 0x820016) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2080: !SWAP [11] (maybe <- 0x820017) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2081: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2082: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2083: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2084: !ST [2] (maybe <- 0x820018) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2085: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2086: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2087: !ST [8] (maybe <- 0x820019) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2088: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2089: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2090: !DWST [10] (maybe <- 0x82001a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2091: !CASX [4] (maybe <- 0x82001b) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2092: !ST [3] (maybe <- 0x82001c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2093: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2094: !CASX [15] (maybe <- 0x82001d) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2095: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2096: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2097: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P2098: !MEMBAR (Int)
membar #StoreLoad

P2099: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2100: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P2101: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2102: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2103: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2104: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P2105: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2106: !DWLD [9] (Int)
ldx [%i1 + 512], %o4
! move %o4(upper) -> %o4(upper)

P2107: !CAS [12] (maybe <- 0x82001e) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2108: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2109: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2110: !SWAP [6] (maybe <- 0x82001f) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2111: !DWLD [12] (Int)
ldx [%i3 + 0], %o1
! move %o1(upper) -> %o1(upper)

P2112: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2113: !CAS [5] (maybe <- 0x820020) (Int)
add %i1, 76, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2114: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2115: !CASX [13] (maybe <- 0x820021) (Int)
add %i3, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2116: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2117: !CASX [3] (maybe <- 0x820022) (Int)
add %i0, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P2118: !LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2119: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2

P2120: !ST [8] (maybe <- 0x820023) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2121: !DWST [8] (maybe <- 0x820024) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2122: !DWST [5] (maybe <- 0x47ffff80) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P2123: !CAS [3] (maybe <- 0x820025) (Int)
add %i0, 32, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2124: !DWLD [12] (Int)
ldx [%i3 + 0], %o4
! move %o4(upper) -> %o4(upper)

P2125: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2126: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2127: !DWST [5] (maybe <- 0x820026) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2128: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2129: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2130: !LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2131: !DWST [5] (maybe <- 0x820027) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2132: !DWST [3] (maybe <- 0x820028) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2133: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2134: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2135: !MEMBAR (Int)
membar #StoreLoad

P2136: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2137: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2138: !ST [11] (maybe <- 0x820029) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2139: !ST [1] (maybe <- 0x82002a) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2140: !DWST [10] (maybe <- 0x82002b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2141: !MEMBAR (Int)
membar #StoreLoad

P2142: !ST [7] (maybe <- 0x82002c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2143: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2144: !DWST [5] (maybe <- 0x82002d) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2145: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2146: !ST [2] (maybe <- 0x82002e) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2147: !ST [13] (maybe <- 0x82002f) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2148: !MEMBAR (Int)
membar #StoreLoad

P2149: !MEMBAR (Int)
membar #StoreLoad

P2150: !DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P2151: !CAS [0] (maybe <- 0x820030) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2152: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2153: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2154: !CAS [1] (maybe <- 0x820031) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2155: !CASX [9] (maybe <- 0x820032) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2156: !DWST [8] (maybe <- 0x820033) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2157: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2158: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2159: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2160: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2161: !CAS [3] (maybe <- 0x820034) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2162: !DWST [2] (maybe <- 0x820035) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P2163: !SWAP [8] (maybe <- 0x820036) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2164: !ST [11] (maybe <- 0x820037) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2165: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2166: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2167: !CAS [15] (maybe <- 0x820038) (Int)
add %i3, 192, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2168: !ST [10] (maybe <- 0x820039) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2169: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2170: !LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2171: !CASX [0] (maybe <- 0x82003a) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2172: !CASX [2] (maybe <- 0x82003c) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2173: !DWST [3] (maybe <- 0x82003d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2174: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2175: !MEMBAR (Int)
membar #StoreLoad

P2176: !SWAP [9] (maybe <- 0x82003e) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2177: !ST [8] (maybe <- 0x82003f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2178: !MEMBAR (Int)
membar #StoreLoad

P2179: !LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2180: !DWST [7] (maybe <- 0x820040) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P2181: !DWST [15] (maybe <- 0x820042) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2182: !ST [13] (maybe <- 0x820043) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2183: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2184: !DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P2185: !ST [7] (maybe <- 0x820044) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2186: !MEMBAR (Int)
membar #StoreLoad

P2187: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P2188: !DWST [8] (maybe <- 0x48000000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P2189: !LD [15] (Int)
lduw [%i3 + 192], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2190: !ST [10] (maybe <- 0x820045) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2191: !DWST [2] (maybe <- 0x820046) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P2192: !DWST [10] (maybe <- 0x820047) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2193: !ST [11] (maybe <- 0x48000040) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P2194: !DWST [15] (maybe <- 0x820048) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2195: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2196: !ST [3] (maybe <- 0x48000080) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P2197: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2198: !MEMBAR (Int)
membar #StoreLoad

P2199: !CAS [9] (maybe <- 0x820049) (Int)
add %i1, 512, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2200: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2201: !ST [13] (maybe <- 0x82004a) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2202: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2203: !SWAP [10] (maybe <- 0x82004b) (Int)
mov %l4, %o4
swap  [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2204: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2205: !MEMBAR (Int)
membar #StoreLoad

P2206: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2207: !ST [12] (maybe <- 0x82004c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2208: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2209: !ST [4] (maybe <- 0x82004d) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2210: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2211: !DWST [1] (maybe <- 0x82004e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2212: !ST [14] (maybe <- 0x820050) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2213: !CAS [4] (maybe <- 0x820051) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2214: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2215: !ST [2] (maybe <- 0x820052) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2216: !CAS [2] (maybe <- 0x820053) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2217: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2218: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2219: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2220: !CASX [6] (maybe <- 0x820054) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2221: !CASX [14] (maybe <- 0x820056) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2222: !CAS [5] (maybe <- 0x820057) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2223: !SWAP [3] (maybe <- 0x820058) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2224: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2225: !MEMBAR (Int)
membar #StoreLoad

P2226: !CAS [0] (maybe <- 0x820059) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2227: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2228: !MEMBAR (Int)
membar #StoreLoad

P2229: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2230: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2231: !ST [3] (maybe <- 0x82005a) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2232: !CAS [1] (maybe <- 0x82005b) (Int)
add %i0, 4, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2233: !DWST [9] (maybe <- 0x82005c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2234: !DWST [4] (maybe <- 0x82005d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2235: !SWAP [7] (maybe <- 0x82005e) (Int)
mov %l4, %o1
swap  [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2236: !DWST [7] (maybe <- 0x82005f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P2237: !ST [4] (maybe <- 0x820061) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2238: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2239: !DWST [3] (maybe <- 0x820062) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2240: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2241: !DWST [14] (maybe <- 0x820063) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2242: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2243: !LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2244: !CAS [2] (maybe <- 0x820064) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2245: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2246: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2247: !DWST [11] (maybe <- 0x820065) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2248: !CAS [9] (maybe <- 0x820066) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2249: !MEMBAR (Int)
membar #StoreLoad

P2250: !DWST [0] (maybe <- 0x820067) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2251: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2252: !SWAP [0] (maybe <- 0x820069) (Int)
mov %l4, %l6
swap  [%i0 + 0], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2253: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2254: !CAS [15] (maybe <- 0x82006a) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2255: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2256: !ST [2] (maybe <- 0x480000c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P2257: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2258: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2259: !CAS [10] (maybe <- 0x82006b) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2260: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2261: !DWST [13] (maybe <- 0x82006c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2262: !MEMBAR (Int)
membar #StoreLoad

P2263: !CAS [1] (maybe <- 0x82006d) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2264: !CAS [2] (maybe <- 0x82006e) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2265: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2266: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2267: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2268: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2269: !DWLD [9] (Int)
ldx [%i1 + 512], %o2
! move %o2(upper) -> %o2(upper)

P2270: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2

P2271: !LD [6] (Int)
lduw [%i1 + 80], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2272: !ST [15] (maybe <- 0x82006f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2273: !CAS [8] (maybe <- 0x820070) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2274: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2275: !DWST [9] (maybe <- 0x820071) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2276: !SWAP [11] (maybe <- 0x820072) (Int)
mov %l4, %o0
swap  [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2277: !MEMBAR (Int)
membar #StoreLoad

P2278: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2279: !MEMBAR (Int)
membar #StoreLoad

P2280: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2281: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2282: !SWAP [15] (maybe <- 0x820073) (Int)
mov %l4, %o1
swap  [%i3 + 192], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2283: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2284: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2285: !DWST [9] (maybe <- 0x820074) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2286: !CASX [10] (maybe <- 0x820075) (Int)
add %i2, 32, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2287: !ST [5] (maybe <- 0x820076) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2288: !ST [9] (maybe <- 0x820077) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2289: !DWLD [13] (FP)
! case fp 
ldd  [%i3 + 64], %f2
! 1 addresses covered

P2290: !ST [7] (maybe <- 0x820078) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2291: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2292: !MEMBAR (Int)
membar #StoreLoad

P2293: !DWLD [6] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2294: !SWAP [13] (maybe <- 0x820079) (Int)
mov %l4, %o0
swap  [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2295: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2296: !DWLD [13] (Int)
ldx [%i3 + 64], %o1
! move %o1(upper) -> %o1(upper)

P2297: !DWST [3] (maybe <- 0x82007a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2298: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2299: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2300: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2301: !CASX [13] (maybe <- 0x82007b) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2302: !ST [11] (maybe <- 0x82007c) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2303: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P2304: !SWAP [12] (maybe <- 0x82007d) (Int)
mov %l4, %o4
swap  [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2305: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2306: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2307: !MEMBAR (Int)
membar #StoreLoad

P2308: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2309: !LD [12] (Int)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2310: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2311: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2312: !NOP (Int)
nop

P2313: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2314: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2315: !CASX [2] (maybe <- 0x82007e) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2316: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P2317: !CASX [11] (maybe <- 0x82007f) (Int)
add %i2, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2318: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2319: !MEMBAR (Int)
membar #StoreLoad

P2320: !ST [14] (maybe <- 0x820080) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2321: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2322: !MEMBAR (Int)
membar #StoreLoad

P2323: !MEMBAR (Int)
membar #StoreLoad

P2324: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2325: !MEMBAR (Int)
membar #StoreLoad

P2326: !DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P2327: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2328: !ST [1] (maybe <- 0x820081) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2329: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2330: !DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P2331: !ST [4] (maybe <- 0x820082) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2332: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2333: !SWAP [4] (maybe <- 0x820083) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2334: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2335: !DWLD [15] (Int)
ldx [%i3 + 192], %o3
! move %o3(upper) -> %o3(upper)

P2336: !DWLD [9] (FP)
! case fp 
ldd  [%i1 + 512], %f18
! 1 addresses covered
fmovs %f18, %f3

P2337: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P2338: !ST [7] (maybe <- 0x820084) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2339: !ST [7] (maybe <- 0x820085) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2340: !SWAP [14] (maybe <- 0x820086) (Int)
mov %l4, %o4
swap  [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2341: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2342: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2343: !NOP (Int)
nop

P2344: !ST [0] (maybe <- 0x820087) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2345: !MEMBAR (Int)
membar #StoreLoad

P2346: !ST [7] (maybe <- 0x48000100) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P2347: !CASX [15] (maybe <- 0x820088) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2348: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2349: !ST [7] (maybe <- 0x820089) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2350: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2351: !CAS [4] (maybe <- 0x82008a) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2352: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2353: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2354: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2355: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P2356: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2357: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2358: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2359: !SWAP [6] (maybe <- 0x82008b) (Int)
mov %l4, %o4
swap  [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2360: !NOP (Int)
nop

P2361: !ST [10] (maybe <- 0x82008c) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2362: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2363: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2364: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2365: !ST [3] (maybe <- 0x48000140) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P2366: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2367: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2368: !LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2369: !DWST [14] (maybe <- 0x82008d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2370: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2371: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2372: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2373: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2374: !MEMBAR (Int)
membar #StoreLoad

P2375: !ST [1] (maybe <- 0x82008e) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2376: !LD [9] (FP)
ld [%i1 + 512], %f4
! 1 addresses covered

P2377: !MEMBAR (Int)
membar #StoreLoad

P2378: !MEMBAR (Int)
membar #StoreLoad

P2379: !DWST [4] (maybe <- 0x82008f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2380: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2381: !SWAP [13] (maybe <- 0x820090) (Int)
mov %l4, %o2
swap  [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2382: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f18
! 1 addresses covered
fmovs %f18, %f5

P2383: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2384: !DWST [11] (maybe <- 0x820091) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2385: !CASX [13] (maybe <- 0x820092) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2386: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2387: !CAS [12] (maybe <- 0x820093) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2388: !MEMBAR (Int)
membar #StoreLoad

P2389: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2390: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2391: !CAS [4] (maybe <- 0x820094) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2392: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2393: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2

P2394: !DWST [8] (maybe <- 0x820095) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2395: !LD [6] (FP)
ld [%i1 + 80], %f6
! 1 addresses covered

P2396: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2397: !ST [15] (maybe <- 0x48000180) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P2398: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2399: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P2400: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2401: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2402: !CAS [12] (maybe <- 0x820096) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P2403: !CASX [12] (maybe <- 0x820097) (Int)
add %i3, 0, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P2404: !DWST [5] (maybe <- 0x820098) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2405: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2406: !CASX [7] (maybe <- 0x820099) (Int)
add %i1, 80, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2407: !SWAP [9] (maybe <- 0x82009b) (Int)
mov %l4, %o4
swap  [%i1 + 512], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2408: !CAS [8] (maybe <- 0x82009c) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2409: !ST [11] (maybe <- 0x82009d) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2410: !CAS [3] (maybe <- 0x82009e) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2411: !ST [8] (maybe <- 0x82009f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2412: !CAS [11] (maybe <- 0x8200a0) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2413: !MEMBAR (Int)
membar #StoreLoad

P2414: !MEMBAR (Int)
membar #StoreLoad

P2415: !CAS [7] (maybe <- 0x8200a1) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2416: !SWAP [14] (maybe <- 0x8200a2) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2417: !MEMBAR (Int)
membar #StoreLoad

P2418: !DWLD [6] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2419: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2420: !DWLD [10] (FP)
! case fp 
ldd  [%i2 + 32], %f18
! 1 addresses covered
fmovs %f18, %f7

P2421: !SWAP [12] (maybe <- 0x8200a3) (Int)
mov %l4, %o0
swap  [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2422: !ST [7] (maybe <- 0x8200a4) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2423: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2424: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2425: !SWAP [6] (maybe <- 0x8200a5) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2426: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2427: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2428: !DWST [11] (maybe <- 0x8200a6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2429: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2430: !CAS [10] (maybe <- 0x8200a7) (Int)
add %i2, 32, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2431: !ST [7] (maybe <- 0x8200a8) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2432: !CASX [3] (maybe <- 0x8200a9) (Int)
add %i0, 32, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2433: !DWLD [0] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2434: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2435: !ST [6] (maybe <- 0x480001c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P2436: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2437: !ST [13] (maybe <- 0x8200aa) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2438: !LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2439: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2440: !NOP (Int)
nop

P2441: !DWST [14] (maybe <- 0x8200ab) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2442: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2443: !MEMBAR (Int)
membar #StoreLoad

P2444: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2445: !LD [6] (FP)
ld [%i1 + 80], %f8
! 1 addresses covered

P2446: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2447: !DWST [10] (maybe <- 0x48000200) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P2448: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P2449: !MEMBAR (Int)
membar #StoreLoad

P2450: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2451: !CAS [4] (maybe <- 0x8200ac) (Int)
add %i0, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P2452: !SWAP [14] (maybe <- 0x8200ad) (Int)
mov %l4, %o0
swap  [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2453: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P2454: !CAS [15] (maybe <- 0x8200ae) (Int)
add %i3, 192, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2455: !DWST [13] (maybe <- 0x8200af) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2456: !DWST [10] (maybe <- 0x8200b0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2457: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P2458: !ST [4] (maybe <- 0x8200b1) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2459: !ST [15] (maybe <- 0x8200b2) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2460: !CASX [8] (maybe <- 0x8200b3) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2461: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2462: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2463: !ST [0] (maybe <- 0x8200b4) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2464: !MEMBAR (Int)
membar #StoreLoad

P2465: !NOP (Int)
nop

P2466: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2467: !LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2468: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2469: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2470: !SWAP [6] (maybe <- 0x8200b5) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2471: !MEMBAR (Int)
membar #StoreLoad

P2472: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2473: !MEMBAR (Int)
membar #StoreLoad

P2474: !DWLD [7] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P2475: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2476: !ST [12] (maybe <- 0x8200b6) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2477: !ST [6] (maybe <- 0x8200b7) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2478: !CAS [2] (maybe <- 0x8200b8) (Int)
add %i0, 12, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2479: !DWST [12] (maybe <- 0x8200b9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2480: !LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2481: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2482: !CAS [8] (maybe <- 0x8200ba) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2483: !DWST [2] (maybe <- 0x8200bb) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P2484: !NOP (Int)
nop

P2485: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2486: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2487: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2488: !CASX [8] (maybe <- 0x8200bc) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2489: !ST [4] (maybe <- 0x8200bd) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2490: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2491: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2492: !DWST [1] (maybe <- 0x8200be) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2493: !CASX [2] (maybe <- 0x8200c0) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2494: !DWST [15] (maybe <- 0x8200c1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2495: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P2496: !MEMBAR (Int)
membar #StoreLoad

P2497: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2498: !DWLD [9] (Int)
ldx [%i1 + 512], %o4
! move %o4(upper) -> %o4(upper)

P2499: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2500: !MEMBAR (Int)
membar #StoreLoad

P2501: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2502: !ST [3] (maybe <- 0x8200c2) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2503: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2504: !MEMBAR (Int)
membar #StoreLoad

P2505: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2506: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2507: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2508: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2509: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2510: !DWLD [2] (FP)
! case fp 
ldd  [%i0 + 8], %f18
! 1 addresses covered
fmovs %f19, %f9

P2511: !DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P2512: !MEMBAR (Int)
membar #StoreLoad

P2513: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2514: !DWST [11] (maybe <- 0x8200c3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2515: !DWST [3] (maybe <- 0x8200c4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2516: !CAS [3] (maybe <- 0x8200c5) (Int)
add %i0, 32, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2517: !ST [13] (maybe <- 0x8200c6) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2518: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2519: !CAS [4] (maybe <- 0x8200c7) (Int)
add %i0, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2520: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P2521: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2522: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2523: !CASX [4] (maybe <- 0x8200c8) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2524: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2525: !DWST [10] (maybe <- 0x8200c9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2526: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2527: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2528: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2529: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2530: !MEMBAR (Int)
membar #StoreLoad

P2531: !ST [15] (maybe <- 0x8200ca) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2532: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2533: !DWLD [15] (Int)
ldx [%i3 + 192], %o1
! move %o1(upper) -> %o1(upper)

P2534: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2535: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2536: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2537: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P2538: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2539: !CAS [14] (maybe <- 0x8200cb) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2540: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2541: !DWST [1] (maybe <- 0x8200cc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2542: !MEMBAR (Int)
membar #StoreLoad

P2543: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2544: !ST [6] (maybe <- 0x8200ce) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2545: !MEMBAR (Int)
membar #StoreLoad

P2546: !LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2547: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2548: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2549: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2550: !LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2551: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2552: !LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2553: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P2554: !LD [5] (Int)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2555: !LD [8] (FP)
ld [%i1 + 256], %f10
! 1 addresses covered

P2556: !LD [5] (FP)
ld [%i1 + 76], %f11
! 1 addresses covered

P2557: !LD [5] (FP)
ld [%i1 + 76], %f12
! 1 addresses covered

P2558: !LD [1] (FP)
ld [%i0 + 4], %f13
! 1 addresses covered

P2559: !LD [1] (FP)
ld [%i0 + 4], %f14
! 1 addresses covered

P2560: !LD [7] (FP)
ld [%i1 + 84], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P2561: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
loop_exit_2_0:
sub %l2, 1, %l2
cmp %l2, 0
bg loop_entry_2_0
nop

P2562: !ST [15] (maybe <- 0x8200cf) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2563: !CASX [10] (maybe <- 0x8200d0) (Int)
add %i2, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P2564: !DWLD [7] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P2565: !LD [14] (FP)
ld [%i3 + 128], %f0
! 1 addresses covered

P2566: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2567: !MEMBAR (Int)
membar #StoreLoad

P2568: !CAS [2] (maybe <- 0x8200d1) (Int)
add %i0, 12, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2569: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2570: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2571: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2572: !SWAP [2] (maybe <- 0x8200d2) (Int)
mov %l4, %o0
swap  [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2573: !MEMBAR (Int)
membar #StoreLoad

P2574: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2575: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2576: !CAS [3] (maybe <- 0x8200d3) (Int)
add %i0, 32, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2577: !LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2578: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f18
! 1 addresses covered
fmovs %f18, %f1

P2579: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2580: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2581: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2582: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P2583: !ST [7] (maybe <- 0x8200d4) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2584: !SWAP [7] (maybe <- 0x8200d5) (Int)
mov %l4, %o3
swap  [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2585: !ST [2] (maybe <- 0x8200d6) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2586: !CASX [5] (maybe <- 0x8200d7) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2587: !CAS [1] (maybe <- 0x8200d8) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2588: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2589: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2590: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2591: !SWAP [2] (maybe <- 0x8200d9) (Int)
mov %l4, %o2
swap  [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2592: !DWST [13] (maybe <- 0x8200da) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2593: !DWST [1] (maybe <- 0x8200db) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2594: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2595: !SWAP [7] (maybe <- 0x8200dd) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2596: !DWLD [1] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2597: !LD [12] (Int)
lduw [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2598: !CAS [15] (maybe <- 0x8200de) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2599: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P2600: !MEMBAR (Int)
membar #StoreLoad

P2601: !DWST [14] (maybe <- 0x8200df) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2602: !LD [14] (FP)
ld [%i3 + 128], %f2
! 1 addresses covered

P2603: !CAS [11] (maybe <- 0x8200e0) (Int)
add %i2, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2604: !MEMBAR (Int)
membar #StoreLoad

P2605: !CASX [0] (maybe <- 0x8200e1) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2606: !LD [11] (Int)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2607: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2608: !SWAP [15] (maybe <- 0x8200e3) (Int)
mov %l4, %o0
swap  [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2609: !ST [9] (maybe <- 0x8200e4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2610: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2611: !SWAP [12] (maybe <- 0x8200e5) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2612: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2613: !ST [2] (maybe <- 0x8200e6) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2614: !CAS [13] (maybe <- 0x8200e7) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2615: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2616: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2617: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2618: !CAS [13] (maybe <- 0x8200e8) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2619: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2620: !DWLD [1] (FP)
! case fp 
ldd  [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f3
fmovs %f19, %f4

P2621: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2622: !DWST [1] (maybe <- 0x8200e9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2623: !MEMBAR (Int)
membar #StoreLoad

P2624: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2625: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2626: !DWST [12] (maybe <- 0x8200eb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2627: !MEMBAR (Int)
membar #StoreLoad

P2628: !DWST [8] (maybe <- 0x8200ec) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2629: !MEMBAR (Int)
membar #StoreLoad

P2630: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2631: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2632: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2633: !MEMBAR (Int)
membar #StoreLoad

P2634: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2635: !LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2636: !CASX [7] (maybe <- 0x8200ed) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2637: !CASX [0] (maybe <- 0x8200ef) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2638: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2639: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2640: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2641: !CASX [7] (maybe <- 0x8200f1) (Int)
add %i1, 80, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2642: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2643: !SWAP [11] (maybe <- 0x8200f3) (Int)
mov %l4, %o4
swap  [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2644: !DWST [14] (maybe <- 0x8200f4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2645: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2646: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2647: !LD [0] (FP)
ld [%i0 + 0], %f5
! 1 addresses covered

P2648: !CAS [13] (maybe <- 0x8200f5) (Int)
add %i3, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2649: !SWAP [13] (maybe <- 0x8200f6) (Int)
mov %l4, %o1
swap  [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2650: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2651: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2652: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2653: !ST [14] (maybe <- 0x48000240) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P2654: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2655: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2656: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2657: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2658: !SWAP [5] (maybe <- 0x8200f7) (Int)
mov %l4, %o4
swap  [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2659: !CAS [4] (maybe <- 0x8200f8) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2660: !DWST [1] (maybe <- 0x8200f9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2661: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2662: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2663: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2664: !ST [1] (maybe <- 0x8200fb) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2665: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2666: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2667: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2668: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2669: !MEMBAR (Int)
membar #StoreLoad

P2670: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2671: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2672: !ST [15] (maybe <- 0x8200fc) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2673: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2674: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2675: !DWST [15] (maybe <- 0x8200fd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2676: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2677: !ST [8] (maybe <- 0x8200fe) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2678: !ST [0] (maybe <- 0x8200ff) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2679: !DWST [15] (maybe <- 0x48000280) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P2680: !DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P2681: !SWAP [2] (maybe <- 0x820100) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2682: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2683: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2684: !MEMBAR (Int)
membar #StoreLoad

P2685: !DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2686: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2687: !LD [0] (Int)
lduw [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2688: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2689: !DWST [15] (maybe <- 0x820101) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2690: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2691: !LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2692: !ST [14] (maybe <- 0x820102) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2693: !ST [1] (maybe <- 0x480002c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P2694: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2695: !LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2696: !MEMBAR (Int)
membar #StoreLoad

P2697: !ST [7] (maybe <- 0x820103) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2698: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2699: !ST [15] (maybe <- 0x820104) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2700: !DWST [1] (maybe <- 0x820105) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2701: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2702: !ST [3] (maybe <- 0x820107) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2703: !LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2704: !ST [1] (maybe <- 0x820108) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2705: !DWST [0] (maybe <- 0x820109) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2706: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2707: !ST [11] (maybe <- 0x82010b) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2708: !ST [1] (maybe <- 0x82010c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2709: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2710: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P2711: !CASX [8] (maybe <- 0x82010d) (Int)
add %i1, 256, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2712: !MEMBAR (Int)
membar #StoreLoad

P2713: !ST [5] (maybe <- 0x82010e) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2714: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2715: !LD [3] (Int)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2716: !CASX [13] (maybe <- 0x82010f) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2717: !CAS [6] (maybe <- 0x820110) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2718: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2719: !LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2720: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2721: !DWLD [14] (Int)
ldx [%i3 + 128], %o1
! move %o1(upper) -> %o1(upper)

P2722: !CASX [7] (maybe <- 0x820111) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2723: !ST [8] (maybe <- 0x820113) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2724: !MEMBAR (Int)
membar #StoreLoad

P2725: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2726: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2727: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2728: !ST [3] (maybe <- 0x820114) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2729: !DWST [1] (maybe <- 0x820115) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2730: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2731: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2732: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2733: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2734: !CASX [7] (maybe <- 0x820117) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2735: !DWST [13] (maybe <- 0x820119) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2736: !CASX [14] (maybe <- 0x82011a) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2737: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2738: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2739: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2740: !CASX [12] (maybe <- 0x82011b) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2741: !MEMBAR (Int)
membar #StoreLoad

P2742: !MEMBAR (Int)
membar #StoreLoad

P2743: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2744: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2745: !DWST [2] (maybe <- 0x48000300) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P2746: !ST [6] (maybe <- 0x82011c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2747: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2748: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2749: !CAS [13] (maybe <- 0x82011d) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2750: !CAS [5] (maybe <- 0x82011e) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2751: !DWST [10] (maybe <- 0x82011f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2752: !CAS [0] (maybe <- 0x820120) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2753: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2754: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2755: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2756: !DWST [12] (maybe <- 0x820121) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2757: !MEMBAR (Int)
membar #StoreLoad

P2758: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2759: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2760: !LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2761: !ST [9] (maybe <- 0x820122) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2762: !MEMBAR (Int)
membar #StoreLoad

P2763: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2764: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2765: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2766: !DWLD [4] (Int)
ldx [%i0 + 64], %o3
! move %o3(upper) -> %o3(upper)

P2767: !ST [2] (maybe <- 0x820123) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2768: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2769: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P2770: !LD [12] (FP)
ld [%i3 + 0], %f6
! 1 addresses covered

P2771: !DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2772: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2773: !DWLD [2] (Int)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2774: !CASX [7] (maybe <- 0x820124) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2775: !CASX [8] (maybe <- 0x820126) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2776: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2777: !ST [6] (maybe <- 0x48000340) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P2778: !MEMBAR (Int)
membar #StoreLoad

P2779: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2780: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2781: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2782: !DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P2783: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2784: !CAS [0] (maybe <- 0x820127) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2785: !DWST [5] (maybe <- 0x820128) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2786: !SWAP [4] (maybe <- 0x820129) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2787: !LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2788: !MEMBAR (Int)
membar #StoreLoad

P2789: !CAS [2] (maybe <- 0x82012a) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2790: !MEMBAR (Int)
membar #StoreLoad

P2791: !CASX [2] (maybe <- 0x82012b) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2792: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2793: !ST [14] (maybe <- 0x82012c) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2794: !CASX [5] (maybe <- 0x82012d) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2795: !DWST [12] (maybe <- 0x82012e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2796: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2797: !ST [14] (maybe <- 0x48000380) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P2798: !ST [4] (maybe <- 0x82012f) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2799: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2800: !DWST [14] (maybe <- 0x820130) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2801: !SWAP [1] (maybe <- 0x820131) (Int)
mov %l4, %o3
swap  [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2802: !DWST [14] (maybe <- 0x820132) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2803: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2804: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P2805: !DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P2806: !MEMBAR (Int)
membar #StoreLoad

P2807: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2808: !MEMBAR (Int)
membar #StoreLoad

P2809: !CAS [4] (maybe <- 0x820133) (Int)
add %i0, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2810: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2811: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2812: !LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2813: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2814: !DWLD [5] (Int)
ldx [%i1 + 72], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2815: !MEMBAR (Int)
membar #StoreLoad

P2816: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2817: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2818: !SWAP [11] (maybe <- 0x820134) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2819: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2820: !DWST [5] (maybe <- 0x820135) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2821: !ST [6] (maybe <- 0x820136) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2822: !ST [8] (maybe <- 0x820137) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2823: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2824: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2825: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2826: !CAS [1] (maybe <- 0x820138) (Int)
add %i0, 4, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P2827: !DWLD [13] (Int)
ldx [%i3 + 64], %o0
! move %o0(upper) -> %o0(upper)

P2828: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2829: !ST [6] (maybe <- 0x820139) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2830: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2831: !CASX [3] (maybe <- 0x82013a) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2832: !DWST [14] (maybe <- 0x82013b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2833: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2834: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2835: !CASX [8] (maybe <- 0x82013c) (Int)
add %i1, 256, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2836: !DWST [7] (maybe <- 0x480003c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P2837: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2838: !ST [7] (maybe <- 0x82013d) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2839: !ST [2] (maybe <- 0x82013e) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2840: !DWST [0] (maybe <- 0x82013f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P2841: !CASX [10] (maybe <- 0x820141) (Int)
add %i2, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P2842: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2843: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2844: !ST [4] (maybe <- 0x820142) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2845: !CAS [11] (maybe <- 0x820143) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2846: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2847: !DWST [10] (maybe <- 0x820144) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2848: !ST [0] (maybe <- 0x820145) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2849: !CAS [2] (maybe <- 0x820146) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2850: !DWST [13] (maybe <- 0x820147) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2851: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2852: !ST [9] (maybe <- 0x820148) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2853: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2854: !ST [9] (maybe <- 0x48000440) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P2855: !DWST [9] (maybe <- 0x48000480) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P2856: !SWAP [7] (maybe <- 0x820149) (Int)
mov %l4, %o0
swap  [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2857: !ST [10] (maybe <- 0x82014a) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2858: !DWST [10] (maybe <- 0x82014b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2859: !CASX [4] (maybe <- 0x82014c) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2860: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f18
! 1 addresses covered
fmovs %f18, %f7

P2861: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P2862: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P2863: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P2864: !LD [10] (FP)
ld [%i2 + 32], %f8
! 1 addresses covered

P2865: !LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2866: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2867: !ST [1] (maybe <- 0x82014d) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2868: !MEMBAR (Int)
membar #StoreLoad

P2869: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2870: !MEMBAR (Int)
membar #StoreLoad

P2871: !DWST [14] (maybe <- 0x82014e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2872: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2873: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2874: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2875: !ST [4] (maybe <- 0x82014f) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2876: !ST [14] (maybe <- 0x820150) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2877: !CAS [4] (maybe <- 0x820151) (Int)
add %i0, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2878: !CASX [13] (maybe <- 0x820152) (Int)
add %i3, 64, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P2879: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2880: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P2881: !CASX [8] (maybe <- 0x820153) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2882: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P2883: !DWST [13] (maybe <- 0x820154) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2884: !DWST [10] (maybe <- 0x820155) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2885: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2886: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P2887: !DWST [12] (maybe <- 0x820156) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2888: !LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2889: !CASX [10] (maybe <- 0x820157) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2890: !DWST [5] (maybe <- 0x820158) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P2891: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2892: !DWST [12] (maybe <- 0x820159) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2893: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2894: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2895: !DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P2896: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2897: !DWLD [7] (FP)
! case fp 
ldd  [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f9
fmovs %f19, %f10

P2898: !MEMBAR (Int)
membar #StoreLoad

P2899: !LD [15] (Int)
lduw [%i3 + 192], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2900: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2901: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2902: !DWST [6] (maybe <- 0x82015a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P2903: !CASX [9] (maybe <- 0x82015c) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2904: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2905: !SWAP [15] (maybe <- 0x82015d) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2906: !NOP (Int)
nop

P2907: !DWST [12] (maybe <- 0x82015e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2908: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2909: !DWST [10] (maybe <- 0x82015f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2910: !ST [13] (maybe <- 0x820160) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2911: !CASX [9] (maybe <- 0x820161) (Int)
add %i1, 512, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P2912: !CASX [9] (maybe <- 0x820162) (Int)
add %i1, 512, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2913: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2914: !MEMBAR (Int)
membar #StoreLoad

P2915: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2916: !SWAP [9] (maybe <- 0x820163) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2917: !CAS [14] (maybe <- 0x820164) (Int)
add %i3, 128, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P2918: !CAS [14] (maybe <- 0x820165) (Int)
add %i3, 128, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2919: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2920: !CAS [9] (maybe <- 0x820166) (Int)
add %i1, 512, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2921: !MEMBAR (Int)
membar #StoreLoad

P2922: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2923: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2924: !ST [3] (maybe <- 0x820167) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2925: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2926: !MEMBAR (Int)
membar #StoreLoad

P2927: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2928: !LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2929: !SWAP [6] (maybe <- 0x820168) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P2930: !ST [15] (maybe <- 0x820169) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2931: !SWAP [14] (maybe <- 0x82016a) (Int)
mov %l4, %o0
swap  [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2932: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2933: !DWST [14] (maybe <- 0x82016b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2934: !ST [3] (maybe <- 0x82016c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2935: !LD [14] (FP)
ld [%i3 + 128], %f11
! 1 addresses covered

P2936: !MEMBAR (Int)
membar #StoreLoad

P2937: !DWST [2] (maybe <- 0x82016d) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P2938: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P2939: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2940: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2941: !DWLD [13] (Int)
ldx [%i3 + 64], %o1
! move %o1(upper) -> %o1(upper)

P2942: !DWST [13] (maybe <- 0x82016e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2943: !CAS [13] (maybe <- 0x82016f) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2944: !CASX [8] (maybe <- 0x820170) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P2945: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2946: !DWST [9] (maybe <- 0x820171) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2947: !LD [10] (FP)
ld [%i2 + 32], %f12
! 1 addresses covered

P2948: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2949: !ST [13] (maybe <- 0x820172) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2950: !CASX [9] (maybe <- 0x820173) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2951: !DWST [13] (maybe <- 0x820174) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2952: !DWST [15] (maybe <- 0x820175) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2953: !MEMBAR (Int)
membar #StoreLoad

P2954: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2955: !LD [12] (FP)
ld [%i3 + 0], %f13
! 1 addresses covered

P2956: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2957: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P2958: !CAS [15] (maybe <- 0x820176) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2959: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2960: !SWAP [6] (maybe <- 0x820177) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P2961: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2962: !MEMBAR (Int)
membar #StoreLoad

P2963: !MEMBAR (Int)
membar #StoreLoad

P2964: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2965: !DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2966: !MEMBAR (Int)
membar #StoreLoad

P2967: !DWLD [14] (Int)
ldx [%i3 + 128], %o1
! move %o1(upper) -> %o1(upper)

P2968: !ST [10] (maybe <- 0x820178) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2969: !MEMBAR (Int)
membar #StoreLoad

P2970: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P2971: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2972: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P2973: !ST [12] (maybe <- 0x820179) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2974: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P2975: !DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P2976: !ST [2] (maybe <- 0x82017a) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2977: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P2978: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2979: !ST [8] (maybe <- 0x82017b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2980: !CASX [7] (maybe <- 0x82017c) (Int)
add %i1, 80, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2981: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P2982: !DWST [8] (maybe <- 0x480004c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P2983: !ST [14] (maybe <- 0x82017e) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2984: !DWST [0] (maybe <- 0x48000500) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P2985: !CAS [11] (maybe <- 0x82017f) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2986: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2987: !ST [3] (maybe <- 0x820180) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2988: !CASX [2] (maybe <- 0x820181) (Int)
add %i0, 8, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %l4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P2989: !MEMBAR (Int)
membar #StoreLoad

P2990: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2991: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2992: !DWLD [2] (Int)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2993: !DWST [13] (maybe <- 0x820182) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2994: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2995: !CAS [0] (maybe <- 0x820183) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2996: !ST [8] (maybe <- 0x820184) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2997: !DWST [15] (maybe <- 0x820185) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2998: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2999: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3000: !MEMBAR (Int)
membar #StoreLoad

P3001: !DWST [15] (maybe <- 0x820186) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3002: !MEMBAR (Int)
membar #StoreLoad

P3003: !MEMBAR (Int)
membar #StoreLoad

P3004: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3005: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3006: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3007: !DWLD [10] (Int)
ldx [%i2 + 32], %o2
! move %o2(upper) -> %o2(upper)

P3008: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3009: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3010: !DWST [4] (maybe <- 0x820187) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3011: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3012: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3013: !SWAP [11] (maybe <- 0x820188) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3014: !CASX [12] (maybe <- 0x820189) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3015: !CASX [0] (maybe <- 0x82018a) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3016: !ST [2] (maybe <- 0x82018c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3017: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3018: !DWLD [7] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3019: !ST [12] (maybe <- 0x82018d) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3020: !ST [12] (maybe <- 0x82018e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3021: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3022: !DWST [10] (maybe <- 0x82018f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3023: !DWST [1] (maybe <- 0x820190) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3024: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3025: !MEMBAR (Int)
membar #StoreLoad

P3026: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3027: !ST [15] (maybe <- 0x820192) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3028: !DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P3029: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3030: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3031: !DWST [13] (maybe <- 0x820193) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3032: !LD [14] (FP)
ld [%i3 + 128], %f14
! 1 addresses covered

P3033: !DWST [0] (maybe <- 0x820194) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3034: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P3035: !DWST [7] (maybe <- 0x820196) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3036: !SWAP [4] (maybe <- 0x820198) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3037: !ST [6] (maybe <- 0x820199) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3038: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3039: !SWAP [5] (maybe <- 0x82019a) (Int)
mov %l4, %o1
swap  [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3040: !SWAP [14] (maybe <- 0x82019b) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3041: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3042: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3043: !DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3044: !LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3045: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3046: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3047: !DWLD [6] (FP)
! case fp 
ldd  [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f15
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovs %f19, %f0

P3048: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3049: !ST [7] (maybe <- 0x82019c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3050: !MEMBAR (FP)
membar #StoreLoad

P3051: !LD [0] (FP)
ld [%i0 + 0], %f1
! 1 addresses covered

P3052: !LD [1] (FP)
ld [%i0 + 4], %f2
! 1 addresses covered

P3053: !LD [2] (FP)
ld [%i0 + 12], %f3
! 1 addresses covered

P3054: !LD [3] (FP)
ld [%i0 + 32], %f4
! 1 addresses covered

P3055: !LD [4] (FP)
ld [%i0 + 64], %f5
! 1 addresses covered

P3056: !LD [5] (FP)
ld [%i1 + 76], %f6
! 1 addresses covered

P3057: !LD [6] (FP)
ld [%i1 + 80], %f7
! 1 addresses covered

P3058: !LD [7] (FP)
ld [%i1 + 84], %f8
! 1 addresses covered

P3059: !LD [8] (FP)
ld [%i1 + 256], %f9
! 1 addresses covered

P3060: !LD [9] (FP)
ld [%i1 + 512], %f10
! 1 addresses covered

P3061: !LD [10] (FP)
ld [%i2 + 32], %f11
! 1 addresses covered

P3062: !LD [11] (FP)
ld [%i2 + 64], %f12
! 1 addresses covered

P3063: !LD [12] (FP)
ld [%i3 + 0], %f13
! 1 addresses covered

P3064: !LD [13] (FP)
ld [%i3 + 64], %f14
! 1 addresses covered

P3065: !LD [14] (FP)
ld [%i3 + 128], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P3066: !LD [15] (FP)
ld [%i3 + 192], %f0
! 1 addresses covered
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30

restore
retl
nop
!-----------------



func3:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1216, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x03deade1), %l7
or    %l7, %lo(0x03deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x830001), %l4
or    %l4, %lo(0x830001), %l4

! Initialize FP counter 
sethi %hi(0x483fff80), %l7
or    %l7, %lo(0x483fff80), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P3067: !CAS [4] (maybe <- 0x830001) (Int)
add %i0, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3068: !DWST [5] (maybe <- 0x830002) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3069: !SWAP [2] (maybe <- 0x830003) (Int)
mov %l4, %o1
swap  [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3070: !NOP (Int)
nop

P3071: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3072: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3073: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3074: !SWAP [2] (maybe <- 0x830004) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3075: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3076: !DWLD [12] (Int)
ldx [%i3 + 0], %o2
! move %o2(upper) -> %o2(upper)

P3077: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3078: !DWLD [1] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3079: !DWST [0] (maybe <- 0x830005) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3080: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3081: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3082: !LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3083: !CASX [11] (maybe <- 0x830007) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3084: !MEMBAR (Int)
membar #StoreLoad

P3085: !SWAP [3] (maybe <- 0x830008) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3086: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3087: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3088: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3089: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3090: !DWST [15] (maybe <- 0x830009) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3091: !LD [2] (Int)
lduw [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3092: !CAS [2] (maybe <- 0x83000a) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3093: !MEMBAR (Int)
membar #StoreLoad

P3094: !CAS [0] (maybe <- 0x83000b) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3095: !CAS [1] (maybe <- 0x83000c) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3096: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3097: !ST [11] (maybe <- 0x83000d) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3098: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3099: !LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3100: !ST [6] (maybe <- 0x83000e) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3101: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3102: !CASX [10] (maybe <- 0x83000f) (Int)
add %i2, 32, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3103: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3104: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3105: !LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3106: !ST [12] (maybe <- 0x830010) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3107: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3108: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3109: !ST [2] (maybe <- 0x830011) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3110: !CAS [3] (maybe <- 0x830012) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3111: !DWST [5] (maybe <- 0x830013) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3112: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3113: !ST [3] (maybe <- 0x830014) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3114: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3115: !ST [13] (maybe <- 0x830015) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3116: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3117: !DWST [13] (maybe <- 0x830016) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3118: !ST [15] (maybe <- 0x830017) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3119: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3120: !DWST [3] (maybe <- 0x830018) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3121: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3122: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f0
! 1 addresses covered

P3123: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3124: !DWST [7] (maybe <- 0x483fff80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P3125: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3126: !CASX [11] (maybe <- 0x830019) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3127: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P3128: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3129: !MEMBAR (Int)
membar #StoreLoad

P3130: !ST [8] (maybe <- 0x83001a) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3131: !DWST [6] (maybe <- 0x83001b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3132: !DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3133: !DWLD [6] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3134: !LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3135: !DWST [3] (maybe <- 0x83001d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3136: !MEMBAR (Int)
membar #StoreLoad

P3137: !ST [8] (maybe <- 0x83001e) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3138: !DWST [4] (maybe <- 0x83001f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3139: !DWST [7] (maybe <- 0x830020) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3140: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3141: !DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P3142: !ST [3] (maybe <- 0x830022) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3143: !ST [13] (maybe <- 0x830023) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3144: !CASX [6] (maybe <- 0x830024) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3145: !CAS [15] (maybe <- 0x830026) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3146: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3147: !MEMBAR (Int)
membar #StoreLoad

P3148: !DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P3149: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3150: !DWST [3] (maybe <- 0x830027) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3151: !MEMBAR (Int)
membar #StoreLoad

P3152: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3153: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3154: !LD [15] (Int)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3155: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3156: !DWST [1] (maybe <- 0x830028) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3157: !DWST [6] (maybe <- 0x83002a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3158: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3159: !DWLD [9] (Int)
ldx [%i1 + 512], %o1
! move %o1(upper) -> %o1(upper)

P3160: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3161: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P3162: !DWST [2] (maybe <- 0x83002c) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P3163: !LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3164: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3165: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3166: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3167: !CAS [9] (maybe <- 0x83002d) (Int)
add %i1, 512, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P3168: !LD [9] (Int)
lduw [%i1 + 512], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3169: !ST [6] (maybe <- 0x83002e) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3170: !ST [6] (maybe <- 0x83002f) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3171: !DWST [12] (maybe <- 0x830030) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3172: !SWAP [1] (maybe <- 0x830031) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3173: !DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3174: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3175: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3176: !DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P3177: !DWST [13] (maybe <- 0x830032) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3178: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3179: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3180: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P3181: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3182: !MEMBAR (Int)
membar #StoreLoad

P3183: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3184: !NOP (Int)
nop

P3185: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3186: !DWST [9] (maybe <- 0x830033) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3187: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3188: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3189: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3190: !CAS [2] (maybe <- 0x830034) (Int)
add %i0, 12, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P3191: !CAS [12] (maybe <- 0x830035) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3192: !DWST [12] (maybe <- 0x830036) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3193: !LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3194: !MEMBAR (Int)
membar #StoreLoad

P3195: !CASX [8] (maybe <- 0x830037) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3196: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3197: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3198: !DWST [8] (maybe <- 0x830038) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3199: !ST [12] (maybe <- 0x830039) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3200: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3201: !LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3202: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P3203: !LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3204: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3205: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3206: !CASX [15] (maybe <- 0x83003a) (Int)
add %i3, 192, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3207: !SWAP [12] (maybe <- 0x83003b) (Int)
mov %l4, %o2
swap  [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3208: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3209: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3210: !CAS [7] (maybe <- 0x83003c) (Int)
add %i1, 84, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P3211: !DWST [0] (maybe <- 0x83003d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3212: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3213: !CASX [14] (maybe <- 0x83003f) (Int)
add %i3, 128, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3214: !DWST [7] (maybe <- 0x830040) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3215: !NOP (Int)
nop

P3216: !DWST [13] (maybe <- 0x830042) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3217: !LD [10] (Int)
lduw [%i2 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3218: !ST [7] (maybe <- 0x830043) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3219: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3220: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3221: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P3222: !ST [4] (maybe <- 0x830044) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3223: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3224: !DWLD [10] (Int)
ldx [%i2 + 32], %o2
! move %o2(upper) -> %o2(upper)

P3225: !SWAP [3] (maybe <- 0x830045) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3226: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3227: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3228: !DWST [14] (maybe <- 0x48400000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P3229: !MEMBAR (Int)
membar #StoreLoad

P3230: !DWST [7] (maybe <- 0x830046) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3231: !LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3232: !DWLD [4] (FP)
! case fp 
ldd  [%i0 + 64], %f18
! 1 addresses covered
fmovs %f18, %f1

P3233: !ST [6] (maybe <- 0x830048) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3234: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3235: !DWST [15] (maybe <- 0x830049) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3236: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3237: !ST [7] (maybe <- 0x83004a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3238: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3239: !ST [15] (maybe <- 0x83004b) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3240: !LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3241: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3242: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3243: !CAS [15] (maybe <- 0x83004c) (Int)
add %i3, 192, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3244: !CASX [2] (maybe <- 0x83004d) (Int)
add %i0, 8, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %l4, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3245: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3246: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P3247: !DWST [9] (maybe <- 0x83004e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3248: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3249: !MEMBAR (Int)
membar #StoreLoad

P3250: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3251: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P3252: !CAS [6] (maybe <- 0x83004f) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3253: !ST [4] (maybe <- 0x830050) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3254: !CAS [9] (maybe <- 0x830051) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3255: !SWAP [1] (maybe <- 0x830052) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3256: !CAS [14] (maybe <- 0x830053) (Int)
add %i3, 128, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3257: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3258: !DWLD [1] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3259: !LD [5] (Int)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3260: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3261: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3262: !ST [7] (maybe <- 0x830054) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3263: !CAS [5] (maybe <- 0x830055) (Int)
add %i1, 76, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3264: !LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3265: !SWAP [12] (maybe <- 0x830056) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3266: !MEMBAR (Int)
membar #StoreLoad

P3267: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3268: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3269: !CAS [9] (maybe <- 0x830057) (Int)
add %i1, 512, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P3270: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3271: !LD [8] (FP)
ld [%i1 + 256], %f2
! 1 addresses covered

P3272: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3273: !DWST [0] (maybe <- 0x830058) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3274: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3275: !LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3276: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3277: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3278: !DWST [4] (maybe <- 0x83005a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3279: !MEMBAR (Int)
membar #StoreLoad

P3280: !LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3281: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3282: !SWAP [11] (maybe <- 0x83005b) (Int)
mov %l4, %o1
swap  [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3283: !CASX [8] (maybe <- 0x83005c) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P3284: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3285: !ST [2] (maybe <- 0x83005d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3286: !DWST [4] (maybe <- 0x83005e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3287: !MEMBAR (Int)
membar #StoreLoad

P3288: !DWST [8] (maybe <- 0x83005f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3289: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3290: !DWST [1] (maybe <- 0x830060) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3291: !LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3292: !DWST [9] (maybe <- 0x830062) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3293: !ST [3] (maybe <- 0x830063) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3294: !SWAP [4] (maybe <- 0x830064) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3295: !CASX [0] (maybe <- 0x830065) (Int)
add %i0, 0, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3296: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3297: !ST [5] (maybe <- 0x830067) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3298: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3299: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3300: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3301: !CASX [13] (maybe <- 0x830068) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P3302: !LD [14] (FP)
ld [%i3 + 128], %f3
! 1 addresses covered

P3303: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3304: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3305: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3306: !DWST [1] (maybe <- 0x830069) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3307: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3308: !LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3309: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3310: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3311: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3312: !DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P3313: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3314: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3315: !LD [13] (FP)
ld [%i3 + 64], %f4
! 1 addresses covered

P3316: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3317: !LD [1] (Int)
lduw [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3318: !CASX [13] (maybe <- 0x83006b) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3319: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3320: !CASX [2] (maybe <- 0x83006c) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3321: !MEMBAR (Int)
membar #StoreLoad

P3322: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3323: !DWST [3] (maybe <- 0x83006d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3324: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P3325: !ST [2] (maybe <- 0x83006e) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3326: !ST [7] (maybe <- 0x83006f) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3327: !LD [2] (FP)
ld [%i0 + 12], %f5
! 1 addresses covered

P3328: !CASX [9] (maybe <- 0x830070) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3329: !DWST [5] (maybe <- 0x830071) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3330: !CAS [2] (maybe <- 0x830072) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3331: !CASX [4] (maybe <- 0x830073) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P3332: !SWAP [1] (maybe <- 0x830074) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P3333: !ST [9] (maybe <- 0x830075) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3334: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3335: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3336: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3337: !DWST [6] (maybe <- 0x48400040) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P3338: !DWLD [5] (Int)
ldx [%i1 + 72], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3339: !SWAP [7] (maybe <- 0x830076) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3340: !ST [0] (maybe <- 0x830077) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3341: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3342: !DWLD [15] (Int)
ldx [%i3 + 192], %o0
! move %o0(upper) -> %o0(upper)

P3343: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3344: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3345: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3346: !LD [8] (FP)
ld [%i1 + 256], %f6
! 1 addresses covered

P3347: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3348: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3349: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P3350: !ST [5] (maybe <- 0x830078) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3351: !ST [8] (maybe <- 0x830079) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3352: !DWST [15] (maybe <- 0x83007a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3353: !DWST [5] (maybe <- 0x83007b) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3354: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3355: !ST [7] (maybe <- 0x83007c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3356: !LD [9] (FP)
ld [%i1 + 512], %f7
! 1 addresses covered

P3357: !ST [9] (maybe <- 0x83007d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3358: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3359: !DWLD [3] (Int)
ldx [%i0 + 32], %o2
! move %o2(upper) -> %o2(upper)

P3360: !MEMBAR (Int)
membar #StoreLoad

P3361: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3362: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3363: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P3364: !LD [1] (Int)
lduw [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3365: !CASX [4] (maybe <- 0x83007e) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3366: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3367: !CASX [14] (maybe <- 0x83007f) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3368: !MEMBAR (Int)
membar #StoreLoad

P3369: !SWAP [5] (maybe <- 0x830080) (Int)
mov %l4, %l6
swap  [%i1 + 76], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3370: !CASX [6] (maybe <- 0x830081) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3371: !DWST [14] (maybe <- 0x830083) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P3372: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3373: !LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3374: !DWST [12] (maybe <- 0x830084) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3375: !ST [6] (maybe <- 0x830085) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3376: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3377: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3378: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P3379: !LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3380: !CAS [4] (maybe <- 0x830086) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3381: !DWLD [11] (FP)
! case fp 
ldd  [%i2 + 64], %f8
! 1 addresses covered

P3382: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f18
! 1 addresses covered
fmovs %f18, %f9

P3383: !CAS [7] (maybe <- 0x830087) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3384: !CAS [3] (maybe <- 0x830088) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3385: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3386: !ST [2] (maybe <- 0x830089) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3387: !CASX [9] (maybe <- 0x83008a) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3388: !MEMBAR (Int)
membar #StoreLoad

P3389: !DWST [7] (maybe <- 0x83008b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3390: !DWLD [13] (FP)
! case fp 
ldd  [%i3 + 64], %f10
! 1 addresses covered

P3391: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3392: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3393: !DWST [4] (maybe <- 0x83008d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3394: !ST [5] (maybe <- 0x83008e) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3395: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3396: !DWST [13] (maybe <- 0x83008f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3397: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3398: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3399: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3400: !DWST [5] (maybe <- 0x830090) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3401: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3402: !CASX [6] (maybe <- 0x830091) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3403: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P3404: !DWST [0] (maybe <- 0x484000c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P3405: !DWST [5] (maybe <- 0x830093) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3406: !MEMBAR (Int)
membar #StoreLoad

P3407: !CASX [10] (maybe <- 0x830094) (Int)
add %i2, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3408: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3409: !DWST [7] (maybe <- 0x830095) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3410: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3411: !ST [0] (maybe <- 0x830097) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3412: !DWST [12] (maybe <- 0x830098) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3413: !ST [3] (maybe <- 0x830099) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3414: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f18
! 1 addresses covered
fmovs %f18, %f11

P3415: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3416: !DWLD [15] (Int)
ldx [%i3 + 192], %o3
! move %o3(upper) -> %o3(upper)

P3417: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P3418: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3419: !ST [9] (maybe <- 0x83009a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3420: !CAS [3] (maybe <- 0x83009b) (Int)
add %i0, 32, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3421: !CAS [2] (maybe <- 0x83009c) (Int)
add %i0, 12, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3422: !LD [10] (Int)
lduw [%i2 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3423: !MEMBAR (Int)
membar #StoreLoad

P3424: !DWST [15] (maybe <- 0x83009d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3425: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3426: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3427: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P3428: !CASX [13] (maybe <- 0x83009e) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P3429: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3430: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3431: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3432: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3433: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3434: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3435: !DWST [11] (maybe <- 0x83009f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P3436: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3437: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3438: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3439: !ST [4] (maybe <- 0x8300a0) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3440: !DWLD [4] (Int)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)

P3441: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3442: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P3443: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3444: !DWST [8] (maybe <- 0x8300a1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3445: !MEMBAR (Int)
membar #StoreLoad

P3446: !MEMBAR (Int)
membar #StoreLoad

P3447: !ST [8] (maybe <- 0x8300a2) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3448: !MEMBAR (Int)
membar #StoreLoad

P3449: !CAS [9] (maybe <- 0x8300a3) (Int)
add %i1, 512, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3450: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3451: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3452: !MEMBAR (Int)
membar #StoreLoad

P3453: !ST [10] (maybe <- 0x8300a4) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3454: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3455: !LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3456: !ST [9] (maybe <- 0x8300a5) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3457: !DWST [5] (maybe <- 0x8300a6) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3458: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3459: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3460: !ST [2] (maybe <- 0x8300a7) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3461: !DWST [5] (maybe <- 0x8300a8) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3462: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3463: !DWLD [5] (FP)
! case fp 
ldd  [%i1 + 72], %f12
! 1 addresses covered
fmovs %f13, %f12

P3464: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3465: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3466: !LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3467: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3468: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3469: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3470: !DWST [6] (maybe <- 0x8300a9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3471: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3472: !DWST [14] (maybe <- 0x8300ab) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P3473: !DWLD [8] (Int)
ldx [%i1 + 256], %o4
! move %o4(upper) -> %o4(upper)

P3474: !ST [13] (maybe <- 0x8300ac) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3475: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3476: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3477: !ST [9] (maybe <- 0x8300ad) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3478: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3479: !LD [9] (FP)
ld [%i1 + 512], %f13
! 1 addresses covered

P3480: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3481: !MEMBAR (Int)
membar #StoreLoad

P3482: !ST [13] (maybe <- 0x8300ae) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3483: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3484: !MEMBAR (Int)
membar #StoreLoad

P3485: !DWLD [9] (Int)
ldx [%i1 + 512], %o1
! move %o1(upper) -> %o1(upper)

P3486: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1

P3487: !DWST [7] (maybe <- 0x8300af) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3488: !CASX [15] (maybe <- 0x8300b1) (Int)
add %i3, 192, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3489: !DWST [1] (maybe <- 0x8300b2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3490: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3491: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3492: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3493: !CASX [11] (maybe <- 0x8300b4) (Int)
add %i2, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3494: !LD [0] (FP)
ld [%i0 + 0], %f14
! 1 addresses covered

P3495: !DWST [0] (maybe <- 0x8300b5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3496: !DWST [10] (maybe <- 0x8300b7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3497: !SWAP [1] (maybe <- 0x8300b8) (Int)
mov %l4, %o2
swap  [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3498: !ST [4] (maybe <- 0x8300b9) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3499: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3500: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3501: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3502: !ST [7] (maybe <- 0x8300ba) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3503: !MEMBAR (Int)
membar #StoreLoad

P3504: !CASX [0] (maybe <- 0x8300bb) (Int)
add %i0, 0, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3505: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3506: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3507: !DWLD [0] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3508: !DWST [12] (maybe <- 0x8300bd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3509: !MEMBAR (Int)
membar #StoreLoad

P3510: !SWAP [7] (maybe <- 0x8300be) (Int)
mov %l4, %o1
swap  [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3511: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3512: !MEMBAR (Int)
membar #StoreLoad

P3513: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3514: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3515: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3516: !ST [4] (maybe <- 0x8300bf) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3517: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3518: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3519: !DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P3520: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3521: !ST [13] (maybe <- 0x8300c0) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3522: !MEMBAR (Int)
membar #StoreLoad

P3523: !MEMBAR (Int)
membar #StoreLoad

P3524: !NOP (Int)
nop

P3525: !DWST [6] (maybe <- 0x8300c1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3526: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3527: !ST [8] (maybe <- 0x8300c3) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3528: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3529: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3530: !MEMBAR (Int)
membar #StoreLoad

P3531: !CASX [13] (maybe <- 0x8300c4) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3532: !DWST [3] (maybe <- 0x8300c5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3533: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3534: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3535: !DWLD [12] (Int)
ldx [%i3 + 0], %o1
! move %o1(upper) -> %o1(upper)

P3536: !MEMBAR (Int)
membar #StoreLoad

P3537: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3538: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3539: !ST [4] (maybe <- 0x8300c6) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3540: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3541: !DWST [6] (maybe <- 0x8300c7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3542: !CAS [6] (maybe <- 0x8300c9) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3543: !CASX [2] (maybe <- 0x8300ca) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3544: !DWST [8] (maybe <- 0x8300cb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3545: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3546: !ST [13] (maybe <- 0x8300cc) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3547: !CASX [14] (maybe <- 0x8300cd) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3548: !DWST [5] (maybe <- 0x8300ce) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3549: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3550: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3551: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3552: !DWST [15] (maybe <- 0x8300cf) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3553: !SWAP [11] (maybe <- 0x8300d0) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3554: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3555: !DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3556: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3557: !DWST [13] (maybe <- 0x48400140) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P3558: !ST [13] (maybe <- 0x48400180) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P3559: !DWST [13] (maybe <- 0x8300d1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3560: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3561: !ST [6] (maybe <- 0x8300d2) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3562: !ST [7] (maybe <- 0x8300d3) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3563: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3564: !DWST [10] (maybe <- 0x8300d4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3565: !DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3566: !ST [9] (maybe <- 0x8300d5) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3567: !LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3568: !DWST [0] (maybe <- 0x8300d6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3569: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3570: !DWLD [10] (Int)
ldx [%i2 + 32], %o2
! move %o2(upper) -> %o2(upper)

P3571: !DWST [9] (maybe <- 0x8300d8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3572: !SWAP [14] (maybe <- 0x8300d9) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3573: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3574: !ST [3] (maybe <- 0x8300da) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3575: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3576: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3577: !MEMBAR (Int)
membar #StoreLoad

P3578: !DWST [6] (maybe <- 0x484001c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P3579: !LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3580: !ST [0] (maybe <- 0x8300db) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3581: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3582: !NOP (Int)
nop

P3583: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P3584: !ST [2] (maybe <- 0x8300dc) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3585: !LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3586: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3587: !ST [12] (maybe <- 0x8300dd) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3588: !DWST [15] (maybe <- 0x8300de) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3589: !CASX [11] (maybe <- 0x8300df) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3590: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3591: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3592: !DWST [6] (maybe <- 0x8300e0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3593: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3594: !DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P3595: !CASX [12] (maybe <- 0x8300e2) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3596: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P3597: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3598: !ST [13] (maybe <- 0x8300e3) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3599: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3600: !CASX [4] (maybe <- 0x8300e4) (Int)
add %i0, 64, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3601: !DWLD [4] (Int)
ldx [%i0 + 64], %o3
! move %o3(upper) -> %o3(upper)

P3602: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P3603: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3604: !CAS [12] (maybe <- 0x8300e5) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3605: !ST [15] (maybe <- 0x8300e6) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3606: !LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3607: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3608: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3609: !LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3610: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3611: !DWLD [7] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3612: !ST [7] (maybe <- 0x8300e7) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3613: !ST [8] (maybe <- 0x48400240) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P3614: !LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3615: !ST [10] (maybe <- 0x8300e8) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3616: !DWST [7] (maybe <- 0x8300e9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3617: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3618: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3619: !DWLD [11] (Int)
ldx [%i2 + 64], %o4
! move %o4(upper) -> %o4(upper)

P3620: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3621: !LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3622: !CAS [14] (maybe <- 0x8300eb) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3623: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3624: !CAS [8] (maybe <- 0x8300ec) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3625: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3626: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3627: !MEMBAR (Int)
membar #StoreLoad

P3628: !DWST [1] (maybe <- 0x8300ed) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3629: !CASX [3] (maybe <- 0x8300ef) (Int)
add %i0, 32, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3630: !ST [15] (maybe <- 0x8300f0) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3631: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3632: !ST [4] (maybe <- 0x8300f1) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3633: !MEMBAR (Int)
membar #StoreLoad

P3634: !DWST [10] (maybe <- 0x8300f2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3635: !ST [5] (maybe <- 0x8300f3) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3636: !ST [5] (maybe <- 0x8300f4) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3637: !DWLD [12] (Int)
ldx [%i3 + 0], %o0
! move %o0(upper) -> %o0(upper)

P3638: !CAS [9] (maybe <- 0x8300f5) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3639: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3640: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3641: !LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3642: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3643: !CASX [9] (maybe <- 0x8300f6) (Int)
add %i1, 512, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3644: !CASX [6] (maybe <- 0x8300f7) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3645: !ST [13] (maybe <- 0x8300f9) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3646: !MEMBAR (Int)
membar #StoreLoad

P3647: !ST [6] (maybe <- 0x8300fa) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3648: !NOP (Int)
nop

P3649: !DWLD [5] (Int)
ldx [%i1 + 72], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3650: !DWST [8] (maybe <- 0x8300fb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3651: !CAS [5] (maybe <- 0x8300fc) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3652: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3653: !DWST [1] (maybe <- 0x8300fd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3654: !CASX [13] (maybe <- 0x8300ff) (Int)
add %i3, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3655: !ST [11] (maybe <- 0x830100) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3656: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3657: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3658: !DWST [7] (maybe <- 0x48400280) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P3659: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3660: !ST [12] (maybe <- 0x830101) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3661: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3662: !CAS [4] (maybe <- 0x830102) (Int)
add %i0, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3663: !DWST [14] (maybe <- 0x830103) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P3664: !DWST [2] (maybe <- 0x830104) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P3665: !LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3666: !MEMBAR (Int)
membar #StoreLoad

P3667: !SWAP [2] (maybe <- 0x830105) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3668: !LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3669: !MEMBAR (Int)
membar #StoreLoad

P3670: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3671: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3672: !CAS [8] (maybe <- 0x830106) (Int)
add %i1, 256, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3673: !DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P3674: !MEMBAR (Int)
membar #StoreLoad

P3675: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3676: !DWST [10] (maybe <- 0x48400300) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P3677: !ST [12] (maybe <- 0x830107) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3678: !ST [9] (maybe <- 0x830108) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3679: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3680: !DWST [3] (maybe <- 0x830109) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3681: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P3682: !ST [3] (maybe <- 0x83010a) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3683: !MEMBAR (Int)
membar #StoreLoad

P3684: !DWLD [15] (Int)
ldx [%i3 + 192], %o1
! move %o1(upper) -> %o1(upper)

P3685: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P3686: !LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3687: !MEMBAR (Int)
membar #StoreLoad

P3688: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3689: !DWST [15] (maybe <- 0x83010b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3690: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3691: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P3692: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P3693: !CASX [15] (maybe <- 0x83010c) (Int)
add %i3, 192, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3694: !MEMBAR (Int)
membar #StoreLoad

P3695: !DWST [2] (maybe <- 0x83010d) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P3696: !CASX [10] (maybe <- 0x83010e) (Int)
add %i2, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3697: !ST [9] (maybe <- 0x83010f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3698: !SWAP [1] (maybe <- 0x830110) (Int)
mov %l4, %o3
swap  [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3699: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3700: !DWST [13] (maybe <- 0x830111) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3701: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3702: !DWST [2] (maybe <- 0x48400340) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P3703: !LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3704: !CAS [15] (maybe <- 0x830112) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3705: !CASX [10] (maybe <- 0x830113) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3706: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3707: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3708: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3709: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P3710: !SWAP [5] (maybe <- 0x830114) (Int)
mov %l4, %o4
swap  [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3711: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3712: !CASX [8] (maybe <- 0x830115) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3713: !MEMBAR (Int)
membar #StoreLoad

P3714: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3715: !LD [4] (FP)
ld [%i0 + 64], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P3716: !MEMBAR (Int)
membar #StoreLoad

P3717: !ST [7] (maybe <- 0x830116) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3718: !SWAP [7] (maybe <- 0x830117) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3719: !DWLD [7] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3720: !DWLD [14] (Int)
ldx [%i3 + 128], %o3
! move %o3(upper) -> %o3(upper)

P3721: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3722: !CAS [8] (maybe <- 0x830118) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3723: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3724: !ST [2] (maybe <- 0x830119) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3725: !DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P3726: !ST [7] (maybe <- 0x83011a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3727: !ST [8] (maybe <- 0x83011b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3728: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3729: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3730: !DWST [10] (maybe <- 0x83011c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3731: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3732: !DWST [15] (maybe <- 0x83011d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3733: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3734: !NOP (Int)
nop

P3735: !CAS [11] (maybe <- 0x83011e) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3736: !ST [7] (maybe <- 0x48400380) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P3737: !DWST [4] (maybe <- 0x83011f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3738: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P3739: !DWLD [13] (Int)
ldx [%i3 + 64], %o4
! move %o4(upper) -> %o4(upper)

P3740: !CAS [15] (maybe <- 0x830120) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3741: !SWAP [0] (maybe <- 0x830121) (Int)
mov %l4, %l6
swap  [%i0 + 0], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3742: !DWST [10] (maybe <- 0x830122) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3743: !DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P3744: !DWST [8] (maybe <- 0x830123) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3745: !DWST [1] (maybe <- 0x830124) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3746: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3747: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3748: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3749: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3750: !LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3751: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3752: !CAS [4] (maybe <- 0x830126) (Int)
add %i0, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3753: !MEMBAR (Int)
membar #StoreLoad

P3754: !MEMBAR (Int)
membar #StoreLoad

P3755: !ST [2] (maybe <- 0x830127) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3756: !CASX [8] (maybe <- 0x830128) (Int)
add %i1, 256, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3757: !CAS [4] (maybe <- 0x830129) (Int)
add %i0, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3758: !SWAP [6] (maybe <- 0x83012a) (Int)
mov %l4, %o3
swap  [%i1 + 80], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3759: !MEMBAR (Int)
membar #StoreLoad

P3760: !CAS [5] (maybe <- 0x83012b) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3761: !CASX [5] (maybe <- 0x83012c) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3762: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P3763: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3764: !LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3765: !DWST [9] (maybe <- 0x484003c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P3766: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3767: !NOP (Int)
nop

P3768: !LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3769: !CASX [15] (maybe <- 0x83012d) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3770: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P3771: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3772: !DWLD [14] (Int)
ldx [%i3 + 128], %o1
! move %o1(upper) -> %o1(upper)

P3773: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3774: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P3775: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3776: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3777: !DWST [10] (maybe <- 0x83012e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3778: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3779: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3780: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3781: !ST [2] (maybe <- 0x83012f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3782: !DWST [11] (maybe <- 0x830130) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P3783: !LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3784: !CAS [1] (maybe <- 0x830131) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3785: !SWAP [9] (maybe <- 0x830132) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3786: !MEMBAR (Int)
membar #StoreLoad

P3787: !DWLD [11] (Int)
ldx [%i2 + 64], %o0
! move %o0(upper) -> %o0(upper)

P3788: !ST [6] (maybe <- 0x48400400) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P3789: !ST [15] (maybe <- 0x830133) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3790: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P3791: !DWST [4] (maybe <- 0x830134) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3792: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3793: !DWST [11] (maybe <- 0x830135) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P3794: !DWLD [15] (Int)
ldx [%i3 + 192], %o1
! move %o1(upper) -> %o1(upper)

P3795: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3796: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P3797: !ST [12] (maybe <- 0x830136) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3798: !LD [14] (Int)
lduw [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3799: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3800: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3801: !ST [15] (maybe <- 0x48400440) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P3802: !SWAP [11] (maybe <- 0x830137) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3803: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3804: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3805: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3806: !CAS [3] (maybe <- 0x830138) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3807: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3808: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3809: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3810: !CAS [15] (maybe <- 0x830139) (Int)
add %i3, 192, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3811: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3812: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3813: !CAS [6] (maybe <- 0x83013a) (Int)
add %i1, 80, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3814: !CASX [9] (maybe <- 0x83013b) (Int)
add %i1, 512, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3815: !CASX [1] (maybe <- 0x83013c) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3816: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3817: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3818: !MEMBAR (Int)
membar #StoreLoad

P3819: !CAS [13] (maybe <- 0x83013e) (Int)
add %i3, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3820: !LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3821: !SWAP [13] (maybe <- 0x83013f) (Int)
mov %l4, %l6
swap  [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3822: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3823: !CASX [0] (maybe <- 0x830140) (Int)
add %i0, 0, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3824: !CAS [10] (maybe <- 0x830142) (Int)
add %i2, 32, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3825: !LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3826: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3827: !DWST [4] (maybe <- 0x830143) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3828: !CAS [11] (maybe <- 0x830144) (Int)
add %i2, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3829: !DWST [6] (maybe <- 0x830145) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3830: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3831: !ST [5] (maybe <- 0x48400480) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P3832: !ST [6] (maybe <- 0x830147) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3833: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3834: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3835: !DWST [5] (maybe <- 0x830148) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P3836: !SWAP [2] (maybe <- 0x830149) (Int)
mov %l4, %o3
swap  [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3837: !CAS [0] (maybe <- 0x83014a) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3838: !CAS [9] (maybe <- 0x83014b) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3839: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3840: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3841: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3842: !ST [13] (maybe <- 0x83014c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3843: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3844: !MEMBAR (Int)
membar #StoreLoad

P3845: !ST [1] (maybe <- 0x83014d) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3846: !MEMBAR (Int)
membar #StoreLoad

P3847: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3848: !ST [12] (maybe <- 0x83014e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3849: !ST [0] (maybe <- 0x83014f) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3850: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3851: !CAS [12] (maybe <- 0x830150) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3852: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3853: !CASX [11] (maybe <- 0x830151) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P3854: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3855: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f0
! 1 addresses covered

P3856: !DWST [7] (maybe <- 0x484004c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P3857: !ST [6] (maybe <- 0x830152) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3858: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P3859: !LD [11] (FP)
ld [%i2 + 64], %f1
! 1 addresses covered

P3860: !MEMBAR (Int)
membar #StoreLoad

P3861: !MEMBAR (Int)
membar #StoreLoad

P3862: !DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P3863: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3864: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3865: !CASX [4] (maybe <- 0x830153) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3866: !NOP (Int)
nop

P3867: !CASX [9] (maybe <- 0x830154) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P3868: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3869: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3870: !CAS [15] (maybe <- 0x830155) (Int)
add %i3, 192, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3871: !DWLD [1] (Int)
ldx [%i0 + 0], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3872: !ST [6] (maybe <- 0x830156) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3873: !MEMBAR (Int)
membar #StoreLoad

P3874: !DWST [14] (maybe <- 0x830157) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P3875: !DWST [10] (maybe <- 0x830158) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3876: !DWST [12] (maybe <- 0x830159) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3877: !CAS [5] (maybe <- 0x83015a) (Int)
add %i1, 76, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3878: !LD [6] (Int)
lduw [%i1 + 80], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3879: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P3880: !ST [7] (maybe <- 0x83015b) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3881: !ST [1] (maybe <- 0x83015c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3882: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P3883: !CASX [11] (maybe <- 0x83015d) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3884: !ST [7] (maybe <- 0x83015e) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3885: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3886: !MEMBAR (Int)
membar #StoreLoad

P3887: !ST [9] (maybe <- 0x83015f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3888: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3889: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3890: !MEMBAR (Int)
membar #StoreLoad

P3891: !DWST [11] (maybe <- 0x830160) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P3892: !LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3893: !MEMBAR (Int)
membar #StoreLoad

P3894: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3895: !CASX [1] (maybe <- 0x830161) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3896: !DWLD [1] (FP)
! case fp 
ldd  [%i0 + 0], %f2
! 2 addresses covered

P3897: !DWLD [1] (Int)
ldx [%i0 + 0], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3898: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3899: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3900: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f4
! 1 addresses covered

P3901: !DWLD [0] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3902: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3903: !CASX [4] (maybe <- 0x830163) (Int)
add %i0, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3904: !ST [2] (maybe <- 0x830164) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3905: !MEMBAR (Int)
membar #StoreLoad

P3906: !MEMBAR (Int)
membar #StoreLoad

P3907: !LD [15] (Int)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3908: !CAS [8] (maybe <- 0x830165) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3909: !CASX [9] (maybe <- 0x830166) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P3910: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3911: !NOP (Int)
nop

P3912: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3913: !MEMBAR (Int)
membar #StoreLoad

P3914: !ST [13] (maybe <- 0x830167) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3915: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3916: !CAS [8] (maybe <- 0x830168) (Int)
add %i1, 256, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P3917: !DWST [10] (maybe <- 0x48400540) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P3918: !MEMBAR (Int)
membar #StoreLoad

P3919: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3920: !DWST [11] (maybe <- 0x830169) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P3921: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3922: !DWST [14] (maybe <- 0x83016a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P3923: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3924: !CAS [5] (maybe <- 0x83016b) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3925: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3926: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1

P3927: !DWLD [5] (Int)
ldx [%i1 + 72], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3928: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3929: !ST [3] (maybe <- 0x83016c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3930: !CASX [6] (maybe <- 0x83016d) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3931: !CASX [1] (maybe <- 0x83016f) (Int)
add %i0, 0, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3932: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3933: !DWST [4] (maybe <- 0x830171) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3934: !CASX [9] (maybe <- 0x830172) (Int)
add %i1, 512, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3935: !CASX [0] (maybe <- 0x830173) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3936: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3937: !MEMBAR (Int)
membar #StoreLoad

P3938: !ST [13] (maybe <- 0x830175) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3939: !DWLD [7] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3940: !MEMBAR (Int)
membar #StoreLoad

P3941: !NOP (Int)
nop

P3942: !LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3943: !ST [6] (maybe <- 0x830176) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3944: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3945: !CAS [15] (maybe <- 0x830177) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3946: !CAS [9] (maybe <- 0x830178) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3947: !DWST [6] (maybe <- 0x830179) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3948: !DWST [7] (maybe <- 0x83017b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P3949: !CASX [1] (maybe <- 0x83017d) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3950: !ST [8] (maybe <- 0x83017f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3951: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P3952: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3953: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P3954: !CASX [8] (maybe <- 0x830180) (Int)
add %i1, 256, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3955: !CASX [13] (maybe <- 0x830181) (Int)
add %i3, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P3956: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3957: !CASX [0] (maybe <- 0x830182) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3958: !CASX [12] (maybe <- 0x830184) (Int)
add %i3, 0, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P3959: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3960: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3961: !MEMBAR (Int)
membar #StoreLoad

P3962: !LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3963: !CASX [10] (maybe <- 0x830185) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P3964: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3965: !ST [10] (maybe <- 0x830186) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3966: !CASX [14] (maybe <- 0x830187) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P3967: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3968: !DWST [0] (maybe <- 0x830188) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P3969: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3970: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3971: !CASX [9] (maybe <- 0x83018a) (Int)
add %i1, 512, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P3972: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3973: !MEMBAR (Int)
membar #StoreLoad

P3974: !MEMBAR (Int)
membar #StoreLoad

P3975: !LD [5] (Int)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3976: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3977: !MEMBAR (Int)
membar #StoreLoad

P3978: !MEMBAR (Int)
membar #StoreLoad

P3979: !DWST [12] (maybe <- 0x83018b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3980: !DWST [14] (maybe <- 0x83018c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P3981: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P3982: !DWLD [12] (Int)
ldx [%i3 + 0], %o0
! move %o0(upper) -> %o0(upper)

P3983: !CAS [8] (maybe <- 0x83018d) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3984: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3985: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3986: !MEMBAR (Int)
membar #StoreLoad

P3987: !CAS [1] (maybe <- 0x83018e) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3988: !DWST [10] (maybe <- 0x83018f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3989: !DWST [9] (maybe <- 0x830190) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3990: !DWST [10] (maybe <- 0x830191) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3991: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3992: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3993: !ST [14] (maybe <- 0x830192) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3994: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P3995: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3996: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3997: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P3998: !LD [0] (Int)
lduw [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3999: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4000: !ST [12] (maybe <- 0x830193) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4001: !CASX [8] (maybe <- 0x830194) (Int)
add %i1, 256, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4002: !LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4003: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4004: !MEMBAR (Int)
membar #StoreLoad

P4005: !DWST [5] (maybe <- 0x48400580) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P4006: !DWST [10] (maybe <- 0x484005c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P4007: !DWLD [1] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4008: !DWST [8] (maybe <- 0x830195) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4009: !SWAP [9] (maybe <- 0x830196) (Int)
mov %l4, %o4
swap  [%i1 + 512], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4010: !ST [5] (maybe <- 0x830197) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4011: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4012: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4013: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4014: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4015: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4016: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4017: !CAS [6] (maybe <- 0x830198) (Int)
add %i1, 80, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4018: !LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4019: !NOP (Int)
nop

P4020: !SWAP [3] (maybe <- 0x830199) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4021: !ST [0] (maybe <- 0x83019a) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4022: !DWST [7] (maybe <- 0x48400600) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4023: !CASX [13] (maybe <- 0x83019b) (Int)
add %i3, 64, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4024: !CASX [7] (maybe <- 0x83019c) (Int)
add %i1, 80, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P4025: !DWLD [1] (Int)
ldx [%i0 + 0], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4026: !CASX [0] (maybe <- 0x83019e) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4027: !LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4028: !CASX [11] (maybe <- 0x8301a0) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4029: !SWAP [8] (maybe <- 0x8301a1) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4030: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4031: !CAS [2] (maybe <- 0x8301a2) (Int)
add %i0, 12, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4032: !DWST [5] (maybe <- 0x8301a3) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4033: !LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4034: !CASX [2] (maybe <- 0x8301a4) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4035: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P4036: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4037: !LD [0] (FP)
ld [%i0 + 0], %f5
! 1 addresses covered

P4038: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4039: !ST [10] (maybe <- 0x8301a5) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4040: !DWST [2] (maybe <- 0x8301a6) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4041: !DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4042: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4043: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4044: !MEMBAR (Int)
membar #StoreLoad

P4045: !CASX [6] (maybe <- 0x8301a7) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4046: !ST [2] (maybe <- 0x8301a9) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4047: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4048: !DWST [12] (maybe <- 0x8301aa) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4049: !DWST [15] (maybe <- 0x8301ab) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4050: !ST [12] (maybe <- 0x8301ac) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4051: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4052: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4053: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4054: !NOP (Int)
nop

P4055: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4056: !ST [3] (maybe <- 0x8301ad) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4057: !ST [14] (maybe <- 0x8301ae) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4058: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4059: !DWLD [4] (Int)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)

P4060: !LD [0] (FP)
ld [%i0 + 0], %f6
! 1 addresses covered

P4061: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P4062: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4063: !CAS [15] (maybe <- 0x8301af) (Int)
add %i3, 192, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4064: !ST [4] (maybe <- 0x8301b0) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4065: !LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4066: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4067: !MEMBAR (Int)
membar #StoreLoad

P4068: !LD [0] (FP)
ld [%i0 + 0], %f7
! 1 addresses covered

P4069: !LD [1] (FP)
ld [%i0 + 4], %f8
! 1 addresses covered

P4070: !LD [2] (FP)
ld [%i0 + 12], %f9
! 1 addresses covered

P4071: !LD [3] (FP)
ld [%i0 + 32], %f10
! 1 addresses covered

P4072: !LD [4] (FP)
ld [%i0 + 64], %f11
! 1 addresses covered

P4073: !LD [5] (FP)
ld [%i1 + 76], %f12
! 1 addresses covered

P4074: !LD [6] (FP)
ld [%i1 + 80], %f13
! 1 addresses covered

P4075: !LD [7] (FP)
ld [%i1 + 84], %f14
! 1 addresses covered

P4076: !LD [8] (FP)
ld [%i1 + 256], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P4077: !LD [9] (FP)
ld [%i1 + 512], %f0
! 1 addresses covered

P4078: !LD [10] (FP)
ld [%i2 + 32], %f1
! 1 addresses covered

P4079: !LD [11] (FP)
ld [%i2 + 64], %f2
! 1 addresses covered

P4080: !LD [12] (FP)
ld [%i3 + 0], %f3
! 1 addresses covered

P4081: !LD [13] (FP)
ld [%i3 + 64], %f4
! 1 addresses covered

P4082: !LD [14] (FP)
ld [%i3 + 128], %f5
! 1 addresses covered

P4083: !LD [15] (FP)
ld [%i3 + 192], %f6
! 1 addresses covered
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30

restore
retl
nop
!-----------------



func4:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1280, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x04deade1), %l7
or    %l7, %lo(0x04deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x840001), %l4
or    %l4, %lo(0x840001), %l4

! Initialize FP counter 
sethi %hi(0x487fff40), %l7
or    %l7, %lo(0x487fff40), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P4084: !DWST [12] (maybe <- 0x840001) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4085: !LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4086: !CAS [2] (maybe <- 0x840002) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4087: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4088: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4089: !CAS [7] (maybe <- 0x840003) (Int)
add %i1, 84, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4090: !ST [12] (maybe <- 0x487fff40) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P4091: !ST [13] (maybe <- 0x487fff80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P4092: !CASX [3] (maybe <- 0x840004) (Int)
add %i0, 32, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4093: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4094: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4095: !NOP (Int)
nop

P4096: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4097: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4098: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P4099: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4100: !CASX [4] (maybe <- 0x840005) (Int)
add %i0, 64, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4101: !DWLD [6] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4102: !MEMBAR (Int)
membar #StoreLoad

P4103: !DWLD [7] (FP)
! case fp 
ldd  [%i1 + 80], %f0
! 2 addresses covered

P4104: !ST [6] (maybe <- 0x840006) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4105: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4106: !DWST [14] (maybe <- 0x840007) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P4107: !LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4108: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4109: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P4110: !DWST [12] (maybe <- 0x840008) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4111: !DWLD [13] (Int)
ldx [%i3 + 64], %o1
! move %o1(upper) -> %o1(upper)

P4112: !DWST [13] (maybe <- 0x840009) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4113: !CASX [3] (maybe <- 0x84000a) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4114: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4115: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4116: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4117: !ST [14] (maybe <- 0x84000b) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4118: !CASX [4] (maybe <- 0x84000c) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4119: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4120: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4121: !DWST [4] (maybe <- 0x84000d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4122: !DWST [2] (maybe <- 0x84000e) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4123: !DWST [5] (maybe <- 0x84000f) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4124: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4125: !DWST [0] (maybe <- 0x487fffc0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P4126: !CAS [1] (maybe <- 0x840010) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4127: !ST [3] (maybe <- 0x840011) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4128: !NOP (Int)
nop

P4129: !DWST [3] (maybe <- 0x840012) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4130: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4131: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4132: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4133: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4134: !LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4135: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4136: !LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4137: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4138: !LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4139: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4140: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4141: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4142: !CAS [13] (maybe <- 0x840013) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4143: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4144: !CAS [2] (maybe <- 0x840014) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4145: !CAS [2] (maybe <- 0x840015) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4146: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4147: !ST [12] (maybe <- 0x840016) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4148: !LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4149: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4150: !ST [13] (maybe <- 0x840017) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4151: !ST [3] (maybe <- 0x840018) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4152: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4153: !SWAP [2] (maybe <- 0x840019) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4154: !ST [1] (maybe <- 0x84001a) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4155: !CASX [7] (maybe <- 0x84001b) (Int)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4156: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4157: !SWAP [7] (maybe <- 0x84001d) (Int)
mov %l4, %o3
swap  [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4158: !NOP (Int)
nop

P4159: !DWST [13] (maybe <- 0x84001e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4160: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4161: !DWST [0] (maybe <- 0x84001f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4162: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4163: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4164: !ST [15] (maybe <- 0x840021) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4165: !ST [8] (maybe <- 0x840022) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4166: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4167: !SWAP [14] (maybe <- 0x840023) (Int)
mov %l4, %o4
swap  [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4168: !MEMBAR (Int)
membar #StoreLoad

P4169: !SWAP [14] (maybe <- 0x840024) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4170: !DWLD [15] (Int)
ldx [%i3 + 192], %o0
! move %o0(upper) -> %o0(upper)

P4171: !DWST [13] (maybe <- 0x48800020) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P4172: !DWST [5] (maybe <- 0x840025) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4173: !DWST [2] (maybe <- 0x48800040) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P4174: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4175: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P4176: !CASX [10] (maybe <- 0x840026) (Int)
add %i2, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4177: !ST [0] (maybe <- 0x840027) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4178: !DWLD [8] (Int)
ldx [%i1 + 256], %o3
! move %o3(upper) -> %o3(upper)

P4179: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4180: !MEMBAR (Int)
membar #StoreLoad

P4181: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P4182: !LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4183: !CAS [11] (maybe <- 0x840028) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4184: !ST [11] (maybe <- 0x840029) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4185: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4186: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4187: !ST [3] (maybe <- 0x84002a) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4188: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4189: !DWLD [13] (Int)
ldx [%i3 + 64], %o1
! move %o1(upper) -> %o1(upper)

P4190: !CASX [3] (maybe <- 0x84002b) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4191: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4192: !DWST [3] (maybe <- 0x48800060) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P4193: !DWST [7] (maybe <- 0x84002c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4194: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4195: !DWST [6] (maybe <- 0x48800080) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4196: !LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4197: !DWST [2] (maybe <- 0x84002e) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4198: !NOP (Int)
nop

P4199: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4200: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P4201: !DWST [7] (maybe <- 0x84002f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4202: !DWST [7] (maybe <- 0x840031) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4203: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0

P4204: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4205: !CAS [4] (maybe <- 0x840033) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4206: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4207: !ST [5] (maybe <- 0x840034) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4208: !LD [10] (Int)
lduw [%i2 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4209: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4210: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4211: !MEMBAR (Int)
membar #StoreLoad

P4212: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4213: !MEMBAR (Int)
membar #StoreLoad

P4214: !DWST [10] (maybe <- 0x840035) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4215: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4216: !ST [9] (maybe <- 0x840036) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4217: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4218: !ST [1] (maybe <- 0x840037) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4219: !DWLD [8] (Int)
ldx [%i1 + 256], %o4
! move %o4(upper) -> %o4(upper)

P4220: !DWST [0] (maybe <- 0x840038) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4221: !ST [15] (maybe <- 0x84003a) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4222: !SWAP [3] (maybe <- 0x84003b) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4223: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4224: !DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P4225: !DWST [9] (maybe <- 0x84003c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4226: !CASX [4] (maybe <- 0x84003d) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4227: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4228: !ST [8] (maybe <- 0x84003e) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4229: !ST [1] (maybe <- 0x84003f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4230: !SWAP [8] (maybe <- 0x840040) (Int)
mov %l4, %o3
swap  [%i1 + 256], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4231: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P4232: !SWAP [6] (maybe <- 0x840041) (Int)
mov %l4, %o4
swap  [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4233: !DWST [9] (maybe <- 0x840042) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4234: !ST [15] (maybe <- 0x840043) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4235: !MEMBAR (Int)
membar #StoreLoad

P4236: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4237: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4238: !ST [12] (maybe <- 0x840044) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4239: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4240: !DWST [4] (maybe <- 0x840045) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4241: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4242: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4243: !LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4244: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4245: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4246: !SWAP [3] (maybe <- 0x840046) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4247: !ST [1] (maybe <- 0x840047) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4248: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4249: !DWST [4] (maybe <- 0x840048) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4250: !LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4251: !ST [9] (maybe <- 0x840049) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4252: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4253: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4254: !SWAP [2] (maybe <- 0x84004a) (Int)
mov %l4, %o2
swap  [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4255: !CASX [2] (maybe <- 0x84004b) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4256: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4257: !DWST [9] (maybe <- 0x84004c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4258: !DWST [6] (maybe <- 0x488000c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4259: !LD [7] (FP)
ld [%i1 + 84], %f2
! 1 addresses covered

P4260: !CAS [11] (maybe <- 0x84004d) (Int)
add %i2, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4261: !SWAP [9] (maybe <- 0x84004e) (Int)
mov %l4, %o1
swap  [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4262: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4263: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4264: !CAS [1] (maybe <- 0x84004f) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4265: !CASX [14] (maybe <- 0x840050) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4266: !CAS [11] (maybe <- 0x840051) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4267: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4268: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4269: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4270: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4271: !ST [2] (maybe <- 0x48800100) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P4272: !ST [6] (maybe <- 0x840052) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4273: !DWST [2] (maybe <- 0x840053) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4274: !ST [2] (maybe <- 0x840054) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4275: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4276: !SWAP [10] (maybe <- 0x840055) (Int)
mov %l4, %l6
swap  [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4277: !ST [1] (maybe <- 0x840056) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4278: !CAS [12] (maybe <- 0x840057) (Int)
add %i3, 0, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4279: !DWST [13] (maybe <- 0x840058) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4280: !SWAP [8] (maybe <- 0x840059) (Int)
mov %l4, %o4
swap  [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4281: !DWST [9] (maybe <- 0x84005a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4282: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4283: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4284: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4285: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4286: !NOP (Int)
nop

P4287: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4288: !LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4289: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4290: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4291: !CAS [4] (maybe <- 0x84005b) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4292: !DWST [6] (maybe <- 0x84005c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4293: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4294: !DWST [12] (maybe <- 0x84005e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4295: !NOP (Int)
nop

P4296: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4297: !SWAP [13] (maybe <- 0x84005f) (Int)
mov %l4, %l6
swap  [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4298: !CASX [15] (maybe <- 0x840060) (Int)
add %i3, 192, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4299: !DWST [5] (maybe <- 0x840061) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4300: !DWST [0] (maybe <- 0x840062) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4301: !DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P4302: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4303: !CAS [6] (maybe <- 0x840064) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4304: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4305: !ST [6] (maybe <- 0x48800120) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P4306: !ST [2] (maybe <- 0x840065) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4307: !DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4308: !ST [6] (maybe <- 0x840066) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4309: !DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4310: !DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P4311: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4312: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4313: !CASX [14] (maybe <- 0x840067) (Int)
add %i3, 128, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4314: !ST [1] (maybe <- 0x840068) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4315: !CAS [8] (maybe <- 0x840069) (Int)
add %i1, 256, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4316: !ST [8] (maybe <- 0x84006a) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4317: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4318: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4319: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4320: !CASX [7] (maybe <- 0x84006b) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4321: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4322: !LD [15] (Int)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4323: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4324: !CAS [3] (maybe <- 0x84006d) (Int)
add %i0, 32, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4325: !MEMBAR (Int)
membar #StoreLoad

P4326: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4327: !DWST [3] (maybe <- 0x84006e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4328: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4329: !DWST [2] (maybe <- 0x84006f) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4330: !DWST [4] (maybe <- 0x840070) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4331: !ST [13] (maybe <- 0x840071) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4332: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4333: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4334: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4335: !CAS [3] (maybe <- 0x840072) (Int)
add %i0, 32, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4336: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4337: !DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4338: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4339: !DWST [2] (maybe <- 0x840073) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4340: !LD [1] (Int)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4341: !DWST [2] (maybe <- 0x840074) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4342: !ST [10] (maybe <- 0x840075) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4343: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4344: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4345: !LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4346: !DWST [5] (maybe <- 0x840076) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4347: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4348: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4349: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f18
! 1 addresses covered
fmovs %f18, %f3

P4350: !CAS [3] (maybe <- 0x840077) (Int)
add %i0, 32, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4351: !LD [0] (Int)
lduw [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4352: !CAS [5] (maybe <- 0x840078) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4353: !CASX [6] (maybe <- 0x840079) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4354: !NOP (Int)
nop

P4355: !CAS [5] (maybe <- 0x84007b) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4356: !DWST [2] (maybe <- 0x84007c) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4357: !MEMBAR (Int)
membar #StoreLoad

P4358: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4359: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4360: !SWAP [11] (maybe <- 0x84007d) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4361: !DWST [6] (maybe <- 0x84007e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4362: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4363: !DWST [12] (maybe <- 0x840080) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4364: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4365: !DWLD [15] (Int)
ldx [%i3 + 192], %o4
! move %o4(upper) -> %o4(upper)

P4366: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4367: !SWAP [5] (maybe <- 0x840081) (Int)
mov %l4, %l6
swap  [%i1 + 76], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4368: !DWST [8] (maybe <- 0x840082) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4369: !DWST [12] (maybe <- 0x840083) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4370: !ST [14] (maybe <- 0x840084) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4371: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4372: !LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4373: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P4374: !CAS [3] (maybe <- 0x840085) (Int)
add %i0, 32, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4375: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4376: !MEMBAR (Int)
membar #StoreLoad

P4377: !DWST [5] (maybe <- 0x840086) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4378: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4379: !DWST [8] (maybe <- 0x840087) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4380: !DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P4381: !DWST [4] (maybe <- 0x840088) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4382: !CASX [14] (maybe <- 0x840089) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4383: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4384: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4385: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4386: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4387: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4388: !DWST [3] (maybe <- 0x48800140) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P4389: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4390: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4391: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4392: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4393: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4394: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4395: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4396: !DWST [6] (maybe <- 0x84008a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4397: !DWST [7] (maybe <- 0x84008c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4398: !CAS [5] (maybe <- 0x84008e) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4399: !MEMBAR (Int)
membar #StoreLoad

P4400: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4401: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4402: !CASX [3] (maybe <- 0x84008f) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4403: !DWST [4] (maybe <- 0x48800160) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P4404: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4405: !DWST [5] (maybe <- 0x840090) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4406: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4407: !DWST [0] (maybe <- 0x840091) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4408: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4409: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4410: !LD [0] (Int)
lduw [%i0 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4411: !SWAP [15] (maybe <- 0x840093) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4412: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4413: !DWST [14] (maybe <- 0x840094) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P4414: !LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4415: !CASX [5] (maybe <- 0x840095) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4416: !CASX [11] (maybe <- 0x840096) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4417: !SWAP [11] (maybe <- 0x840097) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4418: !DWST [15] (maybe <- 0x840098) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4419: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4420: !CAS [6] (maybe <- 0x840099) (Int)
add %i1, 80, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4421: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4422: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P4423: !DWST [3] (maybe <- 0x84009a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4424: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4425: !DWST [5] (maybe <- 0x84009b) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4426: !CASX [10] (maybe <- 0x84009c) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4427: !CAS [9] (maybe <- 0x84009d) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4428: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P4429: !CASX [7] (maybe <- 0x84009e) (Int)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4430: !DWST [8] (maybe <- 0x8400a0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4431: !SWAP [9] (maybe <- 0x8400a1) (Int)
mov %l4, %o3
swap  [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4432: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P4433: !ST [10] (maybe <- 0x8400a2) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4434: !NOP (Int)
nop

P4435: !CAS [15] (maybe <- 0x8400a3) (Int)
add %i3, 192, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4436: !MEMBAR (Int)
membar #StoreLoad

P4437: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4438: !CASX [12] (maybe <- 0x8400a4) (Int)
add %i3, 0, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4439: !CASX [12] (maybe <- 0x8400a5) (Int)
add %i3, 0, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4440: !DWLD [13] (Int)
ldx [%i3 + 64], %o4
! move %o4(upper) -> %o4(upper)

P4441: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4442: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4443: !CAS [2] (maybe <- 0x8400a6) (Int)
add %i0, 12, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4444: !ST [7] (maybe <- 0x8400a7) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4445: !SWAP [12] (maybe <- 0x8400a8) (Int)
mov %l4, %o1
swap  [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4446: !DWST [3] (maybe <- 0x8400a9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4447: !ST [9] (maybe <- 0x8400aa) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4448: !SWAP [13] (maybe <- 0x8400ab) (Int)
mov %l4, %l6
swap  [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4449: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4450: !LD [9] (FP)
ld [%i1 + 512], %f4
! 1 addresses covered

P4451: !DWLD [12] (Int)
ldx [%i3 + 0], %o2
! move %o2(upper) -> %o2(upper)

P4452: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4453: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4454: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4455: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P4456: !CAS [10] (maybe <- 0x8400ac) (Int)
add %i2, 32, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4457: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P4458: !ST [7] (maybe <- 0x8400ad) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4459: !ST [2] (maybe <- 0x8400ae) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4460: !ST [12] (maybe <- 0x8400af) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4461: !MEMBAR (Int)
membar #StoreLoad

P4462: !ST [7] (maybe <- 0x8400b0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4463: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4464: !DWST [2] (maybe <- 0x8400b1) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4465: !ST [8] (maybe <- 0x8400b2) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4466: !MEMBAR (Int)
membar #StoreLoad

P4467: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4468: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P4469: !MEMBAR (Int)
membar #StoreLoad

P4470: !DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4471: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4472: !MEMBAR (Int)
membar #StoreLoad

P4473: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4474: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P4475: !DWST [15] (maybe <- 0x8400b3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4476: !DWST [15] (maybe <- 0x8400b4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4477: !MEMBAR (Int)
membar #StoreLoad

P4478: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P4479: !ST [1] (maybe <- 0x48800180) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P4480: !MEMBAR (Int)
membar #StoreLoad

P4481: !LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4482: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4483: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4484: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4485: !MEMBAR (Int)
membar #StoreLoad

P4486: !DWLD [2] (FP)
! case fp 
ldd  [%i0 + 8], %f18
! 1 addresses covered
fmovs %f19, %f5

P4487: !ST [15] (maybe <- 0x8400b5) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4488: !CAS [12] (maybe <- 0x8400b6) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4489: !ST [10] (maybe <- 0x8400b7) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4490: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4491: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4492: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4493: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4494: !DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4495: !DWST [1] (maybe <- 0x8400b8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4496: !ST [0] (maybe <- 0x8400ba) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4497: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4498: !ST [7] (maybe <- 0x8400bb) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4499: !DWST [12] (maybe <- 0x8400bc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4500: !MEMBAR (Int)
membar #StoreLoad

P4501: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4502: !NOP (Int)
nop

P4503: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4504: !DWST [6] (maybe <- 0x8400bd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4505: !NOP (Int)
nop

P4506: !DWST [7] (maybe <- 0x8400bf) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4507: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4508: !DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P4509: !SWAP [11] (maybe <- 0x8400c1) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4510: !CASX [0] (maybe <- 0x8400c2) (Int)
add %i0, 0, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4511: !LD [15] (Int)
lduw [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4512: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4513: !CAS [2] (maybe <- 0x8400c4) (Int)
add %i0, 12, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4514: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4515: !SWAP [3] (maybe <- 0x8400c5) (Int)
mov %l4, %o4
swap  [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4516: !SWAP [2] (maybe <- 0x8400c6) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4517: !LD [0] (Int)
lduw [%i0 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4518: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f6
! 1 addresses covered

P4519: !ST [5] (maybe <- 0x488001a0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P4520: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4521: !DWLD [14] (Int)
ldx [%i3 + 128], %o1
! move %o1(upper) -> %o1(upper)

P4522: !DWST [13] (maybe <- 0x8400c7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4523: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P4524: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4525: !LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4526: !ST [6] (maybe <- 0x8400c8) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4527: !MEMBAR (Int)
membar #StoreLoad

P4528: !MEMBAR (Int)
membar #StoreLoad

P4529: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4530: !DWST [2] (maybe <- 0x8400c9) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4531: !ST [0] (maybe <- 0x8400ca) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4532: !DWST [6] (maybe <- 0x488001c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4533: !ST [14] (maybe <- 0x8400cb) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4534: !ST [15] (maybe <- 0x48800200) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P4535: !SWAP [15] (maybe <- 0x8400cc) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4536: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4537: !CAS [3] (maybe <- 0x8400cd) (Int)
add %i0, 32, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4538: !ST [8] (maybe <- 0x8400ce) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4539: !DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P4540: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4541: !ST [13] (maybe <- 0x8400cf) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4542: !NOP (Int)
nop

P4543: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4544: !CASX [10] (maybe <- 0x8400d0) (Int)
add %i2, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4545: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4546: !SWAP [7] (maybe <- 0x8400d1) (Int)
mov %l4, %o3
swap  [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4547: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4548: !ST [7] (maybe <- 0x8400d2) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4549: !MEMBAR (Int)
membar #StoreLoad

P4550: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4551: !ST [2] (maybe <- 0x48800220) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P4552: !DWST [13] (maybe <- 0x8400d3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4553: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4554: !ST [2] (maybe <- 0x8400d4) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4555: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4556: !ST [1] (maybe <- 0x48800240) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P4557: !DWST [7] (maybe <- 0x8400d5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4558: !CAS [2] (maybe <- 0x8400d7) (Int)
add %i0, 12, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4559: !MEMBAR (Int)
membar #StoreLoad

P4560: !SWAP [11] (maybe <- 0x8400d8) (Int)
mov %l4, %o1
swap  [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4561: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4562: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4563: !NOP (Int)
nop

P4564: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4565: !DWST [11] (maybe <- 0x8400d9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4566: !MEMBAR (Int)
membar #StoreLoad

P4567: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4568: !CASX [5] (maybe <- 0x8400da) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4569: !MEMBAR (Int)
membar #StoreLoad

P4570: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4571: !DWST [14] (maybe <- 0x8400db) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P4572: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4573: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4574: !DWST [12] (maybe <- 0x8400dc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4575: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4576: !DWST [5] (maybe <- 0x8400dd) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4577: !CASX [7] (maybe <- 0x8400de) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4578: !ST [14] (maybe <- 0x8400e0) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4579: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4580: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4581: !LD [7] (FP)
ld [%i1 + 84], %f7
! 1 addresses covered

P4582: !LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4583: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f8
! 1 addresses covered

P4584: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4585: !DWST [11] (maybe <- 0x8400e1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4586: !ST [7] (maybe <- 0x8400e2) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4587: !DWST [2] (maybe <- 0x8400e3) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4588: !CASX [9] (maybe <- 0x8400e4) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4589: !CAS [13] (maybe <- 0x8400e5) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4590: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4591: !DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P4592: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4593: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4594: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4595: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4596: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P4597: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P4598: !LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4599: !DWST [1] (maybe <- 0x8400e6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4600: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4601: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4602: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4603: !MEMBAR (Int)
membar #StoreLoad

P4604: !ST [6] (maybe <- 0x8400e8) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4605: !DWST [8] (maybe <- 0x8400e9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4606: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4607: !DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P4608: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4609: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4610: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4611: !SWAP [2] (maybe <- 0x8400ea) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4612: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4613: !LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4614: !ST [6] (maybe <- 0x8400eb) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4615: !DWST [4] (maybe <- 0x8400ec) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4616: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P4617: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4618: !ST [14] (maybe <- 0x8400ed) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4619: !DWST [3] (maybe <- 0x8400ee) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4620: !DWST [6] (maybe <- 0x48800260) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4621: !DWLD [15] (Int)
ldx [%i3 + 192], %o4
! move %o4(upper) -> %o4(upper)

P4622: !MEMBAR (Int)
membar #StoreLoad

P4623: !DWST [0] (maybe <- 0x8400ef) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4624: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4625: !DWST [11] (maybe <- 0x8400f1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4626: !DWST [2] (maybe <- 0x8400f2) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4627: !DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4628: !DWST [14] (maybe <- 0x8400f3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P4629: !DWLD [12] (FP)
! case fp 
ldd  [%i3 + 0], %f18
! 1 addresses covered
fmovs %f18, %f9

P4630: !DWST [15] (maybe <- 0x8400f4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4631: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P4632: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4633: !DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P4634: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P4635: !DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4636: !ST [11] (maybe <- 0x8400f5) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4637: !CAS [2] (maybe <- 0x8400f6) (Int)
add %i0, 12, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4638: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4639: !CASX [7] (maybe <- 0x8400f7) (Int)
add %i1, 80, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P4640: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4641: !ST [9] (maybe <- 0x8400f9) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4642: !CAS [8] (maybe <- 0x8400fa) (Int)
add %i1, 256, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4643: !DWLD [3] (Int)
ldx [%i0 + 32], %o2
! move %o2(upper) -> %o2(upper)

P4644: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4645: !DWST [10] (maybe <- 0x8400fb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4646: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P4647: !DWLD [11] (Int)
ldx [%i2 + 64], %o3
! move %o3(upper) -> %o3(upper)

P4648: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4649: !DWST [0] (maybe <- 0x8400fc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4650: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4651: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P4652: !ST [2] (maybe <- 0x8400fe) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4653: !DWLD [0] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4654: !ST [0] (maybe <- 0x8400ff) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4655: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4656: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4657: !DWST [6] (maybe <- 0x840100) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4658: !ST [15] (maybe <- 0x840102) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4659: !ST [10] (maybe <- 0x488002a0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P4660: !LD [3] (Int)
lduw [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4661: !ST [15] (maybe <- 0x840103) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4662: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4663: !ST [2] (maybe <- 0x840104) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4664: !ST [13] (maybe <- 0x840105) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4665: !DWST [8] (maybe <- 0x840106) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4666: !CASX [15] (maybe <- 0x840107) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4667: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4668: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4669: !CASX [11] (maybe <- 0x840108) (Int)
add %i2, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4670: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4671: !CASX [6] (maybe <- 0x840109) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4672: !LD [14] (Int)
lduw [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4673: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4674: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4675: !DWST [8] (maybe <- 0x84010b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4676: !CAS [8] (maybe <- 0x84010c) (Int)
add %i1, 256, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4677: !DWLD [3] (Int)
ldx [%i0 + 32], %o4
! move %o4(upper) -> %o4(upper)

P4678: !DWST [8] (maybe <- 0x84010d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4679: !CAS [1] (maybe <- 0x84010e) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4680: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4681: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4682: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4683: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4684: !DWLD [8] (Int)
ldx [%i1 + 256], %o2
! move %o2(upper) -> %o2(upper)

P4685: !ST [14] (maybe <- 0x84010f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4686: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P4687: !LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4688: !CAS [4] (maybe <- 0x840110) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4689: !DWST [8] (maybe <- 0x840111) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4690: !CAS [7] (maybe <- 0x840112) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4691: !NOP (Int)
nop

P4692: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4693: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4694: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4695: !CAS [9] (maybe <- 0x840113) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4696: !DWST [11] (maybe <- 0x840114) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4697: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P4698: !DWLD [14] (Int)
ldx [%i3 + 128], %o3
! move %o3(upper) -> %o3(upper)

P4699: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4700: !DWLD [4] (FP)
! case fp 
ldd  [%i0 + 64], %f10
! 1 addresses covered

P4701: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4702: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P4703: !DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4704: !CASX [10] (maybe <- 0x840115) (Int)
add %i2, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4705: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4706: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4707: !DWST [11] (maybe <- 0x840116) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4708: !LD [0] (FP)
ld [%i0 + 0], %f11
! 1 addresses covered

P4709: !DWLD [8] (FP)
! case fp 
ldd  [%i1 + 256], %f12
! 1 addresses covered

P4710: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4711: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4712: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4713: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4714: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4715: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4716: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4717: !DWLD [15] (Int)
ldx [%i3 + 192], %o3
! move %o3(upper) -> %o3(upper)

P4718: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P4719: !CAS [1] (maybe <- 0x840117) (Int)
add %i0, 4, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4720: !CAS [14] (maybe <- 0x840118) (Int)
add %i3, 128, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4721: !CAS [15] (maybe <- 0x840119) (Int)
add %i3, 192, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4722: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4723: !DWST [1] (maybe <- 0x84011a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4724: !CASX [0] (maybe <- 0x84011c) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4725: !DWLD [15] (FP)
! case fp 
ldd  [%i3 + 192], %f18
! 1 addresses covered
fmovs %f18, %f13

P4726: !MEMBAR (Int)
membar #StoreLoad

P4727: !CASX [14] (maybe <- 0x84011e) (Int)
add %i3, 128, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P4728: !DWST [13] (maybe <- 0x84011f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4729: !DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4730: !CAS [2] (maybe <- 0x840120) (Int)
add %i0, 12, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4731: !DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4732: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4733: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4734: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4735: !LD [10] (FP)
ld [%i2 + 32], %f14
! 1 addresses covered

P4736: !SWAP [12] (maybe <- 0x840121) (Int)
mov %l4, %o4
swap  [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4737: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4738: !MEMBAR (Int)
membar #StoreLoad

P4739: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4740: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4741: !CASX [1] (maybe <- 0x840122) (Int)
add %i0, 0, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4742: !LD [14] (Int)
lduw [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4743: !MEMBAR (Int)
membar #StoreLoad

P4744: !DWST [8] (maybe <- 0x840124) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4745: !DWST [15] (maybe <- 0x840125) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4746: !SWAP [0] (maybe <- 0x840126) (Int)
mov %l4, %l6
swap  [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4747: !LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4748: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4749: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4750: !CASX [0] (maybe <- 0x840127) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P4751: !LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4752: !DWST [11] (maybe <- 0x840129) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4753: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4754: !DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P4755: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4756: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P4757: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4758: !MEMBAR (Int)
membar #StoreLoad

P4759: !LD [11] (Int)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4760: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4761: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4762: !DWST [13] (maybe <- 0x84012a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4763: !ST [1] (maybe <- 0x84012b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4764: !MEMBAR (Int)
membar #StoreLoad

P4765: !CASX [4] (maybe <- 0x84012c) (Int)
add %i0, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4766: !LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4767: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4768: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4769: !MEMBAR (Int)
membar #StoreLoad

P4770: !MEMBAR (Int)
membar #StoreLoad

P4771: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4772: !ST [0] (maybe <- 0x84012d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4773: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4774: !DWST [8] (maybe <- 0x84012e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4775: !DWST [13] (maybe <- 0x488002c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P4776: !MEMBAR (Int)
membar #StoreLoad

P4777: !ST [13] (maybe <- 0x84012f) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4778: !DWST [5] (maybe <- 0x840130) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4779: !DWST [0] (maybe <- 0x840131) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4780: !DWST [9] (maybe <- 0x840133) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4781: !ST [0] (maybe <- 0x488002e0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P4782: !DWST [0] (maybe <- 0x840134) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4783: !CASX [4] (maybe <- 0x840136) (Int)
add %i0, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P4784: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4785: !LD [12] (Int)
lduw [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4786: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4787: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4788: !DWST [5] (maybe <- 0x840137) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4789: !MEMBAR (Int)
membar #StoreLoad

P4790: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4791: !DWST [4] (maybe <- 0x840138) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4792: !LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4793: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4794: !ST [2] (maybe <- 0x48800300) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P4795: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4796: !ST [10] (maybe <- 0x840139) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4797: !MEMBAR (Int)
membar #StoreLoad

P4798: !LD [12] (FP)
ld [%i3 + 0], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P4799: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4800: !ST [13] (maybe <- 0x84013a) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4801: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4802: !SWAP [2] (maybe <- 0x84013b) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4803: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4804: !LD [4] (Int)
lduw [%i0 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4805: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4806: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4807: !ST [3] (maybe <- 0x84013c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4808: !CAS [12] (maybe <- 0x84013d) (Int)
add %i3, 0, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4809: !CASX [3] (maybe <- 0x84013e) (Int)
add %i0, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4810: !DWST [15] (maybe <- 0x84013f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4811: !LD [4] (FP)
ld [%i0 + 64], %f0
! 1 addresses covered

P4812: !CAS [14] (maybe <- 0x840140) (Int)
add %i3, 128, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P4813: !LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4814: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4815: !DWST [1] (maybe <- 0x840141) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4816: !SWAP [4] (maybe <- 0x840143) (Int)
mov %l4, %o0
swap  [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4817: !CASX [15] (maybe <- 0x840144) (Int)
add %i3, 192, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4818: !ST [7] (maybe <- 0x48800320) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P4819: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P4820: !CASX [6] (maybe <- 0x840145) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4821: !ST [9] (maybe <- 0x840147) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4822: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4823: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f18
! 1 addresses covered
fmovs %f18, %f1

P4824: !DWST [6] (maybe <- 0x840148) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4825: !DWLD [12] (Int)
ldx [%i3 + 0], %o1
! move %o1(upper) -> %o1(upper)

P4826: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P4827: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4828: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4829: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4830: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4831: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4832: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4833: !DWST [10] (maybe <- 0x84014a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4834: !DWST [11] (maybe <- 0x84014b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4835: !DWST [5] (maybe <- 0x84014c) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4836: !DWST [11] (maybe <- 0x84014d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4837: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4838: !ST [12] (maybe <- 0x84014e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4839: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4840: !MEMBAR (Int)
membar #StoreLoad

P4841: !DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4842: !ST [10] (maybe <- 0x48800340) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P4843: !DWST [13] (maybe <- 0x84014f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4844: !MEMBAR (Int)
membar #StoreLoad

P4845: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4846: !CAS [9] (maybe <- 0x840150) (Int)
add %i1, 512, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4847: !SWAP [7] (maybe <- 0x840151) (Int)
mov %l4, %o0
swap  [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4848: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4849: !DWST [8] (maybe <- 0x840152) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4850: !CASX [6] (maybe <- 0x840153) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4851: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4852: !MEMBAR (Int)
membar #StoreLoad

P4853: !SWAP [5] (maybe <- 0x840155) (Int)
mov %l4, %o3
swap  [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4854: !ST [0] (maybe <- 0x840156) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4855: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4856: !LD [2] (FP)
ld [%i0 + 12], %f2
! 1 addresses covered

P4857: !DWLD [0] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4858: !LD [14] (FP)
ld [%i3 + 128], %f3
! 1 addresses covered

P4859: !DWST [5] (maybe <- 0x840157) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4860: !ST [14] (maybe <- 0x840158) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4861: !DWST [9] (maybe <- 0x840159) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4862: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4863: !DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P4864: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4865: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4866: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P4867: !ST [12] (maybe <- 0x48800360) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P4868: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4869: !ST [4] (maybe <- 0x84015a) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4870: !DWLD [11] (FP)
! case fp 
ldd  [%i2 + 64], %f4
! 1 addresses covered

P4871: !DWST [15] (maybe <- 0x84015b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4872: !LD [10] (FP)
ld [%i2 + 32], %f5
! 1 addresses covered

P4873: !ST [0] (maybe <- 0x84015c) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4874: !CASX [3] (maybe <- 0x84015d) (Int)
add %i0, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4875: !SWAP [12] (maybe <- 0x84015e) (Int)
mov %l4, %o3
swap  [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4876: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4877: !DWST [5] (maybe <- 0x84015f) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4878: !CASX [0] (maybe <- 0x840160) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P4879: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4880: !NOP (Int)
nop

P4881: !ST [3] (maybe <- 0x840162) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4882: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4883: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4884: !DWST [10] (maybe <- 0x840163) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4885: !ST [3] (maybe <- 0x840164) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4886: !ST [10] (maybe <- 0x840165) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4887: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4888: !LD [15] (Int)
lduw [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4889: !CAS [15] (maybe <- 0x840166) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4890: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P4891: !SWAP [2] (maybe <- 0x840167) (Int)
mov %l4, %o4
swap  [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4892: !CASX [5] (maybe <- 0x840168) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4893: !ST [11] (maybe <- 0x840169) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4894: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4895: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4896: !CASX [8] (maybe <- 0x84016a) (Int)
add %i1, 256, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4897: !DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P4898: !SWAP [10] (maybe <- 0x84016b) (Int)
mov %l4, %l6
swap  [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P4899: !DWST [5] (maybe <- 0x48800380) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P4900: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P4901: !DWST [1] (maybe <- 0x84016c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4902: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4903: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4904: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4905: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P4906: !LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4907: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P4908: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4909: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4910: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4911: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4912: !DWST [14] (maybe <- 0x84016e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P4913: !LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4914: !ST [5] (maybe <- 0x84016f) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4915: !ST [6] (maybe <- 0x840170) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4916: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4917: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4918: !DWST [1] (maybe <- 0x840171) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4919: !CASX [13] (maybe <- 0x840173) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4920: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4921: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4922: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4923: !CASX [0] (maybe <- 0x840174) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4924: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4925: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4926: !SWAP [0] (maybe <- 0x840176) (Int)
mov %l4, %o2
swap  [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4927: !ST [5] (maybe <- 0x840177) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4928: !DWST [9] (maybe <- 0x840178) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4929: !CASX [3] (maybe <- 0x840179) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P4930: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4931: !LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4932: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4933: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P4934: !SWAP [3] (maybe <- 0x84017a) (Int)
mov %l4, %l6
swap  [%i0 + 32], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4935: !ST [8] (maybe <- 0x84017b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4936: !DWLD [15] (Int)
ldx [%i3 + 192], %o2
! move %o2(upper) -> %o2(upper)

P4937: !ST [14] (maybe <- 0x84017c) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4938: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P4939: !MEMBAR (Int)
membar #StoreLoad

P4940: !MEMBAR (Int)
membar #StoreLoad

P4941: !MEMBAR (Int)
membar #StoreLoad

P4942: !CASX [0] (maybe <- 0x84017d) (Int)
add %i0, 0, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4943: !DWST [6] (maybe <- 0x84017f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4944: !CAS [9] (maybe <- 0x840181) (Int)
add %i1, 512, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4945: !CAS [7] (maybe <- 0x840182) (Int)
add %i1, 84, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4946: !MEMBAR (Int)
membar #StoreLoad

P4947: !ST [7] (maybe <- 0x840183) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4948: !DWST [8] (maybe <- 0x488003a0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P4949: !MEMBAR (Int)
membar #StoreLoad

P4950: !MEMBAR (Int)
membar #StoreLoad

P4951: !DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4952: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4953: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4954: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4955: !DWLD [15] (Int)
ldx [%i3 + 192], %o4
! move %o4(upper) -> %o4(upper)

P4956: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f6
! 1 addresses covered

P4957: !NOP (Int)
nop

P4958: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4959: !DWST [10] (maybe <- 0x840184) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4960: !CAS [2] (maybe <- 0x840185) (Int)
add %i0, 12, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4961: !DWST [2] (maybe <- 0x840186) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P4962: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4963: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4964: !LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4965: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4966: !CAS [11] (maybe <- 0x840187) (Int)
add %i2, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4967: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4968: !LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4969: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P4970: !ST [11] (maybe <- 0x840188) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4971: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4972: !ST [7] (maybe <- 0x840189) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4973: !DWST [13] (maybe <- 0x84018a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4974: !DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P4975: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4976: !ST [2] (maybe <- 0x84018b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4977: !CAS [0] (maybe <- 0x84018c) (Int)
add %i0, 0, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4978: !DWST [1] (maybe <- 0x84018d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P4979: !CAS [0] (maybe <- 0x84018f) (Int)
add %i0, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4980: !ST [13] (maybe <- 0x840190) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4981: !CAS [15] (maybe <- 0x840191) (Int)
add %i3, 192, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4982: !DWST [5] (maybe <- 0x840192) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P4983: !SWAP [11] (maybe <- 0x840193) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4984: !ST [10] (maybe <- 0x840194) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4985: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3

P4986: !DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P4987: !MEMBAR (Int)
membar #StoreLoad

P4988: !CAS [13] (maybe <- 0x840195) (Int)
add %i3, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4989: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4990: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4991: !DWLD [8] (Int)
ldx [%i1 + 256], %o1
! move %o1(upper) -> %o1(upper)

P4992: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4993: !DWST [7] (maybe <- 0x840196) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P4994: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4995: !SWAP [15] (maybe <- 0x840198) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4996: !ST [6] (maybe <- 0x840199) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4997: !SWAP [5] (maybe <- 0x84019a) (Int)
mov %l4, %o2
swap  [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4998: !DWST [3] (maybe <- 0x84019b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4999: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5000: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5001: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5002: !LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5003: !DWST [10] (maybe <- 0x84019c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5004: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5005: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5006: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P5007: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5008: !MEMBAR (Int)
membar #StoreLoad

P5009: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5010: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5011: !ST [0] (maybe <- 0x84019d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P5012: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5013: !MEMBAR (Int)
membar #StoreLoad

P5014: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5015: !CASX [11] (maybe <- 0x84019e) (Int)
add %i2, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5016: !ST [12] (maybe <- 0x84019f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5017: !ST [3] (maybe <- 0x8401a0) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5018: !DWLD [5] (FP)
! case fp 
ldd  [%i1 + 72], %f18
! 1 addresses covered
fmovs %f19, %f7

P5019: !MEMBAR (Int)
membar #StoreLoad

P5020: !DWST [3] (maybe <- 0x8401a1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5021: !CAS [0] (maybe <- 0x8401a2) (Int)
add %i0, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5022: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5023: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5024: !ST [0] (maybe <- 0x8401a3) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P5025: !ST [9] (maybe <- 0x8401a4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5026: !DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P5027: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5028: !SWAP [10] (maybe <- 0x8401a5) (Int)
mov %l4, %l6
swap  [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P5029: !ST [14] (maybe <- 0x488003c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P5030: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5031: !ST [8] (maybe <- 0x8401a6) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5032: !DWST [3] (maybe <- 0x8401a7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5033: !ST [14] (maybe <- 0x8401a8) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P5034: !ST [10] (maybe <- 0x8401a9) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P5035: !DWLD [15] (Int)
ldx [%i3 + 192], %o3
! move %o3(upper) -> %o3(upper)

P5036: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P5037: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5038: !DWST [8] (maybe <- 0x488003e0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P5039: !ST [13] (maybe <- 0x8401aa) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5040: !LD [11] (Int)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5041: !CASX [0] (maybe <- 0x8401ab) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5042: !CASX [2] (maybe <- 0x8401ad) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5043: !CAS [6] (maybe <- 0x8401ae) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5044: !MEMBAR (Int)
membar #StoreLoad

P5045: !CAS [6] (maybe <- 0x8401af) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5046: !LD [13] (FP)
ld [%i3 + 64], %f8
! 1 addresses covered

P5047: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5048: !DWST [3] (maybe <- 0x8401b0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5049: !CASX [3] (maybe <- 0x8401b1) (Int)
add %i0, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5050: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5051: !DWST [8] (maybe <- 0x8401b2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5052: !DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P5053: !ST [15] (maybe <- 0x8401b3) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P5054: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5055: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5056: !CAS [1] (maybe <- 0x8401b4) (Int)
add %i0, 4, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5057: !CAS [0] (maybe <- 0x8401b5) (Int)
add %i0, 0, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5058: !CASX [1] (maybe <- 0x8401b6) (Int)
add %i0, 0, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5059: !LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5060: !CAS [7] (maybe <- 0x8401b8) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5061: !MEMBAR (Int)
membar #StoreLoad

P5062: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5063: !DWST [11] (maybe <- 0x8401b9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5064: !DWST [4] (maybe <- 0x8401ba) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5065: !CAS [9] (maybe <- 0x8401bb) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5066: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5067: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5068: !ST [2] (maybe <- 0x8401bc) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5069: !CASX [13] (maybe <- 0x8401bd) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5070: !CAS [15] (maybe <- 0x8401be) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5071: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5072: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P5073: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P5074: !ST [5] (maybe <- 0x8401bf) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5075: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5076: !LD [5] (Int)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5077: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5078: !MEMBAR (Int)
membar #StoreLoad

P5079: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5080: !ST [2] (maybe <- 0x8401c0) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5081: !ST [5] (maybe <- 0x8401c1) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5082: !DWST [9] (maybe <- 0x8401c2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5083: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5084: !MEMBAR (FP)
membar #StoreLoad

P5085: !LD [0] (FP)
ld [%i0 + 0], %f9
! 1 addresses covered

P5086: !LD [1] (FP)
ld [%i0 + 4], %f10
! 1 addresses covered

P5087: !LD [2] (FP)
ld [%i0 + 12], %f11
! 1 addresses covered

P5088: !LD [3] (FP)
ld [%i0 + 32], %f12
! 1 addresses covered

P5089: !LD [4] (FP)
ld [%i0 + 64], %f13
! 1 addresses covered

P5090: !LD [5] (FP)
ld [%i1 + 76], %f14
! 1 addresses covered

P5091: !LD [6] (FP)
ld [%i1 + 80], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P5092: !LD [7] (FP)
ld [%i1 + 84], %f0
! 1 addresses covered

P5093: !LD [8] (FP)
ld [%i1 + 256], %f1
! 1 addresses covered

P5094: !LD [9] (FP)
ld [%i1 + 512], %f2
! 1 addresses covered

P5095: !LD [10] (FP)
ld [%i2 + 32], %f3
! 1 addresses covered

P5096: !LD [11] (FP)
ld [%i2 + 64], %f4
! 1 addresses covered

P5097: !LD [12] (FP)
ld [%i3 + 0], %f5
! 1 addresses covered

P5098: !LD [13] (FP)
ld [%i3 + 64], %f6
! 1 addresses covered

P5099: !LD [14] (FP)
ld [%i3 + 128], %f7
! 1 addresses covered

P5100: !LD [15] (FP)
ld [%i3 + 192], %f8
! 1 addresses covered
!---- flushing int results buffer----
mov %o0, %o5
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30

restore
retl
nop
!-----------------



func5:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1344, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x05deade1), %l7
or    %l7, %lo(0x05deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x850001), %l4
or    %l4, %lo(0x850001), %l4

! Initialize FP counter 
sethi %hi(0x489fff80), %l7
or    %l7, %lo(0x489fff80), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P5101: !LD [5] (Int) (Loop entry) (Loop exit)
sethi %hi(0x1), %l2
or %l2, %lo(0x1),  %l2
loop_entry_5_0:
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5102: !DWST [13] (maybe <- 0x850001) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5103: !MEMBAR (Int)
membar #StoreLoad

P5104: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5105: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5106: !DWST [12] (maybe <- 0x850002) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5107: !CASX [9] (maybe <- 0x850003) (Int)
add %i1, 512, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5108: !MEMBAR (Int)
membar #StoreLoad

P5109: !DWLD [2] (Int)
ldx [%i0 + 8], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5110: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5111: !MEMBAR (Int)
membar #StoreLoad

P5112: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P5113: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5114: !DWST [8] (maybe <- 0x850004) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5115: !SWAP [13] (maybe <- 0x850005) (Int)
mov %l4, %o4
swap  [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5116: !CASX [1] (maybe <- 0x850006) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5117: !SWAP [12] (maybe <- 0x850008) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5118: !DWST [10] (maybe <- 0x850009) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5119: !ST [11] (maybe <- 0x85000a) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P5120: !DWST [6] (maybe <- 0x85000b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5121: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P5122: !DWST [14] (maybe <- 0x85000d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5123: !DWST [11] (maybe <- 0x85000e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5124: !MEMBAR (Int)
membar #StoreLoad

P5125: !DWLD [2] (Int)
ldx [%i0 + 8], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5126: !DWST [13] (maybe <- 0x85000f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5127: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5128: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5129: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P5130: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5131: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5132: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5133: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5134: !DWLD [3] (FP)
! case fp 
ldd  [%i0 + 32], %f0
! 1 addresses covered

P5135: !CASX [13] (maybe <- 0x850010) (Int)
add %i3, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5136: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P5137: !DWST [13] (maybe <- 0x850011) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5138: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5139: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P5140: !ST [14] (maybe <- 0x489fff80) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P5141: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5142: !DWLD [5] (FP)
! case fp 
ldd  [%i1 + 72], %f18
! 1 addresses covered
fmovs %f19, %f1

P5143: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5144: !ST [1] (maybe <- 0x850012) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5145: !CAS [1] (maybe <- 0x850013) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5146: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5147: !ST [3] (maybe <- 0x850014) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5148: !DWST [2] (maybe <- 0x850015) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P5149: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P5150: !NOP (Int)
nop

P5151: !DWST [14] (maybe <- 0x850016) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5152: !CAS [11] (maybe <- 0x850017) (Int)
add %i2, 64, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5153: !LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5154: !ST [3] (maybe <- 0x850018) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5155: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5156: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5157: !ST [5] (maybe <- 0x850019) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5158: !DWLD [2] (Int)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5159: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5160: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5161: !MEMBAR (Int)
membar #StoreLoad

P5162: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5163: !MEMBAR (Int)
membar #StoreLoad

P5164: !CAS [10] (maybe <- 0x85001a) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5165: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5166: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5167: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5168: !ST [2] (maybe <- 0x85001b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5169: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5170: !CASX [12] (maybe <- 0x85001c) (Int)
add %i3, 0, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5171: !CASX [13] (maybe <- 0x85001d) (Int)
add %i3, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5172: !DWST [9] (maybe <- 0x85001e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5173: !MEMBAR (Int)
membar #StoreLoad

P5174: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5175: !LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5176: !MEMBAR (Int)
membar #StoreLoad

P5177: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P5178: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5179: !CASX [11] (maybe <- 0x85001f) (Int)
add %i2, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5180: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P5181: !NOP (Int)
nop

P5182: !ST [1] (maybe <- 0x850020) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5183: !DWST [0] (maybe <- 0x850021) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5184: !MEMBAR (Int)
membar #StoreLoad

P5185: !CASX [6] (maybe <- 0x850023) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5186: !MEMBAR (Int)
membar #StoreLoad

P5187: !ST [6] (maybe <- 0x850025) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P5188: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5189: !DWST [3] (maybe <- 0x850026) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5190: !DWLD [15] (Int)
ldx [%i3 + 192], %o2
! move %o2(upper) -> %o2(upper)

P5191: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P5192: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5193: !DWST [4] (maybe <- 0x850027) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5194: !DWLD [2] (Int)
ldx [%i0 + 8], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5195: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5196: !DWST [12] (maybe <- 0x850028) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5197: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5198: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5199: !LD [6] (FP)
ld [%i1 + 80], %f2
! 1 addresses covered

P5200: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5201: !ST [0] (maybe <- 0x850029) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P5202: !MEMBAR (Int)
membar #StoreLoad

P5203: !LD [4] (FP)
ld [%i0 + 64], %f3
! 1 addresses covered

P5204: !MEMBAR (Int)
membar #StoreLoad

P5205: !SWAP [3] (maybe <- 0x85002a) (Int)
mov %l4, %o4
swap  [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5206: !MEMBAR (Int)
membar #StoreLoad

P5207: !ST [2] (maybe <- 0x85002b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5208: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5209: !MEMBAR (Int)
membar #StoreLoad

P5210: !NOP (Int)
nop

P5211: !SWAP [0] (maybe <- 0x85002c) (Int)
mov %l4, %l6
swap  [%i0 + 0], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5212: !CAS [5] (maybe <- 0x85002d) (Int)
add %i1, 76, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5213: !DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P5214: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5215: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5216: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5217: !NOP (Int)
nop

P5218: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P5219: !DWLD [3] (Int)
ldx [%i0 + 32], %o2
! move %o2(upper) -> %o2(upper)

P5220: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P5221: !DWLD [1] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5222: !ST [5] (maybe <- 0x85002e) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5223: !ST [3] (maybe <- 0x85002f) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5224: !DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5225: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5226: !DWST [1] (maybe <- 0x489fffa0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P5227: !ST [7] (maybe <- 0x850030) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P5228: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5229: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5230: !SWAP [12] (maybe <- 0x850031) (Int)
mov %l4, %o0
swap  [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5231: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5232: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5233: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5234: !ST [9] (maybe <- 0x850032) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5235: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5236: !MEMBAR (Int)
membar #StoreLoad

P5237: !DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0

P5238: !CAS [4] (maybe <- 0x850033) (Int)
add %i0, 64, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5239: !DWST [9] (maybe <- 0x850034) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5240: !CASX [5] (maybe <- 0x850035) (Int)
add %i1, 72, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %l4, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5241: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5242: !DWST [7] (maybe <- 0x850036) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5243: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5244: !CASX [4] (maybe <- 0x850038) (Int)
add %i0, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5245: !LD [12] (Int)
lduw [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5246: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5247: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P5248: !MEMBAR (Int)
membar #StoreLoad

P5249: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P5250: !DWLD [10] (Int)
ldx [%i2 + 32], %o2
! move %o2(upper) -> %o2(upper)

P5251: !CASX [5] (maybe <- 0x850039) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5252: !DWST [11] (maybe <- 0x85003a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5253: !ST [2] (maybe <- 0x85003b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5254: !SWAP [12] (maybe <- 0x85003c) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5255: !DWST [13] (maybe <- 0x85003d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5256: !LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5257: !CAS [5] (maybe <- 0x85003e) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P5258: !DWST [3] (maybe <- 0x85003f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5259: !SWAP [12] (maybe <- 0x850040) (Int)
mov %l4, %l6
swap  [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5260: !CASX [1] (maybe <- 0x850041) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5261: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5262: !LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5263: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5264: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5265: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5266: !DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P5267: !CAS [6] (maybe <- 0x850043) (Int)
add %i1, 80, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P5268: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5269: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5270: !DWST [12] (maybe <- 0x850044) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5271: !ST [3] (maybe <- 0x850045) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5272: !ST [5] (maybe <- 0x850046) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5273: !CASX [4] (maybe <- 0x850047) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5274: !CASX [5] (maybe <- 0x850048) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5275: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5276: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5277: !ST [2] (maybe <- 0x850049) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5278: !LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5279: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5280: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P5281: !CASX [10] (maybe <- 0x85004a) (Int)
add %i2, 32, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5282: !CASX [10] (maybe <- 0x85004b) (Int)
add %i2, 32, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5283: !LD [1] (Int)
lduw [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5284: !DWST [13] (maybe <- 0x85004c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5285: !CASX [3] (maybe <- 0x85004d) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5286: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5287: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5288: !DWLD [8] (Int)
ldx [%i1 + 256], %o4
! move %o4(upper) -> %o4(upper)

P5289: !ST [12] (maybe <- 0x489fffe0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P5290: !SWAP [14] (maybe <- 0x85004e) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5291: !DWST [13] (maybe <- 0x85004f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5292: !DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P5293: !DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5294: !DWST [11] (maybe <- 0x850050) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5295: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5296: !ST [15] (maybe <- 0x48a00000) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P5297: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5298: !ST [12] (maybe <- 0x850051) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5299: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5300: !ST [2] (maybe <- 0x850052) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5301: !CAS [10] (maybe <- 0x850053) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5302: !MEMBAR (Int)
membar #StoreLoad

P5303: !MEMBAR (Int)
membar #StoreLoad

P5304: !CASX [6] (maybe <- 0x850054) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5305: !CASX [7] (maybe <- 0x850056) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5306: !ST [1] (maybe <- 0x850058) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5307: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5308: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5309: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P5310: !CASX [7] (maybe <- 0x850059) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5311: !DWST [15] (maybe <- 0x85005b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5312: !DWLD [3] (Int)
ldx [%i0 + 32], %o0
! move %o0(upper) -> %o0(upper)

P5313: !SWAP [1] (maybe <- 0x85005c) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5314: !DWST [2] (maybe <- 0x85005d) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P5315: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P5316: !CASX [9] (maybe <- 0x85005e) (Int)
add %i1, 512, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5317: !MEMBAR (Int)
membar #StoreLoad

P5318: !MEMBAR (Int)
membar #StoreLoad

P5319: !DWST [15] (maybe <- 0x85005f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5320: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5321: !CAS [9] (maybe <- 0x850060) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5322: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5323: !SWAP [13] (maybe <- 0x850061) (Int)
mov %l4, %o0
swap  [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5324: !CASX [4] (maybe <- 0x850062) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5325: !MEMBAR (Int)
membar #StoreLoad

P5326: !CASX [14] (maybe <- 0x850063) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5327: !ST [9] (maybe <- 0x850064) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5328: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5329: !ST [4] (maybe <- 0x850065) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5330: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5331: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P5332: !ST [13] (maybe <- 0x48a00020) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P5333: !DWST [7] (maybe <- 0x850066) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5334: !ST [5] (maybe <- 0x850068) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5335: !DWST [15] (maybe <- 0x850069) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5336: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5337: !DWLD [4] (FP)
! case fp 
ldd  [%i0 + 64], %f4
! 1 addresses covered

P5338: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5339: !DWST [10] (maybe <- 0x48a00040) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P5340: !SWAP [5] (maybe <- 0x85006a) (Int)
mov %l4, %o0
swap  [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5341: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5342: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5343: !DWST [4] (maybe <- 0x85006b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5344: !MEMBAR (Int)
membar #StoreLoad

P5345: !ST [12] (maybe <- 0x85006c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5346: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5347: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5348: !ST [2] (maybe <- 0x48a00060) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P5349: !DWST [7] (maybe <- 0x85006d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5350: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5351: !DWST [7] (maybe <- 0x85006f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5352: !CAS [6] (maybe <- 0x850071) (Int)
add %i1, 80, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5353: !ST [15] (maybe <- 0x48a00080) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P5354: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5355: !SWAP [11] (maybe <- 0x850072) (Int)
mov %l4, %o2
swap  [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5356: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5357: !ST [9] (maybe <- 0x850073) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5358: !CASX [14] (maybe <- 0x850074) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5359: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5360: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5361: !DWST [5] (maybe <- 0x48a000a0) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P5362: !DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5363: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5364: !ST [7] (maybe <- 0x850075) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P5365: !MEMBAR (Int)
membar #StoreLoad

P5366: !DWST [10] (maybe <- 0x48a000c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P5367: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P5368: !DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P5369: !ST [2] (maybe <- 0x850076) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5370: !CAS [12] (maybe <- 0x850077) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5371: !CASX [0] (maybe <- 0x850078) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5372: !CASX [11] (maybe <- 0x85007a) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5373: !DWST [15] (maybe <- 0x85007b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5374: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5375: !CAS [13] (maybe <- 0x85007c) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5376: !SWAP [8] (maybe <- 0x85007d) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P5377: !DWST [8] (maybe <- 0x85007e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5378: !ST [15] (maybe <- 0x85007f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P5379: !ST [9] (maybe <- 0x850080) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5380: !CAS [8] (maybe <- 0x850081) (Int)
add %i1, 256, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5381: !CASX [13] (maybe <- 0x850082) (Int)
add %i3, 64, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5382: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5383: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P5384: !LD [3] (Int)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5385: !ST [10] (maybe <- 0x850083) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P5386: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5387: !ST [8] (maybe <- 0x850084) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5388: !MEMBAR (Int)
membar #StoreLoad

P5389: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5390: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5391: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5392: !MEMBAR (Int)
membar #StoreLoad

P5393: !DWST [15] (maybe <- 0x850085) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5394: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5395: !DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P5396: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5397: !LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5398: !CASX [6] (maybe <- 0x850086) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5399: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5400: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5401: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5402: !ST [3] (maybe <- 0x850088) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5403: !DWST [1] (maybe <- 0x850089) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5404: !CASX [10] (maybe <- 0x85008b) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5405: !DWST [15] (maybe <- 0x85008c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5406: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5407: !DWST [12] (maybe <- 0x85008d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5408: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5409: !CAS [1] (maybe <- 0x85008e) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5410: !CAS [3] (maybe <- 0x85008f) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5411: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5412: !ST [4] (maybe <- 0x850090) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5413: !MEMBAR (Int)
membar #StoreLoad

P5414: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5415: !DWST [12] (maybe <- 0x850091) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5416: !SWAP [7] (maybe <- 0x850092) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5417: !DWST [9] (maybe <- 0x850093) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5418: !CAS [15] (maybe <- 0x850094) (Int)
add %i3, 192, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5419: !MEMBAR (Int)
membar #StoreLoad

P5420: !DWLD [3] (Int)
ldx [%i0 + 32], %o2
! move %o2(upper) -> %o2(upper)

P5421: !CASX [4] (maybe <- 0x850095) (Int)
add %i0, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5422: !DWLD [5] (FP)
! case fp 
ldd  [%i1 + 72], %f18
! 1 addresses covered
fmovs %f19, %f5

P5423: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5424: !CASX [1] (maybe <- 0x850096) (Int)
add %i0, 0, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5425: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5426: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5427: !DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P5428: !SWAP [6] (maybe <- 0x850098) (Int)
mov %l4, %o3
swap  [%i1 + 80], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5429: !DWST [14] (maybe <- 0x850099) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5430: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5431: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5432: !CAS [13] (maybe <- 0x85009a) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5433: !ST [0] (maybe <- 0x85009b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P5434: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P5435: !CAS [15] (maybe <- 0x85009c) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5436: !SWAP [7] (maybe <- 0x85009d) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5437: !LD [1] (Int)
lduw [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5438: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5439: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P5440: !LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5441: !CAS [13] (maybe <- 0x85009e) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5442: !DWST [14] (maybe <- 0x85009f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5443: !CAS [12] (maybe <- 0x8500a0) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5444: !NOP (Int)
nop

P5445: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5446: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5447: !DWST [1] (maybe <- 0x8500a1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5448: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P5449: !LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5450: !CASX [12] (maybe <- 0x8500a3) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5451: !DWST [12] (maybe <- 0x8500a4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5452: !CASX [3] (maybe <- 0x8500a5) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5453: !CAS [8] (maybe <- 0x8500a6) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5454: !CASX [6] (maybe <- 0x8500a7) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5455: !MEMBAR (Int)
membar #StoreLoad

P5456: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5457: !ST [12] (maybe <- 0x8500a9) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5458: !DWST [8] (maybe <- 0x8500aa) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5459: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5460: !MEMBAR (Int)
membar #StoreLoad

P5461: !CAS [1] (maybe <- 0x8500ab) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5462: !SWAP [4] (maybe <- 0x8500ac) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5463: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5464: !DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5465: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5466: !DWST [4] (maybe <- 0x8500ad) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5467: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5468: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5469: !DWST [10] (maybe <- 0x8500ae) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5470: !DWLD [13] (Int)
ldx [%i3 + 64], %o0
! move %o0(upper) -> %o0(upper)

P5471: !ST [5] (maybe <- 0x8500af) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5472: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5473: !MEMBAR (Int)
membar #StoreLoad

P5474: !ST [1] (maybe <- 0x8500b0) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5475: !CAS [14] (maybe <- 0x8500b1) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P5476: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P5477: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5478: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5479: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5480: !DWLD [2] (FP)
! case fp 
ldd  [%i0 + 8], %f6
! 1 addresses covered
fmovs %f7, %f6

P5481: !DWST [15] (maybe <- 0x48a000e0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P5482: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5483: !ST [15] (maybe <- 0x8500b2) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P5484: !DWST [10] (maybe <- 0x8500b3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5485: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5486: !DWLD [7] (FP)
! case fp 
ldd  [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f7
fmovs %f19, %f8

P5487: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5488: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5489: !MEMBAR (Int)
membar #StoreLoad

P5490: !ST [4] (maybe <- 0x8500b4) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5491: !CAS [8] (maybe <- 0x8500b5) (Int)
add %i1, 256, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5492: !ST [3] (maybe <- 0x8500b6) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5493: !DWLD [9] (Int)
ldx [%i1 + 512], %o4
! move %o4(upper) -> %o4(upper)

P5494: !CASX [5] (maybe <- 0x8500b7) (Int)
add %i1, 72, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5495: !MEMBAR (Int)
membar #StoreLoad

P5496: !DWST [11] (maybe <- 0x8500b8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5497: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5498: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5499: !DWST [8] (maybe <- 0x8500b9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5500: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P5501: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5502: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P5503: !NOP (Int)
nop

P5504: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P5505: !MEMBAR (Int)
membar #StoreLoad

P5506: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5507: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5508: !ST [6] (maybe <- 0x8500ba) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P5509: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5510: !NOP (Int)
nop

P5511: !SWAP [3] (maybe <- 0x8500bb) (Int)
mov %l4, %o2
swap  [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5512: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5513: !SWAP [10] (maybe <- 0x8500bc) (Int)
mov %l4, %l6
swap  [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P5514: !LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5515: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5516: !MEMBAR (Int)
membar #StoreLoad

P5517: !DWST [7] (maybe <- 0x8500bd) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5518: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5519: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5520: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5521: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5522: !ST [6] (maybe <- 0x8500bf) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P5523: !CASX [2] (maybe <- 0x8500c0) (Int)
add %i0, 8, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %l4, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5524: !SWAP [13] (maybe <- 0x8500c1) (Int)
mov %l4, %o2
swap  [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5525: !DWST [8] (maybe <- 0x8500c2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5526: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P5527: !MEMBAR (Int)
membar #StoreLoad

P5528: !SWAP [0] (maybe <- 0x8500c3) (Int)
mov %l4, %o3
swap  [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5529: !DWST [11] (maybe <- 0x8500c4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5530: !DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5531: !ST [6] (maybe <- 0x8500c5) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P5532: !DWLD [13] (Int)
ldx [%i3 + 64], %o4
! move %o4(upper) -> %o4(upper)

P5533: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P5534: !NOP (Int)
nop

P5535: !CAS [12] (maybe <- 0x8500c6) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5536: !LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5537: !LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5538: !SWAP [9] (maybe <- 0x8500c7) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5539: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5540: !LD [14] (Int)
lduw [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5541: !CAS [15] (maybe <- 0x8500c8) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5542: !SWAP [5] (maybe <- 0x8500c9) (Int)
mov %l4, %l6
swap  [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5543: !CAS [11] (maybe <- 0x8500ca) (Int)
add %i2, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5544: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5545: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P5546: !LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5547: !DWST [11] (maybe <- 0x8500cb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5548: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P5549: !MEMBAR (Int)
membar #StoreLoad

P5550: !SWAP [14] (maybe <- 0x8500cc) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5551: !ST [7] (maybe <- 0x8500cd) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P5552: !DWST [12] (maybe <- 0x8500ce) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5553: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5554: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5555: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5556: !LD [13] (FP)
ld [%i3 + 64], %f9
! 1 addresses covered

P5557: !DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P5558: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5559: !CAS [8] (maybe <- 0x8500cf) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5560: !CAS [14] (maybe <- 0x8500d0) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5561: !CAS [8] (maybe <- 0x8500d1) (Int)
add %i1, 256, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5562: !MEMBAR (Int)
membar #StoreLoad

P5563: !CAS [3] (maybe <- 0x8500d2) (Int)
add %i0, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5564: !ST [8] (maybe <- 0x8500d3) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5565: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5566: !SWAP [5] (maybe <- 0x8500d4) (Int)
mov %l4, %l6
swap  [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5567: !LD [8] (FP)
ld [%i1 + 256], %f10
! 1 addresses covered

P5568: !DWST [7] (maybe <- 0x8500d5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5569: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5570: !CASX [2] (maybe <- 0x8500d7) (Int)
add %i0, 8, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %l4, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5571: !MEMBAR (Int)
membar #StoreLoad

P5572: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5573: !ST [4] (maybe <- 0x8500d8) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5574: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5575: !CAS [9] (maybe <- 0x8500d9) (Int)
add %i1, 512, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5576: !LD [4] (Int)
lduw [%i0 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5577: !ST [13] (maybe <- 0x8500da) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5578: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5579: !ST [2] (maybe <- 0x48a00100) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P5580: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5581: !MEMBAR (Int)
membar #StoreLoad

P5582: !SWAP [8] (maybe <- 0x8500db) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5583: !MEMBAR (Int)
membar #StoreLoad

P5584: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5585: !CASX [6] (maybe <- 0x8500dc) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5586: !CASX [14] (maybe <- 0x8500de) (Int)
add %i3, 128, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5587: !ST [5] (maybe <- 0x8500df) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5588: !DWST [4] (maybe <- 0x8500e0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5589: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5590: !CASX [5] (maybe <- 0x8500e1) (Int)
add %i1, 72, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5591: !DWST [8] (maybe <- 0x8500e2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5592: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5593: !LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5594: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5595: !DWST [4] (maybe <- 0x8500e3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5596: !CASX [11] (maybe <- 0x8500e4) (Int)
add %i2, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5597: !DWST [0] (maybe <- 0x8500e5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5598: !CAS [14] (maybe <- 0x8500e7) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5599: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5600: !SWAP [1] (maybe <- 0x8500e8) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5601: !CASX [11] (maybe <- 0x8500e9) (Int)
add %i2, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5602: !ST [8] (maybe <- 0x8500ea) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5603: !SWAP [1] (maybe <- 0x8500eb) (Int)
mov %l4, %o2
swap  [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5604: !MEMBAR (Int)
membar #StoreLoad

P5605: !MEMBAR (Int)
membar #StoreLoad

P5606: !SWAP [4] (maybe <- 0x8500ec) (Int)
mov %l4, %l6
swap  [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P5607: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5608: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5609: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5610: !DWST [7] (maybe <- 0x8500ed) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5611: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5612: !LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5613: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5614: !LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5615: !LD [15] (FP)
ld [%i3 + 192], %f11
! 1 addresses covered

P5616: !LD [7] (FP)
ld [%i1 + 84], %f12
! 1 addresses covered

P5617: !LD [13] (FP)
ld [%i3 + 64], %f13
! 1 addresses covered

P5618: !LD [7] (FP)
ld [%i1 + 84], %f14
! 1 addresses covered

P5619: !LD [1] (FP)
ld [%i0 + 4], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P5620: !LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
loop_exit_5_0:
sub %l2, 1, %l2
cmp %l2, 0
bg loop_entry_5_0
nop

P5621: !CAS [5] (maybe <- 0x8500ef) (Int)
add %i1, 76, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5622: !CAS [5] (maybe <- 0x8500f0) (Int)
add %i1, 76, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5623: !MEMBAR (Int)
membar #StoreLoad

P5624: !LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5625: !CASX [3] (maybe <- 0x8500f1) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5626: !DWST [1] (maybe <- 0x8500f2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5627: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5628: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5629: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5630: !CASX [13] (maybe <- 0x8500f4) (Int)
add %i3, 64, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5631: !CASX [13] (maybe <- 0x8500f5) (Int)
add %i3, 64, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5632: !NOP (Int)
nop

P5633: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5634: !DWST [8] (maybe <- 0x8500f6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5635: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5636: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P5637: !DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5638: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5639: !SWAP [11] (maybe <- 0x8500f7) (Int)
mov %l4, %o0
swap  [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5640: !LD [13] (FP)
ld [%i3 + 64], %f0
! 1 addresses covered

P5641: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5642: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P5643: !CASX [2] (maybe <- 0x8500f8) (Int)
add %i0, 8, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %l4, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5644: !DWST [0] (maybe <- 0x8500f9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5645: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5646: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P5647: !MEMBAR (Int)
membar #StoreLoad

P5648: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5649: !ST [8] (maybe <- 0x8500fb) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5650: !DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P5651: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5652: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5653: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P5654: !NOP (Int)
nop

P5655: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P5656: !ST [12] (maybe <- 0x8500fc) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5657: !ST [15] (maybe <- 0x8500fd) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P5658: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5659: !MEMBAR (Int)
membar #StoreLoad

P5660: !LD [1] (Int)
lduw [%i0 + 4], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5661: !DWST [11] (maybe <- 0x8500fe) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5662: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5663: !ST [12] (maybe <- 0x8500ff) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5664: !SWAP [6] (maybe <- 0x850100) (Int)
mov %l4, %o0
swap  [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5665: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5666: !DWLD [15] (Int)
ldx [%i3 + 192], %o1
! move %o1(upper) -> %o1(upper)

P5667: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5668: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5669: !CAS [1] (maybe <- 0x850101) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5670: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5671: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5672: !CASX [9] (maybe <- 0x850102) (Int)
add %i1, 512, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5673: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5674: !LD [9] (FP)
ld [%i1 + 512], %f1
! 1 addresses covered

P5675: !LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5676: !DWST [15] (maybe <- 0x850103) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P5677: !ST [11] (maybe <- 0x850104) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P5678: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5679: !MEMBAR (Int)
membar #StoreLoad

P5680: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5681: !CAS [12] (maybe <- 0x850105) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P5682: !CASX [3] (maybe <- 0x850106) (Int)
add %i0, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5683: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5684: !DWLD [12] (Int)
ldx [%i3 + 0], %o4
! move %o4(upper) -> %o4(upper)

P5685: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5686: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5687: !DWLD [11] (Int)
ldx [%i2 + 64], %o0
! move %o0(upper) -> %o0(upper)

P5688: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5689: !CASX [0] (maybe <- 0x850107) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5690: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5691: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P5692: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5693: !CASX [2] (maybe <- 0x850109) (Int)
add %i0, 8, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %l4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5694: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5695: !ST [5] (maybe <- 0x85010a) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5696: !ST [8] (maybe <- 0x85010b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5697: !DWST [2] (maybe <- 0x85010c) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P5698: !DWST [13] (maybe <- 0x85010d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5699: !ST [1] (maybe <- 0x85010e) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5700: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5701: !MEMBAR (Int)
membar #StoreLoad

P5702: !DWST [14] (maybe <- 0x85010f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5703: !DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P5704: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5705: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P5706: !ST [4] (maybe <- 0x850110) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5707: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5708: !MEMBAR (Int)
membar #StoreLoad

P5709: !DWST [11] (maybe <- 0x850111) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5710: !DWST [11] (maybe <- 0x850112) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P5711: !SWAP [11] (maybe <- 0x850113) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P5712: !LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5713: !MEMBAR (Int)
membar #StoreLoad

P5714: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5715: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5716: !DWST [9] (maybe <- 0x850114) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5717: !CASX [6] (maybe <- 0x850115) (Int)
add %i1, 80, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5718: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5719: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P5720: !DWST [5] (maybe <- 0x850117) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P5721: !MEMBAR (Int)
membar #StoreLoad

P5722: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5723: !CASX [0] (maybe <- 0x850118) (Int)
add %i0, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l3
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5724: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5725: !ST [3] (maybe <- 0x48a00120) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P5726: !SWAP [5] (maybe <- 0x85011a) (Int)
mov %l4, %o4
swap  [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5727: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5728: !ST [12] (maybe <- 0x85011b) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5729: !CAS [5] (maybe <- 0x85011c) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5730: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5731: !DWST [14] (maybe <- 0x85011d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5732: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5733: !ST [12] (maybe <- 0x85011e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5734: !CAS [1] (maybe <- 0x85011f) (Int)
add %i0, 4, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5735: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5736: !LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5737: !CASX [14] (maybe <- 0x850120) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5738: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5739: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P5740: !DWLD [7] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5741: !DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P5742: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P5743: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5744: !ST [1] (maybe <- 0x850121) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5745: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5746: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5747: !ST [9] (maybe <- 0x850122) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5748: !CASX [8] (maybe <- 0x850123) (Int)
add %i1, 256, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5749: !ST [12] (maybe <- 0x850124) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5750: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5751: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5752: !ST [13] (maybe <- 0x850125) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5753: !SWAP [8] (maybe <- 0x850126) (Int)
mov %l4, %o0
swap  [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5754: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5755: !CASX [1] (maybe <- 0x850127) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5756: !ST [5] (maybe <- 0x850129) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P5757: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P5758: !CAS [15] (maybe <- 0x85012a) (Int)
add %i3, 192, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5759: !LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5760: !ST [4] (maybe <- 0x48a00140) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P5761: !DWST [8] (maybe <- 0x48a00160) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P5762: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P5763: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5764: !DWLD [15] (Int)
ldx [%i3 + 192], %o4
! move %o4(upper) -> %o4(upper)

P5765: !DWST [12] (maybe <- 0x85012b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5766: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5767: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5768: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5769: !CASX [15] (maybe <- 0x85012c) (Int)
add %i3, 192, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5770: !CASX [10] (maybe <- 0x85012d) (Int)
add %i2, 32, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
sllx %l4, 32, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P5771: !LD [9] (Int)
lduw [%i1 + 512], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5772: !MEMBAR (Int)
membar #StoreLoad

P5773: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5774: !CAS [13] (maybe <- 0x85012e) (Int)
add %i3, 64, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5775: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5776: !DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5777: !CAS [12] (maybe <- 0x85012f) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5778: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5779: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5780: !CASX [2] (maybe <- 0x850130) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5781: !SWAP [14] (maybe <- 0x850131) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5782: !CASX [7] (maybe <- 0x850132) (Int)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5783: !ST [0] (maybe <- 0x850134) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P5784: !CASX [13] (maybe <- 0x850135) (Int)
add %i3, 64, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5785: !LD [2] (Int)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5786: !LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5787: !DWST [4] (maybe <- 0x48a00180) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P5788: !MEMBAR (Int)
membar #StoreLoad

P5789: !ST [3] (maybe <- 0x850136) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5790: !ST [12] (maybe <- 0x850137) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P5791: !ST [11] (maybe <- 0x850138) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P5792: !DWST [1] (maybe <- 0x850139) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5793: !SWAP [1] (maybe <- 0x85013b) (Int)
mov %l4, %o1
swap  [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P5794: !SWAP [10] (maybe <- 0x85013c) (Int)
mov %l4, %l6
swap  [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5795: !DWST [12] (maybe <- 0x85013d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5796: !DWST [9] (maybe <- 0x85013e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5797: !ST [15] (maybe <- 0x85013f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P5798: !DWST [3] (maybe <- 0x850140) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5799: !DWST [7] (maybe <- 0x850141) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5800: !DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P5801: !ST [7] (maybe <- 0x48a001a0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P5802: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5803: !MEMBAR (Int)
membar #StoreLoad

P5804: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5805: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5806: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5807: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5808: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5809: !CASX [14] (maybe <- 0x850143) (Int)
add %i3, 128, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5810: !SWAP [11] (maybe <- 0x850144) (Int)
mov %l4, %l6
swap  [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5811: !ST [4] (maybe <- 0x850145) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5812: !DWLD [12] (Int)
ldx [%i3 + 0], %o2
! move %o2(upper) -> %o2(upper)

P5813: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5814: !CAS [7] (maybe <- 0x850146) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5815: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5816: !MEMBAR (Int)
membar #StoreLoad

P5817: !DWST [14] (maybe <- 0x850147) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P5818: !CASX [0] (maybe <- 0x850148) (Int)
add %i0, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %o4, %l3
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5819: !ST [6] (maybe <- 0x85014a) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P5820: !DWST [7] (maybe <- 0x85014b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5821: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5822: !LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5823: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5824: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5825: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5826: !DWST [10] (maybe <- 0x85014d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5827: !CASX [10] (maybe <- 0x85014e) (Int)
add %i2, 32, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5828: !DWST [5] (maybe <- 0x85014f) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P5829: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5830: !ST [7] (maybe <- 0x850150) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P5831: !MEMBAR (Int)
membar #StoreLoad

P5832: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5833: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5834: !ST [2] (maybe <- 0x850151) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P5835: !SWAP [14] (maybe <- 0x850152) (Int)
mov %l4, %o4
swap  [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5836: !ST [8] (maybe <- 0x48a001c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P5837: !MEMBAR (Int)
membar #StoreLoad

P5838: !CAS [13] (maybe <- 0x850153) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5839: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P5840: !DWST [6] (maybe <- 0x850154) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5841: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5842: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5843: !ST [1] (maybe <- 0x48a001e0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P5844: !LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5845: !ST [0] (maybe <- 0x850156) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P5846: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P5847: !LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5848: !DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P5849: !CASX [12] (maybe <- 0x850157) (Int)
add %i3, 0, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5850: !ST [8] (maybe <- 0x850158) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5851: !MEMBAR (Int)
membar #StoreLoad

P5852: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5853: !LD [15] (Int)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5854: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5855: !DWST [1] (maybe <- 0x850159) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5856: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5857: !ST [4] (maybe <- 0x85015b) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5858: !CASX [8] (maybe <- 0x85015c) (Int)
add %i1, 256, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5859: !SWAP [14] (maybe <- 0x85015d) (Int)
mov %l4, %o3
swap  [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5860: !DWST [1] (maybe <- 0x85015e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5861: !DWST [9] (maybe <- 0x850160) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P5862: !CAS [0] (maybe <- 0x850161) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5863: !LD [12] (FP)
ld [%i3 + 0], %f2
! 1 addresses covered

P5864: !CAS [14] (maybe <- 0x850162) (Int)
add %i3, 128, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5865: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5866: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5867: !CASX [15] (maybe <- 0x850163) (Int)
add %i3, 192, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5868: !LD [10] (Int)
lduw [%i2 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5869: !NOP (Int)
nop

P5870: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5871: !CASX [13] (maybe <- 0x850164) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5872: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P5873: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5874: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5875: !DWST [2] (maybe <- 0x850165) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P5876: !ST [14] (maybe <- 0x850166) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P5877: !CAS [1] (maybe <- 0x850167) (Int)
add %i0, 4, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P5878: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5879: !SWAP [11] (maybe <- 0x850168) (Int)
mov %l4, %o2
swap  [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P5880: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5881: !ST [13] (maybe <- 0x850169) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5882: !DWST [13] (maybe <- 0x85016a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P5883: !CASX [12] (maybe <- 0x85016b) (Int)
add %i3, 0, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P5884: !SWAP [7] (maybe <- 0x85016c) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5885: !PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P5886: !CAS [15] (maybe <- 0x85016d) (Int)
add %i3, 192, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5887: !REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5888: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5889: !CASX [11] (maybe <- 0x85016e) (Int)
add %i2, 64, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5890: !SWAP [15] (maybe <- 0x85016f) (Int)
mov %l4, %o3
swap  [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5891: !REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5892: !DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5893: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P5894: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5895: !DWST [3] (maybe <- 0x850170) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5896: !ST [9] (maybe <- 0x850171) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5897: !MEMBAR (Int)
membar #StoreLoad

P5898: !ST [13] (maybe <- 0x850172) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5899: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P5900: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5901: !LD [11] (FP)
ld [%i2 + 64], %f3
! 1 addresses covered

P5902: !DWST [1] (maybe <- 0x850173) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5903: !CAS [11] (maybe <- 0x850175) (Int)
add %i2, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5904: !DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P5905: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5906: !DWLD [11] (FP)
! case fp 
ldd  [%i2 + 64], %f4
! 1 addresses covered

P5907: !DWST [10] (maybe <- 0x850176) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5908: !DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P5909: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5910: !MEMBAR (Int)
membar #StoreLoad

P5911: !SWAP [7] (maybe <- 0x850177) (Int)
mov %l4, %l6
swap  [%i1 + 84], %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P5912: !LD [6] (Int)
lduw [%i1 + 80], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P5913: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P5914: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5915: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P5916: !MEMBAR (Int)
membar #StoreLoad

P5917: !ST [1] (maybe <- 0x850178) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P5918: !LD [1] (Int)
lduw [%i0 + 4], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5919: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5920: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P5921: !DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5922: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5923: !LD [3] (Int)
lduw [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5924: !ST [11] (maybe <- 0x850179) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P5925: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P5926: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P5927: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5928: !DWST [8] (maybe <- 0x85017a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5929: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P5930: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5931: !DWST [7] (maybe <- 0x85017b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P5932: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5933: !DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1

P5934: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5935: !LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P5936: !NOP (Int)
nop

P5937: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2

P5938: !DWLD [4] (FP)
! case fp 
ldd  [%i0 + 64], %f18
! 1 addresses covered
fmovs %f18, %f5

P5939: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5940: !CAS [11] (maybe <- 0x85017d) (Int)
add %i2, 64, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P5941: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5942: !LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5943: !ST [10] (maybe <- 0x85017e) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P5944: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P5945: !ST [8] (maybe <- 0x85017f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P5946: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P5947: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P5948: !ST [9] (maybe <- 0x850180) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5949: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5950: !MEMBAR (Int)
membar #StoreLoad

P5951: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P5952: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5953: !MEMBAR (Int)
membar #StoreLoad

P5954: !DWST [3] (maybe <- 0x850181) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P5955: !LD [7] (FP)
ld [%i1 + 84], %f6
! 1 addresses covered

P5956: !DWST [4] (maybe <- 0x850182) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P5957: !LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P5958: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P5959: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5960: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5961: !DWST [10] (maybe <- 0x850183) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P5962: !DWST [12] (maybe <- 0x850184) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P5963: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P5964: !DWST [5] (maybe <- 0x850185) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72 ] 
add   %l4, 1, %l4

P5965: !CAS [1] (maybe <- 0x850186) (Int)
add %i0, 4, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o3(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P5966: !ST [13] (maybe <- 0x850187) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5967: !ST [6] (maybe <- 0x850188) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P5968: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5969: !PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P5970: !DWST [8] (maybe <- 0x850189) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P5971: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5972: !LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5973: !CAS [3] (maybe <- 0x85018a) (Int)
add %i0, 32, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P5974: !DWST [1] (maybe <- 0x85018b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P5975: !CASX [10] (maybe <- 0x85018d) (Int)
add %i2, 32, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P5976: !ST [13] (maybe <- 0x85018e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5977: !SWAP [5] (maybe <- 0x85018f) (Int)
mov %l4, %o3
swap  [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P5978: !LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5979: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P5980: !LD [5] (Int)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P5981: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P5982: !LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P5983: !REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5984: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P5985: !SWAP [12] (maybe <- 0x850190) (Int)
mov %l4, %o1
swap  [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P5986: !CASX [0] (maybe <- 0x850191) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P5987: !ST [4] (maybe <- 0x850193) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5988: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P5989: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P5990: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P5991: !MEMBAR (Int)
membar #StoreLoad

P5992: !CAS [8] (maybe <- 0x850194) (Int)
add %i1, 256, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P5993: !ST [9] (maybe <- 0x850195) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P5994: !ST [3] (maybe <- 0x850196) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P5995: !MEMBAR (Int)
membar #StoreLoad

P5996: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P5997: !SWAP [13] (maybe <- 0x850197) (Int)
mov %l4, %o0
swap  [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P5998: !ST [4] (maybe <- 0x850198) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P5999: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6000: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P6001: !DWLD [12] (Int)
ldx [%i3 + 0], %o1
! move %o1(upper) -> %o1(upper)

P6002: !MEMBAR (Int)
membar #StoreLoad

P6003: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6004: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P6005: !CAS [7] (maybe <- 0x850199) (Int)
add %i1, 84, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P6006: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6007: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P6008: !ST [15] (maybe <- 0x85019a) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P6009: !CASX [2] (maybe <- 0x85019b) (Int)
add %i0, 8, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P6010: !CASX [13] (maybe <- 0x85019c) (Int)
add %i3, 64, %l7
ldx [%l7], %l6
mov %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
sllx %l4, 32, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P6011: !PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P6012: !LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P6013: !ST [2] (maybe <- 0x85019d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P6014: !SWAP [15] (maybe <- 0x85019e) (Int)
mov %l4, %o2
swap  [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P6015: !DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P6016: !ST [13] (maybe <- 0x85019f) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P6017: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P6018: !ST [6] (maybe <- 0x8501a0) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P6019: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P6020: !ST [12] (maybe <- 0x48a00200) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P6021: !DWST [13] (maybe <- 0x8501a1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P6022: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P6023: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6024: !CASX [15] (maybe <- 0x8501a2) (Int)
add %i3, 192, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P6025: !REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6026: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P6027: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P6028: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P6029: !CAS [0] (maybe <- 0x8501a3) (Int)
add %i0, 0, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P6030: !ST [12] (maybe <- 0x8501a4) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P6031: !DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P6032: !DWST [6] (maybe <- 0x8501a5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P6033: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P6034: !ST [7] (maybe <- 0x8501a7) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P6035: !PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P6036: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P6037: !ST [7] (maybe <- 0x8501a8) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P6038: !ST [12] (maybe <- 0x8501a9) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P6039: !PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P6040: !MEMBAR (Int)
membar #StoreLoad

P6041: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P6042: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P6043: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6044: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6045: !DWLD [8] (Int)
ldx [%i1 + 256], %o3
! move %o3(upper) -> %o3(upper)

P6046: !SWAP [8] (maybe <- 0x8501aa) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P6047: !CASX [10] (maybe <- 0x8501ab) (Int)
add %i2, 32, %l7
ldx [%l7], %o4
mov %o4, %l3
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
casx [%l7], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P6048: !ST [10] (maybe <- 0x8501ac) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P6049: !PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P6050: !LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P6051: !CASX [6] (maybe <- 0x8501ad) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P6052: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P6053: !DWLD [4] (FP)
! case fp 
ldd  [%i0 + 64], %f18
! 1 addresses covered
fmovs %f18, %f7

P6054: !MEMBAR (Int)
membar #StoreLoad

P6055: !DWST [14] (maybe <- 0x48a00220) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P6056: !REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6057: !DWST [13] (maybe <- 0x8501af) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P6058: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6059: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P6060: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P6061: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6062: !DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P6063: !CAS [11] (maybe <- 0x8501b0) (Int)
add %i2, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P6064: !DWST [6] (maybe <- 0x48a00240) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P6065: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6066: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P6067: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P6068: !DWST [12] (maybe <- 0x8501b1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P6069: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P6070: !ST [10] (maybe <- 0x8501b2) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P6071: !DWLD [15] (Int)
ldx [%i3 + 192], %o1
! move %o1(upper) -> %o1(upper)

P6072: !DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1

P6073: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6074: !MEMBAR (Int)
membar #StoreLoad

P6075: !DWLD [4] (Int)
ldx [%i0 + 64], %o2
! move %o2(upper) -> %o2(upper)

P6076: !LD [2] (FP)
ld [%i0 + 12], %f8
! 1 addresses covered

P6077: !DWST [11] (maybe <- 0x48a00280) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P6078: !MEMBAR (Int)
membar #StoreLoad

P6079: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6080: !LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2

P6081: !CASX [10] (maybe <- 0x8501b3) (Int)
add %i2, 32, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
sllx %l4, 32, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P6082: !LD [12] (Int)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P6083: !DWST [9] (maybe <- 0x8501b4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P6084: !CAS [4] (maybe <- 0x8501b5) (Int)
add %i0, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P6085: !CAS [12] (maybe <- 0x8501b6) (Int)
add %i3, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o1(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P6086: !CAS [0] (maybe <- 0x8501b7) (Int)
add %i0, 0, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P6087: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6088: !ST [2] (maybe <- 0x8501b8) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P6089: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P6090: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6091: !DWST [14] (maybe <- 0x8501b9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P6092: !SWAP [7] (maybe <- 0x8501ba) (Int)
mov %l4, %o4
swap  [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P6093: !CAS [10] (maybe <- 0x8501bb) (Int)
add %i2, 32, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P6094: !LD [10] (FP)
ld [%i2 + 32], %f9
! 1 addresses covered

P6095: !ST [2] (maybe <- 0x8501bc) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P6096: !NOP (Int)
nop

P6097: !LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P6098: !ST [15] (maybe <- 0x8501bd) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P6099: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6100: !DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P6101: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6102: !MEMBAR (Int)
membar #StoreLoad

P6103: !CASX [2] (maybe <- 0x8501be) (Int)
add %i0, 8, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %l4, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P6104: !REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6105: !CAS [0] (maybe <- 0x8501bf) (Int)
add %i0, 0, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P6106: !SWAP [7] (maybe <- 0x8501c0) (Int)
mov %l4, %o0
swap  [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P6107: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P6108: !REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6109: !MEMBAR (Int)
membar #StoreLoad

P6110: !LD [0] (FP)
ld [%i0 + 0], %f10
! 1 addresses covered

P6111: !LD [1] (FP)
ld [%i0 + 4], %f11
! 1 addresses covered

P6112: !LD [2] (FP)
ld [%i0 + 12], %f12
! 1 addresses covered

P6113: !LD [3] (FP)
ld [%i0 + 32], %f13
! 1 addresses covered

P6114: !LD [4] (FP)
ld [%i0 + 64], %f14
! 1 addresses covered

P6115: !LD [5] (FP)
ld [%i1 + 76], %f15
! 1 addresses covered
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P6116: !LD [6] (FP)
ld [%i1 + 80], %f0
! 1 addresses covered

P6117: !LD [7] (FP)
ld [%i1 + 84], %f1
! 1 addresses covered

P6118: !LD [8] (FP)
ld [%i1 + 256], %f2
! 1 addresses covered

P6119: !LD [9] (FP)
ld [%i1 + 512], %f3
! 1 addresses covered

P6120: !LD [10] (FP)
ld [%i2 + 32], %f4
! 1 addresses covered

P6121: !LD [11] (FP)
ld [%i2 + 64], %f5
! 1 addresses covered

P6122: !LD [12] (FP)
ld [%i3 + 0], %f6
! 1 addresses covered

P6123: !LD [13] (FP)
ld [%i3 + 64], %f7
! 1 addresses covered

P6124: !LD [14] (FP)
ld [%i3 + 128], %f8
! 1 addresses covered

P6125: !LD [15] (FP)
ld [%i3 + 192], %f9
! 1 addresses covered
!---- flushing int results buffer----
mov %o0, %o5
!---- flushing fp results buffer, offset 0 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30

restore
retl
nop
!-----------------



func6:

! 1000 instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
srlx %i0, 6, %i0
sllx %i0, 6, %i0

add %i1, 63, %i1
srlx %i1, 6, %i1
sllx %i1, 6, %i1

add %i2, 63, %i2
srlx %i2, 6, %i2
sllx %i2, 6, %i2

add %i3, 63, %i3
srlx %i3, 6, %i3
sllx %i3, 6, %i3

add %i4, 63, %i4
srlx %i4, 6, %i4
sllx %i4, 6, %i4

add %i5, 63, %i5
srlx %i5, 6, %i5
sllx %i5, 6, %i5

mov   %i4, %l1
add   %i5, 1408, %l5

! Initialize %o7, the pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
addx  %o7, %l1, %o7 

! Initializing %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%l5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%l5+4]
ldd [%l5], %f0
ldd [%l5], %f2
ldd [%l5], %f4
ldd [%l5], %f6
ldd [%l5], %f8
ldd [%l5], %f10
ldd [%l5], %f12
ldd [%l5], %f14
ldd [%l5], %f16
ldd [%l5], %f18
ldd [%l5], %f20
ldd [%l5], %f22
ldd [%l5], %f24
ldd [%l5], %f26
ldd [%l5], %f28
ldd [%l5], %f30
ldd [%l5], %f32
ldd [%l5], %f34
ldd [%l5], %f36
ldd [%l5], %f38
ldd [%l5], %f40
ldd [%l5], %f42
ldd [%l5], %f44
ldd [%l5], %f46
ldd [%l5], %f48
ldd [%l5], %f50
ldd [%l5], %f52
ldd [%l5], %f54
ldd [%l5], %f56
ldd [%l5], %f58
ldd [%l5], %f60
ldd [%l5], %f62

! Initializing int results buffer registers: %o0 %o1 %o2 %o3 %o4 
mov %g0, %o0
mov %g0, %o1
mov %g0, %o2
mov %g0, %o3
mov %g0, %o4

! Signature for extract_loads
sethi %hi(0x06deade1), %l7
or    %l7, %lo(0x06deade1), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize integer counter 
sethi %hi(0x860001), %l4
or    %l4, %lo(0x860001), %l4

! Initialize FP counter 
sethi %hi(0x48bfff60), %l7
or    %l7, %lo(0x48bfff60), %l7
stw %l7, [%l5] 
ld [%l5], %f16

! Initialize FP counter increment value 
sethi %hi(0x3f800000), %l7
or    %l7, %lo(0x3f800000), %l7
stw %l7, [%l5] 
ld [%l5], %f17 

P6126: !DWST [15] (maybe <- 0x860001) (Int) (Loop entry) (Loop exit)
sethi %hi(0x1), %l2
or %l2, %lo(0x1),  %l2
loop_entry_6_0:
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P6127: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P6128: !ST [14] (maybe <- 0x860002) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P6129: !DWST [14] (maybe <- 0x860003) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P6130: !DWST [1] (maybe <- 0x860004) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P6131: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P6132: !CASX [3] (maybe <- 0x860006) (Int)
add %i0, 32, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
sllx %l4, 32, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P6133: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6134: !DWST [0] (maybe <- 0x48bfff60) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P6135: !ST [9] (maybe <- 0x860007) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P6136: !DWLD [14] (FP)
! case fp 
ldd  [%i3 + 128], %f0
! 1 addresses covered

P6137: !LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P6138: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6139: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P6140: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6141: !LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P6142: !DWLD [10] (Int)
ldx [%i2 + 32], %o3
! move %o3(upper) -> %o3(upper)

P6143: !DWST [1] (maybe <- 0x860008) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P6144: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P6145: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P6146: !ST [10] (maybe <- 0x86000a) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P6147: !ST [8] (maybe <- 0x86000b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P6148: !ST [15] (maybe <- 0x86000c) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P6149: !CAS [13] (maybe <- 0x86000d) (Int)
add %i3, 64, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P6150: !MEMBAR (Int)
membar #StoreLoad

P6151: !ST [2] (maybe <- 0x86000e) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P6152: !CASX [5] (maybe <- 0x86000f) (Int)
add %i1, 72, %l7
ldx [%l7], %o0
mov %o0, %l3
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %l4, %o1
add  %l4, 1, %l4
casx [%l7], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P6153: !CAS [11] (maybe <- 0x860010) (Int)
add %i2, 64, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P6154: !LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P6155: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P6156: !DWST [10] (maybe <- 0x860011) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P6157: !PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P6158: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P6159: !DWST [7] (maybe <- 0x860012) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P6160: !DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P6161: !DWLD [13] (Int)
ldx [%i3 + 64], %o4
! move %o4(upper) -> %o4(upper)

P6162: !DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P6163: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6164: !ST [12] (maybe <- 0x860014) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P6165: !LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P6166: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P6167: !PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P6168: !CASX [6] (maybe <- 0x860015) (Int)
add %i1, 80, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P6169: !DWST [14] (maybe <- 0x860017) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P6170: !CASX [1] (maybe <- 0x860018) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

P6171: !CAS [13] (maybe <- 0x86001a) (Int)
add %i3, 64, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o4(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
mov %l4, %o0
cas [%l7], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P6172: !DWST [10] (maybe <- 0x86001b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P6173: !LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P6174: !LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P6175: !DWST [0] (maybe <- 0x86001c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i0 + 0 ] 
add   %l4, 1, %l4

P6176: !ST [0] (maybe <- 0x86001e) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P6177: !LD [15] (FP)
ld [%i3 + 192], %f1
! 1 addresses covered

P6178: !SWAP [10] (maybe <- 0x86001f) (Int)
mov %l4, %l6
swap  [%i2 + 32], %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P6179: !ST [2] (maybe <- 0x860020) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P6180: !LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P6181: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P6182: !CAS [9] (maybe <- 0x860021) (Int)
add %i1, 512, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o2(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P6183: !ST [11] (maybe <- 0x860022) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P6184: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3

P6185: !DWLD [5] (Int)
ldx [%i1 + 72], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P6186: !PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P6187: !ST [1] (maybe <- 0x860023) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P6188: !LD [0] (FP)
ld [%i0 + 0], %f2
! 1 addresses covered

P6189: !PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P6190: !ST [0] (maybe <- 0x860024) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P6191: !PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P6192: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6193: !ST [13] (maybe <- 0x860025) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P6194: !REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6195: !DWST [7] (maybe <- 0x860026) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P6196: !DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P6197: !PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P6198: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6199: !PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P6200: !DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0

P6201: !DWST [2] (maybe <- 0x860028) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8 ] 
add   %l4, 1, %l4

P6202: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6203: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6204: !DWST [7] (maybe <- 0x860029) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P6205: !REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6206: !REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6207: !ST [7] (maybe <- 0x86002b) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P6208: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P6209: !CASX [14] (maybe <- 0x86002c) (Int)
add %i3, 128, %l7
ldx [%l7], %o1
mov %o1, %l3
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
sllx %l4, 32, %o2
add  %l4, 1, %l4
casx [%l7], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P6210: !MEMBAR (Int)
membar #StoreLoad

P6211: !CAS [14] (maybe <- 0x86002d) (Int)
add %i3, 128, %l7
lduw [%l7], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P6212: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P6213: !PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P6214: !REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6215: !DWLD [11] (Int)
ldx [%i2 + 64], %o4
! move %o4(upper) -> %o4(upper)

P6216: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P6217: !CAS [12] (maybe <- 0x86002e) (Int)
add %i3, 0, %l7
lduw [%l7], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o0(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P6218: !ST [5] (maybe <- 0x86002f) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P6219: !CAS [9] (maybe <- 0x860030) (Int)
add %i1, 512, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P6220: !CAS [7] (maybe <- 0x860031) (Int)
add %i1, 84, %l7
lduw [%l7], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o2(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P6221: !DWLD [2] (Int)
ldx [%i0 + 8], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P6222: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6223: !SWAP [6] (maybe <- 0x860032) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P6224: !CAS [9] (maybe <- 0x860033) (Int)
add %i1, 512, %l7
lduw [%l7], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o4(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
add   %l4, 1, %l4

P6225: !LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P6226: !PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P6227: !CAS [5] (maybe <- 0x860034) (Int)
add %i1, 76, %l7
lduw [%l7], %l6
mov %l6, %l3
! move %l3(lower) -> %o0(lower)
sllx %l3, 32, %l6
srlx %l6, 32, %l6
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P6228: !MEMBAR (Int)
membar #StoreLoad

P6229: !DWST [4] (maybe <- 0x860035) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P6230: !REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6231: !LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P6232: !DWST [6] (maybe <- 0x860036) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
add   %l4, 1, %l4
mov %l4, %l7 
or %l6, %l7, %l6
stx %l6, [%i1 + 80 ] 
add   %l4, 1, %l4

P6233: !LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P6234: !LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P6235: !DWST [3] (maybe <- 0x860038) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P6236: !DWST [4] (maybe <- 0x860039) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P6237: !REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6238: !CASX [2] (maybe <- 0x86003a) (Int)
add %i0, 8, %l7
ldx [%l7], %o3
mov %o3, %l3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %l4, %o4
add  %l4, 1, %l4
casx [%l7], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P6239: !DWST [15] (maybe <- 0x86003b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P6240: !MEMBAR (Int)
membar #StoreLoad

P6241: !ST [13] (maybe <- 0x48bfffa0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P6242: !ST [2] (maybe <- 0x86003c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P6243: !DWLD [15] (Int)
ldx [%i3 + 192], %o0
! move %o0(upper) -> %o0(upper)

P6244: !LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0

P6245: !CAS [10] (maybe <- 0x86003d) (Int)
add %i2, 32, %l7
lduw [%l7], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %l6
cas [%l7], %l3, %l6
! move %l6(lower) -> %o1(lower)
sllx %l6, 32, %l7
srlx %l7, 32, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P6246: !MEMBAR (Int)
membar #StoreLoad

P6247: !MEMBAR (Int)
membar #StoreLoad

P6248: !LD [3] (FP)
ld [%i0 + 32], %f3
! 1 addresses covered

P6249: !CASX [5] (maybe <- 0x86003e) (Int)
add %i1, 72, %l7
ldx [%l7], %o2
mov %o2, %l3
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %l4, %o3
add  %l4, 1, %l4
casx [%l7], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P6250: !ST [8] (maybe <- 0x86003f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P6251: !DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5

P6252: !PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P6253: !ST [3] (maybe <- 0x860040) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P6254: !SWAP [8] (maybe <- 0x860041) (Int)
mov %l4, %o0
swap  [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P6255: !LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P6256: !LD [1] (Int)
lduw [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P6257: !CASX [1] (maybe <- 0x860042) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P6258: !REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6259: !DWST [3] (maybe <- 0x860044) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P6260: !CASX [0] (maybe <- 0x860045) (Int)
add %i0, 0, %l7
ldx [%l7], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l3
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
add  %l4, 1, %l4
casx [%l7], %l3, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %o5
mov %o1, %o5
mov %o2, %o5
mov %o3, %o5
mov %o4, %o5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P6261: !LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P6262: !REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6263: !MEMBAR (Int)
membar #StoreLoad

P6264: !DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P6265: !ST [10] (maybe <- 0x860047) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P6266: !REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
add %i3, %l6, %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P6267: !ST [3] (maybe <- 0x860048) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P6268: !NOP (Int)
nop

P6269: !DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P6270: !ST [13] (maybe <- 0x860049) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P6271: !PREFETCH [5] (Int)

mov %l4, %l6 

