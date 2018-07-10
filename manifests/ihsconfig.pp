# Class websphere8::ihsconfig
#
# This class configures IHS post WCS instance creation.
#
class websphere8::ihsconfig () {

  $_cell_name = $::websphere8::app_profile::dmgr::cell_name
  $httpd_home = $::websphere8::ihs::install_loc

 # Copy the latest ihs config, ihs keys, plugin config, plugin keys files

  File <<| tag == "${_cell_name}_plugin-cfg.xml" |>>
  File <<| tag == "${_cell_name}_plugin-key.kdb" |>>
  File <<| tag == "${_cell_name}_plugin-key.sth" |>>
  File <<| tag == "${_cell_name}_httpd.conf" |>>
  File <<| tag == "${_cell_name}_keyfile.kdb" |>>
  File <<| tag == "${_cell_name}_keyfile.sth" |>>

 # Start IHS Service
  service { 'httpd':
    ensure   => 'running',
    start    => "${httpd_home}/bin/apachectl -k start -f ${httpd_home}/conf/httpd.conf",
    stop     => "${httpd_home}/bin/apachectl -k stop -f ${httpd_home}/conf/httpd.conf",
    status   => "test -e   ${httpd_home}/logs/httpd.pid && ps -ef | grep $(cat ${httpd_home}/logs/httpd.pid) &>/dev/null",
    restart  => "${httpd_home}/bin/apachectl -k restart -f ${httpd_home}/conf/httpd.conf",
    provider => 'base',
  }

}
