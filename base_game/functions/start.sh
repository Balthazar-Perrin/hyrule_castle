
#!/bin/bash
################################### Variables ##################################
RED='\033[1;31m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
NC='\033[0m'
BOLD='\033[1m'

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

	name_player=$(grep  ^$choix_player"," ./csv/players.csv | cut -d\, -f2)
	hp_player=$(grep  ^$choix_player"," ./csv/players.csv | cut -d\, -f3)
	str_player=$(grep  ^$choix_player"," ./csv/players.csv | cut -d\, -f5)
	def_player=$(grep  ^$choix_player"," ./csv/players.csv | cut -d\, -f7)
}



