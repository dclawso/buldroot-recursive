
function error_exit() {
    echo "$*"
    exit 99
}

function on_exit() {
    cd "${topdir}"
}

topdir="$(dirname "$(realpath "${0}")")"

set -e

trap on_exit EXIT

echo "****************************************************************************"
echo "topdir=${topdir}"
echo "****************************************************************************"
ext_build_name="package1"
config_name="${ext_build_name}-release_defconfig"
dot_config_name=."${config_name}"
br2_out_dir="${topdir}/${ext_build_name}-release-output"
brdir="${topdir}/buildroot"
br2_externals="${topdir}/pkg1"


pkgdir="${topdir}/pkg1"
mkdir "${topdir}/pkg1/configs" || error_exit "Could not create ${topdir}/pkg1/configs"
cd "${pkgdir}" || error_exit "could not change into ${pkgdir}"
if [ -e "configs"/${dot_config_name} ] ; then
    echo "already have defconfig: ${sdkdir}/configs/${dot_config_name}"
else 
    cp "${brdir}/.config" "configs/${dot_config_name}"
fi

mkdir -p "${br2_out_dir}" || error_exit "Could not create output directory ${br2_out_dir}"
make -d -C "${brdir}" O="${br2_out_dir}" BR2_EXTERNAL="${br2_externals}" "${dot_config_name}"
