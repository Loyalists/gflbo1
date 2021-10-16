#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\_clientfaceanim;


#using_animtree("generic_human");

main()
{
	
	level.drone_weaponlist_axis = [];
	level.drone_weaponlist_axis[0] = "fnfal_sp";
	
	maps\hue_city_fx::main();
	
	precacheeverything("everything");
	
	default_start( maps\hue_city_event1::event1_main, false ); 
	add_start( "e1c_macv", maps\hue_city_event1::event1_new_skipto, "macv top floor" );
	add_start( "e1c_after_skydemon", maps\hue_city_event1::event1_new_skipto_after_skydemon, "after skydemon" );
	add_start( "e1c_mowdown", maps\hue_city_event1::event1_new_skipto_mowdown, "civilian mowdown" );
	add_start( "e1d", maps\hue_city_event1_reznov::event1d_start, "macv_transition_reveal" );
	add_start( "e2_streets", maps\hue_city_event2::event2_start, "steets" );
	add_start( "e2b_streets_end", maps\hue_city_event2::event2b_start, "streetsb" );
	add_start( "e2c_2ndtank_vignette", maps\hue_city_event2::event2c_start, "midsection" );
	add_start( "e2d_after_balcony", maps\hue_city_event2::event2d_start, "1st_tank" );
	add_start( "e3_defend", maps\hue_city_event3::event3_start, "defend" );
	add_start( "e3b_defend_choppers_retreat", maps\hue_city_event3::event3b_start, "defend_wave2" );
	add_start( "e3c_defend_call_airstrike", maps\hue_city_event3::event3c_start, "defend_wave2" );

	init_flags();
	setsaveddvar( "phys_buoyancy", "0" );
	// MKV correct painful parallax in stereo 3d when on mg62; DVAR_SAVED so resets on level load
	setsaveddvar("r_stereoTurretShift", 5);
	level.swimmingFeature = false;

	level thread vista_delete();
	maps\_load::main();
	
	//-- GLocke: moved this to after _load so that the _callback arrays are all setup
	OnSaveRestored_Callback( ::angles_save_restore );
	
	level.drone_spawnFunction["axis"] = character\c_vtn_nva1::main;
	level.drone_spawnFunction["allies"] = character\c_usa_jungmar_assault::main;
	
	level.max_drones["axis"] = 40;
	level.max_drones["allies"] = 0;	
	maps\_drones::init();	

	level thread maps\hue_city_fx::initModelAnims_delay();
		
	maps\hue_city_ai_spawnfuncs::hue_city_ai_spawnfuncs(); 
	
		// utilized version of chopper support, although curently will only work with this level
	level thread maps\_chopper_support::main();
		
		// If you have civilians in your level, then call civilians init function after load.
	maps\_civilians::init_civilians();
	// maps\_door_breach::door_breach_init("viewmodel_usa_jungmar_player_fullbody"); 
	maps\_door_breach::door_breach_init("t5_gfl_ump45_viewbody"); 

	maps\hue_city_amb::main();
	maps\hue_city_anim::hue_city_anim_main();
	
	trigs_off();
	level thread player_setup();
	init_level_variables();
	level thread threatbiasgroups();
	level thread glass_only_player_can_break();
	
	//turn off hurt trigger for the molotov throwers
	molotov_hurt_trig = getent("molotov_hurt_trig","targetname");
	molotov_hurt_trig trigger_off();
	
	//tracking the 'dragon within' achievment of killing 10 dudes w/the dragons breath
	level.dragon_deaths = 0;
	
	//tracking the 'raining pain' achievement of kiling 20 guys w/the chopper
	level.huey_deaths = 0;
	

	//level thread debug_main();
}

angles_save_restore()
{
	player = get_players()[0];
	angles = player getplayerangles();
	for (i = 0; i < 10; i++)
	{
		player SetPlayerAngles( (0,angles[1],angles[2]) );
		wait(0.05);
	}

}

vista_delete()
{
	trigger_wait("nearing_e2","targetname");
	brushes = getentarray("vista_delete","targetname");
	while(brushes.size < 1)
	{
		wait(1);
		brushes = getentarray("vista_delete","targetname");
	}
	array_delete(brushes);
}

Callback_DemoActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	// Allies are unaffected.
	// Damage that will kill is unaffected.
	// Otherwise damage is increased, so next hit should kill.
	
	if(self.team == "allies")
	{
		return iDamage;
	}
	
	if(IsDefined(eAttacker) && eAttacker != level.player)
	{
		return iDamage;	// don't make friendlies do more damage.
	}
	
	if(iDamage > self.health)
	{
		return iDamage;
	}
	
	if(iDamage < (self.health - 5))
	{
		iDamage = self.health - 5;
	}
	
	return iDamage;
}


player_setup()
{
	wait_for_all_players();
	level.player = get_players()[0];
}


new_e1_start()
{
	level thread fake_intro();

}

play_radio_chatter()
{
	//setGroupSnapshot ( "quagmire_in_chopper");
	
	sound_org = spawn ("script_origin", (0,0,0));
//	soundtag = self GetTagOrigin ( "snd_cockpit" );
//	sound_org linkto ( self, soundtag );
	sound_org playloopsound ("amb_cb_chatter" );
		
	level waittill ("radio_off");
	
	sound_org stoploopsound(4);
	
}

init_flags()
{
			// EVENT 1 - MACV FLAGS
	flag_init("event1_skydemon_ready");				 // set when level.macv_skydemon is ready to use ( is defined )
	flag_init("macv_civ_corner_surprise_2_spawned"); // set when this civilian is spawned, when flag set woods aim's at this civilian
	flag_init("event1_skydemon_done");  			 // set when skydemon has finished killing everyone
	flag_init("repel_is_on");				 		 // set when the intro chopper repel should start				
	flag_init("chopper_hit");						 // set when the burning effect start on the fake spirit heli
	flag_init("redshirt_repelling");				 // set when redshirt start repelling
	flag_init("repel_done");						 // set when repel sequence is done
	flag_init("molotov_being_thrown");				 // set when AI is about to the grenade
	flag_init("molotov_thrower_done");				 // set when the greande thrower on the stairs is done
	flag_init("morse_code_guy_dead");				 // set when the morse code guy after the door breach is dead
	flag_init("repel_troop_start");					 // set when tropp1 in repelsequnce starts animating
	flag_init("bowman_repel_started");				 // set when bowman is just about to start the repel
	flag_init("bowman_repel_done");					 // set when bowman is done with repel
	flag_init("aa_gun_switch_fire");				 // set when aa gun starts firing on spirit
	flag_init("player_eye_blinked");				 // set when player's eye is blinked in war room balcony fall

	flag_init("override_sumeets_cqbwalk");
	flag_init("woods_breaching_reznov_hall");
	flag_init("in_reznov_room");
	flag_init("war_room_clear");	
	flag_init("cut_current_dialogue");
	flag_init("actor_speaking");
	flag_init("full_rappel_sequence");
	flag_init("still_with_me");
	flag_init("bowman_repel_go");
	flag_init("skydemon_flyover_1_spawned");
	flag_init("doing_rezhall_quickanim");
	flag_init("reznov_reveal_start");
	
		//  triggered flag   flag_init("out_of_macv");
		//  triggered flag   flag_init("civ_mowdown_room");
		//  triggered flag   flag_init("player_in_reznov_hall");
		//  triggered flag   flag_init("approaching_macv");
		//  triggered flag   flag_init("civ_mowdown_room");
		//  triggered flag   flag_init("crossing_e1b_street");
	
			// EVENT 2 - STEET BATTLE FLAGS
	flag_init("event2_skipto");
	flag_init("gimmie_son");
	flag_init("first_airstrike_called");
	flag_init("authorization_operation_said");
	flag_init("chopper_vignette_over");
	flag_init("event2_start_go");
	flag_init("requesting_air_support");
	flag_init("get_chopper_now");
	flag_init("end_strafe");
	flag_init("dont_clear_friendlies");

	flag_init("tank_ok_to_target");
	flag_init("enemytank1_almost_inplace");
	flag_init("tank_in_final_position");
	flag_init("tank_strafe_commencing");
	flag_init("street1_tank_dead_now");
	flag_init("player_ready_alley_door");
	flag_init("apc_reached_end_node");
	flag_init("street_end_go");
	flag_init("skydemon_taking_aa_fire");
	flag_init("playboy_blowthrough_go");
	flag_init("get_off_street_go");
	flag_init("chopperstrike_1_called");
	flag_init("chopperstrike_2_called");
	flag_init("chopperstrike_3_called");
	flag_init("chopperstrike_4_called");
	flag_init("chopperstrike_5_called");
	flag_init("alleyskipto_start");
	flag_init("enemytank1_modelswap");
	
	flag_init("woods_at_playboy");
	flag_init("skydemon_ran_from_aa_gun");
	flag_init("ignore_player_now");
	flag_init("alley_car_explosion");
	flag_init("playboy_ohshit_go");
	flag_init("flashback_done");
	flag_init("alley_aa_gun_spawned");
	flag_init("sending_alley_jets_1");
	flag_init("alleyjets_1_gone");
	flag_init("alley_door_ready");
	flag_init("alley_balcony_fell");
	flag_init("through_alley_door");
	flag_init("street_beating_zone_said");
	flag_init("tank_in_good_balconyshot_position");
	flag_init("c4_planted");
	flag_init("aagun_blown");
	flag_init("alley_cross_chopper_shootdown_go");
	
	//  triggered flag	flag_init("alleytank_at_end");
	//  triggered flag	flag_init("gonna_need_as");
	//  triggered flag	flag_init("apcchain1_go");
	//  triggered flag	flag_init("apcchain2_go");
	//  triggered flag	flag_init("apcchain3_go");
	//  triggered flag	flag_init("apcchain4_go");
	//  triggered flag	flag_init("apcchain5_go");
	//  triggered flag   flag_init("player_is_before_balcony");
	//  triggered flag	flag_init("street_end_ready");
	//  triggered flag	flag_init("through_alley_gate");
	//  triggered flag	flag_init("on_midstreet_trig");	
	//  triggered flag	flag_init("alley_tank_trig_fired");
	//	triggered flag	flag_init("brutalize_scene_go");
	//	triggered flag	flag_init("execution_scene_go");
	//	triggered flag	flag_init("in_alley_stair_room");
	//	triggered flag	flag_init("at_aa_gun");
	//	triggered flag	flag_init("player_on_alley_balcony");
	
			// Event 3 - Defend flags
	flag_init("e3_player_near_leaving_chopper");
	flag_init("mortar_guys_clear");
	
	flag_init("said_grab_scoped");
	flag_init("said_there_on_roof");
	flag_init("said_need_take_out_spotters");
	flag_init("said_on_the_rooftop");
	
	
	flag_init("wounded_on_skydemon");
	flag_init("defend_loudspeaker_started");
	flag_init("satchels_depeleted");
	flag_init("claymores_depeleted");
	flag_init("ruins_sm_on");
	flag_init("street_sm_on");
	flag_init("dock_sm_on");
	flag_init("mortar_guys_out");
	flag_init("defend_light_sm_on");
	flag_init("ready_for_defend");
	flag_init("acog_objective_active");
	flag_init("retreat_choppers_flyover");
	flag_init("wave2_timer_done");
	flag_init("bomber_support_ready");
	flag_init("final_airstrike_called");
	flag_init("player_in_boat");
	flag_init("defend_wave1_smoke_fading");
	flag_init("2nd_wave_on");
	flag_init("saying_direct_fire_support");
	flag_init("doing_defend_color_chains");
	flag_init("get_people_back_said");


	
		// triggered flag flag_init("player_running_to_boat");	
		// triggered flag flag_init("player_near_landed_skydemon");
		// triggered flag flag_init("event3_go");



		// Client flags
	level.CLIENT_RAGLAUNCH_FLAG	= 2;



}


// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Objective functions ----
// -------------------------------------------------------------------------------------
event1_handle_objectives()
{
	switch_case = undefined;

	// check if we are skipping
	if( !IsDefined( level.skipto ) )
	{
		switch_case = "default";
	}
	else
	{
		switch_case = level.skipto;
	}
	
	switch ( switch_case )
	{
		case "default":	
		{

		}
	}
}


objective_control(num)
{
	switch (num)
	{
		case 1:
		{
			// search macv for the informer	
			Objective_Add( 1, "current", &"HUE_CITY_OBJ_1" );
			Objective_Set3D( 1, true, "default" , "" );
			
			for (i=1; i < 8; i++)
			{
				trig = GetEnt("macv_obj_trig_"+i, "script_noteworthy");
				spot = getstruct("macv_obj_trig_"+i+"_spot", "script_noteworthy");
				Objective_Position(1, spot.origin);
				trig waittill_any("trigger", "death");
			}
									
			struct = getstruct("dispatch_breach_marker", "targetname");
			Objective_Position(1, struct.origin);
			Objective_Set3D( 1, true, "default" ,&"HUE_CITY_BREACH" );
			
			flag_wait("player_breaching");

			Objective_Set3D( 1, true, "default" , "" );
			
			for (i=8; i < 10; i++)
			{
				trig = GetEnt("macv_obj_trig_"+i, "script_noteworthy");
				spot = getstruct("macv_obj_trig_"+i+"_spot", "script_noteworthy");
				Objective_Position(1, spot.origin);
				trig waittill_any("trigger", "death");
			}
			
			Objective_Position(1, level.woods);
			Objective_Set3D( 1, true, "default" , &"HUE_CITY_SUPPORT" );
			
			flag_wait("war_room_clear");
			Objective_Set3D( 1, true, "default" , &"HUE_CITY_REGROUP" );
						
			flag_wait("player_in_reznov_hall");
			trig = GetEnt("rh_end_trig", "targetname");

			Objective_Position( 1, trig.origin+(0,0,45) );
			Objective_Set3D( 1, true, "default" , &"HUE_CITY_BREACH" );
				
			trigger_wait("in_reznov_room");
			
			//TUEY Sets music state to BREACh REZNOV DOOR
			setmusicstate ("BREACH_REZNOV_DOOR");
			flag_wait("reznov_reveal_start");
			Objective_State(1, "done");
			
			flag_wait("in_reznov_room");
			
			Objective_Add( 2, "current", &"HUE_CITY_OBJ_2A" );
			Objective_Set3D( 2, true, "default" , "" );
						
			for (i=10; i < 13; i++)
			{
				trig = GetEnt("macv_obj_trig_"+i, "script_noteworthy");
				spot = getstruct("macv_obj_trig_"+i+"_spot", "script_noteworthy");
				Objective_Position(2, spot.origin);
				trig waittill_any("trigger", "death");
			}
		}
		break;
						
		case 3:
		{
			
			if (flag("event2_skipto") || flag("alleyskipto_start") )
			{
				Objective_Add( 1, "active", &"HUE_CITY_OBJ_1");
				Objective_State(1, "done");
				Objective_Add( 2, "current", &"HUE_CITY_OBJ_2B" );
			}
			
			if (!flag("alleyskipto_start")) // more hackery for skipto objective testing
			{
				trigger_wait("sky_cowbell_2_trig");
				//trig = GetEnt("street_objective1", "targetname");
				trig = GetEnt("street_objective_trig_1", "targetname");
				Objective_String(2, &"HUE_CITY_OBJ_2B");
				Objective_State(2, "active");
				Objective_Set3D( 2, 0);
				
				objective_add(3, "current", &"HUE_CITY_OBJ_3",  trig.origin+(0,0,100) );
				objective_current(3);
				Objective_Set3D ( 3, 1, "default", "" );
					
				if (!flag("get_chopper_now"))
				{
					guy = level.crosby;
					Objective_Position(3, guy.origin+(0,0,50) );
					Objective_Set3D ( 3, 1, "default", &"HUE_CITY_OBJ_3A" );
					flag_wait("get_chopper_now");
					Objective_State(3, "done");
					Objective_Delete(3);
					Objective_State(2, "current");
				}
				
				flag_wait("chopperstrike_1_called");
				
				apc = GetEnt("e2_friendly_apc", "targetname");
				Objective_Position( 2, apc );	
				Objective_Set3D ( 2, 1, "default", &"HUE_CITY_SUPPORT", -1, (0,0,140) );			
				
				flag_wait("tank_ok_to_target");
				tank = GetEnt("enemytank1", "targetname");
				Objective_Position( 2, tank );	
				Objective_Set3D ( 2, 1, "default", &"HUE_CITY_TARGET", -1, (0,0,140) );	
				flag_wait("street1_tank_dead_now");	
				
				//TUEY  Set music to APC_OWNED
				setmusicstate ("APC_OWNED");
			}
			
			trig = GetEnt("pillar_area_battle", "script_noteworthy");
			if (IsDefined(trig))
			{
				Objective_Position( 2, trig.origin );	
				Objective_Set3D ( 2, 1, "default", "" );
				trig waittill_any("trigger", "death");
			}
			
			trig = GetEnt("on_midstreet_trig", "targetname");
			Objective_Position( 2, trig.origin );	
			flag_wait("skydemon_taking_aa_fire");
				
			Objective_State(2,"active");
			Objective_Set3D ( 2, 0 );
			
			objective_add(4, "current", &"HUE_CITY_OBJ_4",  level.woods );
			Objective_Position( 4, level.woods );	
			Objective_Set3D ( 4, 1, "default", &"HUE_CITY_FOLLOW" );
		
			flag_wait("woods_at_playboy");
			
			Objective_Set3D ( 4, 1, "default", &"HUE_CITY_OBJ_HELP_WOODS" );
			

			flag_wait("playboy_blowthrough_go");
			Objective_Set3D( 4, 0);

			flag_wait("through_alley_door");
			c4 = getstruct("c4_obj", "targetname");
			
			Objective_Position(4, c4.origin );
			Objective_Set3D( 4, 1, "default", "" );
			
			for( i=1; i < 7; i++ ) // this loop strings you alone to each next objective spot
			{
				trig = getent("alley_obj_trig_"+i, "script_noteworthy");
				Objective_Position( 4, trig.origin );
				trig waittill ("trigger");
			}
			
			Objective_Position( 4, c4.origin+(0,0,-15) );
			
			while(DistanceSquared(level.player.origin, c4.origin) > (450*450) )
			{
				wait 0.05;
			}
		
			Objective_Set3D ( 4, 1, "default", &"HUE_CITY_PLANT_C4" );
			flag_wait("c4_planted");
			Objective_Set3D ( 4, 0 );
			
			Objective_string(4, &"HUE_CITY_DETONATE_EXPLOSIVE");			
			level waittill ("aagun_blown");
			objective_state(4,"done");
			Objective_Delete(4);
			
			spot = getstruct("defend_objective_spot", "targetname");
			Objective_Position( 2, spot.origin );		
			Objective_Set3D ( 2, 1, "default", &"HUE_CITY_LANDING_ZONE" );
			objective_current(2);
		}
		break;
		
		case 4:
		{
			Objective_State(2,"done");
			Objective_Delete(2);
			Objective_Set3D ( 2, 0 );
			c4_trig = GetEnt("near_c4_trig", "targetname");
			objective_add(5, "active", &"HUE_CITY_OBJ_5", c4_trig.origin+(0,0,50) );
			
			claytrig = GetEnt("near_claymore_trig", "targetname");
			Objective_Position( 5, claytrig.origin+(0,0,45) );
			//Objective_Set3D ( 5, 1, "default", &"HUE_CITY_CLAYMORES" );
			
			objective_add(6, "current", &"HUE_CITY_OBJ_6", c4_trig.origin+(0,0,50) );
			//Objective_Set3D ( 6, 1,"default", &"HUE_CITY_SATCHEL_CHARGES" );
			
			flag_wait("defend_loudspeaker_started");
			
			Objective_Set3D ( 6, 0 );
			Objective_State(6, "done");
			Objective_Delete(6);
			
			spot = getstruct("defend_objective_spot", "targetname");
			Objective_Position( 5, spot.origin+(0,0,-50) );
			Objective_Set3D ( 5, 0,"default",  &"HUE_CITY_DEFEND" );
			Objective_State(5, "current");
		
		}
		break;
		
		case 5:
		{
			Objective_Add (7, "active", &"HUE_CITY_OBJ_7A" );
			Objective_Current(6);
			Objective_State(5, "active");
			objective_set3d(5, 0);
			
			flag_waitopen("mortar_guys_out");
			
			Objective_State(7,"done");
			Objective_Delete(7);
			Objective_State(5, "current");
			Objective_Set3D ( 5, 1,"default",  &"HUE_CITY_DEFEND" );
		}
		break;
		
		case 6:
		{
			Objective_Add (8, "active", &"HUE_CITY_OBJ_8" );
			Objective_Current(8);
			Objective_State(5, "active");
			objective_set3d(5, 0);
			
			level waittill ("final_airstrike_called");;
			
			Objective_State(8,"done");
			Objective_Delete(8);
			Objective_State(5, "current");
			Objective_Set3D ( 5, 0,"default",  &"HUE_CITY_DEFEND" );
		}
		break;
		
		case 7:
		{
			Objective_State(8,"done");
			Objective_Delete(8);
			Objective_State(5, "done");
			Objective_Delete(5);
			Objective_Set3D ( 5, 0 );
			
			wait 0.1;
			spot = GetEnt("end_save_boat", "targetname");
			objective_add(9, "active", &"HUE_CITY_OBJ_9", spot);
			objective_current(9);
			Objective_Set3D ( 9, 1, "default", "");
		}
		break;
		
		case 8:
		{
			Objective_State(9, "done");
			Objective_Delete(9);
			Objective_Set3D ( 9, 0 );
		}
	}
}


trigs_off()
{
	trigs = [];
	trigs = array_combine( getentarray("trigmeoff", "script_noteworthy"), trigs);
	
	for( i=0; i < trigs.size; i++ )
	{
		trigs[i] trigger_off();
	}
	
	clips = array_combine(GetEntArray("defend_split_ai_pathing_clip", "targetname"), GetEntArray("balcony_fell_mclip", "targetname") );
	
	for (i=0; i < clips.size; i++)
	{
		clips[i] ConnectPaths();
		clips[i] trigger_off();
	}
}
	
threatbiasgroups()
{
	CreateThreatBiasGroup( "standard_enemies" );
	CreateThreatBiasGroup( "ai_biased_enemies" );
	CreateThreatBiasGroup( "player_biased_enemies" );
	
	
	CreateThreatBiasGroup("player");
	CreateThreatBiasGroup("player_ignored");
	CreateThreatBiasGroup("ignore_player");
	CreateThreatBiasGroup("ignored_hero");
	
	SetIgnoreMeGroup("player_ignored", "ignore_player");
	SetIgnoreMeGroup("ignore_player", "player_ignored");
	SetIgnoreMeGroup("player", "ignore_player");
	SetIgnoreMeGroup("ignore_player", "player");
	SetIgnoreMeGroup("player_ignored", "axis");
	SetIgnoreMeGroup("axis", "player_ignored");
	
	SetIgnoreMeGroup("ignored_hero", "ignore_player");
	
	wait_for_first_player();
	level.player SetThreatBiasGroup("player");
	wait 5;
	level.player SetThreatBiasGroup("player");
}

#using_animtree( "generic_human" );
precacheeverything(jokes_on_u)
{
	PreCacheItem("spas_sog_sp");
	PreCacheItem("spas_db_sp");
	//PreCacheItem("zpu_turret");
	//PreCacheItem("ak47_sp");
	//PreCacheItem("willy_pete_sp");
	PreCacheItem("spas_sp");
	PreCacheItem("rocket_barrage_sp");
	//PreCacheItem("creek_satchel_charge_sp");
	PreCacheItem("satchel_charge_sp");
	//PreCacheItem("commando_acog_sp");
	PreCacheItem("claymore_sp");
	
	PreCacheModel("tag_origin");
	//PreCacheModel("t5_weapon_ak47_world");
	PreCacheModel("t5_veh_jet_f4_gearup_lowres");
	PreCacheModel("p_glo_metal_chair");
	PreCacheModel("viewmodel_usa_jungmar_player_fullbody");
	PreCacheModel("anim_jun_carabiner");
	PreCacheModel("t5_weapon_spas_world");
	PreCacheModel("viewmodel_usa_jungmar_player");
	PreCacheModel("p_glo_plainchair");
	PreCacheModel("t5_weapon_radio_viewmodel");
	PreCacheModel("t5_veh_tank_t55_lite");
	PreCacheModel("t5_veh_helo_huey_vista");
	PreCacheModel("t5_veh_helo_huey");
	PreCacheModel("fxanim_hue_aagun_mod");
	PreCacheModel("weapon_c4_obj");
	PreCacheModel("weapon_c4");
	PreCacheModel("weapon_claymore");
	PreCacheModel("weapon_claymore_objective");
	//PreCacheModel("t5_veh_boat_pbr_revision");
	PreCacheModel("fxanim_creek_junk1_mod");
	PreCacheModel("t5_veh_civ_tiara");
	//PreCacheModel("t5_veh_boat_pbr_set01");
	PreCacheModel("mortar_shell");
	PreCacheModel("t5_weapon_commando_world");
	PreCacheModel("p_pent_manila_folder_1");
	PreCacheModel("t5_veh_boat_pbr_sugarfree");
	PreCacheModel("t5_veh_helo_huey_att_rockets");
	PreCacheModel("t5_veh_helo_huey_att_interior");	
	PreCacheModel("t5_veh_helo_huey_att_interior_vista");
	
	PreCacheModel("t5_gfl_ump45_viewbody");

	PreCacheShellShock("quagmire_window_break");
	PreCacheShellShock("explosion");
	PreCacheShellShock("tankblast");
	
	PreCacheString( &"HUE_CITY_INTROSCREEN_TITLE" ); 
	PreCacheString( &"HUE_CITY_INTROSCREEN_DATE" ); 
	PreCacheString( &"HUE_CITY_INTROSCREEN_PLACE" ); 
	PreCacheString( &"HUE_CITY_INTROSCREEN_NAME" ); 
	PreCacheString( &"HUE_CITY_INTROSCREEN_INFO" ); 
	PreCacheString( &"HUE_CITY_RAPELHINT");

	// SUMEET SECTION - 

	//added a hint string to tell the player to switch to dragons breath
	PreCacheString( &"HUE_CITY_SPAS_SWITCH");
	
	// added rope model
	PreCacheModel("anim_jun_rappel_rope");
	PreCacheModel("c_usa_jungmar_fieldagent_fb");

	// 	added molotov weapon
	PreCacheItem("molotov_sp");
	PreCacheItem("napalmblob_sp");
	
	PreCacheRumble("artillery_rumble");
	PreCacheRumble("melee_garrote");
	PreCacheRumble("assault_fire");
	PreCacheRumble("barrel_explosion");
	PreCacheRumble("damage_heavy");
	PreCacheRumble("damage_light");
	PreCacheRumble("defaultweapon_fire");
	PreCacheRumble("explosion_generic");
	PreCacheRumble("grenade_rumble");
	PreCacheRumble("heavygun_fire");
	PreCacheRumble("pistol_fire");
	
	character\c_usa_jungmar_tanker::precache();
	PreCacheModel( "t5_knife_sog" );	
	
	//attachments
	PreCacheItem("commando_acog_sp");
	preCacheItem("commando_dualclip_sp");
	preCacheItem("commando_gl_sp");
	preCacheItem("gl_commando_sp");
		
	PreCacheItem("commando_acog_dualclip_sp");
	preCacheItem("commando_gl_dualclip_sp");
	preCacheItem("commando_acog_gl_dualclip_sp");	
	
	
	PreCacheItem("fnfal_acog_sp");	
	preCacheItem("fnfal_acog_extclip_sp");
	preCacheItem("fnfal_acog_gl_extclip_sp");	
	preCacheItem("fnfal_acog_dualclip_sp");
	preCacheItem("fnfal_acog_gl_dualclip_sp");
	
	PreCacheItem("fnfal_gl_sp");
	preCacheItem("gl_fnfal_sp");
	preCacheItem("fnfal_gl_extclip_sp");
	preCacheItem("fnfal_gl_dualclip_sp");
	preCacheItem("fnfal_acog_gl_sp");	

	
	preCacheItem("rpk_acog_sp");
	preCacheItem("rpk_extclip_sp");
	preCacheItem("rpk_acog_extclip_sp");
	
	precacheShader("cinematic");

	character\gfl\character_gfl_saiga12::precache();
}

woods_ridealong()
{
	woods = getent("woods_struct_spawner", "targetname") stalingradspawnsafe(1);
	wait 0.05;
	level.woods = woods;
	woods linkto (level.spirit, "tag_passenger3", (0,0,0) );
	woods.pacifist = true;
	woods.name = "Woods";
	woods.targetname = "woods_spirit";
	woods.ignoreme = true;
}

init_level_variables()
{
	level._forcechoke = 1;
	level._attackers_killed_by_player = 0;
	
	// setup ahero  squad array
	if( !IsDefined( level.squad ) )
	{
		level.squad = [];
	}

}

init_results_hudelem(x, y, alignX, alignY, fontscale, alpha)
{
	self.x = x;
	self.y = y;
	self.alignX = alignX;
	self.alignY = alignY;
	self.fontScale = fontScale;
	self.alpha = alpha;
	self.sort = 20;
	self.font = "objective";
}

switch_music_timer(time, state)
{
	wait (time);
	setmusicstate (state);
}

fake_intro()
{

	
	
	bg = NewHudElem(); 
	bg.x = 0; 
	bg.y = 0; 
	bg.horzAlign = "fullscreen"; 
	bg.vertAlign = "fullscreen"; 
	bg.foreground = true; 
	bg SetShader( "white", 640, 480 ); 
	bg.alpha = 1; 
	bg FadeOverTime( 2 );
	
	wait 2;
	bg FadeOverTime( 1 );
	bg.alpha = 0; 
	
	wait 10;
	bg destroy();
}
		
is_macv_start()
{
	
	if ( is_part_of_name(GetDvar( #"start"), "e1") || 		// for when I no compile these to work on other sections
			 GetDvar( #"start") == "" )
	{
		return true;
	}
	else
		return false;
}

get_skydemon()
{
	while(!IsDefined(level.skydemon))
	{
		level.skydemon = GetEnt("skydemon", "targetname");
		wait 0.1;
	}
	return level.skydemon;
}

three_jet_squadron(name, traveltime, quake, movedelay)
{
	playsoundatposition ("veh_mig_flyby_2d", (0,0,0));
	jet1 = getstructent(name+"_m_start", "targetname", "t5_veh_jet_f4_gearup_lowres");
	jet2 = getstructent(name+"_r_start", "targetname", "t5_veh_jet_f4_gearup_lowres");
	jet3 = getstructent(name+"_l_start", "targetname", "t5_veh_jet_f4_gearup_lowres");
	
	jet1end = getstruct(name+"_m_end", "targetname");
	jet2end = getstruct(name+"_r_end", "targetname");
	jet3end = getstruct(name+"_l_end", "targetname");
	
	if (IsDefined(movedelay))
	{
		wait movedelay;
	}
	
	jet1 moveto(jet1end.origin, traveltime);
	jet1 rotateto(jet1end.angles, traveltime);
	playfxontag(level._effect["jet_contrail"], jet1, "tag_left_wingtip");
	playfxontag(level._effect["jet_contrail"], jet1, "tag_right_wingtip");
	jet1 playsound("veh_mig_flyby_evt1");
	
	jet2 moveto(jet2end.origin, traveltime);
	jet2 rotateto(jet2end.angles, traveltime);
	playfxontag(level._effect["jet_contrail"], jet2, "tag_left_wingtip");
	playfxontag(level._effect["jet_contrail"], jet2, "tag_right_wingtip");
	jet2 playsound("veh_mig_flyby_evt1");

	jet3 moveto(jet3end.origin, traveltime);
	jet3 rotateto(jet3end.angles, traveltime);
	playfxontag(level._effect["jet_contrail"], jet3, "tag_left_wingtip");
	playfxontag(level._effect["jet_contrail"], jet3, "tag_right_wingtip");
	jet3 playsound("veh_mig_flyby_evt1");

	if (isdefined(quake))
	{
		wait traveltime * 0.2;
		earthquake(0.1, traveltime*0.4, level.player.origin, 1000);
		wait traveltime * 0.8;
	}
	else
	{
		wait traveltime;
	}
	
	jet1 delete();
	jet2 delete();
	jet3 delete();
}

#using_animtree("generic_human");
fill_huey_with_script_models(kill_passengers_notify, pilots_only)
{
	if (!IsDefined(kill_passengers_notify))
	{
		kill_passengers_notify = "death";
	}
	
	tags = [];
	tags[0] = "tag_driver";				// pilot
	tags[1] = "tag_passenger";		// copilot
	
	if (!IsDefined(pilots_only))
	{
		tags[2] = "tag_guy1";		// seated on the left edge front
		tags[3] = "tag_passenger3";		// crouched on the left edge middle
		tags[4] = "tag_passenger4";		// seated on the right edge middle
		tags[5] = "tag_passenger5";		// seated on the right edge front
	}

	guys = [];

	for( i=0; i < tags.size; i++ )
	{
		tag = tags[i];
		if (i == 0 || i == 1)
		{
			guy = spawn("script_model",self gettagorigin(tag) );
			guy character\c_usa_jungmar_tanker::main();
			guys = array_add(guys, guy);
		}
		else
		{
			guy = spawn("script_model", self gettagorigin(tag));
			guy character\c_usa_jungmar_assault::main();
			guys = array_add(guys, guy);
		}
		if (i > 2)
		{
			//gun = spawn_a_model("t5_weapon_commando_world", guy gettagorigin("tag_weapon_right") );
			guy Attach("t5_weapon_commando_world", "tag_weapon_right");
			//guys = array_add(guys, guy);
		}
		guy UseAnimTree(#animtree);
		guy.animname = "hueyspot"+(i);
		guy linkto(self,tag, (0,0,0));
		self thread anim_loop_aligned(guy, "idle", tag, kill_passengers_notify);
	}
	self waittill_any ("death",kill_passengers_notify);
	
	for (i=0; i < guys.size; i++)
	{
		guys[i] StopAnimScripted();
		guys[i] Delete();
	}
}

		
	
line_please(myline,waittime, myflag, dontplay_flag)
{
	//level endon ("cut_current_dialogue");
	stringline = undefined;
	if (isdefined(myflag))
	{
		flag_wait (myflag);
	}
	
	if (IsDefined(dontplay_flag) && flag(dontplay_flag))
	{
		return;
	}
	
	if (isdefined(waittime))
	{
		wait waittime;
	}
	
	if (IsDefined(self._isspeaking))
	{
		self StopSounds();
		wait 0.5;
	}
	waittillframeend; // make sure to reset next flag if its done elsewhere before its checked
	
	if (flag("cut_current_dialogue"))
	{
		return;
	}
	
	if (IsDefined(dontplay_flag) && flag(dontplay_flag))
	{
		return;
	}
	

	/*
	if (!(IsAI(self))) // if it's the radio or the player
	{
 	 	self anim_generic(self,myline);
  }
	else
	{
	*/
 	 	self anim_generic( self, myline );
 	/*
	}
	*/
	//Assert( isdefined(stringline), "Stringline with animname "+self.animname+" and line "+myline+" couldn't be found");
 	self._isspeaking = undefined;
}

// -------------------------------------------------------------------------------------
// ----  DEBUG FUNCTIONS----
// -------------------------------------------------------------------------------------

debug_main()
{
	level thread debug_ai();
	//level thread monsterclip_debug();
	level.player thread damage_tracker();
	level waittill ("start_stopwatch");
	level thread onscreen_stopwatch();
	//level thread xattack_is_unlink();
}

damage_tracker()
{
	while(1)
	{
		self waittill ("damage", amount, inflictor, direction, point, typem, modelname, tagname);
		wait 0.05;
	}
}

monsterclip_debug()
{
	while(!IsDefined(level.woods))
	{
		wait 0.1;
	}
	while(1)
	{
		while( !level.player UseButtonPressed() && !level.player AttackButtonPressed() )
		{
			wait 0.2;
		}
		debug_monsterclips(level.woods, "radio_light");
		wait 5;
	}
}

