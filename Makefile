JOBS ?= 2

all : basic_arty35t_vivado signature_arty35t_vivado basic_ice40up5k_foss signature_ice40up5k_foss

basic_arty35t_vivado : dual_xor_basic_arty35t_vivado
	make -C dual_xor_basic_arty35t_vivado JOBS=${JOBS}
	
signature_arty35t_vivado : dual_xor_signature_arty35t_vivado
	make -C dual_xor_signature_arty35t_vivado JOBS=${JOBS}
	
basic_ice40up5k_foss:
	make -C dual_xor_basic_ice40up5_foss

signature_ice40up5k_foss:	
	make -C dual_xor_signature_ice40up5_foss
help:

	
clean :
	make -C dual_xor_basic_arty35t_vivado clean
	make -C dual_xor_signature_arty35t_vivado clean
	make -C dual_xor_basic_ice40up5_foss clean
	make -C dual_xor_signature_ice40up5_foss clean
	
