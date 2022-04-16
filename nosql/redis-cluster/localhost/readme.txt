
redis-cli -p 6880 -c cluster meet 127.0.0.1 6881
redis-cli -p 6880 -c cluster meet 127.0.0.1 6882
redis-cli -p 6880 -c cluster meet 127.0.0.1 6883
redis-cli -p 6880 -c cluster meet 127.0.0.1 6884
redis-cli -p 6880 -c cluster meet 127.0.0.1 6885
redis-cli -p 6880 -c cluster nodes

redis-cli -p 6880 -c cluster addslots {0..5461}
redis-cli -p 6881 -c cluster addslots {5462..10922}
redis-cli -p 6882 -c cluster addslots {10923..16383}
redis-cli -p 6880 -c cluster nodes
redis-cli -p 6880 -c cluster info

redis-cli -p 6880 -c cluster slots
redis-cli -p 6883 -c cluster replicate 26f183e3ba3b34f350c4c2647d3cd90a47976189
redis-cli -p 6884 -c cluster replicate ffa9cf32b03f6418455449c6c7aaa76767560ecc
redis-cli -p 6885 -c cluster replicate 0eec4adc7c6435b238b0e5c4123003eccc009a1f
redis-cli -p 6880 -c cluster nodes

redis-cli --cluster reshard 127.0.0.1:6880

redis-cli --cluster create 127.0.0.1:6880 127.0.0.1:6881 127.0.0.1:6882 127.0.0.1:6883 127.0.0.1:6884 127.0.0.1:6885 --cluster-replicas 1
redis-cli --cluster add-node 127.0.0.1:6886 127.0.0.1:6880
redis-cli --cluster del-node 127.0.0.1:6880 546764a682ec330f4a432c66825cc7c9436762a0
redis-cli --cluster check 127.0.0.1:6880
redis-cli --cluster info 127.0.0.1:6880

redis-cli -p 6880 -c cluster nodes
redis-cli -p 6881 -c debug segfault
redis-server ./redis-6881.conf

redis-benchmark -h 127.0.0.1 -p 6880 -c 100 -n 100000

wget https://download.redis.io/releases/redis-stable.tar.gz #v6.0.5
wget https://download.redis.io/releases/redis-6.2.6.tar.gz
tar -zxvf redis-stable.tar.gz
tar -zxvf redis-6.2.6.tar.gz
cd redis-stable/
cd redis-6.2.6/
make MALLOC=libc
make test
taskset -c 1 make test
make
make install
mkdir bin
mv src/redis-server bin/
mv src/redis-benchmark bin/
mv src/redis-cli bin/
mv src/redis-check-aof bin/
mv src/redis-check-rdb bin/
mv src/redis-sentinel bin/
