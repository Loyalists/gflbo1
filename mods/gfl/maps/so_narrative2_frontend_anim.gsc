#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_music;
#include maps\flamer_util;

#using_animtree ("generic_human");
main()
{
	level.xenon = ( GetDvar( #"xenonGame" ) == "true" ); 
	level.ps3 = ( GetDvar( #"ps3Game" ) == "true" ); 
	level.wii = ( GetDvar( #"wiiGame" ) == "true" ); 
	level.console = ( level.xenon || level.ps3 || level.wii ); 

	init_ai_anims();
	init_prop_anims();
	init_player_anims();
	init_notetracks();
}

precache_animated_objects()
{
	PreCacheModel("p_glo_cigarette01");
	PreCacheModel("p_rus_coffeemug");
	
	PreCacheModel("p_int_monitor_a_extracam");
	PreCacheModel("p_int_monitor_b_extracam");
	PreCacheModel("p_int_monitor_c_extracam");
	PreCacheModel("p_int_monitor_c_bink");
	PrecacheShellShock("electrocution");
	PreCacheShader("cinematic");

	character\gfl\character_gfl_m16a1::precache();
	character\gfl\character_gfl_ak12::precache();
}

init_ai_anims()
{
	level.scr_anim["generic"]["vorkuta_02_chair_anim"]			 = %ch_flash_vorkuta02_mason;
	level.scr_anim["generic"]["vorkuta_03_chair_anim"]			 = %ch_flash_vorkuta03_mason;
	level.scr_anim["generic"]["hue_city_02_chair_anim"]			 = %ch_flash_huey02_mason;
	level.scr_anim["generic"]["flashpoint_01_chair_anim"]		 = %ch_flash_flashpoint01_mason;
	level.scr_anim["generic"]["flashpoint_02_chair_anim"]		 = %ch_flash_flashpoint02_mason;
	level.scr_anim["generic"]["flashpoint_03_chair_anim"]		 = %ch_flash_flashpoint03_mason;

	level.scr_anim["generic"]["river_01_chair_anim"]				 = %ch_flash_river01_mason;
	level.scr_anim["generic"]["rebirth02_chair_anim"]				 = %ch_flash_rebirth02_mason;
	level.scr_anim["generic"]["flash_cuba01_chair_anim"]		 = %ch_flash_cuba01_mason;
	level.scr_anim["generic"]["flash_cuba03_chair_anim"]		 = %ch_flash_cuba03_mason;


	level.scr_anim["generic"]["hudson_inter_02"]			 = %ch_inter_02_interrogator;
	level.scr_anim["generic"]["hudson_inter_03"]			 = %ch_inter_03_hudson;	
	level.scr_anim["generic"]["weaver_inter_03"]			 = %ch_inter_03_weaver;	
	level.scr_anim["generic"]["hudson_inter_04"]			 = %ch_inter_04_interrogator;		
	level.scr_anim["generic"]["hudson_inter_05"]			 = %ch_inter_05_interrogator;	
	level.scr_anim["generic"]["hudson_inter_06"]			 = %ch_inter_06_interrogator;		
	level.scr_anim["generic"]["hudson_inter_07"][0]		 = %ch_inter_05_interrogator;	

	level.scr_anim["generic"]["int2_chair_anim"]			 = %ch_inter_02_mason_full;
	level.scr_anim["generic"]["int3_chair_anim"]			 = %ch_inter_03_mason_full;
	level.scr_anim["generic"]["int4_chair_anim"]			 = %ch_inter_04_mason_full;
	level.scr_anim["generic"]["int5_chair_anim"]			 = %ch_inter_05_mason_full;
	level.scr_anim["generic"]["int6_chair_anim"]			 = %ch_inter_06_mason_full;
	level.scr_anim["generic"]["int7_chair_anim"][0]		 = %ch_interrogation_chair_idle_full_char;
}

#using_animtree ("player");
init_player_anims()
{
	level.scr_animtree[ "player" ] 	= #animtree;
	level.scr_model[ "player" ] = level.player_interactive_model;
	
	level.scr_anim["player"]["int2_chair_anim"]			 = %ch_inter_02_mason;
	level.scr_anim["player"]["int3_chair_anim"]			 = %ch_inter_03_mason;
	level.scr_anim["player"]["int4_chair_anim"]			 = %ch_inter_04_mason;
	level.scr_anim["player"]["int5_chair_anim"]			 = %ch_inter_05_mason;
	level.scr_anim["player"]["int6_chair_anim"]			 = %ch_inter_06_mason;
	level.scr_anim["player"]["int7_chair_anim"][0]			 = %ch_inter_06_mason;
}

#using_animtree ("animated_props");
init_prop_anims()
{

	level.scr_animtree["strap"] 	        				  = #animtree;
	level.scr_model["strap"] 	       					 		  = "p_int_interrogation_chair_strap";
	level.scr_anim["strap"]["rightstrap_idle"][0]	 	= %p_interrogation_rightstrap_idle;
	level.scr_anim["strap"]["leftstrap_idle"][0]	 	= %p_interrogation_leftstrap_idle;

}

init_notetracks()
{
	addNotetrack_customFunction( "player", "shock",  ::electrocute, "int2_chair_anim" );
	addNotetrack_customFunction( "player", "shock",  ::electrocute, "int3_chair_anim" );
	addNotetrack_customFunction( "player", "shock",  ::electrocute, "int4_chair_anim" );
	addNotetrack_customFunction( "player", "shock",  ::electrocute, "int5_chair_anim" );
	addNotetrack_customFunction( "player", "shock",  ::electrocute, "int6_chair_anim" );

	addNotetrack_customFunction( "player", "sndnt#vox_fro3_s01_005A_maso",  ::next_tv_round_notify, "int2_chair_anim" );

	addNotetrack_customFunction( "player", "sndnt#vox_fro4_s01_003A_maso",  ::next_tv_round_notify, "int3_chair_anim" );
	addNotetrack_customFunction( "player", "sndnt#vox_fro4_s01_004A_maso",  ::next_tv_round_notify, "int3_chair_anim" );
	addNotetrack_customFunction( "player", "sndnt#vox_fro4_s01_006A_maso",  ::next_tv_round_notify, "int3_chair_anim" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro4_s01_009A_weav",  ::next_tv_round_notify, "weaver_inter_03" );

	addNotetrack_customFunction( "generic", "sndnt#vox_fro5_s01_003A_inte",  ::next_tv_round_notify, "hudson_inter_04" );
	addNotetrack_customFunction( "player", "sndnt#vox_fro5_s01_004A_maso",  ::next_tv_round_notify, "int4_chair_anim" );

	addNotetrack_customFunction( "player",  "sndnt#vox_fro6_s01_002A_maso",  ::next_tv_round_notify, "int5_chair_anim" );
	addNotetrack_customFunction( "generic",  "sndnt#vox_fro6_s01_003A_inte",  ::next_tv_round_notify, "hudson_inter_05" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro6_s01_005A_inte",  ::next_tv_round_notify, "hudson_inter_05" );
	addNotetrack_customFunction( "generic", "sndnt#vox_fro6_s01_007A_inte",  ::next_tv_round_notify, "hudson_inter_05" );
	addNotetrack_customFunction( "player", "sndnt#vox_fro6_s01_008A_maso",  ::next_tv_round_notify, "int5_chair_anim" );

	addNotetrack_customFunction( "generic", "sndnt#vox_fro7_s01_003A_inte",  ::next_tv_round_notify, "hudson_inter_06" );
	addNotetrack_customFunction( "player", "sndnt#vox_fro7_s01_004A_maso",  ::next_tv_round_notify, "int6_chair_anim" );		
	addNotetrack_customFunction( "player", "sndnt#vox_fro7_s01_006A_maso",  ::next_tv_round_notify, "int6_chair_anim" );
	addNotetrack_customFunction( "player", "sndnt#vox_fro7_s01_008A_maso",  ::next_tv_round_notify, "int6_chair_anim" );
}

narrative_straps()
{
	align_struct = getstruct("int_anims_align_struct", "targetname");
	
	lstrap = spawn_anim_model("strap");
	rstrap = spawn_anim_model("strap");
	
	align_struct thread anim_loop_aligned(lstrap, "leftstrap_idle");
	align_struct thread anim_loop_aligned(rstrap, "rightstrap_idle");
}

#using_animtree ("generic_human");
cleanup_fakeplayer_setup()
{
	level waittill ("menu_resetstate");
	get_ai("muthaduckin_mason_ai", "targetname") Delete();
}

interstitial_ai_anims()
{
	if (IsDefined(level.interrogator))
	{
		level.interrogator StopAnimScripted();
		level.interrogator Delete();
	}
	
	hudson = simple_spawn_single("hudson");
	hudson.animname = "generic";
	level.hudson = hudson;
		
	align_struct = getstruct("int_anims_align_struct", "targetname");
	
	if (IsDefined( level._weaver_int_anim ))
	{
		weaver = simple_spawn_single("weaver");
		weaver.animname = "generic";
		level.weaver = weaver;
		level.weaver Detach(level.weaver.headModel);
		level.weaver character\gfl\character_gfl_ak12::main();

		align_struct thread anim_single_aligned(weaver, level._weaver_int_anim);	
	}
	
	align_struct anim_single_aligned(hudson, level._hudson_int_anim);
}
		
fakeplayer_setup()
{
	level endon ("menu_resetstate");
	level thread cleanup_fakeplayer_setup();
	
	SetSavedDvar( "r_extracam_shadowmap_enable", 1 );
	get_players()[0] SetClientDvar("cg_drawFriendlyNames", 0);
	align_struct = getstruct("fakeplayer_head_align_struct", "targetname");
	player_align_struct = getstruct("player_release_align_struct", "targetname");
	maps\frontend::set_default_dof();
	
	if (!IsDefined (level.player_hands) )
	{
		level.player_hands = spawn_anim_model( "player" );	
	}
	
	level thread interstitial_ai_anims();
	level thread interstitial_player_camera_movement_control();
	level thread narrative_straps();
	level thread skip_interstitial();
	
	mason = simple_spawn_single("muthaduckin_mason");
	mason.animname = "generic";
	align_struct thread anim_single_aligned(mason, level._ai_chair_anim);
	player_align_struct thread anim_single_aligned(level.player_hands, level._player_chair_anim);


	starting_clamp = 0.1;
	get_players()[0] PlayerLinkTo(level.player_hands, "tag_camera", 0, starting_clamp, starting_clamp, starting_clamp,starting_clamp, true);
		
	animlength = GetAnimLength(level.scr_anim["generic"][level._player_chair_anim]);
	delaythread(animlength-2, ::flag_set, "level_fadeout" );

	lookspot = Spawn_a_model("tag_origin", (0,0,0) );
	lookspot Hide();
	
	level._mason_ai = mason;
	level._mason_lookspot = lookspot;

	wait .5;
	
	og_yaw = AngleClamp180(level.player_hands GetTagAngles("tag_camera")[1]);

	mason lookatentity(lookspot);
	
	while(1)
	{
		current_angles = get_players()[0] GetPlayerAngles();

		curr_yaw = AngleClamp180(current_angles[1]);
		yaw_diff = AngleClamp180(current_angles[1] - og_yaw);
		goal_yaw = AngleClamp180(og_yaw + yaw_diff*3);

		goal_angles = (current_angles[0] + 40, goal_yaw, current_angles[2]);
		forward = AnglesToForward(goal_angles);

		lookat_pos = get_players()[0] get_eye() + forward * 100;
		lookspot MoveTo(lookat_pos, .05);
		lookspot waittill("movedone");
	}
}

player_cam_lock(guy)
{
	//flag_set("take_control");
}

player_cam_unlock(guy)
{
	//flag_clear("take_control");
}
	
next_tv_round_notify(guy)
{
	flag_set("next_tv_round");
}	

checkpoint_safe_int_screens()
{
	while(1)
	{
		start3dcinematic("int_screens");
		level waittill("save_restore");
	}
}

electrocute(guy)
{
	level endon ("menu_resetstate");

	get_players()[0] ShellShock ("electrocution", 3);
	get_players()[0] DoDamage(1, get_players()[0].origin+(0,0,20) );
	get_players()[0] PlayRumbleOnEntity("melee_garrote");
	
	stop3DCinematic();

	flag_set("take_control");
	
	PlaySoundAtPosition( "evt_electrocute" , (0,0,0) );
	
	level.fullscreen_cin_hud.alpha = 0.4;

	if (cointoss())
	{
		thread play_movie("int_shocking_1", true, true);
	}
	else
	{
		thread play_movie("int_shocking_2", true, true);
	}
	
	wait RandomFloatRange(1.5,2);
	stop_movie();
	get_players()[0] StopRumble("melee_garrote");
	
	level.fullscreen_cin_hud.alpha = 0;
	
	Start3DCinematic("int_screens");

	wait .5;
	flag_clear("take_control");
}

interstitial_player_camera_movement_control()
{
	flag_init("take_control");

	level.INTRO_PLAYER_CLAMP_RIGHT = 50;
	level.INTRO_PLAYER_CLAMP_LEFT = 50;
	level.INTRO_PLAYER_CLAMP_TOP = 50;
	level.INTRO_PLAYER_CLAMP_BOTTOM = 50;

	player = get_players()[0];

	level endon("menu_resetstate");

	move_time = 2;
	took_control = false;

	while (true)
	{
		if (flag("take_control") || (Length(player GetNormalizedCameraMovement()) <= .05))
		{
			if (!took_control)
			{
				took_control = true;
				player StartCameraTween(move_time);
				player PlayerLinkTo(level.player_hands, "tag_camera", 1, 0, 0, 0, 0);
			}
		}
		else if (took_control)
		{
			took_control = false;
			//player StopCameraTween();	// this would help if we had it
			player PlayerLinkTo(level.player_hands, "tag_camera", 1, level.INTRO_PLAYER_CLAMP_RIGHT, level.INTRO_PLAYER_CLAMP_LEFT, level.INTRO_PLAYER_CLAMP_TOP, level.INTRO_PLAYER_CLAMP_BOTTOM);
			wait 3;
		}

		wait .05;
	}
}

skip_interstitial()
{
	wait 3;
	if ( GetDvar( #"language" ) == "japanese" && level.ps3 )
	{
		press_start = a_safe_text_display(&"FRONTEND_HOLD_TO_SKIP_PS3", -10, 0, undefined, 1.1 ,"right", "bottom", "right", "bottom");
	}
	else
	{
		press_start = a_safe_text_display(&"FRONTEND_HOLD_TO_SKIP", -10, 0, undefined, 1.1 ,"right", "bottom", "right", "bottom");
	}
	press_start.font = "small";
	
	press_start thread fadeout_skip_text(3.0);

 	counter = 0;
 	
 	while(counter < 30)
 	{
		if ( GetDvar( #"language" ) == "japanese" && level.ps3 )
		{
 			while (!get_players()[0] ButtonPressed( "BUTTON_B" ) )
 			{
 				wait 0.05;
 				counter = 0;
 			}
		}
		else if ( !level.console )
		{
			while ( !( get_players()[0] ButtonPressed( "BUTTON_A" ) || get_players()[0] jumpButtonPressed() ) )
			{
				wait 0.05;
				counter = 0;
			}
		}
		else
		{
 			while (!get_players()[0] ButtonPressed( "BUTTON_A" ) )
 			{
 				wait 0.05;
 				counter = 0;
 			}
 		}
 		counter++;
 		wait 0.05;
 	}
 	
 	if (level.script == "frontend")
 	{
 		level notify ("interstitial_skipped");
 	}
 	else
 	{
 		nextmission();
 	}
}

fadeout_skip_text(time)
{
	wait(time);
	self FadeOverTime(2.0);
	self.alpha = 0.0;
}
