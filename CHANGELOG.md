### Change Log
  
**[1.4.1.dev]** - DEV
  
*Changed*
 *  Allow admin commands from server console

*Fixed*
 *  Allow OneHit knife with any knife - Thx @hexah
 *  Restrict player commands from server console
  
  
  
**[1.4.0]** - API for custom shop items & some examples
  
*Added*
 *  new item: Random Teleport - teleport to an random prisoner. thx hexer10!
    *  new cvar - sm_jailshop_randomtp - 0 disable, price of the 'Random teleport' shop item
    *  new cvar - sm_jailshop_randomtp_flag - Set flag for admin/vip must have to get accesso to RandomTP. No flag = is avaible for all players!
 *  new shop item as extra plugin: Jetpack - (yes, make your own custom items! without editing MyJailShop.sp - see Developer stuff)
    *  new plugin - myjailshop_jetpack.smx
        *  new cvar - sm_jailshop_jetpack_price - Price of the Jetpack perk
        *  new cvar - sm_jailshop_jetpack_access - 0 - guards only, 1 - guards & prisoner, 2 - prisoner only
        *  new cvar - sm_jailshop_jetpack_flags - Set flag for admin/vip must have to get access to Jetpack. No flag = is available for all players!
        *  new cvar - sm_jailshop_jetpack_reloadtime - Time in seconds to reload JetPack. 0 = One time use, no reload
        *  new cvar - sm_jailshop_jetpack_boost - The amount of boost to apply to JetPack.
        *  new cvar - sm_jailshop_jetpack_angle - The angle of boost to apply to JetPack.
        *  new cvar - sm_jailshop_jetpack_max - Time in seconds of using JetPacks. 
*  new shop item as extra plugin: Jihad
    *  new plugin - myjailshop_jihad.smx
        *  new cvar - sm_jailshop_jihad_price - Price of the Jihad bomb
        *  new cvar - sm_jailshop_jihad_flags - Set flag for admin/vip must have to get access to jihad. No flag = is available for all players!
        *  new cvar - sm_jailshop_standstill - 0 - disabled, 1 - standstill(cant move) on Activate bomb
        *  new cvar - sm_jailshop_bomb_radius - Radius for bomb damage
*  new shop item as extra plugin: ViewDoor - open a door by viewing on it.
    *  new plugin - myjailshop_door.smx
        *  new cvar - sm_jailshop_door_price - Price of the ViewDoor perk
        *  new cvar - sm_jailshop_door_flags - Set flag for admin/vip must have to get access to view door. No flag = is available for all players!
*  new shop item as extra plugin: Blackout - darken the map for some time.
    *  new plugin - myjailshop_blackout.smx
        *  new cvar - sm_jailshop_blackout_price - Price of the Blackout perk
        *  new cvar - sm_jailshop_blackout_flags - Set flag for admin/vip must have to get access to blackout. No flag = is available for all players!
        *  new cvar - sm_jailshop_blackout_time - How many seconds the blackout should be?
  
  
  
*Changed*
 *  Throwing knife no more team damage.
 *  Gravity: new way for Ladderfix
 *  NoClip: autoslay player when stuck.
    *  new cvar - sm_jailshop_noclip_stuck - 0 - disabled / 1 - kill player when stuck after noclip
  
  
  
*Developer stuff*
 * new API to add custom item to shop! take a look to template plugins code of jetpack, jihad, doors & blackout
    *  new forward - MyJailShop_OnShopMenu(int client, Menu menu) - Called after the shop menu is built, but before it's displayed. 
    *  new forward - MyJailShop_OnShopMenuHandler(Menu menu, MenuAction action, int client, int itemNum) - Called once a shop menu item has been selected 
    *  new forward - MyJailShop_OnResetPlayer(int client) -  Called when a client should remove his items 
    *  new native - bool MyJailShop_IsBuyTime() - Is buytime? - can player buy item or is shopping restricted
  
  

**[1.3.0]** - Sale, VIP Items & teamgames support
  
*Added*
 *  Sale - Discount all items with x percent on a sale - sale end on mapchange
    *  new command - sm_sale - Toggle Sale - discount all items 
    *  new cvar - sm_jailshop_sale_multi - How many percent discount on a sale!
 *  new cvar - sm_jailshop_**ITEMNAME**_flag - Set flag for admin/vip must have to get access to a item. No flag = is available for all players!
 *  remove item perks (not the guns/nades) on TeamGames game start.
  
  
  
**[1.2.1]** - fix
  
*Fixed*
 *  bug on using original warden not MyJailbreaks warden 
  
  
  
**[1.2.0]** - 3rd party credits, MyJailbreaks paperclips support & fixes 
  
*Added*
 *  new item: new item paperclips if MyJailBreaks Warden & Handcuffs available
    *  new cvar - sm_jailshop_paperclip_price - 0 - disabled, price of the 'PaperClips' shop item (only if myjb is available)
    *  new cvar - sm_jailshop_paperclip_amount - Amount of paperclips a player get (only if myjb is available)
 *  Support for 3rd party store/shop plugins credit system (use their credits instead myjs credits)
    *  new cvar - sm_jailshop_credits_system - 1 - MyJailShop Credits, 0 - Zephrus store or 'SM Store' or FrozDark shop (need extra support plugin)
    *  new plugin - myjailshop-zephyrus-store.smx - Support plugin for Zephyrus store plugin
    *  new plugin - myjailshop-sm-store.smx - Support plugin for 'sm store' plugin
    *  new plugin - myjailshop-frozdark-shop.smx - Support plugin for FrozDarks shop plugin
 *  new cvar - sm_jailshop_tag - Allow "MyJailShop" to be added to the server tags? So player will find servers with MyJailShop faster. it dont touch you sv_tags
 *  new cvar - sm_jailshop_log - Allow MyJailShop to log purchases and gifts in logs/MyJailShop
 *  new cvar - sm_jailshop_buy_lr - 0 - disabled, 1 - Restrict shopping on last request
 *  new cvar - sm_jailshop_remove_lr - 0 - disabled, 1 - Remove the bought perks on a last request. (bought weapons stay)
 *  RU transaltion - Thx include1!
 *  IT transaltion - Thx Hexer10!
 *  new builds system - sourcecode on github / binarys at http://shanapu.de/MyJailShop
  
  
  
*Changed*
* Moved 'Be a Bird'-item to end of menu
* Already buyed items are greyed out
* When using MyJB, icons will be disabled on invisible, bird & fakeguard
* MyJailbreak: remove players icon above heads on 'fakeguard' & 'be a bird'-items
  
  
  
*Fixed*
*  Ammobug when a player already got a prim/sec weapon and buy deagle or awp
    *  new cvar - sm_jailshop_removeweapon - 0 - disabled, 1 - When a player already got a prim/sec weapon and buy deagle or awp the current weapon disappear
*  Bug color in give/gift chat messages
*  Bug to get more bullets on deagle & awp Thx Jezis
*  Show chat message "You bought..." only to client.
*  Possibility for player to !jailgift credits to themself
*  Show wrong costs on Taser Thx Dkmuniz
*  minor fixes & small typos
  
  
  
*Developer stuff*
*  Natives: Changed all native names by adding MyJailShop_* in front to avoid conflicts with 3rd party plugins
*  Forwards: Changed all forward names by adding MyJailShop_* in front to avoid conflicts with 3rd party plugins
  
  
**[1.1.0]** - skipped
  
**[1.0.0]** - initial release

### Versioning
for a better understanding:
```
0.7.2  
│ │ └───patch level - fix within major/minior release  
│ └─────minor release - feature/structure added/removed/changed  
└───────major release - stable/release  
```
