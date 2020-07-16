##############################################
#   SebaUbuntu custom kernel build script    #
##############################################

# Set defaults directory's
ROOT_DIR=$(pwd)
OUT_DIR=$ROOT_DIR/out
# ANYKERNEL_DIR=$ROOT_DIR/anykernel3
KERNEL_DIR=$ROOT_DIR
DATE=$(date +"%m-%d-%y")
BUILD_START=$(date +"%s")

# Export ARCH and SUBARCH <arm, arm64, x86, x86_64>
export ARCH=arm
export SUBARCH=arm

# Set kernel name and defconfig
export VERSION=MedusaKernel-v1.7-NeMutluTürkümDiyene
export DEFCONFIG=j4primelte_caf_defconfig

# Keep it as is
export LOCALVERSION=-$VERSION

# Export Username and machine name
export KBUILD_BUILD_USER=Batuu
export KBUILD_BUILD_HOST=Manjaro

# Color definition
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`
reset=`tput sgr0`

# Cross-compiler exporting
if [ $ARCH = arm ]
	then
		# Export ARM from the given directory
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
elif [ $ARCH = arm64 ]
	then
		# Export ARM64 and ARM cross-compliers from the given directory
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
		export CROSS_COMPILE_ARM32=${ROOT_DIR}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
elif [ $ARCH = x86 ]
	then
		# Export x86 cross-compliers from the given directory
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/bin/x86_64-linux-android-
elif [ $ARCH = x86_64 ]
	then
		# Export x86 and x86_64 cross-compliers from the given directory
		export CROSS_COMPILE=${ROOT_DIR}/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/bin/x86_64-linux-android-
		export CROSS_COMPILE_X86=${ROOT_DIR}/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/bin/x86_64-linux-android-
else
	echo "$red Error: Arch not compatible $reset"
	exit
fi

echo -e "*****************************************************"
echo    "            Compiling kernel using GCC               "
echo -e "*****************************************************"
echo -e "-----------------------------------------------------"
echo    " Architecture: $ARCH                                 "
echo    " Output directory: $OUT_DIR                          "
echo    " Kernel version: $VERSION                            "
echo    " Build user: $KBUILD_BUILD_USER                      "
echo    " Build machine: $KBUILD_BUILD_HOST                   "
echo    " Build started on: $BUILD_START                      "
echo    " Toolchain: GCC 4.9 Brillo-M10-Release               "
echo -e "-----------------------------------------------------"

# Set kernel source workspace
cd $KERNEL_DIR

# Clean build
make O=$OUT_DIR clean
CLEAN_SUCCESS=$?
if [ $CLEAN_SUCCESS != 0 ]
	then
		echo "$red Error: make clean failed"
		exit
fi

make O=$OUT_DIR mrproper
MRPROPER_SUCCESS=$?
if [ $MRPROPER_SUCCESS != 0 ]
	then
		echo "$red Error: make mrproper failed"
		exit
fi 

# Make your device device_defconfig
make O=$OUT_DIR ARCH=$ARCH $DEFCONFIG
DEFCONFIG_SUCCESS=$?
if [ $DEFCONFIG_SUCCESS != 0 ]
	then
		echo "$red Error: make $DEFCONFIG failed, specified a defconfig not present? $reset"
		exit
fi

# Build Kernel
make O=$OUT_DIR ARCH=$ARCH -j$(nproc --all)

# Find how much build has been long
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

BUILD_SUCCESS=$?
if [ $BUILD_SUCCESS != 0 ]
	then
		echo "$red Error: Build failed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
		exit
fi

clear

echo -e "$green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds $reset"
done
