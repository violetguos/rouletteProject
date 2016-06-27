.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000
.equ ADDR_PSTWO, 0xFF200100
.equ Timer,0xFF202000
.equ Audio,0xFF203040



#make code  look up table 
.equ zero, 0x45
.equ one, 0x16
.equ two, 0x1E
.equ three,0x26
.equ four,0x25
.equ five,0x2E
.equ six,0x36
.equ seven,0x3D
.equ eight,0x3E
.equ nine,0x46
.equ enter,0x5A
.equ brk, 0xF0
.equ RKey, 0x2D
.equ BKey, 0x32
.equ YKey,  0x35
.equ NKey, 0x31

/*ascii code */
.equ Azero, 0x30
.equ Aone, 0x31
.equ Atwo,0x32
.equ Athree,0x33
.equ Afour,0x34
.equ Afive,0x35
.equ Asix,0x36
.equ Aseven,0x37
.equ Aeight,0x38
.equ Anine,0x39
.equ ARKey,0x52
.equ ABKey,0x42
.equ AYKey,0x59
.equ ANKey,0x4E

#offset of box
.equ offSetOne,0x1813a
.equ offSetTwo,0xf53a
.equ offSetThree,0x693a
.equ offSetFour,0x18172
.equ offSetFive,0xf572
.equ offSetSix,0x6972
.equ offSetSeven,0x181aa
.equ offSetEight,0xf5aa
.equ offSetNine,0x69aa
.equ offSetA,0x181e2
.equ offSetB,0xf5e2
.equ offSetC,0x69e2
.equ offSetD,0x1821e
.equ offSetE,0xf61e
.equ offSetF,0x6a1c




.global main


.data
.align 4
myAudio: 
.incbin "audio2.wav" #need a 44khz wav audio watch out for alignment problem
endAudio:
#.align 4
#loseAudio: 
#.incbin "lose.wav"
#loseEnd:

.align 2
StartPicture: .incbin "latest.bin" 
SecondPicture: .incbin "newback.bin"   #need to add the picture 

firstString: .asciz "Welcome to the Roulette game!"
secondString: .asciz "Press Enter to Play!" 
thirdString: .asciz "Enter your lucky number(Press Enter to end):"
forthString: .asciz "Enter the result(Press enter to end):"
fifthString: .asciz "You win!"
sixthString: .asciz "You lose"




.text
main:

mov r21,r0   # r21 reserved for checking if Enter get pressed\

mov r17,r0   # first input stored in decimal 
mov r18,r0   # second input store in decimal 
mov r19,r0	 # indicate the number sequence, 0 is first , 1 is second  after load the value, r19 store the result of user's input
 

	/*string intialize*/
  movia r3, ADDR_CHAR
  movia r4,firstString
  addi r3, r3,23
  
	/*picutre initialize*/
    movia r8, StartPicture
	movi r6, 320
	movi r7, 240
	movia r5, ADDR_VGA
	movi r9, 0
	movi r10, 0
pictureY:
	beq r9,r6,YInc
	beq r10,r7,stringOne
	ldh r12,0(r8) #io
	sth r12,0(r5)
	addi r8,r8,2
	addi r9,r9,1
	addi r5,r5,2
	br pictureY

YInc:
		movi r11,384
		add r5,r5,r11
		addi r10,r10,1
		movi r9 ,0
		br pictureY
	
stringOne:
	ldbio r15,0(r4)
	beq r15,r0,stringTwoIni
	stbio r15,0(r3)
	addi r4,r4,1
	addi r3,r3,1
	
	br stringOne
	
stringTwoIni:

addi r3,r3,103
movia r4,secondString


stringTwo:
	ldbio r15,0(r4)
	beq r15,r0,keyIni
	stbio r15,0(r3)
	addi r4,r4,1
	addi r3,r3,1
br stringTwo



   
keyIni:

movia r3,ADDR_CHAR


#r21 check if enter
mov r21,r0
#r22 check if previous is break sequence 0xF0
mov r22,r0

/*addi r15,r15,13308*/

KeyboardIni:
movia r12,ADDR_PSTWO
movi r13,0b1
stwio r13,4(r12)   #enable device interrupt
movi r13, 0b10000000
wrctl ctl3,r13      #enable ienable
movi r13,0b1
wrctl ctl0,r13    #PIE enable
  


 waitEnter:
 beq r21,r0,waitEnter
 
#enter detected, second picture initialize
	mov r21,r0 #reset enter to 0
    movia r8, SecondPicture
	movi r6, 320
	movi r7, 240
	movia r5, ADDR_VGA
	movi r9, 0
	movi r10, 0


secondPictureY:
	beq r9,r6,secondYInc
	beq r10,r7,stringThreeIni
	
	mov r15,r0
	sth r15,0(r5) #io

	ldh r15,0(r8)
	sth r15,0(r5)
	addi r8,r8,2
	addi r9,r9,1
	addi r5,r5,2
	br secondPictureY
	
secondYInc:
		movi r11,384
		add r5,r5,r11
		addi r10,r10,1
		movi r9 ,0
		br secondPictureY

stringThreeIni:
movia r3, ADDR_CHAR
movia r4, thirdString
addi r3,r3,6805

stringThree:
	ldbio r15,0(r4)
	beq r15,r0,NumberEnter
	stbio r15,0(r3)
	addi r4,r4,1
	addi r3,r3,1
	
	br stringThree
 
NumberEnter:

beq r21,r0,NumberEnter
movia r20, ARKey
beq r20,r19,StartRoulutte
movia r20,ABKey
beq r20,r19,StartRoulutte
mov r21,r0   #reset enter 
#first number in r17, second in r18
bne r17,r0,addTen
mov r19,r18
br draw_box


addTen:
addi r18,r18,10
mov r19,r18

draw_box:

movia r4, ADDR_VGA  #need to add the exact place you want to draw, expra
#need to check the offset accroding to user input
movia r7,  27 #length of the square 
movia r8,   33 #height of the square 

#initalize check here
movia r20,0x01
beq r20,r19,loadOSOne
movia r20,0x02
beq r20,r19,loadOSTwo
movia r20,0x03
beq r20,r19,loadOSThree
movia r20,0x04
beq r20,r19,loadOSFour
movia r20,0x05
beq r20,r19,loadOSFive
movia r20,0x06
beq r20,r19,loadOSSix
movia r20,0x07
beq r20,r19,loadOSSeven
movia r20,0x08
beq r20,r19,loadOSEight
movia r20,0x09
beq r20,r19,loadOSNine
movia r20,0x0A
beq r20,r19,loadOSA
movia r20,0x0B
beq r20,r19,loadOSB
movia r20,0x0C
beq r20,r19,loadOSC
movia r20,0x0D
beq r20,r19,loadOSD
movia r20,0x0E
beq r20,r19,loadOSE
movia r20,0x0F
beq r20,r19,loadOSF



Draw_sqr_ini:

mov r10,r4    #
movi r5,0   #initialize 
movi r6,0
movia r9, 0x001f  #blue pixel for now 

draw_one:
beq r5,r7,draw_one_done
sthio r9,0(r10)
addi r10,r10,2
addi r5,r5,1
br draw_one

draw_one_done:
beq r6,r8,draw_two
sthio r9,0(r10)
addi r10,r10,1024
addi r6,r6,1
br draw_one_done

draw_two:
beq r5,r0,draw_two_done
sthio r9, 0(r10)
subi r10,r10,2
subi r5,r5,1
br draw_two

draw_two_done:
beq r6,r0,StartRoulutte
sthio r9,0(r10)
subi r10,r10,1024
subi r6,r6,1
br draw_two_done


StartRoulutte:
ldwio r14,0(r12)
#ldwio r14,0(r12)


mov r14,r0
wrctl ctl0,r14 
#call roulutte subroutine
subi sp, sp, 52#
stw ra, 0(sp)
stw r2, 4(sp)
stw r4, 8(sp)
stw r5, 12(sp)
#stw r6, 20(sp)
stw r7, 16(sp)
stw r8, 20(sp)
stw r9, 24(sp)
stw r10, 28(sp)
stw r11, 32(sp)
stw r12, 36(sp)
#stw r14, 52(sp)
#stw r15, 56(sp)
stw r16, 40(sp)
stw r17, 44(sp)
stw r18, 48(sp)
#stw r19, 72(sp)
#stw r20, 76(sp)
#stw r21, 80(sp)
#stw r22, 84(sp)
#stw r23, 88(sp)

call spinner


ldw ra, 0(sp)
ldw r2, 4(sp)
#ldw r3, 8(sp)
ldw r4, 8(sp)
ldw r5, 12(sp)
#ldw r6, 20(sp)
ldw r7, 16(sp)
ldw r8, 20(sp)
ldw r9, 24(sp)
ldw r10, 28(sp)
ldw r11, 32(sp)
ldw r12, 36(sp)
#ldw r13, 40(sp)
#ldw r14, 52(sp)
#ldw r15, 56(sp)
ldw r16, 40(sp)
ldw r17, 44(sp)
ldw r18, 48(sp)
addi sp, sp, 52

movi r14,0b1
wrctl ctl0,r14 
mov r21,r0

  movia r3, ADDR_CHAR
  movia r4,forthString
  addi r3, r3,6730
stringFour:
	ldbio r15,0(r4)
	beq r15,r0,playMusic
	stbio r15,0(r3)
	addi r4,r4,1
	addi r3,r3,1
	
	br stringFour



# br waitResult

# waitResult:
# beq r21,r0,waitResult
# #string initialize 
  # movia r3, ADDR_CHAR
  # movia r4,firstString
  # addi r3, r3,0b1
# beq r19,r0,Lose
# movia r4,forthString
# movia r5, winAudio
# movia r2, winEnd
# br printResult



# Lose:
# movia r4,fifthString
# movia r5, loseAudio
# movia r2,loseEnd
# br printResult

# printResult:
# stringFive:
	# ldbio r15,0(r4)
	# beq r15,r0,Done
	# stbio r15,0(r3)
	# addi r4,r4,1
	# addi r3,r3,1
	
	# br stringFive
	
# playMusic:
# movia r3,Timer 
# movui r2,2803
# stwio r2,8(r3)
# stwio r0,12(r3)
# movui r2,0b0100
# stwio r2,4(r3)

# #audio initialize 
# movia r4, Audio

# #main loop
# audioLoop:
# ldwio r2,0(r3)
# andi r2,r2,0b1
# beq r2,r0,audioLoop
# #timer timed out, check if audio reach the end

# beq r5,r2,Done
# #not end
# ldwio r6,0(r5)    #load audio word , increment audio address
# stwio r6,8(r4)
# stwio r6,12(r4)
# addi r5,r5,4
# #reset the timer 
# stwio r0,0(r3)    #reset time out 
# movui r2,0b0100   #restart timer 
# stwio r2,4(r3)
# br audioLoop
# playMusic:
# subi sp, sp, 4
# stw ra, 0(sp)

# call audio

# ldw ra, 0(sp)
# addi sp, sp, 4
playMusic:
#timer initialize 
movia r3,Timer 
movui r2,2803
stwio r2,8(r3)
stwio r0,12(r3)
movui r2,0b0100
stwio r2,4(r3)

#audio initialize 
movia r4, Audio
movia r5, myAudio

#main loop
audioLoop:
ldwio r2,0(r3)
andi r2,r2,0b1
beq r2,r0,audioLoop
#timer timed out, check if audio reach the end
movia r2,endAudio
beq r5,r2,Done
#not end
ldwio r6,0(r5)    #load audio word , increment audio address
stwio r6,8(r4)
stwio r6,12(r4)
addi r5,r5,4
#reset the timer 
stwio r0,0(r3)    #reset time out 
movui r2,0b0100   #restart timer 
stwio r2,4(r3)
br audioLoop

Done:
br Done


loadOSOne:
movia r20,offSetOne
add r4,r4,r20
br Draw_sqr_ini

loadOSTwo:
movia r20,offSetTwo
add r4,r4,r20
br Draw_sqr_ini

loadOSThree:
movia r20,offSetThree
add r4,r4,r20
br Draw_sqr_ini

loadOSFour:
movia r20,offSetFour
add r4,r4,r20
br Draw_sqr_ini

loadOSFive:
movia r20,offSetFive
add r4,r4,r20
br Draw_sqr_ini

loadOSSix:
movia r20,offSetSix
add r4,r4,r20
br Draw_sqr_ini

loadOSSeven:
movia r20,offSetSeven
add r4,r4,r20
br Draw_sqr_ini

loadOSEight:
movia r20,offSetEight
add r4,r4,r20
br Draw_sqr_ini

loadOSNine:
movia r20,offSetNine
add r4,r4,r20
br Draw_sqr_ini


loadOSA:
movia r20,offSetA
add r4,r4,r20
br Draw_sqr_ini

loadOSB:
movia r20,offSetB
add r4,r4,r20
br Draw_sqr_ini

loadOSC:
movia r20,offSetC
add r4,r4,r20
br Draw_sqr_ini

loadOSD:
movia r20,offSetD
add r4,r4,r20
br Draw_sqr_ini

loadOSE:
movia r20,offSetE
add r4,r4,r20
br Draw_sqr_ini

loadOSF:
movia r20,offSetF
add r4,r4,r20
br Draw_sqr_ini




.section .exceptions, "ax"
KeyboardCheck:

rdctl et,ctl4        #read ipending
andi et,et, 0b10000000
beq et,r0,Exit
#error check 
ldwio r16,4(r12)
andi r16,r16,0b10000000000
bne r16,r0,Exit

ldwio r14,0(r12)


#mov r16,r14
#srli r16,r16,8
#subi r16,r16,0xF0
#beq r16,r0,Exit




andi r14,r14,0xFF #now data is in r14


#initialize check
movia r20,brk
beq r20,r14,keyDown

bne r22,r0,keyUp

movia r20, zero
beq r20,r14,loadZero
movia r20,one
beq r20,r14,loadOne
movia r20,two
beq r20,r14,loadTwo
movia r20,three
beq r20,r14,loadThree
movia r20,four
beq r20,r14,loadFour
movia r20,five
beq r20,r14,loadFive
movia r20,six
beq r20,r14,loadSix
movia r20,seven
beq r20,r14,loadSeven
movia r20,eight 
beq r20,r14,loadEight
movia r20,nine
beq r20,r14,loadNine
movia r20,enter
beq r20,r14,checkEnter
movia r20,RKey
beq r20,r14,loadR
movia r20,BKey
beq r20,r14,loadB
movia r20, YKey
beq r20, r14,enterY
movia r20,NKey
beq r20,r14,enterN


br Exit

enterY:
movi r19,0x01
br print

enterN:
mov r19,r0
br print

loadR:
movia r14,ARKey
br print

loadB:
movia r14,ABKey
br print

keyDown:
movi r22,1
br Exit

keyUp:
mov r22,r0
br Exit

checkEnter:
movia r21, 0b1
br Exit

loadZero:
movia r14,Azero
br print

loadOne:
movia r14,Aone
br print

loadTwo:
movia r14,Atwo
br print

loadThree:
movia r14,Athree
br print

loadFour:
movia r14,Afour
br print

loadFive:
movia r14,Afive
br print

loadSix:
movia r14,Asix
br print

loadSeven:
movia r14,Aseven
br print

loadEight:
movia r14,Aeight
br print

loadNine:
movia r14,Anine
br print

print:
addi r3,r3,1     #move address to next one 
stbio r14,0(r3)   #store input as character on the screen ADD CHAR

beq r19,r0,firstInput

movia r20, 0x42
beq r20,r14,storeB
movia r20,0x52
beq r20,r14,storeR

mov r18,r14
subi r18,r18,0x30
andi r18,r18,0b1111
br Exit

firstInput:
mov r17,r14
subi r17,r17,0x30
andi r17,r17,0b1111
movi r19, 0b1

storeB:
mov r19,r14
br Exit

storeR:
mov r19,r14
br Exit

Exit:
subi ea,ea,4
eret
