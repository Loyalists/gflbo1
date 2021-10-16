#include maps\_utility;
#include common_scripts\utility;
#include maps\wmd_sr71_util;
#include maps\_anim;
#include maps\_music;


main()
{
	SetSavedDvar( "r_skyTransition", 1 );	
	
	level notify("set_runway_fog");
	
	//hide the temp camera reticule
	reticule = ent_get("cam_reticule");
	reticule hide();

	player = GetPlayers()[0];
	player CameraActivate(false);
	OnSaveRestored_Callback( ::wmd_intro_cleanup );
		
	sr71_intro();
	sr71_rts();
	
	// Commented out for Demo - jpark
	//snow_ambush();	
	//setup_post_ambush();
	//wait_for_player_to_hookup();
	//breach_power_building();
	//use_sr71_cam_relaystation();	
}

wmd_intro_cleanup()
{
	player = GetPlayers()[0];
	player CameraActivate(false);
}

/*------------------------------------------------------------------------
SR71 TAKEOFF
------------------------------------------------------------------------*/

sr71_intro()
{
	//kicks off the intro
	setMusicstate("INTRO_SR71");
	level.sunAng = GetDvar( #"r_lightTweakSunDirection" ); //runway
	level.sunSampleSize = GetDvar( #"sm_sunSampleSizeNear" );
	SetSavedDvar("sm_sunSampleSizeNear", 0.55 );
	SetSavedDvar("r_lightTweakSunDirection", (-115.263, -176.677, 0) ); //runway
	
	// the intro up to the takeoff is handled in the vehicle spawn func
	add_spawn_function_veh( "sr71", ::setup_sr71_runway_intro );
	spawn_sr71();

		
	//waits for the player to take off in the sr71
	level thread track_takeoff_node();
	level thread wait_for_player_to_fail_takeoff();
	
	
	flag_wait("takeoff_complete");
	
	// ENTER EARTH CURVATURE
	sr71_earth_curvature_intro();
	
	//rts sequence...
	
}

sr71_rts()
{
	maps\wmd_rts::main();
	
	flag_wait("rts_done");
	player = GetPlayers()[0];
	player AllowCrouch( true );
	player AllowJump(true);
	player AllowLean(true);
	player AllowMelee(true);
	player AllowSprint(true);

	// ENTER RTS...i think...
	autosave_by_name("wmd_sr71ambush");
	
	//spawn the guards in the scene ther player will see thru the SR71 camera
	//level thread spawn_ambush_guys();	 
	
	//put the player in the camera operators seat
	
	//player setclientdvar("compass",0);
	//player unlink();
	//sr71 link_player_to_sr71("passenger");
	
	// player uses the camera to locate the squad
	//use_sr71_camera();
	
	//level notify("sr71_test");
		
	//stop the camera loop sound
	player stoploopsound(2);
	player.playing_loop = false;
	
	//sound snapshot
	clientnotify ("gtg");
	
	custom_fade_screen_out( "white", 5 );
	player SetClientDvar( "compass", 1);
	player setClientDvar( "cg_fov", 65 );
	
	player SetClientDvar( "waypointOffscreenPadLeft", "40" );
	player SetClientDvar( "waypointOffscreenPadRight", "0" );
	player SetClientDvar( "waypointOffscreenPadTop", "0" );
	player SetClientDvar( "waypointOffscreenPadBottom", "30" );
	
	player SetClientDvar( "cg_defaultFadeScreenColor", "1 1 1 0" );
	
	
	if(GetDVarInt("wmd_rts_achievement") == 1)
	{
		player giveachievement_wrapper( "SP_LVL_WMD_RSO" );
	}
	
	// end the level
	nextmission();
}


spawn_sr71()
{	
	flag_wait("all_players_connected");
	
	trigger_use("spawn_sr71");
	
	wait(1.0);
	
	trigger_use("spawn_trucks");	
	
	wait(8.0);
	
	trigger_use("move_trucks");	
}

do_runway_visionsets( body )
{
	VisionSetNaked("wmd_runway", 0);
	
	body waittillmatch( "single anim", "canopy_shut_start" );
	
	VisionSetNaked( "wmd_pilot", 2 );
	
	flag_wait( "camera_cut_1" );
	
	VisionSetNaked( "wmd_takeoff", 0 );
	
	flag_wait( "camera_cuts_done" );
	
	VisionSetNaked( "wmd_pilot", 0 );
	
	flag_wait( "begin_gforce" );
	
	VisionSetNaked( "wmd_gforce", 2.75 );
	clientnotify("start_superflare");
	
	level waittill( "liftoff_begin" );
	//flag_wait("takeoff_complete");
	
	VisionSetNaked( "wmd_runway", 5 );
	
	clientnotify("end_superflare");
}

setup_sr71_runway_intro()
{

	self.cockpit = spawn("script_model",self.origin);
	self.cockpit.angles = self.angles;
	self.cockpit setmodel("t5_veh_jet_sr71_cockpit");
	
	self.cockpit linkto(self,"tag_origin");
	
	self useanimtree(level.scr_animtree["sr71"]);
	self.animname = "sr71";
	
	PlayFXOnTag( level._effect["blackbird_wheel_light"], self, "tag_origin" );

	// Spawn the player body
	body = spawn_anim_model( "player_pilot_body" , self.origin, self.angles);
	body UseAnimTree(level.scr_animtree["player_body"] );
	body.animname = "player_pilot_body";
	
	//send client notify to change snapshot	
	clientnotify ("first_snap_on");

	// Spawn the 3rd person player body
	//body_3rdPerson = spawn_anim_model( "player_sr71_3rdPerson_full_body" , self.origin, self.angles);
	//body_3rdPerson UseAnimTree(level.scr_animtree["player_body"] );
	//body_3rdPerson.animname = "player_sr71_3rdPerson_full_body";
	//body_3rdPerson LinkTo(body);
	//body_3rdPerson Hide();

	// Assimilate with player
	player = get_players()[0];
	player PlayerLinkToDelta(body, "tag_player", 1, 15, 15, 25, 15);
	player HideViewModel();
	player.body = body;
	//player.body_3rdPerson = body_3rdPerson;
	
	player.body Attach( "t5_veh_jet_sr71_flightstick", "tag_weapon" );
	
	self anim_first_frame(player.body, "sr71_intro");	
	player SetPlayerAngles(body.angles);

	// Turn off a bunch of stuff
	player SetClientDvar("compass",0);
	player SetClientDvar( "compass", "0" );
	player SetClientDvar( "hud_showstance", "0" );
	player SetClientDvar( "actionSlotsHide", "1" );
	player SetClientDvar( "ammoCounterHide", "1" );  
	player SetClientDvar( "r_stereo3DFixGunFocus", 0);               
	SetSavedDvar( "aim_view_sensitivity_override", "0.4" );

	player DisableWeapons();
//	player set_player_stances(false,false,false);
	player AllowJump(false);
	player AllowLean(false);
	player AllowMelee(false);
	player AllowSprint(false);
	
	wait(0.2);

	level clientNotify( "toggle_flight_helmet" );



	//start sr71 sounds

	
//	self.exterior_idle_sound_ent = spawn("script_origin" , self.origin);
//	self.exterior_idle_sound_ent PlayLoopSound("veh_sr71_wait_loop_front");
	
	
//	self.interior_idle_sound_ent = spawn("script_origin" , self.origin);
//  self.interior_idle_sound_ent PlayLoopSound("veh_sr71_wait_loop_front");

	//rso_operator = GetEnt( "sr71_rso", "script_noteworthy" );
	//rso_operator SetLookAtText( "Thomas", &"WMD_COPILOT_RANK" );

	// TEST...fire off new animation
	anim_array = array(body, self);

	// Spawn the different crew groups
	crew_structs_player = getstructarray("sr71_crew_group_player", "targetname");
	crew_structs_A = getstructarray( "sr71_crew_group_A", "targetname" );
	crew_structs_B = getstructarray( "sr71_crew_group_B", "targetname" );
	crew_structs_C = getstructarray( "sr71_crew_group_C", "targetname" );
	crew_structs_D = getstructarray( "sr71_crew_group_D", "targetname" );
	
	crew_group_player = [];
	crew_group_A = [];
	crew_group_B = [];
	crew_group_C = [];
	crew_group_D = [];
	
	crew_count = 0;
	
	//level thread move_intro_vehicles();
	
	for( i = 0; i < crew_structs_player.size; i++ )
	{
		crew_member = spawn_anim_model( crew_structs_player[i].script_noteworthy, crew_structs_player[i].origin, crew_structs_player[i].angles );
		if( crew_structs_player[i].script_noteworthy != "sr71_rso" )
		{
			crew_member give_me_my_head();
		}
		else
		{
			crew_member MakeFakeAI();
			crew_member SetLookAtText( "Maj. Neitsch", &"" );
		}
		crew_group_player = array_add( crew_group_player, crew_member );
		crew_count++;
	}
	

	for( i = 0; i < crew_structs_A.size; i++ )
	{
		crew_member = spawn_anim_model( crew_structs_A[i].script_noteworthy, crew_structs_A[i].origin, crew_structs_A[i].angles  );
		crew_member give_me_my_head();
		crew_group_A = array_add( crew_group_A, crew_member );
		crew_member Attach( "anim_glo_clipboard_wpaper", "tag_inhand" );
		crew_count++;
	}
	
	for( i = 0; i < crew_structs_B.size; i++ )
	{
		crew_member = spawn_anim_model( crew_structs_B[i].script_noteworthy, crew_structs_B[i].origin, crew_structs_B[i].angles  );
		crew_member give_me_my_head();
		crew_group_B = array_add( crew_group_B, crew_member );
		crew_count++;
	}
	
	for( i = 0; i < crew_structs_C.size; i++ )
	{
		crew_member = spawn_anim_model( crew_structs_C[i].script_noteworthy, crew_structs_C[i].origin, crew_structs_C[i].angles  );
		crew_member give_me_my_head();
		crew_group_C = array_add( crew_group_C, crew_member );
		crew_count++;
	}
	
	for( i = 0; i < crew_structs_D.size; i++ )
	{
		crew_member = spawn_anim_model( crew_structs_D[i].script_noteworthy, crew_structs_D[i].origin, crew_structs_D[i].angles  );
		crew_member give_me_my_head();
		crew_member Hide();
		crew_group_D = array_add( crew_group_D, crew_member );
		crew_count++;
	}

	level.last_crew_member = crew_group_D[0];

	Assert( IsDefined( level.last_crew_member ) );
	
	level thread do_runway_visionsets( player.body );

	//level waittill( "screen_fade_in_begins" );
	flag_wait( "starting final intro screen fadeout" );
	
	level thread maps\wmd_sr71_amb::play_sr71_surround_track();
	
	level notify ("start_SR71_walkup_tracks");
	
	level notify("set_runway_dof");
	
	level notify( "fuel_hose_start" );
	
	// Spin off our group threads
	self thread sr71_crew_group_anim(crew_group_player, "sr71_intro");
	self thread sr71_crew_group_anim(crew_group_A, "sr71_intro");
	self thread sr71_crew_group_anim(crew_group_B, "sr71_intro");
	self thread sr71_crew_group_anim(crew_group_C, "sr71_intro");
	self thread wait_sr71_crew_group_anim( player.body, "single anim", "start_captain", crew_group_D, "sr71_intro" );

	/*
	array_thread( crew_group_player, ::print_who_i_am_on_my_eye );
	array_thread( crew_group_A, ::print_who_i_am_on_my_eye );
	array_thread( crew_group_B, ::print_who_i_am_on_my_eye );
	array_thread( crew_group_C, ::print_who_i_am_on_my_eye );
	array_thread( crew_group_D, ::print_who_i_am_on_my_eye );
	*/

	// Group player 
	self anim_single_aligned(anim_array, "sr71_intro");	

	// Link the player to the seat
	self link_player_to_sr71("driver");

	// Link copilot to plane
	copilot = self link_pilot_to_sr71("passenger", "sr71_rso_idle");
	self.copilot = copilot;
	
	// Play the idle animation on the player
	cockpit_idle = level.scr_anim["player_pilot_body"]["sr71_cockpit_idle"][0];

	level notify( "delete intro vehicles" );

	player.body SetAnimKnob(cockpit_idle, 1);
	player.body SetAnim( level.scr_anim["player_pilot_body"]["sr71_cockpit_neutral"], 1 );	
	//player.body_3rdPerson thread anim_loop(player.body_3rdPerson, "sr71_cockpit_idle");

	player.body StopAnimScripted();
	
	player StartCameraTween(1.5);
	player SetPlayerAngles((12, 90, 0));

	// start into the take off
	self thread sr71_takeoff();
	
	//kicks off the intro
	setMusicstate("INTRO_SR71");
}

give_me_my_head() //-- self == headless crew guy
{
	if( self.animname == "sr71_crew1" )
	{
		self Attach( "t5_gfl_p90_head");
		self Attach( "t5_gfl_p90_hair");
	}
	
	else if( self.animname == "sr71_crew2" )
	{
		self Attach( "t5_gfl_m1903_head");
		self Attach( "t5_gfl_m1903_hair");
	}
	
	else if( self.animname == "sr71_crew3" )
	{
		self Attach( "t5_gfl_rfb_head");
		self Attach( "t5_gfl_rfb_hair");
	}
	
	else if( self.animname == "sr71_crew4" )
	{
		self Attach( "t5_gfl_suomi_head");
	}
	
	else if( self.animname == "sr71_crew5" )
	{
		self Attach( "t5_gfl_9a91_head");
		self Attach( "t5_gfl_9a91_hair");
	}
	
	else if( self.animname == "sr71_crew6" )
	{
		self Attach( "t5_gfl_ppsh41_head");
		self Attach( "t5_gfl_ppsh41_hair");
	}
	
	else if( self.animname == "sr71_crew7" )
	{
		self Attach( "t5_gfl_type97_head");
		self Attach( "t5_gfl_type97_hair");
	}
	
	else if( self.animname == "sr71_crew8" )
	{
		self Attach( "t5_gfl_9a91_head");
		self Attach( "t5_gfl_9a91_hair");
	}
	//else
	//{
	//	my_head = RandomInt(4) + 1;
	//	self Attach( "c_usa_sr71_groundcrew_head" + my_head);
	//}
}

print_who_i_am_on_my_eye()
{
	self endon("death");
	while(1)
	{
		Print3D( self GetTagOrigin("tag_eye"), self.animname);
		wait(0.05);
	}
}


do_inflight_visionsets( hands, body )
{
	VisionSetNaked( "wmd_sr71", 0 );
	
	body waittillmatch( "single anim", "precut_blur" );
	
	VisionSetNaked( "wmd_jumpcut", 0.5 );
	
	body waittillmatch( "single anim", "jumpcut" );
	/*
	VisionSetNaked( "wmd_pilot", 0.5 );
	
	level waittill( "jumpcut_to_space" );
	
	VisionSetNaked( "wmd_jumpcut", 0.5 );
	
	wait( 0.5 );
	
	VisionSetNaked( "wmd_sr71", 2 );
	
	hands waittillmatch( "single anim", "precut_blur" );
	
	VisionSetNaked( "wmd_jumpcut", 0.25 );
	
	hands waittillmatch( "single anim", "space2backin" );
	*/
	VisionSetNaked( "wmd_sr71cam", 0.5 );
	
	//VisionSetNaked( "wmd_sr71cam", 0.25 );
}

adjust_earth_height()
{
	urf = GetEnt( "earth_cylinder", "targetname" );
	urf_baseheight = urf.origin;
	
	while( 1 )
	{
		if( GetDvar( "curve_tweaks" ) == "1" )
		{
			urf.origin = (urf_baseheight[0], urf_baseheight[1], urf_baseheight[2]+GetDvarFloat( "curve_earth_height"));
		}
		wait( 0.05 );
	}
}

transitional_dialogue(ent, time)
{
	wait(time - 3.5);
	
	ent anim_single( ent, "030A_huds");//	Bigeye this is Kilo One requesting tactical recon, over. Repeat, we can't see anything down here.
	flag_set("sr71_dialogue_done");
}

sr71_earth_curvature_intro()
{
	level notify("set_curvature_fog");	
	
	//init the RSO screen since we can see it much earlier now
	cam = Getent("rts_extracam", "targetname");		
	cam.Angles = ( 70,0, 0);
	cam Setclientflag(1);
	//cam SetClientFlag(8);
	screen = ent_get("sr71_cam");
	screen SetClientFlag(5);	
	
	
	level thread do_inflight_dialogue();

	SetDvar( "curve_tweaks", 0 );
	SetDvar( "curve_earth_height", 0 );
	
	level thread adjust_earth_height();

	SetSunLight(0.880242,0.873514,0.951008);

	//cut to sr71 in flight. curvature of the earth is shown
	//player transitions from the pilot to the camera operator		
	sr71 = ent_get("sr71_cam");
	sr71 Attach( "t5_veh_jet_sr71_gear_doors", "tag_origin" );
	urf = GetEnt( "earth_cylinder", "targetname" );
	
	sr71.cockpit = spawn("script_model",sr71.origin);
	sr71.cockpit setmodel("t5_veh_jet_sr71_cockpit");
	sr71.cockpit.angles = sr71.angles;	
	sr71.cockpit linkto(sr71,"tag_origin");
	
	sr71 HidePart( "tag_landinggear_Front_Wheel" );
//	sr71.animname = "sr71";
	sr71 UseAnimTree(level.scr_animtree["sr71"]);
	sr71 thread show_engine_exhaust();
	sr71._og_origin = sr71.origin;
	sr71._og_angles = sr71.angles;
	//sr71 thread anim_loop(sr71, "sr71_landing_gear_up", "stop looping", "sr71");
	
	//sound stuff
	sr71.sr71_run_sound_ent = spawn("script_origin", sr71.origin);
	sr71.sr71_run_sound_int_ent = spawn("script_origin", sr71.origin);
	
	//start run sounds
	sr71.sr71_run_sound_ent linkto(sr71);
	sr71.sr71_run_sound_ent playloopsound("veh_sr71_run_ext");	
	
	sr71.sr71_run_sound_int_ent linkto(sr71);
	sr71.sr71_run_sound_int_ent playloopsound("veh_sr71_run_int");	
	
	sr71.sr71_tail_sound_r_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_r"));
	sr71.sr71_tail_sound_r_ent linkto(sr71, "tag_engine_r");
	//sr71.sr71_tail_sound_r_ent playloopsound ("veh_sr71_rocket_ext");
	
	sr71.sr71_tail_sound_l_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_l"));
	sr71.sr71_tail_sound_l_ent linkto(sr71, "tag_engine_l");
	//sr71.sr71_tail_sound_l_ent playloopsound ("veh_sr71_rocket_ext");
	
	sr71.sr71_tail_sound_r_int_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_r"));
	sr71.sr71_tail_sound_r_int_ent linkto(sr71, "tag_engine_r");
	sr71.sr71_tail_sound_r_int_ent playloopsound ("veh_sr71_rocket_int");
	
	sr71.sr71_tail_sound_l_int_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_l"));
	sr71.sr71_tail_sound_l_int_ent linkto(sr71, "tag_engine_l");
	sr71.sr71_tail_sound_l_int_ent playloopsound ("veh_sr71_rocket_int");	

	// Unlink Player from Delta and make Absolute
	player = get_players()[0];
	player UnLink();

	// delete the old body
	if (IsDefined(player.body))
	{
		player.body delete();
	}

	// Get the driver seat info
	tag_origin = sr71 GetTagOrigin("tag_driver");
	tag_angles = sr71 GetTagAngles("tag_driver");

	// spawn a new player full body
	body = spawn_anim_model( "player_pilot_body" , tag_origin, tag_angles);
	body UseAnimTree(level.scr_animtree["player_body"] );
	body.animname = "player_pilot_body";

	hands = spawn_anim_model("player_pilot_hands", tag_origin, tag_angles);
	hands UseAnimTree(level.scr_animtree["player_pilot_hands"]);
	hands.animname = "player_pilot_hands";

	player.body = body;
	player.body Hide();
	player PlayerLinkToAbsolute(player.body, "tag_player");

	player.pilot_hands = hands;
	player.pilot_hands Hide();

	level thread do_inflight_visionsets( player.pilot_hands, player.body );

	// Create/Link Pilot/Copilot
	pilot = sr71 link_pilot_to_sr71("driver", "sr71_cockpit_look", false );
	sr71.pilot = pilot;

	copilot = sr71 link_pilot_to_sr71("passenger", "sr71_rso_idle");
	sr71.copilot = copilot;

	// save this off here
	//cockpit_idle = level.scr_anim["player_sr71_3rdPerson_full_body"]["sr71_cockpit_idle"][0];

	// Fade in!
	level thread custom_fade_screen_in(2);
	
	level notify( "inflight_cut_1" );
	
	// Set wide FOV
	player setClientDvar( "cg_fov", 77 );	
	

	//Turn On something in the 3d
//	level thread maps\wmd_rts::create_radar_waypoint(getent("rts_radar","targetname"));
	

//	Cam = Getent("rts_extracam", "targetname");		
//	Cam.Angles = ( 70,0, 0);	
//	Cam Setclientflag(1);
//	wait(.1);
//	cam SetClientFlag(8);

	// Play the far cam shot
	sr71 thread anim_single_aligned(player.body, "trans_cam1");
	anim_length = GetAnimLength(level.scr_anim["player_pilot_body"]["trans_cam1"]);
	sr71 thread transitional_dialogue(body, anim_length);
	
	/*
	player.body waittillmatch( "single anim", "jumpcut" );
	
	
	urf_baseorigin = urf.origin;
	urf.origin = urf.origin + (0, 0, 2001);
	level clientNotify( "toggle_flight_helmet" );
	level notify( "inflight_in_cockpit" );
	sr71.pilot Hide();
	player.body Show();

	player.body waittillmatch( "single anim", "end" );

	// Link the new body to plane
	sr71 link_player_to_sr71("driver");
	player.body Attach( "t5_veh_jet_sr71_flightstick", "tag_weapon" );
	player.body SetAnim(level.scr_anim["player_pilot_body"]["sr71_cockpit_idle"][0], 1);

	// Show the body and Relink
	player UnLink();
	player Playerlinktodelta(player.body, "tag_player", 1, 55, 55, 45, 15);
	
	wait(8.5);
	while( GetDvar( "curve_tweaks" ) == "1" )
	{
		wait( 0.05 );
	}
	urf.origin = urf_baseorigin;
	level clientNotify( "toggle_flight_helmet" );
	level notify( "jumpcut_to_space" );
	wait( 0.5 );
	
	*/
	sr71 waittill( "trans_cam1" );		
	sr71.copilot Hide();
	
	// Play the transition
	player UnLink();
	player PlayerLinkToAbsolute(player.pilot_hands, "tag_player");
	/*
	sr71 thread anim_single_aligned(player.pilot_hands, "trans_cam2");
	urf.angles = urf.angles + (0, 50, 0);
	
	wait( 0.1 );
	
	//client notify for sound
	level notify( "inflight_cut_2" );
	clientnotify ("space_go_outside");

	// Hide show bodies
	player.body Hide();
	sr71.pilot Show();
	*/
	//SetSavedDvar( "r_lightTweakSunDirection", level.sunAng ); //before sro
	SetSavedDvar( "r_lightTweakSunDirection", (-160, -48, 0) );
	
	//level thread do_sro_intro_dialogue();	

	//sr71 waittill("trans_cam2");	
}
sr71_sound_start_post_safehouse()
{
	sr71 = ent_get("sr71_cam");
	
	//sound stuff
	sr71.sr71_run_sound_ent = spawn("script_origin", sr71.origin);
	sr71.sr71_run_sound_int_ent = spawn("script_origin", sr71.origin);
	
	//start run sounds
	sr71.sr71_run_sound_ent linkto(sr71);
	sr71.sr71_run_sound_ent playloopsound("veh_sr71_run_ext");	
	
	sr71.sr71_run_sound_int_ent linkto(sr71);
	sr71.sr71_run_sound_int_ent playloopsound("veh_sr71_run_int");	
	
	sr71.sr71_tail_sound_r_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_r"));
	sr71.sr71_tail_sound_r_ent linkto(sr71, "tag_engine_r");
	//sr71.sr71_tail_sound_r_ent playloopsound ("veh_sr71_rocket_ext");
	
	sr71.sr71_tail_sound_l_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_l"));
	sr71.sr71_tail_sound_l_ent linkto(sr71, "tag_engine_l");
	//sr71.sr71_tail_sound_l_ent playloopsound ("veh_sr71_rocket_ext");
	
	sr71.sr71_tail_sound_r_int_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_r"));
	sr71.sr71_tail_sound_r_int_ent linkto(sr71, "tag_engine_r");
	sr71.sr71_tail_sound_r_int_ent playloopsound ("veh_sr71_rocket_int");
	
	sr71.sr71_tail_sound_l_int_ent = spawn("script_origin", sr71 gettagorigin("tag_engine_l"));
	sr71.sr71_tail_sound_l_int_ent linkto(sr71, "tag_engine_l");
	sr71.sr71_tail_sound_l_int_ent playloopsound ("veh_sr71_rocket_int");
	
	
	
}
play_intro_dialog_line( who, alias, wait_time )
{
	if( !IsDefined( wait_time ) )
	{
		wait_time = 1;
	}
	player = get_players()[0];

	if( IsDefined(level.scr_sound[alias]) )
	{
		player PlaySound( level.scr_sound[alias], "sounddone" );
		player waittill( "sounddone" );
	}
	else
	{
		if( IsDefined( level.dialogue[alias] ) )
		{
			add_dialogue_line( who, level.dialogue[alias] );
		}
		else
		{
			add_dialogue_line( who, "***MISSING LINE***" );
		}
		wait( wait_time );
		player notify( "sounddone" );
	}
}

do_preflight_dialogue()
{
	level endon( "liftoff_fail" );
	
	//do_pre_engine_dialog();
	
	level waittill( "camera_cuts_done" );
	
	sr71 = GetEnt("sr71", "targetname");
	
	sr71 anim_single(sr71, "010A_usc1_f" );
	sr71 anim_single(sr71, "011A_usc3_f" );
	sr71 anim_single(sr71, "013A_usc2_f" );
	sr71 anim_single(sr71, "012A_usc1_f" );
/*	play_intro_dialog_line( "Pilot", "010A_usc1_f" );
	play_intro_dialog_line( "Control", "011A_usc3_f" );
	play_intro_dialog_line( "Copilot", "013A_usc2_f" );
	play_intro_dialog_line( "Pilot", "012A_usc1_f" ); */
	
	level notify( "speed_checks_done" );
	
	flag_wait( "begin_gforce" );
	wait( 1 );
	
	sr71 anim_single(sr71, "014A_usc1_f" );
	//play_intro_dialog_line( "Pilot", "014A_usc1_f" );
	
	level waittill( "liftoff_success" );
	
	sr71 anim_single(sr71, "015A_usc1_f" );
	sr71 anim_single(sr71, "016A_usc2_f" );
	sr71 anim_single(sr71, "017A_usc1_f" );
			
/*	play_intro_dialog_line( "Pilot", "015A_usc1_f" );
	play_intro_dialog_line( "Pilot", "016A_usc2_f" );
	play_intro_dialog_line( "Pilot", "017A_usc1_f" );*/
}

do_inflight_dialogue()
{
	level waittill( "inflight_in_cockpit" );
	wait( 3 );
	
	pilot = get_pilot_ent();
	operator = get_operator_ent();
	
	operator anim_single( operator, "018A_usc2_f");
	wait(2);
//	play_intro_dialog_line( "Copilot", "018A_usc2_f", 2 );
	pilot anim_single( pilot, "019A_usc1_f");
	wait(2);
//	play_intro_dialog_line( "Pilot", "019A_usc1_f", 2 );
	operator anim_single( operator, "020A_usc2_f");
	wait(2);
//	play_intro_dialog_line( "Copilot", "020A_usc2_f", 2 );
	pilot anim_single( pilot, "021A_usc1_f");
	wait(2);
	//play_intro_dialog_line( "Pilot", "021A_usc1_f", 2 );
	operator anim_single( operator, "022A_usc2_f");
	wait(2);
	//play_intro_dialog_line( "Copilot", "022A_usc2_f", 2 );
}

do_sro_intro_dialogue()
{
	
/*	player= get_players()[0];
	player playsound	(level.scr_sound["023A_usc1_f"],"sounddone");
	player waittill("sounddone");
	player playsound	(level.scr_sound["024A_usc2_f"],"sounddone");
	player waittill("sounddone");
	player playsound(level.scr_sound["025A_s71p"],"sounddone");
	player waittill("sounddone");*/
	
	pilot = get_pilot_ent();
	operator = get_operator_ent();	
	
	pilot anim_single( pilot, "023A_usc1_f");	
	operator anim_single( operator, "024A_usc2_f");
	pilot anim_single( pilot, "025A_s71p");
}

move_intro_vehicles()
{
	trucks = GetEntArray( "intro_truck", "script_noteworthy" );
	
	level thread wait_delete_intro_trucks();
	
	for( i = 1; i <= trucks.size; i++ )
	{
		truck = GetEnt( "intro_truck"+i, "targetname" );
		truck_node = GetVehicleNode( "intro_truck_start"+i, "targetname" );
		truck thread go_path( truck_node );
		if( IsDefined( truck.script_float ) )
		{
			wait( truck.script_float );
		}
	}
}

wait_delete_intro_trucks()
{
	level waittill( "delete intro vehicles" );
	
	trucks = GetEntArray( "intro_truck", "script_noteworthy" );
	array_delete( trucks );
}

wait_sr71_crew_group_anim( wait_ent, wait_anim, wait_signal, crew_group, anim_name )
{
	wait_ent waittillmatch( wait_anim, wait_signal );
	
	self thread anim_single_aligned( crew_group, anim_name );
	
	wait( 0.05 );
	
	for( i = 0; i < crew_group.size; i++ )
	{
		crew_group[i] Show();
	}
	
	crew_group[0] waittillmatch( "single anim", "end" );
	
	array_delete(crew_group);
}

sr71_crew_group_anim(crew_group, anim_name)
{
	self anim_single_aligned(crew_group, anim_name);
	array_delete(crew_group);
}

sr71_handle_runway_props()
{
	player = get_players()[0];
	stairs = GetEnt( "sr71_runway_stairs", "targetname" );
	fuel_truck_props = GetEntArray( "fuel_truck_props", "script_noteworthy" );
	final_stair_pos = getstruct( "final_stair_position", "targetname" );
	stairs MoveTo( final_stair_pos.origin, 12, 3 );
	
	flag_wait( "engine_prompt_given" );
	
	for( i = 0; i < fuel_truck_props.size; i++ )
	{
		fuel_truck_props[i] Delete();
	}
	stairs Delete();
	
	//clientNotify( "clear_for_takeoff" );
	//level notify( "clear_for_takeoff" );
}

wait_for_engine_fire() 
{
	player = get_players()[0];
	
	// Wait for the player initiate takeoff
	while (!player AttackButtonPressed())
	{
		wait(0.05);
	}
	
	flag_set( "engines_hit" );
	
	hose = getent("fxanim_wmd_fuel_hose_mod", "targetname");
	hose delete();

	// Hide the prompt
	level screen_message_delete();
}

sr71_handle_engine_prompt()
{
	//level.last_crew_member waittillmatch( "single anim", "end" );
	
	flag_wait( "pre_engine_dialog_done" );
	
	flag_set( "engine_prompt_given" );
	
	player = GetPlayers()[0];
	player thread show_thruster_prompt();
	player thread wait_for_engine_fire();
	
	//Client Notify Wait for X
	clientnotify("wait_for_x");
}

do_sr71_takeoff_anims()
{
	level endon( "liftoff_fail" );
	
	flag_wait( "engine_prompt_given" );
	
	self SetAnimKnob( level.scr_anim["sr71"]["sr71_idle"], 1, 0 );
	
	flag_wait( "camera_cut_4" );
	
	self SetAnimKnob( level.scr_anim["sr71"]["sr71_thrust"], 1, 0.3 );
	self SetAnim( level.scr_anim["sr71"]["sr71_liftoff_neutral"], 1, 0 );
	
	level waittill( "liftoff_success" );
	
	max_pitch = 16;
	
	while( IsDefined( self ) )
	{
		pitch_weight = abs(self.angles[0]) / max_pitch;
		if( pitch_weight < 0 )
		{
			pitch_weight = 0;
		}
		else if( pitch_weight > 1 )
		{
			pitch_weight = 1;
		}
		self SetAnim( level.scr_anim["sr71"]["sr71_liftoff"], pitch_weight, 0.5 );
		self SetAnim( level.scr_anim["sr71"]["sr71_liftoff_neutral"], (1-pitch_weight), 0.5 );
		
		wait( 0.05 );
	}
}

sr71_takeoff()
{
	player = get_players()[0];
	
	// Do the dialogue
	self thread do_sr71_takeoff_anims();
	level thread do_preflight_dialogue();
	level thread sr71_handle_runway_props();
	level thread sr71_handle_engine_prompt();
	
	/*
	while( 1 )
	{
		if( flag( "engines_hit" ) && !flag( "pre_engine_dialog_done" ) )
		{
			player waittill_either( "sounddone", "dialog_done" );
			break;
		}
		if( flag( "pre_engine_dialog_done" ) )
		{
			break;
		}
		wait( 0.05 );
	}
	*/
	
	flag_wait( "engines_hit" );

	level notify ("start_takeoff_sounds");
	//kicks off the runway music---using playsoundatposition on this instead of music state 
	//to blend the two tracks better
	setMusicstate("SR71_RUNWAY");
	playsoundatposition ("mus_sr71_runway_scripted", (0,0,0));
	
	// Init camera cut struct
	level.camera = undefined;
	level.camera_target = undefined;

	// Setup last camera cut here...we want to link these now so we can unlink them
	// whenever we relative to where the plane is at the time
	cam_cut_ent = GetEnt("cam_cut_runway_1", "targetname");
	level.camera_cut4 = Spawn( "script_model", cam_cut_ent.origin);
	level.camera_cut4 SetModel( "tag_origin" );
	level.camera_cut4 LinkTo(self);

	cam_cut_target_ent = GetEnt("cam_cut_runway_1_look_at", "targetname");
	level.camera_target_cut4 = Spawn( "script_model", cam_cut_target_ent.origin);
	level.camera_target_cut4 SetModel( "tag_origin" );
	level.camera_target_cut4 LinkTo(self);

	// Setup 1st camera cut
	cam_cut_info = SpawnStruct();
	cam_cut_info.cam_ent_name = "cam_cut_engine_1";
	cam_cut_info.cam_target_ent_name = "cam_cut_engine_1_look_at";
	cam_cut_info.cam_linkObj = self;
	cam_cut_info.cam_target_linkObj = self;
	cam_cut_info.fov = 25;

	flag_set( "camera_cut_1" );
	
	level maps\createart\wmd_art::set_runway_cam_cuts_dof();
	
	// CUT 1
	level clientNotify( "toggle_flight_helmet" );
	sr71_camera_cut(cam_cut_info, undefined, undefined, ::sr71_thruster_rumble_func, ::sr71_thruster_jitter_func );
	//Client Notify setting snapshot to outside
	clientnotify("external_before_launch");
	
	wait(0.4);

	// Kick off effects
	self show_engine_exhaust();	
	
	//Client Notify kicking off engines
	clientnotify("thrusters_on");
	flag_set("thrusters_on");
	
	// Kick off run sounds
	self sr71_takeoff_sounds();

	wait(0.45);

	flag_set( "camera_cut_2" );

	// Plane starts moving
	self thread go_path(GetVehicleNode("sr71_takeoff", "targetname"));

	// CUT 2
	cam_cut_info.cam_ent_name = "cam_cut_engine_2";
	cam_cut_info.cam_target_ent_name = "cam_cut_engine_2_look_at";
	cam_cut_info.cam_linkObj = undefined;
	cam_cut_info.fov = 30;
	
	//Client Notify camera cut to rear
	clientnotify("second_cut");

	sr71_camera_cut(cam_cut_info, undefined, undefined, ::sr71_side_rumble_func, ::sr71_side_jitter_func );
	self show_takeoff_effects();

	wait(1.45);

	flag_set( "camera_cut_3" );
	flag_set( "camera_cut_4" );

	// CUT4
	cam_cut_info.cam_linkObj = undefined;
	cam_cut_info.cam_target_linkObj = undefined;
	cam_cut_info.fov = 15;
	
	
	//Client Notify camera cut to by
	clientnotify("by_cut");

	level.camera_cut4 UnLink();
	sr71_camera_cut(cam_cut_info, level.camera_cut4, level.camera_target_cut4, ::sr71_side_rumble_func, ::sr71_side_jitter_func );

	wait(0.85);

	flag_set( "camera_cuts_done" );
	
	level maps\createart\wmd_art::set_default_dof();

	// End Camera Cut
	sr71_camera_cuts_done();
	
	//Client Notify camera back in cockpit
	clientnotify("get_back_in_cockpit");

	// hide the 3rd person body
	//player.body_3rdPerson Hide();
	//player.body_3rdPerson Delete();
	//player.body_3rdPerson = undefined;

	// Do Take off Rumble
	player thread sr71_takeoff_rumble();
	player thread sr71_do_throttle();
	
	vehnode = getvehiclenode("lift_off", "script_noteworthy");
	vehnode waittill("trigger");

	player thread show_liftoff_prompt();
	self thread wait_for_player_liftoff(player);
	
	//Client Notify lift_off
	clientnotify("lift_off");
}

sr71_camera_cut(cam_cut_info, camera_override, camera_target_override, rumble_func, jitter_func )
{
	level notify( "new_camera" );
	
	if ( IsDefined(level.camera) )
	{
		level.camera UnLink();
		level.camera Delete();
	}

	if ( IsDefined(level.camera_target) )
	{
		level.camera_target UnLink();
		level.camera_target Delete();
	}
	
	if( IsDefined( level.jitter_ent ) )
	{
		level.jitter_ent Unlink();
		level.jitter_ent Delete();
	}

	if( IsDefined( rumble_func ) )
	{
		level thread [[rumble_func]]( cam_cut_info );
	}

	if (IsDefined(camera_override))
	{
		level.camera = camera_override;
		level.jitter_ent = Spawn( "script_model", camera_override.origin );
		level.jitter_ent SetModel( "tag_origin_animate" );
	}
	else
	{
		cam_cut_ent = GetEnt(cam_cut_info.cam_ent_name, "targetname");
		level.camera = Spawn( "script_model", cam_cut_ent.origin);
		level.camera SetModel( "tag_origin" );
		level.jitter_ent = Spawn( "script_model", cam_cut_ent.origin );
		level.jitter_ent SetModel( "tag_origin_animate" );
	}

	if ( IsDefined(cam_cut_info.cam_linkObj) )
	{
		level.jitter_ent LinkTo( cam_cut_info.cam_linkObj );
		level.camera LinkTo( level.jitter_ent, "origin_animate_jnt" );
	}

	if ( IsDefined(camera_target_override) )
	{
		level.camera_target = camera_target_override;
	}
	else
	{
		cam_cut_look_ent = GetEnt(cam_cut_info.cam_target_ent_name, "targetname");
		level.camera_target = Spawn( "script_model", cam_cut_look_ent.origin);
		level.camera_target SetModel( "tag_origin" );
	}

	if ( IsDefined(cam_cut_info.cam_target_linkObj) )
	{
		level.camera_target LinkTo( cam_cut_info.cam_target_linkObj );
	}

	player = GetPlayers()[0];
	player SetClientDvar( "cg_fov", cam_cut_info.fov );

	player CameraSetPosition(level.camera);
	player CameraSetLookAt(level.camera_target);
	player CameraActivate(true);	
	
	
	if( IsDefined( jitter_func ) )
	{
		level thread [[jitter_func]]( cam_cut_info );
	}
}

sr71_camera_cuts_done()
{
	player = GetPlayers()[0];	
	player SetClientDvar( "cg_fov", 65 );
	player CameraActivate(false);	
	
	SetSavedDvar( "r_lightTweakSunDirection", (-177.5, -67, 0) ); //g-force
	//SetSavedDvar("r_lightTweakSunDirection", (-115.263, -176.677, 0) ); //runway
	
	level clientNotify( "toggle_flight_helmet" );

	level notify( "new_camera" );

	if ( IsDefined(level.camera) )
	{
		level.camera UnLink();
		level.camera Delete();
	}
	
	if( IsDefined( level.jitter_ent ) )
	{
		level.jitter_ent Unlink();
		level.jitter_ent Delete();
	}

	if ( IsDefined(level.camera_target) )
	{
		level.camera_target UnLink();
		level.camera_target Delete();
	}
}

#using_animtree( "wmd_sr71" );
sr71_thruster_jitter_func( cam_cut_info )
{
	level thread sr71_update_jitter_facing();
	level waittill( "thrusters_on" );
	level.jitter_ent UseAnimTree( #animtree );
	level.jitter_ent SetAnim( %p_wmd_b01_sr71_cameraShake_01, 1 );
}

sr71_update_jitter_facing()
{
	level endon( "new_camera" );
	while( 1 )
	{
		vec = level.camera_target.origin - level.jitter_ent.origin;
		level.jitter_ent.angles = VectorToAngles( vec );
		wait( 0.05 );
	}
}

sr71_side_jitter_func( cam_cut_info )
{
	level thread sr71_update_jitter_facing();
	level.jitter_ent UseAnimTree( #animtree );
	level.jitter_ent SetAnim( %p_wmd_b01_sr71_cameraShake_01, 1 );
}

sr71_thruster_rumble_func( cam_cut_info )
{
	level waittill( "thrusters_on" );
	level endon( "new_camera" );
	
	camera = GetEnt(cam_cut_info.cam_ent_name, "targetname");
	
	while( 1 )
	{
		pos = camera.origin;
		PlayRumbleOnPosition( "sr71_exterior", pos );
		wait( 0.15 );
	}
}

sr71_side_rumble_func( cam_cut_info )
{
	level endon( "new_camera" );
	
	camera = GetEnt(cam_cut_info.cam_ent_name, "targetname");
	
	while( 1 )
	{
		pos = camera.origin;
		PlayRumbleOnPosition( "sr71_exterior", pos );
		wait(0.3);
	}	
}

sr71_takeoff_rumble()
{
	self endon("death");
	self endon("disconnect");
	self endon("lift_off");
	level endon("liftoff_fail");
	
	player = get_players()[0];
	
	quakeStrength = 0.1;
	quakeVel = 0.02 * 0.05;
	chance = 40;
	
	duration = 0;
	while ( duration < 4 )
	{
//		wait(randomfloat(.15));
		quakeStrength = quakeStrength + quakeVel;
		if (quakeStrength > 0.15)
		{
			quakeStrength = 0.15;
		}
//		earthquake(randomfloatrange(.09,.12), 5, self.origin, 500);
		earthquake(quakeStrength, 0.1, self.origin, 500);
		
		chance-=.5;
		
		if(randomint(100) > chance)
		{
			self PlayRumbleOnEntity("sr71_interior");
		}

		wait(0.1);
		duration += 0.1;
	}	

	quakeStrength = 0.35;
	flag_set( "begin_gforce" );
	
	duration = 0;
	
	level.taken_off = false;
	level thread wait_for_liftoff();
	while( !level.taken_off  )
	{
		Earthquake( quakeStrength, 0.1, self.origin, 500 );	
		self PlayRumbleOnEntity( "sr71_interior_gforce" );
		wait( 0.1 );
	}
	
	chance = 0;
	while( chance < 100 )
	{
		chance += 1;
		quakeStrength = quakeStrength - 5*quakeVel;
		if( quakeStrength > 0 )
		{
				Earthquake( quakeStrength, 0.1, self.origin, 500 );
		}
		if(randomint(100) > chance)
		{
			self PlayRumbleOnEntity("sr71_interior");
		}
		wait( 0.1 );
	}
}

sr71_do_throttle()
{
	cockpit_throttle = level.scr_anim["player_pilot_body"]["sr71_cockpit_throttle"];
	self.body SetAnim(cockpit_throttle, 1);
	animLength = GetAnimLength( cockpit_throttle );
	wait( animLength );
	self.body ClearAnim( cockpit_throttle, 0.2 );
}

sr71_do_takeoff_stick()
{
	cockpit_pullback = level.scr_anim["player_pilot_body"]["sr71_cockpit_pullback"];
	duration = 1.3;
	while( duration > 0 )
	{
		time = duration + RandomFloatRange( -0.2, 0.2 );
		time = max( 0, time );
		self.body SetAnimKnob(cockpit_pullback, 1, time );
		duration -= 0.05;
		wait( 0.05 );
	}
}

wait_for_liftoff()
{
	self waittill( "liftoff_begin" );
	
	level.taken_off = true;
}

sr71_fireup_rumble()
{
	self endon("death");
	self endon("disconnect");
	self endon("take_off");
	
	while(isalive(self))
	{
		wait(randomfloat(.1));
		earthquake(randomfloatrange(.15,.2),5,self.origin,500);
		self PlayRumbleOnEntity("grenade_rumble");
	}	
}

sr71_takeoff_sounds()
{
	//restart sr71 idle sounds	
	sr71_run_sound_ent = spawn("script_origin", self.origin);
	self.sr71_run_sound_int_ent = spawn("script_origin", self.origin);
	
	//start run sounds
	sr71_run_sound_ent LinkTo(self);
	sr71_run_sound_ent PlayLoopSound("veh_sr71_run_ext", 2);

	self.sr71_run_sound_int_ent LinkTo(self);
	self.sr71_run_sound_int_ent PlayLoopSound("veh_sr71_run_int", 2);

	self PlayLoopSound ("veh_sr71_idle_ext", 6);
	self StopLoopSound(2);
//	self.interior_idle_sound_ent StopLoopSound(2);
	
	self.sr71_tail_sound_r_ent = spawn("script_origin", self gettagorigin("tag_engine_r"));
	self.sr71_tail_sound_r_ent LinkTo(self, "tag_engine_r");
	self.sr71_tail_sound_r_ent PlayLoopSound("veh_sr71_rocket_ext", 3);
	
	self.sr71_tail_sound_l_ent = spawn("script_origin", self gettagorigin("tag_engine_l"));
	self.sr71_tail_sound_l_ent LinkTo(self, "tag_engine_l");
	self.sr71_tail_sound_l_ent PlayLoopSound("veh_sr71_rocket_ext", 3);
	
	self.sr71_tail_sound_r_int_ent = spawn("script_origin", self gettagorigin("tag_engine_r"));
	self.sr71_tail_sound_r_int_ent LinkTo(self, "tag_engine_r");
	self.sr71_tail_sound_r_int_ent PlayLoopSound("veh_sr71_rocket_int", 3);
	
	self.sr71_tail_sound_l_int_ent = spawn("script_origin", self gettagorigin("tag_engine_l"));
	self.sr71_tail_sound_l_int_ent LinkTo(self, "tag_engine_l");
	self.sr71_tail_sound_l_int_ent PlayLoopSound("veh_sr71_rocket_int", 3);
}

link_player_to_sr71(tag)
{
	// Link the body to the seat
	player = GetPlayers()[0];
	player.body LinkTo(self, "tag_" + tag);
}

link_pilot_to_sr71(tag, anim_name, do_loop )
{
	if( !IsDefined( do_loop ) )
	{
		do_loop = true;
	}
	
	// Get the seat position
	tag_origin = self GetTagOrigin("tag_" + tag);
	tag_angles = self GetTagAngles("tag_" + tag);

	// Spawn the 3rd person player body
	pilot = spawn_anim_model( "player_sr71_3rdPerson_full_body" , tag_origin, tag_angles);
	pilot UseAnimTree(level.scr_animtree["player_body"] );
	pilot.animname = "player_sr71_3rdPerson_full_body";
	pilot LinkTo(self, "tag_" + tag);
	if( do_loop )
	{
		pilot thread anim_loop(pilot, anim_name);
	}
	else
	{
		pilot thread anim_single(pilot, anim_name);
	}

	return pilot;
}

show_liftoff_prompt()
{
	self endon("death");
	self endon("disconnect");
	
	level thread screen_message_create(&"PLATFORM_LIFTOFF" );
	level waittill_any("liftoff_fail","liftoff_success");
	level thread screen_message_delete();
}

show_thruster_prompt()
{
	self endon("death");
	self endon("disconnect");

	level thread screen_message_create(&"WMD_SR71_FIRE_THRUSTERS");
	
	self waittill("take_off");
	
	level thread screen_message_delete();	
}

show_engine_exhaust()
{

	PlayFXOnTag( level._effect["blackbird_exhaust"], self, "tag_engine_l" );
	PlayFXOnTag( level._effect["blackbird_exhaust"], self, "tag_engine_r" );
}

show_takeoff_effects()
{
	PlayFXOnTag( level._effect["blackbird_exhaust_smoke"], self, "tag_origin" );
	PlayFXOnTag( level._effect["blackbird_takeoff_wind"], self, "tag_origin" );
}

wait_for_player_liftoff(player)
{
	player endon("death");
	player endon("disconnect");
	level endon("liftoff_fail");
//	level endon("force_takeoff");
	
	switchnodes = GetVehicleNodeArray("take_off_node","script_noteworthy");
	nodes = get_array_of_closest( player.origin, switchnodes);
	
	while(1)
	{
		norm_move = player GetNormalizedMovement();
		new_angle = (0,0,0);

		// pulling down
		if(norm_move[0] < -0.8 || level.force_takeoff)
		{
			player thread sr71_do_takeoff_stick();
			break;
		}
		
		wait(.05);
	}
	
	index = Int(min(level.take_off_node, nodes.size - 1));
	
	node = get_source_node(nodes[index]);
	
	if(!isDefined(node))
	{
		//level notify("liftoff_fail");
		player thread sr71_do_takeoff_stick();
	}
	
	self SetSwitchNode(node,nodes[index]);
	
	
	level notify("liftoff_begin");
	wait(2);	
	level notify("liftoff_success");
	wait(4);
	custom_fade_screen_out( "white", 2 );
	flag_set("takeoff_complete");
	
	//Client Notify fade to white after liftoff
	clientnotify("white_fade_post_liftoff");
	level clientNotify( "toggle_flight_helmet" );
	
	//delete the cockpit model 
	self.cockpit delete();
	self delete();
	
	//kicks off the runway music
	setMusicstate("SR71_GLOBE");
	
	//TUEY plays canned external SR71 sounds
	playsoundatposition ("veh_sr71_3rd_person", (0,0,0));
	level thread force_snapshot_to_plane();

	SetSavedDvar( "r_lightTweakSunDirection", (-170, -80, 0) ); //space shot
	SetSavedDvar( "sm_sunSampleSizeNear", level.sunSampleSize );
}
force_snapshot_to_plane()
{
	wait(4);
	clientnotify("space_snap_into_cockpit");
}
track_takeoff_node()
{
	switchnodes = getvehiclenodearray("take_off_node","script_noteworthy");
	level.take_off_node = 0;
	array_thread(switchnodes,::monitor_takeoff_node);
}

wait_for_player_to_fail_takeoff()
{
	self endon("death");
	self endon("disconnect");
	
	level endon("liftoff_success");
	veh = getent("sr71","targetname");
	//fail_node = getvehiclenode("player_fail","script_noteworthy");
	fail_node = getvehiclenode("force_launch","script_noteworthy");
	
	level.force_takeoff = false;
	
	fail_node waittill("trigger");
	
	level.force_takeoff = true;
	
/*	iprintlnbold("YOU FAILED. THE PLANE CRASHES");
	wait(2);
	level notify("liftoff_fail");	
	iprintlnbold("End of Scripting");
	custom_fade_screen_out( "white", 2 );
	MissionFailed(); */

}

monitor_takeoff_node()
{
	level endon("liftoff_success");
	level endon("liftoff_fail");
	
	player = get_players()[0];
	while(distancesquared(player.origin,self.origin) > self.radius * self.radius )
	{
		wait(.05);
	}
	level.take_off_node ++;	
}

get_source_node(node)
{
	nodes = getAllVehicleNodes();
	
	for(i=0;i<nodes.size;i++)
	{
		anode = nodes[i];

		if(isDefined(anode.script_string) && anode.script_string == node.targetname)
		{
			return anode;
		}
	}
	
	return getvehiclenode(node.script_string,"targetname");
			
}


#using_animtree("generic_human");
/*------------------------------------
------------------------------------*/
Link_Pilot_And_Copilot(plane)
{
	
	pos = [];
	pos[0] = "tag_driver";
	pos[1] = "tag_passenger";
	
	pilots = ent_array("sr71_pilots");
	for(i=0;i<pilots.size;i++)
	{
		pilots[i] unlink();
		pilots[i] notify("stop_anim");
		pilots[i] linkto(plane,pos[i],(0,0,40));
		pilots[i] gun_remove();
		if(i == 0)
		{
			pilots[i].animname = "pilot";
			pilots[i] thread anim_loop(pilots[i],"sr71_pilot_loop","stop_anim");
		}
		else
		{
			
			pilots[i].animname = "operator";
			pilots[i] thread anim_loop(pilots[i],"sr71_operator_loop","stop_anim");
		}	
	}		
}

hide_pilot_and_copilot()
{
	pilots = ent_array("sr71_pilots");
	for(i=0;i<pilots.size;i++)
	{
		pilots[i] hide();
	}
	
}

show_pilot_and_copilot()
{
	pilots = ent_array("sr71_pilots");
	for(i=0;i<pilots.size;i++)
	{
		pilots[i] show();
	}
	
}

delete_pilot_and_copilot()
{
	pilots = ent_array("sr71_pilots");
	for(i=0;i<pilots.size;i++)
	{
		pilots[i] notify("stop_anim");
		pilots[i] delete();
	}	
}
