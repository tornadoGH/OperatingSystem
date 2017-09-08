
	ORG		0x7c00			; このプログラムのメモリ配置場所

; FAT12フォーマットのフロッピーディスク用
	JMP		entry
	DB		0x90
	DB		"HAROBPTE"
	DW		512				; 1セクタの大きさ
	DB		1				; クラスタの大きさ
	DW		1				; FATがどこから始まるか
	DB		2				; FATの個数
	DW		224				; ルートディレクトリ領域の大きさ
	DW		2880			; このドライブの大きさ
	DB		0xf0			; メディアのタイプ
	DW		9				; FAT領域の長さ
	DW		18				; 1トラックにいくつのセクタがあるか
	DW		2				; ヘッドの数
	DD		0				; パーティションを使っていない場合は0指定
	DD		2880			; このドライブの大きさ
	DB		0,0,0x29		; 固定値？
	DD		0xffffffff		; ボリュームシリアル番号？
	DB		"HARIBOTE-OS"	; ディスクの名前（11バイト固定)
	DB		"FAT12   "		; フォーマットの名前(8バイト固定)
	RESB	18				; 18バイトあける


; プログラム本体

entry:
	MOV		AX, 0
	MOV		SS, AX
	MOV		SP, 0x7c00
	MOV		DS, AX

; ディスクをリードする

	MOV		AX, 0x0820
	MOV		ES, AX
	MOV		CH,	0			; シリンダ0
	MOV		DH, 0			; ヘッド0
	MOV		CL, 2			; セクタ2

	MOV		AH, 0x02		; ディスクから読み込み
	MOV		AL, 1			; １セクタ
	MOV		BX, 0			; バッファアドレス (ES*16+BX)=0
	MOV		DL, 0x00		; Aドライブ
	INT		0x13			; ディスクBIOSコール
	JC		error			; キャリーフラグがONならerrorへ

fin:
	HLT
	JMP		fin

error:
	MOV		SI, msg


putloop:
	MOV		AL, [SI]
	ADD		SI, 1			; SI++
	CMP		AL, 0
	JE		fin
	MOV		AH, 0x0e
	MOV		BX, 15
	INT		0x10
	JMP		putloop

msg:
	DB		0x0a, 0x0a		; 改行×２
	DB		"load error"
	DB		0x0a			; 改行
	DB		0

	RESB	0x7dfe-$		; 0x7dfeまでを0x00で埋める
	
	DB		0x55, 0xaa
