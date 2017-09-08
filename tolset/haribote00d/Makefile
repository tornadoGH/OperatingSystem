TOOLPATH 	= ../z_tools/
MAKE		= $(TOOLPATH)make.exe -r
NASK		= $(TOOLPATH)nask.exe
EDIMG		= $(TOOLPATH)edimg.exe
IMGTOL		= $(TOOLPATH)imgtol.com
DEL			= del



default:
	echo [LOG]defalut
	$(MAKE) img

# ファイル生成規則
#	ipl.binを生成するにはipl.nasとMakefileの存在をチェックし存在すればnask.exeが実行される
#   nask.exeが実行され、ipl.binとipl.listが出力される
ipl.bin : ipl.nas Makefile
	echo [LOG]ipl.bin
	$(NASK) ipl.nas ipl.bin ipl.list

#	haribote.imgを生成するには、ipl.binとMakefileの存在をチェックし存在すればedimg.exeが実行される
#	edimg.exeが実行され、haribote.imgが出力される
haribote.img : ipl.bin Makefile
	echo [LOG]haribote.img
	$(EDIMG) imgin:..\z_tools\fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 imgout:haribote.img


#コマンド
asm:
	echo [LOG]asm
	$(MAKE) ipl.bin

img:
	echo [LOG]img
	$(MAKE) haribote.img

run:
	echo [LOG]run
	$(MAKE) img
	copy haribote.img ..\z_tools\qemu\fdimage0.bin
	$(MAKE) -C ..\z_tools\qemu

install:
	echo [LOG]install
	$(MAKE) img
	$(IMGTOL) w a: haribote.img

clean:
	echo [LOG]clean
	-$(DEL) ipl.bin
	-$(DEL) ipl.lst

src_only:
	echo [LOG]src_only
	$(NAME) clean
	-$(DEL) haribote.img

