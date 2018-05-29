#!/bin/bash

#jdk解压目录
jdk_home="/usr/local/setup/jdk_home"
if [ ! -d ${jdk_home} ]
then 
	mkdir ${jdk_home}
else
	cd ${jsk_home}
	rm -rf *
	cd /usr/local/setup/
fi

#jdk版本
jdk_version="jdk1.8*"


#压缩文件位置
jdk_source_code="/usr/local/setup/soft/jdk-*"

#解压至指定目录
tar -zxvf ${jdk_source_code} -C ${jdk_home} --strip-components 1 
#mv /usr/local/setup/${jdk_version} ${jdk_home}


#添加环境变量
echo $jdk_home
echo "export JAVA_HOME=${jdk_home}" >> /etc/profile
echo "export CLASSPATH=\$JAVA_HOME/lib" >> /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
source /etc/profile

echo "################\☺/ JDK安装并配置完成,版本为：#####################"
java -version
echo "###################################################################"

