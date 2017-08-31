/*
 * MyJailShop - Store by Zephyrus Support Plugin.
 * by: shanapu
 * https://github.com/shanapu/MyJailShop
 * 
 * Copyright (C) 2016-2017 Thomas Schmidt (shanapu)
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
 * this program.  ifnot, see <http://www.gnu.org/licenses/>.
 */

/******************************************************************************
                   STARTUP
******************************************************************************/

// Includes
#include <sourcemod>
#include <store>
#include <myjailshop>

// Compiler Options
#pragma semicolon 1
#pragma newdecls required

// Info
public Plugin myinfo = 
{
	name = "MyJailShop - Use Credits from Store by Zephyrus",
	author = "shanapu",
	description = "Add Support for Credits from Store by Zephyrus",
	version = "1.0",
	url = "https://github.com/shanapu/MyJailShop"
};

/******************************************************************************
                   FORWARDS LISTEN
******************************************************************************/

public int MyJailShop_OnGetCredits(int client)
{
	int credits = Store_GetClientCredits(client);

	return credits;
}

public void MyJailShop_OnSetCredits(int client, int credits)
{
	Store_SetClientCredits(client, credits);
}