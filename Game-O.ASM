IDEAL
MODEL small
STACK 20h
DATASEG
; --------------------------
	Color db 6
	Xclick dw ?
	Yclick dw ?
	Xp dw ?
	Yp dw ?
	SquareSize dw 7
	ErrorFile db 0
	
    ScrLine db  320 dup(?)  ; One Color line read buffer
	
	;BMP File data
	FileName1 db 'redCar.bmp' ,0
	FileName2 db 'yellCar2.bmp' ,0 
	FileName3 db 'blueCar.bmp' ,0 
	FileName4 db 'greyCar.bmp', 0 
	FileName5 db 'orngCar.bmp', 0 
	FileName6 db 'pinkCar.bmp', 0 
	FileName7 db 'purCar2.bmp', 0 

	TT db 'TT.bmp' ,0 
	CrossRoadStart db 'crosRoad.bmp', 0 ;start view
	CrossRoadLoser db 'LScreen.bmp', 0 ; screen when u loose
	CrossRoadWinner db 'Wscreen.bmp', 0
	BlackScreen db 'BScreen.bmp' ,0 
 
	FileHandle	dw ?
	Header db 54 dup(0)
	Palette db 400h dup (0)
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?

	PersonUpDown dw 10
	PersonRightLeft dw 40
	
	carsY dw 37, 37, 53, 53, 56, 67, 69, 68, 115, 115, 130, 130, 142, 144, 159, 157, 157  ; בסדר הופעה על המסך
	carsX dw 12, 89, 68, 147, 188, 12, 120, 178, 12, 55, 67, 188, 12, 120, 20, 93, 130 ;המקום ההתחלתי של המכוניות ב BmpLeft (כל פעם מעלים את זה באחד ושמים אותו מחדש בBmpLeft)
	carsLen dw 17
	
	loopCnt dw 1
	finish db 0
; --------------------------
CODESEG

start:
    mov ax, @data
    mov ds, ax
	call setGraphic
	call CheckIfPlayerStart
	call road_stage1
	
StartLoop:

mainLoop:

	call moveCars
	call Check_If_TT_Move
	call Draw_Person
	call Check_Collision_All
	cmp ax, 1 ; collision
	je endGame
c1:
	cmp [word PersonUpDown], 175
	jae victory
c2:
	inc [loopCnt]
	cmp [finish] , 1
	jne mainLoop
	jmp endLoop
endGame:
	call Loser_screen
escape1:	  
	  call CheckAndReadKey
	  cmp al, 'q'
	  jne escape1
	  jmp endLoop 
victory:
	call Victory_screen
escape2:	  
	  call CheckAndReadKey
	  cmp al, 'q'
	  jne escape2
	  jmp endLoop 
endLoop:

mov ah, 7
int 21h

mov ah, 0
mov al, 2
int 10h

@@quit:
; --------------------------
exit:
    mov ax, 4c00h
    int 21h
; --------------------------
;input: carsX, dx - filename, BmpTop - y, BmpColSize - רוחב, BmpRowSize - אורך
;output: אין
; --------------------------
proc moveCars
	mov dx, offset FileName3 
	mov ax,	[carsX + 0]
	mov [BmpLeft], ax
	mov [BmpTop], 37
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1 ;בודק כל פעם כשהמספר מתחלק בשמונה להזיז את המכונית
	jnz @@c2
	inc [carsX + 0]
	cmp [word carsX + 0], 320
	jnz @@c2
	mov [carsX + 0], 0
@@c2:	
	mov dx, offset FileName2
	mov ax,	[carsX + 22]
	mov [BmpLeft], ax
	mov [BmpTop], 130
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 5 ; פעם כשהמספר מתחלק בשמונה להזיז את המכונית (חייב להיות מספר כפול 2 פחות אחד)
	
	jnz @@c3
	dec [carsX + 22]
	cmp [word carsX + 22], 0
	jnz @@c3
	mov [carsX + 22], 320
@@c3:	
	mov dx, offset FileName1
	mov ax,	[carsX + 10]
	mov [BmpLeft], ax
	mov [BmpTop], 67
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 3 ; פעם כשהמספר מתחלק בשמונה להזיז את המכונית (חייב להיות מספר כפול 2 פחות אחד)
	
	jnz @@c4
	inc [carsX + 10]
	cmp [word carsX + 10], 320
	jnz @@c4
	mov [carsX + 10], 0
@@c4:	
	mov dx, offset FileName3 
	mov ax,	[carsX + 24]
	mov [BmpLeft], ax
	mov [BmpTop], 142
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 3 ;בודק כל פעם כשהמספר מתחלק בשמונה להזיז את המכונית
	jnz @@c5
	inc [carsX + 24]
	cmp [word carsX + 24], 320
	jnz @@c5
	mov [carsX + 24], 0
@@c5:	
	mov dx, offset FileName1
	mov ax,	[carsX + 16]
	mov [BmpLeft], ax
	mov [BmpTop], 115
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1 ; פעם כשהמספר מתחלק בשמונה להזיז את המכונית (חייב להיות מספר כפול 2 פחות אחד)
	
	jnz @@c6
	inc [carsX + 16]
	cmp [word carsX + 16], 320
	jnz @@c6
	mov [carsX + 16], 0
@@c6:
	mov dx, offset FileName4
	mov ax,	[carsX + 28]
	mov [BmpLeft], ax
	mov [BmpTop], 159
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1 ; פעם כשהמספר מתחלק בשמונה להזיז את המכונית (חייב להיות מספר כפול 2 פחות אחד)
	
	jnz @@c7
	inc [carsX + 28]
	cmp [word carsX + 28], 320
	jnz @@c7
	mov [carsX + 28], 0
@@c7:
	mov dx, offset FileName2
	mov ax,	[carsX + 8]
	mov [BmpLeft], ax
	mov [BmpTop], 56
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1 ; פעם כשהמספר מתחלק בשמונה להזיז את המכונית (חייב להיות מספר כפול 2 פחות אחד)
	
	jnz @@c8
	dec [carsX + 8]
	cmp [word carsX + 8], 0
	jnz @@c8
	mov [carsX + 8], 320
@@c8:
	mov dx, offset FileName4
	mov ax,	[carsX + 18]
	mov [BmpLeft], ax
	mov [BmpTop], 115
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1 ; פעם כשהמספר מתחלק בשמונה להזיז את המכונית (חייב להיות מספר כפול 2 פחות אחד)
	
	jnz @@c9
	inc [carsX + 18]
	cmp [word carsX + 18], 320
	jnz @@c9
	mov [carsX + 18], 0
@@c9:
	mov dx, offset FileName5
	mov ax,	[carsX + 6]
	mov [BmpLeft], ax
	mov [BmpTop], 53
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1
	
	jnz @@c10
	dec [carsX + 6]
	cmp [word carsX + 6], 0
	jnz @@c10
	mov [carsX + 6], 320
@@c10:
	mov dx, offset FileName5
	mov ax,	[carsX + 20]
	mov [BmpLeft], ax
	mov [BmpTop], 130
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 3
	
	jnz @@c11
	dec [carsX + 20]
	cmp [word carsX + 20], 0
	jnz @@c11
	mov [carsX + 20], 320
@@c11:
	mov dx, offset FileName6
	mov ax,	[carsX + 30]
	mov [BmpLeft], ax
	mov [BmpTop], 157
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1
	
	jnz @@c12
	inc [carsX + 30] ;inc to move right,    to mov left
	cmp [word carsX + 30], 320
	jnz @@c12
	mov [carsX + 30], 0
@@c12:
	mov dx, offset FileName6
	mov ax,	[carsX + 2]
	mov [BmpLeft], ax
	mov [BmpTop], 37
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	
	test [loopCnt], 1
	
	jnz @@c13
	inc [carsX + 2]
	cmp [word carsX + 2], 320
	jnz @@c13
	mov [carsX + 2], 0
@@c13:	
	mov dx, offset FileName7 ; משהו במכונית הזאת תוקע את התוכנית ואני לא מבינה למה
	mov ax,	[carsX + 4]
	mov [BmpLeft], ax
	mov [BmpTop], 53
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1
	
	jnz @@c14
	dec [carsX + 4]
	cmp [word carsX + 4], 0
	jnz @@c14
	mov [carsX + 4], 320
@@c14:	
	mov dx, offset FileName3 
	mov ax,	[carsX + 12]
	mov [BmpLeft], ax
	mov [BmpTop], 69
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 3
	
	jnz @@c15
	inc [carsX + 12]
	cmp [word carsX + 12], 320
	jnz @@c15
	mov [carsX + 12], 0
@@c15:	
	mov dx, offset FileName6
	mov ax,	[carsX + 14]
	mov [BmpLeft], ax
	mov [BmpTop], 68
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 3
	
	jnz @@c16
	inc [carsX + 14]
	cmp [word carsX + 14], 320
	jnz @@c16
	mov [carsX + 14], 0
@@c16:	
	mov dx, offset FileName4
	mov ax,	[carsX + 26]
	mov [BmpLeft], ax
	mov [BmpTop], 144
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 3
	
	jnz @@c17
	inc [carsX + 26]
	cmp [word carsX + 26], 320
	jnz @@c17
	mov [carsX + 26], 0
@@c17:	
	mov dx, offset FileName1
	mov ax,	[carsX + 32]
	mov [BmpLeft], ax
	mov [BmpTop], 157
	mov [BmpColSize], 32
	mov [BmpRowSize], 15
		
	call OpenShowBmp
	
	test [loopCnt], 1
	
	jnz @@ret
	inc [carsX + 32]
	cmp [word carsX + 32], 320
	jnz @@ret
	mov [carsX + 32], 0
@@ret:
call road_stage1

	ret
endp moveCars
; --------------------------	
; input: carsY, carsX, carsLen, TT- x, y
;output: ax = 1 collision, ax = 0 not collision
; --------------------------
proc Check_Collision_All 
	push cx
	push bx
	push dx
	
	mov cx, [carsLen]
	mov bx, 0
	
@@nextCar:

	push [PersonRightLeft]
	push [PersonUpDown]
	mov dx, [PersonRightLeft]
	add dx, 15
	push dx
	mov dx, [PersonUpDown]
	add dx, 20 ;אולי זה צריך להיות sub?
	push dx
	
	
	push [carsX + bx]
	push [carsY + bx]
	mov dx, [carsX + bx]
	add dx, 32
	push dx
	mov dx, [carsY + bx]
	add dx, 15
	push dx
	
	call aabb
	cmp ax, 1
	jz @@ret
	
	add bx, 2
	loop @@nextCar
	
	mov ax, 0


@@ret:
	pop dx
	pop bx
	pop cx

	ret
endp Check_Collision_All

; --------------------------
;input: ax- value you want
;output: אין
; --------------------------
proc ShowAxDecimal
	   push ax
       push bx
	   push cx
	   push dx
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   mov dl, ','
       mov ah, 2h
	   int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal

; --------------------------
;input: cx=x dx=y al = color  si = Length
;output: אין
; --------------------------
proc road_stage1 ;build the roads in stage1

	mov cx, 0
	mov dx, 35
	mov al, 7
	mov si, 320
	call DrawHorizontalLine
	
	mov cx, 0
	mov dx, 85
	mov al, 7
	mov si, 320
	call DrawHorizontalLine

	mov cx, 0
	mov dx, 110
	mov al, 7
	mov si, 320
	call DrawHorizontalLine

	mov cx, 0
	mov dx, 175
	mov al, 7
	mov si, 320
	call DrawHorizontalLine
	
ret
endp road_stage1

; --------------------------
;input: אין
;output: אין
; --------------------------
proc setGraphic ; set grafic mod
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
	
endp SetGraphic

; --------------------------
;input: אין
;output: אין
; --------------------------
proc CheckAndReadKey

      mov ah ,1
	  int 16h
	  pushf
	  jz @@return 
	  mov ah ,0
	  int 16h

		
@@return:
	  popf
	  ret
endp CheckAndReadKey

proc Check_If_TT_Move

	call CheckAndReadKey
	jz @@return
	jmp @@cEsc
	
@@stop:
	  push ax
	  mov al, ah
	  mov ah, 0
	  call ShowAxDecimal
	  pop ax
	  
@@cEsc:	  
	  cmp al, 'q'
	  jne @@c
	  mov [finish], 1 ;to escape
	  jmp @@return
	  
@@c:
	  cmp al, 'w' ; check if up
	  jnz @@c1
	  dec [PersonUpDown]
	  jmp @@return
	  
@@c1:
	  cmp al, 's' ; check if down
	  jne @@c2
	  inc [PersonUpDown]
	  jmp @@return
	  
@@c2:  
	  cmp al, 'a' ; check if left
	  jne @@c3
	  dec [PersonRightLeft]
	  jmp @@return
	  
@@c3:
	  cmp al, 'd' ; check if right
	  jne @@return
	  inc [PersonRightLeft]
	  jmp @@return

		
@@return:
	  
	  ret
endp Check_If_TT_Move

; --------------------------
;input: dx - filename, BmpColSize - רוחב, BmpRowSize - אורך, PersonRightLeft, PersonUpDown
;output: אין
; --------------------------
proc Draw_Person

	  mov dx, offset TT
      mov ax,	[PersonRightLeft]
	  mov [BmpLeft], ax
	  mov ax, [PersonUpDown]
	  mov [BmpTop], ax
	  mov [BmpColSize], 15
	  mov [BmpRowSize], 20
		
	  call OpenShowBmp

	ret
endp Draw_Person 
	    
; --------------------------
;input: dx - filename, BmpLeft - x, BmpTop - y, BmpColSize - רוחב, BmpRowSize - אורך
;output: אין
; --------------------------	  
proc Loser_screen

	  mov dx, offset CrossRoadLoser
      mov [BmpLeft],0
	  mov [BmpTop],0
	  mov [BmpColSize],320
	  mov [BmpRowSize],200
	  
	  call OpenShowBmp
	  
	 ret
endp Loser_screen
	    
; --------------------------
;input: dx - filename,BmpLeft - x, BmpTop - y, BmpColSize - רוחב, BmpRowSize - אורך
;output: אין
; --------------------------
proc Victory_screen

	  mov dx, offset CrossRoadWinner ;לשנות לתמונה של ניצחון
      mov [BmpLeft],0
	  mov [BmpTop],0
	  mov [BmpColSize],320
	  mov [BmpRowSize],200
	  
	  call OpenShowBmp
@@c1:	  
	  call CheckAndReadKey
	  cmp ah, 1
	  jne @@c1
	  mov [finish], 1 ;to escape

	ret
endp Victory_screen
  
; --------------------------
;input: dx - filename,BmpLeft - x, BmpTop - y, BmpColSize - רוחב, BmpRowSize - אורך, cx = col dx= row al = color si = height di = width (for rect)
;output: אין
; --------------------------  
proc CheckIfPlayerStart

@@open:
	push dx
	push ax
	push bx
	push cx 
	
	mov dx, offset CrossRoadStart
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpColSize],320
	mov [BmpRowSize],200
	call OpenShowBmp

	mov ah, 1
	int 21h
	
	cmp al ,'s'
	jne @@open
	
@@startGame:
	pop cx 
	pop bx
	pop ax  
	pop dx
	
	mov cx,0
	mov dx,0
	mov al,0
	mov si,200
	mov di,320
	call Rect
	
ret
endp CheckIfPlayerStart

 ; --------------------------
;input: cx = col dx= row al = color si = height di = width 
;output: אין
; --------------------------
proc Rect
	push cx
	push di
NextVerticalLine:	
	
	cmp di,0
	jz @@EndRect
	
	cmp si,0
	jz @@EndRect
	call DrawVerticalLine
	inc cx
	dec di
	jmp NextVerticalLine
	
@@EndRect:
	pop di
	pop cx
	ret
endp Rect

; --------------------------
;input: cx=x dx=y al = color  si = Length
;output: אין
; --------------------------
proc DrawHorizontalLine	
	push si
	push cx
DrawLine:
	cmp si,0
	jz ExitDrawLine	
	 
    mov ah,0ch	
	int 10h    ; put pixel  cx=x dx=y al = color  si = Length
	
	inc cx
	dec si
	jmp DrawLine
	
ExitDrawLine:
	pop cx
    pop si
	ret
endp DrawHorizontalLine
	
; --------------------------
;input: cx=x dx=y al = color  si = Length
;output: אין
; --------------------------
proc DrawVerticalLine	near
	push si
	push dx
 
DrawVertical:
	cmp si,0
	jz @@ExitDrawLine	
	 
    mov ah,0ch	
	int 10h    ; put pixel
	
	inc dx
	dec si
	jmp DrawVertical
	
@@ExitDrawLine:
	pop dx
    pop si
	ret
endp DrawVerticalLine
	
; --------------------------
;input: dx - filename,BmpLeft - x, BmpTop - y, BmpColSize - רוחב, BmpRowSize - אורך
;output: Ax is file handle, Error: set errorFile 1
; --------------------------	
proc OpenShowBmp near
	
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call ShowBMP
	
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp

; Read 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader

proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette

; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette

proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	dec di
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	
	pop dx
	pop cx
	 
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP 

proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile

; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

; --------------------------
;input: ParamAX1, ParamAY1, ParamAX2, ParamAY2, ParamBX1, ParamBY1, ParamBX2, ParamBY2 (דרך המחסנית)
;output: ax=1 - collision, ax=0 - not collision
; --------------------------	
ParamAX1 equ   [word bp+18]
ParamAY1 equ   [word bp+16]
ParamAX2 equ   [word bp+14]
ParamAY2 equ   [word bp+12]

ParamBX1 equ   [word bp+10]
ParamBY1 equ   [word bp+8]
ParamBX2 equ   [word bp+6]
ParamBY2 equ   [word bp+4]

proc aabb 
	push bp     ; save bp
	mov bp,sp   ; parameters and locals pointer
	push dx
	mov ax ,1
	
	mov dx , ParamAX2
	cmp dx, ParamBX1
	jb @@NotCollision
	
	mov dx , ParamBX2
	cmp dx, ParamAX1
	jb @@NotCollision
	
	mov dx , ParamAY2
	cmp dx, ParamBY1
	jb @@NotCollision
	
	mov dx , ParamBY2
	cmp dx, ParamAY1
	jb @@NotCollision
	jmp @@ret
@@NotCollision:
	mov ax ,0

@@ret:
	pop dx 
	pop bp     
	ret 16
endp aabb
	
END start
