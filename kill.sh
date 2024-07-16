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
