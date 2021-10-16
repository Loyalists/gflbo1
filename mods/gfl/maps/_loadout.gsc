#include maps\_utility;

init_loadout()
{
	// MikeD (7/30/2007): New method of precaching/giving weapons.
	// Set the level variables.
	if( !IsDefined( level.player_loadout ) )
	{
		level.player_loadout = [];
		level.player_loadout_options = [];
	}

	// CODER MOD
	// With the player joining later now we need to precache all weapons for the level
	init_models_and_variables_loadout();
	
	players = get_players("all");
	for ( i = 0; i < players.size; i++ )
	{
		players[i] give_loadout();
		players[i].pers["class"] = "closequarters";
	}
	level.loadoutComplete = true;
	level notify("loadout complete");
	
	
	//TODO: this is where we add in other player types, besides US Marine
	
	//BJoyal (10/23/09) Added an if check so it only precaches the mptype that is needed
	if( GetDvar( #"zombietron" ) == "1" )
	{
		mptype\player_t5_zt::precache();
	}
	else if( GetDvar( #"zombiemode" ) == "1" || IsSubStr( level.script, "nazi_zombie_" ) || IsSubStr( level.script, "zombie_" ) )
	{
		if ( IsSubStr( level.script, "zombie_pentagon" ) )
		{
			mptype\player_t5_zm_pentagon::precache();
		}
		else if( IsSubStr( level.script, "zombie_theater" ) ) // ww: adding theater
		{
			mptype\player_t5_zm_theater::precache();
		}
		else
		{
			mptype\player_t5_zm::precache();
		}
	}
	/* GLOCKE: 7/7/2010: no 3rd person body in single player
	else if(level.script == "vorkuta")
	{
		mptype\player_t5_vorkuta::precache();
	}
	else
	{
		//GLocke 2/6/10 Changed this to a Carter specific character.
		mptype\player_t5_carter::precache();	
	}	
	*/		
}

init_models_and_variables_loadout()
{
	//-- Global Items that are used in every level --//
	//-- TODO: if the knife ever because unique to each level, remove this and add it to each individual level.
	if ( GetDvar( #"zombiemode" ) == "1" )
	{
		if ( !isDefined(level.zombietron_mode) )
		{
			add_weapon( "knife_zm" );
		}
	}
	else
	{
		if(  level.script == "frontend" 
			|| level.script == "so_narrative1_frontend" 
			|| level.script == "so_narrative2_frontend"
			|| level.script == "so_narrative3_frontend"
			|| level.script == "so_narrative4_frontend"
			|| level.script == "so_narrative5_frontend"
			|| level.script == "so_narrative6_frontend"
			|| level.script == "so_narrative0_frontend"
			|| level.script == "outro" )
		{
		}
		else if( level.script == "flashpoint" )
		{
			add_weapon( "knife_karambit_sp" );
		}
		else
		{
			add_weapon( "knife_sp" );
		}
	}
	
	
	/*
	SCRIPTER_MOD: (GLocke 2/12/09)
	
	FUNCTIONS USED WITHIN LOADOUT
	
	add_weapon( "weapon" );
	set_switch_weapon( "weapon" );
	set_laststand_pistol( "pistol_weapon" );
	set_action_slot( #, "type", "weapon_or_item" );
	set_secondary_offhand( "weapon" );
	
	set_player_viewmodel( "viewmodel" );
	set_player_interactive_hands( "viewmodel" );
	
	OTHER VALUES TO SET:
	
	level.campaign = "nationality";	
	*/
	
	if( level.script == "coop_test1" )
	{
		// SCRIPTER_MOD
		// MikeD (3/16/2007): Testmap for Coop
	
		//-- Kept in as an example
		add_weapon( "m1garand" );
		add_weapon( "thompson" );
		add_weapon( "frag_grenade" );
		set_switch_weapon( "m1garand" );
		
		set_player_viewmodel( "viewmodel_usa_marine_arms");
		set_player_interactive_hands( "viewhands_player_usmc");
		
		level.campaign = "american";
		return;
	}
	if( level.script == "m202_sound_test" )
	{
		// SCRIPTER_MOD
		// MikeD (3/16/2007): Testmap for Coop
	
		//-- Kept in as an example
		add_weapon( "rpg_player_sp" );
		add_weapon( "m202_flash_sp" );
		add_weapon( "strela_sp" );
		add_weapon( "m220_tow_sp" );
		add_weapon( "china_lake_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "rpg_player_sp" );
		
		set_player_viewmodel( "viewmodel_usa_marine_arms");
		set_player_interactive_hands( "viewhands_player_usmc");
		
		level.campaign = "american";
		return;
	}
	// all test maps
	else if( GetSubStr( level.script, 0, 6 ) == "sp_t5_" )
	{
		add_weapon( "m16_sp" );
		add_weapon( "m1911_sp" );
		set_switch_weapon( "m16_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "m16_sp" );
		
		set_player_viewmodel( "viewmodel_usa_cia_camo_arms" );
		set_player_interactive_hands( "viewmodel_usa_cia_camo_arms");
		
		level.campaign = "american";
		return;		
	}
	else if( level.script == "berlin" )
	{
		add_weapon( "frag_grenade_sp" );
		add_weapon( "m1911_silencer_sp" );
		set_switch_weapon( "m1911_silencer_sp" );

		set_laststand_pistol( "m1911_silencer_sp" );

		set_player_viewmodel( "viewmodel_usa_jungmar_arms" );
		set_player_interactive_hands( "viewmodel_usa_jungmar_player");
		set_player_interactive_model( "viewmodel_usa_jungmar_player_fullbody" );

		level.campaign = "american";
		return;		
	}
	else if( level.script == "cuba" )
	{
		add_weapon( "frag_grenade_sp" );
		add_weapon( "asp_sp" );
		
		// M16 - Player starts with this weapon, all the other weapons are preached in cuba.gsc
		PreCacheItem("m16_sp");
		PreCacheItem("m16_acog_sp");
		PreCacheItem("m16_gl_sp");
		PreCacheItem("gl_m16_sp");
		add_weapon("m16_acog_gl_sp");
				
		set_switch_weapon( "m16_acog_gl_sp" );

		set_laststand_pistol( "asp_sp" );

		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );

		level.campaign = "american";
		return;		
	}
	
	else if(  level.script == "frontend" 
			|| level.script == "so_narrative1_frontend" 
			|| level.script == "so_narrative2_frontend"
			|| level.script == "so_narrative3_frontend"
			|| level.script == "so_narrative4_frontend"
			|| level.script == "so_narrative5_frontend"
			|| level.script == "so_narrative6_frontend"
			|| level.script == "so_narrative0_frontend")
	{
		set_laststand_pistol( "none" );

		set_player_viewmodel( "tag_origin");	
		set_player_interactive_hands( "tag_origin");
		set_player_interactive_model("t5_gfl_ump45_viewbody");

		level.campaign = "none";
		return;		
	}	
	
	else if ( level.script == "outro"  )
	{
		set_laststand_pistol( "none" );

		level.campaign = "none";
		return;		
	}	
	
	else if( level.script == "int_escape" )
	{
		add_weapon("interrogation_hands_sp");
		set_switch_weapon( "interrogation_hands_sp" );
	
		set_player_viewmodel( "t5_gfl_ump45_viewmodel");	
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model("t5_gfl_ump45_viewbody");

		level.campaign = "american";
		return;		
	}
	
	else if( level.script == "creek_1" )
	{
		precacheitem( "creek_flashlight_pistol_sp" );
		
		add_weapon( "commando_gl_sp" );
		//add_weapon( "commando_sp" );
		add_weapon( "wa2000_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "commando_gl_sp" );
		//set_switch_weapon( "commando_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody");

		level.campaign = "american";
		return;		
	}

	else if( level.script == "river" )
	{		
		add_weapon( "commando_acog_sp", 13 );  // woodland camo
		add_weapon( "ks23_sp", 13 );
		add_weapon( "frag_grenade_sp" );
		add_weapon( "flash_grenade_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "commando_acog_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");

		level.campaign = "american";
		return;		
	}
	else if( level.script == "in_country" )
	{
		add_weapon( "m16_acog_sp" );
		add_weapon( "m1911_sp" );
		set_switch_weapon( "m16_acog_sp" );

		add_weapon( "frag_grenade_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "m16_acog_sp" );

		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_model( "t5_gfl_ump45_viewbody");

		level.campaign = "american";
		return;		
	}
	else if( level.script == "flashpoint" )
	{
		add_weapon( "mp5k_elbit_extclip_sp", 1 );
		add_weapon( "python_speed_sp" );
		
		set_laststand_pistol( "makarov_sp" );
		set_switch_weapon( "mp5k_elbit_extclip_sp" );
		
		add_weapon( "frag_grenade_sp" );
		add_weapon( "willy_pete_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player" );
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );
						
		level.campaign = "american";
		return;		
	}
	else if (level.script == "hue_city")
	{
		precacheitem( "rpg_sp" );
		precacheitem( "rpk_sp" );
		precacheitem( "commando_sp" );
		precacheitem( "m1911_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		add_weapon( "frag_grenade_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody");
				
		level.campaign = "american";
		return;		
	}
	else if( level.script == "pow" )
	{
		PrecacheItem("ak47_acog_sp");
		PrecacheItem("ak47_dualclip_sp");
		PrecacheItem("ak47_extclip_sp");
		PrecacheItem("ak47_gl_sp");
		PrecacheItem("gl_ak47_sp");
		PrecacheItem("ak47_ft_sp");
		PrecacheItem("ft_ak47_sp");
		
		PrecacheItem("rpk_sp");
		PrecacheItem("rpk_acog_sp");
		PrecacheItem("rpk_extclip_sp");
		
		PrecacheItem("galil_sp");
		
		PrecacheItem("cz75_sp");
		PrecacheItem("cz75_auto_sp");
		PrecacheItem("cz75lh_sp");
		PrecacheItem("cz75dw_sp");
		
		PrecacheItem("rpg_player_sp");

		PrecacheItem("uzi_sp");
		PrecacheItem("uzi_acog_sp");
		PrecacheItem("uzi_extclip_sp");
		PrecacheItem("uzi_grip_sp");

		//-- player weapon loadout
		add_weapon( "cz75_sp" );
		add_weapon( "ak47_sp" );
		add_weapon( "frag_grenade_sp" );
		add_weapon( "flash_grenade_sp" );
		
		//-- player's gun after meatshield
		set_switch_weapon( "ak47_sp" );
		set_laststand_pistol( "cz75_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );
		
		level.campaign = "american";
		return;		
	}
	else if( level.script == "wmd_sr71" )
	{
		add_weapon( "aug_arctic_acog_silencer_sp" );
		add_weapon( "m1911_silencer_sp" );
		
		add_weapon( "frag_grenade_sp" );
		add_weapon( "flash_grenade_sp" );
		set_secondary_offhand( "flash_grenade_sp" );

		set_switch_weapon( "aug_arctic_acog_silencer_sp" );
		
		set_laststand_pistol( "m1911_silencer_sp" );
		
		set_player_interactive_model( "t5_gfl_m16a1_viewbody" );
		set_player_interactive_hands( "t5_gfl_m16a1_viewmodel_player");		
		set_player_viewmodel( "t5_gfl_m16a1_viewmodel" );
		
		level.campaign = "american";
		return;		
	}
	else if( level.script == "wmd" )
	{
		add_weapon( "aug_arctic_acog_silencer_sp" );
		add_weapon( "crossbow_vzoom_alt_sp", 11 );				//11 = camo_winter_siberia, frosty!
		
		add_weapon( "frag_grenade_sp" );
		add_weapon( "flash_grenade_sp" );
		set_secondary_offhand( "flash_grenade_sp" );

		set_switch_weapon( "crossbow_vzoom_alt_sp" );
		
		set_laststand_pistol( "m1911_silencer_sp" );
		
		set_player_interactive_model( "t5_gfl_m16a1_viewbody" );
		set_player_interactive_hands( "t5_gfl_m16a1_viewmodel_player" );		
		set_player_viewmodel( "t5_gfl_m16a1_viewmodel" );
		
		level.campaign = "american";
		return;		
	}
	else if (level.script == "khe_sanh")
	{
		PreCacheItem("m16_sp");
		PreCacheItem("m16_mk_sp");
		PreCacheItem("mk_m16_sp");
		
		add_weapon("m16_mk_sp", 1); //1 == solid_camo_dusty
		add_weapon( "m60_sp" );
		add_weapon( "frag_grenade_sp" );

		set_switch_weapon( "m16_mk_sp" );
		set_laststand_pistol( "none" );

		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );
				
		level.campaign = "american";
		return;		
	}
	else if (level.script == "vorkuta")
	{
		PrecacheItem( "makarov_sp" );
		PrecacheItem( "vorkuta_knife_sp" );
				
		add_weapon( "ak47_sp" );
		add_weapon( "ak47_gl_sp" );
				
		set_switch_weapon( "ak47_sp" );
		set_laststand_pistol( "makarov_sp" );

		add_weapon( "frag_grenade_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );
				
		level.campaign = "russian";
		return;		
	}
	else if( level.script == "pentagon" )
	{
		set_laststand_pistol( "m1911_sp" );
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );
		level.campaign = "american";
		return;
	}
	else if( level.script == "collateral_damage" )
	{
		precacheitem( "commando_acog_sp" );
		precacheitem( "m1911_sp" );
		precacheitem( "frag_grenade_sp" );
		add_weapon( "commando_acog_sp" );
		add_weapon( "m1911_sp" );
		add_weapon( "frag_grenade_sp" );
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "commando_acog_sp" );
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model( "t5_gfl_ump45_viewbody" );
		level.campaign = "american";
		return;		

	}	
	else if( level.script == "fullahead" )
	{
		//add_weapon( "tokarevtt30_sp" );
		add_weapon( "ppsh_sp" );
		add_weapon( "mosin_sp" );
		add_weapon( "frag_grenade_russian_sp" );
		
		set_laststand_pistol( "tokarevtt30_sp" );
		set_switch_weapon( "ppsh_sp" );
		
		// TODO: Reznov viewarms, WWII era russian weapons
		set_player_viewmodel( "t5_gfl_ump40_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump40_viewmodel_player") ;
		set_player_interactive_model( "t5_gfl_ump40_viewbody" );
		level.campaign = "russian";
		return;
	}
	else if( level.script == "kowloon" )
	{
		add_weapon( "cz75dw_sp" );
		add_weapon( "frag_grenade_sp" );
		add_weapon( "flash_grenade_sp" );
		set_secondary_offhand( "flash_grenade_sp" );

		set_laststand_pistol( "cz75_sp" );
		set_switch_weapon( "cz75dw_sp" );
		
		set_player_viewmodel(			"t5_gfl_m16a1_viewmodel" );
		set_player_interactive_hands(	"t5_gfl_m16a1_viewmodel_player") ;
		set_player_interactive_model(	"t5_gfl_m16a1_viewbody" );
						
		level.campaign = "american";
		return;		
	}
	else if( level.script == "interrogation_escape" )
	{
		add_weapon( "m1911_sp" );
		add_weapon( "m16_sp" );
		add_weapon( "frag_grenade_sp" );

		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "m16_sp" );

		// TODO: Reznov viewarms, WWII era russian weapons
		set_player_viewmodel( "t5_gfl_ump45_viewmodel" );
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model("t5_gfl_ump45_viewbody");
		level.campaign = "american";
		return;
	}
	else if( level.script == "rebirth" )
	{
		add_weapon("frag_grenade_sp");
		set_laststand_pistol( "m1911_sp" );
		
		set_player_viewmodel( "t5_gfl_ump45_viewmodel");	//changed to cod4 so ads works - jc
		set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		set_player_interactive_model("t5_gfl_ump45_viewbody");
		level.campaign = "american";
		return;
	}
	else if( level.script == "underwaterbase" )
	{
		add_weapon( "mac11_elbit_extclip_sp" );
		add_weapon( "famas_reflex_dualclip_sp" );
		set_laststand_pistol( "cz75_sp" );
		set_switch_weapon( "famas_reflex_dualclip_sp" );
		
		add_weapon( "frag_grenade_sp" );
		add_weapon( "flash_grenade_sp" );
		set_secondary_offhand( "flash_grenade_sp" );

		set_player_viewmodel( "viewmodel_usa_ubase_arms" );
		set_player_interactive_hands( "viewmodel_usa_ubase_player" );
		set_player_interactive_model( "viewmodel_usa_ubase_fullbody" );
		level.campaign = "american";
		return;
	}
	else if( GetDvar( #"zombiemode" ) == "1" || IsSubStr( level.script, "zombie_" ) ) // CODER_MOD (Austin 5/4/08): zombiemode loadout setup
	{
		if ( !isDefined(level.zombietron_mode) )
		{
			add_weapon( "knife_zm" );
			add_weapon( "m1911_zm" );
			PrecacheItem( "bowie_knife_zm" );
			//set_switch_weapon( "m1911_zm" );
			set_laststand_pistol( "m1911_zm" );
	
			set_player_viewmodel( "t5_gfl_ump45_viewmodel");
			set_player_interactive_hands( "t5_gfl_ump45_viewmodel_player");
		}
		
		level.campaign = "american";
		return;
	}
	else if( IsSubStr( level.script, "intro_" ) ) // Support for the intro movies for the campaigns
	{
		return;
	}
	else if( GetDvar( #"g_gametype" ) == "vs" )
	{
		return;
	}

	//------------------------------------
	// level.script is not a single player level. give default weapons.
	println ("loadout.gsc:     No level listing in _loadout.gsc, giving default guns!!!! =======================");		

	//TODO: Design a specific default loadout
	// default weapons
	//add_weapon( "knife" ); //-- Glocke: MOVED TO TO THE TOP OF THE IF/ELSE BECAUSE EVERY LEVEL NEEDS THE KNIFE
	add_weapon( "m1911_sp" );
	add_weapon( "m16_sp" );
	add_weapon( "frag_grenade_sp" );
	add_weapon( "flash_grenade_sp" );
	set_secondary_offhand( "flash_grenade_sp" );
	
	set_laststand_pistol( "m1911_sp" );
	set_switch_weapon( "m16_sp" );

	// GLOCKE 2/12/2009: don't know what campains we will have, so defaulting everything to american
	// SRS 6/29/2008: updated to allow defaulted maps to have different level.campaign default viewarms
	//if( IsDefined( level.campaign ) && level.campaign == "russian" )
	//{
	//	set_player_viewmodel( "viewmodel_rus_guard_arms");
	//}
	//else
	//{
		set_player_viewmodel( "viewmodel_usa_marine_arms");	//changed to cod4 so ads works - jc
		set_player_interactive_hands( "viewhands_player_usmc");
		set_player_interactive_model("viewmodel_usa_marine_player_legs");
		level.campaign = "american";
	//}
}

// This will precache and set the loadout rather than duplicating work.
add_weapon( weapon_name, options )
{
	PrecacheItem( weapon_name );
	level.player_loadout[level.player_loadout.size] = weapon_name;
	if( !isdefined( options ) )
	{
		options = -1;
	}
	level.player_loadout_options[level.player_loadout_options.size] = options;
}

// This sets the secondary offhand type when the player spawns in
set_secondary_offhand( weapon_name )
{
	level.player_secondaryoffhand = weapon_name;
}

// This sets the the switchtoweapon when the player spawns in
set_switch_weapon( weapon_name )
{
	level.player_switchweapon = weapon_name;
}

// This sets the the action slot for when the player spawns in
set_action_slot( num, option1, option2 )
{
	
	if( num < 2 || num > 4)
	{
		if(level.script != "pby_fly")  // GLocke 11/15/2007 - The flying level uses all 4 dpad slots
		{
			// Not using 1, since it's defaulted to grenade launcher.
			assertmsg( "_loadout.gsc: set_action_slot must be set with a number greater than 1 and less than 5" );
		}
	}
	
	// Glocke 12/03/07 - added precaching of weapon type for action slot
	if(IsDefined(option1))
	{
		if(option1 == "weapon")
		{
			PrecacheItem(option2);
			level.player_loadout[level.player_loadout.size] = option2;
		}
	}

	if( !IsDefined( level.player_actionslots ) )
	{
		level.player_actionslots = [];
	}

	action_slot = SpawnStruct();
	action_slot.num = num;
	action_slot.option1 = option1;

	if( IsDefined( option2 ) )
	{
		action_slot.option2 = option2;
	}

	level.player_actionslots[level.player_actionslots.size] = action_slot;
}

set_player_viewmodel( model )
{
	PrecacheModel( model );
	level.player_viewmodel = model;
}

// Sets the player's hand model used for "interactive" hands and banzai attacks
set_player_interactive_hands( model )
{
	PrecacheModel( model ); 
	level.player_interactive_hands = model;
}

// this one has legs
set_player_interactive_model( model )
{
	PrecacheModel( model ); 
	level.player_interactive_model = model;
}

// Sets the player's laststand pistol
set_laststand_pistol( weapon )
{
	level.laststandpistol = weapon;
}

give_loadout(wait_for_switch_weapon)
{
	if( !IsDefined( game["gaveweapons"] ) )
	{
		game["gaveweapons"] = 0;
	}

	if( !IsDefined( game["expectedlevel"] ) )
	{
		game["expectedlevel"] = "";
	}
	
	if( game["expectedlevel"] != level.script )
	{
		game["gaveweapons"] = 0;		
	}

	if( game["gaveweapons"] == 0 )
	{
		game["gaveweapons"] = 1;
	}

	// MikeD (4/18/2008): In order to be able to throw a grenade back, the player first needs to at
	// least have a grenade in his inventory before doing so. So let's try to find out and give it to him
	// then take it away.
	gave_grenade = false;

	// First check to see if we are giving him a grenade, if so, skip this process.
	for( i = 0; i < level.player_loadout.size; i++ )
	{
		if( WeaponType( level.player_loadout[i] ) == "grenade" )
		{
			gave_grenade = true;
			break;
		}
	}

	// If we do not have a grenade then try to automatically assign one
	// If we can't automatically do this, then the scripter needs to do by hand in the level
	if( !gave_grenade )
	{
		if( IsDefined( level.player_grenade ) )
		{
			grenade = level.player_grenade;
			self GiveWeapon( grenade );
			self SetWeaponAmmoStock( grenade, 0 );
			gave_grenade = true;
		}

		if( !gave_grenade )
		{
			// Get all of the AI and assign any grenade to the player
			ai = GetAiArray( "allies" );
	
			if( IsDefined( ai ) )
			{
				for( i = 0; i < ai.size; i++ )
				{
					if( IsDefined( ai[i].grenadeWeapon ) )
					{
						grenade = ai[i].grenadeWeapon;
						self GiveWeapon( grenade );
						self SetWeaponAmmoStock( grenade, 0 );
						break;
					}
				}
			}
	
			println( "^3LOADOUT ISSUE: Unable to give a grenade, the player need to be given a grenade and then take it away in order for the player to throw back grenades, but not have any grenades in his inventory." );
		}
	}

	for( i = 0; i < level.player_loadout.size; i++ )
	{
		if( isdefined(level.player_loadout_options[i]) && (level.player_loadout_options[i]!=-1) )
		{	
			weaponOptions = self calcweaponoptions( level.player_loadout_options[i] );
			self GiveWeapon( level.player_loadout[i], 0, weaponOptions );
		}
		else
		{
			self GiveWeapon( level.player_loadout[i] );
		}
	}
	
	self SetActionSlot( 1, "" );
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "altMode" );	// toggles between attached grenade launcher
	self SetActionSlot( 4, "" );

	// BJoyal (6/8/09) Changed nightvision to only load during living_battlefield.  
	if( level.script == "living_battlefield" )
	{
		self SetActionSlot( 4, "nightvision" );
	}

	if( IsDefined( level.player_actionslots ) )
	{
		for( i = 0; i < level.player_actionslots.size; i++ )
		{
			num = level.player_actionslots[i].num;
			option1 = level.player_actionslots[i].option1;

			if( IsDefined( level.player_actionslots[i].option2 ) )
			{
				option2 = level.player_actionslots[i].option2;
				self SetActionSlot( num, option1, option2 );
			}
			else
			{
				self SetActionSlot( num, option1 );
			}
		}
	}

	if( IsDefined( level.player_switchweapon ) )
	{
		// the wait was added to fix a revive issue with the host
		// for some reson the SwitchToWeapon message gets lost
		// this can be removed if that is ever resolved
		if ( isdefined(wait_for_switch_weapon) && wait_for_switch_weapon == true )
		{
			wait(0.5);
		}
		self SwitchToWeapon( level.player_switchweapon );
	}
	
	if( GetDvar( #"zombiemode" ) == "0" )
	{
		wait(0.5);
	}
	
	self player_flag_set("loadout_given");
}

give_model( class )
{
	// BJoyal (6/1/09) Used to determine if it is player 1, 2, 3, or 4, to give the appropriate model.
	entity_num = self GetEntityNumber();
	
	if (level.campaign == "none")
	{
		// GLOCKE: 7/7/10 - removed the 3rd person model from SP, shouldn't need to build any of these characters
	}
	else if( GetDvar( #"zombietron" ) == "1" )
	{
		switch( entity_num )
		{
			case 0:
				character\c_usa_sog2_zt::main();				// James, a shirtless white guy
				break;
			case 1:
				//character\c_usa_cia2_zt::main();				// blue construction guy with yellow hat
				character\c_zom_blue_guy_zt::main();
				break;
			case 2:
				//character\c_rus_spetsnaz2_zt::main();		// black guy red shirt
				character\c_zom_red_guy_zt::main();
				break;
			case 3:
				//character\c_vtn_nva2_zt::main();				// yellow astronaut guy sr71 pilot
				character\c_zom_yellow_guy_zt::main();
				break;		
		}
	}
	else if( GetDvar( #"zombiemode" ) == "1" || IsSubStr( level.script, "nazi_zombie_" ) || IsSubStr( level.script, "zombie_" ) )
	{
		if ( IsSubStr( level.script, "zombie_pentagon" ) )
		{
			if( IsDefined( self.zm_random_char ) )
			{
				entity_num = self.zm_random_char;
			}
			
			switch( entity_num )
			{
				case 0:
					character\c_usa_jfk_zt::main(); // JFK
					break;
				case 1:
					character\c_usa_mcnamara_zt::main(); //Mcnamara 
					break;
				case 2:
					character\c_usa_nixon_zt::main(); // Nixon
					break;
				case 3:
					character\c_cub_castro_zt::main(); // Castro
					break;
			}
		}
		else if( IsSubStr( level.script, "zombie_theater" ) )
		{
			if( IsDefined( self.zm_random_char ) )
			{
				entity_num = self.zm_random_char;
			}
			
			switch( entity_num )
			{
				case 0:
					character\c_usa_dempsey_zt::main();// Dempsy
					break;
				case 1:
					character\c_rus_nikolai_zt::main();// Nikolai
					break;
				case 2:
					character\c_jap_takeo_zt::main();// Takeo
					break;
				case 3:
					character\c_ger_richtofen_zt::main();// Richtofen
					break;	
			}
		}
		else
		{
			switch( entity_num )
			{
			case 0:
				character\c_usa_marine_michael_carter_player_zm::main();
				break;
			case 1:
				character\c_usa_marine_michael_carter_player_zm::main();
				break;
			case 2:
				character\c_usa_marine_michael_carter_player_zm::main();
				break;
			case 3:
				character\c_usa_marine_michael_carter_player_zm::main();
				break;		
			}
		}
	}
	
	// MikeD (3/28/2008): If specified, give the player his hands
	if( IsDefined( level.player_viewmodel ) )
	{
		self SetViewModel( level.player_viewmodel );
	}
}

///////////////////////////////////////////////
// SavePlayerWeaponStatePersistent
// 
// Saves the player's weapons and ammo state persistently( in the game variable )
// so that it can be restored in a different map.
// You can use strings for the slot:
// 
// SavePlayerWeaponStatePersistent( "russianCampaign" );
// 
// Or you can just use numbers:
// 
// SavePlayerWeaponStatePersistent( 0 );
// SavePlayerWeaponStatePersistent( 1 ); etc.
// 
// In a different map, you can restore using RestorePlayerWeaponStatePersistent( slot );
// Make sure that you always persist the data between map changes.


// SCRIPTER_MOD: dguzzo: 2-25-09 : need this anymore? level.player is no longer used.
//SavePlayerWeaponStatePersistent( slot )
//{
//	current = level.player getCurrentWeapon();
//	if ( ( !isdefined( current ) ) || ( current == "none" ) )
//		assertmsg( "Player's current weapon is 'none' or undefined. Make sure 'disableWeapons()' has not been called on the player when trying to save weapon states." );
//	game[ "weaponstates" ][ slot ][ "current" ] = current;
//	
//	offhand = level.player getcurrentoffhand();
//	game[ "weaponstates" ][ slot ][ "offhand" ] = offhand;
//	
//	game[ "weaponstates" ][ slot ][ "list" ] = [];
//	weapList = level.player GetWeaponsList();
//	for ( weapIdx = 0; weapIdx < weapList.size; weapIdx++ )
//	{
//		game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ] = weapList[ weapIdx ];
//		
//		// below is only used if we want to NOT give max ammo
//		// game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] = level.player GetWeaponAmmoClip( weapList[ weapIdx ] );
//		// game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] = level.player GetWeaponAmmoStock( weapList[ weapIdx ] );
//	}
//}


// SCRIPTER_MOD: dguzzo: 2-25-09 : need this anymore? level.player is no longer used.
//RestorePlayerWeaponStatePersistent( slot )
//{
//	if ( !isDefined( game[ "weaponstates" ] ) )
//		return false;
//	if ( !isDefined( game[ "weaponstates" ][ slot ] ) )
//		return false;
//
//	level.player takeallweapons();
//			
//	for ( weapIdx = 0; weapIdx < game[ "weaponstates" ][ slot ][ "list" ].size; weapIdx++ )
//	{
//		weapName = game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "name" ];
//
//		if ( isdefined( level.legit_weapons ) )
//		{
//			// weapon doesn't exist in this level
//			if ( !isdefined( level.legit_weapons[ weapName ] ) )
//				continue;
//		}
//		
//		// don't carry over C4
//		if ( weapName == "c4" )
//		{
//			continue;
//		}
//			
//		level.player GiveWeapon( weapName );
//		level.player GiveMaxAmmo( weapName );
//		
//		// below is only used if we want to NOT give max ammo
//		// level.player SetWeaponAmmoClip( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "clip" ] );
//		// level.player SetWeaponAmmoStock( weapName, game[ "weaponstates" ][ slot ][ "list" ][ weapIdx ][ "stock" ] );
//	}
//	
//	if ( isdefined( level.legit_weapons ) )
//	{
//		weapname = game[ "weaponstates" ][ slot ][ "offhand" ];
//		if ( isdefined( level.legit_weapons[ weapName ] ) )
//			level.player switchtooffhand( weapname );
//
//		weapname = game[ "weaponstates" ][ slot ][ "current" ];
//		if ( isdefined( level.legit_weapons[ weapName ] ) )
//			level.player SwitchToWeapon( weapname );
//	}
//	else
//	{
//		level.player switchtooffhand( game[ "weaponstates" ][ slot ][ "offhand" ] );
//		level.player SwitchToWeapon( game[ "weaponstates" ][ slot ][ "current" ] );
//	}
//	
//	return true;
//}
