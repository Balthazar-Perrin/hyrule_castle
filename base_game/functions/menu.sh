#!/bin/bash

source ./functions/start.sh
source ./functions/combat.sh

start() {
	floor=1
	healing_potion=5
	hp_player_now=$hp_player
		status="first"
	while [ "$floor" -le 9 ]; do
		fight
		floor=$(("$floor"+1))
		status="start"
		if [ "$floor" -eq 10 ]; then
		boss_fight
		
		fi
	done
}



menu() {
clear
echo -e "
${BLUE}==============================${NC} Main menu ${BLUE}==============================${NC} \n"
echo -e "1) New game    2) Quit \n"
echo -e "Every time a choice appears, just write the number corresponding to your answer.\nHere is the first one, it shouldn't be that difficult. \n"

while read choix; do

	if [ -z "$choix" ] || [ "$choix" != 1 ] && [ "$choix" != 2 ] ; then
		echo "that's not a valid option, try again."
	else
	case $choix in
    	"2") echo -e "\nGoodbye then."
		exit ;;
    	"1") clear
		echo -e "\nYou are $name_player, you have ${GREEN}$hp_player${NC} HP, $str_player strength $def_player defense and 5 potions of healing.\nYou came to the Hyrule tower to free the area from the tyranny of the monsters inside, commanded by a mysterious darklord.\n"
		echo -e "\n 1) Continue  2) Quit \n"
	 	break;;
	esac
    fi
done
while read choix; do
	if [ -z "$choix" ] || [ "$choix" != 1 ] && [ "$choix" != 2 ] ; then
        echo "that's not a valid option, try again."
	else
    case $choix in
        "2") echo -e "\nGoodbye then."
        	exit;;
        "1")clear
		echo "bonjour"
		start
		break;;
	esac
	fi
done
}

