c:\laragon\bin\redis\redis-x64-5.0.14.1

docker run -d --rm --name redis-stack -p 6379:6379 -p 8001:8001 -v ${PWD}\app:/app -v ${PWD}\local-data\:/data -v ${PWD}\redis.conf:/redis-stack.conf -e REDIS_ARGS="--save 60 1000 --appendonly yes" redis/redis-stack:latest

docker container stop redis-stack

docker exec -it redis-stack bash
redis-cli
docker exec -it redis-stack redis-cli

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

<!-- get-range -->

set dwi "muhammad dwi susanto"
setrange dwi 4 "ahmad"
get dwi //muhaahmaddwi susanto
getrange dwi 0 3 //muha

<!-- mget mset | multiple data string -->

mset budi "100" dwi "300" ruly "200"
mget dwi budi ruly

<!-- expiration -->

expire dwi 5 //detik
ttl dwi
get dwi
setex dwi 10 "muhammad dwi susanto"

<!-- increment dan decrement -->

incr counter
decr counter
incrby counter 5
decrby counter 2

<!-- flush | mengosongkan data di db -->

flushdb
flushall

<!-- pipeline -->

docker exec -it redis-stack redis-cli -h host -p port -n database --pipe < input-file
docker exec -it redis-stack redis-cli -h 127.0.0.1 -p 6379 -n 0 --pipe < /app/input-file.txt
cat ${PWD}/app/input-file.txt | docker exec -i redis-stack redis-cli -h 127.0.0.1 -p 6379 -n 0 --pipe

<!-- transaction / multi -->

multi
set apple "Apple"
get apple
set samsung "samsung"
set xiaomi "xiaomi"
exec //eksekusi
discard //batalkan

<!-- monitor -->
monitor