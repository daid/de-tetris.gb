INCLUDE "hardware.inc/hardware.inc"

SECTION "gamemem", WRAM0
wFallingBlockX:
    ds 1
wFallingBlockY:
    ds 1
wFallingBlockType:
    ds 1
wFallingBlockRotation:
    ds 1

SECTION "game", ROMX
mainGameLoop::
    ld   a, 8
    ld   [wFallingBlockX], a
    ld   a, 8
    ld   [wFallingBlockY], a
    ld   a, 0
    ld   [wFallingBlockType], a
    ld   [wFallingBlockRotation], a

    ld   a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ldh  [hLCDC], a

.loop:
    ; update OAM
    ld   a, [wFallingBlockRotation]
    rlca
    ld   b, a
    rlca
    add  a, b
    ld   c, a ; c = wFallingBlockRotation * 6
    ld   a, [wFallingBlockType]
    swap a
    ld   b, a
    rrca
    add  a, b ; a = wFallingBlockType * 24
    add  a, c

    add  a, LOW(BlockTypeData)
    ld   e, a
    adc  a, HIGH(BlockTypeData)
    sub  a, e
    ld   d, a ; de = &BlockTypeData[fallingBlock]

    call getFallingBlockPos
    ld   hl, wShadowOAM
    ld   a, c
    ld   [hl+], a
    ld   a, b
    ld   [hl+], a
    xor  a
    ld   [hl+], a
    ld   [hl+], a

    ld   c, 3
:   push bc
    call getFallingBlockPos
    ld   a, [de]
    inc  de
    sla a
    sla a
    sla a
    add  a, c
    ld   [hl+], a
    ld   a, [de]
    inc  de
    sla a
    sla a
    sla a
    add  a, b
    ld   [hl+], a
    xor  a
    ld   [hl+], a
    ld   [hl+], a
    pop  bc
    dec  c
    jr   nz, :-

    ld a, h ; ld a, HIGH(wShadowOAM)
	ldh [hOAMHigh], a

    ld   a, [hPressedKeys]
    and  a, PADF_A
    call nz, rotateFallingBlock
    ld   a, [hPressedKeys]
    and  a, PADF_B
    call nz, changeFallingBlock

    rst  WaitVBlank
    jp   .loop

; return bc = sprite YX
getFallingBlockPos:
    ld   a, [wFallingBlockY]
    rlca
    rlca
    rlca
    add  a, 16
    ld   b, a
    ld   a, [wFallingBlockX]
    rlca
    rlca
    rlca
    add  a, 8
    ld   c, a
    ret

rotateFallingBlock:
    ld   a, [wFallingBlockRotation]
    inc  a
    and  a, 3
    ld   [wFallingBlockRotation], a
    ret

changeFallingBlock:
    ld   a, [wFallingBlockType]
    inc  a
    cp   7
    jr   nz, :+
    xor  a
:   ld   [wFallingBlockType], a
    ret

BlockTypeData:
    ; For each block type, for each rotation, offsets of 3 tiles from center tile
    ; BlockDataSize = 4*6=24
    ; I
    db -1, 0, 1, 0, 2, 0
    db  0,-1, 0, 1, 0, 2
    db -1, 0, 1, 0, 2, 0
    db  0,-1, 0, 1, 0, 2
    ; J
    db -1, 0,-1,-1, 1, 0
    db  0,-1, 1,-1, 0, 1
    db -1, 0, 1, 0, 1, 1
    db  0,-1, 0, 1,-1, 1
    ; L
    db -1, 0, 1, 0, 1,-1
    db  0,-1, 0, 1, 1, 1
    db -1, 0, 1, 0,-1, 1
    db  0,-1, 0, 1,-1,-1
    ; O
    db -1,-1,-1, 0, 0,-1
    db -1,-1,-1, 0, 0,-1
    db -1,-1,-1, 0, 0,-1
    db -1,-1,-1, 0, 0,-1
    ; S
    db -1, 0, 0,-1, 1,-1
    db  0,-1, 1, 0, 1, 1
    db -1, 0, 0,-1, 1,-1
    db  0,-1, 1, 0, 1, 1
    ; T
    db -1, 0, 1, 0, 0,-1
    db  0, 1, 1, 0, 0,-1
    db  0, 1, 1, 0,-1, 0
    db  0, 1, 0,-1,-1, 0
    ; Z
    db  1, 0, 0,-1,-1,-1
    db  0,-1,-1, 0,-1, 1
    db  1, 0, 0,-1,-1,-1
    db  0,-1,-1, 0,-1, 1

