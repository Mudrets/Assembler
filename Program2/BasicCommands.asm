format PE console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        formatStr db '%s', 0
        formatNum db '%d', 0

        name rd 2
        age rd 1

        wn db 'What is your name? ', 0
        ho db 'How old are you? ', 0
        hello db 'Hello %s, %d', 0

        NULL = 0

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'

section '.code' code readable executable

        start:
                push wn
                call [printf]

                push name
                push formatStr
                call [scanf]

                push ho
                call [printf]

                push age
                push formatNum
                call [scanf]

                push [age]
                push name
                push hello
                call [printf]

                call [getch]

                push NULL
                call ExitProcess