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
	//Start3DCinematic("frontend");
}


event1() //-- rename to be more descriptive
{
	playsoundatposition ("evt_tv_ken_so1", (-17,370,61));	
	wait_for_first_player();
	flag_clear("at_splash_screen");
	
	frontend_player_connect();
	delete_frontend_objects();
	
	
	level._ai_chair_anim = "int2_chair_anim";
	level._player_chair_anim = "int2_chair_anim";
	
	level._hudson_int_anim = "hudson_inter_02";

	do_interstitial_1();
	nextmission();
	//ChangeLevel("vorkuta", false);
}
	
do_interstitial_1()
{
	clientnotify("start_first_interstitial");
	flag_set("first_interstitial_go");
	VisionSetNaked("int_frontend_narrative_2", 1);
	
	maps\frontend::set_monitors_to_snow();
	
	thread int_1_tv_rounds();
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

int_1_tv_rounds()
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
			// start with tile 6 on ui_tv on left
	tv = GetEnt("monitor_ui3d_01", "targetname");
	tv Hide();
	
	//ui_binktv = spawn_a_model("p_int_monitor_c_bink", tv.origin, tv.angles);
	ui_binktv = GetEnt("monitor_left_bink", "targetname");
	ui_binktv.origin = tv.origin;
	ui_binktv.angles = tv.angles;
	ui_binktv setclientflagasval(4);		
	
	monitor1 setclientflagasval(3);
	monitor2 setclientflagasval(5);
	monitor3 setclientflagasval(7);
	monitor4 setclientflagasval(8);
	monitor5 setclientflagasval(6);
	monitor6 setclientflagasval(3);
	monitor7 setclientflagasval(5);
	monitor8 setclientflagasval(7);
	monitor9 setclientflagasval(8);
				
	next_tv_round(); //"... my god" fullscreen flashback
	wait 1.5;
	play_short_movie("int_2_vorkuta");
	start3dcinematic("int_screens", true, false);
}

delete_frontend_objects()
{
}