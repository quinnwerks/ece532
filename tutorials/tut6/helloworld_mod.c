#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"

volatile unsigned int* myip_base = (unsigned int*) XPAR_MYIP_0_S00_AXI_BASEADDR;

int main()
{
    init_platform();

    print("Writing to Registers\n\r");
    *(myip_base+0) = 7;
    *(myip_base+1) = 12;
    *(myip_base+2) = 67;
    *(myip_base+3) = 1;

    cleanup_platform();
    return 0;
}
