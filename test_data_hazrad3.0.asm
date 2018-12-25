#2,3,4
ori $2, $0, 1205   # 4b5
ori $3, $0, 2333
addu $4, $2, $3
#
ori $5, $0, 62
subu $6, $5, $2
#
lui $8, 1205
addu $9, $8, $2 # $7 == 0
#
addu $10, $2, $5
ori $11, $10, 1706
#
subu $12, $9, $11
addu $13, $12, $1
#
sw $3, 8($0)
sw $4, 16($0)
sw $5, 32($0)
ori $15, $0, 16
lw $16, 0($15)       # grab data in $4   *16
addu $15, $15, $15  # double hazard forward 
lw $17, 0($15)      # grab data in $5     *32
ori $1, $0, 8
subu $15, $15, $1   # $15 == 32-8 == 24
subu $15, $15, $1   # $15 = 24 - 8 = 16
lw $18, -8($15)     # grab data in $3      *008

addu $19, $17, $18
addu $20, $18, $17
beq $19, $20, exit

ori $22, $21, 10000
ori $23, $22, 7873
exit:

addu $28, $22, $23
