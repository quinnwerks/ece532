`timescale 1ns / 1ps

module mask_axi532
(
  input aclk,
  input aresetn,

  // AXI-Lite slave interface
  input [31:0]  S_AXI_AWADDR,
  input         S_AXI_AWVALID,
  output        S_AXI_AWREADY,

  input [31:0]  S_AXI_WDATA,
  input [3:0]   S_AXI_WSTRB,
  input         S_AXI_WVALID,
  output        S_AXI_WREADY,

  output [1:0]  S_AXI_BRESP,
  output        S_AXI_BVALID,
  input         S_AXI_BREADY,

  input [31:0]  S_AXI_ARADDR,
  input         S_AXI_ARVALID,
  output        S_AXI_ARREADY,

  output [31:0] S_AXI_RDATA,
  output [1:0]  S_AXI_RRESP,
  output        S_AXI_RVALID,
  input         S_AXI_RREADY,

  // AXI-Lite master interface
  output [31:0] M_AXI_AWADDR,
  output        M_AXI_AWVALID,
  input         M_AXI_AWREADY,

  output [31:0] M_AXI_WDATA,
  output [3:0]  M_AXI_WSTRB,
  output        M_AXI_WVALID,
  input         M_AXI_WREADY,

  input [1:0]   M_AXI_BRESP,
  input         M_AXI_BVALID,
  output        M_AXI_BREADY
);
	// Width of S_AXI data bus
	parameter integer C_S_AXI_DATA_WIDTH	= 32;
	// Width of S_AXI address bus
	parameter integer C_S_AXI_ADDR_WIDTH	= 4;
	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 1;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 4
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	// Modification 1: Register should be 1 bit wide
	reg                             slv_reg3;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;


    // Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end
	  else
	    begin
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when
	          // there is a valid write address and write data
	          // on the write address and data bus. This design
	          // expects no outstanding transactions.
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else
	        begin
	          axi_awready <= 1'b0;
	        end
	    end
	end

	// Implement axi_awaddr latching
	// This process is used to latch the address when both
	// S_AXI_AWVALID and S_AXI_WVALID are valid.
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end
	  else
	    begin
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end
	end

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is
	// de-asserted when reset is low.
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end
	  else
	    begin
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when
	          // there is a valid write address and write data
	          // on the write address and data bus. This design
	          // expects no outstanding transactions.
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end
	end

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      slv_reg2 <= 0;
	      slv_reg3 <= 0;
	    end
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          2'h0:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes
	                // Slave register 0
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	                slv_reg3 <= 1'b0;
	              end
	          2'h1:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes
	                // Slave register 1
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	                slv_reg3 <= 1'b0;
	              end
	          2'h2:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes
	                // Slave register 2
	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	                slv_reg3 <= 1'b0;
	              end
	          2'h3:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes
	                // Slave register 3
	                // MODIFICATION 1: Should be set to high when written to.
	                slv_reg3 <= 1'b1;
	              end
	          default : begin
	                      slv_reg0 <= slv_reg0;
	                      slv_reg1 <= slv_reg1;
	                      slv_reg2 <= slv_reg2;
	                      // MODIFICATION 1: Should go low after one cycle of being written to.
	                      slv_reg3 <= 1'b0;
	                    end
	        endcase
	      end
	  end
	end

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
	// This marks the acceptance of address and indicates the status of
	// write transaction.
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end
	  else
	    begin
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid)
	            //check if bready is asserted while bvalid is high)
	            //(there is a possibility that bready is always asserted high)
	            begin
	              axi_bvalid <= 1'b0;
	            end
	        end
	    end
	end

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is
	// de-asserted when reset (active low) is asserted.
	// The read address is also latched when S_AXI_ARVALID is
	// asserted. axi_araddr is reset to zero on reset assertion.
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end
	  else
	    begin
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end
	end

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers
	// data are available on the axi_rdata bus at this instance. The
	// assertion of axi_rvalid marks the validity of read data on the
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid
	// is deasserted on reset (active low). axi_rresp and axi_rdata are
	// cleared to zero on reset (active low).
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end
	  else
	    begin
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end
	    end
	end

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        2'h0   : reg_data_out <= slv_reg0;
	        2'h1   : reg_data_out <= slv_reg1;
	        2'h2   : reg_data_out <= slv_reg2;
	        // MODIFICATION 1: Last register should not be read to
	        //2'h3   : reg_data_out <= slv_reg3;
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge aclk )
	begin
	  if ( aresetn == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end
	  else
	    begin
	      // When there is a valid read address (S_AXI_ARVALID) with
	      // acceptance of read address by the slave (axi_arready),
	      // output the read dada
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end
	    end
	end

	// My code
	wire [4:0] n;
	wire [31:0] value_in;
	wire [31:0] output_addr;
	wire init_write;

	wire [31:0] value_out;

	assign n = slv_reg0[4:0];
	assign value_in = slv_reg1;
	assign output_addr = slv_reg2;
	assign init_write = slv_reg3;

    // Mask532 module
	mask532 ip (
	   .n(n),
	   .value_in(value_in),
	   .value_out(value_out)
	);

    // Master logic module
	axi_master_logic master (
	   .aclk(aclk),
	   .aresetn(aresetn),
	   .INIT_AXI_TXN(init_write),
	   .axi_awaddr(output_addr),
	   .axi_wdata(value_out),
	   .M_AXI_AWADDR(M_AXI_AWADDR),
	   .M_AXI_AWVALID(M_AXI_AWVALID),
	   .M_AXI_AWREADY(M_AXI_AWREADY),
	   .M_AXI_WDATA(M_AXI_WDATA),
	   .M_AXI_WSTRB(M_AXI_WSTRB),
	   .M_AXI_WVALID(M_AXI_WVALID),
	   .M_AXI_WREADY(M_AXI_WREADY),
	   .M_AXI_BRESP(M_AXI_BRESP),
	   .M_AXI_BVALID(M_AXI_BVALID),
	   .M_AXI_BREADY(M_AXI_BREADY)
	);

endmodule

module axi_master_logic (
  input aclk,
  input aresetn,
  input INIT_AXI_TXN,
  input reg [31:0] axi_awaddr,
  input [31:0] axi_wdata,

  // AXI-Lite master interface
  output [31:0] M_AXI_AWADDR,
  output        M_AXI_AWVALID,
  input         M_AXI_AWREADY,

  output [31:0] M_AXI_WDATA,
  output [3:0]  M_AXI_WSTRB,
  output        M_AXI_WVALID,
  input         M_AXI_WREADY,

  input [1:0]   M_AXI_BRESP,
  input         M_AXI_BVALID,
  output        M_AXI_BREADY
);

    // The master will start generating data from the C_M_START_DATA_VALUE value
	// parameter  C_M_START_DATA_VALUE	= 32'hAA000000;
	// The master requires a target slave base address.
    // The master will initiate read and write transactions on the slave with base address specified here as a parameter.
	//parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h40000000;
	// Width of M_AXI address bus.
    // The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
	parameter integer C_M_AXI_ADDR_WIDTH	= 32;
	// Width of M_AXI data bus.
    // The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
	parameter integer C_M_AXI_DATA_WIDTH	= 32;
	// Transaction number is the number of write
    // and read transactions the master will perform as a part of this example memory test.
	parameter integer C_M_TRANSACTIONS_NUM	= 1;
	// function called clogb2 that returns an integer which has the
	// value of the ceiling of the log base 2

	 function integer clogb2 (input integer bit_depth);
		 begin
		 for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
			 bit_depth = bit_depth >> 1;
		 end
	 endfunction

	// TRANS_NUM_BITS is the width of the index counter for
	// number of write or read transaction.
	localparam integer TRANS_NUM_BITS = clogb2(C_M_TRANSACTIONS_NUM-1);

	// Example State machine to initialize counter, initialize write transactions,
	// initialize read transactions and comparison of read data with the
	// written data words.
	parameter [1:0] IDLE = 2'b00, // This state initiates AXI4Lite transaction
			// after the state machine changes state to INIT_WRITE
			// when there is 0 to 1 transition on INIT_AXI_TXN
		INIT_WRITE   = 2'b01, // This state initializes write transaction,
			// once writes are done, the state machine
			// changes state to INIT_READ
		INIT_READ = 2'b10, // This state initializes read transaction
			// once reads are done, the state machine
			// changes state to INIT_COMPARE
		INIT_COMPARE = 2'b11; // This state issues the status of comparison
			// of the written data with the read data

	 reg [1:0] mst_exec_state;

	// AXI4LITE signals
	//write address valid
	reg  	axi_awvalid;
	//write data valid
	reg  	axi_wvalid;
	//read address valid
	reg  	axi_arvalid;
	//read data acceptance
	reg  	axi_rready;
	//write response acceptance
	reg  	axi_bready;
	//read addresss
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	//Asserts when there is a write response error
	wire  	write_resp_error;
	//Asserts when there is a read response error
	wire  	read_resp_error;
	//A pulse to initiate a write transaction
	reg  	start_single_write;
	//A pulse to initiate a read transaction
	reg  	start_single_read;
	//Asserts when a single beat write transaction is issued and remains asserted till the completion of write trasaction.
	reg  	write_issued;
	//Asserts when a single beat read transaction is issued and remains asserted till the completion of read trasaction.
	reg  	read_issued;
	//flag that marks the completion of write trasactions. The number of write transaction is user selected by the parameter C_M_TRANSACTIONS_NUM.
	reg  	writes_done;
	//flag that marks the completion of read trasactions. The number of read transaction is user selected by the parameter C_M_TRANSACTIONS_NUM
	reg  	reads_done;
	//The error register is asserted when any of the write response error, read response error or the data mismatch flags are asserted.
	reg  	error_reg;
	//index counter to track the number of write transaction issued
	reg [TRANS_NUM_BITS : 0] 	write_index;
	//index counter to track the number of read transaction issued
	reg [TRANS_NUM_BITS : 0] 	read_index;
	//Expected read data used to compare with the read data.
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	expected_rdata;
	//Flag marks the completion of comparison of the read data with the expected read data
	reg  	compare_done;
	//This flag is asserted when there is a mismatch of the read data with the expected read data.
	reg  	read_mismatch;
	//Flag is asserted when the write index reaches the last write transction number
	reg  	last_write;
	//Flag is asserted when the read index reaches the last read transction number
	reg  	last_read;
	reg  	init_txn_ff;
	reg  	init_txn_ff2;
	reg  	init_txn_edge;
	wire  	init_txn_pulse;

    reg ERROR;
	// I/O Connections assignments

	//Adding the offset address to the base addr of the slave
	assign M_AXI_AWADDR	= axi_awaddr;
	//AXI 4 write data
	assign M_AXI_WDATA	= axi_wdata;
	//assign M_AXI_AWPROT	= 3'b000;
	assign M_AXI_AWVALID	= axi_awvalid;
	//Write Data(W)
	assign M_AXI_WVALID	= axi_wvalid;
	//Set all byte strobes in this example
	assign M_AXI_WSTRB	= 4'b1111;
	//Write Response (B)
	assign M_AXI_BREADY	= axi_bready;
	//Read Address (AR)
	//assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_araddr;
	//assign M_AXI_ARVALID	= axi_arvalid;
	//assign M_AXI_ARPROT	= 3'b001;
	//Read and Read Response (R)
	//assign M_AXI_RREADY	= axi_rready;
	//Example design I/O
	//assign TXN_DONE	= compare_done;
	assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;


	//Generate a pulse to initiate AXI transaction.
	always @(posedge aclk)
	  begin
	    // Initiates AXI transaction delay
	    if (aresetn == 0 )
	      begin
	        init_txn_ff <= 1'b0;
	        init_txn_ff2 <= 1'b0;
	      end
	    else
	      begin
	        init_txn_ff <= INIT_AXI_TXN;
	        init_txn_ff2 <= init_txn_ff;
	      end
	  end


	//--------------------
	//Write Address Channel
	//--------------------

	// The purpose of the write address channel is to request the address and
	// command information for the entire transaction.  It is a single beat
	// of information.

	// Note for this example the axi_awvalid/axi_wvalid are asserted at the same
	// time, and then each is deasserted independent from each other.
	// This is a lower-performance, but simplier control scheme.

	// AXI VALID signals must be held active until accepted by the partner.

	// A data transfer is accepted by the slave when a master has
	// VALID data and the slave acknoledges it is also READY. While the master
	// is allowed to generated multiple, back-to-back requests by not
	// deasserting VALID, this design will add rest cycle for
	// simplicity.

	// Since only one outstanding transaction is issued by the user design,
	// there will not be a collision between a new request and an accepted
	// request on the same clock cycle.

	  always @(posedge aclk)
	  begin
	    //Only VALID signals must be deasserted during reset per AXI spec
	    //Consider inverting then registering active-low reset for higher fmax
	    if (aresetn == 0 || init_txn_pulse == 1'b1)
	      begin
	        axi_awvalid <= 1'b0;
	      end
	      //Signal a new address/data command is available by user logic
	    else
	      begin
	        if (start_single_write)
	          begin
	            axi_awvalid <= 1'b1;
	          end
	     //Address accepted by interconnect/slave (issue of M_AXI_AWREADY by slave)
	        else if (M_AXI_AWREADY && axi_awvalid)
	          begin
	            axi_awvalid <= 1'b0;
	          end
	      end
	  end


	  // start_single_write triggers a new write
	  // transaction. write_index is a counter to
	  // keep track with number of write transaction
	  // issued/initiated
	  always @(posedge aclk)
	  begin
	    if (aresetn == 0 || init_txn_pulse == 1'b1)
	      begin
	        write_index <= 0;
	      end
	      // Signals a new write address/ write data is
	      // available by user logic
	    else if (start_single_write)
	      begin
	        write_index <= write_index + 1;
	      end
	  end


	//--------------------
	//Write Data Channel
	//--------------------

	//The write data channel is for transfering the actual data.
	//The data generation is speific to the example design, and
	//so only the WVALID/WREADY handshake is shown here

	   always @(posedge aclk)
	   begin
	     if (aresetn == 0  || init_txn_pulse == 1'b1)
	       begin
	         axi_wvalid <= 1'b0;
	       end
	     //Signal a new address/data command is available by user logic
	     else if (start_single_write)
	       begin
	         axi_wvalid <= 1'b1;
	       end
	     //Data accepted by interconnect/slave (issue of M_AXI_WREADY by slave)
	     else if (M_AXI_WREADY && axi_wvalid)
	       begin
	        axi_wvalid <= 1'b0;
	       end
	   end


	//----------------------------
	//Write Response (B) Channel
	//----------------------------

	//The write response channel provides feedback that the write has committed
	//to memory. BREADY will occur after both the data and the write address
	//has arrived and been accepted by the slave, and can guarantee that no
	//other accesses launched afterwards will be able to be reordered before it.

	//The BRESP bit [1] is used indicate any errors from the interconnect or
	//slave for the entire write burst. This example will capture the error.

	//While not necessary per spec, it is advisable to reset READY signals in
	//case of differing reset latencies between master/slave.

	  always @(posedge aclk)
	  begin
	    if (aresetn == 0 || init_txn_pulse == 1'b1)
	      begin
	        axi_bready <= 1'b0;
	      end
	    // accept/acknowledge bresp with axi_bready by the master
	    // when M_AXI_BVALID is asserted by slave
	    else if (M_AXI_BVALID && ~axi_bready)
	      begin
	        axi_bready <= 1'b1;
	      end
	    // deassert after one clock cycle
	    else if (axi_bready)
	      begin
	        axi_bready <= 1'b0;
	      end
	    // retain the previous value
	    else
	      axi_bready <= axi_bready;
	  end

	//Flag write errors
	assign write_resp_error = (axi_bready & M_AXI_BVALID & M_AXI_BRESP[1]);




	//--------------------------------
	//User Logic
	//--------------------------------
	  //implement master command interface state machine
	  always @ ( posedge aclk)
	  begin
	    if (aresetn == 1'b0)
	      begin
	      // reset condition
	      // All the signals are assigned default values under reset condition
	        mst_exec_state  <= IDLE;
	        start_single_write <= 1'b0;
	        write_issued  <= 1'b0;
	        start_single_read  <= 1'b0;
	        read_issued   <= 1'b0;
	        compare_done  <= 1'b0;
	        ERROR <= 1'b0;
	      end
	    else
	      begin
	       // state transition
	        case (mst_exec_state)

	          IDLE:
	          // This state is responsible to initiate
	          // AXI transaction when init_txn_pulse is asserted
	            if ( init_txn_pulse == 1'b1 )
	              begin
	                mst_exec_state  <= INIT_WRITE;
	                ERROR <= 1'b0;
	                compare_done <= 1'b0;
	              end
	            else
	              begin
	                mst_exec_state  <= IDLE;
	              end

	          INIT_WRITE:
	            // This state is responsible to issue start_single_write pulse to
	            // initiate a write transaction. Write transactions will be
	            // issued until last_write signal is asserted.
	            // write controller
	            if (writes_done)
	              begin
	                mst_exec_state <= INIT_READ;//
	              end
	            else
	              begin
	                mst_exec_state  <= INIT_WRITE;

	                  if (~axi_awvalid && ~axi_wvalid && ~M_AXI_BVALID && ~last_write && ~start_single_write && ~write_issued)
	                    begin
	                      start_single_write <= 1'b1;
	                      write_issued  <= 1'b1;
	                    end
	                  else if (axi_bready)
	                    begin
	                      write_issued  <= 1'b0;
	                    end
	                  else
	                    begin
	                      start_single_write <= 1'b0; //Negate to generate a pulse
	                    end
	              end

	           INIT_COMPARE:
	             begin
	                 // This state is responsible to issue the state of comparison
	                 // of written data with the read data. If no error flags are set,
	                 // compare_done signal will be asseted to indicate success.
	                 ERROR <= error_reg;
	                 mst_exec_state <= IDLE;
	                 compare_done <= 1'b1;
	             end
	           default :
	             begin
	               mst_exec_state  <= IDLE;
	             end
	        endcase
	    end
	  end //MASTER_EXECUTION_PROC

	  //Terminal write count

	  always @(posedge aclk)
	  begin
	    if (aresetn == 0 || init_txn_pulse == 1'b1)
	      last_write <= 1'b0;

	    //The last write should be associated with a write address ready response
	    else if ((write_index == C_M_TRANSACTIONS_NUM) && M_AXI_AWREADY)
	      last_write <= 1'b1;
	    else
	      last_write <= last_write;
	  end

	  //Check for last write completion.

	  //This logic is to qualify the last write count with the final write
	  //response. This demonstrates how to confirm that a write has been
	  //committed.

	  always @(posedge aclk)
	  begin
	    if (aresetn == 0 || init_txn_pulse == 1'b1)
	      writes_done <= 1'b0;

	      //The writes_done should be associated with a bready response
	    else if (last_write && M_AXI_BVALID && axi_bready)
	      writes_done <= 1'b1;
	    else
	      writes_done <= writes_done;
	  end


	//-----------------------------
	//Example design error register
	//-----------------------------

	//Data Comparison
	// Register and hold any data mismatches, or read/write interface errors
	  always @(posedge aclk)
	  begin
	    if (aresetn == 0  || init_txn_pulse == 1'b1)
	      error_reg <= 1'b0;

	    //Capture any error types
	    else if (read_mismatch || write_resp_error || read_resp_error)
	      error_reg <= 1'b1;
	    else
	      error_reg <= error_reg;
	  end

endmodule
