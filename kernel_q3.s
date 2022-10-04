.global main
.text

main:
	movsg $2, $cctrl 
	andi $2, $2, 0x000F
	ori $2, $2, 0x42	   
	movgs $cctrl, $2
	
	movsg $2, $evec	#set up exception handler
	sw $2, old_vector($0)
	la $2, our_handler
	movgs $evec, $2
	
	sw $0, 0x72003($0)		#set up timer
	addi $2, $0, 24
	sw $2, 0x72001($0)
	addi $2, $0, 0x03
	sw $2, 0x72000($0)

	jal serial_main
	
our_handler:
	movsg $13, $estat 		#checks the cause of the interruption
	andi $13, $13, 0xFFB0	
	beqz $13, handle_timer

	lw $13, old_vector($0)
	jr $13

handle_timer:
	sw $0, 0x72003($0)
	lw $13, counter($0)
	addi $13, $13, 1
	sw $13, counter($0)
	
	rfe
	
.bss

old_vector: .word
