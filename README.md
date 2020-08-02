# Lenovo IdeaPad 5 14ARE05 energy management script

This is a bash script that utilizes acpi calls to control certain energy-related aspects of Lenovo Ideapad 5 14ARE05 laptops:

  * rapid charge
  * battery conservation (limits the maximum charge of the battery at the level of 55-60% to prolong the life of the battery)
  * functioning mode:
	* intelligent cooling
	* extreme performance
	* battery saving

### Pre-requisites

The script relies on the ACPI calls and uses for that purpose the functionality of the `/proc/acpi/call` which in turn is provided by the
`acpi_call` packet and hence must be installed in order for script to work.

### Installation

In order to install the script into the system the following command must be executed with root priviledges:

	sudo make install

It will do the following:

 * it will copy `ideapad5_14are05_energy_mgmt.sh` into the `/usr/local/bin` directory
 * change the owner of the `ideapad5_14are05_energy_mgmt.sh` to the root:root
 * create a file in the `/etc/sudoers.d/ideapad5_14are05_energy_mgmt` that will allow current user to run the script with sudo but no password (if you don't need this - just remove the file)

### Uninstall

In order to uninstall the following command must be executed:

	sudo make uninstall

### Usage


	sudo /usr/local/bin/ideapad5_14are05_energy_mgmt.sh perf_mode [..params..]|rapid_charge [on|off]|batt_conserv [on|off]

parameters for 'perf\_mode':

	intel - switch to intelligent cooling mode
	perf - switch to extreme performance mode
	save - switch to battery save mode
	<empty> - return current mode (one of the above)
	
parameters for 'rapid\_charge':

	on - switch rapid charge on
	off - switch rapid charge off
	<empty> - return current state of rapid charge
parameters for 'batt\_conserv':

	on - switch battery conservation mode on (limits charge to 55-60%)
	off - switch battery conservation mode off
	<empty> - return current state of battery conservation mode

