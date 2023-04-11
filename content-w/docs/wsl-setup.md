+++
title = "WSL Setup"
author = ["Clint Jordan"]
description = "Make the Windows OS tolerable"
date = "2023-01-20"
lastmod = " "
tags = ["WSL"]
categories = ["docs"]
draft = false
autonumber = false
printmode = false
+++

## Get Assistance from an IT Specialist
You'll need to give the FS Customer Help Desk (866-945-1354) a call and have an
IT specialist enable Windows Subsystem for Linux on your machine. You can make
it easier on them by downloading and extracting the [WSL
archive](https://usdagcc.sharepoint.com/sites/ocio_itr/_layouts/15/search.aspx/siteall?q=wsl)
from the IT Resources Certified Software list before you call.

> Note: WSL 2 doesn't seem to play well with our VPN client. Feel free to give
> it a shot, but if you don't have an internet connection in WSL 2, you'll need
> to switch to WSL 1.

## Install a Distribution
Once WSL is enabled and installed, install a Linux distribution. To list the available
distributions, enter the following command in a PowerShell session:

```text
wsl --list --online
```

 I suggest installing Ubuntu unless you have a strong preference for one of the
others.

```text
wsl --install -d Ubuntu
```

Set the WSL default distribution.

```text
wsl --install -d Ubuntu
```

Now type WSL in the taskbar search window and run it. 

## Get a Decent Terminal Emulator
The main reason I started researching an alternative to the default WSL terminal
emulator is because there does not seem to be a way to disable the horizontal
scroll bar. The default WSL terminal scroll bars are placed in a sloppy manner
that covers up some of the terminal window. Most importantly, the horizontal
bar *sometimes* completely covers up the tmux status bar, which is very unideal.
Mintty to the rescue.

Mintty is the terminal emulator for CygWin, but it also works for WSL. Luckily,
we actually have adequate permissions to install Mintty. To install it, open
a PowerShell session and execute the following command. 

```text
winget install wsltty
```

If your AD username was JohnDoe, Mintty was probably installed in
`C:\Users\JohnDoe\AppData\Local\wsltty\bin`. Find it, run it, and pin it to the
taskbar. Once you've done that you can unpin the far inferior default terminal
emulator. The setting to disable the horizontal scroll bar can be found under
Window in the options. If you prefer the middle mouse button to serve as
copy/paste like myself, that can be found under Mouse. Lastly, definitely check
out the themes under Looks. These are all features missing from the default WSL
terminal emulator.

> Note: For some reason(s) unknown to me, Mintty does seem quite slow when
> opening new sessions. However, I personally find that the benefits
> significantly outweigh the downside of waiting an extra 3 seconds. 

## Install Packages
Unlike most of your accounts on our servers, you have root privileges in your
WSL environment. To start, it might be a good idea to upgrade all the packages
that were installed by default. First, use `sudo apt update` to fetch the
packages that are out of date and then `sudo apt upgrade` to actually perform
the upgrades.

```text
sudo apt update && sudo apt upgrade
```

To install a package, simply use the `apt` command. For example, the following
command will install the text editor, vim, which is the default editor on our
servers. For more info, refer to [Vim Configuration](/nifty-things/vim-config)

```text
sudo apt install vim
```


