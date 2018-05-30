         .586
         .MODEL  flat
         
         .DATA
         i     dword 0
         position dword 0
         current dword 0
         glasn DB "aeiouy"
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
        mov position,-1
        CLD
        
cic1:   push EAX
        dec i
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
        mov AL,[EDI+ECX]
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
        JE  prod         ;если одинаковы - начинаем менять порядок букв
        JMP cic1
        



prod:;подготовка к удалению гласных
        push ESI  
        PUSH EBX
        push EDX
        push ECX
        
        mov ECX,0
        dec i
        mov EDX,position
        mov ESI,EDI      
        add ESI,EDX
        
        dec EDX
   
kont:   mov EBX,0
        inc EDX        
        mov AL,[glasn+EBX]
        
        cmp EDX,i
        je prepare
        
cycle1:  
        cmp AL,[EDI+EDX]
        je glas
        
        cmp EDX,i
        je prepare
        
        cmp EBX,5
        je kont   

        

             
cycle2:   inc EBX 
repcycle: mov AL,[glasn+EBX]
          jmp cycle1
        
        
                
glas:   
        mov AL,[EDI+EDX]
        cmp AL,[glasn+EBX]
        je glasafter
        dec i
        ;cmp i,EDX
        ;je prepare
        
        
        mov [EDI+EDX],AL
        cmp EDX,i
        je prepare
        inc i
        jmp glas

glasafter:   
               
             mov AL,' '
             mov [EDI+EDX],AL
            mov EBX,0
         
             inc EDX
             jmp repcycle
        
prepare: 
         mov EBX,0
         mov AL,[EDI+EDX]
         
         cmp EBX,5
         je nofinal
         cmp AL,[glasn+EBX]
         je final
         inc EBX 
         jmp prepare
         
         
final:   mov AL,' '
         mov [EDI+EDX],AL


nofinal: pop ECX
         pop EDX
         pop EBX
         pop ESI
         add ESI,4
         inc i
           jmp cic1    
        
        
odin:  mov position,0 
       jmp prod
      


con:;Передача управления в С++ и эпилог
        
        cmp position,1
        je odin
        
        

        Invoke RESULT,[EBP+8]
        POP ESI
        POP EDI
        POP EBX
        POP EBP 
        ret
_GLASDEL endp
	End

