#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"

#define MEMSIZE 16
volatile unsigned int* membase = (unsigned int*) XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR;

int main()
{
    int i, val, err = 0;
    
    init_platform();
    
    print("Writing to Memory\n\r");
    for(i = 0; i < MEMSIZE; i++)
    {
        *(membase+i) = i+1;
    }
    
    print("Reading from Memory\n\r");
    for(i = 0; i < MEMSIZE; i++)
    {
        val = *(membase+i);
        
        if(val != i+1) 
        {
            xil_printf("Error: at addr \%x, read \%d but expected \%d\n\r", membase+i, val, i+1);
            err = 1;
        }
    }
    
    if(!err)
    {
        print("No errors encountered\n\r");
    }

    cleanup_platform();
    return 0;
}