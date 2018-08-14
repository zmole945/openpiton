// Modified by Princeton University on June 9th, 2015
/*
* ========== Copyright Header Begin ==========================================
* 
* OpenSPARC T1 Processor File: tsotool_diag11_071503.s
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
! TSOTOOL.READ_EGI 
! TSOTOOL.WRITE_EGI diag.egi
! TSOTOOL.N_PROCS 8
! TSOTOOL.TEST_NAME diag
! TSOTOOL.BATCH Y
! TSOTOOL.VERBOSE Y
! GEN.N_INSTR_PER_PROC 1000
! GEN.AVG_LOOP_SIZE 512
! GEN.AVG_LOOP_ITER 10
! ADMAP.REGION_SIZE 64
! ADMAP.REGION_OFFSETS 0-4-12-32-64,76-80-84-256-512,32-64,0-64-128-192
! ADMAP.ATTRIBUTES CV=0111,CP=1111
! ADMAP.N_ALIASES 0
! ADMAP.ALIAS_FREQUENCY 64
! ADMAP.ALIAS_OFFSET 8388608
! WT.PCT_FP_INSTR 10
! WT.PCT_LITTLE_ENDIAN 5
! WT.PCT_LOADS_NF 0
! WT.PCT_NFS_FAULT 0
! WT.PCT_PREFETCH_FAULT 0
! WT.PCT_PREFETCH_UNIMP 0
! WT.PCT_CBRANCH 10
! WT.PCT_SECONDARY_CTX 0
! WT.PCT_NUCLEUS_CTX 0
! WT.REPLACEMENT 10
! WT.INTERRUPT 0
! WT.LD 10
! WT.BLD 0
! WT.DWLD 10
! WT.QWLD 0
! WT.AQLD 0
! WT.ST 100
! WT.BST 0
! WT.BSTC 0
! WT.DWST 50
! WT.QWST 0
! WT.SWAP 3
! WT.CAS 10
! WT.CASX 10
! WT.ASI_L2_FLUSH 0
! WT.FLUSHI 0
! WT.MEMBAR 1
! WT.PREFETCH 20
! WT.NOP 1
! DBG.WRITE_RESULTS_FILE Y
! ADV.L2_WAYS 24
! ADV.TEST_ITERATIONS 1
! ADV.RESULTS_TO_MEM N
! ADV.BST_MEMBARS Y
! ADV.BLD_MEMBARS Y
! ADV.PREFETCH_FCNS fcn_1=5
! ADV.SAME_TEST_ALL_CPUS N
! ADV.ANALYSIS_EFFORT max
! ADV.ONLINE_PASSES 10
! GEN.SEED 28


#define N_CPUS  8
#define REGION_SIZE_RTL (64 * 1024)
!====#define RESULTS_BUF_SIZE_PER_CPU_RTL 128
#define RESULTS_BUF_SIZE_PER_CPU_RTL 1024
#define PRIVATE_DATA_AREA_PER_CPU_RTL 64

#define ALIGN_PAGE_8K .align 8192
#define ALIGN_PAGE_512K .align 524288
#define ALIGN_PAGE_4M .align 4194304
SECTION .MY_HYP_SEC TEXT_VA = 0x1100150000
attr_text {
        Name=.MY_HYP_SEC,
        hypervisor
	}
.text
.global intr0x60_custom_trap
intr0x60_custom_trap:
	ldxa	[%g0] 0x72, %g2;
	ldxa	[%g0] 0x74, %g1;	
	retry;

.global intr0x190_custom_trap
intr0x190_custom_trap:
	stxa	%i0, [%g0] 0x73;	
	done;

!============================================================================

#define ENABLE_T0_Fp_exception_ieee_754_0x21
#define ENABLE_T0_Fp_exception_other_0x22
#define ENABLE_T0_Fp_disabled_0x20
#define ENABLE_T0_Illegal_instruction_0x10
#define ENABLE_T0_Clean_Window_0x24

#define H_T0_Trap_Instruction_0
#define My_T0_Trap_Instruction_0	\
	ta      0x90;			\
	done;

#define H_HT0_HTrap_Instruction_0 intr0x190_custom_trap
#define H_HT0_Interrupt_0x60 intr0x60_custom_trap

#include "custom_page1.h"

#define B_TRAP T_BAD_TRAP
#define G_TRAP T_GOOD_TRAP

define(EXIT_GOOD, `ta G_TRAP')
define(EXIT_BAD, `ta B_TRAP')

!try later:
!	stxa    %l6, [$8] (0x22 | ($2 & 0x9)) ! ASI is randomly set
!===========
define(BST_INIT, `
	add     $6, ($7 & 0xfff0), $8	! 4-byte align the offset
	stxa    %l6, [$8] 0x22		! ASI is randomly set
')

!try later:
!ldda    [$8] (0x22 | ($2 & 0x9)), %l6 ! ASI is randomly set
!===========
define(BLD_INIT, `
        add     $6, ($7 & 0xfff0), $8 	! 4-byte align the offset
        ldda    [$8] 0x22, %l6 		! ASI is randomly set
')

define(CHECK_PROC_ID,`
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
#ifdef RTGPRIV
	ta	T_CHANGE_PRIV
#endif
	
')
define(EN_INTERRUPTS,`
nop
')

define(DIS_INTERRUPTS,`
nop
')

define(CHECK_DISPATCH_STATUS,`
nop
')

define(CHECK_RECEIVE_STATUS,`
nop
')

define(WRITE_INTR_DATA_REGS,`
nop
')

define(INTR_SET_DISPATCH_VECTOR,`
add      %g0,$3,$4
sllx    $4, 8, $5      ! DEST ID
add      %g0,$2,$4	! VECTOR NUMBER
or      $5,$4,$5
mov %i0, $4
mov $5, %i0
ta 0x30
mov $4, %i0
')

define(DSPCH_INTERRUPT,`
nop
')

.seg "text"
ALIGN_PAGE_8K
local_trap_handlers_start:

.align 64
extern_interrupt_handler:
stxa  %g0, [%g0]ASI_INTR_RECEIVE
retry

local_trap_handlers_end:


!------------------------------------------------------------------------

.seg "data"
ALIGN_PAGE_512K
tsotool_unshared_data_start:
!-- label names of res_buf must match with extract_loads_m64.pl --
.align 64 ! for self bcopy()
res_buf_fp_p_0:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_0:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_1:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_1:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_2:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_2:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_3:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_3:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_4:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_4:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_5:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_5:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_6:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_6:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_7:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_7:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
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
stack_top_p0:
	.skip 2048
stack_top_p1:
	.skip 2048
stack_top_p2:
	.skip 2048
stack_top_p3:
	.skip 2048
stack_top_p4:
	.skip 2048
stack_top_p5:
	.skip 2048
stack_top_p6:
	.skip 2048
stack_top_p7:
	.skip 2048
tsotool_unshared_data_end:

!------------------------------------------------------------------------

.seg "data"
! 4 shared memory regions, 0 alias(es) each (Alias 0 is normal VA)

ALIGN_PAGE_8K
REGION0_ALIAS0_START:
	.skip REGION_SIZE_RTL
REGION0_ALIAS0_END:

ALIGN_PAGE_8K
REGION1_ALIAS0_START:
	.skip REGION_SIZE_RTL
REGION1_ALIAS0_END:

ALIGN_PAGE_8K
REGION2_ALIAS0_START:
	.skip REGION_SIZE_RTL
REGION2_ALIAS0_END:

ALIGN_PAGE_8K
REGION3_ALIAS0_START:
	.skip REGION_SIZE_RTL
REGION3_ALIAS0_END:

ALIGN_PAGE_8K
REPLACEMENT_ALIAS0_START:
	.skip 24 * REGION_SIZE_RTL	 ! replacement area
REPLACEMENT_ALIAS0_END:

.global main
.seg "text"
ALIGN_PAGE_8K
user_text_start:
main:
	mov     0, %o0
	mov     0, %o1
	CHECK_PROC_ID
! at this point, g1 should have CPU id (0, 1, 2, ...)
	set     REGION0_ALIAS0_START, %o0	! shared address 0
	set     REGION1_ALIAS0_START, %o1	! shared address 1
	set     REGION2_ALIAS0_START, %o2	! shared address 2
	set     REGION3_ALIAS0_START, %o3	! shared address 3
	cmp     %g1, 0x7
	be      setup_p7
	nop
	cmp     %g1, 0x6
	be      setup_p6
	nop
	cmp     %g1, 0x5
	be      setup_p5
	nop
	cmp     %g1, 0x4
	be      setup_p4
	nop
	cmp     %g1, 0x3
	be      setup_p3
	nop
	cmp     %g1, 0x2
	be      setup_p2
	nop
	cmp     %g1, 0x1
	be      setup_p1
	nop
	cmp     %g1, 0x0
	be      setup_p0
	nop
	EXIT_BAD   ! Should never reach here
	nop

setup_p0:
	set     stack_top_p0, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_0, %o4
	set     private_data_p0, %o5
	set     func0, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p1:
	set     stack_top_p1, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_1, %o4
	set     private_data_p1, %o5
	set     func1, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p2:
	set     stack_top_p2, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_2, %o4
	set     private_data_p2, %o5
	set     func2, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p3:
	set     stack_top_p3, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_3, %o4
	set     private_data_p3, %o5
	set     func3, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p4:
	set     stack_top_p4, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_4, %o4
	set     private_data_p4, %o5
	set     func4, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p5:
	set     stack_top_p5, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_5, %o4
	set     private_data_p5, %o5
	set     func5, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p6:
	set     stack_top_p6, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_6, %o4
	set     private_data_p6, %o5
	set     func6, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p7:
	set     stack_top_p7, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_7, %o4
	set     private_data_p7, %o5
	set     func7, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop
!-----------------

! register usage:
! %i0 %i1 %i2 %i3 : base registers for 4 regions
! %i4 fixed pointer to per-cpu results area
! %l1 moving pointer to per-cpu FP results area
! %o7 moving pointer to per-cpu integer results area
! %i5 pointer to per-cpu private area
! %l0 holds lfsr, used as source of random bits 
! %l2 loop count register
! %f16 running counter for unique fp store values
! %f17 holds increment value for fp counter
! %l4 running counter for unique integer store values (increment value is always 1)
! %l5 move-to register for load values (simulation only)
! %f30 move-to register for FP values (simulation only)
! %l3 %l6 %l7 %o5 : 4 temporary registers
! %o0 %o1 %o2 %o3 %o4 : 5 integer results buffer registers
! %f0-f15 FP results buffer registers
! %f32-f47 FP block load/store registers

func0:
! 1000 (dynamic) instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
andn %i0, 63, %i0

add %i1, 63, %i1
andn %i1, 63, %i1

add %i2, 63, %i2
andn %i2, 63, %i2

add %i3, 63, %i3
andn %i3, 63, %i3

add %i4, 63, %i4
andn %i4, 63, %i4

add %i5, 63, %i5
andn %i5, 63, %i5


! Initialize pointer to FP load results area
mov   %i4, %l1

! Initialize pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
add  %o7, %l1, %o7 

! Initialize %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l6
or    %l6, %lo(0xdeadbee0), %l6
stw   %l6, [%i5]
sethi %hi(0xdeadbee1), %l6
or    %l6, %lo(0xdeadbee1), %l6
stw   %l6, [%i5+4]
ldd [%i5], %f0
fmovd %f0, %f2
fmovd %f0, %f4
fmovd %f0, %f6
fmovd %f0, %f8
fmovd %f0, %f10
fmovd %f0, %f12
fmovd %f0, %f14
fmovd %f0, %f16
fmovd %f0, %f18
fmovd %f0, %f20
fmovd %f0, %f22
fmovd %f0, %f24
fmovd %f0, %f26
fmovd %f0, %f28
fmovd %f0, %f30
fmovd %f0, %f32
fmovd %f0, %f34
fmovd %f0, %f36
fmovd %f0, %f38
fmovd %f0, %f40
fmovd %f0, %f42
fmovd %f0, %f44
fmovd %f0, %f46
fmovd %f0, %f48
fmovd %f0, %f50
fmovd %f0, %f52
fmovd %f0, %f54
fmovd %f0, %f56
fmovd %f0, %f58
fmovd %f0, %f60
fmovd %f0, %f62

! Signature for extract_loads script to start extracting load values for this stream
sethi %hi(0x00deade1), %l6
or    %l6, %lo(0x00deade1), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x1), %l4
or    %l4, %lo(0x1), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x3f800001), %l6
or    %l6, %lo(0x3f800001), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x34000000), %l6
or    %l6, %lo(0x34000000), %l6
stw %l6, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x1066^4
sethi %hi(0x1066), %l0
or    %l0, %lo(0x1066), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 0 to 1 ---
stx %g0, [%i0+0]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l7
add %i3, %l7, %l7
sub %l7, -4096, %l7

!-- master of sync_init ---
or %g0, 7, %o5
swap [%l7], %o5
sync_init_0:
swap [%l7+4], %g0
lduw [%l7], %o5
brnz,pt %o5, sync_init_0
membar #Sync ! delay slot
!-- end of sync_init ---


BEGIN_NODES0: ! Test istream for CPU 0 begins

P1: !_ST [0] (maybe <- 0x1) (Int) (Loop entry) (CBR) (Branch target of P235)
sethi %hi(0x1), %l2
or %l2, %lo(0x1),  %l2
loop_entry_0_0:
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1
nop
RET1:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P2
nop

TARGET235:
ba RET235
nop


P2: !_CASX [8] (maybe <- 0x2) (Int)
add %i1, 256, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
sllx %l4, 32, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4: !_ST [13] (maybe <- 0x3) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P5: !_DWST [4] (maybe <- 0x4) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P6: !_DWST [6] (maybe <- 0x5) (Int) (Branch target of P156)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4
ba P7
nop

TARGET156:
ba RET156
nop


P7: !_CAS [6] (maybe <- 0x7) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
wr %g0, 0x88, %asi
add %i1, 80, %o5
lduwa [%o5] %asi, %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l3, %l6
casa [%o5] %asi, %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P8: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l7
or %l7, %lo(0x4c),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P9: !_DWLD [11] (Int)
ldx [%i2 + 64], %o3
! move %o3(upper) -> %o3(upper)

P10: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %o5
or %o5, %lo(0x40),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P11: !_ST [2] (maybe <- 0x8) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P12: !_DWST [11] (maybe <- 0x9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P13: !_ST [10] (maybe <- 0xa) (Int) (Branch target of P686)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P14
nop

TARGET686:
ba RET686
nop


P14: !_ST [14] (maybe <- 0xb) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P15: !_ST [9] (maybe <- 0xc) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P16: !_DWST [2] (maybe <- 0xd) (Int) (Branch target of P182)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4
ba P17
nop

TARGET182:
ba RET182
nop


P17: !_ST [12] (maybe <- 0xe) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P18: !_ST [4] (maybe <- 0x3f800001) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET18
nop
RET18:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P19: !_DWLD [1] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l3, 32, %o5
or %o5, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4

P20: !_LD [5] (Int)
lduw [%i1 + 76], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P21: !_ST [1] (maybe <- 0xf) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET21
nop
RET21:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P22: !_DWST [6] (maybe <- 0x10) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P23: !_DWST [13] (maybe <- 0x12) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P24: !_CASX [2] (maybe <- 0x13) (Int)
add %i0, 8, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
mov %l4, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P25: !_ST [12] (maybe <- 0x3f800002) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P26: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P27: !_PREFETCH [2] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

P28: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P29: !_DWST [2] (maybe <- 0x14) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P30: !_ST [0] (maybe <- 0x15) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P31: !_ST [15] (maybe <- 0x16) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P32: !_LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P33: !_ST [11] (maybe <- 0x17) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P34: !_REPLACEMENT [11] (Int) (Branch target of P458)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P35
nop

TARGET458:
ba RET458
nop


P35: !_ST [6] (maybe <- 0x18) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET35
nop
RET35:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P36: !_CASX [2] (maybe <- 0x19) (Int)
add %i0, 8, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov  %l3, %l6
mov %l4, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l7
or %l7, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
add  %l4, 1, %l4

P37: !_ST [2] (maybe <- 0x1a) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P38: !_ST [11] (maybe <- 0x1b) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P39: !_ST [13] (maybe <- 0x1c) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 64] %asi
add   %l4, 1, %l4

P40: !_ST [2] (maybe <- 0x1d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P41: !_DWST [7] (maybe <- 0x1e) (Int) (Branch target of P809)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4
ba P42
nop

TARGET809:
ba RET809
nop


P42: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P43: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P44: !_ST [7] (maybe <- 0x20) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 84] %asi
add   %l4, 1, %l4

P45: !_DWST [6] (maybe <- 0x21) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P46: !_LD [6] (Int) (Branch target of P142)
lduw [%i1 + 80], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
ba P47
nop

TARGET142:
ba RET142
nop


P47: !_ST [12] (maybe <- 0x23) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P48: !_ST [13] (maybe <- 0x24) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P49: !_DWST [4] (maybe <- 0x25) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P50: !_ST [4] (maybe <- 0x26) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P51: !_DWST [3] (maybe <- 0x27) (Int) (Branch target of P580)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4
ba P52
nop

TARGET580:
ba RET580
nop


P52: !_CASX [11] (maybe <- 0x28) (Int)
add %i2, 64, %l3
ldx [%l3], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %o5
sllx %l4, 32, %o1
casx [%l3], %o5, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P53: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P54: !_CAS [0] (maybe <- 0x29) (Int)
add %i0, 0, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P55: !_DWST [10] (maybe <- 0x2a) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i2 + 32 ] %asi
add   %l4, 1, %l4

P56: !_ST [12] (maybe <- 0x2b) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET56
nop
RET56:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P57: !_DWST [1] (maybe <- 0x2c) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
sllx %l4, 32, %l6
add   %l4, 1, %l4
or %l6, %l4, %l7
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
sllx %o5, 32, %l6
or %o5, %l6, %o5 
and %l7, %o5, %l6
srlx %l6, 8, %l6
sllx %l7, 8, %l7
and %l7, %o5, %l7
or %l7, %l6, %l7 
sethi %hi(0xffff0000), %o5
or %o5, %lo(0xffff0000), %o5
srlx %l7, 16, %l6
andn %l6, %o5, %l6
andn %l7, %o5, %l7
sllx %l7, 16, %l7
or %l7, %l6, %l7 
srlx %l7, 32, %l6
sllx %l7, 32, %l7
or %l7, %l6, %l6 
stxa %l6, [%i0 + 0 ] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET57
nop
RET57:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P58: !_DWST [5] (maybe <- 0x2e) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P59: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l3
or %l3, %lo(0xc),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P60: !_ST [2] (maybe <- 0x2f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P61: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P62: !_DWST [8] (maybe <- 0x3f800003) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P63: !_ST [11] (maybe <- 0x30) (Int) (Branch target of P919)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P64
nop

TARGET919:
ba RET919
nop


P64: !_PREFETCH [7] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 84] %asi, 1

P65: !_CAS [9] (maybe <- 0x31) (Int)
add %i1, 512, %l6
lduw [%l6], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P66: !_CASX [15] (maybe <- 0x32) (Int)
add %i3, 192, %l6
ldx [%l6], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l3
sllx %l4, 32, %o0
casx [%l6], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P67: !_DWST [5] (maybe <- 0x3f800004) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P68: !_ST [15] (maybe <- 0x33) (Int) (Branch target of P173)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P69
nop

TARGET173:
ba RET173
nop


P69: !_DWST [8] (maybe <- 0x34) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

P70: !_CASX [6] (maybe <- 0x35) (Int)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l6
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P71: !_ST [0] (maybe <- 0x37) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P72: !_ST [14] (maybe <- 0x38) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P73: !_ST [7] (maybe <- 0x39) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P74: !_DWLD [3] (Int) (CBR) (Branch target of P446)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET74
nop
RET74:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P75
nop

TARGET446:
ba RET446
nop


P75: !_DWST [5] (maybe <- 0x3a) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P76: !_ST [0] (maybe <- 0x3b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P77: !_ST [6] (maybe <- 0x3f800005) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P78: !_ST [3] (maybe <- 0x3c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P79: !_DWST [8] (maybe <- 0x3d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P80: !_DWST [13] (maybe <- 0x3e) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P81: !_ST [6] (maybe <- 0x3f) (Int) (Branch target of P846)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4
ba P82
nop

TARGET846:
ba RET846
nop


P82: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P83: !_PREFETCH [1] (Int) (CBR)
prefetch [%i0 + 4], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET83
nop
RET83:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P84: !_CAS [8] (maybe <- 0x40) (Int)
add %i1, 256, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P85: !_ST [14] (maybe <- 0x41) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P86: !_ST [6] (maybe <- 0x42) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P87: !_ST [14] (maybe <- 0x43) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P88: !_ST [12] (maybe <- 0x44) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P89: !_ST [4] (maybe <- 0x45) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P90: !_ST [10] (maybe <- 0x46) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P91: !_CAS [7] (maybe <- 0x47) (Int) (Branch target of P617)
add %i1, 84, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4
ba P92
nop

TARGET617:
ba RET617
nop


P92: !_ST [7] (maybe <- 0x48) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P93: !_DWST [7] (maybe <- 0x49) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P94: !_ST [13] (maybe <- 0x4b) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P95: !_ST [14] (maybe <- 0x3f800006) (FP) (Branch target of P717)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]
ba P96
nop

TARGET717:
ba RET717
nop


P96: !_ST [7] (maybe <- 0x4c) (Int) (Branch target of P157)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P97
nop

TARGET157:
ba RET157
nop


P97: !_ST [10] (maybe <- 0x4d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P98: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P99: !_ST [14] (maybe <- 0x4e) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P100: !_DWST [5] (maybe <- 0x4f) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P101: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P102: !_DWST [5] (maybe <- 0x3f800007) (FP) (CBR)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET102
nop
RET102:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P103: !_DWLD [10] (FP) (CBR)
ldd [%i2 + 32], %f0
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET103
nop
RET103:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P104: !_PREFETCH [6] (Int) (CBR)
prefetch [%i1 + 80], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET104
nop
RET104:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P105: !_DWST [13] (maybe <- 0x50) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P106: !_LD [15] (Int) (Branch target of P844)
lduw [%i3 + 192], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
ba P107
nop

TARGET844:
ba RET844
nop


P107: !_ST [15] (maybe <- 0x3f800008) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P108: !_DWST [11] (maybe <- 0x51) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P109: !_ST [9] (maybe <- 0x3f800009) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P110: !_ST [13] (maybe <- 0x3f80000a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P111: !_ST [13] (maybe <- 0x52) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P112: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P113: !_ST [5] (maybe <- 0x53) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P114: !_DWST [1] (maybe <- 0x54) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P115: !_CASX [6] (maybe <- 0x56) (Int)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l6
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P116: !_DWST [1] (maybe <- 0x58) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %l6
add   %l4, 1, %l4
or %l6, %l4, %l7
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
sllx %o5, 32, %l6
or %o5, %l6, %o5 
and %l7, %o5, %l6
srlx %l6, 8, %l6
sllx %l7, 8, %l7
and %l7, %o5, %l7
or %l7, %l6, %l7 
sethi %hi(0xffff0000), %o5
or %o5, %lo(0xffff0000), %o5
srlx %l7, 16, %l6
andn %l6, %o5, %l6
andn %l7, %o5, %l7
sllx %l7, 16, %l7
or %l7, %l6, %l7 
srlx %l7, 32, %l6
sllx %l7, 32, %l7
or %l7, %l6, %l6 
stxa %l6, [%i0 + 0 ] %asi
add   %l4, 1, %l4

P117: !_ST [6] (maybe <- 0x5a) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P118: !_PREFETCH [14] (Int) (Branch target of P464)
prefetch [%i3 + 128], 1
ba P119
nop

TARGET464:
ba RET464
nop


P119: !_CAS [15] (maybe <- 0x5b) (Int)
add %i3, 192, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P120: !_DWST [8] (maybe <- 0x5c) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P121: !_ST [10] (maybe <- 0x5d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P122: !_ST [7] (maybe <- 0x5e) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P123: !_DWST [12] (maybe <- 0x5f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P124: !_ST [2] (maybe <- 0x60) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P125: !_ST [0] (maybe <- 0x61) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P126: !_ST [1] (maybe <- 0x62) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P127: !_ST [9] (maybe <- 0x63) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 512] %asi
add   %l4, 1, %l4

P128: !_DWLD [3] (FP)
ldd [%i0 + 32], %f18
! 1 addresses covered
fmovs %f18, %f1

P129: !_DWST [6] (maybe <- 0x64) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P130: !_DWST [15] (maybe <- 0x66) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P131: !_DWST [5] (maybe <- 0x67) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P132: !_DWST [12] (maybe <- 0x68) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P133: !_DWLD [5] (Int)
ldx [%i1 + 72], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P134: !_DWST [6] (maybe <- 0x69) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P135: !_ST [2] (maybe <- 0x6b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P136: !_ST [14] (maybe <- 0x6c) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P137: !_CASX [15] (maybe <- 0x6d) (Int)
add %i3, 192, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %o5
or %o5, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
add  %l4, 1, %l4

P138: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l7
or %l7, %lo(0x100),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P139: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %l6
or %l6, %lo(0x54),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P140: !_DWST [3] (maybe <- 0x3f80000b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P141: !_DWST [14] (maybe <- 0x6e) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P142: !_DWST [14] (maybe <- 0x6f) (Int) (CBR) (Branch target of P998)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET142
nop
RET142:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P143
nop

TARGET998:
ba RET998
nop


P143: !_ST [15] (maybe <- 0x70) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P144: !_DWST [1] (maybe <- 0x71) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P145: !_DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P146: !_CAS [11] (maybe <- 0x73) (Int)
add %i2, 64, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2
mov %l4, %o3
cas [%o5], %l7, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P147: !_DWST [2] (maybe <- 0x3f80000c) (FP) (Branch target of P266)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]
ba P148
nop

TARGET266:
ba RET266
nop


P148: !_DWST [10] (maybe <- 0x74) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P149: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P150: !_REPLACEMENT [15] (Int) (CBR)
sethi %hi(0xc0), %l3
or %l3, %lo(0xc0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET150
nop
RET150:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P151: !_DWST [12] (maybe <- 0x75) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P152: !_CAS [1] (maybe <- 0x76) (Int) (Branch target of P929)
add %i0, 4, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4
ba P153
nop

TARGET929:
ba RET929
nop


P153: !_DWST [15] (maybe <- 0x77) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P154: !_CAS [12] (maybe <- 0x78) (Int)
add %i3, 0, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%o5], %l7, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P155: !_ST [0] (maybe <- 0x79) (Int) (CBR) (Branch target of P209)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET155
nop
RET155:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P156
nop

TARGET209:
ba RET209
nop


P156: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET156
nop
RET156:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P157: !_ST [2] (maybe <- 0x7a) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET157
nop
RET157:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P158: !_LD [7] (Int)
lduw [%i1 + 84], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P159: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P160: !_LD [10] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i2 + 32] %asi, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P161: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P162: !_CAS [2] (maybe <- 0x7b) (Int) (CBR)
add %i0, 12, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1
mov %l4, %o2
cas [%l3], %o5, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET162
nop
RET162:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P163: !_DWST [3] (maybe <- 0x7c) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P164: !_ST [13] (maybe <- 0x7d) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P165: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P166: !_DWST [4] (maybe <- 0x7e) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P167: !_DWST [14] (maybe <- 0x7f) (Int) (CBR) (Branch target of P56)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET167
nop
RET167:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P168
nop

TARGET56:
ba RET56
nop


P168: !_DWST [4] (maybe <- 0x80) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P169: !_DWST [1] (maybe <- 0x81) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P170: !_ST [2] (maybe <- 0x83) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P171: !_LD [8] (Int) (CBR)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET171
nop
RET171:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P172: !_DWST [15] (maybe <- 0x3f80000d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P173: !_DWST [13] (maybe <- 0x84) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET173
nop
RET173:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P174: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P175: !_DWST [14] (maybe <- 0x85) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET175
nop
RET175:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P176: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P177: !_ST [14] (maybe <- 0x86) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P178: !_CASX [3] (maybe <- 0x87) (Int)
add %i0, 32, %l3
ldx [%l3], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %o5
sllx %l4, 32, %o4
casx [%l3], %o5, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P179: !_ST [5] (maybe <- 0x88) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P180: !_ST [3] (maybe <- 0x89) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P181: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P182: !_CAS [8] (maybe <- 0x8a) (Int) (CBR) (Branch target of P102)
add %i1, 256, %l7
lduw [%l7], %o0
mov %o0, %l6
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET182
nop
RET182:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P183
nop

TARGET102:
ba RET102
nop


P183: !_DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P184: !_ST [2] (maybe <- 0x8b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P185: !_ST [1] (maybe <- 0x8c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P186: !_DWST [7] (maybe <- 0x8d) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P187: !_ST [3] (maybe <- 0x8f) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P188: !_ST [12] (maybe <- 0x90) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P189: !_DWST [13] (maybe <- 0x91) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P190: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P191: !_NOP (Int)
nop

P192: !_ST [10] (maybe <- 0x92) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P193: !_CASX [14] (maybe <- 0x93) (Int)
add %i3, 128, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l7
or %l7, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
add  %l4, 1, %l4

P194: !_DWST [10] (maybe <- 0x94) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P195: !_CAS [9] (maybe <- 0x95) (Int) (CBR)
add %i1, 512, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3
mov %l4, %o4
cas [%l6], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET195
nop
RET195:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P196: !_CAS [8] (maybe <- 0x96) (Int)
add %i1, 256, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P197: !_ST [9] (maybe <- 0x97) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P198: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P199: !_DWST [11] (maybe <- 0x98) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P200: !_ST [9] (maybe <- 0x99) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P201: !_CASX [7] (maybe <- 0x9a) (Int) (CBR)
add %i1, 80, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l7
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET201
nop
RET201:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P202: !_REPLACEMENT [5] (Int) (CBR)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET202
nop
RET202:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P203: !_ST [9] (maybe <- 0x9c) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P204: !_DWST [14] (maybe <- 0x9d) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P205: !_ST [5] (maybe <- 0x9e) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET205
nop
RET205:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P206: !_ST [10] (maybe <- 0x9f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P207: !_ST [11] (maybe <- 0xa0) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P208: !_CASX [9] (maybe <- 0xa1) (Int) (Branch target of P702)
add %i1, 512, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %o5
or %o5, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l3
or %l3, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
add  %l4, 1, %l4
ba P209
nop

TARGET702:
ba RET702
nop


P209: !_LD [12] (Int) (CBR)
lduw [%i3 + 0], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET209
nop
RET209:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P210: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l7
or %l7, %lo(0x4),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P211: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P212: !_ST [7] (maybe <- 0xa2) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P213: !_DWST [7] (maybe <- 0xa3) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P214: !_ST [4] (maybe <- 0x3f80000e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P215: !_DWST [11] (maybe <- 0x3f80000f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P216: !_DWST [0] (maybe <- 0xa5) (Int) (CBR)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET216
nop
RET216:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P217: !_CASX [15] (maybe <- 0xa7) (Int)
add %i3, 192, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
sllx %l4, 32, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P218: !_CAS [2] (maybe <- 0xa8) (Int)
add %i0, 12, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P219: !_ST [12] (maybe <- 0xa9) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P220: !_ST [2] (maybe <- 0xaa) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P221: !_DWST [10] (maybe <- 0xab) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P222: !_DWST [1] (maybe <- 0xac) (Int) (CBR)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET222
nop
RET222:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P223: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P224: !_DWST [1] (maybe <- 0xae) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P225: !_ST [9] (maybe <- 0xb0) (Int) (Branch target of P155)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P226
nop

TARGET155:
ba RET155
nop


P226: !_ST [11] (maybe <- 0xb1) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P227: !_ST [5] (maybe <- 0xb2) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P228: !_ST [13] (maybe <- 0xb3) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P229: !_ST [14] (maybe <- 0xb4) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P230: !_CAS [10] (maybe <- 0xb5) (Int)
add %i2, 32, %l6
lduw [%l6], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P231: !_ST [4] (maybe <- 0xb6) (Int) (Branch target of P171)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P232
nop

TARGET171:
ba RET171
nop


P232: !_ST [13] (maybe <- 0xb7) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P233: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P234: !_ST [6] (maybe <- 0x3f800010) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P235: !_PREFETCH [5] (Int) (CBR)
prefetch [%i1 + 76], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET235
nop
RET235:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P236: !_DWST [9] (maybe <- 0xb8) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P237: !_ST [14] (maybe <- 0xb9) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P238: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P239: !_CAS [1] (maybe <- 0xba) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %l6, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
wr %g0, 0x88, %asi
add %i0, 4, %l6
lduwa [%l6] %asi, %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l7, %o5
casa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P240: !_ST [0] (maybe <- 0xbb) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P241: !_LD [2] (Int)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P242: !_SWAP [15] (maybe <- 0xbc) (Int)
mov %l4, %o5
swap  [%i3 + 192], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l6
or %l6, %o0, %o0
add   %l4, 1, %l4

P243: !_CASX [10] (maybe <- 0xbd) (Int)
add %i2, 32, %l6
ldx [%l6], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l3
sllx %l4, 32, %o2
casx [%l6], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P244: !_DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P245: !_DWST [13] (maybe <- 0xbe) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P246: !_ST [5] (maybe <- 0xbf) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P247: !_ST [3] (maybe <- 0xc0) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P248: !_CAS [9] (maybe <- 0xc1) (Int)
add %i1, 512, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P249: !_LD [7] (Int) (CBR)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET249
nop
RET249:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P250: !_MEMBAR (Int)
membar #StoreLoad

P251: !_LD [14] (Int)
lduw [%i3 + 128], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P252: !_ST [7] (maybe <- 0xc2) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P253: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P254: !_CAS [4] (maybe <- 0xc3) (Int)
add %i0, 64, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P255: !_ST [9] (maybe <- 0xc4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P256: !_SWAP [15] (maybe <- 0xc5) (Int) (CBR)
mov %l4, %o2
swap  [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET256
nop
RET256:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P257: !_DWST [11] (maybe <- 0x3f800011) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P258: !_ST [11] (maybe <- 0x3f800012) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P259: !_ST [1] (maybe <- 0xc6) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P260: !_ST [5] (maybe <- 0xc7) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P261: !_DWST [4] (maybe <- 0xc8) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P262: !_ST [4] (maybe <- 0xc9) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 64] %asi
add   %l4, 1, %l4

P263: !_DWST [3] (maybe <- 0xca) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET263
nop
RET263:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P264: !_ST [3] (maybe <- 0xcb) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P265: !_ST [7] (maybe <- 0xcc) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P266: !_LD [3] (Int) (CBR)
lduw [%i0 + 32], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET266
nop
RET266:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P267: !_ST [12] (maybe <- 0xcd) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P268: !_LD [2] (Int)
lduw [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P269: !_ST [6] (maybe <- 0xce) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P270: !_DWST [15] (maybe <- 0xcf) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P271: !_DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3

P272: !_ST [5] (maybe <- 0xd0) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET272
nop
RET272:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P273: !_ST [8] (maybe <- 0xd1) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P274: !_DWST [9] (maybe <- 0xd2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P275: !_ST [5] (maybe <- 0xd3) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P276: !_DWLD [12] (Int)
ldx [%i3 + 0], %o4
! move %o4(upper) -> %o4(upper)

P277: !_CAS [10] (maybe <- 0xd4) (Int)
add %i2, 32, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P278: !_ST [4] (maybe <- 0xd5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P279: !_DWST [5] (maybe <- 0xd6) (Int) (Branch target of P296)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4
ba P280
nop

TARGET296:
ba RET296
nop


P280: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P281: !_DWST [3] (maybe <- 0xd7) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P282: !_ST [6] (maybe <- 0xd8) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P283: !_ST [11] (maybe <- 0xd9) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P284: !_ST [2] (maybe <- 0xda) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P285: !_MEMBAR (Int)
membar #StoreLoad

P286: !_ST [14] (maybe <- 0xdb) (Int) (Branch target of P377)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P287
nop

TARGET377:
ba RET377
nop


P287: !_PREFETCH [9] (Int) (Branch target of P256)
prefetch [%i1 + 512], 1
ba P288
nop

TARGET256:
ba RET256
nop


P288: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P289: !_ST [3] (maybe <- 0xdc) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P290: !_ST [8] (maybe <- 0xdd) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P291: !_CASX [11] (maybe <- 0xde) (Int) (Branch target of P35)
add %i2, 64, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4
ba P292
nop

TARGET35:
ba RET35
nop


P292: !_DWST [10] (maybe <- 0xdf) (Int) (Branch target of P569)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4
ba P293
nop

TARGET569:
ba RET569
nop


P293: !_DWST [5] (maybe <- 0x3f800013) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P294: !_DWST [9] (maybe <- 0x3f800014) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET294
nop
RET294:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P295: !_LD [10] (Int)
lduw [%i2 + 32], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P296: !_ST [10] (maybe <- 0xe0) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET296
nop
RET296:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P297: !_DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P298: !_ST [4] (maybe <- 0xe1) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P299: !_CASX [0] (maybe <- 0xe2) (Int)
add %i0, 0, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %o5, 32, %l3
or %l3, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
add  %l4, 1, %l4

P300: !_ST [15] (maybe <- 0xe4) (Int) (Branch target of P222)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P301
nop

TARGET222:
ba RET222
nop


P301: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P302: !_ST [6] (maybe <- 0x3f800015) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P303: !_DWST [15] (maybe <- 0xe5) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P304: !_ST [5] (maybe <- 0xe6) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P305: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l3
or %l3, %lo(0x4c),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P306: !_DWST [12] (maybe <- 0xe7) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P307: !_DWLD [5] (Int)
ldx [%i1 + 72], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l7
or %l7, %o0, %o0

P308: !_LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P309: !_ST [0] (maybe <- 0xe8) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P310: !_DWST [7] (maybe <- 0xe9) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P311: !_DWST [10] (maybe <- 0x3f800016) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P312: !_ST [13] (maybe <- 0xeb) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P313: !_ST [12] (maybe <- 0xec) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P314: !_DWST [0] (maybe <- 0xed) (Int) (CBR)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET314
nop
RET314:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P315: !_DWST [3] (maybe <- 0xef) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P316: !_PREFETCH [5] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 76] %asi, 1

P317: !_ST [14] (maybe <- 0xf0) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P318: !_ST [10] (maybe <- 0xf1) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i2 + 32] %asi
add   %l4, 1, %l4

P319: !_DWST [0] (maybe <- 0xf2) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P320: !_DWST [10] (maybe <- 0xf4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P321: !_CASX [7] (maybe <- 0xf5) (Int) (CBR)
add %i1, 80, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l3
or %l3, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l6
or %l6, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET321
nop
RET321:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P322: !_CASX [2] (maybe <- 0xf7) (Int)
add %i0, 8, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov  %l3, %l6
mov %l4, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
add  %l4, 1, %l4

P323: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P324: !_ST [15] (maybe <- 0x3f800017) (FP) (Branch target of P1016)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]
ba P325
nop

TARGET1016:
ba RET1016
nop


P325: !_ST [1] (maybe <- 0xf8) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET325
nop
RET325:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P326: !_DWST [5] (maybe <- 0xf9) (Int) (Branch target of P726)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4
ba P327
nop

TARGET726:
ba RET726
nop


P327: !_ST [10] (maybe <- 0x3f800018) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P328: !_ST [0] (maybe <- 0xfa) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P329: !_CAS [3] (maybe <- 0xfb) (Int)
add %i0, 32, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P330: !_ST [10] (maybe <- 0xfc) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P331: !_DWST [4] (maybe <- 0xfd) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P332: !_DWST [3] (maybe <- 0xfe) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P333: !_ST [4] (maybe <- 0xff) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P334: !_CAS [15] (maybe <- 0x100) (Int)
add %i3, 192, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l6, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P335: !_ST [0] (maybe <- 0x101) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P336: !_LD [7] (Int) (Branch target of P841)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
ba P337
nop

TARGET841:
ba RET841
nop


P337: !_CAS [7] (maybe <- 0x102) (Int) (CBR)
add %i1, 84, %o5
lduw [%o5], %o3
mov %o3, %l7
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET337
nop
RET337:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P338: !_ST [9] (maybe <- 0x103) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P339: !_ST [8] (maybe <- 0x104) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P340: !_CAS [0] (maybe <- 0x105) (Int)
add %i0, 0, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P341: !_DWST [8] (maybe <- 0x106) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P342: !_LD [0] (Int)
lduw [%i0 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P343: !_DWST [13] (maybe <- 0x107) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P344: !_DWST [8] (maybe <- 0x108) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P345: !_ST [13] (maybe <- 0x109) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P346: !_DWST [14] (maybe <- 0x10a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P347: !_ST [1] (maybe <- 0x10b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P348: !_ST [1] (maybe <- 0x10c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P349: !_DWST [0] (maybe <- 0x10d) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %l3
add   %l4, 1, %l4
or %l3, %l4, %l6
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
sllx %l7, 32, %l3
or %l7, %l3, %l7 
and %l6, %l7, %l3
srlx %l3, 8, %l3
sllx %l6, 8, %l6
and %l6, %l7, %l6
or %l6, %l3, %l6 
sethi %hi(0xffff0000), %l7
or %l7, %lo(0xffff0000), %l7
srlx %l6, 16, %l3
andn %l3, %l7, %l3
andn %l6, %l7, %l6
sllx %l6, 16, %l6
or %l6, %l3, %l6 
srlx %l6, 32, %l3
sllx %l6, 32, %l6
or %l6, %l3, %l3 
stxa %l3, [%i0 + 0 ] %asi
add   %l4, 1, %l4

P350: !_REPLACEMENT [13] (Int) (Branch target of P272)
sethi %hi(0x40), %o5
or %o5, %lo(0x40),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
ba P351
nop

TARGET272:
ba RET272
nop


P351: !_ST [3] (maybe <- 0x3f800019) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P352: !_DWST [14] (maybe <- 0x10f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P353: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P354: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P355: !_ST [7] (maybe <- 0x110) (Int) (Branch target of P885)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P356
nop

TARGET885:
ba RET885
nop


P356: !_DWST [15] (maybe <- 0x111) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P357: !_DWLD [14] (Int) (CBR)
ldx [%i3 + 128], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l6
or %l6, %o0, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET357
nop
RET357:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P358: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %l3
or %l3, %lo(0x54),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P359: !_ST [2] (maybe <- 0x112) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P360: !_DWST [5] (maybe <- 0x113) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P361: !_DWST [6] (maybe <- 0x114) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P362: !_ST [15] (maybe <- 0x116) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P363: !_ST [3] (maybe <- 0x117) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P364: !_DWST [0] (maybe <- 0x3f80001a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P365: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET365
nop
RET365:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P366: !_DWST [13] (maybe <- 0x118) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P367: !_DWST [7] (maybe <- 0x119) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P368: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P369: !_REPLACEMENT [1] (Int) (Branch target of P357)
sethi %hi(0x4), %l3
or %l3, %lo(0x4),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
ba P370
nop

TARGET357:
ba RET357
nop


P370: !_ST [0] (maybe <- 0x11b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P371: !_ST [14] (maybe <- 0x11c) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P372: !_ST [5] (maybe <- 0x11d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P373: !_PREFETCH [11] (Int) (Branch target of P972)
prefetch [%i2 + 64], 1
ba P374
nop

TARGET972:
ba RET972
nop


P374: !_CASX [7] (maybe <- 0x11e) (Int)
add %i1, 80, %l6
ldx [%l6], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l6], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P375: !_DWST [13] (maybe <- 0x120) (Int) (CBR) (Branch target of P263)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET375
nop
RET375:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P376
nop

TARGET263:
ba RET263
nop


P376: !_ST [1] (maybe <- 0x121) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P377: !_CASX [10] (maybe <- 0x122) (Int) (CBR)
add %i2, 32, %l3
ldx [%l3], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %o5
sllx %l4, 32, %o4
casx [%l3], %o5, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET377
nop
RET377:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P378: !_LD [1] (Int)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P379: !_ST [2] (maybe <- 0x123) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P380: !_DWST [0] (maybe <- 0x124) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P381: !_DWST [4] (maybe <- 0x126) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P382: !_ST [11] (maybe <- 0x3f80001c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P383: !_CASX [0] (maybe <- 0x127) (Int)
add %i0, 0, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l7
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P384: !_ST [14] (maybe <- 0x129) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P385: !_DWST [8] (maybe <- 0x12a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P386: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P387: !_ST [5] (maybe <- 0x12b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P388: !_ST [0] (maybe <- 0x12c) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 0] %asi
add   %l4, 1, %l4

P389: !_DWST [10] (maybe <- 0x12d) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P390: !_CAS [6] (maybe <- 0x12e) (Int)
add %i1, 80, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P391: !_ST [4] (maybe <- 0x12f) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P392: !_ST [12] (maybe <- 0x130) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i3 + 0] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET392
nop
RET392:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P393: !_ST [9] (maybe <- 0x3f80001d) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET393
nop
RET393:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P394: !_ST [7] (maybe <- 0x131) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P395: !_DWST [0] (maybe <- 0x132) (Int) (Branch target of P1020)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4
ba P396
nop

TARGET1020:
ba RET1020
nop


P396: !_ST [10] (maybe <- 0x134) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P397: !_ST [6] (maybe <- 0x135) (Int) (LE) (Branch target of P850)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i1 + 80] %asi
add   %l4, 1, %l4
ba P398
nop

TARGET850:
ba RET850
nop


P398: !_LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P399: !_LD [0] (Int) (CBR)
lduw [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET399
nop
RET399:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P400: !_DWST [7] (maybe <- 0x136) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P401: !_DWST [7] (maybe <- 0x138) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P402: !_ST [13] (maybe <- 0x13a) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P403: !_ST [0] (maybe <- 0x13b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P404: !_SWAP [15] (maybe <- 0x13c) (Int)
mov %l4, %o5
swap  [%i3 + 192], %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P405: !_ST [2] (maybe <- 0x3f80001e) (FP) (Branch target of P201)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]
ba P406
nop

TARGET201:
ba RET201
nop


P406: !_ST [12] (maybe <- 0x13d) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P407: !_DWLD [12] (Int)
ldx [%i3 + 0], %o0
! move %o0(upper) -> %o0(upper)

P408: !_ST [14] (maybe <- 0x13e) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P409: !_ST [0] (maybe <- 0x13f) (Int) (Branch target of P150)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P410
nop

TARGET150:
ba RET150
nop


P410: !_CASX [6] (maybe <- 0x140) (Int)
add %i1, 80, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l6, %l7
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P411: !_DWST [0] (maybe <- 0x142) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P412: !_DWLD [5] (FP)
ldd [%i1 + 72], %f2
! 1 addresses covered
fmovs %f3, %f2

P413: !_LD [14] (Int)
lduw [%i3 + 128], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P414: !_ST [15] (maybe <- 0x144) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P415: !_DWST [15] (maybe <- 0x145) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P416: !_ST [5] (maybe <- 0x3f80001f) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET416
nop
RET416:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P417: !_DWST [7] (maybe <- 0x146) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P418: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P419: !_ST [12] (maybe <- 0x148) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P420: !_ST [12] (maybe <- 0x149) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P421: !_DWST [5] (maybe <- 0x14a) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P422: !_DWST [12] (maybe <- 0x14b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P423: !_DWST [8] (maybe <- 0x14c) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET423
nop
RET423:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P424: !_CAS [5] (maybe <- 0x14d) (Int)
add %i1, 76, %l6
lduw [%l6], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P425: !_DWLD [8] (Int) (Branch target of P175)
ldx [%i1 + 256], %o4
! move %o4(upper) -> %o4(upper)
ba P426
nop

TARGET175:
ba RET175
nop


P426: !_ST [0] (maybe <- 0x14e) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P427: !_ST [3] (maybe <- 0x14f) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P428: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l3
or %l3, %lo(0x4c),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P429: !_ST [4] (maybe <- 0x150) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P430: !_CAS [3] (maybe <- 0x151) (Int)
add %i0, 32, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%o5], %l7, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P431: !_ST [2] (maybe <- 0x152) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P432: !_ST [5] (maybe <- 0x153) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P433: !_LD [5] (Int) (Branch target of P249)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
ba P434
nop

TARGET249:
ba RET249
nop


P434: !_ST [7] (maybe <- 0x154) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P435: !_DWST [1] (maybe <- 0x155) (Int) (Branch target of P83)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4
ba P436
nop

TARGET83:
ba RET83
nop


P436: !_CAS [15] (maybe <- 0x157) (Int)
add %i3, 192, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P437: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l3
or %l3, %lo(0x20),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P438: !_CAS [3] (maybe <- 0x158) (Int)
add %i0, 32, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4

P439: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P440: !_DWST [5] (maybe <- 0x159) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P441: !_ST [9] (maybe <- 0x15a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P442: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P443: !_DWST [0] (maybe <- 0x3f800020) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET443
nop
RET443:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P444: !_DWST [11] (maybe <- 0x15b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P445: !_ST [8] (maybe <- 0x15c) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P446: !_ST [8] (maybe <- 0x15d) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i1 + 256] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET446
nop
RET446:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P447: !_ST [6] (maybe <- 0x15e) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P448: !_DWST [0] (maybe <- 0x15f) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P449: !_ST [2] (maybe <- 0x161) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P450: !_LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P451: !_ST [13] (maybe <- 0x162) (Int) (Branch target of P1)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P452
nop

TARGET1:
ba RET1
nop


P452: !_ST [12] (maybe <- 0x163) (Int) (Branch target of P74)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P453
nop

TARGET74:
ba RET74
nop


P453: !_DWLD [1] (FP)
ldd [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f3
fmovs %f19, %f4

P454: !_DWST [13] (maybe <- 0x164) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P455: !_DWST [5] (maybe <- 0x165) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P456: !_CASX [6] (maybe <- 0x166) (Int)
add %i1, 80, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l3, %l6
sllx %l4, 32, %l3
add  %l4, 1, %l4
or   %l4, %l3, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
add  %l4, 1, %l4

P457: !_ST [9] (maybe <- 0x168) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P458: !_ST [7] (maybe <- 0x169) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET458
nop
RET458:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P459: !_DWST [3] (maybe <- 0x16a) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P460: !_CASX [2] (maybe <- 0x16b) (Int)
add %i0, 8, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
mov %l4, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

P461: !_DWST [10] (maybe <- 0x3f800022) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P462: !_ST [9] (maybe <- 0x16c) (Int) (Branch target of P21)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P463
nop

TARGET21:
ba RET21
nop


P463: !_DWST [5] (maybe <- 0x3f800023) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P464: !_ST [8] (maybe <- 0x16d) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET464
nop
RET464:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P465: !_DWST [15] (maybe <- 0x16e) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P466: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P467: !_DWST [10] (maybe <- 0x16f) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P468: !_DWST [11] (maybe <- 0x170) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P469: !_DWLD [4] (FP)
ldd [%i0 + 64], %f18
! 1 addresses covered
fmovs %f18, %f5

P470: !_ST [6] (maybe <- 0x171) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P471: !_ST [8] (maybe <- 0x172) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P472: !_CAS [0] (maybe <- 0x173) (Int)
add %i0, 0, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2
mov %l4, %o3
cas [%o5], %l7, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P473: !_CASX [9] (maybe <- 0x174) (Int)
add %i1, 512, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
add  %l4, 1, %l4

P474: !_ST [8] (maybe <- 0x175) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P475: !_NOP (Int)
nop

P476: !_ST [4] (maybe <- 0x176) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P477: !_ST [15] (maybe <- 0x177) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P478: !_DWST [6] (maybe <- 0x178) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P479: !_DWST [15] (maybe <- 0x17a) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P480: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P481: !_ST [0] (maybe <- 0x17b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P482: !_ST [14] (maybe <- 0x17c) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i3 + 128] %asi
add   %l4, 1, %l4

P483: !_ST [4] (maybe <- 0x17d) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P484: !_ST [12] (maybe <- 0x17e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P485: !_ST [0] (maybe <- 0x17f) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P486: !_CASX [14] (maybe <- 0x180) (Int)
add %i3, 128, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l3
or %l3, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l6
or %l6, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
add  %l4, 1, %l4

P487: !_ST [3] (maybe <- 0x181) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P488: !_ST [6] (maybe <- 0x3f800024) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P489: !_ST [15] (maybe <- 0x3f800025) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P490: !_ST [10] (maybe <- 0x182) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P491: !_CAS [10] (maybe <- 0x183) (Int)
add %i2, 32, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l4, %o3
cas [%l6], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P492: !_CAS [7] (maybe <- 0x184) (Int) (Branch target of P715)
add %i1, 84, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3
mov %l4, %o4
cas [%l6], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4
ba P493
nop

TARGET715:
ba RET715
nop


P493: !_ST [6] (maybe <- 0x3f800026) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P494: !_DWST [11] (maybe <- 0x185) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P495: !_DWST [7] (maybe <- 0x186) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P496: !_MEMBAR (Int)
membar #StoreLoad

P497: !_ST [15] (maybe <- 0x188) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P498: !_DWST [14] (maybe <- 0x189) (Int) (Branch target of P843)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4
ba P499
nop

TARGET843:
ba RET843
nop


P499: !_CAS [2] (maybe <- 0x18a) (Int)
add %i0, 12, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l3], %o5, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P500: !_ST [2] (maybe <- 0x18b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P501: !_DWST [15] (maybe <- 0x18c) (Int) (Branch target of P1014)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4
ba P502
nop

TARGET1014:
ba RET1014
nop


P502: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P503: !_ST [10] (maybe <- 0x3f800027) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P504: !_ST [12] (maybe <- 0x18d) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET504
nop
RET504:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P505: !_SWAP [3] (maybe <- 0x18e) (Int)
mov %l4, %l7
swap  [%i0 + 32], %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P506: !_DWST [13] (maybe <- 0x18f) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P507: !_ST [8] (maybe <- 0x190) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P508: !_ST [6] (maybe <- 0x191) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P509: !_CAS [11] (maybe <- 0x192) (Int)
add %i2, 64, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P510: !_ST [10] (maybe <- 0x193) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P511: !_LD [8] (Int) (CBR)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET511
nop
RET511:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P512: !_LD [12] (Int) (Branch target of P399)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2
ba P513
nop

TARGET399:
ba RET399
nop


P513: !_LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P514: !_LD [4] (Int)
lduw [%i0 + 64], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P515: !_LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P516: !_LD [7] (Int)
lduw [%i1 + 84], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P517: !_LD [0] (FP)
ld [%i0 + 0], %f6
! 1 addresses covered

P518: !_LD [13] (FP)
ld [%i3 + 64], %f7
! 1 addresses covered

P519: !_LD [7] (FP)
ld [%i1 + 84], %f8
! 1 addresses covered

P520: !_LD [13] (FP)
ld [%i3 + 64], %f9
! 1 addresses covered

P521: !_LD [1] (FP)
ld [%i0 + 4], %f10
! 1 addresses covered

P522: !_LD [12] (FP)
ld [%i3 + 0], %f11
! 1 addresses covered

P523: !_LD [12] (FP)
ld [%i3 + 0], %f12
! 1 addresses covered

P524: !_LD [8] (FP)
ld [%i1 + 256], %f13
! 1 addresses covered

P525: !_LD [8] (FP) (Branch target of P982)
ld [%i1 + 256], %f14
! 1 addresses covered
ba P526
nop

TARGET982:
ba RET982
nop


P526: !_LD [9] (FP)
ld [%i1 + 512], %f15
! 1 addresses covered
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P527: !_ST [2] (maybe <- 0x194) (Int) (Loop exit)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
loop_exit_0_0:
sub %l2, 1, %l2
cmp %l2, 0
bg loop_entry_0_0
nop

P528: !_ST [15] (maybe <- 0x195) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P529: !_ST [8] (maybe <- 0x196) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET529
nop
RET529:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P530: !_LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P531: !_DWST [13] (maybe <- 0x197) (Int) (Branch target of P696)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P532
nop

TARGET696:
ba RET696
nop


P532: !_ST [14] (maybe <- 0x198) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P533: !_ST [14] (maybe <- 0x199) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P534: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P535: !_DWST [14] (maybe <- 0x19a) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P536: !_CASX [11] (maybe <- 0x19b) (Int)
add %i2, 64, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l7
or %l7, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
add  %l4, 1, %l4

P537: !_ST [1] (maybe <- 0x19c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P538: !_DWST [5] (maybe <- 0x19d) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P539: !_ST [12] (maybe <- 0x19e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P540: !_DWST [14] (maybe <- 0x19f) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P541: !_DWST [10] (maybe <- 0x1a0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P542: !_ST [0] (maybe <- 0x1a1) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i0 + 0] %asi
add   %l4, 1, %l4

P543: !_LD [3] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 32] %asi, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

P544: !_ST [7] (maybe <- 0x1a2) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P545: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P546: !_CAS [0] (maybe <- 0x1a3) (Int)
add %i0, 0, %l6
lduw [%l6], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P547: !_ST [0] (maybe <- 0x1a4) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET547
nop
RET547:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P548: !_ST [6] (maybe <- 0x1a5) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P549: !_ST [11] (maybe <- 0x1a6) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P550: !_DWST [15] (maybe <- 0x1a7) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i3 + 192 ] %asi
add   %l4, 1, %l4

P551: !_CAS [12] (maybe <- 0x1a8) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P552: !_ST [1] (maybe <- 0x1a9) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P553: !_DWLD [2] (Int) (Branch target of P294)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
ba P554
nop

TARGET294:
ba RET294
nop


P554: !_DWST [11] (maybe <- 0x1aa) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P555: !_DWST [13] (maybe <- 0x1ab) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P556: !_CASX [5] (maybe <- 0x1ac) (Int)
add %i1, 72, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l3
or %l3, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov  %o5, %l3
mov %l4, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l6
or %l6, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
add  %l4, 1, %l4

P557: !_CAS [5] (maybe <- 0x1ad) (Int)
add %i1, 76, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l4, %o3
cas [%l6], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P558: !_DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3

P559: !_DWST [7] (maybe <- 0x1ae) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P560: !_DWST [13] (maybe <- 0x1b0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P561: !_DWST [11] (maybe <- 0x1b1) (Int) (LE) (Branch target of P920)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i2 + 64 ] %asi
add   %l4, 1, %l4
ba P562
nop

TARGET920:
ba RET920
nop


P562: !_CASX [12] (maybe <- 0x1b2) (Int) (Branch target of P529)
add %i3, 0, %l3
ldx [%l3], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %o5
sllx %l4, 32, %o0
casx [%l3], %o5, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4
ba P563
nop

TARGET529:
ba RET529
nop


P563: !_ST [0] (maybe <- 0x1b3) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P564: !_DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P565: !_ST [0] (maybe <- 0x1b4) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P566: !_DWST [1] (maybe <- 0x1b5) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET566
nop
RET566:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P567: !_DWST [5] (maybe <- 0x1b7) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P568: !_ST [12] (maybe <- 0x1b8) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P569: !_ST [6] (maybe <- 0x1b9) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET569
nop
RET569:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P570: !_ST [4] (maybe <- 0x1ba) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P571: !_ST [0] (maybe <- 0x1bb) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P572: !_CASX [9] (maybe <- 0x1bc) (Int)
add %i1, 512, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

P573: !_ST [0] (maybe <- 0x1bd) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P574: !_ST [2] (maybe <- 0x1be) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P575: !_ST [6] (maybe <- 0x1bf) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P576: !_ST [7] (maybe <- 0x1c0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P577: !_ST [14] (maybe <- 0x1c1) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P578: !_CASX [10] (maybe <- 0x1c2) (Int)
add %i2, 32, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
add  %l4, 1, %l4

P579: !_ST [0] (maybe <- 0x1c3) (Int) (Branch target of P423)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P580
nop

TARGET423:
ba RET423
nop


P580: !_DWST [10] (maybe <- 0x3f800028) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET580
nop
RET580:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P581: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P582: !_ST [11] (maybe <- 0x1c4) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P583: !_ST [8] (maybe <- 0x1c5) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P584: !_ST [13] (maybe <- 0x1c6) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P585: !_ST [11] (maybe <- 0x1c7) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P586: !_DWST [15] (maybe <- 0x1c8) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P587: !_DWST [3] (maybe <- 0x1c9) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET587
nop
RET587:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P588: !_ST [6] (maybe <- 0x1ca) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P589: !_DWST [8] (maybe <- 0x3f800029) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P590: !_CASX [10] (maybe <- 0x1cb) (Int)
add %i2, 32, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l6
or %l6, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l7
or %l7, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
add  %l4, 1, %l4

P591: !_ST [7] (maybe <- 0x1cc) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P592: !_ST [11] (maybe <- 0x1cd) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P593: !_REPLACEMENT [5] (Int) (CBR)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET593
nop
RET593:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P594: !_ST [14] (maybe <- 0x1ce) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P595: !_DWST [7] (maybe <- 0x1cf) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P596: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P597: !_ST [14] (maybe <- 0x1d1) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P598: !_REPLACEMENT [14] (Int) (CBR)
sethi %hi(0x80), %l3
or %l3, %lo(0x80),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET598
nop
RET598:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P599: !_DWST [7] (maybe <- 0x1d2) (Int) (CBR)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET599
nop
RET599:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P600: !_ST [3] (maybe <- 0x1d4) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET600
nop
RET600:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P601: !_DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2

P602: !_DWST [6] (maybe <- 0x1d5) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P603: !_ST [1] (maybe <- 0x1d7) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P604: !_ST [13] (maybe <- 0x3f80002a) (FP) (Branch target of P325)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]
ba P605
nop

TARGET325:
ba RET325
nop


P605: !_LD [8] (Int)
lduw [%i1 + 256], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P606: !_ST [10] (maybe <- 0x1d8) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P607: !_DWST [15] (maybe <- 0x1d9) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P608: !_DWST [12] (maybe <- 0x1da) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P609: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P610: !_ST [12] (maybe <- 0x3f80002b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P611: !_LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P612: !_DWST [3] (maybe <- 0x1db) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P613: !_ST [4] (maybe <- 0x3f80002c) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET613
nop
RET613:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P614: !_DWST [9] (maybe <- 0x1dc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P615: !_DWST [10] (maybe <- 0x1dd) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P616: !_CASX [1] (maybe <- 0x1de) (Int)
add %i0, 0, %l3
ldx [%l3], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %o4, %o5
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
casx [%l3], %o5, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P617: !_CASX [0] (maybe <- 0x1e0) (Int) (CBR)
add %i0, 0, %l3
ldx [%l3], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %o5
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l3], %o5, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET617
nop
RET617:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P618: !_DWST [9] (maybe <- 0x1e2) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P619: !_PREFETCH [6] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 80] %asi, 1

P620: !_LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P621: !_DWST [14] (maybe <- 0x3f80002d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P622: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P623: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P624: !_ST [3] (maybe <- 0x1e3) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P625: !_LD [5] (Int)
lduw [%i1 + 76], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

P626: !_SWAP [0] (maybe <- 0x1e4) (Int)
mov %l4, %o4
swap  [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P627: !_ST [12] (maybe <- 0x1e5) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P628: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P629: !_ST [5] (maybe <- 0x1e6) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P630: !_ST [10] (maybe <- 0x1e7) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P631: !_LD [4] (Int)
lduw [%i0 + 64], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P632: !_DWST [15] (maybe <- 0x1e8) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P633: !_ST [5] (maybe <- 0x1e9) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P634: !_SWAP [9] (maybe <- 0x1ea) (Int)
mov %l4, %o0
swap  [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P635: !_CASX [14] (maybe <- 0x1eb) (Int)
add %i3, 128, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l3
or %l3, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l6
or %l6, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
add  %l4, 1, %l4

P636: !_LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P637: !_SWAP [10] (maybe <- 0x1ec) (Int)
mov %l4, %o3
swap  [%i2 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P638: !_DWST [5] (maybe <- 0x1ed) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P639: !_DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3

P640: !_CAS [1] (maybe <- 0x1ee) (Int)
add %i0, 4, %o5
lduw [%o5], %o4
mov %o4, %l7
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o4(lower)
srl %l6, 0, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P641: !_DWST [1] (maybe <- 0x1ef) (Int) (Branch target of P18)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4
ba P642
nop

TARGET18:
ba RET18
nop


P642: !_ST [6] (maybe <- 0x3f80002e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P643: !_ST [1] (maybe <- 0x1f1) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P644: !_DWST [2] (maybe <- 0x3f80002f) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P645: !_ST [4] (maybe <- 0x1f2) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P646: !_DWST [9] (maybe <- 0x1f3) (Int) (Branch target of P720)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4
ba P647
nop

TARGET720:
ba RET720
nop


P647: !_CAS [5] (maybe <- 0x1f4) (Int) (CBR)
add %i1, 76, %l6
lduw [%l6], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l6
or %l6, %o0, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET647
nop
RET647:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P648: !_ST [13] (maybe <- 0x1f5) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P649: !_ST [1] (maybe <- 0x3f800030) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET649
nop
RET649:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P650: !_ST [8] (maybe <- 0x1f6) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P651: !_CAS [11] (maybe <- 0x1f7) (Int) (Branch target of P365)
add %i2, 64, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4
ba P652
nop

TARGET365:
ba RET365
nop


P652: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P653: !_DWST [8] (maybe <- 0x1f8) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P654: !_ST [13] (maybe <- 0x3f800031) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P655: !_ST [9] (maybe <- 0x1f9) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P656: !_CAS [2] (maybe <- 0x1fa) (Int)
add %i0, 12, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4

P657: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P658: !_ST [11] (maybe <- 0x1fb) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P659: !_CAS [7] (maybe <- 0x1fc) (Int)
add %i1, 84, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P660: !_DWLD [7] (FP) (Branch target of P599)
ldd [%i1 + 80], %f0
! 2 addresses covered
ba P661
nop

TARGET599:
ba RET599
nop


P661: !_ST [7] (maybe <- 0x1fd) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P662: !_LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P663: !_DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P664: !_LD [3] (FP)
ld [%i0 + 32], %f2
! 1 addresses covered

P665: !_MEMBAR (Int)
membar #StoreLoad

P666: !_ST [5] (maybe <- 0x1fe) (Int) (Branch target of P202)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P667
nop

TARGET202:
ba RET202
nop


P667: !_DWST [0] (maybe <- 0x1ff) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P668: !_ST [13] (maybe <- 0x201) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET668
nop
RET668:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P669: !_SWAP [3] (maybe <- 0x202) (Int)
mov %l4, %o0
swap  [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P670: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P671: !_CASX [10] (maybe <- 0x203) (Int) (CBR)
add %i2, 32, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET671
nop
RET671:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P672: !_ST [7] (maybe <- 0x204) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P673: !_ST [1] (maybe <- 0x205) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P674: !_ST [8] (maybe <- 0x206) (Int) (Branch target of P687)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P675
nop

TARGET687:
ba RET687
nop


P675: !_ST [1] (maybe <- 0x207) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P676: !_ST [11] (maybe <- 0x208) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P677: !_ST [0] (maybe <- 0x209) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P678: !_ST [12] (maybe <- 0x20a) (Int) (Branch target of P104)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P679
nop

TARGET104:
ba RET104
nop


P679: !_ST [14] (maybe <- 0x20b) (Int) (Branch target of P57)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P680
nop

TARGET57:
ba RET57
nop


P680: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P681: !_ST [5] (maybe <- 0x20c) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P682: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P683: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %o5
or %o5, %lo(0x200),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P684: !_ST [0] (maybe <- 0x20d) (Int) (Branch target of P852)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P685
nop

TARGET852:
ba RET852
nop


P685: !_DWST [10] (maybe <- 0x20e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P686: !_DWST [0] (maybe <- 0x20f) (Int) (CBR)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET686
nop
RET686:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P687: !_ST [9] (maybe <- 0x211) (Int) (CBR) (Branch target of P806)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET687
nop
RET687:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P688
nop

TARGET806:
ba RET806
nop


P688: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l3
or %l3, %lo(0x4c),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P689: !_ST [14] (maybe <- 0x212) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P690: !_ST [4] (maybe <- 0x213) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P691: !_ST [2] (maybe <- 0x214) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P692: !_ST [9] (maybe <- 0x215) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P693: !_CASX [8] (maybe <- 0x216) (Int)
add %i1, 256, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %o5
or %o5, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l3
or %l3, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
add  %l4, 1, %l4

P694: !_ST [0] (maybe <- 0x217) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P695: !_DWLD [14] (Int)
ldx [%i3 + 128], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P696: !_DWST [1] (maybe <- 0x218) (Int) (CBR)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET696
nop
RET696:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P697: !_DWST [5] (maybe <- 0x21a) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P698: !_ST [8] (maybe <- 0x21b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P699: !_ST [2] (maybe <- 0x21c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P700: !_CAS [13] (maybe <- 0x21d) (Int)
add %i3, 64, %l7
lduw [%l7], %o0
mov %o0, %l6
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P701: !_ST [14] (maybe <- 0x21e) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P702: !_ST [8] (maybe <- 0x3f800032) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET702
nop
RET702:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P703: !_ST [12] (maybe <- 0x3f800033) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P704: !_ST [2] (maybe <- 0x21f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P705: !_CAS [1] (maybe <- 0x220) (Int)
add %i0, 4, %o5
lduw [%o5], %o1
mov %o1, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P706: !_LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P707: !_CASX [13] (maybe <- 0x221) (Int)
add %i3, 64, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l3
or %l3, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l6
or %l6, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
add  %l4, 1, %l4

P708: !_ST [7] (maybe <- 0x222) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P709: !_LD [9] (Int)
lduw [%i1 + 512], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P710: !_DWST [3] (maybe <- 0x223) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P711: !_DWST [15] (maybe <- 0x224) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P712: !_ST [0] (maybe <- 0x225) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P713: !_ST [2] (maybe <- 0x226) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P714: !_ST [8] (maybe <- 0x227) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P715: !_DWST [4] (maybe <- 0x228) (Int) (CBR) (Branch target of P994)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET715
nop
RET715:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P716
nop

TARGET994:
ba RET994
nop


P716: !_ST [6] (maybe <- 0x229) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P717: !_DWST [0] (maybe <- 0x22a) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET717
nop
RET717:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P718: !_DWST [2] (maybe <- 0x22c) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P719: !_DWST [2] (maybe <- 0x22d) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P720: !_ST [9] (maybe <- 0x3f800034) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET720
nop
RET720:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P721: !_ST [5] (maybe <- 0x22e) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P722: !_ST [14] (maybe <- 0x22f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P723: !_ST [8] (maybe <- 0x230) (Int) (Branch target of P918)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P724
nop

TARGET918:
ba RET918
nop


P724: !_DWST [13] (maybe <- 0x231) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P725: !_ST [13] (maybe <- 0x3f800035) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P726: !_ST [15] (maybe <- 0x232) (Int) (CBR) (Branch target of P763)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET726
nop
RET726:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P727
nop

TARGET763:
ba RET763
nop


P727: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l3
or %l3, %lo(0x4c),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P728: !_DWLD [4] (Int) (Branch target of P162)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)
ba P729
nop

TARGET162:
ba RET162
nop


P729: !_LD [9] (Int)
lduw [%i1 + 512], %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l7, %o0, %o0

P730: !_ST [5] (maybe <- 0x3f800036) (FP) (Branch target of P167)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]
ba P731
nop

TARGET167:
ba RET167
nop


P731: !_DWST [5] (maybe <- 0x233) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P732: !_DWST [3] (maybe <- 0x234) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET732
nop
RET732:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P733: !_DWST [10] (maybe <- 0x235) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P734: !_ST [4] (maybe <- 0x236) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P735: !_DWST [14] (maybe <- 0x3f800037) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET735
nop
RET735:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P736: !_CASX [2] (maybe <- 0x237) (Int)
add %i0, 8, %l3
ldx [%l3], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %o5
mov %l4, %o2
casx [%l3], %o5, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P737: !_DWST [6] (maybe <- 0x238) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P738: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P739: !_CASX [7] (maybe <- 0x23a) (Int)
add %i1, 80, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l6
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P740: !_ST [12] (maybe <- 0x23c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P741: !_ST [9] (maybe <- 0x23d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P742: !_DWLD [6] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P743: !_PREFETCH [12] (Int) (LE) (Branch target of P392)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1
ba P744
nop

TARGET392:
ba RET392
nop


P744: !_ST [10] (maybe <- 0x23e) (Int) (Branch target of P375)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P745
nop

TARGET375:
ba RET375
nop


P745: !_LD [4] (FP)
ld [%i0 + 64], %f3
! 1 addresses covered

P746: !_DWST [5] (maybe <- 0x23f) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P747: !_ST [10] (maybe <- 0x240) (Int) (CBR) (Branch target of P735)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET747
nop
RET747:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P748
nop

TARGET735:
ba RET735
nop


P748: !_NOP (Int)
nop

P749: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P750: !_DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P751: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P752: !_LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

P753: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P754: !_DWST [11] (maybe <- 0x241) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P755: !_ST [3] (maybe <- 0x242) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P756: !_DWLD [5] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i1 + 72] %asi, %l6
! move %l6(upper) -> %o2(upper)
or %l6, %g0, %o2

P757: !_ST [6] (maybe <- 0x243) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P758: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P759: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET759
nop
RET759:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P760: !_ST [3] (maybe <- 0x3f800038) (FP) (Branch target of P103)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]
ba P761
nop

TARGET103:
ba RET103
nop


P761: !_ST [9] (maybe <- 0x244) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P762: !_LD [0] (Int)
lduw [%i0 + 0], %l3
! move %l3(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l3, %o2, %o2

P763: !_ST [15] (maybe <- 0x245) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET763
nop
RET763:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P764: !_ST [14] (maybe <- 0x246) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P765: !_DWLD [8] (Int)
ldx [%i1 + 256], %o3
! move %o3(upper) -> %o3(upper)

P766: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P767: !_ST [4] (maybe <- 0x247) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P768: !_DWLD [2] (Int)
ldx [%i0 + 8], %l7
! move %l7(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %l7, 0, %l6
or %l6, %o3, %o3

P769: !_DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P770: !_DWST [2] (maybe <- 0x248) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P771: !_ST [7] (maybe <- 0x249) (Int) (Branch target of P416)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P772
nop

TARGET416:
ba RET416
nop


P772: !_DWST [4] (maybe <- 0x24a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P773: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P774: !_ST [4] (maybe <- 0x24b) (Int) (Branch target of P587)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P775
nop

TARGET587:
ba RET587
nop


P775: !_DWST [14] (maybe <- 0x24c) (Int) (Branch target of P504)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4
ba P776
nop

TARGET504:
ba RET504
nop


P776: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P777: !_ST [10] (maybe <- 0x24d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P778: !_CASX [8] (maybe <- 0x24e) (Int)
add %i1, 256, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P779: !_ST [12] (maybe <- 0x24f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P780: !_DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P781: !_CAS [11] (maybe <- 0x250) (Int)
add %i2, 64, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P782: !_DWST [2] (maybe <- 0x251) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P783: !_ST [4] (maybe <- 0x252) (Int) (Branch target of P613)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P784
nop

TARGET613:
ba RET613
nop


P784: !_DWST [2] (maybe <- 0x253) (Int) (Branch target of P566)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4
ba P785
nop

TARGET566:
ba RET566
nop


P785: !_DWST [8] (maybe <- 0x254) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P786: !_ST [7] (maybe <- 0x255) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P787: !_DWLD [8] (FP)
ldd [%i1 + 256], %f4
! 1 addresses covered

P788: !_ST [10] (maybe <- 0x256) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P789: !_DWST [9] (maybe <- 0x257) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P790: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P791: !_ST [7] (maybe <- 0x258) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P792: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P793: !_DWST [11] (maybe <- 0x259) (Int) (Branch target of P598)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P794
nop

TARGET598:
ba RET598
nop


P794: !_ST [7] (maybe <- 0x25a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P795: !_MEMBAR (Int)
membar #StoreLoad

P796: !_ST [5] (maybe <- 0x25b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P797: !_ST [13] (maybe <- 0x25c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P798: !_CASX [3] (maybe <- 0x25d) (Int)
add %i0, 32, %o5
ldx [%o5], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l7
sllx %l4, 32, %o0
casx [%o5], %l7, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P799: !_ST [5] (maybe <- 0x25e) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P800: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P801: !_ST [0] (maybe <- 0x25f) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P802: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P803: !_ST [1] (maybe <- 0x260) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 4] %asi
add   %l4, 1, %l4

P804: !_CASX [11] (maybe <- 0x261) (Int) (CBR) (Branch target of P205)
add %i2, 64, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l7
sllx %l4, 32, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET804
nop
RET804:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P805
nop

TARGET205:
ba RET205
nop


P805: !_CAS [15] (maybe <- 0x262) (Int)
add %i3, 192, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P806: !_ST [1] (maybe <- 0x263) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET806
nop
RET806:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P807: !_ST [6] (maybe <- 0x3f800039) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P808: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l7
or %l7, %lo(0x100),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P809: !_ST [10] (maybe <- 0x264) (Int) (CBR) (Branch target of P195)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET809
nop
RET809:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P810
nop

TARGET195:
ba RET195
nop


P810: !_ST [11] (maybe <- 0x3f80003a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P811: !_DWST [11] (maybe <- 0x265) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P812: !_ST [0] (maybe <- 0x266) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P813: !_CAS [0] (maybe <- 0x267) (Int)
add %i0, 0, %o5
lduw [%o5], %o4
mov %o4, %l7
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o4(lower)
srl %l6, 0, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P814: !_DWST [4] (maybe <- 0x268) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P815: !_DWST [2] (maybe <- 0x269) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P816: !_ST [7] (maybe <- 0x26a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P817: !_ST [0] (maybe <- 0x26b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P818: !_DWST [6] (maybe <- 0x26c) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P819: !_ST [8] (maybe <- 0x26e) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P820: !_DWST [2] (maybe <- 0x26f) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P821: !_DWST [12] (maybe <- 0x270) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET821
nop
RET821:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P822: !_ST [11] (maybe <- 0x271) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P823: !_ST [3] (maybe <- 0x272) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P824: !_REPLACEMENT [5] (Int) (Branch target of P314)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
ba P825
nop

TARGET314:
ba RET314
nop


P825: !_DWST [12] (maybe <- 0x273) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P826: !_DWST [14] (maybe <- 0x274) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P827: !_ST [12] (maybe <- 0x275) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P828: !_ST [3] (maybe <- 0x276) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 32] %asi
add   %l4, 1, %l4

P829: !_LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P830: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l7
or %l7, %lo(0x4c),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P831: !_ST [14] (maybe <- 0x277) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P832: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P833: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %l3
or %l3, %lo(0x80),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P834: !_DWST [2] (maybe <- 0x278) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P835: !_ST [0] (maybe <- 0x279) (Int) (Branch target of P593)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P836
nop

TARGET593:
ba RET593
nop


P836: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P837: !_CAS [8] (maybe <- 0x27a) (Int)
add %i1, 256, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P838: !_ST [13] (maybe <- 0x27b) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P839: !_ST [12] (maybe <- 0x3f80003b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P840: !_DWLD [0] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %o5
or %o5, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2

P841: !_CAS [14] (maybe <- 0x27c) (Int) (CBR)
add %i3, 128, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET841
nop
RET841:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P842: !_DWST [14] (maybe <- 0x27d) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P843: !_ST [13] (maybe <- 0x27e) (Int) (CBR) (Branch target of P804)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET843
nop
RET843:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P844
nop

TARGET804:
ba RET804
nop


P844: !_DWLD [1] (Int) (CBR)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l6
or %l6, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET844
nop
RET844:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P845: !_DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P846: !_SWAP [6] (maybe <- 0x27f) (Int) (CBR)
mov %l4, %o0
swap  [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET846
nop
RET846:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P847: !_DWST [2] (maybe <- 0x280) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P848: !_DWST [5] (maybe <- 0x281) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P849: !_DWST [13] (maybe <- 0x282) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P850: !_ST [9] (maybe <- 0x283) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET850
nop
RET850:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P851: !_DWST [2] (maybe <- 0x284) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P852: !_DWST [3] (maybe <- 0x285) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET852
nop
RET852:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P853: !_ST [6] (maybe <- 0x286) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P854: !_ST [14] (maybe <- 0x287) (Int) (Branch target of P321)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P855
nop

TARGET321:
ba RET321
nop


P855: !_ST [14] (maybe <- 0x288) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P856: !_ST [14] (maybe <- 0x289) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P857: !_DWLD [14] (Int)
ldx [%i3 + 128], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l7
or %l7, %o0, %o0

P858: !_ST [0] (maybe <- 0x28a) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P859: !_ST [6] (maybe <- 0x3f80003c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P860: !_DWST [7] (maybe <- 0x3f80003d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P861: !_ST [10] (maybe <- 0x28b) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P862: !_ST [13] (maybe <- 0x28c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P863: !_ST [4] (maybe <- 0x28d) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P864: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P865: !_LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P866: !_DWST [14] (maybe <- 0x3f80003f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P867: !_ST [14] (maybe <- 0x28e) (Int) (Branch target of P747)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P868
nop

TARGET747:
ba RET747
nop


P868: !_ST [10] (maybe <- 0x28f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P869: !_ST [11] (maybe <- 0x290) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P870: !_ST [6] (maybe <- 0x291) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P871: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P872: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P873: !_ST [6] (maybe <- 0x292) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P874: !_ST [5] (maybe <- 0x293) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P875: !_ST [6] (maybe <- 0x294) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P876: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P877: !_LD [7] (FP)
ld [%i1 + 84], %f5
! 1 addresses covered

P878: !_ST [5] (maybe <- 0x295) (Int) (Branch target of P511)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P879
nop

TARGET511:
ba RET511
nop


P879: !_DWST [1] (maybe <- 0x296) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P880: !_ST [4] (maybe <- 0x298) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P881: !_ST [15] (maybe <- 0x299) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P882: !_ST [1] (maybe <- 0x3f800040) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P883: !_DWST [5] (maybe <- 0x29a) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P884: !_ST [13] (maybe <- 0x3f800041) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P885: !_CASX [11] (maybe <- 0x29b) (Int) (CBR) (Branch target of P821)
add %i2, 64, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET885
nop
RET885:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P886
nop

TARGET821:
ba RET821
nop


P886: !_CAS [0] (maybe <- 0x29c) (Int)
add %i0, 0, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3
mov %l4, %o4
cas [%l6], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P887: !_DWST [13] (maybe <- 0x29d) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P888: !_DWST [12] (maybe <- 0x3f800042) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P889: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P890: !_ST [1] (maybe <- 0x29e) (Int) (Branch target of P216)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P891
nop

TARGET216:
ba RET216
nop


P891: !_DWST [0] (maybe <- 0x29f) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P892: !_ST [9] (maybe <- 0x2a1) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P893: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P894: !_ST [11] (maybe <- 0x2a2) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P895: !_CAS [1] (maybe <- 0x2a3) (Int)
add %i0, 4, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P896: !_DWST [13] (maybe <- 0x2a4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P897: !_CAS [2] (maybe <- 0x2a5) (Int)
add %i0, 12, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0
mov %l4, %o1
cas [%l6], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P898: !_DWST [2] (maybe <- 0x2a6) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P899: !_CASX [0] (maybe <- 0x2a7) (Int)
add %i0, 0, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l7, %o5
sllx %l4, 32, %l7
add  %l4, 1, %l4
or   %l4, %l7, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

P900: !_DWST [12] (maybe <- 0x2a9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P901: !_DWST [9] (maybe <- 0x2aa) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i1 + 512 ] %asi
add   %l4, 1, %l4

P902: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P903: !_LD [3] (Int)
lduw [%i0 + 32], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P904: !_CAS [4] (maybe <- 0x2ab) (Int)
add %i0, 64, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P905: !_DWLD [4] (Int) (Branch target of P600)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)
ba P906
nop

TARGET600:
ba RET600
nop


P906: !_ST [15] (maybe <- 0x3f800043) (FP) (Branch target of P649)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]
ba P907
nop

TARGET649:
ba RET649
nop


P907: !_ST [1] (maybe <- 0x2ac) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P908: !_DWLD [1] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l3, 32, %o5
or %o5, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1

P909: !_ST [6] (maybe <- 0x2ad) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P910: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P911: !_SWAP [0] (maybe <- 0x2ae) (Int)
mov %l4, %l7
swap  [%i0 + 0], %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P912: !_ST [10] (maybe <- 0x2af) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P913: !_DWST [6] (maybe <- 0x2b0) (Int) (Branch target of P759)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4
ba P914
nop

TARGET759:
ba RET759
nop


P914: !_ST [11] (maybe <- 0x2b2) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P915: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P916: !_DWST [5] (maybe <- 0x3f800044) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P917: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P918: !_ST [5] (maybe <- 0x2b3) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET918
nop
RET918:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P919: !_ST [4] (maybe <- 0x2b4) (Int) (CBR)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET919
nop
RET919:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P920: !_PREFETCH [2] (Int) (CBR)
prefetch [%i0 + 12], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET920
nop
RET920:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P921: !_LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P922: !_DWST [8] (maybe <- 0x2b5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P923: !_ST [1] (maybe <- 0x2b6) (Int) (Branch target of P732)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P924
nop

TARGET732:
ba RET732
nop


P924: !_DWST [4] (maybe <- 0x2b7) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P925: !_PREFETCH [14] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 128] %asi, 1

P926: !_DWST [9] (maybe <- 0x2b8) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P927: !_ST [1] (maybe <- 0x2b9) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 4] %asi
add   %l4, 1, %l4

P928: !_ST [6] (maybe <- 0x2ba) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P929: !_LD [0] (Int) (CBR)
lduw [%i0 + 0], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET929
nop
RET929:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P930: !_DWST [12] (maybe <- 0x2bb) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P931: !_ST [11] (maybe <- 0x2bc) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P932: !_ST [13] (maybe <- 0x2bd) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P933: !_ST [15] (maybe <- 0x2be) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 192] %asi
add   %l4, 1, %l4

P934: !_CAS [15] (maybe <- 0x2bf) (Int)
add %i3, 192, %o5
lduw [%o5], %o3
mov %o3, %l7
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

P935: !_ST [14] (maybe <- 0x2c0) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P936: !_CASX [9] (maybe <- 0x2c1) (Int)
add %i1, 512, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l6
sllx %l4, 32, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P937: !_ST [5] (maybe <- 0x2c2) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P938: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P939: !_CAS [11] (maybe <- 0x2c3) (Int)
add %i2, 64, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P940: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P941: !_ST [7] (maybe <- 0x3f800045) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P942: !_DWST [11] (maybe <- 0x2c4) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P943: !_ST [1] (maybe <- 0x3f800046) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P944: !_DWST [4] (maybe <- 0x2c5) (Int) (Branch target of P668)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P945
nop

TARGET668:
ba RET668
nop


P945: !_ST [1] (maybe <- 0x2c6) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P946: !_ST [8] (maybe <- 0x2c7) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P947: !_ST [10] (maybe <- 0x3f800047) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P948: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P949: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P950: !_ST [11] (maybe <- 0x2c8) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P951: !_NOP (Int)
nop

P952: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P953: !_PREFETCH [9] (Int) (Branch target of P671)
prefetch [%i1 + 512], 1
ba P954
nop

TARGET671:
ba RET671
nop


P954: !_ST [2] (maybe <- 0x2c9) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P955: !_ST [7] (maybe <- 0x2ca) (Int) (Branch target of P337)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P956
nop

TARGET337:
ba RET337
nop


P956: !_NOP (Int)
nop

P957: !_ST [7] (maybe <- 0x2cb) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P958: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P959: !_DWST [14] (maybe <- 0x2cc) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P960: !_DWST [1] (maybe <- 0x2cd) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P961: !_REPLACEMENT [9] (Int) (CBR)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET961
nop
RET961:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P962: !_DWLD [3] (Int)
ldx [%i0 + 32], %o2
! move %o2(upper) -> %o2(upper)

P963: !_ST [12] (maybe <- 0x2cf) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P964: !_ST [10] (maybe <- 0x2d0) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P965: !_DWST [14] (maybe <- 0x2d1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P966: !_DWST [14] (maybe <- 0x2d2) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P967: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %o5
or %o5, %lo(0x100),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P968: !_ST [0] (maybe <- 0x2d3) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P969: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P970: !_DWST [1] (maybe <- 0x2d4) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P971: !_DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l3
or %l3, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3

P972: !_DWLD [15] (Int) (CBR)
ldx [%i3 + 192], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l7
or %l7, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET972
nop
RET972:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P973: !_ST [10] (maybe <- 0x2d6) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P974: !_ST [7] (maybe <- 0x2d7) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P975: !_ST [7] (maybe <- 0x2d8) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P976: !_CASX [7] (maybe <- 0x2d9) (Int)
add %i1, 80, %o5
ldx [%o5], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %o4, %l7
sllx %l4, 32, %o0
add  %l4, 1, %l4
or   %l4, %o0, %o0
casx [%o5], %l7, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P977: !_ST [8] (maybe <- 0x2db) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P978: !_DWST [5] (maybe <- 0x2dc) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P979: !_DWST [9] (maybe <- 0x2dd) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P980: !_ST [12] (maybe <- 0x2de) (Int) (Branch target of P647)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P981
nop

TARGET647:
ba RET647
nop


P981: !_CAS [9] (maybe <- 0x2df) (Int)
add %i1, 512, %o5
lduw [%o5], %o1
mov %o1, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P982: !_ST [0] (maybe <- 0x2e0) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET982
nop
RET982:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P983: !_DWST [14] (maybe <- 0x2e1) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P984: !_ST [4] (maybe <- 0x2e2) (Int) (Branch target of P443)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P985
nop

TARGET443:
ba RET443
nop


P985: !_LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P986: !_ST [9] (maybe <- 0x3f800048) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P987: !_DWLD [11] (Int)
ldx [%i2 + 64], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2

P988: !_CAS [13] (maybe <- 0x2e3) (Int)
add %i3, 64, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P989: !_DWST [0] (maybe <- 0x2e4) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P990: !_DWST [8] (maybe <- 0x2e6) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i1 + 256 ] %asi
add   %l4, 1, %l4

P991: !_DWST [5] (maybe <- 0x2e7) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P992: !_ST [0] (maybe <- 0x2e8) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P993: !_DWST [4] (maybe <- 0x2e9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P994: !_DWST [0] (maybe <- 0x3f800049) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET994
nop
RET994:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P995: !_DWST [15] (maybe <- 0x2ea) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P996: !_ST [0] (maybe <- 0x2eb) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P997: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P998: !_DWST [9] (maybe <- 0x2ec) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET998
nop
RET998:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P999: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l3
or %l3, %lo(0x4),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1000: !_DWST [3] (maybe <- 0x2ed) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P1001: !_DWST [5] (maybe <- 0x2ee) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P1002: !_CASX [8] (maybe <- 0x2ef) (Int)
add %i1, 256, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l6
sllx %l4, 32, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P1003: !_ST [13] (maybe <- 0x2f0) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1004: !_CASX [0] (maybe <- 0x2f1) (Int) (Branch target of P547)
add %i0, 0, %l6
ldx [%l6], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l3
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l6], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4
ba P1005
nop

TARGET547:
ba RET547
nop


P1005: !_DWST [2] (maybe <- 0x3f80004b) (FP) (Branch target of P393)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]
ba P1006
nop

TARGET393:
ba RET393
nop


P1006: !_NOP (Int)
nop

P1007: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1008: !_DWST [1] (maybe <- 0x2f3) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P1009: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1010: !_LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1011: !_DWST [11] (maybe <- 0x3f80004c) (FP) (Branch target of P1018)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]
ba P1012
nop

TARGET1018:
ba RET1018
nop


P1012: !_ST [4] (maybe <- 0x2f5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1013: !_ST [6] (maybe <- 0x2f6) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1014: !_CAS [6] (maybe <- 0x2f7) (Int) (CBR)
add %i1, 80, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1014
nop
RET1014:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1015: !_ST [6] (maybe <- 0x2f8) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1016: !_MEMBAR (Int) (CBR)
membar #StoreLoad

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1016
nop
RET1016:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1017: !_LD [0] (Int)
lduw [%i0 + 0], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1018: !_LD [1] (Int) (CBR)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1018
nop
RET1018:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1019: !_LD [2] (Int)
lduw [%i0 + 12], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P1020: !_LD [3] (Int) (CBR)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1020
nop
RET1020:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1021: !_LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P1022: !_LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1023: !_LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1024: !_LD [7] (FP)
ld [%i1 + 84], %f6
! 1 addresses covered

P1025: !_LD [8] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i1 + 256] %asi, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1026: !_LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1027: !_LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1028: !_LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1029: !_LD [12] (FP)
ld [%i3 + 0], %f7
! 1 addresses covered

P1030: !_LD [13] (FP)
ld [%i3 + 64], %f8
! 1 addresses covered

P1031: !_LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1032: !_LD [15] (Int) (Branch target of P961)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
ba END_NODES0
nop

TARGET961:
ba RET961
nop


END_NODES0: ! Test istream for CPU 0 ends
sethi %hi(0xdead0e0f), %l7
or    %l7, %lo(0xdead0e0f), %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
stw %l7, [%i5] 
ld [%i5], %f9
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30

restore
retl
nop
!-----------------

! register usage:
! %i0 %i1 %i2 %i3 : base registers for 4 regions
! %i4 fixed pointer to per-cpu results area
! %l1 moving pointer to per-cpu FP results area
! %o7 moving pointer to per-cpu integer results area
! %i5 pointer to per-cpu private area
! %l0 holds lfsr, used as source of random bits 
! %l2 loop count register
! %f16 running counter for unique fp store values
! %f17 holds increment value for fp counter
! %l4 running counter for unique integer store values (increment value is always 1)
! %l5 move-to register for load values (simulation only)
! %f30 move-to register for FP values (simulation only)
! %l3 %l6 %l7 %o5 : 4 temporary registers
! %o0 %o1 %o2 %o3 %o4 : 5 integer results buffer registers
! %f0-f15 FP results buffer registers
! %f32-f47 FP block load/store registers

func1:
! 1000 (dynamic) instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
andn %i0, 63, %i0

add %i1, 63, %i1
andn %i1, 63, %i1

add %i2, 63, %i2
andn %i2, 63, %i2

add %i3, 63, %i3
andn %i3, 63, %i3

add %i4, 63, %i4
andn %i4, 63, %i4

add %i5, 63, %i5
andn %i5, 63, %i5


! Initialize pointer to FP load results area
mov   %i4, %l1

! Initialize pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
add  %o7, %l1, %o7 

! Initialize %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l6
or    %l6, %lo(0xdeadbee0), %l6
stw   %l6, [%i5]
sethi %hi(0xdeadbee1), %l6
or    %l6, %lo(0xdeadbee1), %l6
stw   %l6, [%i5+4]
ldd [%i5], %f0
fmovd %f0, %f2
fmovd %f0, %f4
fmovd %f0, %f6
fmovd %f0, %f8
fmovd %f0, %f10
fmovd %f0, %f12
fmovd %f0, %f14
fmovd %f0, %f16
fmovd %f0, %f18
fmovd %f0, %f20
fmovd %f0, %f22
fmovd %f0, %f24
fmovd %f0, %f26
fmovd %f0, %f28
fmovd %f0, %f30
fmovd %f0, %f32
fmovd %f0, %f34
fmovd %f0, %f36
fmovd %f0, %f38
fmovd %f0, %f40
fmovd %f0, %f42
fmovd %f0, %f44
fmovd %f0, %f46
fmovd %f0, %f48
fmovd %f0, %f50
fmovd %f0, %f52
fmovd %f0, %f54
fmovd %f0, %f56
fmovd %f0, %f58
fmovd %f0, %f60
fmovd %f0, %f62

! Signature for extract_loads script to start extracting load values for this stream
sethi %hi(0x01deade1), %l6
or    %l6, %lo(0x01deade1), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x800001), %l4
or    %l4, %lo(0x800001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x40000001), %l6
or    %l6, %lo(0x40000001), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x34800000), %l6
or    %l6, %lo(0x34800000), %l6
stw %l6, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x3f76^4
sethi %hi(0x3f76), %l0
or    %l0, %lo(0x3f76), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 2 to 3 ---
stx %g0, [%i0+8]
stx %g0, [%i0+32]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l7
add %i3, %l7, %l7
sub %l7, -4096, %l7

!-- begin of sync_init ---
or %g0, 1, %o5
or %g0, %o5, %l3
swap [%l7+4], %l3
membar #Sync
sync_init_1_1:
brnz,pt %o5, sync_init_1_1
lduw [%l7+4], %o5 ! delay slot
sync_init_2_1:
lduw [%l7], %o5
sub %o5, 1, %l3
cas [%l7], %o5, %l3
cmp %o5, %l3
bne,pt %xcc, sync_init_2_1
nop
membar #Sync
sync_init_3_1:
lduw [%l7], %o5 ! delay slot
brnz,pt %o5, sync_init_3_1
nop
!-- end of sync_init ---


BEGIN_NODES1: ! Test istream for CPU 1 begins

P1033: !_ST [10] (maybe <- 0x800001) (Int) (Loop entry)
sethi %hi(0x1), %l2
or %l2, %lo(0x1),  %l2
loop_entry_1_0:
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1034: !_ST [14] (maybe <- 0x800002) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1035: !_CAS [11] (maybe <- 0x800003) (Int) (Branch target of P1129)
add %i2, 64, %l3
lduw [%l3], %o0
mov %o0, %o5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4
ba P1036
nop

TARGET1129:
ba RET1129
nop


P1036: !_DWST [14] (maybe <- 0x40000001) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P1037: !_PREFETCH [9] (Int) (Branch target of P1358)
prefetch [%i1 + 512], 1
ba P1038
nop

TARGET1358:
ba RET1358
nop


P1038: !_ST [9] (maybe <- 0x800004) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1039: !_DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P1040: !_ST [5] (maybe <- 0x800005) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1041: !_LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1042: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1042
nop
RET1042:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1043: !_CAS [10] (maybe <- 0x800006) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
wr %g0, 0x88, %asi
add %i2, 32, %l7
lduwa [%l7] %asi, %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
mov %o5, %o3
casa [%l7] %asi, %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1044: !_ST [14] (maybe <- 0x800007) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1045: !_ST [14] (maybe <- 0x800008) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1046: !_ST [12] (maybe <- 0x800009) (Int) (Branch target of P1163)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P1047
nop

TARGET1163:
ba RET1163
nop


P1047: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l7
or %l7, %lo(0x4),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1048: !_DWST [0] (maybe <- 0x80000a) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P1049: !_DWLD [12] (FP)
ldd [%i3 + 0], %f0
! 1 addresses covered

P1050: !_ST [10] (maybe <- 0x80000c) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1051: !_ST [5] (maybe <- 0x80000d) (Int) (Branch target of P1555)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P1052
nop

TARGET1555:
ba RET1555
nop


P1052: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P1053: !_DWST [2] (maybe <- 0x80000e) (Int) (Branch target of P1331)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4
ba P1054
nop

TARGET1331:
ba RET1331
nop


P1054: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1055: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1056: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1057: !_ST [2] (maybe <- 0x80000f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1058: !_ST [4] (maybe <- 0x800010) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1059: !_ST [9] (maybe <- 0x800011) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1060: !_DWST [12] (maybe <- 0x800012) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P1061: !_NOP (Int)
nop

P1062: !_CASX [15] (maybe <- 0x800013) (Int) (CBR)
add %i3, 192, %l3
ldx [%l3], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %o5
sllx %l4, 32, %o0
casx [%l3], %o5, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1062
nop
RET1062:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1063: !_LD [14] (Int)
lduw [%i3 + 128], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1064: !_ST [0] (maybe <- 0x800014) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1065: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P1066: !_ST [9] (maybe <- 0x40000002) (FP) (Branch target of P1581)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]
ba P1067
nop

TARGET1581:
ba RET1581
nop


P1067: !_ST [4] (maybe <- 0x800015) (Int) (CBR)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1067
nop
RET1067:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1068: !_LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1069: !_ST [7] (maybe <- 0x800016) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1070: !_ST [9] (maybe <- 0x800017) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1071: !_DWST [12] (maybe <- 0x800018) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P1072: !_DWST [10] (maybe <- 0x800019) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1072
nop
RET1072:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1073: !_DWLD [5] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i1 + 72] %asi, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2

P1074: !_DWST [12] (maybe <- 0x80001a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1075: !_ST [9] (maybe <- 0x80001b) (Int) (Branch target of P1297)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P1076
nop

TARGET1297:
ba RET1297
nop


P1076: !_DWST [15] (maybe <- 0x80001c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1077: !_REPLACEMENT [3] (Int) (CBR)
sethi %hi(0x20), %l3
or %l3, %lo(0x20),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1077
nop
RET1077:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1078: !_DWLD [4] (Int)
ldx [%i0 + 64], %o3
! move %o3(upper) -> %o3(upper)

P1079: !_DWST [1] (maybe <- 0x80001d) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1080: !_MEMBAR (Int)
membar #StoreLoad

P1081: !_MEMBAR (Int)
membar #StoreLoad

P1082: !_DWLD [1] (Int) (CBR)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l7, 32, %l6
or %l6, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1082
nop
RET1082:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1083: !_ST [11] (maybe <- 0x80001f) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1084: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %o5
or %o5, %lo(0x80),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1085: !_DWLD [13] (Int)
ldx [%i3 + 64], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1086: !_ST [10] (maybe <- 0x800020) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1087: !_ST [0] (maybe <- 0x800021) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1088: !_DWST [13] (maybe <- 0x800022) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P1089: !_ST [2] (maybe <- 0x800023) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1090: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1091: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1092: !_ST [1] (maybe <- 0x800024) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1093: !_DWST [2] (maybe <- 0x800025) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P1094: !_ST [0] (maybe <- 0x800026) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1094
nop
RET1094:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1095: !_CAS [2] (maybe <- 0x800027) (Int) (Branch target of P1600)
add %i0, 12, %o5
lduw [%o5], %o0
mov %o0, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4
ba P1096
nop

TARGET1600:
ba RET1600
nop


P1096: !_PREFETCH [9] (Int) (CBR)
prefetch [%i1 + 512], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1096
nop
RET1096:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1097: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1098: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %o5
or %o5, %lo(0x100),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1099: !_LD [3] (Int)
lduw [%i0 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1100: !_DWST [15] (maybe <- 0x800028) (Int) (LE) (Branch target of P1594)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i3 + 192 ] %asi
add   %l4, 1, %l4
ba P1101
nop

TARGET1594:
ba RET1594
nop


P1101: !_ST [6] (maybe <- 0x800029) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1102: !_DWLD [9] (Int)
ldx [%i1 + 512], %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l7
or %l7, %o1, %o1

P1103: !_CASX [13] (maybe <- 0x80002a) (Int)
add %i3, 64, %l6
ldx [%l6], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %l3
sllx %l4, 32, %o3
casx [%l6], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P1104: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1105: !_ST [4] (maybe <- 0x80002b) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1106: !_LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1107: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1108: !_ST [8] (maybe <- 0x80002c) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1109: !_ST [8] (maybe <- 0x80002d) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1110: !_CASX [2] (maybe <- 0x80002e) (Int) (Branch target of P1761)
add %i0, 8, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o4(lower)
srlx %l7, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov  %l7, %o5
mov %l4, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l3
or %l3, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
add  %l4, 1, %l4
ba P1111
nop

TARGET1761:
ba RET1761
nop


P1111: !_DWST [5] (maybe <- 0x80002f) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P1112: !_ST [2] (maybe <- 0x800030) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1113: !_DWST [0] (maybe <- 0x800031) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P1114: !_MEMBAR (Int)
membar #StoreLoad

P1115: !_ST [11] (maybe <- 0x800033) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1116: !_ST [15] (maybe <- 0x800034) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1117: !_PREFETCH [1] (Int) (CBR)
prefetch [%i0 + 4], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1117
nop
RET1117:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1118: !_ST [12] (maybe <- 0x800035) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1118
nop
RET1118:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1119: !_ST [15] (maybe <- 0x800036) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1120: !_ST [1] (maybe <- 0x800037) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1120
nop
RET1120:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1121: !_DWST [4] (maybe <- 0x800038) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P1122: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1123: !_DWLD [6] (Int) (Branch target of P1508)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
ba P1124
nop

TARGET1508:
ba RET1508
nop


P1124: !_ST [3] (maybe <- 0x800039) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1125: !_DWST [12] (maybe <- 0x80003a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1126: !_DWST [1] (maybe <- 0x80003b) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1127: !_ST [0] (maybe <- 0x80003d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1128: !_ST [7] (maybe <- 0x80003e) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1129: !_PREFETCH [1] (Int) (CBR)
prefetch [%i0 + 4], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1129
nop
RET1129:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1130: !_ST [11] (maybe <- 0x80003f) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1131: !_ST [10] (maybe <- 0x800040) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1132: !_ST [5] (maybe <- 0x40000003) (FP) (CBR) (Branch target of P1630)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1132
nop
RET1132:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P1133
nop

TARGET1630:
ba RET1630
nop


P1133: !_ST [2] (maybe <- 0x800041) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1134: !_ST [11] (maybe <- 0x800042) (Int) (Branch target of P1096)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P1135
nop

TARGET1096:
ba RET1096
nop


P1135: !_CASX [14] (maybe <- 0x800043) (Int)
add %i3, 128, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %o5
or %o5, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
add  %l4, 1, %l4

P1136: !_NOP (Int)
nop

P1137: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1138: !_DWST [1] (maybe <- 0x800044) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1139: !_DWST [12] (maybe <- 0x40000004) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P1140: !_DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o4(lower)
srl %l6, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1141: !_ST [3] (maybe <- 0x800046) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1142: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1143: !_ST [2] (maybe <- 0x800047) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1144: !_ST [15] (maybe <- 0x800048) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1145: !_ST [10] (maybe <- 0x800049) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1146: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1147: !_DWST [0] (maybe <- 0x80004a) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1148: !_CASX [15] (maybe <- 0x80004c) (Int)
add %i3, 192, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
sllx %l4, 32, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P1149: !_DWLD [0] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1150: !_ST [3] (maybe <- 0x40000005) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P1151: !_DWST [12] (maybe <- 0x40000006) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P1152: !_ST [2] (maybe <- 0x80004d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1153: !_DWST [11] (maybe <- 0x80004e) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P1154: !_PREFETCH [6] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 80] %asi, 1

P1155: !_ST [1] (maybe <- 0x80004f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1156: !_ST [13] (maybe <- 0x800050) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1157: !_ST [3] (maybe <- 0x800051) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1158: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %l3
or %l3, %lo(0x0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1159: !_LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1160: !_ST [11] (maybe <- 0x800052) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1161: !_CASX [6] (maybe <- 0x800053) (Int)
add %i1, 80, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l3
or %l3, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
add  %l4, 1, %l4

P1162: !_DWST [4] (maybe <- 0x800055) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i0 + 64 ] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1162
nop
RET1162:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1163: !_DWST [15] (maybe <- 0x800056) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1163
nop
RET1163:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1164: !_DWST [3] (maybe <- 0x800057) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P1165: !_ST [3] (maybe <- 0x800058) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1166: !_CAS [9] (maybe <- 0x800059) (Int)
add %i1, 512, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1167: !_CAS [0] (maybe <- 0x80005a) (Int)
add %i0, 0, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1
mov %l4, %o2
cas [%o5], %l7, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1168: !_ST [12] (maybe <- 0x80005b) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1169: !_ST [15] (maybe <- 0x80005c) (Int) (Branch target of P1939)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P1170
nop

TARGET1939:
ba RET1939
nop


P1170: !_ST [3] (maybe <- 0x80005d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1171: !_ST [5] (maybe <- 0x80005e) (Int) (Branch target of P1120)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P1172
nop

TARGET1120:
ba RET1120
nop


P1172: !_ST [8] (maybe <- 0x80005f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1173: !_DWST [9] (maybe <- 0x800060) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1174: !_DWST [8] (maybe <- 0x800061) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P1175: !_ST [2] (maybe <- 0x800062) (Int) (Branch target of P1647)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
ba P1176
nop

TARGET1647:
ba RET1647
nop


P1176: !_ST [3] (maybe <- 0x800063) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1177: !_ST [11] (maybe <- 0x40000007) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1178: !_ST [13] (maybe <- 0x800064) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1179: !_ST [11] (maybe <- 0x800065) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1180: !_DWST [5] (maybe <- 0x800066) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P1181: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1182: !_ST [9] (maybe <- 0x800067) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1183: !_LD [1] (FP)
ld [%i0 + 4], %f1
! 1 addresses covered

P1184: !_DWLD [2] (Int)
ldx [%i0 + 8], %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %o5
or %o5, %o2, %o2

P1185: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1186: !_CAS [9] (maybe <- 0x800068) (Int)
add %i1, 512, %l6
lduw [%l6], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P1187: !_ST [4] (maybe <- 0x800069) (Int) (CBR)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1187
nop
RET1187:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1188: !_CAS [8] (maybe <- 0x80006a) (Int)
add %i1, 256, %l6
lduw [%l6], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P1189: !_ST [11] (maybe <- 0x80006b) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1190: !_LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1191: !_LD [0] (Int)
lduw [%i0 + 0], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P1192: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1193: !_ST [1] (maybe <- 0x80006c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1194: !_DWLD [3] (FP)
ldd [%i0 + 32], %f2
! 1 addresses covered

P1195: !_ST [9] (maybe <- 0x80006d) (Int) (LE) (Branch target of P1217)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i1 + 512] %asi
add   %l4, 1, %l4
ba P1196
nop

TARGET1217:
ba RET1217
nop


P1196: !_LD [9] (Int)
lduw [%i1 + 512], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1197: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1198: !_CASX [6] (maybe <- 0x80006e) (Int)
add %i1, 80, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l7, %o5
sllx %l4, 32, %l7
add  %l4, 1, %l4
or   %l4, %l7, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

P1199: !_LD [9] (Int)
lduw [%i1 + 512], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

P1200: !_ST [3] (maybe <- 0x800070) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1201: !_ST [6] (maybe <- 0x800071) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1202: !_ST [2] (maybe <- 0x800072) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 12] %asi
add   %l4, 1, %l4

P1203: !_DWST [10] (maybe <- 0x800073) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P1204: !_DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1205: !_ST [15] (maybe <- 0x800074) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1206: !_ST [14] (maybe <- 0x800075) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1207: !_LD [9] (Int)
lduw [%i1 + 512], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1208: !_CASX [4] (maybe <- 0x800076) (Int)
add %i0, 64, %l3
ldx [%l3], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %o5
sllx %l4, 32, %o1
casx [%l3], %o5, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P1209: !_ST [3] (maybe <- 0x800077) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1210: !_ST [3] (maybe <- 0x40000008) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P1211: !_CAS [10] (maybe <- 0x800078) (Int)
add %i2, 32, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1212: !_ST [6] (maybe <- 0x800079) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1213: !_ST [15] (maybe <- 0x80007a) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1214: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1215: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1216: !_DWST [1] (maybe <- 0x80007b) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1217: !_ST [10] (maybe <- 0x80007d) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1217
nop
RET1217:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1218: !_ST [14] (maybe <- 0x80007e) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1219: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1220: !_ST [2] (maybe <- 0x80007f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1221: !_ST [5] (maybe <- 0x40000009) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1222: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l7
or %l7, %lo(0x4c),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1223: !_ST [11] (maybe <- 0x800080) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1224: !_CASX [8] (maybe <- 0x800081) (Int)
add %i1, 256, %l6
ldx [%l6], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l3
sllx %l4, 32, %o4
casx [%l6], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P1225: !_ST [5] (maybe <- 0x800082) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1226: !_DWST [4] (maybe <- 0x800083) (Int) (Branch target of P1865)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P1227
nop

TARGET1865:
ba RET1865
nop


P1227: !_ST [7] (maybe <- 0x800084) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1228: !_PREFETCH [2] (Int) (Branch target of P1067)
prefetch [%i0 + 12], 1
ba P1229
nop

TARGET1067:
ba RET1067
nop


P1229: !_CAS [2] (maybe <- 0x800085) (Int)
add %i0, 12, %l7
lduw [%l7], %o0
mov %o0, %l6
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P1230: !_DWST [0] (maybe <- 0x800086) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P1231: !_DWST [14] (maybe <- 0x800088) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P1232: !_ST [11] (maybe <- 0x800089) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1233: !_ST [1] (maybe <- 0x80008a) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1234: !_CASX [8] (maybe <- 0x80008b) (Int)
add %i1, 256, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l6
sllx %l4, 32, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P1235: !_CAS [14] (maybe <- 0x80008c) (Int)
add %i3, 128, %l7
lduw [%l7], %o3
mov %o3, %l6
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o3(lower)
srl %l3, 0, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1236: !_ST [12] (maybe <- 0x4000000a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P1237: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1238: !_DWST [15] (maybe <- 0x80008d) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P1239: !_ST [5] (maybe <- 0x4000000b) (FP) (Branch target of P2015)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]
ba P1240
nop

TARGET2015:
ba RET2015
nop


P1240: !_ST [0] (maybe <- 0x4000000c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1241: !_ST [8] (maybe <- 0x80008e) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1242: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1243: !_ST [12] (maybe <- 0x80008f) (Int) (Branch target of P1550)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P1244
nop

TARGET1550:
ba RET1550
nop


P1244: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1245: !_LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1246: !_DWST [7] (maybe <- 0x800090) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P1247: !_ST [10] (maybe <- 0x800092) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1248: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1249: !_ST [15] (maybe <- 0x800093) (Int) (Branch target of P1393)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P1250
nop

TARGET1393:
ba RET1393
nop


P1250: !_ST [1] (maybe <- 0x800094) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1251: !_ST [14] (maybe <- 0x800095) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1252: !_DWST [10] (maybe <- 0x800096) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P1253: !_DWST [9] (maybe <- 0x800097) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P1254: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1255: !_ST [9] (maybe <- 0x800098) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 512] %asi
add   %l4, 1, %l4

P1256: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1257: !_ST [0] (maybe <- 0x800099) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1258: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1259: !_DWST [8] (maybe <- 0x80009a) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1259
nop
RET1259:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1260: !_ST [7] (maybe <- 0x80009b) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1261: !_MEMBAR (Int)
membar #StoreLoad

P1262: !_CAS [9] (maybe <- 0x80009c) (Int)
add %i1, 512, %l3
lduw [%l3], %o0
mov %o0, %o5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P1263: !_ST [11] (maybe <- 0x80009d) (Int) (Branch target of P1884)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P1264
nop

TARGET1884:
ba RET1884
nop


P1264: !_ST [0] (maybe <- 0x80009e) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1265: !_DWST [15] (maybe <- 0x80009f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1266: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l3
or %l3, %lo(0x4c),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1267: !_ST [11] (maybe <- 0x4000000d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1268: !_DWLD [3] (Int) (CBR)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1268
nop
RET1268:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1269: !_DWLD [3] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
ldxa [%i0 + 32] %asi, %l7
! move %l7(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srl %l7, 0, %l6
or %l6, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1269
nop
RET1269:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1270: !_DWST [5] (maybe <- 0x8000a0) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P1271: !_ST [12] (maybe <- 0x8000a1) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1272: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1273: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1274: !_DWST [11] (maybe <- 0x8000a2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1275: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1276: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1277: !_ST [12] (maybe <- 0x8000a3) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1278: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %o5
or %o5, %lo(0x50),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1279: !_ST [0] (maybe <- 0x8000a4) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1280: !_ST [6] (maybe <- 0x8000a5) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1281: !_ST [1] (maybe <- 0x8000a6) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1282: !_CASX [9] (maybe <- 0x8000a7) (Int)
add %i1, 512, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P1283: !_DWLD [3] (Int)
ldx [%i0 + 32], %o4
! move %o4(upper) -> %o4(upper)

P1284: !_ST [1] (maybe <- 0x8000a8) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1284
nop
RET1284:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1285: !_ST [12] (maybe <- 0x8000a9) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1286: !_DWST [6] (maybe <- 0x8000aa) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1287: !_ST [2] (maybe <- 0x4000000e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1288: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1289: !_DWST [10] (maybe <- 0x8000ac) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1290: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1291: !_ST [0] (maybe <- 0x8000ad) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1292: !_ST [15] (maybe <- 0x8000ae) (Int) (Branch target of P1507)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P1293
nop

TARGET1507:
ba RET1507
nop


P1293: !_LD [7] (FP)
ld [%i1 + 84], %f3
! 1 addresses covered

P1294: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1295: !_ST [2] (maybe <- 0x8000af) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 12] %asi
add   %l4, 1, %l4

P1296: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1297: !_REPLACEMENT [14] (Int) (CBR)
sethi %hi(0x80), %l3
or %l3, %lo(0x80),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1297
nop
RET1297:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1298: !_ST [3] (maybe <- 0x8000b0) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1299: !_DWST [15] (maybe <- 0x8000b1) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P1300: !_DWST [14] (maybe <- 0x8000b2) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P1301: !_CAS [10] (maybe <- 0x8000b3) (Int) (Branch target of P1735)
add %i2, 32, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4
ba P1302
nop

TARGET1735:
ba RET1735
nop


P1302: !_ST [5] (maybe <- 0x8000b4) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1303: !_ST [5] (maybe <- 0x4000000f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1304: !_LD [11] (Int)
lduw [%i2 + 64], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P1305: !_DWST [4] (maybe <- 0x8000b5) (Int) (CBR) (Branch target of P1484)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1305
nop
RET1305:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P1306
nop

TARGET1484:
ba RET1484
nop


P1306: !_ST [10] (maybe <- 0x8000b6) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1307: !_DWLD [14] (Int)
ldx [%i3 + 128], %o1
! move %o1(upper) -> %o1(upper)

P1308: !_DWST [12] (maybe <- 0x8000b7) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i3 + 0 ] %asi
add   %l4, 1, %l4

P1309: !_ST [7] (maybe <- 0x8000b8) (Int) (Branch target of P1864)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P1310
nop

TARGET1864:
ba RET1864
nop


P1310: !_LD [14] (Int) (CBR)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l6, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1310
nop
RET1310:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1311: !_DWST [12] (maybe <- 0x8000b9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1312: !_ST [14] (maybe <- 0x8000ba) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1313: !_ST [2] (maybe <- 0x8000bb) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1314: !_ST [8] (maybe <- 0x8000bc) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1315: !_ST [5] (maybe <- 0x40000010) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1316: !_ST [6] (maybe <- 0x8000bd) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1317: !_ST [0] (maybe <- 0x8000be) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1318: !_DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P1319: !_ST [14] (maybe <- 0x40000011) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P1320: !_DWLD [4] (Int)
ldx [%i0 + 64], %l7
! move %l7(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l7, 32, %l6
or %l6, %o2, %o2

P1321: !_CAS [0] (maybe <- 0x8000bf) (Int) (Branch target of P2009)
add %i0, 0, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4
ba P1322
nop

TARGET2009:
ba RET2009
nop


P1322: !_ST [0] (maybe <- 0x40000012) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1323: !_ST [0] (maybe <- 0x8000c0) (Int) (Branch target of P1592)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P1324
nop

TARGET1592:
ba RET1592
nop


P1324: !_ST [10] (maybe <- 0x8000c1) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1325: !_DWST [6] (maybe <- 0x8000c2) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1326: !_DWST [0] (maybe <- 0x8000c4) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P1327: !_DWST [4] (maybe <- 0x8000c6) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P1328: !_ST [14] (maybe <- 0x8000c7) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1329: !_ST [1] (maybe <- 0x8000c8) (Int) (LE) (Branch target of P1367)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i0 + 4] %asi
add   %l4, 1, %l4
ba P1330
nop

TARGET1367:
ba RET1367
nop


P1330: !_ST [6] (maybe <- 0x8000c9) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1331: !_DWLD [8] (FP) (CBR)
ldd [%i1 + 256], %f4
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1331
nop
RET1331:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1332: !_ST [7] (maybe <- 0x8000ca) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1333: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1334: !_CASX [3] (maybe <- 0x8000cb) (Int)
add %i0, 32, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l6
sllx %l4, 32, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P1335: !_ST [15] (maybe <- 0x40000013) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P1336: !_ST [9] (maybe <- 0x8000cc) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1337: !_ST [6] (maybe <- 0x8000cd) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1338: !_DWST [7] (maybe <- 0x8000ce) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P1339: !_ST [8] (maybe <- 0x8000d0) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1340: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1341: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1342: !_DWST [7] (maybe <- 0x8000d1) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1343: !_DWST [14] (maybe <- 0x8000d3) (Int) (Branch target of P1959)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4
ba P1344
nop

TARGET1959:
ba RET1959
nop


P1344: !_ST [12] (maybe <- 0x8000d4) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1345: !_ST [4] (maybe <- 0x8000d5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1346: !_LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1347: !_DWLD [0] (Int)
ldx [%i0 + 0], %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l7
or %l7, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2

P1348: !_LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1349: !_CASX [9] (maybe <- 0x8000d6) (Int)
add %i1, 512, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
sllx %l4, 32, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P1350: !_PREFETCH [5] (Int) (CBR)
prefetch [%i1 + 76], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1350
nop
RET1350:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1351: !_ST [12] (maybe <- 0x8000d7) (Int) (Branch target of P1889)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P1352
nop

TARGET1889:
ba RET1889
nop


P1352: !_LD [3] (Int)
lduw [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1353: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l3
or %l3, %lo(0x0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1354: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1355: !_PREFETCH [9] (Int) (Branch target of P2040)
prefetch [%i1 + 512], 1
ba P1356
nop

TARGET2040:
ba RET2040
nop


P1356: !_ST [11] (maybe <- 0x8000d8) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1357: !_ST [15] (maybe <- 0x8000d9) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1358: !_DWST [5] (maybe <- 0x8000da) (Int) (CBR)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1358
nop
RET1358:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1359: !_DWST [9] (maybe <- 0x8000db) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1360: !_DWST [10] (maybe <- 0x8000dc) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P1361: !_CASX [13] (maybe <- 0x8000dd) (Int)
add %i3, 64, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

P1362: !_ST [6] (maybe <- 0x8000de) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1363: !_ST [13] (maybe <- 0x8000df) (Int) (Branch target of P1670)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P1364
nop

TARGET1670:
ba RET1670
nop


P1364: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1365: !_DWST [14] (maybe <- 0x40000014) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1365
nop
RET1365:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1366: !_ST [8] (maybe <- 0x8000e0) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1367: !_DWST [7] (maybe <- 0x8000e1) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1367
nop
RET1367:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1368: !_ST [13] (maybe <- 0x8000e3) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1369: !_DWST [9] (maybe <- 0x40000015) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P1370: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1371: !_ST [1] (maybe <- 0x40000016) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P1372: !_DWST [3] (maybe <- 0x40000017) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P1373: !_ST [5] (maybe <- 0x8000e4) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1374: !_CASX [9] (maybe <- 0x8000e5) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
wr %g0, 0x88, %asi
add %i1, 512, %o5
ldxa [%o5] %asi, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %l7
or %l7, %o2, %o2
! move %l6(upper) -> %o3(upper)
or %l6, %g0, %o3
mov  %l6, %l7
mov  %l3, %l6
casxa [%o5] %asi, %l7, %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %l6, 0, %o5
or %o5, %o3, %o3
! move %l6(upper) -> %o4(upper)
or %l6, %g0, %o4
add  %l4, 1, %l4

P1375: !_REPLACEMENT [11] (Int) (Branch target of P1430)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P1376
nop

TARGET1430:
ba RET1430
nop


P1376: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1377: !_ST [9] (maybe <- 0x8000e6) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1378: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1379: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %o5
or %o5, %lo(0x4),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1380: !_ST [1] (maybe <- 0x8000e7) (Int) (LE) (Branch target of P1619)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i0 + 4] %asi
add   %l4, 1, %l4
ba P1381
nop

TARGET1619:
ba RET1619
nop


P1381: !_DWST [8] (maybe <- 0x8000e8) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1382: !_ST [9] (maybe <- 0x8000e9) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1383: !_DWLD [1] (Int) (CBR)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1383
nop
RET1383:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1384: !_CAS [2] (maybe <- 0x8000ea) (Int)
add %i0, 12, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1385: !_CAS [1] (maybe <- 0x8000eb) (Int)
add %i0, 4, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1
mov %l4, %o2
cas [%o5], %l7, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1386: !_DWST [4] (maybe <- 0x8000ec) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P1387: !_ST [10] (maybe <- 0x8000ed) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1388: !_ST [0] (maybe <- 0x8000ee) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1389: !_ST [9] (maybe <- 0x8000ef) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1390: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1391: !_ST [4] (maybe <- 0x8000f0) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1392: !_ST [15] (maybe <- 0x40000018) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P1393: !_LD [12] (Int) (CBR)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1393
nop
RET1393:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1394: !_ST [1] (maybe <- 0x8000f1) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1395: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %l7
or %l7, %lo(0x54),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1396: !_DWST [5] (maybe <- 0x8000f2) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P1397: !_ST [13] (maybe <- 0x8000f3) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1398: !_CAS [4] (maybe <- 0x8000f4) (Int)
add %i0, 64, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P1399: !_ST [1] (maybe <- 0x8000f5) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1400: !_CASX [15] (maybe <- 0x8000f6) (Int)
add %i3, 192, %o5
ldx [%o5], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l7
sllx %l4, 32, %o0
casx [%o5], %l7, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P1401: !_CAS [12] (maybe <- 0x8000f7) (Int)
add %i3, 0, %o5
lduw [%o5], %o1
mov %o1, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P1402: !_DWST [9] (maybe <- 0x8000f8) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P1403: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1404: !_ST [13] (maybe <- 0x8000f9) (Int) (LE) (Branch target of P1851)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i3 + 64] %asi
add   %l4, 1, %l4
ba P1405
nop

TARGET1851:
ba RET1851
nop


P1405: !_PREFETCH [4] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 64] %asi, 1

P1406: !_ST [8] (maybe <- 0x8000fa) (Int) (Branch target of P1268)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P1407
nop

TARGET1268:
ba RET1268
nop


P1407: !_ST [2] (maybe <- 0x8000fb) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1408: !_CASX [7] (maybe <- 0x8000fc) (Int)
add %i1, 80, %o5
ldx [%o5], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l7
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
casx [%o5], %l7, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P1409: !_DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1410: !_ST [6] (maybe <- 0x40000019) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P1411: !_ST [3] (maybe <- 0x8000fe) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 32] %asi
add   %l4, 1, %l4

P1412: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l7
or %l7, %lo(0x4c),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1413: !_CASX [8] (maybe <- 0x8000ff) (Int)
add %i1, 256, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
sllx %l4, 32, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P1414: !_DWST [5] (maybe <- 0x800100) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P1415: !_ST [5] (maybe <- 0x4000001a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1416: !_ST [1] (maybe <- 0x800101) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1417: !_ST [5] (maybe <- 0x800102) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1418: !_CAS [9] (maybe <- 0x800103) (Int)
add %i1, 512, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1419: !_DWST [15] (maybe <- 0x800104) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1420: !_DWST [3] (maybe <- 0x800105) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P1421: !_ST [5] (maybe <- 0x800106) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1422: !_LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1423: !_DWST [6] (maybe <- 0x800107) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1424: !_PREFETCH [8] (Int) (Branch target of P1524)
prefetch [%i1 + 256], 1
ba P1425
nop

TARGET1524:
ba RET1524
nop


P1425: !_DWST [6] (maybe <- 0x800109) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P1426: !_MEMBAR (Int)
membar #StoreLoad

P1427: !_DWST [9] (maybe <- 0x80010b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P1428: !_DWST [8] (maybe <- 0x80010c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1429: !_ST [11] (maybe <- 0x80010d) (Int) (CBR)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1429
nop
RET1429:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1430: !_ST [3] (maybe <- 0x80010e) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1430
nop
RET1430:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1431: !_ST [2] (maybe <- 0x80010f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1432: !_REPLACEMENT [0] (Int) (CBR)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1432
nop
RET1432:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1433: !_ST [0] (maybe <- 0x4000001b) (FP) (Branch target of P1117)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]
ba P1434
nop

TARGET1117:
ba RET1117
nop


P1434: !_ST [5] (maybe <- 0x4000001c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1435: !_ST [14] (maybe <- 0x800110) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1436: !_ST [1] (maybe <- 0x800111) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1437: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1438: !_ST [4] (maybe <- 0x800112) (Int) (Branch target of P2019)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P1439
nop

TARGET2019:
ba RET2019
nop


P1439: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1440: !_DWST [2] (maybe <- 0x800113) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %o5
srl %o5, 8, %o5
sll %l4, 8, %l7
and %l7, %l6, %l7
or %l7, %o5, %l7
srl %l7, 16, %o5
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %o5, %l7
sllx %l7, 32, %l7 
stxa %l7, [%i0 + 8 ] %asi
add   %l4, 1, %l4

P1441: !_ST [11] (maybe <- 0x800114) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1442: !_ST [13] (maybe <- 0x800115) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1442
nop
RET1442:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1443: !_DWLD [5] (Int)
ldx [%i1 + 72], %l3
! move %l3(lower) -> %o3(lower)
srl %l3, 0, %o5
or %o5, %o3, %o3

P1444: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1445: !_ST [5] (maybe <- 0x800116) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1446: !_LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1447: !_ST [7] (maybe <- 0x800117) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1448: !_SWAP [14] (maybe <- 0x800118) (Int)
mov %l4, %l7
swap  [%i3 + 128], %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P1449: !_ST [1] (maybe <- 0x800119) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1450: !_DWST [9] (maybe <- 0x80011a) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P1451: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1451
nop
RET1451:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1452: !_ST [11] (maybe <- 0x4000001d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1453: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1454: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l3
or %l3, %lo(0x4c),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1455: !_ST [4] (maybe <- 0x80011b) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1456: !_CAS [9] (maybe <- 0x80011c) (Int)
add %i1, 512, %o5
lduw [%o5], %o0
mov %o0, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P1457: !_DWST [10] (maybe <- 0x80011d) (Int) (Branch target of P1284)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4
ba P1458
nop

TARGET1284:
ba RET1284
nop


P1458: !_ST [4] (maybe <- 0x4000001e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P1459: !_SWAP [10] (maybe <- 0x80011e) (Int)
mov %l4, %o1
swap  [%i2 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1460: !_ST [10] (maybe <- 0x80011f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1461: !_DWST [11] (maybe <- 0x800120) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P1462: !_ST [11] (maybe <- 0x4000001f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1463: !_ST [13] (maybe <- 0x800121) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1464: !_DWST [12] (maybe <- 0x800122) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1465: !_DWST [1] (maybe <- 0x800123) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1466: !_DWST [14] (maybe <- 0x800125) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1466
nop
RET1466:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1467: !_ST [8] (maybe <- 0x800126) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1468: !_ST [2] (maybe <- 0x800127) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1469: !_ST [5] (maybe <- 0x800128) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1470: !_CAS [14] (maybe <- 0x800129) (Int)
add %i3, 128, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1
mov %l4, %o2
cas [%o5], %l7, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P1471: !_ST [1] (maybe <- 0x80012a) (Int) (Branch target of P1847)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P1472
nop

TARGET1847:
ba RET1847
nop


P1472: !_ST [5] (maybe <- 0x80012b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1473: !_ST [15] (maybe <- 0x80012c) (Int) (Branch target of P1971)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P1474
nop

TARGET1971:
ba RET1971
nop


P1474: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %o5
or %o5, %lo(0x50),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1475: !_DWST [10] (maybe <- 0x40000020) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P1476: !_LD [3] (Int)
lduw [%i0 + 32], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P1477: !_ST [12] (maybe <- 0x80012d) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1478: !_DWST [4] (maybe <- 0x80012e) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P1479: !_ST [1] (maybe <- 0x80012f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1480: !_DWST [12] (maybe <- 0x800130) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1480
nop
RET1480:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1481: !_CAS [8] (maybe <- 0x800131) (Int)
add %i1, 256, %l6
lduw [%l6], %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P1482: !_DWST [8] (maybe <- 0x40000021) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P1483: !_DWLD [13] (Int)
ldx [%i3 + 64], %o4
! move %o4(upper) -> %o4(upper)

P1484: !_REPLACEMENT [8] (Int) (CBR)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1484
nop
RET1484:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1485: !_CASX [7] (maybe <- 0x800132) (Int)
add %i1, 80, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l3, %l6
sllx %l4, 32, %l3
add  %l4, 1, %l4
or   %l4, %l3, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l7
or %l7, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
add  %l4, 1, %l4

P1486: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1487: !_ST [15] (maybe <- 0x800134) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1488: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1489: !_ST [2] (maybe <- 0x800135) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1490: !_ST [14] (maybe <- 0x800136) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1491: !_ST [0] (maybe <- 0x800137) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1492: !_ST [11] (maybe <- 0x800138) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1493: !_ST [8] (maybe <- 0x800139) (Int) (Branch target of P1451)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P1494
nop

TARGET1451:
ba RET1451
nop


P1494: !_ST [9] (maybe <- 0x80013a) (Int) (Branch target of P1819)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P1495
nop

TARGET1819:
ba RET1819
nop


P1495: !_DWST [3] (maybe <- 0x80013b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P1496: !_DWST [0] (maybe <- 0x80013c) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1496
nop
RET1496:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1497: !_CASX [4] (maybe <- 0x80013e) (Int)
add %i0, 64, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

P1498: !_LD [12] (Int) (Branch target of P1094)
lduw [%i3 + 0], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3
ba P1499
nop

TARGET1094:
ba RET1094
nop


P1499: !_DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1500: !_ST [12] (maybe <- 0x80013f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1501: !_CASX [8] (maybe <- 0x800140) (Int) (Branch target of P1859)
add %i1, 256, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4
ba P1502
nop

TARGET1859:
ba RET1859
nop


P1502: !_DWST [4] (maybe <- 0x800141) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P1503: !_DWST [8] (maybe <- 0x40000022) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1503
nop
RET1503:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1504: !_ST [6] (maybe <- 0x800142) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1505: !_ST [5] (maybe <- 0x800143) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1506: !_DWST [3] (maybe <- 0x800144) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P1507: !_CAS [3] (maybe <- 0x800145) (Int) (CBR)
add %i0, 32, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1507
nop
RET1507:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1508: !_DWLD [10] (Int) (CBR)
ldx [%i2 + 32], %o3
! move %o3(upper) -> %o3(upper)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1508
nop
RET1508:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1509: !_CAS [3] (maybe <- 0x800146) (Int)
add %i0, 32, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l7, %o3, %o3
mov %l4, %o4
cas [%o5], %l7, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1510: !_ST [4] (maybe <- 0x800147) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1511: !_ST [9] (maybe <- 0x800148) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1512: !_DWST [7] (maybe <- 0x800149) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1513: !_ST [5] (maybe <- 0x80014b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1514: !_ST [8] (maybe <- 0x40000023) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P1515: !_DWST [6] (maybe <- 0x40000024) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P1516: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1517: !_ST [1] (maybe <- 0x80014c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1518: !_DWST [10] (maybe <- 0x40000026) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P1519: !_ST [2] (maybe <- 0x40000027) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1520: !_DWLD [9] (Int)
ldx [%i1 + 512], %l7
! move %l7(upper) -> %o4(lower)
srlx %l7, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1521: !_ST [1] (maybe <- 0x80014d) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1521
nop
RET1521:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1522: !_DWST [7] (maybe <- 0x40000028) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P1523: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1524: !_DWLD [9] (Int) (CBR)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1524
nop
RET1524:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1525: !_ST [13] (maybe <- 0x80014e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1526: !_ST [0] (maybe <- 0x80014f) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1527: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1528: !_DWST [9] (maybe <- 0x800150) (Int) (Branch target of P1886)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4
ba P1529
nop

TARGET1886:
ba RET1886
nop


P1529: !_ST [2] (maybe <- 0x4000002a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1530: !_ST [9] (maybe <- 0x800151) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1531: !_ST [4] (maybe <- 0x800152) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1532: !_DWST [11] (maybe <- 0x800153) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P1533: !_DWST [9] (maybe <- 0x800154) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1534: !_PREFETCH [8] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 256] %asi, 1

P1535: !_ST [2] (maybe <- 0x800155) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1536: !_ST [11] (maybe <- 0x800156) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i2 + 64] %asi
add   %l4, 1, %l4

P1537: !_DWST [15] (maybe <- 0x800157) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P1538: !_ST [2] (maybe <- 0x800158) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1539: !_DWST [1] (maybe <- 0x800159) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1540: !_SWAP [14] (maybe <- 0x80015b) (Int) (CBR)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1540
nop
RET1540:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1541: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %o5
or %o5, %lo(0xc),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1542: !_ST [5] (maybe <- 0x80015c) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1543: !_DWST [15] (maybe <- 0x80015d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1544: !_LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1545: !_LD [14] (Int)
lduw [%i3 + 128], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P1546: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1547: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P1548: !_LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1549: !_LD [1] (Int) (Branch target of P1442)
lduw [%i0 + 4], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
ba P1550
nop

TARGET1442:
ba RET1442
nop


P1550: !_LD [15] (Int) (CBR)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1550
nop
RET1550:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1551: !_LD [15] (Int)
lduw [%i3 + 192], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1552: !_LD [5] (FP)
ld [%i1 + 76], %f5
! 1 addresses covered

P1553: !_LD [5] (FP)
ld [%i1 + 76], %f6
! 1 addresses covered

P1554: !_LD [15] (FP) (CBR)
ld [%i3 + 192], %f7
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1554
nop
RET1554:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1555: !_LD [8] (FP) (CBR)
ld [%i1 + 256], %f8
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1555
nop
RET1555:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1556: !_LD [4] (FP)
ld [%i0 + 64], %f9
! 1 addresses covered

P1557: !_LD [1] (FP)
ld [%i0 + 4], %f10
! 1 addresses covered

P1558: !_LD [7] (FP)
ld [%i1 + 84], %f11
! 1 addresses covered

P1559: !_LD [0] (FP) (CBR) (Branch target of P1118)
ld [%i0 + 0], %f12
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1559
nop
RET1559:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P1560
nop

TARGET1118:
ba RET1118
nop


P1560: !_LD [14] (FP)
ld [%i3 + 128], %f13
! 1 addresses covered

P1561: !_LD [3] (FP)
ld [%i0 + 32], %f14
! 1 addresses covered

P1562: !_LD [9] (FP)
ld [%i1 + 512], %f15
! 1 addresses covered
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P1563: !_ST [0] (maybe <- 0x80015e) (Int) (Loop exit)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
loop_exit_1_0:
sub %l2, 1, %l2
cmp %l2, 0
bg loop_entry_1_0
nop

P1564: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1565: !_DWST [11] (maybe <- 0x80015f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P1566: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1567: !_DWST [11] (maybe <- 0x800160) (Int) (Branch target of P1072)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P1568
nop

TARGET1072:
ba RET1072
nop


P1568: !_ST [6] (maybe <- 0x800161) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1569: !_LD [2] (Int)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1570: !_ST [3] (maybe <- 0x800162) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1571: !_ST [4] (maybe <- 0x4000002b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P1572: !_DWST [7] (maybe <- 0x800163) (Int) (CBR)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1572
nop
RET1572:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1573: !_ST [1] (maybe <- 0x800165) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1574: !_SWAP [0] (maybe <- 0x800166) (Int) (LE) (Branch target of P2036)
wr %g0, 0x88, %asi
mov %l4, %l7
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l7, %l3, %l6
srl %l6, 8, %l6
sll %l7, 8, %l7
and %l7, %l3, %l7
or %l7, %l6, %l7
srl %l7, 16, %l6
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l6, %l7
swapa  [%i0 + 0] %asi, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4
ba P1575
nop

TARGET2036:
ba RET2036
nop


P1575: !_SWAP [10] (maybe <- 0x800167) (Int) (LE)
wr %g0, 0x88, %asi
mov %l4, %o1
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %o1, %o5, %l3
srl %l3, 8, %l3
sll %o1, 8, %o1
and %o1, %o5, %o1
or %o1, %l3, %o1
srl %o1, 16, %l3
sll %o1, 16, %o1
srl %o1, 0, %o1
or %o1, %l3, %o1
swapa  [%i2 + 32] %asi, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1576: !_DWST [13] (maybe <- 0x800168) (Int) (Branch target of P1480)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P1577
nop

TARGET1480:
ba RET1480
nop


P1577: !_DWLD [3] (Int)
ldx [%i0 + 32], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l6
or %l6, %o1, %o1

P1578: !_DWST [0] (maybe <- 0x4000002c) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1578
nop
RET1578:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1579: !_DWST [1] (maybe <- 0x800169) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P1580: !_ST [6] (maybe <- 0x80016b) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1581: !_ST [5] (maybe <- 0x80016c) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1581
nop
RET1581:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1582: !_DWST [7] (maybe <- 0x4000002e) (FP) (Branch target of P1540)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]
ba P1583
nop

TARGET1540:
ba RET1540
nop


P1583: !_DWST [14] (maybe <- 0x40000030) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P1584: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1585: !_ST [3] (maybe <- 0x80016d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1586: !_DWST [5] (maybe <- 0x80016e) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P1587: !_DWST [5] (maybe <- 0x80016f) (Int) (Branch target of P1572)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4
ba P1588
nop

TARGET1572:
ba RET1572
nop


P1588: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l7
or %l7, %lo(0xc),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1589: !_DWLD [6] (FP)
ldd [%i1 + 80], %f0
! 2 addresses covered

P1590: !_ST [4] (maybe <- 0x800170) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1591: !_ST [4] (maybe <- 0x40000031) (FP) (Branch target of P1769)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]
ba P1592
nop

TARGET1769:
ba RET1769
nop


P1592: !_DWST [11] (maybe <- 0x800171) (Int) (CBR) (Branch target of P1835)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1592
nop
RET1592:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P1593
nop

TARGET1835:
ba RET1835
nop


P1593: !_DWST [8] (maybe <- 0x800172) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P1594: !_REPLACEMENT [3] (Int) (CBR)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1594
nop
RET1594:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1595: !_ST [13] (maybe <- 0x800173) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1595
nop
RET1595:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1596: !_ST [5] (maybe <- 0x800174) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1597: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1598: !_ST [2] (maybe <- 0x800175) (Int) (Branch target of P1554)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
ba P1599
nop

TARGET1554:
ba RET1554
nop


P1599: !_LD [4] (Int) (Branch target of P1310)
lduw [%i0 + 64], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
ba P1600
nop

TARGET1310:
ba RET1310
nop


P1600: !_DWST [1] (maybe <- 0x800176) (Int) (CBR)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1600
nop
RET1600:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1601: !_ST [8] (maybe <- 0x800178) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1602: !_ST [2] (maybe <- 0x40000032) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1603: !_ST [14] (maybe <- 0x800179) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1604: !_ST [12] (maybe <- 0x80017a) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1605: !_ST [14] (maybe <- 0x40000033) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P1606: !_ST [11] (maybe <- 0x40000034) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1607: !_ST [9] (maybe <- 0x80017b) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1608: !_ST [0] (maybe <- 0x40000035) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1609: !_LD [1] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 4] %asi, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1610: !_ST [5] (maybe <- 0x80017c) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1611: !_CASX [5] (maybe <- 0x80017d) (Int)
add %i1, 72, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
add  %l4, 1, %l4

P1612: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1613: !_CAS [12] (maybe <- 0x80017e) (Int)
add %i3, 0, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1614: !_ST [12] (maybe <- 0x80017f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1615: !_LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P1616: !_DWST [12] (maybe <- 0x800180) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P1617: !_ST [9] (maybe <- 0x800181) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1618: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l3
or %l3, %lo(0x4),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1619: !_ST [10] (maybe <- 0x40000036) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1619
nop
RET1619:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1620: !_ST [0] (maybe <- 0x40000037) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1621: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1622: !_ST [10] (maybe <- 0x800182) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1623: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1624: !_ST [13] (maybe <- 0x800183) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1624
nop
RET1624:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1625: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1626: !_ST [6] (maybe <- 0x40000038) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P1627: !_ST [0] (maybe <- 0x800184) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1628: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P1629: !_ST [12] (maybe <- 0x800185) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1630: !_LD [14] (FP) (CBR)
ld [%i3 + 128], %f2
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1630
nop
RET1630:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1631: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1632: !_DWST [11] (maybe <- 0x800186) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P1633: !_ST [14] (maybe <- 0x800187) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1634: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1635: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1636: !_DWST [0] (maybe <- 0x800188) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1637: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1638: !_CAS [12] (maybe <- 0x80018a) (Int)
add %i3, 0, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1639: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1640: !_ST [9] (maybe <- 0x80018b) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1641: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1642: !_PREFETCH [15] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1642
nop
RET1642:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1643: !_ST [6] (maybe <- 0x80018c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1644: !_DWST [1] (maybe <- 0x80018d) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P1645: !_CAS [0] (maybe <- 0x80018f) (Int) (Branch target of P1496)
add %i0, 0, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4
ba P1646
nop

TARGET1496:
ba RET1496
nop


P1646: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1647: !_REPLACEMENT [14] (Int) (CBR)
sethi %hi(0x80), %l3
or %l3, %lo(0x80),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1647
nop
RET1647:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1648: !_ST [13] (maybe <- 0x800190) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1649: !_ST [9] (maybe <- 0x800191) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1650: !_ST [4] (maybe <- 0x800192) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i0 + 64] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1650
nop
RET1650:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1651: !_ST [9] (maybe <- 0x800193) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1652: !_ST [9] (maybe <- 0x800194) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1653: !_ST [4] (maybe <- 0x800195) (Int) (Branch target of P1766)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P1654
nop

TARGET1766:
ba RET1766
nop


P1654: !_PREFETCH [1] (Int) (Branch target of P1934)
prefetch [%i0 + 4], 1
ba P1655
nop

TARGET1934:
ba RET1934
nop


P1655: !_ST [3] (maybe <- 0x800196) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1656: !_ST [10] (maybe <- 0x800197) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1657: !_DWST [15] (maybe <- 0x800198) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1658: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1659: !_DWST [11] (maybe <- 0x800199) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P1660: !_ST [9] (maybe <- 0x80019a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1661: !_DWLD [3] (Int)
ldx [%i0 + 32], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1662: !_DWLD [0] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1663: !_CAS [9] (maybe <- 0x80019b) (Int)
add %i1, 512, %o5
lduw [%o5], %o1
mov %o1, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P1664: !_ST [6] (maybe <- 0x80019c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1665: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1666: !_DWST [4] (maybe <- 0x80019d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1667: !_LD [0] (Int)
lduw [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1668: !_ST [15] (maybe <- 0x80019e) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1669: !_ST [14] (maybe <- 0x80019f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1670: !_CAS [13] (maybe <- 0x8001a0) (Int) (CBR)
add %i3, 64, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l4, %o3
cas [%l6], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1670
nop
RET1670:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1671: !_ST [1] (maybe <- 0x8001a1) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1672: !_DWST [6] (maybe <- 0x8001a2) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %l3
add   %l4, 1, %l4
or %l3, %l4, %l6
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
sllx %l7, 32, %l3
or %l7, %l3, %l7 
and %l6, %l7, %l3
srlx %l3, 8, %l3
sllx %l6, 8, %l6
and %l6, %l7, %l6
or %l6, %l3, %l6 
sethi %hi(0xffff0000), %l7
or %l7, %lo(0xffff0000), %l7
srlx %l6, 16, %l3
andn %l3, %l7, %l3
andn %l6, %l7, %l6
sllx %l6, 16, %l6
or %l6, %l3, %l6 
srlx %l6, 32, %l3
sllx %l6, 32, %l6
or %l6, %l3, %l3 
stxa %l3, [%i1 + 80 ] %asi
add   %l4, 1, %l4

P1673: !_ST [11] (maybe <- 0x8001a4) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1674: !_DWST [4] (maybe <- 0x40000039) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P1675: !_CAS [14] (maybe <- 0x8001a5) (Int)
add %i3, 128, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1676: !_ST [11] (maybe <- 0x8001a6) (Int) (Branch target of P1679)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P1677
nop

TARGET1679:
ba RET1679
nop


P1677: !_DWST [7] (maybe <- 0x8001a7) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1678: !_DWST [13] (maybe <- 0x8001a9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P1679: !_DWLD [1] (Int) (CBR)
ldx [%i0 + 0], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1679
nop
RET1679:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1680: !_ST [0] (maybe <- 0x4000003a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1681: !_ST [10] (maybe <- 0x8001aa) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1681
nop
RET1681:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1682: !_DWST [1] (maybe <- 0x8001ab) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1683: !_CAS [2] (maybe <- 0x8001ad) (Int)
add %i0, 12, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1684: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1685: !_DWST [6] (maybe <- 0x8001ae) (Int) (CBR) (Branch target of P1938)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1685
nop
RET1685:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P1686
nop

TARGET1938:
ba RET1938
nop


P1686: !_DWST [4] (maybe <- 0x8001b0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P1687: !_ST [5] (maybe <- 0x8001b1) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1687
nop
RET1687:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1688: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l7
or %l7, %lo(0x50),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1689: !_LD [11] (Int)
lduw [%i2 + 64], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P1690: !_CASX [6] (maybe <- 0x8001b2) (Int) (Branch target of P1713)
add %i1, 80, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %o5
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4
ba P1691
nop

TARGET1713:
ba RET1713
nop


P1691: !_ST [15] (maybe <- 0x8001b4) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1692: !_ST [13] (maybe <- 0x8001b5) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1692
nop
RET1692:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1693: !_ST [15] (maybe <- 0x8001b6) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1694: !_DWST [2] (maybe <- 0x8001b7) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P1695: !_LD [12] (Int)
lduw [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1696: !_ST [10] (maybe <- 0x8001b8) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i2 + 32] %asi
add   %l4, 1, %l4

P1697: !_ST [5] (maybe <- 0x8001b9) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1698: !_LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1699: !_LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1700: !_DWST [7] (maybe <- 0x8001ba) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1701: !_DWST [0] (maybe <- 0x4000003b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P1702: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l7
or %l7, %lo(0xc),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1703: !_CAS [6] (maybe <- 0x8001bc) (Int)
add %i1, 80, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1704: !_ST [11] (maybe <- 0x8001bd) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1705: !_DWST [4] (maybe <- 0x8001be) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P1706: !_ST [13] (maybe <- 0x8001bf) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 64] %asi
add   %l4, 1, %l4

P1707: !_LD [7] (Int) (CBR) (Branch target of P1503)
lduw [%i1 + 84], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1707
nop
RET1707:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P1708
nop

TARGET1503:
ba RET1503
nop


P1708: !_CAS [6] (maybe <- 0x8001c0) (Int)
add %i1, 80, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P1709: !_ST [15] (maybe <- 0x8001c1) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1710: !_ST [9] (maybe <- 0x8001c2) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1711: !_CAS [1] (maybe <- 0x8001c3) (Int)
add %i0, 4, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P1712: !_DWST [7] (maybe <- 0x8001c4) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P1713: !_DWST [7] (maybe <- 0x8001c6) (Int) (CBR)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1713
nop
RET1713:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1714: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1715: !_DWST [9] (maybe <- 0x4000003d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P1716: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1717: !_ST [11] (maybe <- 0x8001c8) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1718: !_NOP (Int)
nop

P1719: !_ST [6] (maybe <- 0x8001c9) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1719
nop
RET1719:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1720: !_ST [7] (maybe <- 0x8001ca) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1721: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1722: !_DWST [15] (maybe <- 0x8001cb) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P1723: !_DWST [5] (maybe <- 0x8001cc) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P1724: !_DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P1725: !_DWST [0] (maybe <- 0x8001cd) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P1726: !_ST [14] (maybe <- 0x8001cf) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1727: !_ST [7] (maybe <- 0x8001d0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1728: !_ST [0] (maybe <- 0x8001d1) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1729: !_DWST [7] (maybe <- 0x8001d2) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P1730: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1731: !_ST [13] (maybe <- 0x8001d4) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1732: !_DWLD [1] (FP)
ldd [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f3
fmovs %f19, %f4

P1733: !_DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P1734: !_ST [11] (maybe <- 0x4000003e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1735: !_ST [12] (maybe <- 0x4000003f) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1735
nop
RET1735:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1736: !_ST [8] (maybe <- 0x8001d5) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1737: !_DWST [0] (maybe <- 0x8001d6) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P1738: !_LD [1] (Int)
lduw [%i0 + 4], %o5
! move %o5(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %o5, %o0, %o0

P1739: !_CAS [12] (maybe <- 0x8001d8) (Int)
add %i3, 0, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P1740: !_LD [14] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i3 + 128] %asi, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1741: !_ST [12] (maybe <- 0x8001d9) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1742: !_ST [6] (maybe <- 0x8001da) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1743: !_LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1744: !_DWLD [10] (Int) (Branch target of P1860)
ldx [%i2 + 32], %o3
! move %o3(upper) -> %o3(upper)
ba P1745
nop

TARGET1860:
ba RET1860
nop


P1745: !_SWAP [11] (maybe <- 0x8001db) (Int)
mov %l4, %l7
swap  [%i2 + 64], %l7
! move %l7(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P1746: !_ST [13] (maybe <- 0x8001dc) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1747: !_DWST [2] (maybe <- 0x8001dd) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P1748: !_ST [11] (maybe <- 0x8001de) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1749: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1750: !_DWLD [6] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1751: !_DWST [11] (maybe <- 0x8001df) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P1752: !_DWST [3] (maybe <- 0x8001e0) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1753: !_DWST [7] (maybe <- 0x8001e1) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1754: !_DWST [2] (maybe <- 0x8001e3) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P1755: !_CAS [15] (maybe <- 0x8001e4) (Int)
add %i3, 192, %o5
lduw [%o5], %o0
mov %o0, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P1756: !_DWST [5] (maybe <- 0x8001e5) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P1757: !_LD [10] (Int)
lduw [%i2 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1758: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %o5
or %o5, %lo(0x40),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1759: !_ST [6] (maybe <- 0x8001e6) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1760: !_DWST [9] (maybe <- 0x8001e7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1761: !_CAS [9] (maybe <- 0x8001e8) (Int) (CBR)
add %i1, 512, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1
mov %l4, %o2
cas [%l6], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1761
nop
RET1761:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1762: !_ST [14] (maybe <- 0x8001e9) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1763: !_ST [1] (maybe <- 0x8001ea) (Int) (Branch target of P1687)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P1764
nop

TARGET1687:
ba RET1687
nop


P1764: !_DWST [11] (maybe <- 0x8001eb) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P1765: !_DWST [4] (maybe <- 0x8001ec) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P1766: !_ST [8] (maybe <- 0x8001ed) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1766
nop
RET1766:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1767: !_ST [13] (maybe <- 0x8001ee) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1768: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1769: !_CAS [3] (maybe <- 0x8001ef) (Int) (CBR)
add %i0, 32, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2
mov %l4, %o3
cas [%l3], %o5, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1769
nop
RET1769:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1770: !_ST [0] (maybe <- 0x40000040) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1771: !_CAS [12] (maybe <- 0x8001f0) (Int)
add %i3, 0, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1772: !_DWLD [0] (FP)
ldd [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f5
fmovs %f19, %f6

P1773: !_CAS [4] (maybe <- 0x8001f1) (Int)
add %i0, 64, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l3], %o5, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1774: !_ST [8] (maybe <- 0x8001f2) (Int) (Branch target of P1383)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P1775
nop

TARGET1383:
ba RET1383
nop


P1775: !_ST [4] (maybe <- 0x8001f3) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P1776: !_DWST [15] (maybe <- 0x8001f4) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1777: !_ST [6] (maybe <- 0x8001f5) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1778: !_ST [10] (maybe <- 0x8001f6) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1779: !_ST [7] (maybe <- 0x8001f7) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i1 + 84] %asi
add   %l4, 1, %l4

P1780: !_ST [0] (maybe <- 0x8001f8) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1781: !_SWAP [3] (maybe <- 0x8001f9) (Int)
mov %l4, %l7
swap  [%i0 + 32], %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P1782: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1783: !_CAS [13] (maybe <- 0x8001fa) (Int) (CBR)
add %i3, 64, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1783
nop
RET1783:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1784: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1785: !_DWST [6] (maybe <- 0x8001fb) (Int) (Branch target of P1685)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4
ba P1786
nop

TARGET1685:
ba RET1685
nop


P1786: !_DWST [3] (maybe <- 0x8001fd) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P1787: !_ST [0] (maybe <- 0x8001fe) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1788: !_DWST [6] (maybe <- 0x8001ff) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P1789: !_ST [8] (maybe <- 0x800201) (Int) (Branch target of P1692)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P1790
nop

TARGET1692:
ba RET1692
nop


P1790: !_DWST [9] (maybe <- 0x800202) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P1791: !_ST [13] (maybe <- 0x40000041) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P1792: !_DWST [9] (maybe <- 0x800203) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P1793: !_DWST [2] (maybe <- 0x800204) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P1794: !_DWST [13] (maybe <- 0x800205) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P1795: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1796: !_ST [2] (maybe <- 0x800206) (Int) (Branch target of P1595)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
ba P1797
nop

TARGET1595:
ba RET1595
nop


P1797: !_ST [0] (maybe <- 0x800207) (Int) (Branch target of P1624)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P1798
nop

TARGET1624:
ba RET1624
nop


P1798: !_DWST [9] (maybe <- 0x800208) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P1799: !_CAS [13] (maybe <- 0x800209) (Int)
add %i3, 64, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4

P1800: !_DWST [15] (maybe <- 0x80020a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P1801: !_ST [10] (maybe <- 0x40000042) (FP) (Branch target of P1042)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]
ba P1802
nop

TARGET1042:
ba RET1042
nop


P1802: !_CASX [2] (maybe <- 0x80020b) (Int)
add %i0, 8, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
mov %l4, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P1803: !_ST [8] (maybe <- 0x40000043) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P1804: !_ST [9] (maybe <- 0x80020c) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 512] %asi
add   %l4, 1, %l4

P1805: !_DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1806: !_ST [10] (maybe <- 0x80020d) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1806
nop
RET1806:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1807: !_LD [8] (Int)
lduw [%i1 + 256], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P1808: !_ST [0] (maybe <- 0x40000044) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1809: !_DWST [7] (maybe <- 0x80020e) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P1810: !_DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P1811: !_ST [13] (maybe <- 0x800210) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1812: !_ST [13] (maybe <- 0x800211) (Int) (Branch target of P1077)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P1813
nop

TARGET1077:
ba RET1077
nop


P1813: !_ST [0] (maybe <- 0x800212) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1814: !_DWST [0] (maybe <- 0x800213) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1815: !_ST [6] (maybe <- 0x800215) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1816: !_DWST [5] (maybe <- 0x800216) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P1817: !_LD [12] (Int)
lduw [%i3 + 0], %l7
! move %l7(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l7, %o1, %o1

P1818: !_REPLACEMENT [15] (Int)
sethi %hi(0xc0), %o5
or %o5, %lo(0xc0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1819: !_CASX [0] (maybe <- 0x800217) (Int) (CBR)
add %i0, 0, %o5
ldx [%o5], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l7
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
casx [%o5], %l7, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1819
nop
RET1819:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1820: !_ST [10] (maybe <- 0x800219) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1821: !_DWLD [6] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1822: !_CASX [12] (maybe <- 0x80021a) (Int)
add %i3, 0, %l6
ldx [%l6], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l3
sllx %l4, 32, %o1
casx [%l6], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P1823: !_ST [15] (maybe <- 0x80021b) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1824: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1825: !_ST [13] (maybe <- 0x40000045) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P1826: !_ST [8] (maybe <- 0x80021c) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1827: !_ST [3] (maybe <- 0x80021d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1828: !_ST [6] (maybe <- 0x80021e) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1829: !_CAS [1] (maybe <- 0x80021f) (Int)
add %i0, 4, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4

P1830: !_LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1831: !_DWST [10] (maybe <- 0x800220) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1832: !_DWST [14] (maybe <- 0x800221) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P1833: !_ST [10] (maybe <- 0x800222) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i2 + 32] %asi
add   %l4, 1, %l4

P1834: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P1835: !_ST [13] (maybe <- 0x800223) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1835
nop
RET1835:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1836: !_ST [11] (maybe <- 0x800224) (Int) (Branch target of P1806)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P1837
nop

TARGET1806:
ba RET1806
nop


P1837: !_ST [2] (maybe <- 0x40000046) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1838: !_DWST [12] (maybe <- 0x800225) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1839: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1840: !_ST [13] (maybe <- 0x800226) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1841: !_DWST [5] (maybe <- 0x40000047) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P1842: !_ST [12] (maybe <- 0x800227) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1843: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P1844: !_LD [10] (Int)
lduw [%i2 + 32], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P1845: !_PREFETCH [0] (Int) (Branch target of P1642)
prefetch [%i0 + 0], 1
ba P1846
nop

TARGET1642:
ba RET1642
nop


P1846: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l3
or %l3, %lo(0x50),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P1847: !_DWST [1] (maybe <- 0x800228) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1847
nop
RET1847:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1848: !_DWST [9] (maybe <- 0x80022a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P1849: !_ST [12] (maybe <- 0x40000048) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P1850: !_REPLACEMENT [12] (Int) (Branch target of P1650)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
ba P1851
nop

TARGET1650:
ba RET1650
nop


P1851: !_ST [6] (maybe <- 0x80022b) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1851
nop
RET1851:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1852: !_ST [9] (maybe <- 0x80022c) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1853: !_CASX [15] (maybe <- 0x80022d) (Int) (Branch target of P1783)
add %i3, 192, %l3
ldx [%l3], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %o5
sllx %l4, 32, %o0
casx [%l3], %o5, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4
ba P1854
nop

TARGET1783:
ba RET1783
nop


P1854: !_ST [13] (maybe <- 0x80022e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1855: !_DWST [15] (maybe <- 0x80022f) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P1856: !_ST [0] (maybe <- 0x40000049) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P1857: !_DWST [8] (maybe <- 0x800230) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P1858: !_DWST [12] (maybe <- 0x800231) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1859: !_PREFETCH [14] (Int) (CBR)
prefetch [%i3 + 128], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1859
nop
RET1859:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1860: !_CASX [15] (maybe <- 0x800232) (Int) (CBR)
add %i3, 192, %l3
ldx [%l3], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %o5
sllx %l4, 32, %o2
casx [%l3], %o5, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1860
nop
RET1860:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1861: !_ST [7] (maybe <- 0x800233) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1862: !_ST [10] (maybe <- 0x800234) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1863: !_DWST [11] (maybe <- 0x800235) (Int) (Branch target of P1432)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P1864
nop

TARGET1432:
ba RET1432
nop


P1864: !_ST [1] (maybe <- 0x4000004a) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1864
nop
RET1864:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1865: !_CASX [13] (maybe <- 0x800236) (Int) (CBR)
add %i3, 64, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
sllx %l4, 32, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1865
nop
RET1865:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1866: !_CAS [2] (maybe <- 0x800237) (Int)
add %i0, 12, %o5
lduw [%o5], %o0
mov %o0, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P1867: !_DWST [2] (maybe <- 0x800238) (Int) (Branch target of P1681)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4
ba P1868
nop

TARGET1681:
ba RET1681
nop


P1868: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1869: !_DWST [12] (maybe <- 0x800239) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P1870: !_ST [13] (maybe <- 0x80023a) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1871: !_DWST [5] (maybe <- 0x80023b) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P1872: !_DWST [1] (maybe <- 0x80023c) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P1873: !_ST [15] (maybe <- 0x80023e) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1874: !_DWST [8] (maybe <- 0x4000004b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 256]

P1875: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1876: !_ST [1] (maybe <- 0x80023f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1877: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1878: !_DWST [15] (maybe <- 0x800240) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1879: !_DWST [4] (maybe <- 0x800241) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P1880: !_DWLD [2] (Int)
ldx [%i0 + 8], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1881: !_CASX [8] (maybe <- 0x800242) (Int)
add %i1, 256, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l7
or %l7, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
add  %l4, 1, %l4

P1882: !_ST [6] (maybe <- 0x800243) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1883: !_LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P1884: !_CASX [8] (maybe <- 0x800244) (Int) (CBR)
add %i1, 256, %o5
ldx [%o5], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l7
sllx %l4, 32, %o0
casx [%o5], %l7, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1884
nop
RET1884:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1885: !_CAS [14] (maybe <- 0x800245) (Int)
add %i3, 128, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P1886: !_ST [1] (maybe <- 0x800246) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1886
nop
RET1886:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1887: !_DWST [5] (maybe <- 0x4000004c) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P1888: !_CAS [10] (maybe <- 0x800247) (Int)
add %i2, 32, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P1889: !_CAS [8] (maybe <- 0x800248) (Int) (CBR)
add %i1, 256, %o5
lduw [%o5], %o3
mov %o3, %l7
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1889
nop
RET1889:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1890: !_ST [6] (maybe <- 0x800249) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1891: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1892: !_DWLD [8] (Int)
ldx [%i1 + 256], %o4
! move %o4(upper) -> %o4(upper)

P1893: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1894: !_DWST [6] (maybe <- 0x80024a) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1895: !_DWST [12] (maybe <- 0x4000004d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P1896: !_DWST [10] (maybe <- 0x80024c) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i2 + 32 ] %asi
add   %l4, 1, %l4

P1897: !_ST [10] (maybe <- 0x80024d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1898: !_DWST [5] (maybe <- 0x4000004e) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P1899: !_DWLD [15] (Int)
ldx [%i3 + 192], %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1900: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1901: !_ST [11] (maybe <- 0x4000004f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P1902: !_CASX [2] (maybe <- 0x80024e) (Int)
add %i0, 8, %l6
ldx [%l6], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l3
mov %l4, %o1
casx [%l6], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P1903: !_ST [6] (maybe <- 0x80024f) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P1904: !_ST [3] (maybe <- 0x800250) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1905: !_ST [14] (maybe <- 0x800251) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1906: !_DWST [5] (maybe <- 0x800252) (Int) (Branch target of P1429)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4
ba P1907
nop

TARGET1429:
ba RET1429
nop


P1907: !_ST [1] (maybe <- 0x800253) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i0 + 4] %asi
add   %l4, 1, %l4

P1908: !_DWST [15] (maybe <- 0x800254) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P1909: !_ST [13] (maybe <- 0x800255) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1910: !_ST [15] (maybe <- 0x800256) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1911: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1912: !_ST [15] (maybe <- 0x800257) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1913: !_ST [8] (maybe <- 0x800258) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1914: !_ST [10] (maybe <- 0x800259) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1915: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P1916: !_DWST [0] (maybe <- 0x80025a) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1917: !_CASX [0] (maybe <- 0x80025c) (Int)
add %i0, 0, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %o5
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P1918: !_ST [13] (maybe <- 0x80025e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1919: !_DWST [4] (maybe <- 0x80025f) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i0 + 64 ] %asi
add   %l4, 1, %l4

P1920: !_ST [2] (maybe <- 0x800260) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 12] %asi
add   %l4, 1, %l4

P1921: !_DWST [7] (maybe <- 0x40000050) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P1922: !_DWLD [4] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i0 + 64] %asi, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4

P1923: !_DWST [10] (maybe <- 0x800261) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P1924: !_ST [5] (maybe <- 0x800262) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1925: !_DWST [6] (maybe <- 0x800263) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %o5
add   %l4, 1, %l4
or %o5, %l4, %l3
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
sllx %l6, 32, %o5
or %l6, %o5, %l6 
and %l3, %l6, %o5
srlx %o5, 8, %o5
sllx %l3, 8, %l3
and %l3, %l6, %l3
or %l3, %o5, %l3 
sethi %hi(0xffff0000), %l6
or %l6, %lo(0xffff0000), %l6
srlx %l3, 16, %o5
andn %o5, %l6, %o5
andn %l3, %l6, %l3
sllx %l3, 16, %l3
or %l3, %o5, %l3 
srlx %l3, 32, %o5
sllx %l3, 32, %l3
or %l3, %o5, %o5 
stxa %o5, [%i1 + 80 ] %asi
add   %l4, 1, %l4

P1926: !_ST [15] (maybe <- 0x800265) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1927: !_LD [15] (Int)
lduw [%i3 + 192], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1928: !_ST [15] (maybe <- 0x800266) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1929: !_PREFETCH [0] (Int) (CBR)
prefetch [%i0 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1929
nop
RET1929:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1930: !_ST [5] (maybe <- 0x40000052) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1931: !_REPLACEMENT [8] (Int) (Branch target of P1162)
sethi %hi(0x100), %l7
or %l7, %lo(0x100),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P1932
nop

TARGET1162:
ba RET1162
nop


P1932: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1933: !_ST [13] (maybe <- 0x800267) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1934: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1934
nop
RET1934:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1935: !_ST [9] (maybe <- 0x800268) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1936: !_DWLD [7] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P1937: !_DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1938: !_ST [6] (maybe <- 0x800269) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1938
nop
RET1938:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1939: !_ST [3] (maybe <- 0x80026a) (Int) (CBR) (Branch target of P1521)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1939
nop
RET1939:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P1940
nop

TARGET1521:
ba RET1521
nop


P1940: !_DWST [15] (maybe <- 0x40000053) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P1941: !_ST [3] (maybe <- 0x80026b) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1942: !_ST [9] (maybe <- 0x80026c) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1943: !_ST [3] (maybe <- 0x80026d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1944: !_ST [1] (maybe <- 0x80026e) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1945: !_ST [7] (maybe <- 0x80026f) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1946: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1947: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P1948: !_ST [14] (maybe <- 0x800270) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1949: !_ST [9] (maybe <- 0x800271) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1950: !_ST [4] (maybe <- 0x800272) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i0 + 64] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1950
nop
RET1950:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1951: !_CASX [8] (maybe <- 0x800273) (Int)
add %i1, 256, %o5
ldx [%o5], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %l7
sllx %l4, 32, %o3
casx [%o5], %l7, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P1952: !_ST [14] (maybe <- 0x800274) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1953: !_ST [10] (maybe <- 0x800275) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1954: !_LD [10] (Int)
lduw [%i2 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1955: !_DWST [7] (maybe <- 0x40000054) (FP) (CBR) (Branch target of P1305)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1955
nop
RET1955:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P1956
nop

TARGET1305:
ba RET1305
nop


P1956: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1957: !_ST [9] (maybe <- 0x800276) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1958: !_DWST [8] (maybe <- 0x800277) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P1959: !_ST [10] (maybe <- 0x800278) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1959
nop
RET1959:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1960: !_DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P1961: !_LD [15] (Int) (Branch target of P1955)
lduw [%i3 + 192], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
ba P1962
nop

TARGET1955:
ba RET1955
nop


P1962: !_DWST [13] (maybe <- 0x800279) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P1963: !_ST [15] (maybe <- 0x80027a) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1964: !_ST [12] (maybe <- 0x80027b) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P1965: !_DWST [15] (maybe <- 0x80027c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P1966: !_DWST [0] (maybe <- 0x80027d) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1967: !_ST [3] (maybe <- 0x80027f) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1968: !_REPLACEMENT [7] (Int) (Branch target of P1578)
sethi %hi(0x54), %l7
or %l7, %lo(0x54),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P1969
nop

TARGET1578:
ba RET1578
nop


P1969: !_DWST [1] (maybe <- 0x800280) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P1970: !_ST [3] (maybe <- 0x800282) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1971: !_ST [9] (maybe <- 0x800283) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1971
nop
RET1971:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1972: !_ST [2] (maybe <- 0x40000056) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P1973: !_CASX [6] (maybe <- 0x800284) (Int)
add %i1, 80, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l7
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P1974: !_DWST [3] (maybe <- 0x800286) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P1975: !_DWST [11] (maybe <- 0x800287) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1976: !_DWST [5] (maybe <- 0x800288) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P1977: !_ST [9] (maybe <- 0x800289) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1978: !_ST [5] (maybe <- 0x80028a) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1979: !_ST [5] (maybe <- 0x40000057) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P1980: !_DWST [14] (maybe <- 0x80028b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P1981: !_DWST [11] (maybe <- 0x80028c) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P1982: !_ST [7] (maybe <- 0x80028d) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1983: !_ST [7] (maybe <- 0x80028e) (Int) (Branch target of P1365)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P1984
nop

TARGET1365:
ba RET1365
nop


P1984: !_CASX [3] (maybe <- 0x80028f) (Int)
add %i0, 32, %l6
ldx [%l6], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l3
sllx %l4, 32, %o4
casx [%l6], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P1985: !_LD [15] (Int) (Branch target of P1082)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
ba P1986
nop

TARGET1082:
ba RET1082
nop


P1986: !_ST [7] (maybe <- 0x800290) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1987: !_ST [0] (maybe <- 0x800291) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1988: !_ST [0] (maybe <- 0x800292) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1989: !_DWST [12] (maybe <- 0x800293) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1990: !_DWST [4] (maybe <- 0x800294) (Int) (Branch target of P1132)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P1991
nop

TARGET1132:
ba RET1132
nop


P1991: !_DWST [12] (maybe <- 0x800295) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1992: !_DWST [6] (maybe <- 0x800296) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1993: !_DWST [6] (maybe <- 0x800298) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P1994: !_ST [1] (maybe <- 0x40000058) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P1995: !_ST [9] (maybe <- 0x80029a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1996: !_CAS [7] (maybe <- 0x80029b) (Int)
add %i1, 84, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0
mov %l4, %o1
cas [%l6], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P1997: !_ST [11] (maybe <- 0x80029c) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1998: !_ST [7] (maybe <- 0x80029d) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1999: !_ST [10] (maybe <- 0x80029e) (Int) (Branch target of P1187)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P2000
nop

TARGET1187:
ba RET1187
nop


P2000: !_ST [9] (maybe <- 0x80029f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2001: !_ST [6] (maybe <- 0x8002a0) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2002: !_ST [5] (maybe <- 0x8002a1) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2003: !_ST [12] (maybe <- 0x8002a2) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2004: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P2005: !_CASX [11] (maybe <- 0x8002a3) (Int)
add %i2, 64, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P2006: !_DWST [9] (maybe <- 0x40000059) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P2007: !_DWST [3] (maybe <- 0x8002a4) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P2008: !_ST [9] (maybe <- 0x8002a5) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2009: !_ST [7] (maybe <- 0x8002a6) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2009
nop
RET2009:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2010: !_DWST [13] (maybe <- 0x4000005a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P2011: !_LD [7] (Int) (Branch target of P1707)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
ba P2012
nop

TARGET1707:
ba RET1707
nop


P2012: !_REPLACEMENT [5] (Int) (Branch target of P1269)
sethi %hi(0x4c), %l6
or %l6, %lo(0x4c),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
ba P2013
nop

TARGET1269:
ba RET1269
nop


P2013: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2014: !_ST [8] (maybe <- 0x8002a7) (Int) (Branch target of P1559)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P2015
nop

TARGET1559:
ba RET1559
nop


P2015: !_ST [13] (maybe <- 0x8002a8) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2015
nop
RET2015:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2016: !_ST [15] (maybe <- 0x8002a9) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2016
nop
RET2016:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2017: !_ST [9] (maybe <- 0x4000005b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P2018: !_CASX [9] (maybe <- 0x8002aa) (Int)
add %i1, 512, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %o5
or %o5, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
add  %l4, 1, %l4

P2019: !_ST [14] (maybe <- 0x8002ab) (Int) (CBR)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2019
nop
RET2019:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2020: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2021: !_DWST [1] (maybe <- 0x8002ac) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P2022: !_ST [8] (maybe <- 0x4000005c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P2023: !_CAS [15] (maybe <- 0x8002ae) (Int)
add %i3, 192, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1
mov %l4, %o2
cas [%l6], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2024: !_ST [10] (maybe <- 0x8002af) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2025: !_DWST [13] (maybe <- 0x8002b0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P2026: !_DWST [9] (maybe <- 0x8002b1) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P2027: !_ST [3] (maybe <- 0x8002b2) (Int) (Branch target of P1350)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4
ba P2028
nop

TARGET1350:
ba RET1350
nop


P2028: !_CASX [7] (maybe <- 0x8002b3) (Int) (LE)
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
sllx %l3, 32, %l7
or %l3, %l7, %l3 
and %l6, %l3, %l7
srlx %l7, 8, %l7
sllx %l6, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6 
sethi %hi(0xffff0000), %l3
or %l3, %lo(0xffff0000), %l3
srlx %l6, 16, %l7
andn %l7, %l3, %l7
andn %l6, %l3, %l6
sllx %l6, 16, %l6
or %l6, %l7, %l6 
srlx %l6, 32, %l7
sllx %l6, 32, %l6
or %l6, %l7, %l7 
wr %g0, 0x88, %asi
add %i1, 80, %l6
ldxa [%l6] %asi, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l3
or %l3, %o2, %o2
! move %o5(upper) -> %o3(upper)
or %o5, %g0, %o3
mov %o5, %l3
mov  %l7, %o5
casxa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %o5, 0, %l6
or %l6, %o3, %o3
! move %o5(upper) -> %o4(upper)
or %o5, %g0, %o4
add  %l4, 1, %l4

P2029: !_DWST [8] (maybe <- 0x8002b5) (Int) (LE) (Branch target of P1466)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i1 + 256 ] %asi
add   %l4, 1, %l4
ba P2030
nop

TARGET1466:
ba RET1466
nop


P2030: !_ST [1] (maybe <- 0x8002b6) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2031: !_ST [13] (maybe <- 0x8002b7) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2032: !_ST [11] (maybe <- 0x8002b8) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2033: !_DWST [12] (maybe <- 0x8002b9) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P2034: !_ST [12] (maybe <- 0x8002ba) (Int) (Branch target of P1719)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P2035
nop

TARGET1719:
ba RET1719
nop


P2035: !_ST [7] (maybe <- 0x4000005d) (FP) (Branch target of P1259)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]
ba P2036
nop

TARGET1259:
ba RET1259
nop


P2036: !_CASX [12] (maybe <- 0x8002bb) (Int) (CBR)
add %i3, 0, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l7
or %l7, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2036
nop
RET2036:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2037: !_ST [11] (maybe <- 0x8002bc) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2038: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2039: !_ST [8] (maybe <- 0x8002bd) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2040: !_PREFETCH [14] (Int) (CBR) (Branch target of P1950)
prefetch [%i3 + 128], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2040
nop
RET2040:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P2041
nop

TARGET1950:
ba RET1950
nop


P2041: !_ST [5] (maybe <- 0x8002be) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2042: !_ST [1] (maybe <- 0x8002bf) (Int) (Branch target of P2016)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P2043
nop

TARGET2016:
ba RET2016
nop


P2043: !_ST [1] (maybe <- 0x8002c0) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2044: !_CASX [12] (maybe <- 0x8002c1) (Int)
add %i3, 0, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %o5
or %o5, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
add  %l4, 1, %l4

P2045: !_DWST [0] (maybe <- 0x8002c2) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P2046: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2047: !_ST [10] (maybe <- 0x4000005e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P2048: !_ST [1] (maybe <- 0x4000005f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P2049: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %o5
or %o5, %lo(0x4),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P2050: !_DWST [3] (maybe <- 0x8002c4) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P2051: !_DWST [11] (maybe <- 0x8002c5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2052: !_MEMBAR (Int)
membar #StoreLoad

P2053: !_LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P2054: !_LD [1] (Int)
lduw [%i0 + 4], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2055: !_LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2056: !_LD [3] (Int)
lduw [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2057: !_LD [4] (Int) (Branch target of P1062)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
ba P2058
nop

TARGET1062:
ba RET1062
nop


P2058: !_LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2059: !_LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P2060: !_LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2061: !_LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P2062: !_LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2063: !_LD [10] (Int) (Branch target of P1929)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
ba P2064
nop

TARGET1929:
ba RET1929
nop


P2064: !_LD [11] (Int)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2065: !_LD [12] (FP)
ld [%i3 + 0], %f7
! 1 addresses covered

P2066: !_LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2067: !_LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2068: !_LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

END_NODES1: ! Test istream for CPU 1 ends
sethi %hi(0xdead0e0f), %l7
or    %l7, %lo(0xdead0e0f), %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
stw %l7, [%i5] 
ld [%i5], %f8
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30

restore
retl
nop
!-----------------

! register usage:
! %i0 %i1 %i2 %i3 : base registers for 4 regions
! %i4 fixed pointer to per-cpu results area
! %l1 moving pointer to per-cpu FP results area
! %o7 moving pointer to per-cpu integer results area
! %i5 pointer to per-cpu private area
! %l0 holds lfsr, used as source of random bits 
! %l2 loop count register
! %f16 running counter for unique fp store values
! %f17 holds increment value for fp counter
! %l4 running counter for unique integer store values (increment value is always 1)
! %l5 move-to register for load values (simulation only)
! %f30 move-to register for FP values (simulation only)
! %l3 %l6 %l7 %o5 : 4 temporary registers
! %o0 %o1 %o2 %o3 %o4 : 5 integer results buffer registers
! %f0-f15 FP results buffer registers
! %f32-f47 FP block load/store registers

func2:
! 1000 (dynamic) instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
andn %i0, 63, %i0

add %i1, 63, %i1
andn %i1, 63, %i1

add %i2, 63, %i2
andn %i2, 63, %i2

add %i3, 63, %i3
andn %i3, 63, %i3

add %i4, 63, %i4
andn %i4, 63, %i4

add %i5, 63, %i5
andn %i5, 63, %i5


! Initialize pointer to FP load results area
mov   %i4, %l1

! Initialize pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
add  %o7, %l1, %o7 

! Initialize %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l6
or    %l6, %lo(0xdeadbee0), %l6
stw   %l6, [%i5]
sethi %hi(0xdeadbee1), %l6
or    %l6, %lo(0xdeadbee1), %l6
stw   %l6, [%i5+4]
ldd [%i5], %f0
fmovd %f0, %f2
fmovd %f0, %f4
fmovd %f0, %f6
fmovd %f0, %f8
fmovd %f0, %f10
fmovd %f0, %f12
fmovd %f0, %f14
fmovd %f0, %f16
fmovd %f0, %f18
fmovd %f0, %f20
fmovd %f0, %f22
fmovd %f0, %f24
fmovd %f0, %f26
fmovd %f0, %f28
fmovd %f0, %f30
fmovd %f0, %f32
fmovd %f0, %f34
fmovd %f0, %f36
fmovd %f0, %f38
fmovd %f0, %f40
fmovd %f0, %f42
fmovd %f0, %f44
fmovd %f0, %f46
fmovd %f0, %f48
fmovd %f0, %f50
fmovd %f0, %f52
fmovd %f0, %f54
fmovd %f0, %f56
fmovd %f0, %f58
fmovd %f0, %f60
fmovd %f0, %f62

! Signature for extract_loads script to start extracting load values for this stream
sethi %hi(0x02deade1), %l6
or    %l6, %lo(0x02deade1), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x1000001), %l4
or    %l4, %lo(0x1000001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x40800001), %l6
or    %l6, %lo(0x40800001), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x35000000), %l6
or    %l6, %lo(0x35000000), %l6
stw %l6, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x3004^4
sethi %hi(0x3004), %l0
or    %l0, %lo(0x3004), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 4 to 5 ---
stx %g0, [%i0+64]
stx %g0, [%i1+72]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l7
add %i3, %l7, %l7
sub %l7, -4096, %l7

!-- begin of sync_init ---
or %g0, 1, %o5
or %g0, %o5, %l3
swap [%l7+4], %l3
membar #Sync
sync_init_1_2:
brnz,pt %o5, sync_init_1_2
lduw [%l7+4], %o5 ! delay slot
sync_init_2_2:
lduw [%l7], %o5
sub %o5, 1, %l3
cas [%l7], %o5, %l3
cmp %o5, %l3
bne,pt %xcc, sync_init_2_2
nop
membar #Sync
sync_init_3_2:
lduw [%l7], %o5 ! delay slot
brnz,pt %o5, sync_init_3_2
nop
!-- end of sync_init ---


BEGIN_NODES2: ! Test istream for CPU 2 begins

P2069: !_DWST [13] (maybe <- 0x1000001) (Int) (Loop entry)
sethi %hi(0x1), %l2
or %l2, %lo(0x1),  %l2
loop_entry_2_0:
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2070: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2071: !_DWST [5] (maybe <- 0x1000002) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2072: !_DWST [15] (maybe <- 0x1000003) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P2073: !_DWST [6] (maybe <- 0x1000004) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P2074: !_ST [6] (maybe <- 0x1000006) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i1 + 80] %asi
add   %l4, 1, %l4

P2075: !_DWST [6] (maybe <- 0x1000007) (Int) (Branch target of P2542)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4
ba P2076
nop

TARGET2542:
ba RET2542
nop


P2076: !_CAS [6] (maybe <- 0x1000009) (Int)
add %i1, 80, %l3
lduw [%l3], %o0
mov %o0, %o5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P2077: !_PREFETCH [5] (Int) (Branch target of P2624)
prefetch [%i1 + 76], 1
ba P2078
nop

TARGET2624:
ba RET2624
nop


P2078: !_ST [13] (maybe <- 0x100000a) (Int) (CBR) (Branch target of P2342)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2078
nop
RET2078:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2079
nop

TARGET2342:
ba RET2342
nop


P2079: !_LD [15] (Int) (CBR)
lduw [%i3 + 192], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2079
nop
RET2079:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2080: !_DWST [4] (maybe <- 0x100000b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P2081: !_ST [5] (maybe <- 0x100000c) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2082: !_ST [13] (maybe <- 0x100000d) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2083: !_ST [10] (maybe <- 0x100000e) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2084: !_DWST [0] (maybe <- 0x100000f) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P2085: !_CASX [10] (maybe <- 0x1000011) (Int) (Branch target of P2815)
add %i2, 32, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l7
or %l7, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
add  %l4, 1, %l4
ba P2086
nop

TARGET2815:
ba RET2815
nop


P2086: !_DWST [12] (maybe <- 0x1000012) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P2087: !_NOP (Int)
nop

P2088: !_ST [10] (maybe <- 0x1000013) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2089: !_DWST [11] (maybe <- 0x1000014) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P2090: !_ST [1] (maybe <- 0x1000015) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2091: !_ST [3] (maybe <- 0x1000016) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2092: !_DWST [10] (maybe <- 0x40800001) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P2093: !_DWLD [15] (Int)
ldx [%i3 + 192], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %o5
or %o5, %o3, %o3

P2094: !_LD [13] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i3 + 64] %asi, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2095: !_LD [2] (FP)
ld [%i0 + 12], %f0
! 1 addresses covered

P2096: !_DWST [2] (maybe <- 0x1000017) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P2097: !_DWST [7] (maybe <- 0x1000018) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %l7
add   %l4, 1, %l4
or %l7, %l4, %o5
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
sllx %l3, 32, %l7
or %l3, %l7, %l3 
and %o5, %l3, %l7
srlx %l7, 8, %l7
sllx %o5, 8, %o5
and %o5, %l3, %o5
or %o5, %l7, %o5 
sethi %hi(0xffff0000), %l3
or %l3, %lo(0xffff0000), %l3
srlx %o5, 16, %l7
andn %l7, %l3, %l7
andn %o5, %l3, %o5
sllx %o5, 16, %o5
or %o5, %l7, %o5 
srlx %o5, 32, %l7
sllx %o5, 32, %o5
or %o5, %l7, %l7 
stxa %l7, [%i1 + 80 ] %asi
add   %l4, 1, %l4

P2098: !_DWST [8] (maybe <- 0x100001a) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2098
nop
RET2098:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2099: !_ST [5] (maybe <- 0x100001b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2100: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2101: !_ST [0] (maybe <- 0x100001c) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2102: !_DWST [12] (maybe <- 0x100001d) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2102
nop
RET2102:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2103: !_LD [13] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i3 + 64] %asi, %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2104: !_ST [13] (maybe <- 0x100001e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2105: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2106: !_ST [10] (maybe <- 0x100001f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2107: !_DWST [2] (maybe <- 0x1000020) (Int) (CBR)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2107
nop
RET2107:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2108: !_ST [6] (maybe <- 0x1000021) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2109: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2110: !_ST [11] (maybe <- 0x1000022) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2111: !_ST [2] (maybe <- 0x1000023) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2112: !_ST [4] (maybe <- 0x1000024) (Int) (CBR)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2112
nop
RET2112:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2113: !_ST [13] (maybe <- 0x1000025) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2114: !_ST [6] (maybe <- 0x40800002) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P2115: !_LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2116: !_DWST [2] (maybe <- 0x1000026) (Int) (Branch target of P2156)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4
ba P2117
nop

TARGET2156:
ba RET2156
nop


P2117: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2118: !_ST [14] (maybe <- 0x1000027) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2119: !_DWLD [14] (Int)
ldx [%i3 + 128], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l7
or %l7, %o0, %o0

P2120: !_LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2121: !_ST [15] (maybe <- 0x1000028) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2122: !_ST [0] (maybe <- 0x1000029) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2123: !_ST [7] (maybe <- 0x100002a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2124: !_DWST [6] (maybe <- 0x100002b) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2125: !_ST [15] (maybe <- 0x100002d) (Int) (Branch target of P2678)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P2126
nop

TARGET2678:
ba RET2678
nop


P2126: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2127: !_ST [7] (maybe <- 0x100002e) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2128: !_ST [11] (maybe <- 0x100002f) (Int) (CBR)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2128
nop
RET2128:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2129: !_ST [6] (maybe <- 0x1000030) (Int) (Branch target of P2112)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4
ba P2130
nop

TARGET2112:
ba RET2112
nop


P2130: !_CAS [6] (maybe <- 0x1000031) (Int)
add %i1, 80, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1
mov %l4, %o2
cas [%l3], %o5, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2131: !_ST [1] (maybe <- 0x1000032) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2132: !_CAS [12] (maybe <- 0x1000033) (Int)
add %i3, 0, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2
mov %l4, %o3
cas [%o5], %l7, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2133: !_DWLD [9] (Int) (CBR)
ldx [%i1 + 512], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l7
or %l7, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2133
nop
RET2133:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2134: !_ST [9] (maybe <- 0x1000034) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2135: !_CASX [4] (maybe <- 0x1000035) (Int)
add %i0, 64, %l6
ldx [%l6], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l3
sllx %l4, 32, %o0
casx [%l6], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P2136: !_CAS [1] (maybe <- 0x1000036) (Int)
add %i0, 4, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P2137: !_ST [6] (maybe <- 0x1000037) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2138: !_CAS [4] (maybe <- 0x1000038) (Int) (Branch target of P2198)
add %i0, 64, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4
ba P2139
nop

TARGET2198:
ba RET2198
nop


P2139: !_DWST [8] (maybe <- 0x1000039) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P2140: !_ST [0] (maybe <- 0x100003a) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2141: !_DWST [13] (maybe <- 0x100003b) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %o5
srl %o5, 8, %o5
sll %l4, 8, %l7
and %l7, %l6, %l7
or %l7, %o5, %l7
srl %l7, 16, %o5
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %o5, %l7
stxa %l7, [%i3 + 64 ] %asi
add   %l4, 1, %l4

P2142: !_ST [7] (maybe <- 0x100003c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2143: !_ST [10] (maybe <- 0x100003d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2144: !_ST [11] (maybe <- 0x100003e) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2145: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l6
or %l6, %lo(0x20),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2146: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l3
or %l3, %lo(0x100),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2147: !_NOP (Int) (Branch target of P2946)
nop
ba P2148
nop

TARGET2946:
ba RET2946
nop


P2148: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2149: !_DWST [5] (maybe <- 0x100003f) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P2150: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l7
or %l7, %lo(0x4),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2151: !_DWST [9] (maybe <- 0x1000040) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2152: !_ST [7] (maybe <- 0x1000041) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2153: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P2154: !_ST [5] (maybe <- 0x1000042) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2155: !_ST [5] (maybe <- 0x1000043) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2156: !_DWST [15] (maybe <- 0x1000044) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2156
nop
RET2156:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2157: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2158: !_CASX [7] (maybe <- 0x1000045) (Int)
add %i1, 80, %l6
ldx [%l6], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l3
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
casx [%l6], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2159: !_DWST [5] (maybe <- 0x1000047) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2160: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2161: !_DWST [12] (maybe <- 0x1000048) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P2162: !_ST [7] (maybe <- 0x1000049) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2163: !_ST [1] (maybe <- 0x100004a) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2164: !_DWST [4] (maybe <- 0x100004b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P2165: !_ST [2] (maybe <- 0x100004c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2166: !_DWST [13] (maybe <- 0x100004d) (Int) (Branch target of P2253)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P2167
nop

TARGET2253:
ba RET2253
nop


P2167: !_DWST [14] (maybe <- 0x100004e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P2168: !_DWST [3] (maybe <- 0x100004f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P2169: !_ST [15] (maybe <- 0x1000050) (Int) (Branch target of P2998)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P2170
nop

TARGET2998:
ba RET2998
nop


P2170: !_DWST [12] (maybe <- 0x1000051) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2171: !_ST [3] (maybe <- 0x40800003) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P2172: !_DWST [13] (maybe <- 0x1000052) (Int) (Branch target of P2826)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P2173
nop

TARGET2826:
ba RET2826
nop


P2173: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2174: !_ST [10] (maybe <- 0x1000053) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2175: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2176: !_DWLD [13] (FP)
ldd [%i3 + 64], %f18
! 1 addresses covered
fmovs %f18, %f1

P2177: !_DWST [4] (maybe <- 0x1000054) (Int) (Branch target of P2291)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P2178
nop

TARGET2291:
ba RET2291
nop


P2178: !_REPLACEMENT [1] (Int) (Branch target of P3075)
sethi %hi(0x4), %l3
or %l3, %lo(0x4),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
ba P2179
nop

TARGET3075:
ba RET3075
nop


P2179: !_DWST [13] (maybe <- 0x1000055) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P2180: !_ST [11] (maybe <- 0x1000056) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2181: !_CAS [0] (maybe <- 0x1000057) (Int)
add %i0, 0, %l7
lduw [%l7], %o0
mov %o0, %l6
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P2182: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2183: !_CAS [9] (maybe <- 0x1000058) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %l6, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
wr %g0, 0x88, %asi
add %i1, 512, %l6
lduwa [%l6] %asi, %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l7, %o5
casa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P2184: !_ST [12] (maybe <- 0x1000059) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2185: !_CAS [6] (maybe <- 0x100005a) (Int)
add %i1, 80, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4

P2186: !_CAS [6] (maybe <- 0x100005b) (Int)
add %i1, 80, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P2187: !_DWST [1] (maybe <- 0x100005c) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P2188: !_LD [9] (Int)
lduw [%i1 + 512], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2189: !_DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0

P2190: !_ST [4] (maybe <- 0x100005e) (Int) (Branch target of P2647)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P2191
nop

TARGET2647:
ba RET2647
nop


P2191: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2192: !_ST [7] (maybe <- 0x100005f) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2193: !_DWST [3] (maybe <- 0x40800004) (FP) (Branch target of P2455)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]
ba P2194
nop

TARGET2455:
ba RET2455
nop


P2194: !_ST [13] (maybe <- 0x1000060) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 64] %asi
add   %l4, 1, %l4

P2195: !_ST [10] (maybe <- 0x1000061) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2196: !_DWLD [8] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i1 + 256] %asi, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l6
or %l6, %o0, %o0

P2197: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2198: !_DWLD [4] (Int) (CBR)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2198
nop
RET2198:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2199: !_DWST [10] (maybe <- 0x40800005) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P2200: !_ST [1] (maybe <- 0x1000062) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2201: !_ST [8] (maybe <- 0x1000063) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2202: !_DWST [8] (maybe <- 0x1000064) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P2203: !_ST [9] (maybe <- 0x40800006) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P2204: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2205: !_ST [15] (maybe <- 0x1000065) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2206: !_SWAP [5] (maybe <- 0x1000066) (Int)
mov %l4, %l7
swap  [%i1 + 76], %l7
! move %l7(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P2207: !_ST [3] (maybe <- 0x1000067) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2208: !_ST [8] (maybe <- 0x1000068) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2209: !_CAS [15] (maybe <- 0x1000069) (Int)
add %i3, 192, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2210: !_ST [4] (maybe <- 0x100006a) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2211: !_DWLD [1] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P2212: !_LD [11] (Int) (CBR)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2212
nop
RET2212:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2213: !_ST [15] (maybe <- 0x100006b) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2214: !_DWST [9] (maybe <- 0x100006c) (Int) (Branch target of P2098)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4
ba P2215
nop

TARGET2098:
ba RET2098
nop


P2215: !_DWLD [1] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0

P2216: !_ST [15] (maybe <- 0x100006d) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2217: !_ST [15] (maybe <- 0x40800007) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P2218: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2219: !_DWST [5] (maybe <- 0x100006e) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P2220: !_ST [9] (maybe <- 0x100006f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2221: !_ST [2] (maybe <- 0x1000070) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2222: !_SWAP [9] (maybe <- 0x1000071) (Int)
mov %l4, %l7
swap  [%i1 + 512], %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P2223: !_CAS [3] (maybe <- 0x1000072) (Int)
add %i0, 32, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P2224: !_ST [12] (maybe <- 0x1000073) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2225: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2226: !_DWST [4] (maybe <- 0x40800008) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P2227: !_ST [10] (maybe <- 0x1000074) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2228: !_CAS [13] (maybe <- 0x1000075) (Int) (Branch target of P2255)
add %i3, 64, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4
ba P2229
nop

TARGET2255:
ba RET2255
nop


P2229: !_DWST [13] (maybe <- 0x1000076) (Int) (Branch target of P2704)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P2230
nop

TARGET2704:
ba RET2704
nop


P2230: !_ST [2] (maybe <- 0x1000077) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2231: !_CASX [12] (maybe <- 0x1000078) (Int)
add %i3, 0, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
sllx %l4, 32, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2232: !_ST [5] (maybe <- 0x1000079) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2232
nop
RET2232:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2233: !_DWST [2] (maybe <- 0x40800009) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P2234: !_DWST [7] (maybe <- 0x4080000a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P2235: !_ST [8] (maybe <- 0x100007a) (Int) (Branch target of P2321)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P2236
nop

TARGET2321:
ba RET2321
nop


P2236: !_DWLD [10] (Int) (Branch target of P3001)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)
ba P2237
nop

TARGET3001:
ba RET3001
nop


P2237: !_ST [1] (maybe <- 0x100007b) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i0 + 4] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2237
nop
RET2237:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2238: !_ST [7] (maybe <- 0x100007c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2239: !_CASX [11] (maybe <- 0x100007d) (Int)
add %i2, 64, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

P2240: !_LD [8] (Int)
lduw [%i1 + 256], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

P2241: !_ST [2] (maybe <- 0x100007e) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2242: !_ST [14] (maybe <- 0x100007f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2243: !_ST [8] (maybe <- 0x1000080) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2244: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2245: !_CASX [2] (maybe <- 0x1000081) (Int)
add %i0, 8, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
mov %l4, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2246: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2247: !_ST [4] (maybe <- 0x1000082) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2248: !_ST [3] (maybe <- 0x1000083) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2249: !_ST [10] (maybe <- 0x1000084) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2250: !_ST [4] (maybe <- 0x1000085) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2251: !_ST [4] (maybe <- 0x1000086) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2252: !_PREFETCH [9] (Int) (Branch target of P3003)
prefetch [%i1 + 512], 1
ba P2253
nop

TARGET3003:
ba RET3003
nop


P2253: !_ST [2] (maybe <- 0x1000087) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2253
nop
RET2253:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2254: !_ST [13] (maybe <- 0x1000088) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2255: !_ST [2] (maybe <- 0x1000089) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2255
nop
RET2255:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2256: !_ST [12] (maybe <- 0x4080000c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P2257: !_DWST [14] (maybe <- 0x100008a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P2258: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2259: !_ST [1] (maybe <- 0x100008b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2260: !_ST [7] (maybe <- 0x100008c) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2260
nop
RET2260:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2261: !_ST [8] (maybe <- 0x100008d) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2262: !_ST [3] (maybe <- 0x100008e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2263: !_DWLD [1] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2264: !_ST [5] (maybe <- 0x100008f) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2265: !_ST [14] (maybe <- 0x1000090) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2266: !_DWST [9] (maybe <- 0x4080000d) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2266
nop
RET2266:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2267: !_DWST [8] (maybe <- 0x1000091) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P2268: !_CAS [8] (maybe <- 0x1000092) (Int)
add %i1, 256, %o5
lduw [%o5], %o1
mov %o1, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P2269: !_ST [13] (maybe <- 0x1000093) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2270: !_ST [2] (maybe <- 0x1000094) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2271: !_ST [0] (maybe <- 0x1000095) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2272: !_DWLD [11] (Int)
ldx [%i2 + 64], %o2
! move %o2(upper) -> %o2(upper)

P2273: !_ST [8] (maybe <- 0x1000096) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2274: !_ST [5] (maybe <- 0x1000097) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2275: !_ST [12] (maybe <- 0x1000098) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 0] %asi
add   %l4, 1, %l4

P2276: !_DWST [11] (maybe <- 0x1000099) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P2277: !_ST [10] (maybe <- 0x100009a) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2278: !_ST [11] (maybe <- 0x4080000e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P2279: !_DWLD [4] (Int)
ldx [%i0 + 64], %l3
! move %l3(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l3, 32, %o5
or %o5, %o2, %o2

P2280: !_DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P2281: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2282: !_ST [2] (maybe <- 0x100009b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2283: !_ST [0] (maybe <- 0x100009c) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2284: !_CAS [10] (maybe <- 0x100009d) (Int) (Branch target of P3095)
add %i2, 32, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4
ba P2285
nop

TARGET3095:
ba RET3095
nop


P2285: !_DWST [10] (maybe <- 0x100009e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2286: !_ST [6] (maybe <- 0x100009f) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2287: !_DWST [10] (maybe <- 0x10000a0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P2288: !_DWST [8] (maybe <- 0x10000a1) (Int) (Branch target of P2584)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4
ba P2289
nop

TARGET2584:
ba RET2584
nop


P2289: !_DWST [12] (maybe <- 0x10000a2) (Int) (Branch target of P2872)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4
ba P2290
nop

TARGET2872:
ba RET2872
nop


P2290: !_ST [2] (maybe <- 0x10000a3) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2291: !_REPLACEMENT [10] (Int) (CBR)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2291
nop
RET2291:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2292: !_ST [14] (maybe <- 0x10000a4) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2293: !_ST [2] (maybe <- 0x4080000f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P2294: !_CASX [0] (maybe <- 0x10000a5) (Int) (Branch target of P3018)
add %i0, 0, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l3, %l6
sllx %l4, 32, %l3
add  %l4, 1, %l4
or   %l4, %l3, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l7
or %l7, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
add  %l4, 1, %l4
ba P2295
nop

TARGET3018:
ba RET3018
nop


P2295: !_ST [6] (maybe <- 0x10000a7) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2296: !_ST [10] (maybe <- 0x10000a8) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2297: !_SWAP [6] (maybe <- 0x10000a9) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P2298: !_DWST [3] (maybe <- 0x10000aa) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P2299: !_PREFETCH [4] (Int) (Branch target of P2375)
prefetch [%i0 + 64], 1
ba P2300
nop

TARGET2375:
ba RET2375
nop


P2300: !_DWST [4] (maybe <- 0x10000ab) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2301: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2302: !_DWST [4] (maybe <- 0x10000ac) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P2303: !_DWLD [8] (Int)
ldx [%i1 + 256], %o2
! move %o2(upper) -> %o2(upper)

P2304: !_DWST [12] (maybe <- 0x10000ad) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2304
nop
RET2304:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2305: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2306: !_CAS [12] (maybe <- 0x10000ae) (Int) (Branch target of P2642)
add %i3, 0, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4
ba P2307
nop

TARGET2642:
ba RET2642
nop


P2307: !_LD [13] (Int)
lduw [%i3 + 64], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P2308: !_DWST [2] (maybe <- 0x10000af) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P2309: !_ST [14] (maybe <- 0x40800010) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P2310: !_ST [13] (maybe <- 0x10000b0) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2311: !_DWST [3] (maybe <- 0x10000b1) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P2312: !_ST [15] (maybe <- 0x10000b2) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2313: !_ST [14] (maybe <- 0x10000b3) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2314: !_ST [11] (maybe <- 0x10000b4) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2315: !_CAS [10] (maybe <- 0x10000b5) (Int)
add %i2, 32, %l6
lduw [%l6], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P2316: !_DWST [9] (maybe <- 0x10000b6) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i1 + 512 ] %asi
add   %l4, 1, %l4

P2317: !_DWLD [7] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2318: !_DWST [10] (maybe <- 0x10000b7) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2319: !_DWST [2] (maybe <- 0x10000b8) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P2320: !_DWST [9] (maybe <- 0x10000b9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P2321: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2321
nop
RET2321:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2322: !_ST [3] (maybe <- 0x10000ba) (Int) (Branch target of P2860)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4
ba P2323
nop

TARGET2860:
ba RET2860
nop


P2323: !_ST [2] (maybe <- 0x10000bb) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2324: !_ST [3] (maybe <- 0x10000bc) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2325: !_ST [12] (maybe <- 0x10000bd) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2326: !_SWAP [11] (maybe <- 0x10000be) (Int) (Branch target of P2102)
mov %l4, %o1
swap  [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4
ba P2327
nop

TARGET2102:
ba RET2102
nop


P2327: !_CAS [15] (maybe <- 0x10000bf) (Int)
add %i3, 192, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1
mov %l4, %o2
cas [%o5], %l7, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2328: !_DWLD [9] (Int) (Branch target of P2659)
ldx [%i1 + 512], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2
ba P2329
nop

TARGET2659:
ba RET2659
nop


P2329: !_ST [5] (maybe <- 0x10000c0) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2330: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2331: !_ST [15] (maybe <- 0x10000c1) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2332: !_ST [15] (maybe <- 0x40800011) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P2333: !_CAS [9] (maybe <- 0x10000c2) (Int)
add %i1, 512, %l7
lduw [%l7], %o3
mov %o3, %l6
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o3(lower)
srl %l3, 0, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2334: !_ST [6] (maybe <- 0x10000c3) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2335: !_ST [10] (maybe <- 0x10000c4) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2335
nop
RET2335:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2336: !_DWST [4] (maybe <- 0x10000c5) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P2337: !_ST [11] (maybe <- 0x10000c6) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2338: !_DWST [9] (maybe <- 0x10000c7) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P2339: !_ST [3] (maybe <- 0x10000c8) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2340: !_DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2341: !_ST [3] (maybe <- 0x10000c9) (Int) (Branch target of P2475)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4
ba P2342
nop

TARGET2475:
ba RET2475
nop


P2342: !_DWLD [15] (FP) (CBR)
ldd [%i3 + 192], %f2
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2342
nop
RET2342:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2343: !_ST [15] (maybe <- 0x10000ca) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2344: !_ST [5] (maybe <- 0x10000cb) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2345: !_CASX [8] (maybe <- 0x10000cc) (Int)
add %i1, 256, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l6
or %l6, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
add  %l4, 1, %l4

P2346: !_ST [10] (maybe <- 0x10000cd) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2347: !_ST [8] (maybe <- 0x10000ce) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 256] %asi
add   %l4, 1, %l4

P2348: !_ST [9] (maybe <- 0x10000cf) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2349: !_DWST [5] (maybe <- 0x10000d0) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2350: !_DWST [8] (maybe <- 0x10000d1) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P2351: !_DWLD [6] (Int)
ldx [%i1 + 80], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %o5
or %o5, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2

P2352: !_DWST [0] (maybe <- 0x10000d2) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P2353: !_ST [6] (maybe <- 0x10000d4) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2354: !_CAS [7] (maybe <- 0x10000d5) (Int)
add %i1, 84, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2
mov %l4, %o3
cas [%l3], %o5, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2355: !_ST [8] (maybe <- 0x10000d6) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2356: !_ST [6] (maybe <- 0x10000d7) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2357: !_DWST [6] (maybe <- 0x10000d8) (Int) (Branch target of P3049)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4
ba P2358
nop

TARGET3049:
ba RET3049
nop


P2358: !_DWST [3] (maybe <- 0x10000da) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2358
nop
RET2358:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2359: !_DWST [10] (maybe <- 0x10000db) (Int) (Branch target of P3009)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4
ba P2360
nop

TARGET3009:
ba RET3009
nop


P2360: !_ST [8] (maybe <- 0x10000dc) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2361: !_ST [1] (maybe <- 0x40800012) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P2362: !_SWAP [12] (maybe <- 0x10000dd) (Int) (LE)
wr %g0, 0x88, %asi
mov %l4, %o5
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %o5, %l6, %l7
srl %l7, 8, %l7
sll %o5, 8, %o5
and %o5, %l6, %o5
or %o5, %l7, %o5
srl %o5, 16, %l7
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l7, %o5
swapa  [%i3 + 0] %asi, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P2363: !_DWLD [13] (FP)
ldd [%i3 + 64], %f18
! 1 addresses covered
fmovs %f18, %f3

P2364: !_DWST [8] (maybe <- 0x10000de) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P2365: !_ST [12] (maybe <- 0x10000df) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2366: !_DWST [1] (maybe <- 0x10000e0) (Int) (LE) (Branch target of P2078)
wr %g0, 0x88, %asi
sllx %l4, 32, %l7
add   %l4, 1, %l4
or %l7, %l4, %o5
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
sllx %l3, 32, %l7
or %l3, %l7, %l3 
and %o5, %l3, %l7
srlx %l7, 8, %l7
sllx %o5, 8, %o5
and %o5, %l3, %o5
or %o5, %l7, %o5 
sethi %hi(0xffff0000), %l3
or %l3, %lo(0xffff0000), %l3
srlx %o5, 16, %l7
andn %l7, %l3, %l7
andn %o5, %l3, %o5
sllx %o5, 16, %o5
or %o5, %l7, %o5 
srlx %o5, 32, %l7
sllx %o5, 32, %o5
or %o5, %l7, %l7 
stxa %l7, [%i0 + 0 ] %asi
add   %l4, 1, %l4
ba P2367
nop

TARGET2078:
ba RET2078
nop


P2367: !_ST [0] (maybe <- 0x10000e2) (Int) (Branch target of P2777)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P2368
nop

TARGET2777:
ba RET2777
nop


P2368: !_CAS [11] (maybe <- 0x10000e3) (Int)
add %i2, 64, %l6
lduw [%l6], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P2369: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2370: !_SWAP [15] (maybe <- 0x10000e4) (Int) (Branch target of P2496)
mov %l4, %o0
swap  [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4
ba P2371
nop

TARGET2496:
ba RET2496
nop


P2371: !_ST [8] (maybe <- 0x10000e5) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 256] %asi
add   %l4, 1, %l4

P2372: !_LD [5] (Int)
lduw [%i1 + 76], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P2373: !_LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2374: !_ST [14] (maybe <- 0x10000e6) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2375: !_DWST [10] (maybe <- 0x40800013) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2375
nop
RET2375:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2376: !_LD [2] (Int)
lduw [%i0 + 12], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P2377: !_ST [7] (maybe <- 0x10000e7) (Int) (Branch target of P2594)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P2378
nop

TARGET2594:
ba RET2594
nop


P2378: !_ST [0] (maybe <- 0x10000e8) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2379: !_DWST [2] (maybe <- 0x10000e9) (Int) (CBR) (Branch target of P2395)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2379
nop
RET2379:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P2380
nop

TARGET2395:
ba RET2395
nop


P2380: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2381: !_CAS [8] (maybe <- 0x10000ea) (Int) (CBR)
add %i1, 256, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2381
nop
RET2381:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2382: !_DWLD [9] (Int) (CBR)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2382
nop
RET2382:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2383: !_ST [15] (maybe <- 0x10000eb) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2384: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2385: !_DWST [12] (maybe <- 0x10000ec) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P2386: !_ST [4] (maybe <- 0x10000ed) (Int) (Branch target of P2786)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4
ba P2387
nop

TARGET2786:
ba RET2786
nop


P2387: !_DWST [11] (maybe <- 0x10000ee) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2387
nop
RET2387:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2388: !_DWLD [9] (Int) (Branch target of P2446)
ldx [%i1 + 512], %o5
! move %o5(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %o5, 32, %l7
or %l7, %o3, %o3
ba P2389
nop

TARGET2446:
ba RET2446
nop


P2389: !_DWST [7] (maybe <- 0x10000ef) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P2390: !_DWST [10] (maybe <- 0x10000f1) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P2391: !_DWST [1] (maybe <- 0x10000f2) (Int) (CBR)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2391
nop
RET2391:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2392: !_ST [8] (maybe <- 0x10000f4) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2393: !_DWST [11] (maybe <- 0x10000f5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P2394: !_DWST [2] (maybe <- 0x10000f6) (Int) (Branch target of P2943)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4
ba P2395
nop

TARGET2943:
ba RET2943
nop


P2395: !_DWLD [15] (Int) (CBR) (Branch target of P2445)
ldx [%i3 + 192], %o4
! move %o4(upper) -> %o4(upper)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2395
nop
RET2395:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P2396
nop

TARGET2445:
ba RET2445
nop


P2396: !_ST [12] (maybe <- 0x10000f7) (Int) (Branch target of P2607)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P2397
nop

TARGET2607:
ba RET2607
nop


P2397: !_CASX [2] (maybe <- 0x10000f8) (Int)
add %i0, 8, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov  %l3, %l6
mov %l4, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l7
or %l7, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
add  %l4, 1, %l4

P2398: !_ST [4] (maybe <- 0x10000f9) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2399: !_DWST [14] (maybe <- 0x10000fa) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P2400: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2401: !_ST [15] (maybe <- 0x10000fb) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2402: !_ST [5] (maybe <- 0x10000fc) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2403: !_ST [14] (maybe <- 0x10000fd) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2404: !_DWST [9] (maybe <- 0x10000fe) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P2405: !_CAS [5] (maybe <- 0x10000ff) (Int)
add %i1, 76, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1
mov %l4, %o2
cas [%l3], %o5, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2406: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2407: !_DWST [5] (maybe <- 0x1000100) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P2408: !_SWAP [14] (maybe <- 0x1000101) (Int)
mov %l4, %l3
swap  [%i3 + 128], %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P2409: !_ST [14] (maybe <- 0x1000102) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2410: !_ST [14] (maybe <- 0x1000103) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2411: !_CAS [11] (maybe <- 0x1000104) (Int)
add %i2, 64, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P2412: !_DWST [12] (maybe <- 0x1000105) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P2413: !_ST [0] (maybe <- 0x1000106) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2414: !_DWST [10] (maybe <- 0x1000107) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2415: !_DWST [7] (maybe <- 0x1000108) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P2416: !_DWST [15] (maybe <- 0x100010a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P2417: !_ST [15] (maybe <- 0x100010b) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2418: !_DWST [8] (maybe <- 0x100010c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2419: !_DWST [9] (maybe <- 0x100010d) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P2420: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2421: !_ST [7] (maybe <- 0x100010e) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2422: !_ST [11] (maybe <- 0x100010f) (Int) (Branch target of P2818)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P2423
nop

TARGET2818:
ba RET2818
nop


P2423: !_CAS [3] (maybe <- 0x1000110) (Int)
add %i0, 32, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P2424: !_DWLD [13] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i3 + 64] %asi, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0

P2425: !_ST [13] (maybe <- 0x1000111) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2425
nop
RET2425:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2426: !_ST [12] (maybe <- 0x1000112) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2427: !_DWST [5] (maybe <- 0x1000113) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
sllx %o5, 32, %o5 
stxa %o5, [%i1 + 72 ] %asi
add   %l4, 1, %l4

P2428: !_DWST [10] (maybe <- 0x1000114) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2429: !_ST [1] (maybe <- 0x1000115) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2430: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2431: !_DWST [14] (maybe <- 0x1000116) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P2432: !_PREFETCH [3] (Int) (CBR)
prefetch [%i0 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2432
nop
RET2432:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2433: !_ST [4] (maybe <- 0x1000117) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2434: !_DWST [5] (maybe <- 0x1000118) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P2435: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2435
nop
RET2435:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2436: !_ST [13] (maybe <- 0x1000119) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2437: !_DWST [9] (maybe <- 0x100011a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P2438: !_DWST [5] (maybe <- 0x100011b) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2439: !_ST [2] (maybe <- 0x100011c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2440: !_ST [13] (maybe <- 0x100011d) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2441: !_DWST [4] (maybe <- 0x100011e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2442: !_DWST [9] (maybe <- 0x100011f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P2443: !_ST [5] (maybe <- 0x1000120) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2444: !_CAS [2] (maybe <- 0x1000121) (Int)
add %i0, 12, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2445: !_ST [5] (maybe <- 0x1000122) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2445
nop
RET2445:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2446: !_LD [4] (Int) (CBR)
lduw [%i0 + 64], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2446
nop
RET2446:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2447: !_DWST [4] (maybe <- 0x1000123) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2448: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2449: !_ST [1] (maybe <- 0x1000124) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2450: !_SWAP [0] (maybe <- 0x1000125) (Int)
mov %l4, %o2
swap  [%i0 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2451: !_CAS [9] (maybe <- 0x1000126) (Int)
add %i1, 512, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2
mov %l4, %o3
cas [%o5], %l7, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2452: !_DWLD [4] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i0 + 64] %asi, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l7
or %l7, %o3, %o3

P2453: !_CAS [11] (maybe <- 0x1000127) (Int)
add %i2, 64, %l6
lduw [%l6], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P2454: !_DWST [1] (maybe <- 0x1000128) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P2455: !_ST [5] (maybe <- 0x100012a) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2455
nop
RET2455:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2456: !_ST [3] (maybe <- 0x100012b) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2457: !_LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2458: !_ST [6] (maybe <- 0x100012c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2459: !_DWLD [0] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %o5
or %o5, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1

P2460: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2460
nop
RET2460:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2461: !_ST [7] (maybe <- 0x100012d) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2462: !_ST [11] (maybe <- 0x100012e) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2463: !_ST [1] (maybe <- 0x100012f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2464: !_ST [0] (maybe <- 0x40800014) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P2465: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2466: !_ST [3] (maybe <- 0x40800015) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P2467: !_REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l3
or %l3, %lo(0xc0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2468: !_CAS [4] (maybe <- 0x1000130) (Int)
add %i0, 64, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1
mov %l4, %o2
cas [%l3], %o5, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2469: !_DWST [7] (maybe <- 0x1000131) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2470: !_LD [4] (FP) (Branch target of P2538)
ld [%i0 + 64], %f4
! 1 addresses covered
ba P2471
nop

TARGET2538:
ba RET2538
nop


P2471: !_ST [1] (maybe <- 0x1000133) (Int) (Branch target of P3070)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P2472
nop

TARGET3070:
ba RET3070
nop


P2472: !_REPLACEMENT [11] (Int) (CBR)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2472
nop
RET2472:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2473: !_DWST [9] (maybe <- 0x1000134) (Int) (Branch target of P2652)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4
ba P2474
nop

TARGET2652:
ba RET2652
nop


P2474: !_DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2

P2475: !_DWST [8] (maybe <- 0x1000135) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2475
nop
RET2475:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2476: !_ST [2] (maybe <- 0x1000136) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2477: !_CASX [8] (maybe <- 0x1000137) (Int)
add %i1, 256, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
sllx %l4, 32, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2478: !_ST [12] (maybe <- 0x1000138) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2479: !_DWST [14] (maybe <- 0x1000139) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P2480: !_DWLD [3] (Int)
ldx [%i0 + 32], %o0
! move %o0(upper) -> %o0(upper)

P2481: !_ST [5] (maybe <- 0x100013a) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2482: !_CASX [10] (maybe <- 0x100013b) (Int)
add %i2, 32, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %o5, 32, %l3
or %l3, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l6
or %l6, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
add  %l4, 1, %l4

P2483: !_DWLD [11] (FP)
ldd [%i2 + 64], %f18
! 1 addresses covered
fmovs %f18, %f5

P2484: !_LD [2] (Int) (CBR) (Branch target of P2908)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2484
nop
RET2484:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2485
nop

TARGET2908:
ba RET2908
nop


P2485: !_ST [12] (maybe <- 0x100013c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2486: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2487: !_ST [9] (maybe <- 0x40800016) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P2488: !_DWST [4] (maybe <- 0x100013d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2489: !_ST [10] (maybe <- 0x100013e) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2490: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2491: !_DWST [4] (maybe <- 0x100013f) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P2492: !_ST [11] (maybe <- 0x1000140) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2493: !_ST [11] (maybe <- 0x1000141) (Int) (Branch target of P2663)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P2494
nop

TARGET2663:
ba RET2663
nop


P2494: !_DWST [4] (maybe <- 0x1000142) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P2495: !_ST [14] (maybe <- 0x1000143) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2496: !_PREFETCH [14] (Int) (CBR) (Branch target of P2382)
prefetch [%i3 + 128], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2496
nop
RET2496:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2497
nop

TARGET2382:
ba RET2382
nop


P2497: !_DWST [4] (maybe <- 0x1000144) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P2498: !_CAS [8] (maybe <- 0x1000145) (Int)
add %i1, 256, %o5
lduw [%o5], %o3
mov %o3, %l7
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

P2499: !_DWST [15] (maybe <- 0x1000146) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2499
nop
RET2499:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2500: !_DWST [1] (maybe <- 0x1000147) (Int) (Branch target of P2864)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4
ba P2501
nop

TARGET2864:
ba RET2864
nop


P2501: !_CAS [4] (maybe <- 0x1000149) (Int)
add %i0, 64, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P2502: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2503: !_ST [11] (maybe <- 0x100014a) (Int) (CBR)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2503
nop
RET2503:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2504: !_DWST [13] (maybe <- 0x100014b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P2505: !_ST [1] (maybe <- 0x100014c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2506: !_LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2507: !_LD [5] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i1 + 76] %asi, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2508: !_LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2509: !_CAS [4] (maybe <- 0x100014d) (Int)
add %i0, 64, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1
mov %l4, %o2
cas [%l6], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2510: !_ST [9] (maybe <- 0x100014e) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2510
nop
RET2510:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2511: !_ST [5] (maybe <- 0x100014f) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2512: !_DWST [5] (maybe <- 0x1000150) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P2513: !_ST [13] (maybe <- 0x1000151) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2514: !_ST [3] (maybe <- 0x1000152) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2515: !_ST [2] (maybe <- 0x1000153) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2516: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2517: !_LD [2] (Int)
lduw [%i0 + 12], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

P2518: !_ST [15] (maybe <- 0x40800017) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P2519: !_ST [12] (maybe <- 0x1000154) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2520: !_ST [8] (maybe <- 0x1000155) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2521: !_DWST [12] (maybe <- 0x1000156) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2522: !_CASX [5] (maybe <- 0x1000157) (Int)
add %i1, 72, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
mov %l4, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2523: !_ST [3] (maybe <- 0x1000158) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2524: !_ST [13] (maybe <- 0x1000159) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2525: !_ST [2] (maybe <- 0x100015a) (Int) (Branch target of P2304)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
ba P2526
nop

TARGET2304:
ba RET2304
nop


P2526: !_DWLD [5] (Int) (CBR)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2526
nop
RET2526:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2527: !_DWST [4] (maybe <- 0x100015b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2528: !_ST [7] (maybe <- 0x100015c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2529: !_DWLD [12] (Int)
ldx [%i3 + 0], %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %o5
or %o5, %o0, %o0

P2530: !_CASX [7] (maybe <- 0x100015d) (Int) (CBR)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l6
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2530
nop
RET2530:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2531: !_CASX [12] (maybe <- 0x100015f) (Int) (Branch target of P2928)
add %i3, 0, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
sllx %l4, 32, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4
ba P2532
nop

TARGET2928:
ba RET2928
nop


P2532: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2533: !_DWST [12] (maybe <- 0x1000160) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2534: !_DWST [5] (maybe <- 0x1000161) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2535: !_DWST [0] (maybe <- 0x40800018) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P2536: !_ST [3] (maybe <- 0x4080001a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P2537: !_ST [2] (maybe <- 0x1000162) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2538: !_ST [0] (maybe <- 0x1000163) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2538
nop
RET2538:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2539: !_DWST [2] (maybe <- 0x1000164) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P2540: !_DWST [10] (maybe <- 0x1000165) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P2541: !_ST [7] (maybe <- 0x1000166) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 84] %asi
add   %l4, 1, %l4

P2542: !_LD [6] (Int) (CBR)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2542
nop
RET2542:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2543: !_DWST [3] (maybe <- 0x1000167) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2544: !_DWST [11] (maybe <- 0x4080001b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P2545: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2546: !_ST [0] (maybe <- 0x1000168) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2547: !_DWST [0] (maybe <- 0x1000169) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P2548: !_DWST [5] (maybe <- 0x100016b) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2549: !_LD [3] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 32] %asi, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2550: !_ST [8] (maybe <- 0x4080001c) (FP) (Branch target of P2586)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]
ba P2551
nop

TARGET2586:
ba RET2586
nop


P2551: !_DWST [3] (maybe <- 0x100016c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P2552: !_ST [9] (maybe <- 0x100016d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2553: !_ST [11] (maybe <- 0x100016e) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2554: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2555: !_DWST [10] (maybe <- 0x100016f) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P2556: !_LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2557: !_PREFETCH [13] (Int) (CBR) (Branch target of P2924)
prefetch [%i3 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2557
nop
RET2557:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P2558
nop

TARGET2924:
ba RET2924
nop


P2558: !_DWST [5] (maybe <- 0x1000170) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
sllx %l6, 32, %l6 
stxa %l6, [%i1 + 72 ] %asi
add   %l4, 1, %l4

P2559: !_MEMBAR (Int)
membar #StoreLoad

P2560: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2561: !_DWST [4] (maybe <- 0x1000171) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P2562: !_DWST [9] (maybe <- 0x1000172) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P2563: !_ST [9] (maybe <- 0x4080001d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P2564: !_ST [8] (maybe <- 0x1000173) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2565: !_ST [9] (maybe <- 0x1000174) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2566: !_PREFETCH [8] (Int) (Branch target of P2705)
prefetch [%i1 + 256], 1
ba P2567
nop

TARGET2705:
ba RET2705
nop


P2567: !_LD [9] (Int)
lduw [%i1 + 512], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P2568: !_ST [12] (maybe <- 0x1000175) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i3 + 0] %asi
add   %l4, 1, %l4

P2569: !_LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2570: !_CAS [13] (maybe <- 0x1000176) (Int)
add %i3, 64, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2571: !_DWLD [6] (Int)
ldx [%i1 + 80], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l6
or %l6, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4

P2572: !_ST [13] (maybe <- 0x4080001e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P2573: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2574: !_DWST [13] (maybe <- 0x1000177) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P2575: !_ST [9] (maybe <- 0x1000178) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2576: !_ST [6] (maybe <- 0x1000179) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2577: !_ST [11] (maybe <- 0x100017a) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2578: !_ST [1] (maybe <- 0x100017b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2579: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2580: !_LD [2] (FP)
ld [%i0 + 12], %f6
! 1 addresses covered

P2581: !_LD [11] (FP)
ld [%i2 + 64], %f7
! 1 addresses covered

P2582: !_LD [1] (FP)
ld [%i0 + 4], %f8
! 1 addresses covered

P2583: !_LD [4] (FP)
ld [%i0 + 64], %f9
! 1 addresses covered

P2584: !_LD [5] (FP) (CBR)
ld [%i1 + 76], %f10
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2584
nop
RET2584:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2585: !_LD [11] (FP)
ld [%i2 + 64], %f11
! 1 addresses covered

P2586: !_LD [2] (FP) (CBR)
ld [%i0 + 12], %f12
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2586
nop
RET2586:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2587: !_LD [2] (FP)
ld [%i0 + 12], %f13
! 1 addresses covered

P2588: !_LD [11] (FP)
ld [%i2 + 64], %f14
! 1 addresses covered

P2589: !_LD [11] (FP)
ld [%i2 + 64], %f15
! 1 addresses covered
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P2590: !_LD [13] (Int) (Loop exit)
lduw [%i3 + 64], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
loop_exit_2_0:
sub %l2, 1, %l2
cmp %l2, 0
bg loop_entry_2_0
nop

P2591: !_NOP (Int)
nop

P2592: !_ST [10] (maybe <- 0x100017c) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2593: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2594: !_DWST [5] (maybe <- 0x100017d) (Int) (CBR)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2594
nop
RET2594:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2595: !_ST [1] (maybe <- 0x4080001f) (FP) (Branch target of P2635)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]
ba P2596
nop

TARGET2635:
ba RET2635
nop


P2596: !_ST [2] (maybe <- 0x100017e) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2597: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2598: !_DWST [14] (maybe <- 0x100017f) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P2599: !_ST [2] (maybe <- 0x40800020) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P2600: !_DWST [0] (maybe <- 0x40800021) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P2601: !_DWST [1] (maybe <- 0x1000180) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P2602: !_ST [11] (maybe <- 0x1000182) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2603: !_ST [15] (maybe <- 0x1000183) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2604: !_SWAP [9] (maybe <- 0x1000184) (Int)
mov %l4, %o0
swap  [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2605: !_ST [7] (maybe <- 0x1000185) (Int) (Branch target of P2859)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P2606
nop

TARGET2859:
ba RET2859
nop


P2606: !_SWAP [8] (maybe <- 0x1000186) (Int)
mov %l4, %l6
swap  [%i1 + 256], %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P2607: !_ST [10] (maybe <- 0x1000187) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2607
nop
RET2607:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2608: !_LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2609: !_DWST [13] (maybe <- 0x1000188) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P2610: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2611: !_DWLD [1] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %o5
or %o5, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2

P2612: !_ST [9] (maybe <- 0x1000189) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2613: !_ST [6] (maybe <- 0x100018a) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2614: !_ST [3] (maybe <- 0x100018b) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 32] %asi
add   %l4, 1, %l4

P2615: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2616: !_DWLD [9] (Int)
ldx [%i1 + 512], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2

P2617: !_ST [7] (maybe <- 0x100018c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2618: !_ST [13] (maybe <- 0x100018d) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2619: !_ST [2] (maybe <- 0x40800023) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P2620: !_ST [9] (maybe <- 0x100018e) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2621: !_ST [15] (maybe <- 0x100018f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2622: !_ST [3] (maybe <- 0x1000190) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2623: !_CASX [11] (maybe <- 0x1000191) (Int)
add %i2, 64, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
sllx %l4, 32, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2624: !_ST [10] (maybe <- 0x1000192) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i2 + 32] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2624
nop
RET2624:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2625: !_ST [12] (maybe <- 0x1000193) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2626: !_LD [1] (Int)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2627: !_DWST [1] (maybe <- 0x1000194) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P2628: !_PREFETCH [2] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

P2629: !_DWLD [15] (Int)
ldx [%i3 + 192], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l7
or %l7, %o0, %o0

P2630: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2631: !_DWST [8] (maybe <- 0x1000196) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P2632: !_LD [6] (FP)
ld [%i1 + 80], %f0
! 1 addresses covered

P2633: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2634: !_ST [5] (maybe <- 0x1000197) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2635: !_CASX [2] (maybe <- 0x1000198) (Int) (CBR)
add %i0, 8, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l7
mov %l4, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2635
nop
RET2635:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2636: !_DWST [7] (maybe <- 0x1000199) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2637: !_ST [9] (maybe <- 0x100019b) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2638: !_CAS [6] (maybe <- 0x100019c) (Int)
add %i1, 80, %l7
lduw [%l7], %o3
mov %o3, %l6
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o3(lower)
srl %l3, 0, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P2639: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2640: !_DWST [4] (maybe <- 0x100019d) (Int) (Branch target of P2391)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P2641
nop

TARGET2391:
ba RET2391
nop


P2641: !_ST [1] (maybe <- 0x100019e) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2642: !_ST [9] (maybe <- 0x100019f) (Int) (CBR) (Branch target of P2266)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2642
nop
RET2642:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P2643
nop

TARGET2266:
ba RET2266
nop


P2643: !_DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P2644: !_ST [2] (maybe <- 0x10001a0) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2645: !_DWST [9] (maybe <- 0x10001a1) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P2646: !_ST [2] (maybe <- 0x40800024) (FP) (Branch target of P2682)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]
ba P2647
nop

TARGET2682:
ba RET2682
nop


P2647: !_ST [8] (maybe <- 0x10001a2) (Int) (CBR) (Branch target of P2883)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2647
nop
RET2647:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P2648
nop

TARGET2883:
ba RET2883
nop


P2648: !_ST [12] (maybe <- 0x10001a3) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2649: !_ST [1] (maybe <- 0x40800025) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P2650: !_ST [9] (maybe <- 0x10001a4) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 512] %asi
add   %l4, 1, %l4

P2651: !_DWLD [14] (Int)
ldx [%i3 + 128], %o5
! move %o5(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2652: !_ST [8] (maybe <- 0x10001a5) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2652
nop
RET2652:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2653: !_DWST [0] (maybe <- 0x10001a6) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P2654: !_DWST [0] (maybe <- 0x10001a8) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %o5
add   %l4, 1, %l4
or %o5, %l4, %l3
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
sllx %l6, 32, %o5
or %l6, %o5, %l6 
and %l3, %l6, %o5
srlx %o5, 8, %o5
sllx %l3, 8, %l3
and %l3, %l6, %l3
or %l3, %o5, %l3 
sethi %hi(0xffff0000), %l6
or %l6, %lo(0xffff0000), %l6
srlx %l3, 16, %o5
andn %o5, %l6, %o5
andn %l3, %l6, %l3
sllx %l3, 16, %l3
or %l3, %o5, %l3 
srlx %l3, 32, %o5
sllx %l3, 32, %l3
or %l3, %o5, %o5 
stxa %o5, [%i0 + 0 ] %asi
add   %l4, 1, %l4

P2655: !_CASX [11] (maybe <- 0x10001aa) (Int)
add %i2, 64, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P2656: !_CAS [15] (maybe <- 0x10001ab) (Int)
add %i3, 192, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P2657: !_DWST [15] (maybe <- 0x10001ac) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P2658: !_ST [10] (maybe <- 0x10001ad) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2659: !_ST [12] (maybe <- 0x10001ae) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2659
nop
RET2659:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2660: !_ST [14] (maybe <- 0x10001af) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2661: !_ST [15] (maybe <- 0x10001b0) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2662: !_CASX [15] (maybe <- 0x10001b1) (Int)
add %i3, 192, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
sllx %l4, 32, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2663: !_ST [2] (maybe <- 0x10001b2) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2663
nop
RET2663:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2664: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2665: !_ST [0] (maybe <- 0x10001b3) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2666: !_DWST [8] (maybe <- 0x10001b4) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P2667: !_ST [0] (maybe <- 0x40800026) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P2668: !_SWAP [8] (maybe <- 0x10001b5) (Int)
mov %l4, %o0
swap  [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2669: !_SWAP [15] (maybe <- 0x10001b6) (Int)
mov %l4, %o5
swap  [%i3 + 192], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l6
or %l6, %o0, %o0
add   %l4, 1, %l4

P2670: !_DWST [7] (maybe <- 0x10001b7) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P2671: !_CAS [8] (maybe <- 0x10001b9) (Int)
add %i1, 256, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P2672: !_DWST [5] (maybe <- 0x10001ba) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P2673: !_CASX [1] (maybe <- 0x10001bb) (Int) (CBR)
add %i0, 0, %o5
ldx [%o5], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l7
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
casx [%o5], %l7, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2673
nop
RET2673:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2674: !_PREFETCH [11] (Int) (Branch target of P2358)
prefetch [%i2 + 64], 1
ba P2675
nop

TARGET2358:
ba RET2358
nop


P2675: !_CASX [3] (maybe <- 0x10001bd) (Int)
add %i0, 32, %l3
ldx [%l3], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %o5
sllx %l4, 32, %o0
casx [%l3], %o5, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P2676: !_LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2677: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2678: !_CASX [4] (maybe <- 0x10001be) (Int) (CBR)
add %i0, 64, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l3
or %l3, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l6
or %l6, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2678
nop
RET2678:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2679: !_ST [9] (maybe <- 0x10001bf) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2680: !_ST [7] (maybe <- 0x10001c0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2681: !_ST [0] (maybe <- 0x40800027) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P2682: !_ST [3] (maybe <- 0x10001c1) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2682
nop
RET2682:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2683: !_ST [3] (maybe <- 0x10001c2) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2684: !_CAS [9] (maybe <- 0x10001c3) (Int)
add %i1, 512, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2685: !_ST [10] (maybe <- 0x40800028) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P2686: !_LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2687: !_ST [9] (maybe <- 0x10001c4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2688: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %l6
or %l6, %lo(0x80),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2689: !_DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2690: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P2691: !_DWST [5] (maybe <- 0x10001c5) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2692: !_ST [4] (maybe <- 0x10001c6) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2693: !_ST [13] (maybe <- 0x10001c7) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2694: !_ST [5] (maybe <- 0x10001c8) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2695: !_DWST [14] (maybe <- 0x10001c9) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P2696: !_CAS [3] (maybe <- 0x10001ca) (Int)
add %i0, 32, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P2697: !_ST [11] (maybe <- 0x10001cb) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2698: !_DWLD [5] (Int)
ldx [%i1 + 72], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2699: !_DWST [3] (maybe <- 0x10001cc) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P2700: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2701: !_LD [8] (FP) (CBR) (Branch target of P2794)
ld [%i1 + 256], %f1
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2701
nop
RET2701:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P2702
nop

TARGET2794:
ba RET2794
nop


P2702: !_ST [12] (maybe <- 0x10001cd) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2703: !_CASX [7] (maybe <- 0x10001ce) (Int)
add %i1, 80, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %o5
or %o5, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l7, %o5
sllx %l4, 32, %l7
add  %l4, 1, %l4
or   %l4, %l7, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l3
or %l3, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
add  %l4, 1, %l4

P2704: !_DWST [15] (maybe <- 0x10001d0) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2704
nop
RET2704:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2705: !_DWLD [14] (Int) (CBR)
ldx [%i3 + 128], %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2705
nop
RET2705:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2706: !_ST [2] (maybe <- 0x10001d1) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2707: !_CASX [2] (maybe <- 0x10001d2) (Int)
add %i0, 8, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
mov %l4, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P2708: !_CASX [12] (maybe <- 0x10001d3) (Int)
add %i3, 0, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %l6
sllx %l4, 32, %o3
casx [%l7], %l6, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P2709: !_CASX [15] (maybe <- 0x10001d4) (Int)
add %i3, 192, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l6
sllx %l4, 32, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P2710: !_DWST [5] (maybe <- 0x10001d5) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2711: !_ST [10] (maybe <- 0x40800029) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P2712: !_ST [9] (maybe <- 0x10001d6) (Int) (Branch target of P2379)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P2713
nop

TARGET2379:
ba RET2379
nop


P2713: !_ST [11] (maybe <- 0x10001d7) (Int) (Branch target of P2941)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P2714
nop

TARGET2941:
ba RET2941
nop


P2714: !_DWST [1] (maybe <- 0x10001d8) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P2715: !_ST [12] (maybe <- 0x10001da) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2715
nop
RET2715:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2716: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2717: !_CAS [4] (maybe <- 0x10001db) (Int)
add %i0, 64, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P2718: !_CAS [8] (maybe <- 0x10001dc) (Int)
add %i1, 256, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4

P2719: !_DWST [10] (maybe <- 0x10001dd) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i2 + 32 ] %asi
add   %l4, 1, %l4

P2720: !_CASX [1] (maybe <- 0x10001de) (Int)
add %i0, 0, %l3
ldx [%l3], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %o5
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
casx [%l3], %o5, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2721: !_ST [14] (maybe <- 0x10001e0) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2722: !_ST [12] (maybe <- 0x10001e1) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2723: !_DWST [15] (maybe <- 0x10001e2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2724: !_ST [4] (maybe <- 0x10001e3) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2725: !_DWST [9] (maybe <- 0x10001e4) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P2726: !_DWST [6] (maybe <- 0x10001e5) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P2727: !_ST [4] (maybe <- 0x4080002a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P2728: !_DWST [4] (maybe <- 0x10001e7) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P2729: !_ST [1] (maybe <- 0x10001e8) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2730: !_CASX [12] (maybe <- 0x10001e9) (Int)
add %i3, 0, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P2731: !_SWAP [10] (maybe <- 0x10001ea) (Int) (Branch target of P2212)
mov %l4, %o2
swap  [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4
ba P2732
nop

TARGET2212:
ba RET2212
nop


P2732: !_DWST [13] (maybe <- 0x10001eb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2733: !_DWST [5] (maybe <- 0x10001ec) (Int) (CBR)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2733
nop
RET2733:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2734: !_ST [10] (maybe <- 0x10001ed) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2735: !_DWST [5] (maybe <- 0x10001ee) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P2736: !_ST [9] (maybe <- 0x10001ef) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2737: !_ST [11] (maybe <- 0x10001f0) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P2738: !_DWST [10] (maybe <- 0x10001f1) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P2739: !_ST [8] (maybe <- 0x10001f2) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2740: !_DWST [5] (maybe <- 0x10001f3) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P2741: !_ST [9] (maybe <- 0x10001f4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2742: !_ST [10] (maybe <- 0x10001f5) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2743: !_ST [12] (maybe <- 0x10001f6) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2744: !_ST [3] (maybe <- 0x10001f7) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2745: !_DWLD [7] (Int)
ldx [%i1 + 80], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3

P2746: !_CAS [8] (maybe <- 0x10001f8) (Int) (Branch target of P2237)
add %i1, 256, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4
ba P2747
nop

TARGET2237:
ba RET2237
nop


P2747: !_DWST [14] (maybe <- 0x10001f9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P2748: !_ST [0] (maybe <- 0x10001fa) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2749: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2750: !_ST [9] (maybe <- 0x10001fb) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2751: !_DWLD [15] (FP)
ldd [%i3 + 192], %f2
! 1 addresses covered

P2752: !_DWST [9] (maybe <- 0x10001fc) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i1 + 512 ] %asi
add   %l4, 1, %l4

P2753: !_DWST [11] (maybe <- 0x10001fd) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P2754: !_PREFETCH [12] (Int) (Branch target of P2821)
prefetch [%i3 + 0], 1
ba P2755
nop

TARGET2821:
ba RET2821
nop


P2755: !_DWST [14] (maybe <- 0x4080002b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P2756: !_CAS [1] (maybe <- 0x10001fe) (Int)
add %i0, 4, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2757: !_ST [3] (maybe <- 0x10001ff) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2758: !_ST [13] (maybe <- 0x1000200) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2759: !_ST [1] (maybe <- 0x1000201) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2760: !_ST [7] (maybe <- 0x4080002c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P2761: !_ST [10] (maybe <- 0x1000202) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2762: !_ST [14] (maybe <- 0x1000203) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2763: !_PREFETCH [3] (Int) (Branch target of P2460)
prefetch [%i0 + 32], 1
ba P2764
nop

TARGET2460:
ba RET2460
nop


P2764: !_ST [1] (maybe <- 0x1000204) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2765: !_DWST [12] (maybe <- 0x1000205) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2766: !_ST [8] (maybe <- 0x4080002d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P2767: !_CASX [5] (maybe <- 0x1000206) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %l6, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
sllx %l7, 32, %l7
wr %g0, 0x88, %asi
add %i1, 72, %l6
ldxa [%l6] %asi, %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l3
or %l3, %o0, %o0
! move %o5(upper) -> %o1(upper)
or %o5, %g0, %o1
mov  %o5, %l3
mov  %l7, %o5
casxa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srl %o5, 0, %l6
or %l6, %o1, %o1
! move %o5(upper) -> %o2(upper)
or %o5, %g0, %o2
add  %l4, 1, %l4

P2768: !_DWST [4] (maybe <- 0x1000207) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P2769: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2770: !_DWLD [2] (Int)
ldx [%i0 + 8], %l3
! move %l3(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srl %l3, 0, %o5
or %o5, %o2, %o2

P2771: !_ST [8] (maybe <- 0x1000208) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2772: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l3
or %l3, %lo(0x200),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2773: !_DWST [3] (maybe <- 0x1000209) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P2774: !_ST [9] (maybe <- 0x100020a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2775: !_ST [9] (maybe <- 0x100020b) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2776: !_ST [14] (maybe <- 0x100020c) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2777: !_DWST [6] (maybe <- 0x100020d) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2777
nop
RET2777:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2778: !_ST [15] (maybe <- 0x100020f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2779: !_ST [10] (maybe <- 0x4080002e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P2780: !_DWST [15] (maybe <- 0x1000210) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2781: !_ST [4] (maybe <- 0x1000211) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2782: !_DWST [6] (maybe <- 0x1000212) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2783: !_DWST [2] (maybe <- 0x1000214) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P2784: !_DWST [13] (maybe <- 0x1000215) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2785: !_ST [0] (maybe <- 0x1000216) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2786: !_DWST [5] (maybe <- 0x1000217) (Int) (CBR)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2786
nop
RET2786:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2787: !_DWST [5] (maybe <- 0x4080002f) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P2788: !_ST [6] (maybe <- 0x1000218) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2789: !_ST [6] (maybe <- 0x1000219) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2790: !_ST [5] (maybe <- 0x100021a) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2791: !_ST [3] (maybe <- 0x40800030) (FP) (Branch target of P2733)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]
ba P2792
nop

TARGET2733:
ba RET2733
nop


P2792: !_DWST [4] (maybe <- 0x40800031) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P2793: !_DWST [8] (maybe <- 0x100021b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2794: !_ST [7] (maybe <- 0x100021c) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2794
nop
RET2794:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2795: !_ST [0] (maybe <- 0x100021d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2796: !_ST [0] (maybe <- 0x100021e) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2797: !_ST [1] (maybe <- 0x100021f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2798: !_CASX [10] (maybe <- 0x1000220) (Int)
add %i2, 32, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
sllx %l4, 32, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2799: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P2800: !_DWST [13] (maybe <- 0x1000221) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P2801: !_ST [4] (maybe <- 0x1000222) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2802: !_LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2803: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2804: !_PREFETCH [0] (Int) (Branch target of P2335)
prefetch [%i0 + 0], 1
ba P2805
nop

TARGET2335:
ba RET2335
nop


P2805: !_DWST [11] (maybe <- 0x40800032) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P2806: !_DWST [14] (maybe <- 0x1000223) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P2807: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2808: !_ST [15] (maybe <- 0x1000224) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2809: !_LD [3] (Int)
lduw [%i0 + 32], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P2810: !_ST [11] (maybe <- 0x40800033) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P2811: !_CASX [12] (maybe <- 0x1000225) (Int)
add %i3, 0, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l7
sllx %l4, 32, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P2812: !_ST [12] (maybe <- 0x1000226) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2813: !_ST [10] (maybe <- 0x1000227) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i2 + 32] %asi
add   %l4, 1, %l4

P2814: !_DWST [12] (maybe <- 0x1000228) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P2815: !_DWST [9] (maybe <- 0x1000229) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2815
nop
RET2815:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2816: !_ST [13] (maybe <- 0x100022a) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2817: !_CASX [2] (maybe <- 0x100022b) (Int)
add %i0, 8, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
mov %l4, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P2818: !_DWLD [6] (FP) (CBR)
ldd [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f3
fmovs %f19, %f4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2818
nop
RET2818:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2819: !_DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P2820: !_DWST [1] (maybe <- 0x100022c) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P2821: !_DWST [7] (maybe <- 0x100022e) (Int) (CBR)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2821
nop
RET2821:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2822: !_ST [8] (maybe <- 0x1000230) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2823: !_CASX [5] (maybe <- 0x1000231) (Int)
add %i1, 72, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
mov %l4, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

P2824: !_DWST [9] (maybe <- 0x1000232) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P2825: !_DWST [5] (maybe <- 0x40800034) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]

P2826: !_ST [7] (maybe <- 0x1000233) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2826
nop
RET2826:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2827: !_ST [10] (maybe <- 0x1000234) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2828: !_ST [13] (maybe <- 0x1000235) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2829: !_DWLD [3] (Int)
ldx [%i0 + 32], %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %o5
or %o5, %o2, %o2

P2830: !_NOP (Int) (Branch target of P2133)
nop
ba P2831
nop

TARGET2133:
ba RET2133
nop


P2831: !_ST [1] (maybe <- 0x1000236) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2832: !_CASX [3] (maybe <- 0x1000237) (Int) (Branch target of P2432)
add %i0, 32, %l6
ldx [%l6], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l3
sllx %l4, 32, %o4
casx [%l6], %l3, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4
ba P2833
nop

TARGET2432:
ba RET2432
nop


P2833: !_ST [3] (maybe <- 0x1000238) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2834: !_DWST [0] (maybe <- 0x1000239) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P2835: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2836: !_ST [1] (maybe <- 0x100023b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2837: !_CASX [15] (maybe <- 0x100023c) (Int)
add %i3, 192, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
sllx %l4, 32, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P2838: !_DWST [8] (maybe <- 0x100023d) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P2839: !_DWST [5] (maybe <- 0x100023e) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2840: !_ST [15] (maybe <- 0x100023f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2841: !_ST [3] (maybe <- 0x1000240) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2842: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2843: !_DWST [3] (maybe <- 0x40800035) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P2844: !_ST [3] (maybe <- 0x1000241) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2845: !_ST [6] (maybe <- 0x1000242) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2846: !_DWST [8] (maybe <- 0x1000243) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i1 + 256 ] %asi
add   %l4, 1, %l4

P2847: !_LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2848: !_DWST [12] (maybe <- 0x1000244) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l6
srl %l6, 8, %l6
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3
srl %l3, 16, %l6
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l6, %l3
stxa %l3, [%i3 + 0 ] %asi
add   %l4, 1, %l4

P2849: !_ST [1] (maybe <- 0x1000245) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2850: !_DWST [5] (maybe <- 0x1000246) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2851: !_REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l3
or %l3, %lo(0xc0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2852: !_DWST [0] (maybe <- 0x1000247) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P2853: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2854: !_DWST [13] (maybe <- 0x1000249) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P2855: !_CASX [12] (maybe <- 0x100024a) (Int)
add %i3, 0, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l7
or %l7, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
add  %l4, 1, %l4

P2856: !_ST [10] (maybe <- 0x40800036) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P2857: !_DWST [6] (maybe <- 0x100024b) (Int) (Branch target of P2530)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4
ba P2858
nop

TARGET2530:
ba RET2530
nop


P2858: !_DWLD [2] (Int)
ldx [%i0 + 8], %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2859: !_ST [3] (maybe <- 0x100024d) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2859
nop
RET2859:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2860: !_SWAP [12] (maybe <- 0x100024e) (Int) (CBR)
mov %l4, %o0
swap  [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2860
nop
RET2860:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2861: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2862: !_ST [10] (maybe <- 0x100024f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2863: !_DWST [12] (maybe <- 0x1000250) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i3 + 0 ] %asi
add   %l4, 1, %l4

P2864: !_ST [15] (maybe <- 0x1000251) (Int) (CBR) (Branch target of P2974)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2864
nop
RET2864:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2865
nop

TARGET2974:
ba RET2974
nop


P2865: !_ST [3] (maybe <- 0x40800037) (FP) (Branch target of P2999)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]
ba P2866
nop

TARGET2999:
ba RET2999
nop


P2866: !_CAS [3] (maybe <- 0x1000252) (Int) (CBR) (Branch target of P2976)
add %i0, 32, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2866
nop
RET2866:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2867
nop

TARGET2976:
ba RET2976
nop


P2867: !_ST [1] (maybe <- 0x40800038) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P2868: !_DWST [3] (maybe <- 0x1000253) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P2869: !_REPLACEMENT [2] (Int) (Branch target of P2673)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
ba P2870
nop

TARGET2673:
ba RET2673
nop


P2870: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2871: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %l3
or %l3, %lo(0x80),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P2872: !_CASX [15] (maybe <- 0x1000254) (Int) (CBR)
add %i3, 192, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2872
nop
RET2872:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2873: !_DWST [6] (maybe <- 0x1000255) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P2874: !_ST [13] (maybe <- 0x1000257) (Int) (Branch target of P2128)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P2875
nop

TARGET2128:
ba RET2128
nop


P2875: !_CASX [6] (maybe <- 0x1000258) (Int)
add %i1, 80, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l6, %l7
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
add  %l4, 1, %l4

P2876: !_ST [5] (maybe <- 0x100025a) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i1 + 76] %asi
add   %l4, 1, %l4

P2877: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2878: !_LD [2] (FP) (Branch target of P2880)
ld [%i0 + 12], %f5
! 1 addresses covered
ba P2879
nop

TARGET2880:
ba RET2880
nop


P2879: !_ST [2] (maybe <- 0x100025b) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2880: !_LD [13] (Int) (CBR)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2880
nop
RET2880:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2881: !_CAS [0] (maybe <- 0x100025c) (Int)
add %i0, 0, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P2882: !_NOP (Int)
nop

P2883: !_ST [1] (maybe <- 0x100025d) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2883
nop
RET2883:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2884: !_ST [12] (maybe <- 0x100025e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2885: !_ST [5] (maybe <- 0x100025f) (Int) (Branch target of P2387)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P2886
nop

TARGET2387:
ba RET2387
nop


P2886: !_LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2887: !_ST [14] (maybe <- 0x1000260) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P2888: !_ST [12] (maybe <- 0x1000261) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2889: !_DWST [10] (maybe <- 0x1000262) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P2890: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2891: !_CAS [0] (maybe <- 0x1000263) (Int)
add %i0, 0, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l4, %o3
cas [%l6], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2892: !_ST [1] (maybe <- 0x1000264) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2893: !_DWST [1] (maybe <- 0x1000265) (Int) (Branch target of P2232)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4
ba P2894
nop

TARGET2232:
ba RET2232
nop


P2894: !_DWST [15] (maybe <- 0x1000267) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P2895: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2896: !_DWST [5] (maybe <- 0x1000268) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2897: !_DWST [0] (maybe <- 0x1000269) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P2898: !_CAS [12] (maybe <- 0x100026b) (Int)
add %i3, 0, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2899: !_ST [12] (maybe <- 0x100026c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2900: !_DWST [2] (maybe <- 0x100026d) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P2901: !_DWST [1] (maybe <- 0x100026e) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P2902: !_DWST [15] (maybe <- 0x1000270) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P2903: !_DWLD [3] (Int)
ldx [%i0 + 32], %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2904: !_ST [6] (maybe <- 0x40800039) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P2905: !_DWST [15] (maybe <- 0x1000271) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P2906: !_ST [8] (maybe <- 0x1000272) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P2907: !_DWLD [4] (Int)
ldx [%i0 + 64], %o0
! move %o0(upper) -> %o0(upper)

P2908: !_ST [7] (maybe <- 0x1000273) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2908
nop
RET2908:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2909: !_DWST [5] (maybe <- 0x1000274) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2910: !_DWST [15] (maybe <- 0x1000275) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P2911: !_REPLACEMENT [0] (Int) (Branch target of P2472)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P2912
nop

TARGET2472:
ba RET2472
nop


P2912: !_ST [2] (maybe <- 0x1000276) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2913: !_NOP (Int) (Branch target of P3047)
nop
ba P2914
nop

TARGET3047:
ba RET3047
nop


P2914: !_ST [9] (maybe <- 0x1000277) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2915: !_ST [9] (maybe <- 0x4080003a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P2916: !_ST [3] (maybe <- 0x1000278) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2917: !_DWST [10] (maybe <- 0x4080003b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P2918: !_LD [5] (Int) (Branch target of P2503)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l6, %o0, %o0
ba P2919
nop

TARGET2503:
ba RET2503
nop


P2919: !_ST [2] (maybe <- 0x4080003c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P2920: !_ST [9] (maybe <- 0x1000279) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2921: !_DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P2922: !_DWST [0] (maybe <- 0x100027a) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P2923: !_ST [4] (maybe <- 0x100027c) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2924: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2924
nop
RET2924:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2925: !_ST [12] (maybe <- 0x4080003d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P2926: !_ST [2] (maybe <- 0x100027d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2927: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2928: !_ST [0] (maybe <- 0x100027e) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2928
nop
RET2928:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2929: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2930: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2931: !_LD [6] (Int)
lduw [%i1 + 80], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2932: !_ST [12] (maybe <- 0x100027f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2933: !_DWST [6] (maybe <- 0x1000280) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P2934: !_ST [2] (maybe <- 0x1000282) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2935: !_DWST [13] (maybe <- 0x1000283) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P2936: !_DWST [12] (maybe <- 0x1000284) (Int) (Branch target of P2715)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4
ba P2937
nop

TARGET2715:
ba RET2715
nop


P2937: !_ST [15] (maybe <- 0x1000285) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2938: !_ST [13] (maybe <- 0x4080003e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P2939: !_CASX [14] (maybe <- 0x1000286) (Int) (CBR)
add %i3, 128, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %o5
or %o5, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2939
nop
RET2939:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2940: !_ST [3] (maybe <- 0x1000287) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2941: !_ST [9] (maybe <- 0x1000288) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2941
nop
RET2941:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2942: !_ST [1] (maybe <- 0x4080003f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P2943: !_LD [9] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
lduwa [%i1 + 512] %asi, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2943
nop
RET2943:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2944: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2945: !_ST [8] (maybe <- 0x1000289) (Int) (Branch target of P2499)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P2946
nop

TARGET2499:
ba RET2499
nop


P2946: !_DWST [4] (maybe <- 0x100028a) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2946
nop
RET2946:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2947: !_ST [0] (maybe <- 0x100028b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2948: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2949: !_DWST [14] (maybe <- 0x100028c) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P2950: !_LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2951: !_DWST [0] (maybe <- 0x100028d) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P2952: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2953: !_DWST [4] (maybe <- 0x100028f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P2954: !_ST [4] (maybe <- 0x1000290) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2955: !_DWST [11] (maybe <- 0x1000291) (Int) (Branch target of P2557)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P2956
nop

TARGET2557:
ba RET2557
nop


P2956: !_ST [2] (maybe <- 0x1000292) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2957: !_ST [1] (maybe <- 0x1000293) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2958: !_CAS [11] (maybe <- 0x1000294) (Int)
add %i2, 64, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0
mov %l4, %o1
cas [%l6], %l3, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2959: !_DWLD [7] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P2960: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P2961: !_DWLD [15] (Int)
ldx [%i3 + 192], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2

P2962: !_DWST [0] (maybe <- 0x1000295) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P2963: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2964: !_ST [4] (maybe <- 0x1000297) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2965: !_DWST [2] (maybe <- 0x40800040) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P2966: !_ST [6] (maybe <- 0x40800041) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P2967: !_ST [0] (maybe <- 0x1000298) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2968: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2969: !_ST [5] (maybe <- 0x1000299) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2970: !_DWLD [14] (Int)
ldx [%i3 + 128], %o3
! move %o3(upper) -> %o3(upper)

P2971: !_DWST [2] (maybe <- 0x100029a) (Int) (CBR)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2971
nop
RET2971:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2972: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2973: !_DWST [8] (maybe <- 0x100029b) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l6
srl %l6, 8, %l6
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3
srl %l3, 16, %l6
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l6, %l3
stxa %l3, [%i1 + 256 ] %asi
add   %l4, 1, %l4

P2974: !_ST [0] (maybe <- 0x100029c) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2974
nop
RET2974:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2975: !_PREFETCH [13] (Int) (CBR) (Branch target of P2435)
prefetch [%i3 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2975
nop
RET2975:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2976
nop

TARGET2435:
ba RET2435
nop


P2976: !_LD [1] (Int) (CBR)
lduw [%i0 + 4], %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l3, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2976
nop
RET2976:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2977: !_DWST [3] (maybe <- 0x100029d) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i0 + 32 ] %asi
add   %l4, 1, %l4

P2978: !_LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2979: !_ST [3] (maybe <- 0x100029e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2980: !_DWST [10] (maybe <- 0x100029f) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P2981: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2982: !_CAS [12] (maybe <- 0x10002a0) (Int)
add %i3, 0, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l7], %l6, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2983: !_CAS [9] (maybe <- 0x10002a1) (Int)
add %i1, 512, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2984: !_ST [2] (maybe <- 0x10002a2) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2985: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2986: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2987: !_ST [10] (maybe <- 0x10002a3) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2988: !_ST [8] (maybe <- 0x10002a4) (Int) (Branch target of P2701)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P2989
nop

TARGET2701:
ba RET2701
nop


P2989: !_ST [0] (maybe <- 0x10002a5) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2990: !_ST [2] (maybe <- 0x10002a6) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2991: !_ST [2] (maybe <- 0x10002a7) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2992: !_ST [10] (maybe <- 0x10002a8) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2993: !_DWLD [5] (Int)
ldx [%i1 + 72], %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l7
or %l7, %o1, %o1

P2994: !_ST [10] (maybe <- 0x10002a9) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2995: !_SWAP [11] (maybe <- 0x10002aa) (Int)
mov %l4, %o2
swap  [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P2996: !_DWLD [14] (Int)
ldx [%i3 + 128], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2

P2997: !_ST [12] (maybe <- 0x10002ab) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2998: !_PREFETCH [14] (Int) (CBR)
prefetch [%i3 + 128], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2998
nop
RET2998:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2999: !_MEMBAR (Int) (CBR)
membar #StoreLoad

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2999
nop
RET2999:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3000: !_ST [7] (maybe <- 0x10002ac) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3001: !_PREFETCH [6] (Int) (LE) (CBR) (Branch target of P2381)
wr %g0, 0x88, %asi
prefetcha [%i1 + 80] %asi, 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3001
nop
RET3001:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P3002
nop

TARGET2381:
ba RET2381
nop


P3002: !_ST [9] (maybe <- 0x10002ad) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3003: !_ST [13] (maybe <- 0x10002ae) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3003
nop
RET3003:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3004: !_ST [0] (maybe <- 0x10002af) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3005: !_DWST [12] (maybe <- 0x10002b0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P3006: !_DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P3007: !_ST [10] (maybe <- 0x40800042) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P3008: !_ST [15] (maybe <- 0x10002b1) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3009: !_ST [4] (maybe <- 0x10002b2) (Int) (CBR)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3009
nop
RET3009:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3010: !_DWST [9] (maybe <- 0x10002b3) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P3011: !_ST [6] (maybe <- 0x10002b4) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3012: !_ST [5] (maybe <- 0x10002b5) (Int) (Branch target of P2866)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P3013
nop

TARGET2866:
ba RET2866
nop


P3013: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3014: !_ST [11] (maybe <- 0x10002b6) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3015: !_ST [15] (maybe <- 0x10002b7) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3016: !_ST [12] (maybe <- 0x10002b8) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3017: !_PREFETCH [8] (Int) (Branch target of P2484)
prefetch [%i1 + 256], 1
ba P3018
nop

TARGET2484:
ba RET2484
nop


P3018: !_ST [8] (maybe <- 0x10002b9) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3018
nop
RET3018:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3019: !_ST [4] (maybe <- 0x10002ba) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3020: !_ST [5] (maybe <- 0x10002bb) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3021: !_DWST [3] (maybe <- 0x40800043) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P3022: !_CAS [1] (maybe <- 0x10002bc) (Int)
add %i0, 4, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3023: !_ST [1] (maybe <- 0x10002bd) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3024: !_DWLD [13] (FP)
ldd [%i3 + 64], %f6
! 1 addresses covered

P3025: !_CASX [11] (maybe <- 0x10002be) (Int)
add %i2, 64, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l6
or %l6, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
add  %l4, 1, %l4

P3026: !_ST [11] (maybe <- 0x10002bf) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3027: !_ST [11] (maybe <- 0x10002c0) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3028: !_CAS [15] (maybe <- 0x10002c1) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
wr %g0, 0x88, %asi
add %i3, 192, %o5
lduwa [%o5] %asi, %l6
mov %l6, %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1
mov %l3, %o2
casa [%o5] %asi, %l7, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3029: !_ST [8] (maybe <- 0x10002c2) (Int) (Branch target of P2939)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P3030
nop

TARGET2939:
ba RET2939
nop


P3030: !_DWST [3] (maybe <- 0x10002c3) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3031: !_DWST [0] (maybe <- 0x10002c4) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3032: !_DWST [12] (maybe <- 0x10002c6) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P3033: !_ST [12] (maybe <- 0x40800044) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P3034: !_DWLD [4] (Int)
ldx [%i0 + 64], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2

P3035: !_ST [3] (maybe <- 0x10002c7) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3036: !_ST [2] (maybe <- 0x10002c8) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3037: !_ST [6] (maybe <- 0x10002c9) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3038: !_LD [7] (Int)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3039: !_SWAP [11] (maybe <- 0x10002ca) (Int)
mov %l4, %l3
swap  [%i2 + 64], %l3
! move %l3(lower) -> %o3(lower)
srl %l3, 0, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P3040: !_ST [12] (maybe <- 0x10002cb) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3041: !_ST [8] (maybe <- 0x10002cc) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3042: !_DWST [9] (maybe <- 0x10002cd) (Int) (Branch target of P2510)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4
ba P3043
nop

TARGET2510:
ba RET2510
nop


P3043: !_ST [0] (maybe <- 0x10002ce) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3044: !_ST [4] (maybe <- 0x10002cf) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3045: !_DWST [4] (maybe <- 0x10002d0) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P3046: !_DWLD [10] (Int)
ldx [%i2 + 32], %o4
! move %o4(upper) -> %o4(upper)

P3047: !_DWST [13] (maybe <- 0x10002d1) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3047
nop
RET3047:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3048: !_LD [6] (Int)
lduw [%i1 + 80], %l7
! move %l7(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3049: !_DWLD [0] (Int) (CBR)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3049
nop
RET3049:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3050: !_CASX [13] (maybe <- 0x10002d2) (Int)
add %i3, 64, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l7
sllx %l4, 32, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P3051: !_ST [7] (maybe <- 0x40800045) (FP) (Branch target of P2526)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]
ba P3052
nop

TARGET2526:
ba RET2526
nop


P3052: !_ST [6] (maybe <- 0x10002d3) (Int) (Branch target of P2975)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4
ba P3053
nop

TARGET2975:
ba RET2975
nop


P3053: !_DWST [14] (maybe <- 0x10002d4) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P3054: !_CASX [10] (maybe <- 0x10002d5) (Int)
add %i2, 32, %l3
ldx [%l3], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %o5
sllx %l4, 32, %o4
casx [%l3], %o5, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P3055: !_ST [6] (maybe <- 0x10002d6) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3056: !_ST [11] (maybe <- 0x10002d7) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3057: !_ST [11] (maybe <- 0x10002d8) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3058: !_ST [2] (maybe <- 0x10002d9) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3059: !_ST [7] (maybe <- 0x10002da) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3060: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l7
or %l7, %lo(0x50),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3061: !_DWST [12] (maybe <- 0x10002db) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3062: !_ST [11] (maybe <- 0x10002dc) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3063: !_ST [1] (maybe <- 0x10002dd) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3064: !_DWST [5] (maybe <- 0x10002de) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P3065: !_ST [2] (maybe <- 0x10002df) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 12] %asi
add   %l4, 1, %l4

P3066: !_ST [0] (maybe <- 0x10002e0) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3067: !_DWST [3] (maybe <- 0x10002e1) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P3068: !_PREFETCH [13] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 64] %asi, 1

P3069: !_ST [14] (maybe <- 0x10002e2) (Int) (Branch target of P2971)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P3070
nop

TARGET2971:
ba RET2971
nop


P3070: !_ST [7] (maybe <- 0x40800046) (FP) (CBR) (Branch target of P2425)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3070
nop
RET3070:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P3071
nop

TARGET2425:
ba RET2425
nop


P3071: !_PREFETCH [12] (Int) (Branch target of P2079)
prefetch [%i3 + 0], 1
ba P3072
nop

TARGET2079:
ba RET2079
nop


P3072: !_LD [2] (Int) (Branch target of P2260)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
ba P3073
nop

TARGET2260:
ba RET2260
nop


P3073: !_DWST [5] (maybe <- 0x10002e3) (Int) (Branch target of P2107)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4
ba P3074
nop

TARGET2107:
ba RET2107
nop


P3074: !_ST [5] (maybe <- 0x10002e4) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3075: !_ST [5] (maybe <- 0x10002e5) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3075
nop
RET3075:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3076: !_ST [12] (maybe <- 0x10002e6) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3077: !_ST [13] (maybe <- 0x10002e7) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3078: !_ST [13] (maybe <- 0x10002e8) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3079: !_MEMBAR (Int)
membar #StoreLoad

P3080: !_LD [0] (Int)
lduw [%i0 + 0], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P3081: !_LD [1] (Int)
lduw [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3082: !_LD [2] (FP)
ld [%i0 + 12], %f7
! 1 addresses covered

P3083: !_LD [3] (Int)
lduw [%i0 + 32], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P3084: !_LD [4] (Int)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3085: !_LD [5] (Int)
lduw [%i1 + 76], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P3086: !_LD [6] (Int)
lduw [%i1 + 80], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3087: !_LD [7] (FP)
ld [%i1 + 84], %f8
! 1 addresses covered

P3088: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P3089: !_LD [9] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i1 + 512] %asi, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3090: !_LD [10] (Int)
lduw [%i2 + 32], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3091: !_LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3092: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P3093: !_LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3094: !_LD [14] (Int)
lduw [%i3 + 128], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P3095: !_LD [15] (Int) (CBR)
lduw [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3095
nop
RET3095:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


END_NODES2: ! Test istream for CPU 2 ends
sethi %hi(0xdead0e0f), %o5
or    %o5, %lo(0xdead0e0f), %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2
stw %o5, [%i5] 
ld [%i5], %f9
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30

restore
retl
nop
!-----------------

! register usage:
! %i0 %i1 %i2 %i3 : base registers for 4 regions
! %i4 fixed pointer to per-cpu results area
! %l1 moving pointer to per-cpu FP results area
! %o7 moving pointer to per-cpu integer results area
! %i5 pointer to per-cpu private area
! %l0 holds lfsr, used as source of random bits 
! %l2 loop count register
! %f16 running counter for unique fp store values
! %f17 holds increment value for fp counter
! %l4 running counter for unique integer store values (increment value is always 1)
! %l5 move-to register for load values (simulation only)
! %f30 move-to register for FP values (simulation only)
! %l3 %l6 %l7 %o5 : 4 temporary registers
! %o0 %o1 %o2 %o3 %o4 : 5 integer results buffer registers
! %f0-f15 FP results buffer registers
! %f32-f47 FP block load/store registers

func3:
! 1000 (dynamic) instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
andn %i0, 63, %i0

add %i1, 63, %i1
andn %i1, 63, %i1

add %i2, 63, %i2
andn %i2, 63, %i2

add %i3, 63, %i3
andn %i3, 63, %i3

add %i4, 63, %i4
andn %i4, 63, %i4

add %i5, 63, %i5
andn %i5, 63, %i5


! Initialize pointer to FP load results area
mov   %i4, %l1

! Initialize pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
add  %o7, %l1, %o7 

! Initialize %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%i5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%i5+4]
ldd [%i5], %f0
fmovd %f0, %f2
fmovd %f0, %f4
fmovd %f0, %f6
fmovd %f0, %f8
fmovd %f0, %f10
fmovd %f0, %f12
fmovd %f0, %f14
fmovd %f0, %f16
fmovd %f0, %f18
fmovd %f0, %f20
fmovd %f0, %f22
fmovd %f0, %f24
fmovd %f0, %f26
fmovd %f0, %f28
fmovd %f0, %f30
fmovd %f0, %f32
fmovd %f0, %f34
fmovd %f0, %f36
fmovd %f0, %f38
fmovd %f0, %f40
fmovd %f0, %f42
fmovd %f0, %f44
fmovd %f0, %f46
fmovd %f0, %f48
fmovd %f0, %f50
fmovd %f0, %f52
fmovd %f0, %f54
fmovd %f0, %f56
fmovd %f0, %f58
fmovd %f0, %f60
fmovd %f0, %f62

! Signature for extract_loads script to start extracting load values for this stream
sethi %hi(0x03deade1), %l7
or    %l7, %lo(0x03deade1), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x1800001), %l4
or    %l4, %lo(0x1800001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x41000001), %l7
or    %l7, %lo(0x41000001), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x35800000), %l7
or    %l7, %lo(0x35800000), %l7
stw %l7, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x4794^4
sethi %hi(0x4794), %l0
or    %l0, %lo(0x4794), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 6 to 7 ---
stx %g0, [%i1+80]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %o5
add %i3, %o5, %o5
sub %o5, -4096, %o5

!-- begin of sync_init ---
or %g0, 1, %l3
or %g0, %l3, %l6
swap [%o5+4], %l6
membar #Sync
sync_init_1_3:
brnz,pt %l3, sync_init_1_3
lduw [%o5+4], %l3 ! delay slot
sync_init_2_3:
lduw [%o5], %l3
sub %l3, 1, %l6
cas [%o5], %l3, %l6
cmp %l3, %l6
bne,pt %xcc, sync_init_2_3
nop
membar #Sync
sync_init_3_3:
lduw [%o5], %l3 ! delay slot
brnz,pt %l3, sync_init_3_3
nop
!-- end of sync_init ---


BEGIN_NODES3: ! Test istream for CPU 3 begins

P3096: !_ST [10] (maybe <- 0x1800001) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3097: !_ST [12] (maybe <- 0x1800002) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3098: !_LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3099: !_ST [11] (maybe <- 0x1800003) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3100: !_DWST [0] (maybe <- 0x1800004) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3101: !_DWLD [0] (Int) (CBR)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3101
nop
RET3101:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3102: !_LD [8] (Int)
lduw [%i1 + 256], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P3103: !_ST [14] (maybe <- 0x1800006) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3104: !_PREFETCH [11] (Int) (Branch target of P3125)
prefetch [%i2 + 64], 1
ba P3105
nop

TARGET3125:
ba RET3125
nop


P3105: !_ST [7] (maybe <- 0x1800007) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3106: !_ST [13] (maybe <- 0x1800008) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3106
nop
RET3106:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3107: !_DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3108: !_DWST [0] (maybe <- 0x41000001) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P3109: !_DWST [9] (maybe <- 0x1800009) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P3110: !_DWST [8] (maybe <- 0x180000a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P3111: !_LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3112: !_LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3113: !_LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3114: !_ST [2] (maybe <- 0x180000b) (Int) (Branch target of P3904)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
ba P3115
nop

TARGET3904:
ba RET3904
nop


P3115: !_ST [3] (maybe <- 0x180000c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3116: !_DWST [6] (maybe <- 0x180000d) (Int) (CBR)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3116
nop
RET3116:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3117: !_ST [14] (maybe <- 0x180000f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3118: !_ST [14] (maybe <- 0x1800010) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3119: !_DWST [4] (maybe <- 0x1800011) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P3120: !_ST [2] (maybe <- 0x1800012) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3121: !_ST [11] (maybe <- 0x1800013) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3122: !_CASX [8] (maybe <- 0x1800014) (Int)
add %i1, 256, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %l7
or %l7, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
add  %l4, 1, %l4

P3123: !_ST [2] (maybe <- 0x41000003) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P3124: !_CASX [15] (maybe <- 0x1800015) (Int) (CBR)
add %i3, 192, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l3
or %l3, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l6
or %l6, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3124
nop
RET3124:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3125: !_ST [15] (maybe <- 0x41000004) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3125
nop
RET3125:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3126: !_ST [9] (maybe <- 0x1800016) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3127: !_LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3128: !_DWST [12] (maybe <- 0x1800017) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P3129: !_ST [12] (maybe <- 0x1800018) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3130: !_NOP (Int)
nop

P3131: !_ST [0] (maybe <- 0x41000005) (FP) (Branch target of P3682)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]
ba P3132
nop

TARGET3682:
ba RET3682
nop


P3132: !_ST [9] (maybe <- 0x1800019) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3133: !_CASX [5] (maybe <- 0x180001a) (Int)
add %i1, 72, %o5
ldx [%o5], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l7
mov %l4, %o0
casx [%o5], %l7, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P3134: !_DWST [8] (maybe <- 0x180001b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

P3135: !_ST [12] (maybe <- 0x180001c) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3136: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3137: !_CAS [11] (maybe <- 0x180001d) (Int) (Branch target of P3838)
add %i2, 64, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4
ba P3138
nop

TARGET3838:
ba RET3838
nop


P3138: !_ST [13] (maybe <- 0x180001e) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3139: !_ST [6] (maybe <- 0x180001f) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3140: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3141: !_DWLD [14] (Int)
ldx [%i3 + 128], %o2
! move %o2(upper) -> %o2(upper)

P3142: !_ST [6] (maybe <- 0x1800020) (Int) (Branch target of P4098)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4
ba P3143
nop

TARGET4098:
ba RET4098
nop


P3143: !_ST [14] (maybe <- 0x1800021) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3144: !_DWST [7] (maybe <- 0x1800022) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P3145: !_DWST [2] (maybe <- 0x1800024) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P3146: !_ST [10] (maybe <- 0x1800025) (Int) (Branch target of P3281)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P3147
nop

TARGET3281:
ba RET3281
nop


P3147: !_DWST [7] (maybe <- 0x1800026) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P3148: !_ST [1] (maybe <- 0x1800028) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3149: !_ST [6] (maybe <- 0x1800029) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3150: !_ST [7] (maybe <- 0x180002a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3151: !_ST [9] (maybe <- 0x180002b) (Int) (Branch target of P3729)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P3152
nop

TARGET3729:
ba RET3729
nop


P3152: !_DWST [0] (maybe <- 0x180002c) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3153: !_DWLD [0] (FP)
ldd [%i0 + 0], %f0
! 2 addresses covered

P3154: !_PREFETCH [14] (Int) (CBR)
prefetch [%i3 + 128], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3154
nop
RET3154:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3155: !_ST [10] (maybe <- 0x41000006) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3155
nop
RET3155:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3156: !_ST [14] (maybe <- 0x180002e) (Int) (Branch target of P3312)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P3157
nop

TARGET3312:
ba RET3312
nop


P3157: !_ST [13] (maybe <- 0x180002f) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3158: !_ST [5] (maybe <- 0x1800030) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3159: !_DWST [5] (maybe <- 0x1800031) (Int) (Branch target of P4059)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4
ba P3160
nop

TARGET4059:
ba RET4059
nop


P3160: !_CASX [4] (maybe <- 0x1800032) (Int) (CBR)
add %i0, 64, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %o5
or %o5, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3160
nop
RET3160:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3161: !_DWST [13] (maybe <- 0x1800033) (Int) (Branch target of P3897)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P3162
nop

TARGET3897:
ba RET3897
nop


P3162: !_CAS [14] (maybe <- 0x1800034) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
wr %g0, 0x88, %asi
add %i3, 128, %o5
lduwa [%o5] %asi, %l6
mov %l6, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l3, %o0
casa [%o5] %asi, %l7, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3163: !_DWLD [4] (Int)
ldx [%i0 + 64], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l7
or %l7, %o0, %o0

P3164: !_ST [2] (maybe <- 0x1800035) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3165: !_LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3166: !_ST [4] (maybe <- 0x1800036) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3167: !_REPLACEMENT [10] (Int) (Branch target of P3790)
sethi %hi(0x20), %l3
or %l3, %lo(0x20),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
ba P3168
nop

TARGET3790:
ba RET3790
nop


P3168: !_DWST [6] (maybe <- 0x1800037) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P3169: !_ST [1] (maybe <- 0x1800039) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3170: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3171: !_ST [4] (maybe <- 0x180003a) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3172: !_CAS [10] (maybe <- 0x180003b) (Int) (Branch target of P3460)
add %i2, 32, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1
mov %l4, %o2
cas [%l3], %o5, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4
ba P3173
nop

TARGET3460:
ba RET3460
nop


P3173: !_ST [2] (maybe <- 0x41000007) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P3174: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3175: !_DWST [12] (maybe <- 0x180003c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3176: !_ST [9] (maybe <- 0x180003d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3177: !_DWST [3] (maybe <- 0x180003e) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P3178: !_DWST [7] (maybe <- 0x180003f) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P3179: !_ST [4] (maybe <- 0x1800041) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3180: !_DWST [8] (maybe <- 0x1800042) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P3181: !_ST [10] (maybe <- 0x41000008) (FP) (Branch target of P4070)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]
ba P3182
nop

TARGET4070:
ba RET4070
nop


P3182: !_DWLD [7] (FP)
ldd [%i1 + 80], %f2
! 2 addresses covered

P3183: !_ST [6] (maybe <- 0x1800043) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3184: !_ST [13] (maybe <- 0x41000009) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P3185: !_ST [15] (maybe <- 0x1800044) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i3 + 192] %asi
add   %l4, 1, %l4

P3186: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3187: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3188: !_LD [8] (Int)
lduw [%i1 + 256], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

P3189: !_ST [3] (maybe <- 0x1800045) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 32] %asi
add   %l4, 1, %l4

P3190: !_DWST [14] (maybe <- 0x1800046) (Int) (Branch target of P3963)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4
ba P3191
nop

TARGET3963:
ba RET3963
nop


P3191: !_ST [7] (maybe <- 0x1800047) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3192: !_ST [7] (maybe <- 0x1800048) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3193: !_CASX [9] (maybe <- 0x1800049) (Int)
add %i1, 512, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
sllx %l4, 32, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P3194: !_CAS [10] (maybe <- 0x180004a) (Int)
add %i2, 32, %l7
lduw [%l7], %o0
mov %o0, %l6
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3195: !_CASX [6] (maybe <- 0x180004b) (Int)
add %i1, 80, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov %o1, %l6
sllx %l4, 32, %o2
add  %l4, 1, %l4
or   %l4, %o2, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P3196: !_ST [2] (maybe <- 0x180004d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3197: !_DWST [7] (maybe <- 0x180004e) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P3198: !_ST [10] (maybe <- 0x1800050) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3199: !_DWLD [4] (Int)
ldx [%i0 + 64], %o3
! move %o3(upper) -> %o3(upper)

P3200: !_CASX [6] (maybe <- 0x1800051) (Int) (LE)
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
sllx %l3, 32, %l7
or %l3, %l7, %l3 
and %l6, %l3, %l7
srlx %l7, 8, %l7
sllx %l6, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6 
sethi %hi(0xffff0000), %l3
or %l3, %lo(0xffff0000), %l3
srlx %l6, 16, %l7
andn %l7, %l3, %l7
andn %l6, %l3, %l6
sllx %l6, 16, %l6
or %l6, %l7, %l6 
srlx %l6, 32, %l7
sllx %l6, 32, %l6
or %l6, %l7, %l7 
wr %g0, 0x88, %asi
add %i1, 80, %l6
ldxa [%l6] %asi, %o5
! move %o5(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %o5, 0, %l3
or %l3, %o3, %o3
! move %o5(upper) -> %o4(upper)
or %o5, %g0, %o4
mov %o5, %l3
mov  %l7, %o5
casxa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(upper) -> %o0(upper)
or %o5, %g0, %o0
add  %l4, 1, %l4

P3201: !_MEMBAR (Int)
membar #StoreLoad

P3202: !_DWST [5] (maybe <- 0x1800053) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P3203: !_LD [11] (Int)
lduw [%i2 + 64], %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l3, %o0, %o0

P3204: !_ST [0] (maybe <- 0x1800054) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3205: !_DWST [14] (maybe <- 0x1800055) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i3 + 128 ] %asi
add   %l4, 1, %l4

P3206: !_ST [5] (maybe <- 0x1800056) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3207: !_ST [10] (maybe <- 0x1800057) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3208: !_DWST [11] (maybe <- 0x1800058) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P3209: !_ST [12] (maybe <- 0x1800059) (Int) (Branch target of P3930)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P3210
nop

TARGET3930:
ba RET3930
nop


P3210: !_ST [11] (maybe <- 0x4100000a) (FP) (Branch target of P4094)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]
ba P3211
nop

TARGET4094:
ba RET4094
nop


P3211: !_DWST [11] (maybe <- 0x180005a) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i2 + 64 ] %asi
add   %l4, 1, %l4

P3212: !_ST [6] (maybe <- 0x180005b) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3213: !_PREFETCH [10] (Int) (Branch target of P3734)
prefetch [%i2 + 32], 1
ba P3214
nop

TARGET3734:
ba RET3734
nop


P3214: !_DWST [0] (maybe <- 0x180005c) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3215: !_ST [11] (maybe <- 0x180005e) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3216: !_REPLACEMENT [3] (Int) (Branch target of P3832)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P3217
nop

TARGET3832:
ba RET3832
nop


P3217: !_DWLD [9] (Int)
ldx [%i1 + 512], %o1
! move %o1(upper) -> %o1(upper)

P3218: !_DWST [12] (maybe <- 0x180005f) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P3219: !_ST [1] (maybe <- 0x1800060) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3220: !_ST [6] (maybe <- 0x1800061) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3221: !_DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l3
or %l3, %o1, %o1

P3222: !_ST [11] (maybe <- 0x1800062) (Int) (Branch target of P3308)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P3223
nop

TARGET3308:
ba RET3308
nop


P3223: !_ST [6] (maybe <- 0x1800063) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3224: !_DWST [14] (maybe <- 0x1800064) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P3225: !_DWLD [6] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3226: !_ST [0] (maybe <- 0x1800065) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3227: !_DWST [9] (maybe <- 0x1800066) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P3228: !_DWLD [14] (Int)
ldx [%i3 + 128], %o3
! move %o3(upper) -> %o3(upper)

P3229: !_ST [8] (maybe <- 0x1800067) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i1 + 256] %asi
add   %l4, 1, %l4

P3230: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l3
or %l3, %lo(0x0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3231: !_DWST [5] (maybe <- 0x1800068) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P3232: !_ST [6] (maybe <- 0x1800069) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3233: !_ST [11] (maybe <- 0x180006a) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3234: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3235: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %l3
or %l3, %lo(0x54),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3236: !_DWST [15] (maybe <- 0x180006b) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l6
srl %l6, 8, %l6
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3
srl %l3, 16, %l6
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l6, %l3
stxa %l3, [%i3 + 192 ] %asi
add   %l4, 1, %l4

P3237: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l7
or %l7, %lo(0xc),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3238: !_LD [11] (Int) (Branch target of P3755)
lduw [%i2 + 64], %l7
! move %l7(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l7, %o3, %o3
ba P3239
nop

TARGET3755:
ba RET3755
nop


P3239: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %o5
or %o5, %lo(0x200),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3240: !_CAS [3] (maybe <- 0x180006c) (Int)
add %i0, 32, %o5
lduw [%o5], %o4
mov %o4, %l7
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o4(lower)
srl %l6, 0, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P3241: !_ST [7] (maybe <- 0x180006d) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3242: !_ST [1] (maybe <- 0x180006e) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 4] %asi
add   %l4, 1, %l4

P3243: !_ST [7] (maybe <- 0x180006f) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3244: !_CAS [13] (maybe <- 0x1800070) (Int) (Branch target of P3675)
add %i3, 64, %l3
lduw [%l3], %o0
mov %o0, %o5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4
ba P3245
nop

TARGET3675:
ba RET3675
nop


P3245: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3246: !_DWLD [8] (Int) (Branch target of P4097)
ldx [%i1 + 256], %o1
! move %o1(upper) -> %o1(upper)
ba P3247
nop

TARGET4097:
ba RET4097
nop


P3247: !_CASX [13] (maybe <- 0x1800071) (Int)
add %i3, 64, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l7
or %l7, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
add  %l4, 1, %l4

P3248: !_ST [1] (maybe <- 0x1800072) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3249: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3250: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %l3
or %l3, %lo(0x54),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3251: !_CAS [8] (maybe <- 0x1800073) (Int)
add %i1, 256, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3252: !_DWST [1] (maybe <- 0x1800074) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3253: !_ST [14] (maybe <- 0x1800076) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3254: !_ST [15] (maybe <- 0x1800077) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3255: !_ST [9] (maybe <- 0x1800078) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3256: !_DWST [10] (maybe <- 0x1800079) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P3257: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3258: !_ST [2] (maybe <- 0x180007a) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3259: !_DWST [13] (maybe <- 0x180007b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3260: !_ST [15] (maybe <- 0x180007c) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3261: !_ST [10] (maybe <- 0x4100000b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P3262: !_CAS [10] (maybe <- 0x180007d) (Int)
add %i2, 32, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%o5], %l7, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3263: !_CAS [3] (maybe <- 0x180007e) (Int)
add %i0, 32, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3264: !_ST [14] (maybe <- 0x180007f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3265: !_LD [9] (FP)
ld [%i1 + 512], %f4
! 1 addresses covered

P3266: !_ST [7] (maybe <- 0x1800080) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3267: !_ST [11] (maybe <- 0x1800081) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3268: !_DWST [8] (maybe <- 0x1800082) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P3269: !_LD [7] (Int)
lduw [%i1 + 84], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P3270: !_CAS [10] (maybe <- 0x1800083) (Int)
add %i2, 32, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4

P3271: !_CASX [12] (maybe <- 0x1800084) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %l6, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
wr %g0, 0x88, %asi
add %i3, 0, %l6
ldxa [%l6] %asi, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l3
or %l3, %o3, %o3
mov  %o5, %l3
mov  %l7, %o5
casxa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P3272: !_MEMBAR (Int)
membar #StoreLoad

P3273: !_DWLD [11] (Int)
ldx [%i2 + 64], %o0
! move %o0(upper) -> %o0(upper)

P3274: !_CASX [12] (maybe <- 0x1800085) (Int)
add %i3, 0, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P3275: !_DWLD [14] (Int)
ldx [%i3 + 128], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2

P3276: !_ST [2] (maybe <- 0x1800086) (Int) (CBR) (Branch target of P3320)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3276
nop
RET3276:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P3277
nop

TARGET3320:
ba RET3320
nop


P3277: !_ST [2] (maybe <- 0x1800087) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3278: !_LD [7] (Int) (Branch target of P3558)
lduw [%i1 + 84], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
ba P3279
nop

TARGET3558:
ba RET3558
nop


P3279: !_ST [5] (maybe <- 0x1800088) (Int) (Branch target of P3626)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P3280
nop

TARGET3626:
ba RET3626
nop


P3280: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3281: !_ST [9] (maybe <- 0x1800089) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3281
nop
RET3281:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3282: !_CASX [6] (maybe <- 0x180008a) (Int)
add %i1, 80, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l3
or %l3, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
add  %l4, 1, %l4

P3283: !_DWST [10] (maybe <- 0x180008c) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3283
nop
RET3283:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3284: !_DWST [10] (maybe <- 0x180008d) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P3285: !_CAS [10] (maybe <- 0x180008e) (Int) (CBR)
add %i2, 32, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3285
nop
RET3285:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3286: !_DWST [13] (maybe <- 0x180008f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P3287: !_NOP (Int) (CBR)
nop

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3287
nop
RET3287:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3288: !_ST [6] (maybe <- 0x1800090) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3289: !_LD [6] (FP)
ld [%i1 + 80], %f5
! 1 addresses covered

P3290: !_ST [4] (maybe <- 0x1800091) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3291: !_ST [7] (maybe <- 0x4100000c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P3292: !_DWST [1] (maybe <- 0x1800092) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3293: !_DWST [2] (maybe <- 0x4100000d) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P3294: !_ST [6] (maybe <- 0x1800094) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3295: !_ST [11] (maybe <- 0x1800095) (Int) (LE) (Branch target of P3744)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i2 + 64] %asi
add   %l4, 1, %l4
ba P3296
nop

TARGET3744:
ba RET3744
nop


P3296: !_ST [13] (maybe <- 0x1800096) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3297: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3298: !_ST [5] (maybe <- 0x1800097) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3299: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3300: !_DWLD [8] (Int)
ldx [%i1 + 256], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %o5
or %o5, %o1, %o1

P3301: !_DWLD [10] (Int)
ldx [%i2 + 32], %o2
! move %o2(upper) -> %o2(upper)

P3302: !_ST [15] (maybe <- 0x1800098) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3303: !_LD [10] (Int)
lduw [%i2 + 32], %o5
! move %o5(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %o5, %o2, %o2

P3304: !_DWST [13] (maybe <- 0x1800099) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P3305: !_CASX [11] (maybe <- 0x180009a) (Int) (Branch target of P3767)
add %i2, 64, %l3
ldx [%l3], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %o5
sllx %l4, 32, %o4
casx [%l3], %o5, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4
ba P3306
nop

TARGET3767:
ba RET3767
nop


P3306: !_CASX [2] (maybe <- 0x180009b) (Int)
add %i0, 8, %l3
ldx [%l3], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %o5
mov %l4, %o1
casx [%l3], %o5, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3307: !_ST [8] (maybe <- 0x180009c) (Int) (Branch target of P3324)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P3308
nop

TARGET3324:
ba RET3324
nop


P3308: !_DWST [15] (maybe <- 0x4100000e) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3308
nop
RET3308:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3309: !_ST [0] (maybe <- 0x180009d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3310: !_DWST [9] (maybe <- 0x4100000f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P3311: !_ST [12] (maybe <- 0x180009e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3312: !_ST [8] (maybe <- 0x180009f) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3312
nop
RET3312:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3313: !_ST [3] (maybe <- 0x18000a0) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3314: !_CAS [15] (maybe <- 0x18000a1) (Int)
add %i3, 192, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P3315: !_LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3316: !_CASX [10] (maybe <- 0x18000a2) (Int)
add %i2, 32, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l3
or %l3, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
add  %l4, 1, %l4

P3317: !_DWST [0] (maybe <- 0x18000a3) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3318: !_SWAP [1] (maybe <- 0x18000a5) (Int)
mov %l4, %l6
swap  [%i0 + 4], %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P3319: !_ST [8] (maybe <- 0x18000a6) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3320: !_ST [1] (maybe <- 0x18000a7) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3320
nop
RET3320:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3321: !_LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3322: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3323: !_DWST [12] (maybe <- 0x18000a8) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P3324: !_CASX [8] (maybe <- 0x18000a9) (Int) (CBR)
add %i1, 256, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %l6
or %l6, %o1, %o1
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l7
or %l7, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3324
nop
RET3324:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3325: !_ST [12] (maybe <- 0x18000aa) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3326: !_ST [3] (maybe <- 0x18000ab) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3327: !_ST [4] (maybe <- 0x41000010) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P3328: !_ST [10] (maybe <- 0x41000011) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P3329: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3330: !_DWST [10] (maybe <- 0x18000ac) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3330
nop
RET3330:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3331: !_DWST [3] (maybe <- 0x18000ad) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3332: !_DWST [7] (maybe <- 0x18000ae) (Int) (Branch target of P3354)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4
ba P3333
nop

TARGET3354:
ba RET3354
nop


P3333: !_ST [10] (maybe <- 0x18000b0) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3334: !_DWST [13] (maybe <- 0x18000b1) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P3335: !_ST [12] (maybe <- 0x18000b2) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3335
nop
RET3335:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3336: !_ST [9] (maybe <- 0x18000b3) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3337: !_DWST [12] (maybe <- 0x18000b4) (Int) (Branch target of P3552)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4
ba P3338
nop

TARGET3552:
ba RET3552
nop


P3338: !_LD [15] (Int)
lduw [%i3 + 192], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

P3339: !_ST [4] (maybe <- 0x18000b5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3340: !_ST [1] (maybe <- 0x18000b6) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3341: !_ST [11] (maybe <- 0x18000b7) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3342: !_ST [13] (maybe <- 0x18000b8) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3343: !_ST [7] (maybe <- 0x18000b9) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3344: !_ST [10] (maybe <- 0x18000ba) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3345: !_DWLD [6] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3346: !_CASX [12] (maybe <- 0x18000bb) (Int)
add %i3, 0, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
sllx %l4, 32, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3347: !_ST [4] (maybe <- 0x18000bc) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3348: !_CAS [0] (maybe <- 0x18000bd) (Int)
add %i0, 0, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4

P3349: !_ST [14] (maybe <- 0x18000be) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3350: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3351: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3352: !_NOP (Int)
nop

P3353: !_LD [9] (Int) (CBR)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3353
nop
RET3353:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3354: !_LD [0] (Int) (CBR)
lduw [%i0 + 0], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3354
nop
RET3354:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3355: !_DWST [2] (maybe <- 0x18000bf) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P3356: !_ST [9] (maybe <- 0x41000012) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P3357: !_DWST [0] (maybe <- 0x18000c0) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3358: !_ST [2] (maybe <- 0x18000c2) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3359: !_CAS [12] (maybe <- 0x18000c3) (Int)
add %i3, 0, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P3360: !_LD [1] (Int)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3361: !_LD [13] (Int) (CBR)
lduw [%i3 + 64], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3361
nop
RET3361:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3362: !_ST [2] (maybe <- 0x18000c4) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3363: !_ST [8] (maybe <- 0x18000c5) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3364: !_ST [10] (maybe <- 0x18000c6) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3365: !_ST [10] (maybe <- 0x18000c7) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3366: !_ST [12] (maybe <- 0x18000c8) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3367: !_ST [13] (maybe <- 0x18000c9) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3368: !_ST [11] (maybe <- 0x18000ca) (Int) (Branch target of P3276)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P3369
nop

TARGET3276:
ba RET3276
nop


P3369: !_DWST [1] (maybe <- 0x18000cb) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3370: !_ST [13] (maybe <- 0x18000cd) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3371: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l6
or %l6, %lo(0x50),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3372: !_ST [15] (maybe <- 0x18000ce) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3373: !_ST [7] (maybe <- 0x18000cf) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3374: !_DWST [0] (maybe <- 0x18000d0) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3375: !_DWST [1] (maybe <- 0x18000d2) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3376: !_DWST [10] (maybe <- 0x18000d4) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P3377: !_ST [1] (maybe <- 0x18000d5) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3378: !_ST [9] (maybe <- 0x18000d6) (Int) (Branch target of P3283)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P3379
nop

TARGET3283:
ba RET3283
nop


P3379: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3380: !_CAS [1] (maybe <- 0x18000d7) (Int)
add %i0, 4, %l7
lduw [%l7], %o1
mov %o1, %l6
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o1(lower)
srl %l3, 0, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3381: !_ST [6] (maybe <- 0x18000d8) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3381
nop
RET3381:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3382: !_DWST [13] (maybe <- 0x18000d9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3383: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3384: !_DWST [9] (maybe <- 0x18000da) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P3385: !_CASX [11] (maybe <- 0x18000db) (Int)
add %i2, 64, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P3386: !_DWST [2] (maybe <- 0x41000013) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P3387: !_ST [14] (maybe <- 0x18000dc) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3388: !_ST [8] (maybe <- 0x18000dd) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3389: !_ST [15] (maybe <- 0x18000de) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3390: !_DWST [2] (maybe <- 0x18000df) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P3391: !_DWLD [10] (FP) (CBR)
ldd [%i2 + 32], %f6
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3391
nop
RET3391:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3392: !_CAS [8] (maybe <- 0x18000e0) (Int)
add %i1, 256, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P3393: !_ST [5] (maybe <- 0x18000e1) (Int) (Branch target of P3961)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P3394
nop

TARGET3961:
ba RET3961
nop


P3394: !_PREFETCH [5] (Int) (CBR)
prefetch [%i1 + 76], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3394
nop
RET3394:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3395: !_ST [15] (maybe <- 0x18000e2) (Int) (Branch target of P3116)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P3396
nop

TARGET3116:
ba RET3116
nop


P3396: !_ST [7] (maybe <- 0x18000e3) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3397: !_ST [0] (maybe <- 0x18000e4) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3397
nop
RET3397:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3398: !_ST [9] (maybe <- 0x18000e5) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3399: !_DWST [13] (maybe <- 0x18000e6) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P3400: !_ST [12] (maybe <- 0x18000e7) (Int) (Branch target of P3508)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P3401
nop

TARGET3508:
ba RET3508
nop


P3401: !_ST [15] (maybe <- 0x18000e8) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3402: !_DWST [12] (maybe <- 0x18000e9) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P3403: !_ST [3] (maybe <- 0x18000ea) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3404: !_DWST [8] (maybe <- 0x18000eb) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3404
nop
RET3404:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3405: !_DWST [8] (maybe <- 0x18000ec) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P3406: !_CASX [1] (maybe <- 0x18000ed) (Int) (Branch target of P4042)
add %i0, 0, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l7
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4
ba P3407
nop

TARGET4042:
ba RET4042
nop


P3407: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3408: !_ST [8] (maybe <- 0x18000ef) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3409: !_DWST [2] (maybe <- 0x18000f0) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P3410: !_ST [1] (maybe <- 0x18000f1) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3411: !_ST [5] (maybe <- 0x18000f2) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i1 + 76] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3411
nop
RET3411:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3412: !_ST [6] (maybe <- 0x18000f3) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3413: !_ST [7] (maybe <- 0x18000f4) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3414: !_DWST [3] (maybe <- 0x18000f5) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P3415: !_CASX [13] (maybe <- 0x18000f6) (Int)
add %i3, 64, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P3416: !_REPLACEMENT [10] (Int) (Branch target of P3852)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
ba P3417
nop

TARGET3852:
ba RET3852
nop


P3417: !_ST [9] (maybe <- 0x18000f7) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3418: !_DWLD [9] (Int)
ldx [%i1 + 512], %o4
! move %o4(upper) -> %o4(upper)

P3419: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3420: !_CASX [3] (maybe <- 0x18000f8) (Int) (Branch target of P4066)
add %i0, 32, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l7, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l3
or %l3, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
add  %l4, 1, %l4
ba P3421
nop

TARGET4066:
ba RET4066
nop


P3421: !_ST [9] (maybe <- 0x18000f9) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3422: !_ST [10] (maybe <- 0x18000fa) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i2 + 32] %asi
add   %l4, 1, %l4

P3423: !_ST [6] (maybe <- 0x18000fb) (Int) (CBR) (Branch target of P3654)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3423
nop
RET3423:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P3424
nop

TARGET3654:
ba RET3654
nop


P3424: !_ST [9] (maybe <- 0x18000fc) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3425: !_DWST [5] (maybe <- 0x18000fd) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P3426: !_ST [14] (maybe <- 0x18000fe) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3427: !_DWST [12] (maybe <- 0x41000014) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P3428: !_ST [4] (maybe <- 0x18000ff) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3429: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3430: !_ST [15] (maybe <- 0x1800100) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3431: !_MEMBAR (Int)
membar #StoreLoad

P3432: !_ST [4] (maybe <- 0x1800101) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 64] %asi
add   %l4, 1, %l4

P3433: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3434: !_ST [6] (maybe <- 0x1800102) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3435: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3436: !_DWST [11] (maybe <- 0x1800103) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P3437: !_LD [7] (Int)
lduw [%i1 + 84], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P3438: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3439: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3440: !_ST [10] (maybe <- 0x1800104) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3440
nop
RET3440:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3441: !_ST [14] (maybe <- 0x1800105) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3442: !_ST [4] (maybe <- 0x1800106) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3443: !_ST [15] (maybe <- 0x1800107) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3444: !_ST [11] (maybe <- 0x41000015) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3444
nop
RET3444:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3445: !_CAS [2] (maybe <- 0x1800108) (Int)
add %i0, 12, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P3446: !_CASX [2] (maybe <- 0x1800109) (Int) (CBR)
add %i0, 8, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
mov %l4, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3446
nop
RET3446:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3447: !_ST [2] (maybe <- 0x180010a) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3448: !_DWST [2] (maybe <- 0x180010b) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P3449: !_REPLACEMENT [8] (Int)
sethi %hi(0x100), %l6
or %l6, %lo(0x100),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3450: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3451: !_ST [3] (maybe <- 0x180010c) (Int) (CBR) (Branch target of P3397)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3451
nop
RET3451:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P3452
nop

TARGET3397:
ba RET3397
nop


P3452: !_ST [5] (maybe <- 0x180010d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3453: !_ST [13] (maybe <- 0x180010e) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 64] %asi
add   %l4, 1, %l4

P3454: !_ST [13] (maybe <- 0x180010f) (Int) (Branch target of P4045)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P3455
nop

TARGET4045:
ba RET4045
nop


P3455: !_ST [0] (maybe <- 0x1800110) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3456: !_DWST [14] (maybe <- 0x1800111) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P3457: !_ST [1] (maybe <- 0x1800112) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3458: !_ST [7] (maybe <- 0x1800113) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3459: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3460: !_DWST [0] (maybe <- 0x1800114) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
sllx %l4, 32, %l6
add   %l4, 1, %l4
or %l6, %l4, %l7
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
sllx %o5, 32, %l6
or %o5, %l6, %o5 
and %l7, %o5, %l6
srlx %l6, 8, %l6
sllx %l7, 8, %l7
and %l7, %o5, %l7
or %l7, %l6, %l7 
sethi %hi(0xffff0000), %o5
or %o5, %lo(0xffff0000), %o5
srlx %l7, 16, %l6
andn %l6, %o5, %l6
andn %l7, %o5, %l7
sllx %l7, 16, %l7
or %l7, %l6, %l7 
srlx %l7, 32, %l6
sllx %l7, 32, %l7
or %l7, %l6, %l6 
stxa %l6, [%i0 + 0 ] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3460
nop
RET3460:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3461: !_DWLD [5] (Int)
ldx [%i1 + 72], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3462: !_ST [9] (maybe <- 0x1800116) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3463: !_CASX [5] (maybe <- 0x1800117) (Int)
add %i1, 72, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P3464: !_DWST [3] (maybe <- 0x1800118) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P3465: !_DWST [7] (maybe <- 0x1800119) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P3466: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3467: !_ST [9] (maybe <- 0x180011b) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 512] %asi
add   %l4, 1, %l4

P3468: !_DWST [0] (maybe <- 0x180011c) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3469: !_ST [15] (maybe <- 0x180011e) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i3 + 192] %asi
add   %l4, 1, %l4

P3470: !_PREFETCH [3] (Int) (CBR) (Branch target of P3935)
prefetch [%i0 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3470
nop
RET3470:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P3471
nop

TARGET3935:
ba RET3935
nop


P3471: !_ST [14] (maybe <- 0x180011f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3472: !_DWLD [6] (Int)
ldx [%i1 + 80], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3

P3473: !_ST [0] (maybe <- 0x1800120) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3474: !_ST [6] (maybe <- 0x1800121) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3475: !_CASX [7] (maybe <- 0x1800122) (Int)
add %i1, 80, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l3, %l6
sllx %l4, 32, %l3
add  %l4, 1, %l4
or   %l4, %l3, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
add  %l4, 1, %l4

P3476: !_DWST [15] (maybe <- 0x1800124) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3477: !_ST [5] (maybe <- 0x1800125) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3478: !_ST [9] (maybe <- 0x1800126) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3479: !_ST [14] (maybe <- 0x1800127) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3480: !_DWST [15] (maybe <- 0x1800128) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3481: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3482: !_ST [10] (maybe <- 0x1800129) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3483: !_CAS [9] (maybe <- 0x180012a) (Int)
add %i1, 512, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3484: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3485: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3486: !_ST [1] (maybe <- 0x180012b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3487: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3488: !_ST [11] (maybe <- 0x180012c) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3489: !_ST [15] (maybe <- 0x180012d) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3490: !_DWST [3] (maybe <- 0x41000016) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P3491: !_DWST [5] (maybe <- 0x180012e) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P3492: !_ST [14] (maybe <- 0x180012f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3493: !_ST [10] (maybe <- 0x41000017) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P3494: !_LD [3] (Int) (CBR)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3494
nop
RET3494:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3495: !_ST [5] (maybe <- 0x1800130) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3496: !_REPLACEMENT [13] (Int) (Branch target of P3404)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P3497
nop

TARGET3404:
ba RET3404
nop


P3497: !_ST [1] (maybe <- 0x1800131) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3498: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3499: !_DWST [4] (maybe <- 0x41000018) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P3500: !_CASX [13] (maybe <- 0x1800132) (Int)
add %i3, 64, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P3501: !_DWST [14] (maybe <- 0x1800133) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3501
nop
RET3501:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3502: !_CAS [7] (maybe <- 0x1800134) (Int)
add %i1, 84, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P3503: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %o5
or %o5, %lo(0x200),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3504: !_ST [1] (maybe <- 0x1800135) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3505: !_ST [14] (maybe <- 0x1800136) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3506: !_CAS [4] (maybe <- 0x1800137) (Int) (CBR)
add %i0, 64, %l6
lduw [%l6], %o0
mov %o0, %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l6
or %l6, %o0, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3506
nop
RET3506:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3507: !_CAS [10] (maybe <- 0x1800138) (Int)
add %i2, 32, %l7
lduw [%l7], %o1
mov %o1, %l6
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o1(lower)
srl %l3, 0, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3508: !_ST [13] (maybe <- 0x1800139) (Int) (CBR) (Branch target of P4021)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3508
nop
RET3508:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P3509
nop

TARGET4021:
ba RET4021
nop


P3509: !_CASX [6] (maybe <- 0x180013a) (Int)
add %i1, 80, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov %o2, %l6
sllx %l4, 32, %o3
add  %l4, 1, %l4
or   %l4, %o3, %o3
casx [%l7], %l6, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P3510: !_DWST [10] (maybe <- 0x180013c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3511: !_LD [15] (Int)
lduw [%i3 + 192], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3512: !_ST [4] (maybe <- 0x180013d) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3513: !_DWST [2] (maybe <- 0x180013e) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P3514: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3515: !_ST [6] (maybe <- 0x180013f) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3516: !_ST [3] (maybe <- 0x1800140) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3517: !_DWST [0] (maybe <- 0x1800141) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3518: !_DWST [15] (maybe <- 0x41000019) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P3519: !_DWST [11] (maybe <- 0x1800143) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P3520: !_DWST [11] (maybe <- 0x1800144) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P3521: !_DWST [3] (maybe <- 0x1800145) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P3522: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P3523: !_ST [4] (maybe <- 0x1800146) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3524: !_ST [13] (maybe <- 0x1800147) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3525: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3526: !_ST [10] (maybe <- 0x1800148) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3527: !_ST [2] (maybe <- 0x1800149) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3528: !_DWST [2] (maybe <- 0x180014a) (Int) (Branch target of P3748)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4
ba P3529
nop

TARGET3748:
ba RET3748
nop


P3529: !_LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3530: !_ST [7] (maybe <- 0x180014b) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3531: !_NOP (Int)
nop

P3532: !_ST [6] (maybe <- 0x180014c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3533: !_ST [5] (maybe <- 0x180014d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3534: !_ST [12] (maybe <- 0x180014e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3535: !_ST [9] (maybe <- 0x180014f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3536: !_LD [14] (Int)
lduw [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3537: !_DWST [11] (maybe <- 0x1800150) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P3538: !_DWST [1] (maybe <- 0x1800151) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3539: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3540: !_DWST [8] (maybe <- 0x1800153) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3541: !_DWST [2] (maybe <- 0x1800154) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
sllx %l6, 32, %l6 
stxa %l6, [%i0 + 8 ] %asi
add   %l4, 1, %l4

P3542: !_CAS [9] (maybe <- 0x1800155) (Int)
add %i1, 512, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3543: !_ST [6] (maybe <- 0x1800156) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3544: !_DWST [10] (maybe <- 0x1800157) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P3545: !_ST [13] (maybe <- 0x1800158) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3545
nop
RET3545:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3546: !_ST [4] (maybe <- 0x1800159) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3547: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3548: !_DWST [4] (maybe <- 0x180015a) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3548
nop
RET3548:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3549: !_SWAP [12] (maybe <- 0x180015b) (Int)
mov %l4, %l7
swap  [%i3 + 0], %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P3550: !_ST [1] (maybe <- 0x180015c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3551: !_DWST [13] (maybe <- 0x180015d) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P3552: !_DWST [9] (maybe <- 0x180015e) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3552
nop
RET3552:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3553: !_CAS [10] (maybe <- 0x180015f) (Int) (CBR)
add %i2, 32, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3553
nop
RET3553:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3554: !_ST [8] (maybe <- 0x1800160) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3555: !_ST [2] (maybe <- 0x1800161) (Int) (Branch target of P3391)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4
ba P3556
nop

TARGET3391:
ba RET3391
nop


P3556: !_ST [2] (maybe <- 0x1800162) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3557: !_CAS [12] (maybe <- 0x1800163) (Int)
add %i3, 0, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P3558: !_ST [9] (maybe <- 0x1800164) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3558
nop
RET3558:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3559: !_ST [4] (maybe <- 0x1800165) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3560: !_ST [8] (maybe <- 0x1800166) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3561: !_CAS [0] (maybe <- 0x1800167) (Int)
add %i0, 0, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P3562: !_ST [15] (maybe <- 0x1800168) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3563: !_LD [10] (Int)
lduw [%i2 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3564: !_ST [7] (maybe <- 0x1800169) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3565: !_DWST [0] (maybe <- 0x180016a) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3566: !_CASX [1] (maybe <- 0x180016c) (Int)
add %i0, 0, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l3
or %l3, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l6
or %l6, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
add  %l4, 1, %l4

P3567: !_DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2

P3568: !_CAS [9] (maybe <- 0x180016e) (Int)
add %i1, 512, %o5
lduw [%o5], %o3
mov %o3, %l7
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

P3569: !_ST [8] (maybe <- 0x180016f) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3570: !_DWST [11] (maybe <- 0x4100001a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P3571: !_ST [12] (maybe <- 0x1800170) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3572: !_LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3573: !_LD [1] (Int)
lduw [%i0 + 4], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3574: !_DWST [13] (maybe <- 0x1800171) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P3575: !_CASX [7] (maybe <- 0x1800172) (Int)
add %i1, 80, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l7
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3576: !_ST [6] (maybe <- 0x4100001b) (FP) (Branch target of P3440)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]
ba P3577
nop

TARGET3440:
ba RET3440
nop


P3577: !_ST [3] (maybe <- 0x1800174) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3578: !_ST [13] (maybe <- 0x4100001c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P3579: !_DWLD [0] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3580: !_DWST [11] (maybe <- 0x1800175) (Int) (Branch target of P3506)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P3581
nop

TARGET3506:
ba RET3506
nop


P3581: !_ST [13] (maybe <- 0x1800176) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3582: !_DWST [11] (maybe <- 0x1800177) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P3583: !_DWST [2] (maybe <- 0x4100001d) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P3584: !_DWST [13] (maybe <- 0x1800178) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3585: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3586: !_ST [15] (maybe <- 0x1800179) (Int) (Branch target of P3595)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P3587
nop

TARGET3595:
ba RET3595
nop


P3587: !_ST [11] (maybe <- 0x180017a) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3588: !_DWST [3] (maybe <- 0x180017b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P3589: !_DWST [13] (maybe <- 0x180017c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3590: !_SWAP [0] (maybe <- 0x180017d) (Int)
mov %l4, %o3
swap  [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3591: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3592: !_ST [14] (maybe <- 0x180017e) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3593: !_ST [10] (maybe <- 0x180017f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3594: !_ST [11] (maybe <- 0x1800180) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3595: !_ST [6] (maybe <- 0x1800181) (Int) (CBR) (Branch target of P3619)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3595
nop
RET3595:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P3596
nop

TARGET3619:
ba RET3619
nop


P3596: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3597: !_ST [1] (maybe <- 0x1800182) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3598: !_ST [9] (maybe <- 0x1800183) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3599: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3600: !_ST [11] (maybe <- 0x1800184) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3601: !_LD [3] (FP)
ld [%i0 + 32], %f7
! 1 addresses covered

P3602: !_ST [9] (maybe <- 0x1800185) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3603: !_ST [4] (maybe <- 0x1800186) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3604: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3605: !_DWST [4] (maybe <- 0x4100001e) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3605
nop
RET3605:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3606: !_ST [4] (maybe <- 0x1800187) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3607: !_ST [1] (maybe <- 0x1800188) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3608: !_ST [11] (maybe <- 0x1800189) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3609: !_ST [14] (maybe <- 0x180018a) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3610: !_LD [11] (Int)
lduw [%i2 + 64], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P3611: !_ST [0] (maybe <- 0x180018b) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3612: !_REPLACEMENT [11] (Int)
sethi %hi(0x40), %l7
or %l7, %lo(0x40),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3613: !_ST [8] (maybe <- 0x180018c) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3614: !_ST [14] (maybe <- 0x180018d) (Int) (CBR) (Branch target of P3883)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3614
nop
RET3614:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P3615
nop

TARGET3883:
ba RET3883
nop


P3615: !_ST [9] (maybe <- 0x180018e) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3616: !_DWST [0] (maybe <- 0x180018f) (Int) (Branch target of P3879)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4
ba P3617
nop

TARGET3879:
ba RET3879
nop


P3617: !_ST [14] (maybe <- 0x1800191) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3618: !_ST [1] (maybe <- 0x1800192) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3619: !_ST [1] (maybe <- 0x1800193) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3619
nop
RET3619:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3620: !_DWST [0] (maybe <- 0x1800194) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3621: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %o5
or %o5, %lo(0x4),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3622: !_DWST [15] (maybe <- 0x1800196) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P3623: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3624: !_ST [5] (maybe <- 0x1800197) (Int) (Branch target of P3330)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P3625
nop

TARGET3330:
ba RET3330
nop


P3625: !_ST [5] (maybe <- 0x1800198) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3626: !_DWST [6] (maybe <- 0x1800199) (Int) (CBR) (Branch target of P3101)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3626
nop
RET3626:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P3627
nop

TARGET3101:
ba RET3101
nop


P3627: !_CAS [5] (maybe <- 0x180019b) (Int)
add %i1, 76, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P3628: !_ST [10] (maybe <- 0x4100001f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P3629: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3630: !_DWST [1] (maybe <- 0x180019c) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3631: !_CASX [6] (maybe <- 0x180019e) (Int)
add %i1, 80, %l6
ldx [%l6], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l3
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
casx [%l6], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3632: !_ST [7] (maybe <- 0x41000020) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P3633: !_DWST [13] (maybe <- 0x18001a0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P3634: !_DWST [11] (maybe <- 0x18001a1) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P3635: !_ST [12] (maybe <- 0x18001a2) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3636: !_DWST [2] (maybe <- 0x18001a3) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P3637: !_ST [7] (maybe <- 0x18001a4) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3638: !_ST [15] (maybe <- 0x18001a5) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3639: !_LD [4] (FP)
ld [%i0 + 64], %f8
! 1 addresses covered

P3640: !_ST [7] (maybe <- 0x18001a6) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3641: !_CASX [13] (maybe <- 0x18001a7) (Int)
add %i3, 64, %l6
ldx [%l6], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %l3
sllx %l4, 32, %o3
casx [%l6], %l3, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P3642: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3643: !_ST [8] (maybe <- 0x18001a8) (Int) (Branch target of P3124)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P3644
nop

TARGET3124:
ba RET3124
nop


P3644: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %o5
or %o5, %lo(0x50),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3645: !_DWST [3] (maybe <- 0x41000021) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P3646: !_ST [11] (maybe <- 0x18001a9) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3647: !_LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3648: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3649: !_CAS [15] (maybe <- 0x18001aa) (Int)
add %i3, 192, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%o5], %l7, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3650: !_SWAP [5] (maybe <- 0x18001ab) (Int)
mov %l4, %l3
swap  [%i1 + 76], %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3651: !_ST [11] (maybe <- 0x18001ac) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3652: !_ST [15] (maybe <- 0x18001ad) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3653: !_DWST [4] (maybe <- 0x18001ae) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l6
srl %l6, 8, %l6
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3
srl %l3, 16, %l6
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l6, %l3
stxa %l3, [%i0 + 64 ] %asi
add   %l4, 1, %l4

P3654: !_ST [9] (maybe <- 0x18001af) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3654
nop
RET3654:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3655: !_ST [14] (maybe <- 0x18001b0) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3656: !_ST [15] (maybe <- 0x18001b1) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3656
nop
RET3656:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3657: !_SWAP [7] (maybe <- 0x18001b2) (Int) (LE)
wr %g0, 0x88, %asi
mov %l4, %o1
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %o1, %l6, %l7
srl %l7, 8, %l7
sll %o1, 8, %o1
and %o1, %l6, %o1
or %o1, %l7, %o1
srl %o1, 16, %l7
sll %o1, 16, %o1
srl %o1, 0, %o1
or %o1, %l7, %o1
swapa  [%i1 + 84] %asi, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3658: !_DWST [15] (maybe <- 0x18001b3) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P3659: !_DWST [4] (maybe <- 0x18001b4) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P3660: !_CASX [8] (maybe <- 0x18001b5) (Int)
add %i1, 256, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %o5
or %o5, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
add  %l4, 1, %l4

P3661: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3662: !_DWST [15] (maybe <- 0x18001b6) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3663: !_ST [1] (maybe <- 0x18001b7) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3664: !_DWST [0] (maybe <- 0x18001b8) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3665: !_ST [0] (maybe <- 0x18001ba) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3666: !_LD [6] (Int)
lduw [%i1 + 80], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P3667: !_ST [11] (maybe <- 0x18001bb) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3668: !_CASX [5] (maybe <- 0x18001bc) (Int)
add %i1, 72, %o5
ldx [%o5], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l7
mov %l4, %o0
casx [%o5], %l7, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P3669: !_ST [8] (maybe <- 0x18001bd) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3670: !_ST [10] (maybe <- 0x18001be) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3671: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3672: !_DWST [12] (maybe <- 0x18001bf) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P3673: !_DWST [4] (maybe <- 0x18001c0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P3674: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l7
or %l7, %lo(0x50),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3675: !_ST [10] (maybe <- 0x18001c1) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3675
nop
RET3675:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3676: !_ST [14] (maybe <- 0x18001c2) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3677: !_DWST [5] (maybe <- 0x18001c3) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P3678: !_ST [0] (maybe <- 0x18001c4) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3679: !_DWST [5] (maybe <- 0x18001c5) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P3680: !_ST [9] (maybe <- 0x18001c6) (Int) (Branch target of P3381)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P3681
nop

TARGET3381:
ba RET3381
nop


P3681: !_ST [3] (maybe <- 0x18001c7) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3682: !_DWST [4] (maybe <- 0x18001c8) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3682
nop
RET3682:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3683: !_ST [7] (maybe <- 0x18001c9) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3684: !_DWST [5] (maybe <- 0x18001ca) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P3685: !_DWST [10] (maybe <- 0x18001cb) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P3686: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3687: !_LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3688: !_DWST [4] (maybe <- 0x18001cc) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P3689: !_DWLD [14] (Int)
ldx [%i3 + 128], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l6
or %l6, %o1, %o1

P3690: !_DWST [1] (maybe <- 0x18001cd) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3691: !_DWST [7] (maybe <- 0x41000022) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P3692: !_ST [15] (maybe <- 0x18001cf) (Int) (Branch target of P3800)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P3693
nop

TARGET3800:
ba RET3800
nop


P3693: !_LD [4] (Int) (CBR)
lduw [%i0 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3693
nop
RET3693:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3694: !_DWST [11] (maybe <- 0x18001d0) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P3695: !_ST [5] (maybe <- 0x18001d1) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3696: !_ST [3] (maybe <- 0x18001d2) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3697: !_ST [7] (maybe <- 0x41000024) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P3698: !_ST [0] (maybe <- 0x18001d3) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3699: !_ST [12] (maybe <- 0x18001d4) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3700: !_CASX [9] (maybe <- 0x18001d5) (Int) (Branch target of P3898)
add %i1, 512, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %l6
or %l6, %o2, %o2
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l7
or %l7, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
add  %l4, 1, %l4
ba P3701
nop

TARGET3898:
ba RET3898
nop


P3701: !_DWLD [13] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i3 + 64] %asi, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3702: !_ST [8] (maybe <- 0x18001d6) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3703: !_CAS [14] (maybe <- 0x18001d7) (Int) (CBR)
add %i3, 128, %o5
lduw [%o5], %o0
mov %o0, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3703
nop
RET3703:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3704: !_ST [13] (maybe <- 0x41000025) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P3705: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3706: !_ST [3] (maybe <- 0x18001d8) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3707: !_ST [6] (maybe <- 0x41000026) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P3708: !_CAS [0] (maybe <- 0x18001d9) (Int)
add %i0, 0, %l6
lduw [%l6], %o1
mov %o1, %l3
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P3709: !_DWST [6] (maybe <- 0x18001da) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P3710: !_ST [12] (maybe <- 0x18001dc) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3711: !_ST [8] (maybe <- 0x18001dd) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3712: !_ST [5] (maybe <- 0x41000027) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P3713: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3714: !_DWST [5] (maybe <- 0x18001de) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P3715: !_DWST [6] (maybe <- 0x18001df) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P3716: !_DWST [14] (maybe <- 0x18001e1) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P3717: !_ST [4] (maybe <- 0x18001e2) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3718: !_ST [8] (maybe <- 0x18001e3) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3719: !_ST [0] (maybe <- 0x18001e4) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3720: !_CAS [10] (maybe <- 0x18001e5) (Int)
add %i2, 32, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P3721: !_ST [9] (maybe <- 0x18001e6) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3722: !_DWST [11] (maybe <- 0x41000028) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P3723: !_ST [8] (maybe <- 0x18001e7) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3724: !_DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P3725: !_ST [1] (maybe <- 0x18001e8) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3726: !_DWST [7] (maybe <- 0x18001e9) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P3727: !_CASX [10] (maybe <- 0x18001eb) (Int)
add %i2, 32, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l7, 32, %o5
or %o5, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o4(lower)
srlx %l7, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
add  %l4, 1, %l4

P3728: !_REPLACEMENT [8] (Int) (CBR)
sethi %hi(0x100), %o5
or %o5, %lo(0x100),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3728
nop
RET3728:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3729: !_ST [15] (maybe <- 0x18001ec) (Int) (CBR) (Branch target of P3901)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3729
nop
RET3729:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P3730
nop

TARGET3901:
ba RET3901
nop


P3730: !_ST [7] (maybe <- 0x18001ed) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3731: !_LD [3] (Int)
lduw [%i0 + 32], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P3732: !_SWAP [1] (maybe <- 0x18001ee) (Int)
mov %l4, %o1
swap  [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3733: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3734: !_ST [9] (maybe <- 0x18001ef) (Int) (CBR)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3734
nop
RET3734:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3735: !_DWST [6] (maybe <- 0x18001f0) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P3736: !_MEMBAR (Int)
membar #StoreLoad

P3737: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P3738: !_ST [5] (maybe <- 0x41000029) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P3739: !_DWST [10] (maybe <- 0x18001f2) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P3740: !_CAS [4] (maybe <- 0x18001f3) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
wr %g0, 0x88, %asi
add %i0, 64, %l3
lduwa [%l3] %asi, %l7
mov %l7, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1
mov %l6, %o2
casa [%l3] %asi, %o5, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3741: !_ST [9] (maybe <- 0x18001f4) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3742: !_ST [13] (maybe <- 0x18001f5) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3743: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3744: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3744
nop
RET3744:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3745: !_ST [10] (maybe <- 0x18001f6) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3746: !_DWST [0] (maybe <- 0x18001f7) (Int) (Branch target of P3548)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4
ba P3747
nop

TARGET3548:
ba RET3548
nop


P3747: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3748: !_ST [8] (maybe <- 0x18001f9) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3748
nop
RET3748:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3749: !_DWST [4] (maybe <- 0x18001fa) (Int) (Branch target of P3494)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P3750
nop

TARGET3494:
ba RET3494
nop


P3750: !_ST [2] (maybe <- 0x18001fb) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3751: !_ST [6] (maybe <- 0x18001fc) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3752: !_DWST [9] (maybe <- 0x4100002a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P3753: !_ST [11] (maybe <- 0x18001fd) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3754: !_ST [1] (maybe <- 0x18001fe) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3755: !_ST [11] (maybe <- 0x18001ff) (Int) (CBR)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3755
nop
RET3755:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3756: !_ST [14] (maybe <- 0x1800200) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3757: !_ST [5] (maybe <- 0x1800201) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3758: !_DWST [15] (maybe <- 0x1800202) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P3759: !_ST [13] (maybe <- 0x1800203) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3760: !_DWST [2] (maybe <- 0x1800204) (Int) (Branch target of P4111)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4
ba P3761
nop

TARGET4111:
ba RET4111
nop


P3761: !_ST [2] (maybe <- 0x4100002b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P3762: !_DWST [9] (maybe <- 0x1800205) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P3763: !_ST [15] (maybe <- 0x4100002c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P3764: !_DWST [4] (maybe <- 0x1800206) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P3765: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3766: !_CAS [13] (maybe <- 0x1800207) (Int)
add %i3, 64, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l4, %o3
cas [%l6], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3767: !_ST [5] (maybe <- 0x1800208) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3767
nop
RET3767:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3768: !_LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P3769: !_ST [3] (maybe <- 0x1800209) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3770: !_ST [10] (maybe <- 0x180020a) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3771: !_ST [15] (maybe <- 0x4100002d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P3772: !_CASX [5] (maybe <- 0x180020b) (Int)
add %i1, 72, %l3
ldx [%l3], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %o5
mov %l4, %o0
casx [%l3], %o5, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P3773: !_ST [7] (maybe <- 0x180020c) (Int) (Branch target of P3155)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P3774
nop

TARGET3155:
ba RET3155
nop


P3774: !_DWST [14] (maybe <- 0x180020d) (Int) (Branch target of P3335)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4
ba P3775
nop

TARGET3335:
ba RET3335
nop


P3775: !_ST [15] (maybe <- 0x180020e) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3776: !_DWST [12] (maybe <- 0x180020f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P3777: !_LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3778: !_DWLD [4] (Int)
ldx [%i0 + 64], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l6
or %l6, %o1, %o1

P3779: !_ST [8] (maybe <- 0x1800210) (Int) (Branch target of P3922)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P3780
nop

TARGET3922:
ba RET3922
nop


P3780: !_ST [8] (maybe <- 0x1800211) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3781: !_ST [12] (maybe <- 0x4100002e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P3782: !_ST [3] (maybe <- 0x1800212) (Int) (Branch target of P3470)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4
ba P3783
nop

TARGET3470:
ba RET3470
nop


P3783: !_ST [1] (maybe <- 0x1800213) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3784: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3785: !_ST [10] (maybe <- 0x1800214) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3786: !_DWST [9] (maybe <- 0x1800215) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3787: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3788: !_DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3789: !_ST [11] (maybe <- 0x1800216) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3790: !_ST [3] (maybe <- 0x1800217) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3790
nop
RET3790:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3791: !_ST [15] (maybe <- 0x4100002f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P3792: !_DWST [4] (maybe <- 0x1800218) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P3793: !_ST [11] (maybe <- 0x41000030) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3793
nop
RET3793:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3794: !_DWST [15] (maybe <- 0x41000031) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P3795: !_REPLACEMENT [14] (Int) (Branch target of P3958)
sethi %hi(0x80), %l7
or %l7, %lo(0x80),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
ba P3796
nop

TARGET3958:
ba RET3958
nop


P3796: !_ST [3] (maybe <- 0x1800219) (Int) (Branch target of P3160)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4
ba P3797
nop

TARGET3160:
ba RET3160
nop


P3797: !_ST [9] (maybe <- 0x180021a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3798: !_LD [10] (Int)
lduw [%i2 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3799: !_DWST [4] (maybe <- 0x180021b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3800: !_DWLD [0] (Int) (CBR)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3800
nop
RET3800:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3801: !_LD [8] (Int)
lduw [%i1 + 256], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3802: !_ST [1] (maybe <- 0x180021c) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3803: !_DWST [1] (maybe <- 0x180021d) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3804: !_ST [11] (maybe <- 0x180021f) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3805: !_ST [6] (maybe <- 0x41000032) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P3806: !_ST [15] (maybe <- 0x41000033) (FP) (Branch target of P4000)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]
ba P3807
nop

TARGET4000:
ba RET4000
nop


P3807: !_SWAP [9] (maybe <- 0x1800220) (Int)
mov %l4, %o0
swap  [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P3808: !_ST [11] (maybe <- 0x1800221) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3809: !_DWST [15] (maybe <- 0x1800222) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3809
nop
RET3809:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3810: !_ST [7] (maybe <- 0x1800223) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3811: !_DWST [0] (maybe <- 0x1800224) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3812: !_DWST [5] (maybe <- 0x1800226) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P3813: !_ST [0] (maybe <- 0x41000034) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P3814: !_DWST [10] (maybe <- 0x1800227) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P3815: !_ST [0] (maybe <- 0x1800228) (Int) (Branch target of P3614)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P3816
nop

TARGET3614:
ba RET3614
nop


P3816: !_ST [14] (maybe <- 0x1800229) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3817: !_CASX [3] (maybe <- 0x180022a) (Int)
add %i0, 32, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

P3818: !_DWST [2] (maybe <- 0x180022b) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P3819: !_DWST [11] (maybe <- 0x180022c) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P3820: !_ST [9] (maybe <- 0x180022d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3821: !_ST [5] (maybe <- 0x180022e) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3822: !_ST [12] (maybe <- 0x180022f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3823: !_DWST [2] (maybe <- 0x1800230) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P3824: !_ST [4] (maybe <- 0x1800231) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3825: !_DWST [12] (maybe <- 0x1800232) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P3826: !_PREFETCH [0] (Int) (CBR)
prefetch [%i0 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3826
nop
RET3826:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3827: !_DWST [9] (maybe <- 0x41000035) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P3828: !_ST [9] (maybe <- 0x1800233) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3829: !_DWST [0] (maybe <- 0x1800234) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3830: !_LD [2] (Int)
lduw [%i0 + 12], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P3831: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3832: !_LD [0] (Int) (CBR)
lduw [%i0 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3832
nop
RET3832:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3833: !_DWST [5] (maybe <- 0x1800236) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P3834: !_ST [7] (maybe <- 0x1800237) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3835: !_DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3

P3836: !_ST [15] (maybe <- 0x1800238) (Int) (Branch target of P3703)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P3837
nop

TARGET3703:
ba RET3703
nop


P3837: !_ST [11] (maybe <- 0x41000036) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P3838: !_DWST [1] (maybe <- 0x41000037) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3838
nop
RET3838:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3839: !_ST [14] (maybe <- 0x41000039) (FP) (Branch target of P3361)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]
ba P3840
nop

TARGET3361:
ba RET3361
nop


P3840: !_CAS [11] (maybe <- 0x1800239) (Int) (Branch target of P3285)
add %i2, 64, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4
ba P3841
nop

TARGET3285:
ba RET3285
nop


P3841: !_ST [4] (maybe <- 0x180023a) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3842: !_DWST [12] (maybe <- 0x180023b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P3843: !_CAS [10] (maybe <- 0x180023c) (Int)
add %i2, 32, %l7
lduw [%l7], %o0
mov %o0, %l6
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P3844: !_ST [6] (maybe <- 0x180023d) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3845: !_ST [15] (maybe <- 0x180023e) (Int) (Branch target of P4105)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P3846
nop

TARGET4105:
ba RET4105
nop


P3846: !_ST [10] (maybe <- 0x180023f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3847: !_DWST [13] (maybe <- 0x1800240) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P3848: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3849: !_ST [7] (maybe <- 0x1800241) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3850: !_CASX [3] (maybe <- 0x1800242) (Int)
add %i0, 32, %l6
ldx [%l6], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l3
sllx %l4, 32, %o2
casx [%l6], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P3851: !_ST [5] (maybe <- 0x4100003a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P3852: !_LD [2] (Int) (CBR)
lduw [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3852
nop
RET3852:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3853: !_ST [12] (maybe <- 0x1800243) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3854: !_DWST [15] (maybe <- 0x1800244) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P3855: !_CASX [6] (maybe <- 0x1800245) (Int)
add %i1, 80, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l3
or %l3, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
add  %l4, 1, %l4

P3856: !_ST [11] (maybe <- 0x1800247) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3857: !_ST [1] (maybe <- 0x4100003b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P3858: !_ST [12] (maybe <- 0x1800248) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3859: !_ST [15] (maybe <- 0x1800249) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3860: !_ST [6] (maybe <- 0x180024a) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3861: !_ST [1] (maybe <- 0x180024b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3862: !_ST [15] (maybe <- 0x180024c) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3863: !_ST [3] (maybe <- 0x180024d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P3864: !_DWST [1] (maybe <- 0x180024e) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3865: !_DWST [3] (maybe <- 0x1800250) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P3866: !_ST [2] (maybe <- 0x1800251) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3867: !_DWST [13] (maybe <- 0x1800252) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3868: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l3
or %l3, %lo(0xc),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3869: !_DWLD [10] (FP)
ldd [%i2 + 32], %f18
! 1 addresses covered
fmovs %f18, %f9

P3870: !_ST [12] (maybe <- 0x1800253) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i3 + 0] %asi
add   %l4, 1, %l4

P3871: !_ST [13] (maybe <- 0x1800254) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3872: !_DWST [6] (maybe <- 0x1800255) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P3873: !_CASX [1] (maybe <- 0x1800257) (Int) (Branch target of P3982)
add %i0, 0, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l3
or %l3, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l6
or %l6, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
add  %l4, 1, %l4
ba P3874
nop

TARGET3982:
ba RET3982
nop


P3874: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3875: !_ST [12] (maybe <- 0x1800259) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i3 + 0] %asi
add   %l4, 1, %l4

P3876: !_DWST [15] (maybe <- 0x180025a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P3877: !_ST [6] (maybe <- 0x4100003c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P3878: !_ST [11] (maybe <- 0x180025b) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3879: !_ST [14] (maybe <- 0x180025c) (Int) (CBR)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3879
nop
RET3879:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3880: !_DWST [2] (maybe <- 0x180025d) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P3881: !_DWLD [4] (Int)
ldx [%i0 + 64], %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %o5
or %o5, %o2, %o2

P3882: !_DWST [3] (maybe <- 0x180025e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P3883: !_ST [13] (maybe <- 0x180025f) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3883
nop
RET3883:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3884: !_REPLACEMENT [0] (Int) (Branch target of P3446)
sethi %hi(0x0), %l3
or %l3, %lo(0x0),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
ba P3885
nop

TARGET3446:
ba RET3446
nop


P3885: !_DWST [9] (maybe <- 0x1800260) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P3886: !_ST [13] (maybe <- 0x1800261) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3887: !_DWST [14] (maybe <- 0x4100003d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P3888: !_PREFETCH [10] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 32] %asi, 1

P3889: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l3
or %l3, %lo(0x200),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3890: !_ST [10] (maybe <- 0x1800262) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3891: !_CASX [7] (maybe <- 0x1800263) (Int)
add %i1, 80, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %l7
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P3892: !_ST [5] (maybe <- 0x1800265) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3893: !_ST [15] (maybe <- 0x1800266) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3894: !_DWST [11] (maybe <- 0x1800267) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l7
srl %l7, 8, %l7
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %l7, %l6
srl %l6, 16, %l7
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l7, %l6
stxa %l6, [%i2 + 64 ] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3894
nop
RET3894:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3895: !_CASX [14] (maybe <- 0x1800268) (Int) (Branch target of P3353)
add %i3, 128, %l6
ldx [%l6], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l3
sllx %l4, 32, %o1
casx [%l6], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4
ba P3896
nop

TARGET3353:
ba RET3353
nop


P3896: !_NOP (Int)
nop

P3897: !_PREFETCH [13] (Int) (CBR)
prefetch [%i3 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3897
nop
RET3897:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3898: !_PREFETCH [2] (Int) (CBR)
prefetch [%i0 + 12], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3898
nop
RET3898:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3899: !_DWST [3] (maybe <- 0x1800269) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P3900: !_DWST [4] (maybe <- 0x4100003e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P3901: !_PREFETCH [13] (Int) (CBR)
prefetch [%i3 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3901
nop
RET3901:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3902: !_DWST [12] (maybe <- 0x4100003f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P3903: !_DWST [1] (maybe <- 0x180026a) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P3904: !_ST [8] (maybe <- 0x180026c) (Int) (CBR)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3904
nop
RET3904:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3905: !_DWST [11] (maybe <- 0x180026d) (Int) (Branch target of P4073)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P3906
nop

TARGET4073:
ba RET4073
nop


P3906: !_ST [8] (maybe <- 0x180026e) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3907: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3908: !_CAS [8] (maybe <- 0x180026f) (Int)
add %i1, 256, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P3909: !_ST [9] (maybe <- 0x1800270) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3910: !_DWLD [13] (Int)
ldx [%i3 + 64], %o3
! move %o3(upper) -> %o3(upper)

P3911: !_DWST [9] (maybe <- 0x1800271) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P3912: !_DWST [0] (maybe <- 0x1800272) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3913: !_DWST [14] (maybe <- 0x1800274) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3913
nop
RET3913:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3914: !_DWST [3] (maybe <- 0x1800275) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P3915: !_ST [1] (maybe <- 0x1800276) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3916: !_DWST [14] (maybe <- 0x1800277) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P3917: !_ST [8] (maybe <- 0x1800278) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3918: !_DWST [11] (maybe <- 0x1800279) (Int) (Branch target of P3793)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P3919
nop

TARGET3793:
ba RET3793
nop


P3919: !_DWST [0] (maybe <- 0x41000040) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P3920: !_DWST [13] (maybe <- 0x180027a) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P3921: !_ST [5] (maybe <- 0x180027b) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3922: !_ST [11] (maybe <- 0x41000042) (FP) (CBR) (Branch target of P3553)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3922
nop
RET3922:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P3923
nop

TARGET3553:
ba RET3553
nop


P3923: !_ST [11] (maybe <- 0x180027c) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3924: !_ST [3] (maybe <- 0x41000043) (FP) (Branch target of P3451)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]
ba P3925
nop

TARGET3451:
ba RET3451
nop


P3925: !_ST [0] (maybe <- 0x180027d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3926: !_DWST [6] (maybe <- 0x180027e) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P3927: !_DWST [13] (maybe <- 0x1800280) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P3928: !_ST [9] (maybe <- 0x41000044) (FP) (Branch target of P3826)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]
ba P3929
nop

TARGET3826:
ba RET3826
nop


P3929: !_CAS [8] (maybe <- 0x1800281) (Int)
add %i1, 256, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l7, %o3, %o3
mov %l4, %o4
cas [%o5], %l7, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3930: !_ST [4] (maybe <- 0x1800282) (Int) (CBR)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3930
nop
RET3930:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3931: !_LD [4] (Int)
lduw [%i0 + 64], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3932: !_DWST [12] (maybe <- 0x1800283) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P3933: !_ST [13] (maybe <- 0x1800284) (Int) (Branch target of P4029)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P3934
nop

TARGET4029:
ba RET4029
nop


P3934: !_DWST [7] (maybe <- 0x1800285) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P3935: !_ST [6] (maybe <- 0x1800287) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3935
nop
RET3935:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3936: !_ST [1] (maybe <- 0x1800288) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3937: !_DWST [7] (maybe <- 0x1800289) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P3938: !_ST [1] (maybe <- 0x180028b) (Int) (Branch target of P3809)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P3939
nop

TARGET3809:
ba RET3809
nop


P3939: !_ST [0] (maybe <- 0x180028c) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3940: !_ST [14] (maybe <- 0x180028d) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i3 + 128] %asi
add   %l4, 1, %l4

P3941: !_DWST [10] (maybe <- 0x180028e) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P3942: !_DWST [4] (maybe <- 0x180028f) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P3943: !_ST [1] (maybe <- 0x1800290) (Int) (Branch target of P3728)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P3944
nop

TARGET3728:
ba RET3728
nop


P3944: !_ST [15] (maybe <- 0x1800291) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3945: !_DWLD [10] (FP)
ldd [%i2 + 32], %f10
! 1 addresses covered

P3946: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3947: !_DWST [7] (maybe <- 0x1800292) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P3948: !_ST [7] (maybe <- 0x1800294) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3949: !_DWST [13] (maybe <- 0x41000045) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 64]

P3950: !_DWLD [6] (FP)
ldd [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f11
fmovs %f19, %f12

P3951: !_ST [13] (maybe <- 0x41000046) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P3952: !_ST [15] (maybe <- 0x41000047) (FP) (Branch target of P3423)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]
ba P3953
nop

TARGET3423:
ba RET3423
nop


P3953: !_DWST [5] (maybe <- 0x1800295) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P3954: !_DWST [9] (maybe <- 0x1800296) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P3955: !_DWST [13] (maybe <- 0x1800297) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P3956: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3957: !_ST [6] (maybe <- 0x41000048) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P3958: !_DWST [15] (maybe <- 0x1800298) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l6
srl %l6, 8, %l6
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3
srl %l3, 16, %l6
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l6, %l3
stxa %l3, [%i3 + 192 ] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3958
nop
RET3958:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3959: !_CASX [1] (maybe <- 0x1800299) (Int)
add %i0, 0, %l3
ldx [%l3], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %o5
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
casx [%l3], %o5, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3960: !_CAS [10] (maybe <- 0x180029b) (Int)
add %i2, 32, %l3
lduw [%l3], %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4

P3961: !_CAS [15] (maybe <- 0x180029c) (Int) (CBR)
add %i3, 192, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3961
nop
RET3961:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3962: !_DWST [0] (maybe <- 0x41000049) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P3963: !_ST [2] (maybe <- 0x180029d) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3963
nop
RET3963:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3964: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3965: !_DWST [13] (maybe <- 0x180029e) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P3966: !_ST [10] (maybe <- 0x180029f) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3967: !_ST [7] (maybe <- 0x18002a0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3968: !_DWST [6] (maybe <- 0x18002a1) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P3969: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P3970: !_ST [5] (maybe <- 0x18002a3) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3971: !_CASX [12] (maybe <- 0x18002a4) (Int)
add %i3, 0, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l6
sllx %l4, 32, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P3972: !_PREFETCH [11] (Int) (Branch target of P3106)
prefetch [%i2 + 64], 1
ba P3973
nop

TARGET3106:
ba RET3106
nop


P3973: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P3974: !_DWST [12] (maybe <- 0x18002a5) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P3975: !_ST [8] (maybe <- 0x4100004b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

P3976: !_CASX [14] (maybe <- 0x18002a6) (Int)
add %i3, 128, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l7
sllx %l4, 32, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P3977: !_ST [9] (maybe <- 0x18002a7) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3978: !_ST [13] (maybe <- 0x18002a8) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3979: !_LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3980: !_DWLD [15] (Int)
ldx [%i3 + 192], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l7
or %l7, %o3, %o3

P3981: !_ST [8] (maybe <- 0x18002a9) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3982: !_SWAP [0] (maybe <- 0x18002aa) (Int) (CBR)
mov %l4, %o4
swap  [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3982
nop
RET3982:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3983: !_ST [5] (maybe <- 0x18002ab) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 76] %asi
add   %l4, 1, %l4

P3984: !_DWST [3] (maybe <- 0x18002ac) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P3985: !_ST [9] (maybe <- 0x18002ad) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3986: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P3987: !_ST [12] (maybe <- 0x18002ae) (Int) (Branch target of P3501)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P3988
nop

TARGET3501:
ba RET3501
nop


P3988: !_ST [8] (maybe <- 0x18002af) (Int) (Branch target of P3894)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P3989
nop

TARGET3894:
ba RET3894
nop


P3989: !_DWLD [0] (Int)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o4(lower)
srlx %l7, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0

P3990: !_DWST [2] (maybe <- 0x18002b0) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P3991: !_DWST [12] (maybe <- 0x4100004c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P3992: !_ST [8] (maybe <- 0x18002b1) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3993: !_ST [14] (maybe <- 0x18002b2) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3994: !_CAS [12] (maybe <- 0x18002b3) (Int)
add %i3, 0, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3995: !_DWST [2] (maybe <- 0x18002b4) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P3996: !_DWST [8] (maybe <- 0x18002b5) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

P3997: !_DWST [2] (maybe <- 0x18002b6) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P3998: !_ST [5] (maybe <- 0x18002b7) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3999: !_LD [15] (Int)
lduw [%i3 + 192], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P4000: !_ST [13] (maybe <- 0x4100004d) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4000
nop
RET4000:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4001: !_ST [1] (maybe <- 0x18002b8) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4002: !_ST [7] (maybe <- 0x18002b9) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4003: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4004: !_SWAP [11] (maybe <- 0x18002ba) (Int)
mov %l4, %o2
swap  [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4005: !_ST [0] (maybe <- 0x18002bb) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4006: !_ST [3] (maybe <- 0x18002bc) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 32] %asi
add   %l4, 1, %l4

P4007: !_ST [12] (maybe <- 0x18002bd) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4008: !_DWST [12] (maybe <- 0x18002be) (Int) (Branch target of P3444)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4
ba P4009
nop

TARGET3444:
ba RET3444
nop


P4009: !_DWST [5] (maybe <- 0x18002bf) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
sllx %o5, 32, %o5 
stxa %o5, [%i1 + 72 ] %asi
add   %l4, 1, %l4

P4010: !_ST [13] (maybe <- 0x18002c0) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4011: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4012: !_ST [12] (maybe <- 0x18002c1) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4013: !_DWST [9] (maybe <- 0x18002c2) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P4014: !_DWST [6] (maybe <- 0x18002c3) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P4015: !_DWLD [6] (FP)
ldd [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f13
fmovs %f19, %f14

P4016: !_ST [5] (maybe <- 0x18002c5) (Int) (Branch target of P3913)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P4017
nop

TARGET3913:
ba RET3913
nop


P4017: !_LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4018: !_ST [5] (maybe <- 0x4100004e) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P4019: !_ST [12] (maybe <- 0x18002c6) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i3 + 0] %asi
add   %l4, 1, %l4

P4020: !_DWST [0] (maybe <- 0x18002c7) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P4021: !_ST [3] (maybe <- 0x18002c9) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4021
nop
RET4021:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4022: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4023: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4024: !_ST [12] (maybe <- 0x18002ca) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4025: !_DWLD [11] (Int)
ldx [%i2 + 64], %o3
! move %o3(upper) -> %o3(upper)

P4026: !_ST [5] (maybe <- 0x18002cb) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4027: !_DWST [0] (maybe <- 0x18002cc) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4028: !_DWST [10] (maybe <- 0x18002ce) (Int) (Branch target of P3656)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4
ba P4029
nop

TARGET3656:
ba RET3656
nop


P4029: !_ST [11] (maybe <- 0x18002cf) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i2 + 64] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4029
nop
RET4029:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4030: !_ST [1] (maybe <- 0x18002d0) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4031: !_ST [9] (maybe <- 0x18002d1) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4032: !_LD [9] (Int)
lduw [%i1 + 512], %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l3, %o3, %o3

P4033: !_DWST [0] (maybe <- 0x18002d2) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P4034: !_ST [11] (maybe <- 0x18002d4) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4035: !_DWST [8] (maybe <- 0x18002d5) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P4036: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l7
or %l7, %lo(0x4),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4037: !_NOP (Int)
nop

P4038: !_ST [5] (maybe <- 0x18002d6) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4039: !_DWST [15] (maybe <- 0x18002d7) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P4040: !_DWLD [13] (FP)
ldd [%i3 + 64], %f18
! 1 addresses covered
fmovs %f18, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P4041: !_DWST [0] (maybe <- 0x18002d8) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4042: !_ST [15] (maybe <- 0x4100004f) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4042
nop
RET4042:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4043: !_ST [9] (maybe <- 0x18002da) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4044: !_ST [1] (maybe <- 0x18002db) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 4] %asi
add   %l4, 1, %l4

P4045: !_DWST [14] (maybe <- 0x18002dc) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4045
nop
RET4045:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4046: !_CASX [3] (maybe <- 0x18002dd) (Int)
add %i0, 32, %l6
ldx [%l6], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l3
sllx %l4, 32, %o0
casx [%l6], %l3, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P4047: !_LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4048: !_DWST [8] (maybe <- 0x18002de) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

P4049: !_ST [13] (maybe <- 0x18002df) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4050: !_ST [4] (maybe <- 0x41000050) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 64 ]

P4051: !_ST [10] (maybe <- 0x18002e0) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4052: !_ST [14] (maybe <- 0x18002e1) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4053: !_DWST [3] (maybe <- 0x18002e2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4054: !_ST [0] (maybe <- 0x41000051) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P4055: !_DWST [8] (maybe <- 0x18002e3) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P4056: !_ST [4] (maybe <- 0x18002e4) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4057: !_DWST [1] (maybe <- 0x18002e5) (Int) (Branch target of P3411)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4
ba P4058
nop

TARGET3411:
ba RET3411
nop


P4058: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4059: !_REPLACEMENT [13] (Int) (CBR)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4059
nop
RET4059:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4060: !_ST [15] (maybe <- 0x18002e7) (Int) (Branch target of P3394)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P4061
nop

TARGET3394:
ba RET3394
nop


P4061: !_CASX [2] (maybe <- 0x18002e8) (Int)
add %i0, 8, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov  %l7, %o5
mov %l4, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
add  %l4, 1, %l4

P4062: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4063: !_CASX [4] (maybe <- 0x18002e9) (Int)
add %i0, 64, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %o5
or %o5, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o4(lower)
srlx %l7, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
add  %l4, 1, %l4

P4064: !_ST [9] (maybe <- 0x18002ea) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4065: !_ST [14] (maybe <- 0x18002eb) (Int) (Branch target of P3545)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P4066
nop

TARGET3545:
ba RET3545
nop


P4066: !_ST [0] (maybe <- 0x18002ec) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4066
nop
RET4066:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4067: !_DWST [6] (maybe <- 0x18002ed) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P4068: !_DWST [6] (maybe <- 0x18002ef) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P4069: !_DWLD [1] (FP)
ldd [%i0 + 0], %f0
! 2 addresses covered

P4070: !_ST [11] (maybe <- 0x18002f1) (Int) (CBR)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4070
nop
RET4070:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4071: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4072: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4073: !_ST [1] (maybe <- 0x18002f2) (Int) (CBR) (Branch target of P3287)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4073
nop
RET4073:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P4074
nop

TARGET3287:
ba RET3287
nop


P4074: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4075: !_ST [10] (maybe <- 0x18002f3) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4076: !_DWST [6] (maybe <- 0x18002f4) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P4077: !_LD [3] (Int)
lduw [%i0 + 32], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P4078: !_DWST [11] (maybe <- 0x18002f6) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P4079: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4080: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4081: !_DWST [7] (maybe <- 0x18002f7) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P4082: !_ST [10] (maybe <- 0x18002f9) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4083: !_DWST [15] (maybe <- 0x18002fa) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P4084: !_LD [8] (Int) (Branch target of P3693)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
ba P4085
nop

TARGET3693:
ba RET3693
nop


P4085: !_DWST [14] (maybe <- 0x18002fb) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4086: !_DWST [2] (maybe <- 0x41000052) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P4087: !_ST [1] (maybe <- 0x18002fc) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4088: !_CAS [7] (maybe <- 0x18002fd) (Int)
add %i1, 84, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l6, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4089: !_DWST [4] (maybe <- 0x18002fe) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4090: !_DWLD [11] (Int)
ldx [%i2 + 64], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2

P4091: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l7
or %l7, %lo(0x4),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4092: !_ST [8] (maybe <- 0x18002ff) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4093: !_ST [14] (maybe <- 0x1800300) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4094: !_CAS [14] (maybe <- 0x1800301) (Int) (CBR)
add %i3, 128, %l3
lduw [%l3], %o3
mov %o3, %o5
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4094
nop
RET4094:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4095: !_ST [12] (maybe <- 0x1800302) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4096: !_MEMBAR (Int)
membar #StoreLoad

P4097: !_LD [0] (Int) (CBR)
lduw [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4097
nop
RET4097:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4098: !_LD [1] (Int) (CBR)
lduw [%i0 + 4], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4098
nop
RET4098:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4099: !_LD [2] (Int)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4100: !_LD [3] (Int)
lduw [%i0 + 32], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P4101: !_LD [4] (Int)
lduw [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4102: !_LD [5] (Int)
lduw [%i1 + 76], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P4103: !_LD [6] (FP)
ld [%i1 + 80], %f2
! 1 addresses covered

P4104: !_LD [7] (Int)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4105: !_LD [8] (Int) (CBR)
lduw [%i1 + 256], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4105
nop
RET4105:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4106: !_LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4107: !_LD [10] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i2 + 32] %asi, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4108: !_LD [11] (Int)
lduw [%i2 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4109: !_LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4110: !_LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4111: !_LD [14] (Int) (CBR) (Branch target of P3605)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4111
nop
RET4111:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P4112
nop

TARGET3605:
ba RET3605
nop


P4112: !_LD [15] (FP) (Branch target of P3154)
ld [%i3 + 192], %f3
! 1 addresses covered
ba END_NODES3
nop

TARGET3154:
ba RET3154
nop


END_NODES3: ! Test istream for CPU 3 ends
sethi %hi(0xdead0e0f), %o5
or    %o5, %lo(0xdead0e0f), %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
stw %o5, [%i5] 
ld [%i5], %f4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30

restore
retl
nop
!-----------------

! register usage:
! %i0 %i1 %i2 %i3 : base registers for 4 regions
! %i4 fixed pointer to per-cpu results area
! %l1 moving pointer to per-cpu FP results area
! %o7 moving pointer to per-cpu integer results area
! %i5 pointer to per-cpu private area
! %l0 holds lfsr, used as source of random bits 
! %l2 loop count register
! %f16 running counter for unique fp store values
! %f17 holds increment value for fp counter
! %l4 running counter for unique integer store values (increment value is always 1)
! %l5 move-to register for load values (simulation only)
! %f30 move-to register for FP values (simulation only)
! %l3 %l6 %l7 %o5 : 4 temporary registers
! %o0 %o1 %o2 %o3 %o4 : 5 integer results buffer registers
! %f0-f15 FP results buffer registers
! %f32-f47 FP block load/store registers

func4:
! 1000 (dynamic) instruction sequence begins
save   %sp, -192, %sp

! Force %i0-%i3 to be 64-byte aligned
add %i0, 63, %i0
andn %i0, 63, %i0

add %i1, 63, %i1
andn %i1, 63, %i1

add %i2, 63, %i2
andn %i2, 63, %i2

add %i3, 63, %i3
andn %i3, 63, %i3

add %i4, 63, %i4
andn %i4, 63, %i4

add %i5, 63, %i5
andn %i5, 63, %i5


! Initialize pointer to FP load results area
mov   %i4, %l1

! Initialize pointer to integer load results area
sethi %hi(0x80000), %o7
or    %o7, %lo(0x80000), %o7
add  %o7, %l1, %o7 

! Initialize %f0-%f62 to 0xdeadbee0deadbee1
sethi %hi(0xdeadbee0), %l7
or    %l7, %lo(0xdeadbee0), %l7
stw   %l7, [%i5]
sethi %hi(0xdeadbee1), %l7
or    %l7, %lo(0xdeadbee1), %l7
stw   %l7, [%i5+4]
ldd [%i5], %f0
fmovd %f0, %f2
fmovd %f0, %f4
fmovd %f0, %f6
fmovd %f0, %f8
fmovd %f0, %f10
fmovd %f0, %f12
fmovd %f0, %f14
fmovd %f0, %f16
fmovd %f0, %f18
fmovd %f0, %f20
fmovd %f0, %f22
fmovd %f0, %f24
fmovd %f0, %f26
fmovd %f0, %f28
fmovd %f0, %f30
fmovd %f0, %f32
fmovd %f0, %f34
fmovd %f0, %f36
fmovd %f0, %f38
fmovd %f0, %f40
fmovd %f0, %f42
fmovd %f0, %f44
fmovd %f0, %f46
fmovd %f0, %f48
fmovd %f0, %f50
fmovd %f0, %f52
fmovd %f0, %f54
fmovd %f0, %f56
fmovd %f0, %f58
fmovd %f0, %f60
fmovd %f0, %f62

! Signature for extract_loads script to start extracting load values for this stream
sethi %hi(0x04deade1), %l7
or    %l7, %lo(0x04deade1), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x2000001), %l4
or    %l4, %lo(0x2000001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x41800001), %l7
or    %l7, %lo(0x41800001), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x36000000), %l7
or    %l7, %lo(0x36000000), %l7
stw %l7, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x431a^4
sethi %hi(0x431a), %l0
or    %l0, %lo(0x431a), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 8 to 9 ---
stx %g0, [%i1+256]
stx %g0, [%i1+512]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %o5
add %i3, %o5, %o5
sub %o5, -4096, %o5

!-- begin of sync_init ---
or %g0, 1, %l3
or %g0, %l3, %l6
swap [%o5+4], %l6
membar #Sync
sync_init_1_4:
brnz,pt %l3, sync_init_1_4
lduw [%o5+4], %l3 ! delay slot
sync_init_2_4:
lduw [%o5], %l3
sub %l3, 1, %l6
cas [%o5], %l3, %l6
cmp %l3, %l6
bne,pt %xcc, sync_init_2_4
nop
membar #Sync
sync_init_3_4:
lduw [%o5], %l3 ! delay slot
brnz,pt %l3, sync_init_3_4
nop
!-- end of sync_init ---


BEGIN_NODES4: ! Test istream for CPU 4 begins

P4113: !_ST [2] (maybe <- 0x2000001) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4113
nop
RET4113:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4114: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4115: !_DWST [4] (maybe <- 0x2000002) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P4116: !_DWST [15] (maybe <- 0x2000003) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4117: !_LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4118: !_DWST [12] (maybe <- 0x2000004) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P4119: !_ST [5] (maybe <- 0x2000005) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4120: !_ST [15] (maybe <- 0x2000006) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4121: !_ST [7] (maybe <- 0x2000007) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4122: !_ST [13] (maybe <- 0x2000008) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4123: !_ST [14] (maybe <- 0x41800001) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P4124: !_ST [7] (maybe <- 0x2000009) (Int) (CBR)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4124
nop
RET4124:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4125: !_ST [5] (maybe <- 0x200000a) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4126: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4127: !_DWST [13] (maybe <- 0x200000b) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P4128: !_SWAP [13] (maybe <- 0x200000c) (Int)
mov %l4, %l3
swap  [%i3 + 64], %l3
! move %l3(lower) -> %o0(lower)
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P4129: !_ST [12] (maybe <- 0x41800002) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P4130: !_ST [12] (maybe <- 0x200000d) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4131: !_DWST [12] (maybe <- 0x200000e) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P4132: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4133: !_DWST [15] (maybe <- 0x200000f) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4133
nop
RET4133:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4134: !_ST [6] (maybe <- 0x2000010) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4135: !_ST [11] (maybe <- 0x2000011) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4136: !_ST [11] (maybe <- 0x2000012) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i2 + 64] %asi
add   %l4, 1, %l4

P4137: !_CAS [11] (maybe <- 0x2000013) (Int)
add %i2, 64, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P4138: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4139: !_DWST [4] (maybe <- 0x41800003) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P4140: !_ST [5] (maybe <- 0x2000014) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4141: !_ST [11] (maybe <- 0x2000015) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4142: !_ST [13] (maybe <- 0x2000016) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4143: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4144: !_ST [13] (maybe <- 0x2000017) (Int) (Branch target of P4827)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P4145
nop

TARGET4827:
ba RET4827
nop


P4145: !_ST [15] (maybe <- 0x2000018) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4145
nop
RET4145:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4146: !_LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4147: !_ST [8] (maybe <- 0x2000019) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4148: !_ST [1] (maybe <- 0x200001a) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4149: !_ST [4] (maybe <- 0x200001b) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4150: !_ST [13] (maybe <- 0x200001c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4151: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %l7
or %l7, %lo(0x54),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4152: !_DWST [2] (maybe <- 0x200001d) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P4153: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l3
or %l3, %lo(0x4),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4154: !_CASX [12] (maybe <- 0x200001e) (Int)
add %i3, 0, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %o5
or %o5, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l3
or %l3, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
add  %l4, 1, %l4

P4155: !_DWST [2] (maybe <- 0x200001f) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P4156: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4157: !_DWLD [13] (Int)
ldx [%i3 + 64], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4158: !_ST [13] (maybe <- 0x2000020) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4159: !_DWST [3] (maybe <- 0x41800004) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P4160: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4161: !_ST [8] (maybe <- 0x41800005) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 256 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4161
nop
RET4161:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4162: !_ST [12] (maybe <- 0x2000021) (Int) (CBR)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4162
nop
RET4162:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4163: !_ST [5] (maybe <- 0x2000022) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4164: !_DWST [2] (maybe <- 0x2000023) (Int) (Branch target of P4161)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4
ba P4165
nop

TARGET4161:
ba RET4161
nop


P4165: !_REPLACEMENT [6] (Int)
sethi %hi(0x50), %l3
or %l3, %lo(0x50),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4166: !_DWST [7] (maybe <- 0x2000024) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P4167: !_DWST [13] (maybe <- 0x2000026) (Int) (Branch target of P4759)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P4168
nop

TARGET4759:
ba RET4759
nop


P4168: !_DWST [0] (maybe <- 0x2000027) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P4169: !_ST [14] (maybe <- 0x2000029) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4170: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4171: !_LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4172: !_ST [7] (maybe <- 0x200002a) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4173: !_ST [9] (maybe <- 0x41800006) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P4174: !_DWST [10] (maybe <- 0x200002b) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P4175: !_ST [3] (maybe <- 0x200002c) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4176: !_ST [10] (maybe <- 0x200002d) (Int) (Branch target of P5075)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P4177
nop

TARGET5075:
ba RET5075
nop


P4177: !_DWST [5] (maybe <- 0x200002e) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P4178: !_ST [6] (maybe <- 0x200002f) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4179: !_LD [2] (Int)
lduw [%i0 + 12], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P4180: !_DWST [13] (maybe <- 0x2000030) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P4181: !_DWST [4] (maybe <- 0x41800007) (FP) (Branch target of P4446)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]
ba P4182
nop

TARGET4446:
ba RET4446
nop


P4182: !_ST [8] (maybe <- 0x2000031) (Int) (Branch target of P4586)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P4183
nop

TARGET4586:
ba RET4586
nop


P4183: !_ST [9] (maybe <- 0x2000032) (Int) (Branch target of P4262)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P4184
nop

TARGET4262:
ba RET4262
nop


P4184: !_LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4185: !_CASX [7] (maybe <- 0x2000033) (Int)
add %i1, 80, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l6, %l7
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %o5
or %o5, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
add  %l4, 1, %l4

P4186: !_DWLD [11] (Int)
ldx [%i2 + 64], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l7
or %l7, %o3, %o3

P4187: !_CAS [10] (maybe <- 0x2000035) (Int)
add %i2, 32, %l6
lduw [%l6], %o4
mov %o4, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P4188: !_ST [7] (maybe <- 0x2000036) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4189: !_ST [15] (maybe <- 0x2000037) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4189
nop
RET4189:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4190: !_CASX [12] (maybe <- 0x2000038) (Int)
add %i3, 0, %l3
ldx [%l3], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %o5
sllx %l4, 32, %o1
casx [%l3], %o5, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P4191: !_DWLD [12] (Int) (CBR)
ldx [%i3 + 0], %o2
! move %o2(upper) -> %o2(upper)

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4191
nop
RET4191:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4192: !_CASX [2] (maybe <- 0x2000039) (Int) (CBR) (Branch target of P4380)
add %i0, 8, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %o5
or %o5, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4192
nop
RET4192:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P4193
nop

TARGET4380:
ba RET4380
nop


P4193: !_DWST [14] (maybe <- 0x200003a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P4194: !_DWST [4] (maybe <- 0x200003b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P4195: !_ST [13] (maybe <- 0x200003c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4196: !_CASX [7] (maybe <- 0x200003d) (Int)
add %i1, 80, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l6
or %l6, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
add  %l4, 1, %l4

P4197: !_ST [15] (maybe <- 0x200003f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4198: !_ST [15] (maybe <- 0x2000040) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4199: !_ST [13] (maybe <- 0x2000041) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4200: !_DWST [12] (maybe <- 0x41800008) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 0]

P4201: !_ST [11] (maybe <- 0x2000042) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4202: !_DWST [5] (maybe <- 0x2000043) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P4203: !_DWST [3] (maybe <- 0x2000044) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P4204: !_ST [14] (maybe <- 0x41800009) (FP) (Branch target of P4599)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]
ba P4205
nop

TARGET4599:
ba RET4599
nop


P4205: !_ST [10] (maybe <- 0x2000045) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4206: !_SWAP [5] (maybe <- 0x2000046) (Int) (LE)
wr %g0, 0x88, %asi
mov %l4, %l6
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l6, %o5, %l3
srl %l3, 8, %l3
sll %l6, 8, %l6
and %l6, %o5, %l6
or %l6, %l3, %l6
srl %l6, 16, %l3
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %l3, %l6
swapa  [%i1 + 76] %asi, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P4207: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4208: !_DWST [10] (maybe <- 0x4180000a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P4209: !_ST [11] (maybe <- 0x2000047) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4210: !_ST [12] (maybe <- 0x2000048) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4211: !_DWST [1] (maybe <- 0x2000049) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P4212: !_ST [13] (maybe <- 0x200004b) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4213: !_ST [7] (maybe <- 0x200004c) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4214: !_DWST [1] (maybe <- 0x200004d) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P4215: !_ST [0] (maybe <- 0x200004f) (Int) (Branch target of P4401)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4
ba P4216
nop

TARGET4401:
ba RET4401
nop


P4216: !_ST [7] (maybe <- 0x2000050) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4217: !_DWST [8] (maybe <- 0x2000051) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P4218: !_ST [1] (maybe <- 0x2000052) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4219: !_DWST [8] (maybe <- 0x2000053) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P4220: !_DWST [11] (maybe <- 0x2000054) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P4221: !_ST [9] (maybe <- 0x2000055) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4222: !_ST [14] (maybe <- 0x2000056) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4223: !_ST [2] (maybe <- 0x2000057) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4224: !_CASX [15] (maybe <- 0x2000058) (Int)
add %i3, 192, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l3
or %l3, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l6
or %l6, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
add  %l4, 1, %l4

P4225: !_PREFETCH [2] (Int) (Branch target of P4369)
prefetch [%i0 + 12], 1
ba P4226
nop

TARGET4369:
ba RET4369
nop


P4226: !_DWST [15] (maybe <- 0x2000059) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 192 ] 
add   %l4, 1, %l4

P4227: !_DWST [9] (maybe <- 0x200005a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P4228: !_DWST [10] (maybe <- 0x200005b) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i2 + 32 ] %asi
add   %l4, 1, %l4

P4229: !_ST [13] (maybe <- 0x200005c) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4229
nop
RET4229:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4230: !_ST [8] (maybe <- 0x200005d) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4231: !_DWLD [14] (Int)
ldx [%i3 + 128], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4232: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %l7
or %l7, %lo(0x4),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4233: !_DWST [15] (maybe <- 0x200005e) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P4234: !_CASX [10] (maybe <- 0x200005f) (Int)
add %i2, 32, %l6
ldx [%l6], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l3
sllx %l4, 32, %o1
casx [%l6], %l3, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P4235: !_DWST [12] (maybe <- 0x2000060) (Int) (Branch target of P4890)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4
ba P4236
nop

TARGET4890:
ba RET4890
nop


P4236: !_LD [8] (FP)
ld [%i1 + 256], %f0
! 1 addresses covered

P4237: !_DWST [14] (maybe <- 0x2000061) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P4238: !_LD [8] (Int)
lduw [%i1 + 256], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4239: !_ST [2] (maybe <- 0x2000062) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4240: !_ST [6] (maybe <- 0x2000063) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4241: !_ST [14] (maybe <- 0x2000064) (Int) (Branch target of P4765)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P4242
nop

TARGET4765:
ba RET4765
nop


P4242: !_ST [1] (maybe <- 0x2000065) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4243: !_ST [4] (maybe <- 0x2000066) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4244: !_ST [10] (maybe <- 0x2000067) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4245: !_ST [2] (maybe <- 0x2000068) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4246: !_LD [2] (Int)
lduw [%i0 + 12], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P4247: !_DWST [14] (maybe <- 0x2000069) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P4248: !_ST [8] (maybe <- 0x200006a) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4249: !_ST [1] (maybe <- 0x200006b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4250: !_ST [6] (maybe <- 0x200006c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4251: !_ST [6] (maybe <- 0x200006d) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4251
nop
RET4251:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4252: !_ST [3] (maybe <- 0x200006e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4253: !_ST [14] (maybe <- 0x200006f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4254: !_ST [7] (maybe <- 0x2000070) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4255: !_LD [15] (Int) (Branch target of P4766)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
ba P4256
nop

TARGET4766:
ba RET4766
nop


P4256: !_ST [9] (maybe <- 0x2000071) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4257: !_DWST [10] (maybe <- 0x2000072) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4258: !_ST [3] (maybe <- 0x2000073) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4259: !_ST [14] (maybe <- 0x2000074) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4260: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4261: !_ST [15] (maybe <- 0x2000075) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4262: !_ST [0] (maybe <- 0x2000076) (Int) (CBR)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4262
nop
RET4262:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4263: !_DWLD [8] (Int)
ldx [%i1 + 256], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l6
or %l6, %o3, %o3

P4264: !_ST [10] (maybe <- 0x2000077) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4264
nop
RET4264:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4265: !_ST [8] (maybe <- 0x2000078) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4266: !_DWST [14] (maybe <- 0x4180000b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P4267: !_CAS [0] (maybe <- 0x2000079) (Int) (Branch target of P4777)
add %i0, 0, %l7
lduw [%l7], %o4
mov %o4, %l6
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o4(lower)
srl %l3, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4
ba P4268
nop

TARGET4777:
ba RET4777
nop


P4268: !_DWST [10] (maybe <- 0x200007a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4269: !_DWST [14] (maybe <- 0x200007b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4270: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %o5
or %o5, %lo(0x4),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4271: !_DWST [14] (maybe <- 0x200007c) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 128 ] 
add   %l4, 1, %l4

P4272: !_DWST [2] (maybe <- 0x4180000c) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P4273: !_ST [6] (maybe <- 0x200007d) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 80] %asi
add   %l4, 1, %l4

P4274: !_SWAP [15] (maybe <- 0x200007e) (Int)
mov %l4, %o0
swap  [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4275: !_DWST [9] (maybe <- 0x200007f) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P4276: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4277: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l6
or %l6, %lo(0x200),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P4278: !_ST [15] (maybe <- 0x2000080) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4279: !_CASX [1] (maybe <- 0x2000081) (Int)
add %i0, 0, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %o5
or %o5, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l7, %o5
sllx %l4, 32, %l7
add  %l4, 1, %l4
or   %l4, %l7, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l3
or %l3, %o1, %o1
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
add  %l4, 1, %l4

P4280: !_ST [6] (maybe <- 0x2000083) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 80] %asi
add   %l4, 1, %l4

P4281: !_ST [13] (maybe <- 0x2000084) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4282: !_ST [9] (maybe <- 0x2000085) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i1 + 512] %asi
add   %l4, 1, %l4

P4283: !_ST [6] (maybe <- 0x2000086) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4284: !_ST [6] (maybe <- 0x2000087) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 80] %asi
add   %l4, 1, %l4

P4285: !_PREFETCH [5] (Int) (Branch target of P4805)
prefetch [%i1 + 76], 1
ba P4286
nop

TARGET4805:
ba RET4805
nop


P4286: !_CAS [9] (maybe <- 0x2000088) (Int)
add %i1, 512, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2
mov %l4, %o3
cas [%o5], %l7, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4287: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4288: !_ST [3] (maybe <- 0x2000089) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4289: !_REPLACEMENT [13] (Int)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P4290: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4291: !_ST [13] (maybe <- 0x200008a) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4292: !_ST [5] (maybe <- 0x200008b) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i1 + 76] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4292
nop
RET4292:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4293: !_LD [10] (Int)
lduw [%i2 + 32], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

P4294: !_REPLACEMENT [12] (Int)
sethi %hi(0x0), %l6
or %l6, %lo(0x0),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P4295: !_DWST [14] (maybe <- 0x200008c) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4296: !_CAS [5] (maybe <- 0x200008d) (Int)
add %i1, 76, %l3
lduw [%l3], %o4
mov %o4, %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add   %l4, 1, %l4

P4297: !_DWST [4] (maybe <- 0x200008e) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P4298: !_DWST [6] (maybe <- 0x200008f) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P4299: !_DWLD [13] (FP)
ldd [%i3 + 64], %f18
! 1 addresses covered
fmovs %f18, %f1

P4300: !_CASX [5] (maybe <- 0x2000091) (Int)
add %i1, 72, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l6
mov %l4, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P4301: !_ST [10] (maybe <- 0x2000092) (Int) (Branch target of P4510)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P4302
nop

TARGET4510:
ba RET4510
nop


P4302: !_LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4303: !_DWLD [12] (Int)
ldx [%i3 + 0], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2

P4304: !_DWST [10] (maybe <- 0x2000093) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4

P4305: !_CASX [7] (maybe <- 0x2000094) (Int)
add %i1, 80, %l3
ldx [%l3], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov %o3, %o5
sllx %l4, 32, %o4
add  %l4, 1, %l4
or   %l4, %o4, %o4
casx [%l3], %o5, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P4306: !_DWLD [0] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P4307: !_ST [14] (maybe <- 0x2000096) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4308: !_ST [4] (maybe <- 0x2000097) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4309: !_REPLACEMENT [14] (Int)
sethi %hi(0x80), %o5
or %o5, %lo(0x80),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4310: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4311: !_LD [2] (Int)
lduw [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4312: !_ST [10] (maybe <- 0x2000098) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4313: !_DWST [2] (maybe <- 0x2000099) (Int)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4

P4314: !_CAS [2] (maybe <- 0x200009a) (Int)
add %i0, 12, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l6, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4315: !_REPLACEMENT [4] (Int) (CBR)
sethi %hi(0x40), %l6
or %l6, %lo(0x40),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4315
nop
RET4315:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4316: !_ST [7] (maybe <- 0x200009b) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4317: !_DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %l3
or %l3, %o2, %o2

P4318: !_DWST [4] (maybe <- 0x200009c) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P4319: !_DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P4320: !_PREFETCH [12] (Int) (CBR)
prefetch [%i3 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4320
nop
RET4320:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4321: !_ST [15] (maybe <- 0x4180000d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P4322: !_ST [0] (maybe <- 0x200009d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4323: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4324: !_DWST [1] (maybe <- 0x200009e) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P4325: !_ST [2] (maybe <- 0x20000a0) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 12] %asi
add   %l4, 1, %l4

P4326: !_ST [4] (maybe <- 0x20000a1) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4327: !_DWST [7] (maybe <- 0x20000a2) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P4328: !_CASX [2] (maybe <- 0x20000a4) (Int)
add %i0, 8, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
add  %l4, 1, %l4

P4329: !_ST [3] (maybe <- 0x20000a5) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4330: !_ST [15] (maybe <- 0x20000a6) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4331: !_DWST [6] (maybe <- 0x20000a7) (Int) (LE)
wr %g0, 0x88, %asi
sllx %l4, 32, %l3
add   %l4, 1, %l4
or %l3, %l4, %l6
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
sllx %l7, 32, %l3
or %l7, %l3, %l7 
and %l6, %l7, %l3
srlx %l3, 8, %l3
sllx %l6, 8, %l6
and %l6, %l7, %l6
or %l6, %l3, %l6 
sethi %hi(0xffff0000), %l7
or %l7, %lo(0xffff0000), %l7
srlx %l6, 16, %l3
andn %l3, %l7, %l3
andn %l6, %l7, %l6
sllx %l6, 16, %l6
or %l6, %l3, %l6 
srlx %l6, 32, %l3
sllx %l6, 32, %l6
or %l6, %l3, %l3 
stxa %l3, [%i1 + 80 ] %asi
add   %l4, 1, %l4

P4332: !_DWST [15] (maybe <- 0x20000a9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P4333: !_ST [13] (maybe <- 0x20000aa) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4334: !_ST [1] (maybe <- 0x20000ab) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4335: !_DWST [6] (maybe <- 0x20000ac) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P4336: !_CAS [15] (maybe <- 0x20000ae) (Int)
add %i3, 192, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4337: !_ST [0] (maybe <- 0x20000af) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4338: !_ST [2] (maybe <- 0x20000b0) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4339: !_ST [0] (maybe <- 0x20000b1) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4340: !_DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1

P4341: !_ST [8] (maybe <- 0x20000b2) (Int) (Branch target of P4229)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P4342
nop

TARGET4229:
ba RET4229
nop


P4342: !_ST [10] (maybe <- 0x20000b3) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4343: !_CAS [15] (maybe <- 0x20000b4) (Int)
add %i3, 192, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4

P4344: !_DWST [2] (maybe <- 0x20000b5) (Int) (CBR)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4344
nop
RET4344:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4345: !_ST [14] (maybe <- 0x20000b6) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4346: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4347: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %o5
or %o5, %lo(0x0),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4348: !_DWST [9] (maybe <- 0x20000b7) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P4349: !_DWLD [8] (FP) (CBR)
ldd [%i1 + 256], %f2
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4349
nop
RET4349:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4350: !_CAS [7] (maybe <- 0x20000b8) (Int)
add %i1, 84, %o5
lduw [%o5], %o3
mov %o3, %l7
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

P4351: !_ST [5] (maybe <- 0x4180000e) (FP) (Branch target of P4919)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]
ba P4352
nop

TARGET4919:
ba RET4919
nop


P4352: !_ST [3] (maybe <- 0x20000b9) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4353: !_PREFETCH [1] (Int) (CBR)
prefetch [%i0 + 4], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4353
nop
RET4353:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4354: !_DWST [13] (maybe <- 0x20000ba) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4354
nop
RET4354:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4355: !_PREFETCH [9] (Int) (CBR)
prefetch [%i1 + 512], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4355
nop
RET4355:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4356: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4357: !_ST [7] (maybe <- 0x20000bb) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4358: !_MEMBAR (Int)
membar #StoreLoad

P4359: !_LD [10] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i2 + 32] %asi, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4360: !_ST [3] (maybe <- 0x20000bc) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4361: !_CAS [0] (maybe <- 0x20000bd) (Int)
add %i0, 0, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%o5], %l7, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4362: !_ST [5] (maybe <- 0x20000be) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4363: !_ST [3] (maybe <- 0x20000bf) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4364: !_ST [7] (maybe <- 0x20000c0) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4365: !_DWST [9] (maybe <- 0x20000c1) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 512 ] 
add   %l4, 1, %l4

P4366: !_ST [13] (maybe <- 0x20000c2) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i3 + 64] %asi
add   %l4, 1, %l4

P4367: !_ST [12] (maybe <- 0x20000c3) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4368: !_ST [12] (maybe <- 0x20000c4) (Int) (Branch target of P5027)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4
ba P4369
nop

TARGET5027:
ba RET5027
nop


P4369: !_ST [1] (maybe <- 0x20000c5) (Int) (LE) (CBR)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i0 + 4] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4369
nop
RET4369:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4370: !_ST [7] (maybe <- 0x20000c6) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4371: !_ST [9] (maybe <- 0x20000c7) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4372: !_ST [14] (maybe <- 0x20000c8) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4373: !_DWST [14] (maybe <- 0x20000c9) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4374: !_LD [9] (FP) (CBR)
ld [%i1 + 512], %f3
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4374
nop
RET4374:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4375: !_ST [5] (maybe <- 0x20000ca) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4376: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4377: !_ST [10] (maybe <- 0x20000cb) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l3, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
stwa   %o5, [%i2 + 32] %asi
add   %l4, 1, %l4

P4378: !_DWLD [5] (Int) (CBR)
ldx [%i1 + 72], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l7
or %l7, %o0, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4378
nop
RET4378:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4379: !_DWST [14] (maybe <- 0x20000cc) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P4380: !_ST [5] (maybe <- 0x20000cd) (Int) (LE) (CBR) (Branch target of P4612)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 76] %asi
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4380
nop
RET4380:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0

ba P4381
nop

TARGET4612:
ba RET4612
nop


P4381: !_DWST [0] (maybe <- 0x20000ce) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P4382: !_CAS [5] (maybe <- 0x20000d0) (Int)
add %i1, 76, %l3
lduw [%l3], %o1
mov %o1, %o5
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P4383: !_ST [6] (maybe <- 0x20000d1) (Int) (CBR)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4383
nop
RET4383:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4384: !_REPLACEMENT [10] (Int)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4385: !_DWST [10] (maybe <- 0x20000d2) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P4386: !_ST [6] (maybe <- 0x20000d3) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i1 + 80] %asi
add   %l4, 1, %l4

P4387: !_ST [4] (maybe <- 0x20000d4) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4388: !_ST [8] (maybe <- 0x20000d5) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4389: !_CAS [13] (maybe <- 0x20000d6) (Int) (Branch target of P4597)
add %i3, 64, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4
ba P4390
nop

TARGET4597:
ba RET4597
nop


P4390: !_DWST [0] (maybe <- 0x20000d7) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P4391: !_ST [10] (maybe <- 0x20000d9) (Int) (Branch target of P4264)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4
ba P4392
nop

TARGET4264:
ba RET4264
nop


P4392: !_ST [8] (maybe <- 0x20000da) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l6
or %l6, %lo(0xff00ff00), %l6
and %l4, %l6, %l7
srl %l7, 8, %l7
sll %l4, 8, %l3
and %l3, %l6, %l3
or %l3, %l7, %l3
srl %l3, 16, %l7
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l7, %l3
stwa   %l3, [%i1 + 256] %asi
add   %l4, 1, %l4

P4393: !_PREFETCH [3] (Int) (Branch target of P4133)
prefetch [%i0 + 32], 1
ba P4394
nop

TARGET4133:
ba RET4133
nop


P4394: !_REPLACEMENT [5] (Int)
sethi %hi(0x4c), %o5
or %o5, %lo(0x4c),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4395: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4396: !_CASX [13] (maybe <- 0x20000db) (Int)
add %i3, 64, %l7
ldx [%l7], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l6
sllx %l4, 32, %o4
casx [%l7], %l6, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P4397: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4398: !_ST [10] (maybe <- 0x20000dc) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4399: !_ST [7] (maybe <- 0x20000dd) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4400: !_CAS [4] (maybe <- 0x20000de) (Int)
add %i0, 64, %l3
lduw [%l3], %o0
mov %o0, %o5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P4401: !_ST [5] (maybe <- 0x20000df) (Int) (CBR)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4401
nop
RET4401:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4402: !_ST [14] (maybe <- 0x20000e0) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4403: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4404: !_ST [2] (maybe <- 0x20000e1) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4405: !_ST [4] (maybe <- 0x20000e2) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4406: !_DWST [7] (maybe <- 0x4180000f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4407: !_DWST [12] (maybe <- 0x20000e3) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P4408: !_SWAP [1] (maybe <- 0x20000e4) (Int)
mov %l4, %o1
swap  [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4409: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4410: !_ST [4] (maybe <- 0x20000e5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4411: !_CASX [14] (maybe <- 0x20000e6) (Int)
add %i3, 128, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o1(lower)
srlx %o5, 32, %l3
or %l3, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov  %o5, %l3
sllx %l4, 32, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l6
or %l6, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
add  %l4, 1, %l4

P4412: !_ST [13] (maybe <- 0x20000e7) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4413: !_CAS [0] (maybe <- 0x20000e8) (Int) (CBR)
add %i0, 0, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4413
nop
RET4413:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4414: !_NOP (Int)
nop

P4415: !_DWST [6] (maybe <- 0x20000e9) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P4416: !_ST [10] (maybe <- 0x41800011) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P4417: !_CASX [5] (maybe <- 0x20000eb) (Int)
add %i1, 72, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %o5
or %o5, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
add  %l4, 1, %l4

P4418: !_ST [5] (maybe <- 0x20000ec) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4419: !_ST [2] (maybe <- 0x20000ed) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4420: !_DWLD [9] (Int) (Branch target of P4349)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
ba P4421
nop

TARGET4349:
ba RET4349
nop


P4421: !_DWST [9] (maybe <- 0x20000ee) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P4422: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4423: !_ST [13] (maybe <- 0x20000ef) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i3 + 64] %asi
add   %l4, 1, %l4

P4424: !_NOP (Int)
nop

P4425: !_DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P4426: !_SWAP [12] (maybe <- 0x20000f0) (Int)
mov %l4, %o3
swap  [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4427: !_ST [8] (maybe <- 0x20000f1) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4428: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4429: !_ST [12] (maybe <- 0x20000f2) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4430: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %o5
or %o5, %lo(0x4),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4431: !_DWST [11] (maybe <- 0x20000f3) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P4432: !_ST [5] (maybe <- 0x41800012) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 76 ]

P4433: !_CASX [2] (maybe <- 0x20000f4) (Int)
add %i0, 8, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l3
or %l3, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
mov  %o5, %l3
mov %l4, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
add  %l4, 1, %l4

P4434: !_DWST [14] (maybe <- 0x41800013) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P4435: !_ST [4] (maybe <- 0x20000f5) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4436: !_CASX [2] (maybe <- 0x20000f6) (Int)
add %i0, 8, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P4437: !_DWST [3] (maybe <- 0x20000f7) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P4438: !_DWST [2] (maybe <- 0x20000f8) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P4439: !_ST [1] (maybe <- 0x20000f9) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4440: !_ST [8] (maybe <- 0x20000fa) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4441: !_DWST [5] (maybe <- 0x20000fb) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P4442: !_ST [6] (maybe <- 0x20000fc) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4443: !_ST [1] (maybe <- 0x20000fd) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4444: !_CAS [6] (maybe <- 0x20000fe) (Int)
add %i1, 80, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2
mov %l4, %o3
cas [%l3], %o5, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4445: !_LD [7] (Int)
lduw [%i1 + 84], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

P4446: !_LD [0] (FP) (CBR) (Branch target of P4650)
ld [%i0 + 0], %f4
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4446
nop
RET4446:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P4447
nop

TARGET4650:
ba RET4650
nop


P4447: !_DWST [12] (maybe <- 0x20000ff) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P4448: !_ST [3] (maybe <- 0x41800014) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P4449: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4450: !_ST [14] (maybe <- 0x2000100) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4451: !_DWST [6] (maybe <- 0x2000101) (Int) (Branch target of P4689)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4
ba P4452
nop

TARGET4689:
ba RET4689
nop


P4452: !_ST [13] (maybe <- 0x2000103) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4453: !_LD [15] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i3 + 192] %asi, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4454: !_ST [9] (maybe <- 0x2000104) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4455: !_DWST [0] (maybe <- 0x2000105) (Int) (Branch target of P4567)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4
ba P4456
nop

TARGET4567:
ba RET4567
nop


P4456: !_ST [0] (maybe <- 0x2000107) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4457: !_ST [12] (maybe <- 0x2000108) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4458: !_ST [2] (maybe <- 0x2000109) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4459: !_LD [3] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 32] %asi, %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4460: !_ST [3] (maybe <- 0x200010a) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4461: !_REPLACEMENT [1] (Int)
sethi %hi(0x4), %o5
or %o5, %lo(0x4),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

P4462: !_ST [4] (maybe <- 0x200010b) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4463: !_DWST [3] (maybe <- 0x200010c) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4463
nop
RET4463:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4464: !_ST [0] (maybe <- 0x200010d) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4465: !_ST [6] (maybe <- 0x200010e) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4466: !_ST [1] (maybe <- 0x200010f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4467: !_ST [14] (maybe <- 0x2000110) (Int) (CBR)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4467
nop
RET4467:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4468: !_REPLACEMENT [0] (Int)
sethi %hi(0x0), %l7
or %l7, %lo(0x0),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4469: !_LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4470: !_DWST [4] (maybe <- 0x2000111) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 64 ] 
add   %l4, 1, %l4

P4471: !_ST [14] (maybe <- 0x41800015) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P4472: !_ST [4] (maybe <- 0x2000112) (Int) (LE) (Branch target of P4749)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 64] %asi
add   %l4, 1, %l4
ba P4473
nop

TARGET4749:
ba RET4749
nop


P4473: !_DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0

P4474: !_SWAP [4] (maybe <- 0x2000113) (Int)
mov %l4, %o1
swap  [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4475: !_ST [15] (maybe <- 0x2000114) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4476: !_DWST [8] (maybe <- 0x2000115) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P4477: !_LD [4] (Int)
lduw [%i0 + 64], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P4478: !_ST [2] (maybe <- 0x2000116) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4479: !_CAS [6] (maybe <- 0x2000117) (Int)
add %i1, 80, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4

P4480: !_ST [9] (maybe <- 0x2000118) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4481: !_ST [5] (maybe <- 0x2000119) (Int) (Branch target of P4655)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4
ba P4482
nop

TARGET4655:
ba RET4655
nop


P4482: !_DWLD [15] (Int)
ldx [%i3 + 192], %o3
! move %o3(upper) -> %o3(upper)

P4483: !_ST [12] (maybe <- 0x200011a) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4484: !_DWST [13] (maybe <- 0x200011b) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P4485: !_ST [6] (maybe <- 0x200011c) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4486: !_ST [11] (maybe <- 0x200011d) (Int) (Branch target of P5114)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P4487
nop

TARGET5114:
ba RET5114
nop


P4487: !_ST [1] (maybe <- 0x200011e) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4488: !_CAS [0] (maybe <- 0x200011f) (Int)
add %i0, 0, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4489: !_ST [15] (maybe <- 0x2000120) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4489
nop
RET4489:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4490: !_ST [13] (maybe <- 0x2000121) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4491: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4492: !_DWST [8] (maybe <- 0x2000122) (Int) (Branch target of P4467)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4
ba P4493
nop

TARGET4467:
ba RET4467
nop


P4493: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4493
nop
RET4493:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4494: !_DWST [5] (maybe <- 0x2000123) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P4495: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4496: !_DWST [6] (maybe <- 0x2000124) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P4497: !_ST [5] (maybe <- 0x2000126) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4498: !_ST [11] (maybe <- 0x2000127) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4499: !_ST [0] (maybe <- 0x2000128) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4500: !_DWST [4] (maybe <- 0x41800016) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 64]

P4501: !_ST [10] (maybe <- 0x2000129) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4502: !_ST [8] (maybe <- 0x200012a) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4503: !_ST [1] (maybe <- 0x200012b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4504: !_ST [11] (maybe <- 0x200012c) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4505: !_CASX [5] (maybe <- 0x200012d) (Int)
add %i1, 72, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov  %o5, %l3
mov %l4, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l6
or %l6, %o0, %o0
! move %o5(lower) -> %o1(upper)
sllx %o5, 32, %o1
add  %l4, 1, %l4

P4506: !_ST [0] (maybe <- 0x200012e) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4507: !_LD [13] (Int)
lduw [%i3 + 64], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P4508: !_CAS [10] (maybe <- 0x200012f) (Int)
add %i2, 32, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4509: !_DWST [1] (maybe <- 0x2000130) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P4510: !_PREFETCH [15] (Int) (CBR)
prefetch [%i3 + 192], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4510
nop
RET4510:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4511: !_SWAP [11] (maybe <- 0x2000132) (Int)
mov %l4, %o3
swap  [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P4512: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4513: !_DWST [3] (maybe <- 0x2000133) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4

P4514: !_LD [5] (Int) (CBR) (Branch target of P4715)
lduw [%i1 + 76], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4514
nop
RET4514:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P4515
nop

TARGET4715:
ba RET4715
nop


P4515: !_ST [9] (maybe <- 0x41800017) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P4516: !_CASX [11] (maybe <- 0x2000134) (Int)
add %i2, 64, %l7
ldx [%l7], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov  %o4, %l6
sllx %l4, 32, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P4517: !_CAS [5] (maybe <- 0x2000135) (Int)
add %i1, 76, %l7
lduw [%l7], %o1
mov %o1, %l6
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o1(lower)
srl %l3, 0, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P4518: !_CAS [6] (maybe <- 0x2000136) (Int)
add %i1, 80, %l7
lduw [%l7], %o2
mov %o2, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov %l4, %l3
cas [%l7], %l6, %l3
! move %l3(lower) -> %o2(lower)
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4519: !_ST [0] (maybe <- 0x2000137) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4520: !_DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P4521: !_ST [1] (maybe <- 0x2000138) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4522: !_DWST [11] (maybe <- 0x2000139) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P4523: !_DWST [6] (maybe <- 0x200013a) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P4524: !_ST [2] (maybe <- 0x200013c) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4525: !_ST [13] (maybe <- 0x200013d) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4525
nop
RET4525:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4526: !_SWAP [0] (maybe <- 0x200013e) (Int)
mov %l4, %o4
swap  [%i0 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4527: !_DWLD [14] (Int)
ldx [%i3 + 128], %l7
! move %l7(upper) -> %o4(lower)
srlx %l7, 32, %l6
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4528: !_DWLD [15] (Int)
ldx [%i3 + 192], %o0
! move %o0(upper) -> %o0(upper)

P4529: !_DWST [9] (maybe <- 0x200013f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P4530: !_DWST [13] (maybe <- 0x2000140) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P4531: !_ST [6] (maybe <- 0x2000141) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4532: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4533: !_CAS [0] (maybe <- 0x2000142) (Int)
add %i0, 0, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4534: !_NOP (Int)
nop

P4535: !_ST [3] (maybe <- 0x2000143) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4536: !_CAS [15] (maybe <- 0x2000144) (Int)
add %i3, 192, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1
mov %l4, %o2
cas [%l7], %l6, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P4537: !_ST [11] (maybe <- 0x2000145) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4538: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l3
or %l3, %lo(0x20),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4539: !_DWST [0] (maybe <- 0x2000146) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4540: !_ST [8] (maybe <- 0x2000148) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4541: !_ST [13] (maybe <- 0x41800018) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

P4542: !_ST [9] (maybe <- 0x2000149) (Int) (Branch target of P4709)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P4543
nop

TARGET4709:
ba RET4709
nop


P4543: !_DWST [8] (maybe <- 0x200014a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P4544: !_PREFETCH [1] (Int) (LE) (Branch target of P4493)
wr %g0, 0x88, %asi
prefetcha [%i0 + 4] %asi, 1
ba P4545
nop

TARGET4493:
ba RET4493
nop


P4545: !_CASX [0] (maybe <- 0x200014b) (Int)
add %i0, 0, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov %l6, %l7
sllx %l4, 32, %l6
add  %l4, 1, %l4
or   %l4, %l6, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %o5
or %o5, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
add  %l4, 1, %l4

P4546: !_DWLD [8] (Int)
ldx [%i1 + 256], %o5
! move %o5(upper) -> %o4(lower)
srlx %o5, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4547: !_ST [13] (maybe <- 0x41800019) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 64 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4547
nop
RET4547:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4548: !_ST [10] (maybe <- 0x200014d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4549: !_DWST [11] (maybe <- 0x200014e) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P4550: !_DWST [10] (maybe <- 0x4180001a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P4551: !_ST [9] (maybe <- 0x200014f) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4552: !_ST [2] (maybe <- 0x2000150) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4553: !_ST [15] (maybe <- 0x2000151) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4553
nop
RET4553:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4554: !_PREFETCH [8] (Int) (Branch target of P4320)
prefetch [%i1 + 256], 1
ba P4555
nop

TARGET4320:
ba RET4320
nop


P4555: !_ST [12] (maybe <- 0x4180001b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P4556: !_ST [15] (maybe <- 0x2000152) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4557: !_ST [7] (maybe <- 0x2000153) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i1 + 84] %asi
add   %l4, 1, %l4

P4558: !_ST [15] (maybe <- 0x2000154) (Int) (Branch target of P5088)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P4559
nop

TARGET5088:
ba RET5088
nop


P4559: !_ST [15] (maybe <- 0x2000155) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4560: !_LD [12] (Int)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4561: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4562: !_DWST [2] (maybe <- 0x4180001c) (FP)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 8]

P4563: !_DWST [15] (maybe <- 0x2000156) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P4564: !_ST [0] (maybe <- 0x2000157) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4565: !_ST [1] (maybe <- 0x2000158) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4566: !_ST [0] (maybe <- 0x2000159) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4567: !_ST [13] (maybe <- 0x200015a) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4567
nop
RET4567:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4568: !_ST [6] (maybe <- 0x200015b) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4569: !_CASX [5] (maybe <- 0x200015c) (Int)
add %i1, 72, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P4570: !_DWST [10] (maybe <- 0x200015d) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P4571: !_ST [1] (maybe <- 0x200015e) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4571
nop
RET4571:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4572: !_ST [7] (maybe <- 0x200015f) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4573: !_DWST [1] (maybe <- 0x4180001d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P4574: !_CASX [10] (maybe <- 0x2000160) (Int)
add %i2, 32, %l3
ldx [%l3], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %o5
or %o5, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3
mov  %l7, %o5
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l3
or %l3, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
add  %l4, 1, %l4

P4575: !_ST [7] (maybe <- 0x2000161) (Int) (Branch target of P4719)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4
ba P4576
nop

TARGET4719:
ba RET4719
nop


P4576: !_PREFETCH [3] (Int) (Branch target of P4124)
prefetch [%i0 + 32], 1
ba P4577
nop

TARGET4124:
ba RET4124
nop


P4577: !_DWST [11] (maybe <- 0x2000162) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l3
srl %l3, 8, %l3
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l3, %o5
srl %o5, 16, %l3
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l3, %o5
stxa %o5, [%i2 + 64 ] %asi
add   %l4, 1, %l4

P4578: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4579: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4580: !_ST [1] (maybe <- 0x2000163) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4581: !_DWST [8] (maybe <- 0x2000164) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P4582: !_ST [3] (maybe <- 0x2000165) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4583: !_DWST [13] (maybe <- 0x2000166) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P4584: !_ST [0] (maybe <- 0x2000167) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4585: !_ST [1] (maybe <- 0x2000168) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4586: !_ST [13] (maybe <- 0x2000169) (Int) (CBR)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4586
nop
RET4586:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4587: !_CAS [15] (maybe <- 0x200016a) (Int)
add %i3, 192, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l3], %o5, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4588: !_DWST [10] (maybe <- 0x200016b) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P4589: !_CASX [11] (maybe <- 0x200016c) (Int)
add %i2, 64, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l7
or %l7, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %o5
or %o5, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
add  %l4, 1, %l4

P4590: !_PREFETCH [9] (Int) (Branch target of P4967)
prefetch [%i1 + 512], 1
ba P4591
nop

TARGET4967:
ba RET4967
nop


P4591: !_REPLACEMENT [3] (Int)
sethi %hi(0x20), %l7
or %l7, %lo(0x20),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4592: !_ST [4] (maybe <- 0x200016d) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4593: !_CAS [11] (maybe <- 0x200016e) (Int) (CBR)
add %i2, 64, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l4, %o3
cas [%l6], %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4593
nop
RET4593:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4594: !_CASX [10] (maybe <- 0x200016f) (Int)
add %i2, 32, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
mov  %l3, %l6
sllx %l4, 32, %l3
casx [%l7], %l6, %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
add  %l4, 1, %l4

P4595: !_ST [13] (maybe <- 0x2000170) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4596: !_DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0

P4597: !_PREFETCH [2] (Int) (CBR)
prefetch [%i0 + 12], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4597
nop
RET4597:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4598: !_ST [1] (maybe <- 0x2000171) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4599: !_ST [1] (maybe <- 0x2000172) (Int) (CBR)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4599
nop
RET4599:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4600: !_DWST [7] (maybe <- 0x4180001f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4601: !_CASX [10] (maybe <- 0x2000173) (Int) (CBR)
add %i2, 32, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l6
sllx %l4, 32, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4601
nop
RET4601:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4602: !_ST [0] (maybe <- 0x2000174) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4603: !_CASX [4] (maybe <- 0x2000175) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %l6
srl %l6, 8, %l6
sll %l4, 8, %o5
and %o5, %l7, %o5
or %o5, %l6, %o5
srl %o5, 16, %l6
sll %o5, 16, %o5
srl %o5, 0, %o5
or %o5, %l6, %o5
wr %g0, 0x88, %asi
add %i0, 64, %l7
ldxa [%l7] %asi, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %l6
or %l6, %o3, %o3
mov  %l3, %l6
mov  %o5, %l3
casxa [%l7] %asi, %l6, %l3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P4604: !_ST [2] (maybe <- 0x2000176) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4605: !_ST [1] (maybe <- 0x2000177) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4606: !_ST [6] (maybe <- 0x2000178) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4607: !_ST [14] (maybe <- 0x41800021) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P4608: !_DWLD [3] (Int)
ldx [%i0 + 32], %o0
! move %o0(upper) -> %o0(upper)

P4609: !_ST [0] (maybe <- 0x2000179) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4610: !_DWST [1] (maybe <- 0x200017a) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P4611: !_ST [0] (maybe <- 0x41800022) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P4612: !_DWST [4] (maybe <- 0x200017c) (Int) (CBR)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4612
nop
RET4612:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4613: !_ST [9] (maybe <- 0x200017d) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4614: !_ST [12] (maybe <- 0x200017e) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4615: !_ST [2] (maybe <- 0x200017f) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4616: !_LD [2] (Int)
lduw [%i0 + 12], %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l7, %o0, %o0

P4617: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4618: !_ST [11] (maybe <- 0x2000180) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4619: !_ST [10] (maybe <- 0x2000181) (Int) (CBR)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4619
nop
RET4619:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4620: !_ST [14] (maybe <- 0x2000182) (Int) (Branch target of P4489)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P4621
nop

TARGET4489:
ba RET4489
nop


P4621: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4622: !_PREFETCH [1] (Int) (Branch target of P4789)
prefetch [%i0 + 4], 1
ba P4623
nop

TARGET4789:
ba RET4789
nop


P4623: !_DWST [4] (maybe <- 0x2000183) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4624: !_ST [4] (maybe <- 0x2000184) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4625: !_DWST [1] (maybe <- 0x2000185) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4626: !_ST [2] (maybe <- 0x2000187) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4627: !_ST [1] (maybe <- 0x2000188) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4628: !_ST [15] (maybe <- 0x41800023) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P4629: !_ST [1] (maybe <- 0x2000189) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4630: !_DWST [5] (maybe <- 0x200018a) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P4631: !_REPLACEMENT [2] (Int)
sethi %hi(0xc), %l6
or %l6, %lo(0xc),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

P4632: !_CASX [2] (maybe <- 0x200018b) (Int)
add %i0, 8, %l6
ldx [%l6], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l3
mov %l4, %o2
casx [%l6], %l3, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P4633: !_ST [0] (maybe <- 0x200018c) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4634: !_REPLACEMENT [3] (Int) (CBR)
sethi %hi(0x20), %o5
or %o5, %lo(0x20),  %o5
sethi %hi(0x10000), %l3
or %l3, %lo(0x10000),  %l3
add %i3, %o5, %o5
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]
add %o5, %l3, %o5
ld [%o5], %l6
st %l6, [%o5]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4634
nop
RET4634:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4635: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4636: !_DWST [5] (maybe <- 0x200018d) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l6
srl %l6, 8, %l6
sll %l4, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3
srl %l3, 16, %l6
sll %l3, 16, %l3
srl %l3, 0, %l3
or %l3, %l6, %l3
sllx %l3, 32, %l3 
stxa %l3, [%i1 + 72 ] %asi
add   %l4, 1, %l4

P4637: !_ST [1] (maybe <- 0x200018e) (Int) (CBR) (Branch target of P4828)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4637
nop
RET4637:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P4638
nop

TARGET4828:
ba RET4828
nop


P4638: !_ST [1] (maybe <- 0x200018f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P4639: !_LD [13] (Int)
lduw [%i3 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4640: !_ST [5] (maybe <- 0x2000190) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4641: !_ST [11] (maybe <- 0x2000191) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4642: !_ST [12] (maybe <- 0x2000192) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i3 + 0] %asi
add   %l4, 1, %l4

P4643: !_ST [7] (maybe <- 0x2000193) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4644: !_ST [11] (maybe <- 0x2000194) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4645: !_REPLACEMENT [9] (Int)
sethi %hi(0x200), %l7
or %l7, %lo(0x200),  %l7
sethi %hi(0x10000), %o5
or %o5, %lo(0x10000),  %o5
add %i3, %l7, %l7
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]
add %l7, %o5, %l7
ld [%l7], %l3
st %l3, [%l7]

P4646: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4647: !_SWAP [15] (maybe <- 0x2000195) (Int)
mov %l4, %o5
swap  [%i3 + 192], %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P4648: !_ST [10] (maybe <- 0x41800024) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P4649: !_ST [8] (maybe <- 0x2000196) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4650: !_ST [1] (maybe <- 0x41800025) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4650
nop
RET4650:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4651: !_ST [5] (maybe <- 0x2000197) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4652: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4653: !_ST [6] (maybe <- 0x41800026) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P4654: !_MEMBAR (Int)
membar #StoreLoad

P4655: !_LD [12] (Int) (CBR)
lduw [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4655
nop
RET4655:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4656: !_CASX [10] (maybe <- 0x2000198) (Int) (LE)
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %l4, %l3, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l3, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
wr %g0, 0x88, %asi
add %i2, 32, %l3
ldxa [%l3] %asi, %l7
! move %l7(lower) -> %o4(lower)
srl %l7, 0, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l7(upper) -> %o0(upper)
or %l7, %g0, %o0
mov  %l7, %o5
mov  %l6, %l7
casxa [%l3] %asi, %o5, %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srl %l7, 0, %l3
or %l3, %o0, %o0
! move %l7(upper) -> %o1(upper)
or %l7, %g0, %o1
add  %l4, 1, %l4

P4657: !_ST [15] (maybe <- 0x41800027) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P4658: !_CASX [10] (maybe <- 0x2000199) (Int)
add %i2, 32, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l7
or %l7, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %o5
or %o5, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
add  %l4, 1, %l4

P4659: !_CASX [4] (maybe <- 0x200019a) (Int)
add %i0, 64, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l7
or %l7, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
mov  %l6, %l7
sllx %l4, 32, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o4(lower)
srlx %l6, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
! move %l6(lower) -> %o0(upper)
sllx %l6, 32, %o0
add  %l4, 1, %l4

P4660: !_ST [6] (maybe <- 0x200019b) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4661: !_DWST [13] (maybe <- 0x200019c) (Int) (Branch target of P4858)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P4662
nop

TARGET4858:
ba RET4858
nop


P4662: !_DWST [1] (maybe <- 0x200019d) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P4663: !_DWST [1] (maybe <- 0x200019f) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4664: !_ST [0] (maybe <- 0x20001a1) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4665: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4666: !_ST [15] (maybe <- 0x20001a2) (Int) (Branch target of P5021)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P4667
nop

TARGET5021:
ba RET5021
nop


P4667: !_ST [5] (maybe <- 0x20001a3) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4668: !_ST [11] (maybe <- 0x20001a4) (Int) (Branch target of P4553)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4
ba P4669
nop

TARGET4553:
ba RET4553
nop


P4669: !_DWST [11] (maybe <- 0x20001a5) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 64 ] 
add   %l4, 1, %l4

P4670: !_ST [0] (maybe <- 0x20001a6) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4671: !_DWST [14] (maybe <- 0x20001a7) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4672: !_ST [2] (maybe <- 0x20001a8) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4673: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4674: !_ST [13] (maybe <- 0x20001a9) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4675: !_DWST [10] (maybe <- 0x20001aa) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 32 ] 
add   %l4, 1, %l4

P4676: !_ST [9] (maybe <- 0x20001ab) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4677: !_DWST [0] (maybe <- 0x20001ac) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4678: !_CAS [14] (maybe <- 0x20001ae) (Int)
add %i3, 128, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0
mov %l4, %o1
cas [%o5], %l7, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4679: !_ST [11] (maybe <- 0x41800028) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P4680: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P4681: !_ST [9] (maybe <- 0x20001af) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4682: !_ST [8] (maybe <- 0x20001b0) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4683: !_LD [11] (FP)
ld [%i2 + 64], %f5
! 1 addresses covered

P4684: !_DWST [12] (maybe <- 0x20001b1) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P4685: !_ST [3] (maybe <- 0x20001b2) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4686: !_ST [12] (maybe <- 0x20001b3) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4687: !_DWST [8] (maybe <- 0x20001b4) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

P4688: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4689: !_REPLACEMENT [1] (Int) (CBR)
sethi %hi(0x4), %l6
or %l6, %lo(0x4),  %l6
sethi %hi(0x10000), %l7
or %l7, %lo(0x10000),  %l7
add %i3, %l6, %l6
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]
add %l6, %l7, %l6
ld [%l6], %o5
st %o5, [%l6]

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4689
nop
RET4689:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4690: !_DWST [4] (maybe <- 0x20001b5) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P4691: !_CAS [15] (maybe <- 0x20001b6) (Int) (Branch target of P4727)
add %i3, 192, %l6
lduw [%l6], %o2
mov %o2, %l3
! move %l3(lower) -> %o2(upper)
sllx %l3, 32, %o2
mov %l4, %o5
cas [%l6], %l3, %o5
! move %o5(lower) -> %o2(lower)
srl %o5, 0, %l6
or %l6, %o2, %o2
add   %l4, 1, %l4
ba P4692
nop

TARGET4727:
ba RET4727
nop


P4692: !_ST [5] (maybe <- 0x20001b7) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4693: !_DWST [2] (maybe <- 0x20001b8) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P4694: !_ST [13] (maybe <- 0x20001b9) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4695: !_ST [1] (maybe <- 0x20001ba) (Int) (Branch target of P4637)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P4696
nop

TARGET4637:
ba RET4637
nop


P4696: !_ST [8] (maybe <- 0x20001bb) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4697: !_ST [8] (maybe <- 0x20001bc) (Int) (Branch target of P4726)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4
ba P4698
nop

TARGET4726:
ba RET4726
nop


P4698: !_CASX [4] (maybe <- 0x20001bd) (Int)
add %i0, 64, %o5
ldx [%o5], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
mov  %o3, %l7
sllx %l4, 32, %o4
casx [%o5], %l7, %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
add  %l4, 1, %l4

P4699: !_CAS [4] (maybe <- 0x20001be) (Int)
add %i0, 64, %o5
lduw [%o5], %o0
mov %o0, %l7
! move %l7(lower) -> %o0(upper)
sllx %l7, 32, %o0
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P4700: !_ST [2] (maybe <- 0x20001bf) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4701: !_DWST [5] (maybe <- 0x20001c0) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P4702: !_ST [3] (maybe <- 0x20001c1) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4703: !_ST [3] (maybe <- 0x20001c2) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4704: !_CAS [11] (maybe <- 0x20001c3) (Int)
add %i2, 64, %o5
lduw [%o5], %o1
mov %o1, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P4705: !_PREFETCH [7] (Int) (Branch target of P4593)
prefetch [%i1 + 84], 1
ba P4706
nop

TARGET4593:
ba RET4593
nop


P4706: !_DWLD [15] (Int)
ldx [%i3 + 192], %o2
! move %o2(upper) -> %o2(upper)

P4707: !_REPLACEMENT [4] (Int)
sethi %hi(0x40), %l3
or %l3, %lo(0x40),  %l3
sethi %hi(0x10000), %l6
or %l6, %lo(0x10000),  %l6
add %i3, %l3, %l3
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]
add %l3, %l6, %l3
ld [%l3], %l7
st %l7, [%l3]

P4708: !_ST [3] (maybe <- 0x20001c4) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4709: !_CASX [5] (maybe <- 0x20001c5) (Int) (CBR)
add %i1, 72, %o5
ldx [%o5], %l6
! move %l6(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l6, 32, %l7
or %l7, %o2, %o2
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
mov  %l6, %l7
mov %l4, %l6
casx [%o5], %l7, %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %o5
or %o5, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4709
nop
RET4709:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4710: !_CAS [14] (maybe <- 0x20001c6) (Int)
add %i3, 128, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l3], %o5, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4711: !_ST [7] (maybe <- 0x20001c7) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4712: !_DWLD [2] (FP)
ldd [%i0 + 8], %f6
! 1 addresses covered
fmovs %f7, %f6

P4713: !_ST [13] (maybe <- 0x20001c8) (Int) (Branch target of P5009)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P4714
nop

TARGET5009:
ba RET5009
nop


P4714: !_DWLD [1] (Int)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l6
or %l6, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1

P4715: !_ST [7] (maybe <- 0x20001c9) (Int) (CBR) (Branch target of P4944)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4715
nop
RET4715:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P4716
nop

TARGET4944:
ba RET4944
nop


P4716: !_ST [12] (maybe <- 0x20001ca) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P4717: !_DWST [3] (maybe <- 0x20001cb) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P4718: !_ST [2] (maybe <- 0x20001cc) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4719: !_SWAP [15] (maybe <- 0x20001cd) (Int) (CBR)
mov %l4, %l7
swap  [%i3 + 192], %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4719
nop
RET4719:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4720: !_ST [11] (maybe <- 0x20001ce) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4721: !_ST [6] (maybe <- 0x20001cf) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P4722: !_PREFETCH [9] (Int) (Branch target of P4113)
prefetch [%i1 + 512], 1
ba P4723
nop

TARGET4113:
ba RET4113
nop


P4723: !_CAS [8] (maybe <- 0x20001d0) (Int)
add %i1, 256, %o5
lduw [%o5], %o2
mov %o2, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
mov %l4, %l6
cas [%o5], %l7, %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P4724: !_LD [15] (FP)
ld [%i3 + 192], %f7
! 1 addresses covered

P4725: !_ST [0] (maybe <- 0x20001d1) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P4726: !_ST [11] (maybe <- 0x20001d2) (Int) (CBR) (Branch target of P4162)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4726
nop
RET4726:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P4727
nop

TARGET4162:
ba RET4162
nop


P4727: !_DWST [13] (maybe <- 0x20001d3) (Int) (CBR) (Branch target of P4514)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4727
nop
RET4727:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P4728
nop

TARGET4514:
ba RET4514
nop


P4728: !_ST [14] (maybe <- 0x41800029) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 128 ]

P4729: !_DWST [11] (maybe <- 0x20001d4) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P4730: !_DWST [14] (maybe <- 0x4180002a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 128]

P4731: !_SWAP [12] (maybe <- 0x20001d5) (Int) (CBR)
mov %l4, %o3
swap  [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4731
nop
RET4731:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4732: !_ST [15] (maybe <- 0x20001d6) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7
or %l7, %l3, %l7
stwa   %l7, [%i3 + 192] %asi
add   %l4, 1, %l4

P4733: !_ST [2] (maybe <- 0x20001d7) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4734: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4735: !_NOP (Int)
nop

P4736: !_ST [2] (maybe <- 0x20001d8) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4737: !_DWST [15] (maybe <- 0x20001d9) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P4738: !_ST [13] (maybe <- 0x20001da) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P4739: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4740: !_ST [11] (maybe <- 0x20001db) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4741: !_ST [9] (maybe <- 0x20001dc) (Int) (Branch target of P4915)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4
ba P4742
nop

TARGET4915:
ba RET4915
nop


P4742: !_CAS [11] (maybe <- 0x20001dd) (Int)
add %i2, 64, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P4743: !_DWST [1] (maybe <- 0x20001de) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4744: !_LD [13] (Int) (Branch target of P5068)
lduw [%i3 + 64], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
ba P4745
nop

TARGET5068:
ba RET5068
nop


P4745: !_ST [4] (maybe <- 0x20001e0) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P4746: !_DWST [1] (maybe <- 0x4180002b) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P4747: !_ST [8] (maybe <- 0x20001e1) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4748: !_DWST [3] (maybe <- 0x20001e2) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4749: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4749
nop
RET4749:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4750: !_ST [14] (maybe <- 0x20001e3) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4751: !_DWST [4] (maybe <- 0x20001e4) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P4752: !_DWST [0] (maybe <- 0x20001e5) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P4753: !_ST [14] (maybe <- 0x20001e7) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4754: !_ST [4] (maybe <- 0x20001e8) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l7
or %l7, %lo(0xff00ff00), %l7
and %l4, %l7, %o5
srl %o5, 8, %o5
sll %l4, 8, %l6
and %l6, %l7, %l6
or %l6, %o5, %l6
srl %l6, 16, %o5
sll %l6, 16, %l6
srl %l6, 0, %l6
or %l6, %o5, %l6
stwa   %l6, [%i0 + 64] %asi
add   %l4, 1, %l4

P4755: !_ST [10] (maybe <- 0x20001e9) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4756: !_CAS [14] (maybe <- 0x20001ea) (Int)
add %i3, 128, %l3
lduw [%l3], %o0
mov %o0, %o5
! move %o5(lower) -> %o0(upper)
sllx %o5, 32, %o0
mov %l4, %l7
cas [%l3], %o5, %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l3
or %l3, %o0, %o0
add   %l4, 1, %l4

P4757: !_PREFETCH [1] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 4] %asi, 1

P4758: !_PREFETCH [6] (Int) (LE) (Branch target of P4999)
wr %g0, 0x88, %asi
prefetcha [%i1 + 80] %asi, 1
ba P4759
nop

TARGET4999:
ba RET4999
nop


P4759: !_PREFETCH [9] (Int) (CBR)
prefetch [%i1 + 512], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4759
nop
RET4759:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4760: !_ST [8] (maybe <- 0x20001eb) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P4761: !_DWST [13] (maybe <- 0x20001ec) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P4762: !_ST [3] (maybe <- 0x20001ed) (Int) (LE)
wr %g0, 0x88, %asi
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %l4, %o5, %l3
srl %l3, 8, %l3
sll %l4, 8, %l7
and %l7, %o5, %l7
or %l7, %l3, %l7
srl %l7, 16, %l3
sll %l7, 16, %l7
srl %l7, 0, %l7