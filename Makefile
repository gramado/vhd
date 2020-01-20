


PHONY := all

all: DISK.VHD vhd-mount vhd-unmount

	@echo "end"
DISK.VHD:
	nasm main.asm -o DISK.VHD   
	
	
vhd-mount:

	@echo "================================="
	@echo "Creating the directory to mount the VHD ..."
	-sudo umount /mnt/gramadovhd2
	-sudo rm -r /mnt/gramadovhd2
	sudo mkdir /mnt/gramadovhd2


	@echo "================================="
	@echo "Mounting the VHD ..."
	-sudo umount /mnt/gramadovhd2
	sudo mount -t vfat -o loop,offset=32256 DISK.VHD /mnt/gramadovhd2/

	@echo "================================="
	@echo "Copying files ..."
	sudo mkdir /mnt/gramadovhd2/BOOT
	sudo cp bm/BM.BIN /mnt/gramadovhd2/BOOT/BM.BIN
	sudo cp bm/BM.BIN /mnt/gramadovhd2/BM.BIN

## Step7 vhd-unmount        - Unmounting the VHD.
vhd-unmount:
	@echo "================================="
	@echo "Unmounting the VHD ..."

	sudo umount /mnt/gramadovhd2


# qemu 
qemu-test:
	qemu-system-x86_64 -hda DISK.VHD -m 128 -device e1000 -show-cursor -serial stdio



clean:
	rm *.VHD
	
	
	
