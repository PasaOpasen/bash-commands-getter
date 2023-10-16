
packages_dir=${1:-/data/centos/packages}

cd $packages_dir
yum -y install *.rpm



