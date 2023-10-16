
packages_dir=${1:-/data/redos/packages}

cd $packages_dir


dnf install --setopt=install_weak_deps=False -y *.rpm
# dnf -y install *.rpm
# rpm -Uvh --force *.rpm || true

