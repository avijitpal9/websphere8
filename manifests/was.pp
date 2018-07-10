# Class websphere8::was
#
# This class downloads & install WebSphere Application Server on target machine.
#
class websphere8::was (
String $install_loc = '/apps/was/AppServer',
String $pkg_id,
)
{

$imcl_path = $::websphere8::params::imcl_install_loc
$repo_loc = $::websphere8::params::wasrepo
$shared_loc = $::websphere8::params::shared_loc
$user = $::websphere8::params::user

$cmd = "$imcl_path/eclipse/tools/imcl install $pkg_id -repositories $repo_loc -installationDirectory $install_loc -sharedResourcesDirectory $shared_loc -properties user.wasjava=java6 -acceptLicense"

exec { 'INSTALL_WAS':
   command  => $cmd,
   cwd      => $imcl_path,
   creates  => "${install_loc}/bin/versionInfo.sh",
   timeout  => 0,
   user => $user,
 }

}
