#include <sourcemod>
#include <cstrike>
#include <clientprefs>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
    name = "[SM] ClanTag hider",
    description = "Strips clantags.",
    author = "B3none",
    version = "1.0.0",
    url = "https://github.com/b3none"
}

public void OnPluginStart()
{
    HookEvent("round_start", OnRoundStartOrEnd);
    HookEvent("round_end", OnRoundStartOrEnd);
    HookEvent("player_spawn", OnPlayerSpawn);
}

public Action OnRoundStartOrEnd(Event event, const char[] name, bool dontBroadcast)
{
    CreateTimer(1.0, ProcessClanTags);
}

public Action OnPlayerSpawn(Handle event, char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(GetEventInt(event, "userid"));

    if (IsValidClient(client))
    {
        ProcessClanTag(client);
    }
}

public void OnClientSettingsChanged(int client)
{
    if (IsClientAuthorized(client))
    {
        ProcessClanTag(client);
    }
}

public Action ProcessClanTags(Handle timer)
{
    for(int i = 0; i <= MaxClients; i++)
    {
        if(IsValidClient(i))
        {
            ProcessClanTag(i);
        }
    }
}

void ProcessClanTag(int client)
{
	char CurrentClanTag[16] = "";
	CS_GetClientClanTag(client, CurrentClanTag, sizeof(CurrentClanTag));

	if(!StrEqual(CurrentClanTag, "VoidReality|"))
    {
		CS_SetClientClanTag(client, "");
    }
}

stock bool IsValidClient(int clientId)
{
    return clientId > 0 && clientId <= MaxClients && IsClientConnected(clientId) && IsClientInGame(clientId);
}
