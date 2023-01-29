#!/bin/sh

if [ -z "$1" ]
then
      CONFIG=Debug
else
      CONFIG=$1
fi

PROJECT=sdl2
BUILDER=ninja
TARGET=hl
#TARGET=jvm
ARCH=x64
#ARCH=arm64

mkdir -p build/${TARGET}/${ARCH}/${CONFIG}
mkdir -p installed/${TARGET}/${ARCH}/${CONFIG}

mkdir -p build/${TARGET}/${CONFIG}
pushd build/${TARGET}/${CONFIG}
cmake -G${BUILDER} -DCMAKE_BUILD_TYPE=${CONFIG} -DCMAKE_INSTALL_PREFIX=../../../../installed/${TARGET}/${ARCH}/${CONFIG} ../../../.. 
popd

