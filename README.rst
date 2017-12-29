CQLPing
=======

About:
------

Simple CQL I/O latency monitoring tool

https://github.com/amoskong/cqlping

Help:
----

cqlping --help

.. code:: sh

    usage: cqlping [-h] [--debug] [-c C] [-i I] [--cqlport CQLPORT]
                   [--cqluser CQLUSER] [--cqlpwd CQLPWD]
                   [--request-query REQUEST_QUERY] [--reply-query REPLY_QUERY]
                   [-t T] [-s S]
                   destination

    CQLPing - Simple CQL I/O latency monitoring tool

    positional arguments:
      destination           CqlPing packet destination

    optional arguments:
      -h, --help            show this help message and exit
      --debug               Enable debug mode (only for developer)
      -c C                  Stop after sending count ECHO_REQUEST packets
      -i I                  Wait interval seconds between each sending packet
      --cqlport CQLPORT     CQL port
      --cqluser CQLUSER     CQL username
      --cqlpwd CQLPWD       CQL password
      --request-query REQUEST_QUERY
                            Request query for using existing schema
      --reply-query REPLY_QUERY
                            Reply query for using exiting schema
      -t T                  Time to live
      -s S                  (Optional) Size of random packet

Default Schema:
--------------

CQLPing creates a keyspace `cqlping` and table `cf` (key1 bigint, key2 bigint,
val blob, PRIMARY KEY(key1, key2)). It convert current time to two integers,
and use them as primary key. So each ping will increase a new row.

The blob val will be assigned a random string, the size is decided by `-s`
argument (default: 60). Plus the two bigint, so the default reply packet size
is 64 bytes.

Use existing schema:
-------------------

We must assign `request-query` and `reply-query` arguments for using existing
schema.

Current code always update one row with hardcode primary key in query arguments,
the other columns can also be hardcode, then the packet size is fixed, and we can't
use `-s` at the same time.

If you want to use a random string for each insert request, you can use '%s',
cqlping will generate a fixed-size random string, and append to request-query
statement.

.. code:: sh

    If you assign packet size by `-s` and `request-query` argument that
    contains a '%s', cqlping will generate a fixed-size random string and
    append to request-query cmd. It means table must contains a `blob`,
    `text` or `varchar` column.

    Blob: -s 20 --request-query "INSERT INTO cqlping.cf (key1, val) VALUES (1, textAsBlob('%s'))"
    Text: -s 20 --request-query "INSERT INTO cqlping.cf (key1, val) VALUES (1, '%s')"
    Varchar: -s 20 --request-query "INSERT INTO cqlping.cf (key1, val) VALUES (1, '%s')"

.. code:: sh

    If `-s` isn't assigned, it will directly execute assigned request-query,
    the packet size is depends on the query content.

    Blob: --request-query "INSERT INTO cqlping.cf (key1, val) VALUES (1, textAsBlob('hello'))"
    Text: --request-query "INSERT INTO cqlping.cf (key1, val) VALUES (1, 'hello')"
    Varchar: --request-query "INSERT INTO cqlping.cf (key1, val) VALUES (1, 'hello')"
    More: --request-query "INSERT INTO cqlping.cf (key1, key2, val, val2) VALUES (1, 'k2', 'hello', 'val2-val2-val2')"

Example:
-------
Found more examples in example.txt & test.sh

.. code:: sh

    $ cqlping scylla-server
    CQLPing scylla-server (127.0.0.1), preparing...
    64 bytes scylla-server (127.0.0.1) seq=1 ttl=64 time=0.284 ms
    64 bytes scylla-server (127.0.0.1) seq=2 ttl=64 time=0.204 ms
    64 bytes scylla-server (127.0.0.1) seq=3 ttl=64 time=0.203 ms
    64 bytes scylla-server (127.0.0.1) seq=4 ttl=64 time=0.197 ms

    $ time cqlping --cqluser=cassandra --cqlpwd=cassandra -s 100 -c 5 -i 0.1 scylla-server
    CQLPing scylla-server (127.0.0.1), preparing...
    116 bytes scylla-server (127.0.0.1) seq=1 ttl=64 time=0.189 ms
    116 bytes scylla-server (127.0.0.1) seq=2 ttl=64 time=0.186 ms
    116 bytes scylla-server (127.0.0.1) seq=3 ttl=64 time=0.188 ms
    116 bytes scylla-server (127.0.0.1) seq=4 ttl=64 time=0.187 ms
    116 bytes scylla-server (127.0.0.1) seq=5 ttl=64 time=0.189 ms

    real	0m2.860s
    user	0m0.257s
    sys	0m0.105s

    $ cqlping --cqluser=cassandra --cqlpwd=cassandra -s 100 -c 1 -i 0.1 scylla-server --debug
    cqlping INFO: CQLPing scylla-server (127.0.0.1), preparing...
    cqlping DEBUG: INSERT INTO cqlping.cf (key1, key2, val) VALUES (1588084343092317, 1048576, textAsBlob('Q1FQR0CG9NUBDEN3HPEMXMP4DI03NYB7Z83FM7MJBFL74Y3ZDNCIB2M55J5BGZR4TKEP3393H0GS958P8Y0OQ60WW53DNUO6LQZ1'))
    cqlping DEBUG: select * from cqlping.cf where key1 = 1588084343092317 and key2 = 1048576
    cqlping DEBUG: [Row(key1=1588084343092317, key2=1048576, val='Q1FQR0CG9NUBDEN3HPEMXMP4DI03NYB7Z83FM7MJBFL74Y3ZDNCIB2M55J5BGZR4TKEP3393H0GS958P8Y0OQ60WW53DNUO6LQZ1')]
    cqlping INFO: 116 bytes scylla-server (127.0.0.1) seq=1 ttl=64 time=0.180 ms

    $ cqlping --cqluser=cassandra --cqlpwd=cassandra -s 8 -c 1 -i 0.1 scylla-server --request-query "INSERT INTO keyspace1.standard1 (key,\"C0\") VALUES (textAsBlob('1'), textAsBlob('%s'))" --reply-query "select * from keyspace1.standard1 where key=textAsBlob('1')" --debug
    cqlping INFO: CQLPing scylla-server (127.0.0.1), preparing...
    cqlping DEBUG: INSERT INTO keyspace1.standard1 (key,"C0") VALUES (textAsBlob('1'), textAsBlob('CW6PZMH7'))
    cqlping DEBUG: select * from keyspace1.standard1 where key=textAsBlob('1')
    cqlping DEBUG: reply data length: 6
    cqlping DEBUG: [Row(key='1', C0='CW6PZMH7', C1=None, C2=None, C3=None, C4=None)]
    cqlping INFO: 24 bytes scylla-server (127.0.0.1) seq=1 ttl=64 time=0.207 ms

