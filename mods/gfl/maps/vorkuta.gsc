/*
	   ===Call of Duty 7===
	VORKUTA Prison Camp Escape!!!
	Builder: Paul Mason-Firth
	Scripter: Steve Holmes

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_music;
#include maps\vorkuta_util;

#include animscripts\Utility;
#include animscripts\combat_utility;
#include animscripts\Debug;
#include animscripts\anims_table;

main()
{
	level thread vorkuta_precache();

	maps\vorkuta_fx::main();
	
	//-- Starts
	add_start( "start_mine", ::start_mine, &"SECTION1_Escape" );
	add_start( "start_inclinator", ::start_inclinator, &"SECTION1_Inclinator" );
	add_start( "start_tower", ::start_tower, &"SECTION2_Tower" );
	add_start( "start_slingshot", ::start_slingshot, &"SECTION2_Slingshot" );
	add_start( "start_courtyard", ::start_courtyard, &"SECTION2_Courtyard");
	add_start( "start_enter_armory", ::start_enter_armory, &"SECTION3_Enter_Armory");
	add_start( "start_defend_armory", ::start_defend_armory, &"SECTION3_Defend_Armory");
	add_start( "start_minigun_alley", ::start_minigun_alley, &"SECTION3_Minigun_Alley");
	add_start( "start_bike", ::start_bike, &"SECTION4_Bike");
		
	default_start(::vorkuta_events);

	level.no_color_respawners_sm = true; //-- keep color guys from entering the _colors.gsc respawning functions

	//overrides default introscreen function
	level.custom_introscreen = ::vorkuta_custom_introscreen;
	
	maps\_load::main();

	//drones
	maps\_drones::init();	

	maps\vorkuta_amb::main();
	maps\vorkuta_anim::main();

	//override the naming function for russians
	maps\_names::add_override_name_func("russian", ::vorkuta_custom_names);

	//motorycle 
	maps\_motorcycle_ride::motorcycle_init();

	silo = GetEnt("fxanim_vorkuta_towers_mod","targetname");
	silo Hide();
	armory = GetEnt("fxanim_vorkuta_armory_mod","targetname");
	armory Hide();
	
	//rusher AI
	level maps\_rusher::init_rusher();

	//prisoner AI
	level maps\_prisoners::init_prisoners();
		
	level thread init_flags();
	level thread hide_armory_stuff();

	//turn on battlechatter
	battlechatter_on();
	
	//flag_wait ("all_players_spawned");

	//play outdoor fx on player
	//level thread vorkuta_fx_on_player();
}


hide_armory_stuff()
{
	walkway_after = getentarray("armory_entrance_destroyed", "targetname");
	for(i=0; i<walkway_after.size; i++)
	{
		if (isdefined(walkway_after[i]))
		{
			walkway_after[i] hide();
		}
	}
	
	walkway_dest = getentarray("armory_entrance_destroyed_model", "targetname");
	for(i=0; i<walkway_dest.size; i++)
	{
		if (isdefined(walkway_dest[i]))
		{
			walkway_dest[i] hide();
		}
	}
	
	trigger_to_armory = getent("squad_to_stairs", "targetname");
	trigger_to_armory trigger_off();

	barrels = GetEntArray("hidden_barrels", "script_noteworthy");
	for(i = 0; i < barrels.size; i++)
	{
		barrels[i] Hide();
	}
}

vorkuta_custom_names()
{
	if(!IsDefined(level._prisoner_names))
	{
		level._prisoner_names = [];
		level._prisoner_names_index = 0;

		alphabet[0] = "A";
		alphabet[1] = "B";
		alphabet[2] = "C";
		alphabet[3] = "D";
		alphabet[4] = "E";
		alphabet[5] = "F";		

		//TODO: Changed Prisoner to use the localized string &"VORKUTA_PRISONER_RANK" once API comes online
		for(i = 0; i < 100; i++)
		{
			name = alphabet[RandomInt(alphabet.size)];
			for(j = 0; j < 4; j++)
			{
				name = name + RandomIntRange(0,9);

			}
			level._prisoner_names[i] = MakeLocalizedString(&"VORKUTA_PRISONER_RANK", name);
		}
	}

	name = level._prisoner_names[level._prisoner_names_index];
	level._prisoner_names_index = (level._prisoner_names_index + 1) % level._prisoner_names.size;

	return name;
}

intro_hud_fadeout()
{
	wait(0.2);
		// Fade out black
	self FadeOverTime( 0.5 ); 
	self.alpha = 0; 
	
	wait 0.5;
	self Destroy();
}

vorkuta_custom_introscreen(string1, string2, string3, string4, string5)
{
	level.introstring = []; 

	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = true;
	introblack SetShader( "black", 640, 480 );

	flag_wait("all_players_connected");

	introblack thread intro_hud_fadeout();

	//notify from intro animation sent from event_1_info_screen in vorkuta_mine.gsc
	level waittill("show_level_info");

	pausetime = 0.75;
	totaltime = 14.25;
	time_to_redact = ( 0.525 * totaltime);
	rubout_time = 1;
	color = (1,1,1);

	delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	delay_between_redacts_max = 500;

	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

	// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomInt(delay_between_redacts_min,delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomInt(delay_between_redacts_min,delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomInt(delay_between_redacts_min,delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		

	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomInt(delay_between_redacts_min,delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	wait (totaltime - totalpausetime);

	//default wait time
	wait 2.5;

	level notify("introscreen_done");
	
	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 
}

//level logic flow
vorkuta_events()
{
	level thread vorkuta_objectives();

	//disable the ak-47 gl from dropping until armory
	disable_random_alt_weapon_drops();

	maps\vorkuta_mine::main();
	maps\vorkuta_surface::surface_main();
	maps\vorkuta_armory::armory_main();
	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();
}	

vorkuta_objectives(skipto)
{
	// if there is no event specified then start from the begining	
	if( !isdefined( skipto ) )
		skipto = "start_default";

	obj_number = 0;

	if(skipto == "start_default")
	{
		level waittill("introscreen_done");
	}

	//overall objective through the level "ESCAPE VORKUTA"
	Objective_Add (obj_number, "current", &"VORKUTA_OBJ_GLOBAL");
	obj_number++;
		
	switch (skipto)
	{
	case "start_default":
		//dummy objective "STEP 1: Secure the Keys"
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_STEP_1");
		flag_wait("flag_obj_step_1");
		Objective_State(obj_number, "done" );
		obj_number++;
		
		// "STEP 2: Ascend from the Darkness"
		flag_wait("flag_obj_step_2");
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_STEP_2", level.reznov);
		Objective_Set3D(obj_number, true, "default", &"VORKUTA_OBJ_FOLLOW");
		
		//wait for doors to open until completing the objective
		flag_wait("tower_start");
		Objective_State(obj_number, "done" );
		obj_number++;

	case "start_tower":
		// "STEP 3: Rain Fire"
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_STEP_3");
		Objective_Position (obj_number, level.reznov); 
		Objective_Set3D ( obj_number, true, "default", &"VORKUTA_OBJ_FOLLOW"); 

		flag_wait("flag_obj_step_3");

		Objective_Position(obj_number, GetEnt( "cart_right", "targetname" ) );
		Objective_Set3D(obj_number, true, "default", "", -1, (0, 0, 50));

		flag_wait("tower_done");

		Objective_State(obj_number, "done");
		obj_number++;

	case "start_slingshot":
		// "STEP 4: Unleash the Horde"
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_STEP_4");
		Objective_Position(obj_number, level.reznov);
		Objective_Set3D(obj_number, true, "default", &"VORKUTA_OBJ_FOLLOW");

		//wait until Reznov tells Mason to go upstairs
		flag_wait("flag_obj_step_4");

		obj_origin = GetEnt("sling_roof_trig", "targetname").origin;
		Objective_Position(obj_number, obj_origin); //set the obj position
		Objective_Set3D(obj_number, true);
		
		//bread crumb
		flag_wait("flag_player_on_roof");
		obj_origin = getstruct("slingshot_align_node", "targetname").origin + (0,0,40);
		Objective_Position(obj_number, obj_origin); //set the obj position

		//player is on the slingshot remove the start point
		flag_wait("player_on_slingshot");
		Objective_Set3D(obj_number, false); 

		//additional target objectives are handled in vorkuta_surface.gsc
		level waittill( "slingshot_roof_done" );
		Objective_State(obj_number, "done");
		obj_number++;

		// "GET A SHOTGUN"
		obj_origin = GetEnt ("tower_shotgun", "targetname").origin;
		Objective_Add (obj_number, "current", &"VORKUTA_OBJ_OBTAIN_SHOTGUN", obj_origin);
		Objective_Set3D ( obj_number, true);

		flag_wait ("player_has_shotgun");
		Objective_State (obj_number, "done");
		Objective_Delete(obj_number);
		obj_number++;

	case "start_courtyard":
		// "SHOOT THE LOCK"
		obj_origin = GetEnt("courtyard_gate_damage","targetname").origin;
		Objective_Add (obj_number, "current", &"VORKUTA_OBJ_SHOOT_LOCK", obj_origin);
		Objective_Set3D ( obj_number, true);

		//flag is set after lock is blown off
		flag_wait("flag_obj_step_5");
		Objective_State(obj_number, "done");
		Objective_Delete(obj_number);
		obj_number++;

		// "STEP 5: Slay the Winged Beast"
		Objective_Add(obj_number,"current", &"VORKUTA_OBJ_STEP_5"); 
		obj_origin = GetEnt("courtyard_heli_trig","targetname").origin + (0,0,64);
		Objective_Position(obj_number, obj_origin); //door is the obj position
		Objective_Set3D ( obj_number, true ); //Set 3d marker

		trigger_wait("courtyard_heli_trig");

		obj_origin = GetEnt( "rope_entrance", "targetname" ).origin + (0,32,64);
		Objective_Position(obj_number, obj_origin);

		//player is in front of the door
		trigger_wait("courtyard_roof_ent");

		obj_origin = GetEnt("helicopter_roof_lookat","targetname").origin;
		Objective_Position (obj_number, obj_origin); 

		//kill the guy holding the weapon
		trigger_wait( "helicopter_roof_lookat" );
		level.rope_guys[0] waittill("death");
		wait(0.05);
		if(IsDefined(level.gun))
		{
			Objective_Position (obj_number, level.gun); 
		}		
	
		//wait until the player has the harpoon gun
		trigger_wait("rope_give");

		//update the objective marker to the helicopter
		heli = GetEnt("courtyard_heli", "targetname" );
		Objective_Position(obj_number, heli);
		Objective_Set3D(obj_number, true, "default", "", -1, (0, 0, -50)); //Set 3d marker and lower then the heli origin

		//remove the 3D marker when the heli is hit
		flag_wait("flag_heli_hit");
		Objective_Set3D(obj_number, false);
		
		//wait for the helicopter crash animation to complete
		level waittill( "heli_crash_done" );
		Objective_State(obj_number, "done");
		obj_number++;
		
	case "start_enter_armory":
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_GET_TO_ARMORY");
		obj_origin = GetEnt("trigger_armory_proximity","targetname").origin + (0,0,64);
		Objective_Position(obj_number, obj_origin); 
		Objective_Set3D(obj_number, true);

		trigger_wait("trigger_armory_proximity");

		obj_origin = GetStruct("fire_fallguy_pos","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		Objective_Set3D(obj_number, true, "default", "");

		flag_wait("unleash_hall_defense");

		obj_origin = getstruct("door_obj", "targetname").origin;
		Objective_Position(obj_number, obj_origin);

		//player made it under the door
		flag_wait("player_rolled");
		Objective_State(obj_number, "done");
		Objective_Delete(obj_number);
		obj_number++;
		
		//make the button the objective
		obj_origin = getstruct("door_button", "targetname").origin;
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_DEACTIVATE_DOOR");
		Objective_Position(obj_number, obj_origin);
		Objective_Set3D(obj_number, true);
		
		//player hit the button
		flag_wait("player_opened_rolling_door");
		
		Objective_State (obj_number, "done");
		Objective_Delete(obj_number);
		obj_number++;
		
	case "start_defend_armory":
		//wait for the VO line "Wield a fist of iron"
		flag_wait("go_upstairs");
		
		Objective_Add (obj_number, "current", &"VORKUTA_OBJ_STEP_6");
		Objective_Position(obj_number, level.reznov); 
		Objective_Set3D(obj_number, true, "default", &"VORKUTA_OBJ_FOLLOW");
		
		//sub objective to protect reznov
		flag_wait("heavy_intro");
		
		Objective_Set3D(obj_number, false);
		obj_number++;

		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_PROTECT_REZNOV");
		Objective_Position (obj_number, level.reznov);
		Objective_Set3D (obj_number, true, "default", &"VORKUTA_OBJ_PROTECT");

		flag_wait ("welding_stopped");
		Objective_State(obj_number, "done");
		Objective_Delete(obj_number);
		
		obj_origin = getstruct ("btrs_obj", "targetname").origin; 
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_MINI_GUN", obj_origin);
		Objective_Set3D (obj_number, true);
		
		flag_wait("got_minigun");

		Objective_State(obj_number, "done");
		Objective_Delete(obj_number);

		//go back to previous objective "Wield a Fist of Iron" to complete it
		obj_number--;
		Objective_State(obj_number, "done");
		obj_number++;
					
	case "start_minigun_alley": 
		// "Step 7: Unleash Hell"
		obj_origin = GetEnt("triggercolor_startinto_alley","targetname").origin;
		Objective_Add (obj_number, "current", &"VORKUTA_OBJ_STEP_7", obj_origin);
		Objective_Set3D (obj_number, true);

		flag_wait("into_alley");
		obj_origin = GetEnt("triggercolor_to_lsection","targetname").origin;
		Objective_Position(obj_number, obj_origin);

		flag_wait("lsection");
		obj_origin = GetEnt("triggercolor_turn_corner","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		
		flag_wait("turn_corner");
		obj_origin = GetEnt("final_pos_trigger","targetname").origin;
		Objective_Position(obj_number, obj_origin);

		//remove 3D objective for the animation and video
		flag_wait("gas_attack");
		Objective_Set3D(obj_number, false);

		flag_wait("player_in_warehouse");
		Objective_State(obj_number, "done");
		obj_number++;
		
	case "start_bike": 
		flag_wait ("player_recovered");

		//initial crumb is the player bike
		obj_origin = GetEnt("bike", "targetname").origin;
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_STEP_8", obj_origin);
		Objective_Set3D(obj_number, true);

		flag_wait ("player_on_bike");

		//the window
		obj_origin = getstruct("player_window_bullet_hit","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		trigger_wait ("delete_warehouse_guys");

		//the gate
		obj_origin = getstruct("gate","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		trigger_wait ("main_road_start");
				
		//first bridge
		obj_origin = getent("over_bridge","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		trigger_wait("over_bridge");

		//chopper spawn
		obj_origin = getent("chopper1_spawn","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		trigger_wait("chopper1_spawn");

		//oncoming truck
		obj_origin = getent("oncoming_truck_trigger","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		trigger_wait("oncoming_truck_trigger");

		//river approach
		obj_origin = getent("river_approach","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		trigger_wait("river_approach");

		//past river 
		obj_origin = getent("mg_warning","targetname").origin;
		Objective_Position(obj_number, obj_origin);
		flag_wait("vo_mg");

		Objective_Set3D(obj_number, false);

		//sub objective to get on the truck
		obj_number++;
		obj_ent = GetEnt("rez_truck", "targetname");
		Objective_Add(obj_number, "current", &"VORKUTA_OBJ_JUMP_ON_TRUCK", obj_ent);
		Objective_Set3D (obj_number, true, "default", "", -1, (-98,-36,72) );
		flag_wait ("rez_truck_warped");
		Objective_State(obj_number, "done");
		Objective_Delete(obj_number);
		obj_number--;

		//player jumped to the train
		flag_wait("player_jumped_on_train");
		Objective_State(obj_number, "done");
	}

	trigger_wait ("end_mission");
	obj_number = 0;
	Objective_State (obj_number, "done");
}

init_flags()
{
	//objective related flags
	flag_init("flag_obj_step_1");
	flag_init("flag_obj_step_2");
	flag_init("flag_obj_step_3");
	flag_init("flag_obj_step_4");
	flag_init("flag_obj_step_5");

	//event1 mine
	flag_init("flag_intro_punch_happened");
	flag_init("flag_intro_melee_happened");
	flag_init("flag_stop_intro_prisoner_loop");
	flag_init("flag_intro_fight_done");
	flag_init("flag_exit_mine");
	flag_init("flag_sergei_guards");
	flag_init("flag_sergei_intro_start");
	flag_init("flag_sergei_intro_over");
	flag_init("flag_inclinator_door_start");
	flag_init("flag_inclinator_door_finish");
	flag_init("flag_sergei_board");
	flag_init("flag_front_board");
	flag_init("flag_player_in_inclinator");
	flag_init("flag_reznov_in_inclinator");
	flag_init("flag_sergei_in_inclinator");
	flag_init("flag_front_passengers_in_inclinator");
	flag_init("flag_rear_passengers_in_inclinator");
	flag_init("flag_inclinator_moving");
	flag_init("flag_inclinator_conversation_done");
	flag_init("flag_sergei_skewer");
	flag_init("flag_skirmish_1_done");
	flag_init("flag_skirmish_2_done");
	flag_init("flag_everyone_at_doors");

	//event2 tower
	flag_init("flag_bridge_done");
	flag_init("flag_bridge_early");
	flag_init("flag_cart_start");
	flag_init("flag_cart_end");
	flag_init("tower_start");
	flag_init("shoot_tower");
	flag_init("tower_done");
	
	//slingshot
	flag_init("player_has_tower");
	flag_init("player_has_shotgun");
	
	//courtyard
	flag_init("flag_shoot_rope_guy");
	flag_init("flag_has_rope_gun");	
	flag_init("flag_heli_hit");
	flag_init("courtyard_start");
	flag_init("courtyard_done");
	flag_init("armory_entrance_guards_dead");//outside armory entrance
	flag_init("player_on_1st_floor_armory");
	flag_init("player_arriving_2nd_floor_armory");
	flag_init("player_in_armory");
	
	//event4 defend armory
	flag_init("covering_fire_guys_retreating");
	flag_init("rolling_door_ready");
	flag_init("player_can_see_rolling_door");
	flag_init("player_opened_rolling_door");
	flag_init("door_is_closed");
	flag_init("door_event_over");
	flag_init("rez_closed_door");
	flag_init("armory_defend_started");
	flag_init("back_door_guys_Spawned");
	flag_init("intermission_complete");
	flag_init("sunroof_guys_spawned");
	flag_init("sunroof_guys_attack");
	flag_init("antinov_going_to_garage");
	flag_init("antinov_at_stairs");
	flag_init("antinov_in_catwalk");
	flag_init("antinov_in_armory");
	flag_init("antinov_died");
	flag_init("repel_guys_in");
	flag_init("welding_cart_moving");
	flag_init("welding_cart_at_vault");
	flag_init("welding_half_done");
	flag_init("welding_stopped");
	flag_init("wave2_started");
	flag_init("wave2_complete");
	flag_init("windows_blown");
	flag_init("btr1_spawned");
	flag_init("btr1_arrived");
	flag_init("btr2_arrived");
	flag_init("btr2_firing");
	flag_init("btr1_dead");
	flag_init("btr2_dead");
	flag_init("all_btrs_dead");
	
	flag_init("delete_rush");
	flag_init("go_shields");
	flag_init("shield1_dead");
	flag_init("shield2_dead");
	flag_init("end_secondfloor");
	flag_init("sergei_inposition");
	flag_init("player_rolled");
	flag_init("sergei_dead");
	flag_init("close_rolldoor");
	flag_init("go_upstairs");
	flag_init("flag_torch_on");
	flag_init("flag_torch_off");
	flag_init("player_3rd_floor");
	flag_init("btr_entry");
	flag_init("to_bridge");
	flag_init("goto_weld");
	flag_init("at_welder");
	flag_init("get_weld");
	flag_init("heavy_intro");
	flag_init("reznov_pinned");
	flag_init("vault_open");
	flag_init("go_btr_victims");
	flag_init("kill_btr_victims");
	flag_init("heavy_armor");
	flag_init("got_minigun");
	flag_init("goto_window");
	flag_init("approach_btr1");
	flag_init("begin_alley");
	
	flag_init("into_alley");
	flag_init("lsection");
	flag_init("turn_corner");
	flag_init("across_road");
	flag_init("last_guy");
	flag_init("end_alley");
	
	flag_init("final_step");
	flag_init("gas_attack");
	flag_init("reznov_runs");
	flag_init("flag_player_gas_fade");
	flag_init("player_in_warehouse");
	
	//Event7 bike ride
	flag_init("player_recovered");
	flag_init("player_on_bike");
	flag_init("player_on_main_road");
	flag_init("player_at_first_merge");
	flag_init("Player_out_window");
	flag_init("gaz_chaser2_at_end_node");
	flag_init("gaz_chaser2_attackers_dead");
	
	flag_init("player_past_bridge");
	flag_init("player_at_river");
	flag_init("player_at_final_turn");
	flag_init("gaz_gunners_dead");
	flag_init("gaz_at_end_node");
	flag_init("gaz_crashed");
	flag_init("player_at_final_ramp");
	flag_init("jump_begin");
	flag_init("flag_jumped_to_train");
	flag_init("jump_outcome_set");
	flag_init("player_crashed_into_chopper");
	flag_init("player_released_bike");
	flag_init("player_landed_on_train");
}	

vorkuta_precache()
{
	//guns
	PreCacheItem ("rpg_magic_bullet_sp");
	PreCacheItem ("willy_pete_sp"); //remove if not magic nading anywhere
	PreCacheItem ("vorkuta_motorcycle_shotgun_sp");
	PreCacheItem("rpg_sp");
	PreCacheItem( "ks23_sp" );
	PreCacheItem( "ks23_hook_sp" );

	//shellshocks!
	PreCacheShellShock("explosion");

	//misc
	PreCacheModel("tag_origin");
	
	//intro props
	PrecacheModel("p_rus_vork_single_rock");
	PrecacheModel("p_rus_vork_pickaxe_sergei");
	PrecacheModel("anim_rus_inclinator_keys");

	//vehicle gibs
	PreCacheModel("t5_veh_gaz66_tire_low");
	PreCacheModel("t5_veh_gaz66_bumper_dest");
	PreCacheModel("t5_veh_gaz66_door_dest");
	
	//in game movies
	PreCacheShader("cinematic");
	
	//spinning light
	PreCacheModel("p_rus_rb_lab_warning_light_01");
	PreCacheModel("p_rus_rb_lab_warning_light_01_off");
	PreCacheModel("p_rus_rb_lab_light_core_on");
	PreCacheModel("p_rus_rb_lab_light_core_off");	

	PreCacheModel("anim_rus_torch_backpack");
	PreCacheModel("anim_rus_torch_backpack_stowed");
	PreCacheModel("anim_rus_torch");
	
	PreCacheModel( "t5_gfl_ump45_viewmodel" );
	PreCacheModel( "t5_gfl_ump45_viewmodel_player" );
	PreCacheModel( "t5_gfl_ump45_viewbody" );

	precacheshellshock("vorkuta_gas");
	
	//slingshot stuff
	maps\vorkuta_slingshot_util::slingshot_precache();
}	

setup_reznov()
{
	
	level.reznov = simple_spawn_single ("reznov");
	level.reznov.ignoreall = true;
	level.reznov.ignoreme = true;	
	level.reznov.name = "Reznov";
	level.reznov.goalradius = 32;
	
}	

//skip the intro cutscene
start_mine()
{
	level thread vorkuta_events();

	wait(0.5);

	flag_set("flag_obj_step_1");
	flag_set("flag_intro_fight_done");

}

//in front of the inclinator
start_inclinator()
{
	//spawn sergei
	level.sergei = simple_spawn_single("sergei", maps\_sergei::init_sergei);

	//spawn russians
	level.mine_russians[0] = maps\vorkuta_mine::mine_create_prisoner("prisoner_russian_1", false);
	level.mine_russians[1] = maps\vorkuta_mine::mine_create_prisoner("prisoner_russian_2", false);
	level.mine_control_guy = maps\vorkuta_mine::mine_create_prisoner("prisoner_cntrl", false);

	teleport_struct = GetStruct("start_inclinator");
	for(i = 0; i < level.mine_russians.size; i++)
	{
		level.mine_russians[i] forceteleport( teleport_struct.origin, teleport_struct.angles );	
	}
	level.mine_control_guy forceteleport( teleport_struct.origin, teleport_struct.angles );	
	level.sergei forceteleport( teleport_struct.origin, teleport_struct.angles );

	level thread maps\vorkuta_mine::event_2_vig_ready_passengers();
	level thread vorkuta_events();

	wait(0.1);
	level.reznov forceteleport( teleport_struct.origin, teleport_struct.angles );	

	start_teleport("start_inclinator");
	
	flag_set("flag_intro_fight_done");
	flag_set("flag_sergei_intro_over");
	array_thread(level.mine_russians, maps\vorkuta_mine::event_3_russians_board);
	level thread maps\vorkuta_mine::event_3_sergei_board();
	get_players()[0] GiveWeapon( "knife_sp", 0 );
	get_players()[0] GiveWeapon( "vorkuta_knife_sp", 0 );
	get_players()[0] SwitchToWeapon( "vorkuta_knife_sp" );
}

start_tower()
{
	flag_wait ("all_players_spawned");
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	level setup_reznov();
	level.reznov maps\_prisoners::make_prisoner();
	level.sergei = simple_spawn_single("sergei", maps\_sergei::init_sergei);
	
	level thread vorkuta_objectives("start_tower");

	//teleport AI?
	start_teleport( "start_tower" );
	
	//team
	rez_start = getstruct ("start_tower_rez", "targetname");
	level.reznov forceteleport (rez_start.origin,rez_start.angles);
	sergei_start = getstruct ("start_tower_sergei", "targetname");
	level.sergei forceteleport (sergei_start.origin,sergei_start.angles);

	//take guns, give pistol
	get_players()[0] TakeAllWeapons();
	get_players()[0] GiveWeapon( "knife_sp", 0 );
	get_players()[0] GiveWeapon ("makarov_sp");
	get_players()[0] SwitchToWeapon ("makarov_sp");

	//spawn Prisoners
	level.tower_start = true;

	
	//events
	anim_node = GetNode("anim_mine_exit_room","targetname");
	level.reznov thread maps\vorkuta_mine::event_4_reznov(anim_node);
	level.sergei thread maps\vorkuta_mine::event_4_sergei(anim_node);
	maps\vorkuta_mine::event_4_exit();
	maps\vorkuta_surface::surface_main();
	maps\vorkuta_armory::armory_main();
	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();
}	

start_slingshot()
{
	flag_wait ("all_players_spawned");
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	level setup_reznov();
	level.reznov maps\_prisoners::make_prisoner();
	
	level.sergei = simple_spawn_single("sergei", maps\_sergei::init_sergei);

	level thread vorkuta_objectives("start_slingshot");
	
	start_teleport_players ("start_slingshot");
		
	rez_start = getstruct ("start_sling_rez", "targetname");
	level.reznov forceteleport (rez_start.origin,rez_start.angles);
	sergei_start = getstruct ("start_sling_sergei", "targetname");
	level.sergei forceteleport (sergei_start.origin,sergei_start.angles);
	
	//take guns, give pistol
	get_players()[0] TakeAllWeapons();
	get_players()[0] GiveWeapon( "knife_sp", 0 );
	get_players()[0] GiveWeapon ("makarov_sp");
	get_players()[0] SwitchToWeapon ("makarov_sp");
		
	trigger_use ("slingshot_start");
	
	flag_set ("player_has_tower");

	level thread maps\vorkuta_surface::slingshot_int();
	level thread maps\vorkuta_surface::slingshot_int_sergei();
	level.reznov notify("left_cart");
	level.sergei notify("left_cart");
	maps\vorkuta_surface::slingshot();
	maps\vorkuta_surface::courtyard();
	flag_wait( "courtyard_done" );

	//rest of level
	maps\vorkuta_armory::armory_main();
	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();

	
}	
	

start_courtyard()
{
	flag_wait ("all_players_spawned");
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	level setup_reznov();
	level thread vorkuta_objectives("start_courtyard");
	
	start_teleport_players ("start_courtyard");
	
	//take guns, give guns
	get_players()[0] TakeAllWeapons();
	get_players()[0] GiveWeapon( "knife_sp", 0 );
	get_players()[0] GiveWeapon ("ks23_sp");
	get_players()[0] GiveWeapon( "makarov_sp", 0 );
	get_players()[0] GiveWeapon ("frag_grenade_sp");
	get_players()[0] SwitchToWeapon ("ks23_sp");
	
	//move reznov to courtyard
	rez_e3_start = getstruct("start_e3_reznov", "targetname");
	level.reznov forceteleport (rez_e3_start.origin,rez_e3_start.angles);
	
	//delete slingshot exit door or move guys
	door = GetEnt( "sling_door_exit", "targetname" );
	door_col = GetEnt( "slingshot_exit_col", "targetname" );
	door_col ConnectPaths();
	door_col LinkTo( door );
	door RotateYaw( -120,0.1 );
	
	//start friendly sm
	trigger_use ("sm_courtyard_friendly_1");

	//friendly chain for reznov and prisoners
	trigger_use("courtyard_gate_chain");
	
	flag_set ("player_has_shotgun");
			
	//orange color triggers for reznov for a while
	level.reznov set_force_color( "o" );
	level.reznov enable_ai_color();		
	level.reznov.ignoreall = false;
	level.reznov.ignoreme = false;	
	
	//shoot heli on roof
	maps\vorkuta_surface::courtyard();
	flag_wait( "courtyard_done" );


	//rest of level
	maps\vorkuta_armory::armory_main();
	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();
	
}	


start_enter_armory()
{
	flag_wait ("all_players_spawned");

	//remove the blocker brush so player can mantle off the roof
	blocker = GetEnt("helicopter_roof_blocker","targetname");
	blocker Delete();
	
	exit_door =  GetEnt( "rope_exit", "targetname" );
	exit_door Delete();
	exit_door_col = GetEnt( "rope_exit_col", "targetname" );
	exit_door_col ConnectPaths();
	exit_door_col Delete();
	
	trigger_to_armory = getent("squad_to_stairs", "targetname");
	trigger_to_armory trigger_on();

	player = get_players()[0];
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	//array_thread (GetEntArray ("courtyard_squad", "targetname"), ::add_spawn_function, ::e3_courtyard_followers_logic);  
	
	start_teleport_players ("start_e4_defend1");
	
	level setup_reznov();
	
	//move reznov
	rez_e4_start = getstruct("start_e4_defend1_rez", "targetname");
	level.reznov forceteleport(rez_e4_start.origin,rez_e4_start.angles);
	
	//turn off ingore on Rez
	level.reznov.ignoreme = false;
	level.reznov.ignoreall = false;
	
	//orange color triggers for reznov for a while
	level.reznov set_force_color( "c" );
	
	player TakeAllWeapons();
	player GiveWeapon( "knife_sp", 0 );
	player GiveWeapon ("ak47_gl_sp");
	player GiveWeapon ("ks23_sp");
	player GiveWeapon("frag_grenade_sp");
	player SwitchToWeapon("ak47_gl_sp");
		
	level thread vorkuta_objectives("start_enter_armory");
		
	maps\vorkuta_armory::armory_main();
	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();
}	


start_defend_armory()
{
	flag_wait ("all_players_spawned");
	
	spawn_manager_kill("manager_armory_rush");
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	level setup_reznov();
	
	start_teleport_players ("start_e4_defend2");
	
	//move reznov 
	rez_e4_start = getstruct("start_e4_defend2_rez", "targetname");
	level.reznov forceteleport (rez_e4_start.origin,rez_e4_start.angles);
	
	//turn off ingore on Rez
	level.reznov.ignoreme = false;
	level.reznov.ignoreall = false;
	level.reznov clear_force_color();
	level.reznov setgoalpos(level.reznov.origin);
	
	get_players()[0] TakeAllWeapons();
	get_players()[0] GiveWeapon( "knife_sp", 0 );
	get_players()[0] GiveWeapon ("ak47_sp");
	get_players()[0] GiveWeapon ("ks23_sp");
	get_players()[0] SwitchToWeapon ("ak47_sp");
		
	level thread vorkuta_objectives("start_defend_armory");
	
	flag_set("player_rolled");
	//flag_set("player_3rd_floor");
	flag_set("go_upstairs");
	flag_set("player_on_1st_floor_armory");
	flag_set("player_second_floor");
	flag_set ("player_arriving_2nd_floor_armory");
	
	wait(0.5);
	
	trigger_use("reznov_up_stairs");
	
	guys = getentarray("armory_rush_ai", "targetname");
	for(i=0; i<guys.size; i++)
	{
		guys[i] delete();
	}
	
	trigger_wait("trigger_third_floor");
	
	flag_set ("player_3rd_floor");
	
	maps\vorkuta_armory::armory_main();
	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();
}


start_minigun_alley()
{
	flag_wait ("all_players_spawned");
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	level setup_reznov();
	
	level thread vorkuta_objectives("start_minigun_alley");
	
	//take weps, give m16 and shottie
	get_players()[0] TakeAllWeapons();
	get_players()[0] GiveWeapon ("minigun_sp");
	get_players()[0] GiveWeapon ("ks23_sp");
	get_players()[0] SwitchToWeapon ("minigun_sp");
	
	//move player
	start_teleport_players ("start_minigun_alley");
	
	//move reznov 
	rez_e5_start = getstruct("start_e5_tank_rez", "targetname");
	level.reznov forceteleport (rez_e5_start.origin,rez_e5_start.angles);
	level.reznov set_force_color("c");
	level.reznov thread maps\vorkuta_armory::vo_reznov_minigun();
	level thread maps\vorkuta_armory::armory_exit_under_fire();

	add_spawn_function_veh("gaz_gunner_1", maps\vorkuta_armory::armory_exit_gaz_gunner_1);
	add_spawn_function_veh("gaz_gunner_2", maps\vorkuta_armory::armory_exit_gaz_gunner_2);
	add_spawn_function_veh("gaz_alley", ::truck_monitor);

	level thread maps\vorkuta_armory::defend_open_outside_gates();

	trigger_btr_reinforce = getent("trigger_btr_reinforcement", "targetname");
	trigger_btr_reinforce thread maps\vorkuta_armory::armory_exit_gaz_reinforcement();
	delayThread(5, ::trigger_use, "trigger_btr_reinforcement");

	//turn off ingore on Rez
	level.reznov.ignoreme = false;
	level.reznov.ignoreall = false;
	
	spawn_manager_enable("manager_prisoner_alley");
	spawn_manager_enable("manager_alley_fighter");
	level thread maps\vorkuta_armory::spawn_prisoners();

	maps\vorkuta_minigun_alley::minigun_alley_main();
	maps\vorkuta_event7::event7_main();
}	
	
start_bike()
{
	flag_wait ("all_players_spawned");
	
	clientnotify( "ors" ); //C. Ayers: WIll override the audio snapshot set up on the client
	
	level setup_reznov();
	
	level thread vorkuta_objectives("start_bike");
	
	//move player
	start_teleport_players ("start_e7_bike");
	
	rez_e7_start = getstruct ("start_e7_bike_rez", "targetname");
	level.reznov forceteleport (rez_e7_start.origin,rez_e7_start.angles);
	
	level.reznov SetGoalPos (level.reznov.origin);

	level thread maps\vorkuta_event7::event7_main();
	
	wait(1);
	
	flag_set ("player_in_warehouse");
	

}	
	
vorkuta_fx_on_player()
{
	level.outdoor = false;
	
	//grab trigs
	
	player = get_players()[0];
	
	while(1)
	{
		if( level.outdoor == true )
		{
			//playfx
			//PlayFXOnTag(level._effect["player_outdoor"], player, "tag_origin");
			PlayFX (level._effect["player_outdoor"], player.origin);

		}
		
		wait 1;
				
	}
	
}