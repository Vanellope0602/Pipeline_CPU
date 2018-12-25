ori $9, $0, 28     # data hazard 
ori $10, $9, 1773  # data hazard 
ori $11, $10, 233  #continuous hazard 
ori $1, $0, 1      # let $1 == 1 forever 
ori $3, $0, 3
j store_word

back_here:
subu $22, $22, $15
ori $2,$14, 16
subu $2, $2, $2
subu $22, $22, $22
beq $2, $22, end   ## must branch successfull cuz they are zero !!! 

store_word: 
sw $9, 16($0)
sw $10, 8($0)
sw $11, 12($0)
lw $22, 16($0)
j back_here

end:
addu $18, $1, $6
sw $18, -16($9)
lui $7,9
ori $8, $0, 702
jal test
#ra
subu $2, $8, $1   # has been executed after jal!!! SO jr back to lui !!
lui $0, 233       #  jal PC + 8 position 
subu $9, $7, $6

test:
sw $9, 28($0)
addu $20, $20, $1
beq $20, $3, exit
              # Why MARS can automatically skip this jr $31 at the last time when they are equal??
jr $ra
exit:
addu $13, $10, $11
