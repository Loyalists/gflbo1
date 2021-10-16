/*

PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_color_manager;
#include maps\cuba_util;
#include maps\_music;
#include maps\_vehicle;

main()
{
	// Keep this first for CreateFX
	maps\cuba_fx::main();

	// bar specific fx, animations, and ambient things
	maps\cuba_bar_fx::main();
	maps\cuba_bar_anim::main();
	
	settings();
	_precache();
	init_flags();

	setup_objectives();
	setup_fail_messages();
	
	add_start( "bar",			::start_bar,			&"CUBA_SKIPTO_BAR"			);
	add_start( "street",		::start_street,			&"CUBA_SKIPTO_STREET"		);
	add_start( "alley",			::start_alley,			&"CUBA_SKIPTO_ALLEY"		);
	add_start( "drive",			::start_drive,			&"CUBA_SKIPTO_DRIVE"		);
	add_start( "zipline",		::start_zipline,		&"CUBA_SKIPTO_ZIPLINE"		);
	add_start( "compound",		::start_compound,		&"CUBA_SKIPTO_COMPOUND"		);
	add_start( "mansion",		::start_mansion,		&"CUBA_SKIPTO_MANSION"		);
	add_start( "assasination",	::start_assasination,	&"CUBA_SKIPTO_ASSASINATION"	);	
	add_start( "escape",		::start_escape,			&"CUBA_SKIPTO_ESCAPE"		);
	add_start( "courtyard",		::start_courtyard,		&"CUBA_SKIPTO_COURTYARD"	);
	add_start( "airfield",		::start_airfield,		&"CUBA_SKIPTO_AIRFIELD"		);
	add_start( "captured",		::start_captured,		&"CUBA_SKIPTO_CAPTURED"		);

	default_start(::start_bar);

	level.introscreen_dontfreezcontrols = true;
	level.introstring_text_color = ( 1, 1, 1 );
	level.introscreen_shader_fadeout_time = 2.5;
	level.introscreen_shader = "none";

	// this is so that smg use the pistol anim set
	level.supportsPistolAnimations = true;

	maps\cuba_amb::main();
	maps\cuba_anim::main();

	maps\_mig17::mig17_setup_bombs();

	maps\cuba_load::pre_load();
	maps\_load::main();
	
	maps\cuba_load::main();

	// bulletcam init
	maps\_bulletcam::main();

	// patrol init, override the animation with cuba only animation to save memory
	maps\_patrol::patrol_init();
	maps\cuba_anim::cuba_patrol_anims();
	
	// start color manager here
	level thread color_manager_think();
	
	//maps\_drones::init();
	maps\_civilians::init_civilians();
	maps\_rusher::init_rusher();

	maps\_names::add_override_name_func("american", ::cuban_rebel_names);

	OnFirstPlayerConnect_Callback(::on_first_player_connect);
	OnPlayerConnect_Callback(::on_player_connect);

	//create_billboard();

	level thread objectives();
	
	// start art transition thread
	level thread art_transition_thread();
	
	battlechatter_on();
}

_precache()
{
	//weapons
	PreCacheItem("fnfal_sp");
	PreCacheItem("fnfal_acog_sp");
	PreCacheItem("fnfal_silencer_sp");
	PreCacheItem("fnfal_acog_silencer_sp");
	
	PreCacheItem("skorpion_sp");
	PreCacheItem("skorpion_extclip_sp");
	PreCacheItem("skorpion_silencer_sp");
	
	PreCacheItem("rpk_sp");
	PreCacheItem("rpk_acog_sp");
	PreCacheItem("rpk_dualclip_sp");
		
	PreCacheItem("rpg_magic_bullet_sp");
	PreCacheItem("m60_explosive_sp");

	PrecacheItem("rpk_magicbullet_noflash");
		
	// precache special assasination weapon
	PreCacheItem( "asp_sp_castro" );
	PreCacheItem( "asp_sp_bar" );
	
	// zipline hooks
	PreCacheModel( "anim_rus_zipline_hook" );
	PreCacheModel( "t5_weapon_al54_hook" );

	// bulletcam model
	PreCacheModel("p_glo_bullet_tip");
	
	PreCacheModel("anim_jun_rappel_rope");
	
	//vehicle gibs
	PreCacheModel("t5_veh_gaz66_tire_low");
	PreCacheModel("t5_veh_gaz66_door_dest");
	PreCacheModel("t5_veh_gaz66_bumper_dest");

	//castro cigar
	PreCacheModel("p_glo_cuban_cigar01");

	// contextual melee 
	PreCacheModel("t5_weapon_garrot_wire");

	//2d bomber card
	PreCacheModel("p_cub_vista_bomber");

	//precache rumble
	PreCacheRumble( "damage_heavy" );
	PreCacheRumble( "damage_light" );
	PreCacheRumble( "grenade_rumble" );
	PreCacheRumble( "artillery_rumble" );
	PrecacheRumble("cuba_peelout");

	//shellshocks
	PreCacheShellShock("quagmire_window_break");

	//shaders
	PreCacheShader("cinematic");
	
	//glowy AA gun for airfield
	PreCacheModel("vehicle_zpu4_obj");
	
	PreCacheModel("p_rus_reel_disc");
	PreCacheModel("dest_glo_paper_01_d0");

	PreCacheModel( "t5_gfl_ump45_viewmodel" );
	PreCacheModel( "t5_gfl_ump45_viewmodel_player" );
	PreCacheModel( "t5_gfl_ump45_viewbody" );
}


remove_lmg_anims()
{
	//no LMG arrivals/exits
	anim.anim_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.pre_move_delta_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.move_delta_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.post_move_delta_array["default"]["move"]["stand"]["mg"] = undefined;
	anim.angle_delta_array["default"]["move"]["stand"]["mg"] = undefined;
}	

settings()
{
	level.noAutoStartLevelSave = true;

	SetSavedDvar("phys_buoyancy", "0");
	SetSavedDvar("vehicle_riding", false); // Allows player to die when hit by vehicles

	level.swimmingFeature = false;

	level._vehicle_load_lights = true;
	level._vehicle_load_sirens = true;

	SetSavedDvar( "r_flashLightRange", "1000" );
	SetSavedDvar( "r_flashLightEndRadius", "800" );
	SetSavedDvar( "r_flashLightBrightness", "6" );
	SetSavedDvar( "r_flashLightOffset", "0 0 0" );

	SetSavedDvar( "r_flashLightFlickerAmount", "0.03" );
	SetSavedDvar( "r_flashLightFlickerRate", "65" );
	SetSavedDvar( "r_flashLightBobAmount", "4 6 0" );
	SetSavedDvar( "r_flashLightBobRate", "0.17 0.16 0.25" );
	SetSavedDvar( "r_flashLightColor", "0.03 0.2 0.3" );

	SetSavedDvar("cg_aggressiveCullRadius", 500);
}

on_player_connect()
{
}

on_first_player_connect()
{
	self.animname = "mason";
	self dds_set_player_character_name("mason");

	level remove_lmg_anims();
	
	// Fog settings can't be set until first player connects
	maps\createart\cuba_art::main();
}

init_flags()
{
	// generic/level wide flags
	flag_init("woods!spawned");
	flag_init("bowman!spawned");
	flag_init("carlos!spawned");

	flag_init("mission_failed");
	flag_init("transition_sky");
	flag_init("art_trasition_tracking");

	flag_init("player_used_ads");
	flag_init("player_used_alt_weapon");
	
	// Street
	flag_init("police_chatter");
	flag_init("keep_moving");
	flag_init("shoot_up_car_guy_dead");
	flag_init("turn_back");
	flag_init("stand_off");
	flag_init("backing_up");
	flag_init("almost_slomo");
	flag_init("drive_slomo");
	flag_init("lamppost_01_hit_start");
	flag_init("lamppost_01_fall_start");
	flag_init("blow_fire_hydrant");
	flag_init("player_in_alley");
	flag_init("player_in_car");
	flag_init("street_done"); // turns on some goatpath triggers when street is done

	//Mansion Escape
	flag_init( "spawn_balcony_breach_guys" );
	flag_init( "spawn_roof_squad_leader" );
	flag_init( "spawn_roof_squad" );
	flag_init( "spawn_crashing_plane" );
	flag_init( "stop_firing_aa_gun" );
	flag_init( "spawn_courtyard_rebels" );
	flag_init( "player_on_balcony" );
	flag_init( "player_off_balcony" );
	flag_init( "mansion_small_boom" );
	flag_init( "spawn_courtyard_btr" );
	flag_init( "courtyard_btr_destroyed" );
	flag_init( "courtyard_btr_spawned" );
	flag_init( "heroes_in_cover" );
	flag_init( "plane_crashed" );
	flag_init( "bookshelf_dropped" );
	flag_init( "stop_mid_color_chain" );
	flag_init( "stop_balcony_bombers" );
	flag_init( "stop_courtyard_bombers" );
	flag_init( "woods_stop_shooting" );
	flag_init( "cleaned_up_balcony" );
	flag_init( "plane_passed_by" );
	flag_init( "bowman_entrance_trig" );
	flag_init( "balcony_combat" );
	flag_init( "stop_go_outside_nag" );
	flag_init( "start_gunner_fire" );
	flag_init( "btr_entrance_fire" );
	flag_init( "stop_balcony_nag" );
	flag_init( "stop_balcony_mansion_nag" );
	flag_init( "stop_sugarcane_nag_lines" );
	flag_init( "woods_done_radioing" );
	flag_init( "spawn_courtyard_blocker" );
	flag_init ("bookshelf_guy_done");
	flag_init ("player_at_stairs");
	flag_init ("squad_downstairs");

	// airfield generic flag
	flag_init( "airfield_forward_rappel_start" ); // set when players forward rappel starts in airfield
	flag_init("cuba_end_script_started");
	flag_init("start_outro");

	// flags for zipline/compound/mansion events, keeping them in main gsc

	maps\cuba_bar::setup_bar_flags();
	maps\cuba_zipline::setup_zipline_flags();
	maps\cuba_compound::setup_compound_flags();
	maps\cuba_mansion::setup_mansion_flags();
	maps\cuba_assasination::setup_assasination_flags();	
}

setup_fail_messages()
{
	level.fail_messages[ "blew_cover" ] = &"CUBA_FAIL_BLEW_COVER";
	level.fail_messages[ "carlos_died" ] = &"CUBA_FAIL_CARLOS_DEAD";
	level.fail_messages[ "castro_killed_player" ] = &"CUBA_FAIL_CASTRO_KILLED_PLAYER";
}

setup_objectives()
{
	level.OBJ_MISC				= 0;
	level.OBJ_MISC2				= 1;
	level.OBJ_STREET			= 2;
	level.OBJ_CAR				= 3;
	level.OBJ_ZIPLINE			= 4;
	level.OBJ_COMPOUND			= 5;
	level.OBJ_ESCAPE			= 6;
	level.OBJ_AIRFIELD			= 7;
	level.OBJ_RAPPEL_DOWN		= 8;
	level.OBJ_PLANE				= 9;
	level.OBJ_PROTECT_PLANE		= 10;
	level.OBJ_AA_GUN			= 11;
	
	level.objectives[level.OBJ_STREET]		= &"CUBA_OBJECTIVE_STREET";
	level.objectives[level.OBJ_CAR]			= &"CUBA_OBJECTIVE_CAR";
	level.objectives[level.OBJ_ZIPLINE]		= &"CUBA_OBJECTIVE_ZIPLINE";
	level.objectives[level.OBJ_COMPOUND]	= &"CUBA_OBJECTIVE_COMPOUND";
	level.objectives[level.OBJ_ESCAPE]		= &"CUBA_OBJECTIVE_ESCAPE";
	level.objectives[level.OBJ_AIRFIELD]	= &"CUBA_OBJECTIVE_AIRFIELD";
	level.objectives[level.OBJ_RAPPEL_DOWN]	= &"CUBA_OBJECTIVE_RAPPEL";
	level.objectives[level.OBJ_PLANE]		= &"CUBA_OBJECTIVE_PLANE";
	level.objectives[level.OBJ_PROTECT_PLANE] = &"CUBA_OBJECTIVE_PROTECT_PLANE";
	level.objectives[level.OBJ_AA_GUN]		= &"CUBA_OBJECTIVE_AAGUN";
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
start_bar()
{
	maps\cuba_bar::start();
	maps\cuba_street::start();
	maps\cuba_zipline::start();
	maps\cuba_compound::start();
	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_street()
{
	heroes = get_heroes_by_name("woods", "bowman", "carlos");
	start_teleport("start_street", "squad");
	array_func(heroes, ::make_casual);

	battlechatter_on("allies");

	level thread create_vehicle_from_spawngroup_and_gopath(0);

	flag_set("police_chatter");
	
	level thread maps\cuba_bar::open_door();
	maps\cuba_street::set_street_objective();

	maps\cuba_street::start();
	maps\cuba_zipline::start();
	maps\cuba_compound::start();
	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_alley()
{
	heroes = get_heroes_by_name("woods", "bowman", "carlos");
	array_func(heroes, ::disable_ai_color);
	array_func(heroes, ::make_casual);

	start_teleport("start_alley", "squad");

	battlechatter_on("allies");

	get_hero_by_name("woods").cuba_next_node = "node_turn_back";
	get_hero_by_name("bowman").cuba_next_node = "node_turn_back";
	get_hero_by_name("carlos").cuba_next_node = "node_turn_back";

	spawn_manager_kill("street_spawner_2");

	flag_set("turn_around");
	flag_set("turn_back");
	flag_set("start_drive_event");
	flag_set("street_group_4_cleared");

 	GetEnt("trig_turn_back_cars", "targetname") Delete();
	//getstruct("trig_turn_back_cars", "targetname") notify("death");

	level thread create_vehicle_from_spawngroup_and_gopath(50);
	level thread create_vehicle_from_spawngroup_and_gopath(52);

	maps\cuba_street::start();
	maps\cuba_zipline::start();
	maps\cuba_compound::start();
	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_drive()
{
	heroes = get_heroes_by_name("woods", "bowman", "carlos");
	array_func(heroes, ::disable_ai_color);
	array_func(heroes, ::make_casual);

	start_teleport("start_drive", "squad");
	spawn_manager_enable("sm_alley_chasers");
	spawn_manager_kill("street_spawner_2");

	flag_set("turn_around");
	flag_set("turn_back");
	flag_set("start_drive_event");
	flag_set("street_spawner_4");
	flag_set("street_group_4_cleared");

 	GetEnt("trig_turn_back_cars", "targetname") Delete();
	//getstruct("trig_turn_back_cars", "targetname") notify("death");

	level thread create_vehicle_from_spawngroup_and_gopath(50);
	level thread create_vehicle_from_spawngroup_and_gopath(52);

	spawn_manager_kill("alley_spawner");
	GetEnt("trig_stand_off", "targetname") notify("trigger");
	
	maps\cuba_street::start();
	maps\cuba_zipline::start();
	maps\cuba_compound::start();
	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_zipline()
{
	get_heroes_by_name("woods", "bowman");
	start_teleport("start_zipline", "squad");

	flag_set("street_done");
	
	maps\cuba_zipline::start();
	maps\cuba_compound::start();
	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_compound()
{
	maps\cuba_street::cleanup();

	get_heroes_by_name("woods", "bowman");
	start_teleport("start_compound", "squad");

	flag_set( "art_trasition_tracking" );

	maps\cuba_compound::start();
	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_mansion()
{
	maps\cuba_street::cleanup();

	get_heroes_by_name("woods", "bowman");
	start_teleport("start_mansion", "squad");

	flag_set("art_trasition_tracking");

	maps\cuba_mansion::start();
	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_assasination()
{
	maps\cuba_street::cleanup();

	get_heroes_by_name("woods", "bowman");
	start_teleport("start_assasination", "squad");

	flag_set("art_trasition_tracking");

	maps\cuba_assasination::start();
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
}

start_escape()
{
	maps\cuba_street::cleanup();

	get_heroes_by_name("woods");
	start_teleport("start_escape", "squad");

	level thread maps\cuba_mansion::ambiant_effect_think();
	flag_set("player_inside_mansion");

	flag_set("art_trasition_tracking");
		//spawn AA gun outside
	maps\cuba_escape::setup_balcony_aa_gun();
	maps\cuba_assasination::post_assasination_open_door();
	wait(2);
	player = get_players()[0];
	player GiveWeapon ("fnfal_silencer_sp");
	wait(.5);
	player SwitchToWeapon ("fnfal_silencer_sp");
	
	maps\cuba_escape::start();
	maps\cuba_airfield::start();
	wait(1);
	flag_set ("stop_sugarcane_nag_lines");
}

start_courtyard()
{
	maps\cuba_street::cleanup();

	get_heroes_by_name("woods", "bowman");
	start_teleport("start_courtyard", "squad");

	flag_set("art_trasition_tracking");

	parked_courtyard_sedans = maps\_vehicle::spawn_vehicles_from_targetname( "parked_courtyard_sedans" );
	array_func( parked_courtyard_sedans, maps\cuba_escape::setup_parked_vehicles );

	maps\_vehicle::spawn_vehicles_from_targetname( "courtyard_aa_gun_1" );
	maps\_vehicle::spawn_vehicles_from_targetname( "courtyard_aa_gun_2" );
	maps\_vehicle::spawn_vehicles_from_targetname( "courtyard_aa_gun_3" );

	wait( 2 );

	level thread maps\cuba_escape::courtyard();

	flag_set( "player_in_courtyard" );

	trigger_use( "move_heroes_cover", "targetname" );

	trigger_wait( "start_airfield_scripts", "script_noteworthy" );
	maps\cuba_airfield::start();
}

start_airfield()
{
	maps\cuba_street::cleanup();

	get_heroes_by_name("woods", "bowman", "carlos");
	start_teleport("start_airfield", "squad");

	flag_set("art_trasition_tracking");

	maps\cuba_airfield::start();
	Maps\cuba_airfield::sugar_field_planes();
	wait(2);
	flag_set ( "player_outside_mansion" );
}

start_captured()
{
	maps\cuba_street::cleanup();

	flag_set("art_trasition_tracking");
	
	level.using_captured_skitpo = 1;
	
	wait(2);

	level.player_model = spawn_anim_model("player_hands");
	level.player_model.animname = "player_hands";

	// take all the weapons from the player
	player = get_players()[0];
	player DisableWeapons();
	player take_weapons();
	
	player PlayerLinkToAbsolute( level.player_model, "tag_player" );
	

	
	wait(2);
	flag_set ( "player_outside_mansion" );
	flag_set("start_outro");
	
	maps\cuba_airfield::outro_scene();
	
}

/* ------------------------------------------------------------------------------------------
MAIN LEVEL THREADS
-------------------------------------------------------------------------------------------*/
objectives()
{
	current_obj = -1;
	type = undefined;
	pos = undefined;

	while (true)
	{
		if (IsDefined(level.objective))
		{
			num = level.objective;

			// if the current objective is the same as new one, then only update set3D and dont add a new objective
			if ((current_obj != num) || !is_objective_pos_the_same(level.objective_pos, pos))
			{
				if (num > level.OBJ_STREET && num != current_obj)
				{
					Objective_State(num - 1, "done");
				}

				if (IsDefined(level.objective_pos))
				{
					if (current_obj != num)
					{
						if (IsSentient(level.objective_pos) || level.objective_pos is_vehicle() || IsVec(level.objective_pos))
						{
							Objective_Add(num, "current", level.objectives[num], level.objective_pos);
						}
						else
						{
							Objective_Add(num, "current", level.objectives[num], level.objective_pos.origin);
						}
					}
					else
					{
						if (IsSentient(level.objective_pos) || level.objective_pos is_vehicle() || IsVec(level.objective_pos))
						{
							Objective_Position(current_obj, level.objective_pos);
						}
						else
						{
							Objective_Position(current_obj, level.objective_pos.origin);
						}
					}
				}				
				else if (current_obj != num)
				{
					Objective_Add(num, "current", level.objectives[num]);
				}		
			}
			
			if (IsDefined(level.objective_pos))
			{
				if (IsDefined(level.objective_type))
				{
					switch (level.objective_type)
					{
					case "follow":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_FOLLOW");
						break;
					case "position":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_POSITION");
						break;
					case "enter":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_ENTER");
						break;				
					case "use":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_USE" );
						break;
					case "support":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_SUPPORT" );
						break;
					case "breach":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_BREACH" );
						break;
					case "assasinate":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_ASSASINATE" );
						break;
					case "melee":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_MELEE" );
						break;
					case "squad":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_SQUAD" );
						break;
					case "pick_up":
						Objective_Set3D(num, true, (1, 1, 1), &"CUBA_3D_PICKUP" );
						break;
					case "":
						Objective_Set3D(num, true, (1, 1, 1) );
						break;
					default: AssertMsg("Unsupported objective type: '" + level.objective_type + "'.");
					}
				}
				else
				{
					Objective_Set3D(num, true, (1, 1, 1) );
				}
			}
			else
			{
				Objective_Set3D(num, false);
			}

			current_obj = num;
			type = level.objective_type;
			pos = level.objective_pos;
		}

		level waittill("update_objective");
	}
}

is_objective_pos_the_same(pos1, pos2)
{
	if (!IsDefined(pos1) && !IsDefined(pos2))
	{
		return true;
	}
	else if (IsDefined(pos1) && !IsDefined(pos2))
	{
		return false;
	}
	else if (!IsDefined(pos1) && IsDefined(pos2))
	{
		return false;
	}
	else if (IsSentient(pos1) && !IsSentient(pos2))
	{
		return false;
	}
	else if (!IsSentient(pos1) && IsSentient(pos2))
	{
		return false;
	}
	else if (pos1 != pos2)
	{
		return false;
	}

	return true;
}

// --------------------------------------------------------------------------------
// ---- art transition thread  ----
// --------------------------------------------------------------------------------
art_transition_thread()
{
	mansion_vision_trig  = GetEnt( "mansion_vision_trig", "targetname" );
	compound_vision_trig = GetEnt( "compound_vision_trig", "targetname" );
	airfield_vision_trig = GetEnt( "airfield_vision_trig", "targetname" );
	balcony_trig 		 = GetEnt( "balcony_trig", "targetname" );
	
	flag_wait( "art_trasition_tracking" );
	
	transition_time = 1.0;
	current_vision = "cuba_sunrise";

	while(1)
	{
		player = get_players()[0];
	
		if( flag( "player_zipline_ready" ) && !flag( "zipline_event_done" ) )
		{
			// zipline vision set
			vision = "cuba_zipline";				
			maps\createart\cuba_art::set_cuba_fog( "zipline" );
		}
		else if( player IsTouching( compound_vision_trig ) )
		{
			// compound vision set, just using sunrise for it
			vision = "cuba_compound";
			maps\createart\cuba_art::set_cuba_fog( "compound" );
		}
		else if( player IsTouching( mansion_vision_trig ) ) 
		{
			vision = "cuba_mansion";
			maps\createart\cuba_art::set_cuba_fog( "mansion" );
		}
		else if( player IsTouching( balcony_trig ) )
		{
			// in balcony using courtyard vision
			vision = "cuba_courtyard";		
			maps\createart\cuba_art::set_cuba_fog( "balcony" );
		}
		else if( player IsTouching( airfield_vision_trig ) )
		{
			if( flag( "airfield_forward_rappel_start" ) )
			{
				vision = "cuba_runway_base";  		// airfied after rappel
				transition_time = 5.0;
				maps\createart\cuba_art::set_cuba_fog( "airfield_rappel" );
			}
			else					
			{
				vision = "cuba_runway_vista"; 	  	// airfield before rappel
				maps\createart\cuba_art::set_cuba_fog( "airfield_start" );
			}
		}
		else if( flag( "cuba_end_script_started" ) )
		{
			// rusalka end event
			vision = "cuba_end";					
			maps\createart\cuba_art::set_cuba_fog( "airfield_outro" );
		}
		else
		{	
			// default : courtyard outside mansion
			vision = "cuba_courtyard";				
			maps\createart\cuba_art::set_cuba_fog( "courtyard" );
		}
				
		if( current_vision != vision )
		{
			/#
			IPrintLn( "VISION SET : " + vision );
			#/

			VisionSetNaked( vision, transition_time );
			current_vision = vision;
		}
		
		if( flag( "cuba_end_script_started" ) )
			break;

		wait( 0.5 );
	}

	// delete triggers
	mansion_vision_trig  Delete();
	compound_vision_trig Delete();
	airfield_vision_trig Delete();
	balcony_trig 		 Delete();
}

cuban_rebel_names()
{
	if(!IsDefined(level._names))
	{
		level._names = [];
		level._names_index = 0;
		
		level._names[level._names.size] = "Arias";
		level._names[level._names.size] = "Sanchez";
		level._names[level._names.size] = "Pedroso";
		level._names[level._names.size] = "Reyes";
		level._names[level._names.size] = "Paret";
		level._names[level._names.size] = "Zamora";
		level._names[level._names.size] = "Cepeda";
		level._names[level._names.size] = "Gonz�lez";
		level._names[level._names.size] = "Ibarra";
		level._names[level._names.size] = "Urgelles";
		level._names[level._names.size] = "S�nchez";
	}

	name = level._names[level._names_index];
	level._names_index = (level._names_index + 1) % level._names.size;

	return name;
}

/*
HOUSE OUTSIDE OF CASTROS ROOM
(-161 3301 260)
SUGAR CANE FIELD
(3025 2800 230)
AIRFIELD
(3200 8654 -1135)
COURTYARD CELL 1
(3165 635 286)
COURTYARD CELL 2
(3203 411 289)
COURTYARD CELL 3
(5442 494 248)
MANSION STAIRCASE ROOM CELL 1
(1416 788 504)
MANSION STAIRCASE ROOM CELL 2
(899 1163 504)
MANSION STAIRCASE ROOM CELL 3
(839 1577 504)
MANSION STIARCASE ROOM CELL 4
(907 1865 504)
MANSION STAIRCASE ROOM CELL 5 
(1211 2572 504)
PATH OUTSIDE CASTROS ROOM  CELL 1 
(854 2549 504)
PATH OUTSIDE OF CASTROS ROOM CELL 2
(505 2327 504)
castors room 
(14, 2272, 574)
middle courtyard
(111 990 394)
BREACH ROOM
(-512, 2272, 580)
RIGHT SIDE HALLWAY OF BADBOYS ROOM
(-502 1669 504)
BAD BOYS ROOM 
(-838 1596 504)
LEFT SIDE OF HALLWAY BEFORE BADBOYS ROOM 
(-660 374 504)
RIGHT SIDE HALLWAY LEADING TO BADBOYS ROOM
(-524 417 504)
MAIN HALLWAY (BOWMANS DOOR)
(-423 -183 504)
MANSION FIRST ROOM
(509 -497 504)
MANSION SECOND ROOM 
(91 -562 504)
MANSION THRID ROOM
(-320 -491 504)
MANSION EXTERIOR ENTRANCE
(-175 -942 336)

*/


