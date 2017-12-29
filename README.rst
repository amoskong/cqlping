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

    $ cqlping --cqluser=cassandra --cqlpwd=cassandra -s 100 -c 2 -i 2 scylla-server
    CQLPing scylla-server (127.0.0.1), preparing...
    116 bytes scylla-server (127.0.0.1) seq=1 ttl=64 time=0.187 ms
    116 bytes scylla-server (127.0.0.1) seq=2 ttl=64 time=0.181 ms

