#!/bin/bash

echo "1. Test with default schema (self created cqlping.cf)"
./cqlping scylla-server --debug

echo "2. You should run cassandra-stress write ... to create keyspace1.standard1"

echo "3. Test with keyspace1.standard1 created by C*-stress"

echo "3.1.1 test with one random string (without verify)"
./cqlping scylla-server \
  --request-query "INSERT INTO keyspace1.standard1 (key,\"C0\") VALUES (textAsBlob('1'), textAsBlob('%s'))" \
  -c 2 -s 10 --debug

echo "3.1.2 test with one random string (with verify)"
./cqlping scylla-server \
  --request-query "INSERT INTO keyspace1.standard1 (key,\"C0\") VALUES (textAsBlob('1'), textAsBlob('%s'))" \
  --verify-query "select * from keyspace1.standard1 where key=textAsBlob('1')" \
  -c 2 -s 10 --debug

echo "3.1.3 test with multiple fixed string"
./cqlping scylla-server \
  --request-query "INSERT INTO keyspace1.standard1 (key,\"C0\",\"C1\") VALUES (textAsBlob('1'), textAsBlob('hello'),                textAsBlob('world'))" \
  -c 2 --debug

echo "3.2.1 test with text Column"
cqlsh scylla-server -e "CREATE TABLE IF NOT EXISTS cqlping.cf_txt (key1 bigint, val text, PRIMARY KEY(key1));"

./cqlping scylla-server \
  --request-query "INSERT INTO cqlping.cf_txt (key1, val) VALUES (1, '%s')" \
  --verify-query "select * from cqlping.cf_txt where key1=1" \
  -c 2 -s 2 --debug


echo "3.2.2 test with blob Column"
cqlsh scylla-server -e "CREATE TABLE IF NOT EXISTS cqlping.cf_blob (key1 bigint, val blob, PRIMARY KEY(key1));"

./cqlping scylla-server \
  --request-query "INSERT INTO cqlping.cf_blob (key1, val) VALUES (1, textAsBlob('%s'))" \
  --verify-query "select * from cqlping.cf_blob where key1=1" \
  -c 2 -s 2 --debug


echo "3.2.3 test with varchar Column"
cqlsh scylla-server -e "CREATE TABLE IF NOT EXISTS cqlping.cf_varchar (key1 bigint, val varchar, PRIMARY KEY(key1));"

./cqlping scylla-server \
  --request-query "INSERT INTO cqlping.cf_txt (key1, val) VALUES (1, '%s')" \
  --verify-query "select * from cqlping.cf_txt where key1=1" \
  -c 2 -s 2 --debug
