+++
title = "Password management"
author = ["Clint Jordan"]
description = "Ditch the notepad"
date = "2023-01-20"
lastmod = ""
tags = ["pass"]
categories = ["docs"]
draft = false
autonumber = false
printmode = false
+++

### Why use a Password Manager?

As a government employee in IT, you are tasked with keeping up with quite a few
credentials. Putting a password management system in place can help you become
more efficient at work. Instead of opening a text file or spreadsheet,
highlighting, copying, and pasting every time you need a password, you could
just use a command line argument to automatically add it to the clipboard.
Instead of getting locked out of a server because of typos or that you didn't
notice you had CAPS-LOCK on, you could ensure precision 100% of the time.
Instead of taking time out of your day, or someone else's day, to reset
passwords that you have lost or forgotten, you could have them safely stored on
your machine.

Aside from efficiency, there's the all-important security aspect. Using
a password management system will help us avoid exposing active credentials to
coworkers or others that might gain access to our systems. 

### Why `pass`?

There are, of course, many options out there to choose from. I personally like
to keep things simple and overly secure, so my preference is the standard UNIX
password manager, `pass`. You can choose to store your passwords locally or
also push the encrypted contents to a git repository. So, unlike many of the
other popular password managers, there is no need for your sensitive information
to be stored on a third party server.

> Note: An enterprise-grade password management service may be in the works for
> us. Getting it approved and running will certainly take a while. For now,
> `pass` will serve you well for your individual credentials.

### Install the Required Packages

The required packages are `gpg2`, and `pass`. I'd also recommend installing
`git`, and `pwgen`. Obviously, you'll need to have [WSL
installed](/nifty-things/wsl-setup) on your government machine. This tutorial
assumes that you are using the Ubuntu distribution.

```text
sudo apt install gnupg2 pass git pwgen
```

### Generate GPG Keys
A GPG key pair will serve as your "ID Card" for all password store transactions.
***Never*** share your private key or your master password with anyone. 

```text
gpg2 --full-generate-key
```

{{< code-no-copy lang="text" >}}
Please select what kind of key you want:

   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)

Your selection? 1
{{< /code-no-copy >}}

{{< code-no-copy lang="text" >}}
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
{{< /code-no-copy >}}

{{< code-no-copy lang="text" >}}
Please specify how long the key should be valid.

        0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 0
Key does not expire at all
Is this correct? (y/N) y
{{< /code-no-copy >}}


{{< code-no-copy lang="text" >}}
GnuPG needs to construct a user ID to identify your key.

Real name: John Smith
Email address: john.smith@usda.gov
Comment: 
You selected this USER-ID:
    "John Doe <john.smith@usda.gov>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
{{< /code-no-copy >}}

And, lastly, set your master password. This will be used to access your password
store, so it needs to be strong, but easy to remember. Personally, I prefer
using an odd sentence to make my master password strong than a jumble of symbols,
numbers, and letters. If used correctly, this type of password can even be
[stronger than random
characters](https://www.maketecheasier.com/sentences-make-better-passwords/).
Struggling think of anything? [Check this out](https://www.useapassphrase.com/).


### Initialize and Build Your Password Store
First, get your gpg public key id with `gpg2 --list-keys`.

{{< code-no-copy lang="text" >}}
gpg2 --list-keys
/home/johnsmith/.gnupg/pubring.kbx
--------------------------------
pub   rsa4096 2023-01-03 [SC]
      3D45BB2DC92094D8741E2
uid           [ultimate] John Smith <john.smith@usda.gov>
sub   rsa4096 2023-01-03 [E]
{{< /code-no-copy >}}

In the above example, the public key id is 3D45BB2DC92094D8741E2. Now copy yours
and execute the following command using your key id.

{{< code-no-copy lang="text" >}}
pass init 3D45BB2DC92094D8741E2
{{< /code-no-copy >}}

This will create the directory `$HOME/.password-store`, which is where all the
encripted contents will be stored. Now start adding passwords.

{{< code-no-copy lang="text" >}}
pass insert usda/p-acct/psmitj01
{{< /code-no-copy >}}

The command above adds John Smith's p account to his password store. `pass` uses
a simple directory structure to organize the encripted passwords. After John
enters this command, his password store directory structure would look like
this.

{{< code-no-copy lang="text" >}}
.password-store/
└── usda
    └── p-acct
        └── psmitj01.gpg
{{< /code-no-copy >}}

Another password that fits under the `usda` directory would be John's eAuth
credentials.

{{< code-no-copy lang="text" >}}
pass insert usda/e-auth/johnsmith
{{< /code-no-copy >}}

Now John's directory structure would look like this.

{{< code-no-copy lang="text" >}}
.password-store/
└── usda
    ├── e-auth
    │   └── clintjordan.gpg
    └── p-acct
        └── psmitj01.gpg
{{< /code-no-copy >}}

Simple, right? At the risk of beating a dead horse, let's say John made
a [Stack Overflow](https://stackoverflow.com/) account with his government
email address. These credentials don't really fit in the `usda` directory.

{{< code-no-copy lang="text" >}}
pass insert stack-overflow/john.smith@usda.gov
{{< /code-no-copy >}}

Now John's directory structure looks like this.

{{< code-no-copy lang="text" >}}
.password-store/
└── stack-overflow
    └── john.smith@usda.gov.gpg
└── usda
    ├── e-auth
    │   └── clintjordan.gpg
    └── p-acct
        └── psmitj01.gpg
{{< /code-no-copy >}}


Get it? It's worth noting that because of the descriptive way that John
constructed his password store, if an intruder were to access John Smith's
machine they could look into the `.password-store` directory and plainly see all
of John's accounts and usernames/emails. While the actual encrypted password
contents would be secure with a strong master password, John could take it
a step further and also encrypt the usernames and emails. Sparing you from all
the painful details, John's directory structure might look like this.

{{< code-no-copy lang="text" >}}
.password-store/
└── stack-overflow
    ├── email.gpg
    └── password.gpg
└── usda
    └── e-auth
        ├── username.gpg
        └── password.gpg
    └── p-acct
        ├── username.gpg
        └── password.gpg
{{< /code-no-copy >}}

Probably unnecessary, but very secure.

### Fetching Passwords
Quite simple, really. Just use `pass show`. Continuing with the John Smith
example...

{{< code-no-copy lang="text" >}}
pass show usda/p-acct/psmitj01
{{< /code-no-copy >}}

This, however, will output John's password in the terminal window, which is
**not** always a great idea. A more useful way to do this is to direct the
output to the clipboard. 

{{< code-no-copy lang="text" >}}
pass show usda/p-acct/psmitj01 | clip.exe
{{< /code-no-copy >}}

This is, of course, assuming that John is using WSL. 

And, lastly, if you want to view the password store contents, just use `pass`.

{{< code-no-copy lang="text" >}}
pass

Password Store
└── stack-overflow
    └── john.smith@usda.gov.gpg
└── usda
    ├── e-auth
    │   └── clintjordan.gpg
    └── p-acct
        └── psmitj01.gpg
{{< /code-no-copy >}}

### Generate Passwords with `pwgen`
Now that you don't have to worry about actually remembering passwords anymore,
you can feel free to use some truly ridiculous combinations. While
[passphrases](https://www.useapassphrase.com/) can be extremely secure, as we
all know most account holders these days won't accept anything without a mix of
case, symbols, and numbers. While the passphrase `it's truly bonkers, mate`
would take an estimated 33,936 centuries to crack, it's not even acceptable for
a Netflix account. `pwgen` to the rescue.

```text
pwgen 30 1 --secure --capitalize --numerals --symbols --remove-chars=\'\`\"\|\$\
```

Here I've requested one completely random thirty-character password with mixed
case, numbers, and symbols. I've also removed a few characters that may create
issues when running the command in a script and in the markdown file that
produced this page.  Check out the man page, `man pwgen`, for more info.

So if you've been losing sleep over the fact that your passphrase might get
cracked in the next few thousand centuries, rest assured, `pwgen` has your back.
The password generated from the previous command was
`a8-1I4j~B#ZQ9QW!+?a%DjEAd=RQH\` and it would take an estimated 3.282e+35
centuries to crack with modern day hardware.

### Managing Shared Credentials with `pass`
By using a shared system we could avoid sending passwords through emails, chat
messages, or spreadsheets that could all easily be viewed by anyone that might
access our systems. Sure, we could purchase a fancy enterprise solution, but
`pass` would suffice as long as everyone is using WSL.

Give this a read. [Using pass in
a Team](https://medium.com/@davidpiegza/using-pass-in-a-team-1aa7adf36592).

Basically, it is possible to have multiple password stores using `pass`. Those
in a team would only need to share their public key with a repo manager to gain
access. I'm imagining the workflow might go something like this... Let's say
Greg Kermit is the master of all things WebLogic, so he is chosen to be the repo
manger for the WebLogic password store. Initially, Greg

1. Initializes the password store
2. Inserts all shared EDBA WebLogic credentials
3. Inserts public keys into the `.gpg-id` file for all authorized team members
4. Signs keys and re-encrypts the password store
4. Initializes a local git repository for the password store
5. Creates a git repository on code.fs.usda.gov
6. Pushes the encrypted contents to the code.fs.usda.gov repository
7. Shares the repository name with team members so they can clone the contents

Now, if Greg wants to update credentials, all he has to do is update the
password store and push changes to the remote repository. Greg then would notify
the team that they need to pull the new contents.

Now, let's say a new member has been added to the team and they have requested
WebLogic admin credentials. Greg simply

1. Inserts the new public key into the `.gpg-id` file
2. Signs key and re-encrypts the password store
3. Pushes contents to the code.fs.usda.gov repository

A team member leaving the agency would involve the same steps except, obviously,
Greg would remove the public key from the `.gpg-id` file. If Greg were to leave
the agency, then the password store would simply need to be re-encrypted with
the new repo manager's private key. 

This process would definitely be too time consuming for very large teams or
environments with high turnover rates. However, for our team of less than 30
individuals, and even fewer that actually need shared credentials,
it seems manageable.
