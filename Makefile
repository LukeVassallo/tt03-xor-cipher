JOBS ?= 2

all : basic_test signature_test

basic_test: dual_xor_basic_arty35t_vivado
	make -C dual_xor_basic_arty35t_vivado JOBS=${JOBS}
	
signature_test: dual_xor_signature_arty35t_vivado
	make -C dual_xor_signature_arty35t_vivado JOBS=${JOBS}
	
help:

	
clean :
	make -C dual_xor_basic_arty35t_vivado clean
	make -C dual_xor_signature_arty35t_vivado clean

