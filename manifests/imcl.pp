# Class websphere8::imcl
#
# This class downloads & install the IBM Installation Manger package as
# non root user.
#
class websphere8::imcl (
) inherits ::websphere8::params {

 $user = $::websphere8::params::user
 $temp_dir =  $::websphere8::params::temp_dir
 $installer_path = "${temp_dir}/imcl"
 $source =  $::websphere8::params::imcl_source
 $install_loc = $::websphere8::params::imcl_install_loc
 $cmd="$installer_path/userinstc -acceptLicense -installationDirectory $install_loc"

  file { $installer_path :
    ensure => 'directory',
  }


  file { 'imcl_package':
   ensure => 'present',
   path   => "${installer_path}/INMA1.8.2LNXX86-64OPGRCPLAT7.2ML.zip",
   source => $source,
   notify => Exec["unzip imcl_package"],
 }

 exec { "unzip imcl_package":
    command => "/bin/unzip ${installer_path}/INMA1.8.2LNXX86-64OPGRCPLAT7.2ML.zip -d ${installer_path}",
    cwd => $temp_dir,
    require => File['imcl_package'],
    refreshonly => true,
    creates => "${installer_path}/userinstc",
    before => Exec['install_imcl'],
 }

 exec {'install_imcl':
   command => $cmd,
   cwd      => $installer_path,
   creates  => "${install_loc}/eclipse/IBMIM",
   timeout  => 0,
   user => $user,
 }

 file {"${install_loc}/responsefiles":
  ensure => 'directory',
  subscribe => Exec['install_imcl'],
  owner => $user,
 }

}
