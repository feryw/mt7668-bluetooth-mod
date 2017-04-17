export KERNEL_SRC := /lib/modules/$(shell uname -r)/build

###############################################################################
# USB
###############################################################################
USB_MOD_NAME = btmtk_usb
USB_CFILES := \
	btmtk_usb_main.c \
	btmtk_usb_dbgfs.c \
	btmtk_usb_fifo.c
$(USB_MOD_NAME)-objs := $(USB_CFILES:.c=.o)

###############################################################################
# SDIO
###############################################################################
VPATH = /opt/toolchains/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux
SDIO_MOD_NAME = btmtksdio
SDIO_CFILES := \
	btmtk_sdio.c btmtk_main.c
$(SDIO_MOD_NAME)-objs := $(SDIO_CFILES:.c=.o)

###############################################################################
# Common
###############################################################################
obj-m := $(USB_MOD_NAME).o $(SDIO_MOD_NAME).o

all:
	make -C $(KERNEL_SRC) M=$(PWD) modules

usb:
	make -C $(KERNEL_SRC) M=$(PWD) $(USB_MOD_NAME).ko

sdio:
	#make -C $(KERNEL_SRC) M=$(PWD) $(SDIO_MOD_NAME).ko
	make -C /Projects/ZTE/linux M=$(PWD) modules ARCH=arm64 CROSS_COMPILE=/opt/toolchains/gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux/bin/aarch64-linux-gnu-

clean:
	make -C $(KERNEL_SRC) M=$(PWD) clean

# Check coding style
export IGNORE_CODING_STYLE_RULES := NEW_TYPEDEFS,LEADING_SPACE,CODE_INDENT,SUSPECT_CODE_INDENT
ccs:
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_usb_main.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_usb_main.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_config.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_define.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_usb_dbgfs.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_usb_dbgfs.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_usb_fifo.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_usb_fifo.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_drv.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_main.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_sdio.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_sdio.h


