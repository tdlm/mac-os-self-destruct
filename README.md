# os-x-self-destruct
==================

Self Destruct v0.9 for Mac OS X

Securely destroys files or directories on a delay based on their OS X "Tag."

Available Tags: 1 Minute, 1 Hour, 1 Day, 1 Week, 1 Month, 1 Year

For example, if a file is tagged with "1 Week" then it will be deleted at the time exactly one week from the last time the file was modified.

#### WARNING: If you tag a file that was modified in the past, the time-to-delete will be in the past and it may be deleted on the next run of Self Destruct.

### RUNNING

```bash
chmod +x self-destruct.sh
./self-destruct.sh --run
```

### HELP

```bash
./self-destruct.sh --help
```

#### INSTALLATION

To install Self Destruct, copy this file to a permanent location and put the following entry in your crontab (making sure to point to the path you place the file in):

```bash
* * * * * /path/to/self-destruct.sh --run
```

This will run Self Destruct every minute.



Copyright &copy; [Scott Weaver](http://scottmw.com/)