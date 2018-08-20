/*
 * MyJailShop - Jetpack Item Module.
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
#include <colors>
#include <mystocks>
#include <myjailshop>
#include <autoexecconfig>  // add new cvars to existing .cfg file


// Compiler Options
#pragma semicolon 1
#pragma newdecls required


// ConVars shop specific
ConVar gc_iItemPrice;
ConVar gc_iItemOnlyTeam;
ConVar gc_sItemFlag;

// ConVars item specific
ConVar gc_fJetpackDelay;
ConVar gc_fJetPackBoost;
ConVar gc_fJetPackMax;
ConVar gc_iJetPackAngle;


// Booleans shop specific
bool g_bItem[MAXPLAYERS+1] = false;

// Booleans item specific
bool g_bDelay[MAXPLAYERS+1];


// Integers item specific
int g_iJumps[MAXPLAYERS+1];


// Strings shop specific
char g_sJetpackFlag[64];
char g_sPurchaseLogFile[PLATFORM_MAX_PATH];


// Handels shop specific
Handle gF_hOnPlayerBuyItem;

// Handels item specific
Handle g_hTimer[MAXPLAYERS+1];


// Start
public Plugin myinfo =
{
	name = "Jetpack for MyJailShop",
	author = "shanapu, FrozDark & gubka",
	description = "A jetpack for MyJailShop",
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
	gc_iItemPrice = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_price", "20", "Price of the Jetpack perk");
	gc_iItemOnlyTeam = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_access", "1", "0 - guards only, 1 - guards & prisoner, 2 - prisoner only", _, true, 0.0, true, 2.0);
	gc_sItemFlag = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_flag", "", "Set flag for admin/vip must have to get access to Jetpack. No flag = is available for all players!");
	gc_fJetpackDelay = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_reloadtime", "10", "Time in seconds to reload JetPack. 0 = One time use, no reload", _, true, 1.0);
	gc_fJetPackBoost = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_boost", "500.0", "The amount of boost to apply to JetPack.", _, true, 100.0);
	gc_iJetPackAngle = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_angle", "70", "The angle of boost to apply to JetPack.", _, true, 10.0, true, 80.0);
	gc_fJetPackMax = AutoExecConfig_CreateConVar("sm_jailshop_jetpack_max", "10", "Time in seconds of using JetPacks.", _, true, 0.0);

	// Add new Convars to existing Items.cfg
	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();

	// Set file for Logs
	SetLogFile(g_sPurchaseLogFile, "purchase", "MyJailShop");

	//Hook
	HookEvent("player_death", Event_PlayerDeath);
}


public void OnConfigsExecuted()
{
	gc_sItemFlag.GetString(g_sJetpackFlag, sizeof(g_sJetpackFlag));
}


// Here we add an new item to shop menu
public void MyJailShop_OnShopMenu(int client, Menu menu)
{
	if ((GetClientTeam(client) == CS_TEAM_CT && gc_iItemOnlyTeam.IntValue <= 1) || (GetClientTeam(client) == CS_TEAM_T && gc_iItemOnlyTeam.IntValue >= 1))
	{
		char info[64];
		Format(info, sizeof(info), "%t", "shop_menu_jetpack", gc_iItemPrice.IntValue);

		if (gc_iItemOnlyTeam.IntValue <= 1 && MyJailShop_GetCredits(client) >= gc_iItemPrice.IntValue && MyJailShop_IsBuyTime() && IsPlayerAlive(client) && CheckVipFlag(client, g_sJetpackFlag)) 
			AddMenuItem(menu, "Jetpack", info);
		else if (gc_iItemOnlyTeam.IntValue <= 1 && CheckVipFlag(client, g_sJetpackFlag)) 
			AddMenuItem(menu, "Jetpack", info, ITEMDRAW_DISABLED);
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
			
			if (StrEqual(info, "Jetpack"))
			{
				Item_Jetpack(client, info);
			}
		}
	}

	return;
}


// The item transaction and last checks
void Item_Jetpack(int client, char[] name)
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

	// with this we activate the item itself
	g_bItem[client] = true;  

	// now we take his money & push the forward
	MyJailShop_SetCredits(client,(MyJailShop_GetCredits(client) - gc_iItemPrice.IntValue));
	Forward_OnPlayerBuyItem(client, name);

	// announce it
	CPrintToChat(client, "%t %t", "shop_tag", "shop_jetpack");
	CPrintToChat(client, "%t %t", "shop_tag", "shop_costs", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);

	// log it
	ConVar c_bLogging = FindConVar("sm_jailshop_log");
	if (c_bLogging.BoolValue)
	{
		LogToFileEx(g_sPurchaseLogFile, "Player %L bought: Jetpack", client);
	}

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
	g_bItem[client] = false;  // remove the item in possession

	// remove the item effects
	g_iJumps[client] = 0;
	g_bDelay[client] = false;

	if (g_hTimer[client] != INVALID_HANDLE)
	{
		KillTimer(g_hTimer[client]);
		g_hTimer[client] = INVALID_HANDLE;
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

// Now the item effect themself. Just toggled with g_bItem[client]

/*
//   The following code is based off work(s) by:
//   
//   Despirator / DarkFroz
//   https://forums.alliedmods.net/showthread.php?p=1491181
//   &
//   gubka
//   https://forums.alliedmods.net/showthread.php?p=2369671
*/

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (!g_bItem[client] || !IsPlayerAlive(client) || g_bDelay[client])
		return Plugin_Continue;
	
	if (buttons & IN_JUMP && buttons & IN_DUCK)
	{
		if (0 <= g_iJumps[client] <= gc_fJetPackMax.IntValue)
		{
			if (gc_fJetPackMax.IntValue)
				g_iJumps[client]++;
			
			float ClientEyeAngle[3];
			float ClientAbsOrigin[3];
			float Velocity[3];
			
			GetClientEyeAngles(client, ClientEyeAngle);
			GetClientAbsOrigin(client, ClientAbsOrigin);
			
			float newAngle = gc_iJetPackAngle.FloatValue * -1.0;
			ClientEyeAngle[0] = newAngle;
			GetAngleVectors(ClientEyeAngle, Velocity, NULL_VECTOR, NULL_VECTOR);
			
			ScaleVector(Velocity, gc_fJetPackBoost.FloatValue);
			
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, Velocity);
			
			g_bDelay[client] = true;
			CreateTimer(0.1, Timer_DelayOff, GetClientUserId(client));
			
			CreateEffect(client, ClientAbsOrigin, ClientEyeAngle);
			
			if (g_iJumps[client] == gc_fJetPackMax.IntValue && gc_fJetpackDelay.FloatValue)
			{
				if(gc_fJetpackDelay.FloatValue != 0.0)
				{
					g_hTimer[client] = CreateTimer(gc_fJetpackDelay.FloatValue, Timer_Reload, GetClientUserId(client));
				}
				PrintCenterText(client, "Jetpack Empty");
			}
		}
	}
	return Plugin_Continue;
}

void CreateEffect(int client, float vecorigin[3], float vecangle[3])
{
	vecangle[0] = 110.0;
	vecorigin[2] += 25.0;
	
	char tName[128];
	Format(tName, sizeof(tName), "target%i", client);
	DispatchKeyValue(client, "targetname", tName);
	
	// Create the fire
	char fire_name[128];
	Format(fire_name, sizeof(fire_name), "fire%i", client);
	int fire = CreateEntityByName("env_steam");
	DispatchKeyValue(fire,"targetname", fire_name);
	DispatchKeyValue(fire, "parentname", tName);
	DispatchKeyValue(fire,"SpawnFlags", "1");
	DispatchKeyValue(fire,"Type", "0");
	DispatchKeyValue(fire,"InitialState", "1");
	DispatchKeyValue(fire,"Spreadspeed", "10");
	DispatchKeyValue(fire,"Speed", "400");
	DispatchKeyValue(fire,"Startsize", "20");
	DispatchKeyValue(fire,"EndSize", "600");
	DispatchKeyValue(fire,"Rate", "30");
	DispatchKeyValue(fire,"JetLength", "200");
	DispatchKeyValue(fire,"RenderColor", "255 100 30");
	DispatchKeyValue(fire,"RenderAmt", "180");
	DispatchSpawn(fire);
	
	TeleportEntity(fire, vecorigin, vecangle, NULL_VECTOR);
	SetVariantString(tName);
	AcceptEntityInput(fire, "SetParent", fire, fire, 0);
	
	AcceptEntityInput(fire, "TurnOn");
	
	char fire_name2[128];
	Format(fire_name2, sizeof(fire_name2), "fire2%i", client);
	int fire2 = CreateEntityByName("env_steam");
	DispatchKeyValue(fire2,"targetname", fire_name2);
	DispatchKeyValue(fire2, "parentname", tName);
	DispatchKeyValue(fire2,"SpawnFlags", "1");
	DispatchKeyValue(fire2,"Type", "1");
	DispatchKeyValue(fire2,"InitialState", "1");
	DispatchKeyValue(fire2,"Spreadspeed", "10");
	DispatchKeyValue(fire2,"Speed", "400");
	DispatchKeyValue(fire2,"Startsize", "20");
	DispatchKeyValue(fire2,"EndSize", "600");
	DispatchKeyValue(fire2,"Rate", "10");
	DispatchKeyValue(fire2,"JetLength", "200");
	DispatchSpawn(fire2);
	TeleportEntity(fire2, vecorigin, vecangle, NULL_VECTOR);
	SetVariantString(tName);
	AcceptEntityInput(fire2, "SetParent", fire2, fire2, 0);
	AcceptEntityInput(fire2, "TurnOn");
	
	Handle firedata = CreateDataPack();
	WritePackCell(firedata, fire);
	WritePackCell(firedata, fire2);
	CreateTimer(0.5, Killfire, firedata);
}

public Action Killfire(Handle timer, Handle firedata)
{
	ResetPack(firedata);
	int ent1 = ReadPackCell(firedata);
	int ent2 = ReadPackCell(firedata);
	CloseHandle(firedata);
	
	char classname[256];
	
	if (IsValidEntity(ent1))
	{
		AcceptEntityInput(ent1, "TurnOff");
		GetEdictClassname(ent1, classname, sizeof(classname));
		if (!strcmp(classname, "env_steam", false))
			AcceptEntityInput(ent1, "kill");
	}
	
	if (IsValidEntity(ent2))
	{
		AcceptEntityInput(ent2, "TurnOff");
		GetEdictClassname(ent2, classname, sizeof(classname));
		if (StrEqual(classname, "env_steam", false))
			AcceptEntityInput(ent2, "kill");
	}
}

public Action Timer_DelayOff(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	g_bDelay[client] = false;
}

public Action Timer_Reload(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	if (g_hTimer[client] != INVALID_HANDLE)
	{
		g_iJumps[client] = 0;
		PrintCenterText(client, "Jetpack Reloaded");
		g_hTimer[client] = INVALID_HANDLE;
	}
}