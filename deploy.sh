#!/bin/bash

# 1. 3000번 포트를 사용하는 프로세스 종료
PORT=3000
PIDS=$(sudo netstat -tulnp | grep :$PORT | awk '{print $7}' | cut -d/ -f1)

if [ -n "$PIDS" ]; then
    echo "Port $PORT is currently being used by processes: $PIDS. Terminating the processes..."
    for PID in $PIDS; do
        echo "Terminating process $PID..."
        sudo kill -9 $PID
        if [ $? -eq 0 ]; then
            echo "Process $PID terminated."
        else
            echo "Failed to terminate process $PID."
            exit 1
        fi
    done
else
    echo "Port $PORT is not in use."
fi

# 2. Git Pull
echo "Pulling latest changes from git repository..."
git pull

if [ $? -ne 0 ]; then
    echo "Git pull failed. Exiting..."
    exit 1
fi

# 3. 프로젝트 빌드
echo "Running pnpm run build..."
pnpm run build

if [ $? -ne 0 ]; then
    echo "Build failed. Exiting..."
    exit 1
fi

# 4. 서버 실행
echo "Starting the server with pnpm run serve..."
nohup pnpm run serve &

echo "Server started on port $PORT."