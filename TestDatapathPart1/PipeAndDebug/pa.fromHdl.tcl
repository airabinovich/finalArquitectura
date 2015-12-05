
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name PipeAndDebug -dir "C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug/planAhead_run_3" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "Datapath1.ucf" [current_fileset -constrset]
add_files [list {ipcore_dir/RAM.ngc}]
add_files [list {ipcore_dir/instructionROM.ngc}]
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
set hdlfile [add_files [list {SigExt.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {REGBANK_banco.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {MEM_WB.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {MemoryLoadMask.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/RAM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ipcore_dir/instructionROM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {IF_ID.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ID_EX.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {HazardsUnit.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {FE.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {EX_MEM.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {DebugUnit.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ControlUnit.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ALU.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Adder.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Datapath1.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top Datapath1 $srcset
add_files [list {Datapath1.ucf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/instructionROM.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/RAM.ncf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
