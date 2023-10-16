
# deps=$(cat deps.txt)

hub=/deb/packages

mkdir -p ${hub}

# apt-get -o dir::cache::archives="${hub}" -d install ${deps} -y --reinstall

#
# IMPORTANT!
# DONT PUT # STRINGS BETWEEN PACKAGES
#

# debian 10 requires this additions:
#   poppler directly (why?)
#
apt-get -o dir::cache::archives="${hub}" -d -y install --reinstall \
    build-essential make \
    libzbar0 zbar-tools   \
    screen curl \
    tesseract-ocr tesseract-ocr-rus \
    poppler-utils libpoppler-cpp-dev  \
    libsasl2-dev libldap2-dev libssl-dev \
    # libgl1 \
    # cmake pkg-config  \

apt-get -o dir::cache::archives="${hub}" -d install --no-install-recommends -y --reinstall \
    libreoffice-java-common default-jre libreoffice-calc libreoffice-writer

find ${hub} -mindept 1 -not -name "*.deb" -delete

ls -lah ${hub}

