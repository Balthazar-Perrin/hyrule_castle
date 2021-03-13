
#!/bin/bash

source ./functions/start.sh
source ./functions/show_hp.sh


fight() {


############################################## Enemy creation ######################################

    rarity=$((1 + RANDOM % 101))
    if [ $rarity -le 50 ]; then enemy_random=$((1 + RANDOM % 3))
    elif [ $rarity -gt 50 ] && [ $rarity -le 80 ]; then enemy_random=$((3 + RANDOM % 6))
    elif [ $rarity -gt 80 ] && [ $rarity -le 95 ]; then enemy_random=$((3 + RANDOM % 9))
    elif [ $rarity -gt 95 ] && [ $rarity -le 100 ];then enemy_random=$((2 + RANDOM % 11))
	fi

    name_enemy=$(grep ^$enemy_random"," ./csv/enemies.csv | cut -d\, -f2)
    hp_enemy=$(grep ^$enemy_random"," ./csv/enemies.csv | cut -d\, -f3)
    str_enemy=$(grep ^$enemy_random"," ./csv/enemies.csv | cut -d\, -f5)
    def_enemy=$(grep ^$enemy_random"," ./csv/enemies.csv | cut -d\, -f5)
	

############################################## Combat ##############################################


	hp_enemy_now=$hp_enemy
    while [ "$hp_enemy" -gt "0" ]
    do
		####################### Affichage combat #######################		
		clear
		echo -e "${BLUE}=================${NC} Floor $floor : $name_player   VS   $name_enemy ${BLUE}==================${NC}\n"
		show_hp "$hp_player" "$hp_player_now" "hero" "$name_player"
		show_hp "$hp_enemy" "$hp_enemy_now" "enemy" "$name_enemy"

		if [ "$status" == "first" ]; then
			echo -e "\nYou enter the tower, and are welcomed by an enemy "$name_enemy" on the first floor !"
		elif [ "$status" == "start" ]; then
			echo -e "\nYou kill your enemy and progress to the floor "$floor" to find your next opponent, a "$name_enemy"."
		elif [ "$status" == "heal" ]; then
			echo -e "\nYou heal yourself and now have ${BLUE}$healing_potion${NC} potions, and $name_enemy attacks you right away."
		elif [ "$status" == "fail_heal" ]; then
			echo -e "\nYou waste your time searching for healing potions when you have none left, and $name_enemy takes that time to attack you !"
		fi
		
		echo -e "\nYou can:     1) Attack      2) Use a healing potion\n" 
		
		if [ "$status" == "fail" ]; then
			echo "that's not a valid option, try again."
		fi

		####################### Action héros #######################

		read choix_combat

		if [ -z "$choix_combat" ] || [ "$choix_combat" != "1" ] && [ "$choix_combat" != "2" ]; then
			status="fail"
		else

			case $choix_combat in 
				"1") hp_enemy_now=$(($hp_enemy_now - ($str_player - $str_player * ($def_enemy / 100))))
					status="attack"
					if [ "$hp_enemy_now" -le "0" ]; then			
					return;
					fi;;
				"2") if [ $healing_potion -gt "0" ]; then
						hp_player_now=$hp_player 
						healing_potion=$(($healing_potion - 1))
						status="heal"
					else status="fail_heal" 
					fi;;
			esac
			

			if [ "$hp_enemy" -le "0" ]; then			
				return;
			fi
			####################### Attaque ennemie #######################
			hp_player_now=$(($hp_player_now - ($str_enemy - $str_enemy * ($def_player / 100))))

			#######################  Mort joueur #######################

			if [ "$hp_player_now" -le "0" ]
			then echo -e "You are dead, killed by "$name_enemy", sorry about that.\n"
			exit
			fi
		fi
    done
}

############################################## Bossfight ##############################################

boss_fight() {
	boss_random=$(( 1 + RANDOM % 7))
	name_enemy=$(grep ^$boss_random"," ./csv/bosses.csv | cut -d\, -f2)
	hp_enemy=$(grep ^$boss_random"," ./csv/bosses.csv | cut -d\, -f3)
	str_boss=$(grep ^$boss_random"," ./csv/bosses.csv | cut -d\, -f5)
	def_boss=$(grep ^$boss_random"," ./csv/bosses.csv | cut -d\, -f7)
	hp_enemy_now=$hp_enemy


	while [ $hp_enemy_now -gt 0 ]
	do  
		####################### Affichage combat boss #######################
		clear
		echo -e "${PURPLE}==============================${NC} ${BOLD}Boss fight${NC} ${PURPLE}==============================${NC}
		${BOLD}$name_player   
			  	  VS 
			  	 		$name_enemy ${NC}\n${PURPLE}========================================================================${NC}\n"
		show_hp "$hp_player" "$hp_player_now" "hero" "$name_player"
		show_hp "$hp_enemy" "$hp_enemy_now" "enemy" "$name_enemy"

		if [ "$status" == "start" ]; then
			echo -e "\nThis floor doesn't look like any other one from the tower. As you enter a huge room filled with darkness and gruesome decorations, a big noise sends a shiver down your spine.\nAfter a while, your eyes get used to the darkness and you see a huge creature slowly approaching from the back of the room. Get ready for your last deathfight against $name_enemy !!\n "
		elif [ "$status" == "heal" ]; then
			echo -e "\nYou heal yourself and now have ${BLUE}$healing_potion${NC} potions, and $name_enemy attacks you right away."
		elif [ "$status" == "fail_heal" ]; then
			echo -e "\nYou waste your time searching for healing potions when you have none left."
		fi

		if [ "$boss_status" == "dodge" ]; then
			echo -e "\nYou manage to dodge "$name_enemy"'s attack by an inch !"
		elif [ "$boss_status" == "critical" ]; then
			echo -e "\n"$name_enemy" deals you a critical hit, ignoring your defense and doing bonus damage !!"
		fi

		echo -e "\nYou can    1) Attack     2) Use a healing potion     3) Run away\n " 


		####################### Action héros #######################
		read choix
		
		if [ -z "$choix" ] || [ "$choix" != 1 ] && [ "$choix" != 2 ] && [ "$choix" != 3 ]; then
        echo "that's not a valid option, try again."
		else

		case $choix in
			"1") hp_enemy_now=$(($hp_enemy_now - ($str_player -$str_player *($def_boss / 100))))
				status="attack";;
			"2") if [ $healing_potion -gt "0" ]; then
	 				hp_player_now=$hp_player 
	 				healing_potion=$(($healing_potion - 1))
					status="heal"
	 			 else status="fail_heal" 
				 fi;;

			"3") status="run"
			echo -e "\nYou get scared and try to run away with your tail between your legs, but $name_enemy jumps on your cowardly back and crushes you to death.\nYou are reduced to a puddle that he will sip for supper.\n"
			exit;;
		esac
		fi

		####################### Attaque boss #######################

		if [ "$hp_enemy_now" -gt 0 ];then 
			random_atk_boss=$(( 1 + RANDOM % 7))
			if [ "$random_atk_boss" -eq 6 ];then
				boss_status="dodge"
			fi
			if [ "$random_atk_boss" -le 5 ]; then  
				hp_player_now=$(($hp_player_now - ($str_boss - $str_boss * ($def_player/100))))
				boss_status="attack"
			fi
			
			if [ "$random_atk_boss" -eq 7 ]; then 
				hp_player_now=$(($hp_player_now - ($str_boss + 5 )))
				boss_status"critical"
			fi
		fi
		if [ "$hp_enemy_now" -le "0" ]; then 
			clear
			echo -e "\n\n${BOLD}Congratulations !${NC} You stand over the dead body of $name_enemy, wounded but triomphous. \nThe monsters of the Hyrule castle are now all dead, and the area can live peacefully again.\n"
			exit
		fi
		#######################  Mort joueur #######################

		if [ "$hp_player_now" -le 0 ]; then
			clear
			echo -e "\n\nYou fall for the overwhelming strength of "$name_enemy". \nYour head on a spike will decorate the room and $name_enemy will continue ruling over the area until another adventurer manages to take him down.\n"
			exit
		fi
		
	done
}