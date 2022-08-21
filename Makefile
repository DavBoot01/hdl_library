

.PHONY: list_prj cleanall

PROJECT_LIST= \
parallel2serial \
serial2parallel \

PROJECT := ${project}

.PHONY: clean compile analysis_sources analysis_testbenches \
elaborate_testbench list run \
list_prj cleanall 


list_prj:
	@echo "List of all projects:"
	@for i in $(PROJECT_LIST); do \
		echo " - $${i}"; \
	done


cleanall:
	@for i in $(PROJECT_LIST); do \
		make -C $${i} -f Makefile clean ; \
	done


list compile run view clean:
ifeq ($(findstring $(PROJECT),$(PROJECT_LIST)),)
	@echo "ERROR: project $(PROJECT) does not exist"
else
	@echo "*** Task $@ on project $(PROJECT) ***"
	@make -C $(PROJECT) -f Makefile $@
endif
