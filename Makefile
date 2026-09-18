obj-m += mt7601u.o

mt7601u-objs := main.o mcu.o trace.o phy.o mac.o util.o debugfs.o tx.o \
                dma.o core.o eeprom.o init.o usb.o

ccflags-y := -I$(src)

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
KERNEL_VER := $(shell uname -r)
MOD_PATH   := /lib/modules/$(KERNEL_VER)/kernel/drivers/net/wireless/mediatek

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

start:
	rmmod mt7601u 2>/dev/null || true
	insmod mt7601u.ko
	@dmesg | tail -n 30

install: default
	aarch64-linux-gnu-strip --strip-unneeded ./mt7601u.ko
	@echo "--- Install to kernel $(KERNEL_VER) ---"
	mkdir -p $(MOD_PATH)/mt7601u/
	rm -f $(MOD_PATH)/mt7601u.ko* 2>/dev/null || echo temp
	rm -f $(MOD_PATH)/mt7601u/mt7601u.ko* 2>/dev/null || true
	cp ./mt7601u.ko $(MOD_PATH)/mt7601u/
	depmod -a $(KERNEL_VER)
	@echo "--- Installed OK ---"

uninstall:
	@echo "--- Uninstalling mt7601u  ---"
	-rmmod mt7601u 2>/dev/null || true
	rm -rf $(MOD_PATH)/mt7601u/
	rm -f $(MOD_PATH)/mt7601u.ko* 2>/dev/null || true || echo temp
	depmod -a $(KERNEL_VER)
	@echo "--- Uninstalled OK ---"

