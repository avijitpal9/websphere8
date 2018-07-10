# Class websphere8::wcs_updi
#
# This class install WCS Update Installer
#
class websphere8::wcs_updi (
 String $inst_loc = '/apps/wcs/WCS_UpdateInstaller',
 String $updi_source,
) inherits ::websphere8::params {

  $wcs_temp_dir =  "${::websphere8::params::temp_dir}/wcs8"
  $user = $::websphere8::params::user

  file { 'WCS8_UPDI':
    ensure => 'present',
    path => "${wcs_temp_dir}/download.updii.8011.linux.amd64.zip",
    source => $updi_source,
    notify => Exec['UNZIP_WCS8_UPDI'],
    owner => $user,
  }

 exec { 'UNZIP_WCS8_UPDI':
  command => "/bin/unzip ${wcs_temp_dir}/download.updii.8011.linux.amd64.zip",
  creates => "${wcs_temp_dir}/UpdateInstaller",
  refreshonly => true,
  notify => Exec['WCS8_UPDI_INSTALL'],
  user => $user,
 }

  file { 'WCS-UPDI-ResponseFile':
    ensure => 'present',
    path => "${wcs_temp_dir}/UpdateInstaller/wcs-updi_responsefile.txt",
    content => epp('websphere8/wcs-updi_responsefile.txt.epp', { inst_loc => $inst_loc }),
    owner => $user,
    require => Exec['UNZIP_WCS8_UPDI'],
    notify => Exec['WCS8_UPDI_INSTALL'],
  }

  $cmd_updi = "${wcs_temp_dir}/UpdateInstaller/install -options wcs-updi_responsefile.txt -silent"
  exec { 'WCS8_UPDI_INSTALL':
    command => $cmd_updi,
    cwd => "${wcs_temp_dir}/UpdateInstaller",
    creates => $inst_loc,
    require => File['WCS-UPDI-ResponseFile'],
    user => $user,
  }

}
