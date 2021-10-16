/*
	Rebirth: BTR Rail Event - 
		
	The player changes to Hudson and rides a BTR equipped with a grenade launcher through parts of the town

*/

#include maps\_utility;
#include common_scripts\utility; 
#include maps\_vehicle;
#include maps\rebirth_anim;
#include maps\_anim;
#include maps\_vehicle_turret_ai;
#include maps\rebirth_utility;
#include maps\_music;

/*------------------------------------------------------------------------------------------------------------
																								Event:  BTR Rail
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Main event thread.  Controls the flow of the event.  
// Waits for the proper flag to be set to move on.
event_btr_rail() 
{	
	if(level.rebirth_movie == true)
	{
		flag_wait("movie_done");
	}
	
	SetCullDist( 3500 );
	
	player = get_players()[0];
	if(IsDefined(player.player_body))
	{
		player Unlink();
		player.player_body Delete();
		player EnableWeapons();
	}
	level thread maps\_introscreen::introscreen_clear_redacted_flags();
	thread intro_fade();
	thread show_redacted();
	
	//thread maps\createart\rebirth_art::dof_opening();
	maps\createart\rebirth_art::dof_reset();
	level.callbackVehicleDamage = ::rebirth_vehicle_damage;

	maps\rebirth_portals::rb_portals_btr_rail();
	
	maps\createart\rebirth_art::btr_rail_fog();
	VisionSetNaked( "rebirth_btr_rail", 0 );
	
	level thread btr_rail_objectives();
	wait(.05);
	// event functions
	change_to_hudson();
	link_player_to_btr();
	level.is_btr_rail = true;

	battlechatter_on("allies");
	battlechatter_on("axis");
	level thread set_start_enemies();
	level thread player_btr_start_moving();
	level thread weaver_btr_start_moving();
	level thread spawn_enemy_rail_vehicles();
	level thread btr_rail_destructibles();
	level thread btr_rail_dialogue();
	level thread btr_rail_turn_a();
	level thread btr_rail_turn_b();
	level thread btr_rail_turn_c();
	level thread btr_rail_turn_e();
	
	//SOUND - Shawn J
	//iprintlnbold ("notifiez!");
	//array_thread(GetEntArray("rebirth_helicopter", "script_noteworthy "), ::vehicle_toggle_sounds, 1);
	clientnotify ( "bg_battle_notify" ); 
	clientnotify ( "bg_dock_notify" );	
	clientnotify ( "alarms_outside" );	
	player dds_set_player_character_name("hudson");

//	level thread btr_rail_push_car();
	level thread btr_rail_hips();

	level waittill("btr_stopped");
	thread cleanup_btr_triggers();
	thread cleanup_btr_spawners();
	thread cleanup_btr_vehicles();
}

show_redacted()
{
	flag_wait( "takeover_fade_done" );
	level maps\_introscreen::introscreen_redact_delay( &"REBIRTH_HUDSON_INTROSCREEN_1", &"REBIRTH_HUDSON_INTROSCREEN_2", &"REBIRTH_HUDSON_INTROSCREEN_3", &"REBIRTH_HUDSON_INTROSCREEN_4", &"REBIRTH_HUDSON_INTROSCREEN_5" );
	//autosave_by_name("event_btr_rail");
}

intro_fade()
{
	player = get_players()[0];
	
	//TUEY set music to HUDSON_INTRO
	setmusicstate ("HUDSON_INTRO");
	
	if(level.rebirth_movie == false)
	{
		level.black = create_overlay_element( "white", 0 );	
		level.black fadeovertime( 0.01 );
		level.black.alpha = 1;
	}
	
	player FreezeControls( true );
	wait(1);

	hud_string();
	flag_wait( "takeover_fade_clear" );
	
	//black fadeovertime( 4 );
	player FreezeControls( false );
	player SetClientDVAR( "compass", "1" );
	player SetClientDVAR( "hud_showstance", "1" );
	player SetClientDVAR( "actionslotshide" , "0" );
	player SetClientDvar( "ammoCounterHide", "0" );

	SetSavedDvar("cg_hideWeaponHeat", false);
	
	clientNotify ("hudson_start");
	wait 2;
	
 	flag_set( "takeover_fade_done" );
	level.black.alpha = 0;
	level.black Destroy();
	autosave_after_delay( 1, "event_btr_rail" );
}

hud_string()
{
	fade_time = 3;
	hud_string = maps\_hud_util::createFontString( "objective", 1.5 );
	hud_string.sort = 3;
	hud_string.color = (0,0,0);
	hud_string.font = "objective";
	hud_string.horzAlign = "center";
	hud_string.vertAlign = "middle";
	hud_string.alignX = "center"; 
	hud_string.alignY = "middle";
	hud_string.y = -60;	
	hud_string.foreground = true;
	hud_string.fontscale = 1.8;
	hud_string.alpha = 0;
	hud_string setText( &"REBIRTH_BTR_20_TITLE" );
	hud_string FadeOverTime(fade_time);
	hud_string.alpha = 1;
	
	hud_string2 = maps\_hud_util::createFontString( "objective", 1.5 );
	hud_string2.sort = 3;
	hud_string2.color = (0,0,0);
	hud_string2.font = "objective";
	hud_string2.horzAlign = "center";
	hud_string2.vertAlign = "middle";
	hud_string2.alignX = "center"; 
	hud_string2.alignY = "middle";
	hud_string2.y = -33;	
	hud_string2.foreground = true;
	hud_string2.fontscale = 1.8;
	hud_string2.alpha = 0;
	hud_string2 setText( &"REBIRTH_BTR_20_AGENTS" );
	hud_string2 FadeOverTime(fade_time);
	hud_string2.alpha = 1;	
	
	hud_string3 = maps\_hud_util::createFontString( "objective", 1.5 );
	hud_string3.sort = 3;
	hud_string3.color = (0,0,0);
	hud_string3.font = "objective";
	hud_string3.horzAlign = "center";
	hud_string3.vertAlign = "middle";
	hud_string3.alignX = "center"; 
	hud_string3.alignY = "middle";
	hud_string3.y = -6;	
	hud_string3.foreground = true;
	hud_string3.fontscale = 1.8;
	hud_string3.alpha = 0;
	hud_string3 setText( &"REBIRTH_BTR_20_BODY" );	
	hud_string3 FadeOverTime(fade_time);
	hud_string3.alpha = 1;	

	//hud_string maps\_hud_util::setPoint( "BOTTOM", undefined, 0, -150 );

	wait 4;

	hud_string destroy();
	hud_string2 Destroy();
	hud_string3 Destroy();
}

create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	overlay.foreground = true;
	overlay.sort = 2;
	return overlay;
}

show_btr_instructions()
{
	screen_message_create( &"REBIRTH_BTR_HINT_GUN", &"REBIRTH_BTR_HINT_GRENADE" );
	level.player_veh_btr thread player_btr_weapon_overheating();
	wait(4);
	screen_message_delete();	
	screen_message_create( &"REBIRTH_BTR_HINT_ADS" );
	wait(4);
	screen_message_delete();
}

set_start_enemies()
{
	player = get_players()[0];
	start_enemy_trig = GetEnt("btr_rail_guys_start", "script_noteworthy");
	start_enemy_trig UseBy( player );	
}


//------------------------------------
// Change the player to Hudson, warp to BTR
change_to_hudson()
{
	player = get_players()[0];
	player.animname = "hudson";
	
	/*black_bg = NewHudElem(); 
	black_bg.x = 0; 
	black_bg.y = 0; 
	black_bg.alpha = 0; 
	black_bg.horzAlign = "fullscreen"; 
	black_bg.vertAlign = "fullscreen"; 
	black_bg SetShader( "white", 640, 480 ); 

	// Fade out
	black_bg FadeOverTime(1); 
	black_bg.alpha = 1;
	wait(4);*/

	level thread maps\rebirth_mason_lab::lab_clean_up();
	start_teleport( "start_btr_rail", "hudson_hero" );		// TEMP HAX, WARP TO BTR CRASH
	// Fade in
	//black_bg FadeOverTime( 3 ); 
	//black_bg.alpha = 0; 	
}



//------------------------------------
// Link the player to the BTR until the end
link_player_to_btr()
{	
	level.player_viewmodel = "t5_gfl_m16a1_viewmodel";

	player = get_players()[0];
	player SetViewModel(level.player_viewmodel);
	player TakeAllWeapons();
	/* -- moved to when the player is taken off of the btr
	player GiveWeapon( "enfield_ir_mk_sp", 0, 7 );
	player GiveWeapon( "hk21_extclip_sp", 0, 7 );
	player GiveWeapon( "frag_grenade_sp" );
	player GiveWeapon( "knife_sp" );
	player SwitchToWeapon( "enfield_ir_mk_sp" );
	*/

	level.player_veh_btr = getent( "veh_btr_player", "targetname" );

	SetSavedDvar("cg_hideWeaponHeat", true);

	level.player_veh_btr MakeVehicleUsable();	
	level.player_veh_btr UseBy( player );
	level.player_veh_btr MakeVehicleUnusable();

	player thread player_btr_grenade_launcher();
	player thread player_btr_anim_thread();

	// Headlight FX
//	PlayFXOnTag(level._effect["btr_headlight_spot"], level.player_veh_btr, "tag_headlight_left");
	PlayFXOnTag(level._effect["btr_headlight"], level.player_veh_btr, "tag_headlight_left");
	PlayFXOnTag(level._effect["btr_headlight"], level.player_veh_btr, "tag_headlight_right");

	//flag_set("event_btr_player_linked");
	//flag_wait( "takeover_fade_done" );	
}



//------------------------------------
// Start moving the BTR.  Notify the level when it is done
player_btr_start_moving()
{
	player = get_players()[0];

	node_btr_start = getvehiclenode( "hudson_btr_start_node", "targetname" );
	node_btr_end = getvehiclenode( "btr_end_node", "targetname" );
	
	// Start the BTR stopped, start after the wait
	flag_wait("event_btr_rail_start");
	

	
	//TUEY set music state to HUDSON_BTR
	setmusicstate("HUDSON_BTR");
	
	wait( 1 );	

	level.player_veh_btr veh_magic_bullet_shield( true );
	level.player_veh_btr thread go_path( node_btr_start );

	node_btr_end waittill( "trigger" );
	
	level notify( "btr_stopped" );
	
	level.player_veh_btr MakeVehicleUsable();		
	level.player_veh_btr UseBy( player );
	level.player_veh_btr MakeVehicleUnusable();	
	level.player_veh_btr delete();
	
	//-- GLocke: player doesn't needs weapons on BTR and they show up on the d-pad
	weaponOptions = player calcweaponoptions( 7 );
	player GiveWeapon( "enfield_ir_mk_sp", 0, weaponOptions );
	player GiveWeapon( "hk21_extclip_sp", 0, weaponOptions );
	player GiveWeapon( "frag_grenade_sp" );
	player GiveWeapon( "knife_sp" );
	player SwitchToWeapon( "enfield_ir_mk_sp" );
}

//------------------------------------
// Grenade Launcher Thread
player_btr_grenade_launcher()
{
	self endon("death");
	level endon("death");
	level endon("btr_stopped");
	
	player = get_players()[0];//kevin using player to play turret

	fire_timer = 0.0;
	level.player_veh_btr.fired_grenade = false;

	while (true)
	{
		aim_pos = level.player_veh_btr GetTagOrigin("tag_flash_gunner1");
		aim_angles = level.player_veh_btr GetTagAngles("tag_flash_gunner1");
		aim_dir = AnglesToForward(aim_angles);
		aim_pos = aim_pos + aim_dir * 1500;
		//aim_pos = level.player_veh_btr getgunnertargetvec(0);

		level.player_veh_btr SetGunnerTargetVec(aim_pos, 1);

		if( ( self SecondaryOffhandButtonPressed() || self FragButtonPressed() ) && fire_timer <= 0.0 )
		{
			player playsound( "wpn_china_lake_fire_plr" );
			EarthQuake(0.3, 0.25, self.origin, 128);
			level.player_veh_btr.fired_grenade = true;
			level.player_veh_btr FireGunnerWeapon(1);
			fire_timer = 1.0;
			player playsound( "wpn_btr_gl_reload" );
		}

		fire_timer -= 0.05;
		if (fire_timer < 0.0)
		{
			fire_timer = 0.0;
		}
		//IPrintLnBold("Fire Timer: " + fire_timer);

		wait(0.05);
	}
}

//------------------------------------
// Take care of BTR anims ... self == player
player_btr_anim_thread()
{
	self endon("death");
	level endon("death");
	level endon("btr_stopped");

	turret_pos = level.player_veh_btr GetTagOrigin("tag_gunner_turret1");
	turret_angles = level.player_veh_btr GetTagAngles("tag_gunner_turret1");

	barrel_pos = level.player_veh_btr GetTagOrigin("tag_gunner_barrel1");

	link_offset = turret_pos - barrel_pos;

	player_hands = spawn_anim_model("player_hands_hazmat", turret_pos, turret_angles);

	self thread player_btr_anim_thread_left_hand(player_hands);

	player_hands LinkTo(level.player_veh_btr, "tag_gunner_barrel1");
	player_hands SetAnim(level.scr_anim["player_hands_hazmat"]["btr_idle"][0], 1, 0.0, 1);
	
	self thread turret_audio();
	self thread killturret_audio_safely();

	firing = false;

	while (true)
	{
		if (self AttackButtonPressed())
		{
			if (!firing)
			{
				firing = true;

				player_hands SetFlaggedAnimKnob("mg_in", level.scr_anim["player_hands_hazmat"]["btr_mg_fire_in"], 1, 0.0, 1);
				player_hands waittillmatch("mg_in", "end");
				player_hands SetAnimKnob(level.scr_anim["player_hands_hazmat"]["btr_mg_fire_loop"], 1, 0.0, 1);
			}
		}
		else
		{
			if (firing)
			{
				firing = false;

				player_hands SetFlaggedAnimKnob("mg_out", level.scr_anim["player_hands_hazmat"]["btr_mg_fire_out"], 1, 0.0, 1);
				player_hands waittillmatch("mg_out", "end");
				player_hands ClearAnim(level.scr_anim["player_hands_hazmat"]["btr_mg_fire_out"], 0.0);
			}
		}

		wait(0.05);
	}
}

turret_audio()
{
	self endon("death");
	level endon("death");
	level endon("btr_stopped");
	player = get_players()[0];//kevin using player to play turret
	while(1)
	{
		while(!self AttackButtonPressed())
		{
			wait(0.05);
		}
		while(self AttackButtonPressed() && !player isweaponoverheating())
		{
			player playloopsound( "wpn_btr_turret_fire_loop_plr" );
			wait(0.05);
		}
		player stoploopsound();
		if(!player isweaponoverheating())
		{
			player playsound( "wpn_btr_turret_fire_loop_ring_plr" );
		}
		wait(0.05);
	}
}
killturret_audio_safely()
{
	level waittill_any ("death","btr_stopped");
	player = get_players()[0];
	wait_network_frame();
	if (self AttackButtonPressed())
	{
		player stoploopsound();
		player playsound( "wpn_btr_turret_fire_loop_ring_plr" );
	}
	else
	{
		player stoploopsound();
	}
}

player_btr_anim_thread_left_hand(player_hands)
{
	self endon("death");
	level endon("death");
	level endon("btr_stopped");

	while (true)
	{
		if (IsDefined(level.player_veh_btr.fired_grenade) && level.player_veh_btr.fired_grenade)
		{
			player_hands SetFlaggedAnimKnob("grenade_fire", level.scr_anim["player_hands_hazmat"]["btr_grenade_fire"], 1, 0.0, 1);
			player_hands waittillmatch("grenade_fire", "end");
			player_hands ClearAnim(level.scr_anim["player_hands_hazmat"]["btr_grenade_fire"], 0.0);

			level.player_veh_btr.fired_grenade = false;
		}

		wait(0.05);
	}
}

//------------------------------------
// Start moving Weaver's BTR
weaver_btr_start_moving()
{
	level.weaver_veh_btr = getent( "veh_btr_weaver", "targetname" );
	node_btr_start = getvehiclenode( "weaver_btr_start_node", "targetname" );
	weaver_start_shooting = GetVehicleNode("weaver_start_shooting", "targetname");
	weaver_stop_shooting = GetVehicleNode("weaver_stop_shooting", "targetname");

	// Headlight FX
	PlayFXOnTag(level._effect["btr_headlight"], level.weaver_veh_btr, "tag_headlight_left");
	PlayFXOnTag(level._effect["btr_headlight"], level.weaver_veh_btr, "tag_headlight_right");

	// Get Weaver in teh BTR
	weaver = level.heroes[ "weaver" ];

	level thread weaver_btr_anim_thread();

	// Start this BTR stopped, start after the wait
	flag_wait("event_btr_rail_start");

	//wait( 5 );

	trigger_use("btr_rail_allies_move_a");
	
	level.weaver_veh_btr veh_magic_bullet_shield( true );
	level.weaver_veh_btr thread go_path( node_btr_start );

	wait(14.0);

	level.weaver_veh_btr thread enable_turret(1, "grenade_btr", "axis", 4, 5);
	
	weaver_stop_shooting waittill("trigger");
	level.weaver_veh_btr disable_turret(1);
	
	weaver_start_shooting waittill("trigger");
	if(!flag("disable_weaver_turret"))
		level.weaver_veh_btr thread enable_turret(1, "grenade_btr", "axis", 4, 5);

	level.weaver_veh_btr waittill("reached_end_node");
	level.weaver_veh_btr disable_turret(1);
//	level.weaver_veh_btr notify("unload");

	weaver Delete();
	level.weaver_veh_btr Delete();

	weaver_spawner = GetEnt( "weaver", "targetname" );
	weaver_spawner.count++;

	level.heroes[ "weaver" ] = simple_spawn_single(weaver_spawner);
	level.heroes[ "weaver" ].animname = "weaver";

}

//------------------------------------
// Weaver Anim thread
weaver_btr_anim_thread()
{
	//level.weaver_veh_btr anim_single_aligned(level.heroes["weaver"], "btr_talk", "tag_gunner_turret1");
	level.heroes["weaver"] LinkTo(level.weaver_veh_btr, "tag_gunner1");
	level.weaver_veh_btr thread anim_loop_aligned(level.heroes["weaver"], "btr_idle", "tag_gunner1");
	flag_set( "takeover_fade_clear" );//Ok to start fade now that everyone is set
	trigger_wait("btr_rail_turn_c_sm");
	autosave_by_name("btr_first_turn");
	level.weaver_veh_btr anim_single_aligned(level.heroes["weaver"], "btr_motion_left", "tag_gunner1");
	level.weaver_veh_btr thread anim_loop_aligned(level.heroes["weaver"], "btr_idle", "tag_gunner1");

	trigger_wait("btr_rail_parking_lot_sm");

	level.weaver_veh_btr anim_single_aligned(level.heroes["weaver"], "btr_motion_right", "tag_gunner1");
	level.weaver_veh_btr thread anim_loop_aligned(level.heroes["weaver"], "btr_idle", "tag_gunner1");

	flag_wait("event_btr_rail_turn_d");//d_weaver

	level.weaver_veh_btr anim_single_aligned(level.heroes["weaver"], "btr_motion_left", "tag_gunner1");
	level.weaver_veh_btr thread anim_loop_aligned(level.heroes["weaver"], "btr_idle", "tag_gunner1");
}



//------------------------------------
// Controls the spawning of enemy vehicles 
// during the rail
spawn_enemy_rail_vehicles()
{	
	node_heli1_start	= GetVehicleNode( "btr_rail_enemy_heli1_start", "targetname" );
	node_backup 			= GetVehicleNode( "btr_backup", "targetname" );
	veh_heli1					= GetEnt( "btr_rail_enemy_heli1", "targetname" );
	node_heli1				= GetVehicleNode( veh_heli1.target, "targetname" );
	player 						= get_players()[0];
	
	// Start the Helicopter that disables the bridge
	node_heli1_start waittill( "trigger" );
	
	//TUEY sets music to CHOPPER_COMING
	setmusicstate ("CHOPPER_COMING");
	
	veh_heli1 thread fire_for_effect(node_backup);
	veh_heli1 veh_magic_bullet_shield( true );
	level notify("btr_rail_crash_heli_start");
	veh_heli1 rb_heli_spotlight_enable();
	veh_heli1 go_path( node_heli1 );
	veh_heli1 setgunnertargetent( player, (0, 0, 0), 3 );
	veh_heli1 rb_heli_spotlight_enable( true );
}

fire_for_effect(backup_node)
{
	player = get_players()[0];
	behind_node = GetVehicleNode("btr_rail_enemy_heli1_start", "targetname");
	level waittill("heli_fire");
	player magic_bullet_shield();
	shot_offset = (0,0,0);
	time_between_shots = .7;
	num_shots = 4;
	base_offset = 50;
	for(x = 0; x < num_shots; x++)
	{
		PlayFXOnTag( level._effect[ "rocket_muzzleflash" ], self, "tag_rocket_left" );
		MagicBullet("rpg_magic_bullet_sp", self GetTagOrigin("tag_rocket_left"), backup_node.origin + (0,0,base_offset*x));
		PlayFXOnTag( level._effect[ "rocket_muzzleflash" ], self, "tag_rocket_right" );
		MagicBullet("rpg_magic_bullet_sp", self GetTagOrigin("tag_rocket_right"), backup_node.origin + (0,0,base_offset*x));
		wait(time_between_shots);		
		
	}
	PlayFXOnTag( level._effect[ "rocket_muzzleflash" ], self, "tag_rocket_left" );
	MagicBullet("rpg_magic_bullet_sp", self GetTagOrigin("tag_rocket_left"), player.origin + (0,30,0));
	PlayFXOnTag( level._effect[ "rocket_muzzleflash" ], self, "tag_rocket_right" );
	MagicBullet("rpg_magic_bullet_sp", self GetTagOrigin("tag_rocket_right"), player.origin + (0,30,0));	
	wait(.5);
	player ShellShock ("explosion", 4);
	wait(3);
	player stop_magic_bullet_shield();						
}



//------------------------------------
// Set up the destructibles for the rail
btr_rail_destructibles()
{
	// specific destructibles
//	level thread water_tower_fall();
	
	// common destructibles
	destructible_trigs = GetEntArray( "e2_btr_destructible", "targetname" );
	array_thread( destructible_trigs, ::common_destructible );
	
	fueltanks = GetEntArray( "e2_fueltank", "targetname" );
	array_thread( fueltanks, ::fueltank_blowup );	

	// ragdoll launchers
	//explosion_launchers = GetEntArray( "brt_rail_explosion_launcher", "script_noteworthy" );
	//array_thread( explosion_launchers, ::explosion_launcher );

	// destroy the fence the BTR drives through
//	trigger_wait( "btr_through_fence" );
//	fence = GetEnt( "event2_fencefall", "targetname" );
//	fence RotatePitch( 90, .5 );
}



//------------------------------------
// Explodes the fueltanks, adding a radius explosion
fueltank_blowup()
{	
	self waittill( "trigger" );
	boom_struct = getstruct( self.target, "targetname" );
	RadiusDamage( boom_struct.origin, 256, 500, 500, get_players()[0], "MOD_PROJECTILE_SPLASH" );
	PhysicsExplosionSphere( boom_struct.origin, 256, 128, 1 );
	//SOUND - Shawn J
	playsoundatposition ("evt_fuel_tank", boom_struct.origin);
}



//------------------------------------
// deletes the object hit by the grenade 
// A better solution may replace this
common_destructible()
{
//	destroy_ent = GetEnt( self.target, "targetname" );
//	
//	self waittill( "trigger" );
//	
//	destroy_ent Delete();
}

//------------------------------------
// creates an explosion sphere that launches nearby
// ai characters
explosion_launcher()
{
	self endon("death");

	player = get_players()[0];

	while (1)
	{
		self waittill("damage", amount, attacker);

		if (IsDefined(attacker) && attacker == player)
		{
			//IPrintLnBold("Explosion!");

			explosion_launch(self.origin, 256, 50, 150, 15, 25);
			self PhysicsLaunch(self.origin, (0, 0, 2000));
			//PhysicsExplosionSphere( self.origin, 256, 80, 100 );
		}
	}
}

//------------------------------------
// If the tower is hit, drop it
water_tower_fall()
{
	trigger_wait( "water_tower_destroy" );
	
	water_tower = GetEnt( "rb_watertower_destroy", "targetname" );
	water_tower RotateRoll( 90, 3, 1 );
}

//------------------------------------
// VO played from triggers
btr_rail_dialogue()
{
	level waittill("finished final intro screen fadein");//Wait until fade is completed
	wait(1);
	// get actors
	weaver = level.heroes[ "weaver" ];
	hudson = get_players()[0];

	// Intro
	hudson anim_single(hudson, "btr_weaver");
	weaver anim_single(weaver, "go_ahead");

	wait(1.0);

	hudson anim_single(hudson, "research_facility");
	weaver anim_single(weaver, "were_moving");
	flag_set("event_btr_rail_start");

	wait(1);

	hudson anim_single(hudson, "lets_roll");

	friendlies = get_ai_array("btr_rail_friendlies", "script_noteworthy");
	friendlies[0].animname = "redshirt_1";
	friendlies[0] anim_single(friendlies[0], "on_the_move");
	thread show_btr_instructions();
	// Turn A
	trigger_wait("btr_rail_allies_move_a");

	weaver anim_single(weaver, "evacuate");

//	flag_wait("event_btr_rail_rpg_moment");

	hudson anim_single(hudson, "damn_rpgs");

	// turn b
	trigger_wait("btr_rail_turn_c_sm");

	//hudson anim_single(hudson, "massacre");
	//hudson anim_single(hudson, "noone_alive");
	wait(5);
	weaver anim_single(weaver, "hard_right");

	// Turn C
	trigger_wait("btr_through_fence");

	weaver anim_single(weaver, "twelve_oclock");

	flag_wait("event_btr_rail_turn_d");//d_weaver

	weaver anim_single(weaver, "main_drive");
	hudson anim_single(hudson, "understood");

	friendlies_c = get_ai_array("btr_rail_friendlies_c", "script_noteworthy");
	friendlies_c[0].animname = "redshirt_1";
	friendlies_c[1].animname = "redshirt_2";

	friendlies_c[0] anim_single(friendlies_c[0], "were_moving");
	friendlies_c[1] anim_single(friendlies_c[1], "balcony");

	trigger_wait("btr_rail_turn_e");

	friendlies_c[0] anim_single(friendlies_c[0], "on_road");
	friendlies_c[1] anim_single(friendlies_c[1], "inbound");
	hudson anim_single(hudson, "pick_it_up");

	level waittill("btr_rail_crash_heli_start");

	friendlies_c[0] anim_single(friendlies_c[0], "dead_ahead");
	friendlies_c[1] anim_single(friendlies_c[1], "cover");
	friendlies_c[0] anim_single(friendlies_c[0], "locked_on");
	level notify("heli_fire");
	friendlies_c[1] anim_single(friendlies_c[1], "incoming");

	array_delete(friendlies_c);
}


//------------------------------------
// Cleanup any AI left over
btr_rail_cleanup()
{
	flag_wait("event_btr_rail_done");

	btr_enemies = get_ai_array( "btr_rail_enemies", "script_noteworthy" );
	btr_friendlies = get_ai_array( "btr_rail_friendlies", "script_noteworthy" );
	
	for( i = 0; i < btr_enemies.size; i++ )
	{
		btr_enemies[i] Delete();
	}
	
	for( i = 0; i < btr_friendlies.size; i++ )
	{
		btr_friendlies[i] Delete();
	}
}

//------------------------------------
// Thread for making the first turn
btr_rail_turn_a()
{
	trigger_wait("btr_rail_allies_move_a");

	//level thread btr_rail_civ_deaths();//These vignettes were cut

	wait(10);

	spawn_manager_enable("btr_rail_civs_a_manager");
	btr_rail_guys_a = simple_spawn("btr_rail_guys_a", ::kill_trig_watcher, "kill_btr_rail_guys_a");
	btr_rail_guys_a2= simple_spawn("btr_rail_guys_a2", ::kill_trig_watcher, "kill_btr_rail_guys_a");

	trigger_use("btr_rail_turn_a_enemies_color");

	level thread btr_rail_roof_rpg_moment();

	waittill_ai_group_amount_killed( "btr_rail_guys_a", 6 );

	flag_set("event_btr_rail_turn_b");

	trigger_use("btr_rail_turn_b_allies_color");
}

kill_trig_watcher(trig_name, noteworthy)
{
	self endon("death");
	if(IsDefined(noteworthy))
	{
		if(IsDefined(self.script_noteworthy) && self.script_noteworthy == noteworthy)
			self thread btr_runner_spawnerfunc();
	}
	else	
		self disable_replace_on_death();
	trigger_wait(trig_name);
	self DoDamage(self.health + 100, (0,0,0));
}

//------------------------------------
// Thread for making the second turn
btr_rail_turn_b()
{
	trigger_wait("btr_rail_allies_move_b");

	btr_friendlies = get_ai_array( "btr_rail_friendlies", "script_noteworthy" );
	
	for( i = 0; i < btr_friendlies.size; i++ )
	{
		btr_friendlies[i] disable_cqbwalk();
	}
	spawn_manager_enable("btr_rail_civs_b_manager");
	spawn_manager_enable("btr_rail_guys_b_manager");
	spawn_manager_enable("btr_rail_turn_c_sm");
	//btr_rail_guys_b = simple_spawn("btr_rail_guys_b", ::kill_trig_watcher, "btr_rail_turn_c");
	//btr_rail_guys_c = simple_spawn("btr_rail_turn_c_guys", ::kill_trig_watcher, "kill_turn_two");

	trigger_use("btr_rail_turn_b_enemies_color");
}

//------------------------------------
// Thread for making the third
btr_rail_turn_c()
{
	trigger_wait("btr_rail_turn_c");

	level thread btr_rail_enemy_vehicles();
	level thread btr_rail_parking_lot();

	start_allies = get_ai_array("btr_rail_friendlies", "script_noteworthy");
	array_delete(start_allies);

	waittill_ai_group_amount_killed( "btr_rail_jeep_enemies", 8 );

	flag_set("event_btr_rail_turn_d_weaver");
}

btr_parking_lot_kill()
{
	self endon("death");
	trigger_wait("kill_parkinglot_ai");
	self DoDamage(self.health + 100, (0,0,0));
}

//------------------------------------
// Thread for making the last turn
btr_rail_turn_e()
{
	trigger_wait("btr_rail_turn_e");

	house_guys = simple_spawn("btr_rail_house_guys");
	//balcony_guys = simple_spawn("btr_rail_balcony_guys_e");
	spawn_manager_enable("btr_rail_house_guys_manager");
	spawn_manager_enable("btr_rail_balcony_guys_e_manager");

//	wait(3.0);

	trigger_use("sm_btr_rail_guys_e");
}

btr_turn_e_kill()
{
	self endon("death");
	trigger_wait("kill_turn_e");
	self DoDamage(self.health + 100, (0,0,0));
}

//------------------------------------
// Launch Enemy Vehicles
btr_rail_enemy_vehicles()
{
	wait(0.05);

	btr_rail_enemy_vehicles = GetEntArray( "btr_rail_enemy_vehicle", "script_noteworthy" );
	//btr_rail_civ_vehicles = GetEntArray( "brt_rail_explosion_launcher", "script_noteworthy" );
	array_thread( btr_rail_enemy_vehicles, maps\rebirth_btr_rail::btr_rail_enemy_veh_spawnfunc );
	//array_thread( btr_rail_civ_vehicles, maps\rebirth_btr_rail::btr_rail_enemy_veh_spawnfunc );
}

//------------------------------------
// Wait to start flood spawner
btr_rail_parking_lot()
{
	wait(1);

//	trigger_use("sm_btr_rail_guys_c");
//
//	waittill_spawn_manager_cleared("sm_btr_rail_guys_c");

	hip_1 = GetEnt("btr_rail_hip_1", "targetname");
	hip_1 SetJitterParams((0, 0, 0), 1, 2);
	hip_1 SetHoverParams(0,2,1);
	hip_1 waittill("death");
	flag_set("disable_weaver_turret");
	if(IsDefined(level.weaver_veh_btr))
		level.weaver_veh_btr disable_turret(1);//Weaver shoots you during this point too, so shut him down
	//SOUND - Shawn J - no longer needed - gary notetracked the anim.
	//playsoundatposition ("evt_hip_down", (4709, 6664, 797));

	wait(4);

	// level the parking lot...TODO: fire this off when the heli crashes
//	RadiusDamage(hip_1.origin, 1500, 1000, 1000);

	spawn_manager_kill("btr_rail_parking_lot_sm");

	autosave_by_name("turn_d");

	flag_set("event_btr_rail_turn_d");

	wait(0.0);

	Spawn_manager_enable("btr_rail_guys_d2_manager");
	trigger_use("trig_btr_rail_guys_d");
	trigger_use("btr_rail_allies_color_y2");
}

//------------------------------------
// Rooftop RPG guy shoots at an ally near our BTR
btr_rail_roof_rpg_moment()
{
	a = get_ai_array("btr_roof_guy_left", "script_noteworthy");
	rpg_guy = a[0];
	rpg_guy.goalradius = 16;
	rpg_guy set_ignoreall( true );

	rpg_guy waittill("goal");

	wait(0.5);

	target_node = GetNode("btr_rail_rpg_hit", "script_noteworthy");

	// get the guy who is at this node
	node_owner = GetNodeOwner(target_node);
	if (IsDefined(node_owner))
	{
		node_owner stop_magic_bullet_shield();
		node_owner.health = 5000;
	}

	// create start and end positions
	start_pos = rpg_guy.origin + (0, 0, 10);
	end_pos = target_node.origin;
	dir = VectorNormalize(end_pos - start_pos);

	// push the start pos out a bit so rpg guy doesn't shoot himself
	start_pos = start_pos + dir * 25;

	// magic bullet!
	MagicBullet("rpg_pow_sp", start_pos, end_pos);

	flag_set("event_btr_rail_rpg_moment");

	// wait for explosion
	node_owner thread btr_rail_marine_explode(dir);
	
	// stop ignoring
	wait(3.0);

	if (IsAlive(rpg_guy) && IsAI(rpg_guy))
	{
		rpg_guy set_ignoreall(false);
	}
}

btr_rail_marine_explode(dir)
{
	self waittill("damage");

	dir = (dir[0], dir[1], 0);
	force = dir * 150;
	force = force + (0, 0, 150);

	self DoDamage( self.health * 100, self.origin, self, undefined, "explosive" );
	self StartRagdoll( 1 );
	self LaunchRagdoll( force );	
}

//------------------------------------
// First set of civ deaths
// vignette(node, actors, scene_name, loop, thread_type, group_name, auto_delete /* only works for non threaded */, remove_weapons)
btr_rail_civ_deaths()
{
/*	wait(8.0);

	// Get the spawner
	spez_spawner = GetEnt("btr_rail_civ_death_spez", "targetname");
	spez_spawner.count = 20;
	spez_spawner.script_allowdeath = true;

	civ_spawner =  GetEnt("btr_rail_civ_death_civ", "targetname");
	civ_spawner.count = 20;
	civ_spawner.script_allowdeath = true;

	spawners = array(spez_spawner, civ_spawner);*/

	// civ death b
	/*spez_spawner.animname = "civ_death_b_spetz";
	civ_spawner.animname = "civ_death_b_civ";

	vignette("align_civ_death_b", spawners, "civ_death_b", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_btr_rail_guys_a");

	// civ death d
	spez_spawner.animname = "civ_death_d_spetz";
	civ_spawner.animname = "civ_death_d_civ";

	vignette("align_civ_death_d", spawners, "civ_death_d", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_btr_rail_guys_a");

	// civ death e
	spez_spawner.animname = "civ_death_e_spetz";
	civ_spawner.animname = "civ_death_e_civ";

	vignette("align_civ_death_e", sPawners, "civ_death_e", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_btr_rail_guys_a");	

	// civ death f
	spez_spawner.animname = "civ_death_d_spetz";
	civ_spawner.animname = "civ_death_d_civ";

	vignette("align_civ_death_f", spawners, "civ_death_d", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_btr_rail_guys_a");*/

	// Wait for turn B
	trigger_wait("btr_rail_allies_move_b");

	wait(2.0);

	// switch to purple
//	spez_spawner.script_forcecolor = "p";
//	civ_spawner.script_forcecolor = "p";

	// civ death a
	/*spez_spawner.animname = "civ_death_a_spetz";
	civ_spawner.animname = "civ_death_a_civ";

	vignette("align_civ_death_a", spawners, "civ_death_a", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_turn_two");

	// civ death c
	spez_spawner.animname = "civ_death_c_spetz";
	civ_spawner.animname = "civ_death_c_civ";

	vignette("align_civ_death_c", spawners, "civ_death_c", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_turn_two");

	// switch back to blue
//	spez_spawner.script_forcecolor = "b";
//	civ_spawner.script_forcecolor = "b";

	// civ death g
	spez_spawner.animname = "civ_death_b_spetz";
	civ_spawner.animname = "civ_death_b_civ";

	vignette("align_civ_death_g", spawners, "civ_death_b", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_turn_two");

	// civ death h
	spez_spawner.animname = "civ_death_d_spetz";
	civ_spawner.animname = "civ_death_d_civ";

	vignette("align_civ_death_h", spawners, "civ_death_d", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_turn_two");

	// civ death i
	spez_spawner.animname = "civ_death_e_spetz";
	civ_spawner.animname = "civ_death_e_civ";

	vignette("align_civ_death_i", spawners, "civ_death_e", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_turn_two");

	// civ death j
	spez_spawner.animname = "civ_death_d_spetz";
	civ_spawner.animname = "civ_death_d_civ";

	vignette("align_civ_death_j", spawners, "civ_death_d", false, 1, undefined, undefined, undefined, ::kill_trig_watcher, "kill_turn_two");		*/
}

//------------------------------------
// Guys pushing the car into place
btr_rail_push_car()
{
	trigger_wait("btr_rail_turn_e");

	push_car_guys = simple_spawn("btr_rail_push_car_guys");

	align_node = GetStruct("align_btr_rail_push_car", "targetname");

	// play animation on guys
	align_node thread anim_single(push_car_guys, "push");

	// play animation on car
	push_car = spawn_anim_model("push_car", align_node.origin, align_node.angles);

	align_node thread anim_single(push_car, "push");
}

//------------------------------------
// Manage Rail Hips
btr_rail_hips()
{
	trigger_wait("btr_rail_spawn_hip_1");

	wait(0.05);

	hip_1 = GetEnt("btr_rail_hip_1", "targetname");
	hip_1 veh_magic_bullet_shield( true );
	hip_1.health = 1;

	level.vehicle_death_thread[hip_1.vehicletype] = ::btr_rail_hip_1_crash;

	hip_1 thread btr_rail_hip_1_think();

	hip_1 waittill("reached_end_node");
	hip_1 veh_magic_bullet_shield( false );
}

//------------------------------------
// Hip think function
btr_rail_hip_1_think()
{
	self endon("death");
	self thread rappel_watcher();
	self waittill("reached_end_node");
	self SetVehGoalPos(self.origin, 1);

	look_at = spawn("script_origin", self.origin + AnglesToForward(self.angles) * 500);
	self SetLookAtEnt(look_at);

	//rappel_struct_left = SpawnStruct();
	rappel_struct_left = Spawn("script_origin", (0,0,0));
	rappel_struct_left.origin = self GetTagOrigin("tag_enter_gunner");
	rappel_struct_left.targetname = "btr_rail_hip_1_rappel_left";

	//rappel_struct_right = SpawnStruct();
	rappel_struct_right = Spawn("script_origin", (0,0,0));
	

	// project the delta vector from the origin to the left struct pos onto the right vector
	delta = rappel_struct_left.origin - self.origin;
	dist = Abs(VectorDot(delta, AnglesToRight(self.angles)));

	// move the right struct to the exact spot on the other side
	rappel_struct_right.origin = rappel_struct_left.origin + AnglesToRight(self.angles) * (2.0 * dist);
	rappel_struct_right.targetname = "btr_rail_hip_1_rappel_right";

	rappel_spawner = GetEnt("btr_rail_hip_lot_rappellers", "targetname");
	rappel_spawner.count = 15;

	num_guys = 4;
	create_rope = true;
	while (num_guys > 0)
	{
		new_guy_left = simple_spawn_single("btr_rail_hip_lot_rappellers");
		new_guy_left.target = "btr_rail_hip_1_rappel_left";
		new_guy_left thread maps\_ai_rappel::start_ai_rappel(2, rappel_struct_left, create_rope, false);
		new_guy_left thread rappel_watch_heli_destroyed();

		wait(RandomFloatRange(0.25, 0.5));

		new_guy_right = simple_spawn_single("btr_rail_hip_lot_rappellers");
		new_guy_right.target = "btr_rail_hip_1_rappel_left";
		new_guy_right thread maps\_ai_rappel::start_ai_rappel(2, rappel_struct_right, create_rope, false);
		new_guy_right thread rappel_watch_heli_destroyed();

		create_rope = false;
		num_guys--;

		wait(RandomFloatRange(1.5, 2.0));
	}
	self thread parkinglot_heli_attack();
}

rappel_watcher()
{
	self waittill("damage");
	self notify("rappel_done");
}

rappel_watch_heli_destroyed()
{
	level waittill( "hip_crash_begin" );
	self notify( "stop_rappel" );
}

parkinglot_heli_attack()
{
	self endon("death");
	player = get_players()[0];
	player endon("death");
	face_here = GetVehicleNode("parkinglot_heli_end_node", "targetname");
	face_forward = AnglesToForward( face_here.angles ) * 10;
	level.p_heli_face = Spawn("script_origin", face_here.angles + face_forward);
	weaver_btr = GetEnt("veh_btr_weaver", "targetname");
	self SetLookAtEnt( weaver_btr );
	self thread rb_heli_fire_side_gun(weaver_btr, 6);
	self thread rb_heli_fire_rockets(weaver_btr, 3);
	wait(6);
	self SetLookAtEnt( player );
	self notify("stop_firing");
	self notify("fire_rockets");
	self thread rb_heli_fire_side_gun(player, 5);
	wait( 1 );
	self rb_heli_fire_rockets(player, .5);
	/*wait(1);
	self notify("fire_rockets");*/
}

//------------------------------------
// Hip Crash Thread
btr_rail_hip_1_crash()
{
	if (IsDefined(self.targetname) && self.targetname != "btr_rail_hip_1")
	{
		return;
	}
	level notify( "hip_crash_begin" );
	//self SetLookAtEnt( level.p_heli_face );
	//wait(.1);
	level.crash_heli = spawn_anim_model("crash_heli", self.origin, self.angles);
	anim_struct = getstruct( "crash_heli_align_pos", "targetname" );
	
	rotor_pos = level.crash_heli GetTagOrigin("main_rotor_jnt");
	rotor_angles = level.crash_heli GetTagAngles("main_rotor_jnt");

	level.crash_heli.rotor_ent = spawn("script_model", rotor_pos);
	level.crash_heli.rotor_ent.angles = rotor_angles;
	level.crash_heli.rotor_ent SetModel("tag_origin");
	level.crash_heli.rotor_ent LinkTo(level.crash_heli, "main_rotor_jnt");
	
	//-- GLocke: make sure that the ropes delete
	rappel_struct_right = GetEnt("btr_rail_hip_1_rappel_right", "targetname");
	rappel_struct_left = GetEnt("btr_rail_hip_1_rappel_left", "targetname");
	rappel_struct_right notify("stop_rappel"); 
	rappel_struct_left notify("stop_rappel"); 
	self notify("stop_rappel"); 
	self notify("nodeath_thread");
	self Delete();

	level.crash_heli moveto( anim_struct.origin, .3 );
	level.crash_heli waittill( "movedone" );
	
	PlayFXOnTag(level._effect["heli_rotors"], level.crash_heli.rotor_ent, "tag_origin");
	PlayFXOnTag(level._effect["hip_crash_exp_impact"], level.crash_heli.rotor_ent, "tag_origin");

	anim_struct thread anim_single_aligned(level.crash_heli, "crash");

	wait(0.5);

	PlayFXOnTag(level._effect["hip_crash_smoke"], level.crash_heli.rotor_ent, "tag_origin");
}

//------------------------------------
// Hip Crash Initial impact
btr_rail_hip_1_crash_impact(guy)
{
	PlayFXOnTag(level._effect["hip_crash_impact01"], level.crash_heli.rotor_ent, "tag_origin");
}

//------------------------------------
// Hip Crash Rotors Hit Ground
btr_rail_hip_1_crash_rotor_hit(guy)
{
	level notify("heli01_chunks_start");
}

//------------------------------------
// Hip Crash Rotors Swap
btr_rail_hip_1_crash_rotor_swap(guy)
{
	rotors = GetEnt("fxanim_rebirth_heli01_rotor_mod", "targetname");
	rotors LinkTo(level.crash_heli, "main_rotor_jnt");

	level notify("heli01_rotor_start");

	level.crash_heli.rotor_ent delete();
	
	level waittill( "heli_explode" );
	rotors Delete();
}

//------------------------------------
// Hip Crash Explode
btr_rail_hip_1_crash_explode(guy)
{
	level notify( "heli_explode" );
	level.crash_heli SetModel("t5_veh_helo_mi8_woodland_dead");
	
	explosion_launch(level.crash_heli.origin, 256, 50, 150, 15, 25);
}


/*------------------------------------------------------------------------------------------------------------
																								Objectives
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Update objectives and objective markers
btr_rail_objectives()
{
	flag_wait("event_btr_rail_start");

	Objective_Add( level.obj_iterator, "current", &"REBIRTH_OBJECTIVE_2", (0, 0, 0) );
}



/*------------------------------------------------------------------------------------------------------------
																								Spawn Functions
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Have AI ignore the player until they reach
// their nodes
btr_rail_spawnfunc( radius )
{
	if (IsDefined(radius))
	{
		self.goalradius = radius;
	}

	self set_ignoreall( true );
	self waittill( "goal" );
	self set_ignoreall( false );
}

btr_rail_friendlies_start()
{
	self endon("death");
	self set_ignoreall( true );
	flag_wait("event_btr_rail_start");
	self set_ignoreall( false );
}

btr_starting_enemy()
{
	self gun_remove();
	self endon("death");
	self set_ignoreall( true );
	self DoDamage(self.health + 100, (0,0,0));
}

//------------------------------------
// Have allies do cqb walk during the intro to the rail
// their nodes
btr_rail_friendlies_spawnfunc( ignoreall, cqb )
{
	self set_ignoreall(ignoreall);

	if (cqb)
	{
		self enable_cqbwalk();
	}
	self magic_bullet_shield();
	self.grenadeAwareness = 0;
}

//------------------------------------
// Launch Vehicles!
btr_rail_enemy_veh_spawnfunc( )
{
	//self endon("death");

	self waittill("death");

	//player = get_players()[0];
	//while (1)
	//{
	//	self waittill("damage", amount, attacker);
	//	IprintlnBold("Launch!!");

	//	new_health = self.health - amount;
	//	if (new_health < 0 && attacker == player)
	//	{
			//self DoDamage( self.health * 100, self.origin, self, undefined, "explosive" );
			explosion_launch(self.origin, 256, 50, 150, 15, 25);
			self btr_grenade_hit();
//		}
//	}
}

//------------------------------------
// Force throw a molotov at the player
btr_rail_molotov_thrower_spawnfunc(target)
{
	self endon("death");
	wait(RandomFloatRange(5, 6));

	//random_angle = target.angles[1] + RandomIntRange(0, 20);
	random_angle = target.angles + (RandomIntRange(-3, 3),RandomIntRange(0, 3),RandomIntRange(-3, 3));
	//offset_dir = AnglesToForward((0, random_angle, 0));
	offset_dir = AnglesToForward(random_angle);

	target_pos = target.origin + offset_dir * RandomIntRange(30,40);

	self maps\_grenade_toss::force_grenade_toss( target_pos, "molotov_sp" );
}

btr_rail_molotov_player_spawnfunc(target)
{
	self endon("death");
	molotov_target_1 = GetStruct( "btr_rail_molotov_target_1", "targetname" );
	btr = GetEnt("veh_btr_player", "targetname");
	wait(6);
	offset_dir = AnglesToForward(molotov_target_1.angles);

	target_pos = molotov_target_1.origin + offset_dir * 30;
	self maps\_grenade_toss::force_grenade_toss( target_pos, "molotov_sp" );
	wait(2);
	firefx = PlayFXOnTag(level._effect["btr_hood_fire"], btr, "tag_origin");
}

//------------------------------------
// Guys running to the parking lot
btr_rail_turn_c_guys_spawnfunc()
{
	self endon("death");
	self thread kill_trig_watcher("kill_turn_two");
	/*self.ignoreall = true;
	self.goalradius = 128;
	self SetGoalPos(pos);
	self waittill("goal");
	self.ignoreall = false;*/
}

/*------------------------------------------------------------------------------------------------------------
	Ragdoll Explosion
------------------------------------------------------------------------------------------------------------*/
guy_explosion_launch(org, force)
{
	self StopAnimScripted();
	self.force_gib = true;
	self DoDamage( self.health * 100, org, self, undefined, "explosive" );
	self StartRagdoll( 1 );
	self LaunchRagdoll( force );
}

explosion_launch(org, radius, min_force, max_force, min_launch_angle, max_launch_angle)
{
	allies = GetAIArray("allies");
	axis = GetAIArray("axis");

	ai_array = array_merge(allies, axis);

	radiusSquared = radius * radius;
	for (i = 0; i < ai_array.size; i++)
	{
		is_hero = IsDefined(ai_array[i].script_hero) && (ai_array[i].script_hero == 1);

		if (IsDefined(ai_array[i]) && !IsGodMode(ai_array[i]) && !is_hero)
		{
			distSquared = Distance2DSquared(org, ai_array[i].origin);
			if (distSquared < radiusSquared)
			{
				dir = ai_array[i].origin - org;
				dir = (dir[0], dir[1], 0);
				dir = VectorNormalize(dir);
				launch_angles = VectorToAngles(dir);

				launch_pitch = linear_map(distSquared, 0, radiusSquared, min_launch_angle, max_launch_angle);
				launch_pitch = launch_pitch * -1;
				launch_angles = (launch_pitch, launch_angles[1], launch_angles[2]);

				dir = AnglesToForward(launch_angles);

				force_mag = linear_map(distSquared, 0, radiusSquared, min_force, max_force);
				force = dir * force_mag;
				
				ai_array[i] guy_explosion_launch(org, force);
			}
		}
	}
}

rebirth_vehicle_damage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName)
{
	player_btr = GetEnt("veh_btr_player", "targetname");
	weaver_btr = GetEnt("veh_btr_weaver", "targetname");
	player = get_players()[0];
	
	//self = vehicle that is taking Damage
	/*
	if( self IsVehicleImmuneToDamage( iDFlags, sMeansOfDeath, sWeapon ) )
	{
		return;
	}
	*/	
	
	if ( (IsDefined(player_btr) && eAttacker == player_btr) || (IsDefined(weaver_btr) && eAttacker == weaver_btr) )
	{
		if(IsSubStr(self.vehicletype, "gaz63") || IsSubStr(self.vehicletype, "uaz"))
		{
			self.last_weapon_hit = sWeapon;
			
			if(self.last_weapon_hit == "btr60_grenade_gunner_rebirth" )
			{
				//new_health = self.health - iDamage;
				//if (new_health < 0)
				{
					physiced = self btr_grenade_hit( eInflictor );
					//if(physiced)
					{
						iDamage = self.health + 10000;
					}
				}
			}
		}
	}

	self finishVehicleDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, damageFromUnderneath, modelIndex, partName, false);
}

btr_grenade_hit( rocket )
{
	impact_pt = (-100, 0, 0);

	forward = AnglesToForward(self.angles);
	force = forward * 125;

	if (IsDefined(self.script_int) && self.script_int == 0)
	{
		force = force * -1.0;
		impact_pt = (100, 0, 0);
	}

	force = force + (0, 0, 125);

	self LaunchVehicle( force, impact_pt, true, true );
	
	return true;
}

btr_runner_spawnerfunc()
{
	self endon("death");
	self.team = "axis";
	self waittill("goal");
	self DoDamage(self.health + 100, (0,0,0));
}

cleanup_btr_vehicles()
{
	vehicles = GetEntArray( "brt_rail_explosion_launcher", "script_noteworthy" );
	vehicles = array_merge( vehicles, GetEntArray( "btr_rail_enemy_vehicle", "script_noteworthy" ) );
	vehicles destroy_array();
}

cleanup_btr_triggers()
{
	btr_triggers = GetEntArray("btr_trigger", "script_noteworthy");
	btr_triggers destroy_array();
}

cleanup_btr_spawners()//Grab and cleanup all btr related spawners
{
	a = GetEntArray("btr_rail_guys_a", "targetname");
	a thread destroy_array();
	b = GetEntArray("btr_rail_guys_b", "targetname");
	b thread destroy_array();
	c = GetEntArray("btr_rail_turn_c_guys", "targetname");
	c thread destroy_array();
	d = GetEntArray("btr_rail_guys_d", "targetname");
	d thread destroy_array();
	e = GetEntArray("btr_rail_guys_e", "targetname");
	e thread destroy_array();
	pl = GetEntArray("parkinglot_enemy", "script_noteworthy");
	pl thread destroy_array();
	run = GetEntArray("btr_runner", "targetname");
	run thread destroy_array();
	run2 = GetEntArray("btr_runner2", "targetname");
	run2 thread destroy_array();	
	uaz = GetEntArray("btr_uaz_guys", "script_noteworthy");
	uaz thread destroy_array();
	rail = GetEntArray("btr_rail_enemies", "targetname");
	rail thread destroy_array();
	house = GetEntArray("btr_rail_house_guys", "targetname");
	house thread destroy_array();
	balcony = GetEntArray("btr_rail_balcony_guys_e", "targetname");
	balcony thread destroy_array();
	//civ = GetEntArray("btr_rail_civ_death_civ", "targetname");
	//civ thread destroy_array();
	spez = GetEntArray("btr_rail_civ_death_spez", "targetname");
	spez thread destroy_array();
}

destroy_array()
{
	for(x = 0; x< self.size;x++)
	{
		self[x] destroy_me();
	}		
}

destroy_me()
{
	if(IsDefined(self))
		self Delete();
}

player_btr_weapon_overheating()
{
	self endon( "death" );

	player = get_players()[0];

	// OAA: 9/16/10...brought over for consitency with river and other vehicle turret weapons
	xsync = -100;

	canon_icon = newHudElem();
	canon_icon.alignX = "center";
	canon_icon.alignY = "bottom";
	canon_icon.horzAlign = "user_right";
	canon_icon.vertAlign = "user_bottom";
	canon_icon.x = -155+xsync;
	canon_icon.y = -10;
	canon_icon.foreground = true;
	canon_icon SetText("^3[{+attack}]^7");
	canon_icon.hidewheninmenu = true;
	canon_icon.fontScale = 1.0;

	self thread destroy_hud_elem_on_death( canon_icon );

	while ( 1 )
	{
		player = get_players()[0];

		weapon_overheating = player isWeaponOverheating();

		if( player attackbuttonPressed() )
		{
			if( !weapon_overheating )
			{
				Earthquake( 0.15, 0.2, player.origin, (42*2)*10 );
			}
		}
		
		// Get the over heat value (0 to 100)
		overheat_val = player isWeaponOverheating(1);
		if( overheat_val < 0 )
		{
			overheat_val = 0;
		}
		else if ( overheat_val > 100 )
		{
			overheat_val = 100;
		}

		// OAA...a bit haxxor but we set this value on the server to be fished out by the client
		// to use for rendering the overheat bar. we are commandeering this value because it is networked
		// properly and we no longer use it for its originally inteded purpose...so its 9/15/2010...remember
		// this uber haxxx forever!
		self SetHealthPercent(overheat_val / 100);

		// Has the player exited the BTR?
		if( player isinvehicle() == false )
		{
			break;
		}

		wait( 0.05 );
	}
}

destroy_hud_elem_on_death( _hud_elem )
{
	self waittill("death");
	_hud_elem Destroy();
}
 