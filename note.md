c:\laragon\bin\redis\redis-x64-5.0.14.1

docker run -d --rm --name redis-stack -p 6379:6379 -p 8001:8001 -v ${PWD}\local-data\:/data -v ${PWD}\redis.conf:/redis-stack.conf -e REDIS_ARGS="--save 60 1000 --appendonly yes" redis/redis-stack:latest

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

