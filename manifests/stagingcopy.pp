class websphere8::stagingcopy (
String $dba_name = 'db2inst1',
String $dba_home = '/db2home/db2inst1',
String $live_db = $websphere8::wcs_instance::cm_db_name,
String $live_dbhost = $websphere8::wcs_instance::cm_db_host_name,
String $live_dbport = '50000',
String $live_dbuser = $websphere8::wcs_instance::cm_db_user_name,
String $live_dbpass = $websphere8::wcs_instance::cm_db_user_pass,
String $auth_db     = $websphere8::wcs_instance::db_name,
String $auth_dbhost = $websphere8::wcs_instance::db_host_name,
String $auth_dbport = '50000',
String $auth_dbuser = $websphere8::wcs_instance::db_user_name,
String $auth_dbpass = $websphere8::wcs_instance::db_user_pass,
) {

$wcsinstall_dir = $::websphere8::wcs::install_loc
$db2install_dir = $::db2::params::install_dest
$user = $::websphere8::params::user

 file { 'DB2ALIAS_SCRIPT':
 ensure => 'present',
 path   => "${dba_home}/db2alias.sh",
 content => epp('websphere8/db2alias.sh.epp',{ live_db => $live_db, live_dbhost => $live_dbhost, live_dbport => $live_dbport,  auth_db => $auth_db, auth_dbhost => $auth_dbhost, auth_dbport => $auth_dbport } ),
 owner   => $dba_name,
 mode    => '744',
  }

 exec { 'DB2ALIAS':
 command => "${dba_home}/db2alias.sh",
 cwd     => $dba_home,
 unless  => "db2 list database directory | /bin/grep AUTHDB && db2 list database directory | /bin/grep LIVEDB",
 user    => $dba_name,
 path    => '/db2home/db2inst1/sqllib/bin:/db2home/db2inst1/sqllib/adm:/db2home/db2inst1/sqllib/misc:/db2home/db2inst1/.local/bin:/db2home/db2inst1/bin',
 require => File['DB2ALIAS_SCRIPT'],
 notify  => Exec['StagingCopy'],
 }

 $cmd = "${wcsinstall_dir}/bin/stagingcopy.sh -scope _all_ -sourcedb ${live_db} -destdb ${auth_db} -sourcedb_user ${live_dbuser} -sourcedb_passwd ${live_dbpass} -destdb_user ${auth_dbuser} -destdb_passwd ${auth_dbpass}"
 exec { 'StagingCopy':
   command => $cmd,
   cwd => "${wcsinstall_dir}/bin",
   environment => ['LD_LIBRARY_PATH=/apps/db2/V10.5/lib64:/apps/wcs/CommerceServer80/bin:/db2home/db2inst1/sqllib/lib64:/db2home/db2inst1/sqllib/lib64/gskit:/db2home/db2inst1/sqllib/lib32'], 
  user => $user,
  path => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:${wcsinstall_dir}/bin:${db2install_dir}",
 }

}

