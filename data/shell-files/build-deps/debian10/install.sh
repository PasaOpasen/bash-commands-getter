
packages_dir=${1:-/data/debian/packages}

cd $packages_dir
dpkg -i *.deb

apt-get install -y -f

