read -p "Insert the volume name: " volume
n=1;
echo ""
echo "Benchmarking disk $volume"
echo "------------- Buffered disk read spead test -------------"
while [ $n -lt 11 ]; do
    echo 3 | sudo tee /proc/sys/vm/drop_caches
    echo "Test $n"
    sudo hdparm -t /dev/$volume
    n=$((n+1))
    sleep 1
done
n=0;
echo ""
echo "------------- Cached read speed test -------------"
while [ $n -lt 11 ]; do
    echo "Test $n"
    sudo hdparm -T /dev/$volume
    n=$((n+1))
    sleep 1
done
n=0;
echo "Benchmarking finished"