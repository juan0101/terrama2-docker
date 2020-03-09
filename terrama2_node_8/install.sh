#!/bin/bash

echo "Installing packages..."

apt-get update

add-apt-repository -y ppa:apt-fast/stable
apt-get update
apt-get install -y apt-fast

apt-fast install -y qtcreator curl unzip locales supervisor wget libcurl3-dev libpython2.7-dev libproj-dev libgeos++-dev libssl-dev \
libxerces-c-dev screen doxygen graphviz gnutls-bin gsasl libgsasl7 libghc-gsasl-dev libgnutls-dev zlib1g-dev \
python-pip debhelper devscripts git build-essential ssh openssh-server libpq-dev sudo

pip install psycopg2

curl -sL https://deb.nodesource.com/setup_8.x | bash -

apt-get install -y nodejs

export PATH=$PATH:/usr/lib/node_modules/npm/bin

npm install -g grunt-cli

export PATH=$PATH:/usr/lib/node_modules/grunt-cli/bin

echo "Installing CMake..."

wget -c https://github.com/Kitware/CMake/releases/download/v3.11.4/cmake-3.11.4-Linux-x86_64.sh

chmod +x cmake-3.11.4-Linux-x86_64.sh

./cmake-3.11.4-Linux-x86_64.sh --skip-license --exclude-subdir --prefix=/usr/local

echo "Compiling projects..."

TERRAMA_BUILD_PATH="/terrama2/build"
TERRAMA_3RD_PARTY_PATH="/terrama2/3rdparty"
TERRAMA_MYLIBS_PATH="/terrama2/mylibs"
TERRAMA_CODEBASE_PATH="/terrama2/codebase"

TERRALIB_BUILD_PATH="/terrama2/terralib/build"
TERRALIB_3RD_PARTY_PATH="/terrama2/terralib/3rdparty"
TERRALIB_CODEBASE_PATH="/terrama2/terralib/codebase"

mkdir -p $TERRAMA_BUILD_PATH
mkdir -p $TERRAMA_3RD_PARTY_PATH
mkdir -p $TERRAMA_MYLIBS_PATH
mkdir -p $TERRAMA_CODEBASE_PATH

mkdir -p $TERRALIB_BUILD_PATH
mkdir -p $TERRALIB_3RD_PARTY_PATH
mkdir -p $TERRALIB_CODEBASE_PATH

echo -e "Terralib"

cd $TERRALIB_CODEBASE_PATH

GIT_SSL_NO_VERIFY=false git clone -o upstream -b 5.4.5 https://gitlab.dpi.inpe.br/terralib/terralib.git .

cd $TERRALIB_3RD_PARTY_PATH

wget -c http://www.dpi.inpe.br/terralib5-devel/3rdparty/src/terralib-3rdparty-linux-ubuntu-16.04.tar.gz
TERRALIB_DEPENDENCIES_DIR="$TERRAMA_MYLIBS_PATH" $TERRALIB_CODEBASE_PATH/install/install-3rdparty-linux-ubuntu-16.04.sh

cd $TERRALIB_BUILD_PATH

cmake -G "CodeBlocks - Unix Makefiles" \
	-DCMAKE_PREFIX_PATH:PATH="$TERRAMA_MYLIBS_PATH" \
    -DTERRALIB_BUILD_AS_DEV:BOOL="ON" \
    -DTERRALIB_BUILD_EXAMPLES_ENABLED:BOOL="OFF" \
    -DTERRALIB_BUILD_UNITTEST_ENABLED:BOOL="OFF" $TERRALIB_CODEBASE_PATH/build/cmake

make -j $(($(nproc)/2))

echo -e "TerraMA"

cd $TERRAMA_CODEBASE_PATH

GIT_SSL_NO_VERIFY=false git clone -o upstream -b b4.1.0 https://github.com/terrama2/terrama2.git .

cd $TERRAMA_3RD_PARTY_PATH
wget -c http://www.dpi.inpe.br/jenkins-data/terradocs/terrama2-3rdparty.zip
unzip terrama2-3rdparty.zip -d $TERRAMA_3RD_PARTY_PATH

echo "Installing packages..."

cd $TERRAMA_BUILD_PATH

cmake -G "CodeBlocks - Unix Makefiles" \
	-DCMAKE_PREFIX_PATH:PATH="$TERRAMA_MYLIBS_PATH" \
	-DCMAKE_BUILD_TYPE:STRING="Debug" \
	-DCMAKE_SKIP_BUILD_RPATH:BOOL="OFF" \
	-DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL="OFF" \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL="ON" \
	-DCMAKE_PREFIX_PATH:PATH="$TERRAMA_MYLIBS_PATH" \
	-Dterralib_DIR:PATH="$TERRALIB_BUILD_PATH" \
	-DBoost_INCLUDE_DIR="$TERRAMA_MYLIBS_PATH/include" \
	-DQUAZIP_INCLUDE_DIR="$TERRAMA_3RD_PARTY_PATH/quazip-install/include/quazip" \
	-DQUAZIP_LIBRARIES="$TERRAMA_3RD_PARTY_PATH/quazip-install/lib/libquazip.so" \
	-DQUAZIP_LIBRARY_DIR="$TERRAMA_3RD_PARTY_PATH/vmime-install/lib" \
	-DQUAZIP_ZLIB_INCLUDE_DIR="$TERRAMA_3RD_PARTY_PATH/vmime-install/include" \
	-DVMIME_INCLUDE_DIR="$TERRAMA_3RD_PARTY_PATH/vmime-install/include" \
	-DVMIME_LIBRARY="$TERRAMA_3RD_PARTY_PATH/vmime-install/lib/libvmime.so" \
	-DVMIME_LIBRARY_DIR="$TERRAMA_3RD_PARTY_PATH/vmime-install/lib" $TERRAMA_CODEBASE_PATH/build/cmake

make -j $(($(nproc)/2))

echo "### Running npm install... ###"

echo "### Webapp... ###"

cd $TERRAMA_CODEBASE_PATH/webapp
npm install
grunt

echo "### Webcomponents... ###"

cd $TERRAMA_CODEBASE_PATH/webcomponents
npm install
grunt

echo "### Webmonitor... ###"

cd $TERRAMA_CODEBASE_PATH/webmonitor
npm install
grunt