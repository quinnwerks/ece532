# Create a new project
create_project proj_p2 ./proj -part xc7a100tcsg324-1 -force
set_property target_language Verilog [current_project]

# Add all design files
add_files -norecurse ../part1/mask532.sv
add_files -norecurse mask_axi532.sv
