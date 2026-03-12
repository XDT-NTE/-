#!/bin/bash

echo "==========================================================="

now=$(date +"%Y-%m-%d %H:%M:%S")
rq=$(date +"%Y-%m-%d")
echo "开始开启时间：$now"

PORT1=5000
LOG_FILE="/shell/wp_$rq.log"

# 检查端口是否被占用
check_port() {
  local port=$1
  local process_id=$(/usr/sbin/lsof -t -i:$port)

  if [[ -n $process_id ]]; then
    echo "端口 $port 已被进程 $process_id 占用。"
    echo "终止该进程..."
    kill -9 $process_id
    sleep 1
  fi
}

# 启动服务器
start_server() {
  local log_file=$1
  echo "正在启动端口 $PORT 的服务器..."
  nohup python3 /mnt/flaskProject/app.py >> "$log_file" 2>&1 &
  echo "服务器已启动。"
}
# 检查端口是否被占用
check_port $PORT1

#重启nginx
nginx

# 启动服务器
start_server $LOG_FILE
