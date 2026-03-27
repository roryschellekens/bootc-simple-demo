#!/bin/bash

# === Configuration ===
VM_NAME="bootc-simple-demo"
VM_DIR="$HOME/VirtualBox VMs/$VM_NAME"
DISK_SIZE_MB=20480   # 20 GB
MEMORY_MB=4096
CPUS=4
DISK_PATH="output/vmdk/disk.vmdk"

# === Create VM ===
VBoxManage createvm --name "$VM_NAME" --ostype "Oracle9_arm64" --platform-architecture "arm"  --register --basefolder "$HOME/VirtualBox VMs"
# === Configure VM ===
VBoxManage modifyvm "$VM_NAME" \
    --memory $MEMORY_MB \
    --cpus $CPUS \
    --firmware efi \
    --vram 20 \
    --nic1 nat \
    --usb on \
    --usbehci on \
    --graphicscontroller QemuRamFB

# === Create virtual disk ===
#VBoxManage createmedium disk --filename "$DISK_PATH" --size $DISK_SIZE_MB --format VDI

# === Create SATA controller ===
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci

# === Attach disk and ISO ===
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$DISK_PATH"
#VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"

VBoxManage modifyvm $VM_NAME --natpf1 "ssh,tcp,127.0.0.1,2222,10.0.2.15,22"
# === Start VM ===
VBoxManage startvm "$VM_NAME"


# Fix Disk issue
# vi ~/Library/VirtualBox/VirtualBox.xml
#
