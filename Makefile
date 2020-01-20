


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
	sudo cp bm/BM.BIN /mnt/gramadovhd2


## Step7 vhd-unmount        - Unmounting the VHD.
vhd-unmount:
	@echo "================================="
	@echo "Unmounting the VHD ..."

	sudo umount /mnt/gramadovhd2



clean:
	rm *.VHD
	
	
	
