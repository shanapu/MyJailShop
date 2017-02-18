### Change Log
  
**[1.3.0]** - Sale, VIP Items & teamgames support
  
*Added*

 * Sale - Discount all items with x percent on a sale - sale end on mapchange
 *  new command - sm_sale - Toggle Sale - discount all items 
 *  new cvars - sm_jailshop_sale_multi - How many percent discount on a sale!
 *  new cvars - sm_jailshop_**ITEMNAME**_flag - Set flag for admin/vip must have to get access to a item. No flag = is available for all players!
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
 *  New builds system - sourcecode on github / binarys at http://shanapu.de/MyJailShop
  
  
  
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
