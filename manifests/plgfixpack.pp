# Class websphere8::plgfixpack
#
# This class install plugin fixpack on top of base plugin installation.
#
class websphere8::plgfixpack (
String $repo_loc = $::websphere8::params::wasrepo,
String $mtn_pkgid,
)
{

  $imcl_path = "${::websphere8::params::imcl_install_loc}/eclipse/tools"
  $installation_loc = $::websphere8::plg::install_loc
  $user = $::websphere8::params::user


 websphere8::df_wasfixpack { 'INSTALL_PLG_FIXPACK':
    type             => 'plg',
    imcl_path        => $imcl_path,
    installation_loc => $installation_loc,
    repo_loc         => $repo_loc,
    mtn_pkgid        => $mtn_pkgid,
    user             => $user,
    require          => Exec['INSTALL_PLG'],
  }

}
