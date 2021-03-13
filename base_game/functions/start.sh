
#!/bin/bash
################################### Variables ##################################
RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
NC='\033[0m'

quit() {
	rm -f ../choix_boss ../choix_player ./choix_boss ./choix_player
	clear
	exit
}


################################### Player ##########################################
create_player() {
	healing_potion=5

	rarity=$((1 + RANDOM % 75))
	if [ $rarity -le 25 ];then choix_player=1
	elif [ $rarity -gt 25 ] && [ $rarity -le 50 ]; then choix_player=2
	elif [ $rarity -gt 50 ] && [ $rarity -le 60 ]; then choix_player=3
	elif [ $rarity -gt 60 ] && [ $rarity -le 70 ]; then choix_player=4
	elif [ $rarity -gt 70 ] && [ $rarity -le 75 ]; then choix_player=5
	fi


	stats_perso=$(grep ^$choix_player"," players.csv | awk -F\, '{print "#" $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8 "," $9 "," $10 "," $11 "," $12}')
	rm -f choix_player
	touch choix_player
	echo -n "$stats_perso" > choix_player
}


##stats_boss=$(grep -v "name" bosses.csv | awk -F\, '{print "#" $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8 "," $9 "," $10}' )
##echo -n "$stats_boss" > choix_boss

##stats_enemy=$(grep -v "name" enemies.csv | awk -F\, '{print "#" $1 "," $2 "," $3 "," $4 "," $5 "," $6 "," $7 "," $8 "," $9 "," $10 "," $11 "," $12}')
##echo -n "$stats_enemy" > choix_enemy.csv

name_player=$(cat choix_player | cut -d\, -f2)
hp_player=$(cat choix_player | cut -d\, -f3)
str_player=$(cat choix_player | cut -d\, -f5)
def_player=$(cat choix_player | cut -d\, -f7)
