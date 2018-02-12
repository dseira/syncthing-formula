AVAILABLE STATES
===

* [init](#init)
* [install](#install)
* [config](#config)
* [service](#service)

|OS|Compatibility|
|:----:|:--------------:|
|Ubuntu 14|Yes|
|Ubuntu 16|Yes|
|CentOS 6|Yes|
|CentOS 7|Yes|

<br/>

``init``
--------
Meta state.

``install``
-----------
Install syncthing into a selected folder.

``config``
----------
Configure syncthing using either templating-style or ftp-style.

SYNCTHING SERVICE
===
Keep in mind that this formula doesn't configure syncthing as a service. This should be done using supervisor using the following example of a program:

```
[program:syncthing]
autorestart=true
group=syncthing
redirect_stderr=true
startsecs=5
stdout_logfile_maxbytes=50MB
environment=STNORESTART="1", HOME="/home/syncthing"
stdout_logfile_backups=10
command=/opt/syncthing/bin/syncthing
user=syncthing
autostart=true
directory=/home/syncthing
stdout_logfile=/var/log/supervisor/syncthing.log
```

If using the supervisor formula, this can be done with the following example:

```
supervisor:
    programs:
        syncthing:
            enabled: True
            autorestart: 'true'
            autostart: 'true'
            redirect_stderr: 'true'
            startsecs: '5'
            stdout_logfile_maxbytes: '50MB'
            stdout_logfile_backups: '10'
            command: '/opt/syncthing/bin/syncthing'
            directory: '/home/syncthing'
            environment: 'STNORESTART="1", HOME="/home/syncthing"'
            user: 'syncthing'
            group: 'syncthing'
            stdout_logfile: '/var/log/supervisor/syncthing.log'
```

SYNCTHING DEVICEID
===
Another thing to be aware of is the generation of the device ID and the certificates; both are created in the first run (working on this to self-generate those certs and device id in the same formula). A workaround is to use another instance of syncthing to generate the certificates and get the device-id:

- Generate the certificates in the `/tmp` folder:

```
/opt/syncthing/bin/syncthing -generate='/tmp/'
```

- Get the device-id from those certificates:

```
/opt/syncthing/bin/syncthing -device-id -home='/tmp'
```

Then, you can use those certificates and device id in the syncthing formula.
