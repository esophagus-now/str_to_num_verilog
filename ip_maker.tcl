# Call as:
# vivado -mode tcl -nolog -nojournal -source scripts/ip_package.tcl -tclargs $out_dir $ip_name $part_name

# start_gui

set out_dir [lindex $argv 0]
set ip_name [lindex $argv 1]
set part_name [lindex $argv 2]
set project_name ${ip_name}_tmp_proj
create_project ${project_name} ${project_name} -part ${part_name}
add_files ${out_dir}/src
ipx::package_project -root_dir ${out_dir} -vendor mmerlini -library yov -taxonomy /UserIP

# 'str' interface
ipx::add_bus_interface str [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]
set_property physical_name s_dtm [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]
set_property physical_name s_vld [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]
set_property physical_name s_rdy [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces str -of_objects [ipx::current_core]]]

# 'num' interface
ipx::add_bus_interface num [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]
ipx::add_port_map TDATA [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]
set_property physical_name n_dtm [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]]
ipx::add_port_map TVALID [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]
set_property physical_name n_vld [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]]
ipx::add_port_map TREADY [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]
set_property physical_name n_rdy [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces num -of_objects [ipx::current_core]]]

# Fix up 'clk' interface
ipx::add_bus_parameter ASSOCIATED_BUSIF [ipx::get_bus_interfaces clk -of_objects [ipx::current_core]]
set_property VALUE str:num [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces clk -of_objects [ipx::current_core ]]]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project 
exit

