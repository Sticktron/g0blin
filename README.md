# g0blin

An almost-finished iOS 10.3.x jailbreak based on Siguza's [v0rtex](http://github.com/siguza/v0rtex) kernel exploit and Luca Todesco's KPP bypass.

For 64-bit devices prior to the iPhone 7 (A7 - A9).

Spawns an SSH server listening on port 2222. Remember to change your passwords!

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


## credits

v0rtex kernel exploit by Siguza, vuln by Ian beer, POC by windknown

yalu102 KPP bypass by Luca Todesco (qwertyoruiop)

Patchfinder from Xerub

Thanks to Powerful Saurik for Cydia and answering my questions and being a boss.

Special thanks to {unknown} and {unknown} for reaching out, answering my questions, and providing critical insight.

Also thanks to the community and everyone who had a hand in helping to get this thing off the ground :)
