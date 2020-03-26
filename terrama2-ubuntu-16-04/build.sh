#!/bin/bash

echo "********************"
echo "* Installing CMake *"
echo "********************"
echo ""

cd /

wget -c https://github.com/Kitware/CMake/releases/download/v3.11.4/cmake-3.11.4-Linux-x86_64.sh

chmod +x cmake-3.11.4-Linux-x86_64.sh

./cmake-3.11.4-Linux-x86_64.sh --skip-license --exclude-subdir --prefix=/usr/local

echo "**********************"
echo "* Compiling projects *"
echo "**********************"
echo ""

TERRAMA_BUILD_PATH="/opt/terrama2/build"
TERRAMA_3RD_PARTY_PATH="/opt/terrama2/3rdparty"
TERRAMA_MYLIBS_PATH="/opt/terrama2/mylibs"
TERRAMA_CODEBASE_PATH="/opt/terrama2/codebase"

TERRALIB_BUILD_PATH="/opt/terrama2/terralib/build"
TERRALIB_3RD_PARTY_PATH="/opt/terrama2/terralib/3rdparty"
TERRALIB_CODEBASE_PATH="/opt/terrama2/terralib/codebase"

mkdir -p $TERRAMA_BUILD_PATH
mkdir -p $TERRAMA_3RD_PARTY_PATH
mkdir -p $TERRAMA_MYLIBS_PATH
mkdir -p $TERRAMA_CODEBASE_PATH

mkdir -p $TERRALIB_BUILD_PATH
mkdir -p $TERRALIB_3RD_PARTY_PATH
mkdir -p $TERRALIB_CODEBASE_PATH

echo "************"
echo "* TerraLib *"
echo "************"
echo ""

cd $TERRALIB_3RD_PARTY_PATH

wget -c http://www.dpi.inpe.br/terralib5-devel/3rdparty/src/terralib-3rdparty-linux-ubuntu-16.04.tar.gz
TERRALIB_DEPENDENCIES_DIR="$TERRAMA_MYLIBS_PATH" $TERRALIB_CODEBASE_PATH/install/install-3rdparty-linux-ubuntu-16.04.sh

cd $TERRALIB_BUILD_PATH

cmake -G "CodeBlocks - Unix Makefiles" \
	-DCMAKE_PREFIX_PATH:PATH="$TERRAMA_MYLIBS_PATH" \
    -DTERRALIB_BUILD_AS_DEV:BOOL="ON" \
    -DTERRALIB_BUILD_EXAMPLES_ENABLED:BOOL="OFF" \
    -DTERRALIB_BUILD_UNITTEST_ENABLED:BOOL="OFF" $TERRALIB_CODEBASE_PATH/build/cmake

make -j $(($(nproc)-1))

echo "************"
echo "* TerraMA² *"
echo "************"
echo ""

cd $TERRAMA_3RD_PARTY_PATH

wget -c http://www.dpi.inpe.br/jenkins-data/terradocs/terrama2-3rdparty.zip
unzip terrama2-3rdparty.zip -d $TERRAMA_3RD_PARTY_PATH

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

make -j $(($(nproc)-1))