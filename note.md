c:\laragon\bin\redis\redis-x64-5.0.14.1

docker run -d --rm --name redis-stack -p 6379:6379 -p 8001:8001 -v ${PWD}\app:/app -v ${PWD}\local-data\:/data -v ${PWD}\redis.conf:/redis-stack.conf -e REDIS_ARGS="--save 3600 1 300 100 60 10000 --appendonly yes --requirepass redis-stack --maxmemory 100mb --maxmemory-policy allkeys-lru" redis/redis-stack:latest

<!-- --save 3600 1 300 100 60 10000 | penyimpanan dengan rdb 1jam 1data 5menit 60data 60detik 10000 -->
<!-- --appendonly yes | penyimpanan dengan AOF -->

<!-- jika membuat confignya di redis.conf otomatis REDIS_ARGSnya tertimpa, tetapi jika di filenya tidak di set, otomatis menggunakan yang di REDIS_ARGS -->

docker container stop redis-stack

docker exec -it redis-stack bash
redis-cli
docker exec -it redis-stack redis-cli

ctrl + shift + v //untuk paste

ping
select 0
docker exec -it redis-stack redis-cli
set test "muhammad dwi susanto"
get test
exists test
exists tidakada
append test "ganteng"
keys _
keys te_
keys \*
del test

<!--! get-range -->

set dwi "muhammad dwi susanto"
setrange dwi 4 "ahmad"
get dwi //muhaahmaddwi susanto
getrange dwi 0 3 //muha

<!-- length -->
strlen dwi

<!--! mget mset | multiple data string -->

mset budi "100" dwi "300" ruly "200"
mget dwi budi ruly

<!--! expiration -->

expire dwi 5 //detik
ttl dwi
get dwi
setex dwi 10 "muhammad dwi susanto"

<!-- !increment dan decrement -->

incr counter
decr counter
incrby counter 5
decrby counter 2
set pi 3.14
incrbyfloat pi 0.0001

<!--! flush | mengosongkan data di db -->

flushdb
flushall

<!--! pipeline -->

docker exec -it redis-stack redis-cli -h host -p port -n database --pipe < input-file
docker exec -it redis-stack redis-cli -h 127.0.0.1 -p 6379 -n 0 --pipe < /app/input-file.txt
cat ${PWD}/app/input-file.txt | docker exec -i redis-stack redis-cli -h 127.0.0.1 -p 6379 -n 0 --pipe

<!-- !transaction / multi -->

multi
set apple "Apple"
get apple
set samsung "samsung"
set xiaomi "xiaomi"
exec //eksekusi
discard //batalkan

<!-- !monitor -->

monitor

<!--! server information -->

info
config get databases
config get save
config get bind
config get port

<!--! client connection -->

client list
client id
client kill ip:port

<!--! security -->
<!-- tambahkan di redis.conf -->

<!-- dengan args -->

--requirepass redis-stack //hanya password saja yang di isi

<!-- dengan user -->

user default on +@connection
user dwi on +@all ~\* >rahasia
auth dwi rahasia

<!-- !persistence -->
<!-- RDB dan AOF -->
<!-- --save dan --appendonly -->

<!--! eviction -->

--maxmemory-policy allkeys-lru

<!-- noeviction: Keys are not evicted but the server will return an error when you try to execute commands that cache new data. If your database uses replication then this condition only applies to the primary database. Note that commands that only read existing data still work as normal.
allkeys-lru: Evict the least recently used (LRU) keys.
allkeys-lfu: Evict the least frequently used (LFU) keys.
allkeys-random: Evict keys at random.
volatile-lru: Evict the least recently used keys that have the expire field set to true.
volatile-lfu: Evict the least frequently used keys that have the expire field set to true.
volatile-random: Evict keys at random only if they have the expire field set to true.
volatile-ttl: Evict keys with the expire field set to true that have the shortest remaining time-to-live (TTL) value. -->
