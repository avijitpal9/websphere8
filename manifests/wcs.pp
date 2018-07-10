# Class websphere8::wcs
#
# This class downloads & install WebSphere Commerce product on target machines.
#
class websphere8::wcs (
String $accept_license = 'true',
String $install_loc ='/apps/wcs/CommerceServer80',
String $install_commerceedition = 'Enterprise',
String $install_commerceserver = 'true',
String $install_remoteUtilities = 'true',
String $install_commerceHelp = 'true',
String $db_type = '1',
String $remote_db = true,
String $db_user = 'db2inst1',
String $db_group = 'db2iadm1',
String $db_userhome = '/db2home/db2inst1',
String $database_type ='1',
String $webserver_type ='1',
String $configmanager_pass = 'config@123',
String $replace_exst_resp = 'yesToAll',
String $replace_new_resp = 'yesToAll',
) {

  $wcs_temp_dir =  "${::websphere8::params::temp_dir}/wcs8"
  $source = $::websphere8::params::wcs8_source
  $installer_path = "${wcs_temp_dir}/disk1"
  $installdb2_loc = $::db2::params::install_dest
  $installihs_loc = $::websphere8::ihs::install_loc
  $installplg_loc = $websphere8::plg::install_loc
  $installwas_loc = $websphere8::was::install_loc
  $wcs_user = $::websphere8::params::user
  $wcs_group = $::websphere8::params::user
  $wcs_userhome = "/home/${::websphere8::params::user}"


  file { 'wcs8_package':
     ensure => 'present',
     path =>  "${wcs_temp_dir}/WC_EntPro_800_MPML.zip",
     source => $source,
     notify => Exec['unzip wcs8_package'],
  }

  exec { 'unzip wcs8_package':
    command => "/bin/unzip ${wcs_temp_dir}/WC_EntPro_800_MPML.zip -d ${wcs_temp_dir}",
    require => File['wcs8_package'],
    refreshonly => true,
    creates => "$temp_dir/wcs8/disk1",
    timeout => 0,
    before => Exec['Install_WCS'],
  }

  validate_absolute_path($installer_path)

  $cmd = "${installer_path}/setup_linux -G licenseAccepted=${accept_license} -W CustomInstallOptions.commerceServer=${install_commerceserver} \
-W InstallEdition.commerceEdition=${install_commerceedition} -W CustomInstallOptions.remoteUtilities=${install_remoteUtilities} \
-W CustomInstallOptions.commerceHelp=${install_commerceHelp} -W InstallPath.commerceLocation=${install_loc} -W InstallPath.db2Location=${installdb2_loc} \
-W InstallPath.ihsLocation=${installihs_loc} -W InstallPath.pluginLocation=${installplg_loc} \
-W InstallPath.wasLocation=${installwas_loc} -W NonRoot.userID=${wcs_user} -W NonRoot.userGroup=${wcs_group} -W NonRootHome.userHome=${wcs_userhome} \
-W DatabaseOptions.databaseType=${db_type} -W DatabaseOptions.remoteDB=${remote_db} -W Database.userID=${db_user} -W Database.userGroup=${db_group} \
-W Database.userHome=${db_userhome} -W WebServerOptions.webServerType=${webserver_type} -W ConfigManager.userPassword=${configmanager_pass} \
-G replaceExistingResponse=${replace_exst_resp}-G replaceNewerResponse=${replace_new_resp} -silent"


#   notify { $cmd: }

    exec { 'Install_WCS':
    command => $cmd,
    cwd => $installer_path,
    creates => "${install_loc}/bin/versionInfo.sh",
    timeout => 0,
  }


 file { 'setpasswd.py':
   ensure => 'present',
   path => "${install_loc}/bin/setpasswd.py",
   source => 'puppet:///modules/websphere8/setpasswd.py',
   owner  => $wcs_user,
   group  => $wcs_group,
   mode => '755',
   require => Exec['Install_WCS'],
  }

}
