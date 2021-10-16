/* 
-----------------------------------------------------------------------------------
 ---- EVENT 1 - Helicopter scene, THINGS TO DO  ----
-----------------------------------------------------------------------------------
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\creek_1_util;
#include maps\_anim;
#include animscripts\Debug;
#include maps\_music;

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Helicopter scene, Functions called from creek_1.gsc ----
// --------------------------------------------------------------------------------
#using_animtree("generic_human");
event1_setup()
{
	maps\creek_1_start_fx::main(); 
	event1_precache_everything();
}

event1_extra_setup()
{
	// SUMEET_TODO - handle this time differently based on the difficulty of the level.
	level._meatshield_timer = 10;	
	level._meatshield_kill_player = true;	
	maps\_meatshield::main( "creek_meatshield_ak47_sp", "t5_gfl_ump45_viewmodel" );

	// setup callbacks
	OnPlayerConnect_Callback(::event1_on_player_connect);
	OnSaveRestored_Callback(::event1_on_save_restored);
}


event1_on_player_connect()
{
	event1_reset_dvars();
}

event1_on_save_restored()
{
	event1_reset_dvars();
}

event1_reset_dvars()
{
	
}

	
event1_precache_everything()
{
	PreCacheItem("creek_meatshield_ak47_sp");
	PreCacheItem( "m1911_sp" );
	PrecacheModel("viewmodel_usa_meatshield_arms");
	PrecacheModel("viewmodel_usa_jungmar_wet_player_fullbody");
	PrecacheModel("viewmodel_usa_jungmar_wet_player");
	PreCacheString( &"CREEK_1_OPEN_HUEY_DOOR");
}

// --------------------------------------------------------------------------------
// ---- Helicopter scene and meatshield main ----
// --------------------------------------------------------------------------------

main()
{
	wait(0.5);

	player = get_players()[0];
	player clientnotify( "start_helo_event" );
		
	// setup animation arrays
	maps\creek_1_start_anim::main();

	// init level flags
	init_event_flags();	

	// turn battle chatter off
	battlechatter_off();
	
	// handle effects
	level thread maps\creek_1_start_fx::handle_effects();
	
	// TEMP - handle sound loops
	level thread helo_audio_loopers(); //AUDIO - Ayers: Adding in some Temp Loopers
	
	// Event 1 - start actual event here
	level event1_crash_main();

	// Event 2 - start meatshield 
	level event2_meatshield_scene_main();
	
	// Continue next part of the script
	level maps\creek_1_stealth::main();
}

init_event_flags()
{
	// event 1
	flag_init("heli_in_place");			  // set when heli is ready to animate
	flag_init("player_woke_up");		  // player recovered from crash
	flag_init("heli_crash_scene_done");   // player is out of the huey
	flag_init("player_has_control");      // player has control
	flag_init("vcs_killed"); 			  // player killed VC's on sampans
	flag_init("eye_blink");			  	  // happens when player blinks the eye
		
	flag_init("open_huey_door_button_pressed");    // set when player hits x to open the door
	flag_init( "start_crash_door" );	// -- WWILLIAMS: FLAG TO START THE DOOR ANIMS BOTH PLAYER AND HELI
	flag_init( "huey_start_strength_test" );		// -- WWILLIAMS: BETTER TIMING FOR THE SCREEN MESSAGE ABOUT THE STRENGTH TEST
	flag_init( "huey_strength_test_half" );			// -- WWILLIAMS: FLAG THAT HALF OF THE STRENGTH TEST HAS BEEN PASSED
	flag_init( "huey_stage_2_ready" );	// -- WWILLAIMS: FLAG TELLS THAT THE PLAYER ARMS ARE DONE WITH THE FIRST STRENGTH TEST LOOP
	flag_init("open_huey_door");          // set when the player animation really starts opening the door
	flag_init("start_fall" );			  // set when huey should fall/sink.
	flag_init("event1_player_below_water_first_time"); //set when head below water first time. set from creek_1_start_anim
	flag_init("player_below_water");	  // set when player camera goes completely under that water when player falls	
	flag_init("reznov_open_door");		  // set when reznov opens the door with player

	// event 2
	flag_init("player_meatshield_ready");     	// set when player interacts with sampan1 for meatshield
	flag_init("meatshield_alerted"); 			// player is ready for meatshield
	flag_init("meatshield_finished");			// set when meatshiled is completed
	flag_init("meatshield_guy_ready");			// set when this meatshield guy is spawned
	flag_init("all_meatshield_vc_dead");		// set when all the meatshield VC's are dead
}

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Helicopter scene ----
// --------------------------------------------------------------------------------

#using_animtree("creek_1");
event1_crash_main()
{
	wait(0.1);
	
	// wait for the player to get into the game
	wait_for_first_player();

	//acb 03.30.10 save player for later use
	level.player = get_players()[0];	

	// player hud: turns off during opening scene
	level thread handle_player_hud();
	
	// handle vision set for the player at this point
	level thread maps\createart\creek_1_art::art_settings_inside_crashed_huey();

	// handle introscreen
	//level thread maps\_introscreen::introscreen_redact_delay( &"CREEK_1_B2_INTRO_LEVELNAME", &"CREEK_1_B2_INTRO_LOCATION", &"CREEK_1_B2_INTRO_DATE", &"CREEK_1_B2_INTRO_NAME", "", 2, 4, 2+7 );
	
	// turn off player shadow
	//player = get_players()[0];
	level.player SetClientDvar("r_enablePlayerShadow", 0 );


	// delete debug effects model
	original = GetEnt( "debug_original_pos", "targetname" );
	original Delete();
	
	final = GetEnt( "debug_final_pos", "targetname" );
	final Delete();
	
	// move away the clip at the huey
	player_clip = getent( "keep_player_away_from_huey", "targetname" );
	player_clip.origin = player_clip.origin + ( 0, 0, -2000 );
	

	// setup animation tags
	level.huey_tag   		= "origin_animate_jnt";
	level.sampan_tag 		= "tag_origin_animate";
	level.player_link_tag 	= "tag_player";
	
	// setup huey, player, pilots, sampans, vc's	
	event1_setup_intro_huey();
	event1_setup_player();
	event1_setup_pilots();
	event1_setup_sampan();
	event1_setup_vcs();

	// spawn a reference point for animations to play out, used for sampan and huey
	level.huey_anim_reference = spawn_boats_animation_reference();

	// variable wait here to dictate when the level should really start
	wait(7);
	setmusicstate("INTRO");

	wait(8);
	
	level thread custom_intro_text();

/#
	// DEBUG - record everyone
	recordEnt( level.intro_huey );
	recordEnt( level.event1_player_model );
	recordEnt( level.event1_sampan6 );

	level thread draw_animation_reference();
	level.intro_huey thread debug_huey_position();
	
	//acb debug stars the origins/tags of stuff in heli.
	//level thread debug_positions_in_heli();	
#/
	
	// heli
	level thread event1_animate_heli();
	
	flag_wait( "heli_in_place" );	
	
	// player
	level thread event1_animate_player();	

	// pilot/copilot
	level thread event1_animate_pilots();
	
	// In wake up loop for the player we only need pilots in place, everything else needs to animate later on.
	flag_wait( "player_woke_up" );

	// VC's
	level thread event1_animate_vcs();

	// sampan
	level thread event1_animate_sampan6();
	
	// barnes
	level thread event1_animate_barnes();

	// reznov
	level thread event1_animate_reznov();

	// wait for first event to be done
	flag_wait("open_huey_door");
}

custom_intro_text()
{
	level.introstring_custom = []; 

/*
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_LEVELNAME", 2700, 14000, 1300 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_LOCATION", 3500, 13500, 1800 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_DATE", 4800, 13000, 2500 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_NAME", 6800, 12500, 2200 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_TIME", 8500, 12000, 1000 );
*/

	custom_create_redacted_line( &"CREEK_1_B2_INTRO_LEVELNAME", 3200, 13500, 1300 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_LOCATION", 4000, 13000, 1800 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_DATE", 5300, 12500, 2000 ); 
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_NAME", 6800, 12000, 1700 );
	wait( 0.5 );
	custom_create_redacted_line( &"CREEK_1_B2_INTRO_TIME", 8000, 11500, 1000 );
}

// delay_cross = time between when text shows up and when the cross out occurs
// delay_fade_away = how long the text stays on screen before disappearing
// cross_out_time = how long it takes to cross out the line
custom_create_redacted_line( string, delay_cross, delay_fade_away, cross_out_time )
{
	index = level.introstring_custom.size;
	yPos = ( index * 30 ); 
	
	if (level.console)
	{
		yPos -= 90; 
		xPos = 0;
	}
	else
	{
		yPos -= 120;
		xPos = 10;
	}

	yPos -= 30;
	align_x = "left";
	align_y = "bottom";
	horz_align = "left";
	vert_align = "bottom";

	if ( level.splitscreen && !level.hidef )
		fontScale = 2.5;
	else
		fontScale = 1.5;
		
	if( !isdefined( cross_out_time ) )
	{
		cross_out_time = 1000;
	}
	
	level.introstring_custom[index] = NewHudElem(); 
	level.introstring_custom[index].x = xPos; 
	level.introstring_custom[index].y = yPos; 
	level.introstring_custom[index].alignX = align_x; 
	level.introstring_custom[index].alignY = align_y; 
	level.introstring_custom[index].horzAlign = horz_align; 
	level.introstring_custom[index].vertAlign = vert_align; 
	level.introstring_custom[index].sort = 1; // force to draw after the background
	level.introstring_custom[index].foreground = true; 
	level.introstring_custom[index].fontScale = fontScale; 
	level.introstring_custom[index] SetText( string );
	level.introstring_custom[index] SetRedactFX( delay_fade_away, 500, delay_cross, cross_out_time );
	level.introstring_custom[index].alpha = 0; 
	level.introstring_custom[index] FadeOverTime( 1.2 ); 
	level.introstring_custom[index].alpha = 1; 
}

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Helicopter animation ----
// --------------------------------------------------------------------------------
event1_animate_heli()
{
	// first crash the huey, just set the angles of the huey to the first frame of the fall animation
	level.huey_anim_reference anim_first_frame( level.intro_huey, "fall" );

	// let everyone know that heli is set in place
	flag_set( "heli_in_place" );
	
	// wait till we are ready to fall
	flag_wait("start_fall");

	// fall/sink into water now
	level.huey_anim_reference anim_single_aligned( level.intro_huey, "fall" );
	
	// -- WWILLIAMS: WAIT FOR THE PLAYER TO START PHASE ONE
	flag_wait( "start_crash_door" );

	//ACB - PHASE 1 LOOP	
	while( 1 )
	{
		level.huey_anim_reference anim_single_aligned( level.intro_huey, "huey_door_open_stage_1_loop" );
		/#
//		IPrintLn( "ANIMATION::huey_door_open_stage_1_loop::ANIMATION" );
		#/
		
		if( flag( "open_huey_door_button_pressed" ) )
		{
			break;
		}
	}
	
	//ACB - End anim for heli door
	level.huey_anim_reference anim_single_aligned( level.intro_huey, "huey_door_open_stage_1" );
/#
//	IPrintLn( "ANIMATION::huey_door_open_stage_1::ANIMATION" );
#/	

	// move the clip into player to block player from coming back in
	player_clip = getent( "keep_player_away_from_huey", "targetname" );
	player_clip.origin = player_clip.origin + ( 0, 0, 2000 );
} 

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Player animation ----
// --------------------------------------------------------------------------------
event1_animate_player()
{
	player_pos = event1_player_position();

	// link the player model to huey
	level.event1_player_model LinkTo( level.intro_huey, level.huey_tag );

	// wake up animation animation
	players = get_players();
	players[0] thread event1_wake_up_the_player();
	players[0] thread audio_event1_door_open();

	// handles the script model on the ground in heli
	players[0] thread event1_weapon_handler();

	// wait for the player to wake up, this is set when initial blur is over on the player
	flag_wait("player_woke_up");

	// SOUND - wakeup and move ahead
	players[0] PlaySound( "evt_s01_helo_plr" );

	//ACB: TEMP HACK to increase playback speed of animation for play. ANIMATION MUST FIX. FOR DEMO
	level thread event1_hack_anim_playback();
	
	// crash animation
	level.intro_huey anim_single_aligned( level.event1_player_model, "crash", level.huey_tag );

	// playre gets control
	//first setting of this flag which gets rid of prop weapon and resets hud
	flag_set("player_has_control");
	
	// -- WWILLIAMS: LOWER THE PLAYER SPEED DURING THE HUEY SHOOTING SECTION
	players[0] SetMoveSpeedScale( 0.35 );
	
	// if player waits for a while he will die
	players[0] thread kill_player_in_huey_if_he_waits();

	// give controls to the player for brief time
	event1_let_player_shoot();
	
	// wait here for  VC's being killed by the player
	flag_wait("vcs_killed");
	
	// -- WWILLIAMS: RESETS THE PLAYER SPEED TO NORMAL
	players[0] SetMoveSpeedScale( 1.0 );
	
	// wait a beat before kicking off the next anim
	level notify( "end_groans" );
	playsoundatposition( "evt_s01_helo_first_groan", (0,0,0) );
	playsoundatposition ("evt_s01_helo_metal_clang", (0,0,0));
	Earthquake( 0.6, 3, players[0].origin, 500 );
	players[0] PlayRumbleOnEntity( "damage_light" );
	
	//AUDIO: C. Ayers - PLAY BARNES LINE HERE
	level.barnes PlaySound( "vox_cre1_s01_020A_wood" );
	wait( 1.75 ); 

	// Lerp Player to start of anim to start helicopter falling. Placed between quakes to hide it.
	players[0] FreezeControls(true);
	players[0] StartCameraTween( 1 );	
	wait 0.05;
	players[0] SetPlayerAngles(level.intro_huey.angles);
	wait 0.05;
	players[0] player_fudge_moveto(player_pos, 85);	

	Earthquake( 0.8, .5, players[0].origin, 500 );
	playsoundatposition( "evt_s01_helo_fall_sweet", (0,0,0) );
	players[0] PlayRumbleOnEntity( "damage_heavy" );

	wait(.25);
			
	// take controls back from the player
	event1_setup_player();

	// ready to fall/sink
	level.intro_huey notify("start_fall");
	flag_set("start_fall"); 
	
	players[0] thread event1_adjust_fall_effects();
	
	// Aliu: Move the near plane closer so the camera doesn't clip into the arms. Will reset once the door opens.
	players[0] set_near_plane( 1 );

	//hide compass hud during strength test
	level thread handle_player_hud(true);
	
	// fall with the helicopter
	level.intro_huey anim_single_aligned( level.event1_player_model, "crash_fall", level.huey_tag );
	
	//wait for player to open the door, keep playing looping animation
	//ACB strength test button logic
	level thread event1_wait_for_player_to_open_door();

	// -- WWILLIAMS: MOVE THE HUEY DOOR INTO POSITION
	flag_set( "start_crash_door" );

	// start a looping animation until player presses x to exit
	players[0] event1_player_at_the_door_loop();
		
	// open the door, player should be now out of the huey
	level.intro_huey anim_single_aligned( level.event1_player_model, "crash_huey_door_end", level.huey_tag );
	/#
	//PrintLn( "ANIMATION::crash_huey_door_end::ANIMATION" );
	#/

	flag_set("heli_crash_scene_done");

	event1_player_release_player();
	
	//enable player clip for when player is out of helicopter and delete the one when he was in the chopper.
	level.intro_huey.player_clip Delete();
	level.intro_huey.player_clip_exit Solid();

	// save a checkpoint
	//autosave_by_name( "out_of_heli" );	//saving in water viewarms bug -jc
}

kill_player_in_huey_if_he_waits()
{
	level endon("vcs_killed");

	wait( 6 );
	
	// if both vcs are still alive, kill player
	if( isalive( level.crash_vcs[0] ) && isalive( level.crash_vcs[1] ) )
	{
		level thread burst_fire_kill_player( self );
		return;
	}
	
	wait( 3 );
	
	// if one vc is left, kill player 
	if( isalive( level.crash_vcs[0] ) || isalive( level.crash_vcs[1] ) )
	{
		level thread burst_fire_kill_player( self );
	}
}

burst_fire_kill_player( player )
{
	level endon("vcs_killed");
	
	player dodamage( player.health + 100, (0,0,0) );
	wait( 0.05 );
	player dodamage( player.health + 100, (0,0,0) );
	wait( 0.05 );
	player dodamage( player.health + 100, (0,0,0) );
	wait( 0.05 );
	player dodamage( player.health + 100, (0,0,0) );
	
	missionfailedwrapper();
}

//this is a hack. ANIMATION needs to adjust timing of the gun grab to be faster.
event1_hack_anim_playback()
{
/*
	wait 6.4;
	level.event1_player_model SetAnimRateComplete(0.01);
	wait 0.25;
	level.event1_player_model SetAnimRateComplete(1.0);
*/
	down = true;

	wait 12; //10.5-11 secs is looking at tooth death pilot 12 is at sampan guys
	
	//ramp down then ramp up timescale during player crash
	//IPrintLnBold("start slow timescale");
	while(1)
	{
		curr_timescale = GetTimeScale();
/*
		if(down)
		{
			SetTimeScale(  curr_timescale - 0.01 );			
			
			if( curr_timescale - 0.01 <= 0.7 )
			{
				down = false;
				//hold between end of ramp down and start of ramp up
				//wait 0.10;
				//IPrintLnBold("start fast timescale");
			}			
		}
*/
		if(down)
		{
			SetTimeScale(  curr_timescale + 0.01 );			
	
			if( curr_timescale + 0.01 >= 1.32 )
			{
				wait 2.5;
				SetTimeScale(1);	
				//IPrintLnBold("end timescale");				
				break;
			}			
		}
	
		wait(0.05);
	}		

}

//get position of arm model for animation of helicopter crash so player can be lerped there after he shoots VC
event1_player_position()
{
	level.intro_huey anim_first_frame(level.event1_player_model, "crash_fall", level.huey_tag);
	return level.event1_player_model.origin;
}

event1_weapon_handler()
{
	weapon_ent = Spawn("script_model", ( 0, 0, 0 ) );
	weapon_ent SetModel( "t5_weapon_1911_rh_world" );

	weapon_ent LinkTo( level.event1_player_model, "tag_weapon", ( 0,0,0 ), ( 0,0,0 ) );

	weapon_ent.angles = level.event1_player_model GetTagAngles( "tag_weapon" );

	// wait until player is about to get control and delete the fake model.
	flag_wait("player_has_control");

	weapon_ent Delete();
}

//ACB now being called from a note track in creek_1_start_anim
event1_adjust_fall_effects() // self = player
{
	flag_wait("event1_player_below_water_first_time");
	blur_amount = 7.0;
	step = 0.01;
	
	//ACB dont need the wait since based on note track
	//wait(0.5);

	// just a little blur to feel like we are falling.
	self StartFadingBlur( blur_amount, 4 );
	self SetWaterSheeting( 1, 6.0);
	SetTimeScale( 0.4, 1 );
	self PlayRumbleOnEntity("damage_heavy");

	wait(1);

	while(1)
	{
		curr_timescale = GetTimeScale();

		SetTimeScale(  curr_timescale + step );			

		if( curr_timescale + step >= 1 )
		{
			SetTimeScale(1);	
			break;
		}
	
		wait(0.05);
	}
}


event1_player_at_the_door_loop() // self = player
{	
	players = get_players();
	// -- WWILLIAMS: START STRENGTH TEST
	flag_set( "huey_start_strength_test" );
	
	// -- WWILLIAMS: PHASE ONE LOOP
	// -- WWILLIAMS: LOOP PLAYS THE STRUGGLE ANIMATION FOR PHASE ONE
	//ACB: Strength Test is now one loop with an exit.
	while( 1 )
	{
		level.intro_huey anim_single_aligned( level.event1_player_model, "crash_huey_strength_test_1_loop", level.huey_tag );
		/#
//		IPrintLnBold( "ANIMATION::crash_huey_strength_test_1_loop::ANIMATION" );
		#/
		
		if( flag( "open_huey_door_button_pressed" ) )
		{
			break;
		}				
	}

	// plays breath fx
	level thread event1_player_breath_underwater();	
	
	//kick off door, reznov, and player to open heli door
	flag_set( "open_huey_door" );	

	//ACB this is now being called here because it needs to adjsut as you open the door.
	players[0] clientnotify("change_heli_water_fog");

	//ACB door open animation - no more phase 2
	level.intro_huey anim_single_aligned( level.event1_player_model, "crash_huey_strength_test_1", level.huey_tag );
/#
//	IPrintLnBold( "ANIMATION::crash_huey_strength_test_1::ANIMATION" );
#/

	level thread maps\creek_1_start_anim::player_open_door( players[0] );
}

//player breath
event1_player_breath_underwater() // self = player
{
  playsoundatposition( "chr_swimming_vox_bubble", (0,0,0) );
	exploder(1007);
	exploder(1008);
}


event1_wake_up_the_player() // self = player
{
	wake_up_loop_count = 2;
	
	// this animation is 91 frames about 3 sec long, playing three times about 9 secs
	anim_length = GetAnimLength( level.scr_anim["player_hands"]["crash_wake_up"] );
	wake_up_time =  anim_length * wake_up_loop_count;

	// setup vision
	self thread event1_adjust_vision_settings( wake_up_time );
		
	// play wake up sounds, player and copilot ( just playing both of the player right now )
	self thread maps\creek_1_start_anim::event1_player_scripted_intro_dialogue();
	self thread maps\creek_1_start_anim::event1_copilot_scripted_intro_dialogue();
	self thread maps\creek_1_start_anim::event1_player_talk_to_barnes();
	
	// now play the wakeup animation three times
	for( i = 0; i < wake_up_loop_count; i++ )
	{
		level.intro_huey anim_single_aligned( level.event1_player_model, "crash_wake_up", level.huey_tag );
	}
		
	// player ready
	flag_set( "player_woke_up" );
}


event1_adjust_vision_settings( fadeout_time ) // self = player
{
	blur_amount = 16.0;
	fade_in_blur_time = fadeout_time - 3;

	// handle blinking
	self thread event1_player_blink_eye();

	self StartFadingBlur( blur_amount, fadeout_time + 4 );
	
	wait( fade_in_blur_time + 1 );
	flag_set("eye_blink"); // blink now
}


event1_player_blink_eye()
{
	flag_wait( "eye_blink" );	// just to let the level know that player is blinking eyes

	level.blinkeye = NewHudElem(); 
	level.blinkeye.x = 0; 
	level.blinkeye.y = 0; 
	level.blinkeye.horzAlign = "fullscreen"; 
	level.blinkeye.vertAlign = "fullscreen"; 
	level.blinkeye.foreground = true;
	level.blinkeye SetShader( "black", 640, 480 );

	// slower blink
	level.blinkeye.alpha = 0;
	level.blinkeye FadeOverTime( 0.75 ); 
	level.blinkeye.alpha = 1;

	wait( 1 );
	
	level.blinkeye FadeOverTime( 0.75 ); 
	level.blinkeye.alpha = 0;

	
	// wait a bit and destroy the hud
	wait(5);
	level.blinkeye Destroy();
}

event1_strength_test_button_prompt()
{
	self endon("end");
	
	/*
	if (!IsDefined(level.strengthtest))
	{
		level.strengthtest = NewHudElem();
		level.strengthtest.elemType = "font";
		level.strengthtest.font = "objective";
		level.strengthtest.horzAlign = "center"; 
		level.strengthtest.vertAlign = "middle";
		level.strengthtest.alignX = "center"; 
		level.strengthtest.alignY                = "middle"; 
		level.strengthtest.x = -63;
		level.strengthtest.y = -60;
		level.strengthtest.fontscale = 1.8;
		level.strengthtest.alpha = 0.7;

		if(level.console)
		{
			level.strengthtest SetText(&"CREEK_1_PROMPT_PRESS_BUTTON"); 				
		}
	}
	
	if (!IsDefined(level.strengthtest_text))
	{
		level.strengthtest_text = NewHudElem();
		level.strengthtest_text.elemType = "font";
		level.strengthtest_text.font = "objective";
		level.strengthtest_text.horzAlign = "center"; 
		level.strengthtest_text.vertAlign = "middle";
		level.strengthtest_text.alignX = "center"; 
		level.strengthtest_text.alignY     = "middle"; 
		level.strengthtest_text.x = -38;
		level.strengthtest_text.y = -60;
		level.strengthtest_text.fontscale = 1.8;
		level.strengthtest_text.alpha = 0.7;

		if(level.console)
		{
			level.strengthtest_text SetText(&"CREEK_1_PROMPT_PRESS"); 				
		}
	}
	*/
	
	
	if( !level.console )
	{
		screen_message_create( &"CREEK_1_OPEN_HUEY_DOOR" );
	}
	else
	{
		screen_message_create( &"CREEK_1_OPEN_HUEY_DOOR_FLASH" );
	}
		
	/*
	while(1)
	{
		if(IsDefined(level.strengthtest))
		{
			if(level.console)
			{
				level.strengthtest.alpha = 0.1;
				wait 0.2;
				level.strengthtest.alpha = 1;
			}
		}
		
		if( flag( "open_huey_door_button_pressed" ) || !IsDefined(level.strengthtest))
		{
			for( i = 0; i < 3 ; i++ )
			{
				wait 0.2;
				level.strengthtest.alpha = 0.1;
				wait 0.2;
				level.strengthtest.alpha = 1;
			}
			break;
		}
		wait 0.2;
	}
	
	level.strengthtest Destroy(); 	
	level.strengthtest_text Destroy();
	
	if(!level.console)
	{
		screen_message_delete();
	}
	*/
	
	flag_wait( "open_huey_door_button_pressed" );
	
	screen_message_delete();
}


//STRENGTH TEST BUTTON LOGIC
//self is level
event1_wait_for_player_to_open_door()
{
	flag_wait( "huey_start_strength_test" );
	self endon("death");
	
	//sent from event1_strength_test_fail_timer
	self endon("end");
	
	// show the prompt on the screen	
	//screen_message_create( &"CREEK_1_OPEN_HUEY_DOOR" );
	self thread event1_strength_test_button_prompt();
	
	//vars for strength test
	MAX_BUTTON_PRESSES = 15;
	level.button_presses = 0;
	fail_time = 8;
	
	//The smaller the number the longer it will take to decay from full.
	//example: 0.2 will drain a full meter in 5 seconds. while 2 will drain it in 0.5 seconds
	DECAY_RATE = 0.2;
	
	//0 == down; 1 == up; 2 == pressed; 3 == released (doing this to avoid more script strings)  
	button_state = 1; 

	//rumble function sets rumble based on value of level.button_presses
	level.player thread event1_strength_test_rumble();

	//fails mission when you are idle based on int passed in.
	level.player thread event1_strength_test_fail_timer( fail_time );
	
	//ACB - Strength Test button watcher
	while( level.button_presses <= MAX_BUTTON_PRESSES * 0.05 ) 
	{
		if( !flag( "huey_strength_test_half" ) && level.button_presses >= ( ( MAX_BUTTON_PRESSES * 0.05 ) * 0.5 ) )
		{
			flag_set( "huey_strength_test_half" );
		}
		
		//fix for button press always returning true on hold. checks for button states
		if(level.player UseButtonPressed())
		{
			//makes sure fast presses are counted.
			if(button_state == 1 || button_state == 3)	//if "up" or "released"
			{
				button_state = 2;	//set to "pressed"
			}
			else if(button_state == 2)	//if still "pressed"
			{
				button_state = 0;	//set to down  
			}
		}
		else
		{
			//make sure fast releases are counted
			if(button_state == 0 || button_state == 2)	//if "down" or "pressed"
			{
				button_state = 3;	//set to "released" 
			}
			else if(button_state == 3 )	//if still "released"
			{
				button_state = 1;	//set to "up" 
			}
		}
	
		//decrements per frame if button is "up"
		if(button_state == 1)
		{
			level.button_presses -= DECAY_RATE * 0.05;
		}	
	
		//increments strength test if button is "pressed".
		if(button_state == 2 ) 
		{
			level.button_presses += 1/MAX_BUTTON_PRESSES;
		}
			
		//ACB - hackery to space out breath fx
		//at two button presses from 0 trigger bubbles
		if( level.button_presses > 0 && level.button_presses < 2/MAX_BUTTON_PRESSES ) 
		{
			level thread event1_player_breath_underwater();
		}

		//stop decay 
		if(level.button_presses <= 0)
		{
			level.button_presses = 0;
		}			
					
/#		
//		IPrintLn("button_state " +button_state);
#/				
/#		
//		IPrintLnBold("presses " +level.button_presses);
#/		
		wait( 0.05 );
	}
	
	flag_set( "reznov_open_door" );
		
	// done, delete this message	
	//screen_message_delete();

	// let every one know that player has pressed x to open the door
	flag_set("open_huey_door_button_pressed");
}

//self is level.player
//takes level.button_presses and applies rumble based on range.
//switches between low and high rumble at 50%
event1_strength_test_rumble()
{
	self endon( "death" );
	level endon("open_huey_door");
	
	//sent from event1_strength_test_fail_timer
	level endon("end");
	
	RUMBLE_RANGE = 0.5;
	
	flag_wait( "huey_start_strength_test" );
	
	while( 1 )
	{
		if(level.button_presses >= 0 && level.button_presses <= 1)
		{
			if( level.button_presses >= 0 && level.button_presses < RUMBLE_RANGE )
			{
				self PlayRumbleOnEntity( "damage_light" );
				wait 0.22;
			}
		
			if( level.button_presses >= RUMBLE_RANGE && level.button_presses <= 1 )
			{
				self PlayRumbleOnEntity( "damage_heavy" );
				wait 0.02;				
			}
		}
		
		wait 0.05;
	}	
}

//ACB mission fail wrapper based on idle time.
//self is level.player
event1_strength_test_fail_timer( fail_time )
{
	self endon("death");
	level endon("open_huey_door_button_pressed");
	
	AssertEx(IsDefined(fail_time), "fail_time not defined");
	AssertEx(is_true(fail_time > 0), "fail_time must be greater than 0" );
		
	while(1)
	{
/#
		if(IsGodMode(level.player))
		{	
			fail_time = 10;
		}
#/
		if(fail_time <= 0)
		{
			//stop the strength test watcher and rumble logic so player cannot complete as we are failing
			level notify("end");
			
			// done, delete this message	
			screen_message_delete();
			/*
			if(IsDefined(level.strengthtest) && IsDefined(level.strengthtest_text))
			{
				level.strengthtest Destroy();
				level.strengthtest_text Destroy();
			}
			*/
			
			fail_time = 0;
			self event1_player_breath_underwater();
			self StartFadingBlur( 7, 6 );
			self SetWaterSheeting( 1, 6 );
		  
		  //rumble and spawn breath effects for 3 secs		  
			for(i = 0; i < 6; i++ )		 
		  {	
		  	self PlayRumbleOnEntity( "grenade_rumble" );
		 		wait 0.5;
			}
			
			self event1_player_breath_underwater();

			missionFailedWrapper();
			break;
		}	
		
		wait 1;
		fail_time--;
/#		
		PrintLn("loiter_time " +fail_time);
#/		
	}
}

// --------------------------------------------------------------------------------
// ---- EVENT 1 - VC and Sampan animations ----
// --------------------------------------------------------------------------------

event1_animate_vcs()
{
	// make sure the VC's are not killed yet.
	Assert( !flag( "vcs_killed" ) );

	// animate VC and the sampan in the same function
	array_thread( level.crash_vcs, ::event1_animate_vc_on_sampan );

	// wait until VC's are, we dont want to wait for death notify as this is driven by animation
	array_wait( level.crash_vcs, "killed" );

	// tell everyone that VC's are dead
	flag_set("vcs_killed");
	level notify( "vcs_killed" );
}

event1_animate_vc_on_sampan() // self = vc ai
{
	self endon("death"); // this should never happen, as these guys have magic_bullet_shield

	//level.player SetClientDvar("g_debug_bullets", 1);
	
	// we only want animation to kill these guys
	//self magic_bullet_shield();
	
	// make sure they are accurate enough
	self.perfectAim = 1;
	
	// VC's will animate based of the boat 
	self LinkTo( level.event1_sampan6, level.sampan_tag );

	// approach animation
	level.event1_sampan6 anim_single_aligned( self, "crash", level.sampan_tag );

	// die notification is sent when AI takes damage	
	self thread event1_wait_until_player_shoots();	

	// shooting at the player animation, until player shoots them
	level.event1_sampan6 anim_loop_aligned( self, "crash_shoot_loop", level.sampan_tag, "die" );

	// let the main animate thread that I am dead
	self notify( "killed" );
	
	self thread meatshield_special_death_vox();
	
	// death
	level.event1_sampan6 anim_single_aligned( self, "crash_death", level.sampan_tag );

	// death loop, , only have nothing when you want this animation to never die
	level.event1_sampan6 anim_loop_aligned( self, "crash_death_loop", level.sampan_tag, "nothing" );

	// now kill these guys
	self stop_magic_bullet_shield();
	self DoDamage( self.health + 200, self.origin );
}

event1_wait_until_player_shoots() // self = vc ai
{
	self endon("death");

	self waittill("damage", value, attacker );
	
	// sopt shooting loop and play death loop
	self notify("die");
}

event1_animate_sampan6() // self = sampan
{
	// approach 
	level.huey_anim_reference anim_single_aligned( level.event1_sampan6, "crash" );

	// looping until the scene is over
	level.huey_anim_reference anim_loop_aligned( level.event1_sampan6, "crash_loop" );	
}


// --------------------------------------------------------------------------------
// ---- EVENT 1 - Pilots ----
// --------------------------------------------------------------------------------
event1_animate_pilots()
{
	array_thread( level.pilots, ::event1_animate_pilot_inside_heli );
}

event1_animate_pilot_inside_heli() // self = pilot
{
	self endon("death");

	self magic_bullet_shield();

	// link pilot to huey
	self LinkTo( level.intro_huey, level.huey_tag );

	// pilot plays a real loop instead of hanging into a frame, cause he can be seen by the player
	if( self.animname == "pilot" )
	{
		level.intro_huey thread anim_loop_aligned( self, "start_loop", level.huey_tag, "player_woke_up" );	
	}
	else
	{	
		// crash animation
		level.intro_huey anim_first_frame( self, "crash", level.huey_tag );
	}

	// SOUND - Copilot sound
	if( self.targetname == "copilot_ai" )
	{
		self PlaySound("evt_s01_helo_copilot");
	}

	flag_wait("player_woke_up");
	
	// stop animation loops waiting on this before
	self notify( "player_woke_up" );
	
	// crash animation
	level.intro_huey anim_single_aligned( self, "crash", level.huey_tag );
	
	//ACB have to clear out string names since these guys are still alive in looping anims.
	for(i = 0; i < level.pilots.size; i++)
	{
		level.pilots[i].name = "";
	}
	
	// keep looping until the whole scene is done, only have nothing when you want this animation to never die
	level.intro_huey anim_loop_aligned( self, "crash_loop", level.huey_tag, "nothing" );
}

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Reznov ----
// --------------------------------------------------------------------------------
event1_animate_reznov()
{
	level.reznov endon( "reznov_open_door" );	

	// link reznov to the heli
	level.reznov LinkTo( level.intro_huey,  level.huey_tag );
	
	// door animation can be any time
	level thread event1_animate_reznov_open_door();

}

event1_animate_reznov_open_door()
{
	// -- WWILLIAMS: WAIT FOR THE PLAYER TO GET THE DOOR HALWAY OPEN, THEN HAVE REZNOV APPROACH.
	flag_wait( "reznov_open_door" );
	
	//level.intro_huey anim_single_aligned( level.reznov, "crash_approach", level.huey_tag );
	//IPrintLn( "ANIMATION::crash_approach::ANIMATION" );
	
	// remove his weapons, for now
	level.reznov gun_remove();
	
	flag_wait( "open_huey_door" );

	level.intro_huey anim_single_aligned( level.reznov, "crash_door_open", level.huey_tag );
	
	level thread event1_animate_reznov_idle_in_water();
	//IPrintLn( "ANIMATION::crash_door_open::ANIMATION" );
}

event1_animate_reznov_idle_in_water()
{
	// once player is getting on the boat we will stop animating Reznov
	level endon( "player_meatshield_ready" );
	level endon( "player_getting_on_sampan" );
	
	kill_sign_completed = false;
	while( 1 )
	{
		if( !isdefined( level.reznov ) || !isalive( level.reznov ) )
		{
			return;
		}
		
		// if player is close do the kill sign
		player = get_players()[0];
		if( kill_sign_completed == false && distance( player.origin, level.reznov.origin ) < 250 )
		{
			level.intro_huey anim_single_aligned( level.reznov, "sampan_kill_sign", level.huey_tag );
			kill_sign_completed = true;
		}
		
		if( !isdefined( level.reznov ) || !isalive( level.reznov ) )
		{
			return;
		}
		
		// do the normal idle
		level.intro_huey anim_single_aligned( level.reznov, "sampan_wait", level.huey_tag );	
	}
}

//self is level.player
event1_hack_specular()
{
	//this needs to be timed based on how long you see reznov's face as you climb out of the chopper
	wait 2.5;
	self SetClientDvar("r_specularmap", 0);	
	
	wait 2.5;
	self SetClientDvar("r_specularmap", 1);		
}

// --------------------------------------------------------------------------------
// ---- EVENT 1 - Barnes ----
// --------------------------------------------------------------------------------
event1_animate_barnes()
{
	//level.barnes endon("death");

	level.barnes.takedamage = false;

	// link pilot to huey
	level.barnes LinkTo( level.intro_huey, level.huey_tag );

	// crash animation
	level.intro_huey anim_single_aligned( level.barnes, "crash", level.huey_tag );

	//looping at the door.
	level.intro_huey anim_loop_aligned( level.barnes, "crash_open_door_loop", level.huey_tag, "start_fall" );
	
	// wait till we are ready to fall
	flag_wait("start_fall");

	// fall animation
	level.intro_huey anim_single_aligned( level.barnes, "crash_fall", level.huey_tag );

	// wait until door needs to be opened
	flag_wait("open_huey_door");

	// open door animation
	level.intro_huey anim_single_aligned( level.barnes, "crash_open_door", level.huey_tag );
	
	level.intro_huey anim_single_aligned( level.barnes, "crash_open_door_swim", level.huey_tag );

	// TEMP - set barnes free, we should play the swim up to the shore animation here
	level.barnes unlink();
	level.barnes.takedamage = true;
}


// --------------------------------------------------------------------------------
// ---- EVENT 1 - Helicopter scene setup functions ----
// --------------------------------------------------------------------------------

// Huey - This function sets up the crashed huey that player starts in
event1_setup_intro_huey()
{
	default_position_struct_targetname = "intro_huey_position_on_water_3";

/#
	position = GetDvarInt( #"scr_debugIntroPosition");

	if( position > 0 )
	{
		if( position > 4 )
			position = 4;

		default_position_struct_targetname = "intro_huey_position_on_water_" + string( position );
	}	

#/
	// store globally so it can be used all over the event
	level.intro_huey = getent( "intro_huey", "targetname" );
	
	// attach a player clip around the huey to help player move around. Delete this clip later
	//this is the player clip when the player is in the chopper and moving around. 
	level.intro_huey.player_clip = getent( "intro_huey_clip", "targetname" );
	level.intro_huey.player_clip LinkTo( level.intro_huey, level.huey_tag );

	//this is the player clip that will be enabled once the player exits the chopper.
	level.intro_huey.player_clip_exit = getent( "intro_huey_clip_exit", "targetname" );
	level.intro_huey.player_clip_exit LinkTo( level.intro_huey, level.huey_tag );
	//This clip needs to be off or else anims will pop.
	level.intro_huey.player_clip_exit NotSolid();

	// put the huey into its correct position
	position_struct = getstruct( default_position_struct_targetname, "targetname" );
	level.intro_huey.origin = position_struct.origin;
	level.intro_huey.angles = position_struct.angles;
	
	// setup the animname for crash event1
	level.intro_huey UseAnimTree(#animtree);
	level.intro_huey.animname = "chopper";
}

event1_setup_player()
{	
	player = get_players()[0];

	// unlink the player, in case he is linked to somthing
	player Unlink();
		
	// spawn a viewmodel and link the player to the viewmodel
	if( !IsDefined( level.event1_player_model ) )
	{
		level.event1_player_model = spawn_anim_model( "player_hands" );
		level.event1_player_model.animname = "player_hands";
	}

	// show the player model if hidden
	level.event1_player_model Show();

	// disable swimming until we get out of the heli
	player hide_swimming_arms();
	disable_swimming();
	
	// disable player input
	player FreezeControls(true);
	player DisableWeapons();

	// take all the weapons from the player
	player take_weapons();
	player GiveWeapon( "m1911_sp" );
	
	// default is absolute		
	player PlayerLinkToAbsolute( level.event1_player_model, level.player_link_tag );
}

// Player - This function lets player shoot from within the helicopter
event1_let_player_shoot()
{
	// allows player to aim assist through the dead pilots
	level.pilots[0] SetContents(0);
	level.pilots[1] SetContents(0);
	
	player = get_players()[0];
	
	level notify( "shut_off_boat" );

	// unlink the player	
	player Unlink();

	// link the player to its own position for now	
	//player PlayerLinkTo( level.event1_player_model, level.player_link_tag, 0, 40, 40, 140, 40 );

	// give controls back to the player
	player FreezeControls(false);
	player EnableWeapons();

	// set the stance to crouch
	player SetStance("stand");
	player AllowCrouch( false );
	player AllowStand( true );
	player AllowProne( false );
	player AllowJump( false );

	// hide fake player arms
	level.event1_player_model Hide();

	// give player pistol he picked up
	player SwitchToWeapon("m1911_sp");
}

// Player - relaease the player so that he can swim now
event1_player_release_player()
{
	player = get_players()[0];

	// unlink the player	
	player Unlink();

	// take the pistol away
	player TakeWeapon( "m1911_sp" );
		
	// give controls back to the player
	player FreezeControls(false);
	player give_weapons();
	player EnableWeapons();

	// show swimming arms
	player show_swimming_arms();

	player AllowCrouch( true );
	player AllowStand( true );
	player AllowProne( true );
	player AllowJump( true );

	// hide fake player arms
	level.event1_player_model Hide();
}

// hero's
event1_setup_heros()
{
	level.reznov = simple_spawn_single( "reznov" );
	level.barnes = simple_spawn_single( "barnes" );

	level.barnes make_hero();
	level.reznov make_hero();

	level.barnes.ignoreall = true;
	level.reznov.ignoreall = true;

	// setup animnames
	level.barnes.animname = "barnes";
	level.reznov.animname = "reznov";
	
	level.reznov wont_disable_player_firing();
}

// pilots
event1_setup_pilots()
{
	// get the pilots 
	level.pilots = [];

	level.pilots[0] = simple_spawn_single( "pilot" );
	level.pilots[0].ignoreall = true;
	level.pilots[0].ignoreme = true;
	level.pilots[0].animname = "pilot";
	level.pilots[0].name = "Pvt.Davis";	
	
	//level.pilots[0] SetContents(0);
		
	level.pilots[1] = simple_spawn_single( "copilot" );
	level.pilots[1].ignoreall = true;
	level.pilots[1].ignoreme = true;
	level.pilots[1].animname = "copilot";
	level.pilots[1].name = "Pvt. Frank";
	
	//level.pilots[1] SetContents(0);
}

// vc's
event1_setup_vcs()
{
	level.crash_vcs = [];

	level.crash_vcs[0] = simple_spawn_single( "sampan6_vc1" );
	level.crash_vcs[0].ignoreall = true;
	level.crash_vcs[0].animname = "vc1";
	
	level.crash_vcs[1] = simple_spawn_single ( "sampan6_vc2" ); 
	level.crash_vcs[1].ignoreall = true;
	level.crash_vcs[1].animname = "vc2";	
	
	level.crash_vcs[0] thread meatshield_fake_ai_conversation( true );
	level.crash_vcs[1] thread meatshield_fake_ai_conversation( true );
}

// sampans
event1_setup_sampan()
{
	level.event1_sampan6 = GetEnt( "sampan6", "targetname" );
	monster_clip = getent( "sampan6_clip", "targetname" );
	monster_clip linkto( level.event1_sampan6 );
	
	level.event1_sampan6 thread play_sampan_motor_audio();

	// sampan animname
	level.event1_sampan6 UseAnimTree(#animtree);
	level.event1_sampan6.animname = "sampan6";
}

// spawns an script origin at the water height to use it as a animation reference for everything.
spawn_boats_animation_reference()
{
	water_height = GetWaterHeight( level.intro_huey.origin );
	offset = 0;

/#
	//water_height_offset = GetDvarInt( #"scr_debugIntroCreekWaterOffset");

	//if( water_height )
	//{
	//	offset = water_height_offset; // set to 0 once testing is done
	//}

#/
	align = Spawn("script_origin", ( level.intro_huey.origin[0], level.intro_huey.origin[1], water_height + offset ) );
	align.angles = (0, 0, 0);
	align.angles = (0, 219, 0);

	return align;
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Meatshield scene ----
// --------------------------------------------------------------------------------

event2_meatshield_scene_main()
{	
	// get the meatshield sampan, player is going to perform meatshield on this sampan.
	level.meatshield_sampan = GetEnt( "sampan1", "script_noteworthy" );
	level.meatshield_sampan HidePart("tag_mantle");
		
	// art settings
	level thread maps\createart\creek_1_art::art_settings_for_meatshield();
	
	// handle objectives
	level thread event2_handle_objectives();

	// vc's and sampans
	level thread event2_animate_vcs_and_sampans_main();
	
	//acb 03.30.10 watch for player head above water fail condition
	level thread event2_above_water_fail();

	// sampan 6, this is the same sampan player encountered before, just shores aside
	level.event1_sampan6 thread event2_animate_sampan6();

	// player
	level event2_animate_player();

	// do not kick off the next event until all the AI's are dead
	flag_wait("all_meatshield_vc_dead");
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - VC and Sampans ----
// --------------------------------------------------------------------------------
event2_animate_vcs_and_sampans_main()
{

/#
	if( GetDvarInt( #"scr_debugIntroCreekVC") == 1 )
	{
		player = get_players()[0];

		while(1)
		{
			// wait until player presses DPAD_UP and Y at the same time 
			if( player ButtonPressed( "DPAD_UP" ) && player ButtonPressed( "BUTTON_Y" ) )
				break;

			wait(0.2);
		}
	}
	
#/
	// animate all the boats and VC's for the scene
	level.meatshield_boats = setup_meatshield_boats_main();
	
	// handle meatshield guy specially
	meatshield_grab_guy = event2_animate_special_meatshield_guy();

	// spawn and animate other VC's and their respective boats 
	level.sampan_ai_meatshield = simple_spawn( "ai_meatshield", ::event2_animate_vc_and_boat, meatshield_grab_guy );

	// start a thread that waits until all the VC's are dead and lets the level know
	array_wait( GetEntArray( "ai_meatshield_ai", "targetname" ), "death" );
	flag_set("all_meatshield_vc_dead");
}

event2_animate_special_meatshield_guy()
{
		// spawn meatshield grab guy first 
	meatshield_grab_guy = simple_spawn_single( "meatshield_vc", ::event2_animate_vc_and_boat );
	
	//iprintlnbold( "Die quietly" );
	meatshield_grab_guy.dieQuietly = true; //kevin avoid death sounds

	// save this guy for use later
	level.meatshield_grab_guy = meatshield_grab_guy;
	
	// let the level know that the meatshield guy spawned
	flag_set("meatshield_guy_ready");

	// start a thread that waits for meatshield is finished
	meatshield_grab_guy thread event2_vc_waittill_meatshield_done();
	
	// this is our meatshied grab guy, set him up
	meatshield_grab_guy contextual_melee( "meatshield" );
	meatshield_grab_guy.automatic_contextual_melee = true;

	return meatshield_grab_guy;
}

event2_vc_waittill_meatshield_done() // self = meatshield AI
{
	// wait for meatshield done
	player = get_players()[0];
	player waittill("_meatshield:done"); //GLocke: change to support ragdoll notetracks in meatshield death animations
	//self waittill("_meatshield:done");
	
	//meatshield grab guy runs his own thread for blood since vc_death ends on this flag and he is not in the water.
	self thread maps\creek_1_start_fx::event2_vc_death_blood_cloud(false);
	
	// let everyone know that meatshield is over with
	flag_set( "meatshield_finished" );
	
	//TUEY Music STate to IN_THE_JUNGLE
	setmusicstate("IN_THE_JUNGLE_ACTION");
	
	if( isalive( level.meatshield_grab_guy ) )
	{
		level.meatshield_grab_guy stop_magic_bullet_shield();
		level.meatshield_grab_guy.health = 1;
		level.meatshield_grab_guy dodamage( self.health + 100, ( 0, 0, 0 ) );
		level.meatshield_grab_guy startragdoll();
	}
}

event2_animate_vc_and_boat( meatshield_grab_guy ) // self = ai
{
	/*
	if( IsDefined( meatshield_grab_guy ) )
	{
		meatshield_grab_guy thread meatshield_struggle_vox();
	}
	*/
	
	// The boat this guy is supposed to be on is stored as script_string on the spawner.
	myboat = GetEnt( self.script_string, "script_noteworthy" );
	self.myboat = myboat; // store it for later reference

	// TEMP - for now we are not animating VC 2
	if( self.animname == "vc2" )
	{
		// TEMP we need to delete the boat too.

		// kill this dude
		self DoDamage( self.health + 200, self.origin );
		return;
	}
	
/#
	self thread debug_vc_and_sampan( myboat );
#/

	// non-meatshied grab guy needs to be setup as target for the meatshield event
	//acb 03.27.10 added exception for vc10 for woods grab vignette
	if( IsDefined( meatshield_grab_guy ) && ( self != meatshield_grab_guy ) && ( self.animname != "vc10" ) )
	{
		self add_meatshield_target( meatshield_grab_guy, false );
		self thread meatshield_fake_ai_conversation();
		self magic_bullet_shield();
	}

	self LinkTo( myboat, level.sampan_tag );
		
	// start animating the boat, this guy will now move with this boat.
	self thread event2_vc_meatshield_animate_myboat( myboat, meatshield_grab_guy );
	
	// wait for player to get in position for meatshield scene
	self thread event2_vc_wait_for_alert();

	// searching around animation
	if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "meatshield_vc" ) )
	{
		// special case for the meatshied guy, he will only loop search animation until player kills him.	
		myboat thread anim_loop_aligned( self, "search_loop", level.sampan_tag );
		return;
	}
	else
	{
		myboat anim_loop_aligned( self, "search_loop", level.sampan_tag, "meatshield_alerted" );
	}
	

	// player takes control of meatshiled guy, get alerted
	//acb 03.27.10 vc10 will be the vignette guy that woods grabs and kills, he never gets alerted.
	if( self.animname != "vc10" && IsAlive( self ) )
	{
		myboat anim_single_aligned( self, "alerted", level.sampan_tag );
	}

	if( self.animname != "vc10" && IsAlive( self ) )
	{	
		// start shooting the player
		myboat thread anim_loop_aligned( self, "shoot_loop", level.sampan_tag, "need_to_die" );
	
		// start the death thinking
		self thread event2_vc_death();
	
		//debug where the origin at death is for meatshield guys -acb 3.26.10
	/#	
		self thread debug_vc_sampan_pos_at_death();
	#/
	
		// failsafe, if this AI is not dead after meatshield is finished,
		// then stop his magic bullet shield so that he can be killed
		self thread event2_meatshield_vc_failsafe(); 		
		
	}

	//acb 03.27.10 isolate the vc woods is to kill and run the watcher to play his custom death.
	if( self.animname == "vc10" && IsAlive( self ) )
	{
		//need to set this up so that it works when player is walking around sampan
		//means this guy needs to have his own search_loop call.
		self notify( "meatshied_alerted" );
		//shooting on the boat like the others
		myboat thread anim_loop_aligned( self, "shoot_loop", level.sampan_tag );
		
		woods_grab_guy = self;
		woods_grab_guy thread event2_woods_grab_guy_vignette();
	}
}

//-acb 03.27.10 vignette for woods grabbing a sampan guy as you pan over.
//self is woods_grab_guy
event2_woods_grab_guy_vignette()
{
	flag_wait("meatshield_alerted");

	look_at_trig = GetEnt("trig_lookat_woods_grab", "targetname");

/#
	Debugstar(look_at_trig.origin, 500, (0,0,1));
#/

	//look_at_trig waittill("trigger"); 
	
	//waittill_player_looking_at( <origin>, <dot>, <do_trace> )
	origin = self.origin;
	
	for(x = 0; x < level.sampan_ai_meatshield.size; x++)
	{
		if(IsDefined(level.sampan_ai_meatshield[x]) && level.sampan_ai_meatshield[x].animname == "vc3")
		{
			origin = level.sampan_ai_meatshield[x].origin + (0,0,25);
		}
	}

/#	
	DebugStar(self.origin, 1000, (0,1,0));
#/

	level.player waittill_player_looking_at(origin, 0.95, true);
	
	//create an array to play aligned anims
	array_woods_grab = [];
	array_woods_grab[0] = self;
	array_woods_grab[1] = level.barnes;
	
	// no crosshair on the enemy
	array_woods_grab[0].activatecrosshair = false;
	
	//link woods/barnes to the boat.
	level.barnes LinkTo(self.myboat, level.sampan_tag);
	
	self stop_magic_bullet_shield();
	self.health = 1;

	//play the anim on woods and vc10	
	self.myboat anim_single_aligned( array_woods_grab, "special_death", level.sampan_tag );
	
	//clean up
	level.barnes Unlink();
	look_at_trig Delete();
	
	//play blood effects on vc10 in water
	self thread maps\creek_1_start_fx::event2_vc_death_blood_cloud(true);

	//NOTE: technically right now he is being killed by ragdoll death. code issue regarding ragdoll death needing a separate notify notetrack
	//kill vc10 and end this
	self stop_magic_bullet_shield();
	self DoDamage( self.health + 200, self.origin );	
}

// waits until meatshield is finished, and if unsuccessfull then makes the remaining AI killable
event2_meatshield_vc_failsafe() // self = vc ai
{
	self endon( "death" );

	// wait until meatshield is finished
	flag_wait( "meatshield_finished" );
	self stop_magic_bullet_shield();
}

//self is level
//ACB fails player when head is above water. fakes shooting the player and kills him.
event2_above_water_fail()
{
	self endon("death");
	self endon("player_meatshield_ready");
	
	FAIL_TIME = 2.5;
	time = 0;
	closest_ent = undefined;
	array_closest_ent = [];

	//start this when player has control. 
	flag_wait("heli_crash_scene_done");

	while(1)
	{
		eye = level.player GetEye();
		water_height = GetWaterHeight(level.player.origin);
/#
//		IPrintLn("eye pos: " +eye[2]);
//		IPrintLn("water height " +water_height);
	
		if(IsGodMode(level.player))
		{
			time = 0;
		}
#/	
		//if player eyes are above water for FAIL_TIME then pick closest AI and have a bullet come from him.
		if(eye[2] > water_height)
		{
			if(time > FAIL_TIME)
			{
				time = 0;
				x = 0;
			
				self event2_disable_meatshield_mantle_trigs();
			
				for(i = 0; i < level.sampan_ai_meatshield.size; i++)
				{
					if(IsDefined(level.sampan_ai_meatshield[i]))
					{
						array_closest_ent[x] = level.sampan_ai_meatshield[i];
						
						//only increment if defined
						x++;
					}
				}
				
				//make sure array is filled with something
				AssertEx(array_closest_ent.size > 0, "array_closest_ent is less than 0");

				//pick the closest one
				closest_ent = getClosest(level.player.origin, array_closest_ent, 1000);
					
				if(IsDefined(closest_ent))
				{
					start = closest_ent.origin;	
					
					if(IsDefined(closest_ent.weapon))
					{
						start = closest_ent GetTagOrigin("tag_flash");
					}
					
					//do damage on the player 3x to build up visual blood.
					for(y = 0; y < 3; y++)
					{
						MagicBullet(closest_ent.weapon, start, eye);
					  level.player DoDamage( level.player.health * 0.33, start );
						wait 0.25;
					}
/#					
					PrintLn("shooter " +closest_ent.animname);
#/					
					wait 0.5;
					level.player Suicide();
					break;		
				}
			}
		}
		else if(eye[2] < water_height)
		{
			time = 0;
		}
		
		wait 0.05;	
		time += 0.05;
	}	
}

//acb - 03.31.10 disable triggers so player cant mantle when fail text appears.
event2_disable_meatshield_mantle_trigs()
{
	if(level.message_created)
	{
		screen_message_delete();		
	}
	
	for(i = 0; i < level.meatshield_trigs.size; i++)
	{
		level.meatshield_trigs[i] Delete();
	}	
}

event2_vc_death() // 
{	
	self endon( "meat_shield_last_guy" ); // dont do this if this guys is the last guy in meatshield sequence
	damage = 0;

	while(1)
	{
		self waittill("damage", value, attacker );

		damage = damage + value;

		if( damage >= 100 )
		{
			break;
		}
	}
	
	// Only play special death if this is not the last guy
	if( !is_true( self.bulletcam_death ) && IsAlive( self ) )
	{
		// stop the previous shooting loop
		self notify( "need_to_die" );
		self notify( "special_fake_death" );
		self meatshield_special_death_vox();
	
		self stop_magic_bullet_shield();
		self.myboat anim_single_aligned( self, "special_death", level.sampan_tag );
	
		// play the bloodcloud effect
		self thread maps\creek_1_start_fx::event2_vc_death_blood_cloud();
	}
}

// breaks the search loop on VC 
event2_vc_wait_for_alert() // self = vc ai
{
	self endon("death");

	// waittill meatshied alert happens and let the AI know about it
	flag_wait( "meatshield_alerted" );

	self notify("meatshield_alerted");
}

event2_vc_meatshield_animate_myboat( boat, meatshield_grab_guy ) // self = ai
{
	// On some boats there are two guys, only one guy should animate the boat
	if( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "dont_animate_myboat" ) )
		return;

/#
	recordEnt( boat );
#/
	
	// if this is not meatshield boat, then we dont have to get this boat in final place right away
	if( self.targetname != "meatshield_vc_ai" )
	{
		flag_wait("heli_crash_scene_done");
	}
	
	// start getting boats into the scene
	boat thread event2_boat_approach();
	
	// decide when to start the search loop, start it if first animation is done or meatshield is alerted
	boat thread event2_decide_search_loop_time_for_boat();

	boat waittill_any( "start_search_loop", "meatshield_alerted" );
	
	level notify("update_obj_pos");

	// play a looped animation, bobing the boat with the water
	level.huey_anim_reference anim_loop_aligned( boat, "meatshield_loop" );
}

event2_boat_approach() // self = boat
{
	self endon("meatshield_alerted");

	// play approach in animation, this animation ends when player
	level.huey_anim_reference anim_single_aligned( self, "meatshield" );

	self notify("start_search_loop");
	
}


event2_decide_search_loop_time_for_boat() // self = boat
{
	self endon("start_search_loop");

	flag_wait( "meatshield_alerted" );
	
	self notify("meatshield_alerted");
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Special Sampan 6 ----
// --------------------------------------------------------------------------------
event2_animate_sampan6() // self = sampan 6
{

/#
	level.event1_sampan6 thread debug_vc_and_sampan( level.event1_sampan6 );
#/
	// sway away from the huey
	level.huey_anim_reference anim_single_aligned( level.event1_sampan6, "meatshield" );

	// keep looping at one side of the scene with two dead bodies.
	level.huey_anim_reference anim_loop_aligned( level.event1_sampan6, "meatshield_loop" );
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Player ----
// --------------------------------------------------------------------------------
event2_animate_player()
{
	// enable swimming for the player
	player = get_players()[0];
	
	// wait until player is on the sampan
	flag_wait( "player_meatshield_ready" );

	//acb 03.29.10 add watcher to fail if player does not run and grab meatshield guy.
	//if we re-add this make sure to comment out the flag "meatshield_alerted" since the watcher will set this.
	//level thread event2_on_sampan_fail_watcher();
	
	autosave_by_name( "creek_meatshield" );
	
	event2_meatshield_animate_player();
}

event2_meatshield_animate_player()
{
	players = get_players();

	// get the controls from player and set him up for this event
	event2_meatshield_setup_player();
	
	players[0] clientNotify( "_swimming:hide_arms" );
	players[0] clientnotify( "force_hide_swimming_arms" );
	wait( 0.1 );
	
	// unlink player model from the huey and link it to sampan1
	level.event1_meatshield_player_model = spawn_anim_model( "player_meatshield_hands" );
	level.event1_meatshield_player_model.animname = "player_meatshield_hands";
		
	// link the player to these new hands
	players[0] PlayerLinkToAbsolute( level.event1_meatshield_player_model, level.player_link_tag );	

	// link the player model to the sampan
	level.event1_meatshield_player_model LinkTo( level.meatshield_sampan, level.sampan_tag );
	
	//AUDIO: C. Ayers - Adding in Function to send off ClientNotify and enable 1st person anim sound design
	level thread meatshield_audio_start();

	// get on to the boat and run up to the meatshield guy animation
	anim_position = players[0].meatshield_trigger_used.script_noteworthy;

	//this is the mantle the boat and run up to meatshield anim
	level.meatshield_sampan anim_single_aligned( level.event1_meatshield_player_model, anim_position, level.sampan_tag );

	// hide meatshiled handle models
	level.event1_meatshield_player_model Hide();
	
	// alert everyone	
	flag_set("meatshield_alerted"); 
	
	// waittill meatshiled is completed 
	flag_wait( "meatshield_finished" );

	// unlink the player if he is linked, this is needed for coming from the back animation
	event2_meatshield_reset_player();
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Meatshield scene objective ----
// --------------------------------------------------------------------------------

event2_handle_objectives()
{
	//this is the default value for the dvar cg_objectiveIndicatorNearDist
	DEFAULT_OBJ_DIST = 256;

	// link the trigger to the boat
	meatshield_trigs = GetEntArray( "meatshield_start", "targetname" );
	
	level.meatshield_trigs = meatshield_trigs;
	
	// setup the objective triggers
	for( i = 0; i< meatshield_trigs.size; i++  )
	{
		meatshield_trigs[i]	event2_setup_player_meatshield_trigger();
	}

	// waittill player is done with the heli crash scene
	flag_wait( "heli_crash_scene_done" );
	flag_wait( "meatshield_guy_ready" );

	//set the dvar so that the objective indicator only fades when you are right on it.
	level.player SetClientDvar("cg_objectiveIndicatorNearDist", 32);

	Objective_Add( 2, "current", &"CREEK_1_OBJ_GET_ON_VC_BOAT" );
	Objective_Position( 2, level.meatshield_sampan GetTagOrigin( "tag_mantle" ) + (-20, 55, -15));
	Objective_Set3D( 2, true, "yellow" );

	// start waiting until player hits one of the triggers
	array_thread( meatshield_trigs, ::event2_waittill_player_near_meatshield_sampan_trig );
	
	flag_wait( "player_meatshield_ready" );

	Objective_State( 2, "done" );
	Objective_Delete( 2 );
	level.player SetClientDvar("cg_objectiveIndicatorNearDist", DEFAULT_OBJ_DIST);
}

event2_waittill_player_near_meatshield_sampan_trig() // self = trigger
{
	self endon("death");
	self endon("player_meatshield_ready");

	player = get_players()[0];
	level.message_created = false;

	while(1)
	{
		if( player IsTouching( self ) )
		{
			if( !level.message_created )
			{
				// -- WWILLIAMS: THOUGH THIS SAYS PRESS_MELEE THE ACTUAL STRING CALL IS FOR RELOAD/USE
				// -- THIS GETS THE PLAYER UP ON THE MEAT SHIELD SAMPAN
				
				// no longer need message. We will play the anim automatically
				//screen_message_create( &"CREEK_1_PRESS_MELEE" ); 
				level.message_created = true;
			}
		}
		else
		{
			if( level.message_created )
			{	
				//screen_message_delete();
				level.message_created = false;
			}
		}

		//if( level.message_created &&  player UseButtonPressed() )
		if( level.message_created )
		{
			//screen_message_delete();
			
			//level.meatshield_sampan HidePart("tag_mantle");
			
			// save the trigger reference on the player for selection of animation	
			player.meatshield_trigger_used = self;

			flag_set( "player_meatshield_ready" );
			level notify( "player_getting_on_sampan" );
			
			// reznov can have his gun back now
			level.reznov gun_switchto( "ak47_sp", "right" );
			break;
		}
		
		wait(0.05);
	}
}

//setup the trigger for player to use to activate the meatshield
event2_setup_player_meatshield_trigger() // self = trigger
{
	self EnableLinkTo();
	self LinkTo( level.meatshield_sampan, self.script_string );
}

// --------------------------------------------------------------------------------
// ---- EVENT 2 - Meatshield scene setup functions ----
// --------------------------------------------------------------------------------
event2_meatshield_setup_player()
{
	player = get_players()[0];

	// hide swimming arms for mantle.
	player hide_swimming_arms();

	// show the player model if hidden
	level.event1_player_model Unlink();
	level.event1_player_model Hide();

	// dont let the player get shot
	player EnableInvulnerability();

	// disable player input
	player HideViewModel();
	player FreezeControls(true);
	player DisableWeapons();
				
	// link the player to these hands
	player PlayerLinkToAbsolute( level.event1_player_model, level.player_link_tag );
}

event2_meatshield_reset_player( anim_position )
{
	players = get_players();

	// -- WWILLIAMS: THIS HAS BEEN MOVED. THE REAR ANIMATION NEEDS THE PLAYER TO BE UNLINKED AT THE END
	// -- OF THE ANIMATION. THIS STILL RUNS AFTER THE MEATSHIELD.
	// disable player input
	// players[0] FreezeControls(false);
	players[0] EnableWeapons();
	
	// show swimming arms after done with meatshield scene.
	players[0] show_swimming_arms();

	// dont show player interactive hands
	level.event1_player_model Hide();
			
	// let the player get shot from now on
	players[0] DisableInvulnerability();

	//  give AI an ak47 to continue
	players[0] GiveWeapon( "ak47_sp" );
	players[0] SwitchToWeapon( "ak47_sp" );
	players[0] ShowViewModel();
}

#using_animtree("creek_1");
setup_meatshield_boats_main()
{
	boats = GetEntArray("boats", "targetname");
	array_thread( boats, ::setup_meatshield_boat );
	
	return boats;
}

setup_meatshield_boat() // self = boat
{
	self UseAnimTree(#animtree);
	self.animname = self.script_animname;
	self PlayLoopSound( "veh_sampan_idle_low", 1 );
}	

// --------------------------------------------------------------------------------
// ---- EVENT 1 & 2 - Util functions ----
// --------------------------------------------------------------------------------

handle_player_hud(demo)
{
	if(IsDefined(demo) && is_true(demo))
	{
		level.player SetClientDvar( "compass", "0" );
		level.player SetClientDvar( "hud_showstance", "0" );
		level.player SetClientDvar( "actionSlotsHide", "1" );
		level.player SetClientDvar( "ammoCounterHide", "1" );		
	}
	else
	{
		SetSavedDvar( "hud_drawhud", 0 );
	}

	flag_wait_any("player_has_control", "heli_crash_scene_done");

	if(IsDefined(demo) && is_true(demo))
	{
		level.player SetclientDvar( "compass", "1" );
		level.player SetClientDvar( "hud_showstance", "1" );
		level.player SetClientDvar( "actionSlotsHide", "0" );
		level.player SetClientDvar( "ammoCounterHide", "0" );		
	}
	else
	{
		SetSavedDvar( "hud_drawhud", 1 );
	}

	flag_clear("player_has_control");
}

// --------------------------------------------------------------------------------
// ---- Debug functions ----
// --------------------------------------------------------------------------------

// Jumpto functions
event2_meathield_jumpto()
{
	// setup animations before using it anywhere
	maps\creek_1_start_anim::main();

	// Setup the huey for the player
	event1_setup_intro_huey();
	
	// setup the sampan
	event1_setup_sampan();

/#
	// DEBUG - draw animation reference
	level thread draw_animation_reference();
#/

	event2_meatshield_scene_main();
}


/#

draw_animation_reference()
{
	// just for debugging
	if( GetDvarInt( #"scr_debugIntroCreek") != 1 )
	{
		 return;
	}
	
	// spawn a reference point for animations to play out, used for sampan and huey
	level.huey_anim_reference = spawn_boats_animation_reference();
	level.intro_huey thread draw_debug_cross( level.huey_anim_reference.origin, "never" );
}

debug_vc_sampan_pos_at_death()
{
	self waittill("death");
	//player = get_players()[0];
	
	DebugStar(self.origin, 300); //white - point of death
}

debug_vc_and_sampan( myboat ) // self = vc ai
{
	self endon("death");

	if( GetDvarInt( #"scr_debugIntroCreek") != 1 )
	{
		 return;
	}

	while(1)
	{
		if( IsAI( self ) )
		{
			self print3d_on_ent( self.script_animname, 70 );
		}
		
		if( IsDefined( myboat ) )
		{
			myboat print3d_on_ent( myboat.script_animname, 40 );
			myboat print3d_on_ent( myboat.script_animname + "_origin", 0 );
			recordLine( myboat.origin, myboat.origin + vector_scale( AnglesToForward( myboat.angles ), 100 ), ( 1, 1, 1 ), "Script", self );
		}

		wait(0.05);
	}

}

debug_huey_position() // self = huey
{
	if( GetDvarInt( #"scr_debugIntroCreek") != 1 )
	{
		 return;
	}

	while(1)
	{
		origin_body = self GetTagOrigin( "tag_body" );
		angles_body = self GetTagAngles( "tag_body" );

		origin_main = self GetTagOrigin( level.huey_tag );

		direction_vec = VectorNormalize( origin_main - origin_body );
		dist = origin_main - origin_body;

		direction_vec = vector_scale( direction_vec, dist );

		new_origin = origin_body + direction_vec;
		new_angles = angles_body;

		forward_vec = AnglesToForward( new_angles );
		up_vec = AnglesToUp( new_angles );

		new_origin = new_origin + vector_scale( up_vec, 3 );

		// these are the fx model angles
		final_origin = new_origin - vector_scale( forward_vec, 4 );
		final_angles = new_angles;

		Record3DText( "huey_origin", new_origin + ( 0,0, 20 ), ( 1, 1, 1 ), "Script" );		
		recordLine( new_origin, new_origin + vector_scale( forward_vec, 100 ), ( 1, 1, 1 ), "Script", self );

		wait(0.05);
	}

}

print3d_on_ent( msg, offset )
{ 
	// recording also prints in real time.
	//Print3d( self.origin + ( 0, 0, offset ), msg );
	Record3DText( msg, self.origin + ( 0, 0, offset ), ( 1, 1, 1 ), "Script" );		
}

// --------------------------------------------------------------------------------
// ---- Debug line/cross functions ----
// --------------------------------------------------------------------------------

draw_debug_cross( point, endon_string )
{
	self endon( endon_string );

	while(1)
	{
		self drawDebugCrossSpecial( point , 1, ( 1, 1, 1 ), .6 );
		wait(0.05);
	}
}

debugLineSpecial(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		RecordLine( fromPoint, toPoint, color, "Script", self );
		wait (0.05);
	}
}

drawDebugCrossSpecial(atPoint, radius, color, durationFrames)
{
	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debugLineSpecial(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debugLineSpecial(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debugLineSpecial(atPoint_forward,	atPoint_back,	color, durationFrames);
}


debug_positions_in_heli()
{
		
	x=0;
	while(x < 180)
	{
		//huey origin is the same as the huey animation joint
		Debugstar(level.intro_huey.origin, 100, (0,1,0));//green
		Debugstar( level.intro_huey GetTagOrigin(level.huey_tag), 100, (1,1,1)); //white
		Debugstar(level.pilots[0].origin, 100, (1,1,0)); //yellow
		Debugstar(level.pilots[1].origin, 100, (1,0,0)); //red
		
		Debugstar(level.barnes.origin, 100, (0,0,0)); //black

		Debugstar(level.player.origin, 100, (0,0,1));	//blue
		
		Debugstar(level.intro_huey GetTagOrigin("tag_driver"), 100, (0,1,0));
		Debugstar(level.intro_huey GetTagOrigin("tag_passenger"), 100, (0,1,0));
		
		Debugstar(level.intro_huey.player_clip.origin, 100, (0,1,0));
	
		
		wait 1;
		x++;
	}
}


#/


/* --------------------------------------------------------------------------------
AUDIO SCRIPTS
----------------------------------------------------------------------------------*/

helo_audio_loopers()
{
	flag_wait( "player_woke_up" );
	
	//TUEY setmusic state to INTRO
	setmusicstate("INTRO");
	
	clientnotify( "hls" ); //Notifying the start of the Heli sequence

	// wait till we are ready to fall
	flag_wait("start_fall");
	playsoundatposition( "evt_s01_helo_fall", (0,0,0) );
	
	// waittill player is below the water, Colin just add your below water stuff here.
	flag_wait("player_below_water");
	clientnotify( "s01uw2" ); //Notifying the client that the Helicopter has dropped
	
	//TUEY Setting music state to Post INTRO.
	flag_wait("open_huey_door");

}

meatshield_fake_ai_conversation( delay )
{
	self endon( "meatshield_alerted" );
	level endon( "vcs_killed" );
	
	if( IsDefined( delay ) )
	{
		flag_wait( "player_woke_up" );
		wait(5);
	}
	
	while(1)
	{
		self play_fake_conversation();
		wait(RandomIntRange(1,9));
	}
}

play_fake_conversation()
{
	if( !IsDefined( level.meatshield_conversation ) )
		level.meatshield_conversation = false;
	
	fake_conversation = [];
	fake_conversation[0] = "_act_fragout";
	fake_conversation[1] = "_rspns_killfirm";
	fake_conversation[2] = "_rspns_lm";
	fake_conversation[3] = "_rspns_fragout";
	
	prefix = "dds_vc";
	ai = RandomIntRange(0,2);
	category = fake_conversation[RandomIntRange(0,3)];
	suffix = "_0" + RandomIntRange(0,4);
	alias = prefix + ai + category + suffix;
	
	if( level.meatshield_conversation == false )
	{
		level.meatshield_conversation = true;
		self PlaySound( alias, "sounddone" );
		self waittill( "sounddone" );
		wait(RandomFloatRange(1,3));
		level.meatshield_conversation = false;
	}
}

meatshield_audio_start()
{
	playsoundatposition( "evt_s01_meatshield_board", (0,0,0) );
	clientNotify( "meats" );
	setmusicstate( "MEAT_SHIELD" );
	flag_wait("meatshield_alerted");
	clientnotify( "meats2" );
	//playsoundatposition( "evt_s01_ms_push_body", (0,0,0) );
}

meatshield_struggle_vox()
{
	flag_wait("meatshield_alerted");
	//self PlaySound( "vox_ai_meatshield_struggle" );
}

meatshield_special_death_vox()
{
	if( !IsDefined( level.special_vox ) )
	{
		level.special_vox = [];
		level.special_vox[0] = "_00";
		level.special_vox[1] = "_01";
		level.special_vox[2] = "_02";
		level.special_vox[3] = "_03";
		level.special_vox[4] = "_04";
	}
	
	num = ( level.special_vox.size - 1 );
	
	if( num < 0 )
	{
	    num = 3;
	}
	
	suffix = level.special_vox[num];
	self PlaySound( "prj_bullet_impact_special" );
	PlaySoundatposition( ("vox_ms_special_death" + suffix), self.origin );
	
	level.special_vox = array_remove( level.special_vox, suffix );
}

play_sampan_motor_audio()
{
    self PlayLoopSound( "veh_sampan_run_loop", 1 );
    level waittill( "shut_off_boat" );
    self StopLoopSound( .25 );
    self PlaySound( "veh_sampan_shut_off" );
}

audio_event1_door_open()
{
	self endon( "death" );
	
	flag_wait( "start_crash_door" );
	
	self PlaySound( "evt_s01_door_start" );
	
	flag_wait( "huey_start_strength_test" );
	
	ent = Spawn( "script_origin", (0,0,0) );
	ent2 = Spawn( "script_origin", (0,0,0) );
	
	while( 1 )
	{
		ent PlayLoopSound( "vox_carter_door_strain" );
		ent2 PlayLoopSound( "evt_s01_door_strain" );
		
		wait( 0.05 );
		
		if( flag( "open_huey_door" ) )
		{
			break;
		}
	}
	
	ent StopLoopSound( .25 );
	ent2 StopLoopSound( .25 );
	
	ent PlaySound( "vox_carter_door_success" );
	ent2 PlaySound( "evt_s01_door_open" );
	playsoundatposition( "evt_num_num_02_r_louder" , (0,0,0) );
	
	wait(5);
	playsoundatposition( "chr_swim_stroke", (0,0,0) );
	ent Delete();
	ent2 Delete();
}
