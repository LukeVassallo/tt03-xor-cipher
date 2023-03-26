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

################################################################
# This is a generated script based on design: dual_xor_fpga_test
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source dual_xor_fpga_test_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# dual_xor_stream_cipher, dual_xor_test_stimulus_1

# Please add the sources of those modules before sourcing this Tcl script.

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:vio:3.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
dual_xor_stream_cipher\
dual_xor_test_stimulus_1\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk [ create_bd_port -dir I clk ]
  set decrypted [ create_bd_port -dir O decrypted ]
  set encrypted [ create_bd_port -dir O encrypted ]
  set locked [ create_bd_port -dir O locked ]
  set plaintext [ create_bd_port -dir O plaintext ]
  set rst [ create_bd_port -dir I rst ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT1_JITTER {290.478} \
   CONFIG.CLKOUT1_PHASE_ERROR {133.882} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {10.000} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {15.625} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {78.125} \
   CONFIG.MMCM_DIVCLK_DIVIDE {2} \
 ] $clk_wiz_0

  # Create instance: dual_xor_stream_ciph_0, and set properties
  set block_name dual_xor_stream_cipher
  set block_cell_name dual_xor_stream_ciph_0
  if { [catch {set dual_xor_stream_ciph_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dual_xor_stream_ciph_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.M {32} \
 ] $dual_xor_stream_ciph_0

  # Create instance: dual_xor_test_stimul_0, and set properties
  set block_name dual_xor_test_stimulus_1
  set block_cell_name dual_xor_test_stimul_0
  if { [catch {set dual_xor_test_stimul_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dual_xor_test_stimul_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
   CONFIG.M {32} \
 ] $dual_xor_test_stimul_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0 ]
  set_property -dict [ list \
   CONFIG.C_DATA_DEPTH {32768} \
   CONFIG.C_ENABLE_ILA_AXI_MON {false} \
   CONFIG.C_MONITOR_TYPE {Native} \
   CONFIG.C_NUM_OF_PROBES {7} \
 ] $ila_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: vio_0, and set properties
  set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]
  set_property -dict [ list \
   CONFIG.C_NUM_PROBE_IN {3} \
   CONFIG.C_NUM_PROBE_OUT {3} \
   CONFIG.C_PROBE_OUT0_INIT_VAL {0x0000000048000000} \
   CONFIG.C_PROBE_OUT0_WIDTH {32} \
   CONFIG.C_PROBE_OUT1_INIT_VAL {0xABCDEFAB} \
   CONFIG.C_PROBE_OUT1_WIDTH {32} \
 ] $vio_0

  # Create port connections
  connect_bd_net -net Net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins dual_xor_stream_ciph_0/clk] [get_bd_pins dual_xor_test_stimul_0/clk] [get_bd_pins ila_0/clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net Net1 [get_bd_pins dual_xor_stream_ciph_0/rst] [get_bd_pins dual_xor_test_stimul_0/rst] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net Net3 [get_bd_pins dual_xor_test_stimul_0/rx_lfsr_taps] [get_bd_pins dual_xor_test_stimul_0/tx_lfsr_taps] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net Net4 [get_bd_pins dual_xor_test_stimul_0/rx_lfsr_state] [get_bd_pins dual_xor_test_stimul_0/tx_lfsr_state] [get_bd_pins vio_0/probe_out1]
  connect_bd_net -net clk_1 [get_bd_ports clk] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_locked [get_bd_ports locked] [get_bd_pins clk_wiz_0/locked] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net dual_xor_stream_ciph_0_cfg_o [get_bd_pins dual_xor_stream_ciph_0/cfg_o] [get_bd_pins dual_xor_test_stimul_0/cfg_i] [get_bd_pins ila_0/probe3]
  connect_bd_net -net dual_xor_stream_ciph_0_rx_p [get_bd_ports decrypted] [get_bd_pins dual_xor_stream_ciph_0/rx_p] [get_bd_pins dual_xor_test_stimul_0/decrypted] [get_bd_pins ila_0/probe6]
  connect_bd_net -net dual_xor_stream_ciph_0_tx_e [get_bd_ports encrypted] [get_bd_pins dual_xor_stream_ciph_0/rx_e] [get_bd_pins dual_xor_stream_ciph_0/tx_e] [get_bd_pins ila_0/probe5]
  connect_bd_net -net dual_xor_test_stimul_0_cfg_en [get_bd_pins dual_xor_stream_ciph_0/cfg_en] [get_bd_pins dual_xor_test_stimul_0/cfg_en] [get_bd_pins ila_0/probe1]
  connect_bd_net -net dual_xor_test_stimul_0_cfg_o [get_bd_pins dual_xor_stream_ciph_0/cfg_i] [get_bd_pins dual_xor_test_stimul_0/cfg_o] [get_bd_pins ila_0/probe2]
  connect_bd_net -net dual_xor_test_stimul_0_cfg_reg [get_bd_pins dual_xor_test_stimul_0/cfg_reg] [get_bd_pins vio_0/probe_in0]
  connect_bd_net -net dual_xor_test_stimul_0_datastream [get_bd_ports plaintext] [get_bd_pins dual_xor_stream_ciph_0/tx_p] [get_bd_pins dual_xor_test_stimul_0/datastream] [get_bd_pins ila_0/probe4]
  connect_bd_net -net dual_xor_test_stimul_0_en [get_bd_pins dual_xor_stream_ciph_0/rx_en] [get_bd_pins dual_xor_stream_ciph_0/tx_en] [get_bd_pins dual_xor_test_stimul_0/en] [get_bd_pins ila_0/probe0]
  connect_bd_net -net dual_xor_test_stimul_0_error_counter [get_bd_pins dual_xor_test_stimul_0/error_counter] [get_bd_pins vio_0/probe_in1]
  connect_bd_net -net dual_xor_test_stimul_0_errors [get_bd_pins dual_xor_test_stimul_0/errors] [get_bd_pins vio_0/probe_in2]
  connect_bd_net -net rst_1 [get_bd_ports rst] [get_bd_pins clk_wiz_0/reset]
  connect_bd_net -net vio_0_probe_out2 [get_bd_pins dual_xor_test_stimul_0/config_once] [get_bd_pins vio_0/probe_out2]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

}
# End of create_root_design()




proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "#"
   puts "# The following procedures will create hiearchical blocks with addressing "
   puts "# for IPs within those blocks and their sub-hierarchical blocks. Addressing "
   puts "# will not be handled outside those blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
