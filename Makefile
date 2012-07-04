#  Project Name
PROJECT=main

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
OBJDUMP = arm-none-eabi-objdump
REMOVE = rm -f
SIZE = arm-none-eabi-size

OPTIMIZATION = s -fno-schedule-insns2 -fsection-anchors -fpromote-loop-indices -ffunction-sections -fdata-sections

#CFLAGS=-mcpu=cortex-m3 -mthumb -static -Os -I../mruby/include/ -I../mruby/include/mruby/ -L../mruby/lib/
#CFLAGS2=-static -Os -mcpu=cortex-m3 -mthumb -L../mruby/lib/ -I../mruby/include/ -I../mruby/include/mruby/
CFLAGS = -Wall -mcpu=cortex-m3 -mfloat-abi=softfp -mthumb -mfix-cortex-m3-ldrd -O$(OPTIMIZATION) -I../mruby/include/ -I../mruby/include/mruby/
CFLAGS += -D__RAM_MODE__=0

ASFLAGS = -mcpu=cortex-m3 --defsym RAM_MODE=0

#LDFLAGS=-T LPC17xx.ld -Wl,--no-warn-mismatch -static
LDFLAGS=-T ldscript_rom_gnu.ld -static -Wl,--no-warn-mismatch -L/Users/shota/Developer/Cross/arm-cs-tools-2011.09-69-0084249-20120622/arm-none-eabi/lib/thumb2/


# Platform specific setups
#include Make.params

#STRIP=$(COMMAND_PREFIX)strip

# Simple build rules

OBJECTS=startup_LPC17xx.o core_cm3.o system_LPC17xx.o $(PROJECT).o 

all:: $(PROJECT).hex $(PROJECT).bin $(PROJECT).lss

$(PROJECT).lss: $(PROJECT).elf
	$(OBJDUMP) -h -S $(PROJECT).elf > $(PROJECT).lss

$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary -j .text -j .data $(PROJECT).elf $(PROJECT).bin

$(PROJECT).hex: $(PROJECT).elf
	$(OBJCOPY) -R .stack -O ihex $(PROJECT).elf $(PROJECT).hex

$(PROJECT).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(PROJECT).elf ../mruby/lib/libmruby.a -lm

stats: $(PROJECT).elf
	$(SIZE) $(PROJECT).elf

clean:
	$(REMOVE) $(OBJECTS)
	$(REMOVE) $(PROJECT).bin
	$(REMOVE) $(PROJECT).elf
	$(REMOVE) $(PROJECT).hex
	$(REMOVE) $(PROJECT).lss
	$(REMOVE) $(PROJECT).map

#########################################################################
#  Default rules to compile .c and .cpp file to .o
#  and assemble .s files to .o

.c.o :
	$(CC) $(CFLAGS) -c $<

.cpp.o :
	$(CC) $(CFLAGS) -c $<

.S.o :
	$(AS) $(ASFLAGS) -o $@ $<

#########################################################################