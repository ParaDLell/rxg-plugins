#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <rxgcommon>
#include <tf2_stocks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =  {
	name = "Fire Fix", 
	author = "Dooby Skoo", 
	description = "Fire on any weapon", 
	version = "1", 
	url = "www.reflex-gamers.com"
};

int validWeapons[] =  { 349 };

//-----------------------------------------------------------------------------
public void OnPluginStart() {
	for (int client = 1; client <= MaxClients; client++) {
		if (!IsValidClient(client)) { continue; }
		SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}

//-----------------------------------------------------------------------------
public void OnClientPutInServer(int client) {
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

//-----------------------------------------------------------------------------
public Action OnTakeDamage(int victim, int &attacker, int &inflictor, 
	float &damage, int &damagetype, int &weapon, 
	float damageForce[3], float damagePosition[3], 
	int damagecustom) {
	
	if (!IsValidClient(attacker) || !IsValidClient(victim) || !IsValidEntity(weapon)) { return Plugin_Continue; }
	
	char weapon_classname[64];
	GetEntityClassname(weapon, weapon_classname, sizeof weapon_classname);
	if (strncmp(weapon_classname, "tf_weapon", 9) != 0) { return Plugin_Continue; } // must be a client weapon, not an eyeball boss or something
	
	int index = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
	if (!IntArrayContains(index, validWeapons, sizeof(validWeapons))) {  //checking against item definition index
		return Plugin_Continue;
	}
	
	//TF2_IgnitePlayer(victim, attacker); //attempt 1
	//TF2_AddCondition(victim, TFCond_OnFire, 10.0, attacker); //attempt 2
	TF2_AddCondition(victim, TFCond_Gas, 0.1, attacker); //more conditions can be found in tf2.inc
	return Plugin_Continue;
} 