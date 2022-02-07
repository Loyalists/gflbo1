#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\_clientfaceanim;
#include maps\int_escape_util;



/* Event Guide - 

	Event 1 - Interrogation room
	Event 2 - CORRIDOR 1 � Numbers and Vorkuta themed
	Event 3 - MORGUE � VORKUTA Brainwash Room Flashback
	Event 4 - CORRIDOR 2 � Floating numbers
	Event 5 - CONFERENCE PROJECTOR ROOM � Friendly REZNOV Room
	Event 6 - CORRIDOR 3 � Rocket Launch Hallway
	Event 7 - INTELLIGENCE GATHERING ROOM � PLAYER second guessing room
	Event 8 - CORRIDOR 4 � HUDSON Encounter / REZNOV Revelation
	Event 9 - COMM ROOM � Black room BOAT revelation
*/
	
	

main()
{
	level.reset_clientdvars = ::reset_clientdvars;

	//This MUST be first for CreateFX!
	maps\int_escape_fx::main();
	
	//-- Starts
	//add_start( "event_1_jumpto", ::event1_jumpto, &"e1_int_chamber" );
	default_start( ::event1_start );
	add_start( "e2", ::event2_start, "event2" );
	add_start( "e3", ::event3_start, "event3" );
	add_start( "e4", ::event4_start, "event4" );
	add_start( "e5", ::event5_start, "event5" );
	add_start( "e6", ::event6_start, "event6" );
	add_start( "e7", ::event7_start, "event7" );
	add_start( "e8", ::event8_start, "event8" );
	add_start( "e9", ::event10_start, "event9" );
	add_start( "e11", ::event11_start, "event11" );
	add_start( "headtrack_test", ::event1_headtracking_test_start, "headtrack_test" );


	precache_everything();
	
	init_flags();
	
	maps\_load::main();
	SetSavedDvar( "compass", 0);	

	init_spawnfuncs();

	maps\int_escape_amb::main();
	maps\int_escape_anim::main();
	
	
	level thread init_level_variables();	
	
	OnPlayerConnect_Callback(::setup_neccessary_systems);
	
//	level thread set_temp_music();
	level thread maps\int_escape_amb::event_heart_beat("sedated");
	
}
set_temp_music()
{
	wait(3);
	//TEMP Music staet
	setmusicstate ("TEMP_INTRO");	
	
}

init_level_variables()
{
	level.player = get_players()[0];
	
	level.CLIENT_REZNOV_PROJECTOR_ON_INTRO = 64;
	level.CLIENT_REZNOV_PROJECTOR_ON_MOVIE = 65;
	level.CLIENT_REZNOV_PROJECTOR_ON_OUTRO = 66;
	level.CLIENT_REZNOV_MOVIE_SMALL 			 = 67;
	level.CLIENT_REZNOV_PROJETOR_OFF  		 = 68;
	level.CLIENT_REZNOV_ROOM_INIT  				 = 69;
	level.CLIENT_MORGUE_DOOR_STATIC				 = 70;
	level.CLIENT_MORGUE_DOOR_TWEAK  			 = 71;
	level.CLIENT_MORGUE_DOOR_LEFT_FLASHES  = 72;
	level.CLIENT_MORGUE_DOOR_RIGHT_FLASHES = 73;
	
	level.CLIENT_RUSALKA_LETTERS_BINK = 200;
	level.CLIENT_RUSALKA_LETTERS_BINK_FADE = 201;
	
}


init_flags()
{
	
	// triggered flag_init("approaching_reznov_room");
	// triggered flag_init("approaching_rocket_hall");
	// triggered flag_init("in_conf_room");
	// triggered flag_init("at_rocket_hall_trig2");
	// triggered flag_init("at_rocket_hall_trig3");
	// triggered flag flag_init("proceed_to_target");
	
	flag_init("no_limp");
	flag_init("dont_show_3d_marker");
	flag_init("bink_monitors_hold");
	
		// event1
	flag_init("e1_punch_done");
	flag_init("player_realeased_anims_go");
	flag_init("start_hudson_anim");
	flag_init("out_of_int_chair");
	flag_init("release_untying");
	flag_init("mason_punch_go");
	
		// event 2
	flag_init("firsthall_flashback1_trig");
	flag_init("through_cor1_doors");
	flag_init("cor1_doors_go");
	flag_init("e2_cart_fall_go");
	flag_init("e2_cart_stumble_done");
	
		// event 3
	flag_init("in_brainwash_room");
	flag_init("start_flashrooms");
	flag_init("looking_in_morgue");
	flag_init("morgue_dialogue_done");
	flag_init("through_morgue_doors");
	flag_init("morgue_entrance_go");
	flag_init("start_morgue_dialogue");
	flag_init("e3_flashroom_go");
	flag_init("wait_a_few");
	flag_init("open_morgue_doors");	
		// event 4

	flag_init("e4_wall_stumble_go");
	flag_init("e4_wall_stumble_done");
	flag_init("first_numbers_hit_mason");
	
		// event 5 
	flag_init("reznov_outro_go");
	flag_init("reznov_outro_done");
	
		// event 6 
	flag_init("kennedy_flashback_done");
	flag_init("kennedy_flashback_go");
	
	flag_init("rocket_out_of_rumble_range");
	flag_init("j_fitz_said");
	flag_init("do_light_rumble");
	flag_init("do_heavy_rumble");
	
		// event 8
	flag_init("e8_hudson_grabbed_player");
	flag_init("e8_brainwash_go");
	flag_init("e8_reznov_brainwash_done");
	flag_init("playing_dks");
	flag_init("start_loading_reznov_movie");
	flag_init("reznov_reveal_go");
	flag_init("reznov_reveal_vo_done");
	
	flag_init("hudson_explplains_2_go");
	flag_init("intro_flashback1_go");
	flag_init("intro_flashback2_go");
	flag_init("intro_flashback3_go");
	flag_init("intro_flashback4_go");

		// event 9 
	
	flag_init("blackroom_go");
	flag_init("starting_boat_dialogue");
	flag_init("scratch_zoom_done");
	flag_init("blackroom_vo_done");
	flag_init("waco_paco_full_go");
	flag_init("rein_distant_numbers_in");
	flag_init("you_dont_know_go");
	flag_init("short_waco_paco_go");
	flag_init("short_waco_paco_done");
	flag_init("zoomed_in_to_table");
}

init_spawnfuncs()
{
	array_thread( getentarray("hudson", "targetname"),      ::add_spawn_function,  ::init_hudson );
	array_thread( getentarray("e8_hudson", "targetname"),   ::add_spawn_function,  ::init_hudson );
	array_thread( getentarray("weaver", "targetname"), 		  ::add_spawn_function,  ::init_weaver );
}

init_hudson()
{
	level.hudson = self;
	level.hudson thread magic_bullet_shield();
	level.streamHintEnt = CreateStreamerHint( level.hudson.origin + (0,0,30), 1 );
}

init_weaver()
{
	level.weaver = self;
	self thread magic_bullet_shield();
}

setup_delete_frontend_items()
{
	GetEnt("int_stool", "targetname") Delete();
}

setup_neccessary_systems()
{
	wait_for_first_player();
	
	init_level_variables();
	
	get_players()[0] TakeAllWeapons();
	get_players()[0] DisableWeaponFire();
	get_players()[0] AllowSprint(false);
	
	level thread switch_interrogation_hands("interrogation_hands_nosway_sp");
	
	setup_delete_frontend_items();
	
	level thread hud_hide();
	level thread larry_the_limper_tweaktech();
	level thread setup_prop_fx();
	level thread door_clip_attach();
	level thread security_cameras_setup();
	
	get_players()[0] thread larry_the_limper();
	
	level thread setup_bink_monitor_randomize();
}

setup_bink_monitor_randomize()
{
	monitor1 = GetEnt( "monitor_01", "targetname" );
	monitor2 = GetEnt( "monitor_02", "targetname" );
	monitor3 = GetEnt( "monitor_03", "targetname" );
	monitor4 = GetEnt( "monitor_04", "targetname" );
	monitor5 = GetEnt( "monitor_05", "targetname" );
	monitor6 = GetEnt( "monitor_06", "targetname" );
	monitor7 = GetEnt( "monitor_07", "targetname" );
	monitor8 = GetEnt( "monitor_08", "targetname" );
	monitor9 = GetEnt( "monitor_09", "targetname" );
	
	nums = [];
	nums = array_add(nums, 5);
	nums = array_add(nums, 9);
	nums = array_add(nums, 25);
	while (1)
	{
		off_screens = 0;
		monitor1 setclientflagasval(0);
		monitor2 setclientflagasval(1);
		monitor3 setclientflagasval(2);
		monitor4 setclientflagasval(0);
		monitor5 setclientflagasval(1);
		monitor6 setclientflagasval(2);
		monitor7 setclientflagasval(2);
		monitor8 setclientflagasval(0);
		monitor9 setclientflagasval(1);
			
		
		for (i=1; i < 10; i++)
		{
			toss = RandomInt(100);
			{
				if (toss < 15 && off_screens < 2 )
				{
					num = nums[RandomInt(nums.size)];
					if (off_screens ==0)
					{
						monitor4 setclientflagasval(num);
					}
					else
					{
						monitor5 setclientflagasval(num);
					}
					off_screens++;
				}
			}
		}
		

		wait RandomFloat(10);
	}
}


event1_start()
{
	level thread event_objectives(1);
	level event1();

	
}

event1_headtracking_test_start()
{
	wait_for_first_player();

	thread maps\int_escape_anim::e1_weaver_idle();
	thread maps\int_escape_anim::e1_straps();

	obj_3d(false);

	get_players()[0] thread maps\int_escape_anim::setup_idle_animation();
	
	level.headtracking_mason = simple_spawn_single("headtracking_mason");

	align_struct = getstruct("fakeplayer_head_align_struct", "targetname");
	level.headtracking_mason.animname = "generic";
	align_struct thread anim_loop_aligned(level.headtracking_mason, "fake_player_chair_loop");

	event1_headtracking_player_check();
	
}

event1_headtracking_player_check()
{
	spot = Spawn_a_model("p_glo_cuban_cigar01", (0,0,0) );
	lookspot = Spawn_a_model("tag_origin", (0,0,0) );
	
	mason = level.headtracking_mason;
	
	wait 1;
	
	player_ba = get_players()[0].angles ;
	mason_ba =  mason.angles ;
	
	//player_ba = AnglesToForward( player_ba );
	//mason_ba = AnglesToForward( mason_ba ) ;
	
	mason lookatentity(lookspot );
	mason relax_ik_headtracking_limits();
	
	while(1)
	{
		ang = get_players()[0] GetPlayerAngles();
		vec = AnglesToForward(ang);
		nvec = VectorNormalize(vec);
		spot.origin =  get_players()[0] GetEye()   + ( nvec*18) + (0,0,-55) ;
		
		offset = ang - player_ba;
		offset = offset*2;
		mason_vec = AnglesToForward(mason_ba + offset);
		mason_nvec = VectorNormalize(mason_vec); 
		lookspot.origin = mason.origin + (mason_nvec*200) + (0,0,55);
		
		wait 0.05;
	}
}

reset_clientdvars()
{
	self SetClientDvars( "compass", "0",
		"hud_showStance", "0",
		"cg_thirdPerson", "0",
		"cg_fov", "65",
		"cg_cursorHints","4",
		"cg_thirdPersonAngle", "0",
		"hud_showobjectives","1",
		"ammoCounterHide", "0",
		"miniscoreboardhide", "0",
		"ui_hud_hardcore", "0",
		"credits_active", "0",
		"hud_missionFailed", "0",
		"cg_cameraUseTagCamera", "1",
		"cg_drawCrosshair", "1",
		"r_heroLightScale", "1 1 1",
		"r_fog_disable", "0",
		"r_dof_tweak", "0",
		"player_sprintUnlimited", "0",
		"r_bloomTweaks", "0",
		"r_exposureTweak", "0",
		"cg_aggressiveCullRadius", "0",
		"sm_sunSampleSizeNear", "0.25",
		"player_viewratescale", 0,
		"cg_drawFriendlyNames", 0
		);

	SetSavedDvar("g_speed", 20);
	SetSavedDvar( "sm_sunSampleSizeNear", "0.25" );
}

event1() 
{
	wait_for_first_player();
	
	get_players()[0] AllowSprint(false);
	get_players()[0] AllowLean( false );
	get_players()[0] AllowJump(false);
	
	if (IsDefined(level.streamHintEnt))
	{
		//level.streamHintEnt Delete();
	}

	thread maps\int_escape_anim::e1_weaver_idle();
	thread maps\int_escape_anim::e1_straps();

	obj_3d(false);

	get_players()[0] thread maps\int_escape_anim::setup_idle_animation();
	
	level thread event1_dialogue();

	level thread start_int_screens();

	exploder(100);
	GetEnt("frontend_cart_clip", "targetname") Delete();
	

	event1_player_release_vignette();
	
	level notify ("punch_into_screens");
	
	flag_wait("e1_punch_done");
	
	thread event2();
	
	level.introscreen_dontfreezcontrols = 1;		
	level.introscreen_shader = "none";
	level.introstring_text_color = (1,1,1);
	maps\_introscreen::introscreen_redact_delay( &"INT_ESCAPE_INTROSCREEN_1", &"INT_ESCAPE_INTROSCREEN_2", &"INT_ESCAPE_INTROSCREEN_3", &"INT_ESCAPE_INTROSCREEN_4", undefined,  0.6, 7.5, 4, 0, 0.5 );
}

start_int_screens()
{
	wait 1;
	Start3DCinematic("int_screens");
}

event1_player_release_vignette()
{
	door = GetEnt("int_room_door", "targetname");
	door.animname = "int_door";
	getstruct("player_release_align_struct", "targetname") origin_firstframe_jnt_aligned(door, "int_door_open");
	
	simple_spawn("hudson");
	flag_wait( "starting final intro screen fadeout" );

	
	flag_wait( "start_hudson_anim" );


	//SetSavedDvar("r_streamFreezeState",1);
	level thread maps\int_escape_anim::e1_player_released();
	flag_wait("release_untying");
	flag_set("mason_punch_go");
	level notify ("out_of_chair_vision");
	SetSavedDvar("r_streamFreezeState",0);
}
	
	

event2_start()
{
	tp_to_start("e2");
	
	level thread event_objectives(2);
	GetEnt("int_room_door", "targetname") Delete();
	flag_set("out_of_int_chair");
	VisionSetNaked("INT_ESC", 0);
	
	event2();
}

event2()
{
	level create_fullscreen_cinematic_hud(0);
	level.fullscreen_cin_hud.alpha = 0;
	
	level thread maps\int_escape_anim::e1_wall_stumble();
	level thread event2_flashbacks();
	level thread event2_dialogue();
	level thread event2_nearing_morgue();
	
	flag_wait("out_of_int_chair");
	level._player_speed_modifier = 0.65;
	
	obj_3d(true);
	//thread do_fp_wrist_grab();
	
	trigger_wait("int_escape_obj1_trig1");
	stop3DCinematic();
	
	event3();

}

event3_start()
{
	tp_to_start("e3");
	level thread create_fullscreen_cinematic_hud(1);
	level notify ("first_junction");
	
	level thread event_objectives(3);
	level thread event2_nearing_morgue();
	
	thread switch_interrogation_hands("interrogation_hands_nosway_sp");
	
	counter = 0;
	
	flag_set("cor1_doors_go");
	
	event3();
}
	
event3()
{
	
	event5_init_movieplaying_surfaces();
	
	doors = GetEntArray("morgue_entrance_door_doubles", "targetname");
	doors[0] Hide();
	doors[1] Hide();
	
	level thread event3_doors();
	level thread event3_dialogue();
	
	trigger_wait("morgue_entrance_door_trig");
	level notify ("entering_morgue");
	wait 0.5;
	level.streamHintEnt = createStreamerHint( (1114, -1694, 86), 1 );

	flag_wait("start_flashrooms");
	
	obj_3d(false);
	SetSavedDvar("g_speed", 90);
	flag_set("no_limp");
	get_players()[0] DisableWeapons();
	get_players()[0] AllowCrouch(false);
	get_players()[0] AllowProne(false);
	
	event3_flashrooms();
	flag_wait("morgue_dialogue_done");
	get_players()[0] SetClientDvar("player_viewratescale", 25);
	event3_flashrooms(1);
	get_players()[0] SetClientDvar("player_viewratescale", 0);

	flag_clear("no_limp");
	get_players()[0] AllowCrouch(true);
	get_players()[0] AllowProne(true);
	
	SetSavedDvar("g_speed", 110);

	guys = GetAIArray();
	for (i=0; i < guys.size; i++)
	{
		guys[i] Delete();
	}

	level notify ("brainwash_sequence_done");
	level thread maps\int_escape_amb::event_heart_beat("sedated");
	level.streamHintEnt Delete();
	obj_3d(true);
	
	event4();
}

event4_start()
{
	tp_to_start("e4");
	level thread event_objectives(4);
	level create_fullscreen_cinematic_hud(1);
	
	event4();
}

event4()
{	
	level thread maps\int_escape_anim::e4_wall_stumble();
	//array_thread(GetEntArray("floating_number_trigs", "script_noteworthy"), ::notify_on_notify, "trigger", level, "release_a_floater");

show_viewmodel();

	//event4_float_numbers();
	event4_floating_numbers();

	event5();
}

event4_floating_numbers()
{
	trigger_wait("int_escape_obj4_trig1");
	for (i=1; i < 4; i++)
	{
		spots = getstructarray("morgue_exit_numspot_"+i, "targetname");
		for (j=0; j < spots.size; j++)
		{
			number = spawn_a_model( "tag_origin", spots[j].origin);
			PlayFXOnTag(level._effect["floating_number"], number, "tag_origin");
			playsoundatposition ("evt_numbers_small", spots[j].origin);
			number thread event4_numbers_close_in();
		}
		wait RandomFloatRange(0.5,1);
	}
	
	flag_wait("e4_wall_stumble_done");
	for (i=1; i < 3; i++)
	{
		spots = getstructarray("in_hall_numspot_"+i, "targetname");
		for (j=0; j < spots.size; j++)
		{
			number = spawn_a_model( "tag_origin", spots[j].origin);
			PlayFXOnTag(level._effect["floating_number"], number, "tag_origin");
			playsoundatposition ("evt_numbers_small", spots[j].origin);
			number thread event4_numbers_close_in();
		}
		wait RandomFloatRange(0.5,1.5);
	}

	trigger_wait("int_escape_obj4_trig2");
	spots = getstructarray("in_hall_numspot_3", "targetname");
	for (j=0; j < spots.size; j++)
	{
		number = spawn_a_model( "tag_origin", spots[j].origin);
		PlayFXOnTag(level._effect["floating_number"], number, "tag_origin");
		playsoundatposition ("evt_numbers_small", spots[j].origin);
		number thread event4_numbers_close_in();
	}
	
	trigger_wait("e4_hall_numtrig_4");
	for (i=4; i < 6; i++)
	{
		spots = getstructarray("in_hall_numspot_"+i, "targetname");
		for (j=0; j < spots.size; j++)
		{
			number = spawn_a_model( "tag_origin", spots[j].origin);
			PlayFXOnTag(level._effect["floating_number"], number, "tag_origin");
			playsoundatposition ("evt_numbers_small", spots[j].origin);
			number thread event4_numbers_close_in();
		}
	}
}
		
	

event4_float_numbers()
{
	spots = getstructarray("floating_number_startspots", "script_noteworthy");
	for (i=0; i < spots.size; i++)
	{
		level waittill ("release_a_floater");
		number = getstructent("floating_number_startspot"+(i+1), "targetname", "tag_origin");
		PlayFXOnTag(level._effect["floating_number"], number, "tag_origin");
		playsoundatposition ("evt_numbers_large", spots[i].origin);
		number thread event4_floating_number_spline(spots[i]);
		number thread event4_numbers_close_in();
	}
}
	

event4_floating_number_spline(current_spot)
{
	self endon ("move_close_to_player");
	while(IsDefined(current_spot.target))
	{
		spot = getstruct(current_spot.target, "targetname");
		Dist = Distance(current_spot.origin, spot.origin);
		movetime = dist / 70;
		if (movetime < 0.5)
		{
			movetime = 0.5;
		}
		self moveto(spot.origin, movetime);
		self waittill ("movedone");
		current_spot = spot;
	}
}

event4_numbers_close_in()
{
	speed_dividend = RandomIntRange(10000,25000);
	//speed_dividend = 20000;
	while( DistanceSquared(self.origin, get_players()[0].origin+(0,0,50) ) > (30*30) )
	{
		movetime = DistanceSquared(self.origin, get_players()[0].origin) / speed_dividend;
		self moveto(get_players()[0].origin + (0,0,50), movetime);
		wait 0.1;
	}
	
	flag_set("first_numbers_hit_mason");
	PlayFX(level._effect["floating_number_fade"], self.origin);
	playsoundatposition ("evt_numbers_large_flux", self.origin);
	self Delete();
} 
	

event5_start()
{
	wait_for_all_players();
	level thread create_fullscreen_cinematic_hud(1);
	tp_to_start("e5");
	level thread event_objectives(5);
	
	level notify ("punch_into_screens");
	VisionSetNaked("INT_ESC", 0);
	
	wait 1;
	event5_init_movieplaying_surfaces();
	wait 1;
	event5();
}

event5()
{
	level.fullscreen_cin_hud.alpha = 0;
	
	thread event5_movie_control();
	thread event5_dialogue();
	thread event5_closedoors();
	
	flag_wait("reznov_outro_done");
	door = GetEnt("reznov_room_exit", "targetname");
	level.e5_door = door;
	door RotateYaw(-33, 12, 6, 6);
	obj_3d(true);
	
	trigger_wait("e5_open_rezroom_door_trig", "targetname");
	door playsound ("evt_proj_door_open");
	door RotateTo( (0,164,0) , 0.9, .3, .6);
	
	event6();
}

event5_closedoors()
{
	door_l = GetEnt("reznov_room_left_door", "targetname");
	door_r = GetEnt("reznov_room_right_door", "targetname");
	
	trigger_wait("e5_close_doors_trig");
	playsoundatposition ("evt_proj_door_close", door_l.origin);
	//TUEY set music state to PROJECTOR_ROOM
	playsoundatposition ("num_06_s", (0,0,0));
	setmusicstate ("PROJECTOR_ROOM");
	
	door_l RotateTo( (0,180,0), 0.5  );
	door_r RotateTo( (0,180,0), 0.5 );
}
	

event5_init_movieplaying_surfaces()
{
	surfaces = [];
	surfaces[0] = GetEnt("projector_screen", "targetname");
	surfaces = array_combine(surfaces, GetEntArray("smaller_movie_players", "script_noteworthy") );
	for (i=0; i < surfaces.size; i++)
	{
		surfaces[i] setclientflagasval(level.CLIENT_REZNOV_ROOM_INIT);
	}
}
		
	

event5_movie_control()
{
	projector_screen = GetEnt("projector_screen", "targetname");
	projector_screen setclientflagasval(level.CLIENT_REZNOV_PROJECTOR_ON_INTRO);

	if ( level.ps3 )
	{
		start3dcinematic("int_reznov_room", true , false);
	}
	else
	{
		start3dcinematic("int_reznov_room", true , false);
	}
	
	trigger_wait("entering_reznov_room", "targetname");
	obj_3d(false);
	
	level thread event5_small_movies_go();
	
	projector_screen setclientflagasval(level.CLIENT_REZNOV_PROJECTOR_ON_MOVIE);
	flag_wait("reznov_outro_go");
	projector_screen setclientflagasval(level.CLIENT_REZNOV_PROJECTOR_ON_OUTRO);

	flag_wait("kennedy_flashback_go");
	projector_screen setclientflagasval(level.CLIENT_REZNOV_PROJETOR_OFF);
}

event5_small_movies_go()
{
	screens = GetEntArray("smaller_movie_players", "script_noteworthy");
	screens = shuffle_array(screens);
	wait 2;
	
	for (i=0; i < screens.size; i++)
	{
		wait RandomFloat(0.5);
		screens[i] setclientflagasval(level.CLIENT_REZNOV_MOVIE_SMALL);
	}
	
	flag_wait("reznov_outro_go");
	level thread maps\int_escape_amb::event_heart_beat("sedated");
	
	for (i=0; i < screens.size; i++)
	{
		screens[i] setclientflagasval(level.CLIENT_REZNOV_PROJECTOR_ON_OUTRO);
	}

	flag_wait("reznov_outro_done");
	wait 1;

	
	flag_wait("kennedy_flashback_go");
	for (i=0; i < screens.size; i++)
	{
		screens[i] setclientflagasval(level.CLIENT_REZNOV_PROJETOR_OFF);
	}
}

event5_dialogue()
{
	trigger_wait("entering_reznov_room", "targetname");
	get_players()[0] line_please ("were_all_bros", 0, "approaching_reznov_room"); //In Vorkuta, we are all brothers.
	
	level thread maps\int_escape_amb::event_heart_beat("stressed");
	
	get_players()[0] line_please ("sure_can_trust", 0.5,undefined, "approaching_rocket_hall"); //Are you sure you can trust this American?
	get_players()[0] line_please ("with_my_life", 0.5, undefined,"approaching_rocket_hall"); //With my life...
	get_players()[0] line_please ("not_so_diff", undefined, undefined, "approaching_rocket_hall"); //He and us, are not so different... We are all soldiers without an army.
	get_players()[0] line_please ("forgotton_abandoned", 0.5, undefined, "approaching_rocket_hall"); //Betrayed.  Forgotten.  Abandoned.
	get_players()[0] line_please ("you_will_survive", 0, undefined, "approaching_rocket_hall"); //You will survive... You have to...
	flag_set("reznov_outro_go");
	get_players()[0] line_please ("were_bros_mason", 0.5, undefined, "approaching_rocket_hall"); //I know it all too well... We are brothers Mason... We are the same.
	flag_set("reznov_outro_done");
}

event6_start()
{
	tp_to_start("e6");
	level thread event_objectives(6);
	door = GetEnt("reznov_room_exit", "targetname");
	door RotateYaw(-105, 4, 0, 4);
	door playsound ("evt_proj_door_open");
	level thread create_fullscreen_cinematic_hud(1);
	
	VisionSetNaked("INT_ESC", 0);
	
	event6();
}

event6()
{
	GetEnt("rocketdoor1", "targetname") Hide();
	GetEnt("rocketdoor2", "targetname") Hide();
	
	
	level thread event6_dialogue();
	
	trigger_wait("e6_start_roof");
	level._player_speed_modifier = 0.55;
	
	stop3dcinematic();

	level thread event6_dissolve_roof();
	level thread event6_open_rocket_gantry();
	level thread event6_rocket_clamps();
	level thread event6_rocket_takeoff();
	
	level event6_limo_warps();

	GetEnt("rocketdoor1", "targetname") Show();
	GetEnt("rocketdoor2", "targetname") Show();
	
	event7();
}

event6_dialogue()
{
	level thread event6_russian_dialogue();
	
	trigger_wait("int_escape_obj6_trig1");
	
	playsoundatposition ("num_25", (0,0,0));	
	get_players()[0] line_please ("j_fitz"); //Kennedy...John...Fitzgerald. I'm told you are the best we have. Anywhere.

	
	wait 0.5;
	flag_wait("in_rocket_hall");
	flag_set("kennedy_flashback_go");

	get_players()[0] line_please ("when_i_kill_him", 0, "kennedy_flashback_done"); //When do I kill him?

	get_players()[0] line_please ("get_hell_out", 2); //Okay. Time we got the hell out of here.
	get_players()[0] line_please ("not_yet..."); //Not yet...
	get_players()[0] line_please ("going_after_drago"); //We're going after Dragovich.
	wait 2;
	flag_set("j_fitz_said");
	
	get_players()[0] line_please ("noones_gettin_out", 0 , "at_rocket_hall_trig3"); //No one's getting out.
	get_players()[0] line_please ("satisfied", 1); //Satisfied, Mason?
	get_players()[0] line_please ("not_till_body", 1); //Not yet... Not until I see the body.
}

event6_russian_dialogue()
{
	flag_wait("in_rocket_hall");
	extra = Spawn("script_origin", get_players()[0] GetEye() );
	extra LinkTo(get_players()[0]);
	extra.animname = "generic";
	
	
	wait(1.5);
	extra anim_generic(extra,"engines_on"); //(Translated) Engines On. 5, 4... 3...
	flag_wait("kennedy_flashback_done");
	extra anim_generic (extra, "guidance_interval"); //(Translated) 15 seconds, guidance internal, 13, 12, 11, 10, 9, 8, ignition sequence start.
	extra anim_generic(extra, "engines_running"); //(Translated) ...2, 1, all engines running.   Launch commit.
	extra anim_generic(extra, "have_lift_off"); //(Translated) Lift-off. We have lift-off.
}

event6_dissolve_roof()
{
	SetSavedDvar( "sm_sunSampleSizeNear", "1.1" );
	playsoundatposition ("evt_tiles", (0,0,0));
	level notify ("escape_ceiling_start");
	exploder(400);
	
	wait(2);
	level thread maps\int_escape_amb::event_heart_beat("panicked");
	
}

event6_rocket_rumble()
{
	counter = 0;
	
	while(counter < 50)
	{
		if (flag("do_light_rumble"))
		{
			counter++;
			get_players()[0] PlayRumbleOnEntity("pistol_fire");
			wait 0.25;
		}
		else if ( flag("do_heavy_rumble") )
		{
			get_players()[0] PlayRumbleOnEntity("damage_light");
			wait 0.1;
		}

	}
	flag_set("rocket_out_of_rumble_range");
}

event6_open_rocket_gantry()
{

	gantry_1 = getent( "gantry_1", "targetname" );
	gantry_2 = getent( "gantry_2", "targetname" );
	gantry_1_arm = getent( "gantry_1_arm", "targetname" );
	gantry_2_arm = getent( "gantry_2_arm", "targetname" );
	stabalizer = GetEnt("rocket_stabilizer_big", "targetname");

	total_open_time = 35;
	total_open_angle = 35;
	
	//gantry_1 playsound( "evt_flashpoint_gantry_2dflexf" );
	gantry_1 thread gantry_audio();

	gantry_1 RotateRoll( total_open_angle*-1, total_open_time );
	gantry_1 moveto(gantry_1.origin+(0,1000,0), total_open_time);
	gantry_1_arm rotatepitch( total_open_angle, total_open_time );
	
	gantry_2 RotateRoll( total_open_angle, total_open_time );
	gantry_2 moveto(gantry_2.origin+(0,-1000,0), total_open_time);
	gantry_2_arm rotatepitch( total_open_angle, total_open_time );

	stabalizer moveto(stabalizer.origin+(1000,0,0), total_open_time);

}

event6_rocket_takeoff()
{
	wait 2;
	rocket_origin = getstruct("rocket_origin", "targetname").origin;
	Earthquake(0.2, 5, rocket_origin, 5000);
	rocket_top = GetEnt("rocket_top_piece", "targetname");
	rocket_decal = GetEntArray("stationary_rocket_top", "targetname");
	for (i=0; i < rocket_decal.size; i++)
	{
		rocket_decal[i] LinkTo(rocket_top);
	}
	
	rocket_bottom = GetEnt("rocket_bottom_piece", "targetname");
	rocket_bottom LinkTo(rocket_top);
	
	flag_wait("kennedy_flashback_done");
	Earthquake(0.1, 2, rocket_origin, 5000);

	wait 2;
	
	Earthquake(0.3, 2, rocket_origin, 5000);
	
	flag_set("do_light_rumble");
	level thread event6_rocket_rumble();
	rocket_top playsound("evt_flashpoint_launch3");	
	wait 1;
	
	exploder(500);
	
	
	spot = spawn_a_model("tag_origin", rocket_bottom.origin+(0,0,-700), rocket_bottom.angles);
	PlayFXOnTag(level._effect["rocket_trail"], spot, "tag_origin");
	spot LinkTo(rocket_top);
	rocket_top moveto(rocket_top.origin + (0,0,30000), 35, 35);
	
	Earthquake(0.4, 1.5, rocket_origin, 5000);
	wait 1;
	Earthquake(0.5, 2, rocket_origin, 5000);
	flag_set("do_heavy_rumble");
	flag_clear("do_light_rumble");
	wait 1.5;
	Earthquake(0.6, 2, rocket_origin, 5000);
	wait 2;
	Earthquake(0.3, 15, rocket_origin, 5000);
	flag_set("do_light_rumble");
	flag_clear("do_heavy_rumble");
	//spot moveto(spot.origin + (0,0,30000), 35, 35);

}

gantry_audio()
{
	self playloopsound( "evt_flashpoint_gantry_2dloopf" , .1 );
	self playsound( "evt_flashpoint_gantry_3dloop" );
	wait 18;
	self playsound( "evt_flashpoint_gantry_2dflexf" );
	self stoploopsound( 17 );
}

event6_rocket_clamps()
{
	clamp1 = getent( "rocket_clamp_1", "targetname" );
	clamp2 = getent( "rocket_clamp_2", "targetname" );	
	clamp3 = getent( "rocket_clamp_3", "targetname" );	
	clamp4 = getent( "rocket_clamp_4", "targetname" );	

	clamp1 rotateroll( -50, 10.0, 0.1, 0.3 );
	clamp2 rotateroll( -50, 10.0, 0.1, 0.3 );
	clamp3 rotateroll( -50, 10.0, 0.1, 0.3 );
	clamp4 rotateroll( -50, 10.0, 0.1, 0.3 );
}

event6_limo_warps()
{
	time_between_warps = 0.5;

	flag_wait("in_rocket_hall");
	SetSavedDvar("r_streamFreezeState",1);
	level.fullscreen_cin_hud.alpha = 0;
	wait 1;
	thread play_movie("int_kennedy_pentagon_flash", false, false, "jfk_movie_play", undefined, "jfk_movie_done", 0.1);
	start_movie_scene();
	add_scene_line(&"int_escape_vox_pen1_s01_039A_kenn_m", .1, 5);		//We are in grave danger from the communists. Our very way of life is at risk.
	add_scene_line(&"int_escape_vox_pen1_s01_040A_kenn_m", 7.5, 2);		//Dragovich.
	wait 1;
	flag_wait("kennedy_flashback_go");


	delaythread(1, ::stop_exploder,400);
		
	level.fullscreen_cin_hud.alpha = 1;
	level thread maps\int_escape_amb::event_heart_beat("none", 0, 1);
	level notify ("jfk_movie_play");
	thread switch_interrogation_hands("interrogation_hands_sp");
	

	level waittill ("jfk_movie_done");
	SetSavedDvar("r_streamFreezeState",0);

	level thread maps\int_escape_amb::event_heart_beat("panicked");

	flag_set("kennedy_flashback_done");
	
	trig = GetEnt("limo_warptrig_3", "script_noteworthy");
	trig thread notify_delay("trigger", 7);
	
	flag_wait("j_fitz_said");
	level thread maps\int_escape_amb::event_heart_beat("none", 0, 1);
	int_esc_play_movie("int_flaming_limo", false, false);
	get_players()[0] player_warpto(getstruct("limo_warpbackspot_2", "targetname") );

	SetSavedDvar( "sm_sunSampleSizeNear", "0.25" );
	
	level thread maps\int_escape_amb::event_heart_beat("sedated");
}

event7_start()
{
	tp_to_start("e7");
	level thread event_objectives(7);
	event7();
}

event7()
{
	level thread event7_dialogue();
	event8();
}

event7_dialogue()
{
	//get_players()[0] line_please ("whyd_u_go_rogue", 0, "in_conf_room"); //Mason, for the last time, why did you go rogue? Why ignore the recall to Da Nang? Why did you go to Rebirth island?
	//playsoundatposition ("num_15", (0,0,0));	
	level thread event7_number_loop_start();
	get_players()[0] line_please ("had_kill_steiner", 0, "in_conf_room"); //Steiner was there. We had to kill Steiner.

	get_players()[0] line_please ("we_viktor"); //We? Viktor Reznov?
	get_players()[0] line_please ("need_closure");  //We wanted the same thing. The same.

	level notify ("hudson_control_vision", 5);

	get_players()[0] line_please ("hell_he_doing", 0, undefined, "e8_hudson_grabbed_player"); 		//What the Hell is he doing?
	get_players()[0] line_please ("killing_everyone", 0, undefined, "e8_hudson_grabbed_player");  //Killing everyone between him and Steiner.
}

event7_number_loop_start()
{

	number_sound_ent = spawn( "script_origin", (0,0,0) );
	//	number_sound_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	number_sound_ent playloopsound ("num_15_loop");

	level waittill ("stop_numbers_sound");
	level notify ("numbers_stopped_early");	
	
	if ( isdefined (number_sound_ent))
	{
		number_sound_ent StopLoopSound( 0.5 );
		wait .5;
	}
	if ( isdefined (number_sound_ent))
	{
		number_sound_ent delete();	
	}
}
event7_number_loop_end_timer()
{	
	level endon ("numbers_stopped_early");
	
	wait (42);
	level notify ("stop_numbers_sound");
}	
event8_start()
{
	tp_to_start("e8");
	level thread create_fullscreen_cinematic_hud(1);
	
	level thread event_objectives(7);
	
	clientnotify ("bring_in_brainwash_fov");
	
	event8();
}

event8_get_player_mover()
{
	align_struct = getstruct("brainwash_align_struct", "targetname");

	fake_player_hands_1 = spawn_anim_model( "player" );
	fake_player_hands_1.animname = "player";
	fake_player_hands_1 UseAnimTree( level.scr_animtree["player"] );
	align_struct anim_first_frame(fake_player_hands_1, "reznov_brainw_1");
	fake_player_hands_1 Hide();
	level.fake_player_hands = fake_player_hands_1;
	
	fake_player_hands_2 = spawn_anim_model( "player" );
	fake_player_hands_2.animname = "player";
	fake_player_hands_2 UseAnimTree( level.scr_animtree["player"] );
	align_struct anim_first_frame(fake_player_hands_2, "reznov_brainw_1");
	fake_player_hands_2 Hide();

	startspot = getstruct("player_overbed_spot", "targetname");
	fake_player_hands_2.origin = startspot.origin;
	
	return fake_player_hands_2;
}

event8()
{
	level thread event8_dialogue();
		
	level thread maps\int_escape_anim::e9_short_waco_paco();
	
	get_players()[0] AllowCrouch(false);
	get_players()[0] AllowProne(false);
		
	simple_spawn("brainwash_reznov");
		
	trigger_wait("hudson_own_player_trig");
	obj_3d(false);	
	flag_set("dont_show_3d_marker");
	
	event8_hudson_own_player();
	
	flag_wait("start_loading_reznov_movie");
	event8_do_reznov_reveal_video();
	flag_set("no_limp");
	thread player_speed_set(80,0.1);
	hide_viewmodel();
	//event8_to_com_room();
	flag_wait("blackroom_go");
	
	event10();
	
}

event8_to_com_room()
{
	node = GetNode("hudson_e9_node", "targetname");
	level.hudson set_run_anim("patrol_walk");
	level.hudson SetGoalNode(node);
	
	level.hudson PushPlayer(true);
}

event8_dialogue()
{
	flag_wait("e8_hudson_grabbed_player");

/*
	get_players()[0] line_please ("defector_survived", 0, "reznov_reveal_go"); //You think the defector survived the attack?!
	get_players()[0] line_please ("1_tuff_sob"); //If he did, then he's one tough son of a bitch!
	get_players()[0] line_please ("mason?"); //Mason?
	get_players()[0] line_please ("reznov"); //Reznov.
	get_players()[0] line_please ("never_see_u_alive"); //Never thought I'd see you alive...in_conf_room
	get_players()[0] line_please ("real_defector_nova"); //He was never in Vietnam.  The real  defector with the Nova 6 dossier died during the attack on the MAC-V.
  get_players()[0] line_please ("never_in_tunnels");			 //He was never in the rat tunnels.
	get_players()[0] line_please ("fucks_wrong_wit_u"); //What the fuck's wrong with you?
	get_players()[0] line_please ("kreavchenko_here"); //Kravchenko is here!
	get_players()[0] line_please ("cant_let_him_slip"); //This way! We cannot let him slip through our grasp!
	get_players()[0] line_please ("fuck_u_doin"); //Mason?!  What the fuck are you doing?!! We gotta get these guys out.
	get_players()[0] line_please ("too_close_to_goal"); //We are too close to our goal, Mason... You will survive... You have to!
	get_players()[0] line_please ("never_at_rebirth"); //He was never at Rebirth Island.
	get_players()[0] line_please ("names_reznov"); //My name is Viktor Reznov.
	get_players()[0] line_please ("no.."); //No...
	get_players()[0] line_please ("mason!"); //MASON!
	get_players()[0] line_please ("will_have_revenge"); //I will have my revenge!
	get_players()[0] line_please ("mason_no"); //Mason - NO!
	get_players()[0] line_please ("step_8_freedom"); //Step eight, Reznov - Freedom!
	get_players()[0] line_please ("4_you_mason"); //For you Mason...
	get_players()[0] line_please ("not_4_me"); //Not for me...
*/

  level.hudson line_please("lost_our_link", 0, "hudson_explplains_2_go");
  level.hudson line_please("brought_you_here");

	/*
  level.hudson line_please("reznov_been_dead");
  level.hudson line_please("trusted_him");
  level.hudson line_please("gaps_in_memory");
  level.hudson line_please("strike_imminent");
  level.hudson line_please("lost_our_link");
  level.hudson line_please("brought_you_here");
  level.hudson line_please("have_broadcasts");
  level.hudson line_please("last_shot");
*/

}


event8_hudson_own_player()
{
	hide_viewmodel();
	
	hudson = simple_spawn_single("e8_hudson");
	
	level.fall_to_bed_crossfade					 = NewClientHudElem(get_players()[0]);
	level.fall_to_bed_crossfade.x 				 = 0;
	level.fall_to_bed_crossfade.y 			   = 0;
	level.fall_to_bed_crossfade.horzAlign  = "fullscreen";
	level.fall_to_bed_crossfade.vertAlign  = "fullscreen";
	level.fall_to_bed_crossfade.foreground = false; //Arcade Mode compatible
	level.fall_to_bed_crossfade.sort			 = 0;
	level.fall_to_bed_crossfade setShader( "black", 640, 480 );
	level.fall_to_bed_crossfade.alpha = 0;
	
	level thread maps\int_escape_anim::e8_hudson_vignette();
	
	flag_set("e8_hudson_grabbed_player");
	level thread play_hudson_punch_special();
	
	level notify ("stop_numbers_sound");

	
	flag_wait("e8_brainwash_go");
	event8_reznov_flashback();
}
play_hudson_punch_special()
{
	wait(1);	
	playsoundatposition("evt_hudson_punch", (0,0,0));
}
	
event8_reznov_flashback()
{
	
	//overbed_spot = getstruct("player_overbed_spot", "targetname");
	//inbed_spot = getstruct("player_inbed_with_reznov_spot", "targetname");

	wait 1.2;
	//wait 0.4;
	linker = event8_get_player_mover();
	linker RotateYaw(-360, 0.05);
	linker waittill ("rotatedone");
	get_players()[0] PlayerLinkToAbsolute(linker);
	
	linker moveto(level.fake_player_hands.origin, 4);
	linker RotateYaw(360, 3.8);
	
	wait 0.2;
	level.fall_to_bed_crossfade FadeOverTime(1);
	level.fall_to_bed_crossfade.alpha = 0;
	
	wait 1.8;
	
	clientnotify("e8_bw_fov_in");
	
	linker waittill ("movedone");
	
	get_players()[0] FreezeControls(false);

	maps\int_escape_anim::e8_reznov_brainwash();
}

event8_prep_reznov_reveal_video()
{
}

event8_do_reznov_reveal_video()
{
	level.fullscreen_cin_hud Destroy();

	thread play_movie("int_reznov_disappearing_flashback", false, false, "reznov_movie_play", undefined, "reznov_movie_done", 0.1);
	start_movie_scene();
	add_scene_line(&"int_escape_VOX_HUE1_S01_430A_REZN_M_A", 1, 1);		//Mason?
	add_scene_line(&"int_escape_vox_hue1_s01_431A_maso_m", 3, 3);		//Reznov. How'd you get out of Vorkuta?
	add_scene_line(&"int_escape_vox_hue1_s01_432A_maso_m", 7, 2);		//Never thought I'd see you alive...
	add_scene_line(&"int_escape_vox_int1_s01_063A_huds", 9, 7);		//He was never in Vietnam.  The real  defector with the Nova 6 dossier died during the attack on the MAC-V. 
	add_scene_line(&"int_escape_vox_int1_s01_302A_huds", 16, 2.5);		//He was never in the rat tunnels.
	add_scene_line(&"int_escape_vox_cre1_s04_163A_swif_m", 19.5, 2);		//What the fuck's wrong with you?
	add_scene_line(&"int_escape_vox_pow1_s04_416A_rezn", 25, 2);		//Kravchenko is here! 
	add_scene_line(&"int_escape_vox_pow1_s04_417A_rezn", 27.5, 4);		//This way! We cannot let him slip through our grasp!
	add_scene_line(&"int_escape_vox_int1_s01_303A_huds", 32.5, 3);		//He was never at Rebirth Island.
	add_scene_line(&"int_escape_vox_reb1_s02_079A_rezn_m_b", 36.5, 4.5);		//My name is Viktor Reznov. 
	add_scene_line(&"int_escape_vox_reb1_s02_080A_stei_m", 41, 2);		//No...
	add_scene_line(&"int_escape_vox_reb1_s03_153A_huds", 43, 1);		//MASON!
	add_scene_line(&"int_escape_vox_reb1_s03_157A_maso_a", 44, 6);		//My name is Viktor Reznov. And I will have my revenge!
	add_scene_line(&"int_escape_vox_reb1_s03_158A_huds", 50, 1.5);		//Mason - NO!
	add_scene_line(&"int_escape_vox_vor1_s7_274A_maso", 52, 2);		//Step eight, Reznov - Freedom!
	add_scene_line(&"int_escape_vox_vor1_s7_275A_rezn_m_b", 54, 1.5); 		//For you Mason...
	add_scene_line(&"int_escape_vox_vor1_s7_276A_rezn_m", 55.5, 1.5);		//Not for me...
	
	flag_wait("reznov_reveal_go");
	
	obj_3d(false);
	SetSavedDvar("r_streamFreezeState",1);
	
	level notify ("reznov_movie_play");
	
	level waittill ("reznov_movie_done");
	create_fullscreen_cinematic_hud();
	
	flag_set("reznov_reveal_vo_done");
	SetSavedDvar("r_streamFreezeState",0);
	//flag_wait("reznov_reveal_vo_done");
	//stop3dcinematic();
	get_players()[0] FreezeControls(false);
	
}
	

event9_temp_cuba_movie()
{
	thread int_esc_play_movie("int_drag_krav_stein_flash", false, false);
	level.fullscreen_cin_hud.alpha = 0;
	wait 0.15;
	level.fullscreen_cin_hud.alpha = 1;
	wait 1;
	level.fullscreen_cin_hud.alpha = 0;
	
	exploder(4001);
	play_numbers_bink(0.3, "stop_numbers_bink");
	
	
	

}

event10_distant_floating_numbers()
{
	delay = 0.5;
	offset = 300;
	zoffset = Int(offset*0.8);
	get_players()[0] SetClientDvar("player_viewratescale", 10);
	counter = 0;
	overall_counter = 0;
	
	player_forward_vec = AnglesToForward(get_players()[0].angles);
	player_backward_vec = player_forward_vec*-1;

	thread event10_close_floating_number_group();
	
	while(1)
	{
		while(1)
		{
			spots = GetEntArray("blackroom_number", "targetname");
			if (spots.size < 250)
			{
				break;
			}
			wait 0.1;
		}

		//player_forward_vec = AnglesToForward(get_players()[0].angles);

		
		num_start_point = get_players()[0] GetEye() + (player_forward_vec*1500);
		
		toss = RandomInt(100);
		
		if (toss < 33 )
			num_start_point = num_start_point+random_offset(offset,offset,zoffset, int(offset*0.8), int(offset*0.8) );
		else if (toss < 66)
			num_start_point = num_start_point+random_offset(offset,offset,zoffset, int(offset*0.8), undefined, int(zoffset*0.8) );
		else
			num_start_point = num_start_point+random_offset(offset,offset,zoffset,  undefined, int(offset*0.8), int(zoffset*0.8) );
			

		if (flag("rein_distant_numbers_in"))
		{
			flag_wait("short_waco_paco_done");
			thread event10_closer_floating_numbers(player_forward_vec);
			return;
		}
	

	
		
		num_end_point = num_start_point + (player_backward_vec*3000);
		
		spot = Spawn_a_model("tag_origin", num_start_point);
		spot.targetname = "blackroom_number";
		movetime = RandomFloatRange(3, 5);
		spot moveto(num_end_point,movetime );
		spot thread wait_and_delete(movetime);
		PlayFXOnTag(level._effect["floating_number"], spot, "tag_origin");
		
		counter++;
		overall_counter++;
		if (counter > 0)
		{
			if (delay > 0.05)
			{
				delay -= 0.05;
			}
			wait delay;
			counter = 0;
		}
	}
}		

event10_closer_floating_numbers(player_forward_vec)
{
	level endon ("waco_paco_full_go");
	offset = 200;
	zoffset = Int(offset*0.8);
	startspot = GetEnt("blackroom_center_spot", "targetname");
	counter = 0;
	overall_counter = 0;
	
	player_backward_vec = player_forward_vec*-1;

	while(1)
	{
		while(1)
		{
			spots = GetEntArray("blackroom_number", "targetname");
			if (spots.size < 250)
			{
				break;
			}
			wait 0.1;
		}
		
		num_start_point = get_players()[0] GetEye() + (player_forward_vec*800);
		num_start_point = num_start_point+random_offset(offset,offset,zoffset );

	

	
		
		num_end_point = num_start_point + (player_backward_vec*1200);
		
		spot = Spawn_a_model("tag_origin", num_start_point);
		spot.targetname = "blackroom_number";
		movetime = RandomFloatRange(0.5, 2);
		spot moveto(num_end_point,movetime );
		spot thread wait_and_delete(movetime);
		PlayFXOnTag(level._effect["floating_number"], spot, "tag_origin");
		
		counter++;
		overall_counter++;
		if (counter > 0)
		{
			wait 0.05;
			counter = 0;
		}
	}
}	

event10_close_floating_number_group()
{
	wait 6;
	player_forward_vec = AnglesToForward(get_players()[0].angles);
	player_backward_vec = player_forward_vec*-1;

	offset = 300;

	VisionSetNaked("int_castro_reveal", 0);
	
	
	for (i=0; i < 15; i++)
	{
		num_start_point = get_players()[0] GetEye() + (player_forward_vec*1500);
		num_start_point = num_start_point+random_offset(offset,offset,offset );
		num_end_point = get_players()[0] GetEye();
		
		spot = Spawn_a_model("tag_origin", num_start_point);
		PlayFXOnTag(level._effect["floating_number"], spot, "tag_origin");
		spot thread event10_numbers_close_in();
	}
	
	level waittill ("numbers_hit_players_face");
	
	thread play_numbers_flash(1, 0.95);
	playsoundatposition ("evt_numberflash_black", (0,0,0));		
	
	flag_set("short_waco_paco_go");
	flag_set("rein_distant_numbers_in");
	wait 0.5;
	level.fullscreen_cin_hud FadeOverTime(0.5);
	level.fullscreen_cin_hud.alpha = 0.2;
	
	wait 0.5;	
	thread play_numbers_bink(0.3, "stop_numbers_bink");
	
	flag_wait("short_waco_paco_done");
	
	flag_set("you_dont_know_go");
	
	wait 0.2;
	level.fullscreen_cin_hud FadeOverTime(0.4);
	level.fullscreen_cin_hud.alpha = 0.3;
	
	wait 0.4;
	thread play_numbers_bink(0.3, "stop_numbers_bink");
}	

event10_numbers_close_in()
{
	
	mytime = 4;
	while(mytime > 0)
	{
		self moveto(get_players()[0].origin + (0,0,60), mytime);
		wait 0.05;
		mytime -= 0.05;
	}
	

	
	level notify ("numbers_hit_players_face");
	PlayFX(level._effect["floating_number_fade"], self.origin);
	playsoundatposition ("evt_numbers_large_flux", self.origin);
	self Delete();
	wait 0.1;
} 

event10_flash_to_bed()
{
	bedspot = getstructent("blackroom_player_inbed_spot", "targetname", "tag_origin");
	
	clamp_l =  26;
	clamp_r =  0;
	clamp_u =  100;
	clamp_d =  -15;

	spot = Spawn("script_origin", get_players()[0].origin+(0,0,5) );
	spot.angles = get_players()[0].angles;
	
	get_players()[0] PlayerLinkToDelta( bedspot, "tag_origin", 1, clamp_r, clamp_l, clamp_u, clamp_d );
}

event11_start()
{
	level thread create_fullscreen_cinematic_hud(1);
	thread maps\int_escape_anim::waco_paco();
	thread switch_interrogation_hands("interrogation_hands_nosway_sp");
	get_players()[0] DisableWeapons();
		
	SetTimeScale(10);
	playsoundatposition ("num_26", (0,0,0));
	
	wait 1;
	clientnotify("bring_in_brainwash_fov");
	wait 0.1;
	clientnotify("e8_punch_fov_out");
	wait 0.1;
	clientnotify("e8_bw_fov_in");
	wait 0.1;
	clientnotify("e9_br_table_zoom_in");
	wait 0.1;
	
	wait 8;
	SetTimeScale(1);

	flag_set("waco_paco_full_go");
	thread	event10_rusalka_letters();
				
	wait 2.1;
	wait 5;
	clientnotify("e9_rusalka_zoom_in");
}
	

event10_start()
{
	tp_to_start("e9");
	
	level thread create_fullscreen_cinematic_hud(1);
	level.hudson = simple_spawn_single("e8_hudson");
	clientnotify("bring_in_brainwash_fov");
	wait 0.1;
	clientnotify("e8_punch_fov_out");
	wait 0.1;
	clientnotify("e8_bw_fov_in");
	
	thread maps\int_escape_anim::e9_short_waco_paco();


	thread maps\int_escape_anim::e9_skipto_animation();
	
	flag_wait("blackroom_go");
	
	thread event10();
}

event10_rusalka_letters()
{
	sign1 =  GetEnt("rusalka_letters", "targetname");
	sign1 Hide();
	sign = GetEnt("rusalka_letters_bink", "targetname");

	sign setclientflagasval(level.CLIENT_RUSALKA_LETTERS_BINK);
	
	flag_wait("waco_paco_full_go");
	wait 5;
	level.fullscreen_cin_hud.alpha = 0;

	start3dcinematic("int_rusalka_numbers_2", true, true);
	wait 0.2;
	sign setclientflagasval(level.CLIENT_RUSALKA_LETTERS_BINK_FADE);
	
	wait 2;
	clientnotify("dim_rusalka_light");
	
	wait 6;
	exploder (903);
}

event10_steiner_plead()
{
	guy = GetEnt("br_steiner", "script_noteworthy") StalingradSpawn();
	guy.animname = "steiner";
	guy thread maps\int_escape_anim::e9_steiner_emit_numbers();
	
	align_struct = GetEnt("blackroom_steiner_align", "targetname");
	playsoundatposition ("evt_numberflash_black", (0,0,0));		
  level thread e8_snd_number_loop("num_static_rusalka", (0,0,0), "end_static_loop_black");			
	VisionSetNaked("int_castro_reveal", 1);
	
		SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 0.5 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	if (!IsDefined(level.player_hands))
	{
		level.player_hands = Spawn_anim_model( "player" );
	}
	
	level.player_hands Show();
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	align_struct thread anim_single_aligned(level.player_hands, "u_dont_know");
	animtime = GetAnimLength(level.scr_anim["player"]["u_dont_know"]);
	align_struct thread anim_single_aligned(guy, "u_dont_know");
	wait animtime - 0.6;
	level notify ("stop_numbers_bink");
	wait 0.05;
	thread play_numbers_flash(0, undefined, "stop_numbers_bink");
	playsoundatposition ("evt_numberflash_black", (0,0,0));		
	
	level.fullscreen_cin_hud FadeOverTime(0.5);
	level.fullscreen_cin_hud.alpha = 1;
	
	level notify ("end_static_loop_black");		
	
	wait 0.55;
	guy Delete();
}

event10_rusalka_scratch_zoom()
{
	thread play_numbers_flash(1, undefined, "stop_numbers_flash");
	playsoundatposition ("evt_numberflash_black", (0,0,0));		
	level.fullscreen_cin_hud FadeOverTime(0.2);
	level.fullscreen_cin_hud.alpha = 0.6;
	wait 0.2;
	
	level.fullscreen_cin_hud.alpha = 1;
	spot = Getstructent("e10_rusala_zoom_spot1", "targetname", "tag_origin");
	get_players()[0] PlayerLinkToAbsolute(spot);
	wait 0.2;
	Earthquake(0.1, 2, get_players()[0].origin, 1000);
	level.fullscreen_cin_hud FadeOverTime(0.2);
	level.fullscreen_cin_hud.alpha = 0.6;
	
	wait 0.4;
	get_players()[0] SetClientDvar("cg_fov", 30);
	level.fullscreen_cin_hud.alpha = 0.4;

	wait 0.05;
	
	
	wait 0.7;
	//level notify ("stop_numbers_bink");

	//thread play_numbers_flash(1, 1);
	
	level.fullscreen_cin_hud.alpha = 1;
	get_players()[0] SetClientDvar("cg_fov", 65);
	warpto_blackroom_spot();
	level.fullscreen_cin_hud FadeOverTime(1);
	level.fullscreen_cin_hud.alpha = 0;
	
	flag_set("scratch_zoom_done");
}
		

event10()
{
	level notify ("set_default_fog");
	level thread event10_dialogue();
	obj_3d(false);

	thread event10_rusalka_letters();
	event10_blackroom();
}

event10_blackroom()
{
				// setup stuff
	level._player_speed_modifier = 0.02;
	hide_viewmodel();
	GetEnt("blackroom_brainwash_table", "targetname") Hide();
	
	warpto_blackroom_spot();
	//level.fullscreen_cin_hud FadeOverTime(2.5);
	level.fullscreen_cin_hud.alpha = 0;
	
	thread event10_distant_floating_numbers();
	
	flag_wait("starting_boat_dialogue");
	flag_wait("scratch_zoom_done");
	
	wait 1.5;
	level notify ("stop_numbers_bink");
	
	wait 0.05;
	thread play_numbers_flash(0.3, 2);
	playsoundatposition ("evt_numberflash_black", (0,0,0));		
  level thread e8_snd_number_loop("num_static_rusalka", (0,0,0), "end_static_loop_black");		
	level.fullscreen_cin_hud FadeOverTime(0.4);
	level.fullscreen_cin_hud.alpha = 1;

	wait 1.4;
	
	level notify ("end_static_loop_black");	
	
	wait .5;
	//level.fullscreen_cin_hud.alpha = 0;
	thread cover_screen_in_black(2, undefined, 3);
	playsoundatposition ("evt_numberflash_black", (0,0,0));		
  level thread e8_snd_number_loop("num_static_rusalka", (0,0,0), "end_static_loop_black");			
	get_players()[0] SetBlur( 10, 1 );
	get_players()[0] PlayerLinkToAbsolute(level.player_hands);
	
	wait 1;
	
	level notify ("end_static_loop_black");	

	wait .5;
	
	get_players()[0] SetBlur( 0, 2.5 );

	flag_set("waco_paco_full_go");
	level notify ("castro_reveal");
	

	
	wait 5;
	clientnotify("e9_rusalka_zoom_in");
}



event10_dialogue()
{

	flag_wait("you_dont_know_go");
	event10_steiner_plead();

	clientnotify("e9_br_table_zoom_in");
	thread event10_flash_to_bed();
	
	
	maps\int_escape_anim::e9_brainwash_vignette();
	//get_players()[0] line_please ("successfully_implanted", 1); //The subject has been successfully implanted with the knowledge to translate the number sequences.
	
	level.fullscreen_cin_hud FadeOverTime(0.5);
	level.fullscreen_cin_hud.alpha = 0.3;
	wait 0.45;
	level notify ("stop_numbers_bink");
	wait 0.05;
	thread play_numbers_bink(0.3, "stop_numbers_bink");
	
	level thread maps\int_escape_amb::event_heart_beat("none", 0, 1);
	
	delaythread (3.5,::event9_temp_cuba_movie);
	
  level thread e8_snd_number_loop("num_static_rusalka", (0,0,0), "end_static_loop_black");	
  
	get_players()[0] line_please ("new_allies_in_cuba"); //...[indistinct] all agents.  Our new allies in Cuba have graciously permitted the construction of a new... and permanent... broadcast station within their borders.
	delaythread (5,::event10_rusalka_scratch_zoom);
	
	get_players()[0] line_please ("from_now_until_nova"); //From now until Project Nova's initiation, all instructions will broadcast on this channel.
	get_players()[0] line_please ("our_plan"); //Our plan to strike at the very heart of the West is now in motion.	

	flag_set("starting_boat_dialogue");

	get_players()[0] line_please ("further_instruction"); //Await further instructions.
	
	level waittill ("new_relationship_said");
 	level thread e8_snd_number_wait();

 				
	get_players()[0] line_please ("our_new_rel_short", 5); //...our new relationship...
	get_players()[0] line_please ("perm_borad_short",0.5); 	//...and permanent... broadcast station within their borders.
	get_players()[0] line_please ("all_inst_short", 0.5);	 	//...all instructions will broadcast from the Rusalka.
	
	level notify ("end_static_loop_black");

}
e8_snd_number_wait()
{
	wait (1);
	playsoundatposition ("num_21_b", (0,0,0));	
	wait (28);
	setmusicstate ("END_FADE");
	playsoundatposition ("mus_hudson_sting", (0,0,0));	
}
e8_snd_number_loop( alias, origin, ender, timeout)
{
	org = spawn ("script_origin",(0,0,0));
	org.origin = origin;
	org playloopsound (alias);
		
	if (isdefined (ender))
	{
		level waittill (ender);
	}
	
	if (isdefined (timeout))
	{
		wait (timeout);
	}

	org stoploopsound (1);
}	

precache_everything()
{
	PreCacheShader("cinematic");
	PreCacheShader("black");
	PreCacheItem("m1911_sp");
	PreCacheItem("interrogation_hands_sp");
	PreCacheItem("interrogation_hands_nosway_sp");
	
	PreCacheModel("p_int_interrogation_chair_strap");
	PreCacheModel("p_dest_int_monitors01_a");
	PreCacheModel("p_dest_int_monitors01_b");
	PreCacheModel("p_dest_int_monitors01_c");
	PreCacheModel("anim_pent_double_doors_win_right");
	PreCacheModel("p_rus_industrial_cart");
	PreCacheModel("p_glo_cuban_cigar01");
	PrecacheShellShock ("int_escape");
	
	PreCacheModel("p_rus_rb_lab_warning_light_01");
	PreCacheModel("p_rus_rb_lab_warning_light_01_off");
	PreCacheModel("p_rus_rb_lab_light_core_on");
	PreCacheModel("p_rus_rb_lab_light_core_off");            

}


test_stumble(startpoint_tn, endpoint_tn, dont_delete)
{
	spot = getstructent(startpoint_tn, "targetname", "tag_origin");
	get_players()[0] PlayerLinkToAbsolute(spot, "tag_origin");
	endpoint = getstruct(endpoint_tn, "targetname");
	
	spot moveto (endpoint.origin, 1);
	spot RotatePitch(40, 0.5);
	spot waittill ("rotatedone");
	spot RotatePitch(-40, 0.5);
	spot waittill ("rotatedone");
	get_players()[0] Unlink();
	
	if (!IsDefined(dont_delete))
	{
		spot Delete();
	}
}

event3_doors()
{
	flag_wait("open_morgue_doors");
	wait 1.3;
	get_players()[0] startcameratween(0.5);
	level thread maps\int_escape_anim::e3_morgue_doors_playeranim();
}

event2_idle_flashbacks()
{
	level endon ("entering_morgue");
	last_movement = 0;
	
	while(1)
	{
		
		movement = length(self GetNormalizedMovement());
		camera_movement = length(self GetNormalizedCameraMovement());
		if ( (movement>0.1 || camera_movement>0.1) )
		{
			last_movement=0;
		}
		else
		{
			last_movement += 0.3;
		}
		
		if (last_movement > 20)
		{
			if (cointoss() )
			{
				//playsoundatposition ("evt_reznov_huecity_front", (0,0,0));
				int_esc_play_movie("int_reznov_huecity_flash", false, false);
			}
			else
			{
				//playsoundatposition ("evt_steiner_wmd_front", (0,0,0));
				int_esc_play_movie("int_steiner_wmd_flash", false, false);
				
			}
			last_movement = -2;
		}
		
		wait 0.3;
	}
}
	

event2_flashbacks()
{
	setmusicstate ("POST_HUDSON");
	trigger_wait("firsthall_flashback1_trig");
	flag_set("firsthall_flashback1_trig");
	
	level thread maps\int_escape_amb::event_heart_beat("panicked");
	
	level.fullscreen_cin_hud.alpha = 1;
	
	thread switch_interrogation_hands("interrogation_hands_sp");
	thread maps\int_escape_anim::e2_stumble_on_cart_playeranim();
	//playsoundatposition ("evt_reznov_huecity_front", (0,0,0));
	int_esc_play_movie("int_reznov_huecity_flash", false, false);
	
	flag_set("e2_cart_fall_go");
	level thread maps\int_escape_amb::event_heart_beat("sedated");
	get_players()[0] thread event2_idle_flashbacks();
	
	trigger_wait("hall_1_door_trig");
	
	level thread maps\int_escape_amb::event_heart_beat("panicked");
	thread switch_interrogation_hands("interrogation_hands_nosway_sp");
	level notify ("first_junction");
	
	//playsoundatposition ("evt_steiner_wmd_front", (0,0,0));
	int_esc_play_movie("int_steiner_wmd_flash", false, false);
	flag_set("cor1_doors_go");
	
	get_players()[0] maps\int_escape_anim::e2_hall_doors_stumble_playeranim();
	flag_set("through_cor1_doors");
	level thread maps\int_escape_amb::event_heart_beat("sedated");
}
	
event2_nearing_morgue()
{
	door_r = GetEnt("morgue_entrance_door_r", "targetname");
	door_l = GetEnt("morgue_entrance_door_l", "targetname");
	
	door_r setclientflagasval(level.CLIENT_REZNOV_ROOM_INIT);
	door_l setclientflagasval(level.CLIENT_REZNOV_ROOM_INIT);
	
	thread event2_morgue_doors_flash_start(door_r, door_l);
	
	flag_wait("cor1_doors_go");
	wait 0.2;
	
	level.fullscreen_cin_hud.alpha = 0;
	thread play_movie_on_surface("int_morgue_doors", 1, 1 );
	
	door_l setclientflagasval(level.CLIENT_MORGUE_DOOR_STATIC);	
	
	trigger_wait("start_morgue_dialogue");
	
	
	flag_set("start_morgue_dialogue");

	
	trigger_wait("start_morgue_tweak");
	
	trigger_wait("morgue_entrance_door_trig");
	level._player_speed_modifier = 0.6;

	spot = getstructent("morgue_doors_vin_spot", "targetname", "tag_origin");
	thread obj_3d(false);
	
	flag_set("morgue_entrance_go");

	thread event2_ah_ah_ah();

	trigger_wait("morgue_doors_lookat");
	level thread maps\int_escape_amb::event_heart_beat("panicked");
	
	get_players()[0] SetClientDvar("player_viewratescale", 20);
	
	level._player_speed_modifier = 0.15;

	//get_players()[0] SetClientDvar("player_viewratescale", 25);
	
	thread switch_interrogation_hands("interrogation_hands_sp");

	level.fullscreen_cin_hud.alpha = 0;
	stop_exploder(200);
	
	flag_wait("e3_flashroom_go");
	trigger_wait("morgue_doors_lookat");

	flag_set("open_morgue_doors");
	flag_wait("through_morgue_doors");

	level._player_speed_modifier = 1;

	flag_set("start_flashrooms");
}

event2_morgue_doors_flash_start(door_r, door_l)
{
	trigger_wait("start_morgue_tweak");
	door_l setclientflagasval(level.CLIENT_MORGUE_DOOR_LEFT_FLASHES);
	wait 0.2;
	door_l setclientflagasval(level.CLIENT_MORGUE_DOOR_STATIC);	
	wait 0.3;
	door_l setclientflagasval(level.CLIENT_MORGUE_DOOR_LEFT_FLASHES);	
	wait 0.5;
	door_l setclientflagasval(level.CLIENT_MORGUE_DOOR_TWEAK);	
	
	flag_wait("wait_a_few");
	door_r setclientflagasval(level.CLIENT_MORGUE_DOOR_RIGHT_FLASHES);
	door_l setclientflagasval(level.CLIENT_MORGUE_DOOR_LEFT_FLASHES);
	playsoundatposition ("evt_numbers_flash_nearing_morgue", (0,0,0));
	exploder(200);
}

event2_ah_ah_ah()
{
	level endon ("open_morgue_doors");
	trigger_wait("back_in_line_soldier");
		
	spot = getstruct("morgue_doors_vin_spot", "targetname");
	get_players()[0] FreezeControls(true);
	get_players()[0] lerp_player_view_to_position( spot.origin, spot.angles, 1, 1, 0, 0, 0, 0 );

	wait 5;
	get_players()[0] FreezeControls(false);
}
	
	

event1_dialogue()
{
	wait 1;
	
	get_players()[0] line_please ("been_here_hours"); //It is no use... we are out of time!
	get_players()[0] line_please ("cant_giveup_now"); //We can't give up now. He was at Vorkuta. He knows how to translate the codes. He's heard the broadcasts which we know contain the location. It's all in his head somewhere. He does know where it is!
	get_players()[0] line_please ("defcon2"); //We have to get to the bunker!  We are at DEFCON 2... You've tried everything...
	get_players()[0] line_please ("not_yet"); //Not yet...
	
	flag_set("start_hudson_anim");
	
	get_players()[0] line_please ("have_the_numbers", 1, "e1_punch_done"); //The numbers, Mason.  What do they mean?  Where are they broadcast from?
	get_players()[0] line_please ("nums_what_they_say", 2, undefined, "firsthall_flashback1_trig"); //Numbers...the numbers...what...are they saying?...
	playsoundatposition( "num_20", (0,0,0) );// //Number Sounds "...broadcast station"

}

event_objective_text()
{
	level waittill ("e1_punch_done");
	wait 1;
	Objective_State(1, "current");
	level waittill ("brainwash_sequence_done");
	Objective_State(1, "empty");
	Objective_String(1, &"INT_ESCAPE_OBJECTIVE_2");
	Objective_State(1, "current");
	level waittill ("reznov_outro_done");
	Objective_State(1, "empty");
	Objective_String(1, &"INT_ESCAPE_OBJECTIVE_3");
	Objective_State(1, "current");
	level waittill ("reznov_reveal_vo_done");
	wait 3;
	Objective_State(1, "empty");
	Objective_String(1, &"INT_ESCAPE_OBJECTIVE_4");
	Objective_State(1, "current");
}
	

event_objectives(event_num)
{
	spot = getstruct("int_escape_obj1_trig1_spot", "targetname").origin;
	objective_marker = Spawn_a_model("tag_origin", spot);
	Objective_Add(1, "empty", &"INT_ESCAPE_OBJECTIVE_1", objective_marker);
	Objective_Position( 1, objective_marker);
	
	thread event_objective_text();
	wait_for_first_player();
	
	objective_set3d(1, true, (1,1,1) );
		
	while(event_num < 8)
	{
		
	
		trigs = GetEntArray("obj_"+event_num+"_stuff", "script_noteworthy");
		for (i=0; i < trigs.size; i++)
		{
			num = i+1;
			trig = GetEnt("int_escape_obj"+event_num+"_trig"+num, "targetname");
			spot = getstruct("int_escape_obj"+event_num+"_trig"+num+"_spot", "targetname");
			movetime = Distance(spot.origin, objective_marker.origin) / 300;
			if (movetime < 1)
			{
				movetime = 1;
			}
			objective_marker moveto(spot.origin, movetime);
			
			if (event_num == 7)
			{
				flag_wait("reznov_reveal_vo_done");
				break;
			}
			else
			{
				trig waittill_any("trigger", "death");
			}
		}
		event_num++;
	}
	Objective_Position( 1, level.hudson);
}

event2_dialogue()
{
	flag_wait("e2_cart_fall_go");
	get_players()[0] line_please ("reznov_where_r_u", 1.5, "e2_cart_fall_go"); //Reznov ... Where are you?... Reznov...
	playsoundatposition ("num_21", (0,0,0));

}

event3_dialogue()
{
	flag_wait("cor1_doors_go");
	//play Mason: "Had..to kill...Steiner�"
	playsoundatposition ("num_19", (0,0,0));	
	get_players()[0] line_please ("had_2_kill_steiner", 0.5, "cor1_doors_go"); //I had...to kill...Steiner...

	playsoundatposition ("num_22", (0,0,0));
	//level thread number_station_wait("num_22", 3);
	
	get_players()[0] line_please ("fucking_numbers", 0.5); //I...keep...hearing...fucking...numbers...


	get_players()[0] line_please ("you_again", 0.5); //You.... Again...
	get_players()[0] line_please ("should_have_killed_u"); //I should have killed you in Vorkuta!

	flag_wait("start_morgue_dialogue");
	flag_set("wait_a_few");
	get_players()[0] line_please ("wait_few_moments"); //Wait a few moments... Let him rest.
	flag_set("e3_flashroom_go");

	get_players()[0] line_please ("regains_consc", 0, "open_morgue_doors"); //When he regains consciousness - Double the voltage.
	get_players()[0] line_please ("i_rem_vork", 0, "open_morgue_doors");		//I remember. Vorkuta...

	level._player_speed_modifier = 0.75;
	get_players()[0] line_please ("orders_embedded", 2, "morgue_dialogue_done"); //If he will not follow the orders embedded in the numbers, then he is of no use to me...
	get_players()[0] line_please ("he_can_rot"); //He can rot... Take him back to his cell.
	
	playsoundatposition ("num_23", (0,0,0));	
	get_players()[0] line_please ("dks_the_pain"); //Dragovich...Kravechenko...Steiner...the pain...oh my God, the pain...
	wait 0.5;
	playsoundatposition ("num_08", (0,0,0));		
	get_players()[0] line_please ("proceed_to_target", 0, "proceed_to_target"); //Proceed...to...target...
	wait 0.5;
	playsoundatposition ("num_24", (0,0,0));	
	get_players()[0] line_please ("oswald_compramised", 0, "approaching_reznov_room"); //Oswald...compromised.
	level._player_speed_modifier = 1;

}


change_heartbeat_timer()
{
	level notify ("morgue_heartbeat_set");
	//TUEY set music to Table
	setmusicstate ("TABLE");
	level thread maps\int_escape_amb::event_heart_beat("none", 0, 1);	
}

event3_flashroom_visionset(coming_back)
{
	if  ( self.targetname == "brainwash_room_warpspot")
		level notify ("brainwash");
	else if ( IsDefined(coming_back) && self.targetname != "e4_playerstart")
		level notify ("brainwash");
	else
		level notify ("first_junction");
}

event3_flashrooms(coming_back)
{
	if (!IsDefined(coming_back) )
	{
		simple_spawn("brainwash_spawners");
		get_players()[0] thread maps\int_escape_anim::e3_brainwash_vignette();
		spottargetname = "brainwash_room_warpspot";
		wait 0.2;
	}
	
	else
	{
		spottargetname = "e4_playerstart";
	}
	
	spot = getstruct(spottargetname, "targetname");
	
	spot2 = Spawn("script_origin", get_players()[0].origin);
	spot2.angles = get_players()[0] GetPlayerAngles();
	spot2.targetname = "morgue_player_spot";
	
	get_players()[0] FreezeControls(true);
	
	
	wait 0.1;
	thread switch_interrogation_hands("interrogation_hands_nosway_sp");
	
	
	get_players()[0] SetClientDvar("cg_fov", 75);
	delaythread(0.1, ::player_warpto,spot);
	play_random_shocking(0.4, 0.5);
	spot event3_flashroom_visionset(coming_back);
	
	wait 0.1;
	if (!IsDefined(coming_back))
	{
		wait 0.4;
	}
	
	
	delaythread(0.1, ::player_warpto,spot2);
	play_random_shocking(0.25, 0.3);
	spot2 event3_flashroom_visionset(coming_back);

	get_players()[0] FreezeControls(false);	
	wait 0.7;
	spot2.origin = get_players()[0].origin;
	spot2.angles = get_players()[0] GetPlayerAngles();
	
	get_players()[0] FreezeControls(true);
	wait 0.1;
	
	delaythread(0.1, ::player_warpto,spot);
	play_random_shocking(0.1, 0.15);
	spot event3_flashroom_visionset(coming_back);
	
	wait 0.1;
	if (!IsDefined(coming_back))
	{
		wait 0.2;
	}
	
	if (!IsDefined(coming_back))
	{
		delaythread(0.1, ::player_warpto,spot2);
		play_random_shocking();
		spot2 event3_flashroom_visionset(coming_back);
		get_players()[0] FreezeControls(false);	
		wait 0.3;
	}
	
	get_players()[0] FreezeControls(true);
	spot2.origin = get_players()[0].origin;
	spot2.angles = get_players()[0] GetPlayerAngles();
	
	for (i=0; i < 3; i++)
	{
		if (i < 1)
		{
			wait 0.05;
		}
		
		delaythread(0.1, ::player_warpto,spot);
		play_random_shocking();
		spot event3_flashroom_visionset(coming_back);
		
		if (i==0)
			wait 0.05;
		
		if (spot.targetname == spottargetname)
		{
			spot = spot2;
		}
		else
		{
			spot = getstruct(spottargetname, "targetname");
		}	
	}
	
	if (!IsDefined(coming_back))
	{
		play_random_shocking();
		spot = getstructent("brainwash_room_warpspot", "targetname", "tag_origin");
		spot event3_flashroom_visionset(coming_back);
		get_players()[0] SetClientDvar("cg_fov", 125);
		player_warpto(spot);
		
		newspot = getstruct("brainwash_room_warpspot_close", "targetname");
		clientnotify("bring_in_brainwash_fov");
		
		flag_set("in_brainwash_room");
		get_players()[0] PlayerLinkToAbsolute(spot);		
		movetime = 1;
		spot moveto (newspot.origin, movetime);
		spot RotateTo(newspot.angles, movetime);
		
		thread freeze_controls_for_time(movetime);
		get_players()[0] thread wait_and_unlink(movetime);
		
		wait movetime - 0.2;
		VisionSetNaked("int_frontend_char_trans", 0.2);
		wait 0.2;
		VisionSetNaked("int_brainwash", 1);
		get_players()[0] SetClientDvar("player_viewratescale", 0);
		wait 1;
		level notify ("brainwash");
		
	}
	else
	{
		thread play_random_shocking();
		spot = getstruct(spottargetname, "targetname");
		player_warpto(spot);
		spot event3_flashroom_visionset(coming_back);
		get_players()[0] SetClientDvar("cg_fov", 65);
		get_players()[0] FreezeControls(false);
	}
	
	
	
	

	if (!IsDefined(coming_back))
	{
		thread change_heartbeat_timer();
		event3_flash_to_bed();
	}
}

event3_flash_to_bed()
{
	bedspot = getstructent("player_inbed_spot", "targetname", "tag_origin");
	
	clamp_l =  26;
	clamp_r =  30;
	clamp_u =  100;
	clamp_d =  7;

	level waittill ("switch_to_FPV");
	spot = Spawn("script_origin", get_players()[0].origin );
	spot.angles = get_players()[0].angles;
	
	thread play_random_shocking();
	wait 0.1;
	get_players()[0] PlayerLinkToDelta( bedspot, "tag_origin", 1, clamp_r, clamp_l, clamp_u, clamp_d );
	
	level waittill ("switch_to_TPV");
	
	thread play_random_shocking();
	wait 0.1;
	player_warpto(spot);
	
	level waittill ("switch_to_FPV");
	spot = Spawn("script_origin", get_players()[0].origin );
	spot.angles = get_players()[0].angles;
	
	thread play_random_shocking();
	wait 0.1;
	get_players()[0] PlayerLinkToDelta( bedspot, "tag_origin", 1, clamp_r, clamp_l, clamp_u, clamp_d );
	
	level waittill ("switch_to_TPV");
	
	thread play_random_shocking();
	wait 0.1;
	player_warpto(spot);
}

