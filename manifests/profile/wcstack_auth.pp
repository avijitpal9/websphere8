class websphere8::profile::wcstack_auth {
   require 'db2::profile::db2client'
   class { 'websphere8::prereqcheck': }
   class { 'websphere8::imcl': }
   class { 'websphere8::was': }
#   class { 'websphere8::wasfixpack': }
   class { 'websphere8::ihs': }
#   class { 'websphere8::ihsfixpack': }
   class { 'websphere8::plg': }
#   class { 'websphere8::plgfixpack': }
   class { 'websphere8::sdk': }
   class { 'websphere8::app_profile::dmgr': }
   class { 'websphere8::wcs': }
   class { 'websphere8::wcs_updi': }
   class { 'websphere8::wcsfixpack': }
   class { 'websphere8::wcs_instance': }
   class { 'websphere8::stagingcopy': }
#   class { 'websphere8::wcsinst_postconfig': }
#   class { 'websphere8::publishihsartifacts': }
#   class { 'websphere8::publishpluginartifacts': }
#   class { 'websphere8::ihsconfig': }

#Class['websphere8::prereqcheck']->Class['websphere8::imcl']->Class['websphere8::was']->Class['websphere8::ihs']->Class['websphere8::plg']->Class['websphere8::sdk']->Class['websphere8::wcs']->Class['websphere8::wcs_updi']->Class['websphere8::wcsfixpack']->Class['websphere8::app_profile::dmgr']->Class['websphere8::wcs_instance']->Class['websphere8::stagingcopy']->Class['websphere8::wcsinst_postconfig']->Class['websphere8::publishihsartifacts']->Class['websphere8::publishpluginartifacts']->Class['websphere8::ihsconfig']

Class['websphere8::prereqcheck']->Class['websphere8::imcl']->Class['websphere8::was']->Class['websphere8::ihs']->Class['websphere8::plg']->Class['websphere8::sdk']->Class['websphere8::wcs']->Class['websphere8::wcs_updi']->Class['websphere8::wcsfixpack']->Class['websphere8::app_profile::dmgr']->Class['websphere8::wcs_instance']->Class['websphere8::stagingcopy']
}
