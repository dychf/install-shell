#!/bin/bash
#需先配置Jdk环境变量
#获取本机ip
IP=$(ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g')

#es压缩包路径
es_source_code="/usr/local/setup/soft/elasticsearch*"
#es解压目录
es_source_code_unzip_dir="/usr/local/setup/elasticsearch_home"
rm -rf ${es_source_code_unzip_dir}
#解压es
tar -zxvf ${es_source_code}
mv /usr/local/setup/elasticsearch* ${es_source_code_unzip_dir}

#配置文件位置
conf=${es_source_code_unzip_dir}/config/elasticsearch.yml

#修改es配置
echo "cluster.name: erc-web-es" >> ${conf}
echo "node.name: node-1" >> ${conf}
echo "network.host: ${IP}" >> ${conf}
echo "http.port: 9200" >> ${conf}


user=elastic
#create user if not exists  
id $user >& /dev/null  
if [ $? -ne 0 ]  
then  
   useradd $user  
fi 

chown -R elastic:elastic  ${es_source_code_unzip_dir}

su - elastic <<EOF
	#启动es
	${es_source_code_unzip_dir}/bin/elasticsearch -d
	exit
EOF

echo "##########################################################################"
echo "#                        \☺/ es安装完成                                  #"
echo "##########################################################################"



