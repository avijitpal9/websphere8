#! /bin/python

#Usage: setpasswd.py <WCSINSTALL_DIR> <INSTANCE_NAME> <WASADMIN_USERNAME> <WASADMIN_PASSWORD>

import xml.etree.ElementTree as ET
import subprocess
import sys

wcsinstall_dir = sys.argv[1]
wcsinstance_name = sys.argv[2]
ear_path = sys.argv[3]
user_id = sys.argv[4]
user_pass = sys.argv[5]
print("New User: {}, New Passwd : {}".format(user_id,user_pass))
cmd="{}/bin/wcs_encrypt.sh".format(wcsinstall_dir)
xml_doc="{0}/instances/{1}/xml/{1}.xml".format(wcsinstall_dir,wcsinstance_name)
ear_xml_doc = "{0}/xml/config/wc-server.xml".format(ear_path)
#print cmd
print xml_doc
print ear_xml_doc

ps_wcs=subprocess.Popen([cmd, user_pass],stdout=subprocess.PIPE)
ps_gawk=subprocess.Popen(['gawk', '$1 ~ /ASCII/ {print $5}'],stdin=ps_wcs.stdout,stdout=subprocess.PIPE)

(output,err) = ps_gawk.communicate()
output=output.strip()
#p.terminate()

print("Output: ",output)
user_pass_en=output
print(user_pass_en)

tree = ET.parse(xml_doc)
root = tree.getroot()
#print(root.tag)

for el in root.iter('Security'):
     #print (el.tag,el.attrib)
     _user   = el.get('AdminUser')
     _passwd = el.get('AdminPwd')
     _runid  = el.get('RunAsID')
     _runpwd = el.get('RunAsPwd')

     print("Current User: {}, Current Passwd : {}".format(_user,_passwd))
     if _user != user_id:
         print("setting User Id...")
         el.set('AdminUser',user_id)
         print("User Id set")

     if _passwd != user_pass_en:
         print("setting User Passwd...")
         el.set('AdminPwd',user_pass_en)
         print("User Passwd set")

     if _runid != user_id:
         print("setting RunAsID...")
         el.set('RunAsID',user_id)
         print("RunAsID set")

     if _runpwd != user_pass_en:
       print("setting RunAsPwd...")
       el.set('RunAsPwd',user_pass_en)
       print("RunAsPwd set")

tree.write(xml_doc)

tree = ET.parse(ear_xml_doc)
root = tree.getroot()
#print(root.tag)

for el in root.iter('Security'):
     #print (el.tag,el.attrib)
     _user   = el.get('AdminUser')
     _passwd = el.get('AdminPwd')
     _runid  = el.get('RunAsID')
     _runpwd = el.get('RunAsPwd')

     print("Current User: {}, Current Passwd : {}".format(_user,_passwd))
     if _user != user_id:
         print("setting User Id...")
         el.set('AdminUser',user_id)
         print("User Id set")

     if _passwd != user_pass_en:
         print("setting User Passwd...")
         el.set('AdminPwd',user_pass_en)
         print("User Passwd set")

     if _runid != user_id:
         print("setting RunAsID...")
         el.set('RunAsID',user_id)
         print("RunAsID set")

     if _runpwd != user_pass_en:
         print("setting RunAsPwd...")
         el.set('RunAsPwd',user_pass_en)
         print("RunAsPwd set")

tree.write(ear_xml_doc)

