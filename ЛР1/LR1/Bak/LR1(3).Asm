; Template for console application
         .586           
         .MODEL  flat, stdcall  
         OPTION CASEMAP:NONE 

Include kernel32.inc 
Include masm32.inc

IncludeLib kernel32.lib 
IncludeLib masm32.lib

         .CONST   
MsgExit  DB    "Press Enter to Exit",0AH,0DH,0

         .DATA 
     A SDWORD -30
     B SDWORD 21
     vall BYTE 255
    chart WORD 256
    lue3 SWORD -128
    alu BYTE ?
    v5 BYTE 10h
       BYTE 100101B
    beta BYTE 23,23h,0ch
    sdk BYTE "Hello",0
    min SWORD -32767
    ar DWORD 12345678h
    valar BYTE 5 DUP (1, 2, 8)
        
    ;task 5
    
    twefive sword 25
    doubleword  dword   -35
    wordRus byte    "Артур"
    wordEng byte    "Artur"
    
    ;task 6
        
        num1    word    37
        num1r   word    1001101b
        num2r   word    2500h
        
     ;task 7
     
        F1  word    65535
        F2  dword   65535
    
    
         .DATA? 
     X SDWORD ?    
         
inbuf    DB    100 DUP (?)

         .CODE
Start:
        mov EAX,A
        add EAX,5
        sub EAx,B
        mov X,EAX
; 
;    Add you statements
;       
        ;task 7
            add F1,1
            add F2,1
        
 
         Invoke StdOut,ADDR MsgExit 
         Invoke StdIn,ADDR inbuf,LengthOf inbuf 	
	
         Invoke ExitProcess,0 
         End    Start 
