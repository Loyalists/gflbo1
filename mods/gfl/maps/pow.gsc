/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\pow_utility;
#include maps\_music;

main()
{ 
	// Delete all special ops entities
	maps\_specialops::delete_by_type( maps\_specialops::type_so );

	// This MUST be first for CreateFX!	
	maps\pow_fx::main();
	
	level.mapCenter = (0,0,0);
	SetMapCenter(level.mapCenter);
	
	//level.custom_introscreen = ::demo_intro_screen;
	
	//-- Starts
	add_start( "warp_to_tunnels", ::warpto_tunnels, &"WARP_TO_TUNNELS" );
	add_start( "warp_to_clearing", ::warpto_clearing, &"WARP_TO_CLEARING" );
	add_start( "warp_to_compound", ::warpto_compound, &"WARP_TO_COMPOUND" );
	add_start( "warp_to_hind_vs_hind", ::warpto_hind_vs_hind, &"WARP_TO_HIND_BATTLE" );
	add_start( "start_in_hind", ::warpto_start_in_chopper, &"WARP_INTO_CHOPPER");
	add_start( "rra", ::rr_scene, &"A_SIMPLE_START");
	add_start( "rrb", ::rr_scene_b, &"B_SIMPLE_START");
	add_start( "rrc", ::rr_scene_c, &"C_SIMPLE_START");
	add_start( "rrd", ::rr_scene_d, &"D_SIMPLE_START");
	add_start( "tunnel_start", ::tunnel_start_jumpto, &"TUNNEL_START");
	add_start( "susan", ::warpto_susans_jumpto, &"SUSANS_START");
	add_start( "spetz", ::spetz_scene_jumpto, &"SPETZ_SCENE");
	add_start( "landing", ::warpto_landing, &"LANDING");
	add_start( "krav", ::krav_scene_jumpto, &"KRAVCHENKO");
	
	//add_start( "landing", maps\pow_compound::play_landed_animation, &"LANDING");
	
	SetSavedDvar( "phys_buoyancy", "1" );	
	
	//default_start( ::tunnel_start_jumpto );
	default_start( ::rr_scene );
	
	//DEMO: this is the beginning of the clearing, not the beginning of the actual level
	//level.pow_demo = true;
	//default_start( ::warpto_clearing );
	//END DEMO

	//-- adjustment just for recruit
	if( GetDvarInt( #"g_gameskill" ) == 0 )
	{
		level.invulTime_onShield_multiplier = 0.7;
	}

	maps\_load::main();

	init_drones_for_level();
	
	level thread maps\_door_breach::door_breach_init(); //-- there is a wait in this main
	maps\_rusher::init_rusher();
	
	//TODO: MOVE THESE ITEMS -------------
	precache_level_items();
	init_flags();
	generic_level_threads();
	//------------------------------------

	maps\pow_amb::main();
	maps\pow_anim::main();
	
}

precache_level_items()
{
	PreCacheModel("c_usa_jungmar_barnes_pris_fb");
	PreCacheItem("sam_pow_sp");
	PreCacheItem("hind_rockets_sp");
	PreCacheItem("hind_rockets_2x_sp");
	PreCacheItem("hind_rockets_norad_sp");
	PreCacheItem("cz75_krav_death_sp");	
	
	// player model for hind flying 
	PreCacheModel("viewmodel_usa_prisoner_player_fullbody");
	PreCacheModel("t5_veh_helo_hind_cockpit_control");
	
	// for destructible pipes
	PreCacheModel("p_jun_pipeline_d0");
	PreCacheModel("p_jun_pipeline_d1");
	PreCacheModel("p_jun_pipeline_d2");
	
	PreCacheModel("p_rus_radar_dish");
	
	PreCacheModel("anim_jun_radio_headset_b");
	PreCacheModel("anim_jun_pow_tent");
	
	PreCacheModel("t5_weapon_coltpython_pow");
	PreCacheModel("anim_cz75_world");
	PreCacheModel("p_pow_cage_lid");
	//PreCacheModel("anim_jun_colt_python");
	PreCacheModel("anim_jun_cleaver");
	PreCacheModel("anim_jun_ak47");
	//PreCacheModel("anim_jun_entrenching_tool");
	PreCacheModel("anim_jun_chair_01");
	PreCacheModel("anim_jun_folding_table");
	PreCacheModel("anim_jun_pipe_weapon");
	
	PreCacheModel("t5_weapon_machete");
	PreCacheModel("t5_knife_animate");
	
	PreCacheShader("white");
	PreCacheShader("flamethrowerfx_color_distort_overlay_bloom");
	
	PreCacheRumble("heartbeat");
	PreCacheRumble("heartbeat_low");
	PreCacheRumble("damage_heavy");
	PreCacheRumble("artillery_rumble");

	character\gfl\character_gfl_hk416_v2::precache();
}

#using_animtree ("fakeShooters");
init_drones_for_level()
{
	level.drone_rpg = "rpg_pow_sp";
	
	level.drone_spawnFunction["axis"] = character\c_vtn_vc2_drone::main;
	level.drone_think_func = maps\pow_spawnfuncs::drone_powDeath;
	
	level.droneidleanims = [];
	level.droneidleanims[0] = %patrol_bored_idle;
	level.droneidleanims[1] = %patrol_bored_idle_smoke;
	level.droneidleanims[2] = %patrol_bored_idle_cellphone;
	
	PreCacheModel("c_vtn_vc2_fb_drone");
	
	level.max_drones = [];
	level.max_drones["axis"] = 100; 
	level.max_drones["allies"] = 32; 
	
	//-- the drones are so far away we don't need the sounds
	level._drones_sounds_disable = true;
	
	if(!IsDefined(level.ragdoll_bucket))
	{
		level.ragdoll_bucket = [];
	}
		
	maps\_drones::init();
}

#using_animtree ("generic_human");
generic_level_threads()
{
	//-- Meat Shield
	level._meatshield_no_weapon_management = true; //-- the script removes the weapons before _meatshield.gsc does which caused problems
	level._meatshield_gun_offset = 36;
	level.meatshield_damage_override = ::pow_meatshield_damage;
	level.scripted_meatshield = true;
	level thread maps\_meatshield::set_custom_audio_func( ::pow_empty_function );
	level thread maps\_meatshield::main("cz75_meatshield_sp", "t5_gfl_ump45_viewmodel", maps\pow_anim::init_meatshield_anims, false);
	//level thread maps\_bulletcam::main(); //-- this is seperate from Meat Shield because we do not do the bulletcam as part of the meat shield
		
	//-- disable tank squish which frees up some script vars
	level.noTankSquish = true;
	
	//-- don't allow the random weapon system to drop the flamethrower
	set_random_alt_weapon_drops( "ft", false );
	
	// KevinD( 5/21/2010 ): Remove the master list of structs once to free up script_variables
	
	PrintLn("Saving: " + level.struct.size + " Structs");
	for(i = level.struct.size; i >= 0; i--)
	{
		level.struct[i] = undefined;
	}
	level.struct = undefined;
	
	level.default_sun_samplesize = GetDvar( #"sm_sunSampleSizeNear");
	//-- Cleans up vehicles and what not behind the player
	level thread cleanup_watcher();
	level.hinds_killed = 0;
	
	//-- for charring characters
	level.ACTOR_CHARRING = 2;
	level.ACTOR_BLEEDING = 3;
	
	//level.allowBattleChatter = true;
	battlechatter_on();
	
	//-- Setup destructible Pipes
	level thread pipes_init("pipe_");
	level thread pipes_init("pipe_depot_");
	level thread pipe_tank_init("pipe_tank_1");
	level thread pow_objectives();
	
	level thread player_setup();
	
	//-- setup some generic spawnfuncs
	level thread unlimited_rpgs();
	
	level.callbackVehicleDamage = ::pow_vehicle_damage;

	thread delaySnapshot();	
	
	//-- Controls the background music in the level based on a flag system
	level thread music_controller();
	
	//-- Color Manager
	level thread maps\_color_manager::color_manager_think();

	//-- Achievement tracking
	level thread pow_flame_achievement();
	all_axis_spawners = GetSpawnerTeamArray( "axis" );
	array_thread( all_axis_spawners, ::add_spawn_function, ::spawn_func_setup_death_thread );
}


delaySnapshot()
{
	wait(1);
	//SOUND: Shawn J - setting snapshot (so hind idle sounds are off until heli start-up)
	clientnotify( "pow_default_snapshot" );
}


player_setup()
{
	wait_for_first_player();
	player = get_players()[0];
	player SetWeaponAmmoClip( "flash_grenade_sp", 0 );
}

init_flags()
{
	//russian_roulette
	flag_init("rr_scene_done");
	
	//tunnels
	flag_init("move_woods_to_split");
	flag_init("spetz_hit");
	flag_init("spetz_fell");
	flag_init("tunnel_chase_started");
	flag_init("woods_done_with_climbup_anim");
	flag_init("bowman_vo_finished");
	
	//clearing
	flag_init("clearing_notified");
	flag_init("woods_already_started_VO");
	flag_init("woods_takeoff_anim");
	flag_init("woods_takeoff_anim_finished");
	
	//compound
	flag_init("woods_landing_animation_done");
	flag_init("to_compound_fight_start");
	flag_init("woods_ready_to_save_pows");
	flag_init("player_started_saving_pows");
	flag_init("player_saved_pows");
	flag_init("woods_saved_pows");
	flag_init("fake_ai_fight");
	
	//objective flags
	flag_init("obj_chase_russian");
	flag_init("obj_russian_start");
	flag_init("obj_chase_russian_complete");
	flag_init("obj_boost_woods");
	flag_init("obj_boost_woods_complete");
	flag_init("obj_kill_hind_crew");
	flag_init("obj_take_hind");
	flag_init("obj_player_in_hind");
	flag_init("obj_fly_to_base");
	flag_init("obj_truck_depot"); //-- set in a trigger
	flag_init("obj_truck_depot_complete");
	flag_init("obj_enemy_hip");
	flag_init("obj_enemy_hip_complete");
	flag_init("obj_sam_cave");
	flag_init("obj_sam_cave_complete");
	flag_init("obj_large_village"); //-- set in a trigger
	flag_init("obj_large_village_complete");
	flag_init("obj_large_boat");
	flag_init("obj_enemy_hind");
	flag_init("obj_enemy_hind_complete");
	flag_init("obj_hind_landing");
	flag_init("obj_to_kravchenko");
	flag_init("obj_player_needs_ft");
	
	//-- other flags
	flag_init("radio_tower_destroyed");
	flag_init("player_on_heli");
	flag_init("village_1_vehicles_spawned");
	flag_init("play_morph");
	flag_init("swap_rez");
	
	//-- flew past objectives
	flag_init( "obj_truck_depot_passed");
	flag_init( "obj_enemy_hip_passed" );
	flag_init( "obj_sam_cave_passed" );
	
	//music control flags
	flag_init("music_takeoff");
	flag_init("music_truckdepotdestroyed");
	flag_init("music_hiptakingoff");
	flag_init("music_hipdestroyed");
	flag_init("music_sameventstarted");
	flag_init("music_sameventfinished");
	flag_init("music_villagefinished");
	flag_init("music_twohinds");
	flag_init("music_twohindsdestroyed");
	
	// vo flags
	flag_init("story_dialog");
	flag_init("extra_dialog");
	flag_init("dmg_dialog");
	flag_init("reload_dialog");
	flag_init("nag_dialog");
	
	flag_init("vo_tank_destroyed");
	flag_init("vo_bend_reached");
	flag_init("vo_napalm_reached");
	flag_init("vo_sam_reached");
	flag_init("vo_sam_close");
	flag_init("vo_hind_fallback");
	flag_init("vo_one_hind_down");
	flag_init("vo_rus_truck_depot_attacked");
	flag_init("vo_radar_destroyed");
}

unlimited_rpgs()
{
	spawners = GetEntArray("rpg_unlimited_ammo", "script_noteworthy");
	array_thread( spawners, ::add_spawn_function, maps\pow_spawnfuncs::unlimited_rpgs );
}

/*------------------------

The beginning event of the level, this is mostly a vignette
but it will trigger the chase through the tunnels, which is the first actual
fight

-------------------------*/

rr_scene_d()
{
	rr_scene(false, false, false, true);
}

rr_scene_c()
{
	rr_scene(false, false, true, true);
}

rr_scene_b()
{
	rr_scene(false, true, true, true);
}

intro_hud_fadeout()
{
	wait(0.15);
		// Fade out black
	self FadeOverTime( 0.5 ); 
	self.alpha = 0; 
	
	wait 0.3;
	self Destroy();
}

rr_scene( a, b, c, d)
{
	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = true;
	introblack SetShader( "black", 640, 480 );
		
	wait_for_first_player();
	
	introblack thread intro_hud_fadeout();
	
	clientnotify( "pow_default_snapshot" );
	//Shawn J - dvar for futz override; awaiting exes
	setsaveddvar("snd_dsp_futz", false); 
	
	//TUEY Temp music state until RR scene is done
	setmusicstate ("INTRO");
	level thread maps\pow_amb::event_heart_beat("sedated");
	level thread maps\pow_amb::heartbeat_controller_intro();
	
	//-- disable buoyancy for tunnel section
	SetSavedDvar("phys_buoyancy", 0);
	SetSavedDvar("phys_ragdoll_buoyancy", 0);
	
	//-- start scene
	sync_struct_a = getstruct("rr_sync_a_struct", "targetname");
	sync_struct = getstruct("rr_sync_struct", "targetname");
	//sync_struct thread rr_temp_dialogue();
	
	player = get_players()[0];
	player SetClientDvar("r_poisonFX_blurMin", 0.11);
	player SetClientDvar("r_poisonFX_blurMax", 0.12);
	player StartPoisoning();
	
	if(!IsDefined(a))
	{
		a = true;
		b = true;
		c = true;
		d = true;
	}
	
	level thread rr_animate_objects( sync_struct_a, sync_struct, a, b, c, d );
	level thread rr_animate_player( sync_struct_a, sync_struct, a, b, c, d );
	level thread rr_animate_ai( sync_struct_a, sync_struct, a, b, c, d );
	
	level waittill("rr_ai_ready");
	level notify("rr_scene_start");
	
	//SOUND - Shawn J - snapshot & intro audio (cage to table)
	//clientnotify( "pow_rr_intro_snapshot" );
  	playsoundatposition( "evt_rr_intro", (0,0,0) );
	
	flag_wait("rr_scene_done");
	
	//-- The Next Event
	level thread maps\pow_tunnels::start_tunnel_chase();
}

rr_temp_dialogue()
{
	self notify("kill_temp_dialogue");
	self endon("kill_temp_dialogue");
	
	while(1)
	{
		self waittill( "single anim", msg );
		
		if(msg == "end")
		{
			continue;
		}
		
		if(self.animname != "player_hands")
		{
			if(self.animname == "barnes" && msg == "switch_guns")
			{
				level.woods gun_recall();
			}
		}
		else
		{
			if( msg == "timescale_start")
			{
				SetTimeScale(0.3);
			}
			else if(msg == "timescale_end")
			{
				SetTimeScale(1);
			}
			else if( msg == "slap")
			{
				player = get_players()[0];
				player DoDamage( 50, player.origin );
			}
			else
			{
				//-- nothing
			}
		}
	}
}

#using_animtree ("animated_props");
rr_animate_objects( sync_node_a, sync_node, a, b, c, d )
{
	props_array = [];
	props_array[0] = spawn_anim_model("rr_cleaver", (0,0,0));
	props_array[1] = spawn_anim_model( "rr_roulettegun", (0,0,0) );
	props_array[2] = spawn_anim_model( "rr_otherchair", (0,0,0) );
	props_array[3] = spawn_anim_model("rr_playerchair", (0,0,0));
	props_array[4] = spawn_anim_model( "rr_table", (0,0,0) );
	
	level waittill("rr_scene_start");
	
	if(a)
	{
		
		level waittill("rr_scene_a_1_done");
		
		lid = spawn_anim_model( "rr_cage_lid", (0,0,0) );
		sync_node_a maps\_anim::anim_single_aligned( lid, "rr_1a_2");
		level waittill("rr_scene_a_done");
		lid Delete();
	}
	
	props_array[5] = spawn_anim_model("rr_shovel", (0,0,0));
	
	if(b)
	{
		sync_node maps\_anim::anim_single_aligned( props_array, "rr_1b");
		sync_node maps\_anim::anim_single_aligned( props_array, "rr_1b2");
	}
		
	//props_array[6] = spawn_anim_model("rr_ak47", (0,0,0));
	//props_array[7] = spawn_anim_model( "rr_bookiegun", (0,0,0) );
		
	if(c)
	{
		sync_node maps\_anim::anim_single_aligned( props_array, "rr_1c");
	}
	
	gun = props_array[1];
	props_array = array_remove( props_array, props_array[1] );
	gun Delete();
	
	array_thread( props_array, ::freeze_me, "rr_1d" );
	if(d)
	{
		sync_node maps\_anim::anim_single_aligned( props_array, "rr_1d");
	}
	
	props_array[0] Delete(); //-- delete the knife
}

#using_animtree ("generic_human");
rr_animate_ai( sync_node_a, sync_node, a, b, c, d )
{
	scene_actors = simple_spawn("rr_scene_guys");
	bookie = undefined;
	
	for(i = 0; i < scene_actors.size; i++ )
	{
		if(scene_actors[i].animname == "bookie")
		{
			level.bookie = scene_actors[i];
			level thread rr_animate_bookie( sync_node_a, sync_node, a, b, d, c, scene_actors[i] );
			scene_actors = array_remove(scene_actors, scene_actors[i]);
		}
	}
	
	barnes = simple_spawn_single("barnes_rr_scene");
	level.barnes = barnes;
	level.woods = barnes; //-- this is sloppy but keeps from having to change a bunch of other script
	level.woods gun_remove();
		
	trigger_use("color_trig_after_roulette_allies"); //-- set woods color
	
	scene_actors = array_add(scene_actors, barnes);
	
	vc = simple_spawn("rr_vc_guys");
	
	scene_actors = array_combine(scene_actors, vc);
	
	bowman = Spawn("script_model", (0,0,0));
	bowman character\c_usa_jungmar_pow_bowman::main();
	bowman useAnimTree( #animtree );
	bowman.animname = "bowman";
	
	level notify("rr_ai_ready");
	level waittill("rr_scene_start");
	
	vc1 = undefined;
	for(i = 0; i < vc.size; i++)
	{
		if(vc[i].animname == "vc1")
		{
			vc1 = vc[i];
			break;
		}
	}
		
	array_thread(scene_actors, ::rr_temp_dialogue);
	if(a)
	{
		//sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a");
		sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a_1"); //-- look at woods
		
		//-- remove barnes and vc1
		scene_actors = array_remove(scene_actors, barnes);
		barnes Hide();
		scene_actors = array_remove(scene_actors, vc1);
		vc1 Hide();
		sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a_2"); //-- pull from cage
		sync_node_a maps\_anim::anim_single_aligned(scene_actors, "rr_1a_3"); //-- dragged
	}
	
	barnes Show();
	vc1 Show();
	vc1 set_ignoreme(true);
	
	scene_actors = array_add(scene_actors, barnes);
	scene_actors = array_add(scene_actors, vc1);
	
	level.russian = simple_spawn_single( "spetz_rr_scene" );
	scene_actors = array_add(scene_actors, level.russian);
	
	//-- swap out actors
	scene_actors = array_add(scene_actors, bowman);
	
	
	vc5 = simple_spawn_single("rr_vc_5");
	vc5 set_ignoreme(true);
	scene_actors = array_add(scene_actors, vc5);
	vc6 = simple_spawn_single("rr_vc_6");
	vc6 set_ignoreme(true);
	scene_actors = array_add(scene_actors, vc6);
	
	
	array_thread(scene_actors, ::rr_temp_dialogue);
	if(b)
	{
		sync_node maps\_anim::anim_single_aligned(scene_actors, "rr_1b");
		sync_node maps\_anim::anim_single_aligned(scene_actors, "rr_1b2");
	}
	
	if(c)
	{
		sync_node maps\_anim::anim_single_aligned(scene_actors, "rr_1c");
	}
	
	kill_array = [];
	for( i = 0; i < scene_actors.size; i++ )
	{
		if(IsSubStr(scene_actors[i].animname, "vc" ) && (scene_actors[i].animname == "vc5" || scene_actors[i].animname == "vc6"))
		{
			
			scene_actors[i] add_meatshield_target(level.bookie);
			scene_actors[i] thread freeze_me( "rr_1d" );
			scene_actors[i] thread disable_react(); //-- keep them from sidestepping on whizbys
			scene_actors[i] thread meatshield_infinite_ammo();
			scene_actors[i] set_ignoreme(false);
			sync_node thread start_anim_then_end_it_at_meatshield( scene_actors[i], "rr_1d" );
		}
		else if( scene_actors[i].animname == "vc2" ) //-- This is the one that Woods kills
		{
			scene_actors[i] thread freeze_me( "rr_1d" );
			scene_actors[i] gun_remove();
			scene_actors[i].ignoreme = true;
			scene_actors[i].dropweapon = 0;
			sync_node thread maps\_anim::anim_single_aligned(scene_actors[i], "rr_1d");
		}
		else if(scene_actors[i].animname == "vc1" || scene_actors[i].animname == "vc3" || scene_actors[i].animname == "vc4")
		{
			scene_actors[i] gun_remove();
			scene_actors[i].dropweapon = 0;
			kill_array = array_add(kill_array, scene_actors[i]);
		}
	}
	
	array_thread(kill_array, ::ragdoll_death);
	
	
	//-- Remove the VC from the scene array so that they can fight the player
	scene_actors = [];
	scene_actors[0] = barnes;
	scene_actors[1] = level.russian;
	level.russian gun_remove();
	
	array_thread( scene_actors, ::rr_temp_dialogue);
	if(d)
	{
		array_thread( scene_actors, ::freeze_me, "rr_1d" );
		sync_node thread maps\_anim::anim_single_aligned(scene_actors, "rr_1d");
	}
	
	level waittill("player_done_with_meatshield");
	barnes StopAnimScripted();
	level.russian StopAnimScripted();
	
	//wait(0.1);
	player = get_players()[0];
	flag_set("rr_scene_done");
	player notify("rr_scene_done");
			
	//level.russian thread maps\pow_tunnels::russian_color_chain();
	align_node = getstruct("struct_align_spetz_escape", "targetname");
	level.russian ForceTeleport( align_node.origin, align_node.angles );
	align_node thread maps\_anim::anim_first_frame( level.russian, "escape");
	
	//-- some russian setup
	flag_set( "obj_chase_russian" );
	level.russian set_ignoreme( true );
	
	wait(0.1);//-- This delay was actually necessary for something
	player SwitchToWeapon("ak47_sp");
}

meatshield_infinite_ammo()
{
	self endon("death");
	
	while(1)
	{
		self.bulletsinclip = WeaponClipSize(self.weapon);
		wait(0.05);
	}
}

freeze_me(scene_name)
{
	level waittill("freeze_everyone");
	
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ scene_name ], 1, 0, 0 );
	self thread rr_temp_dialogue();
	
	level waittill("unfreeze_everyone");
	
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ scene_name ], 1, 0, 1 );
	self thread rr_temp_dialogue();
	
}

rr_animate_bookie( sync_node_a, sync_node, a, b, c, d, bookie )
{
	AssertEX( IsDefined( bookie), "Can't find the bookie for the russian roulette scene" );
	bookie gun_remove();
	
	level waittill("rr_scene_start");
	
	bookie thread rr_temp_dialogue();
	bookie.dropweapon = 0;
	
	if(a)
	{
		level waittill("rr_scene_a_done");
	}
	if(b)
	{
		sync_node maps\_anim::anim_single_aligned(bookie, "rr_1b");
		sync_node maps\_anim::anim_single_aligned(bookie, "rr_1b2");
	}
	if(c)
	{
		sync_node maps\_anim::anim_single_aligned(bookie, "rr_1c");
	}
	if(d) //-- start meatshield
	{
		waittillframeend;
		bookie maps\pow_utility::pow_meatshield_success_fail();
	}
}

#using_animtree ("player");

player_dialog_over_black() //-- self == player
{
	level waittill("first_fade_to_black");
	wait(0.9);
	self maps\_anim::anim_single( self, "narration_1a");
	self thread maps\_anim::anim_single( self, "narration_1");
}

rr_animate_player( sync_node_a, sync_node, a, b, c, d )
{
	show_friendly_names( 0 );
	
	player = get_players()[0];
	player_body = spawn_anim_model( "player_hands", (0,0,0) );
		
	player thread take_and_giveback_weapons("rr_scene_done");
	player PlayerLinkToAbsolute(player_body, "tag_player");
	player_body thread rr_temp_dialogue();
	level waittill("rr_scene_start");
	
	battlechatter_off();
	
	if(a)
	{
		player = get_players()[0];
		player.animname = "player";
		player thread player_dialog_over_black();
			
		//sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a");
		sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a_1");
		level notify("rr_scene_a_1_done");
				
		//push the physics light above the table
		//push_pos = getstruct("struct_light_push", "targetname");
		PhysicsJolt( (-6395.5, -50462.5, -300), 32, 1, vector_scale(AnglesToForward((0, 90, 0)), 0.5));		
		sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a_2");
		level thread notify_rats(0.1);
		sync_node_a maps\_anim::anim_single_aligned(player_body, "rr_1a_3");
		level notify("rr_scene_a_done");
		level notify("vs_tunnels");
		
		if(IsDefined(level.fadetoblackrr))
		{
			level.fadetoblackrr FadeOverTime( 2.0 );
			level.fadetoblackrr.alpha = 0;
		}
	}
	
	level notify("after_meatshield_dof_change");
	
	player StopPoisoning();
	
	if(b)
	{
		//play the sound for the scene
		playsoundatposition("evt_deer_hunter", player.origin);
		level notify("at_roullete_table");
		sync_node maps\_anim::anim_single_aligned(player_body, "rr_1b");
		level thread notify_bowman_hit_hb();
		sync_node maps\_anim::anim_single_aligned(player_body, "rr_1b2");
	}
	
	player = get_players()[0];

	align_ent = getstruct("rr_sync_struct");
	start_org = GetStartOrigin(align_ent.origin, align_ent.angles, level.scr_anim["_meatshield:player"]["grab"] );
	start_ang = GetStartAngles(align_ent.origin, align_ent.angles, level.scr_anim["_meatshield:player"]["grab"] );
	player.early_contextual_player_hands = spawn_anim_model( "player_hands_contextual_melee", start_org, start_ang );
	player.early_contextual_player_hands Hide();

	align_ent thread maps\_anim::anim_first_frame( player.early_contextual_player_hands, "grab"); 
	
	if(c)
	{
		anim_length = GetAnimLength(level.scr_anim[player_body.animname]["rr_1c"]);
		sync_node thread maps\_anim::anim_single_aligned(player_body, "rr_1c");
		wait(anim_length - 2);
		level notify("hb_gun_at_head");
		sync_node waittill("rr_1c");
	}
	
	player_body Delete();
	
	player = get_players()[0];
	player waittill("_meatshield:done");
	autosave_by_name( "pow_meatshield_end" );
	player SetClientDvar( "ammoCounterHide", "0" );	
	level notify("player_max_ammo");
	level notify("player_done_with_meatshield");
	level notify("clear_dof");
	show_friendly_names( 1 );
	//level notify("after_meatshield_dof_change");
	
	//TUEY Temp music state until RR scene is done
	setmusicstate ("CAVE_FIGHT");
	
	
	if(IsDefined(level.fadetoblackrr))
	{
		level.fadetoblackrr Destroy();
	}
	
	battlechatter_on();
}

notify_bowman_hit_hb()
{
	wait(3);
	level notify("hb_bowman_hit");
	wait(10);
	level notify("woods_at_table");
}

notify_rats(delay)
{
	wait(delay);
	level notify("rat_01_start");
}

/*----------------------------------

	JUMPTOS: LEVEL EVENTS

----------------------------------*/


rr_jumpto()
{
	
	
	
}


/*----------------------------------

	JUMPTOS: WARP ME

----------------------------------*/

warpto_tunnels()
{
	wait_for_first_player();
	
	player_warpto_struct("player_tunnels");
	
}

music_delay()
{
	wait (2);
	//TUEY INTRO music state
	setmusicstate("CLEARING_INTRO");

}

warpto_clearing()
{
	wait_for_first_player();
	
	//-- TODO: remove this
	level thread maps\_gameskill::setSkill( true, 3 ); //-- should make it veteran
	
	level thread music_delay();
	
	player_warpto_struct("player_clearing");
	
	flag_set("obj_chase_russian");
	flag_set("obj_russian_start");
	flag_set("spetz_hit");
	flag_set("obj_chase_russian_complete");
	flag_set("obj_boost_woods");
	flag_set("obj_boost_woods_complete");
	
	level thread maps\pow_tunnels::tunnel_cleanup_after_fork();
	trigger_use("tunnel_cleanup_sides");
	
	
	
	jumpto_objective = 2; //-- objective before: steal the hind
	//level thread pow_update_objectives(jumpto_objective);
	
	level thread maps\pow_hind_clearing::start();
	//maps\pow_hind_clearing::start_non_demo();
	
	wait(1);
	
	//SOUND: Shawn J - setting snapshot (so hind idle sounds are off until heli start-up)
	clientnotify( "pow_default_snapshot" );
	
	trigger_use( "tunnel_exit", "script_noteworthy");
}

warpto_compound()
{
	wait_for_first_player();
	
	player_warpto_struct("player_compound");
}

krav_scene_jumpto()
{
	wait_for_first_player();
	
	level thread maps\_gameskill::setSkill( true, 3 ); //-- should make it veteran
	
	double_hind = GetEntArray( "hind_for_last_battle", "targetname" );
	array_delete( double_hind );
		
	level.woods = simple_spawn_single("barnes_rr_scene");
	flag_wait( "starting final intro screen fadeout" );
	
	if(IsSubStr(level.woods GetAttachModelName(0), "head"))
	{
		// level.woods Detach(level.woods.headmodel);
		// level.woods SetModel("c_usa_jungmar_barnes_pris_fb");
		level.woods SetModel("t5_gfl_hk416_v2_body");
	}
	
	player_warpto_struct( "struct_krav_door");
	
	player = get_players()[0];
	player waittill("door_breached");
	
	level.hind = maps\_vehicle::scripted_spawn( 15 )[0]; //-- other hind
	level.hind MakeVehicleUsable();
	
	AssertEX(IsDefined(level.hind), "The HInd is not defined in this jumpto");
	
	level thread maps\pow_compound::play_endfight_animation();
	wait(1);
	level notify("vs_tunnels");
	/*
	player FreezeControls(true);
	player EnableInvulnerability();
	
	wait(0.05);
	
	//level maps\pow_compound::play_fade_map_picture();
	//level maps\pow_compound::play_fade_woods_dead();
	//level maps\pow_compound::play_fade_getting_out();
	//level maps\pow_compound::play_fade_in_helicopter();
	
	player FreezeControls(false);
	*/
	//nextmission();
}

spetz_scene_jumpto()
{
	wait_for_first_player();
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	
	//spetz_spawner = GetEnt( "spetz_escape_spawner", "targetname");
	//spetz = spetz_spawner DoSpawn();
	spetz = simple_spawn_single( "spetz_escape_spawner" );
	
	level.woods = simple_spawn_single("barnes_rr_scene");
	warp_point = getstruct("woods_warp_spetz_scene");
	level.woods ForceTeleport(warp_point.origin, warp_point.angles);
	
	flag_wait( "starting final intro screen fadeout" );
	wait(3);
	
	player_warpto_struct( "player_warp_spetz_scene" );
	
	level thread maps\pow_tunnels::spetz_escape_scene( spetz );
}

tunnel_start_jumpto()
{
	wait_for_first_player();
	player_warpto_struct("player_warpto_tunnel_start");
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	
	level.woods = simple_spawn_single("barnes_rr_scene");
	warp_point = getstruct("woods_warpto_tunnel_start");
	level.woods ForceTeleport(warp_point.origin, warp_point.angles);
	trigger_use("color_trig_after_roulette_allies");
	
	/*
	level.russian = simple_spawn_single("spetz_rr_scene");
	warp_point = getstruct("spetz_warpto_tunnel_start");
	level.russian ForceTeleport(warp_point.origin, warp_point.angles);
	level.russian thread maps\pow_tunnels::russian_color_chain();
	*/
	
	flag_set( "obj_chase_russian" );
	
	level thread maps\pow_tunnels::start_tunnel_chase();
	
	wait(1);
	level notify("clear_dof");
}

warpto_susans_jumpto()
{
	wait_for_first_player();
	player_warpto_struct("start_in_chopper_struct");
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "no_ext_amb_snapshot" );
	
	level.hind = maps\_vehicle::scripted_spawn(30)[0];
	AssertEx( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind maps\pow_hind_clearing::init_hind();
	
	//-- make the player the driver of the vehicle
	player = get_players()[0];
	level.hind UseBy(player);
	//level.hind MakeVehicleUnusable();
	
	level.hind.lockheliheight = true;
	
	//-- turn on the hinds controls
	level.hind.tut_hud["fly_controls"] = false;
	level.hind.tut_hud["gun_controls"] = true;
	level.hind.tut_hud["rocket_controls"] = true;
	level.hind maps\_hind_player::create_tutorial_hud( true );
	level.hind maps\_hind_player::enable_driver_weapons();
	
	level.hind maps\pow_hind_fly::init_hind_flight_dvars_flying();
}

warpto_hind_vs_hind()
{
	//-- THIS JUMPTO DOES NOT SUPPORT OBJECTIVES
	
	wait_for_first_player();
	
	player_warpto_struct("start_in_chopper_struct");
	
	//SOUND - Shawn J - setting snapshot
	clientnotify( "hind_on_snapshot" );
	
	//TODO: CHANGE THIS SO THAT IT JUST SETS THE ORIGIN
	level.hind = maps\_vehicle::scripted_spawn(30)[0];
	AssertEx( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind maps\pow_hind_clearing::init_hind();
	
	//-- move the hind to the new position for the jumpto
	position_struct = GetStruct("warpto_hind_vs_hind_struct", "targetname");
	level.hind.origin = position_struct.origin;
	
	//-- make the player the driver of the vehicle
	player = get_players()[0];
	level.hind UseBy(player);
	//level.hind MakeVehicleUnusable();
	

	level.hind.lockheliheight = true;
	
	//-- turn on the hinds controls
	level.hind.tut_hud["fly_controls"] = false;
	level.hind.tut_hud["gun_controls"] = true;
	level.hind.tut_hud["rocket_controls"] = true;
	level.hind maps\_hind_player::create_tutorial_hud( true );
	level.hind maps\_hind_player::enable_driver_weapons();
	
	level.hind maps\pow_hind_fly::init_hind_flight_dvars_flying();
	
	//-- TODO: HOOK INTO THE ACTUAL SCRIPT FOR THE HIND VS HIND FIGHT
	//level thread maps\pow_utility::nva_pbr_target_player();
	//maps\pow_hind_fly::hind_vs_hind();
	//ipritnlnbold("This Start is Broken...Tell Gavin");
	
}

warpto_landing()
{
	wait_for_first_player();
	
	player_warpto_struct("start_in_chopper_struct");
	
	//SOUND - Shawn J - setting snapshot
	clientnotify( "hind_on_snapshot" );
	
	//TODO: CHANGE THIS SO THAT IT JUST SETS THE ORIGIN
	level.hind = maps\_vehicle::scripted_spawn(30)[0];
	wait(0.05);
	AssertEx( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind maps\pow_hind_clearing::init_hind();
	
	//-- move the hind to the new position for the jumpto
	position_struct = GetStruct("struct_landing_warp", "targetname");
	level.hind.origin = position_struct.origin;
	level.hind.angles = position_struct.angles;
	
	//-- make the player the driver of the vehicle
	player = get_players()[0];
	//level.hind UseBy(player);
	//level.hind MakeVehicleUnusable();

	level.hind.lockheliheight = true;
	level.hind maps\pow_hind_fly::init_hind_flight_dvars_flying();
	
	//-- Player Arms - with attached flightstick
	maps\_hind_player::init_player_anims();
	player_body = spawn_anim_model( "hind_body", player.origin, player.angles );
	level.hind.player_body = player_body;
	player_body Attach( "t5_veh_helo_hind_cockpit_control", "tag_weapon" );
	level.hind thread maps\pow_utility::start_hands_flightstick();
	level.hind heli_toggle_rotor_fx(0);
	
	double_hind = GetEntArray( "hind_for_last_battle", "targetname" );
	array_delete( double_hind );
	
	flag_set("obj_chase_russian");
	flag_set("obj_russian_start");
	flag_set("spetz_hit");
	flag_set("obj_chase_russian_complete");
	flag_set("obj_boost_woods");
	flag_set("obj_boost_woods_complete");
	flag_set("obj_kill_hind_crew");
	flag_set("obj_take_hind");
	flag_set("obj_player_in_hind");
	flag_set("obj_fly_to_base");
	flag_set("obj_truck_depot"); //-- set in a trigger
	flag_set("obj_truck_depot_complete");
	flag_set("obj_enemy_hip");
	flag_set("obj_enemy_hip_complete");
	flag_set("obj_sam_cave");
	flag_set("obj_sam_cave_complete");
	flag_set("obj_large_village"); //-- set in a trigger
	flag_set("obj_large_village_complete");
	flag_set("obj_large_boat");
	flag_set("obj_enemy_hind");
	wait(0.5);
	level notify("obj_enemy_hind_complete");
	flag_set("obj_enemy_hind_complete");
	
	level thread maps\pow_compound::start();
	
	enable_random_alt_weapon_drops();
	set_random_alt_weapon_drops( "ft", false );
	
	wait(1);
	
	trigger_use( "tunnel_exit", "script_noteworthy");
}

warpto_start_in_chopper()
{
	wait_for_first_player();
	
	player_warpto_struct("start_in_chopper_struct");
	
	//SOUND: Shawn J - setting snapshot
	clientnotify( "low_ext_amb_snapshot" );
	
	jumpto_objective = 3; //-- objective after stealing the hind
	//level thread pow_update_objectives(jumpto_objective);
	
	level.hind = maps\_vehicle::scripted_spawn(30)[0];
	AssertEx( IsDefined(level.hind), "THE HIND IS NOT DEFINED AND THE LEVEL JUST BROKE!");
	level.hind maps\pow_hind_clearing::init_hind();
	
	player = get_players()[0];
	level.hind UseBy(player);
	level.hind MakeVehicleUnusable();
	
	level.hind maps\pow_hind_clearing::animate_barnes_into_hind();
	level thread maps\pow_hind_fly::start();
	
	/*
	wait(5);
	
	level.hind thread maps\_hind_player::debug_cycle_damage_states();
	*/
}


start_anim_then_end_it_at_meatshield( actor, anim_str ) //-- self is the align node
{
	self thread maps\_anim::anim_single_aligned( actor, anim_str );
	level.bookie waittill("_meatshield:start");
	
	wait(1.0);
	
	actor StopAnimScripted();
	actor.goalradius = 12;
	actor SetGoalPos( actor.origin );
	
	//-- Link me to something so I don't stand on the bench
	linker = Spawn("script_origin", actor.origin);
	actor LinkTo(linker);
	actor waittill("death");
	linker Delete();
}
 