#!/bin/bash

configurations=(`sed -n '/^### CONFIG_OVERRIDDEN ###/,/^#########################/p;/^#########################/q' .env | sed '1d;$d'`)

for index in ${!configurations[*]}
do
	IFS='=' read -r -a part <<< "${configurations[$index]}"
	attributes_names_env[$index]=${part[0]};
	data_default_env[$index]=${part[1]};
done

echo -e "---------------------------------------"
echo -e "| Docker settings project (.env file) |"
echo -e "---------------------------------------\n"

for index in ${!attributes_names_env[*]}
do
	echo -n "${attributes_names_env[$index]} [${data_default_env[$index]}] ? "
	read data_input

	if [ -z "$data_input" ]
	then
		data_input=${data_default_env[$index]}
	fi
	
	sed -i -E "s|(${attributes_names_env[$index]}=).*$|\1$data_input|g" .env
done



