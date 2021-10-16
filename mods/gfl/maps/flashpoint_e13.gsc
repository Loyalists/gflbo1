////////////////////////////////////////////////////////////////////////////////////////////
// 
// SHABS - ENDSLIDES
//
//-	Place VO (Shabs)
//-	Address texture streaming issues (Shabs)
//-	Add white bloom (Shabs)
//-	Hide camera lerps (Shabs)
//-	Address LOD pops (Shabs) 
////////////////////////////////////////////////////////////////////////////////////////////
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\flashpoint_util;
#include maps\flamer_util;


get_anim_struct_no_angles( name )
{	
	anim_struct = getstruct( name, "targetname" );
	anim_struct.angles = (0.0,0.0,0.0);
	return anim_struct;
}

event13_garage()
{

	//slide VO
	level thread slide_vo();
	create_fullscreen_cinematic_hud(0);

	wait 2.8;

	//static fx and fade in
	level.player SetClientDvar( "compass", "0" );
	play_bink_for_time("int_shocking_1", 0.1, 0.3, 0.3, 1);
	level.fullscreen_cin_hud.alpha = 0;
	wait 1.3;
	play_bink_for_time("int_number_field", 1.3, 0.4, 0.6, 0.6);
	wait 0.05;
	play_bink_for_time("flashpoint_number_flash_1", 0.1, 0.3);
	wait 0.7;
	play_bink_for_time("int_shocking_1", 0.5, 0.2, 0, 0.7);
	wait 0.2;
	thread white_bloom_in(0.3, 1.3, 1);
	wait 0.4;

	flag_wait( "setup_slides" );



	level.player DisableWeapons();
	level.player magic_bullet_shield();
	level.player.ignoreme = true;
	level.player FreezeControls(true);

	//turn off HUD
	level.player SetClientDvar( "compass", "0" );
	level.player SetClientDvar( "hud_showstance", "0" );
	level.player SetClientDvar( "actionslotshide" , "0" );

	level thread diorama06_read(); //heli pad
	level thread diorama01_read(); //glass room
	level thread diorama02_read(); //btr hijack
	level thread diorama03_read(); //btr firing limo
	level thread diorama04_read(); //limo on fire
//	level thread diorama05_read(); //CUT slide
	Objective_State( level.obj_num, "done" );


	
	level.player SetClientDvar( "cg_fov", 45 );

	flag_set( "start_dioramas" );
}

/*
	level.streamHintEnt_glass_room = createStreamerHint( (-11520, 56, -104), 1 ); //glass room
	level.streamHintEnt_heli_pad = createStreamerHint( (432, 1368, 424), 1 ); //heli pad
	level.streamHintEnt_btr_hijack = createStreamerHint( (-2860, -498, 326.3), 1 ); //btr_hijack
	level.streamHintEnt_btr_fire = createStreamerHint( (-2860, -498, 326.3), 1 ); //btr firing on limo
	level.streamHintEnt_crash_limo = createStreamerHint( (336.8, -4087.9, 388.8), 1 ); //burning limo
*/

///////////////////////////////////////////////////////////////////////////////////////
// Intro anim - self = player
///////////////////////////////////////////////////////////////////////////////////////
#using_animtree("flashpoint");
camera_anim( anim_node, anim_name )
{
	self.body = spawn_anim_model( "player_body", anim_node.origin );
	self PlayerLinktoAbsolute(self.body, "tag_player");
 
 	//spawn the player body
	anim_node thread anim_single_aligned( self.body, anim_name );
	anim_node waittill( anim_name );
	
	self Unlink();
	self.body Unlink();
	self.body Delete();
}

#using_animtree("generic_human");
diorama01_read() //glass room slide
{
	level.mason_victim = simple_spawn_single( "mason_victim" );
	level.gr_woods = simple_spawn_single( "gr_woods", ::init_gr_woods );
	level.gr_weaver = simple_spawn_single( "gr_weaver" );	
	level.gr_mason = simple_spawn_single( "gr_bowman", ::init_gr_mason );

	level.mason_victim.animname = "vc";
	level.gr_woods.animname = "woods";
	level.gr_weaver.animname = "weaver";
	level.gr_mason.animname = "mason";
	
	level.mason_victim.name = "";
	level.gr_woods.name = "";
	level.gr_weaver.name = "";
	level.gr_mason.name = "";

	//Get all AI into the correct pose
	anim_node = get_anim_struct_no_angles( "gr_woods_spot_2" );
	anim_node thread anim_first_frame( level.mason_victim, "diorama01" );
	anim_node thread anim_first_frame( level.gr_woods, "diorama01" );
	anim_node thread anim_first_frame( level.gr_weaver, "diorama01" );	
	anim_node thread anim_first_frame( level.gr_mason, "diorama01" );

	//Player camera
	flag_wait( "diorama01_go" );
	playsoundatposition( "evt_num_num_11_r" , (0,0,0) );
	
	SetSavedDvar( "r_lightTweakSunDirection", (-158.6, -108, 0) );
	
	stop_exploder( 50 );	// stops ambient effects that are in the diorama scenes
	exploder( 1310 );
 
	level.player SetClientDvar( "cg_fov", 75 );

	level.streamHintEnt_glass_room Delete();
	level.streamHintEnt_btr_hijack = createStreamerHint( (-2860, -498, 326.3), 1 ); //btr_hijack

	
	thread white_bloom_in(0.2, 0.2, 0.2);
	thread notify_delay("set_slide_1_dof", 0.2);
	//SetSavedDvar( "r_lightTweakSunDirection", (-28.0, 205.317, 0) );
	PlayFXOnTag( level._effect["slide_muzzle_flash"], level.gr_mason, "tag_flash" );
	PlayFXOnTag( level._effect["slide_muzzle_flash"], level.gr_weaver, "tag_flash" );

//	level.gr_mason thread playVO_proper( "slide_1", 1.0 );
	level.player camera_anim( anim_node, "diorama01" );
		
	thread play_bink_for_time("flashpoint_number_flash_1", 0.2, 0.4, 0, 1);
	thread white_bloom_in(0.05, 0.1);
	wait 0.05;
	level thread flashback_movie_play( 1.0 );
	flag_set( "diorama02_go" );

	level.fake_slide_heli_woods Delete();
	level.fake_slide_heli_krav Delete();

//	level thread wait_then_thread_static( 1 );
}

init_gr_mason()
{
	//swap to masons full body
	self Detach(self.headmodel, "");
	self SetModel( "t5_gfl_ump45_body" );
	self Attach( "t5_gfl_ump45_head" );
}

init_gr_woods()
{
	// self SetModel("c_usa_blackops_weaver_disguise_body" );
//	
//	//self Detach(self.headmodel, "");
	//self SetModel("c_usa_jungmar_barnes_disguise_headm" );
	// self Attach( "c_usa_jungmar_barnes_pris_head" );
}

diorama02_read() //btr hijack slide
{
	level.heli_woods = simple_spawn_single( "heli_woods", ::init_gr_woods );
	level.heli_woods.animname = "woods";
	level.heli_woods.name = "";

	//Get all AI into the correct pose
	anim_node = get_anim_struct_no_angles( "heli_camera" );
	anim_node thread anim_first_frame( level.heli_woods, "diorama02" );

	//Spawn vehicles
	heli_player_btr = spawn_vehicles_from_targetname( "heli_player_btr" )[0];
	heli_player_btr setbrake( 1 );
	
	//Spawn vehicles
	level.heli_limo_stream = spawn_vehicles_from_targetname( "heli_limo_stream" )[0];
	level.heli_limo_stream setbrake( 1 );

	//Player camera
	flag_wait( "diorama02_go" );
	stop_exploder( 1310 );
	exploder( 1320 );
//	level thread wait_then_thread_static( 1 );

	level.player SetClientDvar( "cg_fov", 45 );

	level.streamHintEnt_btr_hijack Delete();
	level.streamHintEnt_btr_fire = createStreamerHint( (-2860, -498, 326.3), 1 ); //btr firing on limo

	flashback_movie_play( 1.0 );
	level notify ("set_slide_2_dof");
	thread white_bloom_out(0, 0.1);
	PlayFXOnTag( level._effect["slide_muzzle_flash"], level.heli_woods, "tag_flash" );

//	level.gr_mason thread playVO_proper( "slide_2", 1.0 );
	level thread flashback_movie_play( 1.0 );
	level.player camera_anim( anim_node, "diorama02" );

	play_bink_for_time("flashpoint_number_flash_1", 0, 0.5, 0, 1);

	//level.player set_vision_set( "pentagon_kennedy_bloom" );
	thread white_bloom_in(0.5, 0.7);
	wait 1;
	flag_set( "diorama03_go" );
}

//[scrapper]] Whiteout at the end of the level. 
whiteout(time) //self == level 
{
	//hardcoded because I don't know how to get these? 
	base_exposure = 1.25;
	base_tint = 0;
	base_streak = 0.25;
	
	//hardcoded dest values
	exposure = 16;
	tint = 1;
	streak = 3;
	
	incs = int((time)/.05);
	
	inc_exp = ( exposure - base_exposure )/incs;
	inc_tint = ( tint - base_tint )/incs;
	inc_streak = ( streak - base_streak )/incs;
	
	curr_exposure = base_exposure;
	curr_tint = base_tint;
	curr_streak = base_streak;
	
	SetDvar( "r_bloomTweaks", "1" );
	SetDvar( "r_exposureTweak", "1" );
	
	for ( i=0; i<incs; i++ )
	{
		exposure_val = curr_exposure;
		tint_val = "" + curr_tint + " " + curr_tint + " " + curr_tint + " 1";
		streak_val = "" + curr_streak + " " + curr_streak + " " + curr_streak + " 1";
		
		setdvar( "r_exposureValue", exposure_val );
		setdvar( "r_bloomStreakXTint", tint_val );
		setdvar( "r_bloomStreakLevels0", streak_val );
		
		curr_exposure += inc_exp;
		curr_tint += inc_tint;
		curr_streak += inc_streak;
		
		wait .05;
	}
	
	//Add white fade to flesh out the bloom effect.


	//Now that the whitescreen is fully opaque, we can deactivate the bloom.
	//NOTE: must return Dvars to default before handing off to the next level!
	SetDvar( "r_bloomTweaks", "0" );
	SetDvar( "r_exposureTweak", "0" );
	
	//Let the whitescreen settle in before we move onto Flashpoint.
	wait 0.5;
}

diorama03_read() //btr firing at limo slide
{
	//Get all AI into the correct pose
	anim_node = get_anim_struct_no_angles( "compound_camera_end" );
	
	//Spawn vehicles
	compound_limo = spawn_vehicles_from_targetname( "compound_limo" )[0];
	compound_player_btr = spawn_vehicles_from_targetname( "compound_player_btr" )[0];
	compound_limo setbrake( 1 );
	compound_player_btr setbrake( 1 );
	
	compound_woods = simple_spawn_single( "compound_woods", ::init_compound_woods, compound_player_btr, compound_limo );

	btr_turret_target = GetEnt( "btr_turret_target", "targetname" );
	compound_player_btr SetGunnerTargetEnt( btr_turret_target, (0,0,0), 1 );

	burnt_limo_stream = GetEnt( "burnt_limo_stream", "targetname" );
	burnt_limo_stream Show();
	burnt_limo_stream Solid();

	//Player camera
	flag_wait( "diorama03_go" );
	stop_exploder( 1320 );
	exploder( 1330 );
	level clientNotify( "start_diorama_fx_3" );

	level.player SetClientDvar( "cg_fov", 45 );

	level.streamHintEnt_btr_fire Delete();
	level.streamHintEnt_crash_limo = createStreamerHint( (336.8, -4087.9, 388.8), 1 ); //burning limo

	level thread flashback_movie_play( 1.0 );
//	level thread wait_then_thread_static( 1 );

	//Objective_State( level.obj_num, "done" );
	PlayFXOnTag( level._effect["slide_muzzle_flash"], compound_player_btr, "tag_flash_gunner1" );

	level thread custom_fade_in_for_limo_slide();
	wait 0.3;
//	level.gr_mason thread playVO_proper( "slide_3", 1.0 );

	level.player camera_anim( anim_node, "diorama03" );
	level clientNotify( "end_diorama_fx_3" );

	play_bink_for_time("flashpoint_number_flash_1", 0, 0.5, 0, 1);
	thread white_bloom_in(0.7, 0.2, 0.5);
	wait( 1 );

	level.heli_limo_stream Delete();

	flag_set( "diorama04_go" );
	flashback_movie_play( 1.0 );
	//level thread wait_then_thread_static( 1 );

}

custom_fade_in_for_limo_slide()
{
	thread white_bloom_in(0.2, 0.2, 0.3);
}

wait_then_thread_static( time )
{
	wait( time );

	level thread flashback_movie_play( 1.0 );
}

diorama04_read() //limo crashed slide
{
	//Get all AI into the correct pose
	anim_node = get_anim_struct_no_angles( "limo_crash_camera" );
		
	limo_clean = GetEntArray( "limo_clean", "targetname" );
	array_func( limo_clean, ::self_delete );

	//shabs - turn on scorched script terrain patch
	limo_burn = GetEntArray( "limo_burn", "targetname" );
	array_func( limo_burn, ::show_limo_burn );

	crashed_limo = GetEnt( "crashed_limo", "targetname" );
	crashed_limo Show();

	//Player camera
	flag_wait( "diorama04_go" );
	stop_exploder( 1330 );
	exploder( 1340 );
	level clientNotify( "start_diorama_smoke" );

	level.player SetClientDvar( "cg_fov", GetDvarFloat( #"cg_fov_default") );
	thread play_bink_for_time("flashpoint_number_flash_1", 0.2, 1, 0, 0.6);
	level notify ("set_slide_4_dof");



	level.streamHintEnt_crash_limo Delete();

//	level.gr_woods thread playVO_proper( "slide_5", 1.0 );
//	level.gr_woods thread playVO_proper( "slide_4a", 1.0 );
//	level.gr_mason thread playVO_proper( "slide_4b", 3.0 );
//	level.gr_woods thread playVO_proper( "slide_4c", 6.0 );

	level thread wait_then_thread_static( 1 );

	level.player camera_anim( anim_node, "diorama04" );
	level clientNotify( "end_diorama_smoke" );

	thread cover_screen_in_black(5, 0.2);
	flashback_movie_play( 1.0 );
	level.cover_screen_in_black.foreground = true; //Arcade Mode compatible
	level.fullscreen_cin_hud Destroy();
	wait 3.5;
	nextmission();
}

show_limo_burn()
{
	self Show();
}

diorama06_read() //shabs - kravchenko slide, it's the first one now
{
	//helicopter
	last_slide_heli = spawn_vehicles_from_targetname( "last_slide_heli" )[0];
	last_slide_heli veh_toggle_tread_fx( 1 );

	//kravchenko
	//heli_pad_kravchenko = simple_spawn_single( "heli_pad_kravchenko" );
	//heli_pad_kravchenko.animname = "krav_slide";

	//helipad soldiers w/o guns
	guard_1 = simple_spawn_single( "guard_1" );
	guard_1.animname = "guard_1";

	guard_2 = simple_spawn_single( "guard_2" );
	guard_2.animname = "guard_2";

	guard_3 = simple_spawn_single( "guard_3" );
	guard_3.animname = "guard_3";

	//helipad soldiers w/ guns
	krav_guard_1 = simple_spawn_single( "krav_guard_1" );
	krav_guard_1.animname = "krav_guard_1";

	krav_guard_2 = simple_spawn_single( "krav_guard_2" );
	krav_guard_2.animname = "krav_guard_2";

	krav_guard_3 = simple_spawn_single( "krav_guard_3" );
	krav_guard_3.animname = "krav_guard_3";
	
	SetSavedDvar( "r_lightTweakSunDirection", (-159, -221.5, 0) );
	
	flag_wait( "start_dioramas" );

	if( IsDefined( level.fake_slide_krav ) && IsAlive( level.fake_slide_krav ) )
	{
		level.fake_slide_krav Delete();
	}

	if( IsDefined( level.fake_slide_woods ) && IsAlive( level.fake_slide_krav ) )
	{
		level.fake_slide_woods Delete();
	}

	stop_exploder( 1350 );
	exploder( 1360 );

	thread flashback_movie_play( 1.0 );
	level notify ("set_slide_6_dof");
	wait 0.3;
	
	if( IsDefined( level.streamHintEnt_heli_pad ) )
	{
		level.streamHintEnt_heli_pad Delete();
	}
	level.streamHintEnt_glass_room = createStreamerHint( (-11520, 56, -104), 1 ); //glass room

	//Get all AI into the correct pose
	anim_node = get_anim_struct_no_angles( "diorama_06_align_struct" );

	//anim_node thread anim_first_frame( heli_pad_kravchenko, "diorama06" );

	anim_node thread anim_first_frame( guard_1, "diorama06" );
	anim_node thread anim_first_frame( guard_2, "diorama06" );
	anim_node thread anim_first_frame( guard_3, "diorama06" );

	anim_node thread anim_first_frame( krav_guard_1, "diorama06" );
	anim_node thread anim_first_frame( krav_guard_2, "diorama06" );
	anim_node thread anim_first_frame( krav_guard_3, "diorama06" );
	
	diorama_anim_time = GetAnimLength(level.scr_anim["player_body"]["diorama06"]);
	thread play_bink_for_time("int_number_field", 0.5, diorama_anim_time, 0.5, 0.5);
	level.player camera_anim( anim_node, "diorama06" );
	//level thread flashback_movie_play( 1.0 );
	flag_set( "diorama01_go" );
	//level thread flashback_movie_play( 1.0 );
}

init_fake_slide_heli_woods()
{
	self endon( "death" );

	self thread maps\flashpoint_e13::init_gr_woods();

	self SetGoalPos( self.origin );

	self.name = "";
	self gun_remove();
	self disable_pain();
	self disable_react();
	self.ignoreme = true;	
	self.ignoreall = true;
	self thread magic_bullet_shield();
}

fake_slide_heli_krav()
{
	self endon( "death" );

	self SetGoalPos( self.origin );

	self.name = "";
	self gun_remove();
	self disable_pain();
	self disable_react();
	self.ignoreme = true;	
	self.ignoreall = true;
	self thread magic_bullet_shield();
}


init_compound_woods( btr, limo )
{
	self endon( "death" );

	self thread init_gr_woods();

	self magic_bullet_shield();
	self enter_vehicle( btr, "tag_gunner1" );
}

init_escape_shot_woods( btr )
{
	self endon( "death" );
	self magic_bullet_shield();
	self enter_vehicle( btr, "tag_gunner1" );
}

fade_in( time, delay_time )
{
	if( isdefined( delay_time ) )
	{
		wait( delay_time );
	}

	if( !isdefined( level.fade_out_overlay ) )
	{
		level.fade_out_overlay = NewHudElem();
		level.fade_out_overlay.x = 0;
		level.fade_out_overlay.y = 0;
		level.fade_out_overlay.horzAlign = "fullscreen";
		level.fade_out_overlay.vertAlign = "fullscreen";
		level.fade_out_overlay.foreground = false;  // arcademode compatible
		level.fade_out_overlay.sort = 50;  // arcademode compatible
		level.fade_out_overlay SetShader( "black", 640, 480 );
	}

	level.fade_out_overlay.alpha = 1;

	level.fade_out_overlay fadeOverTime( time );
	level.fade_out_overlay.alpha = 0;
	wait( time );
}

slide_vo()
{

	//flag_wait( "start_r45" );

	interrogator_ent = Spawn("script_origin", level.player.origin);
	interrogator_ent LinkTo(level.player );
	interrogator_ent.animname = "interrogator";

	wait( 2.5 );

	level.woods thread playVO_proper( "get_outta_here" ); //Okay. Time we got the hell out of here.

	level.player thread playvo_proper( "not_yet", 2.3 ); //Not yet...

	level.player thread playvo_proper( "after_drago", 2.5 ); //We're going after Dragovich.

	//interrogator
	interrogator_ent thread playvo_proper( "losing_him", 4.3 ); //We're losing him again.

	//level thread flashback_movie_play( 1.0 );

	//interrogator
	interrogator_ent thread playvo_proper( "stay_with_me", 4.4 ); //Stay with me Mason.

	//level thread wait_then_thread_static( 1 );

	wait( 1 );

	//level thread flashback_movie_play( 1.0 );

	level.player thread playvo_proper( "krav_escaped", 8 ); //Kravchenko escpaed before we could get to him.

	//interrogator
	interrogator_ent thread playvo_proper( "you_were_getting_close", 10 ); //You were getting close. Dragovich was there, wasn't he?

	level.player thread playvo_proper( "searched_base", 13 ); //We searched the whole base. We couldn't find the bastard anywhere.

	//interrogator
	interrogator_ent thread playvo_proper( "waste_of_time", 16 ); //This is a waste of time. He's delusional.

	//level.player playVO_proper( "slide_2" ); //stole btr

	level.player thread playvo_proper( "ran_into_limo", 18.5 ); //But then we ran into Dragovich's limo. I had him.

	level.woods thread playVO_proper( "satisfied_mason", 21.7 ); //Satisfied, Mason?

	level.player thread playvo_proper( "no_no_no", 22.3 ); //NO! No, not yet... Not until I see the body.

	//interrogator
	interrogator_ent thread playvo_proper( "confirm_drago_kill", 26 ); //Dragovich. Did. You. Confirm. The kill.

	level.woods thread playVO_proper( "charcoal_briquette", 30 );//Trust me... That rat bastard's a fucking charcoal briquette.
}

/*

    level.scr_sound["woods"]["get_outta_here"] = "vox_fla1_s09_255A_wood"; //Okay. Time we got the hell out of here.

    level.scr_sound["mason"]["not_yet"] = "vox_fla1_s09_270A_maso"; //Not yet...

    level.scr_sound["mason"]["after_drago"] = "vox_fla1_s09_271A_maso"; //We're going after Dragovich.

    level.scr_sound["Interrogator"]["losing_him"] = "vox_fla1_s01_811A_inte"; //We're losing him again.

    level.scr_sound["Interrogator"]["stay_with_me"] = "vox_fla1_s01_812A_inte"; //Stay with me Mason.

    level.scr_sound["mason"]["krav_escaped"] = "vox_fla1_s01_808A_maso"; //Kravchenko escpaed before we could get to him.

    level.scr_sound["Interrogator"]["you_were_getting_close"] = "vox_fla1_s01_813A_inte"; //You were getting close. Dragovich was there, wasn't he?

    level.scr_sound["mason"]["searched_base"] = "vox_fla1_s01_807A_maso"; //We searched the whole base. We couldn't find the bastard anywhere.

    level.scr_sound["Interrogator"]["waste_of_time"] = "vox_fla1_s01_814A_inte"; //This is a waste of time. He's delusional.

    level.scr_sound["mason"]["ran_into_limo"] = "vox_fla1_s01_807C_maso"; //But then we ran into Dragovich's limo. I had him.

    level.scr_sound["Woods"]["satisfied_mason"] = "vox_fla1_s09_317A_wood"; //Satisfied, Mason?

    level.scr_sound["Mason"]["no_no_no"] = "vox_fla1_s09_318A_maso"; //NO! No, not yet... Not until I see the body.

    level.scr_sound["Interrogator"]["confirm_drago_kill"] = "vox_fla1_s01_815A_inte"; //Dragovich. Did. You. Confirm. The kill.

	level.scr_sound["woods"]["charcoal_briquette"] 	= "vox_fla1_s09_320A_wood"; //Trust me... That rat bastard's a fucking charcoal briquette.

*/