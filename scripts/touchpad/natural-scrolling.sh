#! /bin/bash

reverse=false
while getopts "vh:p:" option; do
	case "${option}" in
		v)
			reverse=true
			;;
	esac
done

id=$( xinput list | egrep "slave.*pointer" | grep "Touchpad" | sed -e "s/^.*id=//" -e "s/\s.*$//" )
prop=$( xinput list-props $id | grep "Natural Scrolling Enabled" | grep -v "Default" | sed "s/.*(\([0-9]*\)).*/\1/g" )

if [[ $reverse == true ]]; then
	xinput --set-prop $id $prop 0
else
	xinput --set-prop $id $prop 1
fi
