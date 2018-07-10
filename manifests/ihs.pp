# Class websphere8::ihs
#
# This class installs IHS server on target machines.
#
class websphere8::ihs (
String $install_loc = '/apps/ihs',
String $pkg_id,
) {

$imcl_path = $::websphere8::params::imcl_install_loc
$repo_loc = $::websphere8::params::wasrepo
$user = $::websphere8::params::user
$shared_loc = $::websphere8::params::shared_loc

$cmd = "${imcl_path}/eclipse/tools/imcl install ${pkg_id} -repositories ${repo_loc} -installationDirectory ${install_loc} -sharedResourcesDirectory ${shared_loc} -acceptLicense -properties \"user.ihs.httpPort=80,user.ihs.allowNonRootSilentInstall=true\""
#notify { $cmd: }

exec { 'INSTALL_IHS':
   command  => $cmd,
   cwd      => $imcl_path,
   creates  => "${install_loc}/bin/versionInfo.sh",
   timeout  => 0,
   user => $user,
 }


 file { ["${install_loc}/web"]:
      ensure => 'directory',
      owner  => 'wasadmin',
      group  => 'wasadmin',
      require => Exec['INSTALL_IHS'],
}

}
