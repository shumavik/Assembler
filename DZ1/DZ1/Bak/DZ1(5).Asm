; Template for console application
         .586
         .MODEL  flat, stdcall
         OPTION CASEMAP:NONE

Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

         .CONST
MsgExit   DB    13,10,"Press Enter to Exit",0AH,0DH,0
Enter_Msg DB    "input your string",0AH,0DH,0
         .DATA
buffer     DB    8 dup(?)
Str_Enter  DB    38 dup(?) ;буфер для ввода строки
Result     DD    37 dup(?)
Res_Str    DB    16 dup(?) ;буфер для вывода результата
no         DB    "no"
yes        DB    "yes"
Perenos     DB    13,10
         .DATA?
inbuf    DB    100 DUP (?)
kol      dword   ?
         .CODE
Start:
         
         cld
         mov ECX,0
         
         Invoke StdOut,ADDR Enter_Msg 
         Invoke StdIn, ADDR Str_Enter,LengthOf Str_Enter
         Invoke StripLF,ADDR Str_Enter
         
         lea EDI,Str_Enter
         mov ECX,38
         mov AL,0
         XOR EBX,EBX
         
         
         ;repne scasb            ; поиск конца строки
         
         ;mov AX,38              ; в AX размер буфера
         ;sub AX,CX              ; в AX размер строки + 1
         ;mov CX,AX              
         ;dec CX                 ; в CX длина строки
                 
         ;lea EDI,Str_Enter      ; адрес строки
         ;mov AL,' '             ; через AL идет сравнение с пробелом 
         ;mov EBX,0              ; количество слов
         ;cld
         
         ;cycle1: cmp CX,0       ; Нашли конец строки
          ;       je kon         ; переходим в конец
           ;      mov DX,0       ; считаем количество символов в слове
         
         ;cycle2: scasb          ; поиск пробела
          ;       je consl       ; 
           ;      
            ;     inc DX         ; увеличиваем буквы
             ;    dec CX         ; уменьшаем длину строки
              ;   jmp cycle2     ; переходим на поиск пробела 
                                ; в DX длина слова
                                ; в CX количество оставшихся в строке символов 
         ;consl:  cmp DX,8       ; слово из 8 букв?
          ;       jg prod       ; если букв > 8
           ;      inc BX         
            
         ;prod:   dec CX         ; уменьшаем на 1 из-за пробела между словами
          ;       jmp cycle1     ; переходим на начало поиска конца строки и слов
         
         
         
         
         
         
         
         lea EDI,Str_Enter      ; адрес строки
         mov AL,' '             ; через AL идет сравнение с пробелом 
         mov EBX,0              ; количество слов
         cld
         
         cycle1: cmp CX,0       ; Нашли конец строки
                 je kon         ; переходим в конец
                 mov DX,0       ; считаем количество символов в слове
         
         cycle2: 
                 
                 scasb          ; поиск пробела
                 push AX
                 mov AL,DL
                 
                 
                 je consl       ; 
                 
                 inc DX         ; увеличиваем буквы
                 dec CX         ; уменьшаем длину строки
                 jmp cycle2     ; переходим на поиск пробела 
                                ; в DX длина слова
                                ; в CX количество оставшихся в строке символов 
         consl:  cmp DX,8       ; слово из 8 букв?
                 jg prod       ; если букв > 8
                 inc BX         
            
         prod:   dec CX         ; уменьшаем на 1 из-за пробела между словами
                 jmp cycle1     ; переходим на начало поиска конца строки и слов
         
         
         
                        
               
         kon:  
         mov kol,EBX
                
               
            
         
         
         
         XOR    EAX,EAX
        
         
         
         Invoke dwtoa,kol,ADDR Result      
         Invoke StdOut,ADDR Result
         
         Invoke StdOut, ADDR Perenos
         Invoke StdOut,ADDR Str_Enter
         
         Invoke StdOut,ADDR MsgExit
         Invoke StdIn,ADDR inbuf,LengthOf inbuf		
	
         Invoke ExitProcess,0
         End    Start

