# Create a new project
create_project proj_p1 ./proj -part xc7a100tcsg324-1 -force
set_property target_language Verilog [current_project]

# Add all design files
add_files -norecurse mask532.sv
add_files -fileset sim_1 -norecurse part1_tb.sv
