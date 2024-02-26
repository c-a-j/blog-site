+++
title = "Migration Toolkit and JDBC Drivers"
author = ["Clint Jordan"]
description = " "
date = "2023-05-16"
lastmod = ""
tags = ["edb"]
categories = ["notes"]
draft = false
autonumber = false
printmode = false
+++


## Installation

### Configure the repository manually before installing packages

```shell
dnf install yum-utils 
rpm --import 'https://downloads.enterprisedb.com/Pf2el1JMrOqqdSgR2o8s53Sh5Hhq7zYZ/enterprise/gpg.E71EB0829F1EF813.key'
curl -1sLf 'https://downloads.enterprisedb.com/Pf2el1JMrOqqdSgR2o8s53Sh5Hhq7zYZ/enterprise/config.rpm.txt?distro=el&codename=8' > /tmp/enterprise.repo
dnf config-manager --add-repo '/tmp/enterprise.repo'
dnf -q makecache -y --disablerepo='*' --enablerepo='enterprisedb-enterprise'
```

> Note: These steps only need to be done once and are all included in the EPAS
> installation RN. This should not be necessary after initial installation.

### Install the EPEL Repository

```shell
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
```

### Enable additional repositories to resolve dependencies

```shell
ARCH=$( /bin/arch ) subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"
```

> Note: This step is included in the EPAS installation RN and therefore
> should not be necessary to repeat.


### Install the packages

```shell
sudo dnf -y install edb-migrationtoolkit edb-jdbc
```
