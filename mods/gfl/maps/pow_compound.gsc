/*
	
	THIS SCRIPT HANDLES EVERYTHING SPECIFIC TO ASSAULTING THE COMPOUND AND FREEING THE PRISONERS

*/


#include maps\_utility;
#include common_scripts\utility;
#include maps\pow_utility;
#include maps\_music;
#include maps\_anim;

#using_animtree ("generic_human");

start()
{
	//-- start by landing the hind
	trigger_wait( "landing_trig" );
	
	flag_set("obj_hind_landing");
	
	
	level.hind thread maps\_hind_player::disable_driver_weapons();
	level thread woods_landing_vo();
	
	level.hind notify("stop_flightstick");
	level.hind SetYawSpeed( 360, 20 );
	//level.hind.lockheliheight = false;
	
	
	start_nodes = GetVehicleNodeArray("landing_spline_0", "targetname");
	start_node = getClosest( level.hind.origin , start_nodes );
	
	level.hind.drivepath = 1;
	level.hind SetNearGoalNotifyDist(120);
	
	level.hind SetSpeed( 40, 10, 10 );
	level.hind SetVehGoalPos(start_node.origin, 0);
	level.hind SetGoalYaw( start_node.angles[1] );
	while(Distance2D(level.hind.origin, start_node.origin) > 240)
	{
		wait(0.05);
	}
	
	level.hind.lockheliheight = false;
	level.hind thread go_path( start_node );
	level.hind ResumeSpeed(10);
	level.hind waittill("start_animating");
	
	SetSavedDvar("sm_sunSampleSizeNear", 0.4);
	
	exploder( 400 );
	level.hind thread stop_hind_rotors_after_touching_down();
	
	//SOUND - Shawn J
	clientnotify( "hind_dust" );
	//GAVIN - Please let me know if you can add a function to send a notify when the copper touches the ground - thanks!
	
	level thread setup_guards_at_bottom_of_road();
	level thread wait_player_gets_flamethrower();
	
	cleanup_flying_section();
	play_landed_animation();
	
	level notify("player_out_of_hind");
	
	//-- cleanup all the extra hind parts that get left around
	level.hind Detach( "t5_veh_helo_hind_ckpitdmg0", "origin_animate_jnt");
	
	if(IsDefined(level.hind.extra_parts))
	{
		for(i = 0; i < level.hind.extra_parts.size; i++)
		{
			part = GetEnt(level.hind.extra_parts[i], "targetname");
			part Delete();
		}
	}

	//-- If I don't do this, then on a save restored, the player will be invulnerable
	player = get_players()[0];
	OnSaveRestored_CallbackRemove(maps\pow_utility::vehicle_in_use_save_restored_function);
	player.invulnerable = false; //-- keep global callbacks from resetting invulnerability
	player DisableInvulnerability();
	
	//-- Start the fight up toward the compound
	wait(1);
	flag_set("obj_to_kravchenko");
	
	autosave_by_name("pow_out_of_heli");
	
	level thread battlechatter_on();
	level thread prep_rolling_door();
	
	fight_to_compound();
	
	init_spawners_in_cave();
	
	waittill_spawn_manager_cleared("sm_to_compound");
	waittill_spawn_manager_cleared("sm_at_entrance");
	waittill_ai_group_cleared("guys_at_cave_mouth");
	color_triggers = GetEntArray( "blue_color_trig_up_hill", "script_noteworthy" ); //-- dont' want woods running back down the hill
	array_delete(color_triggers);
	trigger_use("breached_cave_woods_color");
	flag_set("obj_player_needs_ft");
	
	//-- disable the door kick door breach
	//door_kick_trig = GetEnt("trig_kick_door", "script_noteworthy");
	//door_kick_trig maps\_door_breach::door_breach_trigger_off();
	
	
	//-- wait until all of the AI have spawned for this fight
	//trigger_wait("mid_point_sm_trig");
	//waittill_spawn_manager_cleared("sm_cave_mid_point");
	
	//TUEY set music state to IN_BASE
	setmusicstate ("IN_BASE");
	
	woods_free_pows();
	
	level thread kravchenko_pacing();
	level thread woods_advance_last_section();
	level thread spawn_guys_from_krav_door();
	
	//door_kick_trig maps\_door_breach::door_breach_trigger_on();
	player = get_players()[0];
	player waittill("door_breached");
	level thread battlechatter_off();
	
	//-- clear out other AI
	ais = GetAIArray("axis");
	ais = array_remove( ais, level.krav);
	array_thread( ais, ::ragdoll_death);
	
	//TUEY set music state to IN_BASE
	setmusicstate ("END_LEVEL_ANIMATION");
	
	//trigger_wait("entered_krav_office");
	play_endfight_animation();
	
	/*
	player FreezeControls(true);
	
	wait(0.05);
	
	
	//play_fade_map_picture();
	//play_fade_woods_dead();
	//play_fade_getting_out();
	//play_fade_in_helicopter();
	
	player FreezeControls(false);
	*/
	
}

play_extra_lines_and_end( guy )
{
	//level thread play_fade_ending( "black" );
	
	level notify("interrogator_lines");
	
	player = get_players()[0];
	player SetClientDvar( "cg_defaultFadeScreenColor", "1 1 1 1" );
	player.animname = "player";
	VisionSetNaked( "int_frontend_char_trans", 1);
	player maps\_anim::anim_single( player, "interrogator");
	player maps\_anim::anim_single( player, "reznov_all_must_die");
	wait(0.1);
	show_friendly_names( 1 );
	nextmission();
}

stop_hind_rotors_after_touching_down()
{
	self waittill("reached_end_node");
	
	//SOUND - Shawn J
	clientnotify( "hind_landing" );
	
	wait(1.0);
	
	self heli_toggle_rotor_fx(1);
	//wait(5);
	//stop_exploder(400);
}

woods_landing_vo() //-- this is when Woods takes control of the stick
{
	if(IsDefined(level.barnes))
	{
		level.barnes anim_single( level.barnes, "krav_just_to_the_south" );
		playsoundatposition( "evt_num_num_10_r" , (0,0,0) );
		wait(0.2);
		level.barnes anim_single( level.barnes, "im_setting_her_down" );
	}
}

woods_advance_last_section()
{
	level endon("end_fight");
	waittill_cave_is_cleared();
	
	trigger_use( "cave_is_cleared" ); //- send reznov and red shirts to nodes at bottom of cave_is_cleared
	level thread battlechatter_off();
	level woods_to_kravchenko();
}

init_spawners_in_cave()
{
	rushers = GetEntArray( "krav_cave_rushers", "script_noteworthy" );
	array_thread( rushers, ::add_spawn_function, ::player_seek_no_cover, level.woods );
	
	catwalk_guys = GetEntArray("sm_cave_high_spawners", "targetname" );
	array_thread( catwalk_guys, ::add_spawn_function, maps\pow_spawnfuncs::ai_no_dodge );
	
	spetz = GetEntArray("sm_cave_spetz_spawners", "targetname" );
	array_thread( spetz, ::add_spawn_function, maps\pow_spawnfuncs::ai_no_dodge, 15 );
	
	spetz_last = GetEntArray("spetz_last_spawners", "targetname" );
	array_thread( spetz, ::add_spawn_function, maps\pow_spawnfuncs::ai_no_dodge, 15 );
	
	pows = GetEntArray( "pow_spawners", "targetname" );
	array_thread( pows, ::add_spawn_function, ::enable_cqbsprint );
}

//-- wait until all the AI in the cave has been cleared
waittill_cave_is_cleared()
{
	waittill_ai_group_cleared( "cave_left_side" );
	//waittill_ai_group_cleared( "cave_up_high" );
	//waittill_ai_group_cleared( "cave_spetz" );
	waittill_spawn_manager_cleared("sm_cave_high");
	waittill_spawn_manager_cleared("sm_cave_spetz");
	
}

//-- send woods up to kravchenko, bread crumb
woods_to_kravchenko()
{
	level.woods disable_ai_color();
	
	//woods_wait_stairs = GetNode("woods_wait_by_stairs", "targetname");
	//level.woods force_goal(woods_wait_stairs);
	//level.woods waittill("goal");
	
	wait_by_door = GetNode("woods_wait_by_krav", "targetname");
	wait_by_door.script_onlyidle = 1;
	level.woods SetGoalNode( wait_by_door );
	//level.woods force_goal(wait_by_door);
	//level.woods waittill("goal");
	//level.woods SetGoalPos(level.woods.origin);
}

cleanup_flying_section()
{
	//-- clean up the pipes specifically
	if(IsDefined(level.pipeline))
	{
		for(i = level.pipeline["pipe_"].size; i > 0; i--)
		{
			level.pipeline["pipe_"][i] notify("stop_dmg_watch_pipe");
			level.pipeline["pipe_"][i] Delete();
			level.pipeline["pipe_"][i] = undefined;
		}
		
		level.pipeline["pipe_"] = undefined;
		
		for(i = level.pipeline["pipe_depot_"].size; i > 0; i--)
		{
			level.pipeline["pipe_depot_"][i] notify("stop_dmg_watch_pipe");
			level.pipeline["pipe_depot_"][i] Delete();
			level.pipeline["pipe_depot_"][i] = undefined;
		}
		
		level.pipeline["pipe_depot_"] = undefined;
	}
	
	//-- kill the threads that are waiting for animated bridges to take damage
	level notify("kill_bridge_threads");
	
	//-- kill drone looking at threads
	level notify("end_drone_behaviors");
	
	//-- kill the animated trees and delete them
	level notify("kill_tree_behavior");
	tree_array = GetEntArray( "fxanim_tree", "targetname" );
	array_delete( tree_array );
	
	//-- delete all the destructible huts
	destructibles = GetEntArray( "destructible", "targetname" );
	village_buildings = [];
	for( i=0; i < destructibles.size; i++ )
	{
		if(IsDefined(destructibles[i].classname) && (IsSubStr(destructibles[i].classname, "village_dock") || IsSubStr(destructibles[i].classname, "village_building")) )
		{
			village_buildings[village_buildings.size] = destructibles;
		}
	}
	array_delete( village_buildings );
	
	//-- delete the rest of the vehicles
	vehicles = GetEntArray("script_vehicle", "classname");
	max_vehicles = vehicles.size;
	
	for(i=0; i < max_vehicles; i++)
	{
		if( !IsSubStr(vehicles[i].vehicletype, "heli") )
		{
			vehicles[i] Delete();
		}
	}
}

play_fade_ending( color )
{
	level endon("interrogator_lines");
	
	fadeToBlack = NewHudElem(); 
	
	if(!IsDefined(color))
	{
		color = "white";
	}
	
	fadeToBlack.x = 0; 
	fadeToBlack.y = 0;
	fadeToBlack.alpha = 0;
	fadeToBlack.horzAlign = "fullscreen"; 
	fadeToBlack.vertAlign = "fullscreen"; 
	fadeToBlack.foreground = false; 
	fadeToBlack.sort = 50; 
	fadeToBlack SetShader( color, 640, 480 );        
		
	while(1)
	{		
		fadeToBlack FadeOverTime( 0.5 );
		fadeToBlack.alpha = 1; 
		
		level waittill("end_fade_in");
		
		fadeToBlack FadeOverTime( 1.5 );
		fadeToBlack.alpha = 0; 
		
		level waittill("end_fade_out");
	}
}

fight_to_compound()
{
	spawners_to_compound = GetEntArray("sm_to_compound_spawners", "targetname");
	array_thread( spawners_to_compound, ::add_spawn_function, ::start_to_compound_fight );
	
	spawn_target_trigs = GetEntArray("trig_change_spawner_targets", "targetname");
	array_thread( spawn_target_trigs, maps\pow_utility::update_spawner_target_on_trigger, spawners_to_compound );
	
	trigger_use( "trig_color_barnes_compound_start" );
	
	//-- This will remove the blocker to shorten the initial engagement distance
	level thread delete_target_on_trigger( "trig_comp_sight_blocker", ::set_to_compound_fight_flags_and_notify_ai );
	
	
	//-- Other scripted behaviors
	level thread setup_flame_leapover();
	level thread setup_woods_kill_standing_guard();
	level thread setup_rpg_rpk_at_hilltop_guys();
	level thread setup_mantle_guy_on_box();
}

set_to_compound_fight_flags_and_notify_ai()
{
	flag_set("to_compound_fight_start");
	
	//TUEY set music state to BASE_ENTRANCE
	setmusicstate ("BASE_ENTRANCE");
	
	ais = GetAIArray( "axis" );
	array_notify( ais, "start_fighting" );
}

start_to_compound_fight()
{
	if(!flag("to_compound_fight_start"))
	{
		self.ignoreall = true;
		self.a.coverIdleOnly = true;
	
		//self waittill_any( "damage", "whizby", "start_fighting" );
		flag_wait("to_compound_fight_start");
		
		if(!flag("to_compound_fight_start"))
		{
			trigger_use( "trig_comp_sight_blocker" );
			set_to_compound_fight_flags_and_notify_ai();
		}
	}
	
	wait(0.1);
	self.ignoreall = false;
	self.a.coverIdleOnly = false;
}

woods_free_pows()
{
	/*
	axis = GetAIArray("axis");
	someone_inside = true;
	the_inside = GetEnt("first_cave_volume", "targetname");
	
	while( someone_inside && axis.size > 0)
	{
		someone_inside = false;
		
		for(i = 0; i < axis.size; i++)
		{
			if(axis[i] IsTouching(the_inside))
			{
				someone_inside = true;
				break;
			}
		}
		
		wait(0.05);
		
		axis = array_removeundefined(axis);
		axis = array_removedead(axis);
	}
	*/
	
	waittill_ai_group_ai_count( "aigroup_cave_1", 2 );
	level thread woods_pow_VO_convo();
	
	waittill_ai_group_cleared( "aigroup_cave_1" );
	level thread prompt_player_save_pows();
	
	align_node = getstruct( "pow_align_struct", "targetname" );
	
	flag_set("woods_ready_to_save_pows");
	//flag_wait("player_saved_pows");
	
	//level.pows = simple_spawn("pow_spawners");
	/*
	for(i=0; i<level.pows.size; i++)
	{
		level.pows[i].goalradius = 4;
		level.pows[i] SetGoalPos(level.pows[i].origin);
	}
	*/
	
	//level.woods StopAnimScripted();
	//trigger_use( "after_pow_color_trig", "targetname" );
		
	//-- POWS
	/*
	gun_structs = getstructarray("pow_weapon_structs", "targetname");
	for(i = 0; i < level.pows.size; i++)
	{
		level.pows[i] thread get_gun_then_go_to_color(gun_structs[i]);
	}
	*/
}

get_gun_then_go_to_color( gun_struct )
{
	self.goalradius = 36;
	self SetGoalPos( gun_struct.origin );
	self waittill("goal");
	
	//todo: send them to a color node
	self set_force_color( "g" );
}

prompt_player_save_pows() //-- Instruct the player to open the cell door
{
	
	align_node = getstruct( "pow_align_struct", "targetname" );
	
	trig_origin = GetStartOrigin( align_node.origin, align_node.angles, level.scr_anim["player_hands"]["reznov_rescue"]); 
	
	reznov_talk_trig = Spawn( "trigger_radius", trig_origin - (0,0,120), 0, 96, 1000 );
	reznov_talk_trig waittill("trigger");
	
	level thread reznov_mason_pow_VO();	
	
	free_pow_trig = Spawn( "trigger_radius", trig_origin - (0,0,120), 0, 32, 1000 );
	free_pow_trig waittill("trigger");
	
	//SOUND - Shawn J
	clientnotify( "pow_doors" );
	playsoundatposition( "evt_num_num_11_r" , (0,0,0) );
	
	flag_set("player_started_saving_pows");
	
	player = get_players()[0];
		
	level.reznov = simple_spawn_single("reznov");
	//Reznov is an illusion
	level.reznov thread wont_disable_player_firing();
		
	show_friendly_names( 0 );
	player thread animate_player_open_door( align_node );
	level.reznov.old_turnrate = level.reznov.turnrate;
	level.reznov.turnrate = 40;
	wait(0.25); //-- match wait for player animation
	align_node maps\_anim::anim_single_aligned( level.reznov, "reznov_rescue");
	
	//-- This allows for the fake fight incase the player stand still
	level.overrideActorDamage = ::overrideactordamage_fakefight;
	
	trigger_use( "after_pow_color_trig", "targetname" );
	level.reznov set_force_color( "g" );
	
	show_friendly_names( 1 );
	
	//-- On the run Dialog
	wait(0.5);
	level.reznov.turnrate = level.reznov.old_turnrate;
	level.reznov anim_single( level.reznov, "returned_to_russia" );
	wait(1.5);
	wait(0.1);
	player anim_single( player, "our_destiny" );
	wait(0.25);
	player anim_single( player, "krav_must_die" );
}

#using_animtree ("animated_props");

reznov_mason_pow_VO()
{
	player = get_players()[0];
	player.animname = "player";
	
	reznov_door = GetEnt("pow_door_3", "targetname");
	reznov_door.animname = "reznov";
	
	level anim_single( reznov_door, "mason_is_that_you" );
	wait(0.1);
	level anim_single( player, "reznov_ill_get_you");
}

woods_pow_VO_convo()
{
	level endon("player_started_saving_pows");
	
	trigger = GetEnt("first_cave_volume", "targetname");
	player = get_players()[0];
	
	while(!player IsTouching(trigger))
	{
		wait(0.05);
	}
	
	pow_door = GetEnt("pow_door_1", "targetname");
	pow_door.animname = "pow_door";
	
	pow_door anim_single( pow_door, "whos_out_there" );
	wait(0.1);
	pow_door anim_single( pow_door, "help_us" );
	wait(0.3);
	level.woods anim_single( level.woods, "mason_theyre_pows" );
	wait(0.1);
	pow_door anim_single( pow_door, "youre_here_for_us" );
	wait(0.1);
	pow_door anim_single( pow_door, "thank_god" );
	wait(0.1);
	level.woods anim_single( level.woods, "sog_were_gonna" );
	
	level thread woods_pow_VO_nag_line();
}

woods_pow_VO_nag_line()
{
	level endon("player_started_saving_pows");
	
	i = 1;
	while(!flag("player_started_saving_pows") && i < 4)
	{
		wait(15);
		level.woods anim_single( level.woods, "cell_nag_" + i);
		i++;
	}
}

#using_animtree ("player");
animate_player_open_door( align_node ) //self == player
{
	player_body = spawn_anim_model( "player_hands", (0,0,0) );
	player_body Hide();
	
	
	self AllowPickupWeapons( false );	
	self thread take_and_giveback_weapons("reznov_rescued");
	
	align_node thread maps\_anim::anim_first_frame(player_body, "reznov_rescue");
	wait(0.05);
	
	self StartCameraTween(0.1);
	self PlayerLinkToAbsolute(player_body, "tag_player");
	wait(0.2);
	align_node thread maps\_anim::anim_single_aligned( player_body, "reznov_rescue");
	wait(0.1);
	player_body Show();
		
	align_node waittill("reznov_rescue");
	
	self Unlink();
	player_body Delete();
	
	flag_set("player_saved_pows");
	self notify("reznov_rescued");
	
	connector = GetEnt("roll_up_door_clip", "targetname");
	connector ConnectPaths();
	connector Delete();
	
	
	level.pows = simple_spawn("pow_spawners");
	array_thread( level.pows, maps\pow_spawnfuncs::ai_no_dodge, 10 );
	
	trigger_use( "after_pow_color_trig", "targetname" );
	for(i=0; i<level.pows.size; i++)
	{
		level.pows[i] set_force_color("g");
	}
	
	self AllowPickupWeapons( true );
}

#using_animtree ("generic_human");

play_landed_woods_animation()
{
	if(IsDefined(level.barnes))
	{
		level.woods = level.barnes;
	}
	else if(!IsDefined(level.woods))
	{
		level.woods = simple_spawn_single("woods_compound_spawner");
		level.woods LinkTo(self, "origin_animate_jnt");
	}
	
	self maps\_anim::anim_single_aligned( level.woods, "playable_hind_climbout", "origin_animate_jnt");
	
	if(!isAI(level.woods)) //-- just a model is used in the cockpit, so after the animation spawn in a new one
	{
		level.woods Delete();
		level.woods = simple_spawn_single("woods_compound_spawner");
	}
	
	if(IsSubStr(level.woods GetAttachModelName(0), "head"))
	{
		// level.woods Detach(level.woods.headmodel);
		// level.woods SetModel("c_usa_jungmar_barnes_pris_fb");
		level.woods SetModel("t5_gfl_hk416_v2_body");
	}
	
	//-- put him on the groundpos
	/*
	trace = BulletTrace( level.woods.origin, level.woods.origin - (0,0,500), false, level.woods );
	level.woods ForceTeleport( trace["position"] + (0,0,5), level.woods.angles );
	*/
	
	level.woods Unlink();
	flag_set("woods_landing_animation_done");
}


kravchenko_pacing()
{
	align_node = getstruct( "struct_endfight", "targetname" );
	
	level.krav = simple_spawn_single( "kravchenko" );
	level.krav.health = 10000;
	level.krav SetCanDamage( false );
	level.krav.ignoreme = true;
	level.krav gun_remove();
	
	align_node thread maps\_anim::anim_loop_aligned( level.krav, "pacing" );
	
	flag_wait("player_breaching");
	level.krav Hide();
}

play_endfight_animation()
{
	level notify("end_fight");
	align_node = getstruct( "struct_endfight", "targetname" );
	
	if(!IsDefined(level.krav))
	{
		level.krav = simple_spawn_single( "kravchenko" );
		level.krav gun_remove();
		level.krav.health = 10000;
		level.krav SetCanDamage( false );
	}
	
	if(IsDefined(level.barnes)) //-- evil from not having the proper name of characters when this script was born
	{
		level.woods = level.barnes;
	}
	else if(!IsDefined(level.woods))
	{
		level.woods = simple_spawn_single( "woods_compound_spawner" );
	}
	
	animated_ai = [];
	animated_ai[0] = level.woods;
	animated_ai[1] = level.krav;
	
	align_node thread play_endfight_animation_player();
	align_node thread play_endfight_animation_props();
	
	level.krav thread show_after_delay(0.05);
	align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_enter" );
	align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_firstattack" );
	align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_gundraw" );
	align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_kickblock" );
	//align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_kickblock" );
	//align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_kickblock" );
	align_node notify("end_player_block"); //-- resync up with the player animations
	playsoundatposition( "evt_num_num_17_r" , (0,0,0) );
	align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_gungrab" );
	level thread break_window_after_delay();
	SetTimeScale(.82);
	align_node maps\_anim::anim_single_aligned( animated_ai, "endfight_shoot" );
	SetTimeScale(1.0);

	flag_wait("play_morph");
	wait(0.1);
	level.woods.name = "";
	align_node maps\_anim::anim_single_aligned( level.woods, "morph");
}

break_window_after_delay( guy )
{
	wait(1);
	println("broke_the_window");
	maps\pow_anim::notify_window_break();
}

woods_explosion( guy )
{
	playsoundatposition( "evt_big_explof" , self.origin );
	exploder(501);
	level notify("woods_explosion");
}

show_after_delay(delay)
{
	wait(delay);
	self Show();
}

#using_animtree ("player");

hack_chair()
{
	wait(1.5);
	self thread take_and_giveback_weapons("krav_scene_done");
	self thread maps\pow_anim::player_hit_with_chair( self );
}

play_endfight_animation_player()
{
	show_friendly_names( 0 );
	
	player = get_players()[0];
	player_body = spawn_anim_model( "player_hands", (0,0,0) );
	player.player_body = player_body;
		
	//player thread take_and_giveback_weapons("krav_scene_done");
	player PlayerLinkToAbsolute(player_body, "tag_player");
	
	player thread hack_chair();
	player StartCameraTween(0.2);
	self maps\_anim::anim_single_aligned(player_body, "endfight_enter");
	self maps\_anim::anim_single_aligned(player_body, "endfight_firstattack");
	self maps\_anim::anim_single_aligned(player_body, "endfight_gundraw");
	self maps\_anim::anim_single_aligned(player_body, "endfight_kickblock");
	self maps\_anim::anim_single_aligned(player_body, "endfight_gungrab");
	self thread maps\_anim::anim_single_aligned(player_body, "endfight_shoot");	
	
	
	/* // This is from the animation
	while(1)
	{
		player_body waittill( "single anim", msg );
		if(msg == "start fade")
		{
			break;
		}
	}*/
	
	level waittill("woods_explosion"); //-- This happens when the explosion goes off
	
	level.fadeToBlack = NewHudElem(); 
	level.fadeToBlack.x = 0; 
	level.fadeToBlack.y = 0;
	level.fadeToBlack.alpha = 0;
	level.fadeToBlack.horzAlign = "fullscreen"; 
	level.fadeToBlack.vertAlign = "fullscreen"; 
	level.fadeToBlack.foreground = false; 
	level.fadeToBlack.sort = 50; 
	level.fadeToBlack SetShader( "black", 640, 480 );        
		
	level.fadeToBlack FadeOverTime( 1.8 );
	level.fadeToBlack.alpha = 1; 

	wait(3); //-- this matches the above call

	player = get_players()[0];
	player_body Show();
	player PlayerLinkToAbsolute( player_body, "tag_player" );

//	player SetBlur(20, 0.1);
//	player SetBlur(5, 3);

	
	
	flag_set("play_morph");
	wait(0.1);

	self thread maps\_anim::anim_single_aligned(player_body, "morph");
	
	wait(1.0);
	level.fadeToBlack FadeOverTime( 3.0 );
	level.fadeToBlack.alpha = 0.43; 

	player_body waittill("morph");
	
	level.fadeToBlack Destroy();
}

#using_animtree ("animated_props");

play_endfight_animation_props()
{
	props_array = [];
	props_array[0] = spawn_anim_model("krav_gun", (0,0,0));
	props_array[1] = spawn_anim_model( "krav_chair", (0,0,0) );
	props_array[2] = spawn_anim_model( "krav_knife", (0,0,0) );
	
	self maps\_anim::anim_single_aligned( props_array, "endfight_enter");
	self maps\_anim::anim_single_aligned( props_array, "endfight_firstattack");
	self maps\_anim::anim_single_aligned( props_array, "endfight_gundraw");
	self maps\_anim::anim_single_aligned( props_array, "endfight_kickblock");
	self maps\_anim::anim_single_aligned( props_array, "endfight_gungrab");
	self maps\_anim::anim_single_aligned( props_array, "endfight_shoot");
}

#using_animtree ("player");

play_landed_animation()
{
	player = get_players()[0];
	level notify("player_out_of_copter");
	
	level.hind thread play_landed_woods_animation();
	
	level waittill("start_player_landed_animations");
	
	//SOUND - Shawn J
	clientnotify( "hind_exit_sequence" );
	//level.hind heli_toggle_rotor_fx(1);
	
	level.hind thread animate_barnes_headset_exit();
	level.hind thread animate_player_headset_exit();
	level.hind maps\_hind_player::player_exit_animation(player);
	
	add_spawn_function_veh( "no_tread_fx", maps\_utility::veh_toggle_tread_fx, 0 );
	add_spawn_function_veh( "no_tread_fx", maps\_utility::veh_toggle_exhaust_fx, 0 );
		
	maps\_vehicle::scripted_spawn( 16 ); //-- other hind
		
	player FreezeControls(false);
	player notify("landed_scene_done");
	
	flag_wait("woods_landing_animation_done");
	
	player = get_players()[0];
	//player FreezeControls(true);
	player SetClientDvar( "hud_showstance", "1" );
	player SetClientDvar( "actionSlotsHide", "0" );
	player SetClientDvar( "ammoCounterHide", "0" );
}

#using_animtree( "animated_props" );

prep_rolling_door()
{
	door = GetEnt("cave_rollup", "targetname");
	door.animname = "roll_door";
	door useAnimTree( #animtree );
	
	/*
	door.door_align = Spawn("script_model", door.origin);
	door.door_align SetModel("tag_origin");
	door.door_align.angles = door.angles - (0,90,0);
	*/
	
	door.door_align = getstruct("struct_rolling_door", "targetname");
	door.door_align anim_first_frame( door, "door_open" );
}

animate_rolling_door_open( guy )
{
	door = GetEnt("cave_rollup", "targetname");
	
	//SOUND - Shawn J
	clientnotify( "roll_up_door" );
	
	player_clip = GetEnt("roll_up_door_player_clip", "targetname");
	player_clip Delete();
		
	door.door_align anim_single_aligned( door, "door_open" );
}


animate_barnes_headset_exit() //-- self is the hind
{
	if(!IsDefined(level.woods_headset))
	{
		level.woods_headset = spawn_anim_model("barnes_headset", (0,0,0));
		level.woods_headset LinkTo( self, "origin_animate_jnt" );
	}
	
	level.woods_headset thread temp_dialogue_and_logic_takeoff();
	self maps\_anim::anim_single_aligned(level.woods_headset, "landing", "origin_animate_jnt");
	level.woods_headset Delete();
}

animate_player_headset_exit()
{
	if(!IsDefined(level.player_headset))
	{
		level.player_headset = spawn_anim_model("player_headset", (0,0,0));
		level.player_headset LinkTo( self, "origin_animate_jnt" );
	}
	
	self maps\_anim::anim_single_aligned(level.player_headset, "landing", "origin_animate_jnt");
	level.player_headset Delete();
}

#using_animtree ("generic_human");

setup_woods_kill_standing_guard() //-- this is woods killing the standing guard
{
	wait(2);
	
	level.woods thread anim_single( level.woods, "play_this_quiet" );
	
	trigger_wait("activate_woods_kill_guards");
	
	level.woods.perfectaim = true;
	level.woods thread shoot_at_target_untill_dead(level.stander);
	level.stander waittill("death");
	
	level.woods.perfectaim = false;
	
	trigger_use("woods_color_b12");
	wait(0.1);
	level.woods anim_single( level.woods, "lets_do_it" );
}

setup_mantle_guy_on_box()
{
	mantle_guy = GetEnt("box_mantle_guy", "script_noteworthy");
	mantle_guy add_spawn_function( ::guy_mantle_onto_box );
}

guy_mantle_onto_box()
{
	self endon("death");
	
	struct = getstruct("struct_mantle_on_box");
	
	self.allowdeath = true;
	self.animname = "generic";
	
	
	//self thread stop_anim_until_player_looks( 0.1 );
	
	
	struct thread anim_single_aligned( self, "mantle_on_box" );
	wait(0.5);
	self SetAnimLimited( level.scr_anim["generic"]["mantle_on_box"], 1, 0, 0 );
	player = get_players()[0];
	player waittill_player_looking_at( struct.origin + (0,0,35), 0.9, true );
	self SetAnimLimited( level.scr_anim["generic"]["mantle_on_box"], 1, 0, 1 );
	
	self.goalradius = 12;
	self SetGoalPos( self.origin );
}

stop_anim_until_player_looks( delay )
{
	player = get_players()[0];
	self SetAnimLimited( level.scr_anim["generic"]["mantle_on_box"], 1, 0, 0 );
	player waittill_player_looking_at( self.origin + (0,0,35), 0.85, true );
	self SetAnimLimited( level.scr_anim["generic"]["mantle_on_box"], 1, 0, 1 );
}

setup_rpg_rpk_at_hilltop_guys()
{
	rpk_guy = GetEnt("rpk_runout_guy", "script_noteworthy");
	rpk_guy add_spawn_function( ::rpk_runout_guy );
	
	rpg_guy = GetEnt("rpg_rollout_guy", "script_noteworthy");
	rpg_guy add_spawn_function( ::rpg_rollout_guy );
}

rpk_runout_guy()
{
	self endon("death");
	
	self thread rpk_or_rpg_died();
	
	//self SetCanDamage(false);
	//self waittill("goal");
	
	//simple_spawn_single("rpg_rollout_guy");
	
	player = get_players()[0];
	self thread shoot_at_target_untill_dead( player );
	//self SetCanDamage(true);
	
	level waittill_either("rpk_or_rpg_died", "rpg_guy_fired");
	
	self.noDodgeMove = true;
	self.goalradius = 256;
	self SetGoalPos( (30440, 58552, 935) );
	self waittill("goal");
	self Delete();
}

rpg_rollout_guy()
{
	self endon("death");
	self thread rpk_or_rpg_died();
	
	struct = getstruct("struct_rpg_rollout", "targetname");
	
	struct anim_generic_aligned( self, "rpg_rollout");
	self.goalradius = 32;
	self SetGoalPos( self.origin );
	
	self waittill("shoot"); //-- something here
	wait(1);
	
	level notify("rpg_guy_fired");
	
	self.noDodgeMove = true;
	//player = get_players()[0];
	//self thread shoot_at_target_untill_dead( player );
	
	self.goalradius = 256;
	self SetGoalPos( (30440, 58552, 935) );
	self waittill("goal");
	self Delete();
}

rpk_or_rpg_died()
{
	self waittill("death");
	level notify("rpk_or_rpg_died");
}

setup_guards_at_bottom_of_road()
{
	sitter = GetEnt("bottom_sitting_guard", "script_noteworthy");
	sitter add_spawn_function( ::bottom_guard_sit_animate );
	
	stander = GetEnt("bottom_standing_guard", "script_noteworthy");
	stander add_spawn_function( ::bottom_guard_stand_animate );
}

bottom_guard_stand_animate()
{
	self endon("death");
	
	struct = getstruct("struct_aloof_guard", "targetname");
	
	level.stander = self;
	self.ignoreall = true;
	self.ignoreme = true;
	self.health = 100;
	
	self.deathanim = %ai_death_collapse_in_place;
	self.allowdeath = true;
	
	struct thread anim_loop_aligned( self, "stand_guard_idle" );
	
	self waittill("damage");
	
	self StopAnimScripted();
	self.ignoreall = false;
	self.ingoreme = false; 
	
	wait(2);
	self.health = 100;
}

bottom_guard_sit_animate()
{
	self endon("death");
	
	while(!IsDefined(level.stander))
	{
		wait(0.05);
	}
	struct = getstruct("struct_guard_sitting", "targetname");
	
	self.ignoreall = true;
	self.ignoreme = true;
	self.health = 500;
	
	//struct thread anim_loop_aligned( self, "sit_guard_idle" ); //-- no one can see this
	
	self.allowdeath = true;
	struct thread anim_single_aligned( self, "sit_guard_react" );
	wait(0.75);
	self SetAnimLimited( level.scr_anim[ self.animname ][ "sit_guard_react" ], 1, 0, 0 );
	level.stander waittill("damage"); //-- when the stander dies, fall over!
	self SetAnimLimited( level.scr_anim[ self.animname ][ "sit_guard_react" ], 1, 0, 1 );
	self.ignoreall = false;
	
	wait(2);
	
	self.health = 100;
	self.ignoreme = false;
}


setup_flame_leapover()
{
	attacker = GetEnt("cave_flame_guy", "script_noteworthy");
	attacker add_spawn_function( ::cave_flame_attack_animate );
}

cave_flame_attack_animate()
{
	self endon("death");
	struct = getstruct("struct_flame_guy_jumpover", "targetname");
	
	self.animname = "generic";
	self.ignoreme = true;
	self SetCanDamage(false);
	
	//self gun_switchto("ft_ak47_sp", "right");
	
	struct thread anim_first_frame( self, "flame_over");
	
	trigger_wait("trig_mountain_vs");
	
	self SetCanDamage(true);
	self.health = 1000;
	self.allowdeath = true;
	self disable_pain();
	
	level thread woods_dialog_ft_on_death( self );
	struct maps\_anim::anim_generic_aligned( self, "flame_over" );
	
	self thread clear_ignoreme_after_delay(5);
	self thread player_seek_no_cover( level.woods );
}

clear_ignoreme_after_delay( delay )
{
	self endon("death");
	wait(delay);
	self.ignoreme = false;
	self.health = 100;
	self enable_pain();
}

woods_dialog_ft_on_death( ft_guy )
{
	ft_guy waittill("death");
	level.woods anim_single(level.woods, "get_ft");
	level.woods anim_single(level.woods, "burn_bastards");
}

spawn_guys_from_krav_door()
{
	struct = getstruct( "struct_krav_spawn_door", "targetname");
	
	door_ent = Spawn("script_model", struct.origin);
	door_ent SetModel("tag_origin_animate");
		
	door = GetEnt("krav_spawn_door", "targetname");
	door LinkTo(door_ent);
	
	trigger_wait("trig_open_krav_door");
	
	door_ent RotateYaw( -85, 1.2, 0.7, 0.5);
	wait(0.8);
	
	//-- RPG from here to over the player's head
	rpg_start = getstruct("struct_krav_door_rpg_start", "targetname");
	rpg_end = getstruct(rpg_start.target, "targetname");
	MagicBullet( "rpg_pow_sp", rpg_start.origin, rpg_end.origin );
	
	door_ent waittill("rotatedone");
	door ConnectPaths();
	
	//-- Spawn guys and send them out
	ais = simple_spawn("krav_spawn_room_spawners");
	
	ais_in_room = true;
	room_trig = GetEnt("trig_in_krav_spawn_room", "targetname");
	while(ais_in_room)
	{
		ais_in_room = false;
		
		for(i=0; i<ais.size; i++)
		{
			if(ais[i] IsTouching(room_trig))
			{
				ais_in_room = true;
			}
		}
		
		ais = array_removedead(ais);
		wait(0.05);
	}
	
	wait(1.5);
	
	//-- Close the door
	door_ent RotateYaw( 85, 2, 1, 0.5);
	door_ent waittill("rotatedone");
	door DisconnectPaths();
}
 