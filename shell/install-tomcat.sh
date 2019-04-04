#!/bin/bash

#tomcat端口号
#port=8088
#tomcat压缩目录
tomcat_zip="/usr/local/setup/soft/apache-tomcat*"
#tomcat解压目录
tomcat_home="/usr/local/setup/tomcat_home/"
#启动目录
tomcat_start_dir="${tomcat_home}bin/"

if [ ! -d ${tomcat_home} ]
	then 
	mkdir ${tomcat_home}
else 
	cd ${tomcat_home}
	rm -rf *
fi

cd /usr/local/setup/
#解压tomcat
tar -zxvf ${tomcat_zip} -C ${tomcat_home} --strip-components 1 

#cd ${tomcat_home}conf
#sed -i "s#\(port\).*#\1=${port}/#" server.xml

#启动tomcat
#cd ${tomcat_start_dir}
#./startup.sh

#将tomcat注册为服务
cp /usr/local/setup/soft/conf/tomcat_init /etc/init.d/tomcat
chmod 755 /etc/init.d/tomcat
chkconfig --add tomcat
chkconfig tomcat on
service tomcat start 


echo "##########################################################################"
echo "#                    \☺/ tomcat安装并启动成功                            #"
echo "##########################################################################"
