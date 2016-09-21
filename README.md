## MyJailShop

  
MyJailShop a redux rewrite of [Dkmuniz Jail Shop](https://forums.alliedmods.net/showthread.php?t=247917)
  
---
  

***Description:***

MyJailShop provide you a high customizable shop with credits system.



***Shop Items:***

Guards & prisoner / CT & T - both:

* Heal up to 100HP
* Armor & extra HP
* Revive / respawn
* Bunny Hop
* Froggy Jump / double jump
* Low Gravity
* No Damage / Immortal
* Wallhack


Prisoner / Terrorist - only:

* Open Cells (smartjaildoors)
* Vampire - +speed & HP for damage
* Invisible
* No Clip
* Be a Bird
* Fake Guard Model
* Teleport smoke
* Poison smoke
* Fire Grenade
* One bullet AWP
* Seven bullets deagle
* One hit Knife
* Throw One hit Knife
* Three bullets Taser
* Molotov & flashs


***Commands & convars***



***Warden***
This plugins allows players to take control over the prison as warden/Headguard/Commander.  
Chat, hud & sound notifications about warden / no warden. Vote to retire the warden. Colorized warden and define the color. Set warden Model and icon above pleayers head. Open & close cell doors & automatic open. Mute terroist for a amoung of time or round end. Extend roundtime. Gun plant prevention - CT can drop weapons only on round beginn without punishment & report to warden. Use Zeus as Handcuffs and move the cuffed T around. Cuffed T got a chance to gets a paperclip to unlock cuffs. Give warden laser pointer & painter(LaZzZers) with menu to choose color. Warden can toggle painter for terrorists. Set different countdowns (start/stop) with overlays, sound & chat notifications. Start a MathQuiz with endtimer & show the player with the first right answer. Toggle Friendly Fire & No Block. Kill/pick a random T (excluding rebels & last T) with different kill effects(Lighting,Timebomb,Firebomb). Count Player In Wardens radius. Mark or UnMark a player as Rebel. Automute Player when warden Talks.

**Commands**

    sm_jailshop
    sm_jailcredits
    sm_jailgift
    sm_revive
    sm_showjailcredits
    
set your own custom command. take a look at "sm_jailshop_cmds_NAME"

*AdminCommands // ADMFLAG_GENERIC*
    
    sm_give
    sm_set
    

**Plugin ConVars**

    
sm_jailshop_version - The version of this MyJailShop SourceMod plugin
sm_jailshop_enable - 0 - disabled, 1 - enable the MyJailShop SourceMod plugin
sm_jailshop_welcome - 0 - disabled, 1 - welcome messages on spawn
sm_jailshop_credits_save - 0 - disabled, 1 - Save credits on player disconnect
sm_jailshop_mysql - 0 - disabled, 1 - Should we use a mysql database to store credits
sm_jailshop_credits_max - Maximum of credits to earn for a player
sm_jailshop_minplayers - Minimum players to earn credits
sm_jailshop_credits_per_kill_t - Amount of credits a prisioner earns when kill a Guard
sm_jailshop_credits_per_kill_t_vip - Amount of credits a VIP prisioner earns when kill a Guard
sm_jailshop_credits_per_kill_ct - Amount of credits a guard earns when kill a prisoner
sm_jailshop_credits_per_kill_ct_vip - Amount of credits a VIP guard earns when kill a prisoner
sm_jailshop_credits_lr  - Amount of credits for reach last request as prisoner (only if hosties is available)
sm_jailshop_credits_vip - Amount of credits for reach last request as prisoner (only if hosties is available)
sm_jailshop_creditspertime_interval - Time in seconds a player recieved credits per time
sm_jailshop_creditspertime - 0 - disabled, how many credits players receive for 'sm_jailshop_creditspertime_interval'
sm_jailshop_creditspertime_vip - 0 - disabled, how many credits VIP players receive for 'sm_jailshop_creditspertime_interval
sm_jailshop_warmupcredits - 0 - disabled, 1 - enable players get credits on warmup
sm_jailshop_buytime - 0 - disabled, Time in seconds after roundstart shopping is allowed
sm_jailshop_buytime_cells - 0 - disabled, 1 - only shopping until cell doors opened (only if smartjaildoors is available)
sm_jailshop_access - 0 - shop available for guards & prisoner, 1 - only prisoner
sm_jailshop_myjb - 0 - disable shopping on MyJailbreak Event Days, 1 - enable shopping on MyJailbreak Event Days (only if myjb is available, show/gift/... credits is still enabled)
sm_jailshop_close - 0 - disabled, 1 - enable close menu after action

sm_jailshop_cmds_shop - Set your custom chat commands for shop menu(!jailshop (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
sm_jailshop_cmds_gift - Set your custom chat commands for gifting credits(!jailgift (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
sm_jailshop_cmds_revive - Set your custom chat commands for revive(!jailrevive (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
sm_jailshop_cmds_credits - Set your custom chat commands to see you credits (!jailcredits (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
sm_jailshop_cmds_showcredits - Set your custom chat commands for see all online players credits(!showjailcredits (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
    
    sm_jailshop_cmds_shop - Set your custom chat commands for shop menu(!jailshop (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
    sm_jailshop_cmds_gift - Set your custom chat commands for gifting credits(!jailgift (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
    sm_jailshop_cmds_revive - Set your custom chat commands for revive(!jailrevive (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
    sm_jailshop_cmds_credits - Set your custom chat commands to see you credits (!jailcredits (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
    sm_jailshop_cmds_showcredits - Set your custom chat commands for see all online players credits(!showjailcredits (no 'sm_'/'!')(seperate with comma ', ')(max. 12 commands)
    


**Shop Item ConVars**

    
sm_jailshop_openjails_price - 0 - disabled, price of the 'Open jails' shop item (only if smartjaildoors is available)
sm_jailshop_heal_price - 0 - disabled, price of the 'Heal' shop item
sm_jailshop_heal_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only 
sm_jailshop_armor_hp_price - 0 - disabled, price of the 'Armor & HP' shop item
sm_jailshop_health_extra - How many HP get extra with the armor
sm_jailshop_health_extra_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only
sm_jailshop_revive_price - 0 - disabled, price of the 'Revive' shop item
sm_jailshop_heal_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only  
sm_jailshop_vampire_price - 0 - disabled, price of the 'Vampire' shop item
sm_jailshop_vampire_speed - Ratio for how fast the player will walk (1 - normal)
sm_jailshop_vampire_multiplier - Multiplier how many heatlh per damage  (e.g. 100damage * 0.5 = 50HP extra)
sm_jailshop_bhop_price - 0 - disabled, price of the 'Bunny Hop' shop item
sm_jailshop_bhop_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only 
sm_jailshop_froggyjump_price - 0 - disabled, price of the 'Froggy Jump' shop item
sm_jailshop_froggyjump_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only 
sm_jailshop_gravity_price - 0 - disabled, price of the 'Low Gravity' shop item
sm_jailshop_gravity_value - Ratio for Gravity (1.0 earth, 0.5 moon)", _, true, 0.1, true, 1.0);
sm_jailshop_gravity_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only 
sm_jailshop_invisible_price - 0 - disabled, price of the 'Invisible' shop item
sm_jailshop_invisible_time - Time in seconds how long the player is invisible
sm_jailshop_nodamage_price - 0 - disabled, price of the 'NoDamage' shop item
sm_jailshop_nodamage_time - Time in seconds how long the player got nodamage
sm_jailshop_nodamage_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only
sm_jailshop_noclip_price - 0 - disabled, price of the 'No Clip' shop item
sm_jailshop_noclip_time - Time in seconds how long the player has noclip
sm_jailshop_wallhack_price - 0 - disabled, price of the 'Wallhack' shop item (only if CustomPlayerSkins is available)
sm_jailshop_wallhack_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only
sm_jailshop_bird_price - 0 - disabled, price of the 'Be a Bird' shop item
sm_jailshop_bird_mode - 1 - Chicken / 2 - Pigeon / 3 - Crow", _, true, 1.0, true, 3.0);
sm_jailshop_fakeguard_price - 0 - disabled, price of the 'Fake guard model' shop item
sm_jailshop_fakeguard_model - Path to the model for fake guard.
sm_jailshop_teleportsmoke_price - 0 - disabled, price of the 'Teleport smoke' shop item
sm_jailshop_poisonsmoke_price - 0 - disabled, price of the 'Poison smoke' shop item
sm_jailshop_firehe_price - 0 - disabled, price of the 'Fire Grenade' shop item
sm_jailshop_awp_price - 0 - disabled, price of the 'One bullet AWP' shop item
sm_jailshop_deagle_price - 0 - disabled, price of the '7 bullets Deagle' shop item
sm_jailshop_knife_price - 0 - disabled, price of the 'One hit knife' shop item
sm_jailshop_throw_knife_price - 0 - disabled, price of the 'Throwing one hit knife' shop item
sm_jailshop_throw_knife_count - how many knifes a prisoner can throw
sm_jailshop_taser_price - 0 - disabled, price of the '3 bullets Taser' shop item
sm_jailshop_molotov_price - 0 - disabled, price of the 'Molotov & flashs' shop item



***Requires plugins***

* Sourcemod 1.7.0+


***Optional plugins***

* MyJailbreak [](https://github.com/shanapu/MyJailbreak)

* Smart Jail Doors [](https://github.com/Kailo97/smartjaildoors)

* CustomPlayerSkins [](https://forums.alliedmods.net/showthread.php?t=240703)


*Include files needed for compile*[SPOILER]

* autoexecconfig.inc [](https://forums.alliedmods.net/showthread.php?t=204254)

* colors.inc [](https://forums.alliedmods.net/showthread.php?t=96831)

* myjailshop.inc [](https://github.com/shanapu/MyJailShop/blob/master/addons/sourcemod/scripting/include/myjailshop.inc)

* mystocks.inc [](https://github.com/shanapu/MyJailShop/blob/master/addons/sourcemod/scripting/include/mystocks.inc

* myjailbreak.inc [](https://github.com/shanapu/MyJailbreak/blob/master/addons/sourcemod/scripting/include/myjailbreak.inc)

* smartjaildoors.inc [](https://forums.alliedmods.net/showthread.php?p=2306289)

* smlib.inc [](https://github.com/bcserv/smlib)

* CustomPlayerSkins.inc [](https://forums.alliedmods.net/showthread.php?t=240703)



***Installation***


1. Make sure you have the *latest versions* of the **required plugins**
  
1. Download the [latest release]("https://github.com/shanapu/MyJailShop/releases")
  
1. Copy the folders **addons/**&** cfg/** to *your root* **csgo/** directory  
  
1. OPTIONAL need sm_jailshop_mysql "1" 
    * Open *your* ```databases.cfg``` in ```your csgo/addons/sourcemod/configs``` directory and add the following content:
    ```
	"MyJailShop"
    {
        "driver"        "mysql"
        "host"          "127.0.0.1"  //IP to you MySQL server
        "database"      "your_database_name"
        "user"          "your_database_user"
        "pass"          "your_database_password"
    }
	```
  
1. Run plugin for the first time and *all necessary .cfg files will be generated*  
  
1. Configure all settings in *cfg/MyJailShop* to your needs
  
1. Have fun! Give feedback!




***Latest Changes***


**[1.0]** - initial release
  
***Full Change Log:***
[CHANGELOG.md](https://github.com/shanapu/MyJailShop/blob/master/CHANGELOG.md)




***Known Bugs***


* nothing known

[i]you found a bug? tell me please![/i]



***Credits:***
**All credits goes out to the original author [Dkmuniz](https://forums.alliedmods.net/member.php?u=230556)**.
Also thanks to all sourcemod & metamod developers out there!

based/merged/used code/idea plugins:
* [](https://forums.alliedmods.net/showthread.php?t=247917)
* [](https://forums.alliedmods.net/showthread.php?t=269846)
* if I missed someone, please tell me!
* THANK YOU ALL!


###THANKS FOR MAKING FREE SOFTWARE!
*Much Thanks: *
devu4, Weeeishy, Include1, KissLick, live4net for great ideas!



***Download latest stable***
[](https://github.com/shanapu/MyJailShop/releases)
**The smx files on Github are compiled with SM 1.8. 
If you still use 1.7.x you should update your sourcemod or compile MyJailShop for yourself on your SM version**

***Download latest develop***
[](https://github.com/shanapu/MyJailShop/)
**The smx files on develop branch are not uptodate - you have to compile them for yourself.**

***Report Bugs, Ideas, Requests & see todo:***
[](https://github.com/shanapu/MyJailShop/issues)

***Code changes stable:***
[](https://github.com/shanapu/MyJailShop/commits/master)

***Changelogs:***
[](https://github.com/shanapu/MyJailShop/blob/master/CHANGELOG.md)



coded with ![](http://shanapu.de/githearth-small.png) free software

**I would be happy and very pleased if you want to join this project as an equal collaborator. 
Even if you are a beginner and willing to learn or you just want to help with translations.** 



[SIZE="1"]my golden faucets not finance itself...[/SIZE] [ ![](http://shanapu.de/donate.gif)]("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QT8TVRSYWP53J")