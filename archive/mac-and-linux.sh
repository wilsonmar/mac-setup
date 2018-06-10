#!/bin/sh
 
# From https://github.com/sanoakr/homebrew-slab/blob/master/install_drawstuff.sh

# Run at ode source directory
echo "checking OS type"
case `uname -s` in
    "Darwin" ) OS=MAC;;
    "Linux" ) OS=LINUX;;
esac
 
case $OS in
    "MAC" ) DOWNLOAD_COMMAND='curl -O';;
    "LINUX" ) DOWNLOAD_COMMAND='wget';;
esac
 
echo "setup path from ode.pc"
prefix=`grep ^prefix= ode.pc | sed -e s/prefix=//g`
eval PREFIX=$prefix
prefix=$PREFIX
 
exec_prefix=`grep ^exec_prefix= ode.pc | sed -e s/exec_prefix=//g`
eval EXEC_PREFIX=$exec_prefix
exec_prefix=$EXEC_PREFIX
 
libdir=`grep ^libdir= ode.pc | sed -e s/libdir=//g`
eval LIB_DIR=$libdir
libdir=$LIB_DIR
 
includedir=`grep ^includedir= ode.pc | sed -e s/includedir=//g`
eval INCLUDE_DIR=$includedir
includedir=$INCLUDE_DIR
 
SHARE_DIR=${EXEC_PREFIX}/share
ODE_VERSION=`grep ^Version: ode.pc | sed -e s/'Version: '//g`
 
echo "generating drawstuff.pc"
egrep '^prefix=|^exec_prefix=|^libdir=|^includedir=' ode.pc > drawstuff.pc
rm drawstuff.pc.in* 2&>1 > /dev/null
${DOWNLOAD_COMMAND} "https://raw.githubusercontent.com/sanoakr/homebrew-slab/master/drawstuff.pc.in"
egrep -v 'prefix=|^exec_prefix=|^libdir=|^includedir=|^#' drawstuff.pc.in >> drawstuff.pc
 
# replace step
sed -i -e s/@DS_VERSION@/${ODE_VERSION}/g drawstuff.pc
case ${OS} in
    "MAC" ) GL_LIBRARIES="-framework GLUT -framework OpenGL";;
    "LINUX" ) GL_LIBRARIES="-lGL -lGLU";;
esac
sed -i -e s/@GL_LIBRARIES@/"${GL_LIBRARIES}"/g drawstuff.pc
 
#echo "downleoading cmake config files"
#rm ODEConfig*.cmake
#${DOWNLOAD_COMMAND} https://raw.github.com/gist/3224803/ODEConfig.cmake
#${DOWNLOAD_COMMAND} https://raw.github.com/gist/3224803/ODEConfig-version.cmake
 
# install files
echo "installing header files"
install -d ${INCLUDE_DIR}/drawstuff
install -m 644 include/drawstuff/*.h ${INCLUDE_DIR}/drawstuff
 
echo "installing library files"
install -m 755 drawstuff/src/libdrawstuff.la ${LIB_DIR}
install -m 644 drawstuff/src/.libs/libdrawstuff.a ${LIB_DIR}
 
echo "installing pkgconfig file"
install -m 644 drawstuff.pc ${LIB_DIR}/pkgconfig
#install -d ${SHARE_DIR}/ode
#install -m 644 ODEConfig*.cmake ${SHARE_DIR}/ode
echo "installing texture image files"
TEXTURES_PATH=${SHARE_DIR}/drawstuff/textures
install -d ${TEXTURES_PATH}
install -m 644 drawstuff/textures/* ${TEXTURES_PATH}
echo "installing demos"
install -d ${PREFIX}/demo
/bin/cp ode/demo/* ${PREFIX}/demo

 
echo "adding define of textures path into drawstuff.h"
case ${OS} in
"MAC" ) SED_COMMAND=gsed;;
"LINUX" ) SED_COMMAND=sed;;
esac
${SED_COMMAND} -i -e '/version.h>$/a #define DS_TEXTURES_PATH "@TEXTURES_PATH@"\n#define DRAWSTUFF_TEXTURE_PATH DS_TEXTURES_PATH' ${INCLUDE_DIR}/drawstuff/drawstuff.h
eval ${SED_COMMAND} -i -e 's\,@TEXTURES_PATH@\,"${TEXTURES_PATH}"\,' ${INCLUDE_DIR}/drawstuff/drawstuff.h
 
echo "Drawstuff has been installed"
