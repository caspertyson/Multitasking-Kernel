.global main
.text

.equ pcb_link, 0
.equ pcb_reg1, 1
.equ pcb_reg2, 2
.equ pcb_reg3, 3
.equ pcb_reg4, 4
.equ pcb_reg5, 5
.equ pcb_reg6, 6
.equ pcb_reg7, 7
.equ pcb_reg8, 8
.equ pcb_reg9, 9
.equ pcb_reg10, 10
.equ pcb_reg11, 11
.equ pcb_reg12, 12
.equ pcb_reg13, 13
.equ pcb_sp, 14
.equ pcb_ra, 15
.equ pcb_ear, 16
.equ pcb_cctrl, 17
.equ pcb_time, 18


main:
	movsg $2, $cctrl  	#set up cctrl
	andi $2, $2, 0x000F
	ori $2, $2, 0x42	   
	movgs $cctrl, $2
	
	movsg $2, $evec	#set up exception handler
	sw $2, old_vector($0)
	la $2, our_handler
	movgs $evec, $2
	
	
	
	#PCB1_SETUP for SERIAL
	la   $1, process1_pcb
	la   $2, process2_pcb		#change this to next process 
 	sw   $2, pcb_link($1)		#stores next pcb to run here
	la   $2, process1_stack
 	sw   $2, pcb_sp($1)		#stores sp in pcb
 	la   $2, serial_main
 	sw   $2, pcb_ear($1)		#stores link to program?
 	
 	addi $2, $0, 0x1
 	sw $2, pcb_time($1)

 	
 	addi $2, $0, 0x4d		
 	sw   $2, pcb_cctrl($1)  	
 	
	sw   $1, current_process($0)	#saves address of current process
	
	#PCB2_SETUP for PARRALLEL
	la   $1, process2_pcb
	la   $2, process3_pcb		#change this to next process 
 	sw   $2, pcb_link($1)		#stores next pcb to run here
	la   $2, process2_stack
 	sw   $2, pcb_sp($1)		#stores sp in pcb
 	la   $2, parallel_main
 	sw   $2, pcb_ear($1)		#stores link to program?
 	
 	addi $2, $0, 0x1
 	sw $2, pcb_time($1)


 	addi $2, $0, 0x4d		
 	sw   $2, pcb_cctrl($1)  
 	
 	#PCB3_SETUP for GAME
	la   $1, process3_pcb
	la   $2, process1_pcb		#change this to next process 
 	sw   $2, pcb_link($1)		#stores next pcb to run here
	la   $2, process3_stack
 	sw   $2, pcb_sp($1)		#stores sp in pcb
 	la   $2, rocks_main
 	sw   $2, pcb_ear($1)		#stores link to program?
 	
 	addi $2, $0, 0x4
 	sw $2, pcb_time($1)

 	
 	addi $2, $0, 0x4d		
 	sw   $2, pcb_cctrl($1)  	
	
	sw $0, 0x72003($0)		#set up timer
	addi $2, $0, 24
	sw $2, 0x72001($0)
	addi $2, $0, 0x03
	sw $2, 0x72000($0)

	j load_context			#jumps to load_context
	
our_handler:
	movsg $13, $estat 		#checks the cause of the interruption
	andi $13, $13, 0xFFB0	
	beqz $13, handle_timer

	lw $13, old_vector($0)		#jumlps to old exception handler
	jr $13

handle_timer:	
	sw $0, 0x72003($0)		#adds one to timer, for every exception
	lw $13, counter($0)
	addi $13, $13, 1
	sw $13, counter($0)
	
	lw $13, time_slice($0)
	subui $13, $13, 1
	sw $13, time_slice($0)
	
	beqz $13, dispatcher
	rfe
	
dispatcher:			

save_context:	
	lw $13, current_process($0)	#get current pcb address 
	
	sw $1, pcb_reg1($13)		#save register
	sw $2, pcb_reg2($13)
	sw $3, pcb_reg3($13)
	sw $4, pcb_reg4($13)
	sw $5, pcb_reg5($13)
	sw $6, pcb_reg6($13)
	sw $7, pcb_reg7($13)
	sw $8, pcb_reg8($13)
	sw $9, pcb_reg9($13)
	sw $10, pcb_reg10($13)
	sw $11, pcb_reg11($13)
	sw $12, pcb_reg12($13)
	
	movsg $1, $ers			#get old value of $13
	sw $1, pcb_reg13($13)

	sw $sp, pcb_sp($13)

	sw $ra, pcb_ra($13)

	movsg $1, $ear			
	sw $1, pcb_ear($13)
	
	movsg $1, $cctrl
	sw $1, pcb_cctrl($13)
	

schedule:
	lw $13, current_process($0)
	lw $13, pcb_link($13) 		#loads next pcb address
	sw $13, current_process($0)	

load_context:
	lw $13, current_process($0)	#get current PCB

	lw $1, pcb_time($13)
	sw $1, time_slice($0)
	
	lw $1, pcb_reg13($13)
	movgs $ers, $1
		
	lw $ra, pcb_ra($13)

	lw $sp, pcb_sp($13)

	lw $1, pcb_ear($13)
	movgs $ear, $1
	
	lw $1, pcb_cctrl($13)
	movgs $cctrl, $1
	
	lw $1, pcb_reg1($13)
	lw $2, pcb_reg2($13)
	lw $3, pcb_reg3($13)
	lw $4, pcb_reg4($13)
	lw $5, pcb_reg5($13)
	lw $6, pcb_reg6($13)
	lw $7, pcb_reg7($13)
	lw $8, pcb_reg8($13)
	lw $9, pcb_reg9($13)
	lw $10, pcb_reg10($13)
	lw $11, pcb_reg11($13)
	lw $12, pcb_reg12($13)
	lw $13, pcb_reg13($13)
	
	rfe

.data
time_slice: .word 0

.bss
current_process:			#stores current process
	.word
	.space 200
process1_stack:			#creates space process 1 stack
process1_pcb:
	.space 20			#creates space for process 1 pcb
	
#space for process2
	.space 200
process2_stack:
process2_pcb:
	.space 20

#space for process3
	.space 200
process3_stack:
process3_pcb:
	.space 20

old_vector: .word			#place to store old exception handler














