	.data
 fout1:
 	.asciiz "move_1.txt" #file moves
 fout2:
 	.asciiz "move_2.txt" #file moves
 i_board_1:
  	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 i_board_2:
  	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 i_attackBoard_1:
  	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 i_attackBoard_2:
  	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 	.byte	0, 0, 0, 0, 0, 0, 0
 
 i_size:		.word 	7
 i_user_name1:	.space	52 #max length = length of character number
 i_user_name2:	.space	52 #max length = length of character number
 o_board_1:		.byte	0:650
 o_board_2:		.byte 	0:650
 o_attackBoard_1:	.byte 	0:650
 o_attackBoard_2:	.byte	0:650
 c_newline:		.asciiz "\n"
 msg_wrong_input:	.asciiz "You have entered wrong input. Please enter again!"
 msg_no_input:		.asciiz "You didn't enter input. Please enter again!"
 msg_player_1: 		.asciiz "Player 1"
 msg_player_2:		.asciiz "Player 2"
 msg_overload:		.asciiz "Your ship is being there. Please enter again!"
 msg_hit:		.asciiz "HIT!"
 msg_miss:		.asciiz "MISS!"
 msg_player1_win:	.asciiz "Winner: "
 msg_player2_win:	.asciiz "Winner: "
 msg_end:		.asciiz "Thank you for playing this game.\nHope to see you as soon as possible."
 msg_turn:		.asciiz "Turn "
 msg_win:		.asciiz " win"
 	.text
 	.globl main
 main:
 	#start
 	jal	f_home
 	jal	f_endDialog
 #helper function
 	.text
 f_home:
 		.data
 	msg_welcome:	.asciiz "Welcome to battleship game.\n 1. Start game. \n 2. Exit."

 	i_choice:	.space	8
 		.text
 	li	$v0, 51
 	la	$a0, msg_welcome
 	la	$a1, i_choice
 	syscall
 	beq	$a0, 1, f_startDialog
 	beq	$a0, 2, f_endDialog
 	beq	$a1, -1, f_wrong_input # wrong format data
 	beq	$a1, -2, f_home # cancel: exit
 	beq	$a1, -3, f_no_input # no_input
 	#begin wrong_data
 	f_wrong_input:
 		li	$v0, 55
 		la	$a0, msg_wrong_input
 		la	$a1, 0
 		syscall
 		j f_home
 	#end
 	#begin no_change
 	f_no_input:
 		li	$v0, 55
 		la	$a0, msg_no_input
 		la	$a1, 0
 		syscall
 		j f_home
 	#end
 f_startDialog:
 		.data
 	msg_hello:	.asciiz "Hello, "
 	msg_user_name:	.asciiz	"Please enter your user name"
 	msg_name1:	.asciiz "Player 1, enter your name"
 	msg_name2:	.asciiz "Player 2, enter your name"
 	msg_no_change:	.asciiz "You have entered wrong name. Please enter again!"
 	msg_exceed:	.asciiz "Your name was too long. Please enter your name with less than 52 words!"
 	msg_open_instr:	.asciiz "Instructions\n"
 	msg_instruction:.asciiz "In a classic game, each player sets up their ship on their map(a grid 7x7).\nIn each round, each player takes a turn to announce a target square in the opponent's grid which is to be shot at.\nIf all of a player's ships have been sunk, the game is over and their opponent wins."
 	msg_start:	.asciiz "Let's start. (When players play games, they can press 'Cancel' to out of game)"
 		.text
 	#set value of board = 0
 	li	$t0, 0
 	li	$t1, 0
 	li	$t2, 0
 	f_set:
 		sb	$t2, i_board_1($t1)
 		sb	$t2, i_board_2($t1)
 		sb	$t2, i_attackBoard_1($t1)
 		sb	$t2, i_attackBoard_2($t1)
 		addi	$t0, $t0, 1
 		addi	$t1, $t1, 1
 		blt	$t0, 49, f_set
 	#first create each board
 	la	$a0, o_board_1
 	la	$a1, i_board_1
 	jal	f_create_board
 	la	$a0, o_board_2
 	la	$a1, i_board_2
 	jal	f_create_board
 	la	$a0, o_attackBoard_1
 	la	$a1, i_attackBoard_1
 	jal	f_create_board
 	la	$a0, o_attackBoard_2
 	la	$a1, i_attackBoard_2
 	jal	f_create_board
 	#input user_name1
 	li	$v0, 54
 	la	$a0, msg_name1
 	la	$a1, i_user_name1
 	li	$a2, 52
 	syscall
 	beq 	$a1, -2, f_startDialog
 	beq	$a1, -3, f_no_change
 	beq	$a1, -4, f_exceed
 	#input user_name2
 	li	$v0, 54
 	la	$a0, msg_name2
 	la	$a1, i_user_name2
 	li	$a2, 52
 	syscall
 	beq 	$a1, -2, f_startDialog
 	beq	$a1, -3, f_no_change
 	beq	$a1, -4, f_exceed
 	#begin greeting
	greeting:
		li	$v0, 59
		la	$a0, msg_hello
		la	$a1, i_user_name1
		syscall
		li	$v0, 59
		la	$a0, msg_hello
		la	$a1, i_user_name2
		syscall
		li	$v0, 59
		la	$a0, msg_open_instr
		la	$a1, msg_instruction
		syscall
		li	$v0, 55
		la	$a0, msg_start
		la	$a1, 1
		syscall
 	#end greeting
	j	f_setup #temp
 	#begin no_change
 	f_no_change:
 		li	$v0, 55
 		la	$a0, msg_no_change
 		la	$a1, 0
 		syscall
 		j f_startDialog
 	#end
 	#begin exceed
 	f_exceed:
 		li	$v0, 55
 		la	$a0, msg_exceed
 		la	$a1, 0
 		syscall
 		j f_startDialog
 	#end
 f_play_again:
 		.data
 	msg_play_again:	.asciiz "Do you want to play again?"
 		.text
 	li	$v0, 50
 	la	$a0, msg_play_again
 	syscall
 	beq	$a0, 0, f_startDialog
 	beq	$a0, 1, f_endDialog
 	beq	$a0, 2, f_play_again
 f_create_board:
 		.text
 	#save index 0 1 2 3 4 5 6
 	move	$s0, $a0
 	move	$s1, $a1
 	la	$t0, ' '
 	la	$t1, '|'
 	la	$t2, '0'
 	lb	$t3, c_newline
 	
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t0, 4($s0)
 	sb	$t0, 5($s0)
 	sb	$t0, 6($s0)
 	sb	$t2, 7($s0) #store '0'
 	addi	$s0, $s0, 8
 	addi	$t2, $t2, 1 #t2 = '1'
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t2, 4($s0) #store '1'
 	addi	$s0, $s0, 5
 	addi	$t2, $t2, 1 #t2 = '2'
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t2, 4($s0) #store '2'
 	addi	$s0, $s0, 5
 	addi	$t2, $t2, 1 #t2 = '3'
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t2, 4($s0) #store '3'
 	addi	$s0, $s0, 5
 	addi	$t2, $t2, 1 #t2 = '4'
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t2, 4($s0) #store '4'
 	addi	$s0, $s0, 5
 	addi	$t2, $t2, 1 #t2 = '5'
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t2, 4($s0) #store '5'
 	addi	$s0, $s0, 5
 	addi	$t2, $t2, 1 #t2 = '6'
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t2, 4($s0) #store '6'
 	addi	$s0, $s0, 5
 	sb	$t0, 0($s0)
 	sb	$t0, 1($s0)
 	sb	$t0, 2($s0)
 	sb	$t0, 3($s0)
 	sb	$t3, 4($s0) #store '\n'
 	addi	$s0, $s0, 5
 	#store data from i_board_1
 	la	$a0, i_board_1 #store a0 = addr of i_board_1
 	lw	$a1, i_size # n = i_size = 7
 	la	$t2, '0' # assign t2 = '0'
 	li	$t4, 0 # i = 0
 	f_fori:
 		sb	$t2, 0($s0) # store '0'
 		sb	$t1, 1($s0) # store '|'
 		sb	$t0, 2($s0) # store ' '
 		sb	$t0, 3($s0) # store ' '
 		sb	$t0, 4($s0) # store ' '
 		sb	$t0, 5($s0) # store ' '
 		addi	$s0, $s0, 6
 		li	$t5, 0 # j = 0
 		f_forj:
 			lb	$t6, ($s1) # load value of input board
 			addi	$s1, $s1, 1 # next address value of input board
 			add	$t6, $t6, '0' #convert int t5 to char t5	
 			
 			sb	$t6, 0($s0) # store value
 			sb	$t0, 1($s0)
 			sb	$t0, 2($s0)
 			sb	$t0, 3($s0)
 			sb	$t0, 4($s0)
 			addi	$s0, $s0, 5
 			
 			addi	$t5, $t5, 1 #j++
 			blt	$t5, 7, f_forj #if (j < n)
 		sb	$t1, 0($s0) #store '|'
 		sb	$t3, 1($s0) #store '\n'
 		addi	$s0, $s0, 2 
 		addi	$t4, $t4, 1 #i++
 		addi	$t2, $t2, 1 #index t2 += 1
 		blt	$t4, 7, f_fori #if (i < n)
 	jr 	$ra
 f_print_board_1:
 	li	$v0, 55
 	la	$a0, o_board_1
 	la	$a1, 1
 	syscall
 	jr	$ra
 f_print_board_2:
 	li	$v0, 55
 	la	$a0, o_board_2
 	la	$a1, 1
 	syscall
 	jr	$ra
 f_print_attackBoard_1:
 	li	$v0, 55
 	la	$a0, o_attackBoard_1
 	la	$a1, 1
 	syscall
 	jr	$ra
 f_print_attackBoard_2:
 	li	$v0, 55
 	la	$a0, o_attackBoard_2
 	la	$a1, 1
 	syscall
 	jr	$ra
 f_setup:
 		.data
 	msg_intro: 	.asciiz "You will setup location of each ship.\nEach player has 3_2x1 ships, 2_3x1 ships and 1_4x1 ship.\n Each player will choose your location in a view board before setup.\nLet's start bulding your ships!"
 	msg_rBow:	.asciiz "Enter a row of bow(0-6): "
 	msg_cBow:	.asciiz "Enter a column of bow(0-6): "
 	msg_rStern:	.asciiz "Enter a row of stern(0-6): "
 	msg_cStern:	.asciiz "Enter a column of stern(0-6): "
 	msg_ship:	.asciiz "Choose your location in view board.\n                        Ship "
 	msg_2x1:	.asciiz "3 Ship size 2x1"
 	msg_3x1:	.asciiz "2 Ship size 3x1"
 	msg_4x1:	.asciiz "1 Ship size 4x1"
 		.text
 	#intro
	li	$v0, 55
	la	$a0, msg_intro
	la	$a1, 1
	syscall
	#player_1
	li	$s4, 1 #change 0 -> 1
 	f_player_1:
 		
 		li	$v0, 59
 		la	$a0, msg_turn
 		la	$a1, i_user_name1
 		syscall
 		f_block_2x1:
 			li	$v0, 55
 			la	$a0, msg_2x1
 			la	$a1, 1
 			syscall
 			li	$t8, 0 #index loop
 			li	$t9, 1 #index ship	
 			f_2x1:
 				li	$t6, 1 #enum block 2x1
 				li	$v0, 56
 				la	$a0, msg_ship
 				move	$a1, $t9
 				syscall
 				jal	f_print_board_1
 				j	f_input_1
 				f_goto_2x1_1:
 				#handle
 				f_doRow_2x1_1:
 					li	$t7, 1
 					bne	$s1, $s3, f_doCol_2x1_1
 					
 					blt	$s0, $s2, f_down_1
 					blt	$s2, $s0, f_up_1

 					j	f_wrong_setup_1 
 				f_doCol_2x1_1:
 					li	$t7, 1
 					bne	$s0, $s2, f_wrong_setup_1
 					
 					blt	$s1, $s3, f_right_1
 					blt	$s3, $s1, f_left_1

 					j	f_wrong_setup_1 
 		 f_block_3x1:
 			li	$v0, 55
 			la	$a0, msg_3x1
 			la	$a1, 1
 			syscall
 			li	$t8, 0 #index loop
 			li	$t9, 1 #index ship	
 			f_3x1:
 				li	$t6, 2 #enum block 3x1
 				li	$v0, 56
 				la	$a0, msg_ship
 				move	$a1, $t9
 				syscall
 				jal	f_print_board_1
 				j	f_input_1
 				f_goto_3x1_1:
 				#handle
 				f_doRow_3x1_1:
 					li	$t7, 2
 					bne	$s1, $s3, f_doCol_3x1_1
 					blt	$s0, $s2, f_down_1
 					blt	$s2, $s0, f_up_1
 					j	f_wrong_setup_1 
 				f_doCol_3x1_1:
 					li	$t7, 2
 					bne	$s0, $s2, f_wrong_setup_1					
 					blt	$s1, $s3, f_right_1
 					blt	$s3, $s1, f_left_1
 					j	f_wrong_setup_1 
 		
 		f_block_4x1:
 			li	$v0, 55
 			la	$a0, msg_4x1
 			la	$a1, 1
 			syscall
 			li	$t8, 0 #index loop
 			li	$t9, 1 #index ship	
 			f_4x1:
 				li	$t6, 3 #enum block 4x1
 				li	$v0, 56
 				la	$a0, msg_ship
 				move	$a1, $t9
 				syscall
 				jal	f_print_board_1
 				j	f_input_1
 				f_goto_4x1_1:
 				#handle
 				f_doRow_4x1_1:
 					li	$t7, 3
 					bne	$s1, $s3, f_doCol_4x1_1
 					blt	$s0, $s2, f_down_1
 					blt	$s2, $s0, f_up_1
 					j	f_wrong_setup_1 
 				f_doCol_4x1_1:
 					li	$t7, 3
 					bne	$s0, $s2, f_wrong_setup_1
 					blt	$s1, $s3, f_right_1
 					blt	$s3, $s1, f_left_1
 					j	f_wrong_setup_1 
 		#direction 1
 	 	f_down_1:
 			sub	$t0, $s2, $s0
 			bne	$t0, $t7, f_wrong_setup_1
 			mul	$t1, $s0, 7
 			add	$t1, $t1, $s1
 			lb	$t2, i_board_1($t1) #check overload
 			beq	$t2, 1, f_overload_setup_1
 			sb	$s4, i_board_1($t1)				
 			li	$t3, 0
 			f_for_down_1:
 				addi	$t1, $t1, 7
 				lb	$t2, i_board_1($t1)
 				beq	$t2, 1, f_overload_setup_1
 				sb	$s4, i_board_1($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_down_1	
 			beq	$t7, 1, f_complete_2x1_1
 			beq	$t7, 2, f_complete_3x1_1
 			beq	$t7, 3, f_complete_4x1_1
 		f_up_1:
 			sub	$t0, $s0, $s2
 			bne	$t0, $t7, f_wrong_setup_1
 			mul	$t1, $s2, 7
 			add	$t1, $t1, $s3
 			lb	$t2, i_board_1($t1) #check overload
 			beq	$t2, 1, f_overload_setup_1
 			sb	$s4, i_board_1($t1)
 			li	$t3, 0
 			f_for_up_1:
 				addi	$t1, $t1, 7
 				lb	$t2, i_board_1($t1)
 				beq	$t2, 1, f_overload_setup_1
 				sb	$s4, i_board_1($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_up_1
 			beq	$t7, 1, f_complete_2x1_1
 			beq	$t7, 2, f_complete_3x1_1
 			beq	$t7, 3, f_complete_4x1_1
 		f_left_1:
 			sub	$t0, $s1, $s3
 			bne	$t0, $t7, f_wrong_setup_1
 			mul	$t1, $s2, 7
 			add	$t1, $t1, $s3
 			lb	$t2, i_board_1($t1) #check overload
 			beq	$t2, 1, f_overload_setup_1
 			sb	$s4, i_board_1($t1)
 			li	$t3, 0
 			f_for_left_1:
 				addi	$t1, $t1, 1
 				lb	$t2, i_board_1($t1)
 				beq	$t2, 1, f_overload_setup_1
 				sb	$s4, i_board_1($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_left_1
 			beq	$t7, 1, f_complete_2x1_1
 			beq	$t7, 2, f_complete_3x1_1
 			beq	$t7, 3, f_complete_4x1_1
 		f_right_1:
 			sub	$t0, $s3, $s1
 			bne	$t0, $t7, f_wrong_setup_1
 			mul	$t1, $s0, 7
 			add	$t1, $t1, $s1
 			lb	$t2, i_board_1($t1) #check overloadd
 			beq	$t2, 1, f_overload_setup_1
 			sb	$s4, i_board_1($t1)
 			li	$t3, 0
 			f_for_right_1:
 				addi	$t1, $t1, 1
 				lb	$t2, i_board_1($t1)
 				beq	$t2, 1, f_overload_setup_1
 				sb	$s4, i_board_1($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_right_1
 			beq	$t7, 1, f_complete_2x1_1
 			beq	$t7, 2, f_complete_3x1_1
 			beq	$t7, 3, f_complete_4x1_1			
 	#begin f_input_1
 	f_input_1:
 			#rBow
 			li	$v0, 51
 			la	$a0, msg_rBow
 			syscall		
 			move	$s0, $a0 #s0 = rBow 	
 			beq	$a1, -1, f_wrong_setup_1
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_1
 			blt	$s0, 0, f_wrong_setup_1
 			bgt	$s0, 6, f_wrong_setup_1
 			#cBow
 			li	$v0, 51
 			la	$a0, msg_cBow
 			syscall			
 			move	$s1, $a0 #s1 = cBow 
 			beq	$a1, -1, f_wrong_setup_1
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_1
 			blt	$s1, 0, f_wrong_setup_1
 			bgt	$s1, 6, f_wrong_setup_1
 			#rStern
 			li	$v0, 51
 			la	$a0, msg_rStern
 			syscall			
 			move	$s2, $a0 #s2 = rStern 
 			beq	$a1, -1, f_wrong_setup_1
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_1
 			blt	$s2, 0, f_wrong_setup_1
 			bgt	$s2, 6, f_wrong_setup_1
 			#cStern
 			li	$v0, 51
 			la	$a0, msg_cStern
 			syscall			
 			move	$s3, $a0 #s3 = cStern
 			beq	$a1, -1, f_wrong_setup_1
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_1
 			blt	$s3, 0, f_wrong_setup_1
 			bgt	$s3, 6, f_wrong_setup_1
 			#check condition and jump
 			beq	$t6, 1, f_goto_2x1_1
 			beq	$t6, 2, f_goto_3x1_1
 			beq	$t6, 3, f_goto_4x1_1
 	#end
 	f_complete_2x1_1:
 		la	$a0, o_board_1
 		la	$a1, i_board_1
 		jal	f_create_board
 		jal	f_print_board_1
 		addi	$t8, $t8, 1
 		addi	$t9, $t9, 1 
 		blt	$t8, 3, f_2x1
 		j	f_block_3x1
 	f_complete_3x1_1:
 		la	$a0, o_board_1
 		la	$a1, i_board_1
 		jal	f_create_board
 		jal	f_print_board_1
 		addi	$t8, $t8, 1
 		addi	$t9, $t9, 1 
 		blt	$t8, 2, f_3x1
 		j	f_block_4x1
 	f_complete_4x1_1:
 		la	$a0, o_board_1
 		la	$a1, i_board_1
 		jal	f_create_board
 		jal	f_print_board_1
 		addi	$t8, $t8, 1
 		addi	$t9, $t9, 1 
 		blt	$t8, 1, f_4x1
 		j 	f_player_2 #temp
 	#f_exit_setup_1:
 		#jr	$ra
 	f_nodata_setup_1:
 		li	$v0, 55
 		la	$a0, msg_no_input
 		la	$a1, 0
 		syscall
 		beq	$t6, 1, f_2x1
 		beq	$t6, 2, f_3x1
 		beq	$t6, 3, f_4x1
 	f_wrong_setup_1:
 		li	$v0, 55
 		la	$a0, msg_wrong_input
 		la	$a1, 0
 		syscall
 		beq	$t6, 1, f_2x1
 		beq	$t6, 2, f_3x1
 		beq	$t6, 3, f_4x1
 	f_overload_setup_1:
 		li	$v0, 55
 		la	$a0, msg_overload
 		la	$a1, 0
 		syscall
 		beq	$t6, 1, f_2x1
 		beq	$t6, 2, f_3x1
 		beq	$t6, 3, f_4x1
 	#f_player_2
 	 f_player_2:
 	 	li	$v0, 59
 		la	$a0, msg_turn
 		la	$a1, i_user_name2
 		syscall
 		f_block_2x1_2:
 			li	$v0, 55
 			la	$a0, msg_2x1
 			la	$a1, 1
 			syscall
 			li	$t8, 0 #index loop
 			li	$t9, 1 #index ship	
 			f_2x1_2:
 				li	$t6, 1 #enum block 2x1
 				li	$v0, 56
 				la	$a0, msg_ship
 				move	$a1, $t9
 				syscall
 				jal	f_print_board_2
 				j	f_input_2
 				f_goto_2x1_2:
 				#handle
 				f_doRow_2x1_2:
 					li	$t7, 1
 					bne	$s1, $s3, f_doCol_2x1_2
 					blt	$s0, $s2, f_down_2
 					blt	$s2, $s0, f_up_2
 					j	f_wrong_setup_2 
 				f_doCol_2x1_2:
 					li	$t7, 1
 					bne	$s0, $s2, f_wrong_setup_2
 					blt	$s1, $s3, f_right_2
 					blt	$s3, $s1, f_left_2
 					j	f_wrong_setup_2
 		 f_block_3x1_2:
 			li	$v0, 55
 			la	$a0, msg_3x1
 			la	$a1, 1
 			syscall
 			li	$t8, 0 #index loop
 			li	$t9, 1 #index ship	
 			f_3x1_2:
 				li	$t6, 2 #enum block 3x1
 				li	$v0, 56
 				la	$a0, msg_ship
 				move	$a1, $t9
 				syscall
 				jal	f_print_board_2
 				j	f_input_2
 				f_goto_3x1_2:
 				#handle
 				f_doRow_3x1_2:
 					li	$t7, 2
 					bne	$s1, $s3, f_doCol_3x1_2
 					blt	$s0, $s2, f_down_2
 					blt	$s2, $s0, f_up_2
 					j	f_wrong_setup_2
 				f_doCol_3x1_2:
 					li	$t7, 2
 					bne	$s0, $s2, f_wrong_setup_2
 					blt	$s1, $s3, f_right_2
 					blt	$s3, $s1, f_left_2
 					j	f_wrong_setup_2
 		f_block_4x1_2:
 			li	$v0, 55
 			la	$a0, msg_4x1
 			la	$a1, 1
 			syscall
 			li	$t8, 0 #index loop
 			li	$t9, 1 #index ship	
 			f_4x1_2:
 				li	$t6, 3 #enum block 4x1
 				li	$v0, 56
 				la	$a0, msg_ship
 				move	$a1, $t9
 				syscall
 				jal	f_print_board_2
 				j	f_input_2
 				f_goto_4x1_2:
 				#handle
 				f_doRow_4x1_2:
 					li	$t7, 3
 					bne	$s1, $s3, f_doCol_4x1_2
 					blt	$s0, $s2, f_down_2
 					blt	$s2, $s0, f_up_2
 					j	f_wrong_setup_2
 				f_doCol_4x1_2:
 					li	$t7, 3
 					bne	$s0, $s2, f_wrong_setup_2
 					blt	$s1, $s3, f_right_2
 					blt	$s3, $s1, f_left_2
 					j	f_wrong_setup_2
 		#direction ship of player 2
 	 	f_down_2:
 			sub	$t0, $s2, $s0
 			bne	$t0, $t7, f_wrong_setup_2
 			mul	$t1, $s0, 7
 			add	$t1, $t1, $s1
 			lb	$t2, i_board_2($t1) #check overloadd
 			beq	$t2, 1, f_overload_setup_2
 			sb	$s4, i_board_2($t1)				
 			li	$t3, 0
 			f_for_down_2:
 				addi	$t1, $t1, 7
 				lb	$t2, i_board_2($t1)
 				beq	$t2, 1, f_overload_setup_2
 				sb	$s4, i_board_2($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_down_2
 			beq	$t7, 1, f_complete_2x1_2
 			beq	$t7, 2, f_complete_3x1_2
 			beq	$t7, 3, f_complete_4x1_2
 		f_up_2:
 			sub	$t0, $s0, $s2
 			bne	$t0, $t7, f_wrong_setup_2
 			mul	$t1, $s2, 7
 			add	$t1, $t1, $s3
 			lb	$t2, i_board_2($t1) #check overloadd
 			beq	$t2, 1, f_overload_setup_2
 			sb	$s4, i_board_2($t1)
 			li	$t3, 0
 			f_for_up_2:
 				addi	$t1, $t1, 7
 				lb	$t2, i_board_2($t1)
 				beq	$t2, 1, f_overload_setup_2
 				sb	$s4, i_board_2($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_up_2 
 			beq	$t7, 1, f_complete_2x1_2
 			beq	$t7, 2, f_complete_3x1_2
 			beq	$t7, 3, f_complete_4x1_2
 		f_left_2:
 			sub	$t0, $s1, $s3
 			bne	$t0, $t7, f_wrong_setup_2
 			mul	$t1, $s2, 7
 			add	$t1, $t1, $s3
 			lb	$t2, i_board_2($t1) #check overloadd
 			beq	$t2, 1, f_overload_setup_2
 			sb	$s4, i_board_2($t1)
 			li	$t3, 0
 			f_for_left_2:
 				addi	$t1, $t1, 1
 				lb	$t2, i_board_2($t1)
 				beq	$t2, 1, f_overload_setup_2
 				sb	$s4, i_board_2($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_left_2
 			beq	$t7, 1, f_complete_2x1_2
 			beq	$t7, 2, f_complete_3x1_2
 			beq	$t7, 3, f_complete_4x1_2
 		f_right_2:
 			sub	$t0, $s3, $s1
 			bne	$t0, $t7, f_wrong_setup_2
 			mul	$t1, $s0, 7
 			add	$t1, $t1, $s1
 			lb	$t2, i_board_2($t1) #check overloadd
 			beq	$t2, 1, f_overload_setup_2
 			sb	$s4, i_board_2($t1)
 			li	$t3, 0
 			f_for_right_2:
 				addi	$t1, $t1, 1
 				lb	$t2, i_board_2($t1)
 				beq	$t2, 1, f_overload_setup_2
 				sb	$s4, i_board_2($t1)  
 				addi	$t3, $t3, 1
 				blt	$t3, $t7, f_for_right_2
 			beq	$t7, 1, f_complete_2x1_2
 			beq	$t7, 2, f_complete_3x1_2
 			beq	$t7, 3, f_complete_4x1_2			
 	#begin f_input_2
 	f_input_2:
 			#rBow
 			li	$v0, 51
 			la	$a0, msg_rBow
 			syscall			
 			beq	$a1, -1, f_wrong_setup_2
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_2
 			blt	$a0, 0, f_wrong_setup_2
 			bgt	$a0, 6, f_wrong_setup_2 
 			move	$s0, $a0 #s0 = rBow 
 			#cBow
 			li	$v0, 51
 			la	$a0, msg_cBow
 			syscall			
 			beq	$a1, -1, f_wrong_setup_2
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_2
 			blt	$a0, 0, f_wrong_setup_2
 			bgt	$a0, 6, f_wrong_setup_2
 			move	$s1, $a0 #s1 = cBow 
 			#rStern
 			li	$v0, 51
 			la	$a0, msg_rStern
 			syscall			
 			beq	$a1, -1, f_wrong_setup_2
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_2
 			blt	$a0, 0, f_wrong_setup_2 
 			bgt	$a0, 6, f_wrong_setup_2
 			move	$s2, $a0 #s2 = rStern 
 			#cStern
 			li	$v0, 51
 			la	$a0, msg_cStern
 			syscall			
 			beq	$a1, -1, f_wrong_setup_2
 			beq	$a1, -2, f_cancel
 			beq	$a1, -3, f_nodata_setup_2
 			blt	$a0, 0, f_wrong_setup_2
 			bgt	$a0, 6, f_wrong_setup_2
 			move	$s3, $a0 #s3 = cStern
 			beq	$t6, 1, f_goto_2x1_2
 			beq	$t6, 2, f_goto_3x1_2
 			beq	$t6, 3, f_goto_4x1_2
 	#end
 	f_complete_2x1_2:
 		la	$a0, o_board_2
 		la	$a1, i_board_2
 		jal	f_create_board
 		jal	f_print_board_2
 		addi	$t8, $t8, 1
 		addi	$t9, $t9, 1 
 		blt	$t8, 3, f_2x1_2
 		j	f_block_3x1_2
 	f_complete_3x1_2:
 		la	$a0, o_board_2
 		la	$a1, i_board_2
 		jal	f_create_board
 		jal	f_print_board_2
 		addi	$t8, $t8, 1
 		addi	$t9, $t9, 1 
 		blt	$t8, 2, f_3x1_2
 		j	f_block_4x1_2
 	f_complete_4x1_2:
 		la	$a0, o_board_2
 		la	$a1, i_board_2
 		jal	f_create_board
 		jal	f_print_board_2
 		addi	$t8, $t8, 1
 		addi	$t9, $t9, 1 
 		blt	$t8, 1, f_4x1_2
 		j 	f_play 
 	#f_exit_setup_2:
 		#jr	$ra
 	f_nodata_setup_2:
 		li	$v0, 55
 		la	$a0, msg_no_input
 		la	$a1, 0
 		syscall
 		beq	$t6, 1, f_2x1_2
 		beq	$t6, 2, f_3x1_2
 		beq	$t6, 3, f_4x1_2
 	f_wrong_setup_2:
 		li	$v0, 55
 		la	$a0, msg_wrong_input
 		la	$a1, 0
 		syscall
 		beq	$t6, 1, f_2x1_2
 		beq	$t6, 2, f_3x1_2
 		beq	$t6, 3, f_4x1_2
 	f_overload_setup_2:
 		li	$v0, 55
 		la	$a0, msg_overload
 		la	$a1, 0
 		syscall
 		beq	$t6, 1, f_2x1_2
 		beq	$t6, 2, f_3x1_2
 		beq	$t6, 3, f_4x1_2
 f_play:
 		.data
 	msg_play:		.asciiz "Let's play!"
 	msg_round:		.asciiz	"Round "
 	msg_position_attack:	.asciiz "Enter position that you want to attack #'row'_'col'#(E.g 0 2): "
 	msg_alreadyHit:		.asciiz "You've already hit there!"
 	i_player1_attack:	.space	52
 	i_player2_attack:	.space	52
 	i_position:		.byte	0:4
 		.text	
 	li	$v0, 55
 	la	$a0, msg_play
 	la	$a1, 1
 	syscall
 	#create attack board of player1
 	la	$a0, o_attackBoard_1
 	la	$a1, i_attackBoard_1
 	jal	f_create_board
 	#create attack board of player 2
 	la	$a0, o_attackBoard_2
 	la	$a1, i_attackBoard_2
 	jal	f_create_board	
 	#open player1's file
	li	$v0, 13
	la	$a0, fout1
	li	$a1, 1
	li	$a2, 0
	syscall
	move	$s6, $v0 # $s0 = player1 motivation
	#open player2's file
	li	$v0, 13
	la	$a0, fout2
	li	$a1, 1
	li	$a2, 0
	syscall
	move	$s7, $v0 # $s1 = player2 motivation
	li	$s5, 1 #round index
	li	$t8, 0 #n_times was attacked of player1
 	li	$t9, 0 #n_times was attacked of player1
 	f_block_turn:
		#round...
		li	$v0, 56
		la	$a0, msg_round
		move	$a1, $s5
		syscall

 		f_block_player1:
 			li	$v0, 59
 			la	$a0, msg_turn
 			la	$a1, i_user_name1
 			syscall
 			f_player1_turn:
 				jal	f_print_attackBoard_1
 				li	$v0, 54
 				la	$a0, msg_position_attack
 				la	$a1, i_position
 				la	$a2, 4 #row + ' ' + col
 				syscall
 				la	$s2, i_position
 				beq	$a1, -2, f_cancel
 				beq	$a1, -3, f_noinput_1
 				beq	$a1, -4, f_overlength_1
 				lb	$t3, 0($s2) #t3 = row
 				lb	$t4, 1($s2) #t4 = ' '
 				lb	$t5, 2($s2) #t5 = col
 				bne	$t4, ' ', f_overlength_1
 				blt	$t3, '0', f_overlength_1
 				bgt	$t3, '6', f_overlength_1
 				blt	$t5, '0', f_overlength_1
 				bgt	$t5, '6', f_overlength_1
 				li	$s3, 1 #ticking hit's position
 				li	$s4, 2 #ticking miss's position
 				#handle
 				subi	$t3, $t3, '0'
 				subi	$t5, $t5, '0'
 				mul	$t1, $t3, 7
 				add	$t1, $t1, $t5 #address of position
 				lb	$t2, i_board_2($t1)
 				#alreadyhit -> enter again
 				lb	$t6, i_attackBoard_1($t1)
 				beq	$t6, 1, f_alreadyHit_1
 				beq	$t6, 2, f_alreadyHit_1
 				j	f_write_position_1
 				f_goto_1:
 				beq	$t2, 0, f_miss_1 #miss -> player2 turn
 				beq	$t2, 1, f_hit_1
 		f_block_player2:
 			li	$v0, 59
 			la	$a0, msg_turn
 			la	$a1, i_user_name2
 			syscall
 			f_player2_turn:
 				jal	f_print_attackBoard_2
 				li	$v0, 54
 				la	$a0, msg_position_attack
 				la	$a1, i_position
 				la	$a2, 4 #row + ' ' + col
 				syscall
 				la	$s2, i_position
 				beq	$a1, -2, f_cancel
 				beq	$a1, -3, f_noinput_2
 				beq	$a1, -4, f_overlength_2
 				lb	$t3, 0($s2) #t3 = row
 				lb	$t4, 1($s2) #t4 = ' '
 				lb	$t5, 2($s2) #t5 = col
 				li	$s3, 1 #ticking hit's position
 				li	$s4, 2 #ticking miss's position
 				bne	$t4, ' ', f_overlength_2
 				blt	$t3, '0', f_overlength_2
 				bgt	$t3, '6', f_overlength_2
 				blt	$t5, '0', f_overlength_2
 				bgt	$t5, '6', f_overlength_2
 				#handle
 				subi	$t3, $t3, '0'
 				subi	$t5, $t5, '0'
 				mul	$t1, $t3, 7
 				add	$t1, $t1, $t5 #address of position
 				lb	$t2, i_board_1($t1)
 				j	f_write_position_2
 				lb	$t6, i_attackBoard_2($t1)
 				beq	$t6, 1, f_alreadyHit_2
 				beq	$t6, 2, f_alreadyHit_2
 				f_goto_2:
 				beq	$t2, 0, f_miss_2 #miss -> player2 turn
 				beq	$t2, 1, f_hit_2
 		f_miss_1:
 			sb	$s4, i_attackBoard_1($t1)
 			li	$v0, 55
 			la	$a0, msg_miss
 			la	$a1, 1
 			syscall
 			#update_board_1
 			la	$a0, o_board_2
 			la	$a1, i_board_2
 			jal	f_create_board
 			la	$a0, o_attackBoard_1
 			la	$a1, i_attackBoard_1
 			jal	f_create_board
 			jal	f_print_attackBoard_1
 			j	f_block_player2
 		f_hit_1:
 			sb	$s3, i_attackBoard_1($t1)
 			li	$v0, 55
 			la	$a0, msg_hit
 			la	$a1, 1
 			syscall			
 			addi	$t8, $t8, 1
 			#update_board_1
 			la	$a0, o_board_2
 			la	$a1, i_board_2
 			jal	f_create_board
 			la	$a0, o_attackBoard_1
 			la	$a1, i_attackBoard_1
 			jal	f_create_board
 			jal	f_print_attackBoard_1
 			
 			beq	$t8, 16, f_close_file #player1 win
 			j	f_block_player2
 		f_alreadyHit_1:
 			li	$v0, 55
 			la	$a0, msg_alreadyHit
 			la	$a1, 1
 			syscall
 			j	f_player1_turn		
 		f_noinput_1:
 			li	$v0, 55
 			la	$a0, msg_no_input
 			la	$a1, 0
 			syscall 
 			j	f_player1_turn
 		f_overlength_1: 			
 			li	$v0, 55
 			la	$a0, msg_wrong_input
 			la	$a1, 0
 			syscall
 			j	f_player1_turn
 		f_write_position_1:
 			#write position of player 1
 			li	$v0, 15
 			move	$a0, $s6
 			la	$a1, i_position
 			syscall
 			li	$v0, 15
 			move	$a0, $s6
 			la	$a1, c_newline
 			la	$a2, 1
			syscall
			j	f_goto_1
 		f_miss_2:
 			sb	$s4, i_attackBoard_2($t1)
 			li	$v0, 55
 			la	$a0, msg_miss
 			la	$a1, 1
 			syscall
 			#update_board_2
 			la	$a0, o_board_1
 			la	$a1, i_board_1
 			jal	f_create_board
 			la	$a0, o_attackBoard_2
 			la	$a1, i_attackBoard_2
 			jal	f_create_board
 			jal	f_print_attackBoard_2
 			j	f_condition_2
 		f_hit_2:
 			sb	$s3, i_attackBoard_2($t1)
 			li	$v0, 55
 			la	$a0, msg_hit
 			la	$a1, 1
 			syscall
 			addi	$t9, $t9, 1
 			#update_board_2
 			la	$a0, o_board_1
 			la	$a1, i_board_1
 			jal	f_create_board
 			la	$a0, o_attackBoard_2
 			la	$a1, i_attackBoard_2
 			jal	f_create_board
 			jal	f_print_attackBoard_2
 			j	f_condition_2
 		f_alreadyHit_2:
 			li	$v0, 55
 			la	$a0, msg_alreadyHit
 			la	$a1, 1
 			syscall
 			j	f_player2_turn
 		f_condition_2:
 			beq	$t9, 16, f_close_file #player2 win
 			addi	$s5, $s5, 1
 			j	f_block_turn	 
 		f_noinput_2:
 			li	$v0, 55
 			la	$a0, msg_no_input
 			la	$a1, 0
 			syscall 
 			j	f_player2_turn
 		f_overlength_2: 			
 			li	$v0, 55
 			la	$a0, msg_wrong_input
 			la	$a1, 0
 			syscall
 			j	f_player2_turn
 		f_write_position_2:
 			#write position of player2
 			li	$v0, 15
 			move	$a0, $s7
 			la	$a1, i_position
 			syscall
 			li	$v0, 15
 			move	$a0, $s7
 			la	$a1, c_newline
 			la	$a2, 1
			syscall
			j 	f_goto_2
 	f_close_file:
 		#close player1's file
		li	$v0, 16
		move	$a0, $s6
		syscall
		#close player2's file
		li	$v0, 16
		move	$a0, $s7
		syscall	
		beq	$t8, 16, f_player1_win
		beq	$t9, 16, f_player2_win		
 f_cancel:
 	j	f_endDialog
 f_player1_win:
 	li	$v0, 59
 	la	$a0, msg_player1_win
 	la	$a1, i_user_name1
 	syscall
 	j 	f_play_again
 f_player2_win:
 	li	$v0, 59
 	la	$a0, msg_player2_win
 	la	$a1, i_user_name2
 	syscall
 	j 	f_play_again
 f_endDialog:
 	li	$v0, 55
 	la	$a0, msg_end
 	la	$a1, 1
 	syscall
 	li	$v0, 10
 	syscall
 
 	
 

	
	
	
	
	
	
