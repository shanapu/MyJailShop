/*
 * MyJailShop - Freeday Item Module.
 * by: shanapu
 * https://github.com/shanapu/MyJailShop/
 *
 * This file is part of the MyJailShop SourceMod Plugin.
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http:// www.gnu.org/licenses/>.
 */


// Includes
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <emitsoundany>
#include <colors>
#include <mystocks>
#include <myjailshop>
#include <myjbwarden>
#include <autoexecconfig>  // add new cvars to existing .cfg file


// Compiler Options
#pragma semicolon 1
#pragma newdecls required


// ConVars shop specific
ConVar gc_iItemPrice;
ConVar gc_sItemFlag;


// Strings shop specific
char g_sItemFlag[64];
char g_sPurchaseLogFile[PLATFORM_MAX_PATH];


// Handels shop specific
Handle gF_hOnPlayerBuyItem;


// Start
public Plugin myinfo =
{
	name = "Freeday for MyJailShop",
	author = "shanapu",
	description = "Buy a MyJB warden Freeday item for next round",
	version = "1.0",
	url = "https://github.com/shanapu"
};


public void OnPluginStart()
{
	// Translation
	LoadTranslations("MyJailShop.phrases");

	// Add new Convars to existing Items.cfg
	AutoExecConfig_SetFile("Items", "MyJailShop");
	AutoExecConfig_SetCreateFile(true);

	// Register ConVars
	gc_iItemPrice = AutoExecConfig_CreateConVar("sm_jailshop_freeday_price", "5000", "Price of a Freeday");
	gc_sItemFlag = AutoExecConfig_CreateConVar("sm_jailshop_freeday_flag", "", "Set flag for admin/vip must have to get access to freeday. No flag = is available for all players!");

	// Add new Convars to existing Items.cfg
	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

	// Set file for Logs
	SetLogFile(g_sPurchaseLogFile, "purchase", "MyJailShop");
}


public void OnConfigsExecuted()
{
	gc_sItemFlag.GetString(g_sItemFlag, sizeof(g_sItemFlag));
}


// Here we add an new item to shop menu
public void MyJailShop_OnShopMenu(int client, Menu menu)
{
	if (GetClientTeam(client) == CS_TEAM_T)
	{
		char info[64];
		Format(info, sizeof(info), "%t", "shop_menu_freeday", gc_iItemPrice.IntValue);

		if (MyJailShop_GetCredits(client) >= gc_iItemPrice.IntValue && MyJailShop_IsBuyTime() && IsPlayerAlive(client) && CheckVipFlag(client, g_sItemFlag)) 
			AddMenuItem(menu, "Freeday", info);
		else if (CheckVipFlag(client, g_sItemFlag)) 
			AddMenuItem(menu, "Freeday", info, ITEMDRAW_DISABLED);
	}
}


// What should we do when new item was picked?
public void MyJailShop_OnShopMenuHandler(Menu menu, MenuAction action, int client, int itemNum)
{
	if (!IsValidClient(client, false, false))
	{
		return;
	}

	if (action == MenuAction_Select)
	{
		if (MyJailShop_IsBuyTime())
		{
			char info[64];
			menu.GetItem(itemNum, info, sizeof(info));
			
			if (StrEqual(info, "Freeday"))
			{
				Item_Freeday(client, info);
			}
		}
	}

	return;
}


// The item transaction and last checks
void Item_Freeday(int client, char[] name)
{
	// has player enough credits?
	if (MyJailShop_GetCredits(client) < gc_iItemPrice.IntValue)
	{
		CPrintToChat(client, "%t %t", "shop_tag", "shop_missingcredits", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);
		return;
	}

	// now we take his money & push the forward
	MyJailShop_SetCredits(client,(MyJailShop_GetCredits(client) - gc_iItemPrice.IntValue));
	Forward_OnPlayerBuyItem(client, name);

	// here he get the item with native
	warden_freeday_set(client);

	// announce it
	CPrintToChat(client, "%t %t", "shop_tag", "shop_freeday");
	CPrintToChat(client, "%t %t", "shop_tag", "shop_costs", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);

	// log it
	ConVar c_bLogging = FindConVar("sm_jailshop_log");
	if (c_bLogging.BoolValue)
	{
		LogToFileEx(g_sPurchaseLogFile, "Player %L bought: Freeday for next round", client);
	}
}


// Forward MyJailShop_OnPlayerBuyItem
void Forward_OnPlayerBuyItem(int client, char[] item)
{
	Call_StartForward(gF_hOnPlayerBuyItem);
	Call_PushCell(client);
	Call_PushString(item);
	Call_Finish();
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	gF_hOnPlayerBuyItem = CreateGlobalForward("MyJailShop_OnPlayerBuyItem", ET_Ignore, Param_Cell, Param_String);

	return APLRes_Success;
}