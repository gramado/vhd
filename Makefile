


PHONY := all

all: DISK.VHD

	@echo "end"
DISK.VHD:
	nasm main.asm -o DISK.VHD   
	
	
vhd-mount:
	@echo "================================="
	@echo "(Step 3) Creating the directory to mount the VHD ..."

	-sudo mkdir /mnt/gramadovhd

	@echo "================================="
	@echo "(Step 5) Mounting the VHD ..."

	-sudo umount /mnt/gramadovhd
	sudo mount -t vfat -o loop,offset=32256 GRAMADO.VHD /mnt/gramadovhd/


## Step7 vhd-unmount        - Unmounting the VHD.
vhd-unmount:
	@echo "================================="
	@echo "(Step 7) Unmounting the VHD ..."

	sudo umount /mnt/gramadovhd



clean:
	rm *.VHD
	
	
	
