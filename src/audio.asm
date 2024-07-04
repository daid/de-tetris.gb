INCLUDE "hardware.inc/hardware.inc"

SECTION "audio_mem", WRAM0
wAudioPtr:
    ds 2
wAudioDelay:
    ds 1

SECTION "audio", ROM0
audioInit::
    ld   a, $80
    ldh  [rNR52], a
    ld   a, $ff
    ldh  [rNR51], a
    ld   a, $77
    ldh  [rNR50], a
    
    xor  a
    ldh  [rNR10], a
    ld   a, $80
    ldh  [rNR11], a
    ld   a, $F0
    ldh  [rNR12], a
    ld   a, $80
    ldh  [rNR21], a
    ld   a, $F0
    ldh  [rNR22], a

    ld   a, $80
    ldh  [rNR30], a
    ld   a, $01
    ldh  [rNR31], a
    ld   a, $20
    ldh  [rNR32], a
    
    
    ld   de, waveData
    ld   hl, _AUD3WAVERAM
    ld   c, 16
    rst  MemcpySmall

    ld   hl, wAudioPtr
    ld   a, LOW(audioData)
    ld   [hl+], a
    ld   a, HIGH(audioData)
    ld   [hl+], a
    ld   a, 5
    ld   [wAudioDelay], a
    ret

audioUpdate::
    ld   hl, wAudioDelay
    dec  [hl]
    ret  nz
    ld   a, 6
    ld   [hl], a

    ld   hl, wAudioPtr
    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a

    ld   a, [hl+]
    and  a
    jr   z, .skipChannel1
    sub  a, 12
    jr   c, .restart
    add  a, a
    add  a, LOW(freqTable)
    ld   e, a
    adc  a, HIGH(freqTable)
    sub  e
    ld   d, a
    ld   a, $80
    ldh  [rNR11], a
    ld   a, [de]
    inc  de
    ldh  [rNR13], a
    ld   a, [de]
    ldh  [rNR14], a
.skipChannel1:

    ld   a, [hl+]
    and  a
    jr   z, .skipChannel2
    sub  a, 12
    add  a, a
    add  a, LOW(freqTable)
    ld   e, a
    adc  a, HIGH(freqTable)
    sub  e
    ld   d, a
    ld   a, $80
    ldh  [rNR21], a
    ld   a, [de]
    inc  de
    ldh  [rNR23], a
    ld   a, [de]
    ldh  [rNR24], a
.skipChannel2:

    ld   a, [hl+]
    and  a
    jr   z, .skipChannel3
    sub  a, 12
    add  a, a
    add  a, LOW(freqTable)
    ld   e, a
    adc  a, HIGH(freqTable)
    sub  e
    ld   d, a
    ld   a, $01
    ldh  [rNR31], a
    ld   a, [de]
    inc  de
    ldh  [rNR33], a
    ld   a, [de]
    ldh  [rNR34], a
.skipChannel3:
    inc  hl ; skip channel4

.saveAudioPtr:
    ld   a, l
    ld   [wAudioPtr], a
    ld   a, h
    ld   [wAudioPtr+1], a
    ret
.restart:
    ld   hl, audioData
    jr   .saveAudioPtr

MACRO FREQ
    ; \1 = frequency in centi-herz
    ; Hz = 131072 / (2048-period_value)
    ; 2048-(131072 / Hz) = period_value
    DEF VAL = (2048 - (13107200 / \1))
    IF VAL < 1
        REDEF VAL = 1
    ENDC
    dw VAL | $C000
    println(VAL)
    PURGE VAL
ENDM

waveData:
    db $FF, $FF, $FF, $FF, $00, $00, $00, $00
    db $FF, $FF, $FF, $FF, $00, $00, $00, $00

freqTable:
    FREQ 1635 ; C0
    FREQ 1732
    FREQ 1835
    FREQ 1945
    FREQ 2060
    FREQ 2183
    FREQ 2312
    FREQ 2450
    FREQ 2596
    FREQ 2750
    FREQ 2914
    FREQ 3087
    FREQ 3270
    FREQ 3465
    FREQ 3671
    FREQ 3889
    FREQ 4120
    FREQ 4365
    FREQ 4625
    FREQ 4900
    FREQ 5191
    FREQ 5500
    FREQ 5827
    FREQ 6174
    FREQ 6541
    FREQ 6930
    FREQ 7342
    FREQ 7778
    FREQ 8241
    FREQ 8731
    FREQ 9250
    FREQ 9800
    FREQ 10383
    FREQ 11000
    FREQ 11654
    FREQ 12347
    FREQ 13081
    FREQ 13859
    FREQ 14683
    FREQ 15556
    FREQ 16481
    FREQ 17461
    FREQ 18500
    FREQ 19600
    FREQ 20765
    FREQ 22000
    FREQ 23308
    FREQ 24694
    FREQ 26163
    FREQ 27718
    FREQ 29366
    FREQ 31113
    FREQ 32963
    FREQ 34923
    FREQ 36999
    FREQ 39200
    FREQ 41530
    FREQ 44000
    FREQ 46616
    FREQ 49388
    FREQ 52325
    FREQ 55437
    FREQ 58733
    FREQ 62225
    FREQ 65925
    FREQ 69846
    FREQ 73999
    FREQ 78399
    FREQ 83061
    FREQ 88000
    FREQ 93233
    FREQ 98777
    FREQ 104650
    FREQ 110873
    FREQ 117466
    FREQ 124451
    FREQ 131851
    FREQ 139691
    FREQ 147998
    FREQ 156798
    FREQ 166122
    FREQ 176000
    FREQ 186466
    FREQ 197553
    FREQ 209300
    FREQ 221746
    FREQ 234932
    FREQ 248902
    FREQ 263702
    FREQ 279383
    FREQ 295996
    FREQ 313596
    FREQ 332244
    FREQ 352000
    FREQ 372931
    FREQ 395107
    FREQ 418601
    FREQ 443492
    FREQ 469863
    FREQ 497803
    FREQ 527404
    FREQ 558765
    FREQ 591991
    FREQ 627193
    FREQ 664488
    FREQ 704000
    FREQ 745862
    FREQ 790213 ; D#8
