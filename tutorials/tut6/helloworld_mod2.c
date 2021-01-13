#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "myip.h"

int main()
{
	init_platform();

	print("Writing to Registers\n\r");
	MYIP_mWriteReg(XPAR_MYIP_0_S00_AXI_BASEADDR, MYIP_S00_AXI_SLV_REG0_OFFSET, 7);
	MYIP_mWriteReg(XPAR_MYIP_0_S00_AXI_BASEADDR, MYIP_S00_AXI_SLV_REG1_OFFSET, 12);
	MYIP_mWriteReg(XPAR_MYIP_0_S00_AXI_BASEADDR, MYIP_S00_AXI_SLV_REG2_OFFSET, 67);
	MYIP_mWriteReg(XPAR_MYIP_0_S00_AXI_BASEADDR, MYIP_S00_AXI_SLV_REG3_OFFSET, 1);

	cleanup_platform();
	return 0;
}
