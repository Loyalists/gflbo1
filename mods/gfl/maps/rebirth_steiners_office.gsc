/*
	Rebirth: Steiner's Office Event - 
		
	The player runs to Steiner's Office and confront Mason.  Afterwards, they leave the lab and go to the docks.
	Level ends.
*/

#include maps\_utility;
#include common_scripts\utility; 
#include maps\_vehicle;
#include maps\rebirth_anim;
#include maps\rebirth_utility;
#include maps\_rusher;
#include maps\_anim;
#include animscripts\Utility;
#include animscripts\anims;
#include maps\_music;



/*------------------------------------------------------------------------------------------------------------
																								Event:  Steiner's Office
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
//
event_security_room()
{
	wait(.05);
	
	maps\createart\rebirth_art::lower_lab_area_fog();
	VisionSetNaked( "rebirth_lab_interior", 2 );
	
	//Security Room Door
	security_door = GetEnt("security_door", "targetname");
	security_door_clip = GetEnt("security_door_clip", "targetname");
	security_door_clip LinkTo(security_door);
		
	//flash_door 	= GetEnt( "flash_room_door", "targetname" );
	//flash_door ConnectPaths();
	//flash_door Delete();	
	// Update bilboard

	player = get_players()[0];
	level notify("activate_event5_triggers");
	event_trigger = GetEnt( "security_office_start", "targetname" );
	event_trigger UseBy( player );
	security_room_vo();
}

event_steiners_office()
{	
	level thread steiners_office_objectives();
	
	// event functions
	toggle_event5_triggers(true);
	thread spawn_hazmat_enemies();
	run_to_steiners_office();
	spawn_steiners_office_ai();
	steiners_office_breakin();
	//level thread lab_escape_ambience();
	//level thread chinook_lands();
	//level thread player_at_chinook();
	
	flag_wait( "event_steiners_office_done" );
}

security_room_vo()
{
	thread one_shot_event5_color_triggers();
	
	player = get_players()[0];
	player.animname = "hudson";
	weaver = level.heroes[ "weaver" ];
	weaver.animname = "weaver";
	
	weaver_trigger = GetEnt( "weaver_security_room_trigger", "targetname");
	vo_trigger = GetEnt( "security_room_vo_trigger", "targetname");
	hudson_trigger = GetEnt( "hudson_enter_security_room", "targetname" );
	sync_node = getstruct("weaver_security_room_anim", "targetname");
	door_node = GetNode("weaver_door_node", "script_noteworthy");
	event4_trigger = GetEnt("event4_end", "script_noteworthy");

	weaver_trigger waittill( "trigger", weaver );//wait for both weaver and mason to be in place
	weaver disable_ai_color();
	//flag_wait( "player_entered_security_room" );
	//hudson_trigger waittill( "trigger", player );
	//play security room VO	
	//weaver = level.heroes[ "weaver" ];
	//weaver.animname = "weaver";	
	//weaver disable_ai_color();
	//player anim_single(player, "its_him");

	sync_node anim_reach_aligned(weaver, "security_react");
	sync_node thread anim_single_aligned(weaver, "security_react");
	weaver enable_ai_color();
	event4_trigger UseBy( player );
	thread rb_objective_breadcrumb( level.obj_iterator, "security_room_vo_trigger" );
	wait(.05);	
	Objective_Add( level.obj_iterator, "current", &"REBIRTH_OBJECTIVE_2" );//REBIRTH_OBJECTIVE_2	
	vo_trigger UseBy( player );//Continue color nodes
	
	//player anim_single(player, "killing_everyone");
	
	//Objective_Position( level.obj_iterator, weaver );
	//objective_Set3d( level.obj_iterator, true, "default", &"REBIRTH_FOLLOW" );
	thread rb_objective_breadcrumb( level.obj_iterator, "weaver_near_security_door" );	
	weaver.ignoreall = true;
	//wait(1);
	thread stealth_checker();
	thread stealth_trigger_checker();
	weaver thread weaver_ignore_toggler();
	level thread maps\rebirth_hudson_lab::corpse_memory_place_models();
	thread lab_vo();
}

player_react_security_room()
{
	player = get_players()[0];
	player anim_single(player, "its_him");
}

security_door_open( guy )
{
	door = GetEnt( "security_door", "targetname" );
	door_open = (14495.5, 14505.8, -136);
	//door MoveTo(door.origin + ( 0, 0, 500 ), 0.5 );
	door MoveTo( door_open, 0.4);

	door ConnectPaths();
}

weaver_ignore_toggler()
{
	//flag_wait("toggle_weaver_true");
	//self.ignoreall = false;
	//flag_wait("player_looking_for_hazmat");
	//self.ignoreall = true;
	level waittill("stealthbreak");
	self.ignoreall = false;
}

lab_vo()
{
	level endon( "hudson_in_office" );
	
	//wait(19);
	//trigger_wait("objective_stairwell_top");
	//trigger_wait("objective_stairwell_bottom");
	
	weaver = level.heroes[ "weaver" ];
	weaver.animname = "weaver";
	
	player = get_players()[0];
	player.animname = "hudson";
	player thread vo_for_hazmat_enemies();
	
	level waittill("stealthbreak");
	
	wait(3);
	
	weaver anim_single(weaver, "what_the_hell_was_that");
	player anim_single(player, "it_is_steiner");
	wait(0.5);
	player anim_single(player, "what_is_the_situtation");
	player anim_single(player, "drag_round_up");
	player anim_single(player, "those_no_longer");
	player anim_single(player, "you_must_hurry");
	wait(0.5);
	//player anim_single(player, "mason_talk_to_me");//kevin took this line out because this isnt supposed to play on hudson and we dont have the unfutzed version
	
	mason_vo = Spawn( "script_model", player.origin );
	mason_vo SetModel( "tag_origin" );
	mason_vo.animname = "mason";
	mason_vo anim_single( mason_vo, "this_is_the_end" );
	
	//level notify("lab_vo_ended");
	flag_set("lab_vo_done");
}

vo_for_hazmat_enemies()
{
	self endon("death");
	level endon("stealthbreak");
	
	weaver = level.heroes[ "weaver" ];
	weaver.animname = "weaver";
	
	player = get_players()[0];
	player.animname = "hudson";
	
	//level waittill("lab_vo_ended");
	flag_wait("toggle_stealth_on");
	
	wait(3);
	
	weaver anim_single(weaver, "where_are_they_going");
	player anim_single(player, "did_not_see_us");
}
	
one_shot_event5_color_triggers()
{
	color_triggers = GetEntArray( "event5_lab", "targetname" );	
	for(x = 0; x < color_triggers.size; x++)
	{
		color_triggers[x].script_color_auto_disable = 1;
	}
}	


//------------------------------------
// wait for the player to reach the area near
// the office
run_to_steiners_office()
{	
	office_trig = GetEnt("hudson_near_office", "targetname");
	if(level.start_point == "steiners_office")
		office_trig trigger_on();//make sure this is active before we wait
	office_trig SetCursorHint( "HINT_NOICON" );
	office_trig SetHintString( &"REBIRTH_OPEN_STEINER_DOOR" );
	
	//SOUND - Shawn J
	playsoundatposition ("evt_security_door", (14472, 14558, -86));
	
	office_trig waittill( "trigger" );
	
	//SOUND - Shawn J
	playsoundatposition ("evt_final_door", (14949, 11407, -269));
	
	clientNotify ("fss");
	
	//TUEY set music to END SCENE (again)
	setmusicstate("END_SCENE");
	
	level flag_set( "hudson_in_office" );
	office_trig Delete();
}



//------------------------------------
// Spawn the actors inside the lab
spawn_steiners_office_ai()
{
	//trigger_use( "steiners_office_actors" );
	wait(.05);
}



//------------------------------------
//
#using_animtree( "generic_human" );
steiners_office_breakin()
{
	objective_Set3d( level.obj_iterator, false );
	
	flag_init("tunnel_vo_done");
	autosave_by_name("end_steiner_office");
	anim_struct = getstruct( "steiner_office", "targetname" );
	
	chair_struct = getstruct("steiner_chair", "targetname");
	chair = Spawn("script_model", chair_struct.origin);
	chair.angles = chair_struct.angles;
	chair SetModel("p_rus_computer_terminal_chair_blood");
	chair HidePart("tag_blood");
	
	// grab all relevant actors/props
	steiner = Spawn("script_model", anim_struct.origin);
	// steiner SetModel("c_ger_steiner_rebirth_fb");
	steiner Detach(steiner.headModel);
	steiner SetModel("t5_gfl_suomi_body");
	steiner.headModel = "t5_gfl_suomi_head";
	steiner attach(steiner.headModel, "", true);
	//steiner = get_ai( "steiner", "script_noteworthy" );
	//steiner.ignoreall = true;	
	//steiner set_ignoreme( true );
	//steiner gun_remove();
	
	// mason
	//mason = Spawn("script_model", anim_struct.origin);
	//mason SetModel("c_usa_rebirth_mason_fb");
	//mason thread setup_mason();
	mason_model = GetEnt("rebirth_mason", "targetname");
	mason = mason_model StalingradSpawn();
	mason gun_remove();
	mason gun_switchto( "makarov_sp", "right" );
	
	// weaver
	weaver	= level.heroes[ "weaver" ];
	
	// fuse box
	fusebox = GetEnt( "fusebox2", "targetname" );
	fusebox.animname = "fuse";
	fuse_jnt = spawn("script_model",fusebox.origin);
	fuse_jnt setmodel("tag_origin_animate");	
	fuse_jnt.angles = fusebox.angles;
	fusebox linkto( fuse_jnt, "origin_animate_jnt" );

	// player
	player 	= get_players()[0];	
	player SetClientDvar("cg_drawFriendlyNames", 0);
	player TakeWeapon("frag_grenade_sp");
	player DisableWeapons();
	player EnableInvulnerability();
	player_body = spawn_anim_model( "player_body_hazmat", player.origin, player.angles );
	player_body Hide();
	
	// set all the animnames and animtrees
	weaver.animname = "weaver";
	steiner.animname = "steiner";
	mason.animname = "mason";
	//mason UseAnimTree( #animtree );
	steiner UseAnimTree( #animtree );
	fuse_jnt.animname = "fuse";
	fuse_jnt UseAnimTree( level.scr_animtree["fuse"] );
	player_body.animname = "player_body_hazmat";		
	player_body UseAnimTree( level.scr_animtree["player_body_hazmat"] );

	anim_ents = [];
	anim_ents[ anim_ents.size ] = player_body;
	anim_ents[ anim_ents.size ] = weaver;
	anim_ents[ anim_ents.size ] = fuse_jnt;
	anim_ents[ anim_ents.size ] = steiner;
	anim_ents[ anim_ents.size ] = mason;
	
 	//wait(.4);
	
	anim_struct thread anim_single_aligned( anim_ents, "office_intro" );
	wait .05;
	player HideViewModel();
	player StartCameraTween(.2);
	player PlayerLinktoAbsolute( player_body, "tag_player" );
	wait .3;
	player_body Show();

	anim_struct waittill("office_intro");
	
	player thread breakin_wait_fuse_pickup( level.scr_anim[ player_body.animname ][ "office_fuse_idle" ], anim_ents );
	anim_struct thread anim_single_aligned( anim_ents, "office_fuse_idle" );
	
	flag_wait( "breakin_fuse_picked_up" );
	
	trigger_use( "steiners_office_backup" );
	
	weaver gun_remove();
	
	//-- Try to keep anyone from shooting during this scene
	//array_thread(anim_ents, maps\_utility::set_ignoreall, true);
	for(i = 0; i < anim_ents.size; i++)
	{
		if(IsAI(anim_ents[i]))
		{
			anim_ents[i] thread maps\_utility::set_ignoreall(true);
		}
	}
	
	axis = GetAIArray("axis");
	array_delete(axis);
	
	// player StartCameraTween( 0.05 );		
	anim_ents = array_remove( anim_ents, mason );
	anim_ents = array_remove( anim_ents, player_body );
	
	//anim_struct thread anim_single_aligned( mason, "office_window_break" );
	//anim_struct thread anim_single_aligned( player_body, "office_window_break" );
	mason thread mason_animations(anim_struct);
	player_body thread player_beating_mason(anim_struct, mason);
	anim_struct anim_single_aligned( anim_ents, "office_window_break" );
	screen_message_delete();
	
	anim_ents = array_remove( anim_ents, fuse_jnt );
	anim_ents = array_remove( anim_ents, steiner );
	
	//chair = GetEnt("steiner_chair", "targetname");
	floor_blood = GetEnt("steiner_floor_blood", "targetname");
	if( is_mature() )
	{
		// steiner SetModel("c_ger_steiner_rebirth_dead_fb");		
		chair ShowPart("tag_blood");
		floor_blood Show();
		
		//exploder(503);
		//level thread debug_blood_drip(steiner);
		steiner_blood_drip_position = steiner GetTagOrigin( "j_forehead_ri" );
		PlayFX(level._effect["fx_blood_drip"], steiner_blood_drip_position + (1, -6, 0));
	}
	else
	{
		floor_blood Hide();
	}
	
	/*if( !flag( "hit_success" ) )
	{	
		anim_struct thread anim_single_aligned( anim_ents, "office_fail" );	
		anim_struct thread anim_loop_aligned( steiner, "dead_steiner" );	
		MissionFailed();
		fail_to_black();
	}*/
	
	// remove proper elements from anim_ents array, play ending stuffs
	anim_struct thread anim_single_aligned( fuse_jnt, "office_fuse_end" );
	anim_struct thread anim_loop_aligned( steiner, "dead_steiner" );	
	
	fusebox Unlink();
	
	mason_carrier 	= get_ai( "carter_carrier", "script_noteworthy" );	//mason, need to change this
	mason_carrier thread maps\rebirth_hudson_lab::detach_mask();
	mason_carrier magic_bullet_shield();
	mason_carrier.animname = "carrier";
	
	office_redshirt2 	= get_ai( "office_redshirt", "script_noteworthy" );
	office_redshirt2 thread maps\rebirth_hudson_lab::detach_mask();
	office_redshirt2 magic_bullet_shield();
	office_redshirt2.animname = "redshirt2";
	
	door_blocker = get_ai("door_blocker", "script_noteworthy");
	door_blocker thread maps\rebirth_hudson_lab::detach_mask();
	door_blocker magic_bullet_shield();
	
	//anim_ents[ anim_ents.size ] = mason_carrier;
	anim_ents[ anim_ents.size ] = office_redshirt2;
	
	// level.weaver_weapon = spawn_model("t5_weapon_enfield_world");
	level.weaver_weapon = spawn_model("ak12_world_model");
	level.weaver_weapon HidePart("tag_aimpoint");
	level.weaver_weapon HidePart("tag_dual_clip");
	level.weaver_weapon HidePart("tag_elbit");
	level.weaver_weapon HidePart("tag_ext_mag");
	level.weaver_weapon HidePart("tag_flame_unit");
	level.weaver_weapon HidePart("tag_grenade_launcher");
	level.weaver_weapon HidePart("tag_iron_sights");
	level.weaver_weapon HidePart("tag_suppressor");
	level.weaver_weapon HidePart("tag_susat");
	level.weaver_weapon HidePart("tag_masterkey");
	
	weapon_script_model = Spawn("script_model", level.weaver_weapon.origin);
	weapon_script_model SetModel("tag_origin_animate");
	weapon_script_model.angles = level.weaver_weapon.angles;
	weapon_script_model.animname = "weaver_weapon";
	weapon_script_model UseAnimTree( level.scr_animtree["weaver_weapon"] );
	level.weaver_weapon LinkTo( weapon_script_model, "origin_animate_jnt" );
	anim_ents[ anim_ents.size ] = weapon_script_model;

	mason_carrier thread carry_loop(anim_struct);	
	// level waittill("start_success");
	anim_struct anim_single_aligned( anim_ents, "office_success" );
	//anim_struct thread anim_loop_aligned( mason, "office_downloop" );

	//level notify( "remove_mason_gun" );
		
	/*
	player Unlink();
	player_body Delete();
	player EnableWeapons();
	player DisableInvulnerability();	
	player thread set_player_end_conditions();
	*/
	weaver PushPlayer( true );
	trigger_use( "move_friends_into_office" );
	
	/*
	weaver_window_break_len = GetAnimLength( level.scr_anim[ "weaver" ][ "office_window_break" ] );
	weaver_success_len = GetAnimLength( level.scr_anim[ "weaver" ][ "office_success" ] );
	player_window_break_len = GetAnimLength( level.scr_anim[ "player_body_hazmat" ][ "office_window_break" ] );
	wait_time = (weaver_window_break_len + weaver_success_len) - player_window_break_len;
	wait( wait_time );		// not all anims are same length
	*/
	
	weaver waittillmatch( "single anim", "end" );
	weaver anim_set_blend_in_time(0.14);
	weaver anim_set_blend_out_time(0.14);
	weaver enable_cqbwalk();
	//weaver enable_cqbsprint();
	trigger_use( "leave_office" );
	
	//mason anim_first_frame( mason, "mason_pickup" );
	//thread toggle_barrel_damage(false);
	//wait( 2 );	
	Objective_State( level.obj_iterator, "done" );  
	level.obj_iterator++;
	Objective_Add( level.obj_iterator, "current", &"REBIRTH_OBJECTIVE_4" );//REBIRTH_OBJECTIVE_4
	//thread rb_objective_breadcrumb( level.obj_iterator, "event5_objective_start" );
	//objective_trigger = GetEnt( "event5_objective_start", "targetname" );
	//objective_trigger UseBy( player );
	
	level notify("stop_down_loop");
	mason_carrier thread carry_watcher( mason, anim_struct );	
	weaver anim_single(weaver, "this_way_to_dock");//Turn this back on when we get the whole anim set
	
	weaver office_ending_vo();
	//thread track_tunnel_enemies();
	
//	anim_struct thread anim_single_aligned(mason_carrier, "mason_pickup");

	//anim_struct thread anim_loop_aligned(mason_carrier, "mason_carry");
	/*mason thread actor_play_anim(mason_carrier, "mason_carry", true);
	//mason_carrier thread anim_loop_aligned(level.office_mason, "mason_carry", "tag_origin");	
	wait(.05);
	mason_carrier set_generic_run_anim("mason_carry", true);
	mason_carrier.ignoreall = true;
	mason_carrier.disableArrivals = true;
	mason_carrier.disablepain = true;
	mason_carrier.disableturns = true;
	mason_carrier.goalradius = 16;*/
	//trigger_use( "mason_carry_trigger" );
	//autosave_by_name("tunnel_exit");
	
	//wait(2);
	fade_to_black();
	
	objective_Set3d( level.obj_iterator, false );
	
	player FreezeControls( true );
	player SetClientDVAR( "compass", "0" );
	player SetClientDVAR( "hud_showstance", "0" );
	player SetClientDVAR( "actionslotshide" , "1" );
	player SetClientDvar( "ammoCounterHide", "1" );
	player anim_single(player, "what_did_they_do");
	wait(3);
	nextmission();
	wait(3);//wait for mission end
}

debug_blood_drip(steiner)
{
	//steiner_blood_drip_position = steiner GetTagOrigin( "j_forehead_le" );
	steiner_blood_drip_position = steiner GetTagOrigin( "j_forehead_ri" );
	
	while(true)
	{	
		PlayFX(level._effect["fx_blood_drip"], steiner_blood_drip_position + (1, -6, 0));
		wait(1.0);
	}
}

mason_animations(anim_struct)
{
	self gun_remove();
	self gun_switchto( "makarov_sp", "right" );
	anim_struct anim_single_aligned( self, "office_window_break" );
	anim_struct anim_loop( self, "office_downloop", "stop_down_loop" );
}

player_beating_mason(anim_struct, mason)
{
	player = get_players()[0];
	player thread mason_punch_player(mason);
	
	anim_struct anim_single_aligned( self, "office_window_break" );
	
	//level notify( "remove_mason_gun" );
	mason gun_remove();

	player Unlink();
	self Delete();
	player EnableWeapons();
	player SetClientDvar("cg_drawFriendlyNames", 1);
	//player DisableInvulnerability();	
	player thread set_player_end_conditions();
}

mason_punch_player(mason)
{
	wait_time = GetAnimLength(level.scr_anim[ "player_body_hazmat" ][ "office_window_break" ]);
	
	wait_time = wait_time - 5.4;
	
	wait(wait_time);
	
	self PlayRumbleOnEntity( "damage_heavy" );
	self DisableInvulnerability();	
	self DoDamage(50, mason.origin, mason);
}

carry_loop(anim_struct)
{
	anim_struct anim_single_aligned( self, "office_success" );
	anim_struct thread anim_loop(self, "mason_pickup_loop");	
}

carry_watcher( mason, anim_struct )
{
	actors = array(self);
	//anim_struct anim_reach_aligned(self, "mason_pickup");
	//self gun_remove();
	mason thread actor_play_anim(anim_struct, "mason_pickup", false);
	anim_struct anim_single_aligned(actors, "mason_pickup");
	mason LinkTo(self, "tag_origin");
	mason thread actor_play_anim(self, "mason_pickup_idle", true);
	//self thread anim_loop_aligned(mason, "mason_pickup_idle", "tag_origin");
	mason gun_switchto( "ak74u_sp", "right" );
	mason thread anim_loop_aligned(self, "mason_pickup_idle");
	/*flag_wait("carrier_move_one");
	self StopAnimScripted();
	self.goalradius = 16;
	mason.goalradius = 16;
	mason thread actor_play_anim(self, "mason_carry", true);
	//self thread anim_loop_aligned(mason, "mason_carry", "tag_origin");	
	self waittill("goal");
	mason thread actor_play_anim(self, "mason_pickup_idle", true);
	//self thread anim_loop_aligned(mason, "mason_pickup_idle", "tag_origin");
	mason thread anim_loop_aligned(self, "mason_pickup_idle");	
	flag_wait("tunnel_exit_player");
	self StopAnimScripted();
	self.goalradius = 16;
	mason.goalradius = 16;	
	mason thread actor_play_anim(self, "mason_carry", true);
	//self thread anim_loop_aligned(mason, "mason_carry", "tag_origin");	
	self waittill("goal");
	mason thread actor_play_anim(self, "mason_pickup_idle", true);
	//self thread anim_loop_aligned(mason, "mason_pickup_idle", "tag_origin");
	mason thread anim_loop_aligned(self, "mason_pickup_idle");	*/
}

body_mover()
{
	player = get_players()[0];
	while(level.move_body)
	{
		level.office_player_body.origin = player.origin;
		wait(.05);
	}
}

success_player(anim_struct)
{
	level.office_player_body player_play_anim(anim_struct, "office_success", false);
	level.mason_pistol Delete();
	self Unlink();
	level.office_player_body Delete();
	self EnableWeapons();
	self DisableInvulnerability();	
}

success_mason(anim_struct)
{
	self actor_play_anim(anim_struct, "office_success", false);
	self thread actor_play_anim(anim_struct, "office_downloop", true);
	//anim_struct anim_single_aligned( self, "office_success" );
	//anim_struct thread anim_loop_aligned( self, "office_downloop" );	
}

hit_slomo()
{
	anim_struct = getstruct( "steiner_office", "targetname" );
	mason 	= level.office_mason;//get_ai( "mason", "script_noteworthy" );
	steiner = get_ai( "steiner", "script_noteworthy" );
	weaver	= level.heroes[ "weaver" ];	
	fusebox = GetEnt( "fusebox2", "targetname" );
		
	level.fusemodel thread fuse_play_slomo(anim_struct, "office_window_break", level.hit_rate);
	level.office_player_body thread player_play_slomo(anim_struct, "office_window_break", level.hit_rate);
	steiner SetFlaggedAnimLimited( "single anim", level.scr_anim[ steiner.animname ][ "office_window_break" ], 1, 0, level.hit_rate );
	mason SetFlaggedAnimLimited( "single anim", level.scr_anim[ mason.animname ][ "office_window_break" ], 1, 0, level.hit_rate );
	weaver SetFlaggedAnimLimited( "single anim", level.scr_anim[ weaver.animname ][ "office_window_break" ], 1, 0, level.hit_rate );
	
	flag_wait("hit_success");
	
	level.fusemodel thread fuse_play_slomo(anim_struct, "office_window_break", 1);
	level.office_player_body thread player_play_slomo(anim_struct, "office_window_break", 1);
	steiner SetFlaggedAnimLimited( "single anim", level.scr_anim[ steiner.animname ][ "office_window_break" ], 1, 0, 1 );
	mason SetFlaggedAnimLimited( "single anim", level.scr_anim[ mason.animname ][ "office_window_break" ], 1, 0, 1 );
	weaver SetFlaggedAnimLimited( "single anim", level.scr_anim[ weaver.animname ][ "office_window_break" ], 1, 0, 1 );	
}

fail_to_black()
{
	fadeToBlack = NewHudElem(); 
	fadeToBlack.x = 0; 
	fadeToBlack.y = 0;
	fadeToBlack.alpha = 0;
	fadeToBlack.horzAlign = "fullscreen"; 
	fadeToBlack.vertAlign = "fullscreen"; 
	fadeToBlack.foreground = false; 
	fadeToBlack.sort = 50; 
	fadeToBlack SetShader( "black", 640, 480 );        
	fadeToBlack FadeOverTime( 2 );
	fadeToBlack.alpha = 1; 

	wait(2);
}

setup_mason()
{
	//self gun_remove();
	//wait(.5);
	//self gun_switchto("makarov_sp", "right");
	level.mason_pistol = Spawn( "script_model", self GetTagOrigin( "tag_weapon_right" ) );
	level.mason_pistol.angles = self GetTagAngles( "tag_weapon_right" );
	level.mason_pistol SetModel("t5_weapon_makarov_world");
	level.mason_pistol LinkTo(self, "tag_weapon_right");
	level.mason_pistol HidePart("TAG_ext_clip");
	level.mason_pistol HidePart("tag_suppressor");
	level.mason_pistol HidePart("TAG_upgraded_sights");
	//self set_ignoreme( true );
	self.script_friendname = "Mason";
	self.firecount = 0;
	
	level waittill( "remove_mason_gun" );
	level.mason_pistol Delete();
}

#using_animtree("rebirth");
fuse_play_anim( anim_node, anim_name, looping )
{
	self UseAnimTree( #animtree );
	if( IsDefined( looping ) && looping == true )
	{
		anim_node anim_loop_aligned( self, anim_name );	
	}
	else
	{
		anim_node anim_single_aligned( self, anim_name );	
	}
}

fuse_first_frame( anim_node, anim_name )
{
	self UseAnimTree( #animtree );
	anim_node thread anim_first_frame(self, anim_name);
}

fuse_play_slomo( anim_node, anim_name, rate )
{
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ anim_name ], 1, 0, rate );	
}

#using_animtree( "generic_human" );
actor_play_anim( anim_node, anim_name, looping )
{
	//self UseAnimTree( #animtree );
	if( IsDefined( looping ) && looping == true )
	{
		anim_node anim_loop_aligned( self, anim_name );	
	}
	else
	{
		anim_node anim_single_aligned( self, anim_name );	
	}
}

actor_play_slomo( anim_node, anim_name, rate )
{
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ anim_name ], 1, 0, rate );	
}

#using_animtree("player");
player_play_anim( anim_node, anim_name, looping )
{
	self UseAnimTree( #animtree );
	if( IsDefined( looping ) && looping == true )
	{
		anim_node anim_loop_aligned( self, anim_name );	
	}
	else
	{
		anim_node anim_single_aligned( self, anim_name );	
	}
}

player_first_frame( anim_node, anim_name )
{
	self UseAnimTree( #animtree );
	anim_node thread anim_first_frame(self, anim_name);
}

player_play_slomo( anim_node, anim_name, rate )
{
	self SetFlaggedAnimLimited( "single anim", level.scr_anim[ self.animname ][ anim_name ], 1, 0, rate );	
}

office_ending_vo()
{
	//self anim_single(self, "we_have_the_package");
	//wait(.5);
	self.animname = "us pilot";
	self anim_single(self, "taking_the_docks_now");
}

track_tunnel_enemies()
{
	self waittill("death");
	level.tunnel_death_counter++;
	if(level.tunnel_death_counter == 3)
	{
		player = get_players()[0];
		explode_trig = GetEnt( "trig_explode_jeep", "targetname" );
		explode_trig UseBy( player );		
	}
}

track_tunnel_death()
{
	self endon("death");
	flag_wait( "tunnel_exit_player" );
	self DoDamage( self.health + 100, (0,0,0) );
}

office_redshirts()
{
	self.ignoreall = true;
	self enable_cqbwalk();
	self PushPlayer( true );
	flag_wait("tunnel_exit_active");
	self.ignoreall = false;
}

set_steiner_window_model()
{
	window_frame = GetEnt( "weaver_break_window", "targetname" );
	level.steiner_window = spawn("script_model", window_frame.origin );
	level.steiner_window.angles = window_frame.angles - (0, 180, 0);
	level.steiner_window setmodel("p_rus_rb_steiner_window_01");	
}

//------------------------------------
// Crack the glass with each swing of the fuse
steiners_office_crack_glass( shatter )
{
	window_frame = GetEnt( "steiner_window_frame", "targetname" );
	player = get_players()[0];
	//start_struct  = getstruct( "crack_glass_start" );
	//end_struct		= getstruct( "crack_glass_end" );
	
	//MagicBullet( "ak47_silencer_sp", start_struct.origin, end_struct.origin );
	
	//if( shatter )
	/*{
		wait( .1 );
		PhysicsExplosionSphere( start_struct.origin - (0, 0, 48), 128, 16, 1 );
		RadiusDamage( start_struct.origin - (0, 0, 48), 128, shatter, shatter );
	}*/
	
	switch(shatter)
	{
		case 0:
			level.steiner_window SetModel("p_rus_rb_steiner_window_02");
			player PlayRumbleOnEntity( "damage_heavy" );
			exploder(501);
		break;
		
		case 1:
			level.steiner_window SetModel("p_rus_rb_steiner_window_03");
			player PlayRumbleOnEntity( "damage_heavy" );
			exploder(501);
		break;
		
		case 2:
			level.steiner_window SetModel("p_rus_rb_steiner_window_04");
			player PlayRumbleOnEntity( "grenade_rumble" );
			exploder(502);
		break;				
	}
}

hit_rumble(guy)
{
	player = get_players()[0];
	player PlayRumbleOnEntity( "damage_heavy" );
}

weaver_weapon_swap(guy)
{
	level.weaver_weapon Hide();
	weaver = level.heroes["weaver"];
	// weaver gun_switchto("enfield_ir_sp", "right");
	weaver gun_switchto("ak12_zm", "right");
}

mason_spit(guy)
{
	wait(0.25);
	//PlayFXOnTag(level._effect["blood_spit"], guy, "j_lip_top_ri");
	if( is_mature() )
	{
		PlayFXOnTag(level._effect["blood_spit"], guy, "j_jaw");
	}
}

mason_fire(guy)
{
	switch(guy.firecount)
	{
		case 0:
			//steiner = get_ai( "steiner", "script_noteworthy" );
			//self stop_magic_bullet_shield();
			//steiner DoDamage(steiner.health + 100, (0,0,0));
			
			//chair = GetEnt("steiner_chair", "targetname");
			//MagicBullet("makarov_sp", level.mason_pistol.origin, chair.origin);
			/*
			makarov_origin = level.mason_pistol GetTagOrigin("tag_flash");
			PlayFX(level._effect["makarov_flash"], makarov_origin);
			PlayFX(level._effect["makarov_shell"], makarov_origin);
			*/
		break;
		
		case 1:
			//weaver = level.heroes["weaver"];
			//MagicBullet("makarov_sp", level.mason_pistol.origin, weaver.origin);
			/*
			makarov_origin = level.mason_pistol GetTagOrigin("tag_flash");
			PlayFX(level._effect["makarov_flash"], makarov_origin);
			PlayFX(level._effect["makarov_shell"], makarov_origin);
			wait(1);
			*/
		break;
		
		case 2:
			wait(1);
		break;
	}
	guy.firecount++;
}

timescale_success_watch(guy)
{
	
}

timescale_fail(guy)
{
	flag_set( "hit_resolve" );
}


weaver_fire(guy)
{
	
}


/*------------------------------------
// THIS IS SUPER HACKY, GET IT IN FOR REVIEW
------------------------------------*/
steiners_office_freeze_anims( anim_ents, scene_name )
{
	anim_struct = getstruct( "anim_office_breakin", "targetname" );
	
	for( i = 0; i < anim_ents.size; i++ )
	{
		anim_ents[i] AnimScriptedSkipRestart( "breakin", anim_struct.origin, anim_struct.angles, level.scr_anim[ anim_ents[i].animname ][ scene_name ], "normal", undefined, 0.0 );	
	}
}



//------------------------------------
// 
mason_carry_by_ai()
{
	wait(2);
	
	carter_carrier 	= get_ai( "carter_carrier", "script_noteworthy" );	
	carter					= get_ai( "mason", "script_noteworthy" );	
	
	carter_carrier magic_bullet_shield();
	
	carter_mover = Spawn( "script_model", carter.origin );
	carter_mover setmodel( "tag_origin" );
	carter_mover.angles = carter.angles;
	carter LinkTo( carter_mover, "tag_origin" );	
	
	carter set_ignoreall( true );
	carter set_ignoreme( true );
	
	carter_mover RotateTo( carter_carrier.angles, .5 );
	carter_mover MoveTo( carter_carrier.origin + ( 0, 0, 76 ), .1 );	
	carter_mover waittill( "movedone" );
	carter_mover LinkTo( carter_carrier );
}

set_player_end_conditions()
{
	self AllowSprint( false );
	self AllowJump( false );
	self SetMoveSpeedScale(.5);//Slow player until heli lands
	self setlowready( true );	
}


//------------------------------------
// When the player reaches the heli, end the level
player_at_chinook()
{
	player = get_players()[0];
	weaver = level.heroes["weaver"];
	//trigger_wait( "in_med_station" );
	trigger_wait( "tunnel_exit_trigger" );
	player AllowSprint( false );
	player AllowJump( false );
	player SetMoveSpeedScale(.5);//Slow player until heli lands
	player setlowready( true );
	flag_wait("tunnel_vo_done");
	flag_wait( "seaknight_lands" );
	weaver anim_single(weaver, "watch_him");	
	player EnableInvulnerability();
	end_objective_trigger = GetEnt( "event5_objective_end", "targetname" );
	end_objective_trigger UseBy( player );	
	wait(1);
	fade_to_black();
	player anim_single(player, "what_did_they_do");
	//add_dialogue_line("Hudson", "What did they do to you, Mason?");
	wait(3);
	nextmission();
}

fade_to_black()
{
	fadeToBlack = NewHudElem(); 
	fadeToBlack.x = 0; 
	fadeToBlack.y = 0;
	fadeToBlack.alpha = 0;
	fadeToBlack.horzAlign = "fullscreen"; 
	fadeToBlack.vertAlign = "fullscreen"; 
	fadeToBlack.foreground = false; 
	fadeToBlack.sort = 50; 
	fadeToBlack SetShader( "black", 640, 480 );        
	fadeToBlack FadeOverTime( 6 );
	fadeToBlack.alpha = 1; 

	wait(6);
}



//------------------------------------
//
lab_escape_ambience()
{
	trigger_wait( "trig_explode_jeep" );
	wait(1);
	end_struct		= getstruct( level.start_struct.target, "targetname" );
	guys 					= get_ai_array( "ending_launch_enemies", "script_noteworthy" );
	array_thread(guys, ::magic_bullet_shield);
	thread toggle_barrel_damage(true);
	for( i = 0; i < 15; i++ )
	{
		MagicBullet( "hip_minigun_gunner", level.start_struct.origin, end_struct.origin );
		wait(.1);
	}
	thread chinook_attack_docks();
	jeep = GetEnt( "dock_explode_jeep", "targetname" );
	RadiusDamage( jeep.origin, 128, jeep.health + 10, jeep.health + 10 );
	barrel = GetEnt( "dock_explode_auto3", "targetname" );
	truck = GetEnt( "dock_explode_truck", "targetname" );
	RadiusDamage( truck.origin, 200, truck.health + 10, truck.health + 10 );	
	//barrel launch_barrel();
	array_thread(guys, ::launch_me);
	//PlayFX (level._effect["vehicle_explosion"], truck.origin);
	exploder(570);
}

launch_me()
{
	player = get_players()[0];
	self stop_magic_bullet_shield();
	self StartRagdoll();
	toward_player = Vector_Multiply( VectorNormalize( player.origin - self.origin ), 100);	
	toward_player = toward_player + ( RandomIntRange(-50, 50), RandomIntRange(-50, 50), 200);
	self DoDamage(1, (0,0,0));
	self LaunchRagDoll( toward_player, self.origin );
	self burn_me();	
}

launch_barrel()
{
	player = get_players()[0];
	toward_player = Vector_Multiply( VectorNormalize( player.origin - self.origin ), 50);	
	toward_player = toward_player + ( RandomIntRange(-10, 10), RandomIntRange(-10, 10), 1);
	RadiusDamage( self.origin, 5, 20, 20 );
	self PhysicsLaunch( toward_player, self.origin );
}

//from Shabs/Khe Sahn
burn_me()
{
	//self = ai on fire
  self endon( "death" );
  
  self random_burn_anim();

  self.ignoreme = true;
  self.ignoreall = true;

  self thread animscripts\death::flame_death_fx();
  // anim_single( self, "burning_fate" );

  self Die();
}

random_burn_anim()
{
  anims = array("on_fire_1","on_fire_2","on_fire_3","on_fire_4");
  self.animname = anims[RandomInt(anims.size)]; 
}

//------------------------------------
// Friendly helicopter attacks enemy AI
chinook_attack_docks()
{
	//trigger_wait( "spawn_ending_heli" );
	wait( .1 );
	//level.start_struct 	= getstruct( "chinook_firepath_first", "targetname" );
	//thread secondary_attacker();
	wait(.1);
	guys 					= GetEntArray( "ending_enemies", "script_noteworthy" );

	for( i = 0; i < guys.size; i++ )
	{
		if( IsDefined( guys[i] ) && IsAlive( guys[i] ) )
		{
			for( j = 0; j < 3; j++ )
			{
				MagicBullet( "hip_minigun_gunner", level.start_struct.origin, guys[i].origin );
				wait(.05);
			}
			if(IsAlive(guys[i]))
				guys[i] DoDamage(guys[i].health + 100, (0,0,0));
			wait( .1 );
		}
	}
	thread tunnel_end_vo();
	//trigger_use( "spawn_heli_friendlies" );
}

secondary_attacker()
{
	guys 					= get_ai_array( "ending_enemies2", "script_noteworthy" );

	for( i = 0; i < guys.size; i++ )
	{
		if( IsDefined( guys[i] ) && IsAlive( guys[i] ) )
		{
			for( j = 0; j < 4; j++ )
			{
				MagicBullet( "hip_minigun_gunner", level.start_struct.origin, guys[i].origin );
				wait(.05);
			}
			wait( .1 );
		}
	}	
}

chinook_lands()
{
	trigger_wait( "spawn_ending_heli" );
	wait(.05);
	chinook = GetEnt("ending_chinook", "targetname");
	//level.start_struct 	= getstruct( "chinook_firepath_first", "targetname" );
	level.start_struct LinkTo( chinook, "tag_barrel" );
	landing_node = GetVehicleNode( "ending_heli_landed", "targetname" );
	chinook thread spawn_chinook_crew();
	chinook waittill( "reached_end_node" );
	flag_set("seaknight_lands");	
}

kill_remaining_outside_guys()
{
	outside_guys = GetEntArray("ending_tunnel_enemies", "targetname");
	for(x = 0; x < outside_guys.size; x++)
	{
		if(IsAlive(outside_guys[x]))
			outside_guys[x] DoDamage(outside_guys.health + 100, (0,0,0));
	}
}

tunnel_end_vo()
{
	player = get_players()[0];
	heli_trig = GetEnt( "spawn_ending_heli", "targetname" );
	
	weaver = level.heroes["weaver"];
	
	weaver anim_single(weaver, "you_are_clear");
	//wait(1);
	heli_trig UseBy( player );
	weaver.animname = "weaver";
	weaver anim_single(weaver, "on_our_way");
	flag_set("tunnel_vo_done");	
}

spawn_chinook_crew()
{
	names = [];
	for ( i = 0; i < 4; i++ )
	{
		names[i] = "support_troop_0" + ( i + 1 );
	}
	// do the vignette
	//do_vignette(self, names, "unload", false, 2, "ending_chinook");	
	spawners = [];
	for ( i = 0; i < 4; i++ )
	{
		spawners = add_to_array( spawners, GetEnt( "support_troop_0" + (i+1), "targetname" ));
	}	
	//spawners = GetEnt( "support_troop_0" + (i+1), "targetname" );
	array_thread( spawners, ::add_spawn_function, ::chinook_defender );
	org = self gettagorigin( "tag_origin" );
	guys = [];
	for ( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ].origin = org;
		spawn = spawners[ i ] stalingradspawn();
		Spawn LinkTo( self, "tag_origin" );
		spawn.animname = "support_troop_0" + ( i + 1 );
		guys[ guys.size ] = spawn;
	}
	
	self thread anim_first_frame( guys, "unload", "tag_origin" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] linkto( self, "tag_origin" );
		guys[ i ].attackeraccuracy = 0;
	}

	flag_wait( "seaknight_lands" );
	
	self UseAnimTree(level.scr_animtree["support_chopper"]);
	self.animname = "support_chopper";
	self thread anim_loop(self, "unload");

	array_thread( guys, ::send_notify, "stop_first_frame" );
	self anim_single_aligned( guys, "unload", "tag_origin" );

	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] unlink();
	}
}

chinook_defender()
{
	self thread magic_bullet_shield();
	self allowedstances( "crouch" );

	wait( 1 );
	self.a.pose = "crouch";
	self waittillmatch( "single anim", "end" );
	self setgoalpos( self.origin );	
	self.goalradius = 16;
}

spawn_hazmat_enemies()
{
	//flag_wait( "player_looking_for_hazmat" );
	player = get_players()[0];
	office_trigger = GetEnt( "hudson_near_office", "targetname" );
	stealth_trigger = GetEnt("event5_flash_trigger", "targetname");
	hazmat_trigger = GetEnt("event5_hazmat_trigger", "targetname");	
	office_trigger trigger_off();
	thread weaver_last_stand();
	//hazmat_trigger UseBy( player );
	hazmat_trigger waittill( "trigger" );
	wait(2);
	hazmat_trigger2 = GetEnt("event5_hazmat_trigger2", "targetname");
	hazmat_trigger2 UseBy( player );
	waittill_ai_group_amount_killed( "e5_hazmat_enemies", 8 );
	flag_wait("lab_vo_done");
	stealth_trigger UseBy( player );
	wait(.1);
	end_trig = GetEnt("e5_end_obj_trigger", "targetname");
	thread rb_objective_breadcrumb( level.obj_iterator, "e5_end_obj_trigger" );
	end_trig UseBy( player ); 
	office_trigger trigger_on();
	//wait(1);
}

weaver_last_stand()
{
	trigger_wait("event5_flash_trigger");
	
	weaver = level.heroes[ "weaver" ];
	
	weaver_last_stand = GetNode("weaver_last_stand_node", "targetname");
	weaver SetGoalNode( weaver_last_stand );
		
	weaver waittill("goal");
	
	enemies_left = get_ai_group_ai("e5_hazmat_enemies");
	
	if(enemies_left.size > 0)
	{
		array_thread( enemies_left, maps\rebirth_hudson_lab::hunt_down_player );
		
		for(i = 0; i < enemies_left.size; i++)
		{
			while( IsDefined(enemies_left[i]) )
			{
				weaver shoot_at_target( enemies_left[i] );
				//enemies_left[i] DoDamage(enemies_left[i].health * 2, weaver.origin);
				wait(0.06);
			}
		}
	}
}



/*------------------------------------------------------------------------------------------------------------
																								Steiner's Office Notetracks
------------------------------------------------------------------------------------------------------------*/

steiners_office_hit_glass( guy )
{
	level thread steiners_office_crack_glass( 0 );
}

steiners_office_hit_glass2( guy )
{
	level thread steiners_office_crack_glass( 1 );
}

steiners_office_break_glass( guy )
{
	level thread steiners_office_crack_glass( 2 );
}




steiners_office_mason_fire( guy )
{
	steiner = get_ai( "steiner", "script_noteworthy" );
	if( IsDefined( steiner) && IsAlive( steiner ) )
	{
		steiner DoDamage( steiner.health + 10, (0, 0, 0) );
	}
}



//------------------------------------
//
steiners_office_lift_fuse()
{	
	level endon("start_office_anim");
	player = get_players()[0];
	
	//level notify( "stop_office_anim" );

	screen_message_create( &"REBIRTH_BASH_WINDOW" );
	counter = 0;
	while( (!player ThrowButtonPressed() || !player AttackButtonPressed()) && counter <= 40  )
	{
		wait( .05 );
		counter++;
	}	
		
	screen_message_delete();	
	level notify( "start_office_anim" );
}

timescale_fuse(guy)
{
	wait(1);
}

skip_lift_fuse(guy)
{
	screen_message_delete();	
	level notify( "start_office_anim" );	
}



//------------------------------------
//
steiners_office_move_fuse( forward )
{
	player = get_players()[0];
	
	level notify( "stop_office_anim" );
	
	movement = (0, 0, 0);
	
	if( forward )
	{
		screen_message_create( &"REBIRTH_BASH_WINDOW" );
		
		while( !player ThrowButtonPressed() || !player AttackButtonPressed() || movement[1] < .0 )
		{
			movement = player GetNormalizedMovement();
			
			wait( .05 );
		}
	}
	else
	{
		screen_message_create( &"REBIRTH_BASH_WINDOW" );
		
		while( !player ThrowButtonPressed() || !player AttackButtonPressed() || movement[1] > -.0 )
		{
			movement = player GetNormalizedMovement();
			
			wait( .05 );
		}		
	}
		
	screen_message_delete();
	level notify( "start_office_anim" );	
}



//------------------------------------
//
steiners_office_mantle_window()
{
	player = get_players()[0];
	
	level notify( "stop_office_anim" );

	screen_message_create( "^3[{+gostand}]^7" );

	while( !player JumpButtonPressed() )
	{
		wait( .05 );
	}	
		
	screen_message_delete();
	level notify( "start_office_anim" );	
}



/*------------------------------------
***/
steiners_office_tackle_mason()
{
	player = get_players()[0];
	
	level notify( "stop_office_anim" );
	
	screen_message_create( &"REBIRTH_TACKLE_MASON" );
	
	while( !player MeleeButtonPressed() )
	{
		wait( .05 );
	}
	
	screen_message_delete();
	level notify( "start_office_anim" );	
}

hit_success_listener( mason, anim_node )
{
	player = get_players()[0];
	
	//level notify("start_office_anim");
	// thread hit_slomo();
	
	screen_message_create( &"REBIRTH_TACKLE_MASON" );
	
	while( true )
	{
		if( player MeleeButtonPressed() )
		{
			flag_set( "hit_success" );
			screen_message_delete();
			break;
		}
		
		wait( 0.05 );
	}
}



toggle_event5_items(show_item)
{
	hide_me = GetEntArray("event5_hide", "script_noteworthy");
	for(x = 0; x < hide_me.size; x++)
	{
		if(show_item)
			hide_me[x] Show();
		else
			hide_me[x] Hide();
	}
	hide_me = GetEntArray("explodable_barrel", "script_noteworthy");
	for(x = 0; x < hide_me.size; x++)
	{
		if(show_item)
			hide_me[x] Show();
		else	
			hide_me[x] Hide();
	}	
}

toggle_barrel_damage(damage)
{
	barrels = GetEntArray( "explodable_barrel", "script_noteworthy" );
	for(x = 0; x < barrels.size; x++)
	{
		barrels[x] SetCanDamage(damage);
	}
}

toggle_event5_triggers(active)
{
	hazmat_trigger = GetEnt( "event5_hazmat_trigger", "targetname" );
	flash_trigger = GetEnt( "event5_flash_trigger", "targetname" );
	hobbit_trigger = GetEnt( "event5_hobbit_trigger", "targetname" );
	flash_watch_trigger = GetEnt( "event5_flash_watch_trigger", "targetname" );
	office_trigger = GetEnt( "hudson_near_office", "targetname" );
	objective_lab_3 = GetEnt( "objective_lab_3", "targetname" );
	objective_lab_4 = GetEnt( "objective_lab_4", "targetname" );
	weaver_near_security_door = GetEnt( "weaver_near_security_door", "targetname" );
	steiner_door = GetEnt( "open_steiners_door", "targetname" );
	
	if(active)
	{
		//enable
		hazmat_trigger trigger_on();
		flash_trigger trigger_on();
		hobbit_trigger trigger_on();
		flash_watch_trigger trigger_on();
		office_trigger trigger_on();
		objective_lab_3 trigger_on();
		objective_lab_4 trigger_on();
		weaver_near_security_door trigger_on();
		
		steiner_door trigger_off();//TURN OFF EVENT 2 TRIG
	}
	else
	{
		//disable
		hazmat_trigger trigger_off();
		flash_trigger trigger_off();
		hobbit_trigger trigger_off();
		flash_watch_trigger trigger_off();
		office_trigger trigger_off();
		objective_lab_3 trigger_off();
		objective_lab_4 trigger_off();
		weaver_near_security_door trigger_off();
	}
}

stealth_checker()
{
	flag_wait("toggle_stealth_on");
	player = get_players()[0];
	level endon ("stealthbreak");
	while( 1 ) 
	{
		if ( player isfiring() )
		{
			break;
		}
		if ( player isthrowinggrenade() )
		{
			break;
		}
		wait 0.1;
	}
	level notify ("stealthbreak");
}

stealth_trigger_checker()
{
	flash_watch_trigger = GetEnt( "event5_flash_watch_trigger", "targetname" );
	flash_watch_trigger waittill("trigger");
	wait(5);
	level notify ("stealthbreak");
}

toggle_weaver_ignore(ignore)
{
	weaver = level.heroes[ "weaver" ];
	weaver.ignoreall = ignore;
}


/*------------------------------------------------------------------------------------------------------------
																								Objectives
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Update objectives and objective markers
steiners_office_objectives()
{
	
}



/*------------------------------------------------------------------------------------------------------------
																								Spawn Functions
------------------------------------------------------------------------------------------------------------*/

//------------------------------------
// Have enemies on the docks fire upwards
ending_enemies_think()
{
	wait(2);
	if(self.script_noteworthy == "ending_enemies")
		self.a.rockets = 0;
	//level.start_struct = GetEnt( "chinook_firepath_first", "targetname" );
	self SetEntityTarget( level.start_struct );
}

ending_enemies_kill()
{
	self waittill("goal");
	self DoDamage(self.health + 100, (0,0,0));
}

lab_hazmat_enemies()
{
	self endon("death");
	//self.disable_melee = 1;
	self enable_cqbwalk();
	olddist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 100 * 100;
	self.ignoreall = true;
	self thread hazmat_distance_checker();
	level waittill("stealthbreak");
	self notify( "end_patrol" );
	self.ignoreall = false;
	self.goalradius = 1024;
	self.maxsightdistsqrd = olddist;
	level waittill("hudson_in_office");
	self DoDamage(self.health + 100, (0,0,0));
}

hazmat_distance_checker()
{
	self endon("death");
	player = get_players()[0];
	while( Distance2D(self.origin, player.origin) > 200)
	{
		wait(.1);
	}
	level notify("stealthbreak");
}

reset_hazmat_enemies()
{
	self.maxsightdistsqrd = 4096 * 4096;
}

last_stand_enemy()
{
	//self.ignoreall = true;
	self thread last_stander();
	self DoDamage( 1, (0,0,0));
	self.a.script = "pain";
	self disable_react();
	self AnimCustom( maps\rebirth_steiners_office::crawlingPistol );
}//animscripts\pain::

hobbit_trooper()
{
	self.ignoreall = true;
	self.goalradius = 0;
	self.health = 5;
	self animscripts\anims_table::setup_wounded_anims();
	self waittill("goal");
	self.goalradius = 0;
	self.ignoreall = false;
}

last_stander()
{
	self endon("death");
	/*while(1)
	{
		self.a.numCrawls = 8;
		wait(.05);
	}*/
}

//Hack Last Stand
//////////////////////////////////////////////////////////////////////////////
#using_animtree ("generic_human");
crawlingPistol()
{
	// don't end on killanimscript. pain.gsc will abort if self.crawlingPistolStarting is true.
	self endon ( "kill_long_death" );
	self endon ( "death" );

	// don't collide with player during long death
	self SetPlayerCollision(false);
	
	self thread animscripts\pain::preventPainForAShortTime( "crawling" );
	
	self.a.special = "none";
	
	self thread animscripts\pain::painDeathNotify();
	//notify ac130 missions that a guy is crawling so context sensative dialog can be played
	level notify ( "ai_crawling", self );
		
	self.isSniper = false;
	
	self SetAnimKnobAll( %dying, %body, 1, 0.1, 1 );
	
	// dyingCrawl() returns false if we die without turning around
	if ( !self dyingCrawl() )
	{
		return;
	}
	
	assert( self.a.pose == "stand" || self.a.pose == "crouch" || self.a.pose == "prone" );
	transAnimSlot = self.a.pose + "_2_back";
	transAnim = animArrayPickRandom( transAnimSlot );
	
	self SetFlaggedAnimKnob( "transition", transAnim, 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracksIntercept( "transition", animscripts\pain::handleBackCrawlNotetracks );
	
	// A complicated way of doing an assertEx, where the assert needs to contain the name of an anim.
	if ( self.a.pose != "back" )
	{
		println( "Anim \"", transAnim, "\" is missing an 'anim_pose = \"back\"' notetrack." );
		assert( self.a.pose == "back" );
	}
	
	self.a.special = "dying_crawl";
	
	self thread animscripts\pain::dyingCrawlBackAim();
	
	self.a.numCrawls = 5;
	for ( x = 0; x < self.a.numCrawls; x++ )
	{
		crawlAnim = animArray( "back_crawl" );
		delta = getMoveDelta( crawlAnim, 0, 1 );
		endPos = self localToWorldCoords( delta );
		
		if ( !self mayMoveToPoint( endPos ) )
		{
			break;
		}
		
		self SetFlaggedAnimKnobRestart( "back_crawl", crawlAnim, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracksIntercept( "back_crawl", animscripts\pain::handleBackCrawlNotetracks );
	}
	
	self.desiredTimeOfDeath = GetTime() + 20000;
	while ( animscripts\pain::shouldStayAlive() )
	{
		if ( self canSeeEnemy() && self animscripts\pain::aimedSomewhatAtEnemy() )
		{
			backAnim = animArray( "back_fire" );
		
			self SetFlaggedAnimKnobRestart( "back_idle_or_fire", backAnim, 1, 0.2, 1.0 );
			self animscripts\shared::DoNoteTracks( "back_idle_or_fire" );
		}
		else
		{
			backAnim = animArray( "back_idle" );
			if ( RandomFloat(1) < .4 )
			{
				backAnim = animArrayPickRandom( "back_idle_twitch" );
			}
			
			self SetFlaggedAnimKnobRestart( "back_idle_or_fire", backAnim, 1, 0.1, 1.0 );
			
			timeRemaining = getAnimLength( backAnim );
			while( timeRemaining > 0 )
			{
				if ( self canSeeEnemy() && self animscripts\pain::aimedSomewhatAtEnemy() )
				{
					break;
				}
				
				interval = 0.5;
				if ( interval > timeRemaining )
				{
					interval = timeRemaining;
					timeRemaining = 0;
				}
				else
				{
					timeRemaining -= interval;
				}

				self animscripts\shared::DoNoteTracksForTime( interval, "back_idle_or_fire" );
			}
		}
	}
	
	self notify("end_dying_crawl_back_aim");
	self ClearAnim( %dying_back_aim_4_wrapper, .3 );
	self ClearAnim( %dying_back_aim_6_wrapper, .3 );
	
	self.a.nodeath = true;
	animscripts\death::play_death_anim( animArrayPickRandom( "back_death" ) );
	self DoDamage( self.health + 5, (0,0,0) );

	self.a.special = "none";
}

dyingCrawl()
{
	if ( self.a.pose == "prone" )
	{
		return true;
	}
	
	if ( self.a.movement == "stop" )
	{
		if ( RandomFloat(1) < .2 ) // small chance of randomness
		{
			if ( RandomFloat(1) < .5 )
			{
				return true;
			}
		}
		else
		{
			// if hit from front, return true
			if ( abs( self.damageYaw ) > 90 )
			{
				return true;
			}
		}
	}
	else
	{
		// if we're not stopped, we want to fall in the direction of movement
		// so return true if moving backwards
		if ( abs( self getMotionAngle() ) > 90 )
		{
			return true;
		}
	}
	
	self SetFlaggedAnimKnob( "falling", animArrayPickRandom( self.a.pose + "_2_crawl" ), 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracks( "falling" );
	assert( self.a.pose == "prone" );
	
	self.a.special = "dying_crawl";
	
	self.a.numCrawls = 0;
	while ( animscripts\pain::shouldKeepCrawling() )
	{
		crawlAnim = animArray( "crawl" );
		delta = getMoveDelta( crawlAnim, 0, 1 );
		endPos = self localToWorldCoords( delta );

		if ( !self mayMoveToPoint( endPos ) )
		{
			return true;
		}
			
		self SetFlaggedAnimKnobRestart( "crawling", crawlAnim, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracks( "crawling" );
	}
	
	// check if target is in cone to shoot
	if ( animscripts\pain::enemyIsInGeneralDirection( AnglesToForward( self.angles ) * -1 ) )
	{
		return true;
	}
	
	self.a.nodeath = true;
	animscripts\death::play_death_anim( animArrayPickRandom( "death" ) );
	self DoDamage( self.health + 5, (0,0,0) );
	
	self.a.special = "none";
	
	return false;
}



breakin_wait_fuse_pickup( pickup_anim, anim_ents )
{
	level endon( "breakin_fuse_picked_up" );
	
	//screen_message_create( &"REBIRTH_BASH_WINDOW" );
	//level thread rebirth_button_prompt();
	level thread breakin_wait_fuse_anim_finish( pickup_anim );
	
	while( !self ThrowButtonPressed() || !self AttackButtonPressed() )
	{
		wait( .05 );
	}		
	
	//screen_message_delete();
	//flag_set( "fuse_picked_up" );
	
	flag_set( "breakin_fuse_picked_up" );
}

breakin_wait_fuse_anim_finish( pickup_anim )
{
	level endon( "breakin_fuse_picked_up" );
	anim_length = GetAnimLength( pickup_anim );
	wait( anim_length );
	
	//screen_message_delete();
	//flag_set( "fuse_picked_up" );
	
	flag_set( "breakin_fuse_picked_up" );
}

rebirth_button_prompt()
{
	
	if (!IsDefined(level.strengthtest_text_press))
	{
		level.strengthtest_text_press = NewHudElem();
		level.strengthtest_text_press.alignX = "center"; 
		level.strengthtest_text_press.alignY 	 = "middle"; 
		level.strengthtest_text_press.horzAlign = "center"; 
		level.strengthtest_text_press.vertAlign = "middle";
		level.strengthtest_text_press.x = -100;
		level.strengthtest_text_press.y = -60;
		level.strengthtest_text_press.alpha = 0.6;
		level.strengthtest_text_press.fontscale = 2;
		if(level.console)
		{
			level.strengthtest_text_press SetText(&"REBIRTH_PROMPT_PRESS"); 				
		}
	}
	
	if (!IsDefined(level.strengthtest_speed_throw))
	{
		level.strengthtest_speed_throw = NewHudElem();
		level.strengthtest_speed_throw.alignX = "center"; 
		level.strengthtest_speed_throw.alignY 	 = "middle"; 
		level.strengthtest_speed_throw.horzAlign = "center"; 
		level.strengthtest_speed_throw.vertAlign = "middle";
		level.strengthtest_speed_throw.x = -60;
		level.strengthtest_speed_throw.y = -55;
		level.strengthtest_speed_throw.fontscale = 3;
		level.strengthtest_speed_throw.alpha = 1;
		if(level.console)
		{
			level.strengthtest_speed_throw SetText(&"REBIRTH_PROMPT_SPEED_THROW");		
		}
	}
	
	if (!IsDefined(level.strengthtest_text_and))
	{
		level.strengthtest_text_and = NewHudElem();
		level.strengthtest_text_and.alignX = "left"; 
		level.strengthtest_text_and.alignY 	 = "middle"; 
		level.strengthtest_text_and.horzAlign = "center"; 
		level.strengthtest_text_and.vertAlign = "middle";
		level.strengthtest_text_and.x = -41;
		level.strengthtest_text_and.y = -60;
		level.strengthtest_text_and.alpha = 0.6;
		level.strengthtest_text_and.fontscale = 2;
		if(level.console)
		{
			level.strengthtest_text_and SetText(&"REBIRTH_PROMPT_AND"); 				
		}
	}
	
	if (!IsDefined(level.strengthtest_attack))
	{
		level.strengthtest_attack = NewHudElem();
		level.strengthtest_attack.alignX = "left"; 
		level.strengthtest_attack.alignY 	 = "middle"; 
		level.strengthtest_attack.horzAlign = "center"; 
		level.strengthtest_attack.vertAlign = "middle";
		level.strengthtest_attack.x = 0;
		level.strengthtest_attack.y = -55;//115;
		level.strengthtest_attack.alpha = 0.6;
		level.strengthtest_attack.fontscale = 3;
		if(level.console)
		{
			level.strengthtest_attack SetText(&"REBIRTH_PROMPT_ATTACK"); 				
		}
	}
	
	if (!IsDefined(level.strengthtest_text_to_bash_window))
	{
		level.strengthtest_text_to_bash_window = NewHudElem();
		level.strengthtest_text_to_bash_window.alignX = "left"; 
		level.strengthtest_text_to_bash_window.alignY 	 = "middle"; 
		level.strengthtest_text_to_bash_window.horzAlign = "center"; 
		level.strengthtest_text_to_bash_window.vertAlign = "middle";
		level.strengthtest_text_to_bash_window.x = 31;
		level.strengthtest_text_to_bash_window.y = -60;//115;
		level.strengthtest_text_to_bash_window.alpha = 0.6;
		level.strengthtest_text_to_bash_window.fontscale = 2;
		if(level.console)
		{
			level.strengthtest_text_to_bash_window SetText(&"REBIRTH_PROMPT_TO_BASH_WINDOW"); 				
		}
	}
	
	if(!level.console)
	{
		screen_message_create( &"REBIRTH_BASH_WINDOW" );
	}
	while(!flag( "fuse_picked_up" ))
	{

		if(level.console)
		{
			level.strengthtest_speed_throw.alpha = 0.1;
			level.strengthtest_attack.alpha = 0.1;
			wait 0.2;
			level.strengthtest_speed_throw.alpha = 1;
			level.strengthtest_attack.alpha = 1;
		}

		/*		
		if( flag( "fuse_picked_up" ) )
		{
			break;
		}
		*/
		wait 0.2;
	}
	 
	level.strengthtest_text_press Destroy(); 	
	level.strengthtest_speed_throw Destroy();
	level.strengthtest_text_and Destroy();
	level.strengthtest_attack Destroy();
	level.strengthtest_text_to_bash_window Destroy();
	
	if(!level.console)
	{
		screen_message_delete();
	}
}

office_success_hudson_vo1(guy)
{
	get_players()[0] anim_single( get_players()[0], "we_wont" );
}

office_success_hudson_vo2(guy)
{
	get_players()[0] anim_single( get_players()[0], "didnt_believe_it" );
}

office_success_hudson_vo3(guy)
{
	get_players()[0] anim_single( get_players()[0], "it_was_vorkuta" );
}

office_success_hudson_vo4(guy)
{
	get_players()[0] anim_single( get_players()[0], "bring_him_back" );
}
 