Twincat -- set up two tomcats
===============

Sometimes, you need to run more that one tomcat J2EE server.
This script will quickly get you up and running with two tomcats.
Need more than two?  Just add more names in the for loop in
[`grabcat.sh`](https://github.com/tingletech/twincat/blob/master/grabcat.sh#L32)
file.

`./grabcat.sh` will grab tomcat, and then set up two `CATALINA_BASE`
directories.  The binary distribution of tomcat is shared between the
two configurations.  Only run this once.

Once it has run, your directory structure will look like this:
```
.
├── apache-tomcat-7.0.29
├── apache-tomcat-7.0.29.tar.gz
├── appBack
├── appFront
├── CATALINA_BASE
├── grabcat.sh
├── README.md
├── tomcat -> apache-tomcat-7.0.29
└── wrapper.sh
```

To start the servers:

`./wrapper.sh appFront ./tomcat/bin/startup.sh` will start up the front end apache tomcat.
`./wrapper.sh appBack ./tomcat/bin/startup.sh` will start up the back end apache tomcat.

`appFront/webapps` and `appBack/webapps` are where you can put the `.war` files.

TODO: add `monit` config and include a `chkconfig` compatabile init script.


Project
------
Based on tomcat setup for SNAC in [eac-graph-load](https://code.google.com/p/eac-graph-load/source/browse/servers/) on google code.

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
