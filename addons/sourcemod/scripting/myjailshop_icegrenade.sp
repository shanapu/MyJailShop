/*
 * MyJailShop - IceGrenade Item Module.
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
#include <smartdm>
#include <myjailshop>
#include <autoexecconfig>  // add new cvars to existing .cfg file


#define FREEZE_SOUND "music/MyJailbreak/freeze.mp3"

// Compiler Options
#pragma semicolon 1
#pragma newdecls required

// ConVars shop specific
ConVar gc_iItemPrice;
ConVar gc_sItemFlag;
ConVar gc_iItemOnlyTeam;
ConVar gc_fItemTime;
ConVar gc_fItemRadius;
ConVar gc_sItemModel;
ConVar gc_bItemAffectTeam;


// Strings shop specific
char g_sItemFlag[64];
char g_sItemModel[64];
char g_sPurchaseLogFile[PLATFORM_MAX_PATH];


//Bool
bool g_bItem[MAXPLAYERS+1] = false;
int g_iIceEntity[MAXPLAYERS+1] = -1;

// Handels shop specific
Handle gF_hOnPlayerBuyItem;


// Start
public Plugin myinfo =
{
	name = "Ice Grenade item for MyJailShop",
	author = "shanapu",
	description = "Ice Grenade item for MyJailShop",
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
	gc_iItemPrice = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_price", "1000", "Price of the IceGrenade perk");
	gc_sItemFlag = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_flag", "", "Set flag for admin/vip must have to get access to IceGrenade. No flag = is available for all players!");
	gc_iItemOnlyTeam = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_access", "1", "0 - guards only, 1 - guards & prisoner, 2 - prisoner only", _, true, 0.0, true, 2.0);
	gc_fItemRadius = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_radius", "180", "Radius to freeze?");
	gc_bItemAffectTeam = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_affect", "1", "0 - freeze only guards in radius , 1 - freeze guards & prisoner in radius ", _, true, 0.0, true, 1.0);
	gc_fItemTime = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_time", "12", "How many seconds the IceGrenade freeze?");
	gc_sItemModel = AutoExecConfig_CreateConVar("sm_jailshop_icegrenade_model", "models/spree/spree.mdl", "path to the ice model");

	// Add new Convars to existing Items.cfg
	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

	HookEvent("flashbang_detonate", Event_FlashFlashDetonate, EventHookMode_Pre);

	// Set file for Logs
	SetLogFile(g_sPurchaseLogFile, "purchase", "MyJailShop");
}

public void OnConfigsExecuted()
{
	gc_sItemFlag.GetString(g_sItemFlag, sizeof(g_sItemFlag));
	gc_sItemModel.GetString(g_sItemModel, sizeof(g_sItemModel));

	if (!IsModelPrecached(g_sItemModel))
	{
		PrecacheModel(g_sItemModel);
	}
	Downloader_AddFileToDownloadsTable(g_sItemModel);

	PrecacheSoundAnyDownload(FREEZE_SOUND);
}


// Here we add an new item to shop menu
public void MyJailShop_OnShopMenu(int client, Menu menu)
{
	if ((GetClientTeam(client) == CS_TEAM_CT && gc_iItemOnlyTeam.IntValue <= 1) || (GetClientTeam(client) == CS_TEAM_T && gc_iItemOnlyTeam.IntValue >= 1))
	{
		char info[64];
		Format(info, sizeof(info), "%t", "shop_menu_icegrenade", gc_iItemPrice.IntValue);

		if (MyJailShop_GetCredits(client) >= gc_iItemPrice.IntValue && MyJailShop_IsBuyTime() && IsPlayerAlive(client) && CheckVipFlag(client, g_sItemFlag)) 
			AddMenuItem(menu, "IceGrenade", info);
		else if (CheckVipFlag(client, g_sItemFlag)) 
			AddMenuItem(menu, "IceGrenade", info, ITEMDRAW_DISABLED);
	}
}


// What should we do when new item was picked?
public void MyJailShop_OnShopMenuHandler(Menu menu, MenuAction action, int client, int itemNum)
{
	if (!IsValidClient(client, false, false))
		return;

	if (action == MenuAction_Select)
	{
		if (MyJailShop_IsBuyTime())
		{
			char info[64];
			menu.GetItem(itemNum, info, sizeof(info));
			
			if (StrEqual(info, "IceGrenade"))
			{
				Item_icegrenade(client, info);
			}
		}
	}
}


// The item transaction and last checks
void Item_icegrenade(int client, char[] name)
{
	// is player alive?
	if (!IsPlayerAlive(client))
	{
		CPrintToChat(client, "%t %t", "shop_tag", "shop_alive");
		return;
	}

	// has player enough credits?
	if (MyJailShop_GetCredits(client) < gc_iItemPrice.IntValue)
	{
		CPrintToChat(client, "%t %t", "shop_tag", "shop_missingcredits", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);
		return;
	}

	g_bItem[client] = true;
	GivePlayerItem(client, "weapon_flashbang");

	// now we take his money & push the forward
	MyJailShop_SetCredits(client,(MyJailShop_GetCredits(client) - gc_iItemPrice.IntValue));
	Forward_OnPlayerBuyItem(client, name);

	// announce it
	CPrintToChat(client, "%t %t", "shop_tag", "shop_icegrenade");
	CPrintToChat(client, "%t %t", "shop_tag", "shop_costs", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);

	// log it
	ConVar c_bLogging = FindConVar("sm_jailshop_log");
	if (c_bLogging.BoolValue)
	{
		LogToFileEx(g_sPurchaseLogFile, "Player %L bought: IceGrenade", client);
	}
}

public Action Event_FlashFlashDetonate(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	if (!g_bItem[client])
		return;

	g_bItem[client] = false;

	float DetonateOrigin[3];
	DetonateOrigin[0] = event.GetFloat("x");
	DetonateOrigin[1] = event.GetFloat("y");
	DetonateOrigin[2] = event.GetFloat("z");

	for (int i = 1; i <= MaxClients; i++)
	{
		// Check that client is a real player who is alive and is a CT
		if (IsValidClient(i, true, false))
		{
			if (!gc_bItemAffectTeam.BoolValue && GetClientTeam(i) == CS_TEAM_T)
				continue;

			float vec[3];
			GetClientAbsOrigin(i, vec);

			float distance = GetVectorDistance(vec, DetonateOrigin, false);

			if (RoundToFloor(gc_fItemRadius.FloatValue - (distance / 2.0)) <= 0) // distance to ground zero
				continue;
			
			if (g_iIceEntity[i] > 0)
				continue;

			g_iIceEntity[i] = CreateEntityByName("prop_dynamic_override");

			if (g_iIceEntity[i] == -1)
				return;

			SetEntityModel(g_iIceEntity[i], g_sItemModel);
			SetEntProp(g_iIceEntity[i], Prop_Send, "m_nSolidType", 6);

			TeleportEntity(g_iIceEntity[i], vec, NULL_VECTOR, NULL_VECTOR);
			SetEntityMoveType(i, MOVETYPE_NONE);

			EnableWeaponFire(i, false);

			CreateTimer(gc_fItemTime.FloatValue, Timer_Unfreeze, GetClientUserId(i));
		}
	}

	EmitSoundToAllAny(FREEZE_SOUND);
}

public Action Timer_Unfreeze(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	if (!IsValidClient(client, true, true))
		return Plugin_Handled;

	SetEntityMoveType(client, MOVETYPE_WALK);
	EnableWeaponFire(client);

	if (g_iIceEntity[client] == -1)
		return Plugin_Handled;

	AcceptEntityInput(g_iIceEntity[client], "kill");
	g_iIceEntity[client] = -1;

	return Plugin_Handled;
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
