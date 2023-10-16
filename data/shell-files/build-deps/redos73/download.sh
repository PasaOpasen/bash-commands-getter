

hub=/rpm/packages

mkdir -p ${hub}

packages="
    python38 \
    make automake gcc gcc-c++ kernel-devel python3.8-devel \
    cmake pkg-config mesa-libGL \
    zbar \
    bzip2-devel \
    poppler-utils poppler-cpp-devel \
    screen curl \
    tesseract tesseract-osd tesseract-langpack-rus \
    openldap-devel \
    libreoffice-calc-1:7.4.4.2-1.el7.x86_64 libreoffice-writer-1:7.4.4.2-1.el7.x86_64
"

# echo "dnf download"
# dnf download --arch x86_64,noarch --best --resolve --alldeps --downloaddir=${hub} --setopt=install_weak_deps=False ${packages}


echo "repotrack"
cd $hub
# requires yum-utils (dnf-utils)
repotrack --arch x86_64,noarch ${packages}


# # dnf install --downloadonly --downloaddir ${hub} -y $packages
# # dnf reinstall --downloadonly --downloaddir ${hub} -y $packages

# dnf install -y $packages
# dnf reinstall --downloadonly --downloaddir ${hub} -y $packages

# #
# # why needs upgrade to run office?
# #
# dnf update --downloadonly --downloaddir ${hub} -y
# dnf update -y

# packages="libreoffice-calc libreoffice-writer"
# dnf install -y $packages
# dnf reinstall --downloadonly --downloaddir ${hub} -y $packages

ls -lah ${hub}

echo "Removing excess *.rpm"

cd $hub

function mline {
    # converts string with spaces to multiline string
    echo "$@" | tr ' ' '\n'
}

function to_regex {
    # escapes string to regex usage
    echo "$@" | sed 's/+/\\+/g' | sed 's/\./\\./g'
}

all_p=$(ls -1 *.rpm)

uniqs=$(mline $all_p | grep -o -P '^.*?-[0-9]+\.' | awk 'BEGIN{FS=OFS="-"}{NF--; print}' | uniq)

to_install=""
for p in $uniqs
do  
    # escape some symbols of the package
    p_regex=$(to_regex $p)

    candidates=$(mline $all_p | grep -P "^${p_regex}-[0-9]+\." | sort)
    count=$(mline $candidates | wc -l)

    if [ "$count" != "1" ]
    then
        echo "package: $p"
        echo -e "\tcandidates ($count):"
        echo -e "\t\t$(echo $candidates | sed 's/ /\n\t\t/g')"
        last=$(mline $candidates | tail -1)
        echo -e "\tchosen: $last"
    else
        last=$candidates
    fi

    if [ "$(echo $last | xargs)" == "" ]
    then
        echo not found candidates
        # sleep 1000
        exit 1
    fi    

    to_install+="$last "

done

#
# remove excess packages from dir
#
rm -rf $(mline $all_p | grep -v -w -E "$(to_regex $(echo $to_install | tr ' ' '|'))")


