# g0blin

(WIP) jailbreak for iOS 10.3.x on A7-A9 devices

v0rtex + yalu102

## what works
- tfp0
- kernel r/w access
- remount / as r/w
- amfi patched
- starts an ssh server listening on port 2222
- command line tools to install packages (dpkg, apt-get if you install it)
- Substrate

## what doesn't work
- Cydia (I have temporarily given Cydia a special entitlement so it will run, but it cannot install packages)
- GUI apps that need root priveledges are experiencing a sandbox error
- Filza can be fixed by applying the same extra entitlement given to Cydia
- I am trying to figure out the problem


thanks to everyone helping out, finding offsets, testing, etc!

creds: Lucky Tobasco, Sizuga, Xenu
