/*
	WMD
	Script: Chris Pierro, June Park, Dan Laufer, Walter Williams
	Build: Brian Glines

*/
#include maps\_utility;
#include common_scripts\utility;
#include maps\wmd_util;
#include maps\_anim;
#include maps\_music;
#include maps\_rusher;


main()
{
	// This MUST be first for CreateFX!
	maps\wmd_fx::main();
	
	level thread maps\wmd_util::screen_fade_in();
	
	//-- Starts
	default_start( ::wmd_events );
	add_start( "com_stat",::skipto_comstation, &"WMD_START_COMSTATION");
	add_start( "base_jump", ::skipto_base_jump, &"WMD_START_BASEJUMP" );
	add_start( "breach_start", ::skipto_breach, &"WMD_START_BREACH" );
	add_start( "snow_ambush",::skipto_snow_ambush, &"WMD_SNOW_AMBUSH");
	add_start( "ledge",::skipto_ledge, &"WMD_LEDGE");
	add_start( "rappel", ::skipto_rappel, &"WMD_RAPPEL");
	add_start( "base", ::skipto_base, &"WMD_BASE");
	add_start( "steiner_office", ::skipto_warehouse, &"WMD_STEINER" );
	add_start( "avalanche", ::skipto_avalanche, &"WMD_AVALANCHE" );
	
	// -- WWILLIAMS: WILL DISABLE _ART.GSC FROM OVERRIDING STARTING DOF
	level.do_not_use_dof = true;
	
	level.supportsPistolAnimations = true;

	precache_level_assets();
	// maps\wmd_rts::precache_materials();
	// maps\wmd_anim::init_rts_sounds();
	maps\wmd_anim::wmd_dialogue();
	
	maps\_load::main();
	
	level.avalanche_wall_clean = GetEnt( "ava_wall_hide", "targetname" );
	level.avalanche_wall_fxanim = GetEnt( "fxanim_wmd_ava_wall_mod", "targetname" );
	level.avalanche_wall_fxanim Hide();
	
	level thread breach_window_models();
	level thread power_visionset_out();
	level thread radar_visionset_in();
	level thread radar_visionset_out();
	level thread glo_hinges();
	
	//alt weapons
	enable_random_alt_weapon_drops();
	set_random_alt_weapon_drops( "gl", true );
	set_random_alt_weapon_drops( "mk", false );
	set_random_alt_weapon_drops( "ft", false );
	
	// stealth init
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	= 70;
	hidden[ "crouch" ]	= 250;
	hidden[ "stand" ]	= 750;

	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	= 140;
	alert[ "crouch" ]	= 512;
	alert[ "stand" ]	= 750;

	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 512;
	spotted[ "crouch" ]	= 1000;
	spotted[ "stand" ]	= 1800;
	
	maps\_stealth_logic::stealth_detect_ranges_set( hidden, alert, spotted );
	
	// dog
	animscripts\dog_init::initDogAnimations();
	
	// setup the rusher behavior
	maps\_rusher::init_rusher();
	
	maps\wmd_amb::main();
	maps\wmd_anim::main();
	
	//door breach init
	maps\_door_breach::door_breach_init("t5_gfl_m16a1_viewbody");
	
	init_level_flags();
	// maps\wmd_rts::init_rts_flags();
	battlechatter_off("allies");
	// maps\wmd_fx::clouds();	
	
	//delete the old SR71 screen -- NEED TO REMOVE THE ENT FROM RADIANT
	// old_screen = getent("sr71_screen","targetname");
	// old_screen delete();
	
	////Depricated system now set in ART GSC/////////////////
	//SetDvar( "r_heroLightScale", "1.5 1.5 1.5" );
	SetDvar( "ui_deadquote", "" );
	
	// -- WWILLIAMS: DEFINE AND HIDE THE SCRIPT BRUSHMODEL OF THE MOUNTAIN
	level.avalanche_brush = GetEnt( "avalanche_geo", "targetname" );
	level.avalanche_brush Hide();
	
	// -- WWILLIAMS: DEFINE THE FXANIM LEDGE PIECE AND HIDE IT
	level.broken_ledge_fx = GetEnt( "fxanim_wmd_catwalk_mod", "targetname" );
	level.broken_ledge_fx Hide();
	
	// -- WWILLIAMS: CHANGING HOW THE OBJS WORK SO IT ISN'T SPREAD ACROSS FOUR FILES
	level thread maps\wmd_util::wmd_objectives();
	
	flag_wait("all_players_connected");
	
	get_players()[0] SetClientDvar( "cg_defaultFadeScreenColor", "1 1 1 0" );
}


radar_visionset_in()
{
	trigin = getentarray("trigger_vision_insideradar", "targetname");
	for( i=0; i<trigin.size; i++)
	{
		trigin[i] thread visionset_in();
	}
}


visionset_in()
{
	while(1)
	{
		self waittill("trigger", ent);
	
		VisionSetNaked( "wmd_radar_station" );
		
		while(ent isTouching(self))
		{
			wait(0.05);
		}
	}
}


radar_visionset_out()
{
	trigout = getentarray("trigger_vision_outsideradar", "targetname");
	for( i=0; i<trigout.size; i++)
	{
		trigout[i] thread visionset_out();
	}
}


visionset_out()
{
	while(1)
	{
		self waittill("trigger", ent);
	
		VisionSetNaked( "wmd" );
		
		while(ent isTouching(self))
		{
			wait(0.05);
		}
	}
}


power_visionset_out()
{
	trigout = getent("trigger_vision_outsidepower", "targetname");
	trigout waittill("trigger");
	
	VisionSetNaked( "wmd" );
	
	level thread power_visionset_in();
}


power_visionset_in()
{
	trigin = getent("trigger_vision_insidepower", "targetname");
	trigin waittill("trigger");
	
	VisionSetNaked( "wmd_power_station" );
	
	level thread power_visionset_out();
}


breach_window_models()
{
	solid1 = getent( "breach_window_solid_1", "targetname" );
	cracked1 = getent( "breach_window_cracked_1", "targetname" );
	damaged1 = getent( "breach_window_damaged_1", "targetname" );
	solid2 = getent( "breach_window_solid_2", "targetname" );
	cracked2 = getent( "breach_window_cracked_2", "targetname" );
	damaged2 = getent( "breach_window_damaged_2", "targetname" );
	
	if(isDefined(cracked1))
	{
		cracked1 hide();
		cracked2 hide();
		damaged1 hide();
		damaged2 hide();	
	}
}


glo_hinges()
{
	glo_hinge_bot = getent("glo_hinge_bot", "targetname");
	glo_hinge_top = getent("glo_hinge_top", "targetname");
	
	glo_hinge_bot notsolid();
	glo_hinge_top notsolid();
}


precache_level_assets()
{
	// -- WWILLIAMS: WMD STUFF
	PreCacheModel("p_jun_basejump_parachute");		
	PrecacheModel("viewmodel_usa_marine_player_legs");
	PrecacheModel("tag_origin_animate");
	PreCacheModel("anim_rus_rappel_rope");
	PrecacheModel("anim_jun_rappel_rope");
	PrecacheModel("Dest_rus_powerbox_case_d1");
	PrecacheModel("t5_weapon_crossbow_viewmodel_arctic");
	PreCacheModel("viewmodel_usa_blackops_winter_player");
	PrecacheModel("viewmodel_knife");
	PreCacheModel("viewmodel_hands_no_model");
	PreCacheModel("weapon_parabolic_knife");
	
	PreCacheModel("p_rus_reel_disc");
	PreCacheModel("dest_glo_paper_01_d0");
	PreCacheModel("dest_glo_paper_02_d0");
	PreCacheModel("p_rus_crumpled_paper_01");
	
	PreCacheModel("p_rus_camera");
	
	PreCacheModel("t5_veh_gaz66_troops_dead");
	PreCacheModel("t5_veh_gaz66_dead");
	PreCacheModel("t5_veh_gaz66_tanker_dead");
	PreCacheModel("t5_veh_gaz66_troops");
	PreCacheModel("t5_weapon_garrot_wire");
	PreCacheModel("t5_weapon_cz75_world");

	PreCacheModel( "t5_gfl_m16a1_viewmodel" );
	PreCacheModel( "t5_gfl_m16a1_viewmodel_player" );
	PreCacheModel( "t5_gfl_m16a1_viewbody" );

	PreCacheItem( "crossbow_explosive_alt_sp" );
	precacheItem( "explosive_bolt_sp" );
	PreCacheItem ("rpg_magic_bullet_sp");
	
	PreCacheItem( "aug_arctic_acog_silencer_sp" );
	PreCacheItem( "aug_arctic_acog_sp" );
	
	PreCacheItem( "famas_sp" );	
	PreCacheItem( "famas_acog_sp" );	
	PreCacheItem( "famas_dualclip_sp" );	
	PreCacheItem( "famas_elbit_sp" );	
	PreCacheItem( "famas_gl_sp" );
	PreCacheItem( "gl_famas_sp" );
	PreCacheItem( "famas_reflex_sp" );	
	PreCacheItem( "cz75_auto_sp" );
	PreCacheItem( "cz75dw_auto_sp" );
	PreCacheItem( "cz75lh_auto_sp" );
	PreCacheItem( "hk21_sp" );	
	PreCacheItem( "hk21_acog_sp" );
	PreCacheItem( "hk21_reflex_sp" );	
	PreCacheItem( "hk21_extclip_sp" );
	PreCacheItem( "skorpion_sp" );
	PreCacheItem( "skorpion_extclip_sp" );
		
	PreCacheShellShock("explosion");
	
	// Rumble
	// -- WWILLIAMS: WMD RUMBLE
	PrecacheRumble("tank_fire");
	PrecacheRumble("rappel_falling");
	precacherumble("damage_heavy");
	precacherumble("damage_light");
	precacherumble("grenade_rumble");

	PreCacheModel( "t5_gfl_m16a1_viewmodel" );
	PreCacheModel( "t5_gfl_m16a1_viewmodel_player" );
	PreCacheModel( "t5_gfl_m16a1_viewbody" );

	PreCacheItem( "ak12_zm" );
}


init_level_flags()
{	
	flag_init( "heroes_spawned" );
	flag_init( "obj_insertion_a" ); // -- WWILLIAMS: INSERTION OBJECTIVE PART A
	flag_init( "obj_insertion_b" ); // -- WWILLIAMS: INSERTION OBJECTIVE PART B
	flag_init( "obj_insertion_c" ); // -- WWILLIAMS: INSERTION OBJECTIVE PART C
	flag_init( "obj_substation" ); // -- WWILLIAMS: SUBSTATION OBJECTIVE
	flag_init( "obj_personnel_a" ); // -- WWILLIAMS: APPROACH RADAR PERSONNEL OBJECTIVE A
	flag_init( "obj_personnel_a_b" ); // -- WWILLIAMS: USED TO MOVE THE 3D TEXT TO THE RIGHT SPOT DURING APPROACH
	flag_init( "obj_personnel_a_c" ); // -- WWILLIAMS: USED TO MOVE THE 3D OBJ TO THE DOOR THE PLAYER BREACHES
	// -- WWILLIAMS: RADAR PERSONNEL OBJECTIVE B IS HANDLED BY FLAG - hut_breach_ended
	flag_init( "obj_radar" ); // -- WWILLIAMS: RADAR DISABLE OBJECTIVE
	// -- WWILLIAMS: JUMP POINT OBJECTIVE IS COMPLETED BY FLAG - relay_station_sabotaged
	flag_init( "obj_to_steiner_office" );

	
	flag_init("power_bld_guards_clear"); // add something here 
	//relay station
	flag_init("player_went_left");
	flag_init("player_went_right");
	
	flag_init("woodchoppers_dead");
	flag_init ("gaz_guys_dead");	
	flag_init ("right_side_talkers_dead");	
	flag_init ("left_side_talkers_dead");

	flag_init ("roof_guy_dead");	

	flag_init ("radar_guy_dead");
	flag_init("smoker_dead");
	
	flag_init ("left_side_clear");
	flag_init ("right_side_clear");
	
	flag_init ("weapons_hold");
	flag_init ("weapons_free");
	
	flag_init("hut_breach_go");
	flag_init ("breach_begin");
	flag_init ("hut_breach_ended");

	flag_init("player_signaled_reznov");
	flag_init("begin_reznov_distraction");
	flag_init ("reznov_distraction_complete");
	flag_init("relay_station_sabotaged");
	flag_init("relay_station_cleared");
	flag_init("relay_guys_dead");
	
	flag_init("on_roof");
	
	//jump	
	flag_init("end_sprint_hint");
	flag_init("players_jumped");
	flag_init("players_landed");
	flag_init( "basejump_toolate" );
	flag_init("player_pulled_chute");
	flag_init("parachute_anim_triggered");
	flag_init("kristina_landed");
	flag_init("player_in_lz");
	flag_init("dont_adjust_threatbias");
	flag_init("kristina_protected");
	flag_init("start_ambush");
	flag_init("missile_react");
	flag_init("allow_alert");
	flag_init("area_alerted");
	
	//base jump
	flag_init("end_freefall");
	flag_init("ai_pull_chute");
	flag_init("weaver_caught_up");
	flag_init("cord_pull");
	
	flag_init( "patrol_done" );
	flag_init("alert_dog");
	flag_init("kill_dog");
	flag_init("prone_over");
	flag_init( "dog_gone" );
	flag_init("dog_ran");
	flag_init("dog_dead");
	flag_init( "hide_again" );
	flag_init( "go_hot" );
	flag_init("clear_rappel");
	flag_init("hookup");
	flag_init("player_on_roof");
	flag_init("weaver_hookup");
	flag_init("breach_ago");
	flag_init( "go_breach" );
	flag_init("victim_dead");
	flag_init( "window_breached" );
	flag_init( "restore_time" );
	flag_init("approach_choppers");
	flag_init("harris_inposition");
	flag_init("weaver_inposition");
	flag_init("stairs_base");
	flag_init( "target_choppers" );
	flag_init( "choppers_alerted" );
	flag_init("kill_chopper");
	flag_init("go_wheelbarrow");
	flag_init("smoker_shot");
	flag_init("welder_shot");
	flag_init("fueler_shot");
	flag_init("scraper_shot");
	flag_init("shed_alerted");
	flag_init("gaz_alerted");
	flag_init("shoveler_alerted");
	flag_init("shoveler1_shot");
	flag_init("shoveler2_shot");
	flag_init( "jump_down" );
	flag_init("snowcat_arrived");
	flag_init("snowcat_exited");
	flag_init("snowcat_alerted");
	flag_init("passenger_dead");
	flag_init( "crossroad" );
	flag_init("shovelers_dead");
	flag_init("truck_boom");
	//flag_init( "approach" );
	flag_init( "stackup" );
	flag_init("hinge_breach");
	flag_init("stair_dead");
	flag_init("weaver_knife");
	flag_init("knife_done");
	flag_init("kill_spawns");
	flag_init("explosive_hint");
	
	flag_init("to_ledge");
	flag_init("rpg_shoot");
	flag_init("rpg_shot");
	flag_init("lost_harris");
	flag_init("jumped_gap");
	flag_init("squad_go");
	flag_init("approach_jump");
	/////////////////////////////////////////////////////////////////
	
	/*
	// -- BASE FLAGS
	*/
	flag_init( "player_opened_chute" );
	flag_init( "player_in_base" );
	
	flag_init( "field_line_fallback" );
	flag_init( "field_backup_spawned" );
	
	flag_init( "player_field_comment" );
	flag_init( "field_russian_dialogue_1" );
	
	flag_init("mg_activate");
	flag_init( "street_mggunner" );
	flag_init( "street_truck_destroyed" );
	
	flag_init( "interior_door_kick" );
	flag_init( "interior_prepped" );
	
	flag_init( "warehouse_fight_prepare" );
	flag_init( "warehouse_fight_ready" );
	flag_init( "warehouse_doors_phase_1" );
	flag_init( "warehouse_doors_open" );
	flag_init( "warehouse_defend" );
	flag_init( "warehouse_mg_dead" );
	flag_init( "warehouse_front" );
	flag_init( "warehouse_rear" );
	flag_init( "warehouse_cleared" );
	flag_init( "warehouse_out_to_street" );
	flag_init( "run_for_truck" );
	flag_init( "warehouse_timer_on" );
	flag_init( "warehouse_timer_off" );
	
	flag_init("open_steiner");
		
	flag_init( "steiner_office_prep" );
	flag_init( "steiner_office_weaver_present" );
	flag_init( "steiner_office_brooks_present" );
	flag_init( "steiner_office_start_main" );
	
	flag_init("mounting_truck");
	flag_init( "player_on_truck" );
	
	flag_init("ready_explosion");
	flag_init( "base_explosions" );
	flag_init( "base_explosions_done" );
	flag_init( "base_quiet_before_storm_done" );
	flag_init( "base_stirred" );
	flag_init( "base_shaken" );
	
	flag_init("truck_ready");
	flag_init("truck_go");
	
	flag_init("avalanche_go");
	flag_init( "start_avalanche" );
	flag_init( "mid_avalanche" );
	flag_init( "finish_avalanche" );
		
	flag_init( "base_complete" );
	
	/*
	// -- BASE FLAGS
	*/
	
	//level variables
	level.PLAYER_CHUTE_HEIGHT = 20000;
	level.AI_CHUTE_HEIGHT = 18000;	
}


/*------------------------------------
set up some player values to be referenced later
self = a player
------------------------------------*/
init_player_vars()
{
	
	self._fall_speed_up = 150;
	self._fall_speed_down = 30;
	self._fall_speed_left_right = 80;
	self._fall_inc = .5;
	self._fall_z = 10;
	
	self._chute_speed_up = 20;
	self._chute_speed_down = 10;
	self._chute_speed_left_right = 10;
	self._chute_inc = 2;
	
	self._hint_height  = 20000;
	
}

/*------------------------------------
Initialize the objectives

TODO - use flags for objective states and break them off into seperate functions per each objective
rather than monitoring triggers in this function
------------------------------------*/
init_objectives()
{
	//objective triggers 
	obj1 = getent("objective_1","script_noteworthy");
	obj2 = getent("objective_2","script_noteworthy");
	obj3 = getent("objective_3","script_noteworthy");
	obj4 = getent("objective_4","script_noteworthy");
	obj5 = getent("objective_5","script_noteworthy");
	obj6 = getent("objective_6","script_noteworthy");
	
	objective_add(0,"current",&"WMD_OBJ_1A");							//Neutralize secrity personel
	Objective_Add(1,"current",&"WMD_OBJ_1",obj1.origin); //Disable security dish
	

	//wait for all enemies to be killed and the station to be sabotaged
	flag_wait("relay_station_sabotaged");
	objective_state(0,"done");
	
	objective_state(1,"done");
	Objective_Set3D( 1, 0); 
	
	//obj 2 - rendezvous at the jump point
	// put on harris to guide out of room
	Objective_Add(2,"current",&"WMD_OBJ_2" );	
	Objective_Set3D( 2, 1,"default",&"WMD_OBJ_FOLLOW"); 
	Objective_Position( 2, level.heroes["glines"]);
	
	//take off harris and move to weaver
	trigger_wait("ledge_shoot");

	wait 3;	//pause before updating to weaver
	Objective_Position ( 2, level.heroes["kristina"]);
	
	trigger_wait("start_parachute_vignette");
	Objective_Set3D( 2,1); 
	Objective_Position( 2, obj2.origin);
		
	flag_wait ("players_jumped");
	objective_state(2,"done");	
	Objective_Set3D( 2, 0); 
		
	flag_wait("players_landed");	
	//autosave_by_name( "wmd" );
	
	//TODO add the remaining objectives
}

/*------------------------------------
// -- WWILLIAMS: SET UP VEHICLES AT THE END OF SPLINES IN ORDER TO SAVE THE PATH DATA PROPERLY
// -- THIS DELETES THOSE VEHICLES TO MAKE SURE IT WORKS PROPERLY AT RUN TIME
------------------------------------*/
wmd_clean_up_pathing_vehicles()
{
	delete_vehicles = GetEntArray( "vehicle_collision_delete_asap", "targetname" );
	
	array_delete( delete_vehicles );
}


/*------------------------------------
default start of the level 
------------------------------------*/
wmd_events()
{	
	level thread maps\wmd_approach_radar::rotate_radar_dish();
	maps\wmd_snow_hide::snow_hide_main();
	maps\wmd_approach_radar::approach_main();
	
	//radar_station(interior)
	maps\wmd_radar::radar_main();
	
	//basejump
	maps\wmd_basejump::basejump_main();

	// -- WWILLIAMS: BASE
	level maps\wmd_base::base_main();
}



skipto_comstation()
{
	flag_wait("all_players_spawned");
	
	level thread maps\wmd_approach_radar::rotate_radar_dish();
	level thread maps\wmd_util::wmd_objectives();
	maps\wmd_approach_radar::teleport_to_skipto();
	
	level.weaver animscripts\shared::placeweaponOn(level.weaver.secondaryweapon, "none");
	level.brooks animscripts\shared::placeweaponOn(level.brooks.secondaryweapon, "none");
	level.harris animscripts\shared::placeweaponOn(level.harris.secondaryweapon, "none");
	
	maps\wmd_approach_radar::approach_main();
	maps\wmd_radar::radar_main();
	level maps\wmd_base::base_main();
}


//catwalk after radar room
skipto_ledge()
{
	flag_wait("all_players_spawned");
	
	//spawn in hero characters
	spawn_heros();

	player_spots = getstructarray("ledge_skipto","targetname");
	ai_spots = getstructarray("ledge_skipto_ai","targetname");
	
	level.heroes["kristina"].anchor = spawn("script_origin",level.heroes["kristina"].origin);
	level.heroes["kristina"] linkto(level.heroes["kristina"].anchor);
	level.heroes["kristina"].anchor moveto(ai_spots[0].origin,.05);
	level.heroes["kristina"].anchor waittill("movedone");
	level.heroes["kristina"].anchor.angles = ai_spots[0].angles;
	level.heroes["kristina"] unlink();
	level.heroes["kristina"].anchor delete();
	
	level.heroes["pierro"].anchor = spawn("script_origin",level.heroes["pierro"].origin);
	level.heroes["pierro"] linkto(level.heroes["pierro"].anchor);
	level.heroes["pierro"].anchor moveto(ai_spots[1].origin,.05);
	level.heroes["pierro"].anchor waittill("movedone");
	level.heroes["pierro"].anchor.angles = ai_spots[1].angles;
	level.heroes["pierro"] unlink();
	level.heroes["pierro"].anchor delete();	
	
	//put harris on ledge
	node = GetNode( "ledge_death", "targetname" );
	level.heroes["glines"]forceteleport( node.origin );
	level.heroes["glines"] SetGoalNode(node);
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] setorigin(player_spots[i].origin);
		players[i] setplayerangles(player_spots[i].angles);
	}
	
	// -- WWILLIAMS: SET THESE FLAGS FOR THE OBJECTIVES
	// -- TODO: THERE HAS TO BE A BETTER WAY TO DO THIS
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
	flag_set( "hookup" );
	flag_set( "obj_personnel_a" );
	flag_set( "obj_personnel_a_b" );
	flag_set("hinge_breach");
	flag_set( "hut_breach_ended" );
	flag_set( "obj_personnel_a_c" );
	flag_set( "obj_radar" );	
	flag_set( "relay_station_sabotaged" );
		
	level thread maps\wmd_radar::ledge();
	level thread maps\wmd_radar::launch_sa2_and_react();
	level thread maps\wmd_radar::base_jump();
	level thread maps\wmd_basejump::basejump_main();
	level thread maps\wmd_radar::guys_climb_cliff();
	
	//set off flags and triggers
	flag_set("relay_station_cleared");
	flag_set("relay_station_sabotaged");
	level notify( "stop_radar_dish" ); // -- WWILLIAMS: STOPS THE NEW FX ANIM WAITING FOR A NOTIFY
	wait 1;
	activate_trigger_with_targetname("ledge_spawn");
	
	flag_wait("players_jumped");
	//maps\wmd_event2::event2_main();
	level.heroes["pierro"].ignoreme = false;	
	
	level maps\wmd_base::base_main();
}



/*------------------------------------
starts the player directly at the base jump event
------------------------------------*/
skipto_base_jump()
{
	flag_wait("all_players_spawned");
	
	//spawn in hero characters
	spawn_heros();

	player_spots = getstructarray("jump_skipto","targetname");
	ai_spots = getstructarray("jump_skipto_ai","targetname");
	
	level.heroes["kristina"].anchor = spawn("script_origin",level.heroes["kristina"].origin);
	level.heroes["kristina"] linkto(level.heroes["kristina"].anchor);
	level.heroes["kristina"].anchor moveto(ai_spots[0].origin,.05);
	level.heroes["kristina"].anchor waittill("movedone");
	level.heroes["kristina"].anchor.angles = ai_spots[0].angles;
	level.heroes["kristina"] unlink();
	level.heroes["kristina"].anchor delete();
	level.heroes["kristina"] SetGoalPos( ai_spots[0].origin );
	
	
	level.heroes["pierro"].anchor = spawn("script_origin",level.heroes["pierro"].origin);
	level.heroes["pierro"] linkto(level.heroes["pierro"].anchor);
	level.heroes["pierro"].anchor moveto(ai_spots[1].origin,.05);
	level.heroes["pierro"].anchor waittill("movedone");
	level.heroes["pierro"].anchor.angles = ai_spots[1].angles;
	level.heroes["pierro"] unlink();
	level.heroes["pierro"].anchor delete();	
	level.heroes["pierro"] SetGoalPos( ai_spots[1].origin );
	
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] setorigin(player_spots[i].origin);
		players[i] setplayerangles(player_spots[i].angles);
	}
	
	// -- WWILLIAMS: SET THESE FLAGS FOR THE OBJECTIVES
	// -- TODO: THERE HAS TO BE A BETTER WAY TO DO THIS
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
	flag_set( "hookup" );
	flag_set( "obj_personnel_a" );
	flag_set( "obj_personnel_a_b" );
	flag_set( "hinge_breach");
	flag_set( "hut_breach_ended" );
	flag_set( "obj_personnel_a_c" );
	flag_set( "obj_radar" );	
	flag_set( "relay_station_sabotaged" );
	flag_set( "relay_station_cleared");
	
	players = get_players();
	GetEnt( "ledge_shoot", "targetname" ) UseBy( players[0] );
	wait( 0.05 );
	GetEnt( "start_parachute_vignette", "targetname" ) UseBy( players[0] );
	
	level notify( "stop_radar_dish" ); // -- WWILLIAMS: STOPS THE NEW FX ANIM WAITING FOR A NOTIFY
	

	
	//level thread maps\wmd_radar::ledge();
	//level thread maps\wmd_radar::launch_sa2_and_react();
	level thread maps\wmd_radar::base_jump();
	level thread maps\wmd_basejump::basejump_main();
	//level thread maps\wmd_radar::guys_climb_cliff();
	
	level.weaver animscripts\shared::placeweaponOn(level.weaver.secondaryweapon, "none");
	level.brooks animscripts\shared::placeweaponOn(level.brooks.secondaryweapon, "none");
	level.harris animscripts\shared::placeweaponOn(level.harris.secondaryweapon, "none");
	
	level thread maps\wmd_util::wmd_objectives();
	
	//trigger guys to climb
	//activate_trigger_with_targetname( "goto_missile_launch" );	
	
	//starts base jump anim
	level notify( "missile_done" );
	
	flag_wait("players_jumped");
	//maps\wmd_event2::event2_main();
	level.heroes["pierro"].ignoreme = false;	
	
	level maps\wmd_base::base_main();
	
}

skipto_breach()
{
	flag_wait("all_players_spawned");
	
	spawn_heros();
	
	flag_set( "heroes_spawned" );
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
	flag_set( "hookup" );
	flag_set("victim_dead");
	flag_set("stackup");
	flag_set("stair_dead");
		
	player_spots = getstructarray("breach_skipto","targetname");
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] setorigin(player_spots[i].origin);
		players[i] setplayerangles(player_spots[i].angles);
	}
	
	wait(0.1);
	
	level.weaver = getent("spawner_weaver_ai", "targetname");
	
	level.weaver animscripts\shared::placeweaponOn(level.weaver.secondaryweapon, "none");
	level.brooks animscripts\shared::placeweaponOn(level.brooks.secondaryweapon, "none");
	
	level thread player_speed_control();
	level thread init_idle_nodes();
	
	level thread maps\wmd_approach_radar::rotate_radar_dish();
	level thread maps\wmd_radar::radar_main();
	level thread maps\wmd_basejump::basejump_main();
	
	wait(.5);
	
	//teleport kristina and put on node
	level.heroes["kristina"] disable_ai_color();		
	node = GetNode( "lower_door_node", "targetname" );
	level.heroes["kristina"]forceteleport( node.origin );
	level.heroes["kristina"] SetGoalNode(node);
	
	level thread maps\wmd_util::wmd_objectives();	
	level maps\wmd_base::base_main();
}	


skipto_snow_ambush()
{
	
	//wait for players to spawn
	flag_wait("all_players_spawned");
	player = get_players()[0];
	player.ignoreme = true;
	
	// jpark
	//level maps\wmd_intro::spawn_ambush_guys();
	//wait(2);
	//
	
	//Using demo script - jpark
	level thread maps\wmd_approach_radar::rotate_radar_dish();
	maps\wmd_snow_hide::snow_hide_main();
	maps\wmd_approach_radar::approach_main();
	
	//radar_station(interior)
	maps\wmd_radar::radar_main();
	level maps\wmd_base::base_main();
	
}


skipto_rappel()
{
	flag_wait("all_players_spawned");
	
	player = get_players()[0];
	player SetOrigin( ( 10629, -36667, 42476 ) );
	player SetPlayerAngles( ( 0, 90, 0 ) );
	
	level.harris = simple_spawn_single( "spawner_harris", ::setup_skipto_rappel );	
	level.weaver = simple_spawn_single( "spawner_weaver", ::setup_skipto_rappel );	
	level.brooks = simple_spawn_single( "spawner_brooks", ::setup_skipto_rappel );
	//level.lucas = simple_spawn_single( "spawner_lucas", ::setup_skipto_rappel );
	
	level.harris.name = ( "Harris" );
	level.weaver.name = ( "Weaver" );
	level.brooks.name = ( "Brooks" );
	//level.lucas.name = ( "Lucas" );
	
	level.weaver forceteleport((10491, -37155, 42562));
	level.harris forceteleport((10491, -37135, 42562));
	level.brooks forceteleport((10471, -37155, 42562));
	
	level.weaver animscripts\shared::placeweaponOn(level.weaver.secondaryweapon, "none");
	level.brooks animscripts\shared::placeweaponOn(level.brooks.secondaryweapon, "none");
	level.harris animscripts\shared::placeweaponOn(level.harris.secondaryweapon, "none");
	
	flag_set( "heroes_spawned" );
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
		
	level thread maps\wmd_util::wmd_objectives();
	level thread maps\wmd_approach_radar::rotate_radar_dish();
	maps\wmd_snow_hide::rappel_prepare();
	maps\wmd_snow_hide::rappel_player_hookup();
	maps\wmd_snow_hide::breach_power_building();
	maps\wmd_approach_radar::approach_main();
	maps\wmd_radar::radar_main();
	level maps\wmd_base::base_main();
}


setup_skipto_rappel()
{
	self make_hero();
	self.ignoreall = true;
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
}


skipto_base() // -- WWILLIAMS: POST BASE JUMP SKIPTO
{
	flag_wait("all_players_spawned");
	
	//spawn in hero characters
	spawn_heros();
	
	// -- WWILLIAMS: SET THESE FLAGS FOR THE OBJECTIVES
	// -- TODO: THERE HAS TO BE A BETTER WAY TO DO THIS
	flag_set( "heroes_spawned" );
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
	flag_set( "hookup" );
	flag_set("victim_dead");
	flag_set("stackup");
	flag_set("stair_dead");
	flag_set("knife_done");
	flag_set( "obj_radar" );
	flag_set( "relay_station_sabotaged" );
	
	trigger_use("breadcrumb_basejump_1");
	wait(0.5);
	trigger_use("breadcrumb_basejump_2");
	wait(0.5);
	trigger_use("breadcrumb_basejump_3");
	
	flag_set ("players_jumped");
	
	level.weaver ent_flag_set( "basejump_done" );	
	level.harris ent_flag_set( "basejump_done" );

	level thread maps\wmd_util::wmd_objectives();
	level thread maps\wmd_base::base_jumpto_init();	
	
	// for base
	ledge_trig = GetEnt( "ledge_shoot", "targetname" );
	parachute_trig = GetEnt( "start_parachute_vignette", "targetname" );

	players = get_players();
	wait( 0.7 );
	ledge_trig UseBy( players[0] );
	wait( 4.0 );
	parachute_trig UseBy( players[0] );
	
	if (isdefined(level.harris))
	{
		level.harris delete();
	}
	
	trigger_use("triggercolor_post_land");
	
	level.brooks waittill("goal");
	
	level.brooks handsignal("moveup");
	
	trigger_use("triggercolor_base_weaver");
		
	wait(1.5);
	
	trigger_use("triggercolor_base_brooks");
}

/*
// -- WWILLIAMS: WAREHOUSE SKIP TO
*/
skipto_warehouse()
{
	flag_wait( "all_players_spawned" );
	
	spawn_heros();
	
	// -- WWILLIAMS: SET THESE FLAGS FOR THE OBJECTIVES
	// -- TODO: THERE HAS TO BE A BETTER WAY TO DO THIS
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
	flag_set( "hookup" );
	flag_set( "obj_personnel_a" );
	flag_set( "obj_personnel_a_b" );
	flag_set( "hinge_breach");
	flag_set( "hut_breach_go" );
	flag_set( "breach_begin");
	flag_set( "hut_breach_ended" );
	flag_set( "obj_personnel_a_c" );
	flag_set( "obj_radar" );	
	flag_set( "relay_station_sabotaged" );
	flag_set( "relay_station_cleared");
	flag_set( "players_jumped" );
	flag_set( "player_opened_chute" );
	flag_set( "players_landed" );
	flag_set( "street_mggunner" );
	flag_set( "interior_door_kick" );
	flag_set( "obj_to_steiner_office" );
	
	level.weaver animscripts\shared::placeweaponOn(level.weaver.secondaryweapon, "none");
	level.brooks animscripts\shared::placeweaponOn(level.brooks.secondaryweapon, "none");
	level.harris animscripts\shared::placeweaponOn(level.harris.secondaryweapon, "none");
	
	level thread maps\wmd_base::base_jumpto_warehouse();
	level thread maps\wmd_util::wmd_objectives();
	
	// for base
	ledge_trig = GetEnt( "ledge_shoot", "targetname" );
	parachute_trig = GetEnt( "start_parachute_vignette", "targetname" );
	
	players = get_players();
	wait( 0.7 );
	ledge_trig UseBy( players[0] );
	wait( 4.0 );
	parachute_trig UseBy( players[0] );
}


/*
// -- WWILLIAMS: AVALANCHE SKIP TO
*/
skipto_avalanche()
{
	flag_wait( "all_players_spawned" );
	
	spawn_heros();
	
	// -- WWILLIAMS: SET THESE FLAGS FOR THE OBJECTIVES
	// -- TODO: THERE HAS TO BE A BETTER WAY TO DO THIS
	flag_set( "obj_insertion_a" );
	flag_set( "obj_insertion_b" );
	flag_set( "obj_insertion_c" );
	flag_set( "obj_substation" );
	flag_set( "hookup" );
	flag_set( "obj_personnel_a" );
	flag_set( "obj_personnel_a_b" );
	flag_set( "hinge_breach");
	flag_set( "hut_breach_go" );
	flag_set( "breach_begin");
	flag_set( "hut_breach_ended" );
	flag_set( "obj_personnel_a_c" );
	flag_set( "obj_radar" );	
	flag_set( "relay_station_sabotaged" );
	flag_set( "relay_station_cleared");
	flag_set( "players_jumped" );
	flag_set( "player_opened_chute" );
	flag_set( "players_landed" );
	flag_set( "street_mggunner" );
	flag_set( "interior_door_kick" );
	flag_set( "obj_to_steiner_office" );
	flag_set( "steiner_office_start_main" );
	flag_set( "warehouse_fight_prepare" );
	flag_set( "warehouse_cleared" );
	flag_set( "player_on_truck" );
	
	level.weaver animscripts\shared::placeweaponOn(level.weaver.secondaryweapon, "none");
	level.brooks animscripts\shared::placeweaponOn(level.brooks.secondaryweapon, "none");
	level.harris animscripts\shared::placeweaponOn(level.harris.secondaryweapon, "none");
	
	level thread maps\wmd_util::wmd_objectives();
	level thread maps\wmd_base::base_jumpto_avalanche();
	
	// for base
	ledge_trig = GetEnt( "ledge_shoot", "targetname" );
	parachute_trig = GetEnt( "start_parachute_vignette", "targetname" );
	
	players = get_players();
	wait( 0.7 );
	ledge_trig UseBy( players[0] );
	wait( 4.0 );
	parachute_trig UseBy( players[0] );
	
	if (isdefined(level.harris))
	{
		level.harris delete();
	}
}


 