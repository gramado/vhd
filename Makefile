# Compiling Gramado on Manjaro Linux.
# BSD License
# SPDX-License-Identifier: GPL-3.0+
# History:
#     2018 - Created by Matheus Castello.
#     2019 - Fred Nora.
#     2019 - Luciano Gonçalez.


VERSION = 1
PATCHLEVEL = 25
SUBLEVEL = 0
EXTRAVERSION = -rc0
NAME = 


# First of all, lemme discribe this documment!
# We just have two parts. The kernel and the extra stuff.

## The kernel stuff.
## Step1 KERNEL.BIN         - Creating the kernel image.
## Step2 kernel-image-link  - Linking the kernel image.
## Step3 /mnt/gramadovhd    - Creating the directory to mount the VHD.
## Step4 vhd-create         - Creating a VHD in Assembly language.
## Step5 vhd-mount          - Mounting the VHD.
## Step6 vhd-copy-files     - Copying files into the mounted VHD.
## Step7 vhd-unmount        - Unmounting the VHD.
## Step8 clean              - Deleting the object files.           

## The extra stuff.
## 1) ISO support.
## 2) HDD support.
## 3) VM support.
## 4) Serial debug support.
## 5) Clean files support.
## 6) Usage support.


# That's our default target when none is given on the command line
PHONY := _all
_all: all

#Final message.
	@echo "That's all!"


ARCH ?= x86


# Make variables (CC, etc...)
#AS		= as
#LD		= ld
#CC		= gcc
#AR		= ar
#OBJCOPY		= objcopy
#OBJDUMP		= objdump
#LEX		= flex
#YACC	= bison
#PERL		= perl
#PYTHON		= python
#PYTHON2		= python2
#PYTHON3		= python3
#RUBY		= ruby



#GRAMADOINCLUDE := -I include/


# Setup disk:
# For now we're using IDE disk on primary master.
# You can setup this options in:
# arch/x86/boot/bl/include/config/config.h for the boot loader and
# include/kernel/config/config.h for the kernel.



#tests
CFLAGS = -m32 \
	--std=gnu89 \
	-nodefaultlibs \
	-nostdinc \
	-nostdlib \
	-static \
	-fgnu89-inline \
	-ffreestanding \
	-fno-builtin \
	-fno-pie \
	-no-pie \
	-fleading-underscore \
	-fno-stack-protector \
	-s \
	-Werror=strict-prototypes 




##
## Defines
##

#
# DEFINES =  -DGRAMADO_VERSION=$(VERSION) \
#		-DGRAMADO_PATCHLEVEL=$(PATCHLEVEL) \
#		-DGRAMADO_SUBLEVEL=$(SUBLEVEL) \
#		-DGRAMADO_EXTRAVERSION=\"$(EXTRAVERSION)\" \
#		-DGRAMAD0_NAME=\"$(NAME)\"


##
## Objects
##

ifeq ($(ARCH),x86)

	#deveria ser headx86.o
	ENTRY_OBJECTS := boot.o main.o x86main.o 

	EXECVE_OBJECTS := pipe.o socket.o ctype.o  stdio.o stdlib.o string.o unistd.o \
	devmgr.o \
	gde_serv.o \
	debug.o diskvol.o install.o object.o runtime.o \
	abort.o info.o io.o modules.o signal.o sm.o \
	init.o system.o \
	execve.o 
	
	HAL_OBJECTS := cpuamd.o portsx86.o syscall.o x86.o detect.o \
	hal.o 
	
	KDRIVERS_OBJECTS := ahci.o \
	ata.o atadma.o atainit.o atairq.o atapci.o hdd.o \
	channel.o network.o nicintel.o nsocket.o \
	pci.o pciinfo.o pciscan.o \
	tty.o pty.o vt.o\
	usb.o \
	video.o vsync.o screen.o xproc.o \
	i8042.o keyboard.o mouse.o ps2kbd.o ps2mouse.o ldisc.o \
	apic.o pic.o rtc.o serial.o timer.o  
	
	KSERVERS_OBJECTS := cf.o format.o fs.o read.o search.o write.o \
	cedge.o bg.o bmp.o button.o char.o createw.o dtext.o font.o grid.o \
	line.o menu.o menubar.o pixel.o rect.o sbar.o toolbar.o wm.o \
	logoff.o \
	logon.o \
	input.o output.o terminal.o \
	desktop.o room.o userenv.o usession.o \
	kgwm.o kgws.o \
	vfs.o 
	
	
	MK_OBJECTS := x86cont.o x86fault.o x86start.o \
	dispatch.o pheap.o process.o queue.o spawn.o \
	tasks.o theap.o thread.o threadi.o ts.o tstack.o \
	callout.o callfar.o ipc.o ipccore.o sem.o \
	memory.o mminfo.o mmpool.o pages.o \
	preempt.o priority.o sched.o schedi.o \
	create.o \
	mk.o 


	REQUEST_OBJECTS := request.o 
	PANIC_OBJECTS := panic.o 
	REBOOT_OBJECTS := reboot.o 
	SYS_OBJECTS := sys.o 
	
	OBJECTS := $(ENTRY_OBJECTS) \
	$(EXECVE_OBJECTS) \
	$(HAL_OBJECTS) \
	$(KDRIVERS_OBJECTS) \
	$(KSERVERS_OBJECTS) \
	$(MK_OBJECTS) \
	$(REQUEST_OBJECTS) \
	$(PANIC_OBJECTS) \
	$(REBOOT_OBJECTS) \
	$(SYS_OBJECTS)    
	
	
endif


ifeq ($(ARCH),arm)
   # NOTHING FOR NOW
endif

#
# Begin.
#

## =============================================================================
## The kernel stuff.
## Step1 KERNEL.BIN         - Creating the kernel image.
## Step2 kernel-image-link  - Linking the kernel image.
## Step3 /mnt/gramadovhd    - Creating the directory to mount the VHD.
## Step4 vhd-create         - Creating a VHD in Assembly language.
## Step5 vhd-mount          - Mounting the VHD.
## Step6 vhd-copy-files     - Copying files into the mounted VHD.
## Step7 vhd-unmount        - Unmounting the VHD.
## Step8 clean              - Deleting the object files.           

PHONY := all

all: /mnt/gramadovhd  vhd-create vhd-mount vhd-copy-files vhd-unmount clean

	@echo "Gramado $(VERSION) $(PATCHLEVEL) $(SUBLEVEL) $(EXTRAVERSION) $(NAME) "
	@echo "Arch x86"


## Step3 /mnt/gramadovhd    - Creating the directory to mount the VHD.
/mnt/gramadovhd:
	@echo "================================="
	@echo "(Step 3) Creating the directory to mount the VHD ..."

	sudo mkdir /mnt/gramadovhd


## Step4 vhd-create         - Creating a VHD in Assembly language.
vhd-create:
	@echo "================================="
	@echo "(Step 4) Creating a VHD in Assembly language ..."

	nasm -I arch/x86/boot/vhd arch/x86/boot/vhd/main.asm -o GRAMADO.VHD 


## Step5 vhd-mount          - Mounting the VHD.
vhd-mount:
	@echo "================================="
	@echo "(Step 5) Mounting the VHD ..."

	-sudo umount /mnt/gramadovhd
	sudo mount -t vfat -o loop,offset=32256 GRAMADO.VHD /mnt/gramadovhd/


## Step6 vhd-copy-files     - Copying files into the mounted VHD.
vhd-copy-files:
	@echo "================================="
	@echo "(Step 6) Copying files into the mounted VHD ..."


#
# ======== Files in the root dir. ========
#

# bin/
	sudo cp NOTHING.TXT  /mnt/gramadovhd
	sudo cp bin/BM.BIN   /mnt/gramadovhd
	sudo cp bin/BL.BIN   /mnt/gramadovhd


#
# ======== Creating the all the folders in root dir ========
#		

# Creating standard folders

	-sudo mkdir /mnt/gramadovhd/BOOT


#
# ======== Files in the BIN/ folder. ========
#

# bugbug
# Suspendendo isso por falta de espaço na partição.

	
#
# ======== Files in the /BOOT/ folder. ========
#

	sudo cp NOTHING.TXT       /mnt/gramadovhd/BOOT
	sudo cp bin/BM.BIN       /mnt/gramadovhd/BOOT
	sudo cp bin/BL.BIN       /mnt/gramadovhd/BOOT


#
# ======== Files in the /DEV/ folder. ========
#




## Step7 vhd-unmount        - Unmounting the VHD.
vhd-unmount:
	@echo "================================="
	@echo "(Step 7) Unmounting the VHD ..."

	sudo umount /mnt/gramadovhd


## Step8 clean              - Deleting the object files.           
clean:
	@echo "================================="
	@echo "(Step 8) Deleting the object files ..."

	-rm *.o
	@echo "Success?"


## ====================================================================================
## The extra stuff.
## 1) ISO support.
## 2) HDD support.
## 3) VM support.
## 4) Serial debug support.
## 5) Clean files support.
## 6) Usage support.
	
#
# ======== ISO ======== 
#

# test
# todo
# Create a .ISO file using nasm.
makeiso-x86:
	#todo:  
	#nasm -I arch/x86/boot/iso/stage1/ \
	#-I arch/x86/boot/iso/???/  arch/x86/boot/iso/main.asm  -o  GRAMADO.ISO
	
	@echo "#todo Create ISO using nasm"
	
# ISO
# Mount stage1.bin file with nasm.
# Create a .ISO file and move all the content of the /bin folder
# into the .ISO file.
geniso-x86:
	
	#stage1
	nasm arch/x86/boot/iso/stage1/stage1.asm -f bin -o stage1.bin
	cp stage1.bin bin/boot/gramado/
	rm stage1.bin

	#.ISO
	mkisofs -R -J -c boot/gramado/boot.catalog -b boot/gramado/stage1.bin -no-emul-boot -boot-load-size 4 -boot-info-table -o GRAMADO.ISO bin
	
	@echo "iso Success?"	




#
# ======== HDD ========
#

	
hdd-mount:
	-sudo umount /mnt/gramadohdd
	sudo mount -t vfat -o loop,offset=32256 /dev/sda /mnt/gramadohdd/
#	sudo mount -t vfat -o loop,offset=32256 /dev/sdb /mnt/gramadohdd/
	
hdd-unmount:
	-sudo umount /mnt/gramadohdd
	
hdd-copy-kernel:
	sudo cp bin/boot/KERNEL.BIN /mnt/gramadohdd/BOOT 

danger-hdd-clone-vhd:
	sudo dd if=./GRAMADO.VHD of=/dev/sda
#	sudo dd if=./GRAMADO.VHD of=/dev/sdb




#
# ======== VM ========
#


# Oracle Virtual Box 
oracle-virtual-box-test:
	VBoxManage startvm "Gramado"

# qemu 
qemu-test:
#	-debugcon stdio
	qemu-system-x86_64 -hda GRAMADO.VHD -m 128 -device e1000 -show-cursor -serial stdio
#	qemu-system-x86_64 -hda GRAMADO.VHD -m 512 -device e1000 -show-cursor
#	qemu-system-x86_64 -hda GRAMADO.VHD -m 1044 -device e1000 -show-cursor
#	qemu-system-x86_64 -hda GRAMADO.VHD -m 2048 -device e1000 -show-cursor


#install-kvm-qemu:
#	sudo pacman -S virt-manager qemu vde2 ebtables dnsmasq bridge-utils openbsd-netcat



#
# ======== SERIAL DEBUG ========
#

serial-debug:
	cat ./docs/sdebug.txt
	

#
# ======== CLEAN ========
#

clean2:
	-rm *.ISO
	-rm *.VHD


clean-atacama:
	-rm userland/atacama/bin/*.o
	-rm userland/atacama/bin/*.BIN


clean-garden:
	-rm userland/garden/bin/*.o
	-rm userland/garden/bin/*.BIN


#
# #test
# make lib
#

#userland:


#
# ======== USAGE ========
#

usage:
	@echo "> make"
	@echo "> make clean"
	@echo "> make clean2"
	@echo "> make qemu-test"
	@echo "> make oracle-virtual-box-test"
	@echo "> make vhd-mount"
	@echo "> make vhd-unmount"
	@echo "..."

