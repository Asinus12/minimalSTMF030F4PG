# minimalSTMF030f4p6 # 

**Minimal bare-metal project for exploring Cortex-M0 architecture**

- only loads with BOOT0 pin high 

**Dependancies** 
You need arm-none-eabi and stlink installed
```
sudo apt install arm-none-eabi 
git clone https://github.com/stlink-org/stlink.git
sudo apt install xxd 
```
**Referemces** 
- ARM and Thumb instrction set 
    https://developer.arm.com/documentation/dui0489/i/arm-and-thumb-instructions/ldr--register-offset-
- Assembler 
    https://docs.huihoo.com/redhat/rhel-4-docs/rhel-as-en-4/index.html  
- Video of building from zero 
    https://www.youtube.com/watch?v=7stymN3eYw0
    

**Creating a static library foo.a**
```
arm-none-eabi-gcc -c foo.c
arm-none-eabi-ar -rc libfoo.a foo.o
arm-none-eabi-gcc -L. -lfoo main.c -o main

```

**Building**  
```
mkdir build 
make clean && make 
```


**Flashing**   
```
make flash
```

**Debuging** 
- Show section sizes of executable 
```
    arm-none-eabi-size build/minimalF030.elf
```