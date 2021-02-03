# Create a new project
create_project proj_p3 ./proj -part xc7a100tcsg324-1 -force
set_property target_language Verilog [current_project]

# Add all design files
add_files -fileset sim_1 -norecurse part3_tb.sv

# generate block diagram
create_bd_design "design_1"
update_compile_order -fileset sources_1

# add the AXI VIP
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1
set_property -dict [list CONFIG.PROTOCOL.VALUE_SRC USER] [get_bd_cells axi_vip_1]
set_property -dict [list CONFIG.PROTOCOL {AXI4LITE} CONFIG.INTERFACE_MODE {MASTER}] [get_bd_cells axi_vip_1]

# add bram and controller
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
set_property -dict [list CONFIG.PROTOCOL {AXI4LITE} CONFIG.SINGLE_PORT_BRAM {1} CONFIG.ECC_TYPE {0}] [get_bd_cells axi_bram_ctrl_0]

# add interconnects and system reset
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2}] [get_bd_cells axi_interconnect_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {1} CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_1]

# create ports
create_bd_port -dir I -type clk clk
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports clk]
create_bd_port -dir I -type rst resetn

# connect clocks
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_0/ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_0/S00_ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_0/M00_ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_0/M01_ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_vip_1/aclk]
connect_bd_net [get_bd_ports clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_1/S01_ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_1/M00_ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_1/S00_ACLK]
connect_bd_net [get_bd_ports clk] [get_bd_pins axi_interconnect_1/ACLK]

# connect resets
connect_bd_net [get_bd_ports resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_1/ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_vip_1/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_1/S01_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_1/M00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_1/S00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M01_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN]

# connect signals
connect_bd_intf_net [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
connect_bd_intf_net [get_bd_intf_pins axi_vip_1/M_AXI] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_interconnect_1/S00_AXI]

# regenerate layout
regenerate_bd_layout

# map the addresses
assign_bd_address
set_property range 4K [get_bd_addr_segs {axi_vip_1/Master_AXI/SEG_axi_bram_ctrl_0_Mem0}]
set_property offset 0x00000000 [get_bd_addr_segs {axi_vip_1/Master_AXI/SEG_axi_bram_ctrl_0_Mem0}]
save_bd_design

# Note - mask IP missing, need to add and connect to empty links on interconnects (and then map addresses again)
set_property  ip_repo_paths  ../../assign1 [current_project]
update_ip_catalog

create_bd_cell -type ip -vlnv user.org:user:mask_axi532:1.0 mask_axi532_0
set_property location {3 711 335} [get_bd_cells mask_axi532_0]
