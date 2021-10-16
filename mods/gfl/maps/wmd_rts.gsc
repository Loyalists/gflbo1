#include maps\_utility;
#include common_scripts\utility;
#include maps\wmd_sr71_util;
#include maps\_anim;
#include maps\_music;
#include maps\_vehicle;

/*------------------------------------
squad control gameplay from the SR71
Chris P
------------------------------------*/
reset_enemy_reticule()
{
	screen = ent_get("sr71_cam");
	screen ClearClientFlag(0);
}

set_enemy_reticule()
{
	screen = ent_get("sr71_cam");
	screen SetClientFlag(0);	
}

reset_friendly_reticule()
{
	screen = ent_get("sr71_cam");
	screen ClearClientFlag(2);
	flag_clear("targetting_friendlies");
}

set_friendly_reticule()
{
	screen = ent_get("sr71_cam");
	screen SetClientFlag(2);
	flag_set("targetting_friendlies");
}

enable_extra_cam()
{
	cam = Getent("rts_extracam", "targetname");		
	cam SetClientFlag(1);	
}

disable_extra_cam()
{
	cam = Getent("rts_extracam", "targetname");		
	cam ClearClientFlag(1);	
}

start_increase_extra_cam_fov()
{
	screen = ent_get("sr71_cam");
	screen SetClientFlag(3);		
}

stop_increase_extra_cam_fov()
{
	screen = ent_get("sr71_cam");
	screen ClearClientFlag(3);		
}

start_decrease_extra_cam_fov()
{
	screen = ent_get("sr71_cam");
	screen SetClientFlag(4);		
}

stop_decrease_extra_cam_fov()
{
	screen = ent_get("sr71_cam");
	screen ClearClientFlag(4);		
}

set_initial_extra_cam_blur()
{
	screen = ent_get("sr71_cam");
	screen SetClientFlag(5);		
}

init_rso_focus()
{
	screen = ent_get("sr71_cam");
	screen SetClientFlag(7);
}

reset_rso_focus()
{
	screen = ent_get("sr71_cam");
	screen ClearClientFlag(7);
}

main()
{
	if(!IsDefined(level.extra_cam_enabled))
	{
		level.extra_cam_enabled = false;
	}
	
	level._old_drawdist = getDvarInt( #"cg_objectiveIndicatorFarFadeDist");
	
	player = get_players()[0];
	
	player SetClientDVar("cg_objectiveIndicatorFarFadeDist",8000000);	
	player SetClientDvar( "waypointOffscreenPadLeft", "20" );
	player SetClientDvar( "waypointOffscreenPadRight", "20" );
	player SetClientDvar( "waypointOffscreenPadTop", "15" );
	player SetClientDvar( "waypointOffscreenPadBottom", "15" );
	
	flag_wait("all_players_spawned");	
	level.is_in_rts = true;
	
	autosave_by_name("wmd_rts");
	
	if(getdvar(#"start") == "rts_test")
	{
		cam = Getent("rts_extracam", "targetname");		
		cam.Angles = ( 70,0, 0);
		enable_extra_cam();
		
		//cam SetClientFlag(8);
		set_initial_extra_cam_blur();
		
		flag_set("sr71_dialogue_done");
	}
	
	// Stop AI from running around the LHS of the safe house.
	
	level.safehouse_pathbreaker = GetEnt("safehouse_path_breaker", "targetname");
	level.safehouse_pathbreaker Hide();
	level.safehouse_pathbreaker DisconnectPaths();
			
	OnSaveRestored_Callback(::rts_on_save_restored);
	
	level notify("set_rts_fog");

	//TUEY Set music to "Canyon" (SR71_RTS)
	setmusicstate("SR71_RTS");

	visionsetnaked("wmd_sr71cam", 0);		
	//flag_wait("start_rts");
	
	//this deletes the pilot & copilot from the takeoff sequence	
	maps\wmd_intro::delete_pilot_and_copilot();
	
	sr71 = ent_get("sr71_cam");
	
	if(isDefined(sr71.pilot))
	{
		sr71.pilot delete();
		sr71.copilot delete();
	}
	
	make_player_copilot(sr71);
	sr71.pilot = Spawn("script_origin", sr71.origin);
	sr71.pilot.animname = "pilot";
	//hide the fake reticule -- NEED TO JUST GET RID OF THIS
	reticule = ent_get("cam_reticule");
	//reticule hide();
		
	player = get_players()[0];	
	//player thread auto_center_camera();
	
	//spawn the heroes
	level.rts_heroes = simple_spawn("rts_heroes",::setup_rts_heroes);
	level.rts_heroes[1].animname = "hudson";
	set_white_body_models(level.rts_heroes );
	array_thread( level.rts_heroes, ::ai_no_dodge, true );
	
	level thread prone_monitor();
	level thread first_patrol_clear_monitor();
	level thread ambient_vehicle_patrol_factory(1,6,5,11);
	
	//waypoint/objectives on the hud
	//level thread create_power_waypoint(getent("blow_tower","targetname"));	
	//level thread create_radar_waypoint(getent("rts_radar","targetname"));
		
	level thread spawn_rts_cam("rts_extracam","end_rts",1,1);	                                                           
	//set_hud_prompt_test("LEI'S TEST HUD ELEM HAHA",1);

	//-- GLocke: removed because of bug 32127
	//init_checkpoint_spotlights();
	
	setup_rts_spawnfunctions();
	
	//spawns in all the initial enemies , spotlights, etc.
	level thread setup_initial_scene();
	
	//sets up the guys breaching the hosue
	level thread house_breach_1();	
	
	//the tutorial to controlthe camera
	
	
	level thread tutorial_setup();

	//if(getDvar( #"start") != "rts_test")
	//{
	//	level thread wait_for_exit();
	//}
	
	level thread setup_outbound_jeeps();
	
	level thread setup_convoy();	

	level thread setup_first_patrol();
	
	level thread setup_second_patrol();
	
	level thread set_squad_cqb();
	
//	level thread switch_test();
}


#using_animtree("generic_human");
init_rts_flags()
{
	flag_init("start_rts");
	flag_init("rts_done");
	flag_init("squad_located");
	flag_init("move_squad");
	flag_init("optics_check");
	flag_init("zoom_in_check");
	flag_init("zoom_out_check");
	flag_init("zoom_check");
	flag_init("zoomed");
	flag_init("intro_dialogue_done");
	flag_init("squad_safehouse");
	flag_init("coms_tower_blown");
	flag_init("power_grid_blown");
	flag_init("rts_objectives_done");
	flag_init("squad_hidden");
	flag_init("weaver_knife");
	flag_init("weaver_pistol");
	flag_init("safehouse_door");
	flag_init("safehouse_fps_done");
	flag_init("squad_on_bluff");
	flag_init("locate_squad");
	flag_init("squad_detected");
	flag_init("squad_on_hilltop");
	flag_init("detach_chair1");
	flag_init("detach_chair2");
	flag_init("go_barracks");
	flag_init("pre_barracks");
	flag_init("jeep_guys_dead");
	flag_init("zoom_tut");
	flag_init("squad_moved");
	flag_init("patrol_prone");
	flag_init("squad_prone");
	flag_init("wait_for_prone_command");
	flag_init("targetting_friendlies");
	flag_init("first_patrol_clear");
	flag_init("close_door");
	flag_init("weaver_kickdoor");
	flag_init("garage_fps_done");
	flag_init("ambient_vehicle_patrols");
	flag_init("patrol_active");
	flag_init("second_patrol_evaded");
	flag_init("garage_fps");
	flag_init("first_responders");
	flag_init("explosive_placed");
	flag_init("detonation");
}


rumble_on_down()
{
	get_players()[0] PlayRumbleOnEntity("rappel_falling");
	
	wait(1.5);
	
	stopallrumbles();
}


set_squad_cqb()
{
	for(i = 0; i < level.rts_heroes.size; i ++)
	{
		level.rts_heroes[i] enable_cqbwalk();
		level.rts_heroes[i].sprint = true;;
	}
}


first_patrol_clear_monitor()
{
	level endon("end_rts");
	
	flag_wait("safehouse_fps_done");
	
	flag_clear("squad_hidden");
	
	flag_wait("patrol_prone");
	
	//num_needed = 4;
	
	//while(num_needed)
	//{
	//	ent = trigger_wait("patrol_clear_trigger");
	//	
	//	if(IsDefined(ent) && IsDefined(ent.who) && !ent.who is_vehicle() && !IsDefined(ent.who.ridingvehicle))
	//	{
	//		num_needed --;
	//	}
	//}
	
	wait(23.0);
	
	flag_set("first_patrol_clear");
	
	//TUEY set music back to SR71_RTS_SECOND_STATE if its been changed.					
	setmusicstate("SR71_RTS_SECOND_STATE");
	
	flag_clear("patrol_active");
	//flag_clear("wait_for_prone_command");
	
	operator = get_operator_ent();
	
	level.vo_playing = true;
	operator anim_single(operator, "patrol_clear");	//* All clear, Kilo One.
	level.vo_playing = false;
	
	level thread sparse_ambient_patrols();
	
	autosave_by_name("wmd_rts_patrol_done");
}

sparse_ambient_patrols()
{
	wait(25);
	flag_set("ambient_vehicle_patrols");	
	level thread ambient_vehicle_patrol_factory(1,4, 25,40);
	flag_wait("garage_fps");
	flag_clear("ambient_vehicle_patrols");
	level notify("ambient_vehicle_patrols");
	
	vehs = GetEntArray("ambient_vehicle", "script_noteworthy");
	array_delete(vehs);
	
	flag_wait("garage_fps_done");
	flag_set("ambient_vehicle_patrols");	
	//wait(35);
	//level thread ambient_vehicle_patrol_factory(1,4, 25,40);
}

setup_rts_spawnfunctions()
{
	add_spawn_function_veh("roadside_jeep1",::setup_incoming_jeep);	
//	getent("roadside_jeep","targetname") turn_jeep_lights_on(1);
	array_thread(getentarray("rts_checkpoint_jeep","targetname") ,::turn_jeep_lights_on,1);
	add_spawn_function_veh("rts_checkpoint_jeep2",::turn_jeep_lights_on);	
	
}

setup_incoming_jeep()
{
	self thread turn_jeep_lights_on();

	wait(2);
	
	vnode = getvehiclenode("gate_node","targetname");
	vnode waittill("trigger");
	wait(3);
	
	gate = getent("rts_gate1","targetname");
	gate movey(275,5,1);
	gate waittill("movedone");
	
	trigger_use("rts_outbound_gate_trig");
	
/*	wait(5);
	gate movey(-275,5,1);
	gate waittill("movedone");	*/
	
}

setup_outbound_jeeps()
{
	wait(5);
	jeeps = getentarray("rts_checkpoint_jeep2","targetname");
	array_thread(jeeps,::turn_jeep_lights_on);
}

#using_animtree("generic_human");
house_patroller_death_function()
{
	self thread magic_bullet_shield();
	self waittill("damage");
	
	death_anim = "first_death"; 
	
	if(!IsDefined(level._patroller_death))
	{
		level._patroller_death = 1;
		death_anim = "second_death"; 
	}
	
	self.animname = "generic";
	
	self AnimScripted( death_anim, self.origin, self.angles, level.scr_anim[ "generic" ][ death_anim ] );
	
	self notify("fake_death");
	self notify("no_detect");
	self.fake_killed = 1;
	self.dont_target = 1;
	
	self waittill(death_anim);
	
	endPos = self.origin + (0,0,-48);
	
	link_spot = Spawn("script_origin", self.origin);
	link_spot.angles = self.angles;
	self LinkTo(link_spot);
	
	link_spot thread anim_loop(self, death_anim + "_loop");
	
	link_spot moveto(endPos, RandomFloatRange(14,16.0));
	
	wait(1.0);
	self notify("waittill_dead_guy_dead_or_dying");
	
	link_spot waittill("movedone");
	
	self stop_magic_bullet_shield();
	
	self Delete();
	
	link_spot Delete();
}

setup_initial_scene()
{
	rts_house_patrollers = simple_spawn("rts_house_patroller",::setup_rts_generic_guys, 300);
	
	for(i = 0; i < rts_house_patrollers.size; i ++)
	{
		rts_house_patrollers[i] thread house_patroller_death_function();
		rts_house_patrollers[i] thread face_barrel();
	} 
	
	rts_house_patrollers[0] setup_flashlight();
	
	// ai group setup specifically for nag line to head east
	//level thread nag_direction_after_aigroup( "ledge_ai", "053A_usc2_f" );
	
	flag_wait("safehouse_fps_done");
	
	level thread vo_ridge();
	
	fire = getent("tag_barrel_fire", "targetname");
	
	playfxontag(level._effect["barrel_fire"], fire, "tag_origin");
	
	level.rts_house_guys = simple_spawn("rts_house_guys",::setup_rts_generic_guys, 128);
	
	for(i = 0; i < level.rts_house_guys.size; i ++)
	{
		level.rts_house_guys[i].no_target_dialog = 1;
	}
}


face_barrel()
{
	self waittill("reached_path_end");
	
	fire = getent("tag_barrel_fire", "targetname");
	
	self OrientMode("face point", fire.origin );
}


setup_rts_generic_guys(dist)
{
	self setup_rts_guy_model();
	if(IsDefined(self.target))
	{
		self thread setup_patroller(undefined,undefined,1);
		self thread detect_squad(dist);
	}
	else if(IsDefined(self.script_string) && self.script_string == "animate_at_console" )
	{
		self thread anim_generic( self, "idle_at_console");
	}
}


clearup_safehouse_rts_guys()
{
	jeep1_guys = get_ai_group_ai("veh1_guys");
	jeep4_guys = get_ai_group_ai("veh4_guys");
	allguys = array_combine(jeep1_guys,jeep4_guys);
	
	for(i = 0; i < allguys.size; i ++)
	{
		allguys[i] Delete();
	}
}

setup_safehouse_fps_convoy_vehicle()
{
	
	self turn_jeep_lights_on();
	self thread go_path(GetVehicleNode(self.target, "targetname"));
	self.vehicleavoidance = 0;
	self thread veh_magic_bullet_shield(1);
}

unload_trigger(node_note)
{
	node = GetVehicleNode(node_note, "script_noteworthy");
		
	node waittill("trigger", veh);
	
	//veh SetSpeed(10, 15, 0.5);
	 
	operator = get_operator_ent();
	
	level.vo_playing = true;
	
	operator anim_single(operator, "366A_usc2_f");// "Wait, no. Enemy has stopped in front of the house.";
	
	level.vo_playing = false;
}

prone_model_swap_monitor()
{
	level endon("end_rts");
	level endon("squad_detected");

	all_prone = false;

	told_about_prone_success = false;

	while(1)
	{
		
		if(flag("squad_prone") && level._white_models)
		{
			restore_body_model(level.rts_heroes);
			//array_thread( level.rts_heroes, ::ai_no_dodge, false );
			if(!told_about_prone_success)
			{
				told_about_prone_success = true;
				operator = get_operator_ent();
				
				level.vo_playing = true;
				operator anim_single(operator, "like_ninjas");
				level.vo_playing = false;
			}
		}
		else if(!flag("squad_prone") && !level._white_models)
		{
			set_white_body_models(level.rts_heroes);
			//array_thread( level.rts_heroes, ::ai_no_dodge, true );
		}
		wait(0.1);
	}
}

prone_monitor()
{
	level endon("end_rts");
	level endon("squad_detected");
	
	level thread prone_model_swap_monitor();
	
	
	while(1)
	{
		if(IsDefined(level.rts_heroes))
		{
			all_prone = true;
			
			for(i = 0; i < level.rts_heroes.size; i ++)
			{
				if(level.rts_heroes[i].a.pose != "prone")
				{
					all_prone = false;
				}
			}	
			
			if(!flag("squad_prone"))
			{
				if(all_prone)
				{
					flag_set("squad_prone");
				}
			}
			else
			{
				if(!all_prone)
				{
					flag_clear("squad_prone");
					

				}
			}
		}
		wait(0.1);
	}
}


clearup_garage_rts_guys()
{
	for(i = 0; i < level.rts_house_guys.size; i ++)
	{
		level.rts_house_guys[i] Delete();
	}
}

weaver_door_open()
{
	level waittill ("opening_weaver_door");
	battlechatter_on();
	
	clip = getent("clip_barracks_door", "targetname");
	door = getent("barracks_door", "targetname");
	
	door rotateyaw(165, 0.2);
	clip connectpaths();
	clip trigger_off();
		
	exploder(601);
	
	trigger_wait("player_enter_garage");
	
	level notify( "audio_stop_single_gust" );
	
	door RotateYaw(-165,0.2);
	clip disconnectpaths();
	clip trigger_on();
	
	wait(0.1);
	
	stop_exploder(601);
}


brooks_door_open()
{
	level waittill ("opening_brooks_door");
	door = getent("fps_garage_door2", "targetname");

	door rotateyaw(108, 0.1);

	door connectpaths();

	flag_wait("close_door");
	
	door disconnectpaths();
	
	door rotateyaw(-100, 0.1);
}


harris_door_open()
{
	level waittill("opening_harris_door");

	door = getent("fps_garage_door3", "targetname");
	door rotateyaw(-85, 0.1);
	
	door connectpaths();
	
	exploder(603);
	
	flag_wait("close_door");
	
	door disconnectpaths();
	
	door rotateyaw(80, 0.1);
}


weaver_breach()
{
	align_node = getstruct("weaver_breach_align_origin", "targetname");

	level thread weaver_door_open();

	player = get_players()[0];

	scene_ai = [];
	
	player_body = spawn_anim_model( "fps_player_body" , player.origin, player.angles);
	player_body UseAnimTree(level.scr_animtree["fps_player_body"] );
	player_body.animname = "fps_player_body";

	scene_ai = array_add(scene_ai, player_body);
	scene_ai = array_add(scene_ai, level.fps_heroes["weaver"]);
	
	player thread breach_link_and_hide_player_weapons(player_body);
	
	wait 0.05;
	
	player_body Attach("t5_weapon_aug_viewmodel_arctic", "tag_weapon", true);

	addNotetrack_customFunction( "weaver", "door_kick", ::kick_weaver_door, "weaver_player_breach" );	
	addNotetrack_customFunction( "fps_player_body", "enable_player", ::return_control_to_player, "weaver_player_breach" );	
	
	//level waittill("start_weaver_breach");
	
	align_node anim_reach_aligned(level.fps_heroes["weaver"], "weaver_player_breach");
	
	align_node thread anim_single_aligned(scene_ai, "weaver_player_breach");
	
	player StartCameraTween(3.0);
	
	wait(3.1);
	
	VisionSetNaked("wmd_sr71barracks");
	
	level notify("kill_smoker");
}

kick_weaver_door(guy)
{
	level notify("opening_weaver_door");
	
	flag_set("weaver_kickdoor");
}

breach_link_and_hide_player_weapons(body, not_absolute, alternate_functionality)
{
	if(IsDefined(alternate_functionality) && alternate_functionality)
	{
		self HideViewModel();
		self DisableWeapons();
	}
	else
	{
		self SetLowReady(true);
	}
	
	wait .05;
	self PlayerLinkToAbsolute(body, "tag_player");	
	
	self StartCameraTween(.2);
	
	/*
	if(!IsDefined(not_absolute))
	{
		wait(0.05);
		self PlayerLinkToDelta(body, "tag_player", 1, 15, 15, 45, 15);
	}
	*/
}

harris_brooks_breach()
{
	level thread harris_door_open();
	level thread brooks_door_open();
	
	scene_ai = [];
	scene_ai = array_add(scene_ai, level.fps_heroes["brooks"]);
	scene_ai = array_add(scene_ai, level.fps_heroes["harris"]);
	
	for(i = 0; i < scene_ai.size; i ++)
	{
		scene_ai[i].pacifist = true;
		scene_ai[i].ignoreme = true;
		scene_ai[i].ignoreall = true;
	}
	
	wait(1.5);
	
	align_node = getstruct("weaver_breach_align_origin", "targetname");
	
	addNotetrack_customFunction( "harris", "door_kick", ::kick_harris_door, "brooks_harris_breach" );	
	addNotetrack_customFunction( "brooks", "door_kick", ::kick_brooks_door, "brooks_harris_breach" );	
	
	align_node anim_single_aligned(scene_ai, "brooks_harris_breach");

	for(i = 0; i < scene_ai.size; i ++)
	{
		scene_ai[i].pacifist = false;
		scene_ai[i].ignoreme = false;
		scene_ai[i].ignoreall = false;
		scene_ai[i] setgoalpos(scene_ai[i].origin);
	}
	
	level.fps_heroes["brooks"] PushPlayer(true);
	level.fps_heroes["brooks"].goalradius = 32;
	level.fps_heroes["brooks"].grenadeawareness = 0;
	
	node_harris = getnode("harris_postbreach_node", "targetname");
	node_brooks = getnode("brooks_postbreach_node", "targetname");
	
	level.fps_heroes["harris"] thread force_goal();
	level.fps_heroes["brooks"] thread force_goal();
	
	level.fps_heroes["harris"] setgoalnode(node_harris);
	level.fps_heroes["brooks"] setgoalnode(node_brooks);
	
	array_wait(scene_ai, "goal");
	
	flag_set("close_door");
}


get_to_node(node_name)
{
	self thread force_goal();
	
	self SetGoalNode(GetNode(node_name, "targetname"));
}


harris_and_brooks_to_cover(label)
{
	level.fps_heroes["harris"] thread get_to_node("harris_" + label);
	//level.fps_heroes["brooks"] thread get_to_node("brooks_" + label);
	level.fps_heroes["weaver"] thread get_to_node("weaver_" + label);
}

kick_harris_door(guy)
{
	level notify("opening_harris_door");
}


kick_brooks_door(guy)
{
	level notify("opening_brooks_door");
}


setup_garage_chair_guy(guy_targetname, node_name, chair_modelname, anim_name)
{
	guys = GetEntArray(guy_targetname, "script_noteworthy");
	
	guy = undefined;
	
	for(i = 0; i < guys.size; i ++)
	{
		if(IsAI(guys[i]) )
		{
			guy = guys[i];
			break;
		}
	}
	
	if(IsDefined(guy))
	{
		guy.animname = "generic";
		guy.allowdeath = true;
		
		node_align = getstruct(node_name, "targetname");
		
		//guy Attach(chair_modelname, "tag_inhand");
		
		node_align anim_single_aligned(guy, anim_name);
		
		//guy Detach(chair_modelname, "tag_inhand");
		
		if (guy.script_noteworthy == "fps_garage_chair_1_guy" && isAlive(guy))
		{
			guy thread chair1_post_anim();
		}
		
		if (guy.script_noteworthy == "fps_garage_chair_2_guy" && isAlive(guy))
		{
			guy thread chair2_post_anim();
		}
		
		real_chair = Spawn("script_model", guy GetTagOrigin("tag_inhand"));
		real_chair.angles = guy GetTagAngles("tag_inhand");
		real_chair SetModel(chair_modelname);
	}
}


setup_chair1_anim()
{
	self endon("death");
	
	self thread detach_chair1();
	self thread detach_chair1_death();
	self thread spawn_chair1();
	
	self.animname = "generic";
	
	node_align = getstruct("barracks_chair_1_align", "targetname");
	
	node_align thread anim_loop_aligned(self, "first_chair_loop");
	
	self Attach("melee_chair", "tag_inhand");
	
	flag_wait("weaver_kickdoor");
	
	wait(2.0);
	
	self thread wait_chair_detach();
	
	node_align anim_single_aligned(self, "first_chair");
	
	self thread chair1_post_anim();
}


wait_chair_detach()
{
	wait(2.0);
	
	self.allowdeath = true;
	
	flag_set("detach_chair1");
}


setup_chair2_anim()
{
	self endon("death");
	
	//self thread detach_chair2();
	//self thread detach_chair2_death();
	//self thread spawn_chair2();
	
	self.allowdeath = true;
	self.animname = "generic";
	
	node_align = getstruct("barracks_chair_2_align", "targetname");
	
	node_align thread anim_loop_aligned(self, "second_chair_loop");
	
	self Attach("melee_chair", "tag_inhand");
	
	flag_wait("weaver_kickdoor");
	
	self Detach("melee_chair", "tag_inhand");
	
	real_chair = Spawn("script_model", self GetTagOrigin("tag_inhand"));
	real_chair.angles = self GetTagAngles("tag_inhand");
	real_chair SetModel("melee_chair");
	
	wait(2.5);
	
	node_align anim_single_aligned(self, "second_chair");
	
	self thread chair2_post_anim();
}


spawn_chair1()
{
	flag_wait("detach_chair1");
	
	real_chair = Spawn("script_model", self GetTagOrigin("tag_inhand"));
	real_chair.angles = self GetTagAngles("tag_inhand");
	real_chair SetModel("melee_chair");
	
	real_chair physicslaunch(real_chair.origin, (0, 0, 0));
}


detach_chair1()
{
	self endon("death");
	
	flag_wait("detach_chair1");
	
	self Detach("melee_chair", "tag_inhand");
}


detach_chair1_death()
{
	self waittill("damage");
	
	flag_set("detach_chair1");
}


chair1_post_anim()
{
	self endon("death");
	
	self get_to_node("node_post_chair1");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


chair2_post_anim()
{
	self endon("death");
	
	self get_to_node("node_post_chair2");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


setup_garage_chair_guys()
{
	chair1_guy = getai_by_noteworthy("fps_garage_chair_1_guy");
	chair2_guy = getai_by_noteworthy("fps_garage_chair_2_guy");
	
	chair1_guy thread setup_chair1_anim();
	chair2_guy thread setup_chair2_anim();
	
	//level thread setup_garage_chair_guy("fps_garage_chair_1_guy", "barracks_chair_1_align", "melee_chair", "first_chair");
	//level thread setup_garage_chair_guy("fps_garage_chair_2_guy", "barracks_chair_2_align", "melee_chair", "second_chair");
}


setup_garage_bunk_guys()
{
	bunk_nodes = getstructarray("bunk_align", "script_noteworthy");
	bunk_guys_and_spawners = GetEntArray("bunk_guy", "script_noteworthy");
	
	bunk_guys = [];
	for(i = 0; i < bunk_guys_and_spawners.size; i ++)
	{
		if(IsAI(bunk_guys_and_spawners[i]))
		{
			bunk_guys[bunk_guys.size] = bunk_guys_and_spawners[i];
		}
	}
	
	for(i = 0; i < bunk_guys.size; i ++)
	{
		bunk_guys[i].animname = "generic";
		bunk_guys[i].allowdeath = true;
		bunk_nodes[i] thread anim_single_aligned(bunk_guys[i], "bunk" + (1 + i));
		
		if (i == 0)
		{
			bunk_guys[i] thread bunk1_post_anim();
		}
		
		if (i == 1)
		{
			bunk_guys[i] thread bunk2_post_anim();
		}
	}
}


bunk1_post_anim()
{
	self endon("death");
	
	self get_to_node("node_bunk1");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


bunk2_post_anim()
{
	self endon("death");
	
	self get_to_node("node_bunk2");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


setup_garage_bunk_talker_guys()
{
	talker_node = getstruct("bunk_talkers_align", "script_noteworthy");
	talkers_and_spawners = GetEntArray("bunk_talker", "script_noteworthy");

	talker_guys = [];
	for(i = 0; i < talkers_and_spawners.size; i ++)
	{
		if(IsAI(talkers_and_spawners[i]))
		{
			talker_guys[talker_guys.size] = talkers_and_spawners[i];
		}
	}

	for(i = 0; i < talker_guys.size; i ++)
	{
		talker_guys[i].animname = "generic";
		talker_node thread anim_single_aligned(talker_guys[i], "talking_guard_" + (1 + i));
	}
	
}


barracks_response()
{
	wait(2.0);
	
	flag_set("first_responders");
	
	wait(2.0);
	
	flag_set("second_reinforcement");
}


setup_garage_first_reenforcements()
{
	reenforcement_node = getstruct("barracks_reenforce_align", "targetname");
	reenforcements_and_spawners = GetEntArray("first_reenforcements", "script_noteworthy");

	reenforcement_guys = [];
	
	redshirt = 1;
	for(i = 0; i < reenforcements_and_spawners.size; i ++)
	{
		if(IsAI(reenforcements_and_spawners[i]))
		{
			reenforcements_and_spawners[i].animname = "redshirt" + redshirt;
			reenforcements_and_spawners[i].allowdeath = true;
			reenforcements_and_spawners[i].ignoreall = true;
			reenforcements_and_spawners[i].goalradius = 16;
			
			if (reenforcements_and_spawners[i].animname == "redshirt1" && isAlive(reenforcements_and_spawners[i]))
			{
				reenforcements_and_spawners[i] thread redshirt1_anim();
			}
	
			if (reenforcements_and_spawners[i].animname == "redshirt2" && isAlive(reenforcements_and_spawners[i]))
			{
				reenforcements_and_spawners[i] thread redshirt2_anim();
			}
			
			redshirt ++;
		}
	}
}


redshirt1_anim()
{
	self endon("death");
	
	flag_wait("first_responders");
	
	self.ignoreall = false;
	
	reenforcement_node = getstruct("barracks_reenforce_align", "targetname");
	
	reenforcement_node anim_reach_aligned(self, "first_reenforcements");
	
	reenforcement_node anim_single_aligned(self, "first_reenforcements");
	
	self get_to_node("node_first_redshirt1");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


redshirt2_anim()
{
	self endon("death");
	
	flag_wait("first_responders");
	
	self.ignoreall = false;
	
	reenforcement_node = getstruct("barracks_reenforce_align", "targetname");
	
	reenforcement_node anim_reach_aligned(self, "first_reenforcements");
	
	reenforcement_node anim_single_aligned(self, "first_reenforcements");
	
	self get_to_node("node_first_redshirt2");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


setup_garage_second_reenforcements()
{
	reenforcements_and_spawners = GetEntArray("second_reenforcements", "script_noteworthy");

	reenforcement_guys = [];
	
	redshirt = 1;
	
	for(i = 0; i < reenforcements_and_spawners.size; i ++)
	{
		if(IsAI(reenforcements_and_spawners[i]))
		{
			reenforcements_and_spawners[i].animname = "redshirt" + redshirt;
			reenforcements_and_spawners[i].allowdeath = true;
			reenforcements_and_spawners[i].ignoreall = true;
			reenforcements_and_spawners[i].goalradius = 16;
			
			if (reenforcements_and_spawners[i].animname == "redshirt1" && isAlive(reenforcements_and_spawners[i]))
			{
				reenforcements_and_spawners[i] thread redshirt1_group2_anim();
			}
	
			if (reenforcements_and_spawners[i].animname == "redshirt2" && isAlive(reenforcements_and_spawners[i]))
			{
				reenforcements_and_spawners[i] thread redshirt2_group2_anim();
			}
			
			redshirt ++;
		}
	}
}


redshirt1_group2_anim()
{
	self endon("death");
	
	flag_wait("second_reinforcement");
		
	self.ignoreall = false;
	
	reenforcement_node = getstruct("barracks_reenforce_align", "targetname");
	
	reenforcement_node anim_reach_aligned(self, "second_reenforcements");
	reenforcement_node anim_single_aligned(self, "second_reenforcements");
	
	self get_to_node("node_first_redshirt1");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


redshirt2_group2_anim()
{
	self endon("death");
	
	flag_wait("second_reinforcement");
	
	self.ignoreall = false;
	
	reenforcement_node = getstruct("barracks_reenforce_align", "targetname");
	
	reenforcement_node anim_reach_aligned(self, "second_reenforcements");
	reenforcement_node anim_single_aligned(self, "second_reenforcements");
	
	self get_to_node("node_first_redshirt1");
	
	wait(0.1);
	
	self.goalradius = 16;
	
	wait(RandomFloatRange(3.0, 5.0));
	
	self.goalradius = 2048;
}


setup_garage_smoker()
{
	smoker_and_spawner = GetEntArray("fps_garage_smoker", "script_noteworthy");

	smoker_guys = [];
	
	for(i = 0; i < smoker_and_spawner.size; i ++)
	{
		if(IsAI(smoker_and_spawner[i]))
		{
			smoker_guys[smoker_guys.size] = smoker_and_spawner[i];
		}
	}		
	
  smoker_guys[0] thread smoke_til_dead();
  smoker_guys[0] thread die_when_told();
	
}

die_when_told()
{
	level waittill("kill_smoker");
	self.custom_gib_refs[0] = "right_arm";
		
	if (isAlive(self))
	{
		if(is_mature())
		{
			self extreme_bloody_death(true, 0);
		}
		else
		{
			self thread bloody_death(true);
		}
	}
}

smoke_til_dead()
{
	//level waittill("opening_weaver_door");
	align_node = getstruct("smoke_align", "targetname");
	self.animname = "generic";
	self.allowdeath = true;
	align_node anim_single_aligned(self, "patrol_idle_smoke");
}	

debug_text()
{
	if(!IsAI(self))
	{
		return;
	}
	
	self endon("death");
	
	while(1)
	{
		wait(1.0);
		if(IsDefined(self.script_noteworthy))
		{
			//IPrintLnBold(self.script_noteworthy);
		}
		else
		{
			//IPrintLnBold(self.targetname);
		}
	}
}

do_barracks_objectives(struct)
{
	clip_ent = GetEnt("comms_clip", "targetname");
	clip_ent Hide();
	
	//Objective_Add(6, "current", &"WMD_SR71_CLEAR_BARRACKS", struct.origin);
	
	level waittill("barracks_clear");
	
	pos_charge = getstruct("pos_charge", "targetname");
	
	Objective_Position(4, pos_charge.origin);
	Objective_Set3D(4, true, "default", &"WMD_SR71_PLANT");
	
	trig = getent("trigger_charge", "targetname");
	
	player = get_players()[0];
	
	while(1)
	{
		trig waittill("trigger");
		
		get_players()[0] SetScriptHintString(&"WMD_SR71_PLANT_EXPLOSIVE");
								
		while((player isTouching(trig)) && (!player use_button_held() ))
		{
			wait(0.05);
		}
		
		get_players()[0] SetScriptHintString("");
		
		if (player use_button_held())
		{
			break;
		}
	}
	
	Objective_Set3D(4, false, "default", &"WMD_SR71_DESTROY");

	player = get_players()[0];
	player.player_body = spawn_anim_model("player_sabotage_hands", player.origin, player.angles);
	player.player_body hide();
	player.player_body UseAnimTree(level.scr_animtree["player_sabotage_hands"]);
	player.player_body.animname = "player_sabotage_hands";
	player thread breach_link_and_hide_player_weapons(player.player_body, false, true);
	
	align_node = getstruct("destroy_console_align", "targetname");
	
	align_node anim_first_frame(player.player_body, "plant_semtex");
	
	wait (0.05);
	
	player.player_body show();
	
	player.player_body Attach("weapon_semtex_grenade", "tag_weapon");
	
	align_node anim_single_aligned(player.player_body, "plant_semtex");
	
	player Unlink();
	
	player SetOrigin(player.player_body GetTagOrigin("tag_player"));
	
	player ShowViewModel();
	player EnableWeapons();
	
	player.player_body Delete();	
	player.player_body = undefined; 
	
	flag_set("explosive_placed");
		
	player take_weapons();
	
	player GiveWeapon( "satchel_charge_sp" );
	player SetActionSlot( 4, "weapon", "satchel_charge_sp" );
	player SwitchToWeapon( "satchel_charge_sp" );
	player SetWeaponAmmoClip("satchel_charge_sp", 0);
	player SetWeaponAmmoStock("satchel_charge_sp", 0);
	player DisableWeaponCycling();

	//Objective_Set3D(6, true, "default", &"WMD_SR71_DESTROY");
	
	screen_message_create(&"WMD_SR71_DETONATE");
	
	//player waittill_any( "detonate", "alt_detonate" );
	
	while(!player AttackButtonPressed())
	{
		wait(0.05);
	}
	
	exploder(88);
	
	flag_set("detonation");
	
	screen_message_delete();
	
	level notify("comms_destroyed");
	
	wait(0.05);
	
	pos_charge = getstruct("pos_charge", "targetname");
	playsoundatposition("wpn_grenade_explode" , pos_charge.origin);
	
	earthquake(0.2, 3.0, get_players()[0].origin,  500);
	
	player PlayRumbleOnEntity("grenade_rumble");
	
	wait(0.2);
	
	playsoundatposition( "evt_barracks_powerdownf" , (0, 0, 0) );

	level ClientNotify("barracks_destroy");
	VisionSetNaked("wmd_sr71_rts_barracks_destroy");

	wait(0.3);
	
	player EnableWeaponCycling();
	player TakeWeapon( "satchel_charge_sp" );

	player give_weapons();

	Objective_State(4, "done");
	objective_delete(4);
	
	wait(1.0);
	
	box_panels = GetEntArray( "comms_destructable", "script_noteworthy" );
	
	for(i = 0; i < box_panels.size; i++)
	{
		PlayFX( level._effect["electric_box"], box_panels[i].origin, AnglesToForward(box_panels[i].angles) );
	}
	
	wait(0.1);
	
	array_delete(box_panels);
}


force_last_wave()
{
	trigger_wait("trigger_force_last_wave");
//	IPrintLnBold("Forcing last wave");
	level.last_wave_forced = true;
	guys3 = simple_spawn("fps_garage_group3", ::last_barracks_group);
}


garage_fps()
{
	level endon("end_rts");
	level endon("squad_detected");
	
	flag_wait("garage_fps");
	
	//-- turn off ignoreme that was used during the patrol
	array_thread( level.rts_heroes, ::set_ignoreme, false );
	
	autosave_by_name("wmd_rts_garage_fps");
	
	level.last_wave_forced = false;
	
	level thread force_last_wave();
	
	patrollers = GetEntArray("patroller", "script_noteworthy");
	for(i = 0; i < patrollers.size; i ++)
	{
		patrollers[i] Delete();
	}
	
	clearup_garage_rts_guys();
	
	player = get_players()[0];
	player playsound( "evt_rso_zoomdown_front" );//kevin adding sound call for custom cinematic
	
	level thread rumble_on_down();
		
	level thread hud_utility_show( "cinematic", 0.25 );
	Start3DCinematic( "dropfirstperson_v2", false, true );
	level thread audio_play_wind_howling();
	
	wait(0.25);
	
	player_on_ground("garage");
	
	level thread weaver_breach();
	level thread harris_brooks_breach();

	wait(1.25);
	
	barracks_struct = getstruct("communications_objective", "targetname");
	level thread do_barracks_objectives(barracks_struct);

	//operator = get_operator_ent();
	//operator thread anim_single(operator, "multiple_targets");

	level notify("start_weaver_breach");
	
	hud_utility_hide("cinematic", 0.25);
	Stop3DCinematic();
	
	//TUEY Set music state to SR71_RTS
	setmusicstate("BARRACKS_BREECH");	
	battlechatter_on();

	level.fps_garage_guys = simple_spawn("fps_garage_group1");

	for(i = 0; i < level.fps_garage_guys.size; i ++)
	{
		level.fps_garage_guys[i].pacifist = true;
		level.fps_garage_guys[i].ignoreme = true;
		level.fps_garage_guys[i].ignoreall = true;
	}
	
	level thread setup_garage_chair_guys();
	
	level waittill("opening_weaver_door");

	for(i = 0; i < level.fps_garage_guys.size; i ++)
	{
		level.fps_garage_guys[i].pacifist = false;
		level.fps_garage_guys[i].ignoreme = false;
		level.fps_garage_guys[i].ignoreall = false;
	}
	
	guys = GetEntArray("fps_garage_group1", "targetname");

	setup_garage_bunk_guys();
	setup_garage_smoker();
	//setup_garage_bunk_talker_guys();
	level thread setup_garage_first_reenforcements();
	level thread barracks_response();
	level thread monitor_first_group();

	flag_wait("second_group");

	harris_and_brooks_to_cover("post_1");

	guys2 = simple_spawn("fps_garage_group2");
	
	level thread setup_garage_second_reenforcements();
	
	waittill_ai_group_ai_count("garage_wave_1", 0);	
	waittill_ai_group_ai_count("garage_wave_2", 0);	
	
	harris_and_brooks_to_cover("post_2");

	if(!level.last_wave_forced)
	{
		guys3 = simple_spawn("fps_garage_group3", ::last_barracks_group);
	}
	
	waittill_ai_group_ai_count("garage_wave_3", 0);
	
	autosave_by_name("barracks_clear");
	battlechatter_off();
	
	wait(1.0);
	
	operator = get_operator_ent();
	level.vo_playing = true;
	operator anim_single(operator, "in_the_clear");
	level.vo_playing = false;

	level notify("barracks_clear");
	
	level.fps_heroes["harris"] thread get_to_node("harris_destroy");
	wait(0.3);
	level.fps_heroes["weaver"] thread get_to_node("weaver_destroy");
	
	//TUEY Set music state to POST_FIGHT_STINGER
	setmusicstate("POST_FIGHT_STINGER");
	
	flag_wait("explosive_placed");
		
	level.fps_heroes["brooks"] thread get_to_node("brooks_destroy");
	
	level.fps_heroes["weaver"] enable_cqbwalk();
	level.fps_heroes["weaver"] thread get_to_node("weaver_node_explosion");
	
	wait(0.3);
	
	level.fps_heroes["harris"] thread get_to_node("harris_node_explosion");
	
	flag_wait("detonation");
	
	level thread create_streamer_ent();
	
	level.fps_heroes["weaver"] enable_cqbwalk();
	level.fps_heroes["weaver"] thread get_to_node("weaver_post_destroy");
	level.fps_heroes["brooks"] enable_cqbwalk();
	level.fps_heroes["brooks"] thread get_to_node("brooks_post_destroy");

	wait(2.5);

	//operator anim_single( operator, "objective_complete");

	hudson = get_hudson_ent();
	level.vo_playing = true;
	hudson anim_single( hudson, "comms_down");
	level.vo_playing = false;
	
	wait(0.5);
	
	level.vo_playing = true;
	operator anim_single( operator, "copy_that");
	level.vo_playing = false;
	
	//TEMP
	//level waittill("stop_here");

	wait(1.5);
	
	player playsound( "evt_rso_zoomup_front" );//kevin adding sound call for custom cinematic
	level notify( "audio_turn_off_wind_loopers" );
	
	give_player_max_ammo();
	
	get_players()[0] EnableInvulnerability();
	
	level thread hud_utility_show( "cinematic", 0.25 );
	Start3DCinematic( "reversefirstperson_v1", false, true );
	
	level thread rumble_on_down();
			
	wait(0.25);

	structs = getstructarray("post_garage_rts_regroup", "script_noteworthy");
	nodes = getnodearray("barracks_regroup", "targetname");
	
	player_in_cockpit();

	for(i = 0; i < level.rts_heroes.size; i ++)
	{
		level.rts_heroes[i] ForceTeleport(nodes[i].origin, nodes[i].angles);
		level.rts_heroes[i] setgoalnode(nodes[i]);
	}

	/*
	cam = GetEnt("rts_extracam", "targetname");
	
	h = cam.origin[2] - structs[0].origin[2];
	
	vec = AnglesToForward(cam.angles) * -1 * h;
	
	level.force_cam_pos = (structs[0].origin[0], structs[0].origin[1], vec[2]);
	*/
	
	center_camera_over_ai( level.rts_heroes[0] );
	
	wait 1.25;
	
	hud_utility_hide("cinematic", 0.25);
	Stop3DCinematic(); 	
	
	flag_set("garage_fps_done");
	
	//TUEY Set music state to BACK_IN_PLANE
	setmusicstate("BACK_IN_PLANE");
	
	delete_streamer_ent();
}


monitor_first_group()
{
	waittill_ai_group_count("garage_wave_1", 2);
	
	flag_set("second_group");
}


last_barracks_group()
{
	self endon("death");
	
	wait(RandomFloatRange(0.5, 4.0));
	
	self thread maps\_rusher::rush();
}


center_camera_over_ai( guy )
{
	cam = GetEnt("rts_extracam", "targetname");
	
	h = cam.origin[2] - guy.origin[2]; //-- this is how much height we have to make up
	
	towards_cam = AnglesToForward( (180,0,0) + cam.angles ); //-- vector towards the camera
	
	scalar = h / towards_cam[2]; //-- how far we need to scale the vec to reach the camera height
	
	new_cam_position = guy.origin + ( towards_cam * scalar );
	
	level.force_cam_pos = (new_cam_position[0], new_cam_position[1], cam.origin[2]);
}


comms_damage_monitor()
{
	health = 750;
	
	while(1)
	{
		self waittill("damage", dam, who);
		
		health -= dam;
		
		oneshot_destroyed_comms_spark("garage_sparks", "wire_sparks");
		
		if(health <= 0)
		{
			level thread destroyed_comms_fx();
			level notify("comms_destroyed");
			break;		
		}
	}
}

oneshot_destroyed_comms_spark(fx1, fx2)
{
	structs = getstructarray("spark_struct", "targetname");

	fx = level._effect[fx1];
	
	if(cointoss())
	{
		fx = level._effect[fx2];
	}

	i = RandomInt(structs.size);
	
	PlayFX(fx, structs[i].origin, structs[i].angles);
}

destroyed_comms_sparks(fx1, fx2)
{
	level endon("garage_fps_done");
	
	while(1)
	{
		fx = level._effect[fx1];
		
		if(cointoss())
		{
			fx = level._effect[fx2];
		}
		
		PlayFX(fx, self.origin, self.angles);
		
		wait(RandomFloatRange(0.5,3.0));
	}	
}


destroyed_comms_fx()
{
	
	spark_structs = getstructarray("spark_struct", "targetname");
	
	smoke_structs = getstructarray("smoke_struct", "targetname");
	
	array_thread(spark_structs, ::destroyed_comms_sparks, "garage_sparks", "wire_sparks");
	array_thread(smoke_structs, ::destroyed_comms_sparks, "garage_big_spark1", "garage_big_spark2");
}


setup_first_jeep_ai()
{
	ambushers_and_spawners = GetEntArray("safehouse_fps_ambush_soldiers", "script_noteworthy");	
	ambushers = [];
	
	soldier = 1;
	
	for(i = 0; i < ambushers_and_spawners.size; i ++)
	{
		if(IsAI(ambushers_and_spawners[i]))
		{
			ambushers_and_spawners[i].animname = "soldier" + soldier;
			ambushers_and_spawners[i].ignoreall = true;
			ambushers[ambushers.size] = ambushers_and_spawners[i];
			
			soldier ++;
		}
	}
	
	breacher1 = getai_by_noteworthy("safehouse_guard1");
	breacher2 = getai_by_noteworthy("safehouse_guard2");
	
	breacher1 thread prep_window_breach1();
	breacher2 thread prep_window_breach2();
	
	// Get the ambushed soldiers to their start positions, then signal that we're ready to start the main scene.
	
	align_node = getstruct("anim_rsobuilding1", "targetname");
	
	array_wait(ambushers, "jumpedout");
	
	align_node anim_reach_aligned(ambushers, "safehouse_fps_intro");
	
	level notify("ambushers_ready_to_be_ambushed", ambushers);
}


prep_window_breach1()
{
	self endon("death");
	
	self waittill("jumpedout");
	
	self.ignoreall = true;
	self.goalradius = 16;
	
	node1 = getnode("node_outside_right", "targetname");
	
	self thread force_goal();
	self setgoalnode(node1);
	self waittill("goal");
	wait(0.1);
	self.goalradius = 16;
	
	flag_wait("safehouse_door");
	
	wait(2.0);
	
	self.ignoreall = false;
	
	node2 = getnode("node_inside_right", "targetname");
	
	//self thread force_goal();
	//self setgoalnode(node2);
	
	self thread maps\_rusher::rush();
}


prep_window_breach2()
{
	self endon("death");
	
	self waittill("jumpedout");
	
	self.ignoreall = true;
	self.goalradius = 16;
	
	node1 = getnode("node_outside_left", "targetname");
	
	self thread force_goal();
	self setgoalnode(node1);
	self waittill("goal");
	wait(0.1);
	self.goalradius = 16;
	
	flag_wait("safehouse_door");
	
	wait(3.0);
	
	self.ignoreall = false;
	
	node2 = getnode("node_inside_left", "targetname");
	
	self thread force_goal();
	self setgoalnode(node2);
}


do_door_breach_guys()
{
	door = GetEnt("safe_side", "targetname");
	
	breacher1 = getai_by_noteworthy("left_breacher");
	breacher2 = getai_by_noteworthy("right_breacher");
	breacher3 = getai_by_noteworthy("flashbang_guy");
	breacher4 = getai_by_noteworthy("rusher_in_waiting");
	
	breacher1.animname = "generic";
		
	breachers = array(breacher1, breacher2, breacher3, breacher4);
	
	array_wait(breachers, "jumpedout");
	
	for(i = 0; i < breachers.size; i ++)
	{
		if (isAlive(breachers[i]))
		{
			breachers[i] thread force_goal();
			breachers[i].ignoreall = true;
			breachers[i] setcandamage(false);
			breachers[i] enable_cqbwalk();
			breachers[i].sprint = true;
		}
	}
	
	node = getnode("node_door_kick", "targetname");
	
	if (isAlive(breacher2))
	{
		breacher2 thread ready_door_breach2();
	}
	if (isAlive(breacher3))
	{
		breacher3 thread ready_door_breach3();
	}
	if (isAlive(breacher4))
	{
		breacher4 thread ready_door_breach4();
	}
	
	if (isAlive(breacher1))
	{
		breacher1.goalradius = 16;
		breacher1 setgoalnode(node);
		breacher1 waittill("goal");
		
		wait(0.1);
		
		if (isAlive(breacher1))
		{
			breacher1.goalradius = 16;
			breacher1 OrientMode("face point", door.origin );
		}
	}
	
	level notify("safehouse_breach_ai_in_position");
	
	flag_wait("weaver_pistol");
	
	if (isAlive(breacher1))
	{
		breacher1 thread anim_single(breacher1, "door_kick");
	}
	
	wait(0.8);
	
	level notify("door_kick");
	
	door rotateyaw(-120, 0.3);
	
	for(i = 0; i < breachers.size; i ++)
	{
		if (isAlive(breachers[i]))
		{
			breachers[i].ignoreall = false;
			breachers[i] setcandamage(true);
		}
	}
	
	clip = getent("clip_flashbang_door", "targetname");
	clip connectpaths();
	clip trigger_off();
	
	wait(0.1);
	
	flag_set("safehouse_door");
	
	node2 = getnode("post_breach_center", "targetname");
	
	if (isAlive(breacher1))
	{
		breacher1 thread force_goal();
		breacher1 setgoalnode(node2);
	}
	
	exploder(604);

	wait(4.5);

	exploder(610);
	
	door rotateyaw(120, 0.3);
	
	door waittill("rotatedone");
	
	clip trigger_on();
	clip disconnectpaths();
		
	stop_exploder(604);
}


ready_door_breach2()
{
	self endon("death");
	
	node = getnode("right_breach_node", "targetname");
	
	self thread force_goal();
	self.goalradius = 16;
	self setgoalnode(node);
	self waittill("goal");
	wait(0.1);
	self.goalradius = 16;
	
	flag_wait("safehouse_door");
	
	node2 = getnode("post_breach_right", "targetname");
	
	wait(1.5);
	
	self thread force_goal();
	self setgoalnode(node2);
	
	wait(4.0);
	
	self thread close_on_player();
}


ready_door_breach3()
{
	self endon("death");
	
	node = getnode("left_breach_node", "targetname");
	
	self thread force_goal();
	self.goalradius = 16;
	self setgoalnode(node);
	self waittill("goal");
	wait(0.1);
	self.goalradius = 16;
	
	flag_wait("safehouse_door");
	
	node2 = getnode("post_breach_left", "targetname");
	
	wait(2.5);
	
	self thread force_goal();
	self setgoalnode(node2);
	
	wait(3.0);
	
	self thread maps\_rusher::rush();
}


ready_door_breach4()
{
	self endon("death");
	
	node = getnode("rusher_node", "targetname");
	
	self thread force_goal();
	self.goalradius = 16;
	self setgoalnode(node);
	self waittill("goal");
	wait(0.1);
	self.goalradius = 16;
	
	flag_wait("safehouse_door");
	
	node2 = getnode("flashbang_throw_destination", "targetname");
	
	self thread force_goal();
	self setgoalnode(node2);
	
	wait(5.0);
	
	self thread maps\_rusher::rush();
}


do_flashbang_guy_v2()
{
	flag_wait("weaver_pistol");
	
	//level waittill("safehouse_breach_ai_in_position");
	
	align_node = getstruct("grenade_align", "script_noteworthy");
	
	grenade_start = getstruct("flash_grenade_start", "targetname");
	grenade_end = getstruct("flash_grenade_end", "targetname");
	
	//level.fps_heroes["weaver"].flashbangImmunity = true;
	level.fps_heroes["weaver"] MagicGrenadeType("flash_grenade_sp", grenade_start.origin, VectorNormalize(grenade_end.origin - grenade_start.origin) * 550, 1.5);
	
	level notify("flash_grenade_thrown");
	
	RadiusDamage(grenade_start.origin, 50, 150, 150);
		
	wait(0.05);
	
	RadiusDamage(grenade_start.origin, 50, 150, 150);
	
	wait(1.45);
	
	level.fps_heroes["weaver"].animname = "weaver";
	level.fps_heroes["weaver"] anim_single(level.fps_heroes["weaver"], "flashbang_grenade");	//Flashbang!
	
	PhysicsExplosionSphere(grenade_end.origin, 220, 220, 0.6);
	
	wait(0.5);
	
	dmg_pos = getstruct("pos_breach_damage", "targetname");
	RadiusDamage(dmg_pos.origin, 50, 300, 300);
	
	level thread shoot_out_rest_of_windows();
	level notify("post_flashbang_rush_player");
}


shoot_out_weaver_window()
{
	start_ent = GetEnt( "safehouse_break_window_after_weaver", "targetname" );
	end_ent = GetEnt( start_ent.target, "targetname" );
		
	while(IsDefined(end_ent.target))
	{
		MagicBullet("famas_sp", start_ent.origin, end_ent.origin);
		wait(0.05);
		end_ent = GetEnt( end_ent.target, "targetname" );
	}
}


shoot_out_flashbang_window( origin_targetname )
{
	if(!IsDefined(origin_targetname))
	{
		origin_targetname = "safehouse_break_window";
	}
	
	start_ent = GetEnt( origin_targetname, "targetname" );
	end_ent = GetEnt( start_ent.target, "targetname" );
	
	for( i=0; i<5; i++)
	{
		MagicBullet("famas_sp", start_ent.origin, end_ent.origin);
		wait(0.05);
	}
}


shoot_out_rest_of_windows()
{
	level thread shoot_out_flashbang_window( "safehouse_break_window_1" );
	level thread shoot_out_flashbang_window( "safehouse_break_window_2" );
}


setup_second_jeep_ai()
{
	level thread do_flashbang_guy_v2();
	level thread do_door_breach_guys();
}


debug_goodness()
{
	level endon("outside_joins_in");	
	self endon("death");
	
	while(1)
	{
		PrintLn("PP " + get_players()[0].origin[2]);
		PrintLn("TP " + self GetTagOrigin("tag_player")[2]);
		PrintLn("TC " + self GetTagOrigin("tag_camera")[2]);
		PrintLn("TO " + self GetTagOrigin("tag_origin")[2]);
		PrintLn("TV " + self GetTagOrigin("tag_view")[2]);

		PrintLn("---");
		wait(0.5);
	}
}

#using_animtree( "wmd_sr71" );
setup_door_for_animation(door)
{
	door UseAnimTree(#animtree);
	door.animname = "door";
}


#using_animtree("generic_human");
player_and_weaver_safehouse_fps_scene()
{
	align_node = getstruct("anim_rsobuilding1", "targetname");
	
	player = get_players()[0];
	player SetStance("crouch");

	wait(.6);

	scene_ai = [];
	// Get the player and weaver set up in their initial loops
	
	level.fps_heroes["weaver"] custom_ai_weapon_loadout("aug_arctic_acog_silencer_sp", undefined, "m1911_silencer_sp");
	level.fps_heroes["weaver"] gun_remove();

	// Spawn the player body
	player_body = spawn_anim_model( "fps_player_body" , player.origin, player.angles);
	player_body UseAnimTree(level.scr_animtree["fps_player_body"] );
	player_body.animname = "fps_player_body";
	
	player_body Attach("t5_weapon_aug_viewmodel_arctic", "tag_weapon", true);
	
	scene_ai = array_add(scene_ai, player_body);
	scene_ai = array_add(scene_ai, level.fps_heroes["weaver"]);
	
	align_node thread anim_loop_aligned(scene_ai, "safehouse_fps_setup");
	
	wait (0.05);

	player SetLowReady(true);
	player DisableOffhandWeapons();
	player StartCameraTween(1);
	player PlayerLinkToAbsolute(player_body, "tag_player");
	
	wait(0.05);
	
	player PlayerLinkToDelta(player_body, "tag_player", 1, 15, 10, 45, 15);
	
	level waittill("ambushers_ready_to_be_ambushed", scene_enemies);

	for(i = 0; i < scene_enemies.size; i ++)
	{
		if(scene_enemies[i].animname == "soldier1")
		{
			scene_enemies[i] thread do_bloody_death();
		}
		
		if(scene_enemies[i].animname == "soldier2")
		{
			scene_enemies[i] thread alert_outside_guys_on_death();
		}
	}

	operator = get_operator_ent();
	level.vo_playing = true;
	operator thread anim_single(operator, "infantry_take_out");
	level.vo_playing = false;
	
	// Add player & Weaver into scene_ai array.
	scene_ai = array_combine(scene_ai, scene_enemies);
	door = GetEnt("safe_front", "targetname");
	setup_door_for_animation(door);
	
	scene_ai = array_add(scene_ai, door);
	
	addNotetrack_customFunction( "fps_player_body", "enable_player", ::return_control_to_player, "safehouse_fps_intro" );	
	
	//TUEY Set music state to SAFEHOUSE
	level thread maps\_audio::switch_music_wait("SAFEHOUSE_FIGHT", 13.5);
	
	addNotetrack_customFunction( "weaver", "show_knife", ::weaver_show_knife, "safehouse_fps_intro" );	
	addNotetrack_customFunction( "weaver", "show_pistol", ::weaver_show_pistol, "safehouse_fps_intro" );	
	addNotetrack_customFunction( "weaver", "show_aug", ::weaver_show_aug, "safehouse_fps_intro" );	
	
	level.fps_heroes["weaver"] AllowedStances("crouch");
	level.fps_heroes["weaver"].ignoreme = true;
	level.fps_heroes["weaver"].ignoreall = true;
	
	level.fps_heroes["brooks"].ignoreme = true;
	level.fps_heroes["brooks"].ignoreall = true;
	
	level.fps_heroes["harris"].ignoreme = true;
	level.fps_heroes["harris"].ignoreall = true;
	
	level.fps_heroes["weaver"] thread weaver_take_cover();
	
	align_node thread anim_single_aligned(scene_ai, "safehouse_fps_intro");
	
	level.streamhintsafehouse delete();
	
	wait(6.5);
	
	level notify("outside_joins_in");
	
	wait(1.5);
	
	level thread create_streamer_ent();
	
	level waittill("flash_grenade_thrown");
	
	battlechatter_on();
	
	level.fps_heroes["weaver"] AllowedStances("prone", "crouch", "stand");
	level.fps_heroes["weaver"].ignoreme = false;
	level.fps_heroes["weaver"].ignoreall = false;
	
	level.fps_heroes["brooks"].ignoreme = false;
	level.fps_heroes["brooks"].ignoreall = false;
	
	level.fps_heroes["harris"].ignoreme = false;
	level.fps_heroes["harris"].ignoreall = false;
	
	level.fps_heroes["brooks"] enable_cqbwalk();
	level.fps_heroes["harris"] enable_cqbwalk();
	
	wait(6.0);
	
	level.fps_heroes["brooks"] thread get_to_node("node_brooks_safehouse");
	
	wait(3.5);
	
	level.fps_heroes["harris"] thread get_to_node("node_harris_safehouse");
}


weaver_take_cover()
{
	animtime = GetAnimLength(level.scr_anim["weaver"]["safehouse_fps_intro"]);
	
	wait(animtime + 1);
	
	node = getnode("node_weaver_safehouse", "targetname");
	
	self thread force_goal();
	
	self setgoalnode(node);
}


do_bloody_death()
{
	flag_wait("weaver_pistol");
	
	wait(0.2);
	
	if (isAlive(self))
	{
		if( is_mature() )
		{
			self extreme_bloody_death(true, 0);
		}
	}
}


bloody_knife_kill()
{
	wait(0.6);
	
	if( is_mature() )
	{
		playfxontag(level._effect["knife_death"], self, "tag_weapon_right");
	}
}


alert_outside_guys_on_death()
{
	self waittill_either("death", "pain_death");
	
	//level notify("outside_joins_in");
	
	wait(1.5);
	
	level thread shoot_out_weaver_window();
}


weaver_show_knife(node)
{
	level.fps_heroes["weaver"] Attach( "t5_knife_animate", "tag_weapon_right" );
	level.fps_heroes["weaver"] thread bloody_knife_kill();
	
	flag_set("weaver_knife");
}


weaver_show_pistol(node)
{
	level.fps_heroes["weaver"] Detach( "t5_knife_animate", "tag_weapon_right" );
	level.fps_heroes["weaver"] gun_switchto( "m1911_silencer_sp", "right" );
	
	flag_set("weaver_pistol");
}


weaver_show_aug(node)
{
	// level.fps_heroes["weaver"] gun_switchto( "aug_arctic_acog_silencer_sp", "right" );
	level.fps_heroes["weaver"] gun_switchto( "ak12_zm", "right" );
}


debug_star_pos(guy)
{
	pos1 = guy GetTagOrigin("tag_player");
	pos2 = guy GetTagOrigin("tag_camera");
	while(1)
	{
		debugstar(pos1, 1000, (0,1,0) );
		debugstar(pos2, 1000, (0,0,1) );
		wait 1;
	}
	
}


return_control_to_player(guy)
{
	player = get_players()[0];

	//level thread debug_star_pos(guy);
	player Unlink();
	player SetOrigin(guy GetTagOrigin("tag_player"));
	//player ShowViewModel();
	//player EnableWeapons();
	player SetLowReady(false);
	guy Delete();
	
	player EnableOffhandWeapons();
}


do_glass_traverses()
{
	level endon("safehouse_fps_done");
	
	traverses = GetNodeArray("glass_mantle", "script_noteworthy");
	
	for(i = 0; i < traverses.size; i ++)
	{
		SetEnableNode(traverses[i], false);
		traverses[i]._enabled = false;
	}
	
	while(1)
	{
		level waittill("glass_smash", pos, vec);
		
		for(i = 0; i < traverses.size; i ++)
		{
			if(!traverses[i]._enabled)
			{
				if(DistanceSquared(traverses[i].origin, pos) < (72 * 72))
				{
					SetEnableNode(traverses[i], true);
					traverses[i]._enabled = true;
					//IPrintLnBold("Enabled!");
				}
			}
		}
	}
}


give_player_max_ammo()
{
	player = get_players()[0];
	weapList =  player GetWeaponsListPrimaries();
	for (i=0; i < weapList.size; i++)
	{
		clip_size = WeaponClipSize(weapList[i]);
		player SetWeaponAmmoClip(weapList[i], clip_size);		
		player GiveMaxAmmo(weapList[i]);
	}	
}


passing_by_house_VO()
{
	level endon("squad_detected");
	
	jeep = GetEnt("convoy_veh_1", "targetname");
	while(!IsDefined(jeep))
	{
		jeep = GetEnt("convoy_veh_1", "targetname");
		wait(0.1);
	}
	
	jeep waittill("passing_in_front");
	
	operator = get_operator_ent();
	level.vo_playing = true;
	operator anim_single( operator, "365A_usc2_f");//They're passing by the house.
	level.vo_playing = false;
	
	wait(2.0);
	
	level.vo_playing = true;
	operator anim_single(operator, "366A_usc2_f");// "Wait, no. Enemy has stopped in front of the house.";
	level.vo_playing = false;
}


safehouse_fps()
{
	level thread passing_by_house_VO();
	
	level endon("end_rts");
	
	pos_streamer = getstruct("safehouse_streamer_hint", "targetname");
	level.streamhintsafehouse = createStreamerHint(pos_streamer.origin, 1);
	
	level waittill("squad_hidden");

	jeep = GetEnt("convoy_veh_1", "targetname");
	jeep waittill("start_safehouse_fps");
	
	SetSavedDvar( "aim_view_sensitivity_override", -1.0 );
	
	player = get_players()[0];
	
 	clearup_safehouse_rts_guys();
	
	level thread do_glass_traverses();
	
//	level notify("garage_fps");
//	level waittill("eternity");
	player playsound( "evt_rso_zoomdown_front" );//kevin adding sound call for custom cinematic
	
	level thread rumble_on_down();
	
	level thread hud_utility_show( "cinematic", 0.25 );
	
	Start3DCinematic( "dropfirstperson_v2", false, true );
	
	wait(0.25);
	
	player_on_ground("safehouse");
	
	//TUEY Set music state to SAFEHOUSE
	setmusicstate("SAFEHOUSE");
	
	wait(0.05);
	
	level.fps_heroes["harris"].ignoreall = true;
	level.fps_heroes["brooks"].ignoreall = true;
	
	level thread player_and_weaver_safehouse_fps_scene();
	level notify("set_first_fps_dof");
	
	wait 1.25;
	
	autosave_by_name("wmd_rts_fps_safehouse");
	
	hud_utility_hide("cinematic", 0.25);
	Stop3DCinematic(); 	
	
	wait(0.25);
	
	vehs = spawn_vehicles_from_targetname("safehouse_fps_veh_1");
	array_thread(vehs, ::setup_safehouse_fps_convoy_vehicle);
	//level thread unload_trigger("leavingroad");
	//array_thread(vehs, ::unload_trigger);
	
	ambient_jeeps = spawn_vehicles_from_targetname("fps_ambient_convoy");
	array_thread(ambient_jeeps, ::setup_safehouse_fps_convoy_vehicle);

	vehs[0] waittill("reached_end_node");
	
	vehs[0] thread cb_audio_chatter();//kevin adding ambient cb chatter after the first jeep stops
	
	level thread setup_first_jeep_ai();
	
	level waittill("outside_joins_in"); //-- this happens after the 2nd guy has been shot

	vehs2 = spawn_vehicles_from_targetname("safehouse_fps_veh_2");
	array_thread(vehs2, ::setup_safehouse_fps_convoy_vehicle);
	
	vehs2[0] waittill("reached_end_node");
	vehs2[0] thread cb_audio_chatter();//kevin adding ambient cb chatter after the first jeep stops
	
	level thread setup_second_jeep_ai();

	//level.fps_heroes["harris"].ignoreall = false;
	//level.fps_heroes["brooks"].ignoreall = false;
	//wait(1.0);
	
	waittill_ai_group_ai_count("veh1_fps_guys", 0);
	waittill_ai_group_ai_count("veh2_fps_guys", 0);
	
	//TEMP
	//level waittill("test");
	
	wait(1.5);
	
	operator = get_operator_ent();	
	level.vo_playing = true;
	operator anim_single( operator, "objective_complete");
	level.vo_playing = false;
	
	wait(1.0);
	
	give_player_max_ammo();
	
	get_players()[0] EnableInvulnerability();

	player playsound( "evt_rso_zoomup_front" );//kevin adding sound call for custom cinematic
	level thread hud_utility_show( "cinematic", 0.25 );
	Start3DCinematic( "reversefirstperson_v1", false, true );
	
	level thread rumble_on_down();
	
	wait(0.25);

	vehs = array_combine(vehs, vehs2);

	for(i = 0; i < vehs.size; i++)
	{
		vehs[i] Delete();
	}
	
	group = get_ai_group_ai( "veh1_fps_guys" );
	array_delete ( group );	

	group = get_ai_group_ai( "veh2_fps_guys" );
	array_delete ( group );	
	
	//-- warp the AIs back inside the house, in case they posted up outside during the fps section
	nodes = GetNodeArray("post_safehouse_warp_nodes", "targetname");
	for(i = 0; i < level.rts_heroes.size; i ++)
	{
		level.rts_heroes[i] ForceTeleport( nodes[i].origin, nodes[i].angles);
		//level.rts_heroes[i] SetGoalPos(nodes[i].origin);
	}
	
	//trigger_use("safehouse_select", "script_noteworthy");
		
	center_camera_over_ai( level.rts_heroes[0] );
	
	player_in_cockpit();
	
	flag_set("ambient_vehicle_patrols");
		
	wait 1.25;

	corpse_structs = getstructarray("post_safehouse_corpse", "targetname");
	array_thread(corpse_structs, ::fake_corpses);
	
	hud_utility_hide("cinematic", 0.25);
	Stop3DCinematic(); 		
	
	flag_set("safehouse_fps_done");
	battlechatter_off();
	//TUEY Set music state to BACK_IN_PLANE
	setmusicstate("BACK_IN_PLANE");
	
	set_exclusive_area("sr71_road_is_hot");
	
	autosave_by_name("wmd_rts_fps_safehouse_done");
	
	wait(1.0);
	
	level.vo_playing = true;
	operator anim_single(operator, "road_is_hot");
	level.vo_playing = false;
	
	delete_streamer_ent();
	
	//-- delete the script brushmodel that blocks the back half of the level
	brush_blocker = GetEntarray("temporary_camera_blocker", "script_noteworthy");
	for(i=0; i<brush_blocker.size; i++)
	{
		brush_blocker[i] Delete();
	}
}

cb_audio_chatter()
{
	self playsound( "vox_cb1" , "sound_done" );
	self waittill( "sound_done" );
	self playsound( "vox_cb2" , "sound_done" );
	self waittill( "sound_done" );
	self playsound( "vox_cb3" , "sound_done" );
	self waittill( "sound_done" );
	self playsound( "vox_cb4" , "sound_done" );
	self waittill( "sound_done" );
	self playsound( "vox_cb5" , "sound_done" );
	self waittill( "sound_done" );
}

fake_corpses()
{
	corpse = Spawn("script_model", self.origin);
	corpse.angles = self.angles;
	if(cointoss())
	{
		corpse character\c_rus_spetznaz_winter_1::main();
	}
	else
	{
		corpse character\c_rus_spetznaz_winter_2::main();
	}
	
	corpse UseAnimTree( #animtree );
	corpse.animname = "generic";
	corpse makeFakeAI();			// allow it to be animated
	corpse setcandamage( false );		
	
	corpse_mover = Spawn("script_origin", corpse.origin);
	
	corpse LinkTo(corpse_mover);
	
	endPos = self.origin + (0,0,-48);
	
	death_anim = "first_death";
	
	if(cointoss())
	{
		death_anim = "second_death";
	}
	
	corpse_mover thread anim_loop(corpse, death_anim + "_loop");
	
	corpse_mover moveto(endPos, RandomFloatRange(12,16));
	
	corpse_mover waittill("movedone");	

	corpse Delete();
	corpse_mover Delete();		
}

generate_patrollers(id)
{
	num = 1;
	
	if(IsDefined(self.script_delay))
	{
		wait(self.script_delay);
	}
	
	if(id % 2)
	{
		num++;
	}

	if(IsDefined(self.script_int))
	{
		num = self.script_int;
	}
	
	min_delay = 2.25;
	
	if(IsDefined(self.script_delay_min))
	{
		min_delay = self.script_delay_min;
	}
	
	max_delay = 4.5;
	
	if(IsDefined(self.script_delay_max))
	{
		max_delay = self.script_delay_max;
	}
	
	//playback_rate = RandomFloatRange(0.6, 0.8);
	
	for(i = 0; i < num; i ++)
	{
		simple_spawn(self.targetname, ::setup_patrol_member, 0.8);
		self.count ++;
		//wait(RandomFloatRange(min_delay, max_delay));
		wait(min_delay);
	}
}


setup_first_patrol()
{
	level endon("end_rts");
	
	trigger_wait("spawn_patrol", "targetname");
	
	flag_set("patrol_prone");
	
	if(flag("garage_fps_done"))
	{
		return;
	}
	
	array_thread( level.rts_heroes, ::set_ignoreme, true );
	
	// Allow AI to path around LHS of safe house.
	
	level.safehouse_pathbreaker ConnectPaths();
	level.safehouse_pathbreaker Delete();
	
	level thread spawn_patrol_guys();
	
	operator = get_operator_ent();
	pilot = get_pilot_ent();

	level.vo_playing = true;
	pilot anim_single(pilot, "pilot_patrol_inbound");
	level.vo_playing = false;
	
	wait(0.2);

	flag_set("patrol_active");

	flag_set("wait_for_prone_command");
	
	level._confirm_prone_order = false;

	if(!flag("squad_prone"))
	{
		screen_message_create(&"WMD_SR71_PRONE_AVOID");
	}
	
	level.vo_playing = true;
	operator anim_single(operator, "patrol_inbound");
	level.vo_playing = false;
	
	flag_wait("squad_prone");
	
	flag_set("go_barracks");
	
	screen_message_delete();
	
	//TUEY change music state to GO_PRONE
	setmusicstate("GO_PRONE");
	
	//Play music stinger on top of Canyon track
//	playsoundatposition ("mus_stings05_get_down", (0,0,0));
}


spawn_patrol_guys()
{
	for(i = 1; i < 7; i ++)
	{
		spawner = GetEnt("patrol_1_wave_1_"+i, "targetname");
		spawner thread generate_patrollers(i);
		wait(0.3);
	}	
}


second_patrol_inc_vo()
{
	flag_set("rts_done");
	
	level.vo_playing = true;
	self anim_single(self, "second_patrol_inc");		//Kilo One we have Infantry inbound - I count at least six targets. Too hot.
	level.vo_playing = false;

	objective_state(7,"done");
	objective_delete(7);

	get_players()[0] SetClientDvar( "cg_defaultFadeScreenColor", "1 1 1 0" );
	
	level.vo_playing = true;
	self anim_single(self, "second_patrol_inc2");	//Stop and drop.  Stay out of sight.
	level.vo_playing = false;
}


setup_second_patrol()
{
	level endon("end_rts");

	trigger_wait("spawn_second_patrol", "targetname");
	
	operator = get_operator_ent();
	
	operator thread second_patrol_inc_vo();
	
	for(i = 1; i < 6; i ++)
	{
		spawner = GetEnt("patrol_2_wave_1_" + i, "targetname");
		spawner thread generate_patrollers(i);
	}
	
	level.custom_prone_acknowledge = "avoiding_second_patrol";
	
	flag_clear("squad_prone");
	flag_set("wait_for_prone_command");

	flag_wait("squad_prone");
	
	level notify("no_detect");
	
	//TUEY Set music to "Canyon" (SR71_RTS)
	setmusicstate("SR71_RTS_SECOND_STATE");
	
	wait(2.0);
	
	flag_set("second_patrol_evaded");
}


setup_convoy()
{
	level endon("end_rts");
	level thread safehouse_fps();
	
	set_exclusive_area("go_east_select", "script_noteworthy");
	
	trigger_wait("spawn_convoy","targetname");
	
	level thread check_safe_house();
	
	player = get_players()[0];
	pilot = get_pilot_ent();
	operator = get_operator_ent();
	
	level.vo_playing = true;
	pilot anim_single( pilot, "127A_usc1_f"); //	Tac Recon I see enemy vehicles inbound. Get the squad off the road.
	level.vo_playing = false;
	
	wait(0.25);
	
	level.vo_playing = true;
	pilot thread anim_single( pilot, "358A_usc1_f");//Looks like there's a structure to the north. Get them inside, C.P.
	level.vo_playing = false;
	
	clear_exclusive_area();
	
	level thread create_offroad_waypoint(getstruct("squad_offroad","targetname"));
	set_exclusive_area("safehouse_select", "script_noteworthy");
	
	wait(3);

	vehicles = getentarray("convoy_vehicles","script_noteworthy");
	
	for(i=0;i<vehicles.size;i++)
	{
		vehicles[i] thread setup_convoy_vehicle(i);
		vehicles[i] thread vehicle_detects_squad();
	}
	
	flag_wait("safehouse_fps_done");
	
	//losest guy turn on the flashlight
	wait(2);	

	level thread create_hillside_waypoint();
	level thread squad_escapes_to_hillside();
	
	flag_wait("squad_on_hilltop");
	
	safehouse_block = getent("safehouse_blocker", "targetname");
	safehouse_block movez(-128, 0.05);
	safehouse_block waittill("movedone");
	safehouse_block disconnectpaths();

	clear_exclusive_area();

	flag_clear("ambient_vehicle_patrols");
	
	level.vo_playing = true;
	operator anim_single(operator, "road_is_clear");
	level.vo_playing = false;
	
	barracks_struct = getstruct("barracks_objective", "targetname");
	
	//level thread garage_fps();
	level thread create_barracks_waypoint(barracks_struct);
	
	flag_wait("garage_fps_done");
	
	set_exclusive_area("post_barracks_area", "script_noteworthy");
}


check_safe_house()
{
	level endon("squad_detected");
	
	safehouse_trig = getent("safehouse_select", "script_noteworthy");
	
	while(1)
	{
		for(i=0; i<level.rts_heroes.size; i++)
		{
			if (level.rts_heroes[i] isTouching(safehouse_trig))
			{
				flag_set("squad_safehouse");
				break;
			}
		}
		
		wait(0.05);
	}
}


detect_jeep_deaths(veh)
{
	veh endon("goal");
	
	while(!flag("jeep_guys_dead"))
	{
		wait(.05);
	}
	
	//iprintlnbold("THE SQUAD WAS DETECTED!");
	wait(2);
	missionfailed();
	
}

kill_rts_squad(no_gore, custom_death_quote)
{
	flag_set("squad_detected");
	
	if(!IsDefined(level._killing_squad))
	{
		level._killing_squad = 1;

		if(!IsDefined(no_gore))
		{
			player = get_players()[0];
			
			if(randomint(100) > 50)
			{
				player playsound("evt_rso_engagement_1");
			}
			else
			{ 
				player playsound("evt_rso_engagement_2");
			}
	
			for(i = 0; i < level.rts_heroes.size; i ++)
			{
				level.rts_heroes[i] stop_magic_bullet_shield();
				level.rts_heroes[i] thread bloody_death(true, RandomFloatRange(0.1, 1.0));
			}
		}
		else
		{
			array_thread(level.rts_heroes, ::stop_magic_bullet_shield);
		}
		wait(1);
		
		operator = get_operator_ent();
		
		level.vo_playing = true;
		operator anim_single(operator, "death" + RandomIntRange(1, 3));
		level.vo_playing = false;
		
		wait(1);
		
		if(IsDefined(custom_death_quote))
		{
			maps\_utility::missionfailedwrapper(custom_death_quote);
			//SetDvar( "ui_deadquote", custom_death_quote); 
		}
		
		//missionfailedwrapper();	
	}
}


patroler_kills_squad()
{
	self notify("end_patrol");
	self notify("stop_going_to_node");
	
	master = false;
	if(!IsDefined(level._master_patroller))
	{
		level._master_patroller = true;
		master = true;
	}
	self patroller_stop_looking();
	self.goalradius = 16;
	self SetGoalPos(self.origin);
	self waittill("goal");
	
	wait(RandomFloatRange(0.1,0.4));
	
	target = level.rts_heroes[RandomInt(level.rts_heroes.size)];
	
	if(IsDefined(target))
	{
		self.ignoreall = false;
		self thread shoot_at_target(target);
	}
	
	if(master)
	{
		wait(0.15);
		level thread kill_rts_squad(undefined, &"WMD_SR71_KILLED_BY_PATROLLER");		
	}
}

patroller_detects_squad()
{
	level endon("end_rts");
	level endon("squad_detected");
	//level endon("first_patrol_clear");
	level endon("garage_fps");
	self endon("death");
	self endon("squad_detected_so_you_dont_have_to");
	
	detected = false;
	
	detect_dist_squared = 384 * 384;
	
	while(!detected)
	{
		for(i = 0; i < level.rts_heroes.size; i ++)
		{
			if(!flag("squad_prone"))
			{
				guy = level.rts_heroes[i];
				if(IsAlive(guy) && guy.a.pose != "prone")
				{
					if(DistanceSquared(self.origin, guy.origin) < detect_dist_squared)
					{
						if(  SightTracePassed(self gettagorigin( "tag_eye" ) , guy gettagorigin( "tag_eye" ) , false, undefined ))
						{				
							detected = true;
						}
					}
				}
			}
		}
		wait(0.05);
	}

	// TODO : Find nearest patrollers, and 'tell them' we're gonna do some killing.
	// notify them 'squad_detected_so_you_dont_have_to'

	//IPrintLnBold("patroller detected player!");

	//-- turn off ignoreme that was used during the patrol
	array_thread( level.rts_heroes, ::set_ignoreme, false );
		
	patrollers = GetEntArray("patroller", "script_noteworthy");
	closest_patrollers = get_array_of_closest(level.rts_heroes[0].origin, patrollers);
	
	num = closest_patrollers.size;

	if(num > 5)
	{
		num = 5;
	}
	
	nearest = [];
	
	for(i = 0; i < num; i ++)
	{
		nearest[nearest.size] = closest_patrollers[i];
	}
	
	array_thread(nearest, ::patroler_kills_squad);
	array_notify(patrollers, "squad_detected_so_you_dont_have_to");
}

vehicle_detects_squad()
{
	level endon("end_rts");
	level endon("squad_hidden");
	level endon("squad_detected");
	self endon("death");
	
	player = get_players()[0];
	
	detected = false;
	no_gore = undefined;
	
	if (!flag("safehouse_fps_done"))
	{
		custom_death = &"WMD_SR71_EVADE_CONVOY";
	}
	else
	{
		custom_death = &"WMD_SR71_KILLED_BY_VEHICLE";
	}
	
	while(!flag("squad_hidden"))
	{
		if(IsDefined(level._player_on_ground) && level._player_on_ground)
		{
			return;
		}
		
		detected = false;
		for(i=0;i<level.rts_heroes.size;i++)
		{
			guy = level.rts_heroes[i];
			
			if(IsAlive(guy))
			{			
				ds = distancesquared(self.origin,guy.origin);
				
				if (!flag("safehouse_fps_done") && ds < (720*720))
				{
					if (!flag("squad_safehouse"))
					{
						detected = true;
					}
					else
					{
						detected = false;
					}
				}
				
				if( ds < (512*512))
				{
					if(!flag("squad_prone"))
					{
						detected = true;
					}
					else if(self IsTouching(guy))
					{
						detected = true;
						no_gore = true;
						custom_death = &"WMD_SR71_KILLED_BY_HIT_BY_VEHICLE";
						guy thread bloody_death_fx( "j_spine4", undefined );
						player playsound( "evt_rso_runover" );
					}
				}
			}
		}
		if(detected)
		{
			break;
		}
		
		wait(.05);
	}	
	
	if(detected)
	{
//		IPrintLnBold("Detected by vehicles.");
		level thread kill_rts_squad(no_gore, custom_death);
	}
}

squad_escapes_to_hillside()
{

	while(!flag("squad_on_bluff"))
	{
		safe = true;
		for(i=0;i<level.rts_heroes.size;i++)
		{
			if( !level.rts_heroes[i] istouching( getent("squad_escape_vol","targetname")))
			{
				safe = false;
			}
		}
		if(safe)
		{
			break;
		}
		wait(.1);
	}
	
	flag_set("squad_on_bluff");
	
}

setup_convoy_vehicle(i)
{
	
	//self setspeed( 15 );	
	self turn_jeep_lights_on();
	//self.desiredNode = getstruct(self.targetname,"targetname");
	//self setvehgoalpos( self.desiredNode.origin, 1, 1 );
	//self SetNearGoalNotifyDist( 500 );
	self thread go_path(GetVehicleNode(self.target, "targetname"));
	self.vehicleavoidance = 0;
	self thread veh_magic_bullet_shield(1);
	self.script_noteworthy = "ambient_vehicle";
	//self thread convoy_veh_stop();
}

setup_ambient_convoy_vehicle()
{
	
	self turn_jeep_lights_on();
	self thread go_path(GetVehicleNode(self.target, "targetname"));
	self.vehicleavoidance = 0;
	self thread veh_magic_bullet_shield(1);
	self.dont_target = 1;
	
	self thread vehicle_detects_squad();
}

ambient_vehicle_patrol_factory(min_vehicles, max_vehicles, min_delay, max_delay)
{

	flag_wait("ambient_vehicle_patrols");

	level endon("ambient_vehicle_patrols");
	
	while(flag("ambient_vehicle_patrols"))
	{
		if(IsDefined(level._player_on_ground) && level._player_on_ground)
		{
			return;
		}
				
		num = RandomIntRange(min_vehicles,max_vehicles);
		
		for(i = 0; i < num; i ++)
		{
			
			if(IsDefined(level._player_on_ground) && level._player_on_ground)
			{
				return;
			}
					
			ambient_jeeps = undefined;
			
			if(RandomInt(10) > 5)
			{
				ambient_jeeps = spawn_vehicles_from_targetname("ambient_patrol_jeep");
			}
			else
			{
				ambient_jeeps = spawn_vehicles_from_targetname("ambient_patrol_truck");
			}

			array_thread(ambient_jeeps, ::setup_ambient_convoy_vehicle);
			
			wait(RandomFloatRange(0.75, 2.15));
		}

		wait(RandomFloatRange(min_delay,max_delay));

		//ambient_veh_convoy_VO();
	}
}

ambient_veh_convoy_VO()
{
	
	if(IsDefined(level.is_in_rts) && level.is_in_rts)
	{
		triggers = GetEntArray("sr71_road_is_hot", "targetname");
		
		for(i = 0; i < triggers.size; i ++)
		{
			for(j = 0; j < level.rts_heroes.size; j++)
			{
				if(level.rts_heroes[j] IsTouching(triggers[i]))
				{	
					return;
				}
			}
		}
	}
	
	possible_lines = array("ambient_convoy_1","ambient_convoy_2","ambient_convoy_3");
	
	if(!IsDefined(level.last_ambient_vo_convoy))
	{
		level.last_ambient_vo_convoy = 0;
	}
	
	pilot = get_pilot_ent();
	pilot thread anim_single( pilot, possible_lines[level.last_ambient_vo_convoy] );
	
	level.last_ambient_vo_convoy++;
	if(level.last_ambient_vo_convoy >= possible_lines.size)
	{
		level.last_ambient_vo_convoy = 0;
	}
}

convoy_veh_stop()
{
	self waittill_either("near_goal","goal");
	if(!isDefined(level.convoy_warning))
	{
		level.convoy_warning = 1;
//		operator = get_operator_ent();
//		operator anim_single(operator, "366A_usc2_f");// "Wait, no. Enemy has stopped in front of the house.";
	}
	self setspeedimmediate( 0 );
}

#using_animtree("generic_human");

setup_jeep_walkers()
{
	trigger_wait("jeep_walkers_walk","script_noteworthy");
	walkers = getentarray("jeep_walkers","script_noteworthy");
	guys = [];
	for(i=0;i<walkers.size;i++)
	{
		if(isai(walkers[i]))
		{
			guys[guys.size] = walkers[i];
		}
	}

	//IPrintLnBold("Walkers Go!" + guys.size);

	guys[0] notify("end_patrol");
	guys[0] thread maps\_patrol::patrol("jeep_walkers_node1");

	guys[1] notify("end_patrol");
	guys[1] thread maps\_patrol::patrol("jeep_walkers_node2");

}

setup_rts_guy_model()
{
	self.ignoreall = true;
	self.old_model = self.model;	
	// if(isDefined(self.gearModel))
	// {		
	// 	self detach ( self.headModel,"");
	// }
	// if(isDefined(self.gearModel))
	// {
	// 	self detach ( self.gearModel,"");	
	// }
	// self setmodel("c_rus_spetznaz_snow_sr71_fb");
	self thread reset_body_on_death();
	level thread do_custom_muzzleflash(self);
	self thread blood_splatter_enhancement();
}


patroller_stop_looking()
{
	self notify("stop_looking_around");
	self.cqb_point_of_interest = undefined;
}


patroller_look_around()
{
	level endon("end_rts");
	self endon("death");
	self endon("stop_looking_around");
	level endon("squad_detected");
	
	while(1)
	{
		
		side_deflection = AnglesToRight(self.angles) * RandomFloatRange(-240, 240);
		
		up_deflection = AnglesToUp(self.angles) * RandomFloatRange(-240, 240);
	
		point = self.origin + (AnglesToForward(self.angles) * 120 * RandomFloatRange(1, 5)) + side_deflection + up_deflection;
		
		self.cqb_point_of_interest = point;
		
		wait(RandomFloatRange(1,3));
	}
	
}

setup_patrol_member(playback_rate)
{
	self setup_rts_guy_model();
	
	if(cointoss())
	{
		self.script_patrol_walk_anim = "cqb_patrol_1";
	}
	else
	{
		self.script_patrol_walk_anim = "cqb_patrol_2";
	}
	
	
	//self thread setup_patroller(undefined, undefined, 1);
	
	//self.patroller_delete_on_path_end = true;

	self.goalradius = 64;
	self.script_radius = 64;
	self.ignoreall = true;
	self.patrol_dont_claim_node = true;

	//self notify("stop_going_to_node");
 
	self thread maps\_patrol::patrol();
	self thread patroller_detects_squad();
	self thread patroller_look_around();
	
//	wait 0.1;

	//self.moveplaybackrate = playback_rate;
	
	self.dont_target = 1;
	
	self.script_noteworthy = "patroller";
	
	wait(0.05);
	self notify( "patrol_walk_twitch_loop" );
	
	self waittill("reached_path_end");
	self Delete();
}

precache_materials()
{
		//precache the shaders
	precacheshader("hud_sr71_camera_diamond");
	precacheshader("hud_sr71_camera_e_square");
	precacheshader("hud_sr71_camera_arrow");
	precacheshader("hud_onscreenobjectivepointer");
	PreCacheShader( "cinematic" );
}

/*------------------------------------
auto centers the camera back to the sr71 screen
if the player looks 
------------------------------------*/
auto_center_camera()
{
	level endon("end_rts");
	sr71 = ent_get("sr71_cam");
	while( 1 )
	{
		idle_time = 0;
		while( idle_time < 1 )
		{
			movement = self GetNormalizedMovement();
			if(movement[0] == 0 && movement[1] == 0 )
			{
				idle_time += .1;	
			}
			else
			{
				idle_time = 0;
			}
			wait .1;
		}

		self startcameratween(.5);
		wait(.05);
		self setplayerangles( sr71 gettagangles("tag_passenger") );
		wait(.5);
	}
}


/*------------------------------------
s
------------------------------------*/
spawn_rts_cam(cam_model_targetname,ender,do_dialogue,mark_targets)
{
	level endon(ender);
	
	setsaveddvar("r_extracam_custom_aspectratio",1);
	
	create_camera_zoom_icon(1);	
	
	wait(2);
	
	//screen = ent_get("sr71_cam");
	//set_initial_extra_cam_blur();
	init_rso_focus();
	sr71 = ent_get("sr71_cam");

	// sets up the camera entity that can be moved around
	// happens on the client
	cam = GetEnt(cam_model_targetname, "targetname");		
	cam.angles = ( 70,0, 0);
	
	//enable_extra_cam();
	
	cam.movement_max_dist = 90000; //cam.radius;
	
	level.cam_movement_threshold = 0.25;
	
	player = get_players()[0];	
	player thread rts_control_listener( ender );
	player thread rts_control_anims( ender, sr71 );
	player thread move_rts_camera(cam,mark_targets,ender);

	level thread enemy_dialogue();

}


//toggle_angles()
//{
//	
//	player = get_players()[0];
//	cam = GetEnt("rts_extracam", "targetname");	
//	angles = 90;
//	while(1)
//	{
//		if( player usebuttonpressed() )
//		{
//			angles++;
//			cam.angles = ( angles,0, 0);
//		}
//		if ( player jumpbuttonpressed() )
//		{
//			angles--;
//			cam.angles = ( angles,0,0);
//		}
//		iprintlnbold( angles );
//		wait(.05);
//	}
//	
//}


/*------------------------------------
play some dialogue when the player highlights an enemy w/the SR71 cam
------------------------------------*/
enemy_dialogue()
{
	level endon("stop_spotting");
	
	while(1)
	{
		level waittill("enemy_spotted",who);
		//add_dialogue_line("Camera Operator","Enemy spotted");
		wait(5);
	}
	
}

zoom_brightness_controls()
{
	level endon("end_rts");
	screen = ent_get("sr71_cam");
	
	while(1)
	{
		if(level.cam_zoom != 0)
		{
			screen setclientflag(9);
		}
		else
		{
			screen clearclientflag(9);
		}
		wait(.05);
	}
	
}

#using_animtree( "wmd_sr71" );

rts_control_listener( ender )
{
	self endon( "disconnect" );
	level endon( ender );
	
	while( 1 )
	{
		if(IsDefined(level._player_on_ground))
		{
			while(level._player_on_ground)
			{
				wait(0.05);
			}
		}		
		
		level.cam_movement = self GetNormalizedMovement();
		if( self AttackButtonPressed() )
		{
			level.cam_zoom = 1;
		}
		else if( self ThrowButtonPressed() )
		{
			level.cam_zoom = -1;
		}
		else
		{
			level.cam_zoom = 0;
		}
		
		if( self jumpbuttonpressed() )
		{
			level.mark_target = true;
		}
		else
		{
			level.mark_target = false;
		}
		
		if( self MeleeButtonPressed() && flag("wait_for_prone_command"))
		{
			level.force_prone = true;
		}
		else
		{
			level.force_prone = false;
		}
		
		while(self MeleeButtonPressed())
		{
			wait(0.35);
		}
		
		wait( 0.05 );
	}
}


rts_idle_anims( ender, sr71 )
{
	self endon( "disconnect" );
	level endon( ender );
	
	min_twitch_time = 10;
	max_twitch_time = 20;
	
	idle_anim = level.scr_anim["player_pilot_body"]["sr71_RSO_idle"];
	twitch_anim = level.scr_anim["player_pilot_body"]["sr71_RSO_twitch"];
	sr71_twitch_anim = level.scr_anim["sr71"]["sr71_RSO_twitch"];
	twitch_length = GetAnimLength( twitch_anim );
	
	while( 1 )
	{
		wait_time = RandomFloatRange( min_twitch_time, max_twitch_time );
		wait( wait_time );
		if(IsDefined(level._player_on_ground))
		{
			while(level._player_on_ground)
			{
				wait(0.05);
			}
		}
		
		self.hands ClearAnim( idle_anim, 0.2 );
		self.hands SetAnim( twitch_anim, 1 );
		sr71 SetAnim( sr71_twitch_anim, 1 );
		wait( twitch_length );
		if(IsDefined(level._player_on_ground))
		{
			while(level._player_on_ground)
			{
				wait(0.05);
			}
		}
				
		self.hands ClearAnim( twitch_anim, 0.2 );
		sr71 ClearAnim( sr71_twitch_anim, 0.2 );
		self.hands SetAnim( idle_anim, 1 );
	}
}

rts_control_anims( ender, sr71 )
{
	self endon( "disconnect" );
	level endon( ender );
	
	flag_wait( "intro_dialogue_done" );
	
	self thread rts_idle_anims( ender, sr71 );
	
	min_control_weight = 0.0;
	anim_update_time = 0.15;
	
	while( 1 )
	{
		
		if(IsDefined(level._player_on_ground))
		{
			while(level._player_on_ground)
			{
				wait(0.05);
			}
		}		
		
		total_control_weight = 0;
		
		local_cam_movement = level.cam_movement;
		
		if( (abs(local_cam_movement[0]) > abs(local_cam_movement[1])) && abs(local_cam_movement[1]) < 0.15 )
		{
			local_cam_movement = ( local_cam_movement[0], 0, local_cam_movement[2] );
		}
		
		if( (abs(local_cam_movement[1]) > abs(local_cam_movement[0])) && abs(local_cam_movement[0]) < 0.15 )
		{
			local_cam_movement = ( 0, local_cam_movement[1], local_cam_movement[2] );
		}
		
		if( level.cam_zoom != 0)
		{
			total_control_weight += abs( level.cam_zoom );
			if( level.cam_zoom < 0 )
			{
				self.hands SetAnimKnob( level.scr_anim["player_pilot_body"]["sr71_RSO_zoom_in"], 1, anim_update_time );
				sr71 SetAnimKnob( level.scr_anim["sr71"]["sr71_RSO_zoom_in"], 1, anim_update_time );
			}
			else if( level.cam_zoom > 0 && flag( "zoom_in_check" ) )
			{
				self.hands SetAnimKnob( level.scr_anim["player_pilot_body"]["sr71_RSO_zoom_out"], 1, anim_update_time );
				sr71 SetAnimKnob( level.scr_anim["sr71"]["sr71_RSO_zoom_out"], 1, anim_update_time );
			}
		}
		else
		{
			self.hands ClearAnim( %sr71_player_zoom_controls, anim_update_time );
			sr71 ClearAnim( %sr71_zoom_controls, anim_update_time );
		}
		
		if( flag("optics_check" ) )
		{
			if( local_cam_movement[0] > 0 )
			{
				weight = max( local_cam_movement[0], min_control_weight );
				weight = min( weight, 1);
				total_control_weight += weight;
				self.hands SetAnimLimited( %sr71_player_ud_controls, weight, anim_update_time );
				self.hands SetAnimKnobLimited( level.scr_anim["player_pilot_body"]["sr71_RSO_move_up"], 1, anim_update_time );
				sr71 SetAnimLimited( %sr71_ud_controls, weight, anim_update_time );
				sr71 SetAnimKnobLimited( level.scr_anim["sr71"]["sr71_RSO_move_up"], 1, anim_update_time );
			}
			else if( level.cam_movement[0] < 0 ) 
			{
				weight = max( abs(local_cam_movement[0]), min_control_weight );
				weight = min( weight, 1);
				total_control_weight += weight;
				self.hands SetAnimLimited( %sr71_player_ud_controls, weight, anim_update_time );
				self.hands SetAnimKnobLimited( level.scr_anim["player_pilot_body"]["sr71_RSO_move_down"], 1, anim_update_time );
				sr71 SetAnimLimited( %sr71_ud_controls, weight, anim_update_time );
				sr71 SetAnimKnobLimited( level.scr_anim["sr71"]["sr71_RSO_move_down"], 1, anim_update_time );
			}
			else
			{
				self.hands ClearAnim( %sr71_player_ud_controls, anim_update_time );
				sr71 ClearAnim( %sr71_ud_controls, anim_update_time );
			}
			
			if( level.cam_movement[1] > 0 )
			{
				weight = max( local_cam_movement[1], min_control_weight );
				weight = min( weight, 1);
				total_control_weight += weight;
				self.hands SetAnimLimited( %sr71_player_lr_controls, weight, anim_update_time );
				self.hands SetAnimKnobLimited( level.scr_anim["player_pilot_body"]["sr71_RSO_move_right"], 1, anim_update_time );
				sr71 SetAnimLimited( %sr71_lr_controls, weight, anim_update_time );
				sr71 SetAnimKnobLimited( level.scr_anim["sr71"]["sr71_RSO_move_right"], 1, anim_update_time );
			}
			else if( level.cam_movement[1] < 0 ) 
			{
				weight = max( abs(local_cam_movement[1]), min_control_weight );
				weight = min( weight, 1);
				total_control_weight += weight;
				self.hands SetAnimLimited( %sr71_player_lr_controls, weight, anim_update_time );
				self.hands SetAnimKnobLimited( level.scr_anim["player_pilot_body"]["sr71_RSO_move_left"], 1, anim_update_time );
				sr71 SetAnimLimited( %sr71_lr_controls, weight, anim_update_time );
				sr71 SetAnimKnobLimited( level.scr_anim["sr71"]["sr71_RSO_move_left"], 1, anim_update_time );
			}
			else
			{
				self.hands ClearAnim( %sr71_player_lr_controls, anim_update_time );
				sr71 ClearAnim( %sr71_lr_controls, anim_update_time );
			}
		}
		
		total_control_weight = min(total_control_weight, 1);
		
		self.hands SetAnim( level.scr_anim["player_pilot_body"]["sr71_RSO_neutral"], (1-total_control_weight), anim_update_time );
		sr71 SetAnim( level.scr_anim["sr71"]["sr71_RSO_neutral"], (1-total_control_weight), anim_update_time );
			
		wait( anim_update_time );
	}
}


move_rts_camera(cam,mark_targets,ender)	// self == player
{
	self endon("disconnect");
	level endon("squad_detected");
	level endon(ender);
	
	min_cam_move_scale = 10.0;
	max_cam_move_scale = 20.0;
	
	
	cam_height_scaler = 50;
	cam_height = cam.origin[2];
	
	max_struct = getstruct(cam.target,"targetname");
	min_struct = getstruct(max_struct.target,"targetname");
	
	
	cam_max_height = max_struct.origin[2];
	cam_min_height = min_struct.origin[2];
	cam_height_range = cam_max_height - cam_min_height;
	
	cam_move_Scale = min_cam_move_scale;
	
	camera_start_pos = cam.origin;
	level.goal_cam_pos = camera_start_pos;

	level thread check_for_selected_target(cam,false,ender);
	
	delay = 0.1;
	new_pos = cam.origin;
	
	level.move_x_ent = spawn("script_origin",self.origin);
	level.move_y_ent = spawn("script_origin",self.origin);
	level.move_in_ent = spawn("script_origin",self.origin);
	level.move_out_ent = spawn("script_origin",self.origin);
	
	level.move_x_ent.playing = false;
	level.move_y_ent.playing = false; 
	level.move_in_ent.playing = false;
	level.move_out_ent.playing = false;
	
	//screen = getent("sr71_screen","targetname");	
	screen = ent_get("sr71_cam");
	while(1)
	{
		if(IsDefined(level._player_on_ground))
		{
			while(level._player_on_ground)
			{
				if(level.move_x_ent.playing)
				{
					level.move_x_ent StopLoopSound();
					level.move_x_ent.playing = false;
				}

				if(level.move_y_ent.playing)
				{
					level.move_y_ent StopLoopSound();
					level.move_y_ent.playing = false;
				}

				if(level.move_in_ent.playing)
				{
					level.move_in_ent StopLoopSound();
					level.move_in_ent.playing = false;
				}

				if(level.move_out_ent.playing)
				{
					level.move_out_ent StopLoopSound();
					level.move_out_ent.playing = false;
				}


				wait(0.05);
			}
		}
		
		if(!isDefined(cam.cur_fov))
		{
			cam.cur_fov = 35;
		}		
		cam_height_pos = 60 - cam.cur_fov;
	
		hud_zoom_pcnt = 	(cam_height_pos * 100 / 45 ) / 100;
		cam_height_pcnt = 1 - ((cam_height_pos * 100 / 45 ) / 100);		
		set_camera_zoom_hud_percent(hud_zoom_pcnt);
		
		//wait until intro tutorial dialogue is done before allowing the player to move the camera
		if(!flag("intro_dialogue_done"))
		{
			wait(.05);
			continue;
		}
		
		//is_in_fov(level.rts_heroes[0],cam);		
		
		movement = self GetNormalizedMovement();
		
		if(!flag("optics_check")) 
		{
			if (movement[1] != 0 || movement[0] != 0 )
			{
				flag_set("optics_check");
			}
		}
	
		min_cam_move_scale = 10 + cam_height_scaler * cam_height_pcnt;
		max_cam_move_scale = 20 + cam_height_scaler * cam_height_pcnt;
						
						
		if(movement[0] == 0 && movement[1] == 0 )
		{
			if( flag("optics_check"))
			{
				level.move_x_ent stoploopsound();
				level.move_y_ent stoploopsound();
				level.move_x_ent.playing = false;
				level.move_y_ent.playing = false;
				cam_move_scale = min_cam_move_scale;
			}	
		}
		else
		{
			if(cam_move_scale < max_cam_move_scale)
			{
				cam_move_scale = min(cam_move_scale * 1.2, max_cam_move_scale);
			}
			
			if(flag("optics_check"))
			{
				
				if( (movement[0] > 0.25 || movement[0] < -0.25) && !level.move_x_ent.playing )
				{
					level.move_x_ent.playing = true;
					level.move_x_ent playloopsound(level.scr_sound["scroll_x_loop"]);
				}
				
				else if(movement[0] < 0.25 && movement[0] > -0.25)
				{
					level.move_x_ent.playing = false;
					level.move_x_ent stoploopsound();
				}
				
				if( (movement[1] > 0.25 || movement[1] < -0.25) && !level.move_y_ent.playing )
				{
					level.move_y_ent.playing = true;
					level.move_y_ent playloopsound(level.scr_sound["scroll_y_loop"]);
				}
				else if(movement[1] < 0.25 && movement[1] > -0.25)
				{
					level.move_y_ent.playing = false;
					level.move_y_ent stoploopsound();
				}	
			}			
		}

		movement = (movement[0], 0 - movement[1], movement[2]);
		
	//	new_pos = level.goal_cam_pos + (movement * cam_move_scale);
		
		
		//pos = level.goal_cam_pos + (movement * cam_move_scale);
		//new_pos = level.goal_cam_pos + ((movement * cam_move_scale) * is_in_playable_area(pos, cam, movement * cam_move_scale));
		
		new_pos = level.goal_cam_pos + is_in_playable_area(cam, movement * cam_move_scale);
		
		if(!flag("optics_check"))
		{
			new_pos = level.goal_cam_pos;				
		}		
		
		//zooming in/out
		if( level.cam_zoom > 0 &&  (cam.origin[2] + 60 < cam_max_height))
		{
			if(!flag("zoom_out_check"))
			{
				flag_set("zoom_out_check");
			}
			
			if(!level.move_out_ent.playing )
			{
				level.move_out_ent.playing = true;
				level.move_out_ent playloopsound(level.scr_sound["zoom_out_loop"]);
			}
			
			//fov changes on the extracam	
			start_increase_extra_cam_fov();
			if(cam.cur_fov +2.75 < 60)
			{
				cam.cur_fov+=2.75;
			}
			else
			{
				cam.cur_fov = 60;
			}
				
			//new_pos = (new_pos[0],new_pos[1],new_pos[2] );//+ 60);
		}
		else if( level.cam_zoom < 0 && (cam.origin[2] - 60 > cam_min_height))
		{
			if(!flag("zoom_in_check"))
			{
				flag_set("zoom_in_check");
			}
			
			if(!level.move_in_ent.playing )
			{
				level.move_in_ent.playing = true;
				level.move_in_ent playloopsound(level.scr_sound["zoom_in_loop"]);
			}
			//fov changes
			
			start_decrease_extra_cam_fov();
			if(cam.cur_fov -2.75 > 15)
			{
				cam.cur_fov-=2.75;
			}
			else
			{
				cam.cur_fov = 15;
			}
	
			//new_pos = (new_pos[0],new_pos[1],new_pos[2] );//- 60);
		}
		
		if( level.cam_zoom >= 0 && level.move_in_ent.playing)
		{
			level.move_in_ent stoploopsound();
			level.move_in_ent.playing = false;
		}
		if( level.cam_zoom <= 0 && level.move_out_ent.playing)
		{
			level.move_out_ent stoploopsound();
			level.move_out_ent.playing = false;
		}
		
		
		//check to see if the player is pressing the jump button
		
		//only after the squad has been located
		if( flag("move_squad"))
		{
			if(level.mark_target || level.force_prone)
			{
				if(is_area_legal(cam.origin, cam))
				{
					approved_move = false;
					
					if(!isDefined(level._is_moving_or_attacking))
					{
				 		approved_move = move_or_attack(cam);
					}
					
					if(approved_move)
					{
						self thread play_camera_mark_sound();
					}
				}
				else
				{
					level thread pilot_says_no_to_cp();
				}
			}
		}
			
		if(IsDefined(level.force_cam_pos))
		{
			cam.origin = level.force_cam_pos;
			level.goal_cam_pos = cam.origin;
			level.new_end_pos = (cam.origin[0], cam.origin[1], level._cam_height);
			new_pos = level.goal_cam_pos;
			level.force_cam_pos = undefined;
		}
		else if(new_pos != level.goal_cam_pos)
		{
			level.goal_cam_pos = new_pos;
			cam MoveTo(level.goal_cam_pos, delay);
		}		
		
		if(!flag("squad_located"))
		{
			min_x = camera_start_pos[0] - (cam.movement_max_dist / 2);
			max_x = camera_start_pos[0] + (cam.movement_max_dist / 2);
			min_y = camera_start_pos[1] - (cam.movement_max_dist / 2);
			max_y = camera_start_pos[1] + (cam.movement_max_dist / 2);
		}
		
		if(flag("squad_located"))
		{
			//reset the min/max camera movement 
			min_x = level.rts_heroes[0].origin[0] - (cam.movement_max_dist / 2);
			max_x = level.rts_heroes[0].origin[0] + (cam.movement_max_dist / 2);
	
			min_y = level.rts_heroes[0].origin[1] - (cam.movement_max_dist / 2);
			max_y = level.rts_heroes[0].origin[1] + (cam.movement_max_dist / 2);
		}
		wait(delay);
		stop_increase_extra_cam_fov();
		stop_decrease_extra_cam_fov();	
		
		cam thread check_for_lookat_triggers();
	}
}

play_camera_mark_sound()
{
	
	if(!isDefined(self.mark_sound))
	{
		self.mark_sound = true;
		self playsound("evt_sr71_camera_mark");
		while( self jumpbuttonpressed() || self MeleeButtonPressed())
		{
			wait (0.05);
		}
		self.mark_sound = undefined;
	}
}

tutorial_setup()
{
	level endon("end_rts");
	
	//reset the camera radius so it can be moved farther
	cam = GetEnt("rts_extracam", "targetname");		
		
	player= get_players()[0];
	pilot = get_pilot_ent();
	operator = get_operator_ent();
	hudson = get_hudson_ent();

	flag_set("intro_dialogue_done");		

	//TUEY Set music to "Canyon" (SR71_RTS)
	setmusicstate("SR71_RTS");

	wait(3);
	
	flag_wait("sr71_dialogue_done");
	
	wait(0.2);
	
	//pilot anim_single( pilot, "355A_usc1_f"); //	check reticule
	level.vo_playing = true;
	pilot anim_single( pilot, "356A_usc1_f");//	find the squad w/the reticule
	level.vo_playing = false;
	
	if(!flag("optics_check"))
	{
		screen_message_create(&"PLATFORM_MOVE_CAMERA");
	
		flag_wait("optics_check");
		
		screen_message_delete();
	}

	flag_set("zoom_tut");

	create_zoom_tutorial_message();
	
	//for demo
	//flag_set("zoom_in_check");
	//flag_set("zoom_out_check");
	
//	hide_hud_prompt();	
	//wait(1);	

	//player playsound(level.scr_sound["029A_usc2_f"] ,"sounddone");	
	cam.movement_max_dist = 90000;//cam.radius;
	//player waittill("sounddone");
		
//	wait(.5);
//	hudson anim_single( hudson, "030A_huds");//	Bigeye this is Kilo One requesting tactical recon, over. Repeat, we can't see anything down here.
	
//	wait(.2);
	//pilot anim_single( pilot, "356A_usc1_f");//	find the squad w/the reticule
		
	objective_add(0,"current", &"WMD_SR71_LOCATE_SQUAD");
	//level thread create_squad_waypoint();
	
	flag_set("locate_squad");
	flag_wait("squad_located");
	
	objective_state(0,"done");
	objective_delete(0);
	
	level.vo_playing = true;
	operator anim_single( operator, "032A_usc2_f"); //	Affirmative. I have them.
	level.vo_playing = false;
		
//	pilot anim_single( pilot, "033A_usc1_f"); // K.A.D., link has been established with Kilo One.

	//set up the icons and waypoint
	setup_friendly_hud_icons();
	
	//flag_set("zoom_tut");
	
	//do_tutorial_dialogue(level.scr_sound["354A_usc1_f"]);//Check your focal controls, C.P.

	//screen_message_create(&"WMD_ZOOM_IN", &"WMD_ZOOM_OUT");
	
 //flag_wait("zoom_in_check");
	//hide_hud_prompt();
	//wait(1);
	//screen_message_delete();
	//do_tutorial_dialogue(level.scr_sound["026A_usc2_f"]);//	Check. Optics are fully functional.
	
	level.vo_playing = true;
	operator anim_single( operator, "034A_usc2_f");//	Kilo One this is Bigeye 6, I have you on the TRP..
	level.vo_playing = false;

	level.vo_playing = true;
	hudson anim_single(hudson, "035A_huds");	//Copy that Bigeye 6. We have zero visibility on the ground. We need you to guide us to the insertion point  over.
	level.vo_playing = false;
	//operator anim_single( operator, "036A_usc2_f");//	Copy that Kilo One. We are your eyes. Stand by.

	level.vo_playing = true;
	operator anim_single( operator, "049A_usc2_f");//move east
	level.vo_playing = false;
	
	autosave_by_name("wmd_rts_post_tutorial");
	
	cam.movement_max_dist = 90000;
	
	pos_east = getent("pos_obj_east", "targetname");
	
	level thread squad_dist_objective(pos_east, 0);
	
	objective_add(0, "current", &"WMD_SR71_MOVE_EAST");	
	Objective_Position(0, pos_east.origin);
			
	flag_set("move_squad");
	
	screen_message_create(&"WMD_SR71_MOVE_SQUAD");
	
	level waittill_either("stop_color_logic", "valid_move_command");
	
	screen_message_delete();
}


create_offroad_waypoint(ent)
{	
	objective_state(0,"done");
	objective_delete(0);
	
	//add the objective
	objective_add(1, "current", &"WMD_SR71_MOVE_OFFROAD");
	Objective_Set3D( 1, true, "ltblue", &"WMD_SR71_SAFE_SPOT", 1 );
	Objective_Position(1, ent.origin );
	
	player = get_players()[0];	
	elem = newClientHudElem(player);
	
	model = spawn("script_model",ent.origin);
	model setmodel("tag_origin");
	trig = spawn("trigger_radius", ent.origin, 2, 256, 256*2);
	
	level thread wait_for_squad_to_hide(elem,trig,model);
}


create_hillside_waypoint()
{
	ent = getent("hillside_obj", "targetname");
	
	objective_add(2, "current", &"WMD_SR71_FIND_COVER", ent.origin);
	Objective_Position(2, ent.origin);
	level thread squad_dist_objective(ent, 2);
	
	trigger_wait("trigger_ridge");
	
	autosave_by_name("wmd_ridge");
		
	flag_set("squad_on_hilltop");
	
	Objective_State(2, "done");
	objective_delete(2);
	
	ent delete();
	
	ent = getent("pre_barracks_obj", "targetname");
	
	Objective_Add(4, "current", &"WMD_SR71_GET_TO_BARRACKS", ent.origin);
	Objective_Position(4, ent.origin);
	level thread squad_dist_objective(ent, 4);
	
	trigger_wait("trigger_pre_barracks");
	//flag_wait("go_barracks");
	
	ent delete();
	
	flag_set("pre_barracks");
	
	flag_wait("garage_fps_done");
	
	//-- delete the script brushmodel that blocks the area beyond the barracks
	blocker = GetEntarray("barracks_blocker", "script_noteworthy");
	for(i=0; i<blocker.size; i++)
	{
		blocker[i] Delete();
	}
}


create_barracks_waypoint(struct)
{
	flag_wait("pre_barracks");
		
	//Objective_Add(4, "current", &"WMD_SR71_GET_TO_BARRACKS", struct.origin);
	Objective_Set3D(4, true, "ltblue", &"WMD_SR71_BARRACKS", 1);
	Objective_Position(4, struct.origin);
	
	//trigger_wait("spawn_patrol", "targetname");
	
	//Objective_Add(5, "current", &"WMD_SR71_HELP_EVADE_PATROL");
	//Objective_Set3D(4,0);
	
	//flag_wait("first_patrol_clear");
	
	//Objective_State(5, "done");	

	//Objective_Set3D(4, true, "default", &"WMD_SR71_BARRACKS", 1);
	
	//level waittill("garage_fps");
	
	//Objective_State(4, "done");
	//Objective_Set3D(4, 0);
}


wait_for_squad_objective(elem,trig,model,obj,flag)
{
	level endon("end_rts");
	
	trig waittill("trigger");
	
	elem ClearTargetEnt();
	elem Destroy();	
	objective_state(obj,"done");
	trig delete();
	model delete();
	if(isDefined(flag))
	{
		flag_set(flag);
	}
}


squad_dist_objective(ent, obj_num)
{
	while(isdefined(ent) && isAlive(level.rts_heroes[1]))
	{
		level.dist = int(Distance2D(level.rts_heroes[1].origin, ent.origin));
		
		Objective_Set3D(obj_num, true, "ltblue", level.dist, 1);
		
		wait(0.05);
	}
}


tutorial_message(y, text, time_out, flag1, flag2)
{
		elem = NewHudElem(); 
		elem.elemType = "font";
		elem.font = "objective";
		elem.fontscale = 1.8;
		elem.horzAlign = "center";
		elem.vertAlign = "middle";
		elem.alignX = "center"; 
		elem.alignY = "middle";
		elem.y = y;
		elem.sort = 2;
		elem.color = ( 1, 1, 1 );
		elem.alpha = 1.0;
		
		elem SetText(text);

		steps = time_out * 20;

		keep_on_looping = true;

		while(steps > 0 && keep_on_looping)
		{
			steps --;
			if(IsDefined(flag1))
			{
				if(IsDefined(flag2))
				{
					if(flag(flag1) || flag(flag2))
					{
						keep_on_looping = false;
					}
				}
				else
				{
					if(flag(flag1))
					{
						keep_on_looping = false;
					}
				}
			}
			wait(0.05);
		}
		
		elem FadeOverTime(0.5);
		elem.alpha = 0;
		wait(0.5);
		elem Destroy();
		
				
}

create_zoom_tutorial_message()
{
	if(!flag("zoom_in_check") && !flag("zoom_out_check"))
	{
		screen_message_create(&"WMD_SR71_ZOOM_IN", &"WMD_SR71_ZOOM_OUT");
		
		level thread check_zoom_controls();
		
		flag_wait("zoomed");
		
		screen_message_delete();
		
		//level thread tutorial_message(-33, &"WMD_SR71_ZOOM_IN", 4, "zoom_in_check", "zoom_out_check");
		//level thread tutorial_message(-6, &"WMD_SR71_ZOOM_OUT", 4, "zoom_in_check", "zoom_out_check");
	}
}


check_zoom_controls()
{
	while(1)
	{
		if (get_players()[0] ThrowButtonPressed())
		{
			break;
		}
		
		if (get_players()[0] AttackButtonPressed())
		{
			break;
		}
		
		wait(0.05);
	}
	
	flag_set("zoomed");
}


sr71_rso_anim_intro( plane )
{
	if(!IsDefined(level._anim_intro_done))
	{
		self.hands SetFlaggedAnim( "control_anim", level.scr_anim["player_pilot_body"]["sr71_RSO_startup"], 1 );
		plane SetAnim( level.scr_anim["sr71"]["sr71_RSO_startup"], 1 );
		level ClientNotify("start_fov_change");
		self.hands waittillmatch( "control_anim", "end" );
		level._anim_intro_done = true;
	}
	self.hands SetAnimKnob( level.scr_anim["player_pilot_body"]["sr71_RSO_idle"], 1 );
	plane SetAnimKnob( level.scr_anim["sr71"]["sr71_RSO_idle"], 1 );
	self.hands notify( "rso_setup_complete" );
		
	//move the FOV change to a better spot

}

make_player_copilot(plane)
{
	player = get_players()[0];
	tag_origin = plane GetTagOrigin("tag_passenger");
	tag_angles = plane GetTagAngles("tag_passenger");
	
	player HideViewModel();
	player AllowCrouch( false );
	player AllowProne( false );
	Player AllowStand(true);
	player AllowMelee(false);
	player AllowSprint(false);
	
	player setstance("stand");

	player disableweapons();
	
	player SetClientDvar( "compass", "0" );
	player SetClientDvar( "hud_showstance", "0" );
	player SetClientDvar( "actionSlotsHide", "1" );
	player SetClientDvar( "ammoCounterHide", "1" );
	player SetClientDvar( "r_stereo3DFixGunFocus", 0);
	
	player setplayerangles( tag_angles );
	player playerlinktodelta(plane,"tag_passenger",0,0,0,0,0);
	player setplayerangles( tag_angles );
	player.hands = spawn_anim_model("player_pilot_hands", tag_origin+(0, 0, 2), tag_angles );
	player.hands UseAnimTree( level.scr_animtree["player_pilot_hands"] );
	plane UseAnimTree( level.scr_animtree["player_pilot_hands"] );
	plane.animname = "operator";
	player._original_fov = GetDvarFloat( #"cg_fov");
	player SetClientDvar( "cg_fov", "45" );
	
	player thread sr71_rso_anim_intro(plane);	
}


cleanup_player_hands()
{
	player = get_players()[0];
	if(IsDefined(player.hands))
	{
		player.hands Delete();
		player.hands = undefined;
	}
}


create_streamer_ent()
{
	level.streamer_ent = createStreamerHint( GetEnt("cockpit_stream_ent", "targetname").origin, 1);
}

delete_streamer_ent()
{
	if(IsDefined(level.streamer_ent))
	{
		level.streamer_ent Delete();
	}
}

player_in_cockpit()
{
	level notify("set_rts_fog");
	
	//TUEY Make sure the sound are playing on the SR71 again after flying away.
	level thread maps\wmd_intro::sr71_sound_start_post_safehouse();
	
	//TUEY client notify to reset snapshot;
	ClientNotify ("sic");
	
	enable_extra_cam();
	level ClientNotify("update_rts_fov");
	sr71 = ent_get("sr71_cam");
	visionsetnaked("wmd_sr71cam", 0);
	make_player_copilot(sr71);

	if(IsDefined(level.fps_heroes))
	{	
		keys = GetArrayKeys(level.fps_heroes);
		
		for(i = 0; i < keys.size; i ++)
		{
			level.fps_heroes[keys[i]] Delete();
		}
	
		level.fps_heroes = undefined;
	}
		
	level._player_on_ground = false;
	level.is_in_rts = true;
	
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );
}

setup_fps_friendlies(start)
{
	level.fps_heroes = [];
	level.fps_heroes["weaver"] = simple_spawn_single("spawner_weaver_"+start, ::setup_weaver_fps);
	
	level.fps_heroes["harris"] = simple_spawn_single("spawner_harris_"+start, ::setup_harris_fps);
	
	level.fps_heroes["brooks"] = simple_spawn_single("spawner_brooks_"+start, ::setup_brooks_fps);
	
	keys = GetArrayKeys(level.fps_heroes);
	
	for(i = 0; i < level.fps_heroes.size; i ++)
	{
		if(IsDefined(level.fps_heroes[keys[i]].script_string))
		{
			level.fps_heroes[keys[i]] AllowedStances(level.fps_heroes[keys[i]].script_string);
		}
	}
}


setup_weaver_fps()
{
	self.name = "Weaver";
	self make_hero();
	self.animname = "weaver";
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
}


setup_harris_fps()
{
	self.name = "Harris";
	self make_hero();
	self.animname = "harris";
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
}


setup_brooks_fps()
{
	self.name = "Brooks";
	self make_hero();
	self.animname = "brooks";
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
}


player_on_ground(start)
{
	level notify("set_rts_fps_fog");
	
	//TUEY client notify to reset snapshot;
	ClientNotify ("gtg");
	
	player_start_name = "player_rts_fps_" + start;
	
	player_start = get_players()[0];
	
	get_players()[0] DisableInvulnerability();
	
	if(start == "test")
	{
		player_start = level.rts_heroes[0];
	}
	else
	{
		player_start = getstruct(player_start_name, "script_noteworthy");
	}
	
	if(!IsDefined(player_start))
	{
		PrintLn(" Could not find start pos : " + player_start_name);
		return;
	}
	
	cleanup_player_hands();

	player = get_players()[0];
	player ShowViewModel();
	player EnableWeapons();

	player SetClientDvar( "compass", "1" );
	player SetClientDvar( "hud_showstance", "1" );
	player SetClientDvar( "actionSlotsHide", "0" );
	player SetClientDvar( "ammoCounterHide", "0" );
	player SetClientDvar( "r_stereo3DFixGunFocus", 1);        
	
	player AllowCrouch( true );
	player AllowProne( true );
	Player AllowStand(true);
	player AllowMelee(true);
	player AllowJump(true);
	player AllowLean(true);
	player AllowSprint(true);
	
	if(IsDefined(player_start.script_string) && maps\_contextual_melee::is_valid_stance(player_start.script_string))
	{
		player SetStance(player_start.script_string);
	}
	else
	{
		player setstance("stand");
	}
	
	player SetClientDvar( "cg_fov", player._original_fov);
	player Unlink();
	
	stop_increase_extra_cam_fov();
	stop_decrease_extra_cam_fov();
	disable_extra_cam();
	
	player SetPlayerAngles(player_start.angles);
	player SetOrigin(player_start.origin);

	level._player_on_ground = true;
	
	level.is_in_rts = undefined;
	
	if(start != "test")
	{
		setup_fps_friendlies(start);
	}
}

setup_rts_heroes()
{
	self.cqbwalking = false;
	self.ignoreall = true;
	self.pacifist = true;
	
	self.pathenemyfightdist = 0;
	self.pathenemylookahead = 0;
	self.ignoresuppression = true;
	self.grenadeawareness = 0;	
	
	self make_hero();
	playfxontag( level._effect["rts_guy_trail"],self,"J_head");
	level thread do_custom_muzzleflash(self);
	self.crouched = false;
	self AllowedStances("crouch", "stand");
	self.goalradius = 64;
	self.script_radius = 64;
}

setup_friendly_hud_icons()
{
	for(i=0;i<level.rts_heroes.size;i++)
	{
		level.rts_heroes[i] thread create_friendly_hud_icon(level.rts_heroes[i],1);
	}
}

reset_body_on_death()
{

	model = self.old_model;
	head = undefined;
	if(isDefined(self.headModel))
	{
		head = self.headModel;
	}
	self waittill_either("death", "fake_death");	
	if(isDefined(self) )
	{
		self setmodel(model);
		if(isDefined(head))
		{
			self attach(head);
		}
	}
}

go_prone()
{
	if(!IsDefined(self._going_prone) && self.a.pose != "prone")
	{
		self._going_prone = 1;
		// turn on shooting
		self.a.allow_shooting = false;
		self ClearEntityTarget();
		//wait(RandomFloatRange(0.05, 0.2));
		
		old_goal_radius = self.goalradius;
		self notify("forced_prone");
		self notify( "stop_going_to_node" ); 
		self.goalradius = 4;
		self SetGoalPos(self.origin);
		self waittill("goal");
		self.goalradius = old_goal_radius;
		self AllowedStances("prone");
		
		self._going_prone = undefined;
	}
}

force_squad_prone()
{
	
	for(i = 0; i < level.rts_heroes.size; i ++)
	{
		level.rts_heroes[i] thread go_prone();
	}
}

move_or_attack(cam)
{
	level endon("end_rts");
	level endon("rts_done");
		
	level._is_moving_or_attacking = true;
	
	angles 					= cam.angles;
	origin 					= cam.origin;				
	forward 				= anglestoforward( angles );
	vec = vector_scale( forward, 10000 );
	
	trace = bullettrace(origin,origin + vec,false,undefined);
	org = trace["position"];
	norm = trace["normal"];
	
	//check to see if we're targeting an enemy
		// if so, can we attack? 
	enemy = check_enemy_in_sights(cam);
	if(isDefined(enemy) && !level.force_prone)
	{
		enemies = get_targeted_ai(enemy);
		
		//does the first enemy have a color trigger associated with him ( so the AI move into place after selecting him )
		//DO COLOR TRIG CHECK HERE
		if( does_enemy_have_color_trig(enemy) )
		{
			level thread activate_enemy_color_trig(enemies);
		}
		else if( does_enemy_have_parameter_nodes(enemy))
		{
			level notify("stop_color_logic");
		//	do_random_enemy_line(enemies);
			level thread do_random_contact_line();	
			level thread send_heroes_to_parameter_nodes(org,enemies);
		}
		else
		{
			//do a distance check here to see if the AI is close enough to attack ? 
			if( distancesquared(level.rts_heroes[0].origin,enemy.origin) > 2048 * 2048)
			{
				
//				// move squad closer
//				level notify("stop_color_logic");
//				do_random_contact_line();
//				do_random_ack_line();	
//				level thread send_heroes_to_new_position(org);
				
				//add_dialogue_line("Squad","Move us closer to the target so we can get a good shot");
			}
			else
			{
				//add random kill lines here
				//do_random_enemy_line(enemies);
				do_random_contact_line();
				level thread heroes_attack_enemies(enemies,1);
			}
		}
		
	}
	else
	{
		//if(flag("wait_for_prone_command") && flag("targetting_friendlies") && !flag("squad_prone") && level.force_prone)
		if(flag("wait_for_prone_command") && !flag("squad_prone") && level.force_prone) //-- remove the targetting friendlies check
		{
//			IPrintLnBold("Forcing squad prone.");
			if(!level._confirm_prone_order)
			{
				level._confirm_prone_order = true;
				hudson = get_hudson_ent();
				
				if(IsDefined(level.custom_prone_acknowledge))
				{
					hudson thread anim_single(hudson, level.custom_prone_acknowledge);
				}
				else
				{
					hudson thread anim_single(hudson, "acknowledge_prone");
				}
			}
			force_squad_prone();
			level thread create_camera_mark_effect(org,norm);
		}
		//should we activate a targeted color trigger ?
		else if ( is_touching_color_trig(cam) && !level.force_prone)
		{
			level notify ("valid_move_command");
			//level thread do_random_ack_line();
			activate_color_trigger_from_sr71(cam);
			level thread create_camera_mark_effect(org,norm);
		}
		else
		{
		
			if(!level.force_prone)
			{
				//check to see if we're targeting the terrain
					//if so can we move there? 
								
				//for now we can try to move everywhere	
				
				//move there
				level notify("stop_color_logic");
	
				//level thread do_call_and_response_dialogue(org); //-- moved this into the send_heroes_to_new_position in case that function aborted			
				successfully_moved = level thread send_heroes_to_new_position(org);
				if(!successfully_moved)
				{
					player = get_players()[0];
	
					while(player jumpbuttonpressed () || player MeleeButtonPressed())
					{
						wait(.35);
					}
					
					level._is_moving_or_attacking = undefined;
					return false;
				}
				
				level thread create_camera_mark_effect(org,norm);
			}
		}
	}
	
	player = get_players()[0];
	
	while(player jumpbuttonpressed () || player MeleeButtonPressed())
	{
		wait(.35);
	}
	
	level._is_moving_or_attacking = undefined;
	return true;
}

send_heroes_to_new_position(org)
{
	array_func(level.rts_heroes,::disable_ai_color);		
		
	//check for cover/conceal nodes in the area
	//hero_nodes = GetCoverNodeArray(org,512);
	nodes = getallnodes();
	nodes = get_array_of_closest( org, nodes, undefined, 50, 512 );
	_nodes = [];
	
	for(i=0;i<nodes.size;i++)
	{
		if(issubstr(nodes[i].type,"Conceal") || issubstr(nodes[i].type,"Cover") || issubstr(nodes[i].type, "Guard"))
		{
			_nodes[_nodes.size] = nodes[i];
		}
	}
	
	hero_nodes = get_Array_of_closest(org,_nodes,undefined,4,512);
	
	if(hero_nodes.size < 4)
	{
	
		nodes = getallnodes();
		hero_nodes = get_array_of_closest( org, nodes, undefined, 4, 420 );
	
		if(hero_nodes.size < 4)
		{
			//iprintlnbold("not enough nodes were selected");
			//TODO: replace this with a proper buzzer sound or lines from the squad
			//level thread pilot_says_no_to_cp();
			level thread invalid_selection_sound();
			return false;
		}
	}
	
	for(i=0;i<level.rts_heroes.size;i++)
	{
		//-- first find nodes of the heroes color
		hero_color = undefined;
		
		if(IsDefined(level.rts_heroes[i].script_forceColor))
		{
			hero_color = level.rts_heroes[i].script_forceColor;
		}
		
		if(!IsDefined(hero_color))
		{
			hero_color = level.rts_heroes[i].old_forcecolor;	
		}
		
		nodes_of_my_color = [];
		if(IsDefined(hero_color))
		{
			for(j = 0; j < hero_nodes.size; j++)
			{
				if( IsDefined(hero_nodes[j].script_color_allies) && IsSubStr(hero_nodes[j].script_color_allies, hero_color ) )
				{
					nodes_of_my_color[nodes_of_my_color.size] = hero_nodes[j];
				}
			}
		}
		
		node = undefined;
		if(nodes_of_my_color.size > 0)
		{
			node = getclosest(level.rts_heroes[i].origin, nodes_of_my_color);
		}
		else
		{
			node = getclosest(level.rts_heroes[i].origin,hero_nodes);
		}

		if(isDefined(node))
		{
			level.rts_heroes[i] thread moveto_new_pos(node,i);
			hero_nodes = array_remove(hero_nodes,node);
		}
	}
	
	level thread do_call_and_response_dialogue(org);
	return true;	
}

/*------------------------------------
script_parameters are set on enemies
which determines what nodes the squad should use 
to take them out
------------------------------------*/
send_heroes_to_parameter_nodes(org,enemies)
{
	level endon("stop_color_logic");
	
	//array_func(level.rts_heroes,::disable_ai_color);	

	nodes = getnodearray(enemies[0].script_parameters,"targetname");
	
	for(i=0;i<level.rts_heroes.size;i++)
	{
		node = getclosest(level.rts_heroes[i].origin,nodes);
		if(isDefined(node))
		{
			level.rts_heroes[i] thread moveto_new_pos(node,i);
			nodes = array_remove(nodes,node);
		}
	}

	array_wait(level.rts_heroes,"goal");
	
	wait(.5);
	level thread heroes_attack_enemies(enemies);	
	waittill_dead_or_dying(enemies);
	wait(2);
	level thread do_random_congrats();

}

do_call_and_response_dialogue(org)
{
	//do_random_squad_command(org);
	do_random_ack_line();	
}

do_random_ack_line()
{
	if(!IsDefined(level._ack_lines))
	{
		level._ack_lines = array(	"040A_huds", //	Roger that, we're moving.
														 	"044A_huds", //	Copy.
															"048A_huds", //	On our way, over.
															"050A_huds", //	We are moving.
															"052A_huds",//	Roger that.
															"054A_huds",//	Copy that Bigeye.	
															"058A_huds",//	Copy that. Moving.
															"074A_huds",//	We got it Bigeye.
															"106A_huds",//	On the move, Bigeye.
															"112A_huds");//	On it.
	}	
	player = get_players()[0];
	
	if(!isDefined(player.acking) )
	{
		player.acking = 1;
		hudson = get_hudson_ent();
		
		if (!level.vo_playing)
		{
			hudson anim_single(hudson, random(level._ack_lines));
		}
		
		wait(2);
		player.acking = undefined;
	}
}

//	= "vox_wmd1_s01_037A_usc2_f";//	Kilo move north.
//	level.scr_sound["038A_huds"] = "vox_wmd1_s01_038A_huds";//	Copy, moving north.
//	 = "vox_wmd1_s01_039A_usc2_f";//	Kilo, proceed to the north.
//	level.scr_sound["040A_huds"] = "vox_wmd1_s01_040A_huds";//	Roger that, we're moving.
//	 = "vox_wmd1_s01_041A_usc2_f";//	Kilo head north, over.
//	level.scr_sound["042A_huds"] = "vox_wmd1_s01_042A_huds";//	Understood, heading north.
//	 = "vox_wmd1_s01_043A_usc2_f";//	To the south, Kilo.
//	level.scr_sound["044A_huds"] = "vox_wmd1_s01_044A_huds";//	Copy.
//	= "vox_wmd1_s01_045A_usc2_f";//	South coordinates marked.
//	level.scr_sound["046A_huds"] = "vox_wmd1_s01_046A_huds";//	Got it, moving south.
//	 = "vox_wmd1_s01_047A_usc2_f";//	Kilo move south.
//	level.scr_sound["048A_huds"] = "vox_wmd1_s01_048A_huds";//	On our way, over.
//	 = "vox_wmd1_s01_049A_usc2_f";//	Kilo you need to move east.
//	level.scr_sound["050A_huds"] = "vox_wmd1_s01_050A_huds";//	We are moving.
//	 = "vox_wmd1_s01_051A_usc2_f";//	Move east.
//	level.scr_sound["052A_huds"] = "vox_wmd1_s01_052A_huds";//	Roger that.
//	 = "vox_wmd1_s01_053A_usc2_f";//	Kilo, head to the east.
//	level.scr_sound["054A_huds"] = "vox_wmd1_s01_054A_huds";//	Copy that Bigeye.
//	 = "vox_wmd1_s01_055A_usc2_f";//	Move west, Kilo one.
//	level.scr_sound["056A_huds"] = "vox_wmd1_s01_056A_huds";//	We are moving west Bigeye.
//	 = "vox_wmd1_s01_057A_usc2_f";//	Kilo I need you moving west.
//	level.scr_sound["058A_huds"] = "vox_wmd1_s01_058A_huds";//	Copy that. Moving.
//	 = "vox_wmd1_s01_059A_usc2_f";//	Kilo move west.


do_random_squad_command(org)
{
	north = array("037A_usc2_f","039A_usc2_f","041A_usc2_f");
	south = array("043A_usc2_f","045A_usc2_f","047A_usc2_f");
	east = array("049A_usc2_f","051A_usc2_f","053A_usc2_f");
	west = array("055A_usc2_f","057A_usc2_f","059A_usc2_f");
	
	squad_dir = level.squad_central.origin;
	
	
	if(org[0] > squad_dir[0]) // east of the squad
	{
		dir_x = north;
	}
	else
	{
		dir_x = south;
	}
	if(org[1] > squad_dir[1]) //north of squad
	{	
		dir_y = west;
	}
	else
	{
		dir_y = east;
	}
	
	x_dif = abs(org[0] - squad_dir[0]);
	y_dif = abs(org[1] - squad_dir[1]);
	
	final_dir = dir_y;
	if( x_dif > y_dif) // squad should move east/west
	{
		final_dir = dir_x;
	}
	 
	player = get_players()[0];
	
	if(!isDefined(player.commandin))
	{
		player.commandin = 1;
		operator = get_operator_ent();
		level.vo_playing = true;
		operator anim_single(operator, random(final_dir));
		level.vo_playing = false;
		wait(2);
		player.commandin = undefined;
	}
}




do_random_contact_line()
{
	rand_lines = array(	"070A_huds",  //	Copy. Initiating contact.
											"076A_huds",	//	Roger that, moving in.	
											"078A_huds",	//	Copy. We got 'em.
											"084A_huds",	//	Understood Bigeye. Stand by.
											"062A_huds",	//	Copy. Engaging target.
											"064A_huds");	//	Understood. Taking him down.
	player = get_players()[0];
		
	if(!isDefined(player.acking))
	{
		player.acking = 1;
		hudson = get_hudson_ent();
		level.vo_playing = true;
		hudson anim_single(hudson, random(rand_lines));
		level.vo_playing = false;
		wait(2);
		player.acking = undefined;
	}
}

pilot_says_no_to_cp()
{
	lines = array("nocpthatsabadcp1", "nocpthatsabadcp2", "nocpthatsabadcp3" );
	
	pilot = get_pilot_ent();
	
	if(!IsDefined(pilot.talking))
	{
		pilot.talking = true;
		level.vo_playing = true;
		pilot anim_single(pilot, random(lines));
		level.vo_playing = false;
		wait(1);
		pilot.talking = undefined;
	}
}

invalid_selection_sound()
{
	player = get_players()[0];
	player PlaySound("evt_sr71_camera_invalid");
	wait(0.05);
}


vo_ridge()
{
	trigger_wait("trigger_ridge_vo");
	
	operator = get_operator_ent();
	level.vo_playing = true;
	operator anim_single(operator, "065A_usc2_f");
	level.vo_playing = false;
}


do_random_enemy_line(enemies)
{
	rand_lines = [];
	one_lines = [];
	two_lines = [];
	three_lines = [];
		
	//random lines
	rand_lines = array(	"073A_usc2_f",	//	Multiple contacts in sight. Fire at will.
											"075A_usc2_f");	//	Multiple targets. Engage the enemy.
	
	//1 enemy
	one_lines = array(	"061A_usc2_f",	//	One traget marked. Take him out.
											"063A_usc2_f");	//	One target in range. Kill him.
	
	// 2 enemies
	two_lines = array(	"067A_usc2_f",	//	Kilo I have two targets on Tac. Lose them.
											"065A_usc2_f");	//	Two targets sighted. Kill them.	
	
	/// 3 enemies
	three_lines = array(	"071A_usc2_f",	//	Contact. Three targets. Drop them.
												"069A_usc2_f");//	Three enemies in range. Eliminate them.

	player = get_players()[0];
	
	if(enemies.size == 1)
	{
		ack_lines = one_lines;
	}
	else if(enemies.size == 2)
	{
		ack_lines = two_lines;
	}
	else if(enemies.size == 3)
	{
		ack_lines = three_lines;
	}
	else
	{
		ack_lines = rand_lines;
	}	
	
	if(isDefined(enemies[0]._dialogue_spoken) || isDefined(player.tut_dialogue))
	{
		return;
	}
	
	for(i=0;i<enemies.size;i++)
	{
		enemies[i]._dialogue_spoken = 1;
	}
	
	if(!isDefined(player._targeting))
	{
		player._targeting = 1;
		operator = get_operator_ent();
		level.vo_playing = true;
		operator anim_single(operator, random(ack_lines));
		level.vo_playing = false;
		wait(10); //make sure we don't spam dialogue
		
		player._targeting = undefined;
	}
	
	
	
}


do_random_congrats()
{
	rand_lines = array(	"117A_usc2_f",//	Good job Kilo.
											"119A_usc2_f",//	Area's clear. Good work.
											"120A_usc2_f",//	You're in the clear. Nice job.
											"123A_usc2_f");//	Nice work Kilo One.

	player = get_players()[0];
	
	if(!isDefined(player.acking))
	{
		player.acking = 1;
		operator = get_operator_ent();
		level.vo_playing = true;
		operator anim_single( operator, random(rand_lines));
		level.vo_playing = false;
		wait(2);
		player.acking = undefined;
	}

}

check_enemy_in_sights(cam)
{
	
	selected = undefined;
	enemies = getaiarray("axis");
	for ( i = 0; i < enemies.size; i++ )
	{
		enemy 					= enemies[i];
		angles 					= cam.angles;
		origin 					= cam.origin;				
		sight 					= anglestoforward( angles );
		vec_to_enemy  	= vectornormalize( enemy.origin - origin ); 
		
		//do we have an enemy centered in the sights?
		if( vectordot( sight, vec_to_enemy ) < .996 )
		{				
			continue;
		}
		
		if(IsDefined(enemy.dont_target) && enemy.dont_target)
		{
			continue;
		}
					
		return enemy;
	}
	return undefined;
}


check_ally_in_sights(cam)
{
	
	selected = undefined;
	allies = getaiarray("allies");
	for ( i = 0; i < allies.size; i++ )
	{
		ally 						= allies[i];
		angles 					= cam.angles;
		origin 					= cam.origin;				
		sight 					= anglestoforward( angles );
		vec_to_ally  		= vectornormalize( ally.origin - origin ); 
		
		//do we have an enemy centered in the sights?
		if( vectordot( sight, vec_to_ally ) < .996 )
		{				
			continue;
		}
		
		if(IsDefined(ally.dont_target) && ally.dont_target)
		{
			continue;
		}
					
		return ally;
	}
	return undefined;
}


get_targeted_ai(guy)
{

	guys = [];
	axis = getaiarray("axis");
	
	if(isDefined(guy.script_noteworthy) && guy.script_noteworthy == "isolated")
	{
		guys[0] = guy;
		return guys;
	}
	
	for(i=0;i<axis.size;i++)
	{
		if(IsDefined(axis[i].dont_target) && axis[i].dont_target)
		{
			continue;
		}
		
		if(distancesquared(axis[i].origin,guy.origin) < 256 * 256)
		{
			guys[guys.size] = axis[i];
		}
	}

	return guys;
}



heroes_attack_enemies(enemies,track_death)
{	
	
	player = get_players()[0];
	
	if(randomint(100) > 50)
	{
		player playsound("evt_rso_engagement_1");
	}
	else
	{ 
		player playsound("evt_rso_engagement_2");
	}
		
	for(i=0;i<level.rts_heroes.size;i++)
	{
		level.rts_heroes[i] thread hero_attacks_enemy(enemies);
	}
	
	if(isDefined(track_death))
	{
		//waittill_dead_or_dying(enemies);
		
		wait_for_enemies_to_die(enemies);		
		
		level thread do_random_congrats();
	}
		
}

wait_for_enemies_to_die(enemies)
{
	enemies_alive = true;
	
	while(enemies_alive)
	{
		enemies_alive = false;
		
		for(i = 0; i < enemies.size; i ++)
		{
			if(IsDefined(enemies[i].fake_killed))
			{
//				enemies_alive = true;
			}
			else if(IsAlive(enemies[i]))
			{
				enemies_alive = true;
			}
		}
		
		wait(0.1);
	}
}

hero_attacks_enemy(enemies)
{
	self endon("death");
	level endon("end_rts");
	
	self.ignoreall = false;
	for(i=0;i<enemies.size;i++)
	{
		self shoot_and_kill(enemies[i]);
	}
	self.ignoreall = true;
}



/*------------------------------------
this causes the squad to move into pre-defined
positions before attacking the enemy
------------------------------------*/
does_enemy_have_color_trig(enemy)
{
	if(isDefined(enemy.script_string))
	{	
		return true;
	}
	return false;	
}



does_enemy_have_parameter_nodes(enemy)
{
	
	if(isDefined(enemy.script_parameters))
	{	
		return true;
	}
	return false;	
	
}


/*------------------------------------
this causes the squad to move into pre-defined
positions before attacking the enemy

is run when a player clicks direclty on an enemy
------------------------------------*/
activate_enemy_color_trig(enemies)
{
	level notify("stop_color_logic");	
	level endon("stop_color_logic");
	level endon("forced_prone");
	level endon("squad_detected");
	
	for(i=0;i<level.rts_heroes.size;i++)
	{
		level.rts_heroes[i] AllowedStances("crouch","stand");
	}
	
	
	trig = get_enemy_color_trigger(enemies[0]);
	trig.script_color_auto_disable = false;
	
	array_notify(level.rts_heroes,"new_pos");
	wait(.1);
	
	//trig = getent(enemies[0].script_string,"script_noteworthy");	
	array_func(level.rts_heroes,::enable_ai_color);
	trigger_use( trig.targetname );
	
	if(isDefined( level.rts_heroes[0].color_node))
	{
		node_check = level.rts_heroes[0].color_node;
	}
	else if (isDefined(level.rts_heroes[0].colored_ordered_node_assignment))
	{
		node_check = level.rts_heroes[0].colored_ordered_node_assignment;
	}
	else
	{
		node_check = trig;
	}
	
//	if(distancesquared( level.rts_heroes[0].origin,node_check.origin) > 256*256)
//	{
//
//		if( !isDefined(trig.script_string) )
//		{
//			do_random_ack_line();
//		}
//		wait(1);
//		array_wait(level.rts_heroes,"goal",10);	
//		add_dialogue_line("Squad","In position");
//		wait(1);
//	}
//	else
//	{	
	if(!isDefined(trig.script_string))
	{
		//do_random_enemy_line(enemies);
		do_random_contact_line();	
	}
	
	at_correctish_node = level.rts_heroes[0] am_i_at_a_correctish_node( node_check );
	
	if(distancesquared( level.rts_heroes[0].origin,node_check.origin) > 128*128 && !at_correctish_node)
	{	
		array_wait(level.rts_heroes,"goal",20);
	}
	else
	{
		array_wait(level.rts_heroes,"goal",2);
	}
	
	if( isDefined(trig.script_string) && trig.script_string == "no_attack_on_trigger")
	{
		return;
	}
		
	level thread heroes_attack_enemies(enemies);	
	wait_for_enemies_to_die(enemies);
	wait(2);
	level thread do_random_congrats();
	trig delete();
	
}

am_i_at_a_correctish_node( node )
{
	if(IsDefined(node.classname) && IsSubStr(node.classname, "trigger") )
	{
		return false; //-- a trigger is not a correctish node
	}
	
	if(IsDefined(self.node))
	{
		if(IsDefined(self.node.script_color_allies) && self.node.script_color_allies == node.script_color_allies)
		{
			return true;
		}
	}
	
	return false;
}

get_enemy_color_trigger(enemy)
{
	
	possible_trigs = StrTok(enemy.script_string,";");
	
	if(possible_trigs.size < 1)
	{
		return undefined;
	}
	
	if(possible_trigs.size == 1)
	{
		return getent(possible_trigs[0],"script_noteworthy");;
	}
	else
	{	
		trigs = [];
		for(i=0;i<possible_trigs.size;i++)
		{
			trigs[trigs.size] = getent(possible_trigs[i],"script_noteworthy");
		}		
		
		return GetClosest(average_origin(level.rts_heroes),trigs);
	}
	
}


/*------------------------------------
triggers that can be activated via tha SR71
------------------------------------*/
activate_color_trigger_from_sr71(cam)
{
	triggers = ent_array("sr71_color_triggers");
	other_triggers = GetEntArray("sr71_color_triggers", "script_noteworthy");
	triggers = array_combine(triggers, other_triggers);
	
	vec = vector_scale(AnglesToForward(cam.angles), 10000);
	trace = BulletTrace(cam.origin, cam.origin + vec, false, undefined);
	
	pos = trace["position"];
	test_ent = spawn("script_origin",pos + (0,0,10));	
	
	array_func(level.rts_heroes,::enable_ai_color);
	
	for ( i = 0; i < triggers.size; i++ )
	{
		if(test_ent istouching(triggers[i] ))
		{			
			triggers[i].script_color_auto_disable = false;	
			triggers[i] notify("trigger",get_players()[0]);
		}
	}
	test_ent delete();
	
}

is_in_playable_area(cam, in_vec)
{
	
	if(!IsDefined(level._cam_constraints))
	{
		level._cam_constraints = GetEntArray("sr71_cam_constraint", "targetname");
		max_height = getstruct("cam_max_height", "targetname");
		level._cam_height = max_height.origin[2];
		
		/#
/*		level.trace_max_length_hud_elem = newdebughudelem();
		level.trace_max_length_hud_elem.alignX = "center";
		level.trace_max_length_hud_elem.alignY = "middle";
		level.trace_max_length_hud_elem.horzAlign = "center";
		level.trace_max_length_hud_elem.vertAlign = "middle";
		level.trace_max_length_hud_elem.x = -100;
		level.trace_max_length_hud_elem.y = 0;
		level.trace_max_length_hud_elem.sort = 2;
		
		level.trace_length_hud_elem = newdebughudelem();
		level.trace_length_hud_elem.alignX = "center";
		level.trace_length_hud_elem.alignY = "middle";
		level.trace_length_hud_elem.horzAlign = "center";
		level.trace_length_hud_elem.vertAlign = "middle";
		level.trace_length_hud_elem.x = -100;
		level.trace_length_hud_elem.y = 16;
		level.trace_length_hud_elem.sort = 2;
		
		level.scalar_hud_elem = newdebughudelem();
		level.scalar_hud_elem.alignX = "center";
		level.scalar_hud_elem.alignY = "middle";
		level.scalar_hud_elem.horzAlign = "center";
		level.scalar_hud_elem.vertAlign = "middle";
		level.scalar_hud_elem.x = -100;
		level.scalar_hud_elem.y = 32;
		level.scalar_hud_elem.sort = 2;		*/
		#/
	}
	
	vec = vector_scale(AnglesToForward(cam.angles), 10000);

	// Get cam position on ground.
	if( !IsDefined( level.new_end_pos ) )
	{
		trace = BulletTrace(cam.origin, cam.origin + vec, false, undefined);
		start_pos = (trace["position"][0], trace["position"][1], level._cam_height);
	}
	else
	{
		start_pos = level.new_end_pos;
	}
	
	end_pos = start_pos + in_vec;

	Line(start_pos, end_pos, (1,0,0));

	trace = BulletTrace(start_pos, end_pos, false, undefined);
	
	while( trace["fraction"] != 1 )
	{
		solid_vec = end_pos - trace["position"];
		t = vectordot( solid_vec, trace["normal"] );

		push_out_dist = 1;
		end_pos = trace["position"] + solid_vec + trace["normal"] * (abs(t) + push_out_dist);
		
		trace = BulletTrace(trace["position"] + trace["normal"] * push_out_dist, end_pos, false, undefined);
		
		wait(0.05);
	}
	
	level.new_end_pos = end_pos;

	move_vec = end_pos - start_pos;

	return move_vec;
}

set_exclusive_area(name, key)
{
	if(IsDefined(key))
	{
		trigs = GetEntArray(name, key);
	}
	else
	{
		trigs = GetEntArray(name, "targetname");	
	}
	
	
	
	if(trigs.size == 0)
	{
		level._exclusive_area = undefined;
	}
	else
	{
		level._exclusive_area = trigs;
	}
}

clear_exclusive_area()
{
	level._exclusive_area = undefined;
}

is_in_exclusive_area(pos, cam)
{
	if(!IsDefined(level._exclusive_area))
	{
		return true;	// No exclusive area set 
	}
	
	angles	= cam.angles;
	forward = anglestoforward( angles );
	vec 		= vector_scale( forward, 10000 );
	
	trace = BulletTrace(pos, pos + vec, false, undefined);

	start = pos;	
	
	pos = trace["position"];

	if(!IsDefined(level.probe_model))
	{
		level.probe_model = Spawn("script_origin", pos + (0,0,10));
	}
	else
	{
		level.probe_model.origin = pos + (0,0,10);
	}
	
	for(i = 0; i < level._exclusive_area.size; i ++)
	{
		if(level.probe_model IsTouching(level._exclusive_area[i]))
		{	
			return(true);
		}
	}
	
	return false;
}

is_area_legal(pos, cam)
{
	triggers = ent_array("sr71_bad_places");
	
	if(!is_in_exclusive_area(pos, cam))
	{
		return false;
	}
	
	if(triggers.size == 0)
	{
		return true;
	}
	
	angles 					= cam.angles;
	forward 				= anglestoforward( angles );
	vec = vector_scale( forward, 10000 );
	
	trace = BulletTrace(pos, pos + vec, false, undefined);

	start = pos;	
	
	pos = trace["position"];

	if(!IsDefined(level.probe_model))
	{
		level.probe_model = Spawn("script_origin", pos + (0,0,10));
	}
	else
	{
		level.probe_model.origin = pos + (0,0,10);
	}
	
	for(i = 0; i < triggers.size; i ++)
	{
		if(level.probe_model IsTouching(triggers[i]))
		{
			if(IsDefined(triggers[i].script_noteworthy))
			{
				if(level flag_exists(triggers[i].script_noteworthy))
				{
					if(flag(triggers[i].script_noteworthy))
					{
						return(false);
					}
					else
					{
						return(true);
					}
				}
				else
				{
					PrintLn("*** Illegal place trigger needs flag " + triggers[i].script_noteworthy + " setup.");
					return(false);
				}
			}
			else
			{
				return(false);
			}
		}	
	}
	
	return(true);	
}

is_touching_color_trig(cam)
{
	triggers = ent_array("sr71_color_triggers");
	other_triggers = GetEntArray("sr71_color_triggers", "script_noteworthy");
	
	triggers = array_combine(triggers, other_triggers);
	
	//trace = bullettrace(cam.origin,cam.origin + (0,0,-100000),false,undefined);
	vec = vector_scale(AnglesToForward(cam.angles), 10000);
	trace = BulletTrace(cam.origin, cam.origin + vec, false, undefined);
	
	pos = trace["position"];
	test_ent = spawn("script_origin",pos + (0,0,10));

	ret = false;

	for ( i = 0; i < triggers.size; i++ )
	{
		if(test_ent istouching(triggers[i] ))
		{
			ret = true;
			break;
		}
	}
	
	test_ent delete();
	return ret;
	
}


create_enemy_hud_icon(enemy)
{
	player = get_players()[0];	
	elem = newclientHudElem( player );

	//elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.color = ( 1.0, 0, 0 );	
	elem.alpha = .8;	
	
	elem setshader("hud_sr71_camera_e_square");	
	elem SetTargetEnt( enemy );
	enemy waittill ("death");
	elem ClearTargetEnt();
	elem Destroy();	
}

create_friendly_hud_icon(hero,ui3d)
{
	player = get_players()[0];	
	elem = newClientHudElem(player);

	//elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.color = ( 0.2, 1, 0.2 );		
	elem.ui3dwindow = ui3d;
	elem.alpha = .85;
	
	elem setshader("hud_sr71_camera_diamond",10,10);
	elem SetTargetEnt( hero );
	hero waittill("death");
	elem ClearTargetEnt();
	elem Destroy();
	
}

create_friendly_waypoint(ui3d)
{
	
	level.squad_central = spawn("script_model",average_origin( level.rts_heroes));
	level.squad_central thread update_squad_position();	

	
	player = get_players()[0];	
	elem = newClientHudElem(player);

	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.color = ( 0.2, 1, 0.2 );		
	elem.ui3dwindow = ui3d;
	elem SetWayPoint( true );
	elem SetTargetEnt( level.squad_central);
	
	level waittill("end_rts");
	elem destroy();
	
}

create_enemy_waypoint(ent)
{
	
	model = spawn("script_model",ent.origin);
	model setmodel("tag_origin");
		
	player = get_players()[0];	
	elem = newClientHudElem(player);

	//elem.hidewheninmenu = true;
//	elem.horzAlign = "center";
//	elem.vertAlign = "middle";
//	elem.alignX = "center";
//	elem.alignY = "middle";
//	elem.x = 0;
//	elem.y = 0;
//	elem.foreground = true;
//	elem.color = ( 1, 0, 0 );		
//	elem.ui3dwindow = 1;
//	elem.alpha = .75;
//	
//	elem setshader("hud_sr71_camera_e_square",10,10);
//	elem SetTargetEnt( model );
	
	model.elem = elem;
	return model;
	
}


create_power_waypoint(ent)
{
	
	//add the objective
	objective_add(0, "current", "Disable the power grid", getent("blow_tower","targetname").origin);
	Objective_Set3D( 0, true, "ltblue","", 1 );
	
	
	player = get_players()[0];	
	elem = newClientHudElem(player);

	//elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.color = ( 1, 0, 0 );		
	elem.ui3dwindow = 1;
	elem.alpha = .85;
	
	elem setshader("hud_sr71_camera_e_square",10,10);
	elem SetTargetEnt( ent );
	
	flag_wait("power_grid_blown");
	elem ClearTargetEnt();
	elem Destroy();	
}

create_radar_waypoint(ent)
{	
	//add the objective
	//objective_add(7,"current","Disable enemy communications" ,getent("rts_radar","targetname").origin);
	//Objective_Set3D( 1, true, "default","", 1 );
	player = get_players()[0];	
	elem = newClientHudElem(player);

	//elem.hidewheninmenu = true;
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.color = ( 1, 0, 0 );		
	elem.ui3dwindow = 1;
	elem.alpha = .85;
	
	elem setshader("hud_sr71_camera_e_square",10,10);
	elem SetTargetEnt( ent );
	
	flag_wait("coms_tower_blown");
	elem ClearTargetEnt();
	elem Destroy();		
}


wait_for_squad_to_hide(elem,trig,model)
{
	level endon("end_rts");
	level endon("squad_detected");
	trig waittill("trigger");
	
//	IPrintLnBold("trigger!");
	
	while(1)
	{
		all_safe = true;
		for(i=0;i<level.rts_heroes.size;i++)
		{
			if(!level.rts_heroes[i] istouching(getent("squad_cover","targetname")))
			{
				all_safe = false;
			}
		}
		if(all_safe)
		{
	//		IPrintLn("All safe");
			break;
		}	
		wait(.1);	
	}	
	elem ClearTargetEnt();
	elem Destroy();	
	
	objective_state(1,"done");
	objective_delete(1);
	
	trig delete();
	model delete();
	flag_set("squad_hidden");	
}


create_camera_mark_effect(org,norm)
{
	marker = spawn("script_model",org);
	marker setmodel("tag_origin");
	marker.angles = norm;
	
	playfxontag(level._effect["rts_flare"],marker,"tag_origin");
	wait(3);
	marker delete();
}


create_squad_waypoint()
{
	level.squad_central = spawn("script_model",average_origin( level.rts_heroes));
	level.squad_central thread update_squad_position();	
	
	//add the objective
	objective_add(5,"current","" ,level.squad_central);
	Objective_Set3D( 5, true, "ltblue", &"WMD_SR71_SQUAD_LABEL", 1 );
	
	flag_wait("squad_located");
	
	objective_delete(5);
	
	player = get_players()[0];	
	elem = newClientHudElem(player);
	
	elem.horzAlign = "center";
	elem.vertAlign = "middle";
	elem.alignX = "center";
	elem.alignY = "middle";
	elem.x = 0;
	elem.y = 0;
	elem.foreground = true;
	elem.color = ( 0.2, 1, 0.2 );		
	elem.ui3dwindow = 1;
	elem.alpha = 1;
	
	//elem setshader("hud_sr71_camera_diamond",10,10);
	elem SetTargetEnt( level.squad_central);
	elem SetWaypoint(true);
	
	flag_wait("rts_objectives_done");
	
	objective_delete(5);//,"done","" ,level.squad_central);
}


update_squad_position()
{
	level endon("end_rts");
	level endon("squad_detected");
	
	while(1)
	{
		self.origin = average_origin(level.rts_heroes);
		wait(.05);
	}
}


create_camera_zoom_icon(ui3d)
{
	player = get_players()[0];	
	elem = newClientHudElem(player);
	elem.x = 85;
	elem.y = 35;
	elem.foreground = true;
	elem.color = ( 1, 1, 1 );
	elem.alpha = 1;		
	elem.ui3dwindow = ui3d;	
	elem setshader("hud_sr71_camera_arrow",25,25);
	player.camera_zoom_hud = elem;
	
	
}

set_camera_zoom_hud_percent(pcnt)
{
	player = get_players()[0];
	
	min_y = 35;
	max_y = 140;		
	player.camera_zoom_hud.y = min_y + max_y * pcnt;	
	
}




/*------------------------------------
set up the spotlights on the checkpoint guard tower
------------------------------------*/
init_checkpoint_spotlights()
{
	lights = getentarray("checkpoint_spotlight","targetname");
	array_thread (lights,::spotlight_search);
}

/*------------------------------------
Causes the spotlights to search from left to right

	self = the spotlight
------------------------------------*/
spotlight_search()
{
	self endon("stop_searchlight");
	level endon("end_rts");
	
	target = getent(self.target,"targetname");
	self SetTurretTargetEnt(target);
	//self thread wait_to_shut_off();
	//self.fx = spawn("script_model",self gettagorigin("tag_flash"));
	//self.fx.angles = self gettagangles("tag_flash");
	//self.fx linkto(self,"tag_flash");
	//self.fx setmodel("tag_origin");
	playfxontag(level._effect["spotlight_fx"],self,"tag_flash");
	point1 = getstruct(target.target,"targetname");
	point2 = getstruct(point1.target,"targetname");
	self thread can_see_squad();
	while(1)
	{
		target moveto(point1.origin,randomfloatrange(10,12),1,3);
		target waittill("movedone");
		wait(randomfloat(2));	
		target moveto(point2.origin,randomfloatrange(10,12),1,3);
		target waittill("movedone");
		wait(randomfloat(2));	
	}	
}


/*------------------------------------
triggers that can be activated via tha SR71 camera looking at it
------------------------------------*/
check_for_lookat_triggers()
{

	selected = undefined;
	triggers = ent_array("sr71_lookat_trigger");
	
	angles 					= self.angles;
	origin 					= self.origin;				
	forward 				= anglestoforward( angles );
	vec = vector_scale( forward, 10000 );
	
	trace = bullettrace(origin,origin + vec,false,undefined);
	org = trace["position"];

	ent = spawn("script_origin",org);
	
	for ( i = 0; i < triggers.size; i++ )
	{
		trigger 				= triggers[i];
		if( ent istouching(trigger))
		{
			trigger notify("trigger",get_players()[0]);			
		}
	}
	ent delete();
	
}



/*------------------------------------
checks to see if the player is looking at an enemy through the SR71 camera
------------------------------------*/
check_for_selected_target(cam,mark_targets,ender)
{
	level notify("stop_checking_targets");
	level endon("stop_checking_targets");
	level endon("squad_detected");
	level endon(ender);
	
	player = get_players()[0];
	reticule = ent_get("cam_reticule");
	
	reticule hide();
	reticule._hidden = true;
	
	set_enemy_reticule();
	
	while(1)
	{
		selected = undefined;
		enemies = getaiarray("axis");
		for ( i = 0; i < enemies.size; i++ )
		{
			enemy 					= enemies[i];
			angles 					= cam.angles;
			origin 					= cam.origin;				
			sight 					= anglestoforward( angles );
			vec_to_enemy  	= vectornormalize( enemy.origin - origin ); 
			
			if(IsDefined(enemy.dont_target) && enemy.dont_target)
			{
				continue;
			}
			
			//do we have an enemy centered in the sights?
			if( vectordot( sight, vec_to_enemy ) < .996 )
			{				
				continue;
			}
						
			selected = enemy;
			break;

		}
		if(!isDefined(selected))
		{
						
			if(!reticule._hidden)
			{
				//reticule hide();
				reset_friendly_reticule();
				set_enemy_reticule();
				//level hide_hud_prompt();
				level notify("stop_waiting");
				reticule._hidden = true;
			}
			
			
			friends = level.rts_heroes;
			for ( i = 0; i < friends.size; i++ )
			{
				friend 				= friends[i];
				angles 					= cam.angles;
				origin 					= cam.origin;				
				sight 					= anglestoforward( angles );
				vec_to_friend  	= vectornormalize( friend.origin - origin ); 
			
				//do we have a friendly centered in the sights?
				if( vectordot( sight, vec_to_friend ) < .996 )
				{				
					continue;
				}
						
				selected = friend;
				break;

			}
					
			if(isDefined(selected))
			{
				if(!flag("squad_located") && flag("locate_squad"))
				{
					flag_set("squad_located");
				}
				set_friendly_reticule();
			}
			else
			{
				reset_friendly_reticule();
			}
		}
		else
		{
			if(!isDefined(selected.no_target_dialog))
			{
				enemies = get_targeted_ai(selected);
				//level thread do_random_enemy_line(enemies);
			}
			
			//show the 'target' reticule so the player gets some feedback about highlighting enemies
			if(reticule._hidden)
			{
				reset_enemy_reticule();
				reset_friendly_reticule();
				//reticule show();
				screen = ent_get("sr71_cam");
				screen playsound("evt_sr71_camera_highlight");
				level notify("enemy_spotted");
				if(mark_targets)
				{
					level thread wait_for_player_to_mark_enemy(selected,screen);
				}
				reticule._hidden = false;
			}
		}
		wait(.05);
	}	
}


setup_flashlight(time)
{
	if(isDefined(time))
	{
		wait(time);
	}

	playfxontag(level._effect["flashlight"], self, "J_wrist_LE");

}


#using_animtree("generic_human");
house_breach_1()
{
	level endon("stop_house_breach");
	
	/*
	while(!flag("first_patrol_clear"))
	{
		trigger_wait("rts_house_breach","targetname");	
	}
	*/
	
	flag_wait("first_patrol_clear");
	array_notify(level.rts_house_guys,"no_detect");
		
	level thread garage_fps();
		
	level house_breach_dialogue();
}


garage_waittill_goal_start()
{
	level endon("squad_detected");
	
	//-- needs to keep the garage event from starting if the player
	// makes the squad go prone.
	while(1)
	{
		//-- if half of the squad is near their assigned color nodes, then start the breach
		num_squad_in_position = 0;
		
		for( i = 0; i < level.rts_heroes.size; i++ )
		{
			if(IsDefined(level.rts_heroes[i].color_node))
			{
				if(DistanceSquared(flat_origin(level.rts_heroes[i].origin), flat_origin(level.rts_heroes[i].color_node.origin)) < 64*64)
				{
					num_squad_in_position++;
					continue;
				}
			}
			
			if(IsDefined(level.rts_heroes[i].color_ordered_node_assignment))
			{
				if(DistanceSquared(flat_origin(level.rts_heroes[i].origin), flat_origin(level.rts_heroes[i].color_ordered_node_assignment.origin)) < 64*64)
				{
					num_squad_in_position++;
					continue;
				}
			}
		}
		
		if(num_squad_in_position >= level.rts_heroes.size - 1)
		{
			break;
		}
		
		array_wait_any(level.rts_heroes,"goal");
	}
	
	flag_set("garage_fps");
	
	flag_wait("garage_fps_done");
	
	//final_struct = getstruct("final_objective", "targetname");
	//Objective_Add(7, "current", &"WMD_SR71_GUIDE_KILO_TO_INSERTION_POINT", final_struc);
	//Objective_Set3D(7, true, "default", &"WMD_SR71_INSERTION_POINT",1);	
	
	level thread breadcrumb_markers();
	level thread vo_post_barracks();
	
	//autosave_by_name("wmd_rts_post_garage");
	
	flag_wait("second_patrol_evaded");
	
	do_rts_cleanup();

	//hide_hud_prompt();
	//Objective_Set3D(7, 0);
	
	flag_set("rts_done");
		
	level notify("rts_over");
}


vo_post_barracks()
{
	operator = get_operator_ent();
	
	wait(0.5);

	level.vo_playing = true;
	operator anim_single(operator, "move_north");	//Kilo move north.
	level.vo_playing = false;
}


breadcrumb_markers()
{
	waittillframeend;
	ent = GetEnt("first_breadcrumb", "targetname");
	
	Objective_Add(7, "current", &"WMD_SR71_GUIDE_KILO_TO_INSERTION_POINT");
		
	obj = ent;
		
	Objective_Position(7, obj.origin);
	level thread squad_dist_objective(obj, 7);
		
	trigger_wait("first_breadcrumb");
		
	obj delete();
		
	obj = GetEnt("second_breadcrumb", "targetname");
		
	Objective_Position(7, obj.origin);
	level thread squad_dist_objective(obj, 7);
}


house_breach_dialogue()
{
	level endon("squad_detected");
	
	trigger_wait("trigger_approach_barracks");
	
	hudson = get_hudson_ent();
	operator = get_operator_ent();

	level.vo_playing = true;
	operator anim_single(operator, "barracks_breach");	// Coming up on the barracks...
	level.vo_playing = false;
	
	wait(0.5);
	
	level.vo_playing = true;
	hudson anim_single(hudson, "barracks_going_in");	// Copy that, Bigeye.
	level.vo_playing = false;
		
	//wait(0.5);
	
	//operator anim_single(operator, "multiple_targets");	// multiple targets, engage the enemy.
	
	level thread garage_waittill_goal_start();	// starts fps
}


get_guy_at_node(node_targetname)
{
	for(i=0;i<level.rts_heroes.size;i++)
	{
	
		if(isDefined( level.rts_heroes[i].color_node))
		{
			if( isDefined(level.rts_heroes[i].color_node.targetname) && level.rts_heroes[i].color_node.targetname == node_targetname)
			{
				return level.rts_heroes[i];
			}
		}
		else if (isDefined(level.rts_heroes[0].colored_ordered_node_assignment))
		{
			if( isDefined(level.rts_heroes[0].colored_ordered_node_assignment.targetname) && level.rts_heroes[0].colored_ordered_node_assignment.targetname == node_targetname)
			{
				return level.rts_heroes[i];
			}
		}

	}
	return undefined;
	//iprintlnbold("NO GUY WAS FOUND AT NODE: " + node_targetname );	
}


do_custom_muzzleflash(guy)
{
	guy endon("death");
	guy endon("fake_death");
	
	while(1)
	{
		guy waittill("fire");
		playfxontag(level._effect["custom_tracer"] ,guy,"tag_flash");
	}
}



/*------------------------------------
creates a hud prompt for the player
self = LEVEL
------------------------------------*/
exit_hud_prompt()
{
	
	//level thread wait_for_exit();
	prompt = newClientHudElem( get_players()[0] );

	x_offset = -200;
	y_offset = -200;

	font_scale = 1.6;
	
	prompt.x = x_offset;
	prompt.y = y_offset;
	prompt.alignX = "center";
	prompt.alignY = "middle";
	prompt.horzAlign = "center";
	prompt.vertAlign = "middle";
	prompt.fontScale = font_scale;
	prompt settext(&"WMD_SR71_EXIT_SR71");
	prompt.alpha = 1;
	flag_wait("rts_done");
	prompt destroy();
}

wait_for_exit()
{
//	level endon("rts_over");
//	
//	player = get_players()[0];
//	
//	while(1)
//	{
//		if(player usebuttonpressed() && player secondaryoffhandbuttonpressed() )
//		{
//			break;
//		}
//		wait(.05);
//	}
//	
//	do_rts_cleanup();
//	
////	iprintlnbold("Exiting RSO sequence ");
//	//wait(1);
//	//hide_hud_prompt();
//	flag_set("rts_done");
//	level notify("stop_house_breach");

}


do_rts_cleanup()
{
	//ends the targeting/camera mechanics
	level notify("end_rts");
	
	//delete any axis 
	axis = getaiarray("axis");
	for(i=0;i<axis.size;i++)
	{
		axis[i] delete();
	}
	
	//delete the searchlights
	lights = getentarray("checkpoint_spotlight","targetname");
	for(i=0;i<lights.size;i++)
	{
		lights[i] delete();
	}
	
	//delete any stray vehicles 
	vehicles = getentarray("script_vehicle","classname");
	for(i=0;i<vehicles.size;i++)
	{
		if(isDefined(vehicles[i].script_string ) && vehicles[i].script_string == "rts_vehicle")
		{
			vehicles[i] delete();
		}
	}	
	
	//turn off the extracam
	disable_extra_cam();
	
	//delete the camera completely
	cam = ent_get("rts_extracam");
	cam delete();
	
	//delete the heroes
	for(i=0;i<level.rts_heroes.size;i++)
	{
		level.rts_heroes[i] delete();		
	}
	
	player = get_players()[0];
	
	//delete some hud stuff
	player.camera_zoom_hud destroy();		
	flag_set("rts_objectives_done");
	flag_set("coms_tower_blown");
	
	level.is_in_rts = undefined;
	
	
	//kill any looping sounds
	level.move_x_ent delete();
	level.move_y_ent delete();
	level.move_in_ent delete();
	level.move_out_ent delete();
	clientnotify("end_rts");
	
	
	//reset objective draw distance
	
	player setclientdvar("cg_objectiveIndicatorFarFadeDist",level._old_drawdist);
	
	objective_delete(0);
	objective_delete(1);
	objective_delete(2);
	objective_delete(3);
	objective_delete(4);	
	objective_delete(5);
	objective_delete(6);	
	objective_delete(7);
	
	//delete the spinngy radar dish
	//dish = getent("rts_radar","targetname");	
	//dish delete();	
	
	player AllowCrouch( true );
	player AllowProne( true );
	player AllowStand(true);
}


center_test()
{
	prompt = newClientHudElem( get_players()[0] );

	x_offset = 0;
	y_offset = 0;

	font_scale = 1.6;
	
	prompt.x = x_offset;
	prompt.y = y_offset;
	prompt.alignX = "center";
	prompt.alignY = "middle";
	prompt.horzAlign = "center";
	prompt.vertAlign = "middle";
	prompt.fontScale = font_scale;
	prompt setshader("hud_sr71_camera_diamond",10,10);
	
	prompt.alpha = 1;
}


is_in_fov(guy,cam)
{
	
	if ( within_fov( cam.origin, cam.angles, guy.origin, cos( cam.cur_fov ) ) )
	{
			//iprintlnbold("in fov");
	}	
}


can_see_squad()
{
	
	level endon("end_rts");
	level endon("squad_detected");
	
	spotlight_len = 1000;
	enemies = level.rts_heroes;
	
	while(1)
	{
		
		seen = undefined;
		for ( i = 0; i < enemies.size; i++ )
		{
			enemy 					= enemies[i];
			angles 					= self gettagangles("tag_flash");
			origin 					= self.origin;				
			sight 					= anglestoforward( angles );
			vec_to_enemy  	= vectornormalize( enemy.origin - origin );
			
			//do we have an enemy centered in the sights?
			if( vectordot( sight, vec_to_enemy ) < .93  )
			{								
				continue;
			}
			else
			{
				if(distance(self.origin,enemies[i].origin) < spotlight_len)
				{			
					seen = enemies[i];
				}
			}
		}
		
		if(isDefined(seen))
		{
			break;
		}
		
		wait(.1);
	}
	
	self notify("stop_searchlight");
	self SetTurretTargetEnt(seen);
	
	add_spawn_function_veh("rts_flare_vehicles",::flare_fx);

	trigger_use("spawn_flares");	
	
	//iprintlnbold("Squad Detected!");
	//iprintlnbold("Keep the squad out of the searchlights");
	wait(5);
	MissionFailed();	
}


detect_squad(dist)
{
	
	level endon("end_rts");
	self endon("death");
	self endon("no_detect");
	level endon("no_detect");
	level endon("squad_detected");
	
	
	detec_len = 500;
	if(isDefined(dist))
	{
		detec_len = dist;
	}
	enemies = level.rts_heroes;
	
	while(1)
	{
		
		seen = undefined;
		for ( i = 0; i < enemies.size; i++ )
		{
						
			enemy 					= enemies[i];

			angles = self.angles;

			origin 					= self.origin;				
			sight 					= anglestoforward( angles );
			vec_to_enemy  	= vectornormalize( enemy.origin - origin );
			
								
			if(self istouching(getent("squad_cover","targetname")) && enemies[i] istouching(getent("squad_cover","targetname")))
			{
				seen = enemy;
			}			
			
			//do we have an enemy centered in the sights?
			if( vectordot( sight, vec_to_enemy ) < .85 && !isDefined(seen))
			{								
				continue;
			}
			else
			{
				if( distance(self.origin,enemies[i].origin) < detec_len && !isDefined(seen))
				{
					if(  SightTracePassed(self gettagorigin( "tag_eye" ) , enemy gettagorigin( "tag_eye" ) , false, undefined ))
					{				
						seen = enemies[i];
					}
				}
			}
		}
		
		if(isDefined(seen))
		{
			break;
		}	
		
		wait(.1);
	}
	
	axis = [];
	axis[0] = self;
	
	self notify("enemy");
	self alert_notify_wrapper();
	if(!flag("squad_detected"))
	{
		death_quote = &"WMD_SR71_TARGET_ENEMY";
		level thread kill_rts_squad(undefined, death_quote);
	}

}

squad_detection_logic(axis)
{
	flag_wait("squad_detected");

	add_dialogue_line("Squad","We're spotted...open fire!");
	wait(1);
	if(!isDefined(level.heroes_attacking))
	{
		level.heroes_attacking = 1;
		heroes_attack_enemies(axis,1);	
		level.heroes_attacking = undefined;
	}
	flag_clear("squad_detected");
	//IPrintLnBold("Squad undetected.");
}




flare_fx()
{
	playfxontag(level._effect["rts_flare"],self,"tag_origin");
	
}

blood_splatter_enhancement()
{
	self endon("death");
	self endon("fake_death");
	while(1)
	{
		self waittill("damage");
		
		tags = [];
		tags[0] = "j_hip_le";
		tags[1] = "j_hip_ri";
		tags[2] = "j_head";
		tags[3] = "j_spine4";
		tags[4] = "j_elbow_le";
		tags[5] = "j_elbow_ri";
		tags[6] = "j_clavicle_le";
		tags[7] = "j_clavicle_ri";
	
		for( i = 0; i < 2; i++ )
		{
			random = RandomIntRange( 0, tags.size );
			self thread bloody_death_fx( tags[random], level._effect["rts_bloodsplatter"] );
			wait( RandomFloat( 0.1 ) );
		}
	}
}


vehicle_spawn_stuff()
{
	node = GetVehicleNode("e5_jet1","targetname");
	f4EasyRhino = SpawnVehicle("t5_veh_jet_f4", "e5EasyRhino", "plane_phantom", node.origin, (0,0,0));
	f4EasyRhino thread go_path( node );

}


do_spotlight_warning()
{
	level endon("end_rts");
	
	flag_wait("move_squad");
	
	trigger_wait("spotlight_warning","script_noteworthy");

	pilot = get_pilot_ent();	
	
	pilot anim_single(pilot, "128A_usc1_f");//	C.P.the main entrance is too hot. Find another way in. Watch those searchlights.
	
	while(1)
	{
		touching = false;
		for(i=0;i<level.rts_heroes.size;i++)
		{
			if(level.rts_heroes[i] istouching( getent("spotlight_warning","script_noteworthy")))
			{
				touching = true;
			}
		}
		
		if(touching)
		{
			if(randomint(100) > 50)
			{
				pilot anim_single(pilot, "129A_usc1_f");//	Kilo needs to get off the road. Find another way into the base. Keep them away from the searchlights.
			}
			else
			{
				pilot anim_single(pilot, "128A_usc1_f");//	C.P.the main entrance is too hot. Find another way in. Watch those searchlights.
			}
			wait(10);			
		}
		wait(.05);
	}	
	
}

do_squad_warning()
{
	
}




/*------------------------------------
sleeping guys
------------------------------------*/
#using_animtree("generic_human");

// Spawn a drone AI who can be animated
#using_animtree ("generic_human");

set_explosion_deathanim()
{
	anims = array(%death_explosion_back13,%death_explosion_forward13,%death_explosion_left11,%death_explosion_right13);
	self.deathanim = random(anims);
}

restore_rso_focus()
{
	reset_rso_focus();
	wait_network_frame();
	init_rso_focus();		
}

rts_on_save_restored()
{
	ClientNotify("end_rts");
	if(isDefined(level.is_in_rts))
	{
		disable_extra_cam();
		wait(.1);
		enable_extra_cam();
		level thread restore_rso_focus();
			
		level thread restore_fov();
	}
	
	SetDvar("wmd_rts_achievement", 0 ); //-- the achievement is now failed
}

restore_fov()
{
	player = get_players()[0];
	player setClientDvar( "cg_fov", 45 );
	level ClientNotify("update_rts_fov");
}

switch_test()
{

	if(!IsDefined(level._switch_pos))
	{
		level._switch_pos = "cockpit";
	}

	while(1)
	{
		
		while( !get_players()[0] buttonpressed("BUTTON_LSHLDR") )
		{
			wait(0.05);
		}	
		
		if(level._switch_pos == "cockpit")
		{
			level._switch_pos = "ground";
			switch_from_cockpit_to_ground("test");
		}
		else
		{
			level._switch_pos = "cockpit";
			switch_from_ground_to_cockpit();
		}
		
		while( get_players()[0] buttonpressed("BUTTON_LSHLDR") )
		{
			wait(0.05);
		}	
		
	}	
}

switch_from_cockpit_to_ground(name)
{
//	IPrintLnBold("Going to ground.");
	player_on_ground(name);
}

switch_from_ground_to_cockpit()
{
//	IPrintLnBold("Going to cockpit.");
	player_in_cockpit();
}

audio_play_wind_howling()
{
    harris_door_pos = (-93767, 95793, 60.9);
    player_door_pos = (-94304, 95603, 62.5);
    end_door_pos    = (-92781, 95164, 11.3);
    
    sound_ent1 = Spawn( "script_origin", player_door_pos );
    sound_ent2 = Spawn( "script_origin", harris_door_pos );
    sound_ent3 = Spawn( "script_origin", end_door_pos );
    
    sound_ent1 PlayLoopSound( "amb_wind_window_gusts", .25 );
    sound_ent2 PlayLoopSound( "amb_wind_window_gusts", .25 );
    sound_ent3 PlayLoopSound( "amb_wind_window_gusts", .25 );
    
    level waittill( "audio_stop_single_gust" );
    
    sound_ent1 StopLoopSound( .5 );
    
    level waittill( "audio_turn_off_wind_loopers" );
    
    wait(2);
    
    sound_ent1 Delete();
    sound_ent2 Delete();
    sound_ent3 Delete();
}
 