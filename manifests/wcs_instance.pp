# Class websphere8::wcs_instance
#
# This class creates & configures WCS Instance. WCS Product must be installed prior to the creation of Instance.
#
class websphere8::wcs_instance (
String $osname = 'Linux',
String $encoding = 'en_US',
String $merchant_key = '0123456789abcdef',
String $site_adm_id = 'wcsadmin1',
String $site_adm_pass = 'wcsadmin1',
String $bcreate_db = 'false',
String $bcreate_schema = 'true',
String $remote_db = 'false',
String $db_type = 'db2',
String $dba_name = 'db2inst1',
String $dba_pass = 'db2inst1',
String $db_name = 'WCS',
String $db_host_name,
String $db_port,
String $db_user_name,
String $db_user_pass,
String $data_src_name,
String $db_active = 'true',
String $db_exists = 'true',
String $purescale = 'false',
String $was_host_name,
String $was_prf_start_port = '9061',
String $wbs_type = 'HTTP',
Optional[String] $wbs_cfg_path = undef,
String $wbs_remote = 'false',
String $wbs_cfg_ftp = 'false',
String $wbs_cfg_nfs = 'false',
String $wbs_undo = 'false',
String $wbs_host_name,
String $wbs_def_type = 'IHS',
String $wbs_os = 'Linux',
Optional[String] $plg_cfg_file = "${::websphere8::plg::install_loc}/config/webserver1/plugin-cfg.xml",
String $dmgr_uid = 'wasadmin',
String $dmgr_passwd = 'wasadmin',
Boolean $is_staging = false,
Boolean $is_content_management = false,
Optional[String] $cm_read_prefix = undef,
Optional[String] $cm_write_prefix = undef,
Optional[String] $cm_num_wp = undef,
Optional[String] $cm_tgt_app = undef,
Optional[String] $cm_data_src_name = undef,
Optional[String] $cm_db_type = undef,
Optional[String] $cm_db_name = undef,
Optional[String] $cm_db_user_name = undef,
Optional[String] $cm_db_user_pass = undef,
Optional[String] $cm_db_host_name = undef,
Optional[String] $cm_db_port = undef,
String $plginstall_loc = $::websphere8::plg::install_loc,
) {

 $instance_type = $::websphere8::params::wcs_instance_type
 $instance_name = $::websphere8::params::wcs_instance_name
 $was_prf_name = $instance_name
 $wcsinstall_dir = $::websphere8::wcs::install_loc
 $wasinstall_dir = $::websphere8::was::install_loc
 $wbsinstall_dir = $::websphere8::ihs::install_loc
 $db2install_dir = $::websphere8::params::db2install_dir
 $_wcsuser_dir = "${wcsinstall_dir}/instances/${instance_name}"
 $_wcsinstxml_dir = "${wcsinstall_dir}/instances/${instance_name}/xml"
 $_dflt_lang_code = '-1'
 $_dflt_lang = 'en_US'
 $_sprt_lang = '-1'
 $_sprt_lang1 = 'en_US'
 $_struts_enbl = 'true'
 $_pdi_encrpt = 'on'
 $_sqldir = $db_type
 $_ejb_type = $db_type
 $_jdbc_drv_typ = $db_type
 $_trg_del = '#'
# $_id_cust = undef
# $_ml_cust = undef
 $_err_dir = "${wcsinstall_dir}/instances/${instance_name}/logs"
 $_logger_cfg = "${wcsinstall_dir}/instances/${instance_name}/xml/loader/WCALoggerConfig.xml"
# $_id_rslv_mthd = 'mixed'
# $_load_mthd = 'sqlimport'
 $_was_prf_tmp = "${wasinstall_dir}/profileTemplates/default"
 $_was_prf_path = "${wasinstall_dir}/profiles/${instance_name}"
 $_was_cell_name = "Cell01"
 $_was_node_name = "WC_${instance_name}_node"
 $_jdbc_url =  "jdbc:db2://${db_host_name}:${db_port}/${db_name}"
 $_jdbc_loc = "${db2install_dir}/java/db2jcc4.jar;${db2install_dir}/java/db2jcc_license_cu.jar"
 $_jdbc_driver = 'com.ibm.db2.jcc.DB2Driver'
# $_help_srv_port = '8001'
 if $is_content_management == true
 {
   $_cm_jdbc_url =  "jdbc:db2://${cm_db_host_name}:${cm_db_port}/${cm_db_name}"
 }
 else
 {
  $_cm_jdbc_url = undef
 }
 $_ear_path = "${wasinstall_dir}/profiles/${was_prf_name}/installedApps/${$_was_cell_name}/WC_${instance_name}.ear"
 $_wbs_short_name = $wbs_host_name
 $_wbs_cfg_file = "${wbsinstall_dir}/conf/httpd.conf"
 $_db_schema = upcase($db_user_name)

$user = $::websphere8::params::user
 $wbs_doc_root = ''

file {  ["${wcsinstall_dir}/instances/${instance_name}","${wcsinstall_dir}/instances/${instance_name}/properties"]:
   ensure => 'directory',
#  path => ["${wcsinstall_dir}/instances/${instance_name}","${wcsinstall_dir}/instances/${instance_name}/properties"],
   owner => 'wasadmin',
   group => 'wasadmin',
  }

 file { 'WCS_Instance_Property':
  ensure => 'present',
  path   => "${wcsinstall_dir}/instances/${instance_name}/properties/createInstance.properties",
  content => epp('websphere8/createInstance.properties.epp', { instance_name => $instance_name, wcsinstall_dir => $wcsinstall_dir, wcsuser_dir => $_wcsuser_dir, wcsinstxml_dir => $_wcsinstxml_dir, wasinstall_dir => $wasinstall_dir, wbsinstall_dir => $wbsinstall_dir, db2install_dir => $db2install_dir, merchant_key => $merchant_key, site_adm_id => $site_adm_id, site_adm_pass => $site_adm_pass, dba_name => $dba_name, dba_pass => $dba_pass, db_name => $db_name, db_host_name => $db_host_name, db_port => $db_port, db_user_name => $db_user_name, db_user_pass => $db_user_pass, db_schema => $_db_schema, was_host_name => $was_host_name, logger_cfg => $_logger_cfg, err_dir => $_err_dir, jdbc_driver => $_jdbc_driver, jdbc_url => $_jdbc_url, trg_del => $_trg_del, was_prf_tmp => $_was_prf_tmp, was_prf_path => $_was_prf_path, was_prf_name => $was_prf_name, was_prf_start_port => $was_prf_start_port, was_cell_name => $_was_cell_name, was_node_name => $_was_node_name, data_src_name => $data_src_name, jdbc_loc => $_jdbc_loc, wbs_type => $wbs_type, wbs_cfg_path => $wbs_cfg_path,  wbs_remote => $wbs_remote, wbs_cfg_ftp => $wbs_cfg_ftp, wbs_cfg_nfs => $wbs_cfg_nfs, wbs_undo => $wbs_undo, wbs_host_name => $wbs_host_name, wbs_short_name => $_wbs_short_name, wbs_doc_root => $wbs_doc_root, is_staging => $is_staging, is_content_management => $is_content_management, cm_read_prefix => $cm_read_prefix, cm_write_prefix => $cm_write_prefix, cm_num_wp => $cm_num_wp, cm_tgt_app => $cm_tgt_app, cm_data_src_name => $cm_data_src_name, cm_db_type => $cm_db_type, cm_db_name => $cm_db_name, cm_db_user_name => $cm_db_user_name, cm_db_user_pass => $cm_db_user_pass, cm_db_host_name => $cm_db_host_name, cm_db_port => $cm_db_port, cm_jdbc_url => $_cm_jdbc_url, ear_path => $_ear_path, wbs_def_type => $wbs_def_type, wbsinstall_loc => $wbsinstall_dir, wbs_cfg_file => $_wbs_cfg_file, plginstall_loc => $plginstall_loc, plg_cfg_file => $plg_cfg_file }),
 owner => 'wasadmin',
 group => 'wasadmin',
 require => File["${wcsinstall_dir}/instances/${instance_name}","${wcsinstall_dir}/instances/${instance_name}/properties"],
 }


  exec { 'Create_WCS_Instance':
    command => "${wcsinstall_dir}/bin/config_ant.sh -DinstanceName=${instance_name} CreateInstance",
    cwd => "${wcsinstall_dir}/bin",
    user => $user,
    creates => "${wcsinstall_dir}/instances/${instance_name}/xml/${instance_name}.xml",
   # notify  => Exec['Update_WCS_Security'],
    timeout => 0,
  }


  exec { 'Update_WCS_Security':
    command => "${wcsinstall_dir}/bin/setpasswd.py ${wcsinstall_dir} ${instance_name} ${_ear_path} ${dmgr_uid} ${dmgr_passwd}",
    cwd => "${wcsinstall_dir}/bin",
    user => $user,
    refreshonly => true,
    subscribe   => Exec['Create_WCS_Instance'],
    require     => Exec['Create_WCS_Instance'],
   }

}
