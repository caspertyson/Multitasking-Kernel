#include "wramp.h"
int counter = 1;
//print character
void printChar(int c){
    while(!(WrampSp2->Stat & 2));
    WrampSp2->Tx = c;
}
//MAIN
void serial_main(){
    int i;
    int p;
    int arrayLength;
    int array1[10];
    int num;
    int print;
    char format = '1';
    int minutes;
    int one_minute;
    int tensOfMinutes;
    int seconds;
    int onesOfSeconds;
    int tensOfSeconds;
    while(1){
        num = counter;
        if(WrampSp2->Rx == '1' || WrampSp2->Rx == '2' || WrampSp2->Rx == '3' || WrampSp2->Rx == 'q'){
            format = WrampSp2->Rx;
        }
        if(format == 'q'){
            break;
        }
        printChar('\r');
        if(format == '1'){
            num = counter / 100; //num = amount of seconds
            minutes = num / 60; //minutes = amount of minutes
            seconds = (num - (minutes * 60));
            onesOfSeconds = seconds % 10;
            tensOfSeconds = seconds / 10;
            one_minute = minutes % 10;
            tensOfMinutes = minutes / 10;
        }
        for(i = 0; num != 0; i++){
            array1[i] = num % 10;
            num /= 10;
            arrayLength = i;
        }
        if(format == '1'){
            printChar(tensOfMinutes + 48);
            printChar(one_minute + 48);
            printChar(':');
            printChar(tensOfSeconds + 48);
            printChar(onesOfSeconds + 48);
            printChar(' ');
            printChar(' ');
        }
        if(format == '2' || format == '3'){
            for(p = arrayLength; p >= 0; p--){

                if(format == '1' && p == 1){
                    printChar(':');
                }
                if(format == '2' && p == 1){
                    printChar('.');
                }
                print = 48 + array1[p];
                printChar(print);
                if(p == 0){
                    printChar(' ');
                    printChar(' ');
                }
            }
        }
    }
    return;//$ra???
}
