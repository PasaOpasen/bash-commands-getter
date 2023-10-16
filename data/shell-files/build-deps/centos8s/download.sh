

hub=/rpm/packages

mkdir -p ${hub}

# yum install -y yum-utils
yumdownloader --downloadonly --downloaddir=${hub} --resolve \
    make automake gcc gcc-c++ kernel-devel python38-devel \
    cmake pkg-config mesa-libGL \
    zbar \
    bzip2-devel \
    poppler-utils poppler-cpp-devel \
    screen curl \
    python3.8 \
    tesseract tesseract-osd tesseract-langpack-rus \
    libreoffice-calc libreoffice-writer \
    openldap-devel

ls -lah ${hub}


