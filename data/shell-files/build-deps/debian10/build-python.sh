#
# build python on debian
#

hub=/deb/packages

mkdir -p ${hub}

#
# download and install python deps
#   with saving deb to keep folder
#
apt-get -o dir::cache::archives="${hub}" -y install --reinstall \
    build-essential zlib1g-dev \
    libncurses5-dev libncursesw5-dev \
    libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev \
    libffi-dev libsqlite3-dev libbz2-dev \
    tk-dev libc6-dev libvlccore-dev libvlc-dev liblzma-dev lzma \
    curl


PYTHON='3.8.17'

mkdir .Python3.8
cd .Python3.8

curl -O https://www.python.org/ftp/python/${PYTHON}/Python-${PYTHON}.tar.xz
tar -xf Python-${PYTHON}.tar.xz

cd Python-${PYTHON}

./configure \
    --enable-optimizations \
    --enable-loadable-sqlite-extensions \
    --prefix=/usr/local \
    --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"

# build
make -j 4
# make links
make altinstall

# check
python3.8 -V

cd ../
mkdir /deb
cp -r Python-${PYTHON} /deb/python

