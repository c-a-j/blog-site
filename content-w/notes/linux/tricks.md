+++
title = "Nifty Linux Tricks"
author = ["Clint Jordan"]
description = " "
date = "2023-05-01"
lastmod = ""
tags = ["linux"]
categories = ["notes"]
draft = false
autonumber = false
printmode = false
+++

## `find`

### Compress all directories in the current directory

```shell
find . -maxdepth 1 -type d -exec zip archive.zip {} +
```

### Compress by filename

```shell
find "images/*.jpg" -type f -exec zip archive.zip {} +
```

## `grep`

### Search all files in current directory for a regex

```shell
grep -rnw . -e "Hello, world"
```

### Quick and quiet conditional statement

```shell
hostname | grep 'fdc' && echo prod || echo work
```

### Match multiple patterns
```shell
echo -e "foo\nbar\napple" | grep -E 'foo|bar'
```
or
```shell
echo -e "foo\nbar\napple" | grep 'foo\|bar'
```


## `tar`

### Compress
```shell
tar -zcvf archive.tar.gz dir1 dir2 ... file1 file2 ...
```

### Extract to specified directory
```shell
tar -zxvf archive.tar.gz -C /path/to/dir
```

### Extract to current directory
```shell
tar -zxvf archive.tar.gz
```

### List archive contents
```shell
tar -ztvf archive.tar.gz
```

## `zip`

### Compress
```shell
zip archive.zip file1 file2 ...
```

```shell
zip -r archive.zip dir1 dir2 ...
```

### Extract to specified directory
```shell
unzip archive.zip -d /path/to/dir
```

### Extract to current directory
```shell
unzip archive.zip
```

## `file`
Display file info

```shell
file archive.tar.gz
archive.tar.gz: gzip compressed data, from Unix, original size modulo 2^32 45076480
```

```shell
file archive.tar
archive.tar: POSIX tar archive
```

## scp
Transfer single file
```shell
scp source_file user@host:/path/to/destination/file
```

## rsync


## Lowercase and Uppercase variables
Uppercase
```shell
var=abc
echo ${var^^}
```

Lowercase
```shell
var=ABC
echo ${var,,}
```

## cut
Extract the first and second fields separated by a `:`.
```shell
cat $file | cut -f1-2 -d:
```

## Native bash string parsing
```shell
var="abc:123"
```

Cut the `:` and everything to the right of it.
```shell
echo ${var%:*}
```

Cut the `:` and everything to the left of it.
```shell
echo ${var#*:}
```

## Remove last element from bash array
```shell
unset array[-1]
```

## Remove first element from bash array
```shell
array=${array[@]:1}
```

## printf
Repeat `*` 80 times
```shell 
printf '*%.0s' `seq 1 80`
```

Repeat `-` 80 times
```shell 
printf -- '-%.0s' `seq 1 80`
```

## git

Commit to a repository used in a shared account
```shell
git -c user.email="clint.jordan@usda.gov" -c user.name="clint-jordan" commit
```

Push to the remote repository used in a shared account
```shell
git push
```
> Note: you must set up a personal access token and provide valid credentials.

## kill

Kill a process with signal number 15 (SIGTERM). This signal can be ignored by processes.
It notifies the process to clean things up and then end.

```shell
kill [PID]
```

Send signal 9 (SIGKILL), which cannot be ignored by the process.

```shell
kill -9 [PID]
```

## envsubst

Substitute variable references stored in a text file and output to standard out
```shell
cat test.sh
hello $test
```

```shell
test=world envsubst < test.sh
hello world
```

Exported variables can be handled differently

```shell
cat test.sh
hello $test
```

```shell
export test=world
envsubst < test.sh
hello world
```

## set up sshd on WSL
Install the OpenSSH server inside WSL
```shell
sudo apt install openssh-server
```
Configure the port on which the OpenSSH server listens to 22 and restart the
service:
```shell
sudo sed -i -E 's,^#?Port.*$,Port 22,' /etc/ssh/sshd_config
sudo service ssh restart
```
Allow your default WSL user to start the SSH server without typing a password:
```shell
sudo sh -c "echo '${USER} ALL=(root) NOPASSWD: /usr/sbin/service ssh start' >/etc/sudoers.d/service-ssh-start"
```
Verify that the previous works; the command below should not ask for a password:
```shell
sudo /usr/sbin/service ssh start
```

## mktemp - unique filenames
Example using `mktemp` and `date`
```shell
mktemp foo.$(date +%Y%m%d).XXX
```

## cat

### Direct contents to psql

Use cat to send sql commands to psql. This keeps potentially sensitive contents
off the process list.
```shell
cat << EOF | psql
alter user enterprisedb with password '$EDB_USER_PASSWORD';
EOF
```

### Direct contents to a file
```shell
foo=bar
cat << EOF > file.txt
$foo
this is a file
EOF
cat file.txt
```


## sed
### Append a line after a match
```shell
echo line1 | sed "/^line1.*/a line2"
```

### Insert line before a match
```shell
echo line1 | sed "/^line1.*/i line0"
```

### Search and replace
```shell
echo "line1" | sed 's|^line1|this is line number 1|'
```

## lsof
