#/bin/bash
#===============================================
# file_name：Nginx
# User：NTE
# Web：nte21223.top
# create_time：2023/8/23
# FileDir: /shell/
#===============================================

# 压缩包路径
in_tar=/root/

# 解压到路径
out_tar=/opt/

# 函数用于检查软件包是否已安装，如果未安装，则进行安装
yum_install() {
  for package in "$@"; do
    if ! rpm -q "$package" &>/dev/null; then
      yum -y install "$package"
    fi
  done
}

# 下载Nginx压缩包
in_ysb() {
  #下载Nginx
  if ! find "$in_tar" -maxdepth 1 -type f -name '*nginx*' | grep -q '.'; then
    wget --no-cache -nc -P "$in_tar" https://nginx.org/download/nginx-1.24.0.tar.gz
  else
    echo "=======已经存在nginx同名文件======"
  fi
}

# 解压Nginx压缩包
out_ysb() {
  for tar_name in "$@"; do
    if [ -d "${out_tar}${tar_name}" ]; then
      echo "${tar_name}目录存在"
    else
      echo '~~~~~~~~~~ Tar_jdk ~~~~~~~~~~'
      tar -zxvf ${in_tar}*${tar_name}* -C /opt/ && mv ${out_tar}*${tar_name}* ${out_tar}${tar_name}
    fi
  done
}

echo "<<<<<<<<<<<<<<<<----（）安装依赖---->>>>>>>>>>>>>>>>"
# 需要安装的软件包列表
package_list=("gcc-c++" "zlib-devel" "zlib" "pcre" "pcre-devel" "openssl" "openssl-devel")
# 调用 yum_install 函数安装软件包
yum_install ${package_list[@]}

echo '<<<<<<<<<<<<<<<<----（）下载压缩包---->>>>>>>>>>>>>>>>'
in_ysb

echo '<<<<<<<<<<<<<<<<----（）解压压缩包---->>>>>>>>>>>>>>>>'
# 需要解压的压缩包列表
ysb_list=("nginx")
# 解压压缩包，并更改其解压后的目录名
out_ysb ${ysb_list[@]}

#进入到解压后的nginx目录下
cd /opt/nginx/

#在解压的文件目录下,进行编译
./configure --prefix=/usr/local/nginx --with-stream --with-http_ssl_module --with-stream_ssl_preread_module --with-stream_ssl_module

make && make install

# 进行软连接
cp -rf /usr/local/nginx/sbin/nginx /usr/bin/

#先查看nginx位置
find / -name nginx.conf

#先删除最后一行的}
sed -i '$d' /usr/local/nginx/conf/nginx.conf

#修改文件
echo 'server {
    listen       8080 default_server;
    listen       [::]:8080 default_server;
    server_name  localhost;
		location / {
		    root /datadir;  #指定哪个目录作为Http文件服务器的根目录
		    autoindex on;   #设置允许列出整个目录
		    autoindex_exact_size off; #默认为on，显示出文件的确切大小，单位是bytes。改为off后，显示出文件的大概大小，单位是kB或者MB或者GB
		    autoindex_localtime on; #默认为off，显示的文件时间为GMT时间。改为on后，显示的文件时间为文件的服务器时间
		    charset utf-8; #防止文件乱码显示, 如果用utf-8还是乱码，就改成gbk试试
		}
}
}' >>/usr/local/nginx/conf/nginx.conf

#创建仓库目录
if [ -d "/datadir" ]; then
  echo "datadir目录存在"
else
  mkdir /datadir
fi

# 启动nginx服务
# /usr/local/nginx/sbin/nginx
nginx

#这是由于SELinux设置为开启状态（enabled）的原因，继续进行SELinux修改，禁用SELinux
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config && setenforce 0

#查看nginx进程
ps -ef | grep nginx

#=================================开放端口=======================================
ip=$(hostname -I | cut -d ' ' -f 1)
# 检查端口是否已经开放
check_port_open() {
  local port=$1
  local output=$(firewall-cmd --list-ports)
  if echo "$output" | grep -q "\<$port\/tcp\>"; then
    return 0 # 端口已经开放
  else
    return 1 # 端口未开放
  fi
}

# 要开放的端口列表
port_list=("8080")

# 循环遍历端口列表
for port in "${port_list[@]}"; do
  if check_port_open "$port"; then
    echo "端口 $port 已经开放，无需进行操作"
  else
    echo "开放端口 $port"
    firewall-cmd --zone=public --add-port="$port/tcp" --permanent
  fi
done

# 检查是否需要重新加载防火墙配置
if ! check_port_open "${port_list[0]}" || ! check_port_open "${port_list[1]}"; then
  firewall-cmd --reload
fi
#======================================================================
echo "仓库目录(/datadir),网址(http://$ip:8080)"
echo "使用直接拉取文件到/datadir即可"
cd - && rm -rf "$0" #del dis
