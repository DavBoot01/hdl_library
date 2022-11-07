VHDLEX = vhd

RTLDIR := rtl
SOURCEDIR := source
TBDIR := testbench
SIMDIR := simulation

#ARGUMENTS
SIMULATION := ${simulation}

#GHDL CONFIG
GHDL := ghdl-llvm
GHDL_FLAGS :=
GHDL_OPTS := --std=08 --work=hdl_project --workdir=simulation

#SIMULATION OPTIONS
WAVEFORM_VIEWER := gtkwave
GHDL_SIM_POTS = --vcd=simulation/$(SIMULATION).vcd $(shell cat simulation/sim_ops | \
grep $(SIMULATION) | \
awk -F ':' '{print $$2}' )

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(patsubst %/,%,$(dir $(mkfile_path)))
PROJECT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

project_src_folder := 
SOURCE_FILES :=

#TARGET FILE
project_src_folder := $(PROJECT_DIR)/$(SOURCEDIR)

SOURCE_FILES := $(foreach dir, $(project_src_folder), $(wildcard $(dir)/*.$(VHDLEX)))
OBJ_SOURCE := $(patsubst %, $(PROJECT_DIR)/$(SIMDIR)/%, $(notdir $(SOURCE_FILES:.$(VHDLEX)=.o)))

TB_FILES := $(wildcard $(PROJECT_DIR)/$(TBDIR)/*.$(VHDLEX))
OBJ_TB := $(patsubst %, $(PROJECT_DIR)/$(SIMDIR)/%, $(notdir $(TB_FILES:.$(VHDLEX)=.o)))

EXEC_TEST := $(OBJ_TB:%.o=%)


# Define the function that will generate each rule
# Used to anlyzing step
define generateAnalyzingRules
$(PROJECT_DIR)/$(SIMDIR)/$(notdir $(1:.$(VHDLEX)=.o)): $(1)
	@echo " - Analyzing of $$@ from $$<"
	@$(GHDL) -a $(GHDL_FLAGS) $(GHDL_OPTS) $$<
endef


# Define the function that will generate each rule
# Used to elaboration step
define generateElaborationRules
$(PROJECT_DIR)/$(SIMDIR)/$(notdir $(1:.o=)): $(1)
	@echo " - Elaboration of $$@"
	@$(GHDL) -e $(GHDL_FLAGS) $(GHDL_OPTS) -o $$@ $$(notdir $$@)
endef


.PHONY: clean compile analysis_sources analysis_testbenches \
elaborate_testbench list run


# Generate rules
$(foreach obj, $(SOURCE_FILES), $(eval $(call generateAnalyzingRules, $(obj))))
$(foreach obj, $(TB_FILES), $(eval $(call generateAnalyzingRules, $(obj))))
$(foreach obj, $(OBJ_TB), $(eval $(call generateElaborationRules, $(obj))))


analysis_sources: $(OBJ_SOURCE)
	@echo
	@echo "========== Analysis of IP(s) source code complete =========="
	@echo


analysis_testbenches: $(OBJ_TB)
	@echo
	@echo "========== Analysis of Testbench(s) source code complete =========="
	@echo


elaborate_testbench: $(EXEC_TEST)
	@echo
	@echo "========== Elaboration complete =========="
	@echo

compile: analysis_sources analysis_testbenches elaborate_testbench
	@echo
	@echo "========== Compilation complete =========="
	@echo
	@echo "List of executable simulation:"
	@for i in $(EXEC_TEST); do \
		echo " - $${i##*/}"; \
	done
	@echo

list: 
	@echo "******************************"
	@echo "List of executable simulation:"
	@for i in $(EXEC_TEST); do \
		echo " - $${i##*/}"; \
	done
	@echo "******************************"


run: compile
ifeq ($(SIMULATION),)
	@echo "No simulation speficied. Nothing to do!!!"
else
ifeq ($(findstring $(SIMULATION),$(EXEC_TEST)),)
	@echo "Simulation $(SIMULATION) does not exist!!!"
else
ifeq ($(GHDL),ghdl-llvm)
	@./simulation/$(SIMULATION) $(GHDL_SIM_POTS)
else
	@$(GHDL) -r $(GHDL_FLAGS) $(GHDL_OPTS) -o simulation/$(SIMULATION) $(GHDL_SIM_POTS)
endif
endif
endif

view: run
ifneq ("$(wildcard simulation/$(SIMULATION).gtkw)","")
	@echo "gtkw file for this vcd simulation, it will be used."
	@$(WAVEFORM_VIEWER) simulation/$(SIMULATION).gtkw
else
	@echo "No gtkw file found for this vcd simulation."
	@$(WAVEFORM_VIEWER) simulation/$(SIMULATION).vcd
endif


clean:
	@${GHDL} --remove ${GHDL_FLAGS} ${GHDL_OPTS}
	@${GHDL} --clean ${GHDL_FLAGS} ${GHDL_OPTS}
	@rm $(SIMDIR)/*.o $(EXEC_TEST) $(SIMDIR)/*.vcd
