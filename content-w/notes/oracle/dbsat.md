+++
title = "Oracle DB Security Assessment Tool"
author = ["Clint Jordan"]
description = " "
date = "2023-04-03"
lastmod = ""
tags = ["oracle", "STIG"]
categories = ["notes"]
draft = false
autonumber = false
printmode = false
+++


## Download archive
[Download](https://www.oracle.com/database/technologies/security/dbsat.html#:~:text=Oracle%20Database%20Security%20Assessment%20Tool%20(DBSAT)%20is%20a%20popular%20command,controls%20to%20mitigate%20those%20risks.)
from Oracle. 

> Note: My Oracle Support account is required.


## Upload archive to target domain
Upload the archive via WinSCP or other method. 


## Stage archive and extract contents
Move or copy the archive to `/tmp`
{{< code-show-user lang="shell" prompt="p-acct $" cont-prompt=">" >}}
mv dbsat.zip /tmp
{{< /code-show-user >}}

Log in as `root` and change ownership of the archive
{{< code-show-user lang="shell" prompt="p-acct $" output="" cont-str="" cont-prompt=">" >}}
sudo -iu root
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="root $" output="" cont-str="" cont-prompt=">" >}}
cd /tmp
chown oracle:oinstall dbsat.zip
{{< /code-show-user >}}

Log in as `oracle` and verify environment
{{< code-show-user lang="shell" prompt="root $" output="" cont-str="" cont-prompt=">" >}}
exit
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="p-acct $" output="3-20" cont-str="" cont-prompt=">" >}}
sudo -iu oracle
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="oracle $" output="2-20" cont-str="" cont-prompt=">" >}}
env | grep ORA
ORACLE_UNQNAME=orcl
ORA_NLS10=/opt/oracle/product/19/db_1/nls/data
ORACLE_SID=edba02t
ORACLE_BASE=/opt/oracle
ORACLE_TERM=xterm
ORACLE_HOME=/opt/oracle/product/19/db_1
{{< /code-show-user >}}

Create a `dbsat` directory
{{< code-show-user lang="shell" prompt="oracle $" output="" cont-str="" cont-prompt=">" >}}
mkdir /tmp/dbsat
{{< /code-show-user >}}

Extract the archive contents
{{< code-show-user lang="shell" prompt="oracle $" output="" cont-str="" cont-prompt=">" >}}
unzip /tmp/dbsat.zip -d /tmp/dbsat
{{< /code-show-user >}}

## Unlock the `system` user

{{< code-show-user lang="shell" prompt="oracle $" output="" cont-str="" cont-prompt=">" >}}
sqlplus / as sysdba
{{< /code-show-user >}}
> Note: An alias for this may exist. Check for it with `alias`.

{{< code-show-user lang="sql" prompt="SQL>" output="" cont-str="" cont-prompt=">" >}}
alter user system identified by "PASSWORD";
alter user system account unlock;
exit
{{< /code-show-user >}}
> Note: `"PASSWORD"` needs to be replaced by a password of sufficient
> complexity. For example, the password used for this test was
> `Myroot10%01Myroot10%04`. Since passwords cannot be reused, simply change
> a few of the numbers to make it work.

## Collect report data
{{< code-show-user lang="shell" prompt="oracle $" output="" cont-str="" cont-prompt=">" >}}
mkdir /tmp/dbsat/reports
cd /tmp/dbsat/reports
bash /tmp/dbsat/dbsat collect -n system@${ORACLE_SID} "${ORACLE_SID}_$(date +%Y-%m-%d)"
{{< /code-show-user >}}

## Generate readable report
{{< code-show-user lang="shell" prompt="oracle $" output="" cont-str="" cont-prompt=">" >}}
bash /tmp/dbsat/dbsat report -n -a "${ORACLE_SID}_$(date +%Y-%m-%d)"
{{< /code-show-user >}}
> Note: The above command will only work if you are generating the `.html`
> report on the same day that the data was collected. Otherwise you will need to
> manually replace `${ORACLE_SID}_$(date +%Y-%m-%d)` with the filename.

## Copy report to p-account home
Change permissions of the `.html` report file
{{< code-show-user lang="shell" prompt="oracle $" output="" cont-str="" cont-prompt=">" >}}
chmod 777 "${ORACLE_SID}_$(date +%Y-%m-%d)_report.html"
exit
{{< /code-show-user >}}

{{< code-show-user lang="shell" prompt="p-acct $" output="" cont-str="" cont-prompt=">" >}}
cp /tmp/dbsat/reports/REPORT_NAME ~/wherever/you/want/
{{< /code-show-user >}}
> Note: Replace `REPORT_NAME` with the `.html` report filename and
> `~/wherever/you/want/` to the desired path within your home directory.


## Automation idea
We may be able to script this process and run it on an OEM console to get
reports for every database all at once.
