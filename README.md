# g0blin

This is a fork of @Sticktron's original g0blin. The key difference is I have modified the xcode project so that it will compile with a version of xcode that still runs on El Capitan (10.11++).

I will try to keep it maintained with the original, while also including some changes ([e.g., Danoded's](https://github.com/Danoded/10.3.x-Jailbreak-Without-Evil/commit/c91d66787921e7d999c18bf165d93dde14b6a11b)).

You will need to clone and build this project. You must change the name and dev team from the xcode general info screen too.

## Quick-n-dirty

Supposing you chose the profile or archive scheme from xcode, you will then dig through the `DerivedData` folders to find the app. In the same directory, create a new folder named `Payload` and move the app into the new directory. Compress the `Payload` folder with `zip`, and then rename it from `Archive.zip` to whatever (e.g., `PoopyButters.ipa`?). Ensure that the extension is changed from .zip to .ipa. Finally, you can put the newly-minted app onto your phone using Cydia Impactor.

***
***
A work-in-progress iOS 10.3.x jailbreak for 64-bit iDevices (A7 - A9) made from off the shelf parts and shared research.
Long live jailbreaking!


## supported devices

iPod 6G
iPhone 5S, 6, 6+, 6S, 6S+, SE
iPad Air, Air 2, 5G (2017), Pro 1G 9.7", Pro 1G 12.9", Mini 2, Mini 3, Mini 4


## what doesn't work yet?

There are a few things not working that are related to a kernel patching issue:
- Touch ID not working in containerized Apps
- Preferences behaving badly in containerized Apps
- Failure to launch an App via Xcode


## what does work?

Everything else?


## instructions

1) Download an offical .ipa file from [g0blin.sticktron.net](http://g0blin.sticktron.net)

2) Install using [Cydia Impactor](http://www.cydiaimpactor.com)


## tips

- if the Cydia icon is hidden you can fix it by adding a new key `SBShowNonDefaultApps` and binary value `YES` to `/User/Library/Preferences/com.apple.springboard.plist` using Filza
- A temporary workaround for TouchID is to turn it off before jailbreaking and then turn it back on afterward


## a note about dropbear

I decided to make installing an SSH server optional for safety reasons, so g0blin RC2 automatically uninstalls dropbear when it runs. Post-RC2 builds no longer do that.

I recommend installing OpenSSH instead. The port will be `22` by default. It can be changed in `/etc/services`.


## ingredients

+ [v0rtex](http://github.com/siguza/v0rtex) kernel exploit by Siguza, vuln by Ian Beer, POC by windknown
+ kpp bypass, sandbox, codesigning from [yalu102](http://github.com/kpwn/yalu102) by Luca Todesco
+ additional sandbox work from [h3lix](http://h3lix.tihmstar.net) by tihmstar
+ patchfinder from [extra_recipe](http://github.com/xerub/extra_recipe) by Xerub
+ additional patchfinder work from [async_wake_fun](http://github.com/ninjaprawn/async_wake-fun) by ninjaprawn
+ Cydia by Jay Freeman (saurik)


## shoutouts

Siguza, Ian Beer, windknown, Luca Todesco, xerub, tihmstar, saurik, uroboro, cheesecakeufo, arx8x, psycho tea, cryptic; Tyler, the Creator, randomblackdude; Mom.

I am extremely grateful for everyone whose open-source/public contributions to iOS research and developement made this software possible :)


&nbsp;
&nbsp;


<p align="center"><img src="http://data.whicdn.com/images/35103248/original.jpg" width="85%"/></p>


<p align="center">😈</p>
