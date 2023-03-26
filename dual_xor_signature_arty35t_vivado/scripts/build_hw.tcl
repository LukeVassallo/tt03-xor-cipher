# Copyright 2023 Luke Vassallo
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set outputdir work
set projectName work
set partNumber xc7a35tcsg324-1
set jobs 4

# TODO: Input validation
if { $argc != 0 } {
    puts "Changing the number of jobs from $jobs to [lindex $argv 0]"
    set jobs [lindex $argv 0]
    puts "Variable jobs now contains the value $jobs"
}

file mkdir $outputdir

create_project -part $partNumber $projectName $outputdir

add_files -fileset constrs_1 xdc/arty_a7_35t_constraints.xdc
add_files -fileset sources_1 ../src/counter.v
add_files -fileset sources_1 ../src/dual_xor_stream_cipher.v
add_files -fileset sources_1 ../src/dual_xor_test_2.v
add_files -fileset sources_1 ../src/lfsr.v
add_files -fileset sources_1 ../src/mux.v
add_files -fileset sources_1 ../src/signature.v
add_files -fileset sources_1 ../src/serial2parallel.v
add_files -fileset sources_1 ../src/uart_tx.v
add_files -fileset sim_1 ./tb/dual_xor_fpga_signature_tb.v

set_property top dual_xor_signature_tb [get_filesets sim_1]
update_compile_order -fileset sim_1


# Create an empty block diagram
create_bd_design -name dual_xor_fpga_signature -dir ./bd   

# Import .tcl procs ( these are user designs previously exported. )
source scripts/build_bd.tcl    

# Built it
create_root_design ""

# generate a wrapper (top - file) for the block design.
make_wrapper -top [get_files bd/dual_xor_fpga_signature/dual_xor_fpga_signature.bd]

# add the hdl wrapper to the project
add_files -fileset sources_1 bd/dual_xor_fpga_signature/hdl/dual_xor_fpga_signature_wrapper.v

# define top module for the current fileset.
set_property top dual_xor_fpga_signature_wrapper [get_filesets sources_1]
update_compile_order -fileset sources_1

launch_runs -jobs $jobs synth_1	; # launched in the background
wait_on_run synth_1	; # therefore we must wait before proceeding

launch_runs impl_1 -jobs $jobs -to_step write_bitstream
wait_on_run impl_1

puts "Build complete."

puts "Running write bitstream"

write_hw_platform -fixed -force -include_bit hw/dual_xor_fpga_signature_wrapper.xsa
write_bitstream -file hw/dual_xor_fpga_signature_wrapper.bit
write_debug_probes -file hw/dual_xor_fpga_signature_wrapper.ltx

close_project

