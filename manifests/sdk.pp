# Class websphere8::sdk
#
# This class Install & enable IBM JAVA SDK7/SDK8
#
class websphere8::sdk (
Boolean $sdk7_enable = false,
Optional[String] $sdk7_mtn_pkgid = undef,
String $sdk7_repo_loc = $::websphere8::params::sdkrepo,
Boolean $sdk8_enable = false,
Optional[String] $sdk8_mtn_pkgid = undef,
String $sdk8_repo_loc = $::websphere8::params::sdkrepo,
Enum['SDK7','sdk7','SDK8','sdk8'] $default_sdk = 'SDK7',
) {

$imcl_path = $::websphere8::params::imcl_install_loc
$installation_loc = $::websphere8::was::install_loc
$user = $::websphere8::params::user

 # Install IBM JAVA SDK7
  if  $sdk7_enable == true
   {
     websphere8::df_wasfixpack { 'INSTALL_WASSDK7':
      type              => 'wassdk7',
      imcl_path         => $imcl_path,
      installation_loc  => $installation_loc,
      repo_loc          => $sdk7_repo_loc,
      mtn_pkgid         => $sdk7_mtn_pkgid,
      user              => $user,
      before            => Exec['SET_DEFAULT_SDK'],
    }

  }

 # Install IBM JAVA SDK8
  if $sdk8_enable ==true
   {
     websphere8::df_wasfixpack { 'INSTALL_WASSDK8':
      type              => 'wassdk8',
      imcl_path         => $imcl_path,
      installation_loc  => $installation_loc,
      repo_loc          => $sdk8_repo_loc,
      mtn_pkgid         => $sdk8_mtn_pkgid,
      user              => $user,
      before            => Exec['SET_DEFAULT_SDK'],
    }
  }

  # Set Default SDK For WAS

   if $default_sdk != undef
   {

      if $default_sdk == 'SDK7' or $default_sdk == 'sdk7'
       {
           $sdk_id = '1.7_64'
       }
      elsif  $default_sdk == 'SDK8' or $default_sdk == 'sdk8'
       {
            $sdk_id = '1.8_64'
       }


      exec { 'SET_DEFAULT_SDK':
        command => "${installation_loc}/bin/managesdk.sh  -setNewProfileDefault -sdkName $sdk_id",
        cwd   => "${installation_loc}/bin",
        unless => "${installation_loc}/bin/managesdk.sh  -getNewProfileDefault | grep $sdk_id",
        user   => $user,
      }
   }
 }
