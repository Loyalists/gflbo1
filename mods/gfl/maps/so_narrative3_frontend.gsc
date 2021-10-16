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
	Start3DCinematic("int_screens");
}


event1() //-- rename to be more descriptive
{
	wait_for_first_player();
	flag_clear("at_splash_screen");
	
	frontend_player_connect();
	delete_frontend_objects();
	
	level._ai_chair_anim = "int4_chair_anim";
	level._player_chair_anim = "int4_chair_anim";
	
	level._hudson_int_anim = "hudson_inter_04";
	
	do_interstitial_3();
	nextmission();
	//ChangeLevel("fullahead", false);
}
	
do_interstitial_3()
{
	clientnotify("start_first_interstitial");
	flag_set("first_interstitial_go");
	VisionSetNaked("int_frontend_narrative_4", 1);
	
  SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.16 );
	SetSavedDvar( "r_lightGridContrast", 1.0 );
	
	maps\frontend::set_monitors_to_snow();
	thread maps\so_narrative2_frontend_anim::fakeplayer_setup();
	int_3_tv_rounds();
	
	flag_wait("level_fadeout");
	wait 1.8;
	
	stop3dcinematic();
	play_movie("int_4_torturetable");
}

int_3_tv_rounds()
{
	monitor1 = GetEnt( "monitor_01", "targetname" );
	monitor2 = GetEnt( "monitor_02", "targetname" );
	monitor3 = GetEnt( "monitor_03", "targetname" );
	monitor4 = GetEnt( "monitor_04", "targetname" );
	monitor5 = GetEnt( "monitor_05", "targetname" );

	monitor7 = GetEnt( "monitor_07", "targetname" );
	monitor9 = GetEnt( "monitor_09", "targetname" );

	monitor6 = GetEnt( "monitor_06", "targetname" );
	monitor8 = GetEnt( "monitor_08", "targetname" );
		
	wait 1;	

	playsoundatposition ("evt_tv_war_so3", (-17,370,61));	
	
	start3dcinematic("int_screens", true, false);

	wait 0.1;

	monitor1 setclientflagasval(18); // 18
	monitor2 setclientflagasval(20); // 20
	monitor3 setclientflagasval(22); // 22
	monitor4 setclientflagasval(15); // 15
	monitor5 setclientflagasval(16); // 16
	
	monitor7 setclientflagasval(21); // 21
	monitor9 setclientflagasval(19); // 19

	monitor6 setclientflagasval(20);
	monitor8 setclientflagasval(15);

	ui_tv = GetEnt("monitor_ui3d_01", "targetname");
	ui_tv Hide();

	ui_binktv = GetEnt("monitor_left_bink", "targetname");
	ui_binktv.origin = ui_tv.origin;
	ui_binktv.angles = ui_tv.angles;
	ui_binktv setclientflagasval(23);		

	next_tv_round();  // "clarke created nova.." tile 31 on ui_tv

	wait 3.2;
	
	stop3dcinematic();
	play_movie("int_4_nova6_bodies");
	start3dcinematic("int_screens", true, false);
	
	next_tv_round();  // "dragovich's second..." -  fullscreen int_4_krav_weaver
	wait 1.3;
	stop3dcinematic();
	play_movie("int_4_krav_weaver");
	start3dcinematic("int_screens", true, false);
	
}
	
delete_frontend_objects()
{
}