#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\wmd_util;


main()
{
	precache_player_anims();
	precache_level_anims();
	precache_patrol_anims();
	init_vehicle_anims();
	// sr71_intro_sounds();
	rappel();
}

#using_animtree("wmd");
precache_player_anims()
{
	//knife throw after breach
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_animtree["player_body"] = #animtree;

	level.scr_model["player_hands" ] = "t5_gfl_m16a1_viewmodel_player";
	level.scr_animtree[ "player_hands" ] = #animtree;

	level.scr_model["rappel_rope"] = "anim_rus_rappel_rope";
	level.scr_animtree["rappel_rope"] = #animtree;
	
	level.scr_model["rope1"] = "anim_rus_rappel_rope";
	level.scr_animtree["rope1"] = #animtree;
	
	level.scr_model["rope2"] = "anim_rus_rappel_rope";
	level.scr_animtree["rope2"] = #animtree;
	
	level.scr_model["weaver_rope"] = "anim_jun_rappel_rope";
	level.scr_animtree["weaver_rope"] = #animtree;

	level.scr_animtree["door"] = #animtree;
	level.scr_anim["door"]["knife_throw"] = %ch_wmd_b01_knifethrow_door;
	
	// garage door
	level.scr_anim["door"]["garage_leadin"] = %ch_wmd_b01_grdsopengarage_door_leadin;
	level.scr_anim["door"]["garage_loop"][0] = %ch_wmd_b01_grdsopengarage_door_loop;
	
	//free fall anims
	level.scr_anim[ "player_hands" ][ "first_frame_fall" ] = %int_base_jump_freefall_loop;
	level.scr_anim[ "player_hands" ][ "fall_loop" ][0] = %int_base_jump_freefall_loop;
	level.scr_anim[ "player_hands" ][ "fall_left" ][0] = %int_base_jump_freefall_turnleft;
	level.scr_anim[ "player_hands" ][ "fall_right" ][0] = %int_base_jump_freefall_turnright;
	level.scr_anim[ "player_hands" ][ "fall_intro" ] = %int_base_jump_freefall_intro;
	
	level.scr_anim[ "player_hands" ][ "pull_cord" ] = %int_base_jump_cord_pull;
	level.scr_anim[ "player_hands" ][ "fall_land" ] = %int_base_jump_land;
	
	//chute pulled anims
	level.scr_anim[ "player_hands" ][ "chute_loop" ][0] = %int_base_jump_chuteopen_loop;
	level.scr_anim[ "player_hands" ][ "chute_left" ][0] = %int_base_jump_chuteopen_turnleft;
	level.scr_anim[ "player_hands" ][ "chute_right" ][0] = %int_base_jump_chuteopen_turnright;	
	
	
	//player freefall anims after chute deploy
	level.scr_anim["player_chuteopen_loop"] = %int_base_jump_chuteopen_loop;
	level.scr_anim["player_chuteopen_left"] = %int_base_jump_chuteopen_turnleft;
	level.scr_anim["player_chuteopen_right"] = %int_base_jump_chuteopen_turnright;
	
	//player freefall anims before chute deploy
	level.scr_anim["player_fall_loop"] = %int_base_jump_freefall_loop;
	level.scr_anim["player_fall_left"] = %int_base_jump_freefall_turnleft;
	level.scr_anim["player_fall_right"] = %int_base_jump_freefall_turnright;
		
	//ice scraping stuff
	level.scr_anim["gascan"]["fueler_leadin"] = %ch_wmd_b01_icescraping_gascan_leadin;
	level.scr_anim["gascan"]["fueler_loop"][0] = %ch_wmd_b01_icescraping_gascan_loop;
	level.scr_animtree["gascan"] = #animtree;
	level.scr_anim["icescraper"]["scrape_loop"][0] = %ch_wmd_b01_icescraping_icescraper_loop;
	level.scr_animtree["icescraper"] = #animtree;
	
	//shovel for shoveling guys
	level.scr_anim["shovel01"]["shoveling"][0] = %ch_wmd_b01_grdshoveling_shovel01;
	level.scr_animtree["shovel01"] = #animtree;
	
	level.scr_anim["shovel02"]["shoveling"][0] = %ch_wmd_b01_grdshoveling_shovel02;
	level.scr_animtree["shovel02"] = #animtree;
	
	//power station door
	level.scr_anim["pwr_door"]["reunited"]= %ch_wmd_b01_squadregroup02_door;
	level.scr_animtree["pwr_door"] = #animtree;
	
	//chair for card playing reaction guy
	level.scr_anim["chair01"]["breach_loop"][0] =%ch_wmd_b01_rappelbreach_deskreact_loop_chair;
	level.scr_anim["chair01"]["react1"] =  %ch_wmd_b01_rappelbreach_deskreact_react_chair;
	level.scr_animtree["chair01"] = #animtree;
	
	//chair for non-card-playing reaction guy
	level.scr_anim["chair02"]["breach_loop02"][0] =%ch_wmd_b01_rappelbreach_deskreact_loop_chair;
	level.scr_anim["chair02"]["react02"] =%ch_wmd_b01_rappelbreach_deskreact_react_chair;
	level.scr_animtree["chair02"] = #animtree;
	
	level.scr_anim["axe"]["chop"][0] =%ch_wmd_b01_woodchoppers_axe;
	level.scr_animtree["axe"] = #animtree;
	
	level.scr_anim["wood01"]["chop"][0] =%ch_wmd_b01_woodchoppers_wood01;
	level.scr_animtree["wood01"] = #animtree;
	level.scr_anim["wood02"]["chop"][0] =%ch_wmd_b01_woodchoppers_wood02;
	level.scr_animtree["wood02"] = #animtree;

	level.scr_anim["barrel"]["cig_break"] = %p_wmd_b01_cigbreak_barrel;
	
	//level.scr_anim["player_body"]["throwpack"] = %ch_wmd_b01_barnesthrowspack_player;
	//level.scr_anim["pack"]["throwpack"] = %ch_wmd_b01_barnesthrowspack_pack;
	
	level.scr_anim["ai_chute"]["chute_loop"][0] = %ch_wmd_b01_freefall_chutefloat_chute;
	level.scr_anim["ai_chute"]["chute_float"][0] = %ch_wmd_b01_freefall_chutefloat_chute;
	level.scr_anim["ai_chute"]["pull_chute"] = %ch_wmd_b01_freefall_chutepull_chute;
	addNotetrack_customFunction("ai_chute","pull", ::pull_chute, "pull_chute");

	//level.scr_anim["ai_chute"]["pierro_landing"] = %ch_wmd_b01_freefall_land_chute01;
	//level.scr_anim["ai_chute"]["kristina_landing"] = %ch_wmd_b01_freefall_land_chute02;

	//snow ambush
	// level.scr_anim["player_body"]["ambush_idle"][0] = %ch_wmd_b01_ambush_idle_player;
	// level.scr_anim["player_body"]["ambush"] = %ch_wmd_b01_ambush_player;
	//addNOtetrack_customFunction("player_body","start_squad_ambush",::start_squad_ambush,"ambush");

			
	//player rappel
	level.scr_anim["player_body"]["rappel_hookup"]					= %int_rappel_hookup;
	addNotetrack_customFunction("player_body", "rumble1", ::rumble_on_hookup, "rappel_hookup");
		
	level.scr_anim["player_body"]["player_rappel_idle"][0]			= %int_rappel_idle;
	level.scr_anim["player_body"]["player_rappel_loop"][0]			= %int_rappel_loop;
	
	level.scr_anim["player_body"]["player_rappel_compress"]			= %int_rappel_compress;
	level.scr_anim["player_body"]["player_rappel_compress_loop"][0]	= %int_rappel_compress_loop;
	level.scr_anim["player_body"]["player_rappel_kickoff"]			= %int_rappel_kickoff;
	level.scr_anim["player_body"]["player_rappel_brake"]			= %int_rappel_brake;
	level.scr_anim["player_body"]["player_rappel_brake_loop"][0]	= %int_rappel_brake_loop;
	level.scr_anim["player_body"]["player_rappel_brake_succeed"]	= %int_rappel_brake_succeed;
	level.scr_anim["player_body"]["player_rappel_2_fall"]			= %int_rappel_2_fall;
	level.scr_anim["player_body"]["player_rappel_fall_loop"][0]		= %int_rappel_fall_loop;
	level.scr_anim["player_body"]["player_rappel_fall_hit_a"]		= %int_rappel_fall_hit_a;
	level.scr_anim["player_body"]["player_rappel_land"]				= %ch_wmd_b01_player_control_rappel_land;

	level.scr_anim["player_body"]["player_breach_hookup"] = %ch_wmd_b01_rappel_playerBreach_hookup;	

	level.scr_anim["player_body"]["breach"]= %ch_wmd_b01_rappel_playerBreach;
	level.scr_anim["player_body"]["breach_idle"][0]= %ch_wmd_b01_rappel_playerBreach_idle;
	addNotetrack_customFunction("player_body","breach", ::player_breach_into_room, "breach");
	
	// level.scr_anim["box"]["loading_intro"] = %p_wmd_b01_loading_boxes_intro_box;
	// level.scr_anim["box"]["loading_loop"][0] = %p_wmd_b01_loading_boxes_loop_box;
	
	//missile launch
	// level.scr_anim["sam"]["missile_react"] = %p_wmd_b01_missle_react_missle;
	
	
	//sabotage control panel
	level.scr_anim["player_sabotage_hands"]["sabotage"] = %ch_wmd_b01_sabotage_player;
	level.scr_model["player_sabotage_hands"] = "t5_gfl_m16a1_viewmodel_player";
	level.scr_animtree["player_sabotage_hands"] = #animtree;
	
	level.scr_anim["sabotage_wires"]["sabotage"] = %p_wmd_b01_sabotage_wires;
	
	addNotetrack_customFunction("player_sabotage_hands","glass break", ::sabotage_glass_break, "sabotage" );


	//snow hide
	level.scr_anim["player_body"]["hide_idle"][0] = %ch_wmd_b01_hideinsnow_idle_player;
	level.scr_anim["player_body"]["hide_rise"] = %ch_wmd_b01_hideinsnow_rise_player;
	level.scr_anim["player_body"]["reach"] = %ch_wmd_b01_hideinsnow_reach_player;
	level.scr_anim["player_body"]["reach_idle"][0] = %ch_wmd_b01_hideinsnow_reachIdle_player;
	
	//player window breach
	level.scr_anim["player_body"]["player_window_idle"][0] = %ch_wmd_b01_playerRappelBreach_idle_player;
	
	level.scr_anim["player_body"]["player_window_hookup"] = %ch_wmd_b01_playerRappelBreach_hookup_player;
	addNotetrack_customFunction("player_body","rumble1", ::rumble_on_hookup, "player_window_hookup");
	
	level.scr_anim["player_body"]["player_window_breach"] = %ch_wmd_b01_playerRappelBreach_player;
	addNotetrack_customFunction("player_body","shatter", ::player_breach_into_room, "player_window_breach");
	addNotetrack_customFunction("player_body","rumble1", ::rumble_on_breach, "player_window_breach");
	
	//wheelbarrow
	level.scr_anim["wheelbarrow"]["barrow_idle"][0] = %p_wmd_b01_woodchoppers_barrow;
	level.scr_anim["wheelbarrow"]["barrow_death"] = %p_wmd_b01_woodchoppers_death_barrow;
	level.scr_animtree["wheelbarrow"] = #animtree;
	
	// ledge fall
	level.scr_anim[ "player_body" ][ "player_ledge_fall" ] = %ch_wmd_b01_catwalk_collapse_death_player;
	
	// base street truck explosion
	level.scr_anim[ "base_street_truck" ][ "street_block" ] = %fxanim_wmd_truck_flip_anim;
	level.scr_animtree[ "base_street_truck" ] = #animtree;
	
	// avalanche surfing russian truck
	level.scr_anim[ "surfing_truck" ][ "avalanche_surf" ] = %fxanim_wmd_avalanche_truck_anim;
	level.scr_animtree[ "surfing_truck" ] = #animtree;
	
	//truck mount
	level.scr_anim[ "player_hands" ][ "mount_truck" ] = %ch_wmd_b05_player_mount_gaz;
}


rumble_on_hookup(guy)
{
	get_players()[0] PlayRumbleOnEntity("damage_light");
}


rumble_on_breach(guy)
{
	get_players()[0] PlayRumbleOnEntity("damage_light");
}


space_snap2sr71(guy)
{
	//sic - sets up the snapshot to inside the sr71
     clientnotify("sic");
}

space2backin(guy)
{
     clientnotify("space_backin");
}

pull_chute(chute)
{
	//iprintlnbold("woohoo");
	if(isDefined(chute.veh))
	{
		chute.veh setspeedImmediate(15);
	}
	chute show();
}


weaver_knife_attach(guy)
{
	level.weaver Attach("weapon_parabolic_knife", "tag_inhand");
}


weaver_knife_detach(guy)
{
	level.weaver Detach("weapon_parabolic_knife", "tag_inhand");
}


repel_shatter_guy01(guy)
{
	players = get_players();
	//players[0] playsound("dst_glass_radar_pane_break");
	//exploder(200);
	tag = GetEnt( "window1_fx", "targetname" );
	PlayFXOnTag(	level._effect["glass_break"] ,tag,"tag_origin");
	tag playsound("evt_window_smash_1");
	clientNotify("window_1");
	
	//magicbullet("famas_sp", tag.origin, tag.origin + (0,200,0) );	//shatter glass
	
	RadiusDamage(tag.origin, 100, 300, 300);
	
	guy set_force_color("r");	//brooks
}

repel_shatter_guy02(guy)
{
	players = get_players();
	//players[0] playsound("dst_glass_radar_pane_break");
	tag = GetEnt( "window2_fx", "targetname" );
	tag playsound("evt_window_smash_2");
	PlayFXOnTag(	level._effect["glass_break"] ,tag,"tag_origin");
	
	//kill the enemy thats getting kicked
//	russ02 = maps\wmd_util::getai_by_noteworthy("russ02");
//	russ02 StartRagDoll();
//	russ02 LaunchRagdoll( (0,128, 0) );
//	russ02 dodamage (russ02.health*10, russ02.origin);

	//exploder(201); glass_break
	
	clientNotify("window_2");
	
	//magicbullet("famas_sp", tag.origin, tag.origin + (0,200,0) );	//shatter glass
	
	RadiusDamage(tag.origin, 100, 300, 300);
	
	//fx for room
	exploder(90);
	
	guy set_force_color("r");//harris
}	

//repel_shatter_guy03(guy)
//{
//	players = get_players();
//	players[0] playsound("dst_glass_radar_pane_break");
//	exploder(202);
//	clientNotify("window_3");
//	
//	guy set_force_color("b");
//	
//}	

player_breach_into_room(guy)
{
	flag_set( "window_breached" );
	
	level thread maps\wmd_snow_hide::papers_please();
	playsoundatposition ("evt_win_breach_glass_shatter", (0,0,0));
	
	ent = getent("power_window_shatter","targetname");
	window = getstruct( "weaver_window_break", "targetname" );
	
	clientnotify ("breach_window_break");
	
	radiusdamage(ent.origin,16,150,150);
	radiusdamage(window.origin,16,150,150);
	
	player = get_players()[0];
	player disableweapons();
	wait(.25);
	player setviewmodel(level.player_viewmodel);
	player enableweapons();
	player AllowAds(true);			
}


weaver_breach_into_room(guy)
{
	level thread window2_damaged();
	
	solid2 = getent( "breach_window_solid_2", "targetname" );
	cracked2 = getent( "breach_window_cracked_2", "targetname" );
	damaged2 = getent( "breach_window_damaged_2", "targetname" );
	phy_weaver = getstruct( "weaver_physics_blast", "targetname" );
	glass2 = getent( "tag_glass_break2", "targetname" );
	
	if ( isdefined( solid2 ) )
	{
		solid2 delete();
	}
	if ( isdefined( cracked2 ) )
	{
		cracked2 delete();
	}
	
	damaged2 show();
	
	PhysicsExplosionSphere( phy_weaver.origin, 100, 100, 0.6 );
	playfxontag( level._effect["glass_break"], glass2, "tag_origin" );
	
	level.weaver gun_recall();
}


window2_damaged()
{
	level endon( "end_window" );
	
	solid2 = getent( "breach_window_solid_2", "targetname" );
	cracked2 = getent( "breach_window_cracked_2", "targetname" );
	
	solid2 setcandamage( true );
	
	solid2 waittill( "damage" );
	
	solid2 delete();
	cracked2 show();
}


start_squad_ambush(guy)
{
	
	keys = getarraykeys(level.heroes);
	for(i=0;i<keys.size;i++)
	{
		level.heroes[keys[i]] show();
		playfx(level._effect["snow_burst"],level.heroes[keys[i]].origin);
	}	
	
	node = getent("ambush_align","targetname");
	//get the guards
	guards = getentarray("snow_ambush_patrollers_ai","targetname");
	for(i=0;i<guards.size;i++)
	{
		guards[i].animname = "ambush_guard"+i;
		guards[i].allowdeath = true;

	}
	
	level.heroes["kristina"].animname = "ambush_weaver";
	level.heroes["glines"].animname = "ambush_guy1";	

	guards = add_to_array(guards,level.heroes["kristina"]);
	guards = add_to_array(guards,level.heroes["glines"]);
	
	r_cover = ent_get("ambushcover_R");
	l_cover = ent_get("ambushcover_L");
	
	node thread anim_single_aligned(guards,"ambush");
	wait(1);
	guys = getentarray("snow_ambush_patrollers_ai","targetname");
	for(i=0;i<guys.size;i++)
	{
		guys[i] dodamage(300,guys[i].origin);
	}	
}


//knife throw door stuff
weaver_Door_Link( guy )
{
	door = ent_get("door_lower");	
	barnes = level.heroes["kristina"];
	door linkto( barnes,"TAG_WEAPON_LEFT" );
}


weaver_door_unlink( guy )
{
	door = ent_get("door_lower");	
	door Unlink();
}


sabotage_glass_break( guy )
{
	player = get_players()[0];
	
	//get model 
	glass = GetEnt("powerbox_glass", "targetname");
	
	//swap to destroyed model
	glass SetModel( "Dest_rus_powerbox_case_d1" );
	
	//playfx of glass breaking
	PlayFX(level._effect["glass_break"], glass.origin + (0, 0, -50));
	
	glass playsound("dst_glass_radar_pane_break");

	player PlayRumbleOnEntity("grenade_rumble");
	
	wait(1.6);
	
	player PlayRumbleOnEntity("damage_heavy");
	
	wait(2.1);
	
	player PlayRumbleOnEntity("grenade_rumble");
	earthquake(0.2, 2.0, get_players()[0].origin,  500);
}


#using_animtree( "generic_human" );
precache_patrol_anims()
{
		//patrol stuff
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %ai_spets_patrolwalk;
	level.scr_anim[ "generic" ][ "handler_walk" ]			= %ch_wmd_b01_dogHandler_walk_handler;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %ai_spets_patrolwalk;
			
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %ai_spets_patrolwalk_2_stand;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %ai_spets_patrolstand_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %ai_spets_patrolwalk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ai_spets_patrolstand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;	
	
	level.scr_anim[ "generic" ][ "patrol_idle_9" ][0]		= %ai_spets_patrolstand_idle;
	
	//active patrol walk
	level.scr_anim[ "generic" ][ "patrol_leader_walk" ]		= %ch_wmd_b01_patrol_leader;
	level.scr_anim[ "generic" ][ "active_patrol_walk1" ]	= %ch_wmd_b01_patrol_guard01;
	level.scr_anim[ "generic" ][ "active_patrol_walk2" ]	= %ch_wmd_b01_patrol_guard02;
	level.scr_anim[ "generic" ][ "active_patrol_walk3" ]	= %ch_wmd_b01_patrol_guard03;
	level.scr_anim[ "generic" ][ "active_patrol_walk4" ]	= %ch_wmd_b01_patrol_guard04;
	level.scr_anim[ "generic" ][ "active_patrol_walk5" ]	= %ch_wmd_b01_patrol_guard05;

	level._patrol_init = true;
}

rappel()
{
	// npc animations for rappel event
	level.scr_anim["weaver"]["rappel_hookup"]	= %ch_wmd_b01_rappel_A_kristina;

	level.scr_anim["weaver"]["rappel_approach"]			= %ch_wmd_b01_rappel_approach_weaver;
	level.scr_anim["weaver"]["rappel_railing_look"][0]	= %ch_wmd_b01_rappel_idle_weaver;

	level.scr_anim["weaver"]["rappel_idle_a"][0]	= %ai_rappel_wmd_weaver_idle_a;
	level.scr_anim["weaver"]["rappel_bounce_a"]		= %ai_rappel_wmd_weaver_bounce_a;

	level.scr_anim["weaver"]["rappel_idle_b"][0]	= %ai_rappel_wmd_weaver_idle_b;
	level.scr_anim["weaver"]["rappel_bounce_b"]		= %ai_rappel_wmd_weaver_bounce_b;

	level.scr_anim["weaver"]["rappel_idle_c"][0]	= %ai_rappel_wmd_weaver_idle_c;
	level.scr_anim["weaver"]["rappel_bounce_c"]		= %ai_rappel_wmd_weaver_bounce_c;

	level.scr_anim["weaver"]["rappel_idle_d"][0]	= %ai_rappel_wmd_weaver_idle_d;
	level.scr_anim["weaver"]["rappel_bounce_d"]		= %ai_rappel_wmd_weaver_bounce_d;

	level.scr_anim["weaver"]["rappel_idle_e"][0]	= %ai_rappel_wmd_weaver_idle_e;
	level.scr_anim["weaver"]["rappel_bounce_e"]		= %ai_rappel_wmd_weaver_bounce_e;

	level.scr_anim["weaver"]["rappel_idle_f"][0]	= %ai_rappel_wmd_weaver_idle_f;
	level.scr_anim["weaver"]["rappel_bounce_f"]		= %ai_rappel_wmd_weaver_bounce_f;

	level.scr_anim["weaver"]["rappel_idle_g"][0]	= %ai_rappel_wmd_weaver_idle_g;
	level.scr_anim["weaver"]["rappel_bounce_g"]		= %ai_rappel_wmd_weaver_bounce_g;

	level.scr_anim["weaver"]["rappel_idle_h"][0]	= %ai_rappel_wmd_weaver_idle_h;
	level.scr_anim["weaver"]["rappel_bounce_h"]		= %ai_rappel_wmd_weaver_bounce_h;

	rappel_rope();
}

#using_animtree("wmd");
rappel_rope()
{
	level.scr_anim["rappel_rope"]["rappel_hookup"]	= %ch_wmd_b01_rappel_A_kristina_rope;

	level.scr_anim["rappel_rope"]["rappel_idle_a"][0]	= %ai_rappel_wmd_weaver_rope_idle_a;
	level.scr_anim["rappel_rope"]["rappel_bounce_a"]	= %ai_rappel_wmd_weaver_rope_bounce_a;

	level.scr_anim["rappel_rope"]["rappel_idle_b"][0]	= %ai_rappel_wmd_weaver_rope_idle_b;
	level.scr_anim["rappel_rope"]["rappel_bounce_b"]	= %ai_rappel_wmd_weaver_rope_bounce_b;

	level.scr_anim["rappel_rope"]["rappel_idle_c"][0]	= %ai_rappel_wmd_weaver_rope_idle_c;
	level.scr_anim["rappel_rope"]["rappel_bounce_c"]	= %ai_rappel_wmd_weaver_rope_bounce_c;

	level.scr_anim["rappel_rope"]["rappel_idle_d"][0]	= %ai_rappel_wmd_weaver_rope_idle_d;
	level.scr_anim["rappel_rope"]["rappel_bounce_d"]	= %ai_rappel_wmd_weaver_rope_bounce_d;

	level.scr_anim["rappel_rope"]["rappel_idle_e"][0]	= %ai_rappel_wmd_weaver_rope_idle_e;
	level.scr_anim["rappel_rope"]["rappel_bounce_e"]	= %ai_rappel_wmd_weaver_rope_bounce_e;

	level.scr_anim["rappel_rope"]["rappel_idle_f"][0]	= %ai_rappel_wmd_weaver_rope_idle_f;
	level.scr_anim["rappel_rope"]["rappel_bounce_f"]	= %ai_rappel_wmd_weaver_rope_bounce_f;

	level.scr_anim["rappel_rope"]["rappel_idle_g"][0]	= %ai_rappel_wmd_weaver_rope_idle_g;
	level.scr_anim["rappel_rope"]["rappel_bounce_g"]	= %ai_rappel_wmd_weaver_rope_bounce_g;

	level.scr_anim["rappel_rope"]["rappel_idle_h"][0]	= %ai_rappel_wmd_weaver_rope_idle_h;
	level.scr_anim["rappel_rope"]["rappel_bounce_h"]	= %ai_rappel_wmd_weaver_rope_bounce_h;
	
	//weaver rope
	level.scr_anim["weaver_rope"]["rappel_hookup"]	= %ch_wmd_b01_rappel_A_kristina_rope;
	
	level.scr_anim["weaver_rope"]["rappel_idle_a"][0]	= %ai_rappel_wmd_weaver_rope_idle_a;
	level.scr_anim["weaver_rope"]["rappel_bounce_a"]	= %ai_rappel_wmd_weaver_rope_bounce_a;

	level.scr_anim["weaver_rope"]["rappel_idle_b"][0]	= %ai_rappel_wmd_weaver_rope_idle_b;
	level.scr_anim["weaver_rope"]["rappel_bounce_b"]	= %ai_rappel_wmd_weaver_rope_bounce_b;

	level.scr_anim["weaver_rope"]["rappel_idle_c"][0]	= %ai_rappel_wmd_weaver_rope_idle_c;
	level.scr_anim["weaver_rope"]["rappel_bounce_c"]	= %ai_rappel_wmd_weaver_rope_bounce_c;

	level.scr_anim["weaver_rope"]["rappel_idle_d"][0]	= %ai_rappel_wmd_weaver_rope_idle_d;
	level.scr_anim["weaver_rope"]["rappel_bounce_d"]	= %ai_rappel_wmd_weaver_rope_bounce_d;

	level.scr_anim["weaver_rope"]["rappel_idle_e"][0]	= %ai_rappel_wmd_weaver_rope_idle_e;
	level.scr_anim["weaver_rope"]["rappel_bounce_e"]	= %ai_rappel_wmd_weaver_rope_bounce_e;

	level.scr_anim["weaver_rope"]["rappel_idle_f"][0]	= %ai_rappel_wmd_weaver_rope_idle_f;
	level.scr_anim["weaver_rope"]["rappel_bounce_f"]	= %ai_rappel_wmd_weaver_rope_bounce_f;

	level.scr_anim["weaver_rope"]["rappel_idle_g"][0]	= %ai_rappel_wmd_weaver_rope_idle_g;
	level.scr_anim["weaver_rope"]["rappel_bounce_g"]	= %ai_rappel_wmd_weaver_rope_bounce_g;

	level.scr_anim["weaver_rope"]["rappel_idle_h"][0]	= %ai_rappel_wmd_weaver_rope_idle_h;
	level.scr_anim["weaver_rope"]["rappel_bounce_h"]	= %ai_rappel_wmd_weaver_rope_bounce_h;
	
	//rope for squad regroup
	level.scr_anim["rope1"]["reunited"] = %ch_wmd_b01_squadregroup02_guy01_rope;
	level.scr_anim["rope2"]["reunited"] = %ch_wmd_b01_squadregroup02_guy03_rope;
	
	//rope for weaver breach
	level.scr_anim["weaver_rope"]["window_hookup"] = %p_wmd_b01_playerRappelBreach_hookup_wRope;
	level.scr_anim["weaver_rope"]["ready_breach_idle"][0] = %p_wmd_b01_playerRappelBreach_idle02_wRope;
	level.scr_anim["weaver_rope"]["window_breach"] = %p_wmd_b01_playerRappelBreach_wRope;
}

#using_animtree( "generic_human" );
precache_level_anims()
{
	precache_player_anims();
	
	//E1 smoking guys
	//level.scr_anim[ "generic" ][ "ai_smoking" ][0] = %ch_wmd_b01_standsmoking_grd1;
	level.scr_anim[ "generic" ][ "ai_smoking" ][0] = %ch_wmd_b01_standsmoking_grd2;
	
	//E1 welders
	//level.scr_anim[ "generic" ][ "weld" ][0] = %ch_wmd_b01_grdweldingtruck_loop;
	//level.scr_anim[ "generic" ][ "alert" ] = %ch_wmd_b01_grdweldingtruck_alert;
	
	level.scr_anim[ "welder" ][ "weld" ][0] = %ch_wmd_b01_grdweldingstand_loop;
	level.scr_anim[ "welder" ][ "alert" ] = %ch_wmd_b01_grdweldingstand_alert;
	
	//temp hut breach guy
	level.scr_anim[ "crouching_guy" ][ "weld" ][0] = %ch_wmd_b01_grdweldingcrouch_loop;
	
	//E1 talking guys by dumpster
	level.scr_anim[ "russ01" ][ "talking" ][0] = %patrol_bored_idle;
	level.scr_anim[ "russ02" ][ "talking" ][0] = %patrol_bored_twitch_bug;
	
	//e1 shoveling
	level.scr_anim[ "grd01_shoveling" ][ "shoveling" ][0] = %ch_wmd_b01_grdshoveling_grd01;
	level.scr_anim[ "grd02_shoveling" ][ "shoveling" ][0] = %ch_wmd_b01_grdshoveling_grd02;
	level.scr_anim[ "grd01_shoveling" ][ "shoveling_alert" ] = %ch_wmd_b01_grdshoveling_grd01_alert;
	level.scr_anim[ "grd02_shoveling" ][ "shoveling_alert" ] = %ch_wmd_b01_grdshoveling_grd02_alert;
	
	//temp stealth reaction
	//level.scr_anim[ "generic" ][ "custom_react" ] = %exposed_idle_twitch_v4;
	
	//garage door opening
	// level.scr_anim["grd01"]["garage_leadin"] = %ch_wmd_b01_grdsopengarage_grd01_leadin;
	// level.scr_anim["grd01"]["garage_loop"][0] = %ch_wmd_b01_grdsopengarage_grd01_loop;
	// level.scr_anim["grd02"]["death"] = %ch_wmd_b01_grdsopengarage_grd02_death;

	//E1 knife attack
	//level.scr_anim["barnes"]["knife_attack"] = %ch_wmd_b01_knifethrow_barnes;
	//level.scr_anim["russ01"]["knife_attack"] = %ch_wmd_b01_knifethrow_russ01;
	//level.scr_anim["russ02"]["knife_attack"] = %ch_wmd_b01_knifethrow_russ02;
	
	//new knife throw
	level.scr_anim["knife_guy"]["knife_throw"] = %ch_wmd_b01_knifethrow_guy01;
	level.scr_anim["weaver"]["knife_throw"] = %ch_wmd_b01_knifethrow_weaver;
	addNotetrack_customFunction("weaver", "attach_knife", ::weaver_knife_attach, "knife_throw");
	addNotetrack_customFunction("weaver", "detach_knife", ::weaver_knife_detach, "knife_throw");
	
	//notetracks for door
	//addNotetrack_customFunction("weaver", "link", ::weaver_door_link, "knife_throw");
	//addNotetrack_customFunction("weaver", "unlink", ::weaver_door_unlink, "knife_throw");
	
	//hut repel breach
	level.scr_anim["russ01"]["repel_breach"] = %ch_wmd_b01_rappelbreach_russ01;
	level.scr_anim["russ02"]["repel_breach"] = %ch_wmd_b01_rappelbreach_russ02;
	//level.scr_anim["russ03"]["repel_breach"] = %ch_wmd_b01_rappelbreach_russ03;
	
	level.scr_anim["guy01"]["repel_breach"] = %ch_wmd_b01_rappelbreach_guy01;
	level.scr_anim["guy02"]["repel_breach"] = %ch_wmd_b01_rappelbreach_guy02;
	//level.scr_anim["guy03"]["repel_breach"] = %ch_wmd_b01_rappelbreach_guy03;
	
	level.scr_anim["crouching_guy"]["react"] = %ch_wmd_b01_rappelbreach_react02;
	
	//Desk guy using card playing anims
	level.scr_anim["desk_guy01"]["breach_loop"][0] = %ch_wmd_b01_rappelbreach_deskreact_loop_grd01;
	level.scr_anim["desk_guy01"]["react1"] = %ch_wmd_b01_rappelbreach_deskreact_react_grd01;
	
	//Desk guy using real non-card-playing anims
	level.scr_anim["desk_guy02"]["react02"] = %ch_wmd_b01_rappelbreach_deskreact_react_grd01;
	level.scr_anim["desk_guy02"]["breach_loop02"][0]=%ch_wmd_b01_rappelbreach_deskreact_loop_grd01;
	
	addNotetrack_customFunction("guy01", "shatter", ::repel_shatter_guy01, "repel_breach");
	addNotetrack_customFunction("guy02", "shatter", ::repel_shatter_guy02, "repel_breach");
	//addNotetrack_customFunction("guy03", "shatter", ::repel_shatter_guy03, "repel_breach");

	//spetz sliding under rail
	level.scr_anim["spetz1"]["spetz_slide"] = %ch_wmd_b01_railSlide_spets01;
	level.scr_anim["spetz2"]["spetz_slide"] = %ch_wmd_b01_railSlide_spets02;
	
	//avalanche sprint
	level.scr_anim["weaver"]["sprint_weaver"] = %ch_wmd_b01_avalanche_sprint_weaver;
	level.scr_anim["brooks"]["sprint_brooks"] = %ch_wmd_b01_avalanche_sprint_brooks;
	
	//barnes intro
	level.scr_anim["barnes"]["intro"] = %ch_wmd_b01_rappelopen_barnes;
		
	//guys scraping ice and refueling the GAZ
	level.scr_anim["scraper"]["scrape_leadin"] = %ch_wmd_b01_icescraping_grd01_leadin;
	level.scr_anim["scraper"]["scrape_loop"][0] = %ch_wmd_b01_icescraping_grd01_loop;
	level.scr_anim["scraper"]["scrape_react"] = %ch_wmd_b01_icescraping_grd01_react;
	
	level.scr_anim["fueler"]["fueler_leadin"] = %ch_wmd_b01_icescraping_grd02_leadin;
	level.scr_anim["fueler"]["fueler_loop"][0] = %ch_wmd_b01_icescraping_grd02_loop;
	level.scr_anim["fueler"]["fueler_react"] = %ch_wmd_b01_icescraping_grd02_react;
	
	
	//chopping wood guys
	level.scr_anim["chopper_1"]["chop"][0] = %ch_wmd_b01_woodchopper_grd01;
	level.scr_anim["chopper_2"]["chop"][0] = %ch_wmd_b01_woodchopper_grd02;
	level.scr_anim["chopper_1"]["chop_alert"] = %ch_wmd_b01_woodchopper_grd01_alert;
	level.scr_anim["chopper_2"]["chop_alert"] = %ch_wmd_b01_woodchopper_grd01_alert;
	level.scr_anim["chopper_2"]["chop_death"] = %ch_wmd_b01_woodchopper_grd02_death;
	
	//parachute vignette
	//level.scr_anim["kristina"]["throwpack_intro"] = %ch_wmd_b01_barnesthrowspack_intro_barnes;
	//level.scr_anim["pierro"]["throwpack_intro"] = %ch_wmd_b01_barnesthrowspack_intro_guy01;	
	//level.scr_anim["kristina"]["throwpack_loop"][0] = %ch_wmd_b01_barnesthrowspack_loop_barnes;
	//level.scr_anim["pierro"]["throwpack_loop"][0] = %ch_wmd_b01_barnesthrowspack_loop_guy01;			
	//level.scr_anim["kristina"]["throwpack"] = %ch_wmd_b01_barnesthrowspack_barnes;
	//level.scr_anim["pierro"]["throwpack"] = %ch_wmd_b01_barnesthrowspack_guy01;	
	//level.scr_anim["kristina"]["throwpack_signal"][0] = %ch_wmd_b01_barnesthrowspack_signal_barnes;
	//level.scr_anim["kristina"]["throwpack_jump"] = %ch_wmd_b01_barnesthrowspack_jump_barnes;
	level.scr_anim["pierro"]["basejump_leadin"] = %ch_wmd_b01_basejump_leadin_brooks;
	level.scr_anim["kristina"]["basejump_leadin"] = %ch_wmd_b01_basejump_leadin_weaver;
	level.scr_anim["pierro"]["prep_loop"][0] = %ch_wmd_b01_basejump_prepLoop_brooks;
	level.scr_anim["kristina"]["prep_loop"][0] = %ch_wmd_b01_basejump_prepLoop_weaver;
	//level.scr_anim["pierro"]["sam_react"] = %ch_wmd_b01_basejump_react_brooks;
	//level.scr_anim["kristina"]["sam_react"] = %ch_wmd_b01_basejump_react_weaver;
	level.scr_anim["kristina"]["wait_jump"][0] = %ch_wmd_b01_basejump_waitLoop_weaver;
		
	//base jump stuff
	level.scr_anim["pierro"]["freefall"][0] = %ch_wmd_b01_freefall_fall_guy01;
	level.scr_anim["pierro"]["freefall_left"][0] = %ai_base_jump_freefall_left_loop;
	level.scr_anim["pierro"]["freefall_right"][0] = %ai_base_jump_freefall_right_loop;
	level.scr_anim["pierro"]["bullet_dive"][0] = %ai_base_jump_deadfall_loop;
	level.scr_anim["pierro"]["bullet_dive_trans"] = %ai_base_jump_deadfall2freefall;
	level.scr_anim["kristina"]["freefall"][0] = %ch_wmd_b01_freefall_fall_kristina;
	level.scr_anim["kristina"]["freefall_left"][0] = %ai_base_jump_freefall_left_loop;
	level.scr_anim["kristina"]["freefall_right"][0] = %ai_base_jump_freefall_right_loop;
	level.scr_anim["kristina"]["bullet_dive"][0] = %ai_base_jump_deadfall_loop;
	level.scr_anim["kristina"]["bullet_dive_trans"] = %ai_base_jump_deadfall2freefall;
		
	level.scr_anim["pierro"]["pull_chute"] = %ch_wmd_b01_freefall_chutepull_guy01;
	level.scr_anim["kristina"]["pull_chute"] = %ch_wmd_b01_freefall_chutepull_kristina;
	
	level.scr_anim["pierro"]["chute_float"][0] = %ch_wmd_b01_freefall_chutefloat_guy01;
	level.scr_anim["kristina"]["chute_float"][0] = %ch_wmd_b01_freefall_chutefloat_kristina;

	//The "land" anims have TAG_ALIGNs and start 150 units above the ground.
	level.scr_anim["pierro"]["pierro_landing"] = %ch_wmd_b01_freefall_land_guy01;
	level.scr_anim["kristina"]["kristina_landing"] = %ch_wmd_b01_freefall_land_kristina;
	
	//snow ambush
	// level.scr_anim["ambush_guard"]["ambush"] = %ch_wmd_b01_ambush_guard;
	
	//level.scr_anim["ambush_guard0"]["ambush"] = %ch_wmd_b01_ambush_guard01;
	//level.scr_anim["ambush_guard1"]["ambush"] = %ch_wmd_b01_ambush_guard02;
	//level.scr_anim["ambush_guard2"]["ambush"] = %ch_wmd_b01_ambush_guard03;
	//level.scr_anim["ambush_guy1"]["ambush"] = %ch_wmd_b01_ambush_guy01;
	//level.scr_anim["ambush_weaver"]["ambush"] = %ch_wmd_b01_ambush_weaver;

	level.scr_anim["kristina"]["breach"]= %ch_wmd_b01_rappel_kristinaBreach;
	level.scr_anim["kristina"]["breach_idle"][0]= %ch_wmd_b01_rappel_kristinaBreach_idle;
	
	//loading boxes by the garage		
	// level.scr_anim["borris"]["loading_intro"] = %ch_wmd_b01_loading_boxes_intro_boris;
	// level.scr_anim["driver"]["loading_intro"] = %ch_wmd_b01_loading_boxes_intro_driver;
	// level.scr_anim["passenger"]["loading_intro"] = %ch_wmd_b01_loading_boxes_intro_passenger;
	// level.scr_anim["borris"]["loading_loop"][0] = %ch_wmd_b01_loading_boxes_loop_boris;
	// level.scr_anim["driver"]["loading_loop"][0] = %ch_wmd_b01_loading_boxes_loop_driver;
	// level.scr_anim["passenger"]["loading_loop"][0] = %ch_wmd_b01_loading_boxes_loop_passenger;	
	
	
	//reaction to missile launch
	// level.scr_anim["pierro"]["missile_react"] = %ch_wmd_b01_missle_react_guy01;
	// level.scr_anim["kristina"]["missile_react"] = %ch_wmd_b01_missle_react_weaver;
	// level.scr_anim["weaver"]["missile_react"] = %ch_wmd_b01_missle_react_weaver;
	
	//jump down left or right
	//level.scr_anim["blue0"]["dropdown"] = %ch_wmd_b01_squadleft_dropdown_guy01;
	//level.scr_anim["blue1"]["dropdown"] = %ch_wmd_b01_squadleft_dropdown_guy02;
	//level.scr_anim["red0"]["dropdown"] = %ch_wmd_b01_squadRight_dropDown_guy01;
	//level.scr_anim["red1"]["dropdown"] = %ch_wmd_b01_squadRight_dropDown_guy02;
	
				
	//climb up the berms on the cliffside	
	//level.scr_anim["weaver"]["climb_cliff"] = %ch_wmd_b01_cliffside_climb_weaver;
	//level.scr_anim["pierro"]["climb_cliff"] = %ch_wmd_b01_cliffside_climb_guy01;
	level.scr_anim["pierro"]["jump_gap"] = %ch_wmd_b01_cliffside_jumpacross_guy01;
	level.scr_anim["weaver"]["jump_gap"] = %ch_wmd_b01_cliffside_jumpacross_weaver;
	
	
	//reaction to player breaching into window
	level.scr_anim["react_guy0"]["breach_react"] = %ch_wmd_b01_breachreact_guard01;
	level.scr_anim["react_guy1"]["breach_react"] = %ch_wmd_b01_breachreact_guard02;
	
	//weaver halts by the shed
	// level.scr_anim["weaver"]["shed_halt"] = %ch_wmd_b01_squadleft_weaverhalt;
	
	
	//smoking cig break
	level.scr_anim["smoker"]["cig_break"] = %ch_wmd_b01_cigbreak_guy01;
	level.scr_anim["smoker"]["cig_react"] = %ch_wmd_b01_cigbreak_react_guy01;
	level.scr_anim["smoker"]["cig_break_idle"][0] = %ch_wmd_b01_cigbreak_idle_guy01;

	//dog handler
	// level.scr_anim["dog"]["dog_sees"] = %ch_wmd_b01_dog_sees_squad_dog;
	// level.scr_anim["dog"]["dog_walk"] = %ch_wmd_b01_dogHandler_walk_dog;
	
	// level.scr_anim["handler"]["dog_sees"] = %ch_wmd_b01_dog_sees_squad_handler;
	
	//Weaver hide	
	level.scr_anim["weaver"]["hide_idle"][0] = %ch_wmd_b01_hideinsnow_idle_weaver;
	level.scr_anim["weaver"]["hide_rise"] = %ch_wmd_b01_hideinsnow_rise_weaver;	
	
	//run to prone
	level.scr_anim["weaver"]["run2prone_leadin"] = %ch_wmd_b01_run2prone_leadin_guy01;
	level.scr_anim["brooks"]["run2prone_leadin"] = %ch_wmd_b01_run2prone_leadin_guy02;
	level.scr_anim["harris"]["run2prone_leadin"] = %ch_wmd_b01_run2prone_leadin_guy03;
	level.scr_anim["weaver"]["run2prone_idle"][0] = %ch_wmd_b01_run2prone_idle_guy01;
	level.scr_anim["brooks"]["run2prone_idle"][0] = %ch_wmd_b01_run2prone_idle_guy02;
	level.scr_anim["harris"]["run2prone_idle"][0] = %ch_wmd_b01_run2prone_idle_guy03;
	level.scr_anim["weaver"]["run2prone_exit"] = %ch_wmd_b01_run2prone_exit_guy01;
	level.scr_anim["brooks"]["run2prone_exit"] = %ch_wmd_b01_run2prone_exit_guy02;
	level.scr_anim["harris"]["run2prone_exit"] = %ch_wmd_b01_run2prone_exit_guy03;
	
	//squad provides cover for rappel
	level.scr_anim["brooks"]["leadin_aim"] = %ch_wmd_b01_aimoverrail_leadin_guy01;
	level.scr_anim["brooks"]["aim_idle"][0] = %ch_wmd_b01_aimoverrail_idle_guy01;
	
	//weaver window breach
	level.scr_anim["weaver"]["leadin_breach"] = %ch_wmd_b01_playerRappelBreach_leadin_weaver;
	level.scr_anim["weaver"]["window_hookup"] = %ch_wmd_b01_playerRappelBreach_hookup_weaver;
	level.scr_anim["weaver"]["ready_hookup_idle"][0] = %ch_wmd_b01_playerRappelBreach_idle01_weaver;
	level.scr_anim["weaver"]["ready_breach_idle"][0] = %ch_wmd_b01_playerRappelBreach_idle02_weaver;
	level.scr_anim["weaver"]["window_breach"] = %ch_wmd_b01_playerRappelBreach_weaver;
	addNotetrack_customFunction("weaver", "shatter", ::weaver_breach_into_room, "window_breach");
	
	//guard reactions to window breach
	level.scr_anim["guy1"]["window_react"] = %ch_wmd_b01_playerRappelBreach_guy01;
	level.scr_anim["guy2"]["window_react"] = %ch_wmd_b01_playerRappelBreach_guy02;
	level.scr_anim["guy3"]["window_react"] = %ch_wmd_b01_playerRappelBreach_guy03;
	level.scr_anim["guy4"]["window_react"] = %ch_wmd_b01_playerRappelBreach_guy04;
	
	//snowcat guys
	level.scr_anim["snowcat_driver"]["exit_snowcat"] = %ch_wmd_b01_snowcat_driver;
	level.scr_anim["snowcat_driver"]["snowcat_driver_walk"] = %ch_wmd_b01_snowcat_driver_walk;
	level.scr_anim["snowcat_pass"]["exit_snowcat"] = %ch_wmd_b01_snowcat_passenger;
	level.scr_anim["snowcat_pass"]["snowcat_pass_walk"] = %ch_wmd_b01_snowcat_passenger_walk;
	
	//regroup after window breach
	level.scr_anim["brooks"]["reunited"] = %ch_wmd_b01_squadregroup02_guy01;
	level.scr_anim["victim"]["reunited"] = %ch_wmd_b01_squadregroup02_guy02;
	level.scr_anim["victim"]["overrail_dead"][0] = %ch_wmd_b01_squadregroup02_dead_guy02;
	level.scr_anim["harris"]["reunited"] = %ch_wmd_b01_squadregroup02_guy03;
	level.scr_anim["weaver"]["reunited"] = %ch_wmd_b01_squadregroup02_weaver;
		
	//snow run
	//level.scr_anim["weaver"]["snowrun"] = %ai_snow_run_lowready;
	//level.scr_anim["brooks"]["snowrun"] = %ai_snow_run_lowready;
	//level.scr_anim["harris"]["snowrun"] = %ai_snow_run_lowready;
	//level.scr_anim["generic"]["snowrun"] = %ai_snow_run_lowready;
	
	/*
	// -- ledge fall for glines/harris
	*/
	level.scr_anim[ "harris" ][ "ledge_fall" ] = %ch_wmd_b01_catwalk_collapse_death_guy01;
	
	/*
	// -- animations for ai in the base
	// -- level.scr_anim[ "" ][ "" ] = % ;
	*/
	level.scr_anim[ "brooks" ][ "door_kick" ] = %ai_doorbreach_kick;
	addNotetrack_customFunction( "brooks", "door_open", maps\wmd_base::interior_door_react_to_kick, "door_kick" );
	
	// BASE FIELD ANIMATIONS
	level.scr_anim[ "pacing_guard_1" ][ "pacing_loop" ][ 0 ] = %ch_wmd_b05_pacingguards_loop_grd01;
	level.scr_anim[ "pacing_guard_1" ][ "pacing_react" ] = %ch_wmd_b05_pacingguards_alert_grd01;
	
	level.scr_anim[ "pacing_guard_2" ][ "pacing_loop" ][ 0 ] = %ch_wmd_b05_pacingguards_loop_grd02;
	level.scr_anim[ "pacing_guard_2" ][ "pacing_react" ] = %ch_wmd_b05_pacingguards_alert_grd02;
	
	level.scr_anim[ "truck_guard_1" ][ "unload_loop" ][ 0 ] = %ch_wmd_b05_truckguards_loop_grd01;
	addNotetrack_customFunction("truck_guard_1", "attach_reel", ::guard1_attach_reel, "unload_loop");
	addNotetrack_customFunction("truck_guard_1", "attach_papers", ::guard1_attach_papers, "unload_loop");
	addNotetrack_customFunction("truck_guard_1", "detach", ::guard1_detach, "unload_loop");
	
	level.scr_anim[ "truck_guard_2" ][ "unload_loop" ][ 0 ] = %ch_wmd_b05_truckguards_loop_grd02;
	addNotetrack_customFunction("truck_guard_2", "attach_papers", ::guard2_attach_papers, "unload_loop");
	addNotetrack_customFunction("truck_guard_2", "detach", ::guard2_detach, "unload_loop");
	
	level.scr_anim[ "truck_guard_1" ][ "unload_react" ] = %ch_wmd_b05_truckguards_alert_grd01;
	level.scr_anim[ "truck_guard_2" ][ "unload_react" ] = %ch_wmd_b05_truckguards_alert_grd02;
		
	// guy working on truck tire
	level.scr_anim[ "working_guard_1" ][ "working_loop" ][0] = %ch_wmd_b05_workingguard_loop;
	level.scr_anim[ "working_guard_1" ][ "working_react" ] = %ch_wmd_b05_workingguard_alert;
	
	// burning pile guys
	level.scr_anim[ "fire_barrel_1" ][ "burn_pile_loop" ][0] = %ch_wmd_b05_burnpileguards_grd01;
	addNotetrack_customFunction("fire_barrel_1", "attach_paper_left", ::guard1_attach_left, "burn_pile_loop");
	addNotetrack_customFunction("fire_barrel_1", "detach_paper_left", ::guard1_detach_left, "burn_pile_loop");
	addNotetrack_customFunction("fire_barrel_1", "attach_paper_right", ::guard1_attach_right, "burn_pile_loop");
	addNotetrack_customFunction("fire_barrel_1", "detach_paper_right", ::guard1_detach_right, "burn_pile_loop");
	
	level.scr_anim[ "fire_barrel_2" ][ "burn_pile_loop" ][0] = %ch_wmd_b05_burnpileguards_grd02;
	addNotetrack_customFunction("fire_barrel_2", "attach_paper_left", ::guard2_attach_left, "burn_pile_loop");
	addNotetrack_customFunction("fire_barrel_2", "detach_paper_left", ::guard2_detach_left, "burn_pile_loop");
	addNotetrack_customFunction("fire_barrel_2", "attach_paper_right", ::guard2_attach_right, "burn_pile_loop");
	addNotetrack_customFunction("fire_barrel_2", "detach_paper_right", ::guard2_detach_right, "burn_pile_loop");

	
	// BASE INTERIOR ANIMATIONS
	level.scr_anim[ "fire_barrel_1" ][ "burn_notice_loop" ][0] = %ch_wmd_b05_firebarrelguards_loop_guy01;
	addNotetrack_customFunction("fire_barrel_1", "attach_paper_left", ::barrel1_attach_left, "burn_notice_loop");
	addNotetrack_customFunction("fire_barrel_1", "detach_paper_left", ::barrel1_detach_left, "burn_notice_loop");
	addNotetrack_customFunction("fire_barrel_1", "attach_paper_right", ::barrel1_attach_right, "burn_notice_loop");
	addNotetrack_customFunction("fire_barrel_1", "detach_paper_right", ::barrel1_detach_right, "burn_notice_loop");
		
	level.scr_anim[ "fire_barrel_1" ][ "burn_notice_react" ] = %ch_wmd_b05_firebarrelguards_react_guy01;
	
	level.scr_anim[ "fire_barrel_2" ][ "burn_notice_loop" ][0] = %ch_wmd_b05_firebarrelguards_loop_guy02;
	addNotetrack_customFunction("fire_barrel_2", "attach_paper_left", ::barrel2_attach_left, "burn_notice_loop");
	addNotetrack_customFunction("fire_barrel_2", "detach_paper_left", ::barrel2_detach_left, "burn_notice_loop");
	addNotetrack_customFunction("fire_barrel_2", "attach_paper_right", ::barrel2_attach_right, "burn_notice_loop");
	addNotetrack_customFunction("fire_barrel_2", "detach_paper_right", ::barrel2_detach_right, "burn_notice_loop");
	
	level.scr_anim[ "fire_barrel_2" ][ "burn_notice_react" ] = %ch_wmd_b05_firebarrelguards_react_guy02;
	
	level.scr_anim[ "interior_door_fallback_1" ][ "fallback_doorway" ] = %ch_wmd_b05_interiorbreach_guards_grd01;
	level.scr_anim[ "interior_door_fallback_2" ][ "fallback_doorway" ] = %ch_wmd_b05_interiorbreach_guards_grd02;
	
	level.scr_anim[ "interior_boss" ][ "orders_from_the_hole" ] = %ch_wmd_b05_interiorguard_alert;
	
	// STEINER'S OFFICE ANIMATIONS
	level.scr_anim[ "brooks" ][ "office_leadin" ] = %ch_wmd_b05_steinersoffice_leadin_brooks;
	level.scr_anim[ "brooks" ][ "office_loop" ][ 0 ] = %ch_wmd_b05_steinersoffice_loop_brooks;
	level.scr_anim[ "brooks" ][ "office_main" ] = %ch_wmd_b05_steinersoffice_brooks;
	
	level.scr_anim[ "weaver" ][ "office_leadin" ] = %ch_wmd_b05_steinersoffice_leadin_weaver;
	level.scr_anim[ "weaver" ][ "office_loop" ][ 0 ] = %ch_wmd_b05_steinersoffice_loop_weaver;
	level.scr_anim[ "weaver" ][ "office_main" ] = %ch_wmd_b05_steinersoffice_weaver;
	addNotetrack_customFunction( "weaver", "vo_470A_huds", maps\wmd_base::warehouse_hudson_line_470, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _471A_stei", maps\wmd_base::warehouse_steiner_line_471, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _472A_huds", maps\wmd_base::warehouse_hudson_line_472, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _473A_stei", maps\wmd_base::warehouse_steiner_line_473, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _474A_stei", maps\wmd_base::warehouse_steiner_line_474, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _475A_huds", maps\wmd_base::warehouse_hudson_line_475, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _477A_stei", maps\wmd_base::warehouse_steiner_line_477, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _479A_huds", maps\wmd_base::warehouse_hudson_line_479, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _480A_stei", maps\wmd_base::warehouse_steiner_line_480, "office_main" );
	addNotetrack_customFunction( "weaver", "vo _482A_stei", maps\wmd_base::warehouse_steiner_line_482, "office_main" );
	addNotetrack_customFunction( "weaver", "audio_play_steiner_feedback1", ::play_steiner_feedback_1, "office_main" );
	addNotetrack_customFunction( "weaver", "audio_play_steiner_feedback2", ::play_steiner_feedback_2, "office_main" );
	addNotetrack_customFunction( "weaver", "attach_camera", ::camera_attach, "office_main" );
	addNotetrack_customFunction( "weaver", "detach_camera", ::camera_detach, "office_main" );
	addNotetrack_customFunction( "weaver", "flash", ::camera_flash, "office_main" );
}


camera_flash(guy)
{
	PlayFXOnTag(level._effect["camera_flash"], level.weaver, "tag_inhand");
}


camera_attach(guy)
{
	level.weaver Attach("p_rus_camera", "tag_inhand");
}


camera_detach(guy)
{
	level.weaver Detach("p_rus_camera", "tag_inhand");
}


// burn barrel guys ////////////////////////////////////////////////////////
barrel1_attach_left(guy)
{
	guy = getai_by_noteworthy("barrel_fire_1");
	
	if (isAlive(guy) && !level.barrel1_left)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.barrel1_left = true;
	}
}


barrel1_detach_left(guy)
{
	guy = getai_by_noteworthy("barrel_fire_1");
	
	if (isAlive(guy) && level.barrel1_left)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.barrel1_left = false;
	}
}


barrel1_attach_right(guy)
{
	guy = getai_by_noteworthy("barrel_fire_1");
	
	if (isAlive(guy) && !level.barrel1_right)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_inhand");
		level.barrel1_right = true;
	}
}


barrel1_detach_right(guy)
{
	guy = getai_by_noteworthy("barrel_fire_1");
	
	if (isAlive(guy) && level.barrel1_right)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_inhand");
		level.barrel1_right = false;
	}
}


barrel2_attach_left(guy)
{
	guy = getai_by_noteworthy("barrel_fire_2");
	
	if (isAlive(guy) && !level.barrel2_left)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.barrel2_left = true;
	}
}


barrel2_detach_left(guy)
{
	guy = getai_by_noteworthy("barrel_fire_2");
	
	if (isAlive(guy) && level.barrel2_left)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.barrel2_left = false;
	}
}


barrel2_attach_right(guy)
{
	guy = getai_by_noteworthy("barrel_fire_2");
	
	if (isAlive(guy) && !level.barrel2_right)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_inhand");
		level.barrel2_right = true;
	}
}


barrel2_detach_right(guy)
{
	guy = getai_by_noteworthy("barrel_fire_2");
	
	if (isAlive(guy) && level.barrel2_right)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_inhand");
		level.barrel2_right = false;
	}
}


// burn pile guys ////////////////////////////////////////////////////////
guard1_attach_left(guy)
{
	guy = getai_by_noteworthy("fire_pile_1");
	
	if (isAlive(guy) && !level.paper_left)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.paper_left = true;
	}
}


guard1_detach_left(guy)
{
	guy = getai_by_noteworthy("fire_pile_1");
	
	if (isAlive(guy) && level.paper_left)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.paper_left = false;
	}
}


guard1_attach_right(guy)
{
	guy = getai_by_noteworthy("fire_pile_1");
	
	if (isAlive(guy) && !level.paper_right)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_inhand");
		level.paper_right = true;
	}
}


guard1_detach_right(guy)
{
	guy = getai_by_noteworthy("fire_pile_1");
	
	if (isAlive(guy) && level.paper_right)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_inhand");
		level.paper_right = false;
	}
}


guard2_attach_left(guy)
{
	guy = getai_by_noteworthy("fire_pile_2");
	
	if (isAlive(guy) && !level.paper_left2)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.paper_left2 = true;
	}
}


guard2_detach_left(guy)
{
	guy = getai_by_noteworthy("fire_pile_2");
	
	if (isAlive(guy) && level.paper_left2)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_weapon_left");
		level.paper_left2 = false;
	}
}


guard2_attach_right(guy)
{
	guy = getai_by_noteworthy("fire_pile_2");
	
	if (isAlive(guy) && !level.paper_right2)
	{
		guy Attach("p_rus_crumpled_paper_01", "tag_inhand");
		level.paper_right2 = true;
	}
}


guard2_detach_right(guy)
{
	guy = getai_by_noteworthy("fire_pile_2");
	
	if (isAlive(guy) && level.paper_right2)
	{
		guy Detach("p_rus_crumpled_paper_01", "tag_inhand");
		level.paper_right2 = false;
	}
}


// truck burn guys ////////////////////////////////////////////////////////
guard1_attach_reel(guy)
{
	guy = getai_by_noteworthy("truck_guard1");
	
	if (isAlive(guy) && !level.disc)
	{
		guy Attach("p_rus_reel_disc", "tag_inhand");
		level.disc = true;
	}
}


guard1_attach_papers(guy)
{
	guy = getai_by_noteworthy("truck_guard1");
	
	if (isAlive(guy) && !level.paper1)
	{
		guy Attach("dest_glo_paper_01_d0", "tag_inhand");
		level.paper1 = true;
	}
}


guard1_detach(guy)
{
	guy = getai_by_noteworthy("truck_guard1");
	
	if (isAlive(guy) && level.disc)
	{
		guy Detach("p_rus_reel_disc", "tag_inhand");
		level.disc = false;
	}
	
	else if (isAlive(guy) && level.paper1)
	{
		guy Detach("dest_glo_paper_01_d0", "tag_inhand");
		level.paper1 = false;
	}
}
	
	
guard2_attach_papers(guy)
{
	guy = getai_by_noteworthy("truck_guard2");
	
	if (isAlive(guy) && !level.paper2)
	{
		guy Attach("dest_glo_paper_02_d0", "tag_inhand");
		level.paper2 = true;
	}
}
	

guard2_detach(guy)
{
	guy = getai_by_noteworthy("truck_guard2");
	
	if (isAlive(guy) && level.paper2)
	{
		guy Detach("dest_glo_paper_02_d0", "tag_inhand");
		level.paper2 = false;
	}
}


#using_animtree( "vehicles" );
init_vehicle_anims()
{
	level.scr_anim["intro_truck"]["death"] = %ch_wmd_b01_grdsopengarage_cat_death;
	level.scr_anim["intro_truck"]["leadin"] = %ch_wmd_b01_grdsopengarage_cat_leadin;
	level.scr_animtree[ "intro_truck" ] 	= #animtree;
	
	level.scr_anim["snowcat"]["exit_snowcat"] = %ch_wmd_b01_snowcat_doors;
	level.scr_animtree[ "snowcat" ] 	= #animtree;
	
	
	//loading boxes
	level.scr_anim["intro_truck"]["loading_intro"] = %v_wmd_b01_loading_boxes_intro_cat;

}


#using_animtree("dog");
init_dog_anims()
{
	level.scr_anim["dog"]["dog_walk"] = %german_shepherd_walk;
	level.scr_animtree[ "dog" ] 	= #animtree;
}


kick_door1(guy)
{	

	door = GetEnt("house1_door1", "targetname");
	door connectpaths();
	door notsolid();
	door rotateyaw(-130,.4);	
	array_notify(level.rts_house_guys,"enemy");
	wait(.5);
	guy anim_stopanimscripted();
}


kick_door2(guy)
{	
	
	door = GetEnt("house1_door2", "targetname");
	door connectpaths();
	door notsolid();
	door rotateyaw(130,.4);	
	wait(.5);
	guy anim_stopanimscripted();
}	

kick_office_door1(guy)
{
		door = GetEnt("office1_door1", "targetname");
		door connectpaths();
		door notsolid();
		door rotateyaw(-130,.4);	
		array_notify(getentarray("rts_office1_guys_ai","targetname"),"enemy");
		wait(.5);
		guy anim_stopanimscripted();
}

kick_office_door2(guy)
{
		door = GetEnt("office1_door2", "targetname");
		door connectpaths();
		door notsolid();
		door rotateyaw(-130,.4);	
		array_notify(getentarray("rts_office1_guys_ai","targetname"),"enemy");
		wait(.5);
		guy anim_stopanimscripted();
}
	
//sounds


//sounds for snow hide to radar approachle
wmd_dialogue()
{
	//dog house
	level.scr_sound["hudson"]["stay_low"] = "vox_wmd1_s01_137A_usc2_f";		//Stay low... Here they come�
	level.scr_sound["hudson"]["hold"] = "vox_wmd1_s01_138A_usc2_f";				//Hold position... Hold position�
	level.scr_sound["hudson"]["guardhouse"] = "vox_wmd1_s01_139A_usc2_f";	//Clear. More soldiers are on their way. Get to that guard house. GO!
	level.scr_sound["weaver"]["halt"] = "vox_wmd1_s01_140A_weav";					//HALT!
	level.scr_sound["weaver"]["dont_move"] = "vox_wmd1_s01_141A_weav";		//Don't move�
	level.scr_sound["soviet"]["soviet1"] = "vox_wmd1_s01_142A_sov1";				//(Translated) What is it boy? Halt! Drop your weapons!
	level.scr_sound["weaver"]["clear"] = "vox_wmd1_s01_143A_weav";					//Clear.
	
	//pre-rappel
	level.scr_sound["hudson"]["bigeye"] = "vox_wmd1_s01_144A_huds";				//BigEye this is Kilo One, over. You still have us on Tac?
	level.scr_sound["hudson"]["affirmative"] = "vox_wmd1_s01_145A_usc2_f";		//Affirmative Kilo One.
	level.scr_sound["hudson"]["visibility"] = "vox_wmd1_s01_146A_huds";				//Visibility has improved. We're starting our insertion. Moving to the substation.
	level.scr_sound["hudson"]["tracking"] = "vox_wmd1_s01_147A_usc2_f";			//Tracking... Bigeye sees four combatants entering the structure, over.
	level.scr_sound["hudson"]["going_in"] = "vox_wmd1_s01_148A_huds";					//Copy that BigEye, we're going in.
	level.scr_sound["hudson"]["power"] = "vox_wmd1_s01_149A_huds_m";			//The power relay is just below us. 4 targets.
	level.scr_sound["weaver"]["go"] = "vox_wmd1_s01_150A_weav_m";				//Then let's go.
	level.scr_sound["hudson"]["ready"] = "vox_wmd1_s01_151A_huds";					//Ready?
	level.scr_sound["weaver"]["three"] = "vox_wmd1_s01_152A_weav_m";			//Three, two, one�
	
	//russians react to window breach
	level.scr_sound["guy2"]["soviet2"] = "vox_wmd1_s01_153A_sov3";					//(Translated) Sound the alarm! We're under attack!
	level.scr_sound["guy2"]["soviet3"] = "vox_wmd1_s01_154A_sov2";					//(Translated) Move it! Move it!
	
	//under attack
	level.scr_sound["soviet"]["under_attack"] = "vox_wmd1_s01_153B_sov3"; //(Translated) Sound the alarm! We're under attack!
	
	//post window breach
	level.scr_sound["hudson"]["substation"] = "vox_wmd1_s01_155A_huds";					//BigEye, this is Kilo One. We have taken substation.
	level.scr_sound["hudson"]["focal_spread"] = "vox_wmd1_s01_427A_usc2_f";			//Understood.  Re-calibrating Focal spread. Okay - We have Comstat on Tac. Proceed to next objective.
	level.scr_sound["hudson"]["main_facility"] = "vox_wmd1_s01_428A_huds";				//Main facility is located at the base of the ridge.  
	level.scr_sound["hudson"]["find_evidence"] = "vox_wmd1_s01_429A_huds";			//If we're gonna find evidence that Nova six has been weaponized, it'll be there.
	level.scr_sound["hudson"]["knock_out"] = "vox_wmd1_s01_430A_huds";					//Once we knock out the external comms, they'll realize something's wrong.
	level.scr_sound["hudson"]["destroy_intel"] = "vox_wmd1_s01_431A_huds";				//We'll need to move fast - before they can destroy any intel.
	level.scr_sound["hudson"]["stay_sharp"] = "vox_wmd1_s01_432A_huds";				//Stay sharp.
	//level.scr_sound["hudson"]["bigeye_moving"] = "vox_wmd1_s01_156A_usc2_f";				//Understood. Bigeye is moving to the Comstat.
	
	//wood choppers
	level.scr_sound["weaver"]["pick"] = "vox_wmd1_s01_164A_weav";				//Pick one.
	level.scr_sound["chopper_1"]["soviet4"] = "vox_wmd1_s01_161A_sov1";			//(Translated) How much more?
	level.scr_sound["chopper_2"]["soviet5"] = "vox_wmd1_s01_162A_sov2";			//(Translated) The captain didn't say. We keep going until we're told to stop, got  it?
	level.scr_sound["chopper_1"]["soviet6"] = "vox_wmd1_s01_163A_sov1";			//(Translated) Of course. I bet he's warm.
	//level.scr_sound["weaver"]["kill"] = "vox_wmd1_s01_165A_weav";					//Kill him.
	
	//approaching comm station
	level.scr_sound["hudson"]["approach"] = "vox_wmd1_s01_157A_huds";		//Kilo One is approaching the objective.
	level.scr_sound["hudson"]["copy"] = "vox_wmd1_s01_148A_huds";			//Copy.
	level.scr_sound["hudson"]["multiple"] = "vox_wmd1_s01_159A_usc2_f";		//Kilo one, you have multiple targets at the Comstat. Take the storage shed on the south side then head to the power room entrance to the north.
	level.scr_sound["hudson"]["copy_that"] = "vox_wmd1_s01_160A_huds";		//Copy that.
	
	level.scr_sound["brooks"]["crossbow"] = "vox_wmd1_s01_306A_broo";		//Hudson, we need to keep this stealthy. Use your crossbow. If we get heat, switch to explosives.
	level.scr_sound["weaver"]["patrol_shed"] = "vox_wmd1_s01_433A_weav"; //One target patrolling outside the shed - two more inside
   level.scr_sound["hudson"]["by_truck"] = "vox_wmd1_s01_434A_broo";		//Two more by the truck on our right...
   level.scr_sound["hudson"]["gantry"] = "vox_wmd1_s01_435A_huds";			//One more on the right Gantry,
   level.scr_sound["hudson"]["ok_movein"] = "vox_wmd1_s01_436A_huds";		//Okay... Move in.
   
   //level.scr_sound["soviet"]["soviet13"] = "vox_wmd1_s01_176A_sov2";			//(Translated) Boris! Let's go! Load me up! 
   //level.scr_sound["soviet"]["soviet14"] = "vox_wmd1_s01_177A_sov2";			//(Translated) Come on! The captain wants me back at the bottom in 30 minutes!
   
   //welder guy to barrel sitting guy
   level.scr_sound["welder"]["sit_there"] = "vox_wmd1_s01_178A_sov1";			//(Translated) Are you just going to sit there?
   
   //level.scr_sound["soviet"]["soviet16"] = "vox_wmd1_s01_179A_sov2";			//(Translated) I can't let the engines stop. It'll freeze up.
   //level.scr_sound["soviet"]["soviet17"] = "vox_wmd1_s01_180A_sov1";			//(Translated) Bull. Shit.
   //level.scr_sound["soviet"]["soviet18"] = "vox_wmd1_s01_181A_sov3";			//(Translated) Boris, hurry up! I don't want to be on here all day.
	//level.scr_sound["soviet"]["soviet7"] = "vox_wmd1_s01_166A_sov3";			//???
	
	//guys by gaz truck
	level.scr_sound["fueler"]["soviet8"] = "vox_wmd1_s01_168A_sov2";			//(Translated) It must be 50 below.
	level.scr_sound["scraper"]["soviet9"] = "vox_wmd1_s01_169A_sov1";			//(Translated) Not even close.
	level.scr_sound["fueler"]["soviet10"] = "vox_wmd1_s01_170A_sov2";			//(Translated) The gasoline is FROZEN.
	level.scr_sound["scraper"]["soviet11"] = "vox_wmd1_s01_171A_sov1";			//(Translated) It is cold. I'm not saying it's not. But 50 below? We'd be dead.
	level.scr_sound["fueler"]["soviet12"] = "vox_wmd1_s01_172A_sov2";			//(Translated) I AM dead. As dead as this fucking car.
	
	//level.scr_sound["weaver"]["pick_one"] = "vox_wmd1_s01_167A_weav";		//Pick one.
	//level.scr_sound["hudson"]["truck"] = "vox_wmd1_s01_173A_usc2_f";			//Kilo, the truck is pulling out. Hold your position. We have another vehicle entering from the north. Looks like a Snowcat.
	//level.scr_sound["weaver"]["wait"] = "vox_wmd1_s01_174A_weav";				//Wait for them to pull up.
	//level.scr_sound["hudson"]["targets"] = "vox_wmd1_s01_175A_usc2_f";		//Two targets at the Snowcat. One soldier just exited the facility, looks like he's heading to the Snowcat.
	//level.scr_sound["hudson"]["snowcat"] = "vox_wmd1_s01_182A_huds";		//I'll take the snowcat. Ready?
	//level.scr_sound["weaver"]["on_you"] = "vox_wmd1_s01_183A_weav";			//On you.
	
	//stealth broken
	level.scr_sound["weaver"]["trig_alarm"] = "vox_wmd1_s01_437A_weav";		//SHIT! They've triggered the Alarm!
	level.scr_sound["hudson"]["weapons"] = "vox_wmd1_s01_438A_huds";		//Weapons free!!
	level.scr_sound["weaver"]["infantry"] = "vox_wmd1_s01_439A_weav";		//More infantry inbound!
	level.scr_sound["brooks"]["bolts"] = "vox_wmd1_s01_440A_broo";				//Hudson! switch to your explosive bolts!
	
	//knife throw
	level.scr_sound["hudson"]["two_targets"] = "vox_wmd1_s01_184A_usc1_f";	//Kilo, two targets just entered the power room.
	level.scr_sound["hudson"]["copy_that"] = "vox_wmd1_s01_185A_huds";			//Copy that BigEye.
	level.scr_sound["hudson"]["wait_breach"] = "vox_wmd1_s01_186A_huds_a";	//Harris, Brooks, control room. Wait for our breach.
	level.scr_sound["weaver"]["shoot_hinge"] = "vox_wmd1_s01_442A_weav";		//Shoot the hinges...
	level.scr_sound["hudson"]["nice_throw"] = "vox_wmd1_s01_191A_huds";		//Nice throw.
	level.scr_sound["hudson"]["control_per"] = "vox_wmd1_s01_192A_usc2_f";	//Good job Kilo one. You have control of the perimeter.
	level.scr_sound["hudson"]["be_advised"] = "vox_wmd1_s01_443A_usc2_f";		//Be advised - We have about three minutes left before we need to refuel with KC-135
	level.scr_sound["hudson"]["understood"] = "vox_wmd1_s01_444A_huds";		//Understood.
	
	//pre control room breach
	level.scr_sound["hudson"]["at_comstat"] = "vox_wmd1_s01_193A_huds";		//BigEye, Kilo One are at the Comstat.
	level.scr_sound["hudson"]["at_window"] = "vox_wmd1_s01_194A_usc1_f";		//Copy that. Your team is in position at the window.
	level.scr_sound["brooks"]["in_position"] = "vox_wmd1_s01_195A_broo_f";		//We're in position.
	
	//after breach
	level.scr_sound["hudson"]["multiple"] = "vox_wmd1_s01_307A_usc1_f"; 			//Kilo One you have multiple targets inbound to the comstat!
		
	//sabotage comm
	level.scr_sound["weaver"]["shut_down"] = "vox_wmd1_s01_197A_weav";		//We're clear. Hudson, shut down the relay dish.
	level.scr_sound["weaver"]["relay_prompt1"] = "vox_wmd1_s01_198A_weav"; //Hudson! You need to find the relay switch!
	level.scr_sound["weaver"]["relay_prompt2"] = "vox_wmd1_s01_199A_weav"; //Come on Hudson, we need to get moving!
		
	//post sabotage
	level.scr_sound["hudson"]["confirm_offline"] = "vox_wmd1_s01_200A_huds";	//BigEye this is Kilo One. Confirm that the relay is offline, over?
	level.scr_sound["hudson"]["com_ceased"] = "vox_wmd1_s01_445A_usc2_f";	//Affirmative Kilo One. All outbound  communications are have ceased. We have zero chatter.
	level.scr_sound["hudson"]["to_primary"] = "vox_wmd1_s01_446A_huds";			//Kilo 1 - Moving to the Primary Target.
	level.scr_sound["hudson"]["bow_out"] = "vox_wmd1_s01_447A_usc1_f"; 		//Okay Gentlemen, we're running on fumes now... this is where we bow out.
	level.scr_sound["hudson"]["leave_recon"] = "vox_wmd1_s01_216A_usc2_f";	//Leaving recon.
	level.scr_sound["hudson"]["stay_safe"] = "vox_wmd1_s01_219A_huds";			//Copy that BigEye. Thanks for the help. Stay safe.
   level.scr_sound["hudson"]["bigeye_out"] = "vox_wmd1_s01_220A_usc1_f";		//Affirmative. BigEye out.
   
   //pre ledge rpg
	level.scr_sound["weaver"]["wont_take"] = "vox_wmd1_s01_204A_weav";		//It won't take them long to figure out we're here. Let's move.
	level.scr_sound["weaver"]["rpg_ledge"] = "vox_wmd1_s01_448A_weav";			//RPG on the ridge!
	level.scr_sound["brooks"]["off_ledge"] = "vox_wmd1_s01_308A_broo";				//Hudson! Get off the ledge!
	level.scr_sound["hudson"]["lost_harris"] = "vox_wmd1_s01_450A_huds";			//We lost Harris!
	level.scr_sound["weaver"]["avalanche"] = "vox_wmd1_s01_449A_weav";		//Avalanche!!!!
	level.scr_sound["weaver"]["run_run"] = "vox_wmd1_s01_206A_weav";				//Hudson! Run! RUN!
	level.scr_sound["hudson"]["gogogo"] = "vox_wmd1_s01_451A_huds";				//Go!  Go!  Go!
	level.scr_sound["brooks"]["see_you"] = "vox_wmd1_s01_222A_broo_m";			//See you at the bottom.
	level.scr_sound["weaver"]["pick_lz"] = "vox_wmd1_s01_453A_weav";				//I'll follow. Pick the LZ carefully Hudson.
   		
	//missile
	//level.scr_sound["hudson"]["convoy_valley"] = "vox_wmd1_s01_207A_usc2_f"; //Kilo One, be advised we see an enemy convoy moving on the valley floor. Your LZ may be hot.
	//level.scr_sound["hudson"]["id_vehicles"] = "vox_wmd1_s01_202A_huds"; //Bigeye can we get an ID on the vehicles?
	//level.scr_sound["hudson"]["unidentified"] = "vox_wmd1_s01_209A_usc2"; //Negative, they are unidentified. Wait�
	//level.scr_sound["brooks"]["hell_out"] = "vox_wmd1_s01_350A_broo"; //Avalanche, let's get the hell out of here
	//level.scr_sound["brooks"]["basejump"] = "vox_wmd1_s01_351A_broo"; //Get to the base jump!
	//level.scr_sound["brooks"]["gogo"] = "vox_wmd1_s01_352A_broo"; //GO GO
	//level.scr_sound["weaver"]["not_good"] = "vox_wmd1_s01_211A_weav"; //That doesn't sound good.
	//level.scr_sound["hudson"]["radar_lock"] = "vox_wmd1_s01_212A_usc1_f"; //C.P.! They have radar lock. Talk to me!
	//level.scr_sound["hudson"]["bogeys"] = "vox_wmd1_s01_213A_usc2_f"; //Multiple launches detected! 2... 3... no 4 incoming bogeys.
	//level.scr_sound["hudson"]["heat_tail"] = "vox_wmd1_s01_214A_huds"; //BigEye you have heat on your tail! You need to get out of here!
	//level.scr_sound["hudson"]["bugging"] = "vox_wmd1_s01_215A_usc1_f"; //Copy that Kilo One. Gentlemen, we are bugging out.
	//level.scr_sound["hudson"]["leaving_recon"] = "vox_wmd1_s01_216A_usc2_f"; //Leaving recon.
	//level.scr_sound["hudson"]["good_luck"] = "vox_wmd1_s01_217A_usc1_f"; //	You are on your own Kilo One, good luck down there.
	//level.scr_sound["hudson"]["mach3"] = "vox_wmd1_s01_218A_usc2_f"; //	Thrusters engaged. Accelerating to Mach 3.
	//level.scr_sound["hudson"]["stay_safe"] = "vox_wmd1_s01_219A_huds"; //Copy that BigEye. Thanks for the help. Stay safe.
	//level.scr_sound["hudson"]["affirmative_bigeye"] = "vox_wmd1_s01_220A_usc1_f"; //	Affirmative. BigEye out.
	
	// base field
	// level.scr_sound[ "" ][ "" ] = ""; //
	level.scr_sound[ "hudson" ][ "clearing_house" ] = "vox_wmd1_s02_454A_huds"; //Shit... They've already started clearing house - Move!
	
	level.scr_sound[ "pacing_guard_1" ][ "are_we_doing" ] = "vox_wmd1_s02_455A_sov1"; //What are we doing with all this?
	level.scr_sound[ "pacing_guard_2" ][ "burn_everything" ] = "vox_wmd1_s02_456A_sov2"; //Burn it.  Burn everything.
	level.scr_sound[ "truck_guard_1" ][ "have_your_orders" ] = "vox_wmd1_s02_457A_sov3"; //You have your orders... Leave nothing behind.
	level.scr_sound[ "truck_guard_1" ][ "go_on_the_fire" ] = "vox_wmd1_s02_458A_sov3"; //If it does not go on a truck, it is to go on the fire.
	level.scr_sound[ "truck_guard_1" ][ "hurry_it_up" ] = "vox_wmd1_s02_459A_sov3"; //Hurry it up... We blow the base in less than thirty minutes.
	
	level.scr_sound[ "weaver" ][ "mg_in_the_tower" ] = "vox_wmd1_s02_460A_weav"; //Got an MG in the tower!
	level.scr_sound[ "hudson" ][ "into_the_building" ] = "vox_wmd1_s02_461A_huds"; //Into the building!
	level.scr_sound[ "weaver" ][ "here" ] = "vox_wmd1_s02_462A_weav"; //Here!
	
	// base interior
	level.scr_sound[ "weaver" ][ "see_these_wires" ] = "vox_wmd1_s02_463A_weav"; //Hudson... Do you see these wires?
	level.scr_sound[ "hudson" ][ "through_the_facility" ] = "vox_wmd1_s02_464A_huds"; //Yeah... Running all through the facility...
	level.scr_sound[ "weaver" ][ "rigged_to_blow" ] = "vox_wmd1_s02_465A_weav"; //They've got the place rigged to blow...
	level.scr_sound[ "hudson" ][ "have_much_time" ] = "vox_wmd1_s02_466A_huds"; //Make it fast people... We don't have much time!
	
	// base warehouse
	level.scr_sound[ "weaver" ][ "not_here" ] = "vox_wmd1_s02_467A_weav"; //Steiner's not here.
	level.scr_sound[ "weaver" ][ "locking_down" ] = "vox_wmd1_s02_469A_weav"; //It's locking down!
	level.scr_sound[ "hudson" ][ "what_is_that" ] = "vox_wmd1_s02_470A_huds_m"; //What is that?!
	level.scr_sound[ "steiner" ][ "freidrich_steiner" ] = "vox_wmd1_s02_471A_stei_f_m"; //This is Freidrich Steiner.
	level.scr_sound[ "hudson" ][ "jamming_our_radios" ] = "vox_wmd1_s02_472A_huds_m"; //He's jamming our radios... He knew we'd be here.
	level.scr_sound[ "weaver" ][ "watching_us" ] = "vox_wmd1_s02_506A_weav"; //We're on camera. He's watching us.
	level.scr_sound[ "steiner" ][ "everything_and_everyone" ] = "vox_wmd1_s02_473A_stei_f_m"; //Dragovich is burying everything and everyone connected to project Nova.
	level.scr_sound[ "steiner" ][ "will_be_next" ] = "vox_wmd1_s02_474A_stei_f_m"; //I am sure I will be next.
	level.scr_sound[ "hudson" ][ "do_you_want" ] = "vox_wmd1_s02_475A_huds_m"; //What do you want?
	level.scr_sound[ "weaver" ][ "across_the_states" ] = "vox_wmd1_s02_476A_weav"; //Targets marked across the states...
	level.scr_sound[ "steiner" ][ "sleeper_cells_waiting" ] = "vox_wmd1_s02_477A_stei_f_m"; //All across America, Dragovich has sleeper cells waiting for the signal to release the Nova 6.
	level.scr_sound[ "weaver" ][ "weaponized_nova" ] = "vox_wmd1_s02_478A_weav"; //Weaponized Nova 6.
	level.scr_sound[ "hudson" ][ "numbers_broadcast" ] = "vox_wmd1_s02_479A_huds_m"; //The numbers broadcasts - What do they mean?
	level.scr_sound[ "steiner" ][ "for_my_safety" ] = "vox_wmd1_s02_480A_stei_f_m"; //I will tell you everything in exchange for me safety.
	level.scr_sound[ "steiner" ][ "choice_is_yours" ] = "vox_wmd1_s02_482A_stei_f_m"; //I am at Rebirth Island - the Aral Sea... The choice is yours.
	
	level.scr_sound["steiner"]["36_hours"] = "vox_wmd1_s02_481B_stei_f_m"; //* In 36 hours, the sleeper agents will receive their final orders.  Only I can tell you how to stop the broadcast.
	
	level.scr_sound[ "hudson" ][ "need_to_leave" ] = "vox_wmd1_s02_483A_huds"; //We need to leave - Now!
	level.scr_sound[ "hudson" ][ "ready_to_blow" ] = "vox_wmd1_s02_484A_huds"; //Move! Move! This place is ready to blow!
	level.scr_sound[ "hudson" ][ "long_we_have" ] = "vox_wmd1_s02_485A_huds"; //We don't know how long we have!
	level.scr_sound[ "hudson" ][ "move_it_go" ] = "vox_wmd1_s02_486A_huds"; //Move it! Go!
	level.scr_sound[ "weaver" ][ "wait_around" ] = "vox_wmd1_s02_487A_weav"; //We don't have time to wait around!
	level.scr_sound[ "weaver" ][ "to_that_truck" ] = "vox_wmd1_s02_488A_weav"; //Get to that truck!
	
	// base truck
	level.scr_sound[ "hudson" ][ "weaver_drive" ] = "vox_wmd1_s02_489A_huds"; //Weaver - Drive!... I'll get on the MG!
	level.scr_sound[ "hudson" ][ "out_of_here" ] = "vox_wmd1_s02_490A_huds"; //Get us out of here!!!
	level.scr_sound[ "weaver" ][ "hotwire_it" ] = "vox_wmd1_s02_491A_weav"; //I have to hotwire it! 
	level.scr_sound[ "hudson" ][ "all_over_us" ] = "vox_wmd1_s02_492A_huds"; //Make it fast - they're all over us!
	level.scr_sound[ "weaver" ][ "need_a_minute" ] = "vox_wmd1_s02_493A_weav"; //I need a minute!
	level.scr_sound[ "hudson" ][ "have_a_minute" ] = "vox_wmd1_s02_494A_huds"; //We don't have a minute!!
	
	level.scr_sound[ "weaver" ][ "stupid_piece_of" ] = "vox_wmd1_s02_495A_weav"; //Come on - Stupid piece of shit truck!
	level.scr_sound[ "hudson" ][ "we_waiting_for" ] = "vox_wmd1_s02_496A_huds"; //What are we waiting for, Weaver?!!!
	
	level.scr_sound[ "weaver" ][ "nearly_there" ] = "vox_wmd1_s02_497A_weav"; //Nearly there...
	level.scr_sound[ "weaver" ][ "got_it" ] = "vox_wmd1_s02_498A_weav"; //GOT IT!!
	level.scr_sound[ "hudson" ][ "hit_it_go_go" ] = "vox_wmd1_s02_499A_huds"; //Hit it! Go! GO!
	
	level.scr_sound[ "hudson" ][ "mountain_coming_down" ] = "vox_wmd1_s02_500A_huds"; //The whole fucking mountain's coming down!!!
	level.scr_sound[ "hudson" ][ "go_go" ] = "vox_wmd1_s02_501A_huds"; //Go!! GO!!!!
	level.scr_sound[ "hudson" ][ "faster" ] = "vox_wmd1_s02_502A_huds"; //FASTER!!!
	
	// interrogator
	level.scr_sound["hudson"]["hudson_led"] = "vox_wmd1_s01_900A_inte"; //Jason Hudson led the attack on Yamantau.
	level.scr_sound["hudson"]["hudson_led2"] = "vox_wmd1_s01_900B_inte"; //* Jason Hudson led the attack on Yamantau.
	level.scr_sound["hudson"]["ice_cube"] = "vox_wmd1_s01_901A_maso"; //Yeah. 20 degrees below zero. Fucking ice cube was in his element.
	level.scr_sound["hudson"]["ice_cube2"] = "vox_wmd1_s01_901A_maso_s"; //Yeah. 20 degrees below zero. Damn ice cube was in his element.
	level.scr_sound["hudson"]["buried"] = "vox_wmd1_s01_902A_inte"; //The avalanche buried the entire base, but Hudson and Weaver made it out alive. It was almost all over Mason.
}

play_steiner_feedback_1( guy )
{
    speaker_origin1 = (13873,-6343,10083);
    speaker_origin2 = (14201,-5867,10067);
    
    playsoundatposition( "evt_feedback", speaker_origin1 );
    playsoundatposition( "evt_feedback", speaker_origin2 );
}

play_steiner_feedback_2( guy )
{
    speaker_origin1 = (13873,-6343,10083);
    speaker_origin2 = (14201,-5867,10067);
    
    playsoundatposition( "evt_feedback", speaker_origin1 );
    playsoundatposition( "evt_feedback", speaker_origin2 );
}

 