TOP = MyModule
MAIN = MyModule.MyModule
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/OBJ_DIR
TOPNAME = MyModule
TOP_V = $(BUILD_DIR)/verilog/$(TOPNAME).v

SCALA_FILE = $(shell find ./src/main -name '*.scala')
VERILATOR_CONFIG = config/verilator.vlt
VERILATOR = verilator
VERILATOR_COVERAGE = verilator_coverage
# verilator flags
VERILATOR_FLAGS += -Wall -MMD --trace --build -cc --exe \
									 -O3 --x-assign fast --x-initial fast --noassert -report-unoptflat

# timescale set
VERILATOR_FLAGS += --timescale 1us/1us

NXDC_FILES = config/top.nxdc
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@


# rules for NVBoard
include $(NVBOARD_HOME)/scripts/nvboard.mk

verilog: $(SCALA_FILE)
	@mkdir -p $(BUILD_DIR)/verilog
	./mill -i $(TOP).runMain $(MAIN) -td $(BUILD_DIR)/verilog

vcd ?= 
ifeq ($(vcd), 1)
	CFLAGS += -DVCD
endif

# C flags
INC_PATH += $(abspath ./csrc/include)
INCFLAGS = $(addprefix -I, $(INC_PATH))
CFLAGS += $(INCFLAGS) $(CFLAGS_SIM) -DTOP_NAME="V$(TOPNAME)"

# source file
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
CSRCS += $(SRC_AUTO_BIND)
VSRCS = $(shell find $(abspath $(BUILD_DIR)/verilog) -name "*.v" -or -name "*.sv")
#VSRCS += $(shell find $(abspath ./vsrc) -name "*.v" -or -name "*.sv")

 


BIN = $(BUILD_DIR)/$(TOP)
NPC_EXEC := $(BIN)

only_sim: $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CONFIG) $(VERILATOR_FLAGS) -top $(TOPNAME) $(CSRCS) $(VSRCS) \
		$(NVBOARD_ARCHIVE) $(addprefix -CFLAGS , $(CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) -o $(abspath $(BIN))
sim: verilog sim

run: sim only_run
	
only_run: only_sim
	@echo
	@echo "------------ RUN --------------"
	$(NPC_EXEC)
ifeq ($(vcd), 1)
	@echo "----- see vcd file in logs dir ----"
else
	@echo "----- if you need vcd file. add vcd=1 to make ----"
endif
	
srun: sim run

clean:
	-rm -rf $(BUILD_DIR) logs

clean_mill:
	-rm -rf out

clean_all: clean clean_mill

.PHONY: clean clean_all clean_mill srun run sim verilog
