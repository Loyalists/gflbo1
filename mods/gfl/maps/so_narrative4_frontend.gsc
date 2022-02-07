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
	
	//maps\frontend::setup_default_bink_monitors();
	//level thread maps\frontend::bink_monitor_randomize();
	start3dcinematic("int_screens", true, false);
}


event1() //-- rename to be more descriptive
{
	wait_for_first_player();
	flag_clear("at_splash_screen");
	
	frontend_player_connect();
	delete_frontend_objects();
	
	level._ai_chair_anim = "int5_chair_anim";
	level._player_chair_anim = "int5_chair_anim";
	
	level._hudson_int_anim = "hudson_inter_05";
	
	level.CLIENT_EXTRACAM_TV_INIT = 100;
	level.CLIENT_EXTRACAM_TV_SINGLE = 101;
	
	do_interstitial_4();
	nextmission();
	//ChangeLevel("river", false);
}
	
do_interstitial_4()
{
	clientnotify("start_first_interstitial");
	flag_set("first_interstitial_go");
	VisionSetNaked("int_frontend_narrative_5", 1);
	
		SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.16 );
	SetSavedDvar( "r_lightGridContrast", 1.0 );
	
	maps\frontend::set_monitors_to_snow();
	thread maps\so_narrative2_frontend_anim::fakeplayer_setup();
	thread int_4_tv_rounds();
	
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

int_4_tv_rounds()
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
	
	wait 1;	
	start3dcinematic("int_screens", true, false);

	wait 0.1;


	ui_tv = GetEnt("monitor_ui3d_01", "targetname");
	ui_tv Hide();

	ui_binktv = GetEnt("monitor_left_bink", "targetname");
	ui_binktv.origin = ui_tv.origin;
	ui_binktv.angles = ui_tv.angles;
	ui_binktv setclientflagasval(24);		

	ui_extracam_tv = Spawn_a_model("p_int_monitor_c_extracam", ui_tv.origin, ui_tv.angles);
	ui_extracam_tv Hide();
	ui_extracam_tv setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	ui_extracam_tv thread wait_and_setclientflagasval(0.3, level.CLIENT_EXTRACAM_TV_SINGLE);

	next_tv_round();  // "yeah. reznov.."mason on ui_tv
	wait 0.5;

	extracam1 = Spawn_a_model(monitor1.script_noteworthy+"_extracam", monitor1.origin, monitor1.angles);
	extracam1 Hide();
	extracam1 setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	extracam1 thread wait_and_setclientflagasval(0.3, level.CLIENT_EXTRACAM_TV_SINGLE);
	
	extracam2 = Spawn_a_model(monitor2.script_noteworthy+"_extracam", monitor2.origin, monitor2.angles);
	extracam2 Hide();
	extracam2 setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	extracam2 thread wait_and_setclientflagasval(0.3, level.CLIENT_EXTRACAM_TV_SINGLE);
	
	extracam3 = Spawn_a_model(monitor3.script_noteworthy+"_extracam", monitor3.origin, monitor3.angles);
	extracam3 Hide();
	extracam3 setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	extracam3 thread wait_and_setclientflagasval(0.3, level.CLIENT_EXTRACAM_TV_SINGLE);
	
	extracam4 = Spawn_a_model(monitor4.script_noteworthy+"_extracam", monitor4.origin, monitor4.angles);
	extracam4 Hide();
	extracam4 setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	extracam4 thread wait_and_setclientflagasval(0.3, level.CLIENT_EXTRACAM_TV_SINGLE);
	
	extracam5 = Spawn_a_model(monitor5.script_noteworthy+"_extracam", monitor5.origin, monitor5.angles);
	extracam5 Hide();
	extracam5 setclientflagasval(level.CLIENT_EXTRACAM_TV_INIT);
	extracam5 thread wait_and_setclientflagasval(0.3, level.CLIENT_EXTRACAM_TV_SINGLE);

	ui_binktv Hide();
	ui_extracam_tv Show();
	
	monitor1 setclientflagasval(25);
	monitor2 setclientflagasval(25);
	monitor3 setclientflagasval(25);
	monitor4 setclientflagasval(25);
	monitor5 setclientflagasval(25);

	monitor6 setclientflagasval(25);
	monitor7 setclientflagasval(25);
	monitor8 setclientflagasval(25);
	monitor9 setclientflagasval(25);

	next_tv_round();  // "listen to me carefully".. fullscreen bink
	
	wait 3;
	
	// fullscreen int_5_reznov_vorkuta
	play_movie("int_5_reznov_vorkuta", false, false);
	level notify("stop_movie");
	start3dcinematic("int_screens", true, false);
	
	next_tv_round();  // "Reznov's not who.." mason on 01, 03, and 04 
	
		wait 2;
	
	monitor1 Hide();
	extracam1 Show();
		
	monitor3 Hide();
	extracam3 Show();
	
	monitor4 Hide();
	extracam4 Show();
	
	next_tv_round();  // "forget reznov!.." mason on 1-5
	wait 1;
	
	monitor2 Hide();
	extracam2 Show();
	
	monitor5 Hide(); 
	extracam5 Show();
	
	next_tv_round();  // "after who are you anyway" numbers on ui_tv and 1-5

	playsoundatposition ("num_37_b", (-17,370,61));		
	
	wait 3.5;
	
	ui_binktv setclientflagasval(0);
	monitor1 setclientflagasval(1);
	monitor2 setclientflagasval(2);
	monitor3 setclientflagasval(1);
	monitor4 setclientflagasval(2);
	monitor5 setclientflagasval(0);

	monitor6 setclientflagasval(2);
	monitor7 setclientflagasval(1);
	monitor8 setclientflagasval(0);
	monitor9 setclientflagasval(1);
	
	ui_extracam_tv Hide();
	ui_binktv Show();
	monitor1 Show();
	extracam1 Hide();
	monitor2 Show();
	extracam2 Hide();
	monitor3 Show();
	extracam3 Hide();
	monitor4 Show();
	extracam4 Hide();
	monitor5 Show();
	extracam5 Hide();
}


delete_frontend_objects()
{
}