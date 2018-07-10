# Class websphere8::publishpluginartifacts
#
# This class exports the Plugins artifacts genertaed during WCS instance
# creation phase to PuppetDB to be consumed later by the webservers
# during configuraion phase. These resources will be consumed by
# websphere8::ihsconfig class.
#
class websphere8::publishpluginartifacts (
String $webservername = 'webserver1',
String $wsrv_node_name,
) {

$user=$::websphere8::params::user
$_cell_name=$::websphere8::app_profile::dmgr::cell_name
#notify { $_cell_name: }
$wasinstall_dir=$::websphere8::was::install_loc
$plginstall_dir=$::websphere8::plg::install_loc
$_genplugin_cmd="${wasinstall_dir}/bin/GenPluginCfg.sh -profileName Dmgr -cell.name ${_cell_name} -node.name ${wsrv_node_name} -webserver.name webserver1"
$_loc="${wasinstall_dir}/profiles/Dmgr/config/cells/${_cell_name}/nodes/${wsrv_node_name}/servers/webserver1/"

 # Generate Webserver Plugin
   exec {"GENERATE_PLUGIN_${webservername}":
      command => $_genplugin_cmd,
      user   => $user,
  }

 # Export plugin configuration file to PuppetDB
  @@file {"${_cell_name}_plugin-cfg.xml":
     path => "${plginstall_dir}/config/webserver1/plugin-cfg.xml",
     ensure => present,
     source => "file://${_loc}/plugin-cfg.xml",
     owner => $user,
     tag => ["${_cell_name}_plugin-cfg.xml"],
     require => Exec["GENERATE_PLUGIN_${webservername}"],
     notify => Service['httpd'],
   }

  # Export plugin key file to PuppetDB
   @@file {"${_cell_name}_plugin-key.kdb":
     path => "${plginstall_dir}/config/webserver1/plugin-key.kdb",
     ensure => present,
     source => "file://${_loc}/plugin-key.kdb",
     owner => $user,
     tag => ["${_cell_name}_plugin-key.kdb"],
     require => Exec["GENERATE_PLUGIN_${webservername}"],
     notify => Service['httpd'],
    }

   # Export plugin key stash file to PuppetDB
    @@file {"${_cell_name}_plugin-key.sth":
      path => "${plginstall_dir}/config/webserver1/plugin-key.sth",
      ensure => present,
      source => "file://${_loc}/plugin-key.sth",
      owner => $user,
      tag => ["${_cell_name}_plugin-key.sth"],
      require => Exec["GENERATE_PLUGIN_${webservername}"],
      notify => Service['httpd'],
     }

}
