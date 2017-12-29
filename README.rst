CQLPing
=======

About:
------

Simple CQL I/O latency monitoring tool

Help:
----
.. code:: sh

    $ cqlping --help
    usage: cqlping [-h] [-c C] [-i I] [--cqlport CQLPORT] [--cqluser CQLUSER]
                   [--cqlpwd CQLPWD] [-t T] [-s S]
                   destination

    CQLPing

    positional arguments:
      destination        CqlPing packet destination

    optional arguments:
      -h, --help         show this help message and exit
      -c C               Stop after sending count ECHO_REQUEST packets
      -i I               Wait interval seconds between each sending packet
      --cqlport CQLPORT  CQL port
      --cqluser CQLUSER  CQL username
      --cqlpwd CQLPWD    CQL password
      -t T               Time to live
      -s S               Packet size

Example:
-------
.. code:: sh

    $ cqlping scylla-server --cqluser=cassandra --cqlpwd=cassandra
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

