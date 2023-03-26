all : dual_xor_basic_arty35t_vivado/hw/dual_xor_basic_arty35t_vivado.xsa dual_xor_signature_arty35t_vivado/hw/dual_xor_signature_arty35t_vivado.xsa

basic_test: dual_xor_basic_arty35t_vivado
	make -C dual_xor_basic_arty35t_vivado 
	
signature_test: dual_xor_signature_arty35t_vivado
	make -C dual_xor_signature_arty35t_vivado
	
help:

	
clean :
	make -C dual_xor_basic_arty35t_vivado clean
	make -C dual_xor_signature_arty35t_vivado clean

