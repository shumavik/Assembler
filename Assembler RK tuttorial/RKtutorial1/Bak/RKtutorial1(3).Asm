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
buffer      DB  100 dup(?),0
Enter_Str   DB  "Enter a element the matrix",13,10,0
Out_Message DB  "Output the matrix",13,10,0
Pusto       DB  13,10,0
Probel      DB  ' ',0
five        word    5
yes_str      DB    "Yes",13,10,0

X           sword       0,0,0,0,0 
            sword       0,0,0,0,0            
            sword       0,0,0,0,0
            sword       0,0,0,0,0
            sword       0,0,0,0,0  

K           sword   0,0,0,0,0
    

         .DATA?
inbuf    DB    100 DUP (?)
pro      sword  ?
ostatok  sword  ?
point     word  ?
         .CODE
Start:

         mov pro,1   
            
            
         mov EBX,0
         mov ECX,25
         
         
Enter_cycle:
                 push ECX
                 Invoke StdOut, ADDR Enter_Str
                 Invoke StdIn, ADDR buffer,LengthOf buffer 
                 Invoke StripLF, ADDR buffer
                 Invoke atol, ADDR buffer
                 mov X[EBX],AX
                 add EBX,2
                 pop ECX
            loop Enter_cycle


            mov EBX,0
            mov ECX,5
            mov point,0
            
ActionCycle1:
                mov pro,1
                add point,2 

                push ECX
                mov ECX,5
                
ActionCycle2:            
             mov AX,X[EBX*2]
             push EAX
             cwd
             idiv sword PTR five
             pop EAX  
             cmp DX,0
             je yes
             jmp continue
             
       yes:   
              imul pro
              mov pro,AX
              push ECX
              Invoke StdOut, ADDR yes_str
              pop ECX
              push EBX
              
              mov BX,point
              mov DX,pro
              mov K[BX],DX
              
              pop EBX  
                           
                
       
       
             
             
continue:    inc EBX
             loop ActionCycle2
                
             pop ECX

             loop ActionCycle1
            
            Invoke StdOut,ADDR Out_Message
            mov EBX,0
            mov ECX,5
            
              
Outcycle1:                     
            push ECX
            mov ECX,5
Outcycle2:
             
            mov AX,X[EBX*2]
            push ECX
            Invoke dwtoa,X[EBX*2], ADDR buffer
            Invoke StdOut, ADDR buffer
            Invoke StdOut, ADDR Probel
            pop ECX
           
            inc EBX
            loop Outcycle2
            pop ECX
            push ECX
            Invoke StdOut, ADDR Pusto
            pop ECX
            loop Outcycle1
            
            mov EBX,0
            mov ECX,5
            
LastOutput:
            push ECX
            Invoke dwtoa,K[EBX], ADDR buffer
            Invoke StdOut, ADDR buffer
            Invoke StdOut, ADDR Probel            
            pop ECX
            add EBX,2
            loop LastOutput



         XOR    EAX,EAX
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

