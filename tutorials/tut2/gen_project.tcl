start_gui
# Project setup
create_project project /home/quinn/ece532/tutorials/tut2/project -part xc7a100tcsg324-1
import_files -fileset constrs_1 -force -norecurse /home/quinn/ece532/tutorials/tut2/microblaze.xdc
create_bd_design "design_1"
update_compile_order -fileset sources_1
# Create microblaze
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {1} axi_periph {Enabled} cache {None} clk {New Clocking Wizard (100 MHz)} debug_module {Debug Only} ecc {None} local_mem {32KB} preset {None}}  [get_bd_cells microblaze_0]
set_property -dict [list CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} CONFIG.RESET_TYPE {ACTIVE_LOW} CONFIG.RESET_PORT {resetn}] [get_bd_cells clk_wiz_1]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto} rst_polarity {ACTIVE_LOW}}  [get_bd_pins clk_wiz_1/resetn]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Clk {New External Port (100 MHz)} Manual_Source {Auto}}  [get_bd_pins clk_wiz_1/clk_in1]
connect_bd_net [get_bd_ports reset_rtl_0] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]

# Create gpio
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property location {0.5 6 -198} [get_bd_cells axi_gpio_0]
set_property name gpio_led [get_bd_cells axi_gpio_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property location {2 225 -375} [get_bd_cells axi_gpio_0]
set_property name gpio_switch [get_bd_cells axi_gpio_0]
set_property -dict [list CONFIG.C_GPIO_WIDTH {2} CONFIG.C_ALL_INPUTS {1}] [get_bd_cells gpio_switch]
set_property -dict [list CONFIG.C_GPIO_WIDTH {2} CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells gpio_led]
make_bd_pins_external  [get_bd_pins gpio_switch/gpio_io_i]
make_bd_pins_external  [get_bd_pins gpio_led/gpio_io_o]

# Create uartlite
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
set_property location {4 1240 273} [get_bd_cells axi_uartlite_0]
connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells microblaze_0_xlconcat]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_1/clk_out1 (100 MHz)} Clk_slave {Auto} Clk_xbar {/clk_wiz_1/clk_out1 (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/gpio_led/S_AXI} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins gpio_led/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_1/clk_out1 (100 MHz)} Clk_slave {Auto} Clk_xbar {/clk_wiz_1/clk_out1 (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/gpio_switch/S_AXI} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins gpio_switch/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_1/clk_out1 (100 MHz)} Clk_slave {Auto} Clk_xbar {/clk_wiz_1/clk_out1 (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_uartlite_0/S_AXI} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Manual_Source {Auto}}  [get_bd_intf_pins axi_uartlite_0/UART]

# Validate design, generate wrapper and compile
validate_bd_design
save_bd_design
close_bd_design [get_bd_designs design_1]
make_wrapper -files [get_files /home/quinn/ece532/tutorials/tut2/project/project.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /home/quinn/ece532/tutorials/tut2/project/project.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
launch_runs impl_1 -to_step write_bitstream -jobs 2
