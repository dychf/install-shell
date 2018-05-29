#!/bin/bash

#创建fastdfs运行所需的数据目录
mkdir -p /data/fastdfs/{tracker,storage/store}

#校验文件是否存在
function check_file()
{
	
echo "----------------执行函数------------------------"
	if [ ! -d ${fdfs_home} ]
	then
		mkdir $fdfs_home
		mkdir ${fdfs_unzip_source} ${fdfs_unzip_lib} 
	else
		cd $fdfs_home
		rm -rf *
		mkdir ${fdfs_unzip_source} ${fdfs_unzip_lib} 
	fi
	
	if [ ! -s ${redis_config_file} ]
	then
		touch ${redis_config_file}
	fi
	
	
}

#获取本机ip
IP=$(ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g')

#fdfs路径
fdfs_home="/usr/local/setup/fdfs_home/"
#fdfs压缩资源路径
fdfs_zip_source="/usr/local/setup/soft/FastDFS*"
#fdfs压缩依赖库路径
fdfs_zip_lib="/usr/local/setup/soft/libfastcommon*"
#fdfs资源路径
fdfs_unzip_source="${fdfs_home}fdfs_source/"
#fdfs依赖库路径
fdfs_unzip_lib="${fdfs_home}fdfs_lib/"


check_file
cd /usr/local/setup/

tar -zxvf ${fdfs_zip_lib} -C ${fdfs_unzip_lib} --strip-components 1 
tar -zxvf ${fdfs_zip_source} -C ${fdfs_unzip_source} --strip-components 1 

cd ${fdfs_unzip_lib} 
./make.sh && ./make.sh install
cd ${fdfs_unzip_source} 
./make.sh && ./make.sh install

cd /usr/local/setup/



#创建启动所需的配置文件
cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf

cd /etc/fdfs/

sed -i "s#\(base_path\).*#\1=/data/fastdfs/tracker/#" tracker.conf

sed -i "s#\(base_path\).*#\1=/data/fastdfs/storage/#" storage.conf
sed -i "s#\(store_path0\).*#\1=/data/fastdfs/storage/store/#" storage.conf
sed -i "s#\(tracker_server\).*#\1=$IP:22122#" storage.conf

sed -i "s#\(base_path\).*#\1=/tmp#" client.conf
sed -i "s#\(tracker_server\).*#\1=$IP:22122#" client.conf


${fdfs_unzip_source}init.d/fdfs_trackerd start
${fdfs_unzip_source}init.d/fdfs_storaged start

fdfs_monitor /etc/fdfs/client.conf
cd /usr/local/setup/

echo "##########################################################################"
echo "#                  \☺/ FastDFS安装并启动完成                             #"
echo "##########################################################################"
