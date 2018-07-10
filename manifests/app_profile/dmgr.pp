class websphere8::app_profile::dmgr (
String $profile_name  = 'Dmgr',
String $enable_security = 'true',
String $dmgr_user = 'wasadmin',
String $dmgr_pass = 'wasadmin',
String $node_name = 'dmgrNode',
String $host_name,
String $mheap = '2048',
String $iheap = '2048',
) {
  notice ("running dmgr.pp manifest")

  $cell_name = "WC_${::websphere8::params::wcs_instance_name}_Cell"
  $instance_base = $::websphere8::was::install_loc
  $template_path = "${instance_base}/profileTemplates/dmgr"
  $profile_base  = "${instance_base}/profiles"
  $user = $::websphere8::params::user

  $cmd = "${instance_base}/bin/manageprofiles.sh -create  -profileName ${profile_name} -profilePath ${profile_base}/${profile_name} -templatePath ${$template_path}  -nodeName ${node_name} -hostName ${host_name} -cellName ${cell_name} -enableAdminSecurity ${enable_security} -adminUserName ${dmgr_user} -adminPassword ${dmgr_user}"

  exec { 'Dmgr-Profile':
    command => $cmd,
    cwd     => "${instance_base}/bin",
    creates => "${instance_base}/profiles/${profile_name}/logs/AboutThisProfile.txt",
    user    => $user,
    notify  => Exec['DMGR-Heap'],
    timeout => 0,
  }
   
   # Setup JVM Heap Size for DMGR.
  $set_heap = "AdminTask.setJVMMaxHeapSize('-serverName dmgr -nodeName ${node_name} -maximumHeapSize ${mheap}');AdminTask.setJVMInitialHeapSize('-serverName dmgr -nodeName ${node_name} -initialHeapSize ${iheap}');AdminConfig.save()"

  exec { 'DMGR-Heap':
     command => "${instance_base}/bin/wsadmin.sh -conntype NONE -lang jython -user wasadmin -password wasadmin -c \"$set_heap\"",
     cwd     => "${instance_base}/bin",
     user    => $user,
     refreshonly =>true,
     notify      => Websphere8::App_profile::Service[$profile_name],
   }

   websphere8::app_profile::service { $profile_name:
      type         => 'dmgr',
      ensure       => 'running',
      profile_base => $profile_base,
      user         => $user,
      wsadmin_user => 'wasadmin',
      wsadmin_pass => 'wasadmin',
      require      => Exec['Dmgr-Profile'],
    }
}
