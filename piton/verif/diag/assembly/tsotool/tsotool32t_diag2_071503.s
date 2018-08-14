// Modified by Princeton University on June 9th, 2015
/*
* ========== Copyright Header Begin ==========================================
* 
* OpenSPARC T1 Processor File: tsotool32t_diag2_071503.s
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
! TSOTOOL.N_PROCS 32
! TSOTOOL.TEST_NAME diag
! TSOTOOL.BATCH Y
! TSOTOOL.VERBOSE Y
! GEN.N_INSTR_PER_PROC 500
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
! WT.PCT_CBRANCH 5
! WT.PCT_SECONDARY_CTX 0
! WT.PCT_NUCLEUS_CTX 0
! WT.REPLACEMENT 10
! WT.INTERRUPT 0
! WT.LD 10
! WT.BLD 100
! WT.DWLD 10
! WT.QWLD 0
! WT.AQLD 0
! WT.ST 10
! WT.BST 100
! WT.BSTC 0
! WT.DWST 10
! WT.QWST 0
! WT.SWAP 3
! WT.CAS 5
! WT.CASX 5
! WT.ASI_L2_FLUSH 0
! WT.FLUSHI 0
! WT.MEMBAR 5
! WT.PREFETCH 100
! WT.NOP 1
! DBG.WRITE_RESULTS_FILE Y
! ADV.L2_WAYS 4
! ADV.TEST_ITERATIONS 1
! ADV.RESULTS_TO_MEM N
! ADV.BST_MEMBARS Y
! ADV.BLD_MEMBARS Y
! ADV.PREFETCH_FCNS fcn_1=5
! ADV.SAME_TEST_ALL_CPUS N
! ADV.ANALYSIS_EFFORT max
! ADV.ONLINE_PASSES 10
! GEN.SEED 17


#define N_CPUS  32
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
.align 64 ! for self bcopy()
res_buf_fp_p_8:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_8:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_9:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_9:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_10:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_10:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_11:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_11:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_12:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_12:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_13:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_13:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_14:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_14:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_15:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_15:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_16:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_16:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_17:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_17:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_18:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_18:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_19:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_19:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_20:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_20:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_21:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_21:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_22:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_22:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_23:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_23:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_24:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_24:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_25:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_25:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_26:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_26:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_27:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_27:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_28:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_28:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_29:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_29:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_30:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_30:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_fp_p_31:
	.skip RESULTS_BUF_SIZE_PER_CPU_RTL/2
.align 64 ! for self bcopy()
res_buf_int_p_31:
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
private_data_p8:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p9:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p10:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p11:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p12:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p13:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p14:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p15:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p16:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p17:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p18:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p19:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p20:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p21:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p22:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p23:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p24:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p25:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p26:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p27:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p28:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p29:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p30:
	.skip PRIVATE_DATA_AREA_PER_CPU_RTL
private_data_p31:
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
stack_top_p8:
	.skip 2048
stack_top_p9:
	.skip 2048
stack_top_p10:
	.skip 2048
stack_top_p11:
	.skip 2048
stack_top_p12:
	.skip 2048
stack_top_p13:
	.skip 2048
stack_top_p14:
	.skip 2048
stack_top_p15:
	.skip 2048
stack_top_p16:
	.skip 2048
stack_top_p17:
	.skip 2048
stack_top_p18:
	.skip 2048
stack_top_p19:
	.skip 2048
stack_top_p20:
	.skip 2048
stack_top_p21:
	.skip 2048
stack_top_p22:
	.skip 2048
stack_top_p23:
	.skip 2048
stack_top_p24:
	.skip 2048
stack_top_p25:
	.skip 2048
stack_top_p26:
	.skip 2048
stack_top_p27:
	.skip 2048
stack_top_p28:
	.skip 2048
stack_top_p29:
	.skip 2048
stack_top_p30:
	.skip 2048
stack_top_p31:
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
	.skip 4 * REGION_SIZE_RTL	 ! replacement area
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
	cmp     %g1, 0x1f
	be      setup_p31
	nop
	cmp     %g1, 0x1e
	be      setup_p30
	nop
	cmp     %g1, 0x1d
	be      setup_p29
	nop
	cmp     %g1, 0x1c
	be      setup_p28
	nop
	cmp     %g1, 0x1b
	be      setup_p27
	nop
	cmp     %g1, 0x1a
	be      setup_p26
	nop
	cmp     %g1, 0x19
	be      setup_p25
	nop
	cmp     %g1, 0x18
	be      setup_p24
	nop
	cmp     %g1, 0x17
	be      setup_p23
	nop
	cmp     %g1, 0x16
	be      setup_p22
	nop
	cmp     %g1, 0x15
	be      setup_p21
	nop
	cmp     %g1, 0x14
	be      setup_p20
	nop
	cmp     %g1, 0x13
	be      setup_p19
	nop
	cmp     %g1, 0x12
	be      setup_p18
	nop
	cmp     %g1, 0x11
	be      setup_p17
	nop
	cmp     %g1, 0x10
	be      setup_p16
	nop
	cmp     %g1, 0xf
	be      setup_p15
	nop
	cmp     %g1, 0xe
	be      setup_p14
	nop
	cmp     %g1, 0xd
	be      setup_p13
	nop
	cmp     %g1, 0xc
	be      setup_p12
	nop
	cmp     %g1, 0xb
	be      setup_p11
	nop
	cmp     %g1, 0xa
	be      setup_p10
	nop
	cmp     %g1, 0x9
	be      setup_p9
	nop
	cmp     %g1, 0x8
	be      setup_p8
	nop
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

setup_p8:
	set     stack_top_p8, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_8, %o4
	set     private_data_p8, %o5
	set     func8, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p9:
	set     stack_top_p9, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_9, %o4
	set     private_data_p9, %o5
	set     func9, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p10:
	set     stack_top_p10, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_10, %o4
	set     private_data_p10, %o5
	set     func10, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p11:
	set     stack_top_p11, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_11, %o4
	set     private_data_p11, %o5
	set     func11, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p12:
	set     stack_top_p12, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_12, %o4
	set     private_data_p12, %o5
	set     func12, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p13:
	set     stack_top_p13, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_13, %o4
	set     private_data_p13, %o5
	set     func13, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p14:
	set     stack_top_p14, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_14, %o4
	set     private_data_p14, %o5
	set     func14, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p15:
	set     stack_top_p15, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_15, %o4
	set     private_data_p15, %o5
	set     func15, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p16:
	set     stack_top_p16, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_16, %o4
	set     private_data_p16, %o5
	set     func16, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p17:
	set     stack_top_p17, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_17, %o4
	set     private_data_p17, %o5
	set     func17, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p18:
	set     stack_top_p18, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_18, %o4
	set     private_data_p18, %o5
	set     func18, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p19:
	set     stack_top_p19, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_19, %o4
	set     private_data_p19, %o5
	set     func19, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p20:
	set     stack_top_p20, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_20, %o4
	set     private_data_p20, %o5
	set     func20, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p21:
	set     stack_top_p21, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_21, %o4
	set     private_data_p21, %o5
	set     func21, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p22:
	set     stack_top_p22, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_22, %o4
	set     private_data_p22, %o5
	set     func22, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p23:
	set     stack_top_p23, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_23, %o4
	set     private_data_p23, %o5
	set     func23, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p24:
	set     stack_top_p24, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_24, %o4
	set     private_data_p24, %o5
	set     func24, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p25:
	set     stack_top_p25, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_25, %o4
	set     private_data_p25, %o5
	set     func25, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p26:
	set     stack_top_p26, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_26, %o4
	set     private_data_p26, %o5
	set     func26, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p27:
	set     stack_top_p27, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_27, %o4
	set     private_data_p27, %o5
	set     func27, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p28:
	set     stack_top_p28, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_28, %o4
	set     private_data_p28, %o5
	set     func28, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p29:
	set     stack_top_p29, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_29, %o4
	set     private_data_p29, %o5
	set     func29, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p30:
	set     stack_top_p30, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_30, %o4
	set     private_data_p30, %o5
	set     func30, %l4
	call    %l4
	nop
	EXIT_GOOD
	nop

setup_p31:
	set     stack_top_p31, %l1
	add     %l1, 1024, %sp
	set     res_buf_fp_p_31, %o4
	set     private_data_p31, %o5
	set     func31, %l4
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
! 500 (dynamic) instruction sequence begins
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

! Initialize LFSR to 0x253^4
sethi %hi(0x253), %l0
or    %l0, %lo(0x253), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 0 to -1 ---

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l7
add %i3, %l7, %l7
sub %l7, -4096, %l7

!-- master of sync_init ---
or %g0, 31, %o5
swap [%l7], %o5
sync_init_0:
swap [%l7+4], %g0
lduw [%l7], %o5
brnz,pt %o5, sync_init_0
membar #Sync ! delay slot
!-- end of sync_init ---


BEGIN_NODES0: ! Test istream for CPU 0 begins

P1: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered

P2: !_ST [9] (maybe <- 0x1) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3: !_BST [1] (maybe <- 0x3f800001) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4: !_BST [4] (maybe <- 0x3f800005) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4
nop
RET4:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P5: !_BLD [0] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET5
nop
RET5:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P6: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P7: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P8: !_BST [1] (maybe <- 0x3f800006) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P9: !_ST [7] (maybe <- 0x2) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P10: !_CASX [4] (maybe <- 0x3) (Int)
add %i0, 64, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P11: !_LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P12: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P13: !_BST [10] (maybe <- 0x3f80000a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P14: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P15: !_BST [14] (maybe <- 0x3f80000b) (FP) (Branch target of P74)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 
ba P16
nop

TARGET74:
ba RET74
nop


P16: !_REPLACEMENT [3] (Int) (Branch target of P190)
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
ba P17
nop

TARGET190:
ba RET190
nop


P17: !_PREFETCH [1] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 4] %asi, 1

P18: !_LD [14] (Int)
lduw [%i3 + 128], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P19: !_ST [6] (maybe <- 0x4) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P20: !_BST [4] (maybe <- 0x3f80000c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P21: !_LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P22: !_DWST [11] (maybe <- 0x5) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 64 ] 
add   %l4, 1, %l4

P23: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P24: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P25: !_CASX [8] (maybe <- 0x6) (Int)
add %i1, 256, %o5
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

P26: !_BST [5] (maybe <- 0x3f80000d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P27: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P28: !_BST [9] (maybe <- 0x3f800010) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P29: !_BST [7] (maybe <- 0x3f800011) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P30: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P31: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P32: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P33: !_BLD [6] (FP) (Branch target of P206)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10
ba P34
nop

TARGET206:
ba RET206
nop


P34: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P35: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P36: !_BST [14] (maybe <- 0x3f800014) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P37: !_BST [4] (maybe <- 0x3f800015) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P38: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P39: !_CAS [2] (maybe <- 0x7) (Int)
add %i0, 12, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P40: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P41: !_BST [7] (maybe <- 0x3f800016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P42: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P43: !_BST [3] (maybe <- 0x3f800019) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P44: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P45: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P46: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P47: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P48: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P49: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P50: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P51: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P52: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P53: !_PREFETCH [15] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

P54: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P55: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P56: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P57: !_BST [11] (maybe <- 0x3f80001d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P58: !_REPLACEMENT [8] (Int)
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

P59: !_BST [11] (maybe <- 0x3f80001e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P60: !_BLD [5] (FP) (CBR) (Branch target of P239)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET60
nop
RET60:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P61
nop

TARGET239:
ba RET239
nop


P61: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P62: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P63: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P64: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P65: !_PREFETCH [3] (Int) (Branch target of P5)
prefetch [%i0 + 32], 1
ba P66
nop

TARGET5:
ba RET5
nop


P66: !_BST [3] (maybe <- 0x3f80001f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P67: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P68: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P69: !_BLD [2] (FP) (Branch target of P115)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7
ba P70
nop

TARGET115:
ba RET115
nop


P70: !_DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o1(lower)
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P71: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P72: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P73: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P74: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET74
nop
RET74:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P75: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P76: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P77: !_SWAP [15] (maybe <- 0x8) (Int)
mov %l4, %o3
swap  [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P78: !_DWST [6] (maybe <- 0x9) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P79: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P80: !_BST [13] (maybe <- 0x3f800023) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P81: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P82: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P83: !_BST [14] (maybe <- 0x3f800024) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P84: !_BST [4] (maybe <- 0x3f800025) (FP) (Branch target of P465)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 
ba P85
nop

TARGET465:
ba RET465
nop


P85: !_BST [5] (maybe <- 0x3f800026) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P86: !_BST [6] (maybe <- 0x3f800029) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P87: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P88: !_BST [8] (maybe <- 0x3f80002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P89: !_BST [2] (maybe <- 0x3f80002d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P90: !_CAS [10] (maybe <- 0xb) (Int)
add %i2, 32, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3
mov %l4, %o4
cas [%l6], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P91: !_BST [11] (maybe <- 0x3f800031) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P92: !_BST [15] (maybe <- 0x3f800032) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P93: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P94: !_BST [6] (maybe <- 0x3f800033) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P95: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P96: !_BST [5] (maybe <- 0x3f800036) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P97: !_BST [3] (maybe <- 0x3f800039) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P98: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P99: !_BST [8] (maybe <- 0x3f80003d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P100: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P101: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P102: !_BST [0] (maybe <- 0x3f80003e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P103: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P104: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P105: !_LD [8] (Int)
lduw [%i1 + 256], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P106: !_REPLACEMENT [15] (Int)
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

P107: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P108: !_DWST [13] (maybe <- 0xc) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

P109: !_BST [0] (maybe <- 0x3f800042) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P110: !_BST [5] (maybe <- 0x3f800046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P111: !_DWST [12] (maybe <- 0xd) (Int) (LE)
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

P112: !_CASX [4] (maybe <- 0xe) (Int)
add %i0, 64, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P113: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P114: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P115: !_DWLD [2] (Int) (CBR)
ldx [%i0 + 8], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET115
nop
RET115:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P116: !_BST [4] (maybe <- 0x3f800049) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P117: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P118: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P119: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P120: !_BST [11] (maybe <- 0x3f80004a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P121: !_BST [11] (maybe <- 0x3f80004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P122: !_BST [0] (maybe <- 0x3f80004c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P123: !_REPLACEMENT [3] (Int)
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

P124: !_DWST [5] (maybe <- 0xf) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P125: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P126: !_DWST [1] (maybe <- 0x10) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P127: !_BST [8] (maybe <- 0x3f800050) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P128: !_BST [13] (maybe <- 0x3f800051) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P129: !_LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P130: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P131: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f9

P132: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P133: !_BST [9] (maybe <- 0x3f800052) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P134: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P135: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P136: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P137: !_DWLD [14] (FP)
ldd [%i3 + 128], %f18
! 1 addresses covered
fmovs %f18, %f5

P138: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P139: !_BST [7] (maybe <- 0x3f800053) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P140: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P141: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P142: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P143: !_BST [2] (maybe <- 0x3f800056) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P144: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P145: !_BST [6] (maybe <- 0x3f80005a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P146: !_DWST [6] (maybe <- 0x12) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P147: !_BST [9] (maybe <- 0x3f80005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P148: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P149: !_DWST [14] (maybe <- 0x14) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P150: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P151: !_PREFETCH [13] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 64] %asi, 1

P152: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P153: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P154: !_BST [4] (maybe <- 0x3f80005e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P155: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P156: !_BST [11] (maybe <- 0x3f80005f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P157: !_PREFETCH [10] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 32] %asi, 1

P158: !_BST [9] (maybe <- 0x3f800060) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P159: !_MEMBAR (Int) (CBR)
membar #StoreLoad

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET159
nop
RET159:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P160: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P161: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P162: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P163: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P164: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P165: !_DWLD [6] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P166: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P167: !_REPLACEMENT [9] (Int)
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

P168: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P169: !_PREFETCH [14] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 128] %asi, 1

P170: !_LD [12] (Int)
lduw [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P171: !_LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P172: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P173: !_REPLACEMENT [3] (Int)
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

P174: !_REPLACEMENT [3] (Int)
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

P175: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P176: !_BST [6] (maybe <- 0x3f800061) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P177: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P178: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P179: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P180: !_BST [12] (maybe <- 0x3f800064) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P181: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P182: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P183: !_BST [14] (maybe <- 0x3f800065) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P184: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P185: !_LD [5] (FP)
ld [%i1 + 76], %f8
! 1 addresses covered

P186: !_BST [13] (maybe <- 0x3f800066) (FP) (Branch target of P336)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 
ba P187
nop

TARGET336:
ba RET336
nop


P187: !_BST [9] (maybe <- 0x3f800067) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P188: !_DWLD [15] (Int)
ldx [%i3 + 192], %o0
! move %o0(upper) -> %o0(upper)

P189: !_BST [8] (maybe <- 0x3f800068) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P190: !_BST [8] (maybe <- 0x3f800069) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET190
nop
RET190:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P191: !_DWLD [0] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P192: !_BST [6] (maybe <- 0x3f80006a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P193: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P194: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P195: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P196: !_DWLD [11] (Int)
ldx [%i2 + 64], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l6
or %l6, %o1, %o1

P197: !_BST [2] (maybe <- 0x3f80006d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P198: !_MEMBAR (Int)
membar #StoreLoad

P199: !_BLD [13] (FP) (Branch target of P411)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
ba P200
nop

TARGET411:
ba RET411
nop


P200: !_BST [13] (maybe <- 0x3f800071) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P201: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P202: !_BST [7] (maybe <- 0x3f800072) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P203: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P204: !_BST [11] (maybe <- 0x3f800075) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P205: !_BST [7] (maybe <- 0x3f800076) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P206: !_LD [9] (Int) (CBR)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET206
nop
RET206:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P207: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P208: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P209: !_BST [7] (maybe <- 0x3f800079) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P210: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P211: !_BST [12] (maybe <- 0x3f80007c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P212: !_BLD [2] (FP) (Branch target of P361)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9
ba P213
nop

TARGET361:
ba RET361
nop


P213: !_ST [11] (maybe <- 0x3f80007d) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 64 ]

P214: !_LD [2] (Int)
lduw [%i0 + 12], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P215: !_MEMBAR (Int)
membar #StoreLoad

P216: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P217: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P218: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P219: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P220: !_CAS [6] (maybe <- 0x15) (Int)
add %i1, 80, %l6
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

P221: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P222: !_BST [2] (maybe <- 0x3f80007e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P223: !_LD [9] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i1 + 512] %asi, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P224: !_BST [8] (maybe <- 0x3f800082) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P225: !_BST [9] (maybe <- 0x3f800083) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P226: !_BST [8] (maybe <- 0x3f800084) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P227: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P228: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P229: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P230: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P231: !_BLD [13] (FP) (Branch target of P308)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6
ba P232
nop

TARGET308:
ba RET308
nop


P232: !_DWST [12] (maybe <- 0x16) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P233: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P234: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P235: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P236: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P237: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P238: !_BST [1] (maybe <- 0x3f800085) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P239: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET239
nop
RET239:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P240: !_BST [8] (maybe <- 0x3f800089) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P241: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P242: !_BST [9] (maybe <- 0x3f80008a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P243: !_LD [12] (Int)
lduw [%i3 + 0], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P244: !_BST [3] (maybe <- 0x3f80008b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P245: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P246: !_LD [2] (Int)
lduw [%i0 + 12], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P247: !_BST [10] (maybe <- 0x3f80008f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P248: !_BST [15] (maybe <- 0x3f800090) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P249: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P250: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P251: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P252: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P253: !_DWLD [4] (Int)
ldx [%i0 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0

P254: !_BST [13] (maybe <- 0x3f800091) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P255: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P256: !_BST [1] (maybe <- 0x3f800092) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P257: !_ST [5] (maybe <- 0x17) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P258: !_BST [13] (maybe <- 0x3f800096) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P259: !_DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P260: !_DWLD [1] (Int)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l6, 32, %l3
or %l3, %o1, %o1
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P261: !_BST [11] (maybe <- 0x3f800097) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P262: !_DWLD [1] (Int)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3

P263: !_DWLD [4] (Int)
ldx [%i0 + 64], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %o5
or %o5, %o3, %o3

P264: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P265: !_BST [1] (maybe <- 0x3f800098) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P266: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P267: !_REPLACEMENT [11] (Int)
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

P268: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P269: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P270: !_BST [8] (maybe <- 0x3f80009c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P271: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P272: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P273: !_BST [10] (maybe <- 0x3f80009d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P274: !_BST [1] (maybe <- 0x3f80009e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P275: !_BST [9] (maybe <- 0x3f8000a2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P276: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P277: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P278: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P279: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P280: !_DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P281: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P282: !_CAS [15] (maybe <- 0x18) (Int)
add %i3, 192, %l7
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

P283: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P284: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P285: !_PREFETCH [0] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1

P286: !_BST [5] (maybe <- 0x3f8000a3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P287: !_BST [1] (maybe <- 0x3f8000a6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P288: !_PREFETCH [2] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

P289: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P290: !_DWST [14] (maybe <- 0x19) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P291: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P292: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P293: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P294: !_CAS [13] (maybe <- 0x1a) (Int)
add %i3, 64, %o5
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

P295: !_BST [7] (maybe <- 0x3f8000aa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P296: !_REPLACEMENT [7] (Int)
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

P297: !_BST [1] (maybe <- 0x3f8000ad) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P298: !_BST [11] (maybe <- 0x3f8000b1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P299: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P300: !_REPLACEMENT [8] (Int)
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

P301: !_BST [14] (maybe <- 0x3f8000b2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P302: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P303: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P304: !_BST [12] (maybe <- 0x3f8000b3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P305: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P306: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P307: !_BST [15] (maybe <- 0x3f8000b4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P308: !_BST [15] (maybe <- 0x3f8000b5) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET308
nop
RET308:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P309: !_BST [13] (maybe <- 0x3f8000b6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P310: !_BST [13] (maybe <- 0x3f8000b7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P311: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P312: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P313: !_BST [0] (maybe <- 0x3f8000b8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P314: !_CAS [12] (maybe <- 0x1b) (Int)
add %i3, 0, %l3
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

P315: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P316: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P317: !_DWST [7] (maybe <- 0x1c) (Int) (CBR)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET317
nop
RET317:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P318: !_BST [2] (maybe <- 0x3f8000bc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P319: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P320: !_MEMBAR (Int)
membar #StoreLoad

P321: !_DWST [4] (maybe <- 0x1e) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P322: !_SWAP [14] (maybe <- 0x1f) (Int)
mov %l4, %o3
swap  [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P323: !_ST [2] (maybe <- 0x3f8000c0) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P324: !_DWST [5] (maybe <- 0x20) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P325: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P326: !_BLD [14] (FP) (Branch target of P159)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
ba P327
nop

TARGET159:
ba RET159
nop


P327: !_ST [2] (maybe <- 0x21) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P328: !_DWLD [12] (Int)
ldx [%i3 + 0], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l6
or %l6, %o3, %o3

P329: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P330: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P331: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P332: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P333: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P334: !_BST [15] (maybe <- 0x3f8000c1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P335: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P336: !_BLD [14] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET336
nop
RET336:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P337: !_PREFETCH [10] (Int) (Branch target of P482)
prefetch [%i2 + 32], 1
ba P338
nop

TARGET482:
ba RET482
nop


P338: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P339: !_BST [4] (maybe <- 0x3f8000c2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P340: !_CAS [2] (maybe <- 0x22) (Int)
add %i0, 12, %o5
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

P341: !_BST [11] (maybe <- 0x3f8000c3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P342: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P343: !_BST [7] (maybe <- 0x3f8000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P344: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P345: !_BLD [8] (FP) (Branch target of P60)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
ba P346
nop

TARGET60:
ba RET60
nop


P346: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P347: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P348: !_BST [14] (maybe <- 0x3f8000c7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P349: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P350: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P351: !_DWST [10] (maybe <- 0x23) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i2 + 32 ] 
add   %l4, 1, %l4

P352: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P353: !_BST [12] (maybe <- 0x3f8000c8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P354: !_DWST [6] (maybe <- 0x24) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P355: !_BST [6] (maybe <- 0x3f8000c9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P356: !_SWAP [14] (maybe <- 0x26) (Int)
mov %l4, %o0
swap  [%i3 + 128], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P357: !_BST [15] (maybe <- 0x3f8000cc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P358: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P359: !_LD [0] (Int)
lduw [%i0 + 0], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P360: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P361: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET361
nop
RET361:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P362: !_DWST [3] (maybe <- 0x27) (Int) (Branch target of P317)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 32 ] 
add   %l4, 1, %l4
ba P363
nop

TARGET317:
ba RET317
nop


P363: !_BST [0] (maybe <- 0x3f8000cd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P364: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P365: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P366: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P367: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P368: !_MEMBAR (Int)
membar #StoreLoad

P369: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P370: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P371: !_BST [4] (maybe <- 0x3f8000d1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P372: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P373: !_DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P374: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P375: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P376: !_BST [7] (maybe <- 0x3f8000d2) (FP) (Branch target of P4)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P377
nop

TARGET4:
ba RET4
nop


P377: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P378: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P379: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P380: !_DWST [3] (maybe <- 0x28) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P381: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P382: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P383: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered

P384: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P385: !_CASX [11] (maybe <- 0x29) (Int)
add %i2, 64, %l7
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

P386: !_BST [2] (maybe <- 0x3f8000d5) (FP) (Branch target of P485)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P387
nop

TARGET485:
ba RET485
nop


P387: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f4

P388: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P389: !_BST [1] (maybe <- 0x3f8000d9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P390: !_BST [11] (maybe <- 0x3f8000dd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P391: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P392: !_BST [4] (maybe <- 0x3f8000de) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P393: !_BST [3] (maybe <- 0x3f8000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P394: !_BST [8] (maybe <- 0x3f8000e3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P395: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P396: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P397: !_DWST [8] (maybe <- 0x2a) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i1 + 256 ] 
add   %l4, 1, %l4

P398: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P399: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P400: !_BLD [14] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET400
nop
RET400:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P401: !_BST [1] (maybe <- 0x3f8000e4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P402: !_BST [7] (maybe <- 0x3f8000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P403: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P404: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P405: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P406: !_BST [11] (maybe <- 0x3f8000eb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P407: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P408: !_BST [7] (maybe <- 0x3f8000ec) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P409: !_BST [13] (maybe <- 0x3f8000ef) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P410: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P411: !_BLD [0] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET411
nop
RET411:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P412: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P413: !_BST [4] (maybe <- 0x3f8000f0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P414: !_BST [14] (maybe <- 0x3f8000f1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P415: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P416: !_BST [6] (maybe <- 0x3f8000f2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P417: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P418: !_BST [15] (maybe <- 0x3f8000f5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P419: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P420: !_BST [15] (maybe <- 0x3f8000f6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P421: !_BST [7] (maybe <- 0x3f8000f7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P422: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P423: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P424: !_ST [13] (maybe <- 0x2b) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P425: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P426: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P427: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P428: !_BLD [8] (FP) (Branch target of P400)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
ba P429
nop

TARGET400:
ba RET400
nop


P429: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P430: !_LD [11] (FP)
ld [%i2 + 64], %f14
! 1 addresses covered

P431: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P432: !_BST [2] (maybe <- 0x3f8000fa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P433: !_DWLD [6] (Int)
ldx [%i1 + 80], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %o5
or %o5, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4

P434: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P435: !_DWST [9] (maybe <- 0x3f8000fe) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i1 + 512]

P436: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P437: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P438: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P439: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P440: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P441: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

P442: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P443: !_BST [2] (maybe <- 0x3f8000ff) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P444: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P445: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P446: !_BST [12] (maybe <- 0x3f800103) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P447: !_REPLACEMENT [3] (Int)
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

P448: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P449: !_BST [2] (maybe <- 0x3f800104) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P450: !_BST [10] (maybe <- 0x3f800108) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P451: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P452: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P453: !_BST [13] (maybe <- 0x3f800109) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P454: !_BST [10] (maybe <- 0x3f80010a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P455: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P456: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P457: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P458: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P459: !_DWST [4] (maybe <- 0x2c) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P460: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P461: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P462: !_BST [0] (maybe <- 0x3f80010b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P463: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P464: !_CAS [13] (maybe <- 0x2d) (Int)
add %i3, 64, %l3
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

P465: !_BST [3] (maybe <- 0x3f80010f) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET465
nop
RET465:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P466: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P467: !_BST [3] (maybe <- 0x3f800113) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P468: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P469: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P470: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P471: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P472: !_BST [5] (maybe <- 0x3f800117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P473: !_SWAP [5] (maybe <- 0x2e) (Int)
mov %l4, %o5
swap  [%i1 + 76], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l6
or %l6, %o0, %o0
add   %l4, 1, %l4

P474: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P475: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P476: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P477: !_BST [13] (maybe <- 0x3f80011a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P478: !_BST [9] (maybe <- 0x3f80011b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P479: !_BST [3] (maybe <- 0x3f80011c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P480: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P481: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P482: !_BLD [6] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET482
nop
RET482:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P483: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P484: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P485: !_PREFETCH [15] (Int) (CBR)
prefetch [%i3 + 192], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET485
nop
RET485:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P486: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P487: !_DWST [1] (maybe <- 0x2f) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P488: !_ST [0] (maybe <- 0x31) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P489: !_BST [9] (maybe <- 0x3f800120) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P490: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P491: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P492: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P493: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P494: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P495: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P496: !_BST [14] (maybe <- 0x3f800121) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P497: !_PREFETCH [15] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

P498: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P499: !_BST [3] (maybe <- 0x3f800122) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P500: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P501: !_MEMBAR (Int)
membar #StoreLoad

P502: !_LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P503: !_LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P504: !_LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P505: !_LD [3] (Int)
lduw [%i0 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P506: !_LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P507: !_LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P508: !_LD [6] (Int)
lduw [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P509: !_LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P510: !_LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P511: !_LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P512: !_LD [10] (Int)
lduw [%i2 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P513: !_LD [11] (Int)
lduw [%i2 + 64], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P514: !_LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P515: !_LD [13] (Int)
lduw [%i3 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P516: !_LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P517: !_LD [15] (Int)
lduw [%i3 + 192], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

END_NODES0: ! Test istream for CPU 0 ends
sethi %hi(0xdead0e0f), %l7
or    %l7, %lo(0xdead0e0f), %l7
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4
stw %l7, [%i5] 
ld [%i5], %f10
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
!---- flushing fp results buffer to %f30 ----
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
! 500 (dynamic) instruction sequence begins
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

! Initialize LFSR to 0x1567^4
sethi %hi(0x1567), %l0
or    %l0, %lo(0x1567), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 0 to 0 ---
stx %g0, [%i0+0]

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

P518: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P519: !_DWST [8] (maybe <- 0x800001) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P520: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P521: !_DWLD [11] (Int)
ldx [%i2 + 64], %o0
! move %o0(upper) -> %o0(upper)

P522: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P523: !_BST [9] (maybe <- 0x40000001) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P524: !_DWST [1] (maybe <- 0x800002) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P525: !_BST [4] (maybe <- 0x40000002) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P526: !_BST [6] (maybe <- 0x40000003) (FP) (Branch target of P707)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P527
nop

TARGET707:
ba RET707
nop


P527: !_BST [1] (maybe <- 0x40000006) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P528: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P529: !_DWST [7] (maybe <- 0x4000000a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P530: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P531: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P532: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P533: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P534: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P535: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P536: !_DWLD [6] (Int)
ldx [%i1 + 80], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l3
or %l3, %o0, %o0
! move %l6(lower) -> %o1(upper)
sllx %l6, 32, %o1

P537: !_BST [2] (maybe <- 0x4000000c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P538: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P539: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P540: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P541: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P542: !_DWLD [14] (Int)
ldx [%i3 + 128], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l6
or %l6, %o1, %o1

P543: !_REPLACEMENT [8] (Int)
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

P544: !_PREFETCH [6] (Int) (CBR) (Branch target of P680)
prefetch [%i1 + 80], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET544
nop
RET544:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P545
nop

TARGET680:
ba RET680
nop


P545: !_PREFETCH [6] (Int) (CBR)
prefetch [%i1 + 80], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET545
nop
RET545:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P546: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P547: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P548: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P549: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P550: !_BLD [6] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET550
nop
RET550:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P551: !_PREFETCH [11] (Int) (CBR)
prefetch [%i2 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET551
nop
RET551:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P552: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P553: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P554: !_BST [12] (maybe <- 0x40000010) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P555: !_BST [5] (maybe <- 0x40000011) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P556: !_BST [0] (maybe <- 0x40000014) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P557: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P558: !_CAS [10] (maybe <- 0x800004) (Int)
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

P559: !_BST [5] (maybe <- 0x40000018) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P560: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P561: !_BST [5] (maybe <- 0x4000001b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P562: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P563: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P564: !_BLD [0] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET564
nop
RET564:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P565: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P566: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P567: !_BST [15] (maybe <- 0x4000001e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P568: !_LD [8] (Int)
lduw [%i1 + 256], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P569: !_MEMBAR (Int)
membar #StoreLoad

P570: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P571: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P572: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P573: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P574: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P575: !_ST [7] (maybe <- 0x4000001f) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P576: !_BST [12] (maybe <- 0x40000020) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P577: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P578: !_BST [11] (maybe <- 0x40000021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P579: !_BST [3] (maybe <- 0x40000022) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P580: !_NOP (Int)
nop

P581: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P582: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P583: !_DWLD [1] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %o5
or %o5, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4

P584: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P585: !_BST [15] (maybe <- 0x40000026) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P586: !_BST [5] (maybe <- 0x40000027) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P587: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P588: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P589: !_SWAP [2] (maybe <- 0x800005) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
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

P590: !_CAS [6] (maybe <- 0x800006) (Int)
add %i1, 80, %o5
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

P591: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P592: !_BST [0] (maybe <- 0x4000002a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P593: !_ST [2] (maybe <- 0x800007) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P594: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P595: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P596: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET596
nop
RET596:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P597: !_BST [0] (maybe <- 0x4000002e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P598: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P599: !_BST [3] (maybe <- 0x40000032) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P600: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P601: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P602: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P603: !_BLD [3] (FP) (Branch target of P545)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7
ba P604
nop

TARGET545:
ba RET545
nop


P604: !_CASX [6] (maybe <- 0x800008) (Int)
add %i1, 80, %l3
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

P605: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P606: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f9

P607: !_BLD [10] (FP) (Branch target of P934)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f10
ba P608
nop

TARGET934:
ba RET934
nop


P608: !_BST [0] (maybe <- 0x40000036) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P609: !_BST [8] (maybe <- 0x4000003a) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET609
nop
RET609:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P610: !_BST [10] (maybe <- 0x4000003b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P611: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P612: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P613: !_BST [8] (maybe <- 0x4000003c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P614: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P615: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P616: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P617: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P618: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P619: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f12

P620: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P621: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P622: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P623: !_BST [9] (maybe <- 0x4000003d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P624: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P625: !_BST [4] (maybe <- 0x4000003e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P626: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P627: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P628: !_BST [0] (maybe <- 0x4000003f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P629: !_LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P630: !_BST [7] (maybe <- 0x40000043) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P631: !_BLD [11] (FP) (Branch target of P847)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
ba P632
nop

TARGET847:
ba RET847
nop


P632: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P633: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P634: !_BST [12] (maybe <- 0x40000046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P635: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P636: !_LD [4] (Int)
lduw [%i0 + 64], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P637: !_BST [10] (maybe <- 0x40000047) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P638: !_DWST [5] (maybe <- 0x80000a) (Int) (Branch target of P993)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4
ba P639
nop

TARGET993:
ba RET993
nop


P639: !_BST [7] (maybe <- 0x40000048) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P640: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P641: !_CAS [8] (maybe <- 0x80000b) (Int)
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

P642: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P643: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P644: !_BST [0] (maybe <- 0x4000004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P645: !_BST [14] (maybe <- 0x4000004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P646: !_BST [10] (maybe <- 0x40000050) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P647: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P648: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P649: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P650: !_CASX [5] (maybe <- 0x80000c) (Int)
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

P651: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P652: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P653: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P654: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P655: !_BST [12] (maybe <- 0x40000051) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET655
nop
RET655:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P656: !_BST [10] (maybe <- 0x40000052) (FP) (Branch target of P609)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 
ba P657
nop

TARGET609:
ba RET609
nop


P657: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P658: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P659: !_BST [5] (maybe <- 0x40000053) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P660: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P661: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P662: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P663: !_DWLD [5] (Int)
ldx [%i1 + 72], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P664: !_BST [5] (maybe <- 0x40000056) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P665: !_BST [0] (maybe <- 0x40000059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P666: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P667: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P668: !_BST [7] (maybe <- 0x4000005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P669: !_BST [12] (maybe <- 0x40000060) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P670: !_PREFETCH [3] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 32] %asi, 1

P671: !_BST [14] (maybe <- 0x40000061) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P672: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P673: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P674: !_REPLACEMENT [14] (Int)
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

P675: !_BST [3] (maybe <- 0x40000062) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P676: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P677: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P678: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P679: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P680: !_BST [0] (maybe <- 0x40000066) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET680
nop
RET680:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P681: !_BST [6] (maybe <- 0x4000006a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P682: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P683: !_BST [1] (maybe <- 0x4000006d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P684: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P685: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P686: !_BST [1] (maybe <- 0x40000071) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P687: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P688: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P689: !_BST [10] (maybe <- 0x40000075) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P690: !_BST [5] (maybe <- 0x40000076) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P691: !_BST [0] (maybe <- 0x40000079) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P692: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P693: !_DWST [8] (maybe <- 0x80000d) (Int) (Branch target of P828)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4
ba P694
nop

TARGET828:
ba RET828
nop


P694: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P695: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P696: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P697: !_ST [10] (maybe <- 0x80000e) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P698: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P699: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P700: !_BST [0] (maybe <- 0x4000007d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P701: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P702: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P703: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P704: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P705: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P706: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P707: !_BLD [5] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET707
nop
RET707:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P708: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P709: !_BST [10] (maybe <- 0x40000081) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P710: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P711: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P712: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P713: !_BST [10] (maybe <- 0x40000082) (FP) (Branch target of P1032)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 
ba P714
nop

TARGET1032:
ba RET1032
nop


P714: !_BST [13] (maybe <- 0x40000083) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P715: !_BST [13] (maybe <- 0x40000084) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P716: !_BST [12] (maybe <- 0x40000085) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P717: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P718: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P719: !_BST [11] (maybe <- 0x40000086) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P720: !_ST [15] (maybe <- 0x80000f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P721: !_CASX [10] (maybe <- 0x800010) (Int)
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

P722: !_BST [9] (maybe <- 0x40000087) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P723: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P724: !_BST [14] (maybe <- 0x40000088) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P725: !_BLD [10] (FP) (Branch target of P550)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6
ba P726
nop

TARGET550:
ba RET550
nop


P726: !_ST [9] (maybe <- 0x40000089) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 512 ]

P727: !_DWLD [7] (Int)
ldx [%i1 + 80], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P728: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P729: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P730: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P731: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P732: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P733: !_BST [8] (maybe <- 0x4000008a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P734: !_MEMBAR (Int)
membar #StoreLoad

P735: !_SWAP [4] (maybe <- 0x800011) (Int)
mov %l4, %o1
swap  [%i0 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P736: !_SWAP [14] (maybe <- 0x800012) (Int)
mov %l4, %l3
swap  [%i3 + 128], %l3
! move %l3(lower) -> %o1(lower)
srl %l3, 0, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P737: !_SWAP [11] (maybe <- 0x800013) (Int) (Branch target of P1020)
mov %l4, %o2
swap  [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4
ba P738
nop

TARGET1020:
ba RET1020
nop


P738: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P739: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P740: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P741: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P742: !_BST [3] (maybe <- 0x4000008b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P743: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P744: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P745: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P746: !_BST [4] (maybe <- 0x4000008f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P747: !_BST [3] (maybe <- 0x40000090) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P748: !_CAS [4] (maybe <- 0x800014) (Int)
add %i0, 64, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2
mov %l4, %o3
cas [%l7], %l6, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P749: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P750: !_BLD [5] (FP) (Branch target of P819)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
ba P751
nop

TARGET819:
ba RET819
nop


P751: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P752: !_CAS [12] (maybe <- 0x800015) (Int)
add %i3, 0, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P753: !_BST [6] (maybe <- 0x40000094) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P754: !_PREFETCH [11] (Int) (CBR)
prefetch [%i2 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET754
nop
RET754:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P755: !_BST [8] (maybe <- 0x40000097) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P756: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

P757: !_BST [5] (maybe <- 0x40000098) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P758: !_BST [5] (maybe <- 0x4000009b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P759: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET759
nop
RET759:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P760: !_PREFETCH [2] (Int) (Branch target of P766)
prefetch [%i0 + 12], 1
ba P761
nop

TARGET766:
ba RET766
nop


P761: !_BST [1] (maybe <- 0x4000009e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P762: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P763: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P764: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P765: !_BST [5] (maybe <- 0x400000a2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P766: !_BST [1] (maybe <- 0x400000a5) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET766
nop
RET766:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P767: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P768: !_REPLACEMENT [10] (Int)
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

P769: !_PREFETCH [15] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

P770: !_BST [12] (maybe <- 0x400000a9) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET770
nop
RET770:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P771: !_REPLACEMENT [14] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET771
nop
RET771:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P772: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P773: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P774: !_CAS [5] (maybe <- 0x800016) (Int)
add %i1, 76, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l6], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P775: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P776: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P777: !_ST [7] (maybe <- 0x800017) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P778: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P779: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P780: !_PREFETCH [7] (Int) (Branch target of P759)
prefetch [%i1 + 84], 1
ba P781
nop

TARGET759:
ba RET759
nop


P781: !_LD [14] (Int)
lduw [%i3 + 128], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P782: !_BST [13] (maybe <- 0x400000aa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P783: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P784: !_BST [5] (maybe <- 0x400000ab) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P785: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P786: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P787: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P788: !_BST [12] (maybe <- 0x400000ae) (FP) (Branch target of P982)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 
ba P789
nop

TARGET982:
ba RET982
nop


P789: !_BST [9] (maybe <- 0x400000af) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P790: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P791: !_DWLD [0] (Int)
ldx [%i0 + 0], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P792: !_LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P793: !_BST [4] (maybe <- 0x400000b0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P794: !_BLD [5] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET794
nop
RET794:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P795: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P796: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P797: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P798: !_PREFETCH [12] (Int) (CBR)
prefetch [%i3 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET798
nop
RET798:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P799: !_BST [12] (maybe <- 0x400000b1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P800: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P801: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P802: !_BST [7] (maybe <- 0x400000b2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P803: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P804: !_DWST [10] (maybe <- 0x400000b5) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P805: !_BLD [12] (FP) (Branch target of P951)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6
ba P806
nop

TARGET951:
ba RET951
nop


P806: !_BST [13] (maybe <- 0x400000b6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P807: !_BST [3] (maybe <- 0x400000b7) (FP) (Branch target of P1004)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P808
nop

TARGET1004:
ba RET1004
nop


P808: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P809: !_BST [11] (maybe <- 0x400000bb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P810: !_BST [7] (maybe <- 0x400000bc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P811: !_BST [6] (maybe <- 0x400000bf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P812: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P813: !_BST [14] (maybe <- 0x400000c2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P814: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P815: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P816: !_DWST [4] (maybe <- 0x800018) (Int) (Branch target of P857)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P817
nop

TARGET857:
ba RET857
nop


P817: !_REPLACEMENT [14] (Int)
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

P818: !_SWAP [2] (maybe <- 0x800019) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P819: !_BLD [1] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET819
nop
RET819:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P820: !_PREFETCH [11] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 64] %asi, 1

P821: !_BLD [5] (FP) (Branch target of P551)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2
ba P822
nop

TARGET551:
ba RET551
nop


P822: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P823: !_MEMBAR (Int)
membar #StoreLoad

P824: !_BST [15] (maybe <- 0x400000c3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P825: !_DWLD [10] (FP)
ldd [%i2 + 32], %f4
! 1 addresses covered

P826: !_BST [2] (maybe <- 0x400000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P827: !_BST [2] (maybe <- 0x400000c8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P828: !_CAS [15] (maybe <- 0x80001a) (Int) (CBR)
add %i3, 192, %l6
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

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET828
nop
RET828:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P829: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P830: !_BST [13] (maybe <- 0x400000cc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P831: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P832: !_BST [3] (maybe <- 0x400000cd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P833: !_BST [5] (maybe <- 0x400000d1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P834: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P835: !_BST [11] (maybe <- 0x400000d4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P836: !_BST [4] (maybe <- 0x400000d5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P837: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P838: !_BST [1] (maybe <- 0x400000d6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P839: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P840: !_BLD [7] (FP) (Branch target of P794)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8
ba P841
nop

TARGET794:
ba RET794
nop


P841: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P842: !_REPLACEMENT [7] (Int)
sethi %hi(0x54), %o5
or %o5, %lo(0x54),  %o5
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

P843: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P844: !_CAS [10] (maybe <- 0x80001b) (Int)
add %i2, 32, %o5
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

P845: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P846: !_DWST [3] (maybe <- 0x80001c) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 32 ] 
add   %l4, 1, %l4

P847: !_ST [11] (maybe <- 0x80001d) (Int) (CBR)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET847
nop
RET847:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P848: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P849: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P850: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P851: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f11

P852: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P853: !_CAS [2] (maybe <- 0x80001e) (Int)
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

P854: !_LD [6] (Int)
lduw [%i1 + 80], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P855: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P856: !_BST [3] (maybe <- 0x400000da) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P857: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET857
nop
RET857:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P858: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P859: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P860: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P861: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P862: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P863: !_BST [9] (maybe <- 0x400000de) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P864: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P865: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P866: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P867: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P868: !_BST [2] (maybe <- 0x400000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P869: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P870: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P871: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P872: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P873: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P874: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P875: !_BST [6] (maybe <- 0x400000e3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P876: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P877: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P878: !_BST [11] (maybe <- 0x400000e6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P879: !_BLD [0] (FP) (Branch target of P544)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5
ba P880
nop

TARGET544:
ba RET544
nop


P880: !_BST [14] (maybe <- 0x400000e7) (FP) (Branch target of P596)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 
ba P881
nop

TARGET596:
ba RET596
nop


P881: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P882: !_ST [4] (maybe <- 0x80001f) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P883: !_BLD [2] (FP) (Branch target of P971)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9
ba P884
nop

TARGET971:
ba RET971
nop


P884: !_BST [3] (maybe <- 0x400000e8) (FP) (Branch target of P770)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P885
nop

TARGET770:
ba RET770
nop


P885: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P886: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P887: !_BST [14] (maybe <- 0x400000ec) (FP) (Branch target of P564)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 
ba P888
nop

TARGET564:
ba RET564
nop


P888: !_ST [0] (maybe <- 0x800020) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P889: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P890: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P891: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P892: !_BST [8] (maybe <- 0x400000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P893: !_DWST [2] (maybe <- 0x800021) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P894: !_BST [2] (maybe <- 0x400000ee) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P895: !_ST [7] (maybe <- 0x800022) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P896: !_BST [9] (maybe <- 0x400000f2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P897: !_DWST [3] (maybe <- 0x800023) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P898: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P899: !_CAS [4] (maybe <- 0x800024) (Int)
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

P900: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P901: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f5

P902: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P903: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P904: !_DWST [13] (maybe <- 0x800025) (Int) (Branch target of P914)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4
ba P905
nop

TARGET914:
ba RET914
nop


P905: !_REPLACEMENT [8] (Int)
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

P906: !_BST [2] (maybe <- 0x400000f3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P907: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f10

P908: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P909: !_BST [5] (maybe <- 0x400000f7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P910: !_BST [15] (maybe <- 0x400000fa) (FP) (Branch target of P1024)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 
ba P911
nop

TARGET1024:
ba RET1024
nop


P911: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P912: !_MEMBAR (Int)
membar #StoreLoad

P913: !_LD [12] (Int)
lduw [%i3 + 0], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

P914: !_BST [2] (maybe <- 0x400000fb) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET914
nop
RET914:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P915: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P916: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P917: !_DWLD [3] (Int)
ldx [%i0 + 32], %o3
! move %o3(upper) -> %o3(upper)

P918: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P919: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P920: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P921: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P922: !_BLD [5] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET922
nop
RET922:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P923: !_BST [6] (maybe <- 0x400000ff) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P924: !_DWST [15] (maybe <- 0x800026) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P925: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P926: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P927: !_BST [0] (maybe <- 0x40000102) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P928: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P929: !_BST [3] (maybe <- 0x40000106) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P930: !_ST [8] (maybe <- 0x800027) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P931: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P932: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P933: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P934: !_BST [2] (maybe <- 0x4000010a) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET934
nop
RET934:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P935: !_PREFETCH [0] (Int) (LE) (Branch target of P754)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1
ba P936
nop

TARGET754:
ba RET754
nop


P936: !_BST [4] (maybe <- 0x4000010e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P937: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P938: !_PREFETCH [2] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

P939: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f0
membar #Sync 
! 1 addresses covered

P940: !_BST [7] (maybe <- 0x4000010f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P941: !_BST [1] (maybe <- 0x40000112) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P942: !_BLD [13] (FP) (Branch target of P798)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
ba P943
nop

TARGET798:
ba RET798
nop


P943: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P944: !_BST [15] (maybe <- 0x40000116) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P945: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P946: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P947: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P948: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P949: !_SWAP [6] (maybe <- 0x800028) (Int)
mov %l4, %l6
swap  [%i1 + 80], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %l6, 0, %o5
or %o5, %o3, %o3
add   %l4, 1, %l4

P950: !_BST [6] (maybe <- 0x40000117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P951: !_DWLD [5] (Int) (CBR)
ldx [%i1 + 72], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET951
nop
RET951:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P952: !_PREFETCH [2] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

P953: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P954: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P955: !_BST [13] (maybe <- 0x4000011a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P956: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P957: !_REPLACEMENT [9] (Int)
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

P958: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P959: !_BST [11] (maybe <- 0x4000011b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P960: !_REPLACEMENT [14] (Int)
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

P961: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P962: !_BST [14] (maybe <- 0x4000011c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P963: !_BLD [10] (FP) (Branch target of P771)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3
ba P964
nop

TARGET771:
ba RET771
nop


P964: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P965: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P966: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P967: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P968: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P969: !_BST [0] (maybe <- 0x4000011d) (FP) (Branch target of P655)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P970
nop

TARGET655:
ba RET655
nop


P970: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P971: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET971
nop
RET971:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P972: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P973: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P974: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P975: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P976: !_BST [6] (maybe <- 0x40000121) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P977: !_REPLACEMENT [3] (Int)
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

P978: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

P979: !_ST [11] (maybe <- 0x800029) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P980: !_BST [13] (maybe <- 0x40000124) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P981: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P982: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET982
nop
RET982:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P983: !_ST [5] (maybe <- 0x80002a) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P984: !_LD [10] (Int)
lduw [%i2 + 32], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P985: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P986: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P987: !_BST [4] (maybe <- 0x40000125) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P988: !_REPLACEMENT [3] (Int)
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

P989: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P990: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P991: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P992: !_NOP (Int)
nop

P993: !_BST [9] (maybe <- 0x40000126) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET993
nop
RET993:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P994: !_REPLACEMENT [15] (Int)
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

P995: !_BST [4] (maybe <- 0x40000127) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P996: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P997: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P998: !_BST [5] (maybe <- 0x40000128) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P999: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1000: !_BST [4] (maybe <- 0x4000012b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1001: !_BST [14] (maybe <- 0x4000012c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1002: !_BST [12] (maybe <- 0x4000012d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1003: !_DWST [14] (maybe <- 0x80002b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 128 ] 
add   %l4, 1, %l4

P1004: !_BLD [8] (FP) (CBR) (Branch target of P922)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1004
nop
RET1004:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P1005
nop

TARGET922:
ba RET922
nop


P1005: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1006: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P1007: !_DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P1008: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P1009: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1010: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1011: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1012: !_CASX [15] (maybe <- 0x80002c) (Int)
add %i3, 192, %l3
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

P1013: !_BST [8] (maybe <- 0x4000012e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1014: !_BST [7] (maybe <- 0x4000012f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1015: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1016: !_BST [5] (maybe <- 0x40000132) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1017: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P1018: !_MEMBAR (Int)
membar #StoreLoad

P1019: !_LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P1020: !_LD [1] (Int) (CBR)
lduw [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1020
nop
RET1020:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1021: !_LD [2] (Int)
lduw [%i0 + 12], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P1022: !_LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1023: !_LD [4] (Int)
lduw [%i0 + 64], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1024: !_LD [5] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
lduwa [%i1 + 76] %asi, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1024
nop
RET1024:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1025: !_LD [6] (Int)
lduw [%i1 + 80], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P1026: !_LD [7] (Int)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1027: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P1028: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1029: !_LD [10] (Int)
lduw [%i2 + 32], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P1030: !_LD [11] (Int)
lduw [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1031: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P1032: !_LD [13] (Int) (CBR)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1032
nop
RET1032:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1033: !_LD [14] (Int)
lduw [%i3 + 128], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1034: !_LD [15] (Int)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

END_NODES1: ! Test istream for CPU 1 ends
sethi %hi(0xdead0e0f), %o5
or    %o5, %lo(0xdead0e0f), %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
stw %o5, [%i5] 
ld [%i5], %f9
!---- flushing int results buffer----
mov %o0, %l5
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
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0x02deade1), %l7
or    %l7, %lo(0x02deade1), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x1000001), %l4
or    %l4, %lo(0x1000001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x40800001), %l7
or    %l7, %lo(0x40800001), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x35000000), %l7
or    %l7, %lo(0x35000000), %l7
stw %l7, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x5642^4
sethi %hi(0x5642), %l0
or    %l0, %lo(0x5642), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 1 to 0 ---

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %o5
add %i3, %o5, %o5
sub %o5, -4096, %o5

!-- begin of sync_init ---
or %g0, 1, %l3
or %g0, %l3, %l6
swap [%o5+4], %l6
membar #Sync
sync_init_1_2:
brnz,pt %l3, sync_init_1_2
lduw [%o5+4], %l3 ! delay slot
sync_init_2_2:
lduw [%o5], %l3
sub %l3, 1, %l6
cas [%o5], %l3, %l6
cmp %l3, %l6
bne,pt %xcc, sync_init_2_2
nop
membar #Sync
sync_init_3_2:
lduw [%o5], %l3 ! delay slot
brnz,pt %l3, sync_init_3_2
nop
!-- end of sync_init ---


BEGIN_NODES2: ! Test istream for CPU 2 begins

P1035: !_REPLACEMENT [5] (Int)
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

P1036: !_BST [6] (maybe <- 0x40800001) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1037: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1038: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

P1039: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1040: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1041: !_BST [9] (maybe <- 0x40800004) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1042: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1043: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1044: !_BST [10] (maybe <- 0x40800005) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1045: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1045
nop
RET1045:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1046: !_BST [14] (maybe <- 0x40800006) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1047: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1048: !_BST [5] (maybe <- 0x40800007) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1049: !_BST [1] (maybe <- 0x4080000a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1050: !_BST [11] (maybe <- 0x4080000e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1051: !_BST [2] (maybe <- 0x4080000f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1052: !_BST [13] (maybe <- 0x40800013) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1053: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1054: !_PREFETCH [14] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 128] %asi, 1

P1055: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1056: !_REPLACEMENT [10] (Int)
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

P1057: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1058: !_BST [6] (maybe <- 0x40800014) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1059: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1060: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1061: !_BST [2] (maybe <- 0x40800017) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1062: !_PREFETCH [0] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1

P1063: !_REPLACEMENT [12] (Int)
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

P1064: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1065: !_BST [15] (maybe <- 0x4080001b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1066: !_BLD [6] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1066
nop
RET1066:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1067: !_BST [9] (maybe <- 0x4080001c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1068: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1069: !_BST [0] (maybe <- 0x4080001d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1070: !_BST [8] (maybe <- 0x40800021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1071: !_BST [3] (maybe <- 0x40800022) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1072: !_LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1073: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P1074: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1075: !_BST [13] (maybe <- 0x40800026) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1076: !_ST [10] (maybe <- 0x1000001) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1077: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P1078: !_PREFETCH [10] (Int) (Branch target of P1262)
prefetch [%i2 + 32], 1
ba P1079
nop

TARGET1262:
ba RET1262
nop


P1079: !_BST [5] (maybe <- 0x40800027) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1080: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1081: !_BST [1] (maybe <- 0x4080002a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1082: !_BST [1] (maybe <- 0x4080002e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1083: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1083
nop
RET1083:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1084: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P1085: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1086: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1087: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1088: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1089: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1089
nop
RET1089:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1090: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1091: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1092: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1093: !_LD [5] (Int)
lduw [%i1 + 76], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1094: !_NOP (Int)
nop

P1095: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1096: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1097: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1098: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1099: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1099
nop
RET1099:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1100: !_PREFETCH [8] (Int) (Branch target of P1284)
prefetch [%i1 + 256], 1
ba P1101
nop

TARGET1284:
ba RET1284
nop


P1101: !_BST [14] (maybe <- 0x40800032) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1102: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P1103: !_MEMBAR (Int)
membar #StoreLoad

P1104: !_LD [13] (Int)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1105: !_BST [13] (maybe <- 0x40800033) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1106: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1107: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P1108: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1109: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P1110: !_BST [0] (maybe <- 0x40800034) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1111: !_BST [13] (maybe <- 0x40800038) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1111
nop
RET1111:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1112: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P1113: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P1114: !_BST [11] (maybe <- 0x40800039) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1115: !_LD [15] (Int)
lduw [%i3 + 192], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P1116: !_PREFETCH [0] (Int) (LE) (Branch target of P1083)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1
ba P1117
nop

TARGET1083:
ba RET1083
nop


P1117: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1118: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P1119: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1120: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1121: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f0
membar #Sync 
! 1 addresses covered

P1122: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1123: !_BST [9] (maybe <- 0x4080003a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1124: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1125: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1126: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1127: !_BST [2] (maybe <- 0x4080003b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1128: !_BST [8] (maybe <- 0x4080003f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1129: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1130: !_BST [15] (maybe <- 0x40800040) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1131: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1132: !_BST [11] (maybe <- 0x40800041) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1133: !_BST [2] (maybe <- 0x40800042) (FP) (Branch target of P1276)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1134
nop

TARGET1276:
ba RET1276
nop


P1134: !_BST [4] (maybe <- 0x40800046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1135: !_BST [3] (maybe <- 0x40800047) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1136: !_REPLACEMENT [15] (Int)
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

P1137: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P1138: !_BST [11] (maybe <- 0x4080004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1139: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P1140: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1141: !_DWLD [15] (Int)
ldx [%i3 + 192], %o2
! move %o2(upper) -> %o2(upper)

P1142: !_BST [11] (maybe <- 0x4080004c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1143: !_DWST [0] (maybe <- 0x1000002) (Int) (Branch target of P1220)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4
ba P1144
nop

TARGET1220:
ba RET1220
nop


P1144: !_BST [11] (maybe <- 0x4080004d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1145: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P1146: !_BST [0] (maybe <- 0x4080004e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1147: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1148: !_BST [15] (maybe <- 0x40800052) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1149: !_BST [6] (maybe <- 0x40800053) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1150: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1151: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1152: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1153: !_BST [12] (maybe <- 0x40800056) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1154: !_ST [2] (maybe <- 0x1000004) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1155: !_REPLACEMENT [12] (Int)
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

P1156: !_MEMBAR (Int)
membar #StoreLoad

P1157: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1158: !_MEMBAR (Int)
membar #StoreLoad

P1159: !_BST [12] (maybe <- 0x40800057) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1160: !_LD [4] (Int)
lduw [%i0 + 64], %l7
! move %l7(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %l7, %o2, %o2

P1161: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1162: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1163: !_BST [12] (maybe <- 0x40800058) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1164: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1165: !_LD [11] (Int)
lduw [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1166: !_PREFETCH [13] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 64] %asi, 1

P1167: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1168: !_BST [1] (maybe <- 0x40800059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1169: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1170: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P1171: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1172: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1173: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1174: !_BST [1] (maybe <- 0x4080005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1175: !_BST [13] (maybe <- 0x40800061) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1176: !_BST [3] (maybe <- 0x40800062) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1177: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P1178: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1179: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1180: !_BST [7] (maybe <- 0x40800066) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1181: !_PREFETCH [13] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 64] %asi, 1

P1182: !_BST [11] (maybe <- 0x40800069) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1183: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P1184: !_REPLACEMENT [4] (Int)
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

P1185: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1186: !_ST [7] (maybe <- 0x1000005) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1187: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1188: !_DWLD [2] (Int)
ldx [%i0 + 8], %l6
! move %l6(lower) -> %o3(lower)
srl %l6, 0, %l3
or %l3, %o3, %o3

P1189: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1190: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P1191: !_PREFETCH [0] (Int) (CBR)
prefetch [%i0 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1191
nop
RET1191:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1192: !_BLD [11] (FP) (Branch target of P1255)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8
ba P1193
nop

TARGET1255:
ba RET1255
nop


P1193: !_PREFETCH [8] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 256] %asi, 1

P1194: !_REPLACEMENT [0] (Int)
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

P1195: !_BST [0] (maybe <- 0x4080006a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1196: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1197: !_BST [8] (maybe <- 0x4080006e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1198: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1199: !_LD [12] (Int)
lduw [%i3 + 0], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1200: !_REPLACEMENT [2] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1200
nop
RET1200:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1201: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P1202: !_CAS [8] (maybe <- 0x1000006) (Int)
add %i1, 256, %o5
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

P1203: !_REPLACEMENT [9] (Int)
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

P1204: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1205: !_BST [12] (maybe <- 0x4080006f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1206: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1207: !_MEMBAR (Int)
membar #StoreLoad

P1208: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1209: !_BST [1] (maybe <- 0x40800070) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1210: !_MEMBAR (Int)
membar #StoreLoad

P1211: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1212: !_BST [0] (maybe <- 0x40800074) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1213: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1214: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P1215: !_BST [2] (maybe <- 0x40800078) (FP) (Branch target of P1111)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1216
nop

TARGET1111:
ba RET1111
nop


P1216: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P1217: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1218: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1219: !_PREFETCH [1] (Int) (Branch target of P1308)
prefetch [%i0 + 4], 1
ba P1220
nop

TARGET1308:
ba RET1308
nop


P1220: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1220
nop
RET1220:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1221: !_BST [0] (maybe <- 0x4080007c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1222: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1223: !_BST [1] (maybe <- 0x40800080) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1224: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P1225: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1226: !_BST [6] (maybe <- 0x40800084) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1227: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1228: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1229: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1229
nop
RET1229:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1230: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1231: !_MEMBAR (Int)
membar #StoreLoad

P1232: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P1233: !_ST [11] (maybe <- 0x1000007) (Int) (LE)
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

P1234: !_REPLACEMENT [13] (Int)
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

P1235: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1236: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1237: !_LD [7] (Int) (Branch target of P1066)
lduw [%i1 + 84], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
ba P1238
nop

TARGET1066:
ba RET1066
nop


P1238: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1239: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1240: !_BST [11] (maybe <- 0x40800087) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1241: !_BST [6] (maybe <- 0x40800088) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1242: !_CAS [5] (maybe <- 0x1000008) (Int)
add %i1, 76, %o5
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

P1243: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1244: !_MEMBAR (Int)
membar #StoreLoad

P1245: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1246: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1247: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1248: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1249: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1250: !_BST [2] (maybe <- 0x4080008b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1251: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1252: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1253: !_BST [15] (maybe <- 0x4080008f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1254: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1255: !_BLD [2] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1255
nop
RET1255:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1256: !_ST [2] (maybe <- 0x1000009) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P1257: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1258: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P1259: !_DWLD [1] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P1260: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1261: !_BST [15] (maybe <- 0x40800090) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1262: !_BST [13] (maybe <- 0x40800091) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1262
nop
RET1262:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1263: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1264: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P1265: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P1266: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1267: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1268: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1269: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1270: !_PREFETCH [10] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 32] %asi, 1

P1271: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1272: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P1273: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P1274: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1275: !_BST [1] (maybe <- 0x40800092) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1276: !_BST [11] (maybe <- 0x40800096) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1276
nop
RET1276:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1277: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1278: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1279: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1280: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1281: !_BST [14] (maybe <- 0x40800097) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1282: !_BST [13] (maybe <- 0x40800098) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1283: !_LD [11] (Int)
lduw [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1284: !_LD [9] (Int) (CBR)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1284
nop
RET1284:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1285: !_PREFETCH [7] (Int) (Branch target of P1297)
prefetch [%i1 + 84], 1
ba P1286
nop

TARGET1297:
ba RET1297
nop


P1286: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1287: !_BST [7] (maybe <- 0x40800099) (FP) (Branch target of P1045)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P1288
nop

TARGET1045:
ba RET1045
nop


P1288: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1289: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1290: !_ST [9] (maybe <- 0x100000a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1291: !_PREFETCH [5] (Int) (Branch target of P1099)
prefetch [%i1 + 76], 1
ba P1292
nop

TARGET1099:
ba RET1099
nop


P1292: !_PREFETCH [13] (Int) (CBR)
prefetch [%i3 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1292
nop
RET1292:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1293: !_BST [13] (maybe <- 0x4080009c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1294: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P1295: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1296: !_DWST [12] (maybe <- 0x100000b) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 0 ] 
add   %l4, 1, %l4

P1297: !_DWLD [4] (Int) (CBR)
ldx [%i0 + 64], %o4
! move %o4(upper) -> %o4(upper)

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1297
nop
RET1297:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1298: !_ST [15] (maybe <- 0x100000c) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P1299: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1300: !_BST [14] (maybe <- 0x4080009d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1301: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1302: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P1303: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1304: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1305: !_BST [1] (maybe <- 0x4080009e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1306: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1306
nop
RET1306:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1307: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1308: !_BLD [13] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1308
nop
RET1308:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1309: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1310: !_BST [12] (maybe <- 0x408000a2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1311: !_BST [9] (maybe <- 0x408000a3) (FP) (Branch target of P1386)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P1312
nop

TARGET1386:
ba RET1386
nop


P1312: !_DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1313: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1314: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f11

P1315: !_BST [4] (maybe <- 0x408000a4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1316: !_BST [13] (maybe <- 0x408000a5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1317: !_REPLACEMENT [7] (Int)
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

P1318: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P1319: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1320: !_REPLACEMENT [9] (Int)
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

P1321: !_BST [5] (maybe <- 0x408000a6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1322: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1323: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1324: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P1325: !_BLD [4] (FP) (Branch target of P1200)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
ba P1326
nop

TARGET1200:
ba RET1200
nop


P1326: !_BST [10] (maybe <- 0x408000a9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1327: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P1328: !_PREFETCH [8] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 256] %asi, 1

P1329: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P1330: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1331: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1332: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1333: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1334: !_SWAP [5] (maybe <- 0x100000d) (Int)
mov %l4, %o0
swap  [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1335: !_CASX [14] (maybe <- 0x100000e) (Int)
add %i3, 128, %l3
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

P1336: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1337: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1338: !_SWAP [15] (maybe <- 0x100000f) (Int)
mov %l4, %l6
swap  [%i3 + 192], %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %o5
or %o5, %o2, %o2
add   %l4, 1, %l4

P1339: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P1340: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1341: !_SWAP [5] (maybe <- 0x1000010) (Int)
mov %l4, %o3
swap  [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P1342: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P1343: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P1344: !_DWLD [6] (Int)
ldx [%i1 + 80], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l6
or %l6, %o3, %o3
! move %l7(lower) -> %o4(upper)
sllx %l7, 32, %o4

P1345: !_BST [7] (maybe <- 0x408000aa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1346: !_REPLACEMENT [11] (Int)
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

P1347: !_REPLACEMENT [12] (Int)
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

P1348: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1349: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1350: !_BST [12] (maybe <- 0x408000ad) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1351: !_ST [8] (maybe <- 0x1000011) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1352: !_ST [10] (maybe <- 0x1000012) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1353: !_LD [0] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 0] %asi, %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1354: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P1355: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1356: !_BST [14] (maybe <- 0x408000ae) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1357: !_BST [0] (maybe <- 0x408000af) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1358: !_REPLACEMENT [11] (Int)
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

P1359: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1360: !_LD [13] (FP)
ld [%i3 + 64], %f5
! 1 addresses covered

P1361: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P1362: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1363: !_ST [9] (maybe <- 0x1000013) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1364: !_BST [4] (maybe <- 0x408000b3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1365: !_BST [9] (maybe <- 0x408000b4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1366: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1367: !_BST [12] (maybe <- 0x408000b5) (FP) (Branch target of P1089)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 
ba P1368
nop

TARGET1089:
ba RET1089
nop


P1368: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1369: !_BST [11] (maybe <- 0x408000b6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1370: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1371: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1372: !_BST [0] (maybe <- 0x408000b7) (FP) (Branch target of P1439)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1373
nop

TARGET1439:
ba RET1439
nop


P1373: !_BST [4] (maybe <- 0x408000bb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1374: !_NOP (Int) (Branch target of P1292)
nop
ba P1375
nop

TARGET1292:
ba RET1292
nop


P1375: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P1376: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1377: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1378: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1379: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1380: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1381: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1382: !_DWST [3] (maybe <- 0x408000bc) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i0 + 32]

P1383: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1384: !_BST [13] (maybe <- 0x408000bd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1385: !_BST [6] (maybe <- 0x408000be) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1386: !_BST [9] (maybe <- 0x408000c1) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1386
nop
RET1386:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1387: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1388: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1389: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1390: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1391: !_BST [14] (maybe <- 0x408000c2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1392: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P1393: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1394: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1395: !_DWST [11] (maybe <- 0x408000c3) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 64]

P1396: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1397: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P1398: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1399: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1400: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P1401: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1402: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1403: !_BST [1] (maybe <- 0x408000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1404: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P1405: !_BST [13] (maybe <- 0x408000c8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1406: !_BST [9] (maybe <- 0x408000c9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1407: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P1408: !_BST [9] (maybe <- 0x408000ca) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1409: !_BST [2] (maybe <- 0x408000cb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1410: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1411: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f2

P1412: !_DWST [3] (maybe <- 0x1000014) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P1413: !_BST [5] (maybe <- 0x408000cf) (FP) (Branch target of P1517)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P1414
nop

TARGET1517:
ba RET1517
nop


P1414: !_PREFETCH [4] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 64] %asi, 1

P1415: !_BST [7] (maybe <- 0x408000d2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1416: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1417: !_PREFETCH [15] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

P1418: !_BST [4] (maybe <- 0x408000d5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1419: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P1420: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P1421: !_PREFETCH [8] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 256] %asi, 1

P1422: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1423: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P1424: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1425: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f12

P1426: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f13

P1427: !_ST [1] (maybe <- 0x1000015) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P1428: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1429: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1430: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1431: !_DWST [9] (maybe <- 0x1000016) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P1432: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1433: !_REPLACEMENT [1] (Int)
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

P1434: !_LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1435: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1436: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1437: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered
fmovd %f8, %f0

P1438: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1439: !_PREFETCH [5] (Int) (CBR)
prefetch [%i1 + 76], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1439
nop
RET1439:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1440: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1441: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1442: !_BST [6] (maybe <- 0x408000d6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1443: !_BLD [5] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1443
nop
RET1443:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1444: !_LD [15] (Int)
lduw [%i3 + 192], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P1445: !_ST [15] (maybe <- 0x408000d9) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 192 ]

P1446: !_BST [1] (maybe <- 0x408000da) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1447: !_CASX [5] (maybe <- 0x1000017) (Int)
add %i1, 72, %l3
ldx [%l3], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %o5
mov %l4, %o2
casx [%l3], %o5, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P1448: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1449: !_DWLD [6] (Int)
ldx [%i1 + 80], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1450: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1451: !_CAS [11] (maybe <- 0x1000018) (Int)
add %i2, 64, %l7
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

P1452: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P1453: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P1454: !_BST [6] (maybe <- 0x408000de) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1455: !_ST [11] (maybe <- 0x1000019) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1456: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1457: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1458: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1458
nop
RET1458:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1459: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1460: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1461: !_SWAP [10] (maybe <- 0x100001a) (Int)
mov %l4, %o0
swap  [%i2 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P1462: !_ST [9] (maybe <- 0x100001b) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P1463: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P1464: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P1465: !_BST [12] (maybe <- 0x408000e1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1466: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1467: !_REPLACEMENT [10] (Int)
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

P1468: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1469: !_PREFETCH [11] (Int) (CBR)
prefetch [%i2 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1469
nop
RET1469:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1470: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1471: !_BST [11] (maybe <- 0x408000e2) (FP) (Branch target of P1494)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 
ba P1472
nop

TARGET1494:
ba RET1494
nop


P1472: !_LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P1473: !_BST [7] (maybe <- 0x408000e3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1474: !_BST [13] (maybe <- 0x408000e6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1475: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1476: !_BST [4] (maybe <- 0x408000e7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1477: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1478: !_DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P1479: !_BST [15] (maybe <- 0x408000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1480: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P1481: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1482: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P1483: !_BST [0] (maybe <- 0x408000e9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1484: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f12

P1485: !_DWLD [5] (Int) (Branch target of P1306)
ldx [%i1 + 72], %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srl %l3, 0, %o5
or %o5, %o1, %o1
ba P1486
nop

TARGET1306:
ba RET1306
nop


P1486: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1487: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P1488: !_ST [13] (maybe <- 0x100001c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P1489: !_BST [7] (maybe <- 0x408000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1490: !_CAS [9] (maybe <- 0x100001d) (Int) (LE)
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
add %i1, 512, %l3
lduwa [%l3] %asi, %o2
mov %o2, %o5
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov %l6, %l7
casa [%l3] %asi, %o5, %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l3
or %l3, %o2, %o2
add   %l4, 1, %l4

P1491: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1492: !_BST [10] (maybe <- 0x408000f0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1493: !_BST [8] (maybe <- 0x408000f1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1494: !_BLD [10] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered
fmovd %f8, %f0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1494
nop
RET1494:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1495: !_DWST [10] (maybe <- 0x100001e) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P1496: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1497: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1498: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P1499: !_ST [14] (maybe <- 0x100001f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P1500: !_LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P1501: !_BST [15] (maybe <- 0x408000f2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1502: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1503: !_BST [11] (maybe <- 0x408000f3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1504: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1505: !_BST [11] (maybe <- 0x408000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1506: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1507: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1508: !_BST [5] (maybe <- 0x408000f5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1509: !_BST [12] (maybe <- 0x408000f8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1510: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1511: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1512: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P1513: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P1514: !_BST [10] (maybe <- 0x408000f9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1515: !_BST [12] (maybe <- 0x408000fa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1516: !_DWLD [0] (Int)
ldx [%i0 + 0], %l3
! move %l3(upper) -> %o3(lower)
srlx %l3, 32, %o5
or %o5, %o3, %o3
! move %l3(lower) -> %o4(upper)
sllx %l3, 32, %o4

P1517: !_BLD [3] (FP) (CBR) (Branch target of P1458)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1517
nop
RET1517:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P1518
nop

TARGET1458:
ba RET1458
nop


P1518: !_BST [11] (maybe <- 0x408000fb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1519: !_CAS [1] (maybe <- 0x1000020) (Int)
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

P1520: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f5

P1521: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1522: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1523: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1524: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1525: !_ST [0] (maybe <- 0x1000021) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P1526: !_BST [3] (maybe <- 0x408000fc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1527: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1528: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1529: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P1530: !_LD [11] (Int)
lduw [%i2 + 64], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P1531: !_BST [1] (maybe <- 0x40800100) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1532: !_PREFETCH [12] (Int) (Branch target of P1191)
prefetch [%i3 + 0], 1
ba P1533
nop

TARGET1191:
ba RET1191
nop


P1533: !_LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1534: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1535: !_MEMBAR (Int)
membar #StoreLoad

P1536: !_LD [0] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 0] %asi, %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P1537: !_LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1538: !_LD [2] (FP)
ld [%i0 + 12], %f12
! 1 addresses covered

P1539: !_LD [3] (FP)
ld [%i0 + 32], %f13
! 1 addresses covered

P1540: !_LD [4] (Int)
lduw [%i0 + 64], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P1541: !_LD [5] (Int) (Branch target of P1443)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
ba P1542
nop

TARGET1443:
ba RET1443
nop


P1542: !_LD [6] (Int)
lduw [%i1 + 80], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P1543: !_LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1544: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1545: !_LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1546: !_LD [10] (Int)
lduw [%i2 + 32], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P1547: !_LD [11] (Int) (Branch target of P1469)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
ba P1548
nop

TARGET1469:
ba RET1469
nop


P1548: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P1549: !_LD [13] (Int) (Branch target of P1229)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
ba P1550
nop

TARGET1229:
ba RET1229
nop


P1550: !_LD [14] (Int)
lduw [%i3 + 128], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P1551: !_LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

END_NODES2: ! Test istream for CPU 2 ends
sethi %hi(0xdead0e0f), %l7
or    %l7, %lo(0xdead0e0f), %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3
stw %l7, [%i5] 
ld [%i5], %f14
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

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
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0x03deade1), %l6
or    %l6, %lo(0x03deade1), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x1800001), %l4
or    %l4, %lo(0x1800001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x41000001), %l6
or    %l6, %lo(0x41000001), %l6
stw %l6, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x35800000), %l6
or    %l6, %lo(0x35800000), %l6
stw %l6, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x7cff^4
sethi %hi(0x7cff), %l0
or    %l0, %lo(0x7cff), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 1 to 1 ---
stx %g0, [%i0+0]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l7
add %i3, %l7, %l7
sub %l7, -4096, %l7

!-- begin of sync_init ---
or %g0, 1, %o5
or %g0, %o5, %l3
swap [%l7+4], %l3
membar #Sync
sync_init_1_3:
brnz,pt %o5, sync_init_1_3
lduw [%l7+4], %o5 ! delay slot
sync_init_2_3:
lduw [%l7], %o5
sub %o5, 1, %l3
cas [%l7], %o5, %l3
cmp %o5, %l3
bne,pt %xcc, sync_init_2_3
nop
membar #Sync
sync_init_3_3:
lduw [%l7], %o5 ! delay slot
brnz,pt %o5, sync_init_3_3
nop
!-- end of sync_init ---


BEGIN_NODES3: ! Test istream for CPU 3 begins

P1552: !_DWST [3] (maybe <- 0x1800001) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P1553: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1554: !_DWST [1] (maybe <- 0x1800002) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P1555: !_BST [15] (maybe <- 0x41000001) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1556: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1557: !_BST [3] (maybe <- 0x41000002) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1558: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1559: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1560: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1561: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P1562: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1563: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P1564: !_BST [2] (maybe <- 0x41000006) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1565: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P1566: !_LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1567: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1568: !_BST [3] (maybe <- 0x4100000a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1569: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1570: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered
fmovd %f8, %f0

P1571: !_PREFETCH [11] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
prefetcha [%i2 + 64] %asi, 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1571
nop
RET1571:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1572: !_BST [2] (maybe <- 0x4100000e) (FP) (Branch target of P1830)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1573
nop

TARGET1830:
ba RET1830
nop


P1573: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P1574: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1575: !_BST [5] (maybe <- 0x41000012) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1576: !_MEMBAR (Int)
membar #StoreLoad

P1577: !_BST [14] (maybe <- 0x41000015) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1578: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1579: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P1580: !_BST [15] (maybe <- 0x41000016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1581: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1582: !_DWLD [5] (Int)
ldx [%i1 + 72], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l7
or %l7, %o0, %o0

P1583: !_BST [0] (maybe <- 0x41000017) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1584: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1585: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1586: !_PREFETCH [6] (Int) (CBR)
prefetch [%i1 + 80], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1586
nop
RET1586:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1587: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1588: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f9

P1589: !_BST [3] (maybe <- 0x4100001b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1590: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1591: !_DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P1592: !_BST [12] (maybe <- 0x4100001f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1593: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P1594: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1595: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P1596: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1597: !_ST [11] (maybe <- 0x1800004) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P1598: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P1599: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1600: !_LD [11] (FP)
ld [%i2 + 64], %f7
! 1 addresses covered

P1601: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1602: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P1603: !_BST [11] (maybe <- 0x41000020) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1604: !_DWLD [13] (Int)
ldx [%i3 + 64], %o5
! move %o5(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %o5, 32, %l7
or %l7, %o1, %o1

P1605: !_BST [10] (maybe <- 0x41000021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1606: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1607: !_PREFETCH [7] (Int) (CBR)
prefetch [%i1 + 84], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1607
nop
RET1607:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1608: !_ST [5] (maybe <- 0x1800005) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P1609: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1610: !_BST [9] (maybe <- 0x41000022) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1611: !_BST [9] (maybe <- 0x41000023) (FP) (Branch target of P1738)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P1612
nop

TARGET1738:
ba RET1738
nop


P1612: !_BST [3] (maybe <- 0x41000024) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1613: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1614: !_BST [1] (maybe <- 0x41000028) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1615: !_PREFETCH [15] (Int) (CBR)
prefetch [%i3 + 192], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1615
nop
RET1615:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1616: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P1617: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1618: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1619: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1620: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1621: !_BST [8] (maybe <- 0x4100002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1622: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1623: !_BST [10] (maybe <- 0x4100002d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1624: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P1625: !_BLD [14] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1625
nop
RET1625:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1626: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f4

P1627: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1628: !_PREFETCH [14] (Int) (Branch target of P1640)
prefetch [%i3 + 128], 1
ba P1629
nop

TARGET1640:
ba RET1640
nop


P1629: !_LD [6] (FP)
ld [%i1 + 80], %f5
! 1 addresses covered

P1630: !_BST [13] (maybe <- 0x4100002e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1631: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1632: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1633: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1634: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1635: !_BLD [0] (FP) (Branch target of P1704)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14
ba P1636
nop

TARGET1704:
ba RET1704
nop


P1636: !_ST [7] (maybe <- 0x1800006) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P1637: !_BST [14] (maybe <- 0x4100002f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1638: !_BST [15] (maybe <- 0x41000030) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1639: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1640: !_PREFETCH [1] (Int) (CBR)
prefetch [%i0 + 4], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1640
nop
RET1640:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1641: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1642: !_LD [15] (Int)
lduw [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1643: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1644: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P1645: !_ST [3] (maybe <- 0x1800007) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P1646: !_BST [5] (maybe <- 0x41000031) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1647: !_BST [14] (maybe <- 0x41000034) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1648: !_BST [15] (maybe <- 0x41000035) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1649: !_BST [6] (maybe <- 0x41000036) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1650: !_ST [14] (maybe <- 0x1800008) (Int) (Branch target of P2017)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4
ba P1651
nop

TARGET2017:
ba RET2017
nop


P1651: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1652: !_BST [0] (maybe <- 0x41000039) (FP) (Branch target of P1982)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1653
nop

TARGET1982:
ba RET1982
nop


P1653: !_DWST [5] (maybe <- 0x1800009) (Int)
mov %l4, %o5 
stx %o5, [%i1 + 72]
add   %l4, 1, %l4

P1654: !_BST [1] (maybe <- 0x4100003d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1655: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1656: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P1657: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P1658: !_DWST [11] (maybe <- 0x180000a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4

P1659: !_BST [14] (maybe <- 0x41000041) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1660: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1661: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1662: !_BST [5] (maybe <- 0x41000042) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1663: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1664: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P1665: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1666: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1667: !_BST [4] (maybe <- 0x41000045) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1668: !_BST [4] (maybe <- 0x41000046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1669: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P1670: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1671: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1672: !_BST [0] (maybe <- 0x41000047) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1673: !_BST [13] (maybe <- 0x4100004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1674: !_BST [11] (maybe <- 0x4100004c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1675: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1676: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1677: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f4

P1678: !_BST [15] (maybe <- 0x4100004d) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1678
nop
RET1678:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1679: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1680: !_BST [11] (maybe <- 0x4100004e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1681: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P1682: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P1683: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1684: !_BLD [13] (FP) (Branch target of P1807)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12
ba P1685
nop

TARGET1807:
ba RET1807
nop


P1685: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1686: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f13

P1687: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1688: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P1689: !_BST [11] (maybe <- 0x4100004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1690: !_BST [3] (maybe <- 0x41000050) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1691: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1692: !_BST [15] (maybe <- 0x41000054) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1693: !_BST [4] (maybe <- 0x41000055) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1694: !_DWST [4] (maybe <- 0x180000b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P1695: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1696: !_BST [12] (maybe <- 0x41000056) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1697: !_BST [11] (maybe <- 0x41000057) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1698: !_DWST [11] (maybe <- 0x180000c) (Int) (Branch target of P1991)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i2 + 64 ] 
add   %l4, 1, %l4
ba P1699
nop

TARGET1991:
ba RET1991
nop


P1699: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1700: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1701: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1702: !_CAS [7] (maybe <- 0x180000d) (Int) (LE) (CBR)
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
add %i1, 84, %l6
lduwa [%l6] %asi, %o5
mov %o5, %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
mov %l7, %o3
casa [%l6] %asi, %l3, %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1702
nop
RET1702:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1703: !_NOP (Int)
nop

P1704: !_DWLD [15] (Int) (CBR)
ldx [%i3 + 192], %l7
! move %l7(upper) -> %o3(lower)
srlx %l7, 32, %l6
or %l6, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1704
nop
RET1704:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1705: !_BST [10] (maybe <- 0x41000058) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1706: !_CAS [14] (maybe <- 0x180000e) (Int)
add %i3, 128, %l3
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

P1707: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P1708: !_LD [12] (Int) (Branch target of P1769)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
ba P1709
nop

TARGET1769:
ba RET1769
nop


P1709: !_BST [0] (maybe <- 0x41000059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1710: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1711: !_BST [5] (maybe <- 0x4100005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1712: !_BST [14] (maybe <- 0x41000060) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1713: !_BST [9] (maybe <- 0x41000061) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1714: !_BST [3] (maybe <- 0x41000062) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1715: !_BST [1] (maybe <- 0x41000066) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1716: !_LD [11] (Int)
lduw [%i2 + 64], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P1717: !_BST [12] (maybe <- 0x4100006a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1718: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1719: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P1720: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1721: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P1722: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P1723: !_LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1724: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P1725: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P1726: !_PREFETCH [1] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 4] %asi, 1

P1727: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1728: !_LD [4] (Int)
lduw [%i0 + 64], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P1729: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P1730: !_DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P1731: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1732: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1733: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P1734: !_BST [4] (maybe <- 0x4100006b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1735: !_BST [11] (maybe <- 0x4100006c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1736: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1737: !_BST [14] (maybe <- 0x4100006d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1738: !_DWST [15] (maybe <- 0x180000f) (Int) (CBR)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1738
nop
RET1738:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1739: !_BST [11] (maybe <- 0x4100006e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1740: !_PREFETCH [12] (Int) (CBR)
prefetch [%i3 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1740
nop
RET1740:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1741: !_BST [2] (maybe <- 0x4100006f) (FP) (Branch target of P1702)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1742
nop

TARGET1702:
ba RET1702
nop


P1742: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
or %o5, %o2, %o2

P1743: !_BST [0] (maybe <- 0x41000073) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1744: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1745: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1746: !_BST [9] (maybe <- 0x41000077) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1747: !_DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P1748: !_REPLACEMENT [8] (Int)
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

P1749: !_BST [4] (maybe <- 0x41000078) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1750: !_SWAP [1] (maybe <- 0x1800010) (Int)
mov %l4, %l3
swap  [%i0 + 4], %l3
! move %l3(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srl %l3, 0, %l7
or %l7, %o3, %o3
add   %l4, 1, %l4

P1751: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P1752: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P1753: !_BST [2] (maybe <- 0x41000079) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1754: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1755: !_PREFETCH [15] (Int) (Branch target of P1571)
prefetch [%i3 + 192], 1
ba P1756
nop

TARGET1571:
ba RET1571
nop


P1756: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P1757: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1758: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1759: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P1760: !_PREFETCH [6] (Int) (Branch target of P1625)
prefetch [%i1 + 80], 1
ba P1761
nop

TARGET1625:
ba RET1625
nop


P1761: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1762: !_BST [15] (maybe <- 0x4100007d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1763: !_BST [2] (maybe <- 0x4100007e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1764: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1765: !_SWAP [2] (maybe <- 0x1800011) (Int)
mov %l4, %o4
swap  [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1766: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1767: !_REPLACEMENT [5] (Int)
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

P1768: !_BST [13] (maybe <- 0x41000082) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1769: !_BLD [4] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

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


P1770: !_DWST [7] (maybe <- 0x1800012) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P1771: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1772: !_DWST [12] (maybe <- 0x1800014) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 0 ] 
add   %l4, 1, %l4

P1773: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1774: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1775: !_BST [11] (maybe <- 0x41000083) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1776: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P1777: !_BST [12] (maybe <- 0x41000084) (FP) (Branch target of P1980)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 
ba P1778
nop

TARGET1980:
ba RET1980
nop


P1778: !_LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1779: !_BST [7] (maybe <- 0x41000085) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1780: !_BST [7] (maybe <- 0x41000088) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1781: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P1782: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1783: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f8

P1784: !_BST [14] (maybe <- 0x4100008b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1785: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1786: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P1787: !_LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P1788: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P1789: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1790: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1791: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P1792: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1793: !_BST [13] (maybe <- 0x4100008c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1794: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1795: !_DWST [11] (maybe <- 0x1800015) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P1796: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1797: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1798: !_DWLD [11] (Int)
ldx [%i2 + 64], %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %o5
or %o5, %o0, %o0

P1799: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P1800: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1801: !_BST [7] (maybe <- 0x4100008d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1802: !_BST [14] (maybe <- 0x41000090) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1803: !_BST [3] (maybe <- 0x41000091) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1804: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P1805: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1806: !_BST [6] (maybe <- 0x41000095) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1807: !_DWST [15] (maybe <- 0x41000098) (FP) (CBR)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1807
nop
RET1807:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1808: !_BST [2] (maybe <- 0x41000099) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1809: !_BST [4] (maybe <- 0x4100009d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1810: !_REPLACEMENT [1] (Int)
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

P1811: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1812: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P1813: !_BST [5] (maybe <- 0x4100009e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1814: !_BST [7] (maybe <- 0x410000a1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1815: !_BST [7] (maybe <- 0x410000a4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1816: !_REPLACEMENT [2] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1816
nop
RET1816:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1817: !_BST [3] (maybe <- 0x410000a7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1818: !_BST [3] (maybe <- 0x410000ab) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1819: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1820: !_DWST [4] (maybe <- 0x1800016) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P1821: !_REPLACEMENT [5] (Int)
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

P1822: !_MEMBAR (Int)
membar #StoreLoad

P1823: !_BST [13] (maybe <- 0x410000af) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1824: !_LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P1825: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1826: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P1827: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P1828: !_SWAP [12] (maybe <- 0x1800017) (Int) (LE)
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
swapa  [%i3 + 0] %asi, %l7
! move %l7(lower) -> %o1(lower)
srl %l7, 0, %l3
or %l3, %o1, %o1
add   %l4, 1, %l4

P1829: !_BST [3] (maybe <- 0x410000b0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1830: !_LD [7] (Int) (CBR)
lduw [%i1 + 84], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1830
nop
RET1830:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1831: !_BST [5] (maybe <- 0x410000b4) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1831
nop
RET1831:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1832: !_DWLD [0] (Int)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l6
or %l6, %o2, %o2
! move %l7(lower) -> %o3(upper)
sllx %l7, 32, %o3

P1833: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1834: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1835: !_BLD [9] (FP) (Branch target of P2042)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
ba P1836
nop

TARGET2042:
ba RET2042
nop


P1836: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1837: !_BST [14] (maybe <- 0x410000b7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1838: !_BST [9] (maybe <- 0x410000b8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1839: !_BST [0] (maybe <- 0x410000b9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1840: !_BST [12] (maybe <- 0x410000bd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1841: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1842: !_CAS [7] (maybe <- 0x1800018) (Int)
add %i1, 84, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3
mov %l4, %o4
cas [%l3], %o5, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P1843: !_CASX [12] (maybe <- 0x1800019) (Int)
add %i3, 0, %l3
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
sllx %l4, 32, %l7
casx [%l3], %o5, %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l3
or %l3, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
add  %l4, 1, %l4

P1844: !_SWAP [2] (maybe <- 0x180001a) (Int)
mov %l4, %l6
swap  [%i0 + 12], %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P1845: !_ST [8] (maybe <- 0x180001b) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P1846: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P1847: !_DWST [15] (maybe <- 0x180001c) (Int) (LE)
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
stxa %l7, [%i3 + 192 ] %asi
add   %l4, 1, %l4

P1848: !_BST [14] (maybe <- 0x410000be) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1849: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1850: !_BST [2] (maybe <- 0x410000bf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1851: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1852: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered

P1853: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P1854: !_BST [12] (maybe <- 0x410000c3) (FP) (Branch target of P1963)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 
ba P1855
nop

TARGET1963:
ba RET1963
nop


P1855: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1856: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1857: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1858: !_BST [1] (maybe <- 0x410000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1859: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1860: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1861: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P1862: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f11

P1863: !_ST [1] (maybe <- 0x180001d) (Int) (Branch target of P1883)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4
ba P1864
nop

TARGET1883:
ba RET1883
nop


P1864: !_LD [14] (Int)
lduw [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P1865: !_MEMBAR (Int)
membar #StoreLoad

P1866: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P1867: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P1868: !_BST [14] (maybe <- 0x410000c8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1869: !_DWST [0] (maybe <- 0x180001e) (Int) (Branch target of P1607)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4
ba P1870
nop

TARGET1607:
ba RET1607
nop


P1870: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1871: !_BST [7] (maybe <- 0x410000c9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1872: !_BST [1] (maybe <- 0x410000cc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1873: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1874: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P1875: !_BST [4] (maybe <- 0x410000d0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1876: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P1877: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P1878: !_BST [3] (maybe <- 0x410000d1) (FP) (Branch target of P1678)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P1879
nop

TARGET1678:
ba RET1678
nop


P1879: !_PREFETCH [15] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

P1880: !_DWLD [14] (FP)
ldd [%i3 + 128], %f18
! 1 addresses covered
fmovs %f18, %f13

P1881: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1882: !_BST [4] (maybe <- 0x410000d5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1883: !_BST [12] (maybe <- 0x410000d6) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1883
nop
RET1883:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P1884: !_BST [9] (maybe <- 0x410000d7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1885: !_BST [10] (maybe <- 0x410000d8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1886: !_BST [13] (maybe <- 0x410000d9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1887: !_BST [3] (maybe <- 0x410000da) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1888: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1889: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1890: !_BST [13] (maybe <- 0x410000de) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1891: !_DWLD [2] (Int)
ldx [%i0 + 8], %l7
! move %l7(lower) -> %o2(lower)
srl %l7, 0, %l6
or %l6, %o2, %o2

P1892: !_BST [13] (maybe <- 0x410000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1893: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P1894: !_DWLD [0] (Int)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

P1895: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1896: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P1897: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1898: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1899: !_DWLD [5] (Int)
ldx [%i1 + 72], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P1900: !_ST [10] (maybe <- 0x1800020) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P1901: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f0
membar #Sync 
! 1 addresses covered

P1902: !_BST [6] (maybe <- 0x410000e0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1903: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1904: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1905: !_BST [4] (maybe <- 0x410000e3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1906: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P1907: !_ST [3] (maybe <- 0x410000e4) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P1908: !_BST [7] (maybe <- 0x410000e5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1909: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1910: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1911: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P1912: !_LD [13] (Int)
lduw [%i3 + 64], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P1913: !_BST [8] (maybe <- 0x410000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1914: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1915: !_BST [14] (maybe <- 0x410000e9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1916: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1917: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P1918: !_LD [8] (FP)
ld [%i1 + 256], %f11
! 1 addresses covered

P1919: !_DWLD [13] (Int)
ldx [%i3 + 64], %o0
! move %o0(upper) -> %o0(upper)

P1920: !_BST [12] (maybe <- 0x410000ea) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1921: !_BST [12] (maybe <- 0x410000eb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1922: !_DWST [3] (maybe <- 0x1800021) (Int) (Branch target of P1586)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4
ba P1923
nop

TARGET1586:
ba RET1586
nop


P1923: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P1924: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1925: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1926: !_BST [8] (maybe <- 0x410000ec) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1927: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P1928: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1929: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1930: !_BST [4] (maybe <- 0x410000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1931: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P1932: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P1933: !_BST [12] (maybe <- 0x410000ee) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P1934: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1935: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1936: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P1937: !_MEMBAR (Int)
membar #StoreLoad

P1938: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P1939: !_BLD [4] (FP) (Branch target of P1831)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8
ba P1940
nop

TARGET1831:
ba RET1831
nop


P1940: !_BST [1] (maybe <- 0x410000ef) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1941: !_BST [4] (maybe <- 0x410000f3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P1942: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1943: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1944: !_BST [2] (maybe <- 0x410000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1945: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P1946: !_BST [14] (maybe <- 0x410000f8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1947: !_REPLACEMENT [2] (Int)
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

P1948: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P1949: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P1950: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P1951: !_BST [5] (maybe <- 0x410000f9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1952: !_BST [3] (maybe <- 0x410000fc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1953: !_SWAP [5] (maybe <- 0x1800022) (Int)
mov %l4, %l3
swap  [%i1 + 76], %l3
! move %l3(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srl %l3, 0, %l7
or %l7, %o0, %o0
add   %l4, 1, %l4

P1954: !_BST [10] (maybe <- 0x41000100) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1955: !_BST [14] (maybe <- 0x41000101) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P1956: !_BST [9] (maybe <- 0x41000102) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1957: !_BST [1] (maybe <- 0x41000103) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1958: !_BST [1] (maybe <- 0x41000107) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1959: !_BST [7] (maybe <- 0x4100010b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1960: !_BST [5] (maybe <- 0x4100010e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1961: !_BST [10] (maybe <- 0x41000111) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P1962: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P1963: !_BST [12] (maybe <- 0x41000112) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1963
nop
RET1963:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1964: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

P1965: !_BLD [5] (FP) (Branch target of P1740)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2
ba P1966
nop

TARGET1740:
ba RET1740
nop


P1966: !_BST [7] (maybe <- 0x41000113) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1967: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P1968: !_BST [0] (maybe <- 0x41000116) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1969: !_BST [15] (maybe <- 0x4100011a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1970: !_BST [11] (maybe <- 0x4100011b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P1971: !_CASX [0] (maybe <- 0x1800023) (Int)
add %i0, 0, %l7
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

P1972: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P1973: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P1974: !_BST [1] (maybe <- 0x4100011c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1975: !_BST [13] (maybe <- 0x41000120) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P1976: !_BST [15] (maybe <- 0x41000121) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P1977: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P1978: !_BST [9] (maybe <- 0x41000122) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P1979: !_BST [2] (maybe <- 0x41000123) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1980: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1980
nop
RET1980:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P1981: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P1982: !_DWLD [0] (Int) (CBR)
ldx [%i0 + 0], %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET1982
nop
RET1982:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P1983: !_CAS [2] (maybe <- 0x1800025) (Int)
add %i0, 12, %l6
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

P1984: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P1985: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P1986: !_BST [8] (maybe <- 0x41000127) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P1987: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P1988: !_BST [0] (maybe <- 0x41000128) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1989: !_CAS [3] (maybe <- 0x1800026) (Int)
add %i0, 32, %o5
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

P1990: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P1991: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET1991
nop
RET1991:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P1992: !_BST [3] (maybe <- 0x4100012c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P1993: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P1994: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P1995: !_BST [6] (maybe <- 0x41000130) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P1996: !_DWLD [13] (Int)
ldx [%i3 + 64], %o1
! move %o1(upper) -> %o1(upper)

P1997: !_DWLD [12] (Int)
ldx [%i3 + 0], %l3
! move %l3(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l3, 32, %o5
or %o5, %o1, %o1

P1998: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P1999: !_BST [13] (maybe <- 0x41000133) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2000: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2001: !_CAS [6] (maybe <- 0x1800027) (Int)
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

P2002: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2003: !_REPLACEMENT [3] (Int)
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

P2004: !_BST [3] (maybe <- 0x41000134) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2005: !_CASX [6] (maybe <- 0x1800028) (Int)
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

P2006: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2007: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2008: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2009: !_BST [4] (maybe <- 0x41000138) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2010: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2011: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2012: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2013: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P2014: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P2015: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2016: !_LD [12] (Int)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2017: !_PREFETCH [5] (Int) (CBR)
prefetch [%i1 + 76], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2017
nop
RET2017:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2018: !_BST [13] (maybe <- 0x41000139) (FP) (Branch target of P1615)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 
ba P2019
nop

TARGET1615:
ba RET1615
nop


P2019: !_BST [8] (maybe <- 0x4100013a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2020: !_BST [0] (maybe <- 0x4100013b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2021: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P2022: !_BST [3] (maybe <- 0x4100013f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2023: !_PREFETCH [12] (Int) (Branch target of P1816)
prefetch [%i3 + 0], 1
ba P2024
nop

TARGET1816:
ba RET1816
nop


P2024: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2025: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P2026: !_LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P2027: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2028: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2029: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2030: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2031: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2032: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2033: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P2034: !_BST [6] (maybe <- 0x41000143) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2035: !_CASX [13] (maybe <- 0x180002a) (Int)
add %i3, 64, %l7
ldx [%l7], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l6
sllx %l4, 32, %o2
casx [%l7], %l6, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P2036: !_BST [3] (maybe <- 0x41000146) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2037: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2038: !_BST [10] (maybe <- 0x4100014a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2039: !_BST [7] (maybe <- 0x4100014b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2040: !_DWST [15] (maybe <- 0x180002b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4

P2041: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2042: !_PREFETCH [9] (Int) (CBR)
prefetch [%i1 + 512], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2042
nop
RET2042:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2043: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P2044: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2045: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2046: !_LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2047: !_BST [4] (maybe <- 0x4100014e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2048: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2049: !_BST [13] (maybe <- 0x4100014f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2050: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P2051: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2052: !_MEMBAR (Int)
membar #StoreLoad

P2053: !_LD [0] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 0] %asi, %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P2054: !_LD [1] (Int)
lduw [%i0 + 4], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2055: !_LD [2] (Int)
lduw [%i0 + 12], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2056: !_LD [3] (FP)
ld [%i0 + 32], %f3
! 1 addresses covered

P2057: !_LD [4] (FP)
ld [%i0 + 64], %f4
! 1 addresses covered

P2058: !_LD [5] (FP)
ld [%i1 + 76], %f5
! 1 addresses covered

P2059: !_LD [6] (Int)
lduw [%i1 + 80], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2060: !_LD [7] (Int)
lduw [%i1 + 84], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P2061: !_LD [8] (Int)
lduw [%i1 + 256], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2062: !_LD [9] (Int)
lduw [%i1 + 512], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P2063: !_LD [10] (Int)
lduw [%i2 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2064: !_LD [11] (Int)
lduw [%i2 + 64], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P2065: !_LD [12] (Int)
lduw [%i3 + 0], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2066: !_LD [13] (Int)
lduw [%i3 + 64], %o5
! move %o5(lower) -> %o3(lower)
or %o5, %o3, %o3

P2067: !_LD [14] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i3 + 128] %asi, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2068: !_LD [15] (Int)
lduw [%i3 + 192], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

END_NODES3: ! Test istream for CPU 3 ends
sethi %hi(0xdead0e0f), %l3
or    %l3, %lo(0xdead0e0f), %l3
! move %l3(lower) -> %o0(upper)
sllx %l3, 32, %o0
stw %l3, [%i5] 
ld [%i5], %f6
!---- flushing int results buffer----
mov %o0, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30

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
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0xdeadbee0), %o5
or    %o5, %lo(0xdeadbee0), %o5
stw   %o5, [%i5]
sethi %hi(0xdeadbee1), %o5
or    %o5, %lo(0xdeadbee1), %o5
stw   %o5, [%i5+4]
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
sethi %hi(0x04deade1), %o5
or    %o5, %lo(0x04deade1), %o5
stw %o5, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x2000001), %l4
or    %l4, %lo(0x2000001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x41800001), %o5
or    %o5, %lo(0x41800001), %o5
stw %o5, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x36000000), %o5
or    %o5, %lo(0x36000000), %o5
stw %o5, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x6630^4
sethi %hi(0x6630), %l0
or    %l0, %lo(0x6630), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 2 to 1 ---

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l3
add %i3, %l3, %l3
sub %l3, -4096, %l3

!-- begin of sync_init ---
or %g0, 1, %l6
or %g0, %l6, %l7
swap [%l3+4], %l7
membar #Sync
sync_init_1_4:
brnz,pt %l6, sync_init_1_4
lduw [%l3+4], %l6 ! delay slot
sync_init_2_4:
lduw [%l3], %l6
sub %l6, 1, %l7
cas [%l3], %l6, %l7
cmp %l6, %l7
bne,pt %xcc, sync_init_2_4
nop
membar #Sync
sync_init_3_4:
lduw [%l3], %l6 ! delay slot
brnz,pt %l6, sync_init_3_4
nop
!-- end of sync_init ---


BEGIN_NODES4: ! Test istream for CPU 4 begins

P2069: !_ST [7] (maybe <- 0x41800001) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 84 ]

P2070: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P2071: !_BST [1] (maybe <- 0x41800002) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2072: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2073: !_PREFETCH [3] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 32] %asi, 1

P2074: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P2075: !_BST [11] (maybe <- 0x41800006) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2076: !_BST [9] (maybe <- 0x41800007) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2077: !_BST [8] (maybe <- 0x41800008) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2078: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2079: !_CAS [4] (maybe <- 0x2000001) (Int)
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

P2080: !_DWST [12] (maybe <- 0x2000002) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2081: !_BST [0] (maybe <- 0x41800009) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2082: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2083: !_BST [0] (maybe <- 0x4180000d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2084: !_BST [4] (maybe <- 0x41800011) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2084
nop
RET2084:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2085: !_BST [0] (maybe <- 0x41800012) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2085
nop
RET2085:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2086: !_BST [7] (maybe <- 0x41800016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2087: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2088: !_DWLD [9] (Int)
ldx [%i1 + 512], %o1
! move %o1(upper) -> %o1(upper)

P2089: !_DWST [5] (maybe <- 0x2000003) (Int)
mov %l4, %l3 
stx %l3, [%i1 + 72]
add   %l4, 1, %l4

P2090: !_BST [4] (maybe <- 0x41800019) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2091: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2091
nop
RET2091:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2092: !_BST [0] (maybe <- 0x4180001a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2093: !_BST [3] (maybe <- 0x4180001e) (FP) (Branch target of P2242)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P2094
nop

TARGET2242:
ba RET2242
nop


P2094: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2095: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2096: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l7, %o1, %o1

P2097: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2097
nop
RET2097:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2098: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P2099: !_DWST [0] (maybe <- 0x41800022) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i0 + 0]

P2100: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2101: !_BLD [9] (FP) (Branch target of P2097)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8
ba P2102
nop

TARGET2097:
ba RET2097
nop


P2102: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P2103: !_BST [3] (maybe <- 0x41800024) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2104: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2105: !_BST [5] (maybe <- 0x41800028) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2106: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f1

P2107: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P2108: !_MEMBAR (Int)
membar #StoreLoad

P2109: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P2110: !_BST [14] (maybe <- 0x4180002b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2111: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2112: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P2113: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2114: !_LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2115: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2116: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2117: !_CASX [6] (maybe <- 0x2000004) (Int)
add %i1, 80, %o5
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

P2118: !_DWST [12] (maybe <- 0x2000006) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2119: !_LD [15] (Int)
lduw [%i3 + 192], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2120: !_BST [2] (maybe <- 0x4180002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2121: !_REPLACEMENT [11] (Int)
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

P2122: !_BST [7] (maybe <- 0x41800030) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2123: !_DWST [2] (maybe <- 0x2000007) (Int)
mov %l4, %l3 
stx %l3, [%i0 + 8]
add   %l4, 1, %l4

P2124: !_BST [3] (maybe <- 0x41800033) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2125: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P2126: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2127: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2128: !_DWST [15] (maybe <- 0x2000008) (Int) (Branch target of P2084)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 192 ] 
add   %l4, 1, %l4
ba P2129
nop

TARGET2084:
ba RET2084
nop


P2129: !_BST [6] (maybe <- 0x41800037) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2130: !_BST [15] (maybe <- 0x4180003a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2131: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P2132: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2133: !_LD [1] (Int)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2134: !_DWLD [10] (Int)
ldx [%i2 + 32], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l6
or %l6, %o0, %o0

P2135: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2136: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2137: !_BST [11] (maybe <- 0x4180003b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2138: !_BST [8] (maybe <- 0x4180003c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2139: !_LD [1] (Int)
lduw [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2140: !_BST [2] (maybe <- 0x4180003d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2141: !_BST [6] (maybe <- 0x41800041) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2142: !_BST [5] (maybe <- 0x41800044) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2143: !_BST [1] (maybe <- 0x41800047) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2144: !_DWLD [15] (Int)
ldx [%i3 + 192], %l3
! move %l3(upper) -> %o1(lower)
srlx %l3, 32, %o5
or %o5, %o1, %o1

P2145: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2146: !_LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2147: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2148: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2149: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2149
nop
RET2149:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2150: !_DWLD [5] (Int)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %l3
or %l3, %o2, %o2

P2151: !_CAS [8] (maybe <- 0x2000009) (Int)
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

P2152: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2153: !_BLD [5] (FP) (Branch target of P2246)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0
ba P2154
nop

TARGET2246:
ba RET2246
nop


P2154: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P2155: !_BST [2] (maybe <- 0x4180004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2156: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2157: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P2158: !_BST [13] (maybe <- 0x4180004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2159: !_BST [8] (maybe <- 0x41800050) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2160: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2161: !_DWLD [14] (Int)
ldx [%i3 + 128], %o4
! move %o4(upper) -> %o4(upper)

P2162: !_BST [15] (maybe <- 0x41800051) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2163: !_BST [3] (maybe <- 0x41800052) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2164: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2165: !_ST [9] (maybe <- 0x200000a) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P2166: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2167: !_BST [11] (maybe <- 0x41800056) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2167
nop
RET2167:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2168: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P2169: !_BST [9] (maybe <- 0x41800057) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2170: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2171: !_BST [9] (maybe <- 0x41800058) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2172: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2173: !_BST [15] (maybe <- 0x41800059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2174: !_BST [4] (maybe <- 0x4180005a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2175: !_BST [14] (maybe <- 0x4180005b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2176: !_ST [8] (maybe <- 0x200000b) (Int) (LE)
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

P2177: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2178: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2179: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2180: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2181: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P2182: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2183: !_MEMBAR (Int)
membar #StoreLoad

P2184: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2185: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2186: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2187: !_BST [14] (maybe <- 0x4180005c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2188: !_BST [15] (maybe <- 0x4180005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2189: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P2190: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2191: !_BST [10] (maybe <- 0x4180005e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2192: !_LD [8] (Int) (Branch target of P2335)
lduw [%i1 + 256], %l7
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
ba P2193
nop

TARGET2335:
ba RET2335
nop


P2193: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P2194: !_BST [2] (maybe <- 0x4180005f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2195: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2196: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2197: !_REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l7
or %l7, %lo(0xc0),  %l7
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

P2198: !_DWLD [13] (Int)
ldx [%i3 + 64], %o0
! move %o0(upper) -> %o0(upper)

P2199: !_CASX [11] (maybe <- 0x200000c) (Int)
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

P2200: !_DWST [6] (maybe <- 0x200000d) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2201: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2202: !_BST [6] (maybe <- 0x41800063) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2203: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2204: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P2205: !_DWST [1] (maybe <- 0x200000f) (Int) (CBR)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2205
nop
RET2205:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2206: !_BST [7] (maybe <- 0x41800066) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2207: !_BST [1] (maybe <- 0x41800069) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2208: !_PREFETCH [7] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 84] %asi, 1

P2209: !_BST [5] (maybe <- 0x4180006d) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2209
nop
RET2209:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2210: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2211: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2212: !_PREFETCH [9] (Int) (Branch target of P2149)
prefetch [%i1 + 512], 1
ba P2213
nop

TARGET2149:
ba RET2149
nop


P2213: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2214: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2215: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2216: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P2217: !_ST [12] (maybe <- 0x2000011) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P2218: !_BST [15] (maybe <- 0x41800070) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2219: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2220: !_BST [4] (maybe <- 0x41800071) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2221: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2222: !_DWLD [15] (Int)
ldx [%i3 + 192], %l6
! move %l6(upper) -> %o2(lower)
srlx %l6, 32, %l3
or %l3, %o2, %o2

P2223: !_REPLACEMENT [11] (Int)
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

P2224: !_BST [1] (maybe <- 0x41800072) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2225: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f12

P2226: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2227: !_BST [9] (maybe <- 0x41800076) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2228: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2229: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P2230: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2231: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2232: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P2233: !_BST [3] (maybe <- 0x41800077) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2234: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2234
nop
RET2234:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2235: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2236: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f10

P2237: !_BST [9] (maybe <- 0x4180007b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2238: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2239: !_ST [15] (maybe <- 0x2000012) (Int) (Branch target of P2264)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4
ba P2240
nop

TARGET2264:
ba RET2264
nop


P2240: !_LD [11] (Int) (Branch target of P2409)
lduw [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
ba P2241
nop

TARGET2409:
ba RET2409
nop


P2241: !_BST [7] (maybe <- 0x4180007c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2242: !_BST [11] (maybe <- 0x4180007f) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2242
nop
RET2242:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2243: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2244: !_MEMBAR (Int)
membar #StoreLoad

P2245: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2246: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2246
nop
RET2246:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2247: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f13

P2248: !_BST [6] (maybe <- 0x41800080) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2249: !_BST [11] (maybe <- 0x41800083) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2250: !_BST [14] (maybe <- 0x41800084) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2251: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2252: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P2253: !_DWLD [12] (Int)
ldx [%i3 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3

P2254: !_BST [5] (maybe <- 0x41800085) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2255: !_DWST [7] (maybe <- 0x2000013) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P2256: !_CAS [3] (maybe <- 0x2000015) (Int)
add %i0, 32, %l6
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

P2257: !_BST [12] (maybe <- 0x41800088) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2258: !_ST [3] (maybe <- 0x2000016) (Int) (CBR)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2258
nop
RET2258:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2259: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2260: !_DWST [10] (maybe <- 0x41800089) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P2261: !_REPLACEMENT [0] (Int)
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

P2262: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2263: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2264: !_BLD [3] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2264
nop
RET2264:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2265: !_PREFETCH [10] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 32] %asi, 1

P2266: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2267: !_BST [5] (maybe <- 0x4180008a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2268: !_CAS [10] (maybe <- 0x2000017) (Int)
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

P2269: !_BST [9] (maybe <- 0x4180008d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2270: !_PREFETCH [5] (Int) (Branch target of P2234)
prefetch [%i1 + 76], 1
ba P2271
nop

TARGET2234:
ba RET2234
nop


P2271: !_CAS [0] (maybe <- 0x2000018) (Int)
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

P2272: !_DWLD [3] (Int)
ldx [%i0 + 32], %o2
! move %o2(upper) -> %o2(upper)

P2273: !_BST [4] (maybe <- 0x4180008e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2274: !_BST [9] (maybe <- 0x4180008f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2275: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2276: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2277: !_BST [12] (maybe <- 0x41800090) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2278: !_BST [2] (maybe <- 0x41800091) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2279: !_CASX [8] (maybe <- 0x2000019) (Int)
add %i1, 256, %o5
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

P2280: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2281: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P2282: !_BST [12] (maybe <- 0x41800095) (FP) (Branch target of P2209)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 
ba P2283
nop

TARGET2209:
ba RET2209
nop


P2283: !_BST [2] (maybe <- 0x41800096) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2284: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2285: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2286: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2287: !_DWLD [15] (Int)
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

P2288: !_BST [4] (maybe <- 0x4180009a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2289: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P2290: !_BST [0] (maybe <- 0x4180009b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2291: !_BST [12] (maybe <- 0x4180009f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2292: !_DWST [7] (maybe <- 0x200001a) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2293: !_LD [12] (Int) (Branch target of P2574)
lduw [%i3 + 0], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
ba P2294
nop

TARGET2574:
ba RET2574
nop


P2294: !_BST [5] (maybe <- 0x418000a0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2295: !_DWLD [6] (Int)
ldx [%i1 + 80], %l3
! move %l3(upper) -> %o0(lower)
srlx %l3, 32, %o5
or %o5, %o0, %o0
! move %l3(lower) -> %o1(upper)
sllx %l3, 32, %o1

P2296: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2297: !_BST [11] (maybe <- 0x418000a3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2298: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P2299: !_LD [6] (Int) (Branch target of P2447)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1
ba P2300
nop

TARGET2447:
ba RET2447
nop


P2300: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2301: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2302: !_DWLD [7] (Int) (CBR)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2302
nop
RET2302:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2303: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P2304: !_CASX [2] (maybe <- 0x200001c) (Int)
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

P2305: !_BST [8] (maybe <- 0x418000a4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2306: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2307: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P2308: !_BST [0] (maybe <- 0x418000a5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2309: !_PREFETCH [5] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 76] %asi, 1

P2310: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2311: !_BST [14] (maybe <- 0x418000a9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2312: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2313: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P2314: !_BST [0] (maybe <- 0x418000aa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2315: !_BST [2] (maybe <- 0x418000ae) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2316: !_BLD [5] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2316
nop
RET2316:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2317: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2318: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2319: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2320: !_CASX [6] (maybe <- 0x200001d) (Int)
add %i1, 80, %l7
ldx [%l7], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov %o0, %l6
sllx %l4, 32, %o1
add  %l4, 1, %l4
or   %l4, %o1, %o1
casx [%l7], %l6, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P2321: !_BST [8] (maybe <- 0x418000b2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2322: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2323: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2324: !_BST [0] (maybe <- 0x418000b3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2325: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2326: !_DWLD [15] (FP)
ldd [%i3 + 192], %f18
! 1 addresses covered
fmovs %f18, %f13

P2327: !_ST [15] (maybe <- 0x200001f) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P2328: !_BST [4] (maybe <- 0x418000b7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2329: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2330: !_BLD [6] (FP) (Branch target of P2460)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0
ba P2331
nop

TARGET2460:
ba RET2460
nop


P2331: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2331
nop
RET2331:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2332: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2333: !_ST [2] (maybe <- 0x2000020) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2334: !_BST [11] (maybe <- 0x418000b8) (FP) (Branch target of P2536)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 
ba P2335
nop

TARGET2536:
ba RET2536
nop


P2335: !_BST [0] (maybe <- 0x418000b9) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

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


P2336: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2337: !_BLD [1] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2337
nop
RET2337:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2338: !_BST [3] (maybe <- 0x418000bd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2339: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2340: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2341: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2342: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2343: !_BST [15] (maybe <- 0x418000c1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2344: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2345: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2346: !_ST [7] (maybe <- 0x2000021) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2347: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2348: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2349: !_REPLACEMENT [14] (Int)
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

P2350: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P2351: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2352: !_BST [6] (maybe <- 0x418000c2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2353: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2354: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P2355: !_DWLD [9] (Int)
ldx [%i1 + 512], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2

P2356: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P2357: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P2358: !_SWAP [3] (maybe <- 0x2000022) (Int)
mov %l4, %o3
swap  [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P2359: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2360: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2361: !_MEMBAR (Int)
membar #StoreLoad

P2362: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2363: !_BST [2] (maybe <- 0x418000c5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2364: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2365: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2366: !_BST [14] (maybe <- 0x418000c9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2367: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P2368: !_BST [2] (maybe <- 0x418000ca) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2369: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2370: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f12

P2371: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2372: !_BLD [1] (FP) (CBR) (Branch target of P2491)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2372
nop
RET2372:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P2373
nop

TARGET2491:
ba RET2491
nop


P2373: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2374: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2375: !_BST [12] (maybe <- 0x418000ce) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2376: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2377: !_BST [0] (maybe <- 0x418000cf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2378: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P2379: !_BST [5] (maybe <- 0x418000d3) (FP) (Branch target of P2302)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P2380
nop

TARGET2302:
ba RET2302
nop


P2380: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2381: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2382: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2383: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2384: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2385: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2386: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P2387: !_CAS [3] (maybe <- 0x2000023) (Int)
add %i0, 32, %o5
lduw [%o5], %l6
mov %l6, %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3
mov %l4, %o4
cas [%o5], %l7, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2388: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2389: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P2390: !_BST [4] (maybe <- 0x418000d6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2391: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P2392: !_LD [13] (Int)
lduw [%i3 + 64], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2393: !_LD [4] (Int)
lduw [%i0 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2394: !_DWST [7] (maybe <- 0x2000024) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i1 + 80]
add   %l4, 1, %l4

P2395: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2396: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2397: !_BST [11] (maybe <- 0x418000d7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2398: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P2399: !_DWST [15] (maybe <- 0x2000026) (Int) (Branch target of P2331)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4
ba P2400
nop

TARGET2331:
ba RET2331
nop


P2400: !_BST [5] (maybe <- 0x418000d8) (FP) (Branch target of P2091)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P2401
nop

TARGET2091:
ba RET2091
nop


P2401: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P2402: !_PREFETCH [9] (Int) (Branch target of P2085)
prefetch [%i1 + 512], 1
ba P2403
nop

TARGET2085:
ba RET2085
nop


P2403: !_BLD [2] (FP) (Branch target of P2429)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14
ba P2404
nop

TARGET2429:
ba RET2429
nop


P2404: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P2405: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2406: !_PREFETCH [2] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

P2407: !_BST [7] (maybe <- 0x418000db) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2408: !_DWLD [10] (Int)
ldx [%i2 + 32], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0

P2409: !_BLD [8] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2409
nop
RET2409:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2410: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2411: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2412: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2413: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2414: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P2415: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2416: !_DWLD [14] (Int)
ldx [%i3 + 128], %o1
! move %o1(upper) -> %o1(upper)

P2417: !_ST [2] (maybe <- 0x418000de) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 12 ]

P2418: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P2419: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2420: !_DWST [12] (maybe <- 0x2000027) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 0 ] 
add   %l4, 1, %l4

P2421: !_BST [9] (maybe <- 0x418000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2422: !_BST [12] (maybe <- 0x418000e0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2423: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2424: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2425: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P2426: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f2

P2427: !_BST [8] (maybe <- 0x418000e1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2428: !_CASX [2] (maybe <- 0x2000028) (Int) (Branch target of P2337)
add %i0, 8, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %o5, 32, %l3
or %l3, %o1, %o1
! move %o5(lower) -> %o2(upper)
sllx %o5, 32, %o2
mov  %o5, %l3
mov %l4, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l6
or %l6, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
add  %l4, 1, %l4
ba P2429
nop

TARGET2337:
ba RET2337
nop


P2429: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2429
nop
RET2429:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2430: !_BST [7] (maybe <- 0x418000e2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2431: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2432: !_CAS [3] (maybe <- 0x2000029) (Int)
add %i0, 32, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3
mov %l4, %o4
cas [%l6], %l3, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2433: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2434: !_DWST [8] (maybe <- 0x200002a) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 256 ] 
add   %l4, 1, %l4

P2435: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2436: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2437: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f5

P2438: !_ST [1] (maybe <- 0x200002b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2439: !_BST [13] (maybe <- 0x418000e5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2440: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P2441: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P2442: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2443: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2444: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2445: !_BST [12] (maybe <- 0x418000e6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2446: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P2447: !_BST [10] (maybe <- 0x418000e7) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2447
nop
RET2447:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2448: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2449: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2450: !_BST [2] (maybe <- 0x418000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2451: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P2452: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2453: !_NOP (Int)
nop

P2454: !_REPLACEMENT [2] (Int)
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

P2455: !_LD [13] (Int)
lduw [%i3 + 64], %o5
! move %o5(lower) -> %o4(lower)
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2456: !_BST [15] (maybe <- 0x418000ec) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2457: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2458: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2459: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2460: !_BST [15] (maybe <- 0x418000ed) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2460
nop
RET2460:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2461: !_BST [13] (maybe <- 0x418000ee) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2462: !_LD [3] (Int)
lduw [%i0 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2463: !_BST [5] (maybe <- 0x418000ef) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2463
nop
RET2463:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2464: !_BST [14] (maybe <- 0x418000f2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2465: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2466: !_BST [15] (maybe <- 0x418000f3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2467: !_BST [2] (maybe <- 0x418000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2468: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2469: !_BST [12] (maybe <- 0x418000f8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2470: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2471: !_BST [3] (maybe <- 0x418000f9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2472: !_BST [14] (maybe <- 0x418000fd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2473: !_BST [2] (maybe <- 0x418000fe) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2474: !_DWLD [5] (Int)
ldx [%i1 + 72], %l7
! move %l7(lower) -> %o0(lower)
srl %l7, 0, %l6
or %l6, %o0, %o0

P2475: !_PREFETCH [11] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 64] %asi, 1

P2476: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2477: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2478: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2479: !_BST [11] (maybe <- 0x41800102) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2480: !_BST [0] (maybe <- 0x41800103) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2481: !_SWAP [2] (maybe <- 0x200002c) (Int)
mov %l4, %o1
swap  [%i0 + 12], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2482: !_CASX [0] (maybe <- 0x200002d) (Int)
add %i0, 0, %l6
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

P2483: !_SWAP [15] (maybe <- 0x200002f) (Int)
mov %l4, %l7
swap  [%i3 + 192], %l7
! move %l7(lower) -> %o3(lower)
srl %l7, 0, %l3
or %l3, %o3, %o3
add   %l4, 1, %l4

P2484: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2485: !_BST [2] (maybe <- 0x41800107) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2486: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P2487: !_DWLD [6] (FP)
ldd [%i1 + 80], %f14
! 2 addresses covered
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P2488: !_BST [11] (maybe <- 0x4180010b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2489: !_BST [8] (maybe <- 0x4180010c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2490: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P2491: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2491
nop
RET2491:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2492: !_CASX [2] (maybe <- 0x2000030) (Int)
add %i0, 8, %l7
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
mov %l4, %o0
casx [%l7], %l6, %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
add  %l4, 1, %l4

P2493: !_DWST [5] (maybe <- 0x2000031) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2494: !_DWLD [8] (Int)
ldx [%i1 + 256], %o1
! move %o1(upper) -> %o1(upper)

P2495: !_BST [7] (maybe <- 0x4180010d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2496: !_BST [0] (maybe <- 0x41800110) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2497: !_BST [15] (maybe <- 0x41800114) (FP) (Branch target of P2205)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 
ba P2498
nop

TARGET2205:
ba RET2205
nop


P2498: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2499: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2500: !_REPLACEMENT [5] (Int)
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

P2501: !_DWST [12] (maybe <- 0x2000032) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P2502: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2503: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P2504: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P2505: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2506: !_DWLD [10] (Int)
ldx [%i2 + 32], %l7
! move %l7(upper) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srlx %l7, 32, %l6
or %l6, %o1, %o1

P2507: !_BST [15] (maybe <- 0x41800115) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2508: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2509: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2510: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2511: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2512: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2513: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2514: !_BST [15] (maybe <- 0x41800116) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2515: !_BST [13] (maybe <- 0x41800117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2516: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2517: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f11

P2518: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2519: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2520: !_DWLD [0] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P2521: !_ST [3] (maybe <- 0x2000033) (Int) (Branch target of P2167)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4
ba P2522
nop

TARGET2167:
ba RET2167
nop


P2522: !_CASX [1] (maybe <- 0x2000034) (Int)
add %i0, 0, %l7
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

P2523: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2524: !_BST [14] (maybe <- 0x41800118) (FP) (Branch target of P2372)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 
ba P2525
nop

TARGET2372:
ba RET2372
nop


P2525: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P2526: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P2527: !_BST [6] (maybe <- 0x41800119) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2528: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P2529: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2530: !_REPLACEMENT [7] (Int) (Branch target of P2316)
sethi %hi(0x54), %o5
or %o5, %lo(0x54),  %o5
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
ba P2531
nop

TARGET2316:
ba RET2316
nop


P2531: !_BST [3] (maybe <- 0x4180011c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2532: !_REPLACEMENT [14] (Int)
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

P2533: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2534: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2535: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P2536: !_BLD [9] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2536
nop
RET2536:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2537: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P2538: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P2539: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P2540: !_BST [2] (maybe <- 0x41800120) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2541: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2542: !_PREFETCH [0] (Int) (Branch target of P2258)
prefetch [%i0 + 0], 1
ba P2543
nop

TARGET2258:
ba RET2258
nop


P2543: !_BST [14] (maybe <- 0x41800124) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2544: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2545: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2546: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P2547: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2548: !_BST [7] (maybe <- 0x41800125) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2549: !_BST [8] (maybe <- 0x41800128) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2550: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2551: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2552: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2553: !_BST [5] (maybe <- 0x41800129) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2554: !_BST [3] (maybe <- 0x4180012c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2555: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P2556: !_BST [7] (maybe <- 0x41800130) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2557: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2558: !_BLD [13] (FP) (Branch target of P2463)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14
ba P2559
nop

TARGET2463:
ba RET2463
nop


P2559: !_LD [0] (FP)
ld [%i0 + 0], %f15
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

P2560: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P2561: !_BST [4] (maybe <- 0x41800133) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2561
nop
RET2561:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2562: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2563: !_BST [9] (maybe <- 0x41800134) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2564: !_CAS [6] (maybe <- 0x2000036) (Int)
add %i1, 80, %l7
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

P2565: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2566: !_BST [14] (maybe <- 0x41800135) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2567: !_LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2568: !_NOP (Int)
nop

P2569: !_MEMBAR (Int)
membar #StoreLoad

P2570: !_LD [0] (Int)
lduw [%i0 + 0], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P2571: !_LD [1] (Int)
lduw [%i0 + 4], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2572: !_LD [2] (Int)
lduw [%i0 + 12], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P2573: !_LD [3] (FP) (Branch target of P2561)
ld [%i0 + 32], %f4
! 1 addresses covered
ba P2574
nop

TARGET2561:
ba RET2561
nop


P2574: !_LD [4] (Int) (CBR)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2574
nop
RET2574:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2575: !_LD [5] (FP)
ld [%i1 + 76], %f5
! 1 addresses covered

P2576: !_LD [6] (Int)
lduw [%i1 + 80], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

P2577: !_LD [7] (Int)
lduw [%i1 + 84], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2578: !_LD [8] (FP)
ld [%i1 + 256], %f6
! 1 addresses covered

P2579: !_LD [9] (Int)
lduw [%i1 + 512], %l3
! move %l3(lower) -> %o4(lower)
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2580: !_LD [10] (Int)
lduw [%i2 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2581: !_LD [11] (Int)
lduw [%i2 + 64], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P2582: !_LD [12] (Int)
lduw [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P2583: !_LD [13] (Int)
lduw [%i3 + 64], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P2584: !_LD [14] (Int)
lduw [%i3 + 128], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2585: !_LD [15] (Int)
lduw [%i3 + 192], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

END_NODES4: ! Test istream for CPU 4 ends
sethi %hi(0xdead0e0f), %l6
or    %l6, %lo(0xdead0e0f), %l6
! move %l6(lower) -> %o3(upper)
sllx %l6, 32, %o3
stw %l6, [%i5] 
ld [%i5], %f7
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30

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

func5:
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0xdeadbee0), %l3
or    %l3, %lo(0xdeadbee0), %l3
stw   %l3, [%i5]
sethi %hi(0xdeadbee1), %l3
or    %l3, %lo(0xdeadbee1), %l3
stw   %l3, [%i5+4]
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
sethi %hi(0x05deade1), %l3
or    %l3, %lo(0x05deade1), %l3
stw %l3, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x2800001), %l4
or    %l4, %lo(0x2800001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x42000001), %l3
or    %l3, %lo(0x42000001), %l3
stw %l3, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x36800000), %l3
or    %l3, %lo(0x36800000), %l3
stw %l3, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x320a^4
sethi %hi(0x320a), %l0
or    %l0, %lo(0x320a), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 2 to 2 ---
stx %g0, [%i0+8]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l6
add %i3, %l6, %l6
sub %l6, -4096, %l6

!-- begin of sync_init ---
or %g0, 1, %l7
or %g0, %l7, %o5
swap [%l6+4], %o5
membar #Sync
sync_init_1_5:
brnz,pt %l7, sync_init_1_5
lduw [%l6+4], %l7 ! delay slot
sync_init_2_5:
lduw [%l6], %l7
sub %l7, 1, %o5
cas [%l6], %l7, %o5
cmp %l7, %o5
bne,pt %xcc, sync_init_2_5
nop
membar #Sync
sync_init_3_5:
lduw [%l6], %l7 ! delay slot
brnz,pt %l7, sync_init_3_5
nop
!-- end of sync_init ---


BEGIN_NODES5: ! Test istream for CPU 5 begins

P2586: !_ST [12] (maybe <- 0x42000001) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P2587: !_BST [5] (maybe <- 0x42000002) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2588: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2589: !_CASX [1] (maybe <- 0x2800001) (Int)
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

P2590: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2591: !_DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P2592: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered
fmovd %f8, %f0

P2593: !_ST [5] (maybe <- 0x2800003) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P2594: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2595: !_DWST [3] (maybe <- 0x2800004) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i0 + 32 ] 
add   %l4, 1, %l4

P2596: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2597: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2598: !_DWLD [0] (Int)
ldx [%i0 + 0], %o5
! move %o5(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %o5, 32, %l7
or %l7, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3

P2599: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2600: !_BST [0] (maybe <- 0x42000005) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2601: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2602: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P2603: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2604: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P2605: !_LD [10] (FP) (CBR)
ld [%i2 + 32], %f6
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2605
nop
RET2605:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2606: !_LD [7] (FP)
ld [%i1 + 84], %f7
! 1 addresses covered

P2607: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2608: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2609: !_BST [8] (maybe <- 0x42000009) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2610: !_BST [14] (maybe <- 0x4200000a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2611: !_BST [1] (maybe <- 0x4200000b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2612: !_BST [7] (maybe <- 0x4200000f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2613: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2614: !_PREFETCH [5] (Int) (CBR)
prefetch [%i1 + 76], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2614
nop
RET2614:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2615: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2616: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2617: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2618: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2619: !_SWAP [15] (maybe <- 0x2800005) (Int)
mov %l4, %o5
swap  [%i3 + 192], %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P2620: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P2621: !_ST [6] (maybe <- 0x2800006) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P2622: !_BST [3] (maybe <- 0x42000012) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2623: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2624: !_BST [10] (maybe <- 0x42000016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2625: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2626: !_PREFETCH [6] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 80] %asi, 1

P2627: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2628: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2629: !_BST [5] (maybe <- 0x42000017) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2630: !_BST [0] (maybe <- 0x4200001a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2631: !_BST [1] (maybe <- 0x4200001e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2632: !_LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P2633: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2634: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2635: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2636: !_BST [0] (maybe <- 0x42000022) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2637: !_BST [8] (maybe <- 0x42000026) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2638: !_PREFETCH [1] (Int) (Branch target of P2981)
prefetch [%i0 + 4], 1
ba P2639
nop

TARGET2981:
ba RET2981
nop


P2639: !_BST [2] (maybe <- 0x42000027) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2640: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P2641: !_DWST [15] (maybe <- 0x2800007) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 192 ] 
add   %l4, 1, %l4

P2642: !_BST [6] (maybe <- 0x4200002b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2643: !_DWLD [15] (Int)
ldx [%i3 + 192], %l3
! move %l3(upper) -> %o4(lower)
srlx %l3, 32, %o5
or %o5, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2644: !_ST [10] (maybe <- 0x2800008) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P2645: !_BST [1] (maybe <- 0x4200002e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2646: !_PREFETCH [5] (Int) (Branch target of P3060)
prefetch [%i1 + 76], 1
ba P2647
nop

TARGET3060:
ba RET3060
nop


P2647: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2648: !_LD [9] (Int)
lduw [%i1 + 512], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2649: !_PREFETCH [0] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1

P2650: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2651: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2652: !_BST [14] (maybe <- 0x42000032) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2653: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P2654: !_DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o0(lower)
srlx %l6, 32, %l3
or %l3, %o0, %o0

P2655: !_BST [0] (maybe <- 0x42000033) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2656: !_BST [9] (maybe <- 0x42000037) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2657: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P2658: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P2659: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P2660: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2661: !_BST [15] (maybe <- 0x42000038) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2662: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2663: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P2664: !_MEMBAR (Int)
membar #StoreLoad

P2665: !_BST [5] (maybe <- 0x42000039) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2666: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P2667: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2668: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2669: !_MEMBAR (Int)
membar #StoreLoad

P2670: !_REPLACEMENT [12] (Int)
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

P2671: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2672: !_CASX [0] (maybe <- 0x2800009) (Int)
add %i0, 0, %l7
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

P2673: !_REPLACEMENT [6] (Int)
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

P2674: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2675: !_DWST [9] (maybe <- 0x280000b) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i1 + 512 ] 
add   %l4, 1, %l4

P2676: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2677: !_BST [0] (maybe <- 0x4200003c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2678: !_PREFETCH [0] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1

P2679: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2680: !_ST [13] (maybe <- 0x280000c) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2681: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2682: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2683: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P2684: !_BST [3] (maybe <- 0x42000040) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2685: !_REPLACEMENT [8] (Int)
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

P2686: !_DWST [15] (maybe <- 0x42000044) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i3 + 192]

P2687: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P2688: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P2689: !_PREFETCH [0] (Int) (CBR)
prefetch [%i0 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2689
nop
RET2689:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2690: !_BST [11] (maybe <- 0x42000045) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2691: !_BST [5] (maybe <- 0x42000046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2692: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P2693: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2694: !_BST [6] (maybe <- 0x42000049) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2695: !_LD [9] (Int)
lduw [%i1 + 512], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P2696: !_ST [2] (maybe <- 0x280000d) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P2697: !_BST [5] (maybe <- 0x4200004c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2698: !_BST [5] (maybe <- 0x4200004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2699: !_BST [12] (maybe <- 0x42000052) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2700: !_DWST [10] (maybe <- 0x42000053) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
std %f20, [%i2 + 32]

P2701: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2702: !_REPLACEMENT [10] (Int)
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

P2703: !_DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3

P2704: !_BST [6] (maybe <- 0x42000054) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2705: !_DWLD [1] (Int)
ldx [%i0 + 0], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2706: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f0
membar #Sync 
! 1 addresses covered

P2707: !_BST [15] (maybe <- 0x42000057) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2708: !_SWAP [7] (maybe <- 0x280000e) (Int)
mov %l4, %o0
swap  [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P2709: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2710: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2711: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P2712: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2713: !_BLD [7] (FP) (Branch target of P2614)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6
ba P2714
nop

TARGET2614:
ba RET2614
nop


P2714: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2715: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P2716: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P2717: !_BST [8] (maybe <- 0x42000058) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2718: !_BLD [4] (FP) (Branch target of P2729)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered
ba P2719
nop

TARGET2729:
ba RET2729
nop


P2719: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P2720: !_BST [12] (maybe <- 0x42000059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2721: !_ST [1] (maybe <- 0x280000f) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2722: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P2723: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f8

P2724: !_BST [10] (maybe <- 0x4200005a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2725: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2726: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P2727: !_BST [10] (maybe <- 0x4200005b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2728: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2729: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2729
nop
RET2729:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2730: !_PREFETCH [5] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 76] %asi, 1

P2731: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2732: !_BST [4] (maybe <- 0x4200005c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2733: !_REPLACEMENT [15] (Int)
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

P2734: !_BST [9] (maybe <- 0x4200005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2735: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2736: !_DWST [10] (maybe <- 0x2800010) (Int) (Branch target of P2836)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4
ba P2737
nop

TARGET2836:
ba RET2836
nop


P2737: !_BST [10] (maybe <- 0x4200005e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2738: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2739: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2740: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2741: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2742: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2743: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2744: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P2745: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2746: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2747: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2748: !_MEMBAR (Int)
membar #StoreLoad

P2749: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2750: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2751: !_BST [11] (maybe <- 0x4200005f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2752: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2753: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2754: !_LD [3] (Int)
lduw [%i0 + 32], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P2755: !_BST [1] (maybe <- 0x42000060) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2756: !_CAS [12] (maybe <- 0x2800011) (Int)
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

P2757: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P2758: !_BST [0] (maybe <- 0x42000064) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2759: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P2760: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2761: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P2762: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2763: !_ST [13] (maybe <- 0x2800012) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P2764: !_BST [7] (maybe <- 0x42000068) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2765: !_BST [8] (maybe <- 0x4200006b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2766: !_BLD [2] (FP) (Branch target of P2933)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2
ba P2767
nop

TARGET2933:
ba RET2933
nop


P2767: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2768: !_BST [4] (maybe <- 0x4200006c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2769: !_CASX [8] (maybe <- 0x2800013) (Int)
add %i1, 256, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P2770: !_DWLD [6] (FP)
ldd [%i1 + 80], %f18
! 2 addresses covered
fmovs %f18, %f3
fmovs %f19, %f4

P2771: !_MEMBAR (Int)
membar #StoreLoad

P2772: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P2773: !_DWLD [4] (FP)
ldd [%i0 + 64], %f8
! 1 addresses covered

P2774: !_BST [3] (maybe <- 0x4200006d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2775: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P2776: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P2777: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P2778: !_BST [4] (maybe <- 0x42000071) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2779: !_BST [3] (maybe <- 0x42000072) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2780: !_BST [12] (maybe <- 0x42000076) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2781: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2782: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P2783: !_BST [3] (maybe <- 0x42000077) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2784: !_BST [5] (maybe <- 0x4200007b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2785: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2786: !_BST [13] (maybe <- 0x4200007e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2787: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P2788: !_BST [14] (maybe <- 0x4200007f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2789: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2790: !_BST [12] (maybe <- 0x42000080) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2791: !_BST [6] (maybe <- 0x42000081) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2792: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2793: !_LD [5] (Int) (CBR)
lduw [%i1 + 76], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2793
nop
RET2793:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2794: !_BST [15] (maybe <- 0x42000084) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2795: !_DWST [6] (maybe <- 0x2800014) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P2796: !_BLD [8] (FP) (Branch target of P3092)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8
ba P2797
nop

TARGET3092:
ba RET3092
nop


P2797: !_NOP (Int)
nop

P2798: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2799: !_BST [11] (maybe <- 0x42000085) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2800: !_BST [0] (maybe <- 0x42000086) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2801: !_LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2802: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P2803: !_BST [5] (maybe <- 0x4200008a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2804: !_DWLD [0] (Int)
ldx [%i0 + 0], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)

P2805: !_BST [3] (maybe <- 0x4200008d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2806: !_BST [7] (maybe <- 0x42000091) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2807: !_BST [3] (maybe <- 0x42000094) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2808: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P2809: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2810: !_BST [4] (maybe <- 0x42000098) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2811: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2812: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2813: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f1

P2814: !_BST [4] (maybe <- 0x42000099) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2815: !_BST [13] (maybe <- 0x4200009a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P2816: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P2817: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P2818: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P2819: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2820: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2821: !_BST [3] (maybe <- 0x4200009b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2822: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2823: !_CAS [9] (maybe <- 0x2800016) (Int)
add %i1, 512, %l6
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

P2824: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P2825: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P2826: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2827: !_DWST [0] (maybe <- 0x2800017) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P2828: !_LD [5] (Int)
lduw [%i1 + 76], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P2829: !_BST [6] (maybe <- 0x4200009f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2830: !_BST [5] (maybe <- 0x420000a2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2831: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2832: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P2833: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P2834: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2835: !_BST [7] (maybe <- 0x420000a5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2836: !_MEMBAR (Int) (CBR) (Branch target of P2936)
membar #StoreLoad

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2836
nop
RET2836:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0

ba P2837
nop

TARGET2936:
ba RET2936
nop


P2837: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2838: !_DWST [6] (maybe <- 0x2800019) (Int) (LE)
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

P2839: !_DWST [5] (maybe <- 0x420000a8) (FP) (Branch target of P3017)
! 0 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 72]
ba P2840
nop

TARGET3017:
ba RET3017
nop


P2840: !_PREFETCH [10] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 32] %asi, 1

P2841: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2842: !_BST [0] (maybe <- 0x420000a9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2843: !_ST [1] (maybe <- 0x280001b) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P2844: !_LD [9] (Int)
lduw [%i1 + 512], %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2

P2845: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2846: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P2847: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2848: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2849: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2850: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P2851: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P2852: !_CASX [13] (maybe <- 0x280001c) (Int)
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

P2853: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P2854: !_PREFETCH [8] (Int) (Branch target of P2605)
prefetch [%i1 + 256], 1
ba P2855
nop

TARGET2605:
ba RET2605
nop


P2855: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2856: !_ST [12] (maybe <- 0x420000ad) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i3 + 0 ]

P2857: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P2858: !_LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P2859: !_BST [9] (maybe <- 0x420000ae) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2860: !_BST [4] (maybe <- 0x420000af) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2861: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2862: !_BLD [14] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2862
nop
RET2862:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P2863: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2864: !_ST [6] (maybe <- 0x280001d) (Int) (LE)
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

P2865: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2866: !_REPLACEMENT [3] (Int)
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

P2867: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P2868: !_SWAP [9] (maybe <- 0x280001e) (Int)
mov %l4, %l6
swap  [%i1 + 512], %l6
! move %l6(lower) -> %o0(lower)
srl %l6, 0, %o5
or %o5, %o0, %o0
add   %l4, 1, %l4

P2869: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P2870: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P2871: !_BST [0] (maybe <- 0x420000b0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2872: !_PREFETCH [15] (Int) (Branch target of P3007)
prefetch [%i3 + 192], 1
ba P2873
nop

TARGET3007:
ba RET3007
nop


P2873: !_BLD [15] (FP) (Branch target of P2954)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered
ba P2874
nop

TARGET2954:
ba RET2954
nop


P2874: !_BST [0] (maybe <- 0x420000b4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2875: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P2876: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2877: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2878: !_BST [6] (maybe <- 0x420000b8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2879: !_CAS [4] (maybe <- 0x280001f) (Int)
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

P2880: !_CASX [1] (maybe <- 0x2800020) (Int)
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

P2881: !_BST [3] (maybe <- 0x420000bb) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2881
nop
RET2881:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P2882: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2883: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P2884: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P2885: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2886: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P2887: !_BST [0] (maybe <- 0x420000bf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2888: !_BST [12] (maybe <- 0x420000c3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P2889: !_BST [14] (maybe <- 0x420000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2890: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2891: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2892: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P2893: !_ST [4] (maybe <- 0x2800022) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P2894: !_BST [3] (maybe <- 0x420000c5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2895: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f0
membar #Sync 
! 1 addresses covered

P2896: !_BST [2] (maybe <- 0x420000c9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2897: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P2898: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2899: !_BST [9] (maybe <- 0x420000cd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2900: !_BST [0] (maybe <- 0x420000ce) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2901: !_BST [13] (maybe <- 0x420000d2) (FP) (Branch target of P2689)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 
ba P2902
nop

TARGET2689:
ba RET2689
nop


P2902: !_BST [9] (maybe <- 0x420000d3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2903: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2904: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2905: !_BST [11] (maybe <- 0x420000d4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P2906: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2907: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P2908: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P2909: !_BST [6] (maybe <- 0x420000d5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2910: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P2911: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P2912: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P2913: !_BST [8] (maybe <- 0x420000d8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2914: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P2915: !_BST [3] (maybe <- 0x420000d9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2916: !_BST [0] (maybe <- 0x420000dd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2917: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f11

P2918: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2919: !_BST [7] (maybe <- 0x420000e1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2920: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2921: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P2922: !_ST [0] (maybe <- 0x2800023) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P2923: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P2924: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P2925: !_BST [7] (maybe <- 0x420000e4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2926: !_DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2927: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P2928: !_BST [1] (maybe <- 0x420000e7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2929: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2930: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P2931: !_BST [10] (maybe <- 0x420000eb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2932: !_DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P2933: !_PREFETCH [3] (Int) (CBR)
prefetch [%i0 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2933
nop
RET2933:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2934: !_MEMBAR (Int)
membar #StoreLoad

P2935: !_BST [9] (maybe <- 0x420000ec) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2936: !_BLD [2] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2936
nop
RET2936:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P2937: !_BST [7] (maybe <- 0x420000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2938: !_CAS [1] (maybe <- 0x2800024) (Int)
add %i0, 4, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P2939: !_BST [2] (maybe <- 0x420000f0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2940: !_PREFETCH [14] (Int) (Branch target of P2862)
prefetch [%i3 + 128], 1
ba P2941
nop

TARGET2862:
ba RET2862
nop


P2941: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2942: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P2943: !_BST [9] (maybe <- 0x420000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P2944: !_SWAP [0] (maybe <- 0x2800025) (Int)
mov %l4, %o5
swap  [%i0 + 0], %o5
! move %o5(lower) -> %o1(lower)
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P2945: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2946: !_DWST [0] (maybe <- 0x2800026) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P2947: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2948: !_CASX [6] (maybe <- 0x2800028) (Int)
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

P2949: !_ST [3] (maybe <- 0x280002a) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2950: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P2951: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P2952: !_BST [4] (maybe <- 0x420000f5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2953: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P2954: !_BLD [12] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET2954
nop
RET2954:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2955: !_BST [15] (maybe <- 0x420000f6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P2956: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2957: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P2958: !_DWST [5] (maybe <- 0x280002b) (Int)
mov %l4, %l6 
stx %l6, [%i1 + 72]
add   %l4, 1, %l4

P2959: !_BLD [3] (FP) (Branch target of P3091)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11
ba P2960
nop

TARGET3091:
ba RET3091
nop


P2960: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P2961: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2962: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P2963: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P2964: !_SWAP [8] (maybe <- 0x280002c) (Int)
mov %l4, %o4
swap  [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P2965: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P2966: !_ST [3] (maybe <- 0x280002d) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P2967: !_BST [3] (maybe <- 0x420000f7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2968: !_BST [6] (maybe <- 0x420000fb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2969: !_BST [4] (maybe <- 0x420000fe) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2970: !_BST [4] (maybe <- 0x420000ff) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P2971: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2972: !_BST [2] (maybe <- 0x42000100) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2973: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P2974: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P2975: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P2976: !_LD [5] (Int)
lduw [%i1 + 76], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P2977: !_ST [7] (maybe <- 0x280002e) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P2978: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2979: !_BST [8] (maybe <- 0x42000104) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2980: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P2981: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET2981
nop
RET2981:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P2982: !_BST [0] (maybe <- 0x42000105) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P2983: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P2984: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P2985: !_BST [7] (maybe <- 0x42000109) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2986: !_MEMBAR (Int)
membar #StoreLoad

P2987: !_BST [5] (maybe <- 0x4200010c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2988: !_BST [6] (maybe <- 0x4200010f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P2989: !_BST [14] (maybe <- 0x42000112) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P2990: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P2991: !_DWST [13] (maybe <- 0x280002f) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P2992: !_BST [8] (maybe <- 0x42000113) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P2993: !_BST [10] (maybe <- 0x42000114) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P2994: !_CASX [14] (maybe <- 0x2800030) (Int)
add %i3, 128, %o5
ldx [%o5], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %l7
sllx %l4, 32, %o1
casx [%o5], %l7, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P2995: !_MEMBAR (Int)
membar #StoreLoad

P2996: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P2997: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P2998: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P2999: !_DWLD [0] (Int)
ldx [%i0 + 0], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3000: !_BST [12] (maybe <- 0x42000115) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3001: !_BST [8] (maybe <- 0x42000116) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3002: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3003: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3004: !_BST [0] (maybe <- 0x42000117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3005: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P3006: !_BST [6] (maybe <- 0x4200011b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3007: !_ST [15] (maybe <- 0x2800031) (Int) (CBR)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3007
nop
RET3007:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3008: !_BST [6] (maybe <- 0x4200011e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3009: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P3010: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3011: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P3012: !_BST [5] (maybe <- 0x42000121) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3013: !_MEMBAR (Int)
membar #StoreLoad

P3014: !_BST [11] (maybe <- 0x42000124) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3015: !_DWST [1] (maybe <- 0x2800032) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3016: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P3017: !_BLD [8] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3017
nop
RET3017:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3018: !_LD [2] (Int)
lduw [%i0 + 12], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3019: !_BST [0] (maybe <- 0x42000125) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3020: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3021: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3022: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P3023: !_CASX [5] (maybe <- 0x2800034) (Int)
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

P3024: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P3025: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P3026: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P3027: !_BST [1] (maybe <- 0x42000129) (FP) (Branch target of P2881)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P3028
nop

TARGET2881:
ba RET2881
nop


P3028: !_BST [8] (maybe <- 0x4200012d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3029: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3030: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3031: !_ST [1] (maybe <- 0x2800035) (Int)
stw   %l4, [%i0 + 4 ]
add   %l4, 1, %l4

P3032: !_BST [13] (maybe <- 0x4200012e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3033: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3034: !_DWLD [2] (Int)
ldx [%i0 + 8], %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l7
or %l7, %o0, %o0

P3035: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P3036: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3037: !_BST [1] (maybe <- 0x4200012f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3038: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P3039: !_DWLD [9] (FP)
ldd [%i1 + 512], %f14
! 1 addresses covered

P3040: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3041: !_PREFETCH [15] (Int) (Branch target of P2793)
prefetch [%i3 + 192], 1
ba P3042
nop

TARGET2793:
ba RET2793
nop


P3042: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P3043: !_MEMBAR (Int)
membar #StoreLoad

P3044: !_DWST [7] (maybe <- 0x2800036) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i1 + 80]
add   %l4, 1, %l4

P3045: !_DWLD [11] (Int)
ldx [%i2 + 64], %o1
! move %o1(upper) -> %o1(upper)

P3046: !_BST [4] (maybe <- 0x42000133) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3047: !_BST [0] (maybe <- 0x42000134) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3048: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3049: !_MEMBAR (Int)
membar #StoreLoad

P3050: !_BST [15] (maybe <- 0x42000138) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3051: !_BST [6] (maybe <- 0x42000139) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3052: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3053: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P3054: !_BST [0] (maybe <- 0x4200013c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3055: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3056: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3057: !_BST [9] (maybe <- 0x42000140) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3058: !_BST [14] (maybe <- 0x42000141) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3059: !_DWST [4] (maybe <- 0x2800038) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4

P3060: !_BLD [0] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3060
nop
RET3060:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3061: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P3062: !_BST [10] (maybe <- 0x42000142) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3063: !_BST [2] (maybe <- 0x42000143) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3064: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3065: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P3066: !_BST [1] (maybe <- 0x42000147) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3067: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P3068: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3069: !_BST [5] (maybe <- 0x4200014b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3070: !_BST [9] (maybe <- 0x4200014e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3071: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3072: !_BST [14] (maybe <- 0x4200014f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3073: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P3074: !_BST [13] (maybe <- 0x42000150) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3075: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P3076: !_BST [12] (maybe <- 0x42000151) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3077: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3078: !_ST [7] (maybe <- 0x2800039) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3079: !_BST [4] (maybe <- 0x42000152) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3080: !_PREFETCH [15] (Int) (Branch target of P3095)
prefetch [%i3 + 192], 1
ba P3081
nop

TARGET3095:
ba RET3095
nop


P3081: !_ST [2] (maybe <- 0x280003a) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3082: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P3083: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3084: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3085: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3086: !_MEMBAR (Int)
membar #StoreLoad

P3087: !_LD [0] (Int)
lduw [%i0 + 0], %o5
! move %o5(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %o5, %o1, %o1

P3088: !_LD [1] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i0 + 4] %asi, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3089: !_LD [2] (Int)
lduw [%i0 + 12], %o5
! move %o5(lower) -> %o2(lower)
or %o5, %o2, %o2

P3090: !_LD [3] (Int)
lduw [%i0 + 32], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3091: !_LD [4] (FP) (CBR)
ld [%i0 + 64], %f3
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3091
nop
RET3091:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3092: !_LD [5] (Int) (CBR)
lduw [%i1 + 76], %l3
! move %l3(lower) -> %o3(lower)
or %l3, %o3, %o3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3092
nop
RET3092:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3093: !_LD [6] (Int)
lduw [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3094: !_LD [7] (Int)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3095: !_LD [8] (Int) (CBR)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3095
nop
RET3095:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3096: !_LD [9] (Int)
lduw [%i1 + 512], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P3097: !_LD [10] (FP)
ld [%i2 + 32], %f4
! 1 addresses covered

P3098: !_LD [11] (Int)
lduw [%i2 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3099: !_LD [12] (Int)
lduw [%i3 + 0], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P3100: !_LD [13] (Int)
lduw [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3101: !_LD [14] (Int)
lduw [%i3 + 128], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P3102: !_LD [15] (Int)
lduw [%i3 + 192], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

END_NODES5: ! Test istream for CPU 5 ends
sethi %hi(0xdead0e0f), %l6
or    %l6, %lo(0xdead0e0f), %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
stw %l6, [%i5] 
ld [%i5], %f5
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
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

func6:
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0xdeadbee0), %l3
or    %l3, %lo(0xdeadbee0), %l3
stw   %l3, [%i5]
sethi %hi(0xdeadbee1), %l3
or    %l3, %lo(0xdeadbee1), %l3
stw   %l3, [%i5+4]
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
sethi %hi(0x06deade1), %l3
or    %l3, %lo(0x06deade1), %l3
stw %l3, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x3000001), %l4
or    %l4, %lo(0x3000001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x42800001), %l3
or    %l3, %lo(0x42800001), %l3
stw %l3, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x37000000), %l3
or    %l3, %lo(0x37000000), %l3
stw %l3, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x78f7^4
sethi %hi(0x78f7), %l0
or    %l0, %lo(0x78f7), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 3 to 2 ---

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l6
add %i3, %l6, %l6
sub %l6, -4096, %l6

!-- begin of sync_init ---
or %g0, 1, %l7
or %g0, %l7, %o5
swap [%l6+4], %o5
membar #Sync
sync_init_1_6:
brnz,pt %l7, sync_init_1_6
lduw [%l6+4], %l7 ! delay slot
sync_init_2_6:
lduw [%l6], %l7
sub %l7, 1, %o5
cas [%l6], %l7, %o5
cmp %l7, %o5
bne,pt %xcc, sync_init_2_6
nop
membar #Sync
sync_init_3_6:
lduw [%l6], %l7 ! delay slot
brnz,pt %l7, sync_init_3_6
nop
!-- end of sync_init ---


BEGIN_NODES6: ! Test istream for CPU 6 begins

P3103: !_ST [15] (maybe <- 0x3000001) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P3104: !_REPLACEMENT [9] (Int)
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

P3105: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3106: !_BST [1] (maybe <- 0x42800001) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3107: !_PREFETCH [15] (Int) (Branch target of P3253)
prefetch [%i3 + 192], 1
ba P3108
nop

TARGET3253:
ba RET3253
nop


P3108: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3109: !_BST [3] (maybe <- 0x42800005) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3110: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f0
membar #Sync 
! 1 addresses covered

P3111: !_BLD [9] (FP) (Branch target of P3352)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
ba P3112
nop

TARGET3352:
ba RET3352
nop


P3112: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P3113: !_BST [0] (maybe <- 0x42800009) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3113
nop
RET3113:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3114: !_BST [9] (maybe <- 0x4280000d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3115: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3116: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3117: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3118: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P3119: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3120: !_DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P3121: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3122: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l7, %o0, %o0

P3123: !_ST [9] (maybe <- 0x3000002) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P3124: !_LD [15] (FP)
ld [%i3 + 192], %f9
! 1 addresses covered

P3125: !_DWLD [3] (Int)
ldx [%i0 + 32], %o1
! move %o1(upper) -> %o1(upper)

P3126: !_BST [12] (maybe <- 0x4280000e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3127: !_CASX [9] (maybe <- 0x3000003) (Int) (Branch target of P3307)
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
ba P3128
nop

TARGET3307:
ba RET3307
nop


P3128: !_BST [2] (maybe <- 0x4280000f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3129: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3130: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3131: !_BST [11] (maybe <- 0x42800013) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3132: !_BST [2] (maybe <- 0x42800014) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3133: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3134: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3135: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3136: !_DWLD [0] (Int) (CBR)
ldx [%i0 + 0], %l6
! move %l6(upper) -> %o3(lower)
srlx %l6, 32, %l3
or %l3, %o3, %o3
! move %l6(lower) -> %o4(upper)
sllx %l6, 32, %o4

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3136
nop
RET3136:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3137: !_BST [8] (maybe <- 0x42800018) (FP) (Branch target of P3238)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 
ba P3138
nop

TARGET3238:
ba RET3238
nop


P3138: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3139: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P3140: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3141: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3142: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P3143: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3144: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3145: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P3146: !_BST [13] (maybe <- 0x42800019) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3147: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P3148: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3149: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P3150: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3151: !_BST [13] (maybe <- 0x4280001a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3152: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3153: !_BST [12] (maybe <- 0x4280001b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3154: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P3155: !_DWST [8] (maybe <- 0x3000004) (Int) (LE)
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

P3156: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P3157: !_BST [4] (maybe <- 0x4280001c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3158: !_BST [7] (maybe <- 0x4280001d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3159: !_DWLD [0] (Int)
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

P3160: !_BST [11] (maybe <- 0x42800020) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3161: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3162: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3163: !_BST [7] (maybe <- 0x42800021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3164: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3165: !_BST [13] (maybe <- 0x42800024) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3166: !_DWST [13] (maybe <- 0x3000005) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 64 ] 
add   %l4, 1, %l4

P3167: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3168: !_BST [8] (maybe <- 0x42800025) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3169: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3170: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P3171: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3172: !_BST [4] (maybe <- 0x42800026) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3172
nop
RET3172:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3173: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3174: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P3175: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P3176: !_BST [6] (maybe <- 0x42800027) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3177: !_BST [4] (maybe <- 0x4280002a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3178: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3179: !_LD [1] (Int)
lduw [%i0 + 4], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P3180: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3181: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3182: !_BST [15] (maybe <- 0x4280002b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3183: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3184: !_BST [1] (maybe <- 0x4280002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3185: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3186: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P3187: !_ST [4] (maybe <- 0x3000006) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3188: !_PREFETCH [12] (Int) (CBR)
prefetch [%i3 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3188
nop
RET3188:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3189: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P3190: !_CASX [6] (maybe <- 0x3000007) (Int) (LE)
sllx %l4, 32, %l3
add  %l4, 1, %l4
or   %l4, %l3, %l3
! Change double-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
sllx %o5, 32, %l6
or %o5, %l6, %o5 
and %l3, %o5, %l6
srlx %l6, 8, %l6
sllx %l3, 8, %l3
and %l3, %o5, %l3
or %l3, %l6, %l3 
sethi %hi(0xffff0000), %o5
or %o5, %lo(0xffff0000), %o5
srlx %l3, 16, %l6
andn %l6, %o5, %l6
andn %l3, %o5, %l3
sllx %l3, 16, %l3
or %l3, %l6, %l3 
srlx %l3, 32, %l6
sllx %l3, 32, %l3
or %l3, %l6, %l6 
wr %g0, 0x88, %asi
add %i1, 80, %l3
ldxa [%l3] %asi, %l7
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %o5
or %o5, %o1, %o1
mov %l7, %o5
mov  %l6, %l7
casxa [%l3] %asi, %o5, %l7
! move %l7(lower) -> %o2(upper)
sllx %l7, 32, %o2
! move %l7(upper) -> %o2(lower)
srlx %l7, 32, %l3
or %l3, %o2, %o2
add  %l4, 1, %l4

P3191: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P3192: !_BST [10] (maybe <- 0x42800030) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3193: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3194: !_BST [8] (maybe <- 0x42800031) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3195: !_BST [5] (maybe <- 0x42800032) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3196: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P3197: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3198: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P3199: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P3200: !_DWLD [15] (Int)
ldx [%i3 + 192], %o3
! move %o3(upper) -> %o3(upper)

P3201: !_REPLACEMENT [11] (Int)
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

P3202: !_BST [8] (maybe <- 0x42800035) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3203: !_BST [11] (maybe <- 0x42800036) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3204: !_BST [1] (maybe <- 0x42800037) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3205: !_BST [14] (maybe <- 0x4280003b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3206: !_BST [11] (maybe <- 0x4280003c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3207: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P3208: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P3209: !_PREFETCH [0] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1

P3210: !_BST [9] (maybe <- 0x4280003d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3211: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P3212: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P3213: !_BST [11] (maybe <- 0x4280003e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3214: !_BST [1] (maybe <- 0x4280003f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3215: !_CASX [12] (maybe <- 0x3000009) (Int)
add %i3, 0, %l7
ldx [%l7], %l3
! move %l3(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
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

P3216: !_PREFETCH [4] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 64] %asi, 1

P3217: !_BLD [12] (FP) (Branch target of P3606)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered
ba P3218
nop

TARGET3606:
ba RET3606
nop


P3218: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P3219: !_BLD [8] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3219
nop
RET3219:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3220: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3221: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3222: !_BST [8] (maybe <- 0x42800043) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3223: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3224: !_BST [11] (maybe <- 0x42800044) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3225: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P3226: !_BST [3] (maybe <- 0x42800045) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3227: !_CAS [11] (maybe <- 0x300000a) (Int)
add %i2, 64, %l3
lduw [%l3], %l7
mov %l7, %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0
mov %l4, %o1
cas [%l3], %o5, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P3228: !_DWST [2] (maybe <- 0x300000b) (Int)
mov %l4, %o5 
stx %o5, [%i0 + 8]
add   %l4, 1, %l4

P3229: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3230: !_SWAP [9] (maybe <- 0x300000c) (Int)
mov %l4, %l3
swap  [%i1 + 512], %l3
! move %l3(lower) -> %o1(lower)
srl %l3, 0, %l7
or %l7, %o1, %o1
add   %l4, 1, %l4

P3231: !_ST [13] (maybe <- 0x300000d) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3232: !_DWLD [7] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3233: !_BST [7] (maybe <- 0x42800049) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3234: !_BST [10] (maybe <- 0x4280004c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3235: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f9

P3236: !_BST [13] (maybe <- 0x4280004d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3237: !_BLD [2] (FP) (Branch target of P3341)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13
ba P3238
nop

TARGET3341:
ba RET3341
nop


P3238: !_BLD [9] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3238
nop
RET3238:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3239: !_BST [12] (maybe <- 0x4280004e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3240: !_BST [7] (maybe <- 0x4280004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3241: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P3242: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3243: !_DWLD [4] (Int)
ldx [%i0 + 64], %o3
! move %o3(upper) -> %o3(upper)

P3244: !_DWLD [3] (Int)
ldx [%i0 + 32], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l3
or %l3, %o3, %o3

P3245: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3246: !_DWST [9] (maybe <- 0x300000e) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P3247: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3248: !_BST [8] (maybe <- 0x42800052) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3249: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P3250: !_BST [0] (maybe <- 0x42800053) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3251: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3252: !_BST [15] (maybe <- 0x42800057) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3253: !_BST [11] (maybe <- 0x42800058) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3253
nop
RET3253:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3254: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3255: !_BST [8] (maybe <- 0x42800059) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3255
nop
RET3255:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3256: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P3257: !_BST [9] (maybe <- 0x4280005a) (FP) (Branch target of P3188)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P3258
nop

TARGET3188:
ba RET3188
nop


P3258: !_BST [12] (maybe <- 0x4280005b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3259: !_ST [3] (maybe <- 0x4280005c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 32 ]

P3260: !_CAS [5] (maybe <- 0x300000f) (Int)
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

P3261: !_CAS [12] (maybe <- 0x3000010) (Int)
add %i3, 0, %l3
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

P3262: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3263: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3264: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3265: !_BST [2] (maybe <- 0x4280005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3266: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3267: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3268: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3269: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3270: !_LD [12] (Int)
lduw [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3271: !_BST [1] (maybe <- 0x42800061) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3272: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3273: !_BST [4] (maybe <- 0x42800065) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3274: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P3275: !_DWST [11] (maybe <- 0x3000011) (Int) (LE)
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

P3276: !_BST [2] (maybe <- 0x42800066) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3277: !_BST [11] (maybe <- 0x4280006a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3278: !_BST [3] (maybe <- 0x4280006b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3279: !_ST [11] (maybe <- 0x3000012) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3280: !_NOP (Int)
nop

P3281: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3282: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P3283: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P3284: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3285: !_ST [2] (maybe <- 0x3000013) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P3286: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3287: !_BST [8] (maybe <- 0x4280006f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3288: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f7

P3289: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f8

P3290: !_REPLACEMENT [10] (Int) (Branch target of P3410)
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
ba P3291
nop

TARGET3410:
ba RET3410
nop


P3291: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P3292: !_ST [6] (maybe <- 0x3000014) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3293: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P3294: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P3295: !_BST [12] (maybe <- 0x42800070) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3296: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3297: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3298: !_PREFETCH [9] (Int) (Branch target of P3447)
prefetch [%i1 + 512], 1
ba P3299
nop

TARGET3447:
ba RET3447
nop


P3299: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P3300: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3301: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3302: !_BST [1] (maybe <- 0x42800071) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3303: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P3304: !_LD [9] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i1 + 512] %asi, %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

P3305: !_BST [5] (maybe <- 0x42800075) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3306: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3307: !_PREFETCH [12] (Int) (CBR)
prefetch [%i3 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3307
nop
RET3307:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3308: !_BST [5] (maybe <- 0x42800078) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3309: !_DWLD [7] (Int)
ldx [%i1 + 80], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)

P3310: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3311: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3312: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3313: !_DWST [0] (maybe <- 0x3000015) (Int) (Branch target of P3407)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4
ba P3314
nop

TARGET3407:
ba RET3407
nop


P3314: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P3315: !_BST [15] (maybe <- 0x4280007b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3316: !_BST [11] (maybe <- 0x4280007c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3317: !_REPLACEMENT [8] (Int)
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

P3318: !_BST [3] (maybe <- 0x4280007d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3319: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3320: !_CAS [4] (maybe <- 0x3000017) (Int)
add %i0, 64, %l7
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

P3321: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3322: !_BST [5] (maybe <- 0x42800081) (FP) (CBR) (Branch target of P3322)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3322
nop
RET3322:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0

ba P3323
nop

TARGET3322:
ba RET3322
nop


P3323: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3324: !_BST [2] (maybe <- 0x42800084) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3325: !_LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3326: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3327: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3328: !_PREFETCH [3] (Int) (Branch target of P3413)
prefetch [%i0 + 32], 1
ba P3329
nop

TARGET3413:
ba RET3413
nop


P3329: !_DWST [7] (maybe <- 0x3000018) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i1 + 80]
add   %l4, 1, %l4

P3330: !_BST [8] (maybe <- 0x42800088) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3331: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P3332: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P3333: !_BST [0] (maybe <- 0x42800089) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3334: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P3335: !_REPLACEMENT [13] (Int)
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

P3336: !_DWST [8] (maybe <- 0x300001a) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

P3337: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P3338: !_BST [9] (maybe <- 0x4280008d) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3338
nop
RET3338:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3339: !_BST [2] (maybe <- 0x4280008e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3340: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3341: !_BLD [8] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3341
nop
RET3341:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3342: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3343: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P3344: !_BST [2] (maybe <- 0x42800092) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3344
nop
RET3344:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3345: !_DWLD [7] (Int)
ldx [%i1 + 80], %l7
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

P3346: !_LD [9] (Int)
lduw [%i1 + 512], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P3347: !_BST [9] (maybe <- 0x42800096) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3348: !_BST [13] (maybe <- 0x42800097) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3349: !_BST [7] (maybe <- 0x42800098) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3350: !_BST [9] (maybe <- 0x4280009b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3351: !_ST [6] (maybe <- 0x300001b) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3352: !_BLD [3] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3352
nop
RET3352:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3353: !_BST [5] (maybe <- 0x4280009c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3354: !_ST [13] (maybe <- 0x300001c) (Int) (Branch target of P3404)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4
ba P3355
nop

TARGET3404:
ba RET3404
nop


P3355: !_BST [9] (maybe <- 0x4280009f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3356: !_BST [12] (maybe <- 0x428000a0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3357: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P3358: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3359: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P3360: !_BST [1] (maybe <- 0x428000a1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3361: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3362: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3363: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3364: !_BST [13] (maybe <- 0x428000a5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3365: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3366: !_BST [11] (maybe <- 0x428000a6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3367: !_DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P3368: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3369: !_BST [6] (maybe <- 0x428000a7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3370: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3371: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3372: !_BST [2] (maybe <- 0x428000aa) (FP) (Branch target of P3583)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P3373
nop

TARGET3583:
ba RET3583
nop


P3373: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3374: !_BST [12] (maybe <- 0x428000ae) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3374
nop
RET3374:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3375: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3376: !_PREFETCH [9] (Int) (Branch target of P3255)
prefetch [%i1 + 512], 1
ba P3377
nop

TARGET3255:
ba RET3255
nop


P3377: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3378: !_ST [10] (maybe <- 0x300001d) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P3379: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3380: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3381: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P3382: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3383: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3384: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3385: !_BST [12] (maybe <- 0x428000af) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3386: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3387: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3388: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3389: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3389
nop
RET3389:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3390: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f0
membar #Sync 
! 1 addresses covered

P3391: !_SWAP [12] (maybe <- 0x300001e) (Int)
mov %l4, %o5
swap  [%i3 + 0], %o5
! move %o5(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
srl %o5, 0, %l6
or %l6, %o1, %o1
add   %l4, 1, %l4

P3392: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P3393: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P3394: !_BST [3] (maybe <- 0x428000b0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3395: !_BST [0] (maybe <- 0x428000b4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3396: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P3397: !_ST [6] (maybe <- 0x428000b8) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i1 + 80 ]

P3398: !_BST [15] (maybe <- 0x428000b9) (FP) (Branch target of P3374)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 
ba P3399
nop

TARGET3374:
ba RET3374
nop


P3399: !_LD [11] (Int)
lduw [%i2 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3400: !_DWLD [8] (Int)
ldx [%i1 + 256], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2

P3401: !_ST [12] (maybe <- 0x300001f) (Int)
stw   %l4, [%i3 + 0 ]
add   %l4, 1, %l4

P3402: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3403: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3404: !_BLD [3] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3404
nop
RET3404:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3405: !_BST [9] (maybe <- 0x428000ba) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3406: !_MEMBAR (Int)
membar #StoreLoad

P3407: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3407
nop
RET3407:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3408: !_BST [9] (maybe <- 0x428000bb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3409: !_BST [10] (maybe <- 0x428000bc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3410: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3410
nop
RET3410:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3411: !_SWAP [5] (maybe <- 0x3000020) (Int)
mov %l4, %o3
swap  [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3
add   %l4, 1, %l4

P3412: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P3413: !_BST [14] (maybe <- 0x428000bd) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3413
nop
RET3413:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3414: !_BST [14] (maybe <- 0x428000be) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3415: !_BST [8] (maybe <- 0x428000bf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3416: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P3417: !_REPLACEMENT [11] (Int)
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

P3418: !_BST [7] (maybe <- 0x428000c0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3419: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3420: !_BST [14] (maybe <- 0x428000c3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3421: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P3422: !_CAS [4] (maybe <- 0x3000021) (Int)
add %i0, 64, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
mov %l4, %o4
cas [%l7], %l6, %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4
add   %l4, 1, %l4

P3423: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3424: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3425: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3425
nop
RET3425:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3426: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P3427: !_BST [9] (maybe <- 0x428000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3428: !_LD [13] (Int)
lduw [%i3 + 64], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3429: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3429
nop
RET3429:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3430: !_BST [4] (maybe <- 0x428000c5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3431: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3432: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3433: !_MEMBAR (Int)
membar #StoreLoad

P3434: !_BST [15] (maybe <- 0x428000c6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3435: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3436: !_NOP (Int)
nop

P3437: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3438: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P3439: !_BST [0] (maybe <- 0x428000c7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3440: !_DWST [8] (maybe <- 0x3000022) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

P3441: !_BST [2] (maybe <- 0x428000cb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3442: !_REPLACEMENT [15] (Int)
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

P3443: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3444: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P3445: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P3446: !_BST [7] (maybe <- 0x428000cf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3447: !_BLD [1] (FP) (CBR) (Branch target of P3113)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3447
nop
RET3447:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P3448
nop

TARGET3113:
ba RET3113
nop


P3448: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f1

P3449: !_BST [7] (maybe <- 0x428000d2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3450: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P3451: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3452: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3453: !_LD [1] (Int)
lduw [%i0 + 4], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3454: !_BST [1] (maybe <- 0x428000d5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3455: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3456: !_BST [9] (maybe <- 0x428000d9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3457: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P3458: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3459: !_BLD [13] (FP) (Branch target of P3389)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8
ba P3460
nop

TARGET3389:
ba RET3389
nop


P3460: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3461: !_PREFETCH [14] (Int) (CBR)
prefetch [%i3 + 128], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3461
nop
RET3461:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3462: !_BST [8] (maybe <- 0x428000da) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3463: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3464: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P3465: !_BST [0] (maybe <- 0x428000db) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3466: !_BST [9] (maybe <- 0x428000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3467: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3468: !_DWST [0] (maybe <- 0x3000023) (Int)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4

P3469: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3470: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3471: !_DWST [10] (maybe <- 0x3000025) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P3472: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3473: !_LD [0] (FP)
ld [%i0 + 0], %f0
! 1 addresses covered

P3474: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3475: !_BST [6] (maybe <- 0x428000e0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3476: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3477: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3478: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3479: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3480: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3481: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P3482: !_REPLACEMENT [3] (Int)
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

P3483: !_NOP (Int)
nop

P3484: !_BST [4] (maybe <- 0x428000e3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3485: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3486: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3487: !_BST [2] (maybe <- 0x428000e4) (FP) (Branch target of P3461)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P3488
nop

TARGET3461:
ba RET3461
nop


P3488: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P3489: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3490: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3491: !_BST [10] (maybe <- 0x428000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3492: !_BST [9] (maybe <- 0x428000e9) (FP) (Branch target of P3344)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P3493
nop

TARGET3344:
ba RET3344
nop


P3493: !_LD [14] (Int)
lduw [%i3 + 128], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P3494: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3495: !_BST [6] (maybe <- 0x428000ea) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3496: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3497: !_BST [11] (maybe <- 0x428000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3498: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P3499: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3500: !_BST [10] (maybe <- 0x428000ee) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3501: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3502: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3503: !_DWST [0] (maybe <- 0x3000026) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3504: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3505: !_PREFETCH [14] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 128] %asi, 1

P3506: !_BST [9] (maybe <- 0x428000ef) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3507: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P3508: !_BLD [8] (FP) (Branch target of P3556)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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
ba P3509
nop

TARGET3556:
ba RET3556
nop


P3509: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

P3510: !_REPLACEMENT [14] (Int)
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

P3511: !_BST [8] (maybe <- 0x428000f0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3512: !_BST [7] (maybe <- 0x428000f1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3513: !_BST [2] (maybe <- 0x428000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3514: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P3515: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3516: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3517: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P3518: !_BST [9] (maybe <- 0x428000f8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3519: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3520: !_BST [8] (maybe <- 0x428000f9) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3520
nop
RET3520:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3521: !_BST [7] (maybe <- 0x428000fa) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3522: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3523: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3524: !_BST [5] (maybe <- 0x428000fd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3525: !_BST [9] (maybe <- 0x42800100) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3526: !_BST [13] (maybe <- 0x42800101) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3527: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3528: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3529: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3530: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3531: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3532: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3533: !_BST [2] (maybe <- 0x42800102) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3534: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P3535: !_BST [14] (maybe <- 0x42800106) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3536: !_BST [9] (maybe <- 0x42800107) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3537: !_BST [9] (maybe <- 0x42800108) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3538: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3539: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P3540: !_DWST [14] (maybe <- 0x3000028) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 128 ] 
add   %l4, 1, %l4

P3541: !_DWLD [4] (Int)
ldx [%i0 + 64], %o1
! move %o1(upper) -> %o1(upper)

P3542: !_BST [0] (maybe <- 0x42800109) (FP) (Branch target of P3338)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P3543
nop

TARGET3338:
ba RET3338
nop


P3543: !_PREFETCH [13] (Int) (Branch target of P3172)
prefetch [%i3 + 64], 1
ba P3544
nop

TARGET3172:
ba RET3172
nop


P3544: !_PREFETCH [7] (Int) (Branch target of P3425)
prefetch [%i1 + 84], 1
ba P3545
nop

TARGET3425:
ba RET3425
nop


P3545: !_BST [13] (maybe <- 0x4280010d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3546: !_BST [3] (maybe <- 0x4280010e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3547: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P3548: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3548
nop
RET3548:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3549: !_LD [5] (Int)
lduw [%i1 + 76], %o5
! move %o5(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %o5, %o1, %o1

P3550: !_BST [6] (maybe <- 0x42800112) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3551: !_BST [9] (maybe <- 0x42800115) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3552: !_CASX [11] (maybe <- 0x3000029) (Int)
add %i2, 64, %o5
ldx [%o5], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %l7
sllx %l4, 32, %o3
casx [%o5], %l7, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P3553: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P3554: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3555: !_LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3556: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3556
nop
RET3556:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3557: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3558: !_BST [4] (maybe <- 0x42800116) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3559: !_PREFETCH [11] (Int) (Branch target of P3429)
prefetch [%i2 + 64], 1
ba P3560
nop

TARGET3429:
ba RET3429
nop


P3560: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3561: !_LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3562: !_BST [8] (maybe <- 0x42800117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3563: !_REPLACEMENT [0] (Int)
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

P3564: !_BST [0] (maybe <- 0x42800118) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3565: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3566: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3567: !_DWLD [10] (Int)
ldx [%i2 + 32], %o0
! move %o0(upper) -> %o0(upper)

P3568: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3569: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3570: !_DWST [9] (maybe <- 0x300002a) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 512 ] 
add   %l4, 1, %l4

P3571: !_MEMBAR (Int)
membar #StoreLoad

P3572: !_DWLD [13] (Int)
ldx [%i3 + 64], %l6
! move %l6(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l6, 32, %l3
or %l3, %o0, %o0

P3573: !_DWST [5] (maybe <- 0x300002b) (Int)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4

P3574: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3575: !_BST [12] (maybe <- 0x4280011c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3576: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3577: !_BST [14] (maybe <- 0x4280011d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3578: !_DWLD [15] (Int)
ldx [%i3 + 192], %o1
! move %o1(upper) -> %o1(upper)

P3579: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3580: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P3581: !_PREFETCH [7] (Int) (Branch target of P3520)
prefetch [%i1 + 84], 1
ba P3582
nop

TARGET3520:
ba RET3520
nop


P3582: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P3583: !_BST [9] (maybe <- 0x4280011e) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3583
nop
RET3583:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3584: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3585: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l7, %o1, %o1

P3586: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P3587: !_BST [6] (maybe <- 0x4280011f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3588: !_BST [15] (maybe <- 0x42800122) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3589: !_BST [10] (maybe <- 0x42800123) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3590: !_BST [5] (maybe <- 0x42800124) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3591: !_LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3592: !_DWLD [5] (FP)
ldd [%i1 + 72], %f6
! 1 addresses covered
fmovs %f7, %f6

P3593: !_BST [3] (maybe <- 0x42800127) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3594: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3595: !_DWLD [5] (Int) (Branch target of P3136)
ldx [%i1 + 72], %l6
! move %l6(lower) -> %o2(lower)
srl %l6, 0, %l3
or %l3, %o2, %o2
ba P3596
nop

TARGET3136:
ba RET3136
nop


P3596: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3597: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3598: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3599: !_BST [11] (maybe <- 0x4280012b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3600: !_CASX [4] (maybe <- 0x300002c) (Int)
add %i0, 64, %l7
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

P3601: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3602: !_LD [11] (Int)
lduw [%i2 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3603: !_MEMBAR (Int)
membar #StoreLoad

P3604: !_LD [0] (Int)
lduw [%i0 + 0], %l3
! move %l3(lower) -> %o0(lower)
or %l3, %o0, %o0

P3605: !_LD [1] (Int)
lduw [%i0 + 4], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P3606: !_LD [2] (Int) (CBR)
lduw [%i0 + 12], %l3
! move %l3(lower) -> %o1(lower)
or %l3, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3606
nop
RET3606:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3607: !_LD [3] (Int)
lduw [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P3608: !_LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3609: !_LD [5] (Int)
lduw [%i1 + 76], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P3610: !_LD [6] (FP)
ld [%i1 + 80], %f8
! 1 addresses covered

P3611: !_LD [7] (Int) (Branch target of P3548)
lduw [%i1 + 84], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3
ba P3612
nop

TARGET3548:
ba RET3548
nop


P3612: !_LD [8] (Int)
lduw [%i1 + 256], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3613: !_LD [9] (Int)
lduw [%i1 + 512], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3614: !_LD [10] (Int)
lduw [%i2 + 32], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P3615: !_LD [11] (FP)
ld [%i2 + 64], %f9
! 1 addresses covered

P3616: !_LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P3617: !_LD [13] (Int) (Branch target of P3219)
lduw [%i3 + 64], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
ba P3618
nop

TARGET3219:
ba RET3219
nop


P3618: !_LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P3619: !_LD [15] (Int)
lduw [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

END_NODES6: ! Test istream for CPU 6 ends
sethi %hi(0xdead0e0f), %l3
or    %l3, %lo(0xdead0e0f), %l3
! move %l3(lower) -> %o2(lower)
or %l3, %o2, %o2
stw %l3, [%i5] 
ld [%i5], %f10
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
fmovd %f10, %f30

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

func7:
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0xdeadbee0), %o5
or    %o5, %lo(0xdeadbee0), %o5
stw   %o5, [%i5]
sethi %hi(0xdeadbee1), %o5
or    %o5, %lo(0xdeadbee1), %o5
stw   %o5, [%i5+4]
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
sethi %hi(0x07deade1), %o5
or    %o5, %lo(0x07deade1), %o5
stw %o5, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x3800001), %l4
or    %l4, %lo(0x3800001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x43000001), %o5
or    %o5, %lo(0x43000001), %o5
stw %o5, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x37800000), %o5
or    %o5, %lo(0x37800000), %o5
stw %o5, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x6e24^4
sethi %hi(0x6e24), %l0
or    %l0, %lo(0x6e24), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 3 to 3 ---
stx %g0, [%i0+32]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l3
add %i3, %l3, %l3
sub %l3, -4096, %l3

!-- begin of sync_init ---
or %g0, 1, %l6
or %g0, %l6, %l7
swap [%l3+4], %l7
membar #Sync
sync_init_1_7:
brnz,pt %l6, sync_init_1_7
lduw [%l3+4], %l6 ! delay slot
sync_init_2_7:
lduw [%l3], %l6
sub %l6, 1, %l7
cas [%l3], %l6, %l7
cmp %l6, %l7
bne,pt %xcc, sync_init_2_7
nop
membar #Sync
sync_init_3_7:
lduw [%l3], %l6 ! delay slot
brnz,pt %l6, sync_init_3_7
nop
!-- end of sync_init ---


BEGIN_NODES7: ! Test istream for CPU 7 begins

P3620: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3621: !_BST [14] (maybe <- 0x43000001) (FP) (Branch target of P4016)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 
ba P3622
nop

TARGET4016:
ba RET4016
nop


P3622: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3623: !_BST [4] (maybe <- 0x43000002) (FP) (Branch target of P3974)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 
ba P3624
nop

TARGET3974:
ba RET3974
nop


P3624: !_BLD [3] (FP) (Branch target of P3951)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3
ba P3625
nop

TARGET3951:
ba RET3951
nop


P3625: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3626: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3627: !_DWST [0] (maybe <- 0x3800001) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P3628: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P3629: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3630: !_DWLD [9] (Int)
ldx [%i1 + 512], %o0
! move %o0(upper) -> %o0(upper)

P3631: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f7

P3632: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P3633: !_DWST [0] (maybe <- 0x3800003) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3634: !_BST [7] (maybe <- 0x43000003) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3635: !_BST [3] (maybe <- 0x43000006) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3636: !_BST [10] (maybe <- 0x4300000a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3637: !_BST [6] (maybe <- 0x4300000b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3638: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3639: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3640: !_BST [9] (maybe <- 0x4300000e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3641: !_DWST [11] (maybe <- 0x3800005) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 64 ] 
add   %l4, 1, %l4

P3642: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3643: !_BST [5] (maybe <- 0x4300000f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3644: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3645: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P3646: !_PREFETCH [11] (Int) (Branch target of P3808)
prefetch [%i2 + 64], 1
ba P3647
nop

TARGET3808:
ba RET3808
nop


P3647: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3648: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3649: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P3650: !_DWST [8] (maybe <- 0x3800006) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3650
nop
RET3650:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3651: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3652: !_ST [6] (maybe <- 0x3800007) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3653: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P3654: !_LD [15] (Int)
lduw [%i3 + 192], %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l7, %o0, %o0

P3655: !_BST [4] (maybe <- 0x43000012) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3656: !_BST [7] (maybe <- 0x43000013) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3657: !_PREFETCH [2] (Int) (CBR)
prefetch [%i0 + 12], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3657
nop
RET3657:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3658: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3659: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3660: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P3661: !_ST [5] (maybe <- 0x3800008) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3662: !_BST [9] (maybe <- 0x43000016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3663: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P3664: !_ST [7] (maybe <- 0x3800009) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P3665: !_BST [3] (maybe <- 0x43000017) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3666: !_BST [13] (maybe <- 0x4300001b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3667: !_MEMBAR (Int)
membar #StoreLoad

P3668: !_BST [13] (maybe <- 0x4300001c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3669: !_PREFETCH [9] (Int) (CBR)
prefetch [%i1 + 512], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3669
nop
RET3669:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3670: !_ST [14] (maybe <- 0x380000a) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3671: !_BST [1] (maybe <- 0x4300001d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3672: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3673: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P3674: !_BST [7] (maybe <- 0x43000021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3675: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P3676: !_DWLD [10] (Int)
ldx [%i2 + 32], %o1
! move %o1(upper) -> %o1(upper)

P3677: !_CAS [5] (maybe <- 0x380000b) (Int)
add %i1, 76, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o1(lower)
srlx %o1, 32, %o1
sllx %o1, 32, %o1
or %l3, %o1, %o1
mov %l4, %o2
cas [%l6], %l3, %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3678: !_LD [9] (Int) (LE)
wr %g0, 0x88, %asi
lduwa [%i1 + 512] %asi, %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P3679: !_BST [0] (maybe <- 0x43000024) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3680: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P3681: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3682: !_BST [10] (maybe <- 0x43000028) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3683: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3684: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P3685: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P3686: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P3687: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3688: !_BST [12] (maybe <- 0x43000029) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3689: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3690: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3691: !_BST [8] (maybe <- 0x4300002a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3692: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3693: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P3694: !_DWST [1] (maybe <- 0x380000c) (Int)
sllx %l4, 32, %l7 
add   %l4, 1, %l4
or %l7, %l4, %l7
stx %l7, [%i0 + 0]
add   %l4, 1, %l4

P3695: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3696: !_BST [8] (maybe <- 0x4300002b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3697: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3698: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3699: !_CAS [3] (maybe <- 0x380000e) (Int)
add %i0, 32, %l6
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

P3700: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P3701: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3702: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3703: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3704: !_REPLACEMENT [1] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3704
nop
RET3704:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3705: !_BST [8] (maybe <- 0x4300002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3706: !_BST [8] (maybe <- 0x4300002d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3707: !_BST [14] (maybe <- 0x4300002e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3708: !_BST [1] (maybe <- 0x4300002f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3709: !_BLD [6] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3709
nop
RET3709:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3710: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P3711: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3712: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P3713: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P3714: !_BST [11] (maybe <- 0x43000033) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3715: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P3716: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3717: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3718: !_REPLACEMENT [5] (Int)
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

P3719: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3720: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P3721: !_BST [6] (maybe <- 0x43000034) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3722: !_REPLACEMENT [8] (Int)
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

P3723: !_BST [2] (maybe <- 0x43000037) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3724: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P3725: !_DWST [4] (maybe <- 0x380000f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i0 + 64 ] 
add   %l4, 1, %l4

P3726: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P3727: !_BST [9] (maybe <- 0x4300003b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3728: !_BST [7] (maybe <- 0x4300003c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3729: !_BLD [0] (FP) (CBR) (Branch target of P3911)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3729
nop
RET3729:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P3730
nop

TARGET3911:
ba RET3911
nop


P3730: !_ST [5] (maybe <- 0x3800010) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P3731: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3732: !_BST [14] (maybe <- 0x4300003f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3733: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P3734: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3735: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3736: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3737: !_BST [10] (maybe <- 0x43000040) (FP) (Branch target of P3960)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 
ba P3738
nop

TARGET3960:
ba RET3960
nop


P3738: !_PREFETCH [12] (Int) (Branch target of P3824)
prefetch [%i3 + 0], 1
ba P3739
nop

TARGET3824:
ba RET3824
nop


P3739: !_BST [4] (maybe <- 0x43000041) (FP) (Branch target of P3943)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 
ba P3740
nop

TARGET3943:
ba RET3943
nop


P3740: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P3741: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3742: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P3743: !_BST [4] (maybe <- 0x43000042) (FP) (Branch target of P4106)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 
ba P3744
nop

TARGET4106:
ba RET4106
nop


P3744: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P3745: !_BST [5] (maybe <- 0x43000043) (FP) (Branch target of P3986)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P3746
nop

TARGET3986:
ba RET3986
nop


P3746: !_BST [14] (maybe <- 0x43000046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3747: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P3748: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3749: !_BLD [14] (FP) (Branch target of P3729)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2
ba P3750
nop

TARGET3729:
ba RET3729
nop


P3750: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3751: !_MEMBAR (Int)
membar #StoreLoad

P3752: !_BLD [9] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3752
nop
RET3752:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3753: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P3754: !_BST [7] (maybe <- 0x43000047) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3755: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3756: !_ST [10] (maybe <- 0x3800011) (Int) (LE)
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

P3757: !_BST [10] (maybe <- 0x4300004a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3758: !_BLD [3] (FP) (Branch target of P3877)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12
ba P3759
nop

TARGET3877:
ba RET3877
nop


P3759: !_REPLACEMENT [0] (Int)
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

P3760: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3760
nop
RET3760:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3761: !_BLD [14] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3761
nop
RET3761:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3762: !_BST [13] (maybe <- 0x4300004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3763: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3764: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3765: !_BLD [4] (FP) (Branch target of P3650)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14
ba P3766
nop

TARGET3650:
ba RET3650
nop


P3766: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P3767: !_BLD [9] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3767
nop
RET3767:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3768: !_BST [9] (maybe <- 0x4300004c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3769: !_BST [4] (maybe <- 0x4300004d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3770: !_DWLD [13] (Int)
ldx [%i3 + 64], %o4
! move %o4(upper) -> %o4(upper)

P3771: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P3772: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3773: !_REPLACEMENT [10] (Int)
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

P3774: !_BST [4] (maybe <- 0x4300004e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3775: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3776: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P3777: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3778: !_BLD [4] (FP) (Branch target of P3828)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8
ba P3779
nop

TARGET3828:
ba RET3828
nop


P3779: !_DWLD [9] (Int)
ldx [%i1 + 512], %l6
! move %l6(upper) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
srlx %l6, 32, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3780: !_BST [11] (maybe <- 0x4300004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3781: !_REPLACEMENT [15] (Int)
sethi %hi(0xc0), %l6
or %l6, %lo(0xc0),  %l6
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

P3782: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3783: !_BST [4] (maybe <- 0x43000050) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3784: !_PREFETCH [0] (Int) (CBR)
prefetch [%i0 + 0], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3784
nop
RET3784:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3785: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P3786: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3787: !_DWST [10] (maybe <- 0x3800012) (Int) (Branch target of P3709)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i2 + 32 ] 
add   %l4, 1, %l4
ba P3788
nop

TARGET3709:
ba RET3709
nop


P3788: !_ST [8] (maybe <- 0x3800013) (Int)
stw   %l4, [%i1 + 256 ]
add   %l4, 1, %l4

P3789: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3790: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f13

P3791: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P3792: !_BST [1] (maybe <- 0x43000051) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3793: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3794: !_BST [0] (maybe <- 0x43000055) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3795: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3796: !_BST [15] (maybe <- 0x43000059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3797: !_CASX [15] (maybe <- 0x3800014) (Int)
add %i3, 192, %l3
ldx [%l3], %o0
! move %o0(upper) -> %o0(upper)
! move %o0(lower) -> %o0(lower)
mov  %o0, %o5
sllx %l4, 32, %o1
casx [%l3], %o5, %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
add  %l4, 1, %l4

P3798: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3798
nop
RET3798:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3799: !_BST [13] (maybe <- 0x4300005a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3800: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3801: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P3802: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3803: !_BST [6] (maybe <- 0x4300005b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3804: !_DWST [5] (maybe <- 0x3800015) (Int) (Branch target of P3798)
mov %l4, %l7 
stx %l7, [%i1 + 72]
add   %l4, 1, %l4
ba P3805
nop

TARGET3798:
ba RET3798
nop


P3805: !_BLD [10] (FP) (Branch target of P3784)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3
ba P3806
nop

TARGET3784:
ba RET3784
nop


P3806: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P3807: !_BST [4] (maybe <- 0x4300005e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3808: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3808
nop
RET3808:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3809: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3810: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3811: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3812: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f10

P3813: !_BST [12] (maybe <- 0x4300005f) (FP) (Branch target of P3952)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 
ba P3814
nop

TARGET3952:
ba RET3952
nop


P3814: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3815: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P3816: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P3817: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P3818: !_BST [6] (maybe <- 0x43000060) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3819: !_BLD [5] (FP) (Branch target of P3657)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4
ba P3820
nop

TARGET3657:
ba RET3657
nop


P3820: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P3821: !_DWST [0] (maybe <- 0x3800016) (Int) (Branch target of P4136)
sllx %l4, 32, %o5 
add   %l4, 1, %l4
or %o5, %l4, %o5
stx %o5, [%i0 + 0]
add   %l4, 1, %l4
ba P3822
nop

TARGET4136:
ba RET4136
nop


P3822: !_BST [5] (maybe <- 0x43000063) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3823: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3824: !_SWAP [13] (maybe <- 0x3800018) (Int) (CBR)
mov %l4, %o2
swap  [%i3 + 64], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3824
nop
RET3824:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3825: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3826: !_ST [0] (maybe <- 0x43000066) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 0 ]

P3827: !_CASX [11] (maybe <- 0x3800019) (Int)
add %i2, 64, %l6
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

P3828: !_BST [4] (maybe <- 0x43000067) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3828
nop
RET3828:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3829: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P3830: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3831: !_BST [3] (maybe <- 0x43000068) (FP) (Branch target of P3979)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P3832
nop

TARGET3979:
ba RET3979
nop


P3832: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P3833: !_ST [1] (maybe <- 0x4300006c) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P3834: !_BST [3] (maybe <- 0x4300006d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3835: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3835
nop
RET3835:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3836: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3837: !_ST [0] (maybe <- 0x380001a) (Int)
stw   %l4, [%i0 + 0 ]
add   %l4, 1, %l4

P3838: !_BST [6] (maybe <- 0x43000071) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3839: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P3840: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3841: !_BST [13] (maybe <- 0x43000074) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3842: !_BST [1] (maybe <- 0x43000075) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3843: !_DWST [12] (maybe <- 0x380001b) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 0 ] 
add   %l4, 1, %l4

P3844: !_BST [0] (maybe <- 0x43000079) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3845: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3846: !_PREFETCH [13] (Int) (Branch target of P3767)
prefetch [%i3 + 64], 1
ba P3847
nop

TARGET3767:
ba RET3767
nop


P3847: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3848: !_BLD [1] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3848
nop
RET3848:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3849: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3850: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3851: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3852: !_BST [3] (maybe <- 0x4300007d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3853: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3854: !_BST [9] (maybe <- 0x43000081) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3855: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P3856: !_BST [7] (maybe <- 0x43000082) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3857: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P3858: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P3859: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3860: !_BST [9] (maybe <- 0x43000085) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3861: !_BST [8] (maybe <- 0x43000086) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P3862: !_CASX [4] (maybe <- 0x380001c) (Int)
add %i0, 64, %l6
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

P3863: !_ST [6] (maybe <- 0x380001d) (Int)
stw   %l4, [%i1 + 80 ]
add   %l4, 1, %l4

P3864: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3865: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3866: !_BST [6] (maybe <- 0x43000087) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3867: !_BST [15] (maybe <- 0x4300008a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3868: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3869: !_BST [6] (maybe <- 0x4300008b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3870: !_BLD [1] (FP) (Branch target of P3669)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8
ba P3871
nop

TARGET3669:
ba RET3669
nop


P3871: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3872: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3873: !_BST [2] (maybe <- 0x4300008e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3874: !_REPLACEMENT [9] (Int)
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

P3875: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3876: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P3877: !_REPLACEMENT [10] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3877
nop
RET3877:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3878: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3879: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P3880: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P3881: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P3882: !_BST [11] (maybe <- 0x43000092) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3883: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P3884: !_ST [11] (maybe <- 0x380001e) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P3885: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P3886: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P3887: !_ST [14] (maybe <- 0x380001f) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P3888: !_SWAP [3] (maybe <- 0x3800020) (Int)
mov %l4, %o2
swap  [%i0 + 32], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2
add   %l4, 1, %l4

P3889: !_BST [6] (maybe <- 0x43000093) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3890: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P3891: !_MEMBAR (Int)
membar #StoreLoad

P3892: !_DWLD [9] (Int)
ldx [%i1 + 512], %l3
! move %l3(upper) -> %o2(lower)
srlx %l3, 32, %o5
or %o5, %o2, %o2

P3893: !_BST [15] (maybe <- 0x43000096) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P3894: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P3895: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3896: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P3897: !_REPLACEMENT [1] (Int)
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

P3898: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3899: !_BST [4] (maybe <- 0x43000097) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3900: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P3901: !_BST [14] (maybe <- 0x43000098) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3902: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3903: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3904: !_BST [13] (maybe <- 0x43000099) (FP) (Branch target of P3752)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 
ba P3905
nop

TARGET3752:
ba RET3752
nop


P3905: !_ST [13] (maybe <- 0x3800021) (Int)
stw   %l4, [%i3 + 64 ]
add   %l4, 1, %l4

P3906: !_DWST [15] (maybe <- 0x3800022) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P3907: !_BST [3] (maybe <- 0x4300009a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3908: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P3909: !_BST [6] (maybe <- 0x4300009e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3910: !_REPLACEMENT [2] (Int)
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

P3911: !_BST [11] (maybe <- 0x430000a1) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3911
nop
RET3911:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3912: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3913: !_BST [6] (maybe <- 0x430000a2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3914: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3915: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P3916: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3917: !_BST [13] (maybe <- 0x430000a5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3918: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3919: !_DWLD [9] (Int)
ldx [%i1 + 512], %o3
! move %o3(upper) -> %o3(upper)

P3920: !_BST [4] (maybe <- 0x430000a6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3921: !_BST [14] (maybe <- 0x430000a7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P3922: !_BST [2] (maybe <- 0x430000a8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3923: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P3924: !_BST [10] (maybe <- 0x430000ac) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3925: !_BST [3] (maybe <- 0x430000ad) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3926: !_BST [7] (maybe <- 0x430000b1) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3926
nop
RET3926:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3927: !_BLD [7] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3927
nop
RET3927:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3928: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P3929: !_REPLACEMENT [4] (Int)
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

P3930: !_BST [7] (maybe <- 0x430000b4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3931: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P3932: !_DWST [2] (maybe <- 0x3800023) (Int)
mov %l4, %l6 
stx %l6, [%i0 + 8]
add   %l4, 1, %l4

P3933: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f4

P3934: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3935: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3936: !_REPLACEMENT [1] (Int)
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

P3937: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P3938: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P3939: !_BST [4] (maybe <- 0x430000b7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P3940: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P3941: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3942: !_PREFETCH [15] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

P3943: !_PREFETCH [3] (Int) (CBR)
prefetch [%i0 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3943
nop
RET3943:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3944: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3945: !_BST [2] (maybe <- 0x430000b8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3946: !_REPLACEMENT [1] (Int)
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

P3947: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3948: !_MEMBAR (Int)
membar #StoreLoad

P3949: !_BST [1] (maybe <- 0x430000bc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3950: !_DWLD [8] (Int)
ldx [%i1 + 256], %l6
! move %l6(upper) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
srlx %l6, 32, %l3
or %l3, %o3, %o3

P3951: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3951
nop
RET3951:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P3952: !_BLD [0] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3952
nop
RET3952:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3953: !_BST [12] (maybe <- 0x430000c0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3954: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3955: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P3956: !_BST [5] (maybe <- 0x430000c1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3957: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P3958: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P3959: !_BST [13] (maybe <- 0x430000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3960: !_BLD [4] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3960
nop
RET3960:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3961: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P3962: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P3963: !_DWLD [2] (Int)
ldx [%i0 + 8], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P3964: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P3965: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P3966: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3967: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P3968: !_BST [13] (maybe <- 0x430000c5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P3969: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P3970: !_BST [6] (maybe <- 0x430000c6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3971: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P3972: !_DWLD [13] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i3 + 64] %asi, %o5
! move %o5(lower) -> %o4(lower)
srl %o5, 0, %l7
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P3973: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P3974: !_BST [9] (maybe <- 0x430000c9) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3974
nop
RET3974:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P3975: !_PREFETCH [10] (Int) (CBR)
prefetch [%i2 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET3975
nop
RET3975:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3976: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P3977: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P3978: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P3979: !_BST [0] (maybe <- 0x430000ca) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3979
nop
RET3979:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P3980: !_ST [4] (maybe <- 0x3800024) (Int)
stw   %l4, [%i0 + 64 ]
add   %l4, 1, %l4

P3981: !_BST [10] (maybe <- 0x430000ce) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3982: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P3983: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f6

P3984: !_BST [0] (maybe <- 0x430000cf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3985: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P3986: !_DWST [13] (maybe <- 0x3800025) (Int) (CBR)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i3 + 64 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET3986
nop
RET3986:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P3987: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P3988: !_BST [10] (maybe <- 0x430000d3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P3989: !_BST [3] (maybe <- 0x430000d4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3990: !_BST [7] (maybe <- 0x430000d8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3991: !_BST [7] (maybe <- 0x430000db) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P3992: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P3993: !_BST [12] (maybe <- 0x430000de) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P3994: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P3995: !_BST [11] (maybe <- 0x430000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P3996: !_BST [9] (maybe <- 0x430000e0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P3997: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P3998: !_BST [1] (maybe <- 0x430000e1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P3999: !_BLD [13] (FP) (Branch target of P3835)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
ba P4000
nop

TARGET3835:
ba RET3835
nop


P4000: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P4001: !_BST [7] (maybe <- 0x430000e5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4002: !_BST [10] (maybe <- 0x430000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P4003: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4004: !_BST [6] (maybe <- 0x430000e9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4005: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4006: !_BST [10] (maybe <- 0x430000ec) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P4007: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4008: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4009: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f3

P4010: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4011: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P4012: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4013: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4014: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4015: !_BST [4] (maybe <- 0x430000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4016: !_BLD [3] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4016
nop
RET4016:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4017: !_ST [14] (maybe <- 0x3800026) (Int) (LE) (Branch target of P3848)
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
stwa   %l7, [%i3 + 128] %asi
add   %l4, 1, %l4
ba P4018
nop

TARGET3848:
ba RET3848
nop


P4018: !_BST [8] (maybe <- 0x430000ee) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4019: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4020: !_DWLD [14] (FP)
ldd [%i3 + 128], %f18
! 1 addresses covered
fmovs %f18, %f13

P4021: !_PREFETCH [11] (Int) (Branch target of P4044)
prefetch [%i2 + 64], 1
ba P4022
nop

TARGET4044:
ba RET4044
nop


P4022: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4023: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4024: !_BLD [15] (FP) (Branch target of P3761)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14
ba P4025
nop

TARGET3761:
ba RET3761
nop


P4025: !_DWST [0] (maybe <- 0x3800027) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P4026: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P4027: !_DWST [1] (maybe <- 0x3800029) (Int) (LE)
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

P4028: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4029: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4030: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4031: !_MEMBAR (Int)
membar #StoreLoad

P4032: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered
fmovd %f8, %f0

P4033: !_MEMBAR (Int)
membar #StoreLoad

P4034: !_BST [15] (maybe <- 0x430000ef) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4035: !_BST [13] (maybe <- 0x430000f0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4036: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4037: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4038: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4039: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4040: !_DWLD [2] (Int)
ldx [%i0 + 8], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4041: !_BST [8] (maybe <- 0x430000f1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4042: !_ST [14] (maybe <- 0x380002b) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4043: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4044: !_BST [15] (maybe <- 0x430000f2) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4044
nop
RET4044:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4045: !_BST [15] (maybe <- 0x430000f3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4046: !_BST [9] (maybe <- 0x430000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4047: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P4048: !_BST [10] (maybe <- 0x430000f5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P4049: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4050: !_SWAP [2] (maybe <- 0x380002c) (Int) (LE)
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
swapa  [%i0 + 12] %asi, %o5
! move %o5(lower) -> %o0(lower)
srl %o5, 0, %l6
or %l6, %o0, %o0
add   %l4, 1, %l4

P4051: !_REPLACEMENT [13] (Int)
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

P4052: !_BST [13] (maybe <- 0x430000f6) (FP) (Branch target of P4115)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 
ba P4053
nop

TARGET4115:
ba RET4115
nop


P4053: !_BST [15] (maybe <- 0x430000f7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4054: !_BST [12] (maybe <- 0x430000f8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4055: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4056: !_BST [6] (maybe <- 0x430000f9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4057: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P4058: !_BLD [2] (FP) (Branch target of P3926)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4
ba P4059
nop

TARGET3926:
ba RET3926
nop


P4059: !_BST [11] (maybe <- 0x430000fc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4060: !_BST [3] (maybe <- 0x430000fd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4061: !_PREFETCH [1] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 4] %asi, 1

P4062: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4063: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4064: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4065: !_BST [3] (maybe <- 0x43000101) (FP) (Branch target of P3704)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P4066
nop

TARGET3704:
ba RET3704
nop


P4066: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4067: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4068: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4069: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4070: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4071: !_LD [5] (Int)
lduw [%i1 + 76], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4072: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P4073: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P4074: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P4075: !_BST [1] (maybe <- 0x43000105) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4076: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4077: !_ST [5] (maybe <- 0x380002d) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4078: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P4079: !_BST [7] (maybe <- 0x43000109) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4080: !_BST [12] (maybe <- 0x4300010c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4081: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4082: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P4083: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P4084: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4085: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P4086: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4087: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4088: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4089: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4090: !_BST [11] (maybe <- 0x4300010d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4091: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P4092: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P4093: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P4094: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f0
membar #Sync 
! 1 addresses covered

P4095: !_PREFETCH [5] (Int) (Branch target of P3927)
prefetch [%i1 + 76], 1
ba P4096
nop

TARGET3927:
ba RET3927
nop


P4096: !_BST [3] (maybe <- 0x4300010e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4097: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4098: !_BST [10] (maybe <- 0x43000112) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P4099: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4100: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4101: !_PREFETCH [1] (Int) (Branch target of P3975)
prefetch [%i0 + 4], 1
ba P4102
nop

TARGET3975:
ba RET3975
nop


P4102: !_BST [0] (maybe <- 0x43000113) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4103: !_BST [14] (maybe <- 0x43000117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4104: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4105: !_DWST [1] (maybe <- 0x380002e) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P4106: !_BST [5] (maybe <- 0x43000118) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4106
nop
RET4106:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4107: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4108: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4109: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P4110: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4111: !_BST [2] (maybe <- 0x4300011b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4112: !_BST [3] (maybe <- 0x4300011f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4113: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4114: !_BST [5] (maybe <- 0x43000123) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4115: !_DWLD [4] (Int) (CBR)
ldx [%i0 + 64], %l7
! move %l7(upper) -> %o1(lower)
srlx %l7, 32, %l6
or %l6, %o1, %o1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4115
nop
RET4115:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4116: !_BST [4] (maybe <- 0x43000126) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4117: !_BST [0] (maybe <- 0x43000127) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4118: !_LD [15] (Int)
lduw [%i3 + 192], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4119: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P4120: !_MEMBAR (Int)
membar #StoreLoad

P4121: !_LD [0] (Int)
lduw [%i0 + 0], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4122: !_LD [1] (Int)
lduw [%i0 + 4], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4123: !_LD [2] (Int)
lduw [%i0 + 12], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4124: !_LD [3] (Int)
lduw [%i0 + 32], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4125: !_LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4126: !_LD [5] (Int)
lduw [%i1 + 76], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4127: !_LD [6] (Int)
lduw [%i1 + 80], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4128: !_LD [7] (Int) (Branch target of P3760)
lduw [%i1 + 84], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
ba P4129
nop

TARGET3760:
ba RET3760
nop


P4129: !_LD [8] (Int)
lduw [%i1 + 256], %l6
! move %l6(lower) -> %o1(lower)
or %l6, %o1, %o1

P4130: !_LD [9] (Int)
lduw [%i1 + 512], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4131: !_LD [10] (Int)
lduw [%i2 + 32], %l6
! move %l6(lower) -> %o2(lower)
or %l6, %o2, %o2

P4132: !_LD [11] (Int)
lduw [%i2 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4133: !_LD [12] (Int)
lduw [%i3 + 0], %l6
! move %l6(lower) -> %o3(lower)
or %l6, %o3, %o3

P4134: !_LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4135: !_LD [14] (Int)
lduw [%i3 + 128], %l6
! move %l6(lower) -> %o4(lower)
or %l6, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4136: !_LD [15] (Int) (CBR)
lduw [%i3 + 192], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4136
nop
RET4136:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


END_NODES7: ! Test istream for CPU 7 ends
sethi %hi(0xdead0e0f), %l6
or    %l6, %lo(0xdead0e0f), %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
stw %l6, [%i5] 
ld [%i5], %f5
!---- flushing int results buffer----
mov %o0, %l5
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

func8:
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0xdeadbee0), %l3
or    %l3, %lo(0xdeadbee0), %l3
stw   %l3, [%i5]
sethi %hi(0xdeadbee1), %l3
or    %l3, %lo(0xdeadbee1), %l3
stw   %l3, [%i5+4]
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
sethi %hi(0x08deade1), %l3
or    %l3, %lo(0x08deade1), %l3
stw %l3, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x4000001), %l4
or    %l4, %lo(0x4000001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x43800001), %l3
or    %l3, %lo(0x43800001), %l3
stw %l3, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x38000000), %l3
or    %l3, %lo(0x38000000), %l3
stw %l3, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x3d29^4
sethi %hi(0x3d29), %l0
or    %l0, %lo(0x3d29), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 4 to 3 ---

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %l6
add %i3, %l6, %l6
sub %l6, -4096, %l6

!-- begin of sync_init ---
or %g0, 1, %l7
or %g0, %l7, %o5
swap [%l6+4], %o5
membar #Sync
sync_init_1_8:
brnz,pt %l7, sync_init_1_8
lduw [%l6+4], %l7 ! delay slot
sync_init_2_8:
lduw [%l6], %l7
sub %l7, 1, %o5
cas [%l6], %l7, %o5
cmp %l7, %o5
bne,pt %xcc, sync_init_2_8
nop
membar #Sync
sync_init_3_8:
lduw [%l6], %l7 ! delay slot
brnz,pt %l7, sync_init_3_8
nop
!-- end of sync_init ---


BEGIN_NODES8: ! Test istream for CPU 8 begins

P4137: !_DWLD [13] (FP) (CBR)
ldd [%i3 + 64], %f0
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4137
nop
RET4137:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4138: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4139: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4140: !_MEMBAR (Int)
membar #StoreLoad

P4141: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4142: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4143: !_BST [14] (maybe <- 0x43800001) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4143
nop
RET4143:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4144: !_BST [10] (maybe <- 0x43800002) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4144
nop
RET4144:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4145: !_BST [11] (maybe <- 0x43800003) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4146: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P4147: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4148: !_BST [0] (maybe <- 0x43800004) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4149: !_DWLD [14] (Int)
ldx [%i3 + 128], %o0
! move %o0(upper) -> %o0(upper)

P4150: !_DWST [1] (maybe <- 0x4000001) (Int)
sllx %l4, 32, %l6 
add   %l4, 1, %l4
or %l6, %l4, %l6
stx %l6, [%i0 + 0]
add   %l4, 1, %l4

P4151: !_REPLACEMENT [7] (Int)
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

P4152: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P4153: !_BST [13] (maybe <- 0x43800008) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4154: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4155: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4156: !_ST [2] (maybe <- 0x4000003) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4157: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4158: !_BST [1] (maybe <- 0x43800009) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4159: !_BLD [5] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4159
nop
RET4159:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4160: !_BST [11] (maybe <- 0x4380000d) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4160
nop
RET4160:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4161: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4162: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4163: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4164: !_NOP (Int)
nop

P4165: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4166: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f0
membar #Sync 
! 3 addresses covered
fmovs %f3, %f0
fmovs %f4, %f1
fmovs %f5, %f2

P4167: !_DWLD [1] (Int)
ldx [%i0 + 0], %l7
! move %l7(upper) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
srlx %l7, 32, %l6
or %l6, %o0, %o0
! move %l7(lower) -> %o1(upper)
sllx %l7, 32, %o1

P4168: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P4169: !_BST [3] (maybe <- 0x4380000e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4170: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4171: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P4172: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4173: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P4174: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14

P4175: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P4176: !_BST [12] (maybe <- 0x43800012) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4177: !_CASX [14] (maybe <- 0x4000004) (Int)
add %i3, 128, %l3
ldx [%l3], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %o5
sllx %l4, 32, %o3
casx [%l3], %o5, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P4178: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P4179: !_BST [6] (maybe <- 0x43800013) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4180: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4181: !_BST [7] (maybe <- 0x43800016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4182: !_BST [7] (maybe <- 0x43800019) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4183: !_BST [0] (maybe <- 0x4380001c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4184: !_DWST [15] (maybe <- 0x4000005) (Int)
mov %l4, %o5 
sllx %o5, 32, %o5 
stx %o5, [%i3 + 192 ] 
add   %l4, 1, %l4

P4185: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P4186: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4187: !_BST [13] (maybe <- 0x43800020) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4188: !_DWLD [7] (Int)
ldx [%i1 + 80], %o4
! move %o4(upper) -> %o4(upper)
! move %o4(lower) -> %o4(lower)
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4189: !_BST [15] (maybe <- 0x43800021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4190: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4191: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4192: !_BST [9] (maybe <- 0x43800022) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4193: !_BST [4] (maybe <- 0x43800023) (FP) (Branch target of P4625)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 
ba P4194
nop

TARGET4625:
ba RET4625
nop


P4194: !_BST [15] (maybe <- 0x43800024) (FP) (Branch target of P4424)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 
ba P4195
nop

TARGET4424:
ba RET4424
nop


P4195: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P4196: !_LD [7] (Int)
lduw [%i1 + 84], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4197: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4198: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4199: !_CAS [5] (maybe <- 0x4000006) (Int)
add %i1, 76, %l7
lduw [%l7], %l3
mov %l3, %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0
mov %l4, %o1
cas [%l7], %l6, %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4200: !_REPLACEMENT [11] (Int)
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

P4201: !_BLD [12] (FP) (Branch target of P4385)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
ba P4202
nop

TARGET4385:
ba RET4385
nop


P4202: !_BST [13] (maybe <- 0x43800025) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4203: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P4204: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4205: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4206: !_BST [15] (maybe <- 0x43800026) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4207: !_ST [11] (maybe <- 0x4000007) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4208: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4209: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P4210: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P4211: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P4212: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4213: !_BST [2] (maybe <- 0x43800027) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4214: !_BST [15] (maybe <- 0x4380002b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4215: !_BST [14] (maybe <- 0x4380002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4216: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4217: !_LD [5] (FP)
ld [%i1 + 76], %f15
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

P4218: !_BST [6] (maybe <- 0x4380002d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4219: !_BST [7] (maybe <- 0x43800030) (FP) (Branch target of P4409)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P4220
nop

TARGET4409:
ba RET4409
nop


P4220: !_ST [10] (maybe <- 0x43800033) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i2 + 32 ]

P4221: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4221
nop
RET4221:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4222: !_BST [3] (maybe <- 0x43800034) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4223: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f1

P4224: !_ST [2] (maybe <- 0x4000008) (Int)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

P4225: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4226: !_BST [4] (maybe <- 0x43800038) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4227: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P4228: !_BST [6] (maybe <- 0x43800039) (FP) (Branch target of P4494)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 
ba P4229
nop

TARGET4494:
ba RET4494
nop


P4229: !_BST [15] (maybe <- 0x4380003c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4230: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P4231: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4232: !_SWAP [14] (maybe <- 0x4000009) (Int)
mov %l4, %l6
swap  [%i3 + 128], %l6
! move %l6(lower) -> %o1(lower)
srl %l6, 0, %o5
or %o5, %o1, %o1
add   %l4, 1, %l4

P4233: !_BST [9] (maybe <- 0x4380003d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4234: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4235: !_DWST [8] (maybe <- 0x400000a) (Int) (CBR)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i1 + 256 ] 
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4235
nop
RET4235:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4236: !_BST [5] (maybe <- 0x4380003e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4237: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P4238: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P4239: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4240: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4241: !_DWLD [11] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i2 + 64] %asi, %l6
! move %l6(lower) -> %o2(upper)
sllx %l6, 32, %o2

P4242: !_PREFETCH [4] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i0 + 64] %asi, 1

P4243: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4244: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4245: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4246: !_BST [11] (maybe <- 0x43800041) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4247: !_BST [9] (maybe <- 0x43800042) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4248: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4249: !_PREFETCH [0] (Int) (Branch target of P4439)
prefetch [%i0 + 0], 1
ba P4250
nop

TARGET4439:
ba RET4439
nop


P4250: !_CASX [7] (maybe <- 0x400000b) (Int) (CBR)
add %i1, 80, %l6
ldx [%l6], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l3
or %l3, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3
mov %o5, %l3
sllx %l4, 32, %o5
add  %l4, 1, %l4
or   %l4, %o5, %o5
casx [%l6], %l3, %o5
! move %o5(upper) -> %o3(lower)
srlx %o5, 32, %l6
or %l6, %o3, %o3
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
add  %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4250
nop
RET4250:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4251: !_ST [11] (maybe <- 0x400000d) (Int)
stw   %l4, [%i2 + 64 ]
add   %l4, 1, %l4

P4252: !_BST [6] (maybe <- 0x43800043) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4253: !_BST [11] (maybe <- 0x43800046) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4254: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4255: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P4256: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4257: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P4258: !_CAS [8] (maybe <- 0x400000e) (Int)
add %i1, 256, %o5
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

P4259: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4260: !_LD [12] (Int)
lduw [%i3 + 0], %o5
! move %o5(lower) -> %o0(lower)
or %o5, %o0, %o0

P4261: !_BLD [9] (FP) (Branch target of P4420)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f0
membar #Sync 
! 1 addresses covered
ba P4262
nop

TARGET4420:
ba RET4420
nop


P4262: !_PREFETCH [9] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 512] %asi, 1

P4263: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P4264: !_BST [7] (maybe <- 0x43800047) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4265: !_BST [15] (maybe <- 0x4380004a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4266: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P4267: !_PREFETCH [0] (Int) (Branch target of P4221)
prefetch [%i0 + 0], 1
ba P4268
nop

TARGET4221:
ba RET4221
nop


P4268: !_BST [1] (maybe <- 0x4380004b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4269: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4270: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4271: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P4272: !_PREFETCH [8] (Int) (CBR) (Branch target of P4274)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4272
nop
RET4272:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0

ba P4273
nop

TARGET4274:
ba RET4274
nop


P4273: !_BST [9] (maybe <- 0x4380004f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4274: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4274
nop
RET4274:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4275: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P4276: !_BST [14] (maybe <- 0x43800050) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4277: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4278: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4279: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P4280: !_DWLD [5] (Int)
ldx [%i1 + 72], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4281: !_BST [1] (maybe <- 0x43800051) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4282: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4283: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P4284: !_LD [8] (Int)
lduw [%i1 + 256], %o5
! move %o5(lower) -> %o1(lower)
or %o5, %o1, %o1

P4285: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4286: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4287: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4288: !_DWST [14] (maybe <- 0x400000f) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4289: !_BST [7] (maybe <- 0x43800055) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4290: !_BST [15] (maybe <- 0x43800058) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4291: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P4292: !_BLD [4] (FP) (Branch target of P4144)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12
ba P4293
nop

TARGET4144:
ba RET4144
nop


P4293: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4294: !_BLD [8] (FP) (Branch target of P4380)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
ba P4295
nop

TARGET4380:
ba RET4380
nop


P4295: !_BST [14] (maybe <- 0x43800059) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4296: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4297: !_ST [1] (maybe <- 0x4380005a) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
st   %f20, [%i0 + 4 ]

P4298: !_DWLD [4] (Int)
ldx [%i0 + 64], %o2
! move %o2(upper) -> %o2(upper)

P4299: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P4300: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4301: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4302: !_BLD [3] (FP) (Branch target of P4471)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6
ba P4303
nop

TARGET4471:
ba RET4471
nop


P4303: !_DWST [4] (maybe <- 0x4000010) (Int) (Branch target of P4250)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 64 ] 
add   %l4, 1, %l4
ba P4304
nop

TARGET4250:
ba RET4250
nop


P4304: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7
fmovs %f19, %f8
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f40, %f10

P4305: !_PREFETCH [13] (Int) (Branch target of P4235)
prefetch [%i3 + 64], 1
ba P4306
nop

TARGET4235:
ba RET4235
nop


P4306: !_BST [11] (maybe <- 0x4380005b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4307: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4308: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4309: !_BST [9] (maybe <- 0x4380005c) (FP) (Branch target of P4594)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P4310
nop

TARGET4594:
ba RET4594
nop


P4310: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4311: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4311
nop
RET4311:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4312: !_BST [8] (maybe <- 0x4380005d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4313: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4314: !_SWAP [6] (maybe <- 0x4000011) (Int)
mov %l4, %l3
swap  [%i1 + 80], %l3
! move %l3(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4315: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P4316: !_CAS [12] (maybe <- 0x4000012) (Int)
add %i3, 0, %l7
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

P4317: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4318: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P4319: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4320: !_BST [12] (maybe <- 0x4380005e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4321: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f36, %f0

P4322: !_DWST [14] (maybe <- 0x4000013) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4323: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4324: !_CASX [14] (maybe <- 0x4000014) (Int)
add %i3, 128, %l3
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

P4325: !_BLD [10] (FP) (Branch target of P4311)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f2
ba P4326
nop

TARGET4311:
ba RET4311
nop


P4326: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P4327: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P4328: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4329: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4330: !_MEMBAR (Int)
membar #StoreLoad

P4331: !_BST [2] (maybe <- 0x4380005f) (FP) (Branch target of P4272)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P4332
nop

TARGET4272:
ba RET4272
nop


P4332: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4333: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f36, %f18
fmovs %f18, %f11
fmovs %f19, %f12

P4334: !_DWST [2] (maybe <- 0x4000015) (Int) (Branch target of P4137)
mov %l4, %l7 
stx %l7, [%i0 + 8]
add   %l4, 1, %l4
ba P4335
nop

TARGET4137:
ba RET4137
nop


P4335: !_BST [0] (maybe <- 0x43800063) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4336: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4337: !_ST [15] (maybe <- 0x4000016) (Int)
stw   %l4, [%i3 + 192 ]
add   %l4, 1, %l4

P4338: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P4339: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f14

P4340: !_SWAP [12] (maybe <- 0x4000017) (Int)
mov %l4, %o1
swap  [%i3 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1
add   %l4, 1, %l4

P4341: !_PREFETCH [10] (Int) (Branch target of P4143)
prefetch [%i2 + 32], 1
ba P4342
nop

TARGET4143:
ba RET4143
nop


P4342: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
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
fmovs %f19, %f0
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f40, %f2

P4343: !_BST [6] (maybe <- 0x43800067) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4344: !_BST [8] (maybe <- 0x4380006a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4345: !_DWST [14] (maybe <- 0x4000018) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 128 ] 
add   %l4, 1, %l4

P4346: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P4347: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4348: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4349: !_BST [8] (maybe <- 0x4380006b) (FP) (Branch target of P4160)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 
ba P4350
nop

TARGET4160:
ba RET4160
nop


P4350: !_REPLACEMENT [8] (Int)
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

P4351: !_BST [14] (maybe <- 0x4380006c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4352: !_PREFETCH [12] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 0] %asi, 1

P4353: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4354: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4355: !_BST [12] (maybe <- 0x4380006d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4356: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4357: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P4358: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4359: !_BST [13] (maybe <- 0x4380006e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4360: !_BST [6] (maybe <- 0x4380006f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4361: !_LD [9] (Int)
lduw [%i1 + 512], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P4362: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4363: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P4364: !_PREFETCH [10] (Int) (Branch target of P4484)
prefetch [%i2 + 32], 1
ba P4365
nop

TARGET4484:
ba RET4484
nop


P4365: !_BST [2] (maybe <- 0x43800072) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4366: !_BST [15] (maybe <- 0x43800076) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4367: !_LD [9] (FP)
ld [%i1 + 512], %f0
! 1 addresses covered

P4368: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4369: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4370: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4371: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4372: !_DWLD [4] (Int)
ldx [%i0 + 64], %o2
! move %o2(upper) -> %o2(upper)

P4373: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4374: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4375: !_BST [2] (maybe <- 0x43800077) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4376: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f9

P4377: !_BST [1] (maybe <- 0x4380007b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4378: !_BST [9] (maybe <- 0x4380007f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4379: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P4380: !_BLD [4] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4380
nop
RET4380:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4381: !_BST [3] (maybe <- 0x43800080) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4382: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4383: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4384: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13

P4385: !_BST [0] (maybe <- 0x43800084) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4385
nop
RET4385:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4386: !_ST [3] (maybe <- 0x4000019) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4387: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P4388: !_BST [6] (maybe <- 0x43800088) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4389: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

P4390: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f0
membar #Sync 
! 1 addresses covered

P4391: !_DWST [9] (maybe <- 0x400001a) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i1 + 512 ] 
add   %l4, 1, %l4

P4392: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4393: !_BST [12] (maybe <- 0x4380008b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4394: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4395: !_DWST [0] (maybe <- 0x400001b) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P4396: !_BST [14] (maybe <- 0x4380008c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4397: !_BST [0] (maybe <- 0x4380008d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4398: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4399: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P4400: !_DWLD [13] (Int)
ldx [%i3 + 64], %l7
! move %l7(upper) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srlx %l7, 32, %l6
or %l6, %o2, %o2

P4401: !_PREFETCH [8] (Int) (Branch target of P4537)
prefetch [%i1 + 256], 1
ba P4402
nop

TARGET4537:
ba RET4537
nop


P4402: !_BST [10] (maybe <- 0x43800091) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P4403: !_CAS [4] (maybe <- 0x400001d) (Int)
add %i0, 64, %o5
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

P4404: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4405: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4406: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4407: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P4408: !_BST [6] (maybe <- 0x43800092) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4409: !_PREFETCH [2] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
prefetcha [%i0 + 12] %asi, 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4409
nop
RET4409:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4410: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4411: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f36, %f18
fmovs %f18, %f13
fmovs %f19, %f14

P4412: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4413: !_BST [12] (maybe <- 0x43800095) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4414: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4415: !_BST [0] (maybe <- 0x43800096) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4416: !_BST [0] (maybe <- 0x4380009a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4417: !_BLD [11] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4417
nop
RET4417:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4418: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P4419: !_BST [12] (maybe <- 0x4380009e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4420: !_BST [1] (maybe <- 0x4380009f) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4420
nop
RET4420:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4421: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f1

P4422: !_BST [7] (maybe <- 0x438000a3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4423: !_BST [4] (maybe <- 0x438000a6) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4424: !_PREFETCH [6] (Int) (CBR)
prefetch [%i1 + 80], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4424
nop
RET4424:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4425: !_BST [12] (maybe <- 0x438000a7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4426: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4427: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P4428: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4429: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P4430: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P4431: !_REPLACEMENT [10] (Int)
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

P4432: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4433: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4434: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P4435: !_BST [5] (maybe <- 0x438000a8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4436: !_BST [9] (maybe <- 0x438000ab) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4437: !_BST [11] (maybe <- 0x438000ac) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4438: !_BST [15] (maybe <- 0x438000ad) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4439: !_PREFETCH [15] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
prefetcha [%i3 + 192] %asi, 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4439
nop
RET4439:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4440: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4441: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4442: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P4443: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4444: !_DWLD [12] (Int)
ldx [%i3 + 0], %o4
! move %o4(upper) -> %o4(upper)

P4445: !_ST [3] (maybe <- 0x400001e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4446: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4447: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4448: !_BST [0] (maybe <- 0x438000ae) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4449: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4450: !_BST [15] (maybe <- 0x438000b2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4451: !_BST [11] (maybe <- 0x438000b3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4452: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4453: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4454: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f36, %f4

P4455: !_REPLACEMENT [0] (Int)
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

P4456: !_BST [12] (maybe <- 0x438000b4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4457: !_REPLACEMENT [6] (Int)
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

P4458: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P4459: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4460: !_BST [11] (maybe <- 0x438000b5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4461: !_DWST [6] (maybe <- 0x438000b6) (FP)
! 0 th moved, current_fp_src=20 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=21 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
std %f20, [%i1 + 80]

P4462: !_BST [9] (maybe <- 0x438000b8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4463: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4464: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4465: !_BST [1] (maybe <- 0x438000b9) (FP) (Branch target of P4159)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P4466
nop

TARGET4159:
ba RET4159
nop


P4466: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4467: !_CAS [10] (maybe <- 0x400001f) (Int)
add %i2, 32, %l6
lduw [%l6], %o5
mov %o5, %l3
! move %l3(lower) -> %o4(lower)
srlx %o4, 32, %o4
sllx %o4, 32, %o4
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
mov %l4, %o0
cas [%l6], %l3, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4468: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P4469: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P4470: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4471: !_CASX [15] (maybe <- 0x4000020) (Int) (CBR)
add %i3, 192, %l6
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4471
nop
RET4471:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4472: !_BST [6] (maybe <- 0x438000bd) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4473: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4474: !_REPLACEMENT [5] (Int)
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

P4475: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4476: !_ST [9] (maybe <- 0x4000021) (Int)
stw   %l4, [%i1 + 512 ]
add   %l4, 1, %l4

P4477: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4478: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4479: !_DWLD [6] (Int)
ldx [%i1 + 80], %o5
! move %o5(upper) -> %o2(lower)
srlx %o5, 32, %l7
or %l7, %o2, %o2
! move %o5(lower) -> %o3(upper)
sllx %o5, 32, %o3

P4480: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4481: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4482: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P4483: !_BST [13] (maybe <- 0x438000c0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4484: !_PREFETCH [8] (Int) (CBR)
prefetch [%i1 + 256], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4484
nop
RET4484:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4485: !_BST [7] (maybe <- 0x438000c1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4486: !_PREFETCH [7] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i1 + 84] %asi, 1

P4487: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4488: !_MEMBAR (Int)
membar #StoreLoad

P4489: !_BST [14] (maybe <- 0x438000c4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 128 ] %asi
membar #Sync 

P4490: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4491: !_BST [10] (maybe <- 0x438000c5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=40 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i2 + 0 ] %asi
membar #Sync 

P4492: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4493: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P4494: !_BST [12] (maybe <- 0x438000c6) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4494
nop
RET4494:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4495: !_CASX [14] (maybe <- 0x4000022) (Int)
add %i3, 128, %l7
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

P4496: !_BST [3] (maybe <- 0x438000c7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4497: !_DWST [7] (maybe <- 0x4000023) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i1 + 80]
add   %l4, 1, %l4

P4498: !_BST [0] (maybe <- 0x438000cb) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4499: !_BST [11] (maybe <- 0x438000cf) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4500: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4501: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4502: !_BST [3] (maybe <- 0x438000d0) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4503: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4504: !_DWST [13] (maybe <- 0x4000025) (Int)
mov %l4, %l3 
sllx %l3, 32, %l3 
stx %l3, [%i3 + 64 ] 
add   %l4, 1, %l4

P4505: !_BST [5] (maybe <- 0x438000d4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4506: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4507: !_DWLD [15] (Int)
ldx [%i3 + 192], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l7
or %l7, %o0, %o0

P4508: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4509: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8

P4510: !_CAS [8] (maybe <- 0x4000026) (Int) (LE)
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
add %i1, 256, %l6
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

P4511: !_PREFETCH [6] (Int)
prefetch [%i1 + 80], 1

P4512: !_REPLACEMENT [3] (Int)
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

P4513: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4514: !_BST [9] (maybe <- 0x438000d7) (FP) (Branch target of P4417)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P4515
nop

TARGET4417:
ba RET4417
nop


P4515: !_BST [9] (maybe <- 0x438000d8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4516: !_BST [8] (maybe <- 0x438000d9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4517: !_BST [9] (maybe <- 0x438000da) (FP) (Branch target of P4632)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 
ba P4518
nop

TARGET4632:
ba RET4632
nop


P4518: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f10

P4519: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P4520: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P4521: !_ST [7] (maybe <- 0x4000027) (Int)
stw   %l4, [%i1 + 84 ]
add   %l4, 1, %l4

P4522: !_CAS [0] (maybe <- 0x4000028) (Int)
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

P4523: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4524: !_DWST [10] (maybe <- 0x4000029) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i2 + 32 ] 
add   %l4, 1, %l4

P4525: !_BST [7] (maybe <- 0x438000db) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4526: !_BST [12] (maybe <- 0x438000de) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4527: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f0
membar #Sync 
! 1 addresses covered

P4528: !_DWLD [5] (FP)
ldd [%i1 + 72], %f18
! 1 addresses covered
fmovs %f19, %f1

P4529: !_BST [2] (maybe <- 0x438000df) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4530: !_BST [1] (maybe <- 0x438000e3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4531: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4532: !_BST [12] (maybe <- 0x438000e7) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4533: !_BST [15] (maybe <- 0x438000e8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4534: !_BST [11] (maybe <- 0x438000e9) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4535: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P4536: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4537: !_BST [7] (maybe <- 0x438000ea) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4537
nop
RET4537:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4538: !_DWLD [1] (FP)
ldd [%i0 + 0], %f18
! 2 addresses covered
fmovs %f18, %f5
fmovs %f19, %f6

P4539: !_BST [15] (maybe <- 0x438000ed) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4540: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4541: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4542: !_DWLD [12] (Int)
ldx [%i3 + 0], %o3
! move %o3(upper) -> %o3(upper)

P4543: !_BLD [1] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4543
nop
RET4543:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4544: !_LD [1] (Int)
lduw [%i0 + 4], %l6
! move %l6(lower) -> %o3(lower)
srlx %o3, 32, %o3
sllx %o3, 32, %o3
or %l6, %o3, %o3

P4545: !_PREFETCH [2] (Int)
prefetch [%i0 + 12], 1

P4546: !_REPLACEMENT [4] (Int)
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

P4547: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4548: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4549: !_LD [13] (Int)
lduw [%i3 + 64], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4550: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4551: !_ST [14] (maybe <- 0x400002a) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4552: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P4553: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4554: !_BST [7] (maybe <- 0x438000ee) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4555: !_BST [4] (maybe <- 0x438000f1) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4556: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f2
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f40, %f18
fmovs %f18, %f5

P4557: !_SWAP [14] (maybe <- 0x400002b) (Int)
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

P4558: !_BST [8] (maybe <- 0x438000f2) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4559: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f6

P4560: !_BLD [7] (FP) (Branch target of P4609)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f36, %f8
ba P4561
nop

TARGET4609:
ba RET4609
nop


P4561: !_BST [13] (maybe <- 0x438000f3) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4562: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P4563: !_MEMBAR (Int) (Branch target of P4589)
membar #StoreLoad
ba P4564
nop

TARGET4589:
ba RET4589
nop


P4564: !_BST [4] (maybe <- 0x438000f4) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4565: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4566: !_SWAP [10] (maybe <- 0x400002c) (Int) (LE)
wr %g0, 0x88, %asi
mov %l4, %o0
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %l3
or %l3, %lo(0xff00ff00), %l3
and %o0, %l3, %l6
srl %l6, 8, %l6
sll %o0, 8, %o0
and %o0, %l3, %o0
or %o0, %l6, %o0
srl %o0, 16, %l6
sll %o0, 16, %o0
srl %o0, 0, %o0
or %o0, %l6, %o0
swapa  [%i2 + 32] %asi, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4567: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11

P4568: !_BST [7] (maybe <- 0x438000f5) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4569: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f12
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f40, %f18
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

P4570: !_DWST [4] (maybe <- 0x400002d) (Int)
mov %l4, %l7 
sllx %l7, 32, %l7 
stx %l7, [%i0 + 64 ] 
add   %l4, 1, %l4

P4571: !_DWLD [4] (Int)
ldx [%i0 + 64], %l7
! move %l7(upper) -> %o0(lower)
srlx %l7, 32, %l6
or %l6, %o0, %o0

P4572: !_BST [7] (maybe <- 0x438000f8) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4573: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4574: !_ST [3] (maybe <- 0x400002e) (Int)
stw   %l4, [%i0 + 32 ]
add   %l4, 1, %l4

P4575: !_DWLD [15] (FP)
ldd [%i3 + 192], %f0
! 1 addresses covered

P4576: !_BST [11] (maybe <- 0x438000fb) (FP) (Branch target of P4637)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 
ba P4577
nop

TARGET4637:
ba RET4637
nop


P4577: !_PREFETCH [11] (Int)
prefetch [%i2 + 64], 1

P4578: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4579: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P4580: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f6
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f40, %f18
fmovs %f18, %f9

P4581: !_BST [7] (maybe <- 0x438000fc) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4582: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P4583: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4584: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P4585: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f14

P4586: !_ST [5] (maybe <- 0x400002f) (Int)
stw   %l4, [%i1 + 76 ]
add   %l4, 1, %l4

P4587: !_BST [8] (maybe <- 0x438000ff) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4588: !_BST [11] (maybe <- 0x43800100) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4589: !_PREFETCH [3] (Int) (CBR)
prefetch [%i0 + 32], 1

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4589
nop
RET4589:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4590: !_DWST [13] (maybe <- 0x4000030) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i3 + 64 ] 
add   %l4, 1, %l4

P4591: !_BST [9] (maybe <- 0x43800101) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4592: !_BST [3] (maybe <- 0x43800102) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4593: !_CASX [5] (maybe <- 0x4000031) (Int)
add %i1, 72, %o5
ldx [%o5], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)
mov  %o1, %l7
mov %l4, %o2
casx [%o5], %l7, %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
add  %l4, 1, %l4

P4594: !_BLD [15] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4594
nop
RET4594:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4595: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P4596: !_BST [1] (maybe <- 0x43800106) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4597: !_BST [0] (maybe <- 0x4380010a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4598: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4599: !_BST [2] (maybe <- 0x4380010e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4600: !_CAS [4] (maybe <- 0x4000032) (Int) (LE)
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
add %i0, 64, %l6
lduwa [%l6] %asi, %o3
mov %o3, %l3
! move %l3(lower) -> %o3(upper)
sllx %l3, 32, %o3
mov %l7, %o5
casa [%l6] %asi, %l3, %o5
! move %o5(lower) -> %o3(lower)
srl %o5, 0, %l6
or %l6, %o3, %o3
add   %l4, 1, %l4

P4601: !_PREFETCH [4] (Int)
prefetch [%i0 + 64], 1

P4602: !_BST [13] (maybe <- 0x43800112) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4603: !_BST [0] (maybe <- 0x43800113) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4604: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4605: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4606: !_BST [9] (maybe <- 0x43800117) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4607: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4608: !_BST [9] (maybe <- 0x43800118) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4609: !_ST [2] (maybe <- 0x4000033) (Int) (CBR)
stw   %l4, [%i0 + 12 ]
add   %l4, 1, %l4

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4609
nop
RET4609:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4610: !_BST [9] (maybe <- 0x43800119) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4611: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5

P4612: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f36, %f18
fmovs %f18, %f7
fmovs %f19, %f8

P4613: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f9
fmovd %f36, %f10

P4614: !_PREFETCH [15] (Int)
prefetch [%i3 + 192], 1

P4615: !_PREFETCH [13] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i3 + 64] %asi, 1

P4616: !_BST [11] (maybe <- 0x4380011a) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4617: !_BST [6] (maybe <- 0x4380011b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4618: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4619: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P4620: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4621: !_DWST [3] (maybe <- 0x4000034) (Int)
mov %l4, %l6 
sllx %l6, 32, %l6 
stx %l6, [%i0 + 32 ] 
add   %l4, 1, %l4

P4622: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4623: !_LD [14] (Int)
lduw [%i3 + 128], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4624: !_DWLD [14] (Int)
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

P4625: !_BST [6] (maybe <- 0x4380011e) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4625
nop
RET4625:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4626: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4627: !_REPLACEMENT [5] (Int)
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

P4628: !_SWAP [3] (maybe <- 0x4000035) (Int) (LE)
wr %g0, 0x88, %asi
mov %l4, %o0
! Change single-word-level endianess (big endian <-> little endian) 
sethi %hi(0xff00ff00), %o5
or %o5, %lo(0xff00ff00), %o5
and %o0, %o5, %l3
srl %l3, 8, %l3
sll %o0, 8, %o0
and %o0, %o5, %o0
or %o0, %l3, %o0
srl %o0, 16, %l3
sll %o0, 16, %o0
srl %o0, 0, %o0
or %o0, %l3, %o0
swapa  [%i0 + 32] %asi, %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0
add   %l4, 1, %l4

P4629: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3

P4630: !_PREFETCH [7] (Int)
prefetch [%i1 + 84], 1

P4631: !_DWLD [4] (Int)
ldx [%i0 + 64], %o5
! move %o5(upper) -> %o0(lower)
srlx %o5, 32, %l7
or %l7, %o0, %o0

P4632: !_REPLACEMENT [9] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4632
nop
RET4632:

! lfsr step begin
srlx %l0, 1, %o5
xnor %o5, %l0, %o5
sllx %o5, 63, %o5
or  %o5, %l0, %l0
srlx %l0, 1, %l0


P4633: !_BST [7] (maybe <- 0x43800121) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4634: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P4635: !_MEMBAR (Int)
membar #StoreLoad

P4636: !_BST [4] (maybe <- 0x43800124) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4637: !_MEMBAR (Int) (CBR)
membar #StoreLoad

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4637
nop
RET4637:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4638: !_LD [0] (Int)
lduw [%i0 + 0], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4639: !_LD [1] (Int)
lduw [%i0 + 4], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1

P4640: !_LD [2] (Int)
lduw [%i0 + 12], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4641: !_LD [3] (Int)
lduw [%i0 + 32], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P4642: !_LD [4] (Int)
lduw [%i0 + 64], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4643: !_LD [5] (Int)
lduw [%i1 + 76], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

P4644: !_LD [6] (Int)
lduw [%i1 + 80], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4645: !_LD [7] (Int)
lduw [%i1 + 84], %l7
! move %l7(lower) -> %o4(lower)
or %l7, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4646: !_LD [8] (Int)
lduw [%i1 + 256], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4647: !_LD [9] (Int)
lduw [%i1 + 512], %l7
! move %l7(lower) -> %o0(lower)
or %l7, %o0, %o0

P4648: !_LD [10] (Int)
lduw [%i2 + 32], %o1
! move %o1(lower) -> %o1(upper)
sllx %o1, 32, %o1

P4649: !_LD [11] (Int) (Branch target of P4543)
lduw [%i2 + 64], %l7
! move %l7(lower) -> %o1(lower)
or %l7, %o1, %o1
ba P4650
nop

TARGET4543:
ba RET4543
nop


P4650: !_LD [12] (Int)
lduw [%i3 + 0], %o2
! move %o2(lower) -> %o2(upper)
sllx %o2, 32, %o2

P4651: !_LD [13] (Int)
lduw [%i3 + 64], %l7
! move %l7(lower) -> %o2(lower)
or %l7, %o2, %o2

P4652: !_LD [14] (Int)
lduw [%i3 + 128], %o3
! move %o3(lower) -> %o3(upper)
sllx %o3, 32, %o3

P4653: !_LD [15] (Int)
lduw [%i3 + 192], %l7
! move %l7(lower) -> %o3(lower)
or %l7, %o3, %o3

END_NODES8: ! Test istream for CPU 8 ends
sethi %hi(0xdead0e0f), %o5
or    %o5, %lo(0xdead0e0f), %o5
! move %o5(lower) -> %o4(upper)
sllx %o5, 32, %o4
stw %o5, [%i5] 
ld [%i5], %f7
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30

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

func9:
! 500 (dynamic) instruction sequence begins
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
sethi %hi(0x09deade1), %l7
or    %l7, %lo(0x09deade1), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize running integer counter in register %l4
sethi %hi(0x4800001), %l4
or    %l4, %lo(0x4800001), %l4

! Initialize running FP counter in register %f16
sethi %hi(0x44000001), %l7
or    %l7, %lo(0x44000001), %l7
stw %l7, [%i5] 
ld [%i5], %f16

! Initialize FP counter increment value in register %f17 (constant)
sethi %hi(0x38800000), %l7
or    %l7, %lo(0x38800000), %l7
stw %l7, [%i5] 
ld [%i5], %f17 

! Initialize LFSR to 0x600c^4
sethi %hi(0x600c), %l0
or    %l0, %lo(0x600c), %l0
mulx  %l0, %l0, %l0
mulx  %l0, %l0, %l0

!-- init shared addrs 4 to 4 ---
stx %g0, [%i0+64]

! use untouched cache-line (offset 4K) in replacement area for sync
sub %i1, %i0, %o5
add %i3, %o5, %o5
sub %o5, -4096, %o5

!-- begin of sync_init ---
or %g0, 1, %l3
or %g0, %l3, %l6
swap [%o5+4], %l6
membar #Sync
sync_init_1_9:
brnz,pt %l3, sync_init_1_9
lduw [%o5+4], %l3 ! delay slot
sync_init_2_9:
lduw [%o5], %l3
sub %l3, 1, %l6
cas [%o5], %l3, %l6
cmp %l3, %l6
bne,pt %xcc, sync_init_2_9
nop
membar #Sync
sync_init_3_9:
lduw [%o5], %l3 ! delay slot
brnz,pt %l3, sync_init_3_9
nop
!-- end of sync_init ---


BEGIN_NODES9: ! Test istream for CPU 9 begins

P4654: !_LD [13] (Int)
lduw [%i3 + 64], %o0
! move %o0(lower) -> %o0(upper)
sllx %o0, 32, %o0

P4655: !_BST [11] (maybe <- 0x44000001) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i2 + 64 ] %asi
membar #Sync 

P4656: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4657: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f0
membar #Sync 
! 4 addresses covered
fmovs %f3, %f2
fmovs %f8, %f3

P4658: !_BST [13] (maybe <- 0x44000002) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 64 ] %asi
membar #Sync 

P4659: !_BST [15] (maybe <- 0x44000003) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4660: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4661: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f4
fmovd %f34, %f18
fmovs %f19, %f6
fmovd %f40, %f18
fmovs %f18, %f7

P4662: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4663: !_BST [0] (maybe <- 0x44000004) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4664: !_LD [4] (Int)
lduw [%i0 + 64], %l6
! move %l6(lower) -> %o0(lower)
or %l6, %o0, %o0

P4665: !_PREFETCH [10] (Int)
prefetch [%i2 + 32], 1

P4666: !_BLD [2] (FP) (Branch target of P4861)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11
ba P4667
nop

TARGET4861:
ba RET4861
nop


P4667: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4668: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4669: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
fmovs %f18, %f13

P4670: !_BST [15] (maybe <- 0x44000008) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4671: !_BLD [6] (FP) (CBR)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4671
nop
RET4671:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4672: !_BST [3] (maybe <- 0x44000009) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4673: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4674: !_BST [9] (maybe <- 0x4400000d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4675: !_DWLD [6] (Int)
ldx [%i1 + 80], %o1
! move %o1(upper) -> %o1(upper)
! move %o1(lower) -> %o1(lower)

P4676: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P4677: !_MEMBAR (Int) (CBR)
membar #StoreLoad

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4677
nop
RET4677:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4678: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9
fmovs %f19, %f10
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f40, %f12

P4679: !_REPLACEMENT [12] (Int)
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

P4680: !_PREFETCH [10] (Int) (Branch target of P5152)
prefetch [%i2 + 32], 1
ba P4681
nop

TARGET5152:
ba RET5152
nop


P4681: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f36, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30

P4682: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f0
membar #Sync 
! 1 addresses covered

P4683: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4684: !_BST [6] (maybe <- 0x4400000e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4685: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P4686: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4687: !_PREFETCH [8] (Int)
prefetch [%i1 + 256], 1

P4688: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f4
fmovd %f36, %f18
fmovs %f18, %f5
fmovs %f19, %f6

P4689: !_BST [15] (maybe <- 0x44000011) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4690: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4691: !_PREFETCH [0] (Int) (LE) (CBR)
wr %g0, 0x88, %asi
prefetcha [%i0 + 0] %asi, 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4691
nop
RET4691:

! lfsr step begin
srlx %l0, 1, %l3
xnor %l3, %l0, %l3
sllx %l3, 63, %l3
or  %l3, %l0, %l0
srlx %l0, 1, %l0


P4692: !_CASX [5] (maybe <- 0x4800001) (Int)
add %i1, 72, %l7
ldx [%l7], %o2
! move %o2(upper) -> %o2(upper)
! move %o2(lower) -> %o2(lower)
mov  %o2, %l6
mov %l4, %o3
casx [%l7], %l6, %o3
! move %o3(upper) -> %o3(upper)
! move %o3(lower) -> %o3(lower)
add  %l4, 1, %l4

P4693: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4694: !_REPLACEMENT [14] (Int)
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

P4695: !_BST [0] (maybe <- 0x44000012) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4696: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4697: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P4698: !_BST [4] (maybe <- 0x44000016) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4699: !_LD [2] (Int)
lduw [%i0 + 12], %o4
! move %o4(lower) -> %o4(upper)
sllx %o4, 32, %o4

P4700: !_DWLD [13] (Int) (LE)
wr %g0, 0x88, %asi
ldxa [%i3 + 64] %asi, %l6
! move %l6(lower) -> %o4(lower)
srl %l6, 0, %l3
or %l3, %o4, %o4
!---- flushing int results buffer----
mov %o0, %l5
mov %o1, %l5
mov %o2, %l5
mov %o3, %l5
mov %o4, %l5

P4701: !_PREFETCH [0] (Int)
prefetch [%i0 + 0], 1

P4702: !_BST [12] (maybe <- 0x44000017) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4703: !_DWLD [9] (FP)
ldd [%i1 + 512], %f12
! 1 addresses covered

P4704: !_BLD [3] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P4705: !_ST [14] (maybe <- 0x4800002) (Int)
stw   %l4, [%i3 + 128 ]
add   %l4, 1, %l4

P4706: !_BLD [6] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f1
fmovd %f36, %f2

P4707: !_BLD [14] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 128] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f4

P4708: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4709: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4710: !_MEMBAR (Int)
membar #StoreLoad

P4711: !_BST [8] (maybe <- 0x44000018) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4712: !_BST [3] (maybe <- 0x44000019) (FP) (CBR)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

! cbranch
andcc %l0, 1, %g0
be,pn  %xcc, TARGET4712
nop
RET4712:

! lfsr step begin
srlx %l0, 1, %l7
xnor %l7, %l0, %l7
sllx %l7, 63, %l7
or  %l7, %l0, %l0
srlx %l0, 1, %l0


P4713: !_BST [12] (maybe <- 0x4400001d) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4714: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f8

P4715: !_BLD [13] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4716: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f10
fmovd %f34, %f18
fmovs %f19, %f12
fmovd %f40, %f18
fmovs %f18, %f13

P4717: !_PREFETCH [10] (Int) (LE)
wr %g0, 0x88, %asi
prefetcha [%i2 + 32] %asi, 1

P4718: !_BLD [1] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f14
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f34, %f18
fmovs %f19, %f0
fmovd %f40, %f18
fmovs %f18, %f1

P4719: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f2

P4720: !_REPLACEMENT [8] (Int) (CBR)
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

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4720
nop
RET4720:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4721: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4722: !_REPLACEMENT [5] (Int)
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

P4723: !_BST [7] (maybe <- 0x4400001e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4724: !_PREFETCH [3] (Int)
prefetch [%i0 + 32], 1

P4725: !_DWST [1] (maybe <- 0x4800003) (Int) (Branch target of P4840)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4
ba P4726
nop

TARGET4840:
ba RET4840
nop


P4726: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4727: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f3
fmovs %f19, %f4
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f40, %f6

P4728: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4729: !_BLD [8] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 256] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f7

P4730: !_DWLD [8] (Int)
ldx [%i1 + 256], %o0
! move %o0(upper) -> %o0(upper)

P4731: !_BST [3] (maybe <- 0x44000021) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4732: !_BST [6] (maybe <- 0x44000025) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4733: !_BLD [2] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f8
fmovd %f34, %f18
fmovs %f19, %f10
fmovd %f40, %f18
fmovs %f18, %f11

P4734: !_BST [1] (maybe <- 0x44000028) (FP) (Branch target of P4974)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 
ba P4735
nop

TARGET4974:
ba RET4974
nop


P4735: !_BST [6] (maybe <- 0x4400002c) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4736: !_LD [9] (Int)
lduw [%i1 + 512], %l7
! move %l7(lower) -> %o0(lower)
srlx %o0, 32, %o0
sllx %o0, 32, %o0
or %l7, %o0, %o0

P4737: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4738: !_BLD [11] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f12

P4739: !_BST [9] (maybe <- 0x4400002f) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 512 ] %asi
membar #Sync 

P4740: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f13
fmovs %f19, %f14
fmovd %f34, %f18
fmovs %f19, %f15
!---- flushing fp results buffer to %f30 ----
fmovd %f0, %f30
fmovd %f2, %f30
fmovd %f4, %f30
fmovd %f6, %f30
fmovd %f8, %f30
fmovd %f10, %f30
fmovd %f12, %f30
fmovd %f14, %f30
fmovd %f40, %f0

P4741: !_BST [8] (maybe <- 0x44000030) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i1 + 256 ] %asi
membar #Sync 

P4742: !_NOP (Int)
nop

P4743: !_DWLD [15] (FP)
ldd [%i3 + 192], %f18
! 1 addresses covered
fmovs %f18, %f1

P4744: !_BLD [7] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f2
fmovd %f36, %f18
fmovs %f18, %f3
fmovs %f19, %f4

P4745: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f5
fmovs %f19, %f6
fmovd %f34, %f18
fmovs %f19, %f7
fmovd %f40, %f8

P4746: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4747: !_PREFETCH [14] (Int)
prefetch [%i3 + 128], 1

P4748: !_BST [15] (maybe <- 0x44000031) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 192 ] %asi
membar #Sync 

P4749: !_BLD [9] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 512] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f9

P4750: !_PREFETCH [5] (Int)
prefetch [%i1 + 76], 1

P4751: !_PREFETCH [9] (Int)
prefetch [%i1 + 512], 1

P4752: !_CAS [3] (maybe <- 0x4800005) (Int)
add %i0, 32, %l6
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

P4753: !_BLD [4] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 64] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f10

P4754: !_DWST [0] (maybe <- 0x4800006) (Int)
sllx %l4, 32, %l3 
add   %l4, 1, %l4
or %l3, %l4, %l3
stx %l3, [%i0 + 0]
add   %l4, 1, %l4

P4755: !_DWLD [13] (Int)
ldx [%i3 + 64], %o2
! move %o2(upper) -> %o2(upper)

P4756: !_PREFETCH [4] (Int) (CBR)
prefetch [%i0 + 64], 1

! cbranch
andcc %l0, 1, %g0
be,pt  %xcc, TARGET4756
nop
RET4756:

! lfsr step begin
srlx %l0, 1, %l6
xnor %l6, %l0, %l6
sllx %l6, 63, %l6
or  %l6, %l0, %l0
srlx %l0, 1, %l0


P4757: !_ST [10] (maybe <- 0x4800008) (Int)
stw   %l4, [%i2 + 32 ]
add   %l4, 1, %l4

P4758: !_BST [12] (maybe <- 0x44000032) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i3 + 0 ] %asi
membar #Sync 

P4759: !_BLD [2] (FP) (Branch target of P4720)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f11
fmovs %f19, %f12
fmovd %f34, %f18
fmovs %f19, %f13
fmovd %f40, %f14
ba P4760
nop

TARGET4720:
ba RET4720
nop


P4760: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4761: !_REPLACEMENT [11] (Int)
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

P4762: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4763: !_BLD [10] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i2 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f40, %f18
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

P4764: !_PREFETCH [13] (Int)
prefetch [%i3 + 64], 1

P4765: !_BST [7] (maybe <- 0x44000033) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4766: !_BLD [15] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 192] %asi, %f0
membar #Sync 
! 1 addresses covered

P4767: !_BST [4] (maybe <- 0x44000036) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f32
membar #Sync 
stda %f32, [%i0 + 64 ] %asi
membar #Sync 

P4768: !_BST [1] (maybe <- 0x44000037) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4769: !_BLD [0] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i0 + 0] %asi, %f32
membar #Sync 
! 4 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1
fmovs %f19, %f2
fmovd %f34, %f18
fmovs %f19, %f3
fmovd %f40, %f4

P4770: !_PREFETCH [1] (Int)
prefetch [%i0 + 4], 1

P4771: !_BST [7] (maybe <- 0x4400003b) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=35 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=36 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=37 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
fmovd %f20, %f36
membar #Sync 
stda %f32, [%i1 + 64 ] %asi
membar #Sync 

P4772: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f5
fmovd %f36, %f6

P4773: !_PREFETCH [12] (Int)
prefetch [%i3 + 0], 1

P4774: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f8
fmovd %f36, %f18
fmovs %f18, %f9
fmovs %f19, %f10

P4775: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f11
fmovd %f36, %f12

P4776: !_BST [2] (maybe <- 0x4400003e) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 
stda %f32, [%i0 + 0 ] %asi
membar #Sync 

P4777: !_SWAP [2] (maybe <- 0x4800009) (Int)
mov %l4, %l3
swap  [%i0 + 12], %l3
! move %l3(lower) -> %o2(lower)
srlx %o2, 32, %o2
sllx %o2, 32, %o2
srl %l3, 0, %l7
or %l7, %o2, %o2
add   %l4, 1, %l4

P4778: !_BLD [5] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i1 + 64] %asi, %f32
membar #Sync 
! 3 addresses covered
fmovd %f34, %f18
fmovs %f19, %f14
fmovd %f36, %f18
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
fmovs %f19, %f0

P4779: !_BLD [12] (FP)
wr %g0, 0xf0, %asi
membar #Sync 
ldda [%i3 + 0] %asi, %f32
membar #Sync 
! 1 addresses covered
fmovd %f32, %f18
fmovs %f18, %f1

P4780: !_BST [1] (maybe <- 0x44000042) (FP)
wr %g0, 0xf0, %asi
! 0 th moved, current_fp_src=32 
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
! 1 th moved, current_fp_src=33 
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 2 th moved, current_fp_src=35 
fmovd %f20, %f32
fmovs  %f16, %f21
fadds  %f16, %f17, %f16
! 3 th moved, current_fp_src=40 
fmovd %f20, %f34
fmovs  %f16, %f20
fadds  %f16, %f17, %f16
fmovd %f20, %f40
membar #Sync 



