tool_version=2020.2
VIVADO ?= vivado
XSCT ?= xsct 
JOBS ?= 2

all : hw_pfm 

hw_pfm : 
	@echo "Starting Vivado ${tool_version}"
	@${VIVADO} -nolog -nojournal -mode batch -source scripts/build_hw.tcl -tclargs ${JOBS}

env_info:
	@echo "VIVADO is ${VIVADO}"
	@echo "XSCT is ${XSCT}"
	
help:
	@echo "If Xilinx toolchain is on the PATH variable, simply run the script."
	@echo "Alternatively supply the xilinx tools to make like so:"
	@echo "make VIVADO=<path-to-vivado> XSCT=<path-to-xcst> <target>"
	@echo "" 	# Empty link for visual segmentation.
	@echo "Available targets: "
	@echo "    -> hw_pfm		: Creates the hardware platform."
	@echo "    -> clean			: Cleans everything."
	@echo "    -> env_info 		: Prints the environment information."
	
clean :
	@echo "Cleaning ..."
	@echo -n "Attempting to clean the bd directory ... "
	@if [ ! -d "bd" ]; then \
		echo "Not found, therefore nothing to clean."; \
 	else \
 		echo "Found, deleting."; \
 		rm -fr ./bd ; \
 	fi

	@echo -n "Attempting to clean the work directory ... "
	@if [ ! -d "work" ]; then \
		echo "Not found, therefore nothing to clean."; \
 	else \
 		echo "Found, deleting."; \
 		rm -fr ./work ; \
 	fi
	
	@echo -n "Attempting to clean the hw directory ... "
	@if [ ! -d "hw" ]; then \
		echo "Not found, therefore nothing to clean."; \
 	else \
 		echo "Found, deleting."; \
 		rm -fr ./hw ; \
 	fi

