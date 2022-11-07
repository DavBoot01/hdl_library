VHDLEX = vhd

SOURCEDIR := source
TESTDIR := testbench
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


#TARGET FILE
SOURCE_FILES := $(wildcard $(SOURCEDIR)/*.$(VHDLEX))
OBJ_SOURCE := $(patsubst $(SOURCEDIR)/%.$(VHDLEX), $(SIMDIR)/%.o, $(SOURCE_FILES))

TEST_FILES := $(wildcard $(TESTDIR)/*.$(VHDLEX))
OBJ_TEST := $(patsubst $(TESTDIR)/%.$(VHDLEX), $(SIMDIR)/%.o, $(TEST_FILES))
EXEC_TEST := $(OBJ_TEST:%.o=%)


.PHONY: clean compile analysis_sources analysis_testbenches \
elaborate_testbench list run

$(SIMDIR)/%.o: $(SOURCEDIR)/%.$(VHDLEX)
	@echo "Analyze of $@"
	@$(GHDL) -a $(GHDL_FLAGS) $(GHDL_OPTS) $<

analysis_sources: $(OBJ_SOURCE)
	@echo
	@echo "========== Analysis of IP(s) source code complete =========="
	@echo


$(SIMDIR)/%.o: $(TESTDIR)/%.$(VHDLEX)
	@echo "Analyze of $@"
	@$(GHDL) -a $(GHDL_FLAGS) $(GHDL_OPTS) $<

analysis_testbenches: $(OBJ_TEST)
	@echo
	@echo "========== Analysis of Testbench(s) source code complete =========="
	@echo


$(SIMDIR)/%: $(SIMDIR)/%.o
	@echo "Elaboration of $@"
	@$(GHDL) -e $(GHDL_FLAGS) $(GHDL_OPTS) -o $@ $(notdir $@)

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
