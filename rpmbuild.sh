#!/bin/bash -e

source "./functions.sh";

function usage() {
cat << EOF
Usage:
  sh ${SCRIPT_FILE} BUILD_SH_DIR [options...]

Build package via docker container

Options:
  -d, --debug  Debug mode (login to the container via docker exec)
  -h, --help   Print help (this messgae) and exit
EOF
}

function main() {
  # check parameter 1
  if [[ -z "${TARGET_DIR}" || ! -d "${TARGET_DIR}" || $(echo "${TARGET_DIR}" | tr '/' '\n' | wc -l) -lt 3 ]]; then
    echo -e "Error:\n  Invalid argument (BUILD_SH_DIR)";
    echo -e "\nRun 'sh ${SCRIPT_FILE} --help' for more information";
    exit 1;
  fi

  # build base image
  docker build -t ${BASE_IMAGE_NAME} "${OS_NAME}/${OS_VERSION}";

  # cleanup & setup, mount directory
  rm -rf ${MOUNT_PATH};
  if [ ${?} != 0 ]; then
    echo -e $(tco RED "Error:\n  Delete the ./mount directory as a root user")
    exit 1;
  fi
  \cp -rp ${TARGET_DIR} ${MOUNT_PATH};

  # run build script
  DOCKER_RUN="docker run --rm -e BUILD_USER=$(id -nu) -e BUILD_UID=$(id -u) -v ${MOUNT_PATH}:${CONTAINER_BUILD_PATH}:rw -it ${BASE_IMAGE_NAME}";
  if ${OPT_DEBUG}; then
    $DOCKER_RUN;
  else
    eval "$DOCKER_RUN /bin/bash -c 'sh build.sh'";
  fi
}

OPT_DEBUG=false;

ARGUMENTS=`getopt --options dh --longoptions debug,help -n ${SCRIPT_FILE} -- "${@}"`;
if [ ${?} != 0 ] ; then
  exit 1;
fi
eval set -- "${ARGUMENTS}";
while true; do
  case "${1}" in
  -d | --debug)
    OPT_DEBUG=true;
    set -x;
    shift;
    ;;
  -h | --help)
    usage;
    exit 1;
    ;;
  --)
    shift;
    ;;
  *)
    break;
    ;;
  esac
done

# change to your docker_user_name
readonly DOCKER_USER_NAME="fumimaron9";

readonly TARGET_DIR="${1}";
readonly MOUNT_PATH="${SCRIPT_DIR}/mount";
readonly CONTAINER_BUILD_PATH="/root/rpmbuild";
readonly OS_NAME=$(echo ${TARGET_DIR} | awk -F'/' '{print $1}');
readonly OS_VERSION=$(echo ${TARGET_DIR} | awk -F'/' '{print $2}');
readonly PACKAGE_NAME=$(echo ${TARGET_DIR} | awk -F'/' '{print $3}');
readonly BASE_IMAGE_NAME="${DOCKER_USER_NAME}/rpmbuild-${OS_NAME}:${OS_VERSION}";
readonly LOG_FILE="./build.log"

main 2>&1 | tee $LOG_FILE;
