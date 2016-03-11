
################################################################
# This is a generated script based on design: minimal_bram_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source minimal_bram_design_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:0.9 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name minimal_bram_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list \
CONFIG.C_INCLUDE_SG {0} \
CONFIG.C_M_AXI_DATA_WIDTH {32} \
CONFIG.C_M_AXI_MAX_BURST_LEN {16} \
 ] $axi_cdma_0

  # Create instance: axi_interconnect_cdma, and set properties
  set axi_interconnect_cdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_cdma ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
CONFIG.NUM_SI {1} \
 ] $axi_interconnect_cdma

  # Create instance: axi_interconnect_mem, and set properties
  set axi_interconnect_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_mem ]
  set_property -dict [ list \
CONFIG.NUM_MI {3} \
 ] $axi_interconnect_mem

  # Create instance: bram, and set properties
  set bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 bram ]
  set_property -dict [ list \
CONFIG.Byte_Size {8} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Read_Width_A {32} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
CONFIG.Use_Byte_Write_Enable {true} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.Write_Width_A {32} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $bram

  # Create instance: bram_controller_0, and set properties
  set bram_controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 bram_controller_0 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $bram_controller_0

  # Create instance: bram_controller_1, and set properties
  set bram_controller_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 bram_controller_1 ]
  set_property -dict [ list \
CONFIG.DATA_WIDTH {32} \
CONFIG.ECC_TYPE {0} \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $bram_controller_1

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_GP0 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_USE_S_AXI_HP1 {0} \
CONFIG.PCW_USE_S_AXI_HP2 {0} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_interconnect_mem/S00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_cdma_M00_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins axi_interconnect_cdma/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_cdma_M01_AXI [get_bd_intf_pins axi_interconnect_cdma/M01_AXI] [get_bd_intf_pins bram_controller_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_mem_M00_AXI [get_bd_intf_pins axi_interconnect_mem/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_interconnect_mem_M02_AXI [get_bd_intf_pins axi_interconnect_mem/M02_AXI] [get_bd_intf_pins bram_controller_1/S_AXI]
  connect_bd_intf_net -intf_net bram_controller_0_BRAM_PORTA [get_bd_intf_pins bram/BRAM_PORTB] [get_bd_intf_pins bram_controller_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net bram_controller_1_BRAM_PORTA [get_bd_intf_pins bram/BRAM_PORTA] [get_bd_intf_pins bram_controller_1/BRAM_PORTA]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins axi_interconnect_cdma/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins axi_cdma_0/cdma_introut] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_interconnect_cdma/ACLK] [get_bd_pins axi_interconnect_cdma/M00_ACLK] [get_bd_pins axi_interconnect_cdma/M01_ACLK] [get_bd_pins axi_interconnect_cdma/S00_ACLK] [get_bd_pins axi_interconnect_mem/ACLK] [get_bd_pins axi_interconnect_mem/M00_ACLK] [get_bd_pins axi_interconnect_mem/M01_ACLK] [get_bd_pins axi_interconnect_mem/M02_ACLK] [get_bd_pins axi_interconnect_mem/S00_ACLK] [get_bd_pins bram_controller_0/s_axi_aclk] [get_bd_pins bram_controller_1/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_interconnect_cdma/ARESETN] [get_bd_pins axi_interconnect_mem/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_interconnect_cdma/M00_ARESETN] [get_bd_pins axi_interconnect_cdma/M01_ARESETN] [get_bd_pins axi_interconnect_cdma/S00_ARESETN] [get_bd_pins axi_interconnect_mem/M00_ARESETN] [get_bd_pins axi_interconnect_mem/M01_ARESETN] [get_bd_pins axi_interconnect_mem/M02_ARESETN] [get_bd_pins axi_interconnect_mem/S00_ARESETN] [get_bd_pins bram_controller_0/s_axi_aresetn] [get_bd_pins bram_controller_1/s_axi_aresetn] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]

  # Create address segments
  create_bd_addr_seg -range 0x2000 -offset 0x60000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs bram_controller_1/S_AXI/Mem0] SEG_bram_controller_1_Mem0
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000000 -offset 0x10000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] SEG_processing_system7_0_HP2_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x7E200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] SEG_axi_cdma_0_Reg
  create_bd_addr_seg -range 0x2000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs bram_controller_0/S_AXI/Mem0] SEG_bram_controller_0_Mem0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 460 -defaultsOSRD -left
preplace port FIXED_IO -pg 1 -y 480 -defaultsOSRD -left
preplace inst axi_interconnect_mem -pg 1 -lvl 4 -y 130 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 2 -y 40 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 3 -y 90 -defaultsOSRD
preplace inst bram_controller_0 -pg 1 -lvl 5 -y 1010 -defaultsOSRD
preplace inst axi_interconnect_cdma -pg 1 -lvl 2 -y 390 -defaultsOSRD
preplace inst bram_controller_1 -pg 1 -lvl 5 -y 420 -defaultsOSRD
preplace inst bram -pg 1 -lvl 6 -y 430 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 1 -y 180 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 0 2 NJ 460 NJ
preplace netloc bram_controller_1_BRAM_PORTA 1 5 1 2640
preplace netloc axi_cdma_0_M_AXI 1 3 1 1910
preplace netloc bram_controller_0_BRAM_PORTA 1 5 1 2640
preplace netloc processing_system7_0_M_AXI_GP0 1 1 1 NJ
preplace netloc axi_interconnect_cdma_M01_AXI 1 2 3 N 400 N 400 2250
preplace netloc axi_interconnect_cdma_M00_AXI 1 2 1 1550
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 1 1110
preplace netloc axi_interconnect_mem_M02_AXI 1 4 1 2250
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 4 1130 180 1540 180 1940 290 NJ
preplace netloc axi_cdma_0_cdma_introut 1 0 4 -60 -60 NJ -60 NJ -60 1900
preplace netloc processing_system7_0_FIXED_IO 1 0 2 NJ 480 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 3 1120 150 NJ 10 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 5 -40 60 1100 130 1560 170 1930 -30 NJ
preplace netloc axi_interconnect_mem_M00_AXI 1 0 5 -50 -50 NJ -50 NJ -50 NJ -50 2240
levelinfo -pg 1 -80 850 1360 1770 2090 2460 2790 2900 -top -70 -bot 1130
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


