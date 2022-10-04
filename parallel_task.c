#include "wramp.h"
void parallel_main(){
    int switches = 0;
    int mask;
    int num = 0;
    int counter = 1;
    int decimal = 2;

    while(1){
        switches = WrampParallel->Switches;
        //IF MIDDLE BUTTON IS PRESSED
        if(WrampParallel->Buttons & 0x2){
            decimal = 1;
        }
        if(decimal == 1){
            counter = 1;
            num = 0; 
            for(mask = 0; mask < 4; mask++){
                num = switches % 10;
                if(counter == 1){
                    WrampParallel->LowerRightSSD = num;
                }
                else if(counter == 2){
                    WrampParallel->LowerLeftSSD = num;
                }
                else if(counter == 3){
                    WrampParallel->UpperRightSSD = num;
                }
                else{
                    WrampParallel->UpperLeftSSD = num;
                }
                counter++;
                switches = switches / 10;
            }
        }
            //IF RIGHT BUTTON PRESSED
        if(WrampParallel->Buttons & 0x1){
            decimal = 2;
        }
        if(decimal == 2){
            counter = 1;
            num = 0;
            for(mask = 0xF000; mask != 0; mask >>= 4){
                num = mask & switches;
                if(counter == 1){
                    num >>= 12;
                    WrampParallel->UpperLeftSSD = num;
                }
                else if(counter == 2){
                    num >>= 8;
                    WrampParallel->UpperRightSSD = num;
                }
                else if(counter == 3){
                    num >>= 4;
                    WrampParallel->LowerLeftSSD = num;
                }
                else{
                    WrampParallel->LowerRightSSD = num;
                }
                counter++;
            }
        }
        if(WrampParallel->Buttons & 0x4){
            break;
        }
	}
    //$ra?
    return;
}
