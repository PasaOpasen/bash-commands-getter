# bash-commands-getter (bgc)

This repo is purposed to provide a command to list all *shell commands* which are using in provided files. It is my solution for [this question](https://stackoverflow.com/questions/77300162/list-all-commands-using-in-the-bash-script?noredirect=1#comment136282587_77300162).

It uses [bash-parser](https://github.com/vorpaljs/bash-parser) `npm` package to get shell script AST and uses simple Python script for other high-level operations. All this is packed to Docker container and can be user in any UNIX system by attached shell script.

For example, the command (inside this repo)

```sh
bash list-bash-commands.sh data/shell-files data/report.txt
```

will list almost all using shell commands for shell files in the `data/shell-files` directory. The result is 
```sh
apt-get -o -d --no-install-recommends -y --reinstall	==	data/shell-files/build-deps/debian10/download.sh
apt-get -o -d -y --reinstall                        	==	data/shell-files/build-deps/debian10/download.sh
apt-get -o -y --reinstall                           	==	data/shell-files/build-deps/debian10/build-python.sh
apt-get -y -f                                       	==	data/shell-files/build-deps/debian10/install.sh
auditwheel -w                                       	==	data/shell-files/repair_wheels.sh
cd                                                  	==	data/shell-files/build-deps/centos8s/install.sh;data/shell-files/build-deps/debian10/build-python.sh;data/shell-files/build-deps/debian10/install.sh;data/shell-files/build-deps/redos73/install.sh
cp -r                                               	==	data/shell-files/build-deps/debian10/build-python.sh
curl -O                                             	==	data/shell-files/build-deps/debian10/build-python.sh
dnf -y                                              	==	data/shell-files/build-deps/redos73/install.sh
dpkg -i                                             	==	data/shell-files/build-deps/debian10/install.sh
echo                                                	==	data/shell-files/repair_wheels.sh
find -mindept -not -name -delete                    	==	data/shell-files/build-deps/debian10/download.sh
ls -lah                                             	==	data/shell-files/build-deps/centos8s/download.sh;data/shell-files/build-deps/debian10/download.sh
make                                                	==	data/shell-files/build-deps/debian10/build-python.sh
make -j                                             	==	data/shell-files/build-deps/debian10/build-python.sh
mkdir                                               	==	data/shell-files/build-deps/debian10/build-python.sh
mkdir -p                                            	==	data/shell-files/build-deps/centos8s/download.sh;data/shell-files/build-deps/debian10/build-python.sh;data/shell-files/build-deps/debian10/download.sh
python3.8 -V                                        	==	data/shell-files/build-deps/debian10/build-python.sh
repair_wheel                                        	==	data/shell-files/repair_wheels.sh
set -e -u -x                                        	==	data/shell-files/repair_wheels.sh
tar -xf                                             	==	data/shell-files/build-deps/debian10/build-python.sh
true                                                	==	data/shell-files/repair_wheels.sh
yum -y                                              	==	data/shell-files/build-deps/centos8s/install.sh
yumdownloader --downloadonly --resolve              	==	data/shell-files/build-deps/centos8s/download.sh
```

Only the `.sh` script is necessary to perform this operation.

