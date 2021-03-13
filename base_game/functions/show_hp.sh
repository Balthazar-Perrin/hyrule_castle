show_hp() {
base_hp=$1
remaining_hp=$2
type=$3
name=$4
NC='\033[0m'

if [ "$type" == "hero" ]; then
	COLOR='\033[1;32m'
elif [ "$type" == "enemy" ]; then
	COLOR='\033[1;31m'
fi

echo -n -e "["
for (( i=1; i<=$remaining_hp; i++)); do
	echo -e -n "${COLOR}O"
done

for (( i=$remaining_hp; i<$base_hp; i++)); do
	echo -n -e "${COLOR}-"
done
echo -e ${NC}"] "$remaining_hp"/"$base_hp" HP  "$name
}
