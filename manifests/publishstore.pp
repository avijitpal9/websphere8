class websphere8::publishstore () {

 $wcsinstall_dir = $::websphere8::wcs::install_loc
 $site_adm_id = $::websphere8::wcs_instance::site_adm_id
 $site_adm_pass = $::websphere8::wcs_instance::site_adm_pass
 $user = $::websphere8::params::user

$cmd="${wcsinstall_dir}/bin/publishstore.sh -svr ${facts['fqdn']} -userid ${site_adm_id} -pwd ${site_adm_pass} -sar ${wcsinstall_dir}/starterstores/ExtendedSites/ExtendedSites.sar"
notify { $cmd: }

  exec { 'PublishStore_ExtendedSites':
    command => $cmd,
    cwd => "${wcsinstall_dir}/bin",
    user => $user,
    unless => "/bin/test -f ${wcsinstall_dir}/PublishStore_Registry.properties"
    notify => Exec['PublishStore_Registry'],
    timeout => 0,
  }

  exec { 'PublishStore_Registry':
    command => "/bin/echo 'Store Publish Job Submitted' >> ${wcsinstall_dir}/PublishStore_Registry.properties"
    user => $user,
    refreshonly =>true,
  }

}
