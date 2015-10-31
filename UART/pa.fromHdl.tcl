
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name UART -dir "C:/Users/Ariel/Xilinx/Workspace/UART/planAhead_run_5" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "UART_echo_test_module.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {tx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {rx.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {fifo_interface.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {baud_rate_generator.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {UART_echo_test_module.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top UART_echo_test_module $srcset
add_files [list {UART_echo_test_module.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
