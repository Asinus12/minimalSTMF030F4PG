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


**Building**  
```
mkdir build 
make clean && make 
```


**Flashing**   
```
make flash
```