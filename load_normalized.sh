#!/bin/sh

./load_tweets.py --db postgresql://postgres:pass@localhost:13422/postgres --inputs "$1"
