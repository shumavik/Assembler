; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit  DB    13,10,"Press Enter to Exit",0AH,0DH,0

         .DATA
        
        Zapros1 DB 13,10,'Input a',13,10,0
        Zapros2 DB 13,10,'Input m',13,10,0
        
        Result DB 'Result = ' 
        ResStr  DB  16 dup (' '),0 



         .DATA?
            a sword ?
            m sword ?
            b sword ?
            d sword ?    
         Buffer DB 10 DUP (?)   
         inbuf    DB    100 DUP (?)
         
        
         .CODE
Start:  
            Invoke StdOut,ADDR Zapros1  
            
            Invoke StdIn,ADDR Buffer,LengthOf Buffer  ; Ввод числа a
            Invoke StripLF,ADDR Buffer
            Invoke atol,ADDR Buffer
            
            
            mov  a,AX   ; Пересылаем введенные данные из регистра AX
            
            Invoke StdOut,ADDR Zapros2
            Invoke StdIn,ADDR Buffer,LengthOf Buffer ; Ввод числа m
            Invoke StripLF,ADDR Buffer
            Invoke atol,ADDR Buffer
            
            mov  m,AX
         
         ; Начало вычислений   
            
         mov AX,m
         mov CX,m
         
         
         
         sub AX,5 ; AX:=m-5
         add CX,2 ; CX:=m+2
         
       
         imul CX   ;AX:=(m-5)*(m+2)
         
         
         add AX,m  ;AX:=(m-5)*(m+2)+m
         
         
         mov b,AX ;b:=(m-5)*(m+2)+m
        
         XOR EAX,EAX ; Очищаем регистр EAX
         
         mov  AX,a ;AX:=a
         mov CX,2   ;CX:=2
         cwd      ; преобразуем слово в двойное слово
         ; для правильного выполнения деления
         idiv word PTR CX    ;AX:=a/2
         
         add  b,AX ;b:=(m-5)*(m+2)+m+a/2
         mov d,DX   ;остаток
         
        
        
         Invoke  dwtoa,b,ADDR ResStr  ; Преобразуем ответ
            
         Invoke StdOut,ADDR Result   ; Выводим ответ
         
         XOR EAX,EAX  
         
         
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

