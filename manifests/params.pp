# Class websphere8::params
#
# This class defines user defined & default parameters for WEBSPHERE8 puppet module.
# The user paramters can be set or overidden by setting hiera values.
#
class websphere8::params (
String $user ='wasadmin',
String $imcl_source,
String $wasrepo,
String $sdkrepo,
String $wcs8_source,
Enum['auth','AUTH','live','LIVE'] $wcs_instance_type,
String $wcs_instance_name,
String $db2install_dir = '/apps/db2/V10.5',
)
{
$temp_dir='/scratch/packages'
$imcl_install_loc = '/apps/was/InstallationManager'
$shared_loc = '/apps/was/IMShared'
}
