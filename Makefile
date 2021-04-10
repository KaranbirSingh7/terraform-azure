# from: https://www.sapranidis.gr/working-with-terraform-and-makefile/

SHELL:=/bin/bash

all: plan

clean:
	rm -f /tmp/plan_stg

get:
	@echo "Updating modules"
	@terraform get -update

format:
	@echo "Format existing code"
	@terraform fmt

show:
	@echo "Showing plan to apply"
	@terraform show /tmp/plan_stg

plan: format get
	@echo "Checking Infrastracture"
	@terraform plan -out /tmp/plan_stg
	$(MAKE) confirm
	$(MAKE) apply

apply:
	@echo "Applying changes to Infrastracture"
	@terraform apply /tmp/plan_stg
	@echo "Clean up after myself"
	$(MAKE) clean

confirm:
	@read -r -t 5 -p "Type y to apply, otherwise it will abort (timeout in 5 seconds): " CONTINUE; \
	if [ ! $$CONTINUE == "y" ] || [ -z $$CONTINUE ]; then \
	    echo "Abort apply." ; \
		exit 1; \
	fi

help: 
	@echo "Usage: make plan"
	@echo "After applying terraform plan it prompt if to apply the changes."
	@echo "Other commands: "
	@echo " * make show - to list what the plan will apply "
	@echo " * make clean - delete the executed plan, so no files left behind "
	@echo " * make get - update the teffarom modules"
	@echo " * make format - execute terraform fmt"