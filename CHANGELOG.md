### Change Log
  
**[1.0.1]** - initial release
  
*Added*
 *  new cvar - sm_jailshop_tag - Allow "MyJailShop" to be added to the server tags? So player will find servers with MyJailShop faster. it dont touch you sv_tags
 *  new item: new item paperclips if MyJailBreaks Warden & Handcuffs available
    *  new cvar - sm_jailshop_paperclip_price - 0 - disabled, price of the 'PaperClips' shop item (only if myjb is available)
    *  new cvar - sm_jailshop_paperclip_amount - Amount of paperclips a player get (only if myjb is available)
 *  Support for 3rd party store/shop plugins credit system (use their credits instead myjs credits)
    *  new cvar - sm_jailshop_credits_system - 1 - MyJailShop Credits, 0 - Zephrus store or 'SM Store' or FrozDark shop (need extra support plugin)
    *  new plugin - myjailshop-zephyrus-store.smx - Support plugin for Zephyrus store plugin
    *  new plugin - myjailshop-sm-store.smx - Support plugin for 'sm store' plugin
    *  new plugin - myjailshop-frozdark-shop.smx - Support plugin for FrozDarks shop plugin
 *  RU transaltion - Thx include1!
  
  
  
*Changed*
* Moved 'Be a Bird'-item to end of menu
* Already buyed items are greyed out
  
  
  
*Fixed*
*  Bug color in give/gift chat messages
*  Bug to get more bullets on deagle & awp Thx Jezis
*  Show chat message "You bought..." only to client.
*  Possibility for player to !jailgift credits to themself
*  Show wrong costs on Taser Thx Dkmuniz
*  small typos
  
  
  
*Developer stuff*
*  Natives: Changed all native names by adding MyJailShop_* in front to avoid conflicts with 3rd party plugins
*  Forwards: Changed all forward names by adding MyJailShop_* in front to avoid conflicts with 3rd party plugins
  
  
  
**[1.0.0]** - initial release

### Versioning
for a better understanding:
```
0.7.2  
│ │ └───patch level - fix within major/minior release  
│ └─────minor release - feature/structure added/removed/changed  
└───────major release - stable/release  
```
