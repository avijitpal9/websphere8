# Class websphere8::plg
#
# This class install WebSphere8 Plugins for webservers on target machines.
#
class websphere8::plg (
String $install_loc = '/apps/was/Plugins',
String $pkg_id,
) {

 $imcl_path = $::websphere8::params::imcl_install_loc
 $repo_loc = $::websphere8::params::wasrepo
 $user = $::websphere8::params::user
 $shared_loc = $::websphere8::params::shared_loc

 $cmd = "$imcl_path/eclipse/tools/imcl install $pkg_id -repositories $repo_loc -installationDirectory $install_loc -sharedResourcesDirectory $shared_loc -acceptLicense"

 exec { 'INSTALL_PLG':
   command  => $cmd,
   cwd      => $imcl_path,
   creates  => "${install_loc}/bin/versionInfo.sh",
   timeout  => 0,
   user => $user,
 }

}
