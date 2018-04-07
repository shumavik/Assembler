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
;Zapros DB 13,10,'Input a',13,10,0
;Zapros2 DB 13,10,'Input m',13,10,0
RequestA DB "Input matrix 5x5=25: ",0AH,0DH,0

    
    
    ;    NxN 
    ;   i<=N-j+i 
   
         A sword 0,0,0,0,0
              sword 0,0,0,0,0
              sword 0,0,0,0,0
              sword 0,0,0,0,0   
              sword 0,0,0,0,0
           N sword 5
           i sword 1   
           j sword 1
    

Per    DB 13,10,0         ; Для перехода на следующую строку при выводе матрицы
Result DB 'summa = '      ; Заготовка для вывода результата
Pusto  DB ' '             ; Пробел для разделения столбцов при выводе матрицы
ResStr DB 16 DUP (' '),0                   ; Помещаем значение переменной для вывода результата
ResStrOut DB 5 DUP (' '),0                 ; Помещаем значение переменной для вывода матрицы 
OutMatrix DB 'Output the matrix',13,10,0    


         .DATA?
inbuf    DB    100 DUP (?)
;sum     sword    ?              
res     sword    ?
resOut  sword    ?
help    sword    ?
InOutBuf       DB    100 DUP (?) ; Буфер ввода / вывода
          current sword ?
         .CODE
Start:
        ;Invoke StdOut,ADDR Zapros
        ;Invoke StdIn,ADDR Buffer,LengthOf Buffer
        ;Invoke StripLF,ADDR Buffer
        
        ;Invoke atol,ADDR Buffer
        ;mov dword PTR a,EAX
        
            ;Ввод матрицы
          Invoke StdOut, ADDR RequestA
          mov EBX,0
          mov ECX,25
    
  CycleInput:
                push ECX
                Invoke StdIn,ADDR InOutBuf,LengthOf InOutBuf
                Invoke StripLF, ADDR InOutBuf
                Invoke atol, ADDR InOutBuf
                mov  A[EBX],AX            
                pop ECX
               add EBX,2
                
           
                loop CycleInput
      

        
        ; Сумма положительных элементов над побочной диагональю    
                
          mov EBX,0    ;в EBX лежит смещение относительно базы
          
          mov ECX,5   ;ECX количество столбцов          
          cycle1:       
                        
                        push ECX
                        mov ECX,5
          cycle2:
                    
                    XOR EDX,EDX  ;Очищаем EDX
                    
                   mov DX,N     ;DX:=N
                   mov  current,DX ;current:=N
                   mov DX,j   ;DX:=j
                      sub current,DX ;current:=N-j
                      inc current  ;current:=N-j+1
                    
                      ;Выражение N-j+1 обеспечивает "проход"
                      ;над побочной диагональю
                    mov DX,current ;DX:=N-j+1
                    cmp i,DX   ;i<=N-j+1 
                      
                    jle metka1 ;Условие выполнено
                    
                    jmp continue ;Условие ложно
          
         metka1:    cmp A[EBX*2],0 ;Определяем положительный элемент
                    
                    jg metka2  ;Элемент матрицы положителен
                    
                    jmp continue ;Элемент матрицы отрицателен
                    
         metka2:    mov AX,A[EBX*2]  
                    add res,AX      ;Считаем сумму положительных элементов
          
          
       
        continue:       
                    
                   inc EBX
                   inc j 
                   loop cycle2
                    
                    pop ECX
                    sub j,5 ;j:=j-5=N+1-5 В j снова 1
                    inc i

                    loop cycle1              
                 

         XOR    EAX,EAX
         ;Вывод матрицы
           
          Invoke StdOut, ADDR OutMatrix  
            
          mov EBX,0    ;в EBX лежит смещение относительно базы
          mov ECX,5   ;ECX количество столбцов          
          cycleOutput1: 
                        push ECX
                        mov ECX,5
          cycleOutput2:
                        mov AX,A[EBX*2]          
                        mov help,AX
                        
                        push ECX
                        Invoke dwtoa,help, ADDR ResStrOut
                        Invoke StdOut, ADDR ResStrOut
                        Invoke StdOut, ADDR Pusto
                        pop ECX
                        
                        
                        
                          
                   inc EBX 
                   loop cycleOutput2 
                    pop ECX
                    
                    push ECX
                    invoke StdOut, ADDR Per
                    pop ECX
                    
                    loop cycleOutput1              
         XOR    EAX,EAX
         invoke StdOut, ADDR Per
         
         Invoke dwtoa,res, ADDR ResStr
         Invoke StdOut,ADDR Result 
         
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

