set outDir .
create_project tutorial_tcl_with_sim $outDir/tutorial_tcl_with_sim -part xc7a100tcsg324-1
add_files -norecurse $outDir/tutorial.v
import_files -fileset constrs_1 -force -norecurse $outDir/tutorial.xdc
update_compile_order -fileset sources_1
synth_design -rtl -name rtl_1
set_property package_pin U16 [get_ports {led[7]}]
set_property iostandard LVCMOS33 [get_ports [list {led[7]}]]
set_property package_pin R13 [get_ports {swt[7]}]
set_property iostandard LVCMOS33 [get_ports [list {swt[7]}]]
set_property target_constrs_file \
$outDir/tutorial_tcl_with_sim/tutorial_tcl_with_sim.srcs/constrs_1/imports/tutorial_1/tutorial.xdc [current_fileset -constrset]
save_constraints -force
set_property SOURCE_SET sources_1 [get_filesets sim_1]
import_files -fileset sim_1 -norecurse $outDir/tutorial_tb.v
update_compile_order -fileset sim_1
set_property runtime 200ns [get_filesets sim_1]
launch_simulation -simset sim_1 -mode behavioral
launch_runs synth_1
wait_on_run synth_1
launch_runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
