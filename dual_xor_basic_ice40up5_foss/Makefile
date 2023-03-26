src = ../src/counter.v ../src/dual_xor_stream_cipher.v ../src/dual_xor_test_1.v ../src/lfsr.v ../src/signature.v  ./hdl/dual_xor_basic.v
filename = dual_xor_basic
top = dual_xor_basic
pcf_file = ./pcf/io.pcf

build:
	yosys -p "synth_ice40 -top $(top) -json $(filename).json" $(src)
	nextpnr-ice40 --up5k --json $(filename).json --pcf $(pcf_file) --asc $(filename).asc
	icepack $(filename).asc $(filename).bin

prog:
	iceprog -S $(filename).bin

prog_flash:
	iceprog $(filename).bin

clean:
	rm -rf $(filename).blif $(filename).asc $(filename).bin $(filename).json
