#!/bin/bash

if (($EUID != 0)); then
  if [[ -t 1 ]]; then
    sudo "$0" "$@"
  else
    exec 1>output_file
    gksu "$0 $@"
  fi
  exit
fi

conservation_mode=/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
value=$(<"$conservation_mode")

new_value=1
if [[ $value = 1 ]]
then
	new_value=0
fi

echo "$new_value" >> "$conservation_mode"
if [[ $new_value = 1 ]]
then
	echo "Battery charging is disabled"
else
	echo "Battery charging is enabled"
fi
read -p "Press enter to continue"
