# Class websphere8::publishihsartifacts
#
# This class exports the IHS artifacts genertaed during WCS instance
# creation phase to PuppetDB to be consumed later by the webservers
# during configuraion phase. These resources will be consumed by
# websphere8::ihsconfig class.
#
class websphere8::publishihsartifacts (
String $user = 'wasadmin',
) {

$_plginstall_dir=$::websphere8::plg::install_loc
$_wbsinstall_dir=$::websphere8::ihs::install_loc
$_instance_name = $::websphere8::params::wcs_instance_name
$_cell_name=$websphere8::app_profile::dmgr::cell_name
#notify { $_cell_name: }
$_app_path="${::websphere8::was::install_loc}/profiles/${_instance_name}/installedApps/Cell01/WC_${_instance_name}.ear"
$wcs_installdir=$::websphere8::wcs::install_loc

 # Export webserver configuration file to PuppetDB
 @@file {"${_cell_name}_httpd.conf":
    path => "${_wbsinstall_dir}/conf/httpd.conf",
    ensure => present,
    content => epp('websphere8/httpd.conf.epp',{ httpd_home => $_wbsinstall_dir, plginstall_dir => $_plginstall_dir, app_path => $_app_path, instance_name => $_instance_name }),
    tag => ["${_cell_name}_httpd.conf"],
    owner => $user,
    notify => Service['httpd'],
  }

  # Export webserver key file to PuppetDB
  @@file {"${_cell_name}_keyfile.kdb":
     path => "${_wbsinstall_dir}/conf/keyfile.kdb",
     ensure => present,
     source => "file://${wcs_installdir}/instances/${_instance_name}/httpconf/keyfile.kdb",
     owner => $user,
     tag => ["${_cell_name}_keyfile.kdb"],
     notify => Service['httpd'],
   }

   # Export webserver key stash file to PuppetDB
  @@file {"${_cell_name}_keyfile.sth":
      path => "${_wbsinstall_dir}/conf/keyfile.sth",
      ensure => present,
      source => "file://${wcs_installdir}/instances/${_instance_name}/httpconf/keyfile.sth",
      owner => $user,
      tag => ["${_cell_name}_keyfile.sth"],
      notify => Service['httpd'],
    }

}
