# Create a new project
create_project proj_p3 ./proj -part xc7a100tcsg324-1 -force
set_property target_language Verilog [current_project]

# Add all design files
add_files -norecurse cube532.v
add_files -fileset constrs_1 -norecurse clock.xdc
add_files -fileset sim_1 -norecurse cube.mem

# Set properties
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-no_iobuf -mode out_of_context} -objects [get_runs synth_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
