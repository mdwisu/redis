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

watch apple //WATCH digunakan untuk memastikan bahwa kunci yang diawasi tidak berubah selama proses transaksi.
multi
get apple
exec

<!-- Jika kunci apple diubah oleh klien lain setelah WATCH saldo, maka EXEC akan gagal. -->

unwatch

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
client kill <ip:port>
client setname dwi
client getname

<!--! security -->
<!-- tambahkan di redis.conf -->
<!-- dengan user -->

```bash
user default on +@connection
user dwi on +@all ~\* >rahasia
auth dwi rahasia
```

<!-- dengan args -->

--requirepass redis-stack //hanya password saja yang di isi

<!-- terminal -->

config set requirepass redis-stack

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

<!-- lists -->

lpush country India
lpush country Indonesia
lpush country UK
lrange country 0 -1
lrange country 0 0
rpush country Australia
llen country
lpop country
rpop country
lset country 0 indonibos
linsert country before India Australia
linsert country after Australia USA

<!-- lpushx, rpushx -->
<!-- Jika daftar yang dituju tidak ada, LPUSHX tidak akan melakukan apa-apa dan tidak akan membuat daftar baru. -->

lpushx movies Avengers
lpushx country "south africa"
rpushx movies Avengers

<!-- sort -->

sort country ALPHA
sort country desc ALPHA

<!-- blpop -->
<!-- menunggu 15 detik jika datanya tidak ada -->

blpop movies 15
blpop country 15

<!-- !set --> //gabakal duplicate
<!-- add key and value -->

sadd technology java
sadd technology redis nodejs aws
sadd frontend inifrontend

<!-- melihat datanya -->

smembers technology
smembers frontend

<!-- menghitung lengthnya -->

scard technology

<!-- melihat apakah java ada di dalamnya -->

sismember technology java
sismember technology spring

<!-- perbedaan misal mengecek teknologi, jika datanya ada di frontend maka tidak di tampilkan  -->
<!-- technology: java sprint frontend: java | output: spring -->

sdiff technology frontend
sdiff frontend technology

<!-- menyimpan different ke newset -->

sdiffstore newset technology frontend

<!-- sinter | kebalikan different -->

sinter technology frontend
sinter technology frontend newset

<!-- menyimpan internya -->

sinterstore newinter technology frontend

<!-- sunion | semua datanya -->

sunion technology frontend newset newinter

<!-- store -->

sunionstore newunion technology frontend newset newinter

<!-- ! redis sorted sets -->

zadd users 1 Dwi //add
zadd users 2 Muhammad 3 Susanto 4 Alex 5 Suca
zrange users 0 -1
zrange users 0 -1 withscores //melihat data dengan no scorenya
zrevrange users 0 -1 withscores //reverse
zrevrangebyscore users 4 0 withscores
zcard users // hitung banyak set
zcount users -inf +inf
zcount users 0 4
zrem users Alex //remove
zscore users Suca //ada di no berapa (5)
zincrby users 2 Dwi //menambah nilai scorenya
zincrby users -2 Dwi
zremrangebyscore users 3 6 // remove by range
zremrangebyrank users 1 2

<!--! hyperLogLog -->

pfadd hll a
pfadd hll b c d e f g
pfcount hll
pfadd hll2 1 2 3 4 5 6 7
pfcount hll2
pfcount hll1 hll2
pfmerge mergedhll hll hll2
pfcount mergedhll

<!-- !hashes -->

hset myhash name Dwi //set
hset myhash email dwisusanto784@gmail.com
hkeys myhash // keys
hvals myhash // value
hexists myhash name //existing
hlen myhash // length
hset myhash age 23 //set hash
hmset myhash country India Phone 08101010 //multiple
hmget myhash name email Phone // get value
hincrby myhash age 2 //increment
hincrbyfloat myhash age 1.5
hdel myhash age //delete
hstrlen myhash name // panjang value
hsetnx myhash name susanto // set jika name tidak ada, jika ada tidak di set

<!-- !pubsub -->
<!-- terminal1 -->

subscribe news

<!-- terminal2 -->

subscribe news

<!-- terminal3 -->

publish news "New Breaking News"
publish news "New News"

<!-- terminal2 -->

subscribe news broadcast

<!-- ternimal3 -->

publish broadcast "ini broadcast"

<!-- ?psubscribe -->
<!-- terminal1 -->

psubscribe news\* h?llo b[ai]ll

<!-- terminal3 -->

publish news_afd hello
publish hxllo hxloo
publish ball hallo
publish bill hallo

pubsub channels
pubsub numpat //mendapatkan jumlah pola aktif yang saat ini sedang digunakan dalam fitur publish/subscribe (pub/sub) Redis.

<!-- !redis scripts -->
<!-- set name dwi -->

eval "redis.call('set', KEYS[1], ARGV[1])" 1 name Dwi
get name
mset name Susanto last_name Muhammad
eval "redis.call('mset', KEYS[1], ARGV[1], KEYS[2], ARGV[2])" 2 name last_name Susanto Muhammad
get name
get last_name

hmset country_cap indonesia jakarta italy rome japan tokyo russia moscow usa "washington d c" india "new delhi"
zadd country 1 usa 2 italy 3 india
eval "local order = redis.call('zrange', KEYS[1], 0, -1); return redis.call('hmget', KEYS[2], unpack(order));" 2 country country_cap

script load "local order = redis.call('zrange', KEYS[1], 0, -1); return redis.call('hmget', KEYS[2], unpack(order));"
evalsha 1807412636f2f95da7f3cdf6cb3bb0249e2587c7 2 country country_cap

script exists 1807412636f2f95da7f3cdf6cb3bb0249e2587c7
script flush

<!-- redis geospatial -->

```
Perbedaan Format:
Google Maps: indonesia
Latitude, Longitude → -0.24747319093377876, 113.30968039831485
Redis GEOADD: indonesia
Longitude, Latitude → 113.30968039831485 -0.24747319093377876
```

GEOADD maps 72.859493 24.85925 dwi
GEOADD maps 72.859493 24.85925 susanto
GEOADD maps 26.653738 16.839917 ahmad
GEOADD maps 23.002039692866255 78.68513508563122 india
GEOADD maps -18.69131883830992 29.08342413786517 zimbabwe
GEOADD maps -0.24747319093377876 113.30968039831485 indonesia
zrange maps 0 -1
GEOHASH maps dwi
http://geohash.org/
GEOPOS maps dwi
GEODIST maps dwi ahmad //jarak antara 2
GEODIST maps dwi ahmad km
GEODIST maps dwi ahmad mi
GEODIST maps dwi ahmad m
GEORADIUS maps 26.653738 16.839917 10 km //menemukan orang dalam jarak 10km
GEORADIUS maps 26.653738 16.839917 1000000 mi
GEORADIUS maps 26.653738 16.839917 1000000 mi withcoord
GEORADIUSBYMEMBER maps zimbabwe 5000 km
GEORADIUSBYMEMBER maps zimbabwe 5000 km desc | asc

<!-- redis benchmark -->
docker exec -it redis-stack redis-cli -h 127.0.0.1 -p 6379
<!-- -n  jumlah total permintaan yang akan dikirim ke server Redis -->
docker exec -it redis-stack redis-benchmark -n 1000
<!-- -a auth -->
docker exec -it redis-stack redis-benchmark -n 1000 -a redis-stack
<!-- -d Menentukan ukuran data yang akan dikirim dalam setiap permintaan (dalam byte).
100000 byte (sekitar 100 KB) untuk setiap data yang diuji. -->
docker exec -it redis-stack redis-benchmark -n 1000 -d 100000 -a redis-stack
<!-- -c Menentukan jumlah koneksi klien (clients) yang akan digunakan secara bersamaan (concurrent connections). -->
docker exec -it redis-stack redis-benchmark -n 1000 -d 100000 -c 200 -a redis-stack

