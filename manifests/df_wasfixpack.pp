# DefinedType websphere8::df_wasfixpack
#
# This resource ensures fixpacks are applied across different WAS components
#
define websphere8::df_wasfixpack (
Enum['was','ihs','wassdk','plg','ihssdk','wassdk7','wassdk8'] $type,
String $imcl_path,
String $installation_loc,
String $repo_loc,
String $mtn_pkgid,
String $user,
)
{
  validate_absolute_path($imcl_path)
  $_utype =upcase($type)
  $_dtype =downcase($type)


  $cmd = "${imcl_path}/eclipse/tools/imcl  install $mtn_pkgid -installationDirectory $installation_loc -repositories $repo_loc -acceptLicense"

#  notify { "$cmd": }

  exec {"Install_${_utype}_FIXPACKS":
    command => $cmd,
    cwd => $installer_path,
    unless => "/tmp/install_fixpack.sh $mtn_pkgid $installation_loc",
    timeout => 0,
    user   => $user,
 }

}
