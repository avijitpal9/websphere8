class websphere8::wcsfixpack (
String $mtn_pkgid,
String $mtn_pkgid_source,
) inherits ::websphere8::params {

 $updi_loc = $::websphere8::wcs_updi::inst_loc
 $wcs_loc =  $::websphere8::wcs::install_loc
 $wcs_temp_dir =  "${::websphere8::params::temp_dir}/wcs8"
 $user = $::websphere8::params::user

   file { $mtn_pkgid:
     ensure => 'present',
     path => "${wcs_temp_dir}/${mtn_pkgid}.pak",
     source => $mtn_pkgid_source,
     owner => $user,
   }

   file { "Install_${mtn_pkgid}_Responsefile":
      ensure => 'present',
      path   => "${updi_loc}/responsefiles/install_${mtn_pkgid}_responsefile.txt",
      content => epp('websphere8/install_responsefile.txt.epp', { mtn_pkgid => "${wcs_temp_dir}/${mtn_pkgid}.pak", prd_loc => $wcs_loc }),
      owner => $user,
      notify => Exec["Install_${mtn_pkgid}"],
   }

   $cmd_install_pkg="${updi_loc}/update.sh -options ${updi_loc}/responsefiles/install_${mtn_pkgid}_responsefile.txt -silent"

   exec { "Install_${mtn_pkgid}":
      command => $cmd_install_pkg,
      cwd => $updi_loc,
      unless => "/tmp/install_fixpack.sh $mtn_pkgid $wcs_loc",
      timeout => 0,
      require => File["Install_${mtn_pkgid}_Responsefile","$mtn_pkgid"],
      user => $user,
   }

}
