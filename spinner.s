

	.equ JP1, 0xFF200060
	.equ TIMER2, 0xFF202020 #the big timer for the whole game
	.equ off, 0xFFFFFFFF
	.equ FULLOFF, 0XFFF5555
	.equ onR, 0xFFFFFFFC #FORAWRD, ON

	.equ Timer1, 0xFF202000 
	
.equ INIT_STATE, 0xACE10000 #inital num to generate random number
.equ MIN_TIME, 1000000000
.equ MAX_TIME, 32766 
.equ WHOLE_SECONDS, 20

#.equ GAME_TURNS, 5
#moderate speed
.equ MOD_REV_TIME,4500000 #300000000 #400000000 #4000000000 #try one extra 0, 2000
.equ MOD_STOP_TIME, 20000000 #179000000 #1790000000#160000000 #600

# SLOW
.equ SLOW_REV_TIME, 4300000 #300000000 #400000000 #4000000000 #1000
.equ SLOW_STOP_TIME, 20000000 #250000000 #2500000000 #160000000 #600

#VERY SLOW
.equ VERY_SLOW_REV_TIME,4050000 #400000000 #4000000000 #1000
.equ VERY_SLOW_STOP_TIME,20000000 #350000000  #3000000000 #6000
	
#almost stop
.equ ALMOST_STOP_REV_TIME,4000000 #400000000 #4000000000 #20
.equ ALMOST_STOP_STOP_TIME,20000000 #450000000 #3500000000 #need to call delay_time 9 times!

#phase 400000000
.equ PHASE4_SPIN_TIME, 2000000
.equ PHASE4_STOP_TIME, 20000000



.section .text
.global	spinner
spinner:

subi sp, sp, 4
stw ra, 0(sp)

# stw r2, 4(sp)
# stw r4, 8(sp)
# stw r5, 12(sp)
# #stw r6, 20(sp)
# stw r7, 16(sp)
# stw r8, 20(sp)
# stw r9, 24(sp)
# stw r10, 28(sp)
# stw r11, 32(sp)
# stw r12, 36(sp)
# #stw r14, 52(sp)
# #stw r15, 56(sp)
# stw r16, 40(sp)
# stw r17, 44(sp)
# stw r18, 48(sp)

mov r4, r0
mov r2, r0
mov r5, r0
mov r7, r0
mov r8, r0
mov r9, r0
mov r10, r0
mov r11, r0
mov r12, r0
mov r16, r0
mov r17, r0
mov r18, r0


movia r4, INIT_STATE #very first num, set
#movia r12, 10000
#movi r13, 1000 #slow down speed factor              ########motor has a buzz, prob need to adjust the stop time



INIT:
movia r4, INIT_STATE #very first num, set

		movia r8, JP1
		movia r9, 0x07F557FF #initialize directions
		stwio r9, 4(r8)
		
		
		movia r9, off
		stwio r9, 0(r8)
		

		
		
		
		




DECIDE:

  beq r7, r0, PHASE0
  movi r8, 1
  beq r7, r8, PHASE1
  movi r8, 2
  beq r7, r8, PHASE2
  movi r8, 3
  beq r7, r8, PHASE3
  movi r8, 4
 beq r7, r8, PHASE4
 movi r8, 5
 beq r7, r8, DONE


	
	
	  PHASE0:
	movia r11, MOD_REV_TIME
    movia r10, MOD_STOP_TIME
	
	 movia r4, INIT_STATE #GIVES inital value to generate rand
		#addi sp, sp, -4
		# stw ra, 0(sp)	
		  call lsfr	
		# ldw ra, 0(sp)	
		# addi sp, sp, 4
		


		  mov r5, r2 #stroe the rand in
		 mov r12, r2 #also in r12
		 #addi r7, r7, 1
		

		 # START THE BIG TIMER		
		 movia r16, TIMER2
		  mov r12, r5
		  #slli r5, r5, 16	
		
  mov r17, r5 #TIME_CNT 4,200,000,000 
  stwio r17, 8(r16) #lower bit

	srli r12, r12, 16
 mov r17, r12
 stwio r17, 12(r16) #upper bit
 stwio r0, 0(r16)
 movi r18, 0b0100 
  stwio r18, 4(r16)

		
   br SPIN

    PHASE1:
 movia r11, SLOW_REV_TIME
   movia r10, SLOW_STOP_TIME
		
		 mov r4, r2 #continue using the result as an argument
  		# addi sp, sp, -4
		# stw ra, 0(sp)	
		  call lsfr	
		# ldw ra, 0(sp)	
		
		# addi sp, sp, 4
		

		  mov r5, r2 #stroe the rand in r4
		  mov r12, r2 #also in r4
  		 addi r7, r7, 1
		
		

		 # # #START THE BIG TIMER		
		  movia r16, TIMER2
		# # #hard code test movia r5, 1000000000
		 mov r12, r5
		  slli r5, r5, 16	
		
  mov r17, r5 #TIME_CNT 4,200,000,000 
 stwio r17, 8(r16) #lower bit

  srli r12, r12, 16
  mov r17, r12
  stwio r17, 12(r16) #upper bit
  stwio r0, 0(r16)
  movi r18, 0b0100 
 stwio r18, 4(r16)


   br SPIN


    PHASE2:
 movia r11, VERY_SLOW_REV_TIME
 movia r10, VERY_SLOW_STOP_TIME

		 mov r4, r2
		
		# # #addi sp, sp, -4
		# # #stw ra, 0(sp)	
		  call lsfr	
		# # #ldw ra, 0(sp)	
		# # #addi sp, sp, 4
		

		  mov r5, r2 #stroe the rand in r4
		  mov r12, r2 #also in r4
		  addi r7, r7, 1

		 # # # #START THE BIG TIMER		
		movia r16, TIMER2
		# # #movia r5, 1000000000
		
		  mov r12, r5
		 # slli r5, r5, 16	
		
  mov r17, r5 #TIME_CNT 4,200,000,000 
  stwio r17, 8(r16) #lower bit

  srli r12, r12, 16
  mov r17, r12
 stwio r17, 12(r16) #upper bit
 stwio r0, 0(r16)
  movi r18, 0b0100 
stwio r18, 4(r16)

  br SPIN
	
	
 PHASE3:
  movia r11, ALMOST_STOP_REV_TIME
  movia r10, ALMOST_STOP_STOP_TIME
		 mov r4, r2
		# # #addi sp, sp, -4
		# # #stw ra, 0(sp)	
		 call lsfr	
	# #ldw ra, 0(sp)	
		# #addi sp, sp, 4
		
		 mov r5, r2 #stroe the rand in r4
		 mov r12, r2 #also in r4
		  addi r7, r7, 1

		 # # # #START THE BIG TIMER		
		movia r16, TIMER2
		# # #hard ocde movia r5, 1000000000
		 mov r12, r5
		 slli r5, r5, 16	
		
  mov r17, r5 #TIME_CNT 4,200,000,000 
  stwio r17, 8(r16) #lower bit

  srli r12, r12, 16
  mov r17, r12
  stwio r17, 12(r16) #upper bit
  stwio r0, 0(r16)
  movi r18, 0b0100 
  stwio r18, 4(r16)


 br SPIN

PHASE4:
movia r11, PHASE4_SPIN_TIME
movia r10, PHASE4_STOP_TIME

		movia r4, INIT_STATE #mov r4, r2
		#addi sp, sp, -4
		#stw ra, 0(sp)	
		call lsfr	
		#ldw ra, 0(sp)	
		#addi sp, sp, 4
#if commented, ret from big timer goes here		
		mov r5, r2 #stroe the rand in r4
		mov r12, r2 #also in r4
		addi r7, r7, 1

		 # #START THE BIG TIMER		
		movia r16, TIMER2
		#hard ocde movia r5, 1000000000
		mov r12, r5
		slli r5, r5, 16	
		
mov r17, r5 #TIME_CNT 4,200,000,000 
stwio r17, 8(r16) #lower bit

srli r12, r12, 16
mov r17, r12
stwio r17, 12(r16) #upper bit
stwio r0, 0(r16)
movi r18, 0b0100 
stwio r18, 4(r16)


br SPIN
	
	
		
SPIN: 

#subi r6, r6, 1
		movia r8, JP1
		movia r9, onR
		stwio r9, 0(r8)
		
		#movi r10, 1800
		SPIN_MULTI:
mov r4, r11
		#movia  r4,PHASE4_SPIN_TIME # #220000000 # 	 #try spin for 2 #3500
		# movi r10, 20 #couter
		subi  sp, sp, 4
		stw   ra, 0(sp)				
		
		#r5 should be random now
		call  delay_time
		
	    ldw   ra, 0(sp)
		addi  sp, sp, 4

	
SLOW_DOWN:


		 movia r8, JP1
		 movia r9, off
		stwio r9, 0(r8) 
		mov r4, r10
		# #movia r4, PHASE4_STOP_TIME#mov r4, r10 #120000000 #r10 #has pre ef const according to phase
		
	
		
SLOW_CYCLE:


		 subi  sp, sp, 4
		 stw   ra, 0(sp)
		call  delay_time
	
		
		ldw   ra, 0(sp)
		addi  sp, sp, 4	
		
#bug report:
#hits the delay cylcye, timer interrupted. always, no spin again	


		
		TIMER2_OUT:
 movia r16, TIMER2
 ldwio r18, 0(r16)
andi r18,r18,0x1 #timed out
beq r18,r0,SPIN

br DONE
#br DECIDE
		
	
DONE:

		movia r8, JP1
		movia r9, off
		stwio r9, 0(r8)
		#lol
		#addi ra, ra, 320
		ldw ra, 0(sp)
		addi sp, sp, 4
		ret


delay_time: #take different inputs from r4, longer for spin, shorter for off
#r17 is time counter , r16 is timer address
movia r16, Timer1
		
mov r17, r4 #TIME_CNT 4,200,000,000 
#srli r17, r17, 16	#slli
stwio r17, 8(r16) #lower bit

mov r17, r4
srli r17, r17, 16 	#srli
stwio r17, 12(r16) #upper bit
stwio r0, 0(r16) #clear bit

movi r18, 0b0100 #110 #to start the timer
stwio r18, 4(r16)

	
poll: 
ldwio r18, 0(r16)
andi r18,r18,0b1 #timed out
beq r18,r0,poll
ret


