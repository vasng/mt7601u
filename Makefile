obj-m += mt7601u.o

mt7601u-objs := main.o mcu.o trace.o phy.o mac.o util.o debugfs.o tx.o \
                dma.o core.o eeprom.o init.o usb.o

ccflags-y := -I$(src)

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
