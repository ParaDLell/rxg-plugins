 
#include <sourcemod>
#include <sdktools> 
#include <rxgstore> 

#pragma semicolon 1

//-------------------------------------------------------------------------------------------------
public Plugin:myinfo = {
	name = "negev item",
	author = "mukunda",
	description = "disposable negev",
	version = "1.1.0",
	url = "www.mukunda.com"
};

#define ITEM_NAME "negev"
#define ITEM_FULLNAME "negev"
#define ITEMID 3

//-------------------------------------------------------------------------------------------------
public OnPluginStart() {
	RXGSTORE_RegisterItem( ITEM_NAME, ITEMID, ITEM_FULLNAME );
}

//-------------------------------------------------------------------------------------------------
public OnLibraryAdded( const String:name[] ) {
	if( StrEqual( name, "rxgstore" ) ) {
		RXGSTORE_RegisterItem( ITEM_NAME, ITEMID, ITEM_FULLNAME );
	}
}

//-------------------------------------------------------------------------------------------------
public OnPluginEnd() {
	RXGSTORE_UnregisterItem( ITEMID );
}

//-------------------------------------------------------------------------------------------------
public RXGSTORE_OnUse(client) {
	if( !IsPlayerAlive(client) ) return false;
	
	if ( GetTeamScore(2) == 0 && GetTeamScore(3) == 0 ) {
		PrintToChat( client, "\x01 \x02You may not unpack a Negev yet." );
		return false;
	}
	
	PrintToChat( client, "Here is your Negev." );
	GivePlayerItem( client, "weapon_negev" );
	new team = GetClientTeam(client);
	decl String:msg[256];
	FormatEx( msg, sizeof msg, "\01 \x03%N has unpackaged a Negev!", client );
	for( new i = 1; i <= MaxClients; i++ ) {
		if( IsClientInGame(i) && GetClientTeam(i) == team ) {
			PrintToChat( i, msg );
		}
	}
	return true;
}
