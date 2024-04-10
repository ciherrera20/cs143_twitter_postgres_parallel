#!/bin/sh

python3 -u load_tweets_batch.py --db postgresql://postgres:pass@localhost:13423/postgres --inputs "$1"
