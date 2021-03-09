.MODEL
.STACK 100 
.DATA

MSG1 DB "Enter number of rows $"  ;input msg
 
n DB 0      ;the row index and at the same time it is n in calculating nCr
row DB 0    ;the number of rows the user enterd
r DB 0      ;r in calcuating ncr
ncr DB 0    ;the value of ncr 


;itration index
i DB 0      
j DB 0
k DB 0

;for printint NCR
DECIMAL10 DB 10
COUNTER DB 0 

.CODE
 
MOV AX,@DATA
MOV DS,AX 

LEA DX,MSG1     ;Promting the user with a msg
MOV AH,09H
INT 21H
call printNewLine


MOV AH,1      ;input number into al
INT 21H
SUB AL,48      ;substract 48 from number to convert to integer from ascii

;Store number of rows the user entered
MOV row,AL

CALL printNewLine
CALL printNewLine

MOV CX,0

;i=row
MOV DH,row
MOV i,DH

LOOP1:
       
    ;initializing the value of r and n   
    MOV r,0
    ;n = row-i  
    MOV DH,row
    SUB DH,i
    MOV n,DH
    
    ;initialization of the iterations
    ;j = i-1
    MOV DH,i
    DEC DH
    MOV j,DH 
    CMP j,0
    Jz zero   
    LOOP2:
    
    MOV CL,j           ;iteration of loop2    
    CALL printSpace     ;printing space to form the triangle shape    
    DEC j        
    LOOP LOOP2
    
    zero:
        MOV DH,row             ;k = row-i+1
        SUB DH,i
        ADD DH,1
        MOV k,DH
    
    LOOP3: 
    MOV CL,k       ;iteration of loop3 
     
    CMP r,0
    JZ ncrValue

    CALL formulaNCR
    CALL printSpace
    CALL printNCR
    
   RESUME:     
        DEC k
        INC r
        
        LOOP LOOP3
        
        ;iteration of loop1 
        CALL printNewLine
        MOV CL,i
        DEC i
    
LOOP LOOP1


EXIST:
    HLT

    
;ncr value for r=0
ncrValue: 
    MOV ncr,1
    CALL printSpace
    CALL printNCR
    JMP RESUME                     
                                          
;printing new line procedure
printNewLine PROC
    MOV AH,2
    MOV DL,10
    INT 21H
    MOV DL,13
    INT 21H 
RET
printNewLine ENDP
            
;printing space procedure
printSpace PROC
    MOV DL,' '
    MOV AH,2
    INT 21H
RET
printspace ENDP
                          
;printing ncr  
printNCR PROC
    MOV COUNTER,0
    MOV AL,NCR
    CBW
    ;to save the last value of CX
    PUSH CX
       
    MOV CX,3         ;max number of digits is three
    
    LOOPING1:
    
        DIV DECIMAL10
        PUSH AX
        CBW 
        ;determines how many times the AX is pushed
        INC COUNTER
        CMP AL,0
        
    LOOPNE LOOPING1
        
        MOV CL,COUNTER 
    LOOPING2:
    
        POP BX
        MOV DL,BH
        ADD DL,48
        MOV AH,2
        INT 21H
         
    LOOP LOOPING2   
    
    ;to get the last value of CX
    POP CX   
RET
printNCR ENDP
           
             
;formula of calculationg ncr 
formulaNCR PROC
    ;n-r+1/r
    MOV AL,n
    SUB AL,r
    ADD AL,1
    CBW
    DIV r
    MOV BX,AX
    
    ;ncr*(n-r+1)/r  = (ncr* ah)/r + (ncr * ral)/r
    MOV AL,ncr
    MUL BH
    DIV r
    MOV DL,AL
        
    MOV AL,BL
    MUL r
    MOV BL,AL

    MOV AL,ncr
    MUl BL
    DIV r
    ADD Dl,AL
    
    MOV ncr,DL
RET
formulaNCR ENDP 
