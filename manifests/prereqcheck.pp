# Class websphere8::prereqcheck
#
# This class defines & ensures all the prequisites for WEBSPHERE8 module are satisfied.
# Individual classes may contain prerequisites specific to particular functionality.
#
class websphere8::prereqcheck {

  $packages64 = ['psmisc','python2-pip','compat-libstdc++-33','libstdc++','libaio.x86_64','numactl-libs.x86_64','pam']
  $packages86 = ['compat-libstdc++-33.i686','libstdc++.i686','libaio.i686','numactl-libs.i686','pam.i686']

 exec { 'RHEL-SERVER-EXTRAS':
    command => '/bin/yum-config-manager --enable rhui-REGION-rhel-server-extras',
    unless =>  '/bin/yum repolist | grep rhui-REGION-rhel-server-extras',
    before => Package[$packages64,$packages86],
  }

  exec { 'RHEL-SERVER-OPTIONAL':
    command => '/bin/yum-config-manager --enable rhui-REGION-rhel-server-optional',
    unless =>  '/bin/yum repolist | grep rhui-REGION-rhel-server-optional',
    before => Package[$packages64,$packages86],

  }

  class { selinux:
    mode => 'disabled',
    type => 'targeted',
  }


   ensure_resource('file', ['/scratch/packages','/scratch/packages/wcs8'], {'ensure' => 'directory','mode'=>'777'})
#  ensure_resource('file', ['/scratch/packages','/scratch/packages/wcs8'], {'ensure' => 'directory','owner' => 'wasadmin','group' => 'wasadmin','require' => 'User[wasadmin]'})


   user { 'wasadmin':
    name => 'wasadmin',
    ensure => 'present',
    uid    => '2001',
    password => '$1$UCXtPIXj$euQ4gY8awQQXQdp1uIc6H/',
    notify => File['/home/wasadmin/.bash_profile'],
   }


  file { '/home/wasadmin':
    ensure => 'directory',
    owner => 'wasadmin',
    group => 'wasadmin',
    require => User['wasadmin'],
   }

  file { '/home/wasadmin/.bash_profile':
   ensure => 'present',
   replace => false,
   subscribe => File['/home/wasadmin'],
  }

   file { 'Fixpack_Val_Script':
     ensure => 'present',
     path   => '/tmp/install_fixpack.sh',
     owner  => 'wasadmin',
     group  => 'wasadmin',
     mode   => '554',
     source => 'puppet:///modules/websphere8/install_fixpack.sh',
   }

 ensure_packages($packages64,{'ensure' => 'present'})

 ensure_packages($packages64,{'ensure' => 'present'})

}
