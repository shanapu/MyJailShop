/*
 * MyJailShop - Parachute Item Module.
 * by: shanapu
 * https://github.com/shanapu/MyJailShop/
 * 
 * used code by zipcore
 * https://gitlab.com/Zipcore/HungerGames/blob/master/addons/sourcemod/scripting/hungergames/tools/parachute.sp
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
#include <autoexecconfig>  // add new cvars to existing .cfg file
#include <smartdm>


// Compiler Options
#pragma semicolon 1
#pragma newdecls required


// ConVars shop specific
ConVar gc_iItemPrice;
ConVar gc_sItemFlag;
ConVar gc_iItemOnlyTeam;
ConVar gc_bWeapon;
ConVar gc_fSpeed;
ConVar gc_sItemModel;


// Strings shop specific
char g_sItemFlag[64];
char g_sPurchaseLogFile[PLATFORM_MAX_PATH];

// Booleans shop specific
bool g_bItem[MAXPLAYERS+1] = false;

// Handels shop specific
Handle gF_hOnPlayerBuyItem;

// Booleans item specific
bool g_bParachute[MAXPLAYERS+1];

// Integer item specific
int g_iParaEntRef[MAXPLAYERS+1] = {INVALID_ENT_REFERENCE, ...};
int g_iVelocity = -1;

char g_sItemModel[64];

// Start
public Plugin myinfo =
{
	name = "Parachute for MyJailShop",
	author = "shanapu, zipcore",
	description = "Buy a parachute",
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
	gc_iItemPrice = AutoExecConfig_CreateConVar("sm_jailshop_parachute_price", "150", "Price of a parachute");
	gc_sItemFlag = AutoExecConfig_CreateConVar("sm_jailshop_parachute_flag", "", "Set flag for admin/vip must have to get access to shield. No flag = is available for all players!");
	gc_iItemOnlyTeam = AutoExecConfig_CreateConVar("sm_jailshop_parachute_access", "1", "0 - guards only, 1 - guards & prisoner, 2 - prisoner only", _, true, 0.0, true, 2.0);
	gc_bWeapon = AutoExecConfig_CreateConVar("sm_jailshop_parachute_shooting", "0", "0 - disabled / 1 - enable shooting while fly with parachute", _, true, 0.0, true, 1.0);
	gc_fSpeed = AutoExecConfig_CreateConVar("sm_jailshop_parachute_fallspeed", "100.0", "max fall speed", _, true, 1.1, true, 1000.0);
	gc_sItemModel = AutoExecConfig_CreateConVar("sm_jailshop_parachute_model", "models/parachute/parachute_carbon.mdl", "path to the parachute model");

	// Add new Convars to existing Items.cfg
	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

	// Set file for Logs
	SetLogFile(g_sPurchaseLogFile, "purchase", "MyJailShop");

	//Hook
	HookEvent("player_death", Event_PlayerDeath);

	//Offset
	g_iVelocity = FindSendPropInfo("CBasePlayer", "m_vecVelocity[0]");
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
}

// Here we add an new item to shop menu
public void MyJailShop_OnShopMenu(int client, Menu menu)
{
	if ((GetClientTeam(client) == CS_TEAM_CT && gc_iItemOnlyTeam.IntValue <= 1) || (GetClientTeam(client) == CS_TEAM_T && gc_iItemOnlyTeam.IntValue >= 1))
	{
		char info[64];
		Format(info, sizeof(info), "%t", "shop_menu_parachute", gc_iItemPrice.IntValue);

		if (MyJailShop_GetCredits(client) >= gc_iItemPrice.IntValue && MyJailShop_IsBuyTime() && IsPlayerAlive(client) && CheckVipFlag(client, g_sItemFlag)) 
			AddMenuItem(menu, "parachute", info);
		else if (CheckVipFlag(client, g_sItemFlag)) 
			AddMenuItem(menu, "parachute", info, ITEMDRAW_DISABLED);
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

			if (StrEqual(info, "parachute"))
			{
				Item_Para(client, info);
			}
		}
	}

	return;
}


// The item transaction and last checks
void Item_Para(int client, char[] name)
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

	// now we take his money & push the forward
	MyJailShop_SetCredits(client,(MyJailShop_GetCredits(client) - gc_iItemPrice.IntValue));
	Forward_OnPlayerBuyItem(client, name);

	// here he get the item with native
	g_bItem[client] = true;

	// announce it
	CPrintToChat(client, "%t %t", "shop_tag", "shop_parachute");
	CPrintToChat(client, "%t %t", "shop_tag", "shop_costs", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);

	// log it
	ConVar c_bLogging = FindConVar("sm_jailshop_log");
	if (c_bLogging.BoolValue)
	{
		LogToFileEx(g_sPurchaseLogFile, "Player %L bought: parachute", client);
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

// Reset item on Player Death
public void Event_PlayerDeath(Handle event, const char [] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (g_bItem[client])
	{
		MyJailShop_OnResetPlayer(client);
	}
}

// Reset item on call
public void MyJailShop_OnResetPlayer(int client)
{
	DisableParachute(client);
	EnableWeaponFire(client);
	g_bItem[client] = false;
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	gF_hOnPlayerBuyItem = CreateGlobalForward("MyJailShop_OnPlayerBuyItem", ET_Ignore, Param_Cell, Param_String);

	return APLRes_Success;
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (!g_bItem[client])
		return Plugin_Continue;

	// Check abort reasons
	if(g_bParachute[client])
	{
		// Abort by released button
		if(!(buttons & IN_USE) || !IsPlayerAlive(client))
		{
			DisableParachute(client);
			return Plugin_Continue;
		}

		// Abort by up speed
		float fVel[3];
		GetEntDataVector(client, g_iVelocity, fVel);

		if(fVel[2] >= 0.0)
		{
			DisableParachute(client);
			return Plugin_Continue;
		}

		// Abort by on ground flag
		if(GetEntityFlags(client) & FL_ONGROUND)
		{
			DisableParachute(client);
			EnableWeaponFire(client);
			return Plugin_Continue;
		}

		// decrease fallspeed
		float fOldSpeed = fVel[2];

		// Player is falling to fast, lets slow him to max gc_fSpeed
		if(fVel[2] < gc_fSpeed.FloatValue * (-1.0))
		{
			fVel[2] = gc_fSpeed.FloatValue * (-1.0);
		}

		// fallspeed changed
		if(fOldSpeed != fVel[2])
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, fVel);

		if(!gc_bWeapon.BoolValue)
		{
			EnableWeaponFire(client, false);
		}
	}
	// Should we start the parashute?
	else if(g_bItem[client])
	{
		// Reject by released button
		if(!(buttons & IN_USE))
			return Plugin_Continue;

		// Reject by on ground flag
		if(GetEntityFlags(client) & FL_ONGROUND)
			return Plugin_Continue;

		// Reject by up speed
		float fVel[3];
		GetEntDataVector(client, g_iVelocity, fVel);

		if(fVel[2] >= 0.0)
			return Plugin_Continue;

		// Open parachute
		int iEntity = CreateEntityByName("prop_dynamic_override");
		DispatchKeyValue(iEntity, "model", g_sItemModel);
		DispatchSpawn(iEntity);

		SetEntityMoveType(iEntity, MOVETYPE_NOCLIP);

		// Teleport to player
		float fPos[3];
		float fAng[3];
		GetClientAbsOrigin(client, fPos);
		GetClientAbsAngles(client, fAng);
		fAng[0] = 0.0;
		TeleportEntity(iEntity, fPos, fAng, NULL_VECTOR);

		// Parent to player
		char sClient[16];
		Format(sClient, 16, "client%d", client);
		DispatchKeyValue(client, "targetname", sClient);
		SetVariantString(sClient);
		AcceptEntityInput(iEntity, "SetParent", iEntity, iEntity, 0);

		g_iParaEntRef[client] = EntIndexToEntRef(iEntity);
		g_bParachute[client] = true;
	}

	return Plugin_Continue;
}

void DisableParachute(int client)
{
	int iEntity = EntRefToEntIndex(g_iParaEntRef[client]);
	if(iEntity != INVALID_ENT_REFERENCE)
	{
		AcceptEntityInput(iEntity, "ClearParent");
		AcceptEntityInput(iEntity, "kill");
	}

	g_bParachute[client] = false;
	g_iParaEntRef[client] = INVALID_ENT_REFERENCE;
}