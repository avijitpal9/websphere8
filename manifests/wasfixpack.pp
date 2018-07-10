# Class websphere8::wasfixpack
#
# This class install was fixpack on top of base was installation.
#
class websphere8::wasfixpack (
String $repo_loc = $::websphere8::params::wasrepo,
String $mtn_pkgid,
)
{

$imcl_path = "${::websphere8::params::imcl_install_loc}/eclipse/tools"
$installation_loc = $::websphere8::was::install_loc
$user = $::websphere8::params::user

  websphere8::df_wasfixpack { 'INSTALL_WAS_FIXPACK':
    type             => 'was',
    imcl_path        => $imcl_path,
    installation_loc => $installation_loc,
    repo_loc         => $repo_loc,
    mtn_pkgid        => $mtn_pkgid,
    user             => $user,
    require          => $Exec['INSTALL_WAS'],
  }

}
