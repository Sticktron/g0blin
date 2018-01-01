# sz4js (g0blin fork)

(WIP) jailbreak for iOS 10.3.x (64-bit, < iPhone 7)

Updated v0rtex kernel exploit + yalu102 KPP bypass

- tfp0
- kernel r/w
- remount /
- amfi patch
- spawn ssh server on port 2222
- bootstraps Cydia (WIP)
- Cydia substrate

# Issues

setuid(0) does not give root access in sandboxed apps?
Cydia can't install backages because cydo has no root (use dpkg via ssh instead)

creds: Sticktron, Lucky Tobasco, Sizuga, Xenu
