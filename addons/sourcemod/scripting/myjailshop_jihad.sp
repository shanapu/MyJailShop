/*
 * MyJailShop - Jihad Item Module.
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
#include <autoexecconfig>  // add new cvars to existing .cfg file


// Compiler Options
#pragma semicolon 1
#pragma newdecls required


// ConVars shop specific
ConVar gc_iItemPrice;
ConVar gc_sItemFlag;

// ConVars item specific
ConVar gc_bStandStill;
ConVar gc_fBombRadius;
ConVar gc_sSoundSuicideBomberPath;
ConVar gc_sSoundBoomPath;


// Booleans shop specific
bool g_bItem[MAXPLAYERS+1] = false;

// Booleans item specific


// Integers item specific


// Strings shop specific
char g_sJihadFlag[64];
char g_sPurchaseLogFile[PLATFORM_MAX_PATH];

// Strings item specific
char g_sSoundBoomPath[256];
char g_sSoundSuicideBomberPath[256];

// Handels shop specific
Handle gF_hOnPlayerBuyItem;

// Handels item specific


// Start
public Plugin myinfo =
{
	name = "Jihad for MyJailShop",
	author = "shanapu",
	description = "A Jihad for MyJailShop",
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
	gc_iItemPrice = AutoExecConfig_CreateConVar("sm_jailshop_jihad_price", "20", "Price of the Jihad perk");
	gc_sItemFlag = AutoExecConfig_CreateConVar("sm_jailshop_jihad_flag", "", "Set flag for admin/vip must have to get access to Jihad. No flag = is available for all players!");

	gc_bStandStill = AutoExecConfig_CreateConVar("sm_jailshop_standstill", "1", "0 - disabled, 1 - standstill(cant move) on Activate bomb", _, true, 0.0, true, 1.0);
	gc_fBombRadius = AutoExecConfig_CreateConVar("sm_jailshop_bomb_radius", "200.0", "Radius for bomb damage", _, true, 10.0, true, 999.0);

	gc_sSoundSuicideBomberPath = AutoExecConfig_CreateConVar("sm_jailshop_sounds_jihad", "music/MyJailbreak/suicidebomber.mp3", "Path to the soundfile which should be played on activatebomb.");
	gc_sSoundBoomPath = AutoExecConfig_CreateConVar("sm_jailshop_sounds_boom", "music/MyJailbreak/boom.mp3", "Path to the soundfile which should be played on detonation.");

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
	gc_sItemFlag.GetString(g_sJihadFlag, sizeof(g_sJihadFlag));
	gc_sSoundSuicideBomberPath.GetString(g_sSoundSuicideBomberPath, sizeof(g_sSoundSuicideBomberPath));
	gc_sSoundBoomPath.GetString(g_sSoundBoomPath, sizeof(g_sSoundBoomPath));
	
	PrecacheSoundAnyDownload(g_sSoundSuicideBomberPath);
	PrecacheSoundAnyDownload(g_sSoundBoomPath);
}


// Here we add an new item to shop menu
public void MyJailShop_OnShopMenu(int client, Menu menu)
{
	if (GetClientTeam(client) == CS_TEAM_T)
	{
		char info[64];
		Format(info, sizeof(info), "%t", "shop_menu_jihad", gc_iItemPrice.IntValue);

		if (MyJailShop_GetCredits(client) >= gc_iItemPrice.IntValue && MyJailShop_IsBuyTime() && IsPlayerAlive(client) && CheckVipFlag(client, g_sJihadFlag)) 
			AddMenuItem(menu, "Jihad", info);
		else if (CheckVipFlag(client, g_sJihadFlag)) 
			AddMenuItem(menu, "Jihad", info, ITEMDRAW_DISABLED);
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
			
			if (StrEqual(info, "Jihad"))
			{
				Item_jihad(client, info);
			}
		}
	}

	return;
}


// The item transaction and last checks
void Item_jihad(int client, char[] name)
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

	// give the needed item
	GivePlayerItem(client, "weapon_c4");

	// now we take his money & push the forward
	MyJailShop_SetCredits(client,(MyJailShop_GetCredits(client) - gc_iItemPrice.IntValue));
	Forward_OnPlayerBuyItem(client, name);

	// announce it
	CPrintToChat(client, "%t %t", "shop_tag", "shop_jihad");
	CPrintToChat(client, "%t %t", "shop_tag", "shop_costs", MyJailShop_GetCredits(client), gc_iItemPrice.IntValue);

	// log it
	ConVar c_bLogging = FindConVar("sm_jailshop_log");
	if (c_bLogging.BoolValue)
	{
		LogToFileEx(g_sPurchaseLogFile, "Player %L bought: Jihad", client);
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


public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (!g_bItem[client] || !IsPlayerAlive(client))
		return Plugin_Continue;
	
	if (buttons & IN_USE && buttons & IN_ATTACK)
	{
		int iWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		char weaponName[64];

		if (IsValidEdict(iWeapon))
		{
			GetEdictClassname(iWeapon, weaponName, sizeof(weaponName));

			if (GetClientTeam(client) == CS_TEAM_T)
			{
				if (StrEqual(weaponName, "weapon_c4"))
				{
					EmitSoundToAllAny(g_sSoundSuicideBomberPath);
					CreateTimer(1.0, Timer_DetonateBomb, GetClientUserId(client));
					if (gc_bStandStill.BoolValue)
					{
						SetEntityMoveType(client, MOVETYPE_NONE);
						SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 0.0);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

// Detonate Bomb / Kill Player
public Action Timer_DetonateBomb(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);

	EmitSoundToAllAny(g_sSoundBoomPath);

	float suicide_bomber_vec[3];
	GetClientAbsOrigin(client, suicide_bomber_vec);

	int deathList[MAXPLAYERS+1]; // store players that this bomb kills
	int numKilledPlayers = 0;

	for (int i = 1; i <= MaxClients; i++) if (IsClientInGame(i))
	{
		// Check that client is a real player who is alive and is a CT
		if (IsClientInGame(i) && IsPlayerAlive(i))
		{
			float ct_vec[3];
			GetClientAbsOrigin(i, ct_vec);

			float distance = GetVectorDistance(ct_vec, suicide_bomber_vec, false);

			// If CT was in explosion radius, damage or kill them
			// Formula used: damage = 200 - (d/2)
			int damage = RoundToFloor(gc_fBombRadius.FloatValue - (distance / 2.0));

			if (damage <= 0) // this player was not damaged 
				continue;

			// damage the surrounding players
			int curHP = GetClientHealth(i);

			if (curHP - damage <= 0) 
			{
				deathList[numKilledPlayers] = i;
				numKilledPlayers++;
			}
			else
			{ // Survivor
				SetEntityHealth(i, curHP - damage);
				IgniteEntity(i, 2.0);
			}
		}
	}
	if (numKilledPlayers > 0) 
	{
		for (int i = 0; i < numKilledPlayers;++i)
		{
			ForcePlayerSuicide(deathList[i]);
		}
	}
	ForcePlayerSuicide(client);
}
