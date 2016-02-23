
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name PipeAndDebug -dir "C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug/planAhead_run_3" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug/MainModule.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug} {ipcore_dir} }
add_files [list {ipcore_dir/instructionROM.ncf}] -fileset [get_property constrset [current_run]]
add_files [list {ipcore_dir/RAM.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "Datapath1.ucf" [current_fileset -constrset]
add_files [list {Datapath1.ucf}] -fileset [get_property constrset [current_run]]
link_design
