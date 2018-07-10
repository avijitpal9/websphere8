class websphere8::wcsinst_postconfig (
String $dmgr_host,
String $dmgr_port = '8879',
String $mheap = '4098',
String $iheap = '4098',
) {

$instance_name = $::websphere8::params::wcs_instance_name
$wasinstall_dir = $::websphere8::was::install_loc
$was_prf_name = $instance_name
$wcsinstall_dir = $::websphere8::wcs::install_loc
$dmgr_uid=$::websphere8::wcs_instance::dmgr_uid
$dmgr_passwd=$::websphere8::wcs_instance::dmgr_passwd
$_dmgr_cell = $::websphere8::app_profile::dmgr::cell_name
$user =$::websphere8::params::user


# Setup JVM Heap Size for server1.
$node_name="WC_${instance_name}_node"
$set_heap = "AdminTask.setJVMMaxHeapSize('-serverName server1 -nodeName ${node_name} -maximumHeapSize ${mheap}');AdminTask.setJVMInitialHeapSize('-serverName server1 -nodeName ${node_name} -initialHeapSize ${iheap}');AdminConfig.save()"

exec { 'server1 Heap':
command => "${wasinstall_dir}/profiles/${was_prf_name}/bin/wsadmin.sh -conntype NONE -lang jython -user ${dmgr_uid} -password ${dmgr_passwd} -c \"$set_heap\"",
cwd     => "${wasinstall_dir}/profiles/${was_prf_name}/bin",
user    => $user,
refreshonly =>true,
notify      => Websphere8::App_profile::Service[$was_prf_name],
}

$cmd_fd="${wasinstall_dir}/profiles/${instance_name}/bin/addNode.sh ${dmgr_host} ${dmgr_port} -includeapps -includebuses -username ${dmgr_uid} -password ${dmgr_passwd}"

## $test="${wasinstall_dir}/profiles/${instance_name}/config/cells/${_was_cell_name}"
## notify { $test: }

exec { "Federate_WC_${instance_name}_node":
  command => $cmd_fd,
  user    => $user,
  creates => "${wasinstall_dir}/profiles/${instance_name}/config/cells/${_dmgr_cell}",
  require => Exec['Create_WCS_Instance']
}

exec { 'WCS_Vhost_Fix':
 command => "${wcsinstall_dir}/bin/config_ant.sh -DinstanceName=${instance_name} CreateVirtualHosts",
 user => $user,
 subscribe => Exec['Update_WCS_Security'],
 refreshonly => true,
}

file { 'MapModules':
 ensure => 'present',
 path => '/tmp/MapModules.jy',
 owner  => $user,
 group  => $user,
 content => epp('websphere8/MapModules.jy.epp', { instance_name => $instance_name } ),
}

$cmd_mapmodule = "${wasinstall_dir}/profiles/${was_prf_name}/bin/wsadmin.sh -lang jython -conntype SOAP -user ${dmgr_uid} -password ${dmgr_passwd} -f /tmp/MapModules.jy"

exec { 'WCS_Map_Modules':
 command => $cmd_mapmodule,
 user    => $user,
 require => File['MapModules'],
}

websphere8::app_profile::service {  $was_prf_name:
    type         => 'appserver',
    ensure       => 'running',
    profile_base => "${wasinstall_dir}/profiles",
    user         => $user,
    wsadmin_user => $dmgr_uid,
    wsadmin_pass => $dmgr_passwd,
    require      => Exec['WCS_Vhost_Fix','WCS_Map_Modules'],
  }

}

