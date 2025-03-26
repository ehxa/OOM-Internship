read -p "Insert the volume name: " volume
n=0;
echo "Benchmarking disk $volume"
echo "------------- Buffered disk read spead test -------------"
while [ $n -lt 10 ]; do
    hdparm -t /dev/$volume
    n=$((n+1))
    sleep 1
done
n=0;
echo "------------- Cached read speed test -------------"
while [ $n -lt 10 ]; do
    hdparm -T /dev/$volume
    n=$((n+1))
    sleep 1
done
n=0;
echo "Benchmarking finished"