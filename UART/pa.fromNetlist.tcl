
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name UART -dir "C:/Users/Ariel/Xilinx/Workspace/UART/planAhead_run_1" -part xc7a100tcsg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Ariel/Xilinx/Workspace/UART/UART_echo_test_module.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Ariel/Xilinx/Workspace/UART} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "UART_echo_test_module.ucf" [current_fileset -constrset]
add_files [list {UART_echo_test_module.ucf}] -fileset [get_property constrset [current_run]]
link_design
