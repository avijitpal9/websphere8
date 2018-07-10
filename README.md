# WEBSPHERE8

## Overview
Install & Configure WebSphere Commmerce Stack including WebSphere Application Server (ND), IHS & WebSphere Plugin.

## Dependencies
The WebSphere8 puppet module has depends on following puppet modules,
  * avijitpal9-DB2 (latest)
  * puppet-selinux (v1.2.5) - Available on puppetforge
  * puppetlabs-stdlib (v4.15.0) - Available on puppetforge

The puppet module depends on PuppetDB for exported resources.Ensure PuppetDB is configured with puppetserver for the module to work correctly.

## Module Description
The Websphere8 puppet module allows you to install & configure entire
WebSphere Commerce 8 Stack (excluding DB2 Databse). This puppet module can
manage the  following aspect of WCS stack,

* Resolve WCS8 Dependencies
* Install IBM Installation Manager
* Install WebSphere Application Server 8 (WAS8) Network Deployment Edition
* Install WAS8 ND Fixpacks
* Creates & Manages Application server profiles
* Install IBM HTTP Server (IHS)
* Install IHS Fixpacks
* Install WebSphere Application Server 8 Plugin
* Install WAS8 Plugin Fixpacks
* Install & Configure IBM Java SDK
* Install WebSphere Commerce Server 8
* Create WCS Instances
* Configures IHS with WCS Instances
* Generates & Propagates webserver plugins

## Setup
Install WebSphere8 module on PuppetServer using the following command,
  puppet module install avijitpal9-websphere8-x.y.z.tar [--modulepath <Module Installation Path>]

The puppet module depends on PuppetDB for exported resources.Ensure PuppetDB is configured with puppetserver for the module to work correctly.

## Usage

To Install WCS8 stack on a node assign the following classes to the node,

  include 'db2::profile::db2client'
  include 'websphere8::profile::wcstack'
  Class['db2::profile::db2client']->Class['websphere8::profile::wcstack']

You need to pass the following mandatory parameters to the module,

* websphere8::params::imcl_source - Location of IBM Installation Manager Installer.

Example-
websphere8::params::imcl_source: 'http://example.s3.amazonaws.com/INMA1.8.2LNXX86-64OPGRCPLAT7.2ML.zip'

* websphere8::params::wasrepo - Location of WebSphere Enterprise Repository
for WAS, IHS & Plugin

Example-
websphere8::params::wasrepo: 'http://example.s3.amazonaws.com/WAS-ND-8.5/WAS8ENT/repository.config'

* websphere8::params::wcs8_source - Location of WebSphere Commerce 8 Installer

Example-
websphere8::params::wcs8_source: 'http://example.s3.amazonaws.com/WCS8/WC_EntPro_800_MPML.zip'

 * websphere8::params::sdkrepo - Location of IBM JAVA SDK repository

Example-
websphere8::params::sdkrepo: 'http://example.s3.amazonaws.com/WAS-ND-8.5/WASSDK7/repository.config'

* websphere8::was::pkg_id - Package Id for WebSphere Application Server

Example-
websphere8::was::pkg_id: 'com.ibm.websphere.ND.v85_8.5.5011.20161206_1434'

* websphere8::wasfixpack::mtn_pkgid: Package Id for WebSphere Application Server Fixpack

Example-
websphere8::wasfixpack::mtn_pkgid: 'com.ibm.websphere.ND.v85_8.5.5011.20161206_1434'

* websphere8::ihs::pkg_id - Package Id for IBM HTTP Server

Example-
websphere8::ihs::pkg_id: 'com.ibm.websphere.IHS.v85_8.5.5011.20161206_1434'

 * websphere8::ihsfixpack::mtn_pkgid - Package Id for IBM HTTP Server Fixpack

Example-
websphere8::ihsfixpack::mtn_pkgid: 'com.ibm.websphere.IHS.v85_8.5.5011.20161206_1434'

* websphere8::plg::pkg_id - Package Id for WebSphere Application Server Plugin

Example-
websphere8::plg::pkg_id: 'com.ibm.websphere.PLG.v85_8.5.5011.20161206_1434'

 * websphere8::plgfixpack::mtn_pkgid - Package Id for Plugin Fixpack

Example-
websphere8::plgfixpack::mtn_pkgid: 'com.ibm.websphere.PLG.v85_8.5.5011.20161206_1434'

 * websphere8::sdk::sdk7_enable - Whether or not to enable SDK7

Example -
websphere8::sdk::sdk7_enable: true

 * websphere8::sdk::sdk7_mtn_pkgid - Package Id for IBM JAVA SDK7

Example-
websphere8::sdk::sdk7_mtn_pkgid: 'com.ibm.websphere.IBMJAVA.v70_7.0.4001.20130510_2103'

 * websphere8::wcs::remote_db - Whether or not the Database for WCS is installed on remote machine

Example-
websphere8::wcs::remote_db: 'true'

 * websphere8::wcs::configmanager_pass - The WCS configuration manager password

Example-
websphere8::wcs::configmanager_pass: 'config@123'

 * websphere8::app_profile::dmgr::host_name - Host Name for DMGR

Example-
websphere8::app_profile::dmgr::host_name: 'devauth.ec2.internal'

 * websphere8::publishpluginartifacts::wsrv_node_name - Node Name for WebServer1

Example-
websphere8::publishpluginartifacts::wsrv_node_name: 'WC_devauth_node'

 * websphere8::params::wcs_instance_type - WebSphere Commerce Instance type (AUTH/LIVE)

Example-
websphere8::params::wcs_instance_type: 'auth'

 * websphere8::params::wcs_instance_name - WebSphere Commerce Instance Name

Example-
websphere8::params::wcs_instance_name: 'devauth'

* websphere8::wcs_instance::db_host_name - WCS Database Hostname/IP Address

Example-
websphere8::wcs_instance::db_host_name: '10.0.0.6'

* websphere8::wcs_instance::db_port - WCS Database Port Number

Example-
websphere8::wcs_instance::db_port: '50000'

* websphere8::wcs_instance::db_user_name - WCS Database UserName

Example-
websphere8::wcs_instance::db_user_name: 'devauth'

* websphere8::wcs_instance::db_user_pass - WCS Database Password

Example-
websphere8::wcs_instance::db_user_pass: 'devauth'

* websphere8::wcs_instance::data_src_name - WCS DataSource Name

Example-
websphere8::wcs_instance::data_src_name: 'WebSphere Commerce DB2 DataSource Auth'

* websphere8::wcs_instance::was_host_name - WAS Hostname

Example-
websphere8::wcs_instance::was_host_name: 'devauth.ec2.internal'

* websphere8::wcs_instance::wbs_host_name - Webserver Hostname

Example-
websphere8::wcs_instance::wbs_host_name: 'devauth.ec2.internal'

* websphere8::wcsinst_postconfig::dmgr_host - DMGR Hostname

Example-
websphere8::wcsinst_postconfig::dmgr_host: 'devauth.ec2.internal'

* websphere8::wcs_instance::is_staging - Is the WCS Instance for Staging. Defaults to False

Example-
websphere8::wcs_instance::is_staging: true

* websphere8::wcs_instance::is_content_management - Enable Content manager for Instance.
Set to true if you want this instance to be an authoring instance (staging with workspaces)

Example-
websphere8::wcs_instance::is_content_management: true

* websphere8::wcs_instance::cm_read_prefix - Read prefix (suggested: WCR)
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_read_prefix: 'WCR'

* websphere8::wcs_instance::cm_write_prefix - Write prefix (suggested: WCW)
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_write_prefix: 'WCW'

* websphere8::wcs_instance::cm_num_wp - Number of workspaces to create (suggested: 5)
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_num_wp: '5'

* websphere8::wcs_instance::cm_data_src_name - Publish datasource name
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_data_src_name: 'WebSphere Commerce DB2 DataSource CM'

* websphere8::wcs_instance::cm_db_type - Publish database type (Accepted values are: db2 or oracle)
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_db_type: 'db2'

* websphere8::wcs_instance::cm_db_name - Publish database name
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_db_name: 'WCS'

* websphere8::wcs_instance::cm_db_user_name - Publish database user name
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_db_user_name: 'devauth'

* websphere8::wcs_instance::cm_db_user_pass - Publish database user password
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_db_user_pass: 'devauth'

* websphere8::wcs_instance::cm_db_host_name - Publish database server Hostname/IP Address
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_db_host_name: '10.0.0.6'

* websphere8::wcs_instance::cm_db_port - Publish database server port
Required when using content management (creating an authoring instance) otherwise leave blank

Example-
websphere8::wcs_instance::cm_db_port: '50000'
