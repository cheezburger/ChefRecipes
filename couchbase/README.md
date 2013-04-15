Description
===========
Cookbook to install and configure couchbase

License
=======
New BSD License

Requirements
============
Chef 11.0+

Platform
========
* Ubuntu 12.04

Attributes
==========
See attributes/default.rb for default values.
* node['couchbase']['url'] - Full url to download couchbase install package
* node['couchbase']['install_file'] - Filename of install package

Usage
=====
Use default recipe to install and start couchbase. Further configuration will be ready at http://<hostname>:8091
