
function error_exit() {
    echo "$*"
    exit 99
}

function on_exit() {
    cd "${topdir}"
}

topdir="$(dirname "$(realpath "${0}")")"

set -e
set -x

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

if [ ! -e "${topdir}/pkg1/configs" ] ; then 
    mkdir -p "${topdir}/pkg1/configs" || error_exit "Could not create ${topdir}/pkg1/configs"
fi

cd "${pkgdir}" || error_exit "could not change into ${pkgdir}"

if [ ! -e "${br2_out_dir}/.config" ] ; then
    make -C "${brdir}" O="${br2_out_dir}" BR2_EXTERNAL="${br2_externals}" pc_x86_64_efi_defconfig
fi

if [ -e "configs"/${dot_config_name} ] ; then
    echo "already have defconfig: ${sdkdir}/configs/${dot_config_name}"
else 
    cp "${br2_out_dir}/.config" "configs/${dot_config_name}"
fi

mkdir -p "${br2_out_dir}" || error_exit "Could not create output directory ${br2_out_dir}"
make -d -C "${brdir}" O="${br2_out_dir}" BR2_EXTERNAL="${br2_externals}" "${dot_config_name}"
