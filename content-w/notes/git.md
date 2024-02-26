+++
title = "Git notes"
author = ["Clint Jordan"]
description = " "
date = "2023-05-04"
lastmod = ""
tags = ["git"]
categories = ["notes"]
draft = false
autonumber = false
printmode = false
+++

## Using git on a shared account 
It's probably not best practice to associate your SSH keys with a shared account
such as `oracle` or `enterprisedb`. Use a personal access token instead.

### Create personal access token
From your github account, click your icon in the upper right hand corner and
select *Settings*.

![github settings](/images/github-settings.png)

From the settings navbar on the left, click on *Developer Settings*.

![github dev settings](/images/github-dev-settings.png)

From *Developer Settings* select *Personal Access Tokens*.

![github pat](/images/github-pat.png)

From there, generate a new token and store it somewhere safe, preferably
a [password manager](/docs/pass-manage).

### Commit
```shell
git -c user.name="John Doe" -c user.email="john.doe@usda.gov" commit
```

### Push
```shell
git push
```
You will be prompted for github credentials. Use your github
enterprise username and your personal access token as the password.
