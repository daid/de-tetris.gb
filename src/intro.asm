INCLUDE "hardware.inc/hardware.inc"

SECTION "Intro", ROMX

Intro::
	ld de, titleScreenGFX
	ld hl, $9000
	ld bc, titleScreenGFX.end - titleScreenGFX
	call LCDMemcpy

	ld b, 18
	ld de, titleScreenMap
	ld hl, $9800
:
	ld c, 20
	call LCDMemcpySmall
	ld a, 32-20
	add a, l
	ld  l, a
	adc a, h
	sub a, l
	ld  h, a
	dec b
	jr  nz, :-

:
	rst WaitVBlank
	ldh a, [hPressedKeys]
	and PADF_START
	jp  nz, Crash
	jr :-


titleScreenGFX::
INCBIN "assets/title.tileset"
.end:
titleScreenMap::
INCBIN "assets/title.tilemap"
.end: