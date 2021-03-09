; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
include emu8086.inc 

DEFINE_GET_STRING
DEFINE_PRINT_STRING
              
   
start: 
lea dx,msg1
mov ah, 9
int 21h    ; Load the address of a '$'-terminated
           ; string into DX, then call the interrupt with function code 9 in AH.

lea di, buffer      ; buffer offset.
mov dx, size        ; buffer size.
call get_string     ;using the print_string macro function to get string at Dx

putc 0dh        ;inserting space between lines for cleaner style
putc 0ah 


lea bx, table1
lea bp, di   


encrypt: 

cmp [bp] , '$'    ; checking for end of string condition
je print

mov al,[bp]
cmp al, 'a'
jb  condition
cmp al, 'z'
ja  condition    
xlatb     ; encrypt using table1.     
mov [bp],al
mov ah,0     
lea si,di
condition:
inc bp
jmp encrypt

print:

; show result:
push dx
lea dx, msg2
mov ah, 9
int 21h
pop dx
lea dx, di 
call print_string  


putc 0dh         ;inserting space between lines for cleaner style
putc 0ah

lea bx, table2
lea bp,di

decrypt:

cmp [bp] , '$'    ; checking for end of string condition
je print2

mov al, [bp]
cmp al, 'a'
jb  condition1
cmp al, 'z'
ja condition1    
xlatb     ; encrypt using table2.
cmp al,27h
jz sol
return: 
mov [bp],al
mov ah,0     
lea si,di
condition1:
inc bp
jmp decrypt
sol:
mov al,'k'
jmp return 

print2:

lea dx,msg3
mov ah, 9
int 21h 
call print_string 
putc 0dh         ;inserting space between lines for cleaner style
putc 0ah 
jmp start 
ret   ; exit to operating system.

;defining the program variables needed  
buffer db 27,?, 27 dup(' '),'$'
size = offset buffer  ; declare constant
table1 DB 97 dup (' '),'qwertyuiopasdfghjklzxcvbnm' ;'abcdefghijklmnopqrstuvwxyz'
table2 DB 97 dup (' ') 'xvmcnophqrszyijadlegwbuftk' ;'bcdefghijklmnopqrstuvwxyz' 
msg1 db 0Dh,0Ah, " Enter your message in letters: $"
msg2 db 0Dh,0Ah, " The encrypted cipher text: $"
msg3 db 0Dh,0Ah, " The decrypted original message: $"  
end