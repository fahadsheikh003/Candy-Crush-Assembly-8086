                                    ;//////////////////////////////
                                    ;Fahad Waheed 20i0651
                                    ;Ubaidullah 20i0541
                                    ;Ghulam Murtaza 20i0957
                                    ;/////////////////////////////


;0 represents spacer
;1 represents gift candy
;2 represents lollipop
;3 represents icecream
;4 represents diamond (logic bomb)
;9 represents empty location
;7 represents blocker

;Macro to print strings
msgprint MACRO string
    pusha

    lea dx,string
    mov ah,09h
    int 21h

    popa
ENDM

;Source code
.model small
.stack 100h

;Data declaration
.data

    titlemsg1 db "  ____                _          ____                _     $"
    titlemsg2 db " / ___|__ _ _ __   __| |_   _   / ___|_ __ _   _ ___| |__  $"
    titlemsg3 db "| |   / _` | '_ \ / _` | | | | | |   | '__| | | / __| '_ \ $"
    titlemsg4 db "| |__| (_| | | | | (_| | |_| | | |___| |  | |_| \__ \ | | |$"
    titlemsg5 db " \____\__,_|_| |_|\__,_|\__, |  \____|_|   \__,_|___/_| |_|$"
    titlemsg6 db "                        |___/                              $"

    rulemsg1 db " ___   _   _   _      ___   ___ $"
    rulemsg2 db "| _ \ | | | | | |    | __| / __|$"
    rulemsg3 db "|   / | |_| | | |__  | _|  \__ \$"
    rulemsg4 db "|_|_\  \___/  |____| |___| |___/$"

    namemsg db "Enter name: $"
    _name db 20 dup ('$')
    
    rule1 db "1. Swap the candies to get them crushed.$"
    rule2 db "2. If three candies match they get crushed.$"
    rule3 db "3. If 3 candies match they form a color bomb.$"
    rule4 db "4. Swap color bomb with a candy to remove all its occurance.$"
    rule5 db "5. Minimum score to pass a level is 50.$"
    ruleagree db "Press enter if you agree..$"
    levelmsg db "Level: $"
    scoremsg db "Score: $"
    movemsg db "Moves: $"
    gameovermsg db "G A M E  O V E R$"
    youwinmsg db "Y O U  W I N$"
    selectlevelmsg db "Please Select Level:$"
    level1msg db "Press 1 for Level 1..$"
    level2msg db "Press 2 for Level 2..$"
    level3msg db "Press 3 for Level 3..$"
    levelchoicemsg db "Please Press button according to your desire..$" 
    continuemsg db "Press enter to continue..$"


;Creating a grid of 7x7 
    GRID db 49 dup (1)          ;array to hold the entries

;Variables for passing coordinates
    X1 dw ?
    X2 dw ?
    Y1 dw ?
    Y2 dw ?
    temp dw ?
    temp2 dw ?

    level dw 0
    moves dw 0
    scores dw 0
    levelchoice dw 0

    button dw 0
    MouseX dw 0
    MouseY dw 0

    oldindexX dw 0
    oldindexY dw 0
    newindexX dw 0
    newindexY dw 0

    gameovercheck dw 0

    count dw 0
    X dw 0
    Y dw 0
    
    flag dw 0
    nextlevel dw 0

    detonatedelement db -1

.code

;MAIN PROC
main PROC
    mov ax,@data
    mov ds,ax

    ;DRIVER CODE
    call titlepage
    call rulepage
    
    call playgame

    ;call levelone
    ;call leveltwo
    ;call levelthree

    mov ah,0
    int 16h

    ;Exiting
    exit:
        mov ah,4ch
        int 21h
main ENDP

playgame PROC
    call levelinput

    .if levelchoice == 1
    L1:
        call levelone
        .if gameovercheck == 1
            call gameover
        .elseif nextlevel == 1
            jmp L2
        .endif

    .elseif levelchoice == 2
    L2:
        call leveltwo
        .if gameovercheck == 1
            call gameover
        .elseif nextlevel == 1
            jmp L3
        .endif

    .elseif levelchoice == 3
    L3:
        call levelthree 
        .if gameovercheck == 1
            call gameover
        .elseif nextlevel == 1
            call youwin
        .endif
    .endif

    ret
playgame ENDP

youwin PROC uses ax bx dx
    mov bh,00h
    mov bl,00h
    push bx
    call clearscreen

    mov X1,0
    mov X2,640
    mov Y1,0
    mov Y2,480

    call createborders

    mov ah, 02h
    mov bh, 0
    mov dh, 12 ;Row Number 
    mov dl, 30 ;Column Number 
    int 10h

    msgprint youwinmsg

    mov ah, 02h
    mov bh, 0
    mov dh, 20 ;Row Number 
    mov dl, 28 ;Column Number 
    int 10h

    msgprint continuemsg

    mov ah,01h
    int 21h

    mov ah,0
    int 16h

    ;Exiting
    mov ah,4ch
    int 21h

    ret
youwin ENDP

gameover PROC uses ax bx dx
    mov bh,00h
    mov bl,00h
    push bx
    call clearscreen

    mov X1,0
    mov X2,640
    mov Y1,0
    mov Y2,480

    call createborders

    mov ah, 02h
    mov bh, 0
    mov dh, 12 ;Row Number 
    mov dl, 30 ;Column Number 
    int 10h

    msgprint gameovermsg

    mov ah, 02h
    mov bh, 0
    mov dh, 20 ;Row Number 
    mov dl, 28 ;Column Number 
    int 10h

    msgprint continuemsg

    mov ah,01h
    int 21h

    mov ah,0
    int 16h

    ;Exiting
    
    mov ah,4ch
    int 21h

    ret
gameover ENDP

levelinput PROC uses ax bx dx

    AGAINLEVEL:
        mov bh,00h
        mov bl,00h
        push bx
        call clearscreen

        mov X1,0
        mov X2,640
        mov Y1,0
        mov Y2,480

        call createborders

        mov ah, 02h
        mov bh, 0
        mov dh, 3 ;Row Number 
        mov dl, 4 ;Column Number 
        int 10h

        msgprint selectlevelmsg

        mov ah, 02h
        mov bh, 0
        mov dh, 5 ;Row Number 
        mov dl, 4 ;Column Number 
        int 10h

        msgprint level1msg

        mov ah, 02h
        mov bh, 0
        mov dh, 7 ;Row Number 
        mov dl, 4 ;Column Number 
        int 10h

        msgprint level2msg

        mov ah, 02h
        mov bh, 0
        mov dh, 9 ;Row Number 
        mov dl, 4 ;Column Number 
        int 10h

        msgprint level3msg

        mov ah, 02h
        mov bh, 0
        mov dh, 11 ;Row Number 
        mov dl, 4 ;Column Number 
        int 10h

        msgprint levelchoicemsg

        mov ah,01h
        int 21h

        sub al,'0'

        .if (al > 0 && al < 4)
            mov byte ptr levelchoice, al
        .else
            jmp AGAINLEVEL
        .endif 

    ret
levelinput ENDP

levelone PROC uses ax bx si
    call randomvalueinitializer
    mov moves,15
    mov level,1

    mov gameovercheck,0
    mov nextlevel,0

    .while (gameovercheck == 0 && nextlevel == 0)
    Top:
        mov flag,0
        mov bh,0
        mov bl,00h
        push bx
        call clearscreen

        mov X1,0
        mov X2,640
        mov Y1,0
        mov Y2,480

        call createborders

        call printgrid
        call nameandleveldisplay
        call initialboard

        call showmouse

        Againoldindex:
            call mouseInput

            mov oldindexX,0
            push oldindexX

            mov oldindexY,0
            push oldindexY

            call getindex

            pop oldindexY
            pop oldindexX

            .if oldindexY == -1
                jmp Againoldindex
            .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call createlivecell

        Againnewindex:
            call mouseInput

            mov newindexX,0
            push newindexX

            mov newindexY,0
            push newindexY

            call getindex

            pop newindexY
            pop newindexX

            .if newindexY == -1
                jmp Againnewindex
            .endif

        mov ax,0
        push ax

        call checkadjacent

        pop ax

        .if ax == -1
            jmp Top
        .endif

        mov cx,newindexX
        mov X,cx

        mov cx,newindexY
        mov Y,cx

        call createlivecell

        call swapping

        call colorbombcheck

        .if (count > 1)
            mov cx,count
            add scores,cx

            jmp skipchecks
        .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call checkhorizontal

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,oldindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,oldindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        call checkvertical

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,oldindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,oldindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        mov cx,newindexX
        mov X,cx

        mov cx,newindexY
        mov Y,cx

        call checkhorizontal

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,newindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,newindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        call checkvertical

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,newindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,newindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        .if flag == 0
            call swapping
            jmp Top
        .endif

        skipchecks:
            dec moves

            call updateGrid

            .if moves == 0
                .if (scores >= 50)
                    mov nextlevel, 1
                .else
                    mov gameovercheck, 1
                .endif
            .endif
    .endw

    ret
levelone ENDP

leveltwo PROC uses ax bx cx dx si
    call randomvalueinitializer
    mov moves,15
    mov level,2
    mov scores, 0

    mov byte ptr GRID[0],7
    mov byte ptr GRID[3],7
    mov byte ptr GRID[6],7
    mov byte ptr GRID[7],7
    mov byte ptr GRID[13],7
    mov byte ptr GRID[21],7
    mov byte ptr GRID[27],7
    mov byte ptr GRID[35],7
    mov byte ptr GRID[41],7
    mov byte ptr GRID[42],7
    mov byte ptr GRID[45],7
    mov byte ptr GRID[48],7

    mov gameovercheck,0
    mov nextlevel,0

    .while (gameovercheck == 0 && nextlevel == 0)
    Top1:
        mov flag,0

        mov bh,0
        mov bl,00h
        push bx
        call clearscreen

        mov X1,0
        mov X2,640
        mov Y1,0
        mov Y2,480

        call createborders

        call printgrid
        call nameandleveldisplay
        call initialboard

        call showmouse

        Againoldindex1:
            call mouseInput

            mov oldindexX,0
            push oldindexX

            mov oldindexY,0
            push oldindexY

            call getindex

            pop oldindexY
            pop oldindexX

            .if oldindexY == -1
                jmp Againoldindex1
            .endif

            mov cx,oldindexX
            mov X,cx

            mov cx,oldindexY
            mov Y,cx

            mov cx,0
            push cx

            call blockercheck

            pop cx 

            .if cx == 1
                jmp Againoldindex1
            .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call createlivecell

        Againnewindex1:
            call mouseInput

            mov newindexX,0
            push newindexX

            mov newindexY,0
            push newindexY

            call getindex

            pop newindexY
            pop newindexX

            .if newindexY == -1
                jmp Againnewindex1
            .endif

            mov cx,newindexX
            mov X,cx

            mov cx,newindexY
            mov Y,cx

            mov cx,0
            push cx

            call blockercheck

            pop cx 

            .if cx == 1
                jmp Againoldindex1
            .endif

        mov ax,0
        push ax

        call checkadjacent

        pop ax

        .if ax == -1
            jmp Top1
        .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call createlivecell

        call swapping

        call colorbombcheck

        .if (count > 1)
            mov cx,count
            add scores,cx

            jmp skipchecks1
        .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call checkhorizontal

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,oldindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,oldindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        call checkvertical

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,oldindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,oldindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        mov cx,newindexX
        mov X,cx

        mov cx,newindexY
        mov Y,cx

        call checkhorizontal

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,newindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,newindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        call checkvertical

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,newindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,newindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        .if flag == 0
            call swapping
            jmp Top1
        .endif

        skipchecks1:
            dec moves

            call updateGrid

            .if moves == 0
                .if (scores >= 50)
                    mov nextlevel, 1
                .else
                    mov gameovercheck, 1
                .endif
            .endif
    .endw

    ret
leveltwo ENDP

levelthree PROC uses ax bx cx dx si
    call randomvalueinitializer
    mov moves,15
    mov level,3
    mov scores, 0

    mov ax,3
    mov ch,7
    mul ch
    mov si,ax

    mov bx,0
    .while (bx<7)
        mov byte ptr GRID[si + bx],7
        inc bx
    .endw

    mov bx,3
    mov temp,0

    .while (temp<7)
        mov ax,temp
        mov ch,7
        mul ch
        mov si,ax

        mov byte ptr GRID[si + bx],7

        inc temp
    .endw

    mov gameovercheck,0
    mov nextlevel,0

    .while (gameovercheck == 0 && nextlevel == 0)
    Top2:
        mov flag,0

        mov bh,0
        mov bl,00h
        push bx
        call clearscreen

        mov X1,0
        mov X2,640
        mov Y1,0
        mov Y2,480

        call createborders

        call printgrid
        call nameandleveldisplay
        call initialboard

        call showmouse

        Againoldindex2:
            call mouseInput

            mov oldindexX,0
            push oldindexX

            mov oldindexY,0
            push oldindexY

            call getindex

            pop oldindexY
            pop oldindexX

            .if oldindexY == -1
                jmp Againoldindex2
            .endif

            mov cx,oldindexX
            mov X,cx

            mov cx,oldindexY
            mov Y,cx

            mov cx,0
            push cx

            call blockercheck

            pop cx 

            .if cx == 1
                jmp Againoldindex2
            .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call createlivecell

        Againnewindex2:
            call mouseInput

            mov newindexX,0
            push newindexX

            mov newindexY,0
            push newindexY

            call getindex

            pop newindexY
            pop newindexX

            .if newindexY == -1
                jmp Againnewindex2
            .endif

            mov cx,newindexX
            mov X,cx

            mov cx,newindexY
            mov Y,cx

            mov cx,0
            push cx

            call blockercheck

            pop cx 

            .if cx == 1
                jmp Againoldindex2
            .endif

        mov ax,0
        push ax

        call checkadjacent

        pop ax

        .if ax == -1
            jmp Top2
        .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call createlivecell

        call swapping

        call colorbombcheck

        .if (count > 1)
            mov cx,count
            add scores,cx

            jmp skipchecks2
        .endif

        mov cx,oldindexX
        mov X,cx

        mov cx,oldindexY
        mov Y,cx

        call checkhorizontal

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,oldindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,oldindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        call checkvertical

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,oldindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,oldindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        mov cx,newindexX
        mov X,cx

        mov cx,newindexY
        mov Y,cx

        call checkhorizontal

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,newindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,newindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        call checkvertical

        mov cx,count
        .if cx >= 3
            add scores,cx
            mov flag,1
        .endif

        .if (cx>=3)
            mov ax,newindexX
            mov bl,7
            mul bl
            mov si,ax

            mov bx,newindexY
            mov byte ptr GRID[si + bx], 4
        .endif

        .if flag == 0
            call swapping
            jmp Top2
        .endif

        skipchecks2:
            dec moves

            call updateGrid

            .if moves == 0
                .if (scores >= 50)
                    mov nextlevel, 1
                .else
                    mov gameovercheck, 1
                .endif
            .endif
    .endw

    ret
levelthree ENDP

colorbombcheck PROC uses ax bx dx si
    mov count,1
    mov ax,oldindexX
    mov bl,7
    mul bl
    mov si,ax

    mov bx,oldindexY

    .if (GRID[si + bx] == 4)
        mov byte ptr GRID[si + bx],9
        mov ax,newindexX
        mov bl,7
        mul bl
        mov si,ax

        mov bx,newindexY

        mov bh,GRID[si + bx]
        mov detonatedelement, bh

        call detonate
        jmp colorbombreturn
    .endif

    mov ax,newindexX
    mov bl,7
    mul bl
    mov si,ax

    mov bx,newindexY

    .if (GRID[si + bx] == 4)
        mov byte ptr GRID[si + bx],9
        mov ax,oldindexX
        mov bl,7
        mul bl
        mov si,ax

        mov bx,oldindexY

        mov bh,GRID[si + bx]
        mov detonatedelement, bh

        call detonate

    .endif

    colorbombreturn:
        ret
colorbombcheck ENDP

blockercheck PROC uses ax bx cx si bp
    mov bp,sp

    mov ax,X
    mov ch,7
    mul ch
    mov si,ax

    mov bx,Y

    .if GRID[si + bx] == 7
        mov [bp + 12],1
    .else
        mov [bp + 12],-1
    .endif

    ret
blockercheck ENDP

checkhorizontal PROC uses ax bx dx si
    
    mov count,1

    mov ax,X
    mov dl,7
    mul dl

    mov si,ax

    mov bx,Y

    mov dl,GRID[si + bx]

    dec bx

	.while (bx >= 0)
        .if GRID[si + bx] == dl
            inc count
        .else
            .break
        .endif
        dec bx
    .endw
	
    mov bx,Y
    inc bx

    .while (bx < 7)
        .if GRID[si + bx] == dl
            inc count
        .else
            .break
        .endif
        inc bx
    .endw

    .if (count >= 3)

        mov bx,Y
        dec bx

        .while (bx >= 0)
            .if GRID[si + bx] == dl
                mov GRID[si + bx],9
            .else
                .break
            .endif
            dec bx
        .endw
        
        mov bx,Y
        inc bx

        .while (bx < 7)
            .if GRID[si + bx] == dl
                mov GRID[si + bx],9
            .else
                .break
            .endif
            inc bx
        .endw

        mov bx,Y
        mov GRID[si + bx],9

    .endif

    ret
checkhorizontal ENDP

checkvertical PROC uses ax bx cx dx si
    mov count,1

    mov bx,Y
    mov cl,7

    mov ax,X
    mul cl
    mov si,ax

    mov ch,GRID[si + bx];element

    mov dx,X
    dec dx

	.while (dx >= 0)
        mov ax,dx
        mul cl
        mov si,ax
        .if GRID[si + bx] == ch
            inc count
        .else
            .break
        .endif
        dec dx
    .endw
	
    mov dx,X
    inc dx

    .while (dx < 7)
        mov ax,dx
        mul cl
        mov si,ax
        .if GRID[si + bx] == ch
            inc count
        .else
            .break
        .endif
        inc dx
    .endw

    .if (count >= 3)

        mov dx,X
        dec dx

        .while (dx >= 0)
            mov ax,dx
            mul cl
            mov si,ax
            .if GRID[si + bx] == ch
                mov GRID[si + bx],9
            .else
                .break
            .endif
            dec dx
        .endw
        
        mov dx,X
        inc dx

        .while (dx < 7)
            mov ax,dx
            mul cl
            mov si,ax
            .if GRID[si + bx] == ch
                mov GRID[si + bx],9
            .else
                .break
            .endif
            inc dx
        .endw

        mov ax,X
        mul cl
        mov si,ax
        mov GRID[si + bx],9

    .endif

    ret
checkvertical ENDP

Detonate proc uses ax bx cx
	mov bx,0
    mov count,0
    mov cl,detonatedelement

    startdetonating:
        cmp bx,49
        je detonationcompleted

        .if (GRID[bx] == cl)
            mov GRID[bx],9
            inc count
        .endif

        inc bx
        jmp startdetonating
    
    detonationcompleted:
        ret
Detonate endp

swapping PROC uses ax bx cx si di
    mov ax,oldindexX
    mov bl,7
    mul bl

    add ax,oldindexY
    mov si,ax

    mov ax,newindexX
    mov bl,7
    mul bl

    add ax,newindexY
    mov di,ax

    mov cl,GRID[si]
    mov ch,GRID[di]

    mov GRID[si],ch
    mov GRID[di],cl

    ret
swapping ENDP

;returns -1 or 1
checkadjacent PROC uses ax bx cx dx bp
    mov bp,sp

    mov ax,oldindexX
    mov bx,oldindexY
    mov cx,newindexX
    mov dx,newindexY

    .if (ax == cx || bx == dx)
        sub ax,cx
        sub bx,dx

        .if (((ax == -1) || (ax == 0) || (ax == 1)) && ((bx == -1) || (bx == 0) || (bx == 1)))
            mov [bp+12],1
        
        .else
            mov [bp+12],-1
        .endif
    .else
        mov [bp+12],-1
    .endif

    mov ax,oldindexX
    mov bx,oldindexY
    mov cx,newindexX
    mov dx,newindexY
    
    .if (ax == cx && bx == dx)
        mov [bp+12],-1       
    .endif

    ret
checkadjacent ENDP

mouseInput PROC uses ax bx cx dx
    
    againmouseposition:
        mov ax, 3 ;set mouse pad
        int 33h
        
        mov mouseX, cx ;x coordinate
        mov mouseY, dx ;y coordinate
        mov button, bx
        
        mov ax,-1
        push ax
        call delay
        
        mov ax,1
        int 33h
        
        cmp button,1
        jne againmouseposition

	ret
mouseInput ENDP

showmouse PROC uses ax
    mov ah,01h
    int 33h

    ret
showmouse ENDP

;return an index X,Y
getindex PROC uses ax bx cx dx bp
    mov bp,sp

    .if ((MouseX > 175 && MouseX < 525) && (MouseY > 65 && MouseY < 415))
        mov ax,MouseX
        sub ax,175
        mov bx,50
        mov dx,0
        div bx
        mov cx,ax

        mov ax,MouseY
        sub ax,65
        mov bx,50
        mov dx,0
        div bx
        mov dx,ax

        mov [bp + 12],cx ;Y
        mov [bp + 14],dx ;X
    .else
        mov [bp + 12],-1
        mov [bp + 14],-1
    .endif

    ret
getindex ENDP

;PROC to Print Title page and takes input in user name
titlepage PROC uses ax bx dx
    ;clearing screen to set graphic mode
    mov bh,0
    mov bl,00h
    push bx
    call clearscreen

    mov X1,0
    mov X2,640
    mov Y1,0
    mov Y2,480

    call createborders

    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 4 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h

    ;Displaying title msg
    msgprint titlemsg1

    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 5 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h

    ;Displaying title msg
    msgprint titlemsg2
    
    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 6 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h

    ;Displaying title msg
    msgprint titlemsg3
    
    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 7 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h

    ;Displaying title msg
    msgprint titlemsg4
    
    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 8 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h

    ;Displaying title msg
    msgprint titlemsg5
    

    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 9 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h

    ;Displaying title msg
    msgprint titlemsg6

    ;Moving cursor
    mov ah, 02h
    mov bh, 0
    mov dh, 15 ;Row Number 
    mov dl, 10 ;Column Number 
    int 10h    

    ;Displaying namestring
    msgprint namemsg

    ;taking input in name
    call inputname

    ret
titlepage ENDP

inputname PROC uses ax si
    
    mov si,offset _name
    mov ah,01h

    takeinput:
        int 21h

        cmp al,13
        je inputcompleted

        mov byte ptr [si],al
        inc si
        jmp takeinput

    inputcompleted:
        ret
inputname ENDP

;PROC to clear screen
clearscreen PROC uses ax bx cx dx bp
    mov bp,sp

    mov ah,00h
    mov al,12h 
    int 10h

    mov ah,0bh
    mov bx,[bp+12]
    mov bh,00h
    int 10h

    ret 2
clearscreen ENDP

;PROC to display rules
rulepage PROC uses ax bx dx
    mov bh,0
    mov bl,00h
    push bx
    call clearscreen

    mov X1,0
    mov X2,640
    mov Y1,0
    mov Y2,480

    call createborders

    mov ah, 02h
    mov bh, 0
    mov dh, 3 ;Row Number 
    mov dl, 20 ;Column Number 
    int 10h

    msgprint rulemsg1

    mov ah, 02h
    mov bh, 0
    mov dh, 4 ;Row Number 
    mov dl, 20 ;Column Number 
    int 10h

    msgprint rulemsg2

    mov ah, 02h
    mov bh, 0
    mov dh, 5 ;Row Number 
    mov dl, 20 ;Column Number 
    int 10h

    msgprint rulemsg3

    mov ah, 02h
    mov bh, 0
    mov dh, 6 ;Row Number 
    mov dl, 20 ;Column Number 
    int 10h

    msgprint rulemsg4

    mov ah, 02h
    mov bh, 0
    mov dh, 9 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint rule1

    mov ah, 02h
    mov bh, 0
    mov dh, 11 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h
    
    msgprint rule2

    mov ah, 02h
    mov bh, 0
    mov dh, 13 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint rule3

    mov ah, 02h
    mov bh, 0
    mov dh, 15 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint rule4

    mov ah, 02h
    mov bh, 0
    mov dh, 17 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint rule5

    mov ah, 02h
    mov bh, 0
    mov dh, 19 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint ruleagree

    mov ah,01h
    int 21h

    .if al!=13
        mov ah,4ch
        int 21h
    .endif
    
    ret
rulepage ENDP

updateGrid PROC uses ax bx
    mov bx,0

    updatearray:
        cmp bx,49
        je arrayupdated

        .if GRID[bx] == 9
            mov ax,-1
            push ax
            call delay
            mov ax,0
            push ax
            call generateRandom
            pop ax
            mov byte ptr GRID[bx],al
        .endif
       
        inc bx
        jmp updatearray

    arrayupdated:
        ret
updateGrid ENDP

;PROC to randomly intialize values in the GRID elements
randomvalueinitializer PROC uses ax bx si
    mov si,offset GRID
    mov bx,0

    fillarray:
        cmp bx,49
        je arrayfilled

        mov ax,-1
        push ax
        call delay
        mov ax,0
        push ax
        call generateRandom
        pop ax
        mov byte ptr [si + bx],al
        inc bx
        jmp fillarray

    arrayfilled:
        ret
randomvalueinitializer ENDP

;PROC to generate random numbers
;receives no arguments and returns one random value b/w 0-2
generateRandom PROC uses ax bx dx bp
    mov bp,sp
    mov ah,00h
    int 1ah

    mov ax,dx
    mov bx,4
    mov dx,0
    div bx

    mov [bp + 10],dx
    ret
generateRandom ENDP

;PROC to delay program execution
;Used to assign truly random values
;receives an arguments and delays the program accordingly
delay PROC uses cx bp
    mov bp,sp

    mov cx,[bp+6]
    startdelay:
        cmp cx,0
        je enddelay
        dec cx
        jmp startdelay

    enddelay:
        ret 2
delay ENDP

;PROC to display GRID elements
displayarray PROC uses ax bx dx si
    mov si,offset GRID
    mov bx,0

    startloop:
        cmp bx,49
        je returndisplay

        mov dx,[si + bx]
        add dx,'0'
        mov ah,02h
        int 21h
        inc bx
        jmp startloop

    returndisplay:
        ret
displayarray ENDP

;PROC to display username and level on the game screen
nameandleveldisplay PROC uses ax dx
    mov X1,22
    mov X2,160
    mov Y1,75
    mov Y2,220

    call createsquare

    sub X1,2
    add X2,2
    sub Y1,2
    add Y2,2

    call createsquare

    mov ah, 02h
    mov bh, 0
    mov dh, 6 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint _name

    mov ah, 02h
    mov bh, 0
    mov dh, 8 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint levelmsg

    mov dx,level
    add dx,'0'
    mov ah,02
    int 21h

    mov ah, 02h
    mov bh, 0
    mov dh, 10 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint scoremsg

    push scores

    call printmultidigitnumber

    mov ah, 02h
    mov bh, 0
    mov dh, 12 ;Row Number 
    mov dl, 4 ;Column Number 
    int 10h

    msgprint movemsg

    push moves

    call printmultidigitnumber

    mov ah, 02h
    mov bh, 0
    mov dh, 0 ;Row Number 
    mov dl, 0 ;Column Number 
    int 10h

    ret
nameandleveldisplay ENDP

;receives 1 argument
printmultidigitnumber PROC uses ax bx cx dx bp
    mov bp,sp

    mov ax, [bp + 12]
    mov bx, 10
    mov cx, 0

    PUSHINTOSTACK:
        cmp ax,0
        je POPFROMSTACK

        inc cx
        mov dx,0
        div bx
        push dx
        jmp PUSHINTOSTACK

    POPFROMSTACK:
        cmp cx,0
        je COMPLETELYPOPED

        dec cx
        pop dx
        add dx,'0'
        mov ah,02h
        int 21h
        jmp POPFROMSTACK

    COMPLETELYPOPED:
        ret 2
printmultidigitnumber ENDP

;PROC to draw shapes acc to randomly generated values in the GRID
initialboard PROC uses ax bx cx dx
    mov bx,0
    mov cx,175
    mov dx,65

    .while(bx<49)
        .if [GRID + bx] == 0 ;spacer
            mov X1,cx
            add X1,15

            mov Y1,dx
            add Y1,20

            mov X2,cx
            add X2,35
            
            mov Y2,dx
            add Y2,30
            
            call createspacer 
        .elseif [GRID + bx] == 1 ;gift candy
            
            mov X1,cx
            add X1,15

            mov Y1,dx
            add Y1,30

            mov X2,cx
            add X2,35

            mov Y2,dx
            add Y2,45
            
            call creategiftcandy
        .elseif [GRID + bx] == 2 ;lollipop
            mov X1,cx
            add X1,15

            mov Y1,dx
            add Y1,10

            mov X2,cx
            add X2,35

            mov Y2,dx
            add Y2,25
            
            call createlollipop
        .elseif [GRID + bx] == 3 ;icecream
            mov X1,cx
            add X1,15

            mov Y1,dx
            add Y1,20

            mov X2,cx
            add X2,35

            mov Y2,dx
            add Y2,40
            
    
            call createicecream

        .elseif [GRID + bx] == 4 ;diamond
            mov X1,cx
            add X1,5

            mov Y1,dx
            add Y1,25

            mov X2,cx
            add X2,25

            mov Y2,dx
            add Y2,45
    
            call creatediamond

        .elseif [GRID + bx] == 7 ;blocker
            mov X1,cx

            mov Y1,dx

            mov X2,cx
            add X2,50

            mov Y2,dx
            add Y2,50
    
            call createblocker
        .endif

        
        ;INC in row and cols accordingly
        .if cx == 475
            mov cx,175
            add dx,50
        .else
            add cx,50
        .endif
        inc bx
    .endw

    ret
initialboard ENDP

;receives no argument
printgrid PROC uses ax cx dx
    mov ah,0ch
    mov al,0Fh;white

    mov cx,175

    .while(cx<=525)
        mov dx,65

        .while(dx<=415)
            int 10h
            inc dx
        .endw
        add cx,50
    .endw 

    mov dx,65
    .while(dx<=415)
        mov cx,175

        .while(cx<=525)
            int 10h
            inc cx
        .endw
        add dx,50
    .endw    
    
    ret

printgrid ENDP

creategiftcandy PROC uses ax cx dx
    
    mov ah,0ch
    mov al,03h

    mov dx,Y1
    .while dx<Y2
        mov cx,X1
        .while cx<=X2
            int 10h
            inc cx
        .endw
        ;inc al
        inc dx
    .endw

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    push X1
    push Y1
    push X2
    push Y2
    push temp2
    push temp

    mov cx,X1
    add cx,10
    mov X1,cx


    mov cx,Y1
    sub cx,21
    mov Y1,cx

    mov cx,X1
    add cx,6
    mov X2,cx

    mov cx,Y1
    add cx,6
    mov Y2,cx

    call createspecialstar

    pop temp
    pop temp2
    pop Y2
    pop X2
    pop Y1
    pop X1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov al,05h

    mov cx,X1
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc dx
    .endw

    mov cx,X1
    mov dx,Y1

    dec cx

    .while dx<Y2
        int 10h
        inc dx
    .endw

    mov cx,X1
    mov dx,Y2

    .while cx<=X2
        int 10h
        inc cx
    .endw

    mov cx,X1
    mov dx,Y2

    dec dx

    .while cx<=X2
        int 10h
        inc cx
    .endw

    mov cx,X2
    mov dx,Y1

    inc cx

    .while dx<Y2
        int 10h
        inc dx
    .endw 

    mov cx,X2
    mov dx,Y1
    add cx,2
    .while dx<Y2
        int 10h
        inc dx
    .endw     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov al,05h;

    mov cx,X1
    dec cx

    mov dx,Y1
    mov temp,dx
    sub temp,11

    .while dx>temp
        
        int 10h
        inc cx
        dec dx
    .endw

    .while dx<Y1
        int 10h
        inc cx
        inc dx    
    .endw

    dec cx
    dec temp
    .while dx>temp
        
        int 10h
        dec cx
        dec dx
    .endw
    add cx,4
    sub dx,2
    .while dx<Y1
        
        int 10h
        dec cx
        inc dx
    .endw


    mov dx,temp
    mov cx,X1
    add cx,5
    mov temp,cx

    mov temp2,cx
    add temp2,10

    .while cx<temp2
        int 10h
        inc cx
    .endw 
    dec dx
    dec cx
    .while cx>=temp
        int 10h
        dec cx
    .endw

     mov cx,X1
    mov dx,Y1

    .while cx<X2
        int 10h
        inc cx
    .endw

    ret
creategiftcandy ENDP

createspecialstar PROC uses ax cx dx
    mov ah,0ch
    mov al,0Fh

    mov cx,X1
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc cx
        inc dx
    .endw

    mov cx,X1
    mov dx,Y1

    .while dx<Y2
        int 10h
        dec cx
        inc dx
    .endw

    mov dx,Y2
    mov temp,cx

    .while cx<X2
        int 10h
        inc cx
    .endw

    add Y1,2
    add Y2,2
    mov cx,temp
    mov dx,Y1

    .while cx<X2
        int 10h
        inc cx
    .endw

    mov cx,temp
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc cx
        inc dx
    .endw

    .while dx>Y1
        int 10h
        inc cx
        dec dx
    .endw

    ret
createspecialstar ENDP

createlollipop PROC uses ax cx dx
    mov ah,0ch
    mov al,05h

    mov dx,Y1
    .while dx<Y2
        mov cx,X1
        .while cx<X2
            int 10h
            inc cx
        .endw
        inc al
        inc dx
    .endw
    
    mov al,0Fh

    mov cx,X1
    mov dx,Y1

    .while dx<Y2
        inc dx
    .endw

    mov cx,Y2
    mov temp,cx
    add temp,13

    mov cx,X1
    add cx,8

    add cx,4
    mov temp2,cx

    mov cx,X1
    add cx,8

    .while dx<temp
        int 10h
        inc dx
    .endw

    .while cx<temp2
        int 10h
        inc cx
    .endw

    .while dx>=Y2
        int 10h
        dec dx
    .endw
    ret
createlollipop ENDP

createspacer PROC uses ax cx dx
    mov ah,0ch
    mov al,05h

    mov cx,X1
    sub cx,8
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc dx
    .endw

    mov cx,Y2
    mov temp,cx
    sub temp,5

    mov cx,X1
    sub cx,8
    mov dx,Y1

    .while dx<temp
        int 10h
        inc cx
        inc dx
    .endw

    .while dx<Y2
        int 10h
        dec cx
        inc dx
    .endw

    mov al,0Eh

    mov cx,X1

    .while(cx<=X2)
        mov dx,Y1

        .while(dx<Y2)
            int 10h
            inc dx
        .endw
        add cx,4
    .endw 

    mov al,0Eh

    mov dx,Y1
    .while(dx<Y2)
        mov cx,X1

        .while(cx<X2)
            int 10h
            inc cx
        .endw
        add dx,3
    .endw  
    
    mov al,05h

    mov cx,X2
    add cx,8
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc dx
    .endw

    mov cx,Y2
    mov temp,cx
    sub temp,5

    mov cx,X2
    add cx,8
    mov dx,Y1

    .while dx<temp
        int 10h
        dec cx
        inc dx
    .endw

    .while dx<Y2
        int 10h
        inc cx
        inc dx
    .endw

    ret
createspacer ENDP

createicecream PROC uses ax cx dx
    
    mov ah,0ch
    mov al,06h

    mov dx,Y1

    mov cx,X2
    mov temp2,cx

    mov cx,X1
    mov temp,cx

    .while(dx<Y2)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        dec cx
        mov temp2,cx

        mov cx,temp
        inc cx
        mov temp,cx

        add dx,2   
    .endw

    mov al,0Bh

    mov dx,Y1
    sub dx,10

    mov cx,X2
    sub cx,10
    mov temp2,cx

    mov cx,X1
    add cx,9
    mov temp,cx
    .while(dx<=Y1)
        .while(cx<temp2)
            inc al
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        inc cx
        mov temp2,cx

        mov cx,temp
        dec cx
        mov temp,cx

        inc dx     
    .endw

    ret
createicecream ENDP

creatediamond PROC uses ax cx dx
    
    mov ah,0ch
    mov al,0Dh

    mov dx,Y1
    sub dx,10

    mov cx,X2
    sub cx,10
    mov temp2,cx

    mov cx,X1
    add cx,9
    mov temp,cx
    .while(dx<=Y1)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        inc cx
        mov temp2,cx

        mov cx,temp
        dec cx
        mov temp,cx

        inc dx     
    .endw

    mov al,0Ch

    mov dx,Y1
    sub dx,10

    mov cx,X2
    add cx,10
    mov temp2,cx

    mov cx,X1
    add cx,10
    mov temp,cx

    .while(dx<Y1)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        dec cx
        mov temp2,cx

        mov cx,temp
        inc cx
        mov temp,cx

        inc dx   
    .endw

    mov al,0EH

    mov dx,Y1
    sub dx,10

    mov cx,X2
    add cx,20
    sub cx,10
    mov temp2,cx

    mov cx,X1
    add cx,30
    mov temp,cx
    .while(dx<=Y1)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        inc cx
        mov temp2,cx

        mov cx,temp
        dec cx
        mov temp,cx

        inc dx     
    .endw

    mov al,09H
    mov dx,Y1

    mov cx,X2
    mov temp2,cx

    mov cx,X1
    mov temp,cx

    .while(dx<=Y2)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        dec cx
        mov temp2,cx

        mov cx,temp
        inc cx
        mov temp,cx

        inc dx   
    .endw

    mov al,0AH
    mov dx,Y1

    mov cx,X2
    add cx,20
    mov temp2,cx

    mov cx,X1
    add cx,19
    mov temp,cx

    .while(dx<Y2)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        dec cx
        mov temp2,cx

        mov cx,temp
        inc cx
        mov temp,cx

        inc dx   
    .endw


    mov al,0Bh
    mov dx,Y1
    add dx,10

    mov cx,X2
    mov temp2,cx

    mov cx,X2
    dec cx
    mov temp,cx
    sub dx,9
    sub Y2,9
    .while(dx<Y2)
        .while(cx<temp2)
            int 10h
            inc cx
        .endw
        
        mov cx,temp2
        inc cx
        mov temp2,cx

        mov cx,temp
        dec cx
        mov temp,cx

        inc dx     
    .endw

    ret
creatediamond ENDP

createborders proc uses ax bx cx dx

    mov ah,0Ch
    mov al,0Ch

    mov bx,0
    label1:
        mov cx,X1
        mov dx,Y1
        .while cx<X2
            int 10h
            inc cx
        .endw

        .while dx<Y2
            int 10h
            inc dx
        .endw

        .while cx>X1

            int 10h
            dec cx
        .endw

        .while dx>Y1
            int 10h
            dec dx
        .endw

        add X1,2
        add Y1,2
        sub X2,2
        sub Y2,2

        inc bx
        cmp bx,9
        jne label1


    ret
createborders ENDP

createsquare PROC uses ax cx dx
    mov ah,0ch
    mov al,0Ch

    mov cx,X1
    mov dx,Y1

    .while cx<X2
        int 10h
        inc cx
    .endw

    mov cx,X1
    mov dx,Y2

    .while cx<X2
        int 10h
        inc cx
    .endw

    mov cx,X1
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc dx
    .endw

    mov cx,X2
    mov dx,Y1

    .while dx<Y2
        int 10h
        inc dx
    .endw

    ret
createsquare ENDP

createblocker PROC uses ax cx dx
    mov ah,0ch
    mov al,0Fh

    mov cx,X1

    .while cx<=X2
        mov dx,Y1
        .while dx<=Y2
            int 10h
            inc dx
        .endw
        inc cx
    .endw

    ret
createblocker ENDP

createlivecell PROC uses ax cx
    mov ax,Y

    mov cl,50
    mul cl

    add ax,175

    mov X1,ax
    mov X2,ax
    add X2,50

    mov ax,X

    mov cl,50
    mul cl

    add ax,65

    mov Y1,ax
    mov Y2,ax
    add Y2,50

    call createsquare

    ret
createlivecell ENDP

end main