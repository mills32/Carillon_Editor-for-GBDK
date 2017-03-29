;---------------------------------------------------------------------------
; CARILLON PLAYER Header file for GBDK
; (c)2000-2001 Aleksi Eeben (email: aleksi@cncd.fi)
; Ported to GBDK by nitro2k01 (http://gbdev.gg8.se/forums/)
;---------------------------------------------------------------------------
        
		.globl	_CP_Init
		.globl	_CP_LoadSong
		.globl	_CP_SelectSong
		.globl	_CP_UpdateSong
		.globl	_CP_UpdateSamp
		.globl	_CP_StopSong
		.globl	_CP_Mute_Chan
		.globl	_CP_Reset_Chan
		
.area	_CODE
	
.Player_Initialize		=	0x4000
.Player_MusicStart		=	0x4003
.Player_MusicStop		=	0x4006
.Player_SongSelect		=	0x400c
.Player_MusicUpdate		=	0x4100
.Player_SampleUpdate	=	0x4000
.LY						=	0x44		; LCDC Y-coordinate

_CP_init:
		jp		.Player_Initialize		; Initialize
		ret
		
_CP_LoadSong:
		
		push	BC
		call	.Player_MusicStart		; Start music playing
		pop		BC
		ret		

_CP_SelectSong:		
		LDA		HL,2(SP)				; Skip return address
		LD		A,(HL)					; Call SongSelect AFTER MusicStart!
		call	.Player_SongSelect		; (Not needed if SongNumber = 0)
		ret

_CP_UpdateSong:
        jp		.Player_MusicUpdate		; Call this once a frame


_CP_UpdateSamp:		;sample player (GOOD)
        ld      c,#16					; Waiting
        call    _CP_Wait_LCDLine
        call    .Player_SampleUpdate	; 1st call right after music update
		
        ld      c,#54
        call    _CP_Wait_LCDLine
        call    .Player_SampleUpdate	; 2nd call after $26 LCD lines
		
        ld      c,#90
        call    _CP_Wait_LCDLine
        call    .Player_SampleUpdate	; 3rd call after $4d LCD lines
		
        ld      c,#131					; < $90, don't waste VBlank time
        call    _CP_Wait_LCDLine
        call    .Player_SampleUpdate	; 4th call after $73 LCD lines
		ret
		
_CP_StopSong:
        jp		.Player_MusicStop		; Stops music
		
_CP_Wait_LCDLine:
        ldh		a,(.LY)
        cp		c
        jr		nz,_CP_Wait_LCDLine
		
_ret:
		ret

;MILLS:
;As carillon does not have any functions to mute channels, 
;I figured out this "thing" that writes to the ram (0xc7c0)used by carillon...
;it just works...

_CP_Mute_Chan:	

	LDA	HL,2(SP)
	LD	A,(HL)
	CP	#0
	JR	Z,MCH1
	CP	#1
	JR	Z,MCH2
	CP	#2
	JR	Z,MCH3
	CP	#3
	JR	Z,MCH4
	;////////////////////////////////
MCH1:
	LD	HL,#0xc7c7	;BASE+7
	LD	A,#0x00
	LD  (HL),A		;CHAN 1 OFF
	ret
MCH2:
	LD	HL,#0xc7cD	;BASE+D
	LD	A,#0x00
	LD  (HL),A		;CHAN 2 OFF
	ret
MCH3:
	LD	HL,#0xc7d3	;BASE+13
	LD	A,#0x00
	LD  (HL),A		;CHAN 3 OFF
	ret
MCH4:
	LD	HL,#0xc7da	;BASE+1A
	LD  (HL),A		;CHAN 4 OFF
	ret

;MILLS:
;This just resets all parameters after playing a SFX, 
;so that carillon keeps playing well
_CP_Reset_Chan:
	LDA	HL,2(SP)
	LD	A,(HL)
	CP	#0
	JR	Z,CH1
	CP	#1
	JR	Z,CH2
	CP	#2
	JR	Z,CH3
	CP	#3
	JR	Z,CH4
	;////////////////////////////////
CH1:    ;SOUND REG
	LD	A,#0x00
	LD  (#0xFF10),A		;CHAN 1 RESET
	LD  (#0xFF11),A	
	LD  (#0xFF12),A	
	LD  (#0xFF13),A	
	LD  (#0xFF14),A	
	ret
CH2:
	LD	A,#0x00
	LD  (#0xFF16),A		;CHAN 2 RESET
	LD  (#0xFF17),A	
	LD  (#0xFF18),A	
	LD  (#0xFF19),A	
	ret
CH3:
	LD	A,#0x00
	LD  (#0xFF1A),A		;CHAN 3 RESET
	LD  (#0xFF1B),A	
	LD  (#0xFF1C),A	
	LD  (#0xFF1D),A	
	LD  (#0xFF1E),A
	ret
CH4:
	LD	A,#0x00
	LD  (#0xFF20),A		;CHAN 4 RESET
	LD  (#0xFF21),A	
	LD  (#0xFF22),A	
	LD  (#0xFF23),A	
	ret
		
		
.area	_Playervars (ABS)
		.org	0xc7c0
		.ds		0x30					; $c7c0 - $c7ef for player variables
