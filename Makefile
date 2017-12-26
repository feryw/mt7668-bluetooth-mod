export KERNEL_SRC := /lib/modules/$(shell uname -r)/build

$(warning $(CC))

###############################################################################
# SDIO
###############################################################################
SDIO_MOD_NAME = btmtksdio
SDIO_CFILES := \
	btmtk_sdio.c btmtk_main.c
$(SDIO_MOD_NAME)-objs := $(SDIO_CFILES:.c=.o)
###############################################################################
# Common
###############################################################################
ifeq ($(PLATFORM),MT8516_YOCTO)
obj-m := $(SDIO_MOD_NAME).o
else
obj-m := $(USB_MOD_NAME).o $(SDIO_MOD_NAME).o
endif

all:
	make -C $(KERNEL_SRC) M=$(PWD) modules

sdio:
ifeq ($(PLATFORM),MT8516_YOCTO)
	make -C $(LINUX_SRC) M=$(PWD) modules
else
	make -C $(KERNEL_SRC) M=$(PWD) $(SDIO_MOD_NAME).ko
endif

clean:
	make -C $(KERNEL_SRC) M=$(PWD) clean
# Check coding style
export IGNORE_CODING_STYLE_RULES := NEW_TYPEDEFS,LEADING_SPACE,CODE_INDENT,SUSPECT_CODE_INDENT
ccs:
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_config.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_define.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_drv.h
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_main.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_sdio.c
	./util/checkpatch.pl --no-tree --show-types --max-line-length=120 --ignore $(IGNORE_CODING_STYLE_RULES) -f btmtk_sdio.h

