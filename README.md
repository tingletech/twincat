Twincat -- set up two tomcats
===============

Sometimes, you need to run more than one tomcat J2EE server.
This script will quickly get you up and running with two or more tomcats.

`./grabcat.sh` will grab tomcat, and then set up `CATALINA_BASE`
directories for each command line argement.  The binary distribution of
tomcat is shared between the configurations.  Only run this once.

Once you have run, say,
```
./grabcat.sh appFront appBack
```

or, equivalently

```
./grabcat.sh
./clonecat.sh appFront 8080 12005
./clonecat.sh appBack 8081 12006
```

  your directory structure will look like this:
```
.
├── apache-tomcat-7.0.xx                <- current tomcat binary distribution unpacked
├── apache-tomcat-7.0.xx.tar.gz         <- tomcat download
├── appFront                            <- CATALINA_BASE #1 on 8080
├── appBack                             <- CATALINA_BASE #2 on 8081
├── CATALINA_BASE                       <- excerpt from tomcat docs that explains how this works
├── grabcat.sh                          <- only run this once
├── clonecat.sh                         <- set up a new CATALINA_BASE
├── mirrors.txt                         <- list of some apache mirrors
├── README.md                           <- you are here
├── tomcat -> apache-tomcat-7.0.xx      <- maintain this link to the current version
└── wrapper.sh                          <- sets CATALINA_BASE and then runs a command
```

To start the servers:

`./wrapper.sh appFront ./tomcat/bin/startup.sh` will start up the front end apache tomcat.
`./wrapper.sh appBack ./tomcat/bin/startup.sh` will start up the back end apache tomcat.

`appFront/webapps` and `appBack/webapps` are where you can put the `.war` files.

The servers start running on `8080`, `8081`, etc.; with shutdown ports on
`12005`, `12006`, etc.  No ajp connector is configured.

Setting the environmental variables `START_LISTEN` and `START_SHUTDOWN`
will change the starting number to the port number sequence.

TODO: add `monit` config and include a `chkconfig` compatabile init script.

Project
------
Based on tomcat setup for [SNAC](http://socialarchive.iath.virginia.edu/xtf/search) in [eac-graph-load](https://code.google.com/p/eac-graph-load/source/browse/servers/) on google code.

Picture of cats
--------

[![Saimese twins (cats) on the chair back by cookipediachef, on Flickr][2]][1]
  [1]: http://www.flickr.com/photos/cookipedia/3261818751
  [2]: http://farm4.staticflickr.com/3494/3261818751_87fcb1e281.jpg (Saimese twins cats on the chair back)
Saimese twins (cats) on the chair back by cookipediachef, on Flickr

License
-------
Copyright © 2012, Regents of the University of California
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, 
  this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, 
  this list of conditions and the following disclaimer in the documentation 
  and/or other materials provided with the distribution.
- Neither the name of the University of California nor the names of its
  contributors may be used to endorse or promote products derived from this 
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
