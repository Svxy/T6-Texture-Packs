#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/gametypes_zm/_hud_util;

init()
{
	precacheshader("damage_feedback");
	precacheshader("zm_riotshield_tomb_icon");
	precacheshader("zm_riotshield_hellcatraz_icon");
	precacheshader("menu_mp_fileshare_custom");
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		player iprintln("^1Shield Meter Loaded");
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	level endon("end_game");
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		self thread shield_hud();
	}
}

shield_hud()
{
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	shield_text = self createprimaryprogressbartext();
	shield_text setpoint(undefined, "BOTTOM", +205, +15);
	shield_text.hidewheninmenu = 1;
	
	shield_hud = newClientHudElem(self);
	shield_hud.alignx = "right";
	shield_hud.aligny = "bottom";
	shield_hud.horzalign = "user_right";
	shield_hud.vertalign = "user_bottom";
	shield_hud.x -= 175;
	shield_hud.alpha = 0;
	shield_hud.color = ( 1, 1, 1 );
	shield_hud.hidewheninmenu = 1;
	if(getdvar("mapname") == "zm_transit")
	{
		shield_hud setShader("damage_feedback", 32, 32);
	}
	if(getdvar("mapname") == "zm_tomb")
	{
		shield_hud setShader("zm_riotshield_tomb_icon", 32, 32);
	}
	if(getdvar("mapname") == "zm_prison")
	{
		shield_hud setShader("zm_riotshield_hellcatraz_icon", 32, 32);
	}
	

	for(;;)
	{
		if (self hasweapon("riotshield_zm") || self hasweapon("alcatraz_shield_zm") || self hasweapon("tomb_shield_zm") )
		{
			shield_text.alpha = 1;
			shield_hud.alpha = 1;
		}
		else
		{
			shield_text.alpha = 0;
			shield_hud.alpha = 0;
		}
		shield_text setvalue(2250 - self.shielddamagetaken);
		wait 0.05;
		
		if(self.shielddamagetaken >= 2250)
		{
			shield_text.alpha = 0;
		}
	}
}