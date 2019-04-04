#!/bin/bash
#软件安装根目录
ware_root="/usr/local/setup/"

#校验文件是否存在
function check_config_file()
{
	
echo "----------------执行函数------------------------"
	if [ ! -d ${redis} ]
	then
		mkdir ${redis} ${redis_setup_dir} ${redis_source_code_unzip_dir}
	else
		cd $redis_source_code_unzip_dir
		rm -rf *
		cd $redis_setup_dir
		rm -rf *
		mkdir  ${redis_setup_dir} ${redis_source_code_unzip_dir}
	fi
	
	if [ ! -d ${redis_data_dir} ]
	then
		mkdir $redis_data_dir
	else
		cd $redis_data_dir
		rm -rf *
	fi
	
	if [ ! -s ${redis_config_file} ]
	then
		touch ${redis_config_file}
	fi
	
	
}

#获取本机ip
IP=$(ip a|grep -w 'inet'|grep 'global'|sed 's/^.*inet //g'|sed 's/\/[0-9][0-9].*$//g')

#redis目录
redis=/usr/local/setup/redis_home/
#redis端口号
port=6379
#redis安装路径
redis_setup_dir="${redis}redis_setup_dir/"

#redis压缩包源文件
redis_source_code="/usr/local/setup/soft/redis-*"
#redis解压路径
redis_source_code_unzip_dir="${redis}redis_source/"
#redis配置文件位置
redis_config_file="${redis_setup_dir}redis.conf"
#redis数据备份文件位置
redis_data_dir="${redis_setup_dir}redis_data"


check_config_file
cd /usr/local/setup/

tar -zxvf ${redis_source_code} -C ${redis_source_code_unzip_dir} --strip-components 1 

cd ${redis_source_code_unzip_dir} && make
make PREFIX=${redis_setup_dir} install

cd /usr/local/setup/
mv ${redis_setup_dir}bin/* ${redis_setup_dir}
rmdir ${redis_setup_dir}bin/


cat >>${redis_config_file}<< EOF
daemonize yes
logfile ${redis_setup_dir}redis_${port}.log
pidfile ${redis_setup_dir}redis_${port}.pid
port ${port}
bind ${IP}
timeout 0
tcp-keepalive 0
loglevel notice
databases 16
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
#dbfilename dump_6379.rdb
dir ${redis_data_dir}
#maxmemory      2000000000
#slave-serve-stale-data yes
#slave-read-only yes
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
EOF


#${redis_setup_dir}redis-server ${redis_config_file}
#cat ${redis_setup_dir}redis_${port}.log

#将redis注册成服务
cp /usr/local/setup/soft/conf/redis_init_script /etc/init.d/redis
chmod 755 /etc/init.d/redis
chkconfig --add redis
chkconfig redis on
service redis start 


echo "##########################################################################"
echo "#              \☺/ redis安装并启动完成，端口号为${port}                    #"
echo "##########################################################################"
