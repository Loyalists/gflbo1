#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;

main()
{
	default_start( ::event1 );

	maps\so_narrative2_frontend_anim::precache_animated_objects();
	maps\frontend::frontend_precache();

	maps\_specialops::main();

	maps\frontend_fx::main();
	maps\frontend_amb::main();
	maps\frontend_anim::main();
	maps\so_narrative2_frontend_anim::main();

	maps\frontend::init_flags();
}

#using_animtree("player");
frontend_player_connect()
{
	get_players()[0] takeallweapons();

	get_players()[0] DisableWeapons();
	get_players()[0] AllowProne( false );
	get_players()[0] AllowCrouch( false );
	
	get_players()[0] SetClientDvar( "hud_showstance", 0 ); 
	get_players()[0] SetClientDvar( "compass", 0);	
	
	flag_clear("ignore_chair_playerlook");
	
	level thread maps\frontend_amb::interrogation_room_watcher();
	
}


event1() //-- rename to be more descriptive
{
	wait_for_first_player();
	flag_clear("at_splash_screen");
	
	frontend_player_connect();
	delete_frontend_objects();
	
	init_level_vars();

	do_interstitial_2();
	nextmission();
	//ChangeLevel("khe_sanh", false);
}

init_level_vars()
{
	level._ai_chair_anim = "int3_chair_anim";
	level._player_chair_anim = "int3_chair_anim";
	
	level._hudson_int_anim = "hudson_inter_03";
	level._weaver_int_anim = "weaver_inter_03";
	
	level.CLIENT_EXTRACAM_TV_INIT = 100;
	level.CLIENT_EXTRACAM_TV_SINGLE = 101;

	level.CLIENT_EXTRACAM_TV_UL = 102;
	level.CLIENT_EXTRACAM_TV_UR = 103;
	level.CLIENT_EXTRACAM_TV_BL = 104;
	level.CLIENT_EXTRACAM_TV_BR = 105;
}

do_interstitial_2()
{
	clientnotify("start_first_interstitial");
	flag_set("first_interstitial_go");
	VisionSetNaked("int_frontend_narrative_3", 1);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.16 );
	SetSavedDvar( "r_lightGridContrast", 1.0 );
	
	maps\frontend::set_monitors_to_snow();
	
	thread int_2_tv_rounds();
	thread maps\so_narrative2_frontend_anim::fakeplayer_setup();
	//thread first_int_tv_rounds();
	
	flag_wait("level_fadeout");
	level.end_level_hud					 = NewClientHudElem(get_players()[0]);
	level.end_level_hud.x 				 = 0;
	level.end_level_hud.y 			   = 0;
	level.end_level_hud.horzAlign  = "fullscreen";
	level.end_level_hud.vertAlign  = "fullscreen";
	level.end_level_hud.foreground = false; //Arcade Mode compatible
	level.end_level_hud.sort			 = 0;

	level.end_level_hud setShader( "black", 640, 480 );
	level.end_level_hud.alpha = 0;
	
	level.end_level_hud FadeOverTime(1);
	level.end_level_hud.alpha = 1;
	
	wait 1;
}

play_short_movie_stream(movie)
{
	stop3dcinematic();
	start3dcinematic(movie, false, false);
	playsoundatposition(movie+"_movie",(0,0,0));
	wait 0.05;
	hud = create_movie_hud();

		
	timeleft = GetCinematicTimeRemaining();
	counter = 0;
	while ( (timeleft < 0.05) && counter < 100 )
	{
		wait 0.05;
		counter++;
		timeleft = GetCinematicTimeRemaining();
		PrintLn(timeleft);
	}

	oldtimeleft = GetCinematicTimeRemaining();
	
	while (timeleft >= 0.2)
	{
		wait 0.05;

		timeleft = GetCinematicTimeRemaining();

		if (timeleft < oldtimeleft )
		{
			oldtimeleft = timeleft;
		}
		else
		{
			timeleft -= 0.05;
		}
	}
	wait 0.15;
	stop3dcinematic();
	hud Destroy();
}

int_2_tv_rounds()
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

	playsoundatposition ("evt_tv_par_so2", (-17,370,61));	

	wait 1;

	start3dcinematic("int_screens", true, false);

	// start with a num sequence on the ui tv to the left
	playsoundatposition ("num_30_s", (96,413,57));			
	static_tv = GetEnt("monitor_ui3d_01", "targetname");
	static_tv Hide();

	ui_binktv = GetEnt("monitor_left_bink", "targetname");
	ui_binktv.origin = static_tv.origin;
	ui_binktv.angles = static_tv.angles;
	ui_binktv setclientflagasval(0);		
	
	monitor1 setclientflagasval(12);
	monitor2 setclientflagasval(10);
	monitor3 setclientflagasval(14);
	monitor4 setclientflagasval(13);
	monitor5 setclientflagasval(11);
	monitor6 setclientflagasval(13);
	monitor7 setclientflagasval(14);
	monitor8 setclientflagasval(12);
	monitor9 setclientflagasval(11);
				
	next_tv_round(); // ".. others", tv_ui to static
		
	wait 2;
		
	ui_binktv Hide();
	static_tv Show();
	
	ui_binktv setclientflagasval(9);				
	wait 1;
	
	ui_binktv Show();
	static_tv Hide();
	



	ui_extracam_tv = spawn_a_model("p_int_monitor_c_extracam", ui_binktv.origin, ui_binktv.angles);
	ui_extracam_tv Hide();
	ui_extracam_tv setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	wait 0.3;
	ui_extracam_tv setclientflagasval(level.CLIENT_EXTRACAM_TV_SINGLE);

	wait 3;

	ui_binktv setclientflagasval(39);

	wait 2;
	
	ui_binktv Hide();
	ui_extracam_tv Show();
		
	extracam_01 = Spawn_a_model(monitor1.script_noteworthy+"_extracam", monitor1.origin, monitor1.angles );
	extracam_01.targetname = ( "monitor_01_extracam");
	monitor1 Hide();


	for (i=2; i < 6; i++)
	{
		tv = GetEnt( "monitor_0"+i, "targetname" );
		tv thread wait_and_hide(1);
		tv = Spawn_a_model(tv.script_noteworthy+"_bink", tv.origin, tv.angles );
		tv.targetname = ( "monitor_0"+i+"_quad_extracam");
		tv Hide();
		tv thread wait_and_show(1);
		
		tv thread wait_and_setclientflagasval(0.2, 100);
		tv delaythread ( 0.4, maps\frontend::set_cam_space, i);
	}
	
	next_tv_round();			// on voices..russians
	wait 1.2;
	play_short_movie_stream("int_3_drag_krav");
	start3dcinematic("int_screens", true, false);
	
	next_tv_round();			// on "we want..." tvs all turn to TBD numbers
	
	extracam_01 Hide();
	ui_extracam_tv Hide();
	for (i=2; i < 6; i++)
	{
		tv = GetEnt( "monitor_0"+i+"_quad_extracam", "targetname" );
		tv Hide();
	}
	
	
	ui_binktv Show();
	ui_binktv setclientflagasval(0);
	monitor1 Show();
	monitor1 setclientflagasval(1);
	monitor2 Show();
	monitor2 setclientflagasval(2);
	monitor3 Show();
	monitor3 setclientflagasval(0);
	monitor4 Show();
	monitor4 setclientflagasval(2);
	monitor5 Show();
	monitor5 setclientflagasval(1);
	
}
		
	


delete_frontend_objects()
{
}
