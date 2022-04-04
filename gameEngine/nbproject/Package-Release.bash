#!/bin/bash -x

#
# Generated - do not edit!
#

# Macros
TOP=`pwd`
CND_PLATFORM=GNU-Linux-x86
CND_CONF=Release
CND_DISTDIR=dist
CND_BUILDDIR=build
CND_DLIB_EXT=so
NBTMPDIR=${CND_BUILDDIR}/${CND_CONF}/${CND_PLATFORM}/tmp-packaging
TMPDIRNAME=tmp-packaging
OUTPUT_PATH=${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/gameengine
OUTPUT_BASENAME=gameengine
PACKAGE_TOP_DIR=/usr/

# Functions
function checkReturnCode
{
    rc=$?
    if [ $rc != 0 ]
    then
        exit $rc
    fi
}
function makeDirectory
# $1 directory path
# $2 permission (optional)
{
    mkdir -p "$1"
    checkReturnCode
    if [ "$2" != "" ]
    then
      chmod $2 "$1"
      checkReturnCode
    fi
}
function copyFileToTmpDir
# $1 from-file path
# $2 to-file path
# $3 permission
{
    cp "$1" "$2"
    checkReturnCode
    if [ "$3" != "" ]
    then
        chmod $3 "$2"
        checkReturnCode
    fi
}

# Setup
cd "${TOP}"
mkdir -p ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/package
rm -rf ${NBTMPDIR}
mkdir -p ${NBTMPDIR}

# Copy files and create directories and links
cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr/bin"
copyFileToTmpDir "${OUTPUT_PATH}" "${NBTMPDIR}/${PACKAGE_TOP_DIR}bin/${OUTPUT_BASENAME}" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libboost_regex.so" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libboost_regex.so" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libboost_regex.so.1.54.0" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libboost_regex.so.1.54.0" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libboost_system.so" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libboost_system.so" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libboost_system.so.1.54.0" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libboost_system.so.1.54.0" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libboost_thread.so" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libboost_thread.so" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libboost_thread.so.1.54.0" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libboost_thread.so.1.54.0" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libmysqlcppconn.so" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libmysqlcppconn.so" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libmysqlcppconn.so.6" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libmysqlcppconn.so.6" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libmysqlcppconn.so.6.1.1.2" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libmysqlcppconn.so.6.1.1.2" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/usr/lib64/libstdc++.so.6" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libstdc++.so.6" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/librt.so.1" "${NBTMPDIR}/${PACKAGE_TOP_DIR}librt.so.1" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/libpthread.so.0" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libpthread.so.0" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/libc.so.6" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libc.so.6" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/libdl.so.2" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libdl.so.2" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/libgcc_s.so.1" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libgcc_s.so.1" 0755

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/libicui18n.so.53.1" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libicui18n.so.53.1" 0644

cd "${TOP}"
makeDirectory "${NBTMPDIR}//usr"
copyFileToTmpDir "/lib64/libicuuc.so.53.1" "${NBTMPDIR}/${PACKAGE_TOP_DIR}libicuuc.so.53.1" 0644


# Ensure proper rpm build environment
RPMMACROS=~/.rpmmacros
NBTOPDIR=/tmp/cnd/rpms

if [ ! -f ${RPMMACROS} ]
then
    touch ${RPMMACROS}
fi

TOPDIR=`grep _topdir ${RPMMACROS}`
if [ "$TOPDIR" == "" ]
then
    echo "**********************************************************************************************************"
    echo Warning: rpm build environment updated:
    echo \"%_topdir ${NBTOPDIR}\" added to ${RPMMACROS}
    echo "**********************************************************************************************************"
    echo %_topdir ${NBTOPDIR} >> ${RPMMACROS}
fi  
mkdir -p ${NBTOPDIR}/RPMS

# Create spec file
cd "${TOP}"
SPEC_FILE=${NBTMPDIR}/../${OUTPUT_BASENAME}.spec
rm -f ${SPEC_FILE}

cd "${TOP}"
echo BuildRoot: ${TOP}/${NBTMPDIR} >> ${SPEC_FILE}
echo 'Summary: Sumary...' >> ${SPEC_FILE}
echo 'Name: gameengine' >> ${SPEC_FILE}
echo 'Version: 1.0' >> ${SPEC_FILE}
echo 'Release: 1' >> ${SPEC_FILE}
echo 'Group: Applications/System' >> ${SPEC_FILE}
echo 'License: BSD-type' >> ${SPEC_FILE}
echo '%description' >> ${SPEC_FILE}
echo 'Description...' >> ${SPEC_FILE}
echo  >> ${SPEC_FILE}
echo '%files' >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}bin/${OUTPUT_BASENAME}\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libboost_regex.so\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libboost_regex.so.1.54.0\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libboost_system.so\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libboost_system.so.1.54.0\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libboost_thread.so\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libboost_thread.so.1.54.0\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libmysqlcppconn.so\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libmysqlcppconn.so.6\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libmysqlcppconn.so.6.1.1.2\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libstdc++.so.6\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}librt.so.1\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libpthread.so.0\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libc.so.6\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libdl.so.2\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libgcc_s.so.1\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libicui18n.so.53.1\" >> ${SPEC_FILE}
echo \"/${PACKAGE_TOP_DIR}libicuuc.so.53.1\" >> ${SPEC_FILE}
echo '%dir' >> ${SPEC_FILE}

# Create RPM Package
cd "${TOP}"
LOG_FILE=${NBTMPDIR}/../${OUTPUT_BASENAME}.log
rpmbuild --buildroot ${TOP}/${NBTMPDIR}  -bb ${SPEC_FILE} > ${LOG_FILE}
makeDirectory "${NBTMPDIR}"
checkReturnCode
cat ${LOG_FILE}
RPM_PATH=`cat $LOG_FILE | grep '\.rpm' | tail -1 |awk -F: '{ print $2 }'`
RPM_NAME=`basename ${RPM_PATH}`
mv ${RPM_PATH} ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/package
checkReturnCode
echo RPM: ${CND_DISTDIR}/${CND_CONF}/${CND_PLATFORM}/package/${RPM_NAME}

# Cleanup
cd "${TOP}"
rm -rf ${NBTMPDIR}
