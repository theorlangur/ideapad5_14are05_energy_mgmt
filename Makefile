.PHONY: install uninstall checkroot checkscript checksudo checkacpi

# dmidecode produces lots of "Version" lines. `sed -n 'Xp'` (where X is a particular
# number does not guarantee you will get the machine model. This grep is a hacky-fix to
# get "IdeaPad" models.
model_name=$(shell sudo dmidecode | grep "Version: IdeaPad" | sed -n '1p' | cut -d' ' -f2,3,4)

ifeq ("wildcard $(model_name)", "IdeaPad 5 14ARE05")
	noextname = ideapad5_14are05_energy_mgmt
endif

ifeq ("$(model_name)", "IdeaPad 5 15ARE05")
	noextname = ideapad5_15are05_energy_mgmt
endif

ifeq ("$(noextname)", "")
	@echo "Model name is invalid."
	@echo "This machine:$(model_name)"
	exit 1
endif

script = $(noextname).sh
install_path = /usr/local/bin/
sudorule = $(noextname)
origuser = $(shell stat -c %U `tty`)

define SUDORULE_CNT
$(origuser) ALL=NOPASSWD: $(DESTDIR)$(install_path)$(script)
endef

checkscript:
ifneq ("$(wildcard $(DESTDIR)$(install_path)$(script))","")
	@echo "$(DESTDIR)$(install_path)$(script) already exists!"
	exit 1
endif

checksudo:
ifneq ("$(wildcard /etc/sudoers.d/$(sudorule))","")
	@echo "/etc/sudoers.d/$(sudorule) already exists!"
	exit 1
endif

checkroot:
ifneq ($(shell id -u), 0)
	@echo "You are not root. This script will add new file to /etc/sudoers.d/ directory and requires root priviledges for that"
	exit 1
endif

install: checkroot checksudo checkscript
	@echo "Installing..."
	cp $(script) $(DESTDIR)$(install_path)
	chown root:root $(DESTDIR)$(install_path)$(script)
	chmod 0700 $(DESTDIR)$(install_path)$(script)
	$(file > /etc/sudoers.d/$(sudorule),$(SUDORULE_CNT))
	chmod 0440 /etc/sudoers.d/$(sudorule)

uninstall: checkroot
	@echo "Unistalling..."
	rm $(DESTDIR)$(install_path)$(script)
	rm /etc/sudoers.d/$(sudorule)


