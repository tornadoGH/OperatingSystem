
	ORG		0x7c00			; ���̃v���O�����̃������z�u�ꏊ

; FAT12�t�H�[�}�b�g�̃t���b�s�[�f�B�X�N�p
	JMP		entry
	DB		0x90
	DB		"HELLOIPL"
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
	DB		"HELLO-OS   "	; �f�B�X�N�̖��O�i11�o�C�g�Œ�)
	DB		"FAT12   "		; �t�H�[�}�b�g�̖��O(8�o�C�g�Œ�)
	RESB	18				; 18�o�C�g������

; �v���O����

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
	CMP		AL,0			; AL �� 0���r
	JE		fin				; �C�R�[���Ȃ�fin�֔��
	MOV		AH,0x0e			; �ꕶ���\���t�@���N�V����
	MOV		BX,15			; �J���[�R�[�h
	INT		0x10			; �r�f�IBIOS�Ăяo��
	JMP		putloop			; putloop�֔��

fin:
	HLT						; CPU��~
	JMP		fin				; fin�֔��

msg:
	DB		0x0a, 0x0a		; ���s�Q��
	DB		"hello world"
	DB		0x0a			; ���s
	DB		0
	
	RESB	0x7dfe-$		; 0x7efe�܂�0x00�Ŗ��߂�

	DB		0x55, 0xaa

; �ȉ��̓u�[�g�Z�N�^�ȊO�̕���
	DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	RESB	4600
	DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
	RESB	1469432
