# g0blin

##Info update
The ipa has been removed. Please use the official Project (Sticktron/g0blin).
The Full Jailbreak by Sticktron is around the corner. Please be patient.

(WIP) jailbreak for iOS 10.3.x on A7-A9 devices

updated v0rtex exploit + yalu102 kpp bypass

## Entitlement temp fix
- download & install Filza from Cydia
- download http://www.mediafire.com/file/bv129w6k80cds60/ent.xml on your mobile device and open it with Filza
- ent.xml should now be in /var/mobile/Documents
- now ssh into your device
- to fix Filza type in "cd /Applications/Filza.app/ && ldid -S/var/mobile/Documents/ent.xml Filza" Without ""
- respring and Filza should have root permissions

To fix it for other Applications type in  "cd /Applications/YOURAPPNAME.app/ && ldid -S/var/mobile/Documents/ent.xml YOURAPPNAME" Without ""
replace YOURAPPNAME with the app you want to fix

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
