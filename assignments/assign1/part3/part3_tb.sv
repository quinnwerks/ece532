`timescale 1ns / 1ps

import axi_vip_pkg::*;
import design_1_axi_vip_1_0_pkg::*;


// test module to drive the AXI VIP
module axi_lite_stimulus();

	//Your Code Here
  design_1_axi_vip_1_0_mst_t                               agent;

  /*************************************************************************************************
  * Declare variables which will be used in API and parital randomization for transaction generation
  * and data read back from driver.
  *************************************************************************************************/
  axi_transaction                                          wr_trans;            // Write transaction
  axi_transaction                                          rd_trans;            // Read transaction
  xil_axi_uint                                             mtestWID;            // Write ID
  xil_axi_ulong                                            mtestWADDR;          // Write ADDR
  xil_axi_len_t                                            mtestWBurstLength;   // Write Burst Length
  xil_axi_size_t                                           mtestWDataSize;      // Write SIZE
  xil_axi_burst_t                                          mtestWBurstType;     // Write Burst Type
  xil_axi_lock_t                                           mtestWLock;          // Write Lock Type
  xil_axi_cache_t                                          mtestWCache;          // Write Cache Type
  xil_axi_prot_t                                           mtestWProt;          // Write Prot Type
  xil_axi_region_t                                         mtestWRegion;        // Write Region Type
  xil_axi_qos_t                                            mtestWQos;           // Write Qos Type
  xil_axi_uint                                             mtestRID;            // Read ID
  xil_axi_ulong                                            mtestRADDR;          // Read ADDR
  xil_axi_len_t                                            mtestRBurstLength;   // Read Burst Length
  xil_axi_size_t                                           mtestRDataSize;      // Read SIZE
  xil_axi_burst_t                                          mtestRBurstType;     // Read Burst Type
  xil_axi_lock_t                                           mtestRLock;          // Read Lock Type
  xil_axi_cache_t                                          mtestRCache;         // Read Cache Type
  xil_axi_prot_t                                           mtestRProt;          // Read Prot Type
  xil_axi_region_t                                         mtestRRegion;        // Read Region Type
  xil_axi_qos_t                                            mtestRQos;           // Read Qos Type

  xil_axi_data_beat                                        Rdatabeat[];       // Read data beats

//Constants
//AXI GPIO base address and register offsets
localparam M532_BASE_ADDR = 'h80000000;
localparam N_VALUE_OFFSET = 'h0;
localparam VALUE_IN_OFFSET = 'h4;
localparam ADDR_OUT_OFFSET = 'h8;
localparam BEGIN_TXN_OFFSET = 'hC;

localparam MEM_WRITE_ADDR = 'h00000004;
  initial begin
    /***********************************************************************************************
    * Before agent is newed, user has to run simulation with an empty testbench to find the hierarchy
    * path of the AXI VIP's instance.Message like
    * "Xilinx AXI VIP Found at Path: my_ip_exdes_tb.DUT.ex_design.axi_vip_mst.inst" will be printed
    * out. Pass this path to the new function.
    ***********************************************************************************************/
    agent = new("master vip agent",DUT.design_1_i.axi_vip_1.inst.IF);
    agent.start_master();               // agent start to run


    //Put test vectors here

    //Turn on LED 0,1,3,5,7
    writeRegister(M532_BASE_ADDR + N_VALUE_OFFSET, 'h00000002);
    //readRegister(M532_BASE_ADDR + N_VALUE_OFFSET, Rdatabeat);

    //Set pushbutton GPIOs to input
    writeRegister(M532_BASE_ADDR + VALUE_IN_OFFSET, 'hFFFFFFFF);
    //readRegister(M532_BASE_ADDR + VALUE_IN_OFFSET, Rdatabeat);
    
    writeRegister(M532_BASE_ADDR + ADDR_OUT_OFFSET, MEM_WRITE_ADDR);
    //readRegister(M532_BASE_ADDR + ADDR_OUT_OFFSET, Rdatabeat);

    writeRegister(M532_BASE_ADDR + BEGIN_TXN_OFFSET, 'hFFFFFFFF);
   

    //Wait for all writes to complete
    agent.wait_drivers_idle();
    //Read push button values
    #500;
    readRegister(MEM_WRITE_ADDR, Rdatabeat);
    //Print read data to tcl console (similar to printf)
    $write("BRAM Data value: 0x%08x\n", Rdatabeat[0]);
 end


task writeRegister( input xil_axi_ulong           addr =0,
                    input bit [31:0]              data =0
                );

    single_write_transaction_api("single write with api",
                                 .addr(addr),
                                 .size(xil_axi_size_t'(4)),
                                 .data(data)
                                 );
endtask : writeRegister

  /************************************************************************************************
  *  task single_write_transaction_api is to create a single write transaction, fill in transaction
  *  by using APIs and send it to write driver.
  *   1. declare write transction
  *   2. Create the write transaction
  *   3. set addr, burst,ID,length,size by calling set_write_cmd(addr, burst,ID,length,size),
  *   4. set prot.lock, cache,region and qos
  *   5. set beats
  *   6. set AWUSER if AWUSER_WIDH is bigger than 0
  *   7. set WUSER if WUSR_WIDTH is bigger than 0
  *************************************************************************************************/

  task automatic single_write_transaction_api (
                                input string                     name ="single_write",
                                input xil_axi_uint               id =0,
                                input xil_axi_ulong              addr =0,
                                input xil_axi_len_t              len =0,
                                input xil_axi_size_t             size =xil_axi_size_t'(xil_clog2((32)/8)),
                                input xil_axi_burst_t            burst =XIL_AXI_BURST_TYPE_INCR,
                                input xil_axi_lock_t             lock = XIL_AXI_ALOCK_NOLOCK,
                                input xil_axi_cache_t            cache =3,
                                input xil_axi_prot_t             prot =0,
                                input xil_axi_region_t           region =0,
                                input xil_axi_qos_t              qos =0,
                                input xil_axi_data_beat [255:0]  wuser =0,
                                input xil_axi_data_beat          awuser =0,
                                input bit [32767:0]              data =0
                                                );
    axi_transaction                               wr_trans;
    wr_trans = agent.wr_driver.create_transaction(name);
    wr_trans.set_write_cmd(addr,burst,id,len,size);
    wr_trans.set_prot(prot);
    wr_trans.set_lock(lock);
    wr_trans.set_cache(cache);
    wr_trans.set_region(region);
    wr_trans.set_qos(qos);
    wr_trans.set_awuser(awuser);
    wr_trans.set_data_block(data);
    agent.wr_driver.send(wr_trans);
  endtask  : single_write_transaction_api

  //task automatic readRegister (  input xil_axi_ulong addr =0 );

    //single_read_transaction_api(.addr(addr));

  //endtask  : readRegister
  task automatic readRegister (
                                    input xil_axi_ulong              addr =0,
                                    output xil_axi_data_beat Rdatabeat[]
                                                );
    axi_transaction                               rd_trans;
    xil_axi_uint               id =0;
    xil_axi_len_t              len =0;
    xil_axi_size_t             size =xil_axi_size_t'(xil_clog2((32)/8));
    xil_axi_burst_t            burst =XIL_AXI_BURST_TYPE_INCR;
    xil_axi_lock_t             lock =XIL_AXI_ALOCK_NOLOCK ;
    xil_axi_cache_t            cache =3;
    xil_axi_prot_t             prot =0;
    xil_axi_region_t           region =0;
    xil_axi_qos_t              qos =0;
    xil_axi_data_beat          aruser =0;
    rd_trans = agent.rd_driver.create_transaction("single-read");
    rd_trans.set_read_cmd(addr,burst,id,len,size);
    rd_trans.set_prot(prot);
    rd_trans.set_lock(lock);
    rd_trans.set_cache(cache);
    rd_trans.set_region(region);
    rd_trans.set_qos(qos);
    rd_trans.set_aruser(aruser);
    get_rd_data_beat_back(rd_trans,Rdatabeat);
  endtask  : readRegister

  /************************************************************************************************
  * Task send_wait_rd is a task which set_driver_return_item_policy of the read transaction,
  * send the transaction to the driver and wait till it is done
  *************************************************************************************************/
  task send_wait_rd(inout axi_transaction rd_trans);
    rd_trans.set_driver_return_item_policy(XIL_AXI_PAYLOAD_RETURN);
    agent.rd_driver.send(rd_trans);
    agent.rd_driver.wait_rsp(rd_trans);
  endtask

  /************************************************************************************************
  * Task get_rd_data_beat_back is to get read data back from read driver with
  *  data beat format.
  *************************************************************************************************/
  task get_rd_data_beat_back(inout axi_transaction rd_trans,
                                 output xil_axi_data_beat Rdatabeat[]
                            );
    send_wait_rd(rd_trans);
    Rdatabeat = new[rd_trans.get_len()+1];
    for( xil_axi_uint beat=0; beat<rd_trans.get_len()+1; beat++) begin
      Rdatabeat[beat] = rd_trans.get_data_beat(beat);
   //   $display("Read data from Driver: beat index %d, Data beat %h ", beat, Rdatabeat[beat]);
    end
  endtask


  /************************************************************************************************
  *  task single_read_transaction_api is to create a single read transaction, fill in command with user
  *  inputs and send it to read driver.
  *   1. declare read transction
  *   2. Create the read transaction
  *   3. set addr, burst,ID,length,size by calling set_read_cmd(addr, burst,ID,length,size),
  *   4. set prot.lock, cache,region and qos
  *   5. set ARUSER if ARUSER_WIDH is bigger than 0
  *************************************************************************************************/
  task automatic single_read_transaction_api (
                                    input string                     name ="single_read",
                                    input xil_axi_uint               id =0,
                                    input xil_axi_ulong              addr =0,
                                    input xil_axi_len_t              len =0,
                                    input xil_axi_size_t             size =xil_axi_size_t'(xil_clog2((32)/8)),
                                    input xil_axi_burst_t            burst =XIL_AXI_BURST_TYPE_INCR,
                                    input xil_axi_lock_t             lock =XIL_AXI_ALOCK_NOLOCK ,
                                    input xil_axi_cache_t            cache =3,
                                    input xil_axi_prot_t             prot =0,
                                    input xil_axi_region_t           region =0,
                                    input xil_axi_qos_t              qos =0,
                                    input xil_axi_data_beat          aruser =0
                                                );
    axi_transaction                               rd_trans;
    rd_trans = agent.rd_driver.create_transaction(name);
    rd_trans.set_read_cmd(addr,burst,id,len,size);
    rd_trans.set_prot(prot);
    rd_trans.set_lock(lock);
    rd_trans.set_cache(cache);
    rd_trans.set_region(region);
    rd_trans.set_qos(qos);
    rd_trans.set_aruser(aruser);
    agent.rd_driver.send(rd_trans);
  endtask  : single_read_transaction_api

endmodule


// testbench entry point
module part3_tb();

	reg aclk;
	reg aresetn;

	// instantiate the "design under test" module
	design_1_wrapper DUT(
		.clk(aclk),
		.resetn(aresetn)
		);

	// clock generator (100MHz)
	initial
	begin
		aclk = 0;
		forever
			#5ns aclk = ~aclk;
	end

	// start the testbench by resetting the system for 5 cycles
	initial
	begin
		aresetn = 0;
		repeat(5) @(posedge aclk);
		forever
			@(posedge aclk) aresetn = 1;
	end

	// instantiate instance of axi_lite_stimulus into the tb
	axi_lite_stimulus mst();

endmodule