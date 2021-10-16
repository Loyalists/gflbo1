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
	
	level._ai_chair_anim = "int6_chair_anim";
	level._player_chair_anim = "int6_chair_anim";
	
	level._hudson_int_anim = "hudson_inter_06";
	
	level.CLIENT_EXTRACAM_TV_INIT = 100;
	level.CLIENT_EXTRACAM_TV_SINGLE = 101;
	
	do_third_interstitial();
	nextmission();
	//ChangeLevel("rebirth", false);
}
	
do_third_interstitial()
{
	clientnotify("start_first_interstitial");
	flag_set("first_interstitial_go");
	VisionSetNaked("int_frontend_narrative_6", 1);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.16 );
	SetSavedDvar( "r_lightGridContrast", 1.0 );
	
	maps\frontend::set_monitors_to_snow();
	thread maps\so_narrative2_frontend_anim::fakeplayer_setup();
	thread int_5_tv_rounds();
	
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

int_5_tv_rounds()
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
	
	playsoundatposition ("evt_tv_war_so5", (-17,370,61));		

	wait 0.1;

	ui_tv = GetEnt("monitor_ui3d_01", "targetname");
	ui_tv Hide();

	ui_binktv = GetEnt("monitor_left_bink", "targetname");
	ui_binktv.origin = ui_tv.origin;
	ui_binktv.angles = ui_tv.angles;
	ui_binktv setclientflagasval(26);	 // 26

	monitor1 setclientflagasval(28); // 28
	monitor2 setclientflagasval(30); // 30
	monitor3 setclientflagasval(17); // 17
	monitor4 setclientflagasval(29); // 29 
	monitor5 setclientflagasval(27); // 27

	monitor6 setclientflagasval(30);
	monitor7 setclientflagasval(28);
	monitor8 setclientflagasval(17);
	monitor9 setclientflagasval(29);
	
		
	next_tv_round();  // "you went to.." tile 39 on ui_tv
	
	ui_binktv setclientflagasval(31);	

	next_tv_round();  // "steiner was THERE" - on there tile 40 on tv's 1-5
	wait 1;
	monitor1 setclientflagasval(32);
	monitor2 setclientflagasval(32);
	monitor3 setclientflagasval(32);
	monitor4 setclientflagasval(32);
	monitor5 setclientflagasval(32);

	monitor6 setclientflagasval(32);
	monitor7 setclientflagasval(32);
	monitor8 setclientflagasval(32);
	monitor9 setclientflagasval(32);
	
	
	next_tv_round();  // "dks...had to die - tile 50 on tv1, tile 41 on tile 4, mason on 3 and 5
	wait 0.5;
	monitor1 setclientflagasval(34);
	wait 1;
	monitor4 setclientflagasval(33);
	
	
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
	
	
	wait 2;
	
	monitor3 Hide();
	extracam3 Show();
	
	monitor5 Hide();
	extracam5 Show();
	
	
	next_tv_round();  // "the numbers were telling me..." mason on 1-5 
	playsoundatposition ("num_37_b", (-17,370,61));
			
	number_sound_ent = spawn( "script_origin", (-17,370,61) );
	//	number_sound_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	number_sound_ent playloopsound ("num_static_rusalka");			

	monitor1 Hide();
	extracam1 Show();
	monitor2 Hide();
	extracam2 Show();
	monitor4 Hide();
	extracam4 Show();

}



delete_frontend_objects()
{
}