# g0blin

An almost-finished iOS 10.3.x jailbreak based on Siguza's [v0rtex](http://github.com/siguza/v0rtex) kernel exploit and Luca Todesco's KPP bypass.

For 64-bit devices prior to the iPhone 7 (A7 - A9).

Spawns a SSH server listening on port 2222.

Remember to change your SSH passwords! Change the passwords for both the **mobile** and **root** users! (see below)

Please reinstall the bootstrap when you try a new build.


## DO NOT INSTALL UNOFFICIAL IPAs*

This is my first jailbreak and I have been making mistakes as I learn. Please wait until I make an official release unless you *really* know what you are doing and don't mind having to restore to iOS 11 if something goes wrong.


## known issues

~~Location services fails after jailbreaking~~ fixed locally, haven't pushed the changes yet

TouchID fails sometimes after jailbreaking?

Third-party applications that need root priveledges require an extra entitlement to function correctly.

````
<key>com.apple.private.security.no-container</key>
<true/>
````

I have already added the entitlement to the copy of Cydia included in g0blin.

For other apps (eg. Filza, MTerminal) to work correctly you will have to entitle them yourself.

## changing SSH passwords

The default password for all SSH users is **alpine**. Follow the steps below to change the passwords for both the **mobile** and **root** users:

1. Log in as user **mobile** initially (NOT **root**).
2. Once you're logged in and see the command prompt, execute the command `passwd`. Enter **alpine** then select a new, *secure* password.
3. When you're back at the prompt execute `su root`. Enter **alpine** as the password then select a new, *secure* password. For added security change the **root** password to something different than what you chose for the **mobile** user password.
4. Now both **mobile** and **root** should have new passwords. Execute `exit` to close the root shell. This will return you to the **mobile** user prompt.

NOTE: By default the shell prompt will end in **#** when you are **root** and **$** when you are a *non-root* user (in this case the **mobile** user).

## credits

v0rtex kernel exploit by Siguza, vuln by Ian beer, POC by windknown

yalu102 KPP bypass by Luca Todesco (qwertyoruiop)

Patchfinder from Xerub

Thanks to Powerful Saurik for Cydia and answering my questions and being a boss.

Special thanks to {unknown} and {unknown} for reaching out, answering my questions, and providing critical insight.

Also thanks to the community and everyone who had a hand in helping to get this thing off the ground :)
