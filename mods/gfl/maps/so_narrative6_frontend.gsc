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

	PreCacheModel("c_usa_interrogation_hudson_fb");	

	maps\frontend::frontend_precache();
	maps\so_narrative2_frontend_anim::precache_animated_objects();

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
	
	get_players()[0] SetClientDvar( "hud_showstance", 0 ); 
	get_players()[0] SetClientDvar( "compass", 0);	
	
	flag_clear("ignore_chair_playerlook");
	
	level thread maps\frontend_amb::interrogation_room_watcher();

	level thread maps\frontend::bink_monitor_randomize();
	start3dcinematic("int_screens", true, false);
}

#using_animtree("generic_human");
event1() //-- rename to be more descriptive
{
	wait_for_first_player();
	flag_clear("at_splash_screen");
	thread extracams();
	clientnotify("start_first_interstitial");
	
	frontend_player_connect();
	delete_frontend_objects();
	mason = simple_spawn_single("muthaduckin_mason");
	mason.animname = "generic";
	align_struct = getstruct("player_release_align_struct", "targetname"); 

	mason forceteleport(mason.origin+(0,0,1000) );

	wait 1;

	mason2 = simple_spawn_single("muthaduckin_mason");
	mason2.animname = "generic";
	
	level._hudson_int_anim = "hudson_inter_07";

	hudson = spawn("script_model", (-112, 160, 48) );
	hudson character\c_usa_interrogation_hudson::main();
	hudson UseAnimTree(#animtree);
	hudson.animname = "generic";
	level.hudson = hudson;
		
	align_struct = getstruct("int_anims_align_struct", "targetname");
	align_struct thread anim_loop_aligned(hudson, "hudson_inter_07");




	
	thread usebutton_tracker();
	VisionSetNaked("int_frontend_narrative_1", 0);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.16 );
	SetSavedDvar( "r_lightGridContrast", 1.0 );
	
	while(1)
	{

		align_struct play_vid_flashback(mason, "vorkuta_02_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "vorkuta_03_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "hue_city_02_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "flashpoint_01_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "flashpoint_02_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "flashpoint_03_chair_anim", mason2);
	
		align_struct play_vid_flashback(mason, "river_01_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "rebirth02_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "flash_cuba01_chair_anim", mason2);
		align_struct play_vid_flashback(mason, "flash_cuba03_chair_anim", mason2);
				
	}
	
	nextmission();
}

play_vid_flashback(actor, myanim, actor2)
{
	level endon ("x_pressed");
	IPrintLn(myanim);
	align_struct = getstruct("fakeplayer_head_align_struct", "targetname"); 
	
	while(1)
	{
		align_struct thread anim_single_aligned(actor2, myanim);
		self anim_single_aligned(actor, myanim);
	}
}
		
		
usebutton_tracker()
{
	while(1)
	{
		if (get_players()[0] UseButtonPressed() )
		{
			level notify ("x_pressed");
			
			while ( get_players()[0] UseButtonPressed() ) 
			{
				wait 0.05;
			}
		}
		wait 0.05;
	}
}


extracams()
{
	tvs = GetEntArray("p_int_monitor_a", "script_noteworthy");
	tvs = array_combine(tvs, GetEntArray("p_int_monitor_b", "script_noteworthy") );
	tvs = array_combine(tvs, GetEntArray("p_int_monitor_c", "script_noteworthy") );
	tvs = array_add(tvs, GetEnt("monitor_ui3d_01", "targetname") );
	
	for (i=0; i < tvs.size; i++)
	{
		tvs[i]._extracam_replacement = spawn_a_model(tvs[i].script_noteworthy+"_extracam", tvs[i].origin, tvs[i].angles);
		tvs[i]._extracam_replacement.targetname = tvs[i].targetname+"_extracam";
		tvs[i]._extracam_replacement.script_noteworthy = tvs[i].script_noteworthy;
		//tvs[i]._extracam_replacement Hide();
		tvs[i] Hide();
	}
	
	
}
delete_frontend_objects()
{
}