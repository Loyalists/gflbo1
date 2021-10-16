/*===========================================================================
RIVER ANIMATIONS
===========================================================================*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

#using_animtree ("generic_human");
	//level.scr_anim[".anim_name"]["scene_name"] = %file_name;
main()
{
	// MikeA: 5/18/10 "player_boats_intro" scene
	player_boat_intro_scene();

	// Cattle animation setup
	setup_cattle();

	// Misc Scripted VO
	maps\river_vo::setup_vo();

	// Bowman using his rocket launcher on the boat
	bowman_boat_firing();

	aftermath_AI_setup();  // uses AI
	aftermath_cinematic_setup();  // uses animated models instead of AI

	young_soldier_dead();

	helicopter_death_anims();

	boat_landing_anims();
	boat_landing_helicopter();

	vc_appear_setup();

	// -- BOAT DRIVE (EVENT 1 BEAT 3) -----------------------------------------
	level.scr_anim["bow_gunner"]["boat_anims"][0] 		= %ai_huey_pilot2_idle_loop1;
	level.scr_anim["reznov_gunner"]["boat_anims"][0]	= %crew_truck_turret_mount;  // saw_gunner_aim_down_center
	level.scr_anim["pbr_driver"]["boat_anims"][0] 		= %ch_river_b01_soright_kid_loop;
	
	level.scr_anim["gunner"]["patrol_boat_crew"][0] 	= %saw_gunner_aim_level_center;   
	
	level.scr_anim["generic"]["explosive_death_front"] = %death_explosion_forward13; // boss boat AI death
	
	// -- BINOCULAR LOOK -------
	level.scr_anim["woods"]["binocs_up"] 						= %ch_river_b02_woods_binocs_up;
	level.scr_anim["woods"]["binocs_up_idle"] 			= %ch_river_b02_woods_binocs_up_idle;
	level.scr_anim["woods"]["binocs_up_to_half"] 		= %ch_river_b02_woods_binocs_upidle_2_halfway;
	level.scr_anim["woods"]["binocs_half_idle"] 		= %ch_river_b02_woods_binocs_halfway_idle;
	level.scr_anim["woods"]["binocs_half_to_up"] 		= %ch_river_b02_woods_binocs_halfway_2_upidle;
	level.scr_anim["woods"]["binocs_down"] 					= %ch_river_b02_woods_binocs_down;
	addNotetrack_customFunction( "woods", "attach_binocs", maps\river_drive::binocs_attach, "binocs_up" );
	addNotetrack_customFunction( "woods", "detach_binocs", maps\river_drive::binocs_detach, "binocs_down" );

	// animations for boat drive
	//boat_drag_human_anims_setup();
	//boat_drag_vehicle_anims_setup();
	//boat_drag_player_anims_setup();
	
	setup_generic_anims();
	setup_plane_nose_fall();
	setup_plane_crate();
	setup_plane_map();

}

#using_animtree( "generic_human" );
boat_landing_anims()
{
	level.scr_anim[ "woods" ][ "boat_landing" ] = %ch_river_b03_squaddeboard_woods;
	level.scr_anim[ "bowman" ][ "boat_landing" ] = %ch_river_b03_squaddeboard_bowman;  // non-turret exit
 //	level.scr_anim[ "bowman" ][ "boat_landing" ] = %ch_river_b02_bowman_exit_turret;  // turret exit
	level.scr_anim[ "reznov" ][ "boat_landing" ] = %ch_river_b03_squaddeboard_resnov;

	addNotetrack_customFunction( "woods", "switch", ::actor_unlink, "boat_landing" );
	addNotetrack_customFunction( "bowman", "switch", ::actor_unlink, "boat_landing" );
	addNotetrack_customFunction( "reznov", "switch", ::actor_unlink, "boat_landing" );

	// "all_yours"
	level.scr_anim[ "woods" ][ "all_yours_idle" ][0] 	= %ch_river_b03_all_yours_woods_idle;
	level.scr_anim[ "woods" ][ "all_yours" ] 			= %ch_river_b03_all_yours_woods;
	level.scr_anim[ "soldier" ][ "all_yours_idle" ][0] 	= %ch_river_b03_all_yours_soldier_idle;
	level.scr_anim[ "soldier" ][ "all_yours" ] 			= %ch_river_b03_all_yours_soldier;
	
	addNotetrack_customFunction( "soldier", "soldier_points", ::guard_boat, "all_yours" );
}

guard_boat( guy )
{
	alcove_redshirts = GetEntArray( "boat_landing_redshirts_ai", "targetname" );
	if( alcove_redshirts.size == 0 )
	{
		PrintLn( "guard_boat notetrack couldn't find alcove_redshirts!" );
		return;
	}
	
	node = GetNode( "boat_guard_node", "targetname" );
	if( !IsDefined( node ) )
	{
		PrintLn( "node missing for guard_boat" );
	}
	
	closest_redshirt = alcove_redshirts[ 0 ];
	
	dist = 9999999;
	
	for( i = 0; i < alcove_redshirts.size; i++ )
	{
		current_dist = DistanceSquared( alcove_redshirts[ i ].origin, guy.origin );
		
		if( current_dist < dist )
		{
			closest_redshirt = alcove_redshirts[ i ];
			dist = current_dist;
		}
	}	
	
	level notify( "boat_guard_sent" );
	
	wait( 1 );
	
	//closest_redshirt.goalradius = 12;
	//closest_redshirt SetGoalPos( -12678, 25190, -13 );
	closest_redshirt SetGoalNode( node );
	closest_redshirt waittill( "goal" );
	
	pos = ( -12344, 25516, 30 );
	origin = Spawn( "script_origin", pos );
	
	closest_redshirt aim_at_target( origin );	
	closest_redshirt AllowedStances( "crouch" );
}

actor_unlink( guy )
{
	guy Unlink();
	
	if( guy == level.woods )
	{
	//	wait( 0.2 );
		guy anim_stopanimscripted( 1.0 );
	}
	else 
	{
		guy anim_stopanimscripted( 1.0 );
	}
}

#using_animtree( "vehicles" );
boat_landing_helicopter()
{
	//level.scr_anim["us_pilot_2"]["drop_off"] = %v_huey_creek_hover;	
}


#using_animtree( "generic_human" );
vc_appear_setup()
{
	level.scr_anim[ "vc_ambusher_1" ][ "vc_appear" ] = %ch_river_b03_vc_appear_A_1;  // far ambusher
	level.scr_anim[ "vc_ambusher_2" ][ "vc_appear" ] = %ch_river_b03_vc_appear_A_2;  // far ambusher
	level.scr_anim[ "vc_ambusher_3" ][ "vc_appear" ] = %ch_river_b03_vc_appear_B_1;  // far ambusher
	level.scr_anim[ "vc_ambusher_4" ][ "vc_appear" ] = %ch_river_b03_vc_appear_B_2;
	level.scr_anim[ "vc_ambusher_5" ][ "vc_appear" ] = %ch_river_b03_vc_appear_D_1;
	level.scr_anim[ "vc_ambusher_6" ][ "vc_appear" ] = %ch_river_b03_vc_appear_D_2;
	level.scr_anim[ "vc_ambusher_7" ][ "vc_appear" ] = %ch_river_b03_vc_appear_F_1;
	level.scr_anim[ "vc_ambusher_8" ][ "vc_appear" ] = %ch_river_b03_vc_appear_F_2;
	
	// first wave guys
	level.scr_anim[ "vc_ambusher_first_wave_1" ][ "vc_appear" ] = %ch_river_b03_vc_appear_firstwave_1;
	level.scr_anim[ "vc_ambusher_first_wave_2" ][ "vc_appear" ] = %ch_river_b03_vc_appear_firstwave_2;
	level.scr_anim[ "vc_ambusher_first_wave_3" ][ "vc_appear" ] = %ch_river_b03_vc_appear_firstwave_3;
}

#using_animtree ( "player" );
setup_player_anims()
{
	level.scr_animtree["player_hands"] = #animtree;

	level.scr_model["player_hands"] = "t5_gfl_ump45_viewmodel_player";

	level.scr_animtree["player_body"] = #animtree;

	level.scr_model["player_body"] = "t5_gfl_ump45_viewbody";
	//level.scr_model["player_hands"] = "viewhands_sas_woodland";

	level.scr_anim["player_hands"]["intro"] 		= %int_creek_b02_start_player;

	// player get on boat
	level.scr_anim["player_body"]["get_on_boat"] 		= %int_upacreek_b03_landing;

	// player falling out of plane
	level.scr_anim["player_body"]["player_nose_fall"] 		= %int_river_b03_nose_dive_player;
	addNotetrack_customFunction( "player_body", "blackout", maps\river_plane::plane_fall_blackout, "player_nose_fall" );

	// player capture
	level.scr_anim["player_body"]["player_struggles"] 		= %int_river_b03_playerstruggles;
		
		// -- addNotetrack_customFunction( "player_hands", "swap", maps\creek_1_drag::swap_boat, "rope_cut" ); // wwilliams: housekeeping, drag is no longer in creek_1
	
		
	addNotetrack_customFunction( "player_body", "slowmo", ::plane_nose_fall,  "player_nose_fall" );

	addNotetrack_customFunction( "player_body", "gun_on", ::plane_capture_gun,  "player_struggles" );
	addNotetrack_customFunction( "player_body", "kick_face", ::face_kick,  "player_struggles" );
	addNotetrack_customFunction( "player_body", "kick_gun", ::kick_gun, "player_struggles" );
}

#using_animtree( "river" );
aftermath_cinematic_setup()
{
	// patrol guys - loops and one shots
//	level.scr_anim["model_patrol_guy_1"]["aftermath"] = %ch_creek_b02_epilog_patrol_guy_1;
//	level.scr_anim["model_patrol_guy_1_loop"]["aftermath"][0] = %ch_creek_b02_epilog_patrol_guy_1_loop;
//	level.scr_anim["model_patrol_guy_2"]["aftermath"] = %ch_creek_b02_epilog_patrol_guy_2;
//	level.scr_anim["model_patrol_guy_2_loop"]["aftermath"][0] = %ch_creek_b02_epilog_patrol_guy_2_loop;
//	level.scr_anim["model_patrol_guy_3"]["aftermath"] = %ch_creek_b02_epilog_patrol_guy_3;
//	level.scr_anim["model_patrol_guy_3_loop"]["aftermath"][0] = %ch_creek_b02_epilog_patrol_guy_3_loop;	
//	
	// interrogation scene - loops and one shots
//	level.scr_anim["model_interrogation_guy_1"]["aftermath"] = %ch_creek_b02_epilog_interrogation_guy_1;
//	level.scr_anim["model_interrogation_guy_1_loop"]["aftermath"][0] = %ch_creek_b02_epilog_interrogation_guy_1_loop;
//	level.scr_anim["model_interrogation_guy_2"]["aftermath"] = %ch_creek_b02_epilog_interrogation_guy_2;
//	level.scr_anim["model_interrogation_guy_2_loop"]["aftermath"][0] = %ch_creek_b02_epilog_interrogation_guy_2_loop;
//	level.scr_anim["model_interrogation_guy_3"]["aftermath"] = %ch_creek_b02_epilog_interrogation_vc;
//	level.scr_anim["model_interrogation_guy_3_loop"]["aftermath"][0] = %ch_creek_b02_epilog_interrogation_vc_loop;

	// patrol guys - loops and one shots
//	level.scr_anim["model_patrol_guy_1"]["aftermath"] = %ch_creek_b02_epilog_patrol_guy_1;
//	level.scr_anim["model_patrol_guy_1_loop"]["aftermath"][0] = %ch_creek_b02_epilog_patrol_guy_1_loop;
//	level.scr_anim["model_patrol_guy_2"]["aftermath"] = %ch_creek_b02_epilog_patrol_guy_2;
//	level.scr_anim["model_patrol_guy_2_loop"]["aftermath"][0] = %ch_creek_b02_epilog_patrol_guy_2_loop;
//	level.scr_anim["model_patrol_guy_3"]["aftermath"] = %ch_creek_b02_epilog_patrol_guy_3;
//	level.scr_anim["model_patrol_guy_3_loop"]["aftermath"][0] = %ch_creek_b02_epilog_patrol_guy_3_loop;
//	
	// pushing prisoner guys - loops and one shots
//	level.scr_anim["model_pushing_prisoner_guy_1"]["aftermath"] = %ch_creek_b02_epilog_pushing_prisoner_guy_1;
//	level.scr_anim["model_pushing_prisoner_guy_1_loop"]["aftermath"][0] = %ch_creek_b02_epilog_pushing_prisoner_guy_1_loop;
//	level.scr_anim["model_pushing_prisoner_guy_2"]["aftermath"] = %ch_creek_b02_epilog_pushing_prisoner_guy_2;
//	level.scr_anim["model_pushing_prisoner_guy_2_loop"]["aftermath"][0] = %ch_creek_b02_epilog_pushing_prisoner_guy_2_loop;
//	level.scr_anim["model_pushing_prisoner_vc"]["aftermath"] = %ch_creek_b02_epilog_pushing_prisoner_vc;
//	level.scr_anim["model_pushing_prisoner_vc_loop"]["aftermath"][0] = %ch_creek_b02_epilog_pushing_prisoner_vc_loop;

	// searching house guys - loops and one shots
//	level.scr_anim["model_soldiers_searching_house_guy_1"]["aftermath"] = %ch_creek_b02_epilog_soldiers_searching_house_guy_1;
//	level.scr_anim["model_soldiers_searching_house_guy_1_loop"]["aftermath"][0] = %ch_creek_b02_epilog_soldiers_searching_house_guy_1_loop;
//	level.scr_anim["model_soldiers_searching_house_guy_2"]["aftermath"] = %ch_creek_b02_epilog_soldiers_searching_house_guy_2;
//	level.scr_anim["model_soldiers_searching_house_guy_2_loop"]["aftermath"][0] = %ch_creek_b02_epilog_soldiers_searching_house_guy_2_loop;
//	level.scr_anim["model_soldiers_searching_house_guy_3"]["aftermath"] = %ch_creek_b02_epilog_soldiers_searching_house_guy_3;
//	level.scr_anim["model_soldiers_searching_house_guy_3_loop"]["aftermath"][0] = %ch_creek_b02_epilog_soldiers_searching_house_guy_3_loop;

	// captured guys + guards. all looping
//	level.scr_anim["model_captured_guard_1"]["aftermath"][0] = %ch_creek_b02_epilog_captured_guard_1;
//	level.scr_anim["model_captured_guard_2"]["aftermath"][0] = %ch_creek_b02_epilog_captured_guard_2;
//	level.scr_anim["model_captured_vc_1"]["aftermath"][0] = %ch_creek_b02_epilog_captured_vc_1;
//	level.scr_anim["model_captured_vc_2"]["aftermath"][0] = %ch_creek_b02_epilog_captured_vc_2;
//	level.scr_anim["model_captured_vc_3"]["aftermath"][0] = %ch_creek_b02_epilog_captured_vc_3;
//	level.scr_anim["model_captured_vc_4"]["aftermath"][0] = %ch_creek_b02_epilog_captured_vc_4;	
	
//	level.scr_anim["model_medic_soldier_01"]["aftermath"][0] = %ch_khe_opening_stretcher2huey_guy01;
//	level.scr_anim["model_medic_soldier_02"]["aftermath"][0] = %ch_khe_opening_stretcher2huey_guy02;
//	level.scr_anim["model_medic_soldier_03"]["aftermath"][0] = %ch_khe_opening_stretcher2huey_guy03;
//	
	// guards and prisoners scene (river specific)
		// GUARDS
	
		// PRISONERS
//	level.scr_anim[ "model_prisoner_1" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_prisoner_1;
	level.scr_anim[ "model_prisoner_2" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_prisoner_2;
//	level.scr_anim[ "model_prisoner_3" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_prisoner_3;
//	level.scr_anim[ "model_prisoner_4" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_prisoner_4;
	level.scr_anim[ "model_prisoner_5" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_prisoner_5;
	level.scr_anim[ "model_prisoner_6" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_prisoner_6;

	// heli landing guys
	level.scr_anim[ "model_heli_landing_guy_1" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_helilandingguy_1;
	level.scr_anim[ "model_heli_landing_guy_2" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_helilandingguy_2;
	


//	level.scr_anim[ "" ][ "aftermath" ][ 0 ] = %;
	level.scr_anim[ "model_injured_dude" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_a_injured_dude;
	level.scr_anim[ "model_medic_1" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_a_injured_medic_1;
	level.scr_anim[ "model_medic_2" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_a_injured_medic_2;

	// attention guys
	level.scr_anim[ "model_attentionguy_01_idle" ][ "aftermath" ][0]	= %ch_river_b01_intro_activity_attentionguy_01_idle;
	level.scr_anim[ "model_attentionguy_01_action" ][ "aftermath" ] 	= %ch_river_b01_intro_activity_attentionguy_01_action;
	level.scr_anim[ "model_attentionguy_02_idle" ][ "aftermath" ][0]	= %ch_river_b01_intro_activity_attentionguy_02_idle;
	level.scr_anim[ "model_attentionguy_02_action" ][ "aftermath" ] 	= %ch_river_b01_intro_activity_attentionguy_02_action;
	level.scr_anim[ "model_attentionguy_03_idle" ][ "aftermath" ][0]	= %ch_river_b01_intro_activity_attentionguy_03_idle;
	level.scr_anim[ "model_attentionguy_03_action" ][ "aftermath" ] 	= %ch_river_b01_intro_activity_attentionguy_03_action;

	// poser guys - group a
	level.scr_anim[ "model_poserguy_a_01" ][ "aftermath" ] = %ch_river_b01_intro_activity_poserguy_a_01;
	level.scr_anim[ "model_poserguy_a_01_idle" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_poserguy_a_01_idle;
	level.scr_anim[ "model_poserguy_a_02" ][ "aftermath" ] = %ch_river_b01_intro_activity_poserguy_a_02;
	level.scr_anim[ "model_poserguy_a_02_idle" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_poserguy_a_02_idle;
	
	// poser guys - group b
	level.scr_anim[ "model_poserguy_b_01" ][ "aftermath" ] = %ch_river_b01_intro_activity_poserguy_b_01;
	level.scr_anim[ "model_poserguy_b_01_idle" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_poserguy_b_01_idle;
	level.scr_anim[ "model_poserguy_b_02" ][ "aftermath" ] = %ch_river_b01_intro_activity_poserguy_b_02;
	level.scr_anim[ "model_poserguy_b_02_idle" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_poserguy_b_02_idle;

//	//  user guys - these are all loops
//	level.scr_anim[ "model_usher_guy_1" ][ "aftermath" ] = %ch_river_b01_intro_activity_usher_01;
//	level.scr_anim[ "model_usher_guy_2" ][ "aftermath" ] = %ch_river_b01_intro_activity_usher_02;
	//level.scr_anim[ "model_usher_guy_3" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_usher_03;
	
	// photographer's camera
	level.scr_animtree[ "camera" ] = #animtree;	
	level.scr_model[ "camera" ] = "tag_origin_animate";
	level.scr_anim[ "camera" ][ "path" ]			= %o_river_b01_intro_activity_camera;
	level.scr_anim[ "camera" ]["idle_start"][0]		= %o_river_b01_intro_activity_camera_idle_a;
	level.scr_anim[ "camera" ][ "idle_end" ][0]		= %o_river_b01_intro_activity_camera_idle_b;
	
	addNotetrack_customFunction( "camera", "flash", ::camera_flash, "path" );
	addNotetrack_customFunction( "camera", "flash", ::camera_flash, "idle_start" );
	addNotetrack_customFunction( "camera", "flash", ::camera_flash, "idle_end" );
	
	// injured group b
	level.scr_anim[ "injured_dude_b" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_b_injured_dude;
	level.scr_anim[ "injured_dude_b_medic_1" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_b_medic_1;
	level.scr_anim[ "injured_dude_b_medic_2" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_b_medic_2;
	
//	// injured group c
//	level.scr_anim[ "injured_dude_c" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_c_injured_dude;
//	level.scr_anim[ "injured_dude_c_medic_1" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_c_medic_1;
//	level.scr_anim[ "injured_dude_c_medic_2" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_c_medic_2;
//	
	// limping guy group b
	level.scr_anim[ "limping_guy_b" ][ "aftermath" ][0] = %ch_river_b01_intro_triagetent_woundedguy;
	level.scr_anim[ "limping_guy_b_helper_1" ][ "aftermath" ][0] = %ch_river_b01_intro_triagetent_guy1;
	level.scr_anim[ "limping_guy_b_helper_2" ][ "aftermath" ][0] = %ch_river_b01_intro_triagetent_guy2;
	
	// limping guy group c
	level.scr_anim[ "limping_guy_c" ][ "aftermath" ] = %ch_river_b01_intro_activity_limpingguy_c;
	level.scr_anim[ "limping_guy_c_helper_1" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyhelpinglimpingguy_01_c;
	level.scr_anim[ "limping_guy_c_helper_2" ][ "aftermath" ] = %ch_river_b01_intro_activity_guyhelpinglimpingguy_02_c;
	
	// guys in pain
	level.scr_anim[ "guy_in_pain_1" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_guyinpain_01;
	level.scr_anim[ "guy_in_pain_2" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_guyinpain_02;
	level.scr_anim[ "guy_in_pain_3" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_guyinpain_03;
	level.scr_anim[ "guy_in_pain_4" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_guyinpain_04;
	level.scr_anim[ "guy_in_pain_5" ][ "aftermath" ][ 0 ] = %ch_river_b01_intro_activity_guyinpain_05;	
		
	// "seen worse"
	level.scr_anim[ "platoon_leader" ][ "seen_worse" ][ 0 ] = %ch_river_intro_activity_platoon_leader;
//	level.scr_anim[ "platoon_leader" ][ "seen_worse_idle" ][ 0 ] = %unarmed_crouch_idle1;
}

// can't use self or camera here since camera is animated model (tag_origin_animate)
camera_flash( camera )
{
	real_camera = GetEnt( "photographers_camera", "targetname" );
	if( IsDefined( real_camera ) )
	{
		PlayFXOnTag( level._effect[ "camera_flash" ], real_camera, "tag_origin" );
	}
}

#using_animtree( "generic_human" );
aftermath_AI_setup()
{
	// photographer (guy)
	level.scr_anim[ "model_photographer_path" ][ "aftermath" ] = %ch_river_b01_intro_activity_photographer;
	level.scr_anim[ "model_photographer_start_idle" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_photographer_idle_a;
	level.scr_anim[ "model_photographer_done_idle" ][ "aftermath" ][0] = %ch_river_b01_intro_activity_photographer_idle_b;
	
	// guards for prisoners
	level.scr_anim[ "guard_1" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_guard_1;
	level.scr_anim[ "guard_2" ][ "aftermath" ][ 0 ] = %ch_river_intro_activity_guard_2;	
	
	// usher guys
	level.scr_anim[ "model_usher_guy_1" ][ "aftermath" ] = %ch_river_b01_intro_activity_usher_01;
	level.scr_anim[ "model_usher_guy_2" ][ "aftermath" ] = %ch_river_b01_intro_activity_usher_02;	
	
	level.scr_anim[ "bowman" ][ "seen_worse" ] = %ch_river_intro_activity_bowman_reassures;
		
	// squad boards pbr		
	level.scr_anim[ "bowman" ][ "board_pbr" ] 			= %ch_river_b01_soright_bowman;	
	level.scr_anim[ "bowman" ][ "pre_board_pbr" ] 	= %ch_river_b01_soright_bowman_loops;
	level.scr_anim[ "bowman" ][ "board_pbr_stall" ][0] 	= %ch_river_b01_soright_bowman_stall;
	addNotetrack_customFunction( "bowman", "spawn_gun_left", maps\river_drive::notetrack_geton_pbr_weapon_on_back, "board_pbr" );
	addNotetrack_customFunction( "bowman", "show_gun_right", maps\river_drive::notetrack_geton_pbr_spawn_fake_m202, "board_pbr" );
	addNotetrack_customFunction( "bowman", "pickup_weapon", maps\river_drive::notetrack_geton_pbr_grab_m202, "board_pbr" );
	
	level.scr_anim[ "kid" ][ "board_pbr" ] 		= %ch_river_b01_soright_kid;
	level.scr_anim[ "kid" ][ "pre_board_pbr_loop" ][0]	= %ch_river_b01_soright_kid_loop;
	
	level.scr_anim[ "woods" ][ "board_pbr" ] 	= %ch_river_b01_soright_woods;
	level.scr_anim[ "woods" ][ "pre_board_pbr" ] 	= %ch_river_b01_soright_woods_loops;
	level.scr_anim[ "woods" ][ "board_pbr_stall" ][0] 	= %ch_river_b01_soright_woods_stall;
	addNotetrack_customFunction( "woods", "start_the_music", maps\river_amb::radio_watcher, "board_pbr" );
	addNotetrack_customFunction( "woods", "spawn_gun_left", maps\river_drive::notetrack_geton_pbr_weapon_on_back, "board_pbr" );
	addNotetrack_customFunction( "woods", "show_gun_right", maps\river_drive::notetrack_geton_pbr_spawn_fake_m202, "board_pbr" );
	addNotetrack_customFunction( "woods", "pickup_weapon", maps\river_drive::notetrack_geton_pbr_grab_m202, "board_pbr" );
	
//	addNotetrack_customFunction( "woods", "grab_ropes", maps\river_boat_drag::notetrack_attach_ropes_to_woods, "hook_up_ropes" );  
	
	level.scr_anim[ "reznov" ][ "board_pbr" ] 		= %ch_river_b01_soright_resnov;
	level.scr_anim[ "reznov" ][ "pre_board_pbr" ] 	= %ch_river_b01_soright_resnov_loops;
	level.scr_anim[ "reznov" ][ "board_pbr_stall" ][0] 	= %ch_river_b01_soright_resnov_stall;
}

#using_animtree( "generic_human" );
young_soldier_dead()
{
	level.scr_anim[ "woods" ][ "young_soldier_dead" ] = %ch_river_b02_young_soldier_dead_woods;
	level.scr_anim[ "bowman" ][ "young_soldier_dead" ] = %ch_river_b02_young_soldier_dead_bowman;
	level.scr_anim[ "kid" ][ "young_soldier_dead" ] = %ch_river_b02_young_soldier_dead_youngsoldier;
	level.scr_anim[ "kid" ][ "young_soldier_dead_death" ] = %ch_river_b02_young_soldier_dead_youngsoldier_death;
	level.scr_anim[ "kid" ][ "young_soldier_dead_death_idle" ][0] = %ch_river_b02_young_soldier_dead_youngsoldier_death_idle;
	
	addNotetrack_customFunction( "woods", "drop_gun", maps\river_drive::drop_m202, "young_soldier_dead" );
	addNotetrack_customFunction( "bowman", "drop_gun", maps\river_drive::drop_m202, "young_soldier_dead" );
}

// this is not currently being used, but it's still in script in case we need it later.
#using_animtree ("player");
play_climb_into_boat_anim()
{
//	IPrintLnBold("play animation for getting on boat now");
	
	player = get_players()[0];
	player DisableWeapons();
	
	hands = spawn_anim_model("player_body");
	hands.animname = "player_body";
	
	hands.origin = level.boat GetTagOrigin("tag_origin_animate");
	hands.angles = level.boat GetTagAngles("tag_origin_animate");
	hands LinkTo(level.boat);
	
	player PlayerLinkToAbsolute(hands, "tag_player");
	
	hands anim_single(hands, "get_on_boat");
	
	player Unlink();
	
	fake_destination = GetEnt("reznov_boat_teleport", "targetname");
	player SetOrigin(fake_destination.origin);
	
	hands Unlink();
	hands Delete();
	player EnableWeapons();
}

/*===========================================================================
 River Intro animation of the player boat droppng into the level
===========================================================================*/
#using_animtree( "vehicles" );
player_boat_intro_scene()
{
	//level.scr_animtree["player_heli"] = #animtree;
	level.scr_anim["player_helicopter"]["player_dropoff"] = %veh_river_b01_dropoff_chin_01;
	level.scr_anim["boat3_helicopter"]["player_dropoff"] = %veh_river_b01_dropoff_chin_02;
	level.scr_anim["orig_helicopter"]["player_dropoff"] = %veh_river_b01_dropoff_chin_03;
	
	level.scr_anim["player_boat"]["player_dropoff"] = %veh_river_b01_dropoff_pbr_01;
	level.scr_anim["boat3"]["player_dropoff"] = %veh_river_b01_dropoff_pbr_02;
	
	level.scr_anim[ "player_boat" ][ "idle_for_boarding" ][0] = %veh_river_b01_dropoff_pbr_02_loop;
}



// BOAT DROP TODO:
//
// Add the effects to the helicopter
// Delete the boats and childs and swap in the real boats
// Add the angles (0, 270, 0) to the root node in radient
// Investigate, should we use a script struct instead of a node as the anim root, becuase nodes get dropped to the ground
//

#using_animtree( "vehicles" );
boat_drop_vignette()
{
	// delete the shore clip to allow player to get on
	shore_clip = getent( "player_shore_clip_opening", "targetname" );
	if( isdefined( shore_clip ) )
	{
		shore_clip delete();
	}  
	
	struct = getstruct( "player_boat_intro_node", "targetname" ); 
	
	node = Spawn( "script_origin", struct.origin );
	node.angles = ( 0, 0, 0 ); //struct.angles;
	
	player_boat_node = Spawn( "script_origin", struct.origin );
	player_boat_node.angles = node.angles;
	

	// Setup the player Helicopter:	veh_river_b01_dropoff_chin_01
	chinook_player_ent = spawn( "script_model", (0,0,0) );
	chinook_player_ent setModel( "vehicle_ch46e_expensive" );
	chinook_player_ent useAnimTree( #animtree ); 
	chinook_player_ent.animname = "player_helicopter";
	playfxontag( level._effect["chinook_blade"], chinook_player_ent, "main_rotor_jnt" );
	playfxontag( level._effect["chinook_blade"], chinook_player_ent, "tail_rotor_jnt" );
	PlayFXOnTag( level._effect[ "chinook_spotlight" ], chinook_player_ent, "tag_headlight" );

	// Setup the Helicopter that drops off boat #3: veh_river_b01_dropoff_chin_02
	chinook_boat3_ent = spawn( "script_model", (0,0,0) );
	chinook_boat3_ent setModel( "vehicle_ch46e_expensive" );
	chinook_boat3_ent useAnimTree( #animtree ); 
	chinook_boat3_ent.animname = "boat3_helicopter";
	playfxontag( level._effect["chinook_blade"], chinook_boat3_ent, "main_rotor_jnt" );
	playfxontag( level._effect["chinook_blade"], chinook_boat3_ent, "tail_rotor_jnt" );
	PlayFXOnTag( level._effect[ "chinook_spotlight" ], chinook_boat3_ent, "tag_headlight" );

	// The Helicopter that dropeds off the original boats: veh_river_b01_dropoff_chin_03
	chinook_boat_orig_ent = spawn( "script_model", (0,0,0) );
	chinook_boat_orig_ent setModel( "vehicle_ch46e_expensive" );
	chinook_boat_orig_ent useAnimTree( #animtree ); 
	chinook_boat_orig_ent.animname = "orig_helicopter";
	playfxontag( level._effect["chinook_blade"], chinook_boat_orig_ent, "main_rotor_jnt" );
	playfxontag( level._effect["chinook_blade"], chinook_boat_orig_ent, "tail_rotor_jnt" );
	PlayFXOnTag( level._effect[ "chinook_spotlight" ], chinook_boat_orig_ent, "tag_headlight" );
	
	
	// The Player Boat: veh_river_b01_dropoff_pbr_01
//	player_boat_ent = spawn( "script_model", (0,0,0) );
//	player_boat_ent setModel( "t5_veh_boat_pbr" );
	player_boat_ent = level.boat;
	player_boat_ent useAnimTree( #animtree );
	player_boat_ent.animname = "player_boat";
//	maps\river_util::add_part_to_vehicle( "t5_veh_boat_pbr_stuff", player_boat_ent );
//	maps\river_util::add_part_to_vehicle( "t5_veh_boat_pbr_set01", player_boat_ent );
	
	
	// The Boat #3: veh_river_b01_dropoff_pbr_02
//	boat3_ent = spawn( "script_model", (0,0,0) );
//	//boat3_ent.angles = angles;
//	boat3_ent setModel( "t5_veh_boat_pbr" );
	realboat3 = GetEnt( "friendly_boat_3", "script_noteworthy" );	
	realboat3 useAnimTree( #animtree );
	realboat3.animname = "boat3";
//	maps\river_util::add_part_to_vehicle( "t5_veh_boat_pbr_stuff", boat3_ent );
//	maps\river_util::add_part_to_vehicle( "t5_veh_boat_pbr_set01", boat3_ent );
	maps\river_util::add_part_to_vehicle( "t5_veh_boat_pbr_antenna_static", realboat3 );
	
	
	level thread attach_rope_during_dropoff( chinook_boat3_ent, realboat3, 3.5, "delete_attached_ropes" );
	level thread attach_rope_during_dropoff( chinook_player_ent, level.boat, 3, "delete_attached_ropes" );

	level thread animate_chinook_and_delete( node, chinook_player_ent, "player_dropoff" );
	level thread animate_chinook_and_delete( node, chinook_boat3_ent, "player_dropoff" );
	level thread animate_chinook_and_delete( node, chinook_boat_orig_ent, "player_dropoff" );
	
	//node thread anim_single_aligned( player_boat_ent, "player_dropoff" );
	//node thread model_swap_after_anim( "player_dropoff", player_boat_ent, level.boat, "boat_drop_done" );
//	node thread model_swap_after_anim( "player_dropoff", boat3_ent, realboat3 );
	
	// setup to make the physics boat animatable
	realboat3.supportsAnimScripted = true;
	realboat3 ClearVehGoalPos();	
	//realboat3.drivepath = 0;
	
	node thread anim_single_aligned( realboat3, "player_dropoff" );
	
	// Turn off the water wake effects while the boat is in the air
	player_boat_ent thread hide_intro_boat_wake_effects();

	// Setup a thread that plays the water splash effect on th pier
	level thread boat_drop_water_splash_on_pier();

	level.boat.drivepath = 0;

	// setup to make the physics boat animatable
	level.boat.supportsAnimScripted = true;
	level.boat ClearVehGoalPos();

	/*
	// test
	test_boat = spawn( "script_model", level.boat.origin );
	test_boat SetModel( "t5_veh_boat_pbr" );
	test_boat useAnimTree( #animtree );
	test_boat.animname = "player_boat";
	level.boat = test_boat;
	*/
	
	//model_swap_after_anim( animname, original_model, swapto_ent, set_flag ) 
	
	struct anim_single_aligned( level.boat, "player_dropoff" ); 
	struct thread anim_loop_aligned( level.boat, "idle_for_boarding", undefined, "ready_for_boat_drive" );
	flag_set( "boat_drop_done" );
	
	//level.boat.supportsAnimScripted = false;
}

animate_chinook_and_delete( node, chinook, anime )
{
	node anim_single_aligned( chinook, anime );
	chinook notify( "delete_attached_ropes" );
	chinook delete();
}

attach_rope_during_dropoff( chinook, boat, cut_off_time, delete_notify )
{
	wait( 0.1 );
	
	//level thread debug_print_origins( chinook );
	//level thread debug_print_origins( boat );
	
    rope_mover_chinook = spawn( "script_model", chinook GetTagOrigin( "tag_light_belly" ) ); 
    rope_mover_1 = spawn( "script_model", boat GetTagOrigin( "tag_passenger10" ) );
    rope_mover_2 = spawn( "script_model", boat GetTagOrigin( "tag_passenger3" ) ); 
    rope_mover_3 = spawn( "script_model", boat GetTagOrigin( "snd_stern_port" ) );
    rope_mover_4 = spawn( "script_model", boat GetTagOrigin( "tag_passenger12" ) ); 
    
    rope_mover_chinook.angles = chinook GetTagAngles( "tag_light_belly" );
    rope_mover_1.angles = boat GetTagAngles( "tag_passenger10" );
    rope_mover_2.angles = boat GetTagAngles( "tag_passenger3" );
    rope_mover_3.angles = boat GetTagAngles( "snd_stern_port" );
    rope_mover_4.angles = boat GetTagAngles( "tag_passenger12" );
    
    rope_mover_chinook SetModel( "tag_origin" );
    rope_mover_1 SetModel( "tag_origin" );
    rope_mover_2 SetModel( "tag_origin" );
    rope_mover_3 SetModel( "tag_origin" );
    rope_mover_4 SetModel( "tag_origin" );
    
    rope_mover_chinook LinkTo( chinook, "tag_light_belly" );
    rope_mover_1 LinkTo( boat, "tag_passenger10" );
    rope_mover_2 LinkTo( boat, "tag_passenger3" );
    rope_mover_3 LinkTo( boat, "snd_stern_port" );
    rope_mover_4 LinkTo( boat, "tag_passenger12" );


	// create ropes
	chinook.rope_1 = createrope( rope_mover_1.origin, ( 0, 0, 0 ), 600, chinook, "tag_light_belly" ); // tag_light_belly
	chinook.rope_2 = createrope( rope_mover_2.origin, ( 0, 0, 0 ), 600, chinook, "tag_light_belly" );
	chinook.rope_3 = createrope( rope_mover_3.origin, ( 0, 0, 0 ), 600, chinook, "tag_light_belly" );
	chinook.rope_4 = createrope( rope_mover_4.origin, ( 0, 0, 0 ), 600, chinook, "tag_light_belly" );
	
	RopeRemoveAnchor( chinook.rope_1, 0 );
	RopeRemoveAnchor( chinook.rope_2, 0 );
	RopeRemoveAnchor( chinook.rope_3, 0 );
	RopeRemoveAnchor( chinook.rope_4, 0 );
	
	RopeAddEntityAnchor( chinook.rope_1, 0, rope_mover_1, ( 0, 0, 0 ) );
	RopeAddEntityAnchor( chinook.rope_2, 0, rope_mover_2, ( 0, 0, 0 ) );
	RopeAddEntityAnchor( chinook.rope_3, 0, rope_mover_3, ( 0, 0, 0 ) );
	RopeAddEntityAnchor( chinook.rope_4, 0, rope_mover_4, ( 0, 0, 0 ) );
	
	// make them thicker
	ropesetparam( chinook.rope_1, "width", 4 );
	ropesetparam( chinook.rope_2, "width", 4 );
	ropesetparam( chinook.rope_3, "width", 4 );
	ropesetparam( chinook.rope_4, "width", 4 );
	
	// force them to draw
	ropesetflag( chinook.rope_1, "force_update", 1 );
	ropesetflag( chinook.rope_2, "force_update", 1 );
	ropesetflag( chinook.rope_3, "force_update", 1 );
	ropesetflag( chinook.rope_4, "force_update", 1 );
	
	wait( cut_off_time );

	// cut the bottom of the ropes
	RopeRemoveAnchor( chinook.rope_1, 0 );
	RopeRemoveAnchor( chinook.rope_2, 0 );
	RopeRemoveAnchor( chinook.rope_3, 0 );
	RopeRemoveAnchor( chinook.rope_4, 0 );
	
	rope_mover_1 delete();
	rope_mover_2 delete();
	rope_mover_3 delete();
	rope_mover_4 delete();
	
	RopeRemoveAnchor( chinook.rope_1, 1 );
	RopeRemoveAnchor( chinook.rope_2, 1 );
	RopeRemoveAnchor( chinook.rope_3, 1 );
	RopeRemoveAnchor( chinook.rope_4, 1 );
	
	RopeAddEntityAnchor( chinook.rope_1, 1, rope_mover_chinook, ( 0, 0, 0 ) );
	RopeAddEntityAnchor( chinook.rope_2, 1, rope_mover_chinook, ( 0, 0, 0 ) );
	RopeAddEntityAnchor( chinook.rope_3, 1, rope_mover_chinook, ( 0, 0, 0 ) );
	RopeAddEntityAnchor( chinook.rope_4, 1, rope_mover_chinook, ( 0, 0, 0 ) );
	
	chinook waittill( delete_notify );
	
	// delete the ropes
	deleterope( chinook.rope_1 );
	deleterope( chinook.rope_2 );
	deleterope( chinook.rope_3 );
	deleterope( chinook.rope_4 );
	
	rope_mover_chinook delete();
}

//************************************************************************
// self = level
//************************************************************************
boat_drop_water_splash_on_pier()
{
	wait( 9.15 );
	exploder( 20 );
}


//************************************************************************
// self = player boat
//************************************************************************

hide_intro_boat_wake_effects()
{
	self veh_toggle_tread_fx( 0 );
	wait( 4 );
	self veh_toggle_tread_fx( 1 );
}


/*==========================================================================
// self = boat
==========================================================================*/
play_boat_wake_effect( pos, angles )
{
	// Spawn a script model at the tag_wake	
	water_wake_tag = spawn( "script_model", pos );
	water_wake_tag.angles = angles;
	water_wake_tag setmodel( "tag_origin" );
     
    playfxOnTag( level._effect["boat_drop_splash"], water_wake_tag, "tag_origin" );
    
    wait( 8 );
    water_wake_tag Delete();
}


/*==========================================================================
FUNCTION: model_swap_after_anim
SELF: animation reference (usually a node)
PURPOSE: to change out an animated model with a working script vehicle (or
	whatever ent)

ADDITIONS NEEDED:
==========================================================================*/
model_swap_after_anim( animname, original_model, swapto_ent, set_flag ) 
{
	if( !IsDefined( animname ) || !IsDefined( original_model ) || !IsDefined( swapto_ent ) )
	{
		Maps\river_util::Print_debug_message( "missing parameters on model_swap_after_anim!", true );
		return;
	}
	
//	swapto_ent Hide();
	
	self anim_single_aligned( original_model, animname );
	
	origin = original_model.origin;
	angles = original_model.angles;
	
	if( original_model != level.boat )
	{
		original_model Delete();
		
		wait( 0.05 );
		
		swapto_ent.origin = origin;
		swapto_ent.angles = angles;
				
	}
	
	if( IsDefined( set_flag ) )
	{
		flag_set( set_flag );
	}
	
//	swapto_ent Show();
}

/*==========================================================================
FUNCTION: make_ai_model_and_animate
SELF: TBD
PURPOSE: easy way to spawn in a character model with a weapon and animate him.
	This should save AI count by using animated models. These should be aligned,
	as AI based cinematic animations usually are.

ADDITIONS NEEDED:
==========================================================================*/
#using_animtree( "river" );
make_ai_model_and_animate( char_type, weapon, anim_name, scene_name, anim_struct_targetname, oneshot_then_loop, kill_flag )
{	
	if( !IsDefined( char_type ) )
	{
		PrintLn( "char_type is missing in make_ai_model_and_animate" );
		return;
	}
	
//	if( !IsDefined( weapon ) )
//	{
//		PrintLn( "weapon is missing in make_ai_model_and_animate" );
//		return;
//	}
	
	if( !IsDefined( anim_name ) )
	{
		PrintLn( "anim_name is missing in make_ai_model_and_animate" );
		return;
	}
	
	if( !IsDefined( scene_name ) )
	{
		PrintLn( "scene_name is missing in make_ai_model_and_animate" );
		return;
	}
	
	if( !IsDefined( anim_struct_targetname ) )
	{
		PrintLn( "anim_struct_targetname is missing in make_ai_model_and_animate" );
		return;
	}
	
	node = getstruct( anim_struct_targetname, "targetname" );		
	
	if( !IsDefined( node ) )
	{
		PrintLn( "no struct found with targetname " + anim_struct_targetname + "!" );
		return;
	}
	
	model = make_animated_character_model( char_type, weapon );
	
	model.animname = anim_name;
	
	if( IsDefined( oneshot_then_loop ) && ( oneshot_then_loop == true ) )  // play single anim then loop
	{
		anim_loop_name = anim_name + "_loop";  // must be set up with this convention in _anim file to work right
		node anim_single_aligned( model, scene_name );
		model.animname = anim_loop_name;
		node thread anim_loop_aligned( model, scene_name );
	}
	else  // loop only
	{
		node thread anim_loop_aligned( model, scene_name );
	}

//	if( IsDefined( kill_flag ) )
//	{
//		flag_wait( kill_flag );
//		wait( RandomIntRange( 1, 4 ) );
//		maps\river_util::Print_debug_message( "deleting animated guy playing " + anim_name );
//		model Delete();
//	}
	if( IsDefined( kill_flag ) )
	{
		model.script_noteworthy = kill_flag;
	}
	else
	{
		return model;
	}
}

#using_animtree( "river" );
make_animated_character_model( char_type, weapon )
{	
	if( !IsDefined( char_type ) )
	{
		PrintLn( "char_type is missing in make_ai_model_and_animate" );
		return;
	}
	
//	if( !IsDefined( origin ) )
//	{
//		PrintLn( "origin is missing in make_ai_model_and_animate" );
//		return;
//	}

	
	model = Spawn( "script_model", ( 0, 0, 0 ) );
	model UseAnimTree( #animtree );
	
	// figure out what type of AI it is
	switch( char_type )
	{
		case "american":
			//model character\c_usa_jungmar_assault::main();
			model redshirt_setup_basic();
			model.team = "allies";
			break;
			
//		case "nva":
//			model character\c_vtn_nva1::main();
//			model.team = "axis";
//			break;
		case "vc":
			x =RandomInt( 3 );
			if( x == 0 )
			{
				model character\c_vtn_vc1_nogear::main();  
			}
			else if( x == 1 )
			{
				model character\c_vtn_vc2_nogear::main();
			}
			else
			{
				model character\c_vtn_vc3_nogear::main();
			}
			model.team = "axis";
			break;		
			
		case "vc1":
			model character\c_vtn_vc1_nogear::main();  
			model.team = "axis";
			break;		
			
		case "vc2":
			model character\c_vtn_vc2_nogear::main();  
			model.team = "axis";
			break;	
			
		case "vc3":
			model character\c_vtn_vc3_nogear::main();  
			model.team = "axis";
			break;	
	}

	// Give the drone default health and make it take damage like an AI does
	model.health = 150;
	model setCanDamage( true );
	model.targetname = "drone";
	
	// Put a friendly name on the drone so they look like AI
	if ( model.team == "allies" )
	{
		// force to be american, but should probably figure out what it really should be since all friendlies aren't american
		model.voice = "american";
		
		// asign name
		model maps\_names::get_name();
		model setlookattext( model.name, &"" );
	}
	else
	{
		// 
	}
	
	// Run the friendly fire thread on this drone so the mission can be failed for killing friendly drones
	// Runs on all teams since friendly fire script also keeps track of enemies killed, etc.
	level thread maps\_friendlyfire::friendly_fire_think( model );
	
	model endon( "death" );
	
	// attach weapon to AI
	if( IsDefined( weapon ) )
	{
		weaponModel = GetWeaponModel( weapon );
		model Attach( weaponModel, "tag_weapon_right" );
		model useweaponHideTags( weapon );
	}
	
	/#
	entnum = model GetEntNum();
	model.entnum = entnum;
	#/
	
	model MakeFakeAI(); 
	
	return model;
}

redshirt_setup_basic_old()
{
	self setModel("c_usa_jungmar_body_drab");
	
	if( !isdefined( level.head_index ) )
	{
		level.head_index = 0;
	}

	self.headModel = undefined;
	if( level.head_index == 0 )
	{
		self.headModel = "c_usa_jungmar_head1";
	}
	else if( level.head_index == 1 )
	{
		self.headModel = "c_usa_jungmar_head2";
	}
	else if( level.head_index == 2 )
	{
		self.headModel = "c_usa_jungmar_head3";
	}
	else if( level.head_index == 3 )
	{
		self.headModel = "c_usa_jungmar_head4";
	}
	else // level.head_index == 4
	{
		self.headModel = "c_usa_jungmar_head5";
	}
	level.head_index++;
	level.head_index = level.head_index % 5;
	
	self attach(self.headModel, "", true);
//	self.gearModel = "c_usa_jungmar_gear1";
//	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
	
}

redshirt_CQB_nogear()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head2_nc";
	self attach(self.headModel, "", true);
//	self.gearModel = "c_usa_jungmar_gear2";
//	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

redshirt_LMG_nogear()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head3_nc";
	self attach(self.headModel, "", true);
//	self.gearModel = "c_usa_jungmar_gear3";
//	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";	
}

redshirt_shotgun_nogear()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head4_nc";
	self attach(self.headModel, "", true);
//	self.gearModel = "c_usa_jungmar_gear4";
//	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";	
}

redshirt_sniper_nogear()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head5_nc";
	self attach(self.headModel, "", true);
//	self.gearModel = "c_usa_jungmar_gear5";
//	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";	
}

redshirt_assault_nogear()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head1_nc";
	self attach(self.headModel, "", true);
//	self.gearModel = "c_usa_jungmar_gear1";
//	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";	
}

redshirt_setup_basic()
{
	x = RandomInt( 5 );
	
	if( x == 0 )
	{
		self redshirt_CQB_nogear();
	}
	else if( x == 1 )
	{
		self redshirt_LMG_nogear();
	}
	else if( x == 2 )
	{
		self redshirt_shotgun_nogear();
	}
	else if( x == 3 ) 
	{
		self redshirt_sniper_nogear();
	}
	else
	{
		self redshirt_assault_nogear();
	}

}

//******************************************************************************
//******************************************************************************

#using_animtree( "generic_human" );
bowman_boat_firing()
{
	level.scr_anim["rpg_stand_fire"]["woods_on_boat"] = %rpg_stand_fire;
	level.scr_anim["rpg_stand_reload"]["woods_on_boat"] = %rpg_stand_reload;
}

#using_animtree( "vehicles" );
helicopter_death_anims()
{
	level.scr_anim["us_pilot_2"]["heli_deaths"] 	= %V_pow_b03_hind_crash_left1;  // violent spin death - yaw	
	level.scr_anim["us_pilot_1"]["heli_deaths"] 	= %V_pow_b03_hind_crash_right2;  // moderate speed death spin - yaw with pitch
	level.scr_anim["us_pilot_3"]["heli_deaths"] 	= %V_pow_b03_hip_crash_right;  // initial jolt hit, moderate pitch + yaw
}


/*==========================================================================
FUNCTION: helicopter_crash_path
SELF: helicopter that will crash
PURPOSE: easy way to animate helicopters on splines for a crash path

ADDITIONS NEEDED:
==========================================================================*/
#using_animtree( "vehicles" );
helicopter_crash_path( spline_name, anim_name, timed_death, death_start_notify )
{
	if( !IsDefined( spline_name ) )
	{
		PrintLn( "spline_name is missing for helicopter_crash_path on " + self.targetname );
		return;
	}
		
	if( !IsDefined( anim_name ) )
	{
		PrintLn( "anim_name is missing for helicopter_crash_path on " + self.targetname );
		return;
	}
	
	path_start = GetVehicleNode( spline_name, "targetname" );
	if( !IsDefined( path_start ) )
	{
		PrintLn( "path_start is missing for " + self.targetname );
		return;
	}
	
	//self SetVehGoalPos( self.currentnode.origin );
	self ClearVehGoalPos();
	self ResumeSpeed( 30 );
	
	self useAnimTree( #animtree ); 
	self.animname = anim_name;
	//self SetDrivePathPhysicsScale( 3.0 );
	self.drivepath = 1;
	self thread go_path( path_start );
//	self AttachPath( path_start );
//	self StartPath( path_start );
	
	if( IsDefined( death_start_notify ) )
	{
		self waittill( death_start_notify );
	
		PlayFX( level._effect[ "heli_death" ], self.origin );			
		self AttachPath( path_start );
	}
	
	self thread anim_single( self, "heli_deaths" );
	
	if( IsDefined( timed_death ) )
	{
		wait( timed_death );
	}
	else
	{
		self waittill( "reached_end_node" ); // this is the default case, but it rarely looks good. 
	}
	
	PlayFX( level._effect[ "heli_death" ], self.origin );  // should be set up in river_fx.gsc
	playsoundatposition( "exp_veh_large" , self.origin );
	
	wait( 0.4 );
	//IPrintLnBold( "killing heli!" );
	self.takedamage = true;
	self Delete();
	//RadiusDamage( self.origin, 400, self.health + 100, self.health + 90 );
}

/*

//---------------------------------------------------------------------------
// Boat Drag Anims

#using_animtree ("generic_human");
boat_drag_human_anims_setup()
{
	// rope tying start
	level.scr_anim["woods"]["hook_up_ropes"] 			= %ch_river_b02_hookupropes_woods_A;
	addNotetrack_customFunction( "woods", "grab_ropes", maps\river_boat_drag::notetrack_attach_ropes_to_woods, "hook_up_ropes" );  
	level.scr_anim["bowman"]["hook_up_ropes"] 		= %ch_river_b02_hookupropes_bowman_A;
	level.scr_anim["woods"]["rope_done"] 					= %ch_river_b02_hookupropes_woods_B;
	level.scr_anim["bowman"]["rope_done"] 				= %ch_river_b02_hookupropes_bowman_B;
	
	level.scr_anim["woods"]["dragged"] 			= %ch_upacreek_b03_dragged_pbr_guy_1;
	//level.scr_anim["reznov"]["dragged"] 		= %ch_upacreek_b03_dragged_pbr_guy_2;
	level.scr_anim["bowman"]["dragged"] 		= %ch_upacreek_b03_dragged_pbr_guy_3;
	level.scr_anim["boat_guy_4"]["dragged"] = %ch_upacreek_b03_dragged_pbr_guy_4; // drops from sky
	// add fx to the slamming death guy
	addNotetrack_customFunction( "boat_guy_4", "sndnt#evt_bd_guy4_bodyslam", maps\river_boat_drag::notetrack_blood_guy_falling, "dragged" );  
	// This anim used an AI for player body. We should change this to an actual full body anim
	level.scr_anim["player_legs"]["dragged"] 		= %ch_upacreek_b03_dragged_pbr_ply_stdin;
	
	// post boat drag
	level.scr_anim[ "woods" ][ "stay_with_us" ] = %ch_river_b02_stay_with_us_woods;
	level.scr_anim[ "woods" ][ "gone_for_now" ] = %ch_river_b02_gone_for_now_woods;
}

#using_animtree ("vehicles");
boat_drag_vehicle_anims_setup()
{
	// the main pbr the player is on
	level.scr_anim["pbr"]["dragged"]	 				= %v_pbr_upacreek_b03_dragged;
	// custom fx when we slam into other pbrs.
	addNotetrack_customFunction( "pbr", "evt_bd_plrboat_boat1_hit", maps\river_boat_drag::notetrack_pbr_hit_fx_1, "dragged" );  
	addNotetrack_customFunction( "pbr", "evt_bd_ plrboat _boat2_hit", maps\river_boat_drag::notetrack_pbr_hit_fx_2, "dragged" );  
	addNotetrack_customFunction( "pbr", "evt_bd_ plrboat _boat3_hit", maps\river_boat_drag::notetrack_pbr_hit_fx_3, "dragged" );  

	// the chinook 
	level.scr_anim["chinook"]["dragged"]	 		= %v_chinook_upacreek_b03_dragged;

	// the 3 pbrs that we bump into
	level.scr_anim["crash_pbr1"]["dragged"]	 	= %v_pbr_upacreek_b03_dragged_crash_1;
	level.scr_anim["crash_pbr2"]["dragged"]	 	= %v_pbr_upacreek_b03_dragged_crash_2;
	level.scr_anim["crash_pbr3"]["dragged"]	 	= %v_pbr_upacreek_b03_dragged_crash_3;

	// when the pbr is finally released
	level.scr_anim["pbr"]["released"]	 				= %v_pbr_upacreek_b03_boat_released;
}

#using_animtree ( "player" );
boat_drag_player_anims_setup()
{
	level.scr_anim["player_hands"]["dragged"] 	= %int_upacreek_b03_dragged;
	
	level.scr_anim["player_body"]["prepare_rope_hookup"] 		= %ch_river_b02_hookupropes_player_A;
	level.scr_anim["player_body"]["hook_up_ropes"] 					= %ch_river_b02_hookupropes_player_B;
}

*/

//******************************************************************************
//******************************************************************************

#using_animtree ( "critter" );
setup_cattle()
{
	level.scr_anim["buffalo"]["idle_a"][0] = %a_water_buffalo_idle_a;	// [0] - means looping
	level.scr_anim["buffalo"]["idle_b"][0] = %a_water_buffalo_idle_b;
	
	level.scr_anim["buffalo"]["react_a"] = %a_water_buffalo_react_a;
	level.scr_anim["buffalo"]["react_b"] = %a_water_buffalo_react_b;

	level.scr_anim["buffalo"]["run_a"] = %a_water_buffalo_run_a;
	level.scr_anim["buffalo"]["run_b"] = %a_water_buffalo_run_b;
	
	level.scr_anim["buffalo"]["death_a"] = %a_water_buffalo_death_a;
	level.scr_anim["buffalo"]["death_b"] = %a_water_buffalo_death_b;
}


//******************************************************************************
//******************************************************************************

#using_animtree( "critter" );
buffalo_grazing( start_struct )
{
	self endon("death");
	self endon("damage");

	self UseAnimTree( #animtree );
	self.animname = "buffalo";
		
	// We have 2 anmation types _a and _b
	rval = randomint( 2 );
	if( rval )
	{
		anim_type = "_a";
	}
	else
	{
		anim_type = "_b";
	}
		
	// Setup a thread checking for being shot
	anim_name = "death" + anim_type;
	self thread buffalo_damage_check( anim_name );
		
	// Set the Idle State and wait for the scatter trigger
	idle_name = "idle" + anim_type;
	self thread anim_loop( self, idle_name );
	
	cattle_scatter_trigger = GetEnt( "cattle_scatter_trigger", "targetname" );
	cattle_scatter_trigger waittill( "trigger" );	

	//*****************************
	//*****************************

	// Random wait, so all the cattle don't run at the same time
	delay = randomfloatrange( 0.01, 0.35 );
	wait( delay );

	link_origin = spawn( "script_model", self.origin );
	link_origin.angles = self.angles;
	link_origin SetModel( "tag_origin" );
	self linkto( link_origin, "tag_origin" );
	
	self.linked_origin = link_origin;

	// Reaction animation
	//react_name = "react" + anim_type;
	//self anim_single( self, react_name );
	
	// Thread the run animation
	run_name = "run" + anim_type;
	self thread anim_single( self, run_name );

	// Moo looping sound
	self playLoopSound( "cowloop" ); 
	self.moo_loop = 1;

	// Loop through the path of structs
	start_speed = 225;
	max_speed = randomfloatrange( 300, 400 );
	move_speed = start_speed;
	while( isdefined(start_struct.target) )
	{
		next_struct = getstruct( start_struct.target, "targetname" );
		distance_to_end = distance( start_struct.origin, next_struct.origin );
		time = distance_to_end / move_speed;
		if( isdefined( next_struct.angles ) )
		{
			// Don't want to rotate too slowly
			//link_origin.angles = next_struct.angles;
			link_origin rotateTo( next_struct.angles, 0.4, 0.2, 0.2 );
		}
		
		link_origin moveTo( next_struct.origin, time );
		link_origin waittill( "movedone" );
		start_struct = next_struct;
		
		if( move_speed != max_speed )
		{
			move_speed = max_speed;
		}
	}

	self stoploopsound( 1 );
	self.moo_loop = 0;
	wait( 1 );

	self unlink();
	link_origin delete();

	// Kill off the buffalo
	self delete	();
}

//******************************************************************************
// self = buffalo
//******************************************************************************

buffalo_damage_check( death_anim )
{
	self endon( "death" );

	self waittill( "damage" );
	
	// Stop looping audio and play a dead moo sound
	if( isdefined(self.moo_loop) )
	{
		if( self.moo_loop == 1 )
		{
			self stoploopsound( 1 );
		}
	}
	
	// Stop the cow
	if( isdefined( self.linked_origin ) )
	{
		self.linked_origin moveTo( self.origin, 1 );
	}
		
	self playsound("Moo/Ow");
	
	self anim_single( self, death_anim );

	//wait( 0.35 );

	// If the cattle havn't scattered yet, scatted them
	cattle_scatter_trigger = GetEnt( "cattle_scatter_trigger", "targetname" );
	if( isdefined( cattle_scatter_trigger ) )
	{
		cattle_scatter_trigger activate_trigger();
	}

	//wait( 60 );
	//self delete();
}


//******************************************************************************
//******************************************************************************


#using_animtree ("river");
setup_plane_nose_fall()
{
	level.scr_animtree[ "plane_nose" ] 	= #animtree;
	level.scr_model["plane_nose"] = "tag_origin_animate";
	level.scr_anim["plane_nose"]["plane_nose_fall"] 		= %o_river_b03_nose_dive_nose;
	
	//apple for capture
	level.scr_animtree[ "plane_apple" ] 	= #animtree;
	level.scr_model["plane_apple"] = "tag_origin_animate";
	level.scr_anim["plane_apple"]["pickup_bowman"] 		= %o_river_b03_playerstruggle_apple;
	
	
}

setup_plane_crate()
{
	level.scr_animtree[ "crate" ] 	= #animtree;
	level.scr_model["crate"] = "tag_origin_animate";
	level.scr_anim["crate"]["crate_loop"][0]		= %o_river_b03_c130_crate_base;

	level.scr_animtree[ "crate_lid" ] 	= #animtree;
	level.scr_model["crate_lid"] = "tag_origin_animate";
	level.scr_anim["crate_lid"]["crate_lid_loop"][0]		= %o_river_b03_c130_crate_lid_loop;
	level.scr_anim["crate_lid"]["crate_lid_open"]				= %o_river_b03_c130_crate_lid_open;

	//level.scr_animtree[ "crate_blocker" ] 	= #animtree;
	level.scr_anim["crate_blocker"]["crate_blocker_loop"][0]		= %o_river_b03_c130_blocker_loop;
	level.scr_anim["crate_blocker"]["crate_blocker_open"]				= %o_river_b03_c130_blocker_open;
}

setup_plane_map()
{
	level.scr_animtree[ "map" ] = #animtree;	
	level.scr_model[ "map" ] = "tag_origin_animate";
	level.scr_anim[ "map" ][ "map_pickup" ] = %o_river_b03_c130_map_pickup;
	level.scr_anim[ "map" ][ "map_loop" ][0] = %o_river_b03_c130_map_loop;
	
	addNotetrack_customFunction( "map", "delete_map", ::map_delete, "map_pickup" );
}

map_delete( crate_map )
{
	map_model = GetEnt( "crate_map", "targetname" );
	if( IsDefined( Map_model ) )
	{		
		map_model Delete();
	}
	else
	{
		PrintLn( "crate_map is missing" );
	}
}

plane_nose_fall( guy )
{
	//IPrintLn( "slowmo_here" );
	
}

//player pulls out gun
plane_capture_gun( guy )
{
	
	level notify( "gun_on" );
		
}

//gun kicked out of player hands
plane_capture_kick( guy )
{
	
}

//player kicked in face
plane_capture_face( guy )
{
	
	
}


//******************************************************************************
//******************************************************************************


#using_animtree ("generic_human");
setup_generic_anims()
{
	//patrol
	level.scr_anim[ "generic" ][ "patrol_walk" ]					= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;

	//capture
	//level.scr_anim["kicker"]["kick"] = %ch_vor_b01_tunnel_gaurd_beat_loop1;
	//level.scr_anim["generic"]["kick"] = %ai_doorbreach_kick;
	
	//enemy kick gun
	level.scr_anim["kicker"]["kick_gun"] = %ch_river_b03_enemy_kick_gun;
	
	//enemy pickup bowman
	level.scr_anim["bowman"]["pickup_bowman"] = %ch_river_b03_bowman;
	level.scr_anim["guy1"]["pickup_bowman"] = %ch_river_b03_enemy_pick_up_bowman_guy1;
	level.scr_anim["guy2"]["pickup_bowman"] = %ch_river_b03_enemy_pick_up_bowman_guy2;
	level.scr_anim["kravchenko"]["pickup_bowman"] = %ch_river_b03_playerstruggle_kravchenko;
	level.scr_anim["dragovich"]["pickup_bowman"] = %ch_river_b03_playerstruggle_dragovich;
	level.scr_anim["woods"]["pickup_loop"][0] = %ch_river_b03_playerstruggle_woods;

	//crate anim
	level.scr_anim["bowman"]["crate_loop"][0] = %ch_river_b03_c130_crate_bowman_loop;
	level.scr_anim["woods"]["crate_loop"][0] = %ch_river_b03_c130_crate_woods_loop;
	level.scr_anim["generic"]["crate_loop"][0] = %ch_river_b03_c130_crate_dead_guy_loop;
	level.scr_anim["bowman"]["crate_anim"] = %ch_river_b03_c130_crate_bowman;
	level.scr_anim["woods"]["crate_anim"] = %ch_river_b03_c130_crate_woods;
	level.scr_anim["generic"]["crate_anim"] = %ch_river_b03_c130_crate_dead_guy;
	
	addNotetrack_customFunction( "woods", "cratebash", ::spawn_china_lake, "crate_anim" );  

	level.scr_anim["reznov"]["finally_mason"] = %ch_river_b02_finallymason_reznov;
	level.scr_anim["reznov"]["krav_near"] = %ch_river_b02_kravchenkonear_reznov;
}

spawn_china_lake( guy )
{
	level notify( "spawn_china_lake" );
}

play_reznov_anim( anim_ref, tag )
{
	if( !IsDefined( tag ) )
	{
		level.reznov anim_single( level.reznov, anim_ref );
	}
	else
	{
		level.boat anim_single_aligned( level.reznov, anim_ref, tag );
	}
}

kick_gun( guy )
{
	level notify( "gun_off" );
}

face_kick( guy )
{
	player = get_players()[0];
	player ShellShock( "default", 4 );
	level maps\river_drive::fullscreen_shader_fade( "black", 3.5, 0, 1 );
}
