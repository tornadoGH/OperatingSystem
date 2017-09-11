
CYLS	EQU		10


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

; ディスクを読む
	MOV		AX, 0x0820
	MOV		ES, AX
	MOV		CH, 0			; シリンダ0
	MOV		DH,	0			; ヘッド0
	MOV		CL, 2			; セクタ2
readloop:
	MOV		SI, 0			; 失敗回数をカウントするレジスタ
retry:
	MOV		AH, 0x02		; ディスク読み込み
	MOV		AL, 1			; 1セクタ
	MOV		BX, 0
	MOV		DL, 0x00		; Aドライブ
	INT		0x13			; ディスクBIOS呼び出し
	JNC		next			; エラーなしならnextへ
	ADD		SI, 1
	CMP		SI, 5
	JAE		error			; SI>=5ならerrorへ遷移
	MOV		AH, 0x00
	MOV		DH, 0x00		; Aドライブ
	INT		0x13			; ドライブリセット
	JMP		retry

next:
	MOV		AX, ES			;
	ADD		AX, 0x0200		;
	MOV		ES, AX			; アドレスを0x200進める
	ADD		CL, 1
	CMP		CL, 18
	JBE		readloop		; CL<=18 ならreadloopへ遷移
	MOV		CL, 1
	ADD		DH, 1
	CMP		DH, 2
	JB		readloop		; DH<=2 ならreadloopへ遷移
	MOV		DH, 0
	ADD		CH, 1
	CMP		CH, CYLS
	JB		readloop		; CH<CYHSならreadloopへ遷移

;最後まで読み終わった
fin:
	HLT
	JMP		fin

error:
	MOV		SI, msg

putloop:
	MOV		AL, [SI]
	ADD		SI, 1
	CMP		AL, 0
	JE		fin
	MOV		AH, 0x0e		; 一文字表示ファンクション
	MOV		BX, 15			; カラーコード
	INT		0x10			; ビデオBIOS呼び出し
	JMP		putloop

msg:
	DB		0x0a, 0x0a
	DB		"load error"
	DB		0x0a
	DB		0

	RESB	0x7dfe-$
	
	DB		0x55, 0xaa

