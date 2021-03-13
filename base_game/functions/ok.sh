
#!/bin/bash

source functions.sh

menu() {
echo -e "
====== Main menu ====== \n"
echo -e "1) New game    2) Quit \n"
echo -e "Every time a choice appears, just write the number corresponding to your answer. Here is the first one, it shouldn't be that difficult. \n"

while read choix
do

    if [ $choix != 1 ] && [ $choix != 2 ]
    then
	echo "that's not a valid option, try again."
	else
case $choix in
    "2") echo "Goodbye then."
	 rm choix_boss choix_player
	 exit ;;
    "1") echo -e "=============================================\n
You are $name_player, you have $hp_player HP, $str_player strength and $def_player defense. You came to the Hyrule tower to free the area from the tyranny of the monsters inside, 
commanded by a mysterious darklord.\n"
	 break ;;
esac
    fi
done

}

################################# Var + Random enemy ###################################
fight() {
floor=1
hp_player_now="$hp_player"

while [ $floor -le 9 ]
do
    rarity=$((1 + RANDOM % 101))
    if [ $rarity -le 50 ]; then enemy_random=$((1 + RANDOM % 3))
    elif [ $rarity -gt 50 ] && [ $rarity -le 80 ]; then enemy_random=$((3 + RANDOM % 6))
    elif [ $rarity -gt 80 ] && [ $rarity -le 95 ]; then enemy_random=$((3 + RANDOM % 9))
    elif [ $rarity -gt 95 ] && [ $rarity -le 100 ];then enemy_random=$((2 + RANDOM % 11))
    elif [ $rarity -eq 101 ]; then enemy_random=12
    fi
    name_enemy=$(grep "#$enemy_random," choix_enemy.csv | cut -d\, -f2)
    hp_enemy=$(grep "#$enemy_random," choix_enemy.csv | cut -d\, -f3)
    str_enemy=$(grep "#$enemy_random," choix_enemy.csv | cut -d\, -f5)
    def_enemy=$(grep "#$enemy_random," choix_enemy.csv | cut -d\, -f7)
	echo -e "====== Floor $floor : $name_player with $hp_player_now HP    VS    $name_enemy with $hp_enemy HP ======\n"

################################### Combat #######################################

    while [ "$hp_enemy" -gt "0" ]
    do
	echo -e "You can:     1) Attack      2) Use a healing potion\n" 
	read choix_combat
	case $choix_combat in 
	    "1") hp_enemy=$(($hp_enemy - ($str_player - $str_player * ($def_enemy / 100))))
			     echo -e "The $name_enemy now has $hp_enemy HP !\n" ;;
	    "2") if [ $healing_potion -gt "0" ]
		    then
		 hp_player_now=$(($hp_player_now + 40))
		 healing_potion=$(($healing_potion - 1))
		 if [ $hp_player_now -gt $hp_player ]
		 then hp_player_now=$hp_player
		 fi
		 echo -e "You now have $hp_player_now HP and $healing_potion potions.\n"
		 else echo "You don't have any potion left and just waste your time."
		 fi ;;
	esac
############################# Attaque enemy ########################
	if [ $hp_enemy -gt 0 ]
	then
	    
	echo -e "====== The $name_enemy fights backs ! ======\n"
	hp_player_now=$(($hp_player_now - ($str_enemy - $str_enemy * ($def_player / 100))))
	echo -e "You now have $hp_player_now HP.\n"
	fi
	
############### Mort ennemi ###########
    
    if [ "$hp_enemy" -le "0" ]
    then
	if [ "$name_enemy" = "Jesus" ]
	then healing_potion=$(($healing_potion + 10))
	     echo -e "You killed Jesus, but don't worry, he'll be back after a couple of days. However, you find on his body some holy water with the power of healing, so you now have $healing_potion potions"
	fi
	 
	echo -e "Your enemy is dead and you get to the next floor.\n"
	floor=$(($floor + 1))
	
	break 
    fi
}
###############  Mort joueur ##########
death() {
	  if [ "$hp_player_now" -le "0" ]
	  then echo -e "You are dead, sorry about that.\n"
	       rm choix_player choix_enemy.csv choix_boss
	       exit
	  fi
    done
done
}
######################### intro + variables BOSS ##############################

if [ $floor = 10 ]
then
    boss_random=$(( 1 + RANDOM % 7))
    name_boss=$(grep "#$boss_random" choix_boss | cut -d\, -f2)
    hp_boss=$(grep "#$boss_random" choix_boss | cut -d\, -f3)
    str_boss=$(grep "#$boss_random" choix_boss | cut -d\, -f5)
    def_boss=$(grep "#$boss_random" choix_boss | cut -d\, -f7)			 

    echo -e "====================================
\n\nThis floor doesn't look like any other one from the tower. As you enter a huge room filled with darkness and gruesome decorations, a big noise sends a shiver down your spine.\nAfter a while, your eyes get used to the darkness and you see a huge creature slowly approaching from the back of the room. Get ready for your last deathfight against $name_boss !!\n\n 
======== Floor 10 ========

$name_player    with    $hp_player_now HP
              VS
$name_boss    with    $hp_boss HP

======== Floor 10 ========\n\n"


    
    while [ $hp_boss -gt 0 ]
    do  echo -e " You can    1) Attack     2) Use a healing potion     3) Run away\n " 
	read choix
	case $choix in
	    "1") hp_boss=$(($hp_boss - ($str_player -$str_player *($def_boss / 100))))
		 echo -e "You attack him and the $name_boss now has $hp_boss !!\n";;
	    
	    "2") hp_player_now=$(($hp_player_now + 50))
		 if [ $hp_player_now -gt $hp_player ]
		 then hp_player_now=$hp_player
		 fi
		 if [ $healing_potion -gt 0 ]
		 then healing_potion=$(($healing_potion -1))
	              echo -e "You heal yourself with a potion and now have $hp_player_now HP and $healing_potion potions.\n"
		 else echo -e "You don't have any potion left and waste your time searching for one during the fight.\n"			  
		 fi ;;
	    "3") echo -e "You get scared and try to run away with your tail between your legs, but $name_boss jumps on your cowardly back and crushes you to death. You are reduced to a puddle that he will sip for supper.\n"
		 rm choix_enemy.csv choix_player choix_boss
		 exit
		 r;;
	    
	    "69") echo -e "Haha lol you so funny, you jump into the boss' mouth and die stupidly like the dumbass you are, congratulations STOOPID. \n"
		  rm choix_enemy.csv choix_player choix_boss
		  exit ;;
	    
	esac
	
####################################### Attaque boss #####################################"
	
	if [ $hp_boss -gt 0 ]
	then echo -e "$name_boss attacks you !"
	     random_atk_boss=$(( 1 + RANDOM % 7))
	     if [ $random_atk_boss = 6 ]
	     then echo -e "You manage to dodge his attack !\n"
	     fi
	     if [ $random_atk_boss -le 5 ]
	     then  hp_player_now=$(($hp_player_now - ($str_boss - $str_boss * ($def_player/100))))
		   echo -e "You get hit and now have $hp_player_now HP.\n"
	     fi
	     
	     
	     if [ $random_atk_boss = 7 ]
	     then hp_player_now=$(($hp_player_now - ($str_boss + 5 )))
		  echo -e "He deals you a critical hit, ignoring your defense and doing bonus damage !! You now have $hp_player_now HP.\n"
	     fi
	fi
	if [ $hp_player_now -le 0 ]	     
then echo -e "\n\nYou fall for the overwhelming strength of your enemy. Your head on a spike will decorate the room and $boss_name will continue ruling over the area until another adventurer manages to take him down.\n"
     rm choix_player choix_enemy.csv choix_boss
     exit
fi
if [ $hp_boss -le 0 ]
then echo -e "\n\nCongratulations ! You stand over the dead body of $name_boss, wounded but triomphous. The monsters of the Hyrule castle are now all dead, and the area can leave peacefully again.\n"
fi
    done
    
fi
rm choix_enemy.csv
rm choix_player
rm choix_boss
