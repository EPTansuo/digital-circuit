TOPNAME = top
NXDC_FILES = constr/top.nxdc
INC_PATH ?=

VERILATOR = verilator
# "-MMD"                  Creat .d dependency file;
# "--build"               Build model executable/library after Verilation;
# "-cc"                   Create C++ output
# "-O3"                   High-performance optimizations
# "--x-assign fast"       Assign non-initial Xs to this value
# "--x-initial fast"      Assign initial Xs to this value
# "--noassert"            不知道，man里也没有
VERILATOR_CFLAGS += -MMD --build -cc  \
				-O3 --x-assign fast --x-initial fast --noassert

BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)
DABWAR += --Wno-MULTIDRIVEN

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

# constraint file
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# project source
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp" ! -name "sim_bcd7seg.cpp" \
! -name "sim_encoder83.cpp")
#CSRCS = $(abspath ./csrc/sim_nvboard.cpp)
CSRCS += $(SRC_AUTO_BIND)

# rules for NVBoard
include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INCFLAGS = $(addprefix -I, $(INC_PATH))
CXXFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""
LDFLAGS += -lSDL2 -lSDL2_image

$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
# 这一段就是执行了个verilator命令
# "--top-module"         Name of top-level input module
# "-Mdir"                Name of top-level input module
# "--exe"                Link to create executable
# "-o"                   Name of final executable
# "-CFLAGS <flags>"      C++ compiler arguments for makefile指定一个GCC编译选项
# "-I <include-path>"    可以指定一个包含路径
# "-D<arg>[=value]"      可以给依赖文件前面加上宏，相当于#define <arg> = value
	$(VERILATOR) $(VERILATOR_CFLAGS) $(DABWAR) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CXXFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --trace --exe -o $(abspath $(BIN))

all: default

run: $(BIN)
	@$^

clean:
	rm -rf $(BUILD_DIR)


#MODULE_NAME = ps2_keyboard
#CMODULE = $(abspath ./csrc/sim_$(MODULE_NAME).cpp)
#VMODULE = $(shell find $(abspath ./vsrc) -name "*.v")
#
#check:
#	@rm -rf $(OBJ_DIR)
#	$(VERILATOR) --cc $(DABWAR) --Mdir $(OBJ_DIR) \
#	--top-module $(MODULE_NAME) \
#	--trace $(VMODULE)
#
#generate:
#	@rm -rf $(OBJ_DIR)
#	$(VERILATOR) --cc $(DABWAR) --Mdir $(OBJ_DIR) \
#	--top-module $(MODULE_NAME) \
#	--trace $(VMODULE) $(CMODULE)
#
#wave: $(VMODULE) $(CMODULE)
#	@rm -rf $(OBJ_DIR)
#	$(VERILATOR) --cc $(DABWAR) --Mdir $(OBJ_DIR) \
#	--top-module $(MODULE_NAME) \
#	--trace --build --exe $(VMODULE) $(CMODULE)
#	$(OBJ_DIR)/V$(MODULE_NAME)
#	gtkwave ./dump.vcd

.PHONY: default all clean run #generate wave
