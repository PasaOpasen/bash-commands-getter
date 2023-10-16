#
# lists bash commands in folder shell files using bcg container
#
# usage:
#   bash list-bash-commands.sh folder reportfile
#

set -e
set -x

container=BCG

#
# remove previous container
#
docker container rm ${container} &> /dev/null || true
WD=${HD:-$(pwd)}   # host project directory

if [ ! -d $1 ]
then
    echo "not a directory: $1"
    exit 1
fi

#
# mount and run
#
IMAGE=pasaopasen/bcg:latest
docker pull $IMAGE
docker run --name ${container}  \
    -v "$WD"/$1:/srv/data \
    $IMAGE \
    python main.py data out.txt


reportfile=${2:-bcg.txt}
mkdir -p $(dirname $reportfile)

docker cp ${container}:/srv/out.txt $reportfile

builtins="$(compgen -b | grep -E '\w' | xargs | tr ' ' '|')"

# rename dirs + remove shell builtins
sed -i "s@data/@$1/@g" $reportfile

cat $reportfile | grep -v -E "^($builtins)\s" > tmp/tmpfile && mv tmp/tmpfile $reportfile

set +a
echo -e "\nFound commands:\n"

cat $reportfile

