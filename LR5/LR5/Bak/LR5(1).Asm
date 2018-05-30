         .586
         .MODEL  flat
         
         .DATA
         i     dword 0          ; общее смещение
         position dword 0       ; смещение на начало нового слова 
         current dword 0
         glasn DB "aeiouy"      ; строка с гласными
         .CODE
		 RESULT  proto c str2:ptr byte;Прототип внешней процедуры вывода результата         
    public  _GLASDEL;Объявление внутреннего имени процедуры
_GLASDEL proc
	  ;начало пролога
        PUSH EBP
        MOV  EBP,ESP
        PUSH EBX
        PUSH EDI
        PUSH ESI
        ;конец пролога
      
        
        
        MOV EDI,[EBP+8]    ;загружаем адрес строки в edi
        MOV ESI,[EBP+12]    ;загружаем адрес массива с номерами нужных слов
        MOV ECX,[EBP+16]   ; загружаем длину строки
        MOV EBX,0       ;обнуляем счетчик номера слова
        MOV EDX,0       ;обнуляем счетчик текущей длины слова
        mov position,-1  ;position всегда будет указывать на начало нового слова
        CLD         
        
cic1:   push EAX        ; корректируем position на новое слово
        dec i               ; изначально в position установиться 0
        mov EAX,i
        inc i       
        mov position,EAX
        inc position
        pop EAX
        CMP ECX,0       ;цикл с предусловием конец строки достигнут?
        JE  con         ;если да, переход на вывод результатов
        MOV EAX,' '     ;загружаем в al пробел для поиска
        MOV EDX,0       ;обнуляем счетчик текущей длины слова
        INC EBX         ;увеличиваем счетчик номера слова
        
cic2:   dec ECX         ;уменьшаем счетчик оставшейся длины слова
        push ECX
        mov ECX,i
        mov AL,[EDI+ECX]        ; в i записываетс текущее смещение для всей строки
        inc i
        pop ECX
        cmp AL,' '           ;проверяем очередной символ на пробел
        JE  consl       ;если пробел - переходим на сравнение слова с номером
        INC EDX         ;если нет - увеличиваем длину слова
        CMP ECX,0       ;конец строки достигнут?
        JE  consl2      ;если да, проверяем последнее слово
        JMP cic2        ;переход на следующую итерацию цикла поиска пробела
              
consl2: DEC EDX;уменьшение счетчика длины слова (частный случай)                   
consl:  
        CMP [ESI],EBX    ;сравниваем номер слова с номером в массиве
        JE  prod         ;если одинаковы - начинаем удалять гласные
        JMP cic1
        



prod:;подготовка к удалению гласных
        push ESI  
        PUSH EBX
        push EDX
        push ECX
        
        mov ECX,0           
        dec i               ; в i смещение для конца слова
        mov EDX,position      ; в EDX смещение для начала нового слова
        mov ESI,EDI             ; В ESI загружаем исходную строку 
        add ESI,EDX               ; Смещаем ESI для на начало нового слова  
        
        dec EDX                 
   
kont:   mov EBX,0               ; в EBX смещение для поиска гласной 
        inc EDX                     ; в строке glasn
        mov AL,[glasn+EBX]       ; в AL первую гласную из строки glasn
        
        cmp EDX,i               ; проверка на последнее слово и символ
        je prepare              ;Если истинна то выходим из удаления
        
cycle1:  
        cmp AL,[EDI+EDX]        ; сравнение текущего символа с гласной
        je glas                 ; Если гласная то переходим непосредственно к удалению
        
        cmp EDX,i               ; проверка на последнее слово и символ
        je prepare
        
        cmp EBX,5               ; если достигнут конец в строке glasn
        je kont                 ; начинаем сравнения со слудующим символом в EDI

        

             
cycle2:   inc EBX               ; увеличиваем смещение в строке glasn
repcycle: mov AL,[glasn+EBX]    ; В AL новая гласная для сравнения с текущим символом EDI
          jmp cycle1            ; повторяем условие сравнения с гласной
        
        
                
glas:   
        mov AL,[EDI+EDX]      ; в AL текущий символ  
        cmp AL,[glasn+EBX]     ; повторно сравниваем с гласной
        je glasafter             ; если гласная то удаляем
        dec i                       ; если конец слова то выходим
        cmp i,EDX
        je prepare
        
        
        mov [EDI+EDX],AL        ; если не гласная оставлям символ в EDI
        cmp EDX,i               ; проверка на конец слова
        je prepare
        inc i                   
        jmp glas                ; возвращаемся на метку glas

glasafter:   ; удаление и проверка на подряд идущие гласные
               cmp EDX,i        
        je prepare
             mov AL,' '
             mov [EDI+EDX],AL   ; помещаем пробел вместо гласной
            mov EBX,0           ; смещение на начало строки glasn
         
             inc EDX            ; увеличиваем смещение для EDI
             jmp repcycle       ; повтоорно ищем следующую гласную
        
prepare:                    
         mov AL,[EDI+EDX]   
         cmp AL,[glasn+EBX] ; переход на последнюю замену
         je lastzam
         cmp EBX,5          ; если конец в строки glasn, то выходим
         je final
         inc EBX            ; переходим к следующей гласной
         jmp prepare        ; сравниваем с новой гласной
         
lastzam: 
            mov AL,' '          ; удаляем гласную
            mov [EDI+EDX],AL
         
         
final:   pop ECX       ; подготовка к выходу из удаления
         pop EDX
         pop EBX
         pop ESI
         add ESI,4      ; В ESI номер слова, в котором следует удалить гласные
         inc i
           jmp cic1     ; возвращаемся на поиск конца нового слова
        
        
odin:  mov position,0   ; Если ввели один символ
       jmp prod
      


con:;Передача управления в С++ и эпилог
        
        cmp position,1   ; Доп проверка на гласную 
        je odin             ; если слово всего одно
        
        

        Invoke RESULT,[EBP+8]
        POP ESI
        POP EDI
        POP EBX
        POP EBP 
        ret
_GLASDEL endp
	End

