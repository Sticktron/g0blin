# g0blin

An incomplete jailbreak for A7-A9 devices on iOS 10.3.x

Spawns an SSH server listening on port 2222.

Remember to change your SSH passwords! Change the passwords for both the **mobile** and **root** users! (see below)

Please reinstall the bootstrap when upgrading.


## what is still broken?

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

Siguza - v0rtex kernel exploit

Luca Todesco - yalu102 kpp bypass

Xerub - patchfinder (extra_recipe)

Saurik - Cydia

thanks: PsychoTea, ARX8x, Abraham Masri, ninjaprawn, coolstar, ... ?
