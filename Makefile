# Name of the binaries.
PROJ_NAME=minimalF030

# base folder
BASE_DIR=.
BUILD_DIR =./build

######################################################################
#                         SETUP SOURCES                              #
######################################################################

SRCS   = main.c
SRCS += startup3.s

######################################################################
#                         SETUP TOOLS                                #
######################################################################

TOOLS_DIR = /usr/bin

AS		= $(TOOLS_DIR)/arm-none-eabi-as
CC      = $(TOOLS_DIR)/arm-none-eabi-gcc
LD		= $(TOOLS_DIR)/arm-none-eabi-ld
OBJDUMP = $(TOOLS_DIR)/arm-none-eabi-objdump
OBJCOPY = $(TOOLS_DIR)/arm-none-eabi-objcopy


## Assembler options
AFLAGS = --warn  # Dont suppres warning messages or treat them as errors 
AFLAGS += --fatal-warnings	# treat warnings as errors 
AFLAGS +=  -mcpu=cortex-m0	# assemble for cortexm0

## Compiler options 
CFLAGS = -Wall 
CFLAGS += -O2 
#CFLAGS += -ffreestanding
CFLAGS += -mcpu=cortex-m0 
CFLAGS += -mthumb
#CFLAGS += -nostdlib
CFLAGS += -lc

## Linker options
#LFLAGS  = -nostartfiles # Do not use standard system startup files when linking, standard system libraries are used unless -nostdlib or -nodefaultlibs is used 
#LFLAGS += -nolibc # Do not use the C library or system libraries tightly coupled with it when linking
#LFLAGS += -nostdlib # Do not use the standard system startup files or libraries when linking. 
#LFLAGS += -nodefaultlibs

######################################################################
#                         SETUP TARGETS                              #
######################################################################

.PHONY: $(PROJ_NAME)

	mkdir $(BUILD_DIR)
$(PROJ_NAME): $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(AS) $(AFLAGS) startup3.s -o $(BUILD_DIR)/startup.o
	$(CC) $(CFLAGS) -c main.c -o $(BUILD_DIR)/main.o
	$(LD) $(LFLAGS) -T flash3.ld $(BUILD_DIR)/startup.o $(BUILD_DIR)/main.o -o $(BUILD_DIR)/$(PROJ_NAME).elf
	$(OBJDUMP) -D $(BUILD_DIR)/$(PROJ_NAME).elf > $(BUILD_DIR)/$(PROJ_NAME).list
	$(OBJCOPY) -O binary $(BUILD_DIR)/$(PROJ_NAME).elf $(BUILD_DIR)/$(PROJ_NAME).bin



clean:
	rm -rf  $(BUILD_DIR)/*

# Flash the STM32
flash: 
	st-flash write $(BUILD_DIR)/$(PROJ_NAME).bin 0x8000000
