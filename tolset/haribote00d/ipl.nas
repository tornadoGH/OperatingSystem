
CYLS	EQU		10


	ORG		0x7c00			; ���̃v���O�����̃������z�u�ꏊ

; FAT12�t�H�[�}�b�g�̃t���b�s�[�f�B�X�N�p
	JMP		entry
	DB		0x90
	DB		"HAROBPTE"
	DW		512				; 1�Z�N�^�̑傫��
	DB		1				; �N���X�^�̑傫��
	DW		1				; FAT���ǂ�����n�܂邩
	DB		2				; FAT�̌�
	DW		224				; ���[�g�f�B���N�g���̈�̑傫��
	DW		2880			; ���̃h���C�u�̑傫��
	DB		0xf0			; ���f�B�A�̃^�C�v
	DW		9				; FAT�̈�̒���
	DW		18				; 1�g���b�N�ɂ����̃Z�N�^�����邩
	DW		2				; �w�b�h�̐�
	DD		0				; �p�[�e�B�V�������g���Ă��Ȃ��ꍇ��0�w��
	DD		2880			; ���̃h���C�u�̑傫��
	DB		0,0,0x29		; �Œ�l�H
	DD		0xffffffff		; �{�����[���V���A���ԍ��H
	DB		"HARIBOTE-OS"	; �f�B�X�N�̖��O�i11�o�C�g�Œ�)
	DB		"FAT12   "		; �t�H�[�}�b�g�̖��O(8�o�C�g�Œ�)
	RESB	18				; 18�o�C�g������

; �v���O�����{��
entry:
	MOV		AX, 0
	MOV		SS, AX
	MOV		SP, 0x7c00
	MOV		DS, AX

; �f�B�X�N��ǂ�
	MOV		AX, 0x0820
	MOV		EX, AX
	MOV 	CH, 0			; �V�����_
	MOV		DH, 0			; �w�b�h0
	MOV		CL, 2			; �Z�N�^2
	
readloop:
	MOV		SI, 0			; ���s�񐔂𐔂��郌�W�X�^

retry:
	MOV		AH, 0x02		; �f�B�X�N�ǂݍ���
	MOV		AL, 1			; 1�Z�N�^
	MOV		BX, 0
	MOV		DL, 0x00		; A�h���C�u
	INT		0x13			; �f�B�X�NBIOS�Ăяo��
	JNC		next			; �L�����[�t���O�������Ă��Ȃ��ꍇ��next��(�f�B�X�N�ǂݍ��ݐ������肪�L�����[�t���O�ɃZ�b�g�����)
	ADD		SI, 1			; SI++
	CMP		SI, 5			; SI��5���r
	JAE		error			; SI>=5�̏ꍇ��error�֑J��
	MOV		AH, 0x00
	MOV		DL, 0x00		; A�h���C�u
	INT		0x13			; �h���C�u�̃��Z�b�g
	JMP		retry

next:
	MOV		AX, ES          ;
	ADD		AX, 0x0020		; �A�h���X��0x200(512)�i�߂�
	MOV		ES, AX			; 

	ADD		CL, 1
	CMP		CL, 18
	JBE		readloop		; CL<=18��������readloop��

	MOV		CL,	1
	ADD		DH, 1
	CMP		DH, 2
	JB		readloop		; DH<2��������readloop��

	MOV		DH, 0
	ADD		CH, 1
	CMP		CH, CYLS
	JB		readloop		; CH<CYLS��������readloop��

; Read����
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
	MOV		AH, 0x0e		; �ꕶ���\��
	MOV		BX, 15			; �J���[�R�[�h
	INT		0x10			; �r�f�IBIOS�Ăяo��
	JMP		putloop

msg:
	DB		0x0a, 0x0a
	DB		"load error"
	DB		0x0a
	DB		0

	RESB	0x7dfe-$
	
	DB		0x55, 0xaa
