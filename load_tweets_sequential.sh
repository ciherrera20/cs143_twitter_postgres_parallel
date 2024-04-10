#!/bin/bash

files=$(find data/*)
pg_denormalized_port=13421
pg_normalized_port=13422
pg_normalized_batch_port=13423
pg_denormalized_url="postgresql://postgres:pass@localhost:$pg_denormalized_port/postgres"
pg_normalized_url="postgresql://postgres:pass@localhost:$pg_normalized_port/postgres"
pg_normalized_batch_url="postgresql://postgres:pass@localhost:$pg_normalized_batch_port/postgres"

echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time for file in $files; do
    ./load_tweets.py --db $pg_normalized_url --inputs $file
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time for file in $files; do
    unzip -p $file | sed 's/\\u0000//g' | psql $pg_denormalized_url -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time for file in $files; do
    python3 -u load_tweets_batch.py --db=$pg_normalized_batch_url --inputs $file
done
