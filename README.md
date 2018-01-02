# g0blin

(WIP) jailbreak for iOS 10.3.x on A7-A9 devices

updated v0rtex exploit + yalu102 kpp bypass

## what works
- tfp0
- kernel r/w access
- remount / as r/w
- amfi patched
- starts an ssh server listening on port 2222
- command line tools to install packages (dpkg, apt-get if you install it)
- Substrate
- Cydia can now install tweaks

## what doesn't work
- GUI apps that need root priveledges are experiencing a sandbox error
- Filza can be fixed by applying the same extra entitlement given to Cydia


thanks to everyone helping out, finding offsets, testing, etc!

creds: Lucky Tobasco, Sizuga, Xenu, Saurik
