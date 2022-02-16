/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include maps\_utility;
#include common_scripts\utility; 
#include Maps\_civilians;



/*------------------------------------

------------------------------------*/
main()
{
	//-- Starts
	add_start( "mason_stealth", 	::event_mason_stealth_jumpto, 	&"MASON_STEALTH" );	
	add_start( "mason_lab",				::event_mason_lab_jumpto,				&"MASON_LAB" );
	add_start( "btr_rail",				::event_btr_rail_jumpto,				&"BTR_RAIL" );
	add_start( "gas_attack", 			::event_gas_attack_jumpto, 			&"GAS_ATTACK" );
	add_start( "lab_entrance",		::event_lab_entrance_jumpto,		&"LAB_ENTRANCE" );
	add_start( "security_room",		::event_security_room_jumpto,		&"SECURITY_ROOM" );
	add_start( "steiners_office",	::event_steiners_office_jumpto,	&"STEINERS_OFFICE" );
	default_start( ::event_mason_stealth_jumpto );

	// weapon precaches
	PreCacheItem( "makarov_sp" );
	PreCacheItem( "ks23_sp" );
	PreCacheItem( "ak74u_sp" );
	PreCacheItem( "ak74u_acog_sp" );
	PreCacheItem( "ak74u_reflex_sp" );
	PreCacheItem( "ak74u_elbit_sp" );
	PreCacheItem( "ak74u_extclip_sp" );
	PreCacheItem( "ak74u_dualclip_sp" );
	PreCacheItem( "ak74u_gl_sp" );
	PreCacheItem( "gl_ak74u_sp" );
	PreCacheItem( "kiparis_sp" );
	PreCacheItem( "kiparis_acog_sp" );
	PreCacheItem( "kiparis_reflex_sp" );
	PreCacheItem( "kiparis_extclip_sp" );
	PreCacheItem( "kiparis_grip_sp" );
	PreCacheItem( "rpk_sp" );
	PreCacheItem( "rpk_acog_sp" );
	PreCacheItem( "rpk_ir_sp" );
	PreCacheItem( "rpk_extclip_sp" );
	PreCacheItem( "strela_sp" );
	PreCacheItem( "rpg_player_sp" );
	PreCacheItem( "rpg_pow_sp" );
	PreCacheItem( "rpg_magic_bullet_sp" );
	PreCacheItem( "enfield_sp" );
	PreCacheItem( "enfield_ir_sp" );
	PreCacheItem( "enfield_gl_sp" );
	PreCacheItem( "gl_enfield_sp" );
	PreCacheItem( "enfield_mk_sp" );
	PreCacheItem( "mk_enfield_sp" );
	PreCacheItem( "enfield_ir_mk_sp" );
	PreCacheItem( "hk21_sp" );
	PreCacheItem( "hk21_extclip_sp" );
	PreCacheItem( "hk21_sp" );
	PreCacheItem( "rebirth_hatchet_sp" );
	PreCacheItem( "hatchet_rebirth_sp" );
	// PreCacheItem( "hatchet_sp" );
	PreCacheItem( "molotov_sp" );
	PreCacheItem( "napalmblob_sp" );
	PreCacheItem( "gasmask_sp" );
	
	PreCacheItem( "hip_minigun_gunner" );
	PreCacheModel( "c_ger_steiner_rebirth_fb" );
	PreCacheModel( "c_ger_steiner_rebirth_dead_fb" );
	//PreCacheModel( "arctic_corpse_frozen_a" );
	PreCacheModel( "viewmodel_usa_blackops_urban_player_fullbody" );
	PreCacheItem("rebirth_hands_sp");
	PreCacheModel( "t5_veh_helo_mi8_woodland" );
	PreCacheModel( "t5_veh_helo_mi8_att_dualguns" );
	PreCacheModel( "t5_veh_helo_mi8_att_spotlight" );
	PreCacheModel( "t5_weapon_hatchet_viewmodel" );
	PreCacheModel( "t5_weapon_ks23_viewmodel" );
	PreCacheModel( "t5_weapon_viewmodel_flashlight" );
	PreCacheModel( "t5_weapon_makarov_world" );
	//PreCacheModel( "global_explosive_barrel_d" );
	//PreCacheModel( "t5_veh_gaz66_dead" );
	PreCacheModel( "t5_veh_tiara_static_dead_green" );
	PreCacheModel( "viewmodel_usa_hazmat_arms" );
	PreCacheModel( "viewmodel_usa_hazmat_player" );
	PreCacheModel( "viewmodel_usa_hazmat_player_fullbody" );
	PreCacheModel( "c_usa_rebirth_mason_fb" );
	PreCacheModel( "p_rus_rb_steiner_window_02" );
	PreCacheModel( "p_rus_rb_steiner_window_03" );
	PreCacheModel( "p_rus_rb_steiner_window_04" );
	PreCacheModel( "t5_weapon_strela_world_obj" );
	PreCacheModel( "tag_origin_animate" );
	PreCacheModel( "anim_monkey" );
	PreCacheModel( "anim_monkey_gas" );
	PreCacheModel( "viet_pig" );
	PreCacheModel( "p_rus_animal_cage_medium_01" );
	PreCacheModel( "fxanim_gp_seagull_mod" );
	PreCacheModel( "t5_weapon_radio_hold" );
	PreCacheModel( "t5_weapon_enfield_world" );
	PreCacheModel( "c_rus_engineer_head1_gas" );
	PreCacheModel( "p_rus_computer_terminal_chair_blood" );

	PreCacheModel("p_rus_rb_lab_warning_light_01");
	PreCacheModel("p_rus_rb_lab_warning_light_01_off");
	PreCacheModel("p_lights_cagelight01_on");
	// PreCacheModel("p_lights_cagelight01_off");
	PreCacheModel("p_rus_rb_lab_light_core_on");
	PreCacheModel("p_rus_rb_lab_light_core_off");	

	PreCacheModel( "t5_gfl_ump45_viewmodel" );
	PreCacheModel( "t5_gfl_ump45_viewmodel_player" );
	PreCacheModel( "t5_gfl_ump45_viewbody" );

	PreCacheModel( "t5_gfl_m16a1_viewmodel" );
	PreCacheModel( "t5_gfl_m16a1_viewmodel_player" );
	PreCacheModel( "t5_gfl_m16a1_viewbody" );

	PreCacheItem( "ak12_zm" );
	PreCacheModel( "ak12_world_model" );

	//PreCacheModel( "c_rus_spetznaz_rebirth_1_corpse" );
	//PreCacheModel( "c_rus_spetznaz_rebirth_2_corpse" );
	PreCacheRumble( "damage_heavy" );
	PreCacheRumble( "grenade_rumble" );
	PreCacheShellShock("explosion");
	PreCacheShader("hud_btr_60");
	PreCacheShader("cinematic");
	PreCacheShader( "hud_obit_nova_gas" );

	// PreCacheModel( "fx_axis_createfx" );

	rebirth_setup_characters();

	rebirth_init_dvars();

	maps\rebirth_fx::main();				// Needs to be here for CreateFX
	
  level.drone_spawnFunction["allies"] = character\c_usa_rebirth_hazmat::main;	//drones
	
	rebirth_level_order();					//
	
	maps\_load::main();							// main!

	maps\_drones::init();    
	maps\_civilians::init_civilians();

	maps\rebirth_amb::main();
	maps\rebirth_anim::main();
	
	level thread remove_lmg_anims();
	
	level thread maps\_gasmask::init_and_run( false );	//-- GLocke: Added the ability to disable toggle on init
	maps\_heatseekingmissile::init();
	maps\_rusher::init_rusher();
	// maps\_patrol::patrol_init(); // Saving some memory the hacky way
	level._patrol_init = true;
	
	maps\rebirth_gas::rebirth_gas_init();
	thread maps\rebirth_steiners_office::set_steiner_window_model();
	thread maps\rebirth_steiners_office::toggle_event5_triggers(false);
	rebirth_setup_variables();			// Set Up Level Variables
	thread rebirth_setup_heroes();	// Grab the heroes
	rebirth_setup_spawn_funcs();		// Set spawn functions where needed
	rebirth_setup_flags();					// initialize level flags
	level thread maps\_color_manager::color_manager_think();
	
	maps\rebirth_hudson_lab::corpse_memory_init();
	
	maps\rebirth_hudson_lab::things_for_fx();

	character\gfl\character_gfl_p90::precache();
	character\gfl\character_gfl_9a91::precache();
	character\gfl\character_gfl_saiga12::precache();
}

remove_lmg_anims()
{
	wait_for_first_player();
	
	// KIDS, DON�T TRY THIS AT HOME
	anim.anim_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.pre_move_delta_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.move_delta_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.post_move_delta_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.angle_delta_array["default"]["move"]["stand"]["mg"] = undefined;	
}


/*------------------------------------------------------------------------------------------------------------
																								Jumpto Stuff
------------------------------------------------------------------------------------------------------------*/

/*------------------------------------

------------------------------------*/
event_mason_stealth_jumpto() 
{
	wait_for_first_player();

	maps\createart\rebirth_art::main();
	
	start_teleport( "start_mason_stealth", "mason_hero", true );
	
	rebirth_run_events( "mason_stealth" );
}



/*------------------------------------

------------------------------------*/
event_mason_lab_jumpto()
{
	wait_for_first_player();
	
	start_teleport( "start_mason_lab", "mason_hero", true );
	
	player = get_players()[0];
	player GiveWeapon( "ak74u_sp" );
	player GiveWeapon( "ks23_sp" );
	// player GiveWeapon( "hatchet_sp" );
	player SwitchToWeapon( "ak74u_sp" );
	
	
	rebirth_run_events( "mason_lab" );
}



/*------------------------------------

------------------------------------*/
event_btr_rail_jumpto() 
{
	wait_for_first_player();
	
	maps\rebirth_mason_lab::lab_clean_up();
	open_flash_doors( false );
	level.rebirth_movie = false;
	
	destructible_jeeps = GetEntArray("destructible_jeep", "targetname");
	array_thread(destructible_jeeps, maps\rebirth_mason_lab::jeep_death_damage);
	
	start_teleport( "start_btr_rail", "heroes", true );
	
	rebirth_run_events( "btr_rail" );
}



/*------------------------------------

------------------------------------*/
event_btr_diabled_jumpto() 
{
	wait_for_first_player();
	
	maps\rebirth_mason_lab::lab_clean_up();
	open_flash_doors( false );
	trigger_use( "hudson_btr_riders" );
	wait(.1);
	
	destructible_jeeps = GetEntArray("destructible_jeep", "targetname");
	array_thread(destructible_jeeps, maps\rebirth_mason_lab::jeep_death_damage);
	
	start_teleport( "start_btr_disabled", "hudson_btr_hero", true );
	
	rebirth_run_events( "btr_disabled" );
}



/*------------------------------------

------------------------------------*/
event_gas_attack_jumpto() 
{
	wait_for_first_player();
	
	Objective_Add( level.obj_iterator, "current", &"REBIRTH_OBJECTIVE_2", (0, 0, 0) );

	level.player_viewmodel = "t5_gfl_m16a1_viewmodel";

	player = get_players()[0];
	player SetViewModel( level.player_viewmodel );
	weaponOptions = player calcweaponoptions( 7 );
	player GiveWeapon( "enfield_ir_mk_sp", 0, weaponOptions );
	player GiveWeapon( "hk21_extclip_sp", 0, weaponOptions );
	player SwitchToWeapon( "enfield_ir_mk_sp" );
	
	maps\rebirth_mason_lab::lab_clean_up();
	maps\rebirth_mason_stealth::docks_clean_up();

	open_flash_doors( false );
	
	trigger_use( "spawn_mesh_helis", "script_noteworthy" );
	
	wait(.1);
	
	destructible_jeeps = GetEntArray("destructible_jeep", "targetname");
	array_thread(destructible_jeeps, maps\rebirth_mason_lab::jeep_death_damage);
	
	start_teleport( "start_btr_disabled", "hudson_btr_hero", true );

	battlechatter_on("allies");
	battlechatter_on("axis");
	
	rebirth_run_events( "gas_attack" );
}



/*------------------------------------

------------------------------------*/
event_lab_entrance_jumpto() 
{
	wait_for_first_player();
	
	Objective_Add( level.obj_iterator, "current" );
	
	player = get_players()[0];
	weaponOptions = player calcweaponoptions( 7 );
	player GiveWeapon( "enfield_ir_mk_sp", 0, weaponOptions );
  player GiveWeapon( "hk21_extclip_sp", 0, weaponOptions );
  player SwitchToWeapon( "hk21_extclip_sp" );
	
	maps\rebirth_mason_lab::lab_clean_up();
	open_flash_doors( false );
	
	destructible_jeeps = GetEntArray("destructible_jeep", "targetname");
	array_thread(destructible_jeeps, maps\rebirth_mason_lab::jeep_death_damage);
	
	start_teleport( "start_lab_entrance", "hudson_hero", true );
	
	//level.skipto_lab_entrance = true;
	
	trigger_use( "spawn_redshirts" );
	
	rebirth_run_events( "hudson_lab" );
}

/*------------------------------------

------------------------------------*/
event_security_room_jumpto() 
{
	wait_for_first_player();
	
	maps\rebirth_mason_lab::lab_clean_up();
	open_flash_doors( true );
	start_teleport( "start_security_room", "hudson_hero", true );
  player = get_players()[0];
	weaponOptions = player calcweaponoptions( 7 );
  player GiveWeapon( "enfield_ir_mk_sp", 0, weaponOptions );
  player GiveWeapon( "hk21_extclip_sp", 0, weaponOptions );
  player SwitchToWeapon( "hk21_extclip_sp" );
	
	
	rebirth_run_events( "security_room" );
}



/*------------------------------------

------------------------------------*/
event_steiners_office_jumpto() 
{
	wait_for_first_player();
	
	maps\rebirth_mason_lab::lab_clean_up();
	open_flash_doors( true );
	start_teleport( "start_steiners_office", "hudson_hero", true );
  player = get_players()[0];
	weaponOptions = player calcweaponoptions( 7 );
  player GiveWeapon( "enfield_ir_mk_sp", 0, weaponOptions );
  player GiveWeapon( "hk21_extclip_sp", 0, weaponOptions );
  player SwitchToWeapon( "hk21_extclip_sp" );
	
	
	rebirth_run_events( "steiners_office" );
}



/*------------------------------------

------------------------------------*/
open_flash_doors( set_flag )
{
	level thread maps\rebirth_mason_lab::flash_room_doors();
	
	if( set_flag )
	{
		flag_set( "mason_doors_setup_done" );
		flag_set( "event_lab_entrance_done" );	
	}
	
	door_clip = GetEnt( "mason_door_blocker", "targetname" );	// door near the elevator
	
	if( IsDefined( door_clip ) )
	{
		mason_door_model_blocker = GetEnt( "mason_door_model_blocker", "targetname" );
		mason_door_model_blocker_open = (14505.5, 14488.3, -337);
		door_clip LinkTo( mason_door_model_blocker );
		mason_door_model_blocker MoveTo( mason_door_model_blocker_open, 0.09);
		door_clip ConnectPaths();
		//door ConnectPaths();
		//door Delete();		
	}
	
	maps\rebirth_mason_lab::prevent_hazmat_in_flash();
}



/*------------------------------------------------------------------------------------------------------------
																								Setup Functions
------------------------------------------------------------------------------------------------------------*/

/*------------------------------------

------------------------------------*/
rebirth_init_dvars()
{
	// SetSavedDvar( "sm_sunSampleSizeNear", "0.5" );
	// SetSavedDvar( "r_enableOccluders", "0" );
}



/*------------------------------------

------------------------------------*/
rebirth_setup_variables()
{
	level.obj_iterator = 0;
	level.num_hatchet_kills = 0;
	level.is_btr_rail = false;
	
	level.overrideVehicleDamage = maps\rebirth_gas_attack::vehicle_override_strela_only;
}



/*------------------------------------

------------------------------------*/
rebirth_setup_heroes()
{	
	level.heroes = [];
	
	level.heroes[ "weaver" ] 	= simple_spawn_single( "weaver" ); //GetEnt( "weaver", "targetname" );		// Weaver
	level.heroes[ "reznov" ] 	= simple_spawn_single( "reznov" ); //GetEnt( "reznov", "targetname" );	// Reznov
	
	level.heroes[ "weaver" ].animname = "weaver";
	level.heroes[ "reznov" ].animname = "reznov";
	
	level.heroes[ "reznov" ] wont_disable_player_firing();
	
	wait_for_first_player();
	
	get_players()[0].animname = "hudson";
	get_players()[0] notify( "_gasmask_stop_watching_buttons" );
}



/*------------------------------------

------------------------------------*/
rebirth_setup_spawn_funcs()
{
	dock_patrol_ai 	= GetEntArray( "dock_patroller", "script_noteworthy" );	
	array_thread( dock_patrol_ai, ::add_spawn_function, Maps\rebirth_mason_stealth::dock_patroller_spawnfunc );	
	
	roof_guy1 = GetEntArray( "roof_patroller1", "script_noteworthy" );
	array_thread( roof_guy1, ::add_spawn_function, Maps\rebirth_mason_stealth::roof_ai1_spawnfunc );
	
	roof_guy2 = GetEntArray( "roof_patroller2", "script_noteworthy" );
	array_thread( roof_guy2, ::add_spawn_function, Maps\rebirth_mason_stealth::roof_ai2_spawnfunc );
	
	lab_civs = GetEntArray( "lab_civilians", "script_noteworthy" );
	array_thread( lab_civs, ::add_spawn_function, Maps\rebirth_mason_lab::lab_civs_spawnfunc );
	
	lab_cower_civs = GetEntArray( "lab_cower_civilians", "script_noteworthy" );
	array_thread( lab_cower_civs, ::add_spawn_function, maps\rebirth_mason_lab::lab_civ_idle_react_spawnfunc );
	
	lab_observ_civs = GetEntArray( "lab_observ_civilians", "script_noteworthy" );
	array_thread( lab_observ_civs, ::add_spawn_function, Maps\rebirth_mason_lab::lab_observ_civs_spawnfunc );
	
	mason_lab_flash_guy = GetEnt( "enemy_flashroom", "script_noteworthy" );
	array_thread( mason_lab_flash_guy, ::add_spawn_function, maps\rebirth_mason_lab::mason_lab_flash_guy_spawnfunc );
	
	mason_lab_steiner = GetEnt( "mason_steiner", "script_noteworthy" );
	array_thread( mason_lab_steiner, ::add_spawn_function, maps\rebirth_mason_lab::mason_lab_steiner_spawnfunc );
	
	btr_rail_guys = GetEntArray( "btr_rail_enemies", "script_noteworthy" );
	array_thread( btr_rail_guys, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_spawnfunc );
	
	btr_rail_civs_a = GetEntArray( "btr_rail_civs_a", "script_noteworthy" );
	array_thread( btr_rail_civs_a, ::add_spawn_function, maps\rebirth_btr_rail::btr_runner_spawnerfunc );
	
	btr_rail_civs_b = GetEntArray( "btr_rail_civs_b", "script_noteworthy" );
	array_thread( btr_rail_civs_b, ::add_spawn_function, maps\rebirth_btr_rail::btr_runner_spawnerfunc );		
	
	btr_rail_guys_b = GetEntArray( "btr_rail_guys_b", "targetname" );
	array_thread( btr_rail_guys_b, ::add_spawn_function, maps\rebirth_btr_rail::kill_trig_watcher, "btr_rail_turn_c" );		

	btr_roof_guy_right = GetEntArray( "btr_roof_guy_right", "script_noteworthy" );
	array_thread( btr_roof_guy_right, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_spawnfunc, 32 );
	
	btr_parking_lot_guys = GetEntArray( "parkinglot_enemy", "script_noteworthy" );
	array_thread( btr_parking_lot_guys, ::add_spawn_function, maps\rebirth_btr_rail::btr_parking_lot_kill );
	
	btr_turn_e_guys = GetEntArray( "btr_rail_guys_d", "targetname" );
	array_thread( btr_turn_e_guys, ::add_spawn_function, maps\rebirth_btr_rail::btr_turn_e_kill );
	
	btr_turn_e_guys2 = GetEntArray( "btr_rail_guys_d2", "targetname" );
	array_thread( btr_turn_e_guys2, ::add_spawn_function, maps\rebirth_btr_rail::btr_turn_e_kill );			

//	goal = getstruct("btr_rail_turn_c_guys_goal", "targetname");
	btr_rail_turn_c_guys = GetEntArray( "btr_rail_turn_c_guys", "targetname" );
	array_thread( btr_rail_turn_c_guys, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_turn_c_guys_spawnfunc );
	
	btr_rail_start_enemies = GetEntArray( "btr_rail_guys_start", "targetname" );
	array_thread( btr_rail_start_enemies, ::add_spawn_function, maps\rebirth_btr_rail::btr_starting_enemy );	

	btr_rail_friendlies = GetEntArray( "btr_rail_friendlies", "script_noteworthy" );
	array_thread( btr_rail_friendlies, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_friendlies_spawnfunc, true, true );

	btr_rail_friendlies_c = GetEntArray( "btr_rail_friendlies_c", "targetname" );
	array_thread( btr_rail_friendlies_c, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_friendlies_spawnfunc, false, true );

	molotov_target_1 = GetStruct( "btr_rail_molotov_target_1", "targetname" );
	btr_rail_molotov_throwers = GetEntArray( "btr_rail_molotov_thrower", "script_noteworthy" );
	array_thread( btr_rail_molotov_throwers, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_molotov_thrower_spawnfunc, molotov_target_1 );
	
	btr_rail_molotov_throwers = GetEntArray( "btr_rail_molotov_thrower_player", "script_noteworthy" );
	array_thread( btr_rail_molotov_throwers, ::add_spawn_function, maps\rebirth_btr_rail::btr_rail_molotov_player_spawnfunc );	
	
	btr_runners = GetEntArray( "btr_runner", "targetname" );
	array_thread( btr_runners, ::add_spawn_function, maps\rebirth_btr_rail::btr_runner_spawnerfunc );
	
	btr_runners2 = GetEntArray( "btr_runner2", "targetname" );
	array_thread( btr_runners2, ::add_spawn_function, maps\rebirth_btr_rail::btr_runner_spawnerfunc );			
	
	//btr_rail_enemy_vehicles = GetEntArray( "btr_rail_enemy_vehicle", "script_noteworthy" );
	//array_thread( btr_rail_enemy_vehicles, ::add_spawn_function, maps\rebirth_utility::turn_on_uaz_lights );
	add_spawn_function_veh( "btr_rail_enemy_vehicle", maps\rebirth_utility::turn_on_uaz_lights );
	
	gastown_crash_civs = GetEntArray( "btr_crash_gassed_civ", "targetname" );
	array_thread( gastown_crash_civs, ::add_spawn_function, maps\rebirth_gas_attack::btr_crash_civs );			

	hazmat_allies = GetEntArray( "hudson_btr_hero", "targetname" );
	array_thread( hazmat_allies, ::add_spawn_function, maps\rebirth_gas_attack::gas_hazmat_allies_spawnfunc, 400 );

	hazmat_guys = GetEntArray( "hazmat_spetsnaz", "script_noteworthy" );
	array_thread( hazmat_guys, ::add_spawn_function, maps\rebirth_gas::gas_ai_think );
	array_thread( hazmat_guys, ::add_spawn_function, maps\rebirth_gas_attack::hazmat_guys_spawnfunc );

	left_goal = GetStruct( "gas_attack_weaver_squad_goto_left", "targetname" );
	weaver_guys_left = GetEntArray( "gas_attack_weaver_squad_left", "script_noteworthy" );
	array_thread( weaver_guys_left, ::add_spawn_function, maps\rebirth_gas_attack::gas_weaver_squad_spawnfunc, left_goal.origin );

	right_goal = GetStruct( "gas_attack_weaver_squad_goto_right", "targetname" );
	weaver_guys_right = GetEntArray( "gas_attack_weaver_squad_right", "script_noteworthy" );
	array_thread( weaver_guys_right, ::add_spawn_function, maps\rebirth_gas_attack::gas_weaver_squad_spawnfunc, right_goal.origin );
	
	gas_attack_rushers = GetEntArray( "gas_rusher", "script_noteworthy" );
	array_thread( gas_attack_rushers, ::add_spawn_function, maps\rebirth_gas_attack::gas_rusher_spawnfunc );
	
	corpse_memory_guys = GetEntArray( "lab_int_mason_enemy", "script_noteworthy" );
	array_thread( corpse_memory_guys, ::add_spawn_function, maps\rebirth_hudson_lab::corpse_memory_spawnfunc );
	array_thread( corpse_memory_guys, ::add_spawn_function, maps\rebirth_mason_lab::lab_difficulty_balance_spawnfunc );
	array_thread( corpse_memory_guys, ::add_spawn_function, maps\rebirth_mason_lab::hatchet_achievement_spawnfunc );
	
	ending_hazmat_ai = GetEntArray( "lookat_hazmat_trooper", "targetname" );
	array_thread( ending_hazmat_ai, ::add_spawn_function, maps\rebirth_steiners_office::lab_hazmat_enemies );	
	
	ending_hazmat_ai2 = GetEntArray( "lookat_hazmat_trooper2", "targetname" );
	array_thread( ending_hazmat_ai2, ::add_spawn_function, maps\rebirth_steiners_office::lab_hazmat_enemies );	
	
	last_stand_ai = GetEnt( "last_stand_trooper", "targetname" );
	array_thread( last_stand_ai, ::add_spawn_function, maps\rebirth_steiners_office::last_stand_enemy );	
	
	hobbit_ai = GetEnt( "hobbit_trooper", "targetname" );
	array_thread( hobbit_ai, ::add_spawn_function, maps\rebirth_steiners_office::hobbit_trooper );	
	
	office_redshirts = GetEnt( "office_redshirt", "script_noteworthy" );
	array_thread( office_redshirts, ::add_spawn_function, maps\rebirth_steiners_office::office_redshirts );
	
	office_redshirts = GetEnt( "door_blocker", "script_noteworthy" );
	array_thread( office_redshirts, ::add_spawn_function, maps\rebirth_steiners_office::office_redshirts );			
	
	ending_tunnel_ai = GetEntArray( "tunnel_enemies", "targetname" );
	array_thread( ending_tunnel_ai, ::add_spawn_function, maps\rebirth_steiners_office::track_tunnel_enemies );
	
	ending_tunnel_ai = GetEntArray( "tunnel_enemies", "targetname" );
	array_thread( ending_tunnel_ai, ::add_spawn_function, maps\rebirth_steiners_office::track_tunnel_death );	
	
	ending_ai = GetEntArray( "ending_enemies", "script_noteworthy" );
	array_thread( ending_ai, ::add_spawn_function, maps\rebirth_steiners_office::ending_enemies_think );
	
	ending_ai = GetEntArray( "ending_enemies2", "script_noteworthy" );
	array_thread( ending_ai, ::add_spawn_function, maps\rebirth_steiners_office::ending_enemies_think );	
	
	ending_ai = GetEntArray( "ending_enemies3", "script_noteworthy" );
	array_thread( ending_ai, ::add_spawn_function, maps\rebirth_steiners_office::ending_enemies_kill );	
	
	ending_launch_ai = GetEntArray( "ending_launch_enemies", "script_noteworthy" );
	array_thread( ending_launch_ai, ::add_spawn_function, maps\rebirth_steiners_office::ending_enemies_think );	
	
	hudson_lab_redshirts = GetEntArray( "hudson_lab_redshirts", "script_noteworthy" );
	array_thread( hudson_lab_redshirts, ::add_spawn_function, maps\rebirth_hudson_lab::hudson_lab_redshirts_spawnfunc );
	
	hudson_lab_scientists = GetEntArray( "scientist_lab_hudson", "targetname" );
	array_thread( hudson_lab_scientists, ::add_spawn_function, maps\rebirth_hudson_lab::hudson_lab_scientists_spawnfunc );
	
	hudson_lab_left_window_drones = GetEntArray( "enemy_left_window_drones", "targetname" );
	array_thread( hudson_lab_left_window_drones, ::add_spawn_function, maps\rebirth_hudson_lab::hudson_lab_left_window_drones_spawnfunc );
	
	hudson_lab_right_window_drones = GetEntArray( "enemy_right_window_drones", "targetname" );
	array_thread( hudson_lab_right_window_drones, ::add_spawn_function, maps\rebirth_hudson_lab::hudson_lab_right_window_drones_spawnfunc );
	
	hudson_lab_rpg_left = GetEntArray( "roof_patroller3", "script_noteworthy" );
	array_thread( hudson_lab_rpg_left, ::add_spawn_function, maps\rebirth_hudson_lab::hudson_lab_rpg_left_spawnfunc );
	
	hudson_lab_rpg_right = GetEntArray( "roof_patroller4", "script_noteworthy" );
	array_thread( hudson_lab_rpg_right, ::add_spawn_function, maps\rebirth_hudson_lab::hudson_lab_rpg_right_spawnfunc );
	
	helis = GetEntArray( "destroy_helicopter_backup", "targetname" );
	helis = array_merge( helis, GetEntArray( "gas_attack_strela_heli_1", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "gas_attack_strela_heli_2", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "gas_attack_end_street_heli_1", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "gas_attack_end_street_heli_2", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "gas_attack_end_street_heli_3", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "heli_with_troops_1", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "heli_with_troops_2", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "heli_with_troops_3", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "dynamic_heli", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "scripted_heli", "script_noteworthy" ) );
	helis = array_merge( helis, GetEntArray( "football_heli", "script_noteworthy" ) );
	array_thread( helis, ::add_spawn_function_veh, ::heli_sound_spawnfunc );
}

heli_sound_spawnfunc()
{
	
}


/*------------------------------------

------------------------------------*/
rebirth_setup_characters()
{
	character\c_rus_engineer1_orange_gas::precache();
	// character\c_rus_engineer1_yellow_gas::precache();
	// character\c_rus_engineer1_grey_gas::precache();
	// character\c_rus_engineer1_blue_gas::precache();
	 character\c_usa_rebirth_hazmat_gas::precache();
	// character\c_rus_spetznaz_rebirth_1_corpse::precache();
	character\c_rus_spetznaz_rebirth_2_corpse::precache();
	// character\c_rus_scientist1_corpse::precache();
	//character\c_rus_scientist2_corpse::precache();
	//character\c_rus_scientist3_corpse::precache();

	// setup an array of characters...each array entry is a function pointer to the main for that character
	level.character["engineer_gas_orange"] = character\c_rus_engineer1_orange_gas::main;
	// level.character["engineer_gas_yellow"] = character\c_rus_engineer1_yellow_gas::main;
	// level.character["engineer_gas_grey"] = character\c_rus_engineer1_grey_gas::main;
	// level.character["engineer_gas_blue"] = character\c_rus_engineer1_blue_gas::main;
	level.character["redshirt_hazmat_gas"] = character\c_usa_rebirth_hazmat_gas::main;
	level.character["spetznaz_bloody_corpse1"] = character\c_rus_spetznaz_rebirth_2_corpse::main;
	level.character["spetznaz_bloody_corpse2"] = character\c_rus_spetznaz_rebirth_2_corpse::main;
	// level.character["scientist_bloody_corpse1"] = character\c_rus_scientist1_corpse::main;
	//level.character["scientist_bloody_corpse2"] = character\c_rus_scientist2_corpse::main;
	//level.character["scientist_bloody_corpse3"] = character\c_rus_scientist3_corpse::main;
	level.character["spetznaz_corpse1"] = character\c_rus_spetznaz_rebirth_2::main;
	level.character["spetznaz_corpse2"] = character\c_rus_spetznaz_rebirth_2::main;
}


/*------------------------------------------------------------------------------------------------------------
																									Flags
------------------------------------------------------------------------------------------------------------*/

/*------------------------------------
Create all the level flags
------------------------------------*/
rebirth_setup_flags()
{
	// Event Flags
	
	flag_init( "event_mason_stealth_done" );
	flag_init( "event_mason_lab_done" );
	flag_init( "event_btr_player_linked" );
	flag_init( "event_btr_rail_start" );
	flag_init( "event_btr_rail_rpg_moment" );
	flag_init( "event_btr_rail_turn_b" );
	flag_init( "event_btr_rail_turn_d_weaver");
	flag_init( "event_btr_rail_turn_d");
	flag_init( "event_btr_rail_done" );
	flag_init("disable_weaver_turret");
	flag_init( "event_btr_disabled_done" );
	flag_init( "event_destroy_copter_done" );
	flag_init( "event_gas_attack_start" );
	flag_init( "event_gas_attack_done" );
	flag_init( "event_gas_attack_get_strela" );
	flag_init( "event_gas_attack_got_strela" );
	flag_init( "event_reach_lab_done" );
	flag_init( "event_lab_entrance_done" );
	flag_init( "event_run_to_carter_done" );
	flag_init( "event_steiners_office_done" );
	flag_init( "event_iron_lung_done" );
	flag_init( "event_med_station_done" );
	flag_init( "turn_on_gas_exploders" );
	flag_init( "strela_found" );
	flag_init( "rpg_trigger_0_hit" );
	//flag_init( "sm_lab_ext_0_hit" );
	flag_init( "security_office_start_hit" );
	flag_init("seaknight_lands");
	flag_init( "hudson_in_office" );
	flag_init("hit_resolve");
	flag_init("hit_success");
	flag_init( "breakin_fuse_picked_up" );
	flag_init( "confront_steiner_1" );
	flag_init( "movie_done" );
	flag_init( "stop_rpg_hack" );
	flag_init( "toggle_stealth_on" );
	flag_init( "lab_vo_done" );
	flag_init( "mason_doors_setup_done" );
	flag_init( "hazmat_destroyed" );
	flag_init( "killed_in_flashroom" );
	//flag_init( "delete_flashroom_color" );
	//flag_init( "fuse_picked_up" );
	
	// Mason Stealth Section
	flag_init( "start_crate_stopped" );
	flag_init( "crane_start" );
	flag_init( "crate_dialogue_done" );
	flag_init( "crate_investigate_done" );
	flag_init( "crate_kill_success" );
	flag_init( "crate_kill_done" );
	flag_init( "first_pass_clear" );
	flag_init( "crate_drop_done" );
	flag_init( "first_cover_done" );
	flag_init( "second_crate_drop_done" );
	flag_init( "patrol_clear" );
	flag_init( "second_cover_done" );
	flag_init( "second_hatchet_kill_ready" );
	flag_init( "second_pass_clear" );
	flag_init( "hatchet_kill_prompt" );
	flag_init( "hatchet_kill_start" );
	flag_init( "hatchet_kill_speedup" );
	flag_init( "hatchet_kill_success" );
	flag_init( "hatchet_kill_fail" );
	flag_init( "hatchet_throw_done" );
	flag_init( "third_pass_clear" );
	flag_init( "third_cover_done" );
	flag_init( "lab_approach_done" );
	flag_init( "pull_down_start" );
	flag_init( "pull_down_success" );
	flag_init( "pull_down_resolve" );
	flag_init( "pull_down_done" );
	flag_init( "distant_explosion_triggered" );
	flag_init( "distant_explosion_done" );
	flag_init( "roof_guard_died" );
	flag_init( "player_at_elevator" );
	flag_init( "elevator_slide_start" );
	flag_init( "elevator_slide_done" );
	flag_init( "player_slide_done" );
	flag_init( "elevator_kill_reznov_start" );
	flag_init( "elevator_vig_done" );
	flag_init( "elevator_kill_done" );
	flag_init( "takeover_fade_clear" );
	flag_init( "takeover_fade_done" );
	
	flag_init( "hatchet_achieve_given" );
}



/*------------------------------------------------------------------------------------------------------------
																						Objectives and Events
------------------------------------------------------------------------------------------------------------*/



///*------------------------------------
//
//------------------------------------*/
//rebirth_advance_level( advance_string )
//{
//	switch( advance_string )
//	{
//		case "event_start_level":
//			rebirth_advance_objective( "Sneak to the Lab's Roof", undefined, level.heroes["reznov"].targetname, false );
//			maps\rebirth_mason_stealth::event_mason_stealth();
//			break;
//			
//		case "event_carter_start_done":
//			rebirth_advance_objective( "Find Steiner's Office", "obj_find_steiner", undefined, false );
//			Maps\rebirth_town::event_carter_hunt_office();
//			break;
//			
//		case "event_carter_hunt_office_done":
//			rebirth_advance_objective( "Ride the BTR Through Town", "obj_ride_btr", undefined, false );
//			maps\rebirth_lab::event_btr_rail();
//			break;
//			
//		case "event_btr_rail_done":
//			rebirth_advance_objective( "Fight up street to find cover.", "obj_find_cover", undefined, true );
//			maps\rebirth_lab::event_street_battle();
//			break;
//			
//		case "event_btr_disabled_done":
//			rebirth_advance_objective( "Find the other squad's BTR", "obj_find_sam", undefined, false );
//			maps\rebirth_lab::event_village_walk();
//			break;
//			
//		case "event_gas_attack_done":
//			rebirth_advance_objective( "Use the Strela to destroy the Helicopter", "obj_shoot_copter", undefined, true );
//			maps\rebirth_lab::event_destroy_helicopter();
//			break;			
//			
//		case "event_destroy_copter_done":
//			rebirth_advance_objective( "Reach the Lab", undefined, level.heroes["weaver"].targetname, true );
//			maps\rebirth_lab::event_reach_lab();
//			break;
//			
//		case "event_reach_lab_done":
//			rebirth_advance_objective( "Explore the Lab", "obj_explore_lab", undefined, true );
//			maps\rebirth_lab::event_explore_lab();
//			break;
//			
//		case "event_lab_entrance_done":
//			rebirth_advance_objective( "Find Steiner's Office", "obj_outside_office", undefined, false );
//			maps\rebirth_lab::event_run_to_carter();
//			break;	
//			
//		case "event_run_to_carter_done":
//			rebirth_advance_objective( "Escort Carter Outside", undefined, level.heroes["weaver"].targetname, false );
//			maps\rebirth_lab::event_steiners_office();
//			break;
//
//		case "event_steiners_office_done":
//			rebirth_advance_objective( "Escort Carter Outside", undefined, level.heroes["weaver"].targetname, true );
//			maps\rebirth_iron_lung::event_iron_lung();
//			break;
//			
//		default:
//
//			break;
//	}
//}
//
//
//
///*------------------------------------
//
//------------------------------------*/
//rebirth_advance_objective( obj_string, obj_struct_name, obj_ent_name, make3d )
//{
//	objective_state( level.obj_iterator, "done" );
//	level.obj_iterator++;
//
//	if( IsDefined( obj_struct_name ) )
//	{
//		obj_pos = getstruct( obj_struct_name, "targetname" );
//		objective_add( level.obj_iterator, "current", obj_string, obj_pos.origin );
//	}
//	else if( IsDefined( obj_ent_name ) )
//	{
//		obj_pos = GetEnt( obj_ent_name, "targetname" );
//		objective_add( level.obj_iterator, "current", obj_string, obj_pos );
//	}
//	
//	if( make3d )
//	{
//		objective_Set3d( level.obj_iterator, true );
//	}
//	
//	autosave_by_name( "rebirth" );	// Save whenever objective is updated
//}



//------------------------------------
// Sets the event functions into an array.
// This is used to determine event order
rebirth_level_order()
{
	level.event_funcs 			= [];
	level.event_func_index 	= [];
	
	// Creates the event_funcs array.  Events are called in the reverse order they are defined
	level.event_funcs[ "steiners_office" ]	= maps\rebirth_steiners_office::event_steiners_office;
	level.event_funcs[ "security_room" ]	= maps\rebirth_steiners_office::event_security_room;
	level.event_funcs[ "hudson_lab" ] 			= maps\rebirth_hudson_lab::event_hudson_lab;
	level.event_funcs[ "gas_attack" ] 			= maps\rebirth_gas_attack::event_gas_attack;
	level.event_funcs[ "btr_rail" ] 				= maps\rebirth_btr_rail::event_btr_rail;
	level.event_funcs[ "mason_lab" ] 				= maps\rebirth_mason_lab::event_mason_lab;
	level.event_funcs[ "mason_stealth" ] 		= maps\rebirth_mason_stealth::event_mason_stealth;	
}



//------------------------------------
// Runs the events in order
rebirth_run_events( start_key )
{
	event_iterator = undefined;
	keys = GetArrayKeys( level.event_funcs );
	
	// find the starting key here
	for( i = 0; i < keys.size; i++ )
	{
		if( keys[i] == start_key )
		{
			event_iterator = i;
			break;
		}
	}
	
	while( true )
	{
		[[ level.event_funcs[ keys[event_iterator] ] ]]();
		if( keys[event_iterator] != "mason_lab" )
		{
			autosave_by_name( "rebirth" );
		}
		event_iterator++;		
	}
}
 