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
 
         Invoke StdOut,ADDR MsgExit 
         Invoke StdIn,ADDR inbuf,LengthOf inbuf 	
	
         Invoke ExitProcess,0 
         End    Start 
