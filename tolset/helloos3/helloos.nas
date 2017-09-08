
	ORG		0x7c00			; このプログラムのメモリ配置場所

; FAT12フォーマットのフロッピーディスク用
	JMP		entry
	DB		0x90
	DB		"HELLOIPL"
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
	DB		"HELLO-OS   "	; ディスクの名前（11バイト固定)
	DB		"FAT12   "		; フォーマットの名前(8バイト固定)
	RESB	18				; 18バイトあける

; プログラム

entry:
	MOV		AX,0
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX
	MOV		ES,AX

	MOV		SI,msg

putloop:
	MOV		AL,[SI]
	ADD		SI,1			; SI++
	CMP		AL,0			; AL と 0を比較
	JE		fin				; イコールならfinへ飛ぶ
	MOV		AH,0x0e			; 一文字表示ファンクション
	MOV		BX,15			; カラーコード
	INT		0x10			; ビデオBIOS呼び出し
	JMP		putloop			; putloopへ飛ぶ

fin:
	HLT						; CPU停止
	JMP		fin				; finへ飛ぶ

msg:
	DB		0x0a, 0x0a		; 改行２つ
	DB		"hello world"
	DB		0x0a			; 改行
	DB		0
	
	RESB	0x7dfe-$		; 0x7efeまで0x00で埋める

	DB		0x55, 0xaa

; 以下はブートセクタ以外の部分
	DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	RESB	4600
	DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	RESB	1469432
