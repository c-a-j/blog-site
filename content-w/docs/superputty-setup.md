+++
title = "SuperPuTTY Setup"
author = ["Clint Jordan"]
description = " "
date = "2023-03-07"
lastmod = ""
tags = ["workflow", "superputty"]
categories = ["docs"]
draft = false
printmode = false
+++

## 1. Download and launch SuperPuTTY

### 1.1 Download
Download the latest zip archive
[here](https://github.com/jimradford/superputty/releases/latest).

### 1.2 Unzip the archive
Unzip the archive and move it to somewhere within the `C:\Users\{USERNAME}`
directory. For example, I decided to keep my SuperPuTTY files in
`C:\Users\ClintJordan\bin`, but feel free place them anywhere you like.

### 1.3 Change the SuperPuTTY icon and pin it
The SuperPuTTY icon will probably be set to the default command prompt icon,
which could be confusing if you ever actually use the command prompt. To change
the icon, follow the steps below.

1. Right click on the SuperPuTTY executable and click on **Create Shortcut**
2. Right click on the new shortcut and click on **Properties**
3. Under the **Shortcut** tab, click on **Change Icon**
4. Click **Browse**
5. Navigate to the PuTTY directory (likely `C:\Program Files\PuTTY`)
6. Double click on the PuTTY executable
7. Select the icon with two computers connected by a lightening bolt
8. Click **OK**
9. Click **Apply** then **OK**
10. If you have PuTTY currently pinned to the taskbar, unpin it
11. Double click on the new shortcut to open SuperPuTTY
12. Right click on the taskbar SuperPuTTY icon and pin it


> Note: Feel free to choose any icon you like. I chose to use the PuTTY icon
> because after switching to SuperPuTTY, there aren't any reasons to ever
> open the standard PuTTY again. More details on this below.

## 2. Session Configuration

### 2.1 Add and organize sessions
There's a few different ways to do this.

1. **File -> Import Sessions -> From PuTTY Settings** 
2. Build a new session directory structure in the SuperPuTTY sessions window
3. Hybrid 1 and 2 approach
    * import all your saved PuTTY sessions
    * organize all the sessions into a directory structure
    * delete all the saved PuTTY profiles except the default
    * modify all SuperPuTTY sessions to use the default PuTTY profile

Option 1 will probably get you up and running the quickest. But options 2 and
3 lead to a ***much*** more efficient way of handling session settings.

To illustrate the advantage of options 2 and 3, let's say you've accumulated 100
saved PuTTY sessions over the years and now you've decided that the font size
needs to increase. In PuTTY, you would have to load, increase the font size, and
save the new settings for all 100 sessions *individually*. If you decided that
the font type needs to change a few weeks later...same story all over again.
Option 1 alone does nothing to remedy this issue.

On the other hand, if you have a little time to invest in options 2 or 3, you
could reduce the number of saved PuTTY settings from 100 to 1. That's right, you
could change any setting in a single PuTTY profile and it will take effect in
all 100 of your SuperPuTTY sessions. This tutorial will proceed assuming that
you have taken the path of option 2.

#### 2.1.1 Create session directory structure

The sessions window should be visible by default. If it's not visible, select
**View -> Sessions**. Follow the steps below to start creating a session
structure.

1. Right click on **PuTTY Sessions** and select new folder
    * create PROD, DEV, and TEST 
2. Create subdirectories within PROD, DEV, and TEST
    * as a starting point, create a PALS folder under TEST
3. Right click on the TEST/PALS folder and select **New**
    * Session Name = `nfs0207 (db)`
    * Host Name = `fsxnfsx0207.wrk.fs.usda.gov`
    * PuTTY Session Profile = `Default Settings`

Now just repeat that process for all new sessions. The above steps just outline
a good example, feel free to organize and name sessions however you prefer.

> Alternatively, if you went with option 3 (the hybrid approach), drag your
> imported sessions into appropriate folders and then edit all of them so they
> use the default profile.

Now your session window might look something like this:

![session struct](/images/superputty-session-struct.png)

#### 2.1.2 Clean up PuTTY profiles

It would be a good idea at this point to back up your sessions list. If your
list is incomplete and you haven't already done so, you might also want to
import your PuTTY Sessions as well. They will populate in a separate folder.

To import PuTTY sessions:
* **File -> Import Sessions -> From PuTTY Settings**

To export SuperPuTTY sessions:
* **File -> Export Sessions**

Now that all your sessions in SuperPuTTY are backed up and set to use the
default session profile, you can simply delete all the now unnecessary PuTTY
profiles and start fresh. Access the PuTTY Configurations through **Tools ->
PuTTY Configuration**.

> Before you do this be sure that the default profile is set up the way you
> want! Take time to compare your most frequently used sessions to your default
> profile. Be sure to save everything you want in the default.

After you have cleaned up, your PuTTY Configuration window should look like
this:

![fresh putty](/images/fresh-putty.png)

If you prefer to have the terminal styled differently depending on the host or
type of work being performed, just save a few more general profiles. For
example, if you want PROD, DEV, and TEST servers to have different background
colors and/or fonts, you could create new profiles called PROD, DEV, and TEST
starting with the default. After doing this the PuTTY configuration window would
look like the screenshot below and there will be four different profiles to
choose from in SuperPuTTY.

![custom putty](/images/custom-putty.png)

## 3. Set up CAPI authentication

### 3.1 Set auto-login username
First, I recommend eliminating the need to type in your account name every time
a new session is opened. 

1. Open the PuTTY Configurations 
    * **Tools -> PuTTY Configuration** from SuperPuTTY
2. Load the default profile
3. Navigate to **Connection -> Data**
4. Insert your p-account into the **Auto-login username** text bar
5. Navigate back to **Session**
6. Highlight the default profile and click **Save**

If you changed all the SuperPuTTY sessions to use the default profile as
outlined in [**2 Session
Configuration**](/docs/superputty-setup/#2-session-configuration), now your
p-account will automatically be inserted when opening new sessions. The purpose
of should now be very clear. Let's take the efficiency a step further.

### 3.2 Configure CAPI authentication

#### 3.2.1 Add CAPI keys to default PuTTY profile

1. Open the PuTTY Configurations
2. Load the default profile
3. Navigate to **Connection -> SSH -> Certificate**
4. Click on **Set CAPI Cert**
5. Ensure that your certificate is chosen (you may have a list)
6. Click **OK**
7. Navigate back to **Session**
8. Highlight the default profile and click **Save**

> Note: **3.2.1** must be repeated for all PuTTY profiles.

Now open two new sessions, one in the production domain and the other in the
dev/test domain. Repeat **3.2.2** - **3.2.4** for each domain.

#### 3.2.2 Check for the existence of the `~/.ssh` directory.

```text
$ ls -lad .ssh
drwx------ 1 cjordan cjordan 4096 Feb 21 16:02 .ssh
```

If you get `ls: cannot access '.sshh': No such file or directory`, then the
directory must be created.

```text
$ mkdir ~/.ssh
```

#### 3.2.3 Create the `~/.ssh/authorized_keys` file.

```text
$ cat > ~/.ssh/authorized_keys
```

After you hit enter on this command, the prompt will drop to the next line and
wait for input. Now we must copy the CAPI public key from PuTTY.

1. Open the PuTTY Configurations
2. Load the default profile
3. Navigate to **Connection -> SSH -> Certificate**
4. Click on **Copy to Clipboard**

Go back to the terminal window and paste in the clipboard contents, press `Enter`,
then `Ctrl+D`. It should have looked something like this.

```text
$ cat > ~/.ssh/authorized_keys
ssh-rsa gVVSvgd9lrPUY4rZIQsmDxsN6JljDI42GlgwVtQNxaek9KcLn9lEEC8R
CAPI:69862ffda995 CN=JOHN DOE + OID.1.1=1200, OU=Department of Agriculture,
O=U.S. Government, C=US
```

> Note: Your key will be much longer than this. I have stripped out many
> characters from mine for example.

Output the `~/.ssh/authorized_keys` file and check the contents. It might be a good
idea to open a Notepad file and paste in the CAPI key for comparison.

```text
cat ~/.ssh/authorized_keys
```

It should start with `ssh-rsa` and end with `C=US`.

#### 3.2.4 Remove group permissions on `~/.ssh` and `~/.ssh/authorized_keys`.

```text
$ chmod 700 ~/.ssh

$ chmod 600 ~/.ssh/authorized_keys
```

Check the permissions.

```text
$ ls -lad ~/.ssh
drwx------ 1 cjordan cjordan 4096 Feb 21 16:02 /home/cjordan/.ssh

$ ls -la ~/.ssh/authorized_keys
-rw------- 1 cjordan cjordan 546 Mar  2 16:18 authorized_keys
```

If the previous steps were followed correctly, you should now be able to log
into new SuperPuTTY sessions with your PIV credentials. Nifty!

## 4. Configure helpful hot keys

### 4.1 Moving through tabs

When doing work in a terminal, it's more efficient to switch over to the mouse
as little as possible. To achieve this workflow in SuperPuTTY, we need to set
a few hot keys.

* **Tools -> Options -> Shortcuts**

Look for two items in this window, **NextTab** and **PrevTab**. Set them to
whatever you like. For example, I have mine set to `Ctrl+.` and `Ctrl+,` for
NextTab and PrevTab, respectively. This might seem like a strange choice at
first glance, but those are also the keys for `>` and `<`, which may make
a little more sense. Additionally, I have tmux set up to change windows with
those same keys, but using `Alt` instead of `Ctrl`.

For some reason that is completely mysterious to me, SuperPuTTY allows for
changing tabs while maintaining the cursor focus in another tab. This means that
it's often possible to unintentionally send keys to tabs that you aren't even
looking at.  For this reason, you may want to set another key to change focus to
the visible tab to avoid having to switch to the mouse for a click. Go back to
**Tools -> Options -> Shortcuts** and look for **FocusActiveSession** and set it
to anything you like. I set mine to `Ctrl+f`.
