# g0blin

A work-in-progress iOS 10.3.x jailbreak for 64-bit iDevices (A7 - A9) made from off the shelf parts and shared research.
Long live jailbreaking!


## supported devices

iPod 6G
iPhone 5S, 6, 6+, 6S, 6S+, SE
iPad Air, Air 2, 5G (2017), Pro 1G 9.7", Pro 1G 12.9", Mini 2, Mini 3, Mini 4


## ingredients

+ [v0rtex](http://github.com/siguza/v0rtex) kernel exploit by Siguza, vuln by Ian Beer, POC by windknown
+ kpp bypass, sandbox, codesigning from [yalu102](http://github.com/kpwn/yalu102) by Luca Todesco
+ additional sandbox work from [h3lix](http://h3lix.tihmstar.net) by tihmstar
+ patchfinder from [extra_recipe](http://github.com/xerub/extra_recipe) by Xerub
+ additional patchfinder work from [async_wake_fun](http://github.com/ninjaprawn/async_wake-fun) by ninjaprawn
+ Cydia by Jay Freeman (saurik)


## dropbear vs OpenSSH

RC1 installed the dropbear SSH server by default. I would rather make SSH optional because some people may not need it or may forget to change their passwords.

RC2 uninstalls dropbear for everyone. If you want to use ssh you can install OpenSSH from Cydia.

RC3 will remove that behaviour allowing you to re-install dropbear if that's your preference.


## what's broken?

- Touch ID does not work in App Store apps while in jailbroken mode
- see the Issue tracker


## tips

- if the Cydia icon is hidden you can fix it by adding a new key `SBShowNonDefaultApps` and binary value `YES` to `/User/Library/Preferences/com.apple.springboard.plist` using Filza
- A temporary workaround for TouchID is to turn it off before jailbreaking and then turn it back on afterward


## instructions

1) Download an offical .ipa file from [g0blin.sticktron.net](http://g0blin.sticktron.net)

2) Install using [Cydia Impactor](http://www.cydiaimpactor.com)


## shoutouts

Siguza, Ian Beer, windknown, Luca Todesco, xerub, tihmstar, saurik, uroboro, cheesecakeufo, arx8x, psycho tea, cryptic; Tyler, the Creator, randomblackdude, Mom.

I am extremely grateful for everyone whose open-source/public contributions to iOS research and developement made this software possible :)


&nbsp;
&nbsp;


<img src="http://data.whicdn.com/images/35103248/original.jpg" width="100%"/>


<p align="center">😈</p>
