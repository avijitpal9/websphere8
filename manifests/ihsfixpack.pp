# Class websphere8::ihsfixpack
#
# This class install ihs fixpacks on top of  base ihs installation.
#
class websphere8::ihsfixpack (
String $repo_loc = $::websphere8::params::wasrepo,
String $mtn_pkgid,
)
{

 $imcl_path = "${::websphere8::params::imcl_install_loc}/eclipse/tools"
 $installation_loc = $::websphere8::ihs::install_loc
 $user = $::websphere8::params::user

websphere8::df_wasfixpack { 'INSTALL_IHS_FIXPACK':
  type             => 'ihs',
  imcl_path        => $imcl_path,
  installation_loc => $installation_loc,
  repo_loc         => $repo_loc,
  mtn_pkgid        => $mtn_pkgid,
  user             => $user,
  require          => Exec['INSTALL_IHS'],
}


}
