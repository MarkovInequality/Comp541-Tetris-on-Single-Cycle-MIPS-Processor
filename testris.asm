# 1 - 7 colors of tetris blocks
#
# .5 second loop
#

.data
# addr 0x 1001 0000 is gameloop counter
counter:	.word 0
# addr 0x 1001 0004 is gameloop top, results in 60hz loop for counter
countEnd:	.word 1
# addr 0x 1001 0008
accelXLoc:	.word 0x10030000 #ro
accelYLoc:	.word 0x10030004 #ro
accelZLoc:	.word 0x10030008 #ro
accelTLoc:	.word 0x1003000C #ro
keyBLoc:	.word 0x10030010 #ro
audPeriod:	.word 0x10030014 #wo
leds:		.word 0x10030018 #wo
segScreen:	.word 0x1003001C #wo
# song 0x 1001 0028
song:		.word 0x0004A126,  #E
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x00062E1E,  #B
		      0x0005D537,  #C
		      0x00053203,  #D
		      0x00053203,  #D
		      0x0005D537,  #C
		      0x00062E1E,  #B
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x0005D537,  #C
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x00053203,  #D
		      0x0005D537,  #C
		      0x00062E1E,  #B
		      0x00062E1E,  #B
		      0x00062E1E,  #B
		      0x0005D537,  #C
		      0x00053203,  #D
		      0x00053203,  #D
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x0005D537,  #C
		      0x0005D537,  #C
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x00053203,  #D
		      0x00053203,  #D
		      0x00053203,  #D
		      0x00045EA1,  #F
		      0x000377C9,  #A5
		      0x000377C9,  #A5
		      0x0003E47E,  #G
		      0x00045EA1,  #F
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x0005D537,  #C
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x00053203,  #D
		      0x0005D537,  #C
		      0x00062E1E,  #B
		      0x00062E1E,  #B
		      0x00062E1E,  #B
		      0x0005D537,  #C
		      0x00053203,  #D
		      0x00053203,  #D
		      0x0004A126,  #E
		      0x0004A126,  #E
		      0x0005D537,  #C
		      0x0005D537,  #C
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x0006EF91,  #A
		      0x00000000,  #blank
		      0x00000000  #blank
# addr points to music counters
mcount:		.word 0x00000000
mcount2:	.word 0x00000000
# addr points to data beginning
screenBegin:	.word 0x10020000
#blk data
blockstate:	.word 0
blockpos:	.word 0
I0:		.word 40, 41, 42, 43, 9
I1:		.word 2, 42, 82, 122, 9
I2:		.word 40, 41, 42, 43, 9
I3:		.word 2, 42, 82, 122, 9
J0:		.word 0, 40, 41, 42, 10
J1:		.word 1, 2, 41, 81, 10
J2:		.word 40, 41, 42, 82, 10
J3:		.word 1, 41, 80, 81, 10
RJ0:		.word 2, 40, 41, 42, 11
RJ1:		.word 1, 41, 81, 82, 11
RJ2:		.word 40, 41, 42, 82, 11
RJ3:		.word 0, 1, 41, 81, 11
SQ0:		.word 1, 2, 41, 42, 12
SQ1:		.word 1, 2, 41, 42, 12
SQ2:		.word 1, 2, 41, 42, 12
SQ3:		.word 1, 2, 41, 42, 12
S0:		.word 1, 2, 40, 41, 13
S1:		.word 1, 41, 42, 82, 13
S2:		.word 1, 2, 40, 41, 13
S3:		.word 1, 41, 42, 82, 13
T0:		.word 1, 40, 41, 42, 14
T1:		.word 1, 41, 42, 81, 14
T2:		.word 40, 41, 42, 81, 14
T3:		.word 1, 40, 41, 81, 14
RS0:		.word 0, 1, 41, 42, 15
RS1:		.word 2, 41, 42, 81, 15
RS2:		.word 0, 1, 41, 42, 15
RS3:		.word 2, 41, 42, 81, 15
#random number data
prandogen:	.word 2147483647
prandonum:	.word 0
#keyb history memory
pastkey:	.word 0
#dropcounter
dropcounter:	.word 0
droplimit:	.word 60


.text
#update loop, refreshes roughly 60 times per second
	lw $a0, screenBegin
	addi $a0, $a0, 4580
	addi $a0, $a0, 160
asdf1:	subi $a0, $a0, 160
	ori $t0, $a0, 0
	lw $t1, 0($t0)
	beq $t1, 6, asdf3
asdf2:	subi $t0, $t0, 4
	lw $t1, 0($t0)
	beq $t1, 5, asdf1
	ori $t3, $0, 0
	sw $t3, 0($t0)
	j asdf2
asdf3:
	
	jal blkgen

updl:	jal music
	
	jal keydet
	bne $v0, 0x1C, kchk2
	lw $a0, blockstate
	ori $a1, $a0, 0
	lw $a2, blockpos
	subi $a3, $a2, 1
	jal updblk
	j droplp
kchk2:	bne $v0, 0x23, kchk3
	lw $a0, blockstate
	ori $a1, $a0, 0
	lw $a2, blockpos
	addi $a3, $a2, 1
	jal updblk
	j droplp	
kchk3:	bne $v0, 0x1D, kchk4
	lw $a0, blockstate
	lw $t0, 16($a0)
	lw $t1, 36($a0)
	beq $t0, $t1, dkchk
	subi $a1, $a0, 60
	j dkchkd
dkchk:	addi $a1, $a0, 20
dkchkd:	lw $a2, blockpos
	ori $a3, $a2, 0
	jal updblk
	j droplp
kchk4:	bne $v0, 0x1B, kchk5
	ori $t0, $0, 10
	sw $t0, droplimit
	j droplp
kchk5:	bne $v0, 0xF01B, droplp
	ori $t0, $0, 60
	sw $t0, droplimit
	j droplp
	
droplp:	lw $t0, dropcounter
	lw $t1, droplimit
	addi $t0, $t0, 1
	sw $t0, dropcounter
	blt $t0, $t1, drople
	sw $0, dropcounter
	lw $a0, blockstate
	ori $a1, $a0, 0
	lw $a2, blockpos
	add $a3, $a2, 40
	jal updblk
drople:		
	
tloop:	lw $t0, counter
        lw $t1, countEnd
        addi $t0, $t0, 1
        sw $t0, counter
        sw $t1, countEnd
	blt $t0, $t1, tloop
	ori $t0, $0, 0
	sw $t0, counter
j updl


#keypress detect
keydet:	lw $t0, keyBLoc
	lw $t1, 0($t0)
	lw $t2, pastkey
	beq $t1, $t2, samek
	ori $v0, $t1, 0
	sw $t1, pastkey
	jr $ra
samek:	ori $v0, $0, 0
	jr $ra



#new block generation
blkgen:	ori $t0, $0, 7
	lw $t1, prandonum
	lw $t2, prandogen
	lw $t4, mcount
	ori $t3, $0, 0
	j genchk
regen:	addu $t1, $t2, $t1
	addu $t1, $t1, $t4
	and $t3, $t0, $t1
genchk:	beq $t3, $0, regen
	sw $t1, prandonum
	bne $t3, 1, bg2
	la $v0, I0
	j genpos
bg2:	bne $t3, 2, bg3
	la $v0, J0
	j genpos
bg3:	bne $t3, 3, bg4
	la $v0, RJ0
	j genpos
bg4:	bne $t3, 4, bg5
	la $v0, SQ0
	j genpos
bg5:	bne $t3, 5, bg6
	la $v0, S0
	j genpos
bg6:	bne $t3, 6, bg7
	la $v0, T0
	j genpos
bg7:	bne $t3, 7, regen
	la $v0, RS0
genpos:	ori $v1, $0, 218
	sw $v0, blockstate
	sw $v1, blockpos
	jr $ra
	


#gamelogic, a0 is old state, a1 is new state, a2 is old pos, a3 is new pos, pos is in offset
updblk:	lw $t0, screenBegin	#screen mem position for 0,0
	srl $t0, $t0, 2
	addi $s4, $t0, 374
	sll $s4, $s4, 2
	add $a2, $t0, $a2	
	add $a3, $t0, $a3	#offset pos by screen mem pos
	lw $s0, 0($a0)		#old block pt1 
	lw $s1, 4($a0)		#old block pt2
	lw $s2, 8($a0)		#old block pt3
	lw $s3, 12($a0)		#old block pt4
	add $s0, $a2, $s0
	add $s1, $a2, $s1
	add $s2, $a2, $s2
	add $s3, $a2, $s3	#old pos of block
	sll $s0, $s0, 2
	sll $s1, $s1, 2
	sll $s2, $s2, 2
	sll $s3, $s3, 2
	blt $s3, $s4, poschk 
	sw $0, 0($s3)
	blt $s2, $s4, poschk
	sw $0, 0($s2)
	blt $s1, $s4, poschk	
	sw $0, 0($s1)
	blt $s0, $s4, poschk
	sw $0, 0($s0)		#delete old block
poschk:	lw $t0, 0($a1)		#block pt1
	lw $t1, 4($a1)		#block pt2
	lw $t2, 8($a1)		#block pt3
	lw $t3, 12($a1)		#block pt4
	lw $t9, 16($a1)		#block color
	add $t0, $a3, $t0
	add $t1, $a3, $t1
	add $t2, $a3, $t2
	add $t3, $a3, $t3	#new pos of blocks
	sll $t0, $t0, 2
	sll $t1, $t1, 2
	sll $t2, $t2, 2
	sll $t3, $t3, 2
	lw $t4, 0($t3)
	bgt $t4, 2, br1
	blt $t3, $s4, ccc1
	sw $t9, 0($t3)
ccc1:	lw $t4, 0($t2)
	bgt $t4, 2, br2
	blt $t2, $s4, ccc2
	sw $t9, 0($t2)
ccc2:	lw $t4, 0($t1)
	bgt $t4, 2, br3
	blt $t1, $s4, ccc3
	sw $t9, 0($t1)
ccc3:	lw $t4, 0($t0)
	bgt $t4, 2, br4
	blt $t0, $s4, ccc4
	sw $t9, 0($t0)
ccc4:	j doop
	#works
br4:	sw $0, 0($t1)
br3:	sw $0, 0($t2)
br2:	sw $0, 0($t3)
br1:	j noop

doop:	ori $v0, $a1, 0
	lw $t0, screenBegin
	srl $t0, $t0, 2
	sub $v1, $a3, $t0
	sw $v0, blockstate
	sw $v1, blockpos
	jr $ra

noop:	lw $t4, 16($a0)
	blt $s3, $s4, cccc
	sw $t4, 0($s3)
	blt $s2, $s4, cccc
	sw $t4, 0($s2)
	blt $s1, $s4, cccc	
	sw $t4, 0($s1)
	blt $s0, $s4, cccc
	sw $t4, 0($s0)
cccc:	sub $t0, $a3, $a2
	beq $t0, 40, noop2
	ori $v0, $a0, 0
	lw $t0, screenBegin
	srl $t0, $t0, 2
	sub $v1, $a2, $t0
	jr $ra
noop2:	ori $s6, $ra, 0
	ori $a0, $s3, 0
	jal fdline
	jal blkgen
	jr $s6
	


#foundline a0 is from line(lower) screen mem pos
fdline:	ori $s7, $ra, 0	
	ori $t0, $a0, 0
fndrl:	addi $t0, $t0, 4
	lw $t1, 0($t0)
	bne $t1, 4, fndrl
	subi $s1, $t0, 0
	subi $s2, $t0, 484
fdll21:	ori $t0, $s1, 0
fdll22:	subi $t0, $t0, 4
	lw $t1, 0($t0)
	bgt $t1, 8, fdll22
	bne $t1, 5, noline
	ori $a0, $s1, 0
	jal clrln
	addi $s1, $s1, 160
	addi $s2, $s2, 160
noline:	subi $s1, $s1, 160
	bgt $s1, $s2, fdll21
	jr $s7
	


#clear a lines with right boundary at location a0
clrln:	addi $a0, $a0, 160
dropp:	subi $a0, $a0, 160
	ori $t0, $a0, 0
	lw $t1, 0($t0)
	beq $t1, 6, clrlf
clrl2:	subi $t0, $t0, 4
	lw $t1, 0($t0)
	beq $t1, 5, dropp
	subi $t2, $t0, 160
	lw $t3, 0($t2)
	beq $t3, 1, aaaa
	sw $t3, 0($t0)
	j clrl2
aaaa:	ori $t3, $0, 0
	sw $t3, 0($t0)
	j clrl2
clrlf:	jr $ra




#music module
music:	lw $t0, mcount
	addi $t0, $t0, 1
	sw $t0, mcount
	blt $t0, 30, mend
	ori $t0, $0, 0
	sw $t0, mcount
	lw $t0, mcount2
	addi $t0, $t0, 4
	sw $t0, mcount2
	la $t1, song
	add $t0, $t1, $t0
	lw $t1, ($t0)
	lw $t2, audPeriod
	sw $t1, ($t2)
	bne $t1, 0, mend
	ori $t0, $0, 0
	sw $t0, mcount2
mend:	jr $ra
	

#does multiplication on 16 bit numbers
#multiplication operation, expensive(~140 cycles)
mul:	bgt $a0, $a1, gt
lt:	ori $t1, $a0, 0
	ori $t0, $a1, 0
	j dofn
gt:	ori $t0, $a0, 0
	ori $t1, $a1, 0
dofn:	lui $t2, 0
	ori $t2, $t2, 1
	ori $t5, $0, 0
	ori $t6, $0, 0
	j evall
evalb:	and $t3, $t1, $t2
	beqz $t3, skip
	sllv $t4, $t0, $t5
	add $t6, $t6, $t4
skip:	sll $t2, $t2, 1
	addi $t5, $t5, 1
evall:	blt $t5, 17, evalb
	ori, $v0, $t6, 0
	jr $ra
	
end:
	