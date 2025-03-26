read -p "Insert the volume name: " volume
n=0;
echo ""
echo "Benchmarking disk $volume"
echo "------------- Buffered disk read spead test -------------"
while [ $n -lt 10 ]; do
    echo 3 | sudo tee /proc/sys/vm/drop_caches
    sudo hdparm -t /dev/$volume
    n=$((n+1))
    sleep 1
done
n=0;
echo ""
echo "------------- Cached read speed test -------------"
while [ $n -lt 10 ]; do
    sudo hdparm -T /dev/$volume
    n=$((n+1))
    sleep 1
done
n=0;
echo "Benchmarking finished"