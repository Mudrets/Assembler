format PE console

include 'win32a.inc'

entry start

section '.data' data readable writable

        strVecSize      db 'size of vector?', 10, 0
        strIncorSize    db 'Incorrect size of vector = %d', 10, 0
        strVecElemI     db '[%d]? ', 0
        strScanInt      db '%d', 0
        strVecElemOut   db '[%d] = %d', 10, 0
        strVecBracketS  db '[', 0
        strVecBracketE  db ']', 10, 0
        strDigit        db '%d ', 0
        strArrA         db 'Array A: ', 0
        strArrB         db 'Array B: ', 0

        arrA_size       dd 0
        arrB_size       dd 0
        arrA            rd 10
        arrB            rd 10
        min             dd ?
        i               dd ?
        tmp             dd ?
        tmpB            dd ?
        stackPointer    dd ?
        a               dd ?

        NULL = 0


section '.code' code readable executable

;____________________READ_ARR_______________
        readArr:
                ;��������� �������� ��������� � �����
                ;����� �� ��������� ��
                push eax
                mov  eax, esp ;���������� �������� ��������� ����� � ������� eax
                push ecx
                push edx

                xor  ecx, ecx ;ecx = 0
                mov  edx, [ss:eax+8+0] ; mov edx, arrA (�������� ������ �� ������
                ;�� ����� ��������� � ������������������ �������� 8 (�� ���� ����������
                ;�� ��� ������� ����))

        inputArrLoop:
                ;��������� �������� ��������� � ���������� �� �������
                mov  [stackPointer], eax
                mov  [tmp], edx

                cmp  ecx, [ss:eax+8+4]
                jge  endInputArrLoop

                ;��������� �������
                mov  [i], ecx
                push ecx
                push strVecElemI
                call [printf]
                ;����� ������ printf �������� ��������� ��������

                push [tmp]
                push strScanInt
                call [scanf]
                ;��� ��� ���� ��������

                ;����� ������ printf � scanf �������� �������� �������
                ;��������������� ������ �������� ��������� �� ����������
                ;� ������� �� �������� �������� �� �����
                mov  ecx, [i]
                inc  ecx
                mov  edx, [tmp]
                add  edx, 4
                mov  eax, [stackPointer]
                jmp  inputArrLoop

        endInputArrLoop:
                ;�������� ��������� ���� �� ��� ������� �����
                sub  eax, 8
                mov  esp, eax
                ;���������� ��������� �� �������� �� �������������
                ;���������
                pop  edx
                pop  ecx
                pop  eax

        ret
;___________________END_READ_ARR____________

;_____________________FIND_MIN______________

        findMin:
                ;��������� �������� ��������� � �����
                ;����� �� ��������� ��
                push eax
                mov  eax, esp
                push ecx
                push edx
                push ebx

                xor  ecx, ecx ;ecx = 0
                mov  edx, [ss:eax+8+0] ; mov ebx, arrA (���������� � edx ������ �� ������)
                mov  ebx, [edx] ;���������� � ebx arr[0]
                mov  [min], ebx ;��������� arr[0] � �������

        findMinLoop:
                ;��������� �������� ��������� � ���������� �� �������
                mov  [stackPointer], eax
                mov  [tmp], edx
                mov  [i], ecx

                cmp  ecx, [ss:eax+8+4]
                jge  endFindMinLoop

                ;if ebx > [edx]
                cmp  ebx, [edx]
                jle  findMinLoopElse

                mov  ebx, [edx]
                mov  [min], ebx ;��������� ��������

        findMinLoopElse:
                mov  edx, [tmp]
                add  edx, 4
                mov  ecx, [i]
                inc  ecx

                jmp  findMinLoop


        endFindMinLoop:
                ;�������� ��������� ����� �� 3 ������� �����
                sub  eax, 12
                mov  esp, eax
                ;���������� ��������� �� �������� �� �������������
                ;���������
                pop  ebx
                pop  edx
                pop  ecx
                pop  eax

        ret
;___________________END_FIND_MIN____________


;______________CREATE_ARR_WITHOUT_MIN_______

        createArrWithoutMin:
                ;��������� �������� ��������� � �����
                ;����� �� ��������� ��
                push eax
                mov  eax, esp ;���������� �������� ��������� ����� � ������� eax
                push ecx
                push edx
                push ebx

                mov  edx, [ss:eax+8+4] ;mov edx, arrA (���������� � edx ������ �� ������ ������)
                mov  ebx, [ss:eax+8+0] ;mov ebx, arrB (���������� � edx ������ �� ������ ������)

                mov  ecx, [ss:eax+8+8] ;���������� � ecx ���������� ��������� ������� �������

                ;������� ������� � �������
                push ecx ;���������� ��������� ������� �������
                push edx ;������ �� ������ ������
                call findMin

                xor  ecx, ecx ;ecx = 0

        arrWithoutMinLoop:
                ;��������� �������� ��������� � ���������� �� �������
                mov  [tmp], edx
                mov  [tmpB], ebx
                mov  [i], ecx

                ;��������� �� ��������� �� ��� ������� (� ������ ������ ������� ecx)
                ;������ �������
                cmp  ecx, [ss:eax+8+8]
                jge  endArrWithoutMinLoop

                ;�������� �� �������
                mov  ecx, [min]
                cmp  [edx], ecx
                je   equalWithMin

                ;������ ������� arrA[i] � arrB
                mov  ecx, [edx]
                mov  [ebx], ecx
                mov  ebx, [tmpB]
                add  ebx, 4
                inc  [arrB_size]

        equalWithMin:
                ;�� ������ ������ ���������������
                mov  ecx, [i]
                inc  ecx
                mov  edx, [tmp]
                add  edx, 4
                jmp  arrWithoutMinLoop


        endArrWithoutMinLoop:
                ;�������� ��������� ����� �� 3 ������� �����
                sub  eax, 12
                mov  esp, eax

                ;���������� ��������� �� �������� �� �������������
                ;���������
                pop  ebx
                pop  edx
                pop  ecx
                pop  eax

        ret

;____________END_CREATE_ARR_WITHOUT_MIN_____


;____________________PRINT_ARR______________

        printArr:

                ;��������� �������� ��������� � �����
                push eax
                mov  eax, esp
                push ecx
                push edx

                ;��������� ������� eax � ���������� �� �������
                mov  [stackPointer], eax

                push strVecBracketS
                call [printf]

                ;� ��� �� ����� �������, printf �������� ��� ��� �������
                ;� ��� �� ��� ���������������
                mov  eax, [stackPointer]

                xor  ecx, ecx ;ecx = 0
                mov  edx, [ss:eax+8+0] ;mov edx, arr (���������� � edx ������ �� ������)

        printArrLoop:
                ;��������� �������� ��������� � ����������
                mov  [tmp], edx
                mov  [i], ecx

                cmp  ecx, [ss:eax+8+4];���������� ����� ������� � ecx, ������ �������� ��� �������
                jge  endPrintArrLoop

                mov  ecx, [edx]
                push ecx
                push strDigit
                call [printf]

                ;����� �� ��������������� �������� ��������� ��� ���
                ;����� printf ��� �����������
                mov  edx, [tmp]
                add  edx, 4
                mov  ecx, [i]
                inc  ecx
                mov  eax, [stackPointer]
                jmp  printArrLoop

        endPrintArrLoop:
                ;������� ������ ������
                push strVecBracketE
                call [printf]

                ;��������������� �������� �������� eax ����� printf
                mov  eax, [stackPointer]

                ;�������� ��������� ���� �� ��� ������� �����
                sub  eax, 8
                mov  esp, eax
                ;���������� ��������� �� �������� �� �������������
                ;���������
                pop  edx
                pop  ecx
                pop  eax

        ret

;__________________END_PRINT_ARR____________

;______________________MAIN_________________
        start:
                push strVecSize
                call [printf]

                push arrA_size
                push strScanInt
                call [scanf]

                ;If (arrA_size <= 0) { //errorCode }
                ;else { //succesCode }
                mov  eax, [arrA_size]
                cmp  eax, 0
                jg  successInput

                ;Incorrect arr size
                push [arrA_size]
                push strIncorSize
                call [printf]

                jmp finish

        successInput:
                ;��������� ������ �
                push [arrA_size]
                push arrA
                call readArr

                ;������� ������ B ��� ������������ ��������
                push [arrA_size]
                push arrA
                push arrB
                call createArrWithoutMin

                ;������� �������
                push strArrA
                call [printf]

                push [arrA_size]
                push arrA
                call printArr

                push strArrB
                call [printf]

                push [arrB_size]
                push arrB
                call printArr

        finish:
                call [getch]

                push NULL
                call ExitProcess
;_________________END_MAIN_________________

section '.idata' data readable import

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'