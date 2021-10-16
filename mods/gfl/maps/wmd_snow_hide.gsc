#include maps\_utility;
#include common_scripts\utility;
#include maps\wmd_util;
#include maps\_anim;
#include maps\_music;
#include maps\_stealth_logic;
#include maps\wmd;



snow_hide_main()
{
	//TUEY TO Change Music once on the ground
	level thread maps\_audio::switch_music_wait("ON_THE_GROUND", 16);
	
	level thread setup_hide();
	level thread spawn_squad();
	level thread spawn_patrol01();
	level thread glowy_rails();
	level thread hide_comstat_objects();
	level thread hide_show_start();
	
	player = GetPlayers()[0];
	
	player AllowJump(true);
	player AllowLean(true);
	player AllowMelee(true);
	player AllowSprint(true);
		
	flag_wait( "patrol_done" );
	
	setmusicstate ("NONE");
	
	guard_house();
	//rappel_prepare();
	rappel_player_hookup();
	breach_power_building();	
}


hide_show_start()
{
	garage = getstruct("occlude_garage", "targetname");
	baseoutdoors = getstructarray("occlude_baseoutdoors", "targetname");
	baseindoors = getstructarray("occlude_baseindoors", "targetname");
	
	SetCellInvisibleAtPos(garage.origin);
	
	for(i=0; i<baseoutdoors.size; i++)
	{
		SetCellInvisibleAtPos(baseoutdoors[i].origin);
	}
	
	for(i=0; i<baseindoors.size; i++)
	{
		SetCellInvisibleAtPos(baseindoors[i].origin);
	}
}


hide_comstat_objects()
{
	weapons = getentarray("weapon_comstat", "targetname");
	
	for (i=0; i<weapons.size; i++)
	{
		weapons[i] hide();
	}
	
	tanker = getent("tanker", "targetname");
	truck = getent("scrape_gaz", "targetname");
	can = getent("gaz_can", "targetname");
	
	tanker hide();
	truck hide();
	can hide();
}


glowy_rails()
{
	cliff_glow = getent("rappelrail_cliff_glow", "targetname");
	shack_glow = getent("rappelrail_powershack_glow", "targetname");
	
	cliff_glow hide();
	shack_glow hide();
}


setup_hide()
{
	flag_wait("all_players_connected");
	
	//Need to delete from SR71 runway
	pilots = getentarray("sr71_pilots", "targetname");
	if (pilots.size > 0)
	{
		for(i=0; i<pilots.size; i++)
		{
			pilots[i] delete();
		}
	}
	
	level thread setup_hide_player();
	
	guy = getent( "ambush_guard_ai", "targetname" );
	if ( isdefined( guy ) )
	{
		guy delete();
	}
	
	guys = getentarray( "snow_ambush_patrollers_ai", "targetname" );
	for ( i=0; i<guys.size; i++ )
	{
		if ( isdefined( guys[i] ) )
		{
			guys[i] delete();
		}
	}
	
	//turn off the hookup trigger until the objective is ready
	trig = ent_get("rappel_hookup");
	trig trigger_off();
	
	level notify("set_ambush_fog");
	
	SetSavedDvar( "r_skyTransition", 0 );
}


spawn_squad()
{
	level.harris = simple_spawn_single( "spawner_harris", ::behavior_snow_hideguy );	
	level.weaver = simple_spawn_single( "spawner_weaver", ::weaver_snow_hide );	
	level.brooks = simple_spawn_single( "spawner_brooks", ::behavior_snow_hideguy );
	//level.lucas = simple_spawn_single( "spawner_lucas", ::behavior_snow_hideguy );
	
	wait( 0.1 );
	
	level.harris.name = ( "Harris" );
	level.weaver.name = ( "Weaver" );
	level.brooks.name = ( "Brooks" );
	//level.lucas.name = ( "Lucas" );
	
	// -- WWILLIAMS: THE SQUAD ISN'T BEING SPAWNED IN FROM A NORMAL PLAY THROUGH, THIS SHOULD FIX THE MISSING ENT FLAG ON BROOKS
	level.weaver ent_flag_init( "basejump_done" );
	level.brooks ent_flag_init( "basejump_done" );
	level.harris ent_flag_init( "basejump_done" );
	
	if( !flag( "heroes_spawned" ) )
	{
		flag_set( "heroes_spawned" );
	}
	
	level.weaver gun_recall();
}


weaver_snow_hide()
{
	self.animname = "weaver";
	self make_hero();
	self.ignoreall = true;
	self.ignoreme = true;
	self AllowedStances( "prone" );
	self disable_ai_color();
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
	
	//self thread anim_loop( self, "hide_idle" );
	
	flag_wait( "patrol_done" );
	
	self AllowedStances("prone", "crouch", "stand");
	
	//anim_single(self, "hide_rise");
	
	trigger_use("triggercolor_exit_snowhide");
}


behavior_snow_hideguy()
{
	self make_hero();
	self.ignoreall = true;
	self.ignoreme = true;
	self AllowedStances( "prone" );
	self disable_ai_color();
	self.a.allow_weapon_switch = false;
	self animscripts\shared::placeweaponOn(self.secondaryweapon, "none");
}


play_temp_russian_voice()
{
	level thread heart_beat_controller_walkby();

//	player = getplayers();
//	ent = spawn("script_origin", (0,0,0));
//	ent playloopsound ("vox_breath_scared_loop");
	wait(18);	
	playsoundatposition ("vox_russian_passby", (10376, -39824, 43280));	
}


heart_beat_controller_walkby()
{
	level thread maps\wmd_amb::event_heart_beat("relaxed");
	wait(23);
	level thread maps\wmd_amb::event_heart_beat("stressed");
	flag_wait("patrol_done");
	level thread maps\wmd_amb::event_heart_beat("relaxed");
	wait(3);
	level thread maps\wmd_amb::event_heart_beat ("none");
}


#using_animtree("generic_human");
setup_hide_player()
{
	if(isDefined(level.sunAng))
	{
		SetSavedDvar( "r_lightTweakSunDirection", level.sunAng );
	}
	
	exploder(501);
	
	player = get_players()[0];
	
	player.force_minigame = 1;	// always do dog minigame.
	
	VisionSetNaked("wmd_snow_hide");
	//SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )
	player SetDepthOfField( 0, 115, 1000, 9286, 4, 1.03 );
	
	//removing HUD elements
	player SetClientDVAR( "compass", "0" );
	player SetClientDVAR( "hud_showstance", "0" );
	player SetClientDVAR( "actionslotshide" , "1" );
	player SetClientDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "aim_view_sensitivity_override", "-1" );
	
	org = getstruct( "player_hide_pos", "targetname" );
		
	player.ignoreme = true;
	
	player setorigin( org.origin );
	player setplayerangles( org.angles );
		
	player disableweapons();
	
	body = spawn_anim_model( "player_body", org.origin, org.angles );
	body useanimtree (level.scr_animtree["player_body"] );
	
	player PlayerLinktoDelta( body, "tag_player", 0, 1, 1,15,15 );
	player HideViewModel();
	player SetStance( "prone" );
		
	body Attach( "t5_weapon_crossbow_viewmodel_arctic", "tag_weapon" );
	player thread vo_snow_hide();
	
	org thread anim_loop( body, "hide_idle" );
	
	level thread play_temp_russian_voice();
	
	wait(.5);
	
	player PlayerLinktoDelta( body, "tag_player", 0, 35, 35,15,15 );
	
	player thread cold_breath("plyr");
	level thread squad_breath_on();
	
	wait( 26.0 );
	
	org anim_single( body, "reach" );
	org thread anim_loop( body, "reach_idle" );	
	
	wait( 12.0 );
	
	flag_set( "patrol_done" );
	
	wait( 2.0 );
	
	//player StartCameraTween(.1);
	
	player_cover = getentarray("ambushcover_player","targetname");
	for(i=0;i<player_cover.size;i++)
	{
		player_cover[i] delete();
	}
	
	level thread squad_color_chain();
	
	screen_message_create( &"PLATFORM_REVEAL" );
	
	while(1)
	{
		norm_move = player GetNormalizedMovement();
		new_angle = (0,0,0);

		// pushing up
		if(norm_move[0] > 0.8)
		{
			screen_message_delete();
			// player SetDepthOfField(0, 1, 8000, 10000, 6, 1 );
			//player SetDepthOfField(0, 1, 8000, 10000, 6, 1 );
			player thread lerp_dof_over_time(4.0, 0, 1, 8000, 10000, 6, 0);
			level thread visionset_restore();
			player thread crawl_rumble();
			//clientnotify("frost_overlay_off");
			break;
		}
		
		wait(.05);
	}
	
	guys = getaiarray("allies");
	for( i=0; i<guys.size; i++ )
	{
		guys[i] AllowedStances( "crouch", "stand" );
	}
	
	triggercolor = getent("triggercolor_others", "targetname");
	triggercolor useby(player);
	
	player unlink();
	player PlayerLinktoAbsolute(body, "tag_player");
	
	org anim_single( body, "hide_rise" );
	
	player SetClientDVAR( "compass", "1" );
	player SetClientDVAR( "hud_showstance", "1" );
	player SetClientDVAR( "actionslotshide" , "0" );
	player SetClientDvar( "ammoCounterHide", "0" ); 
	
	//falloff = getent( "snow_falloff_player", "targetname" );
	//playfxontag( level._effect["snow_falloff"], falloff, "tag_origin" );
	playfx( level._effect["snow_falloff"], player.origin );
		
	//snow_overlay_off();
	
	player unlink();
	player enableweapons();
	player SetStance("stand");
	player ShowViewModel();
	
	//aug delete();
	body delete();
	
	//TUEY Shutting off music here for now
	setmusicstate ("NONE");
}


crawl_rumble()
{
	wait(1.35);
	self PlayRumbleOnEntity("damage_light");
	
	stop_exploder(501);
	
	wait(1.4);
	self PlayRumbleOnEntity("damage_light");
}


visionset_restore()
{
	wait(2.0);
	
	VisionSetNaked("wmd");
}


snow_overlay_on()
{
	screen_overlay = "flamethrowerfx_color_distort_overlay_bloom";
	
	if(!IsDefined(level.screen_overlay))
	{
		level.snow_overlay = NewHudElem(); 
		level.snow_overlay.x = 0; 
		level.snow_overlay.y = 0; 
		level.snow_overlay.horzAlign = "fullscreen"; 
		level.snow_overlay.vertAlign = "fullscreen"; 
		level.snow_overlay.foreground = true;
		level.snow_overlay SetShader( screen_overlay, 640, 480 );
	}
}

/*------------------------------------
takes off the visor  TODO: make co-op friendly
------------------------------------*/
snow_overlay_off()
{
	if(IsDefined(level.snow_overlay))
	{
		level.snow_overlay Destroy();
	}
}


squad_color_chain()
{
	guys = getaiarray( "allies" );
	
	for( i=0; i<guys.size; i++ )
	{
		guys[i] enable_ai_color();
	}
	
	trigger_wait( "triggercolor_runto_guardhouse", "targetname" );
	
	level.weaver thread weaver_prone();
	level.brooks thread brooks_prone();
	level.harris thread harris_prone();
	
	flag_wait( "hide_again" );
	
	level.weaver thread vo_hide_guard();
	
	level thread maps\wmd_amb::event_heart_beat("stressed");
	
	level thread check_player_spotted();
	level thread setup_squad_battle();
	//level thread spawn_patrol_pursuit();
	
	/*level.weaver.animname = "weaver";
	level.brooks.animname = "brooks";
	level.harris.animname = "squad";
	level.lucas.animname = "squad";
	
	level.weaver thread anim_single( level.weaver, "run2prone" );
	level.weaver AllowedStances( "prone" );
	wait( 0.3 );
	level.brooks thread anim_single( level.brooks, "run2prone" );
	level.brooks AllowedStances( "prone" );
	wait( 0.5 );
	level.harris thread anim_single( level.harris, "run2prone" );
	level.harris AllowedStances( "prone" );
	wait( 0.3 );
	level.lucas thread anim_single( level.lucas, "run2prone" );
	level.lucas AllowedStances( "prone" );*/
	
	//wait( 15.0 );
	flag_wait("prone_over");
	
	if (!flag("alert_dog"))
	{
		wait(4.0);
	}
	
	level thread squad_runto_guardhouse();
	level thread squad_clear();
}


squad_runto_guardhouse()
{
	guys = getaiarray( "allies" );
	
	if ( !flag( "go_hot" ) && !flag( "dog_gone" ) )
	{
		level notify( "patrol_gone" );
				
		level thread maps\wmd_amb::event_heart_beat("none");
		
		for( i=0; i<guys.size; i++ )
		{
			guys[i] enable_ai_color();
			guys[i] AllowedStances( "prone", "crouch", "stand" );
		}
	
		wait( 0.1 );
		
		trigger_use("triggercolor_at_guardhouse1");
		
		wait(0.8);
		
		trigger_use("triggercolor_at_guardhouse2");
		
		level.brooks thread cover_ridge();
		
		wait(0.4);
		
		trigger_use("triggercolor_at_guardhouse3");
	
		wait( 15.0 );
		
		if ( !flag( "go_hot" ) && !flag( "dog_gone" ) )
		{	
			flag_set( "dog_gone" );
			flag_set("clear_rappel");
		}
	}
}


cover_ridge()
{
	self waittill("goal");
	
	aim_ent = spawn("script_origin", (12307, -38292, 43235));
	
	self aim_at_target(aim_ent);
	
	flag_wait("clear_rappel");
	
	self stop_aim_at_target();
	
	aim_ent delete();
}


cover_hill()
{
	self waittill("goal");
	
	aim_ent = spawn("script_origin", (11077, -39436, 43080));
	
	self aim_at_target(aim_ent);
	
	flag_wait("go_breach");
	
	self stop_aim_at_target();
	
	aim_ent delete();
}


squad_clear()
{
	flag_wait("dog_gone");
	
	if (!flag("go_hot"))
	{
		flag_set("clear_rappel");
	}
}


weaver_prone()
{
	org = getstruct("runtoprone", "targetname");
	node = getnode("node_weaver_prone", "targetname");
	snow = getent("prone_hole_cover_4", "targetname");
	puff = getent("snow_puff_weaver", "targetname");
	
	self disable_ai_color();
	
	org anim_reach_aligned(self, "run2prone_leadin");
	
	puff thread play_snow_puff();
		
	org anim_single_aligned(self, "run2prone_leadin");
	
	org thread anim_loop_aligned(self, "run2prone_idle");
	
	//self thread dog_spotted();
	
	flag_wait_any("prone_over", "go_hot");
	
	if (!flag("go_hot"))
	{
		wait(4.0);
	}
	else
	{
		player = get_players()[0];
		player.animname = "hudson";
		player anim_single(player, "weapons");
	}
	
	//if (!flag("go_hot"))
	//{
		org anim_single_aligned(self, "run2prone_exit");
	//}
	
	self notify("getup");
	
	snow delete();
	wait( 5.0 );
	puff delete();
}


brooks_prone()
{
	org = getstruct("runtoprone", "targetname");
	node = getnode( "node_brooks_prone", "targetname" );
	snow = getent( "prone_hole_cover_3", "targetname" );
	puff = getent( "snow_puff_brooks", "targetname" );
	
	level.brooks.animname = "brooks";
	
	wait(0.5);
	
	self disable_ai_color();
	
	org anim_reach_aligned(self, "run2prone_leadin");
	
	puff thread play_snow_puff();
		
	org anim_single_aligned(self, "run2prone_leadin");
	
	org thread anim_loop_aligned(self, "run2prone_idle");
	
	//self thread dog_spotted();
	
	flag_wait_any("prone_over", "go_hot");
	
	if (!flag("go_hot"))
	{
		wait(4.0);
	}
	
	//if (!flag("go_hot"))
	//{
		org anim_single_aligned(self, "run2prone_exit");
	//}
	
	self notify("getup");
		
	snow delete();
	wait( 5.0 );
	puff delete();
}


harris_prone()
{
	org = getstruct("runtoprone", "targetname");
	node = getnode( "node_harris_prone", "targetname" );
	snow = getent( "prone_hole_cover_1", "targetname" );
	puff = getent( "snow_puff_harris", "targetname" );
	
	level.harris.animname = "harris";
	
	wait(0.4);
	
	self disable_ai_color();
	
	org anim_reach_aligned(self, "run2prone_leadin");
	
	puff thread play_snow_puff();
		
	org anim_single_aligned(self, "run2prone_leadin");
	
	org thread anim_loop_aligned(self, "run2prone_idle");
	
	//self thread dog_spotted();
	
	flag_wait_any("prone_over", "go_hot");
	
	if (!flag("go_hot"))
	{
		wait(4.0);
	}
	
	//if (!flag("go_hot"))
	//{
		org anim_single_aligned(self, "run2prone_exit");
	//}
	
	self notify("getup");
		
	snow delete();
	wait( 5.0 );
	puff delete();
}


play_snow_puff()
{
	wait(0.85);
	
	playfxontag( level._effect["snow_puff"], self, "tag_origin" );
}


dog_spotted()
{
	self endon("getup");
	level endon("clear_rappel");
	
	org = getstruct("runtoprone", "targetname");
	
	while(!flag("go_hot"))
	{
		wait(0.05);
	}

	org anim_single_aligned(self, "run2prone_exit");
	
	self setgoalpos(self.origin);
}


check_player_spotted()
{
	level endon("prone_over");
	level endon("patrol_gone");
	
	guards = getentarray( "patrol_pursuit", "targetname" );
	for( i=0; i<guards.size; i++ )
	{
		guards[i] add_spawn_function( ::setup_patrol_pursuit );
	}
		
	player = get_players()[0];
	guys = getaiarray( "allies" );
	
	wait( 3.0 );
	
	while( ( player GetStance() == "prone" ) )
	{
		wait( 0.1 );
	}
	
	if ( ( player GetStance() != "prone" ) ) 
	{
		wait( 0.5 );
		
		flag_set( "go_hot" );
		level thread maps\wmd_amb::event_heart_beat("none");
	}
}


setup_squad_battle()
{
	level endon("breach_ready");
	
	flag_wait("go_hot");
	
	level thread shoot_dog();
	
	battlechatter_on();
	
	player = get_players()[0];
	
	player.ignoreme = false;
	
	guys = getaiarray( "allies" );
	node_harris = getnode("tower_node", "targetname");
	node_brooks = getnode("tower_cover2", "targetname");
	node_weaver = getnode("tower_cover1", "targetname");
	
	for( i=0; i<guys.size; i++ )
	{
		guys[i] disable_ai_color();
		guys[i].goalradius = 2048;
		guys[i].ignoreall = false;
		guys[i].ignoreme = false;
		guys[i] AllowedStances( "prone", "crouch", "stand" );
		
		if(flag("go_hot"))
		{
			guys[i] gun_switchto("aug_arctic_acog_sp", "right");
			level.weaver gun_switchto("ak12_zm", "right");
		}
	}
	
	waittill_ai_group_cleared("group_dog_handler");
	
	flag_set( "dog_gone" );
	flag_set("clear_rappel");
	
	battlechatter_off();
}


shoot_dog()
{
	wait(8.0);
	
	guys = getaiarray("allies");
	
	if (!flag("dog_dead"))
	{
		dog = getent("dog_ai", "targetname");
		
		for (i=0; i<guys.size; i++)
		{
			if (isAlive(dog))
			{
				guys[i] shoot_and_kill(dog);
			}
		}
	}
}


spawn_patrol01()
{
	wait( 10.0 );
	
	simple_spawn_single( "patrol1_01", ::setup_patrol1_01 );
	
	simple_spawn_single( "patrol1_02", ::setup_patrol_walk1 );
	simple_spawn_single( "patrol1_03", ::setup_patrol_walk2 );
	simple_spawn_single( "patrol1_04", ::setup_patrol_walk3 );
	simple_spawn_single( "patrol1_05", ::setup_patrol_walk5 );
	
	wait( 2.0 );
	
	simple_spawn_single( "patrol1_06", ::setup_patrol_walk1 );
	simple_spawn_single( "patrol1_07", ::setup_patrol_walk3 );
	
	wait( 2.0 );
	
	simple_spawn_single( "patrol1_08", ::setup_patrol_walk2 );
	simple_spawn_single( "patrol1_09", ::setup_patrol_walk5 );
	
	wait( 2.0 );
	
	simple_spawn_single( "patrol1_10", ::setup_patrol_walk2 );
	simple_spawn_single( "patrol1_11", ::setup_patrol_walk3 );
	
	wait(2.0);
	
	simple_spawn_single( "patrol1_12", ::setup_patrol_walk1 );
	
	wait(16.5);
	
	simple_spawn_single( "patrol1_13", ::setup_patrol_walk5 );
	
	level thread snow_fall();
	
	trigger = getent( "trigger_dog_patrol", "targetname" );
	trigger waittill("trigger");
	
	door = getent( "guardhouse_door", "targetname" );
	door connectpaths();
	
	door rotateyaw(-135, 1.0);
	
	simple_spawn_single("dog_handler", ::setup_dog_handler);
	
	flag_set( "hide_again" );
	
	wait(0.1);
	
	dog = getent("dog_ai", "targetname");
	dog thread dog_behave();
	
	wait(5.0);
	
	door rotateyaw(135, 1.0);
	door disconnectpaths();
}


snow_fall()
{
	wait(5.0);
	
	exploder(50);
}


setup_patrol1_01()
{
	self endon( "death" );
	
	self.script_radius = 16;
	self.ignoreall = true;
	self.disablearrivals = true;
	self.disableexits = true;
	self.animname = "generic";
	self.ikpriority = 5;
	self.disableTurns = true;
	
	self thread delete_patrol();
	self thread cold_breath("guy");
		
	node_delete = getnode( "node_patrol_delete", "targetname" );
	align = getent( "node_align_patrol", "targetname" );
	
	align anim_single_aligned( self, "patrol_leader_walk" );
	
	self delete();
}


setup_patrol()
{
	self endon( "death" );
	
	self.script_radius = 16;
	self.ignoreall = true;
	self.disablearrivals = true;
	self.disableexits = true;
	self.animname = "generic";
	self.ikpriority = 5;
		
	self thread delete_patrol();
	self thread cold_breath("guy");
}


setup_patrol_walk1()
{
	self thread setup_patrol();
	self set_run_anim("active_patrol_walk1");
}


setup_patrol_walk2()
{
	self thread setup_patrol();
	self set_run_anim("active_patrol_walk2");
}


setup_patrol_walk3()
{
	self thread setup_patrol();
	self set_run_anim("active_patrol_walk3");
}


setup_patrol_walk5()
{
	self thread setup_patrol();
	self set_run_anim("active_patrol_walk5");
}


setup_patrol_pursuit()
{
	self endon("death");
	
	self waittill("goal");
	
	player = get_players()[0];
	self.goalradius = 500;
	self.ignoresuppression = true;
	self setgoalentity( player );
	self waittill( "goal" );
	self.ignoresuppression = false;
}


scan_forward()
{
	self endon( "death" );
	
	while( 1 )
	{
		forward = AnglesToForward( self.angles );
	
		x = RandomIntRange( -500, 501 );
		y = RandomIntRange( -500, 501 );
		z = RandomIntRange( -200, 501 );
	
		aim_spot = ( ( self.origin + ( x, y, z ) ) + ( forward*600 ) );
	
		aim_ent = spawn( "script_origin", aim_spot );
	
		self aim_at_target( aim_ent );
	
		wait( RandomFloatRange( 0.8, 2.5 ) );
		
		self stop_aim_at_target();
		
		aim_ent delete();
		
		wait( RandomFloatRange( 0.5, 1.5 ) );
	}
}


guard_house()
{
	flag_set( "obj_insertion_a" ); // -- WWILLIAMS: SETS THE OBJECTIVE
	
	player = get_players()[0];
	
	flag_wait("dog_gone");
	flag_wait("clear_rappel");
	flag_wait("dog_dead");
	
	level thread maps\wmd_amb::event_heart_beat("none");
	
	wait(1.0);
	
	rappel_prepare();
}


dog_behave()
{
	self endon("death");
	
	self thread follow_handler();
	self thread dog_run_off();
	self thread wait_for_death();
		
	self.ignoreme = true;
	self.a.movement = "walk";
	
	self thread dog_bark_delay(3);
	
	flag_wait_any("go_hot", "alert_dog");
	
	self notify("stop_follow");
		
	self.a.movement = "run";
	
	playsoundatposition ("aml_dog_bark_close", self.origin);
	
	player = get_players()[0];
	self shoot_at_target(player);
}


wait_for_death()
{
	while(isAlive(self))
	{
		wait(0.1);
	}
	
	flag_set("dog_dead");
}


follow_handler()
{
	self endon("death");
	self endon("stop_follow");
	
	handler = getent("dog_handler_ai", "targetname");
	
	wait(7.0);
	
	while(isAlive(handler))
	{
		self.goalradius = 300;
		self setgoalpos(handler.origin + (-50, 50, 0));
		self waittill("goal");
	}
}


dog_run_off()
{
	self endon("death");
	self endon("go_hot");
	self endon("alert_dog");
	
	flag_wait("prone_over");
	
	self notify("stop_follow");
	
	self.a.movement = "run";
	
	self thread dog_bark_delay(.7);
	
	node = getnode("dog_end", "targetname");
	self setgoalnode(node);
	self waittill("goal");
	
	flag_set("dog_ran");
	
	wait(9.0);
	
	self delete();
}


dog_bark_delay(delay)
{
	self endon( "death" );
	
	if (IsDefined (self) && (delay == 3))
	{
		wait (delay);
		playsoundatposition ("evt_dog_bark_1", self.origin);
	}
	else if (IsDefined (self))
	{
		wait (delay);
		playsoundatposition ("evt_dog_bark_2", self.origin);
	}	
}


setup_dog_handler()
{
	self endon( "death" );
	
	self contextual_melee(false);
	
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self.ignoreall = true;
	self.goalradius = 16;
	self.dofiringdeath = false;
	
	self.animname = "generic";
	self.patrol_walk_anim = "active_patrol_walk1";
	
	self thread maps\wmd_amb::cb_audio_chatter();
	
	self thread check_handler_death();
	
	//wait( 1.0 );
	
	//patrol_path = "dog_patrol";
	
	//self thread maps\_patrol::patrol( patrol_path );
	
	self thread check_for_enemy();
	self thread hit_by_enemy();
	self thread check_dog_handler();
	self thread alert_dog_handler();
	self thread check_prone_over();
	self thread check_dog_death();
			
	wait( 2.0 );
	
	self thread check_sight();
	
	self waittill("reached_path_end");
	
	if (isAlive(self))
	{
		self delete();
	}
}


check_prone_over()	//self = dog handler
{
	self endon("death");
	self endon("alert");
	
	trigger_wait("trigger_prone_over");
	
	flag_set("prone_over");
		
	wait(1.5);
	
	self notify("end_patrol");
	
	//TUEY MUSIC stet to ON_THE_GO track
	setmusicstate("ON_THE_GO");
		
	node = getnode("chase_dog", "targetname");
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}


check_dog_handler()	//self = dog handler
{
	self endon("death");
	
	flag_wait( "go_hot" );
	
	self notify( "end_patrol" );
	
	self setgoalpos(self.origin);
	
	self.ignoreall = false;
	
	self.goalradius = level.default_goalradius;
	self.maxsightdistsqrd = self.old_sightdist;
}


alert_dog_handler()	//self = dog handler
{
	self endon("death");
	self endon( "handler_range" );	
	
	self waittill("alert");
	
	self.animname = "soviet";
	
	self anim_single(self, "soviet1");	//(Translated) What is it boy? Halt! Drop your weapons!
	
	wait( 0.5 );
	
	flag_set( "go_hot" );
	
	level thread maps\wmd_amb::event_heart_beat("none");
}


check_dog_death()
{
	self endon("death");
	self endon("dog_runoff");
	
	wait(0.1);
	
	dog = getent("dog_ai", "targetname");
	
	while(isAlive(dog))
	{
		wait(0.1);
	}
	
	if(!flag("dog_ran"))
	{
		self alert_notify_wrapper();
	}
}


check_handler_death()
{
	self waittill("death", attacker);
	
	if (isdefined(attacker))
	{
		if (attacker == get_players()[0])
		{
			flag_set("kill_dog");
			kill_dog();
		}
	}
	
	wait(1.0);
	
	flag_set("prone_over");
	flag_set("alert_dog");
	flag_set("dog_gone");
	
	level notify("patrol_gone");
	
	//TUEY MUSIC stet to ON_THE_GO track
	setmusicstate("ON_THE_GO");
}


kill_dog()
{
	guys = getaiarray("allies");
	dog = getent("dog_ai", "targetname");
	
	wait(0.5);
	
	if (isAlive(dog))
	{
		for(i=0; i<guys.size; i++)
		{
			guys[i] thread shoot_and_kill (dog);
		}
	}
}


check_for_enemy()
{
	self endon( "death" );
	self endon( "melee_victim" );
	
	self waittill_any( "grenade danger", "explode", "bulletwhizby" );
	
	wait( 0.2 );
	
	self alert_notify_wrapper();
}


hit_by_enemy()
{
	self endon("death");
	self endon( "melee_victim" );
	
	self waittill( "damage", amount, inflictor, direction, point, type, modelName, tagName );
	
	wait( 0.2 );

	self alert_notify_wrapper();
}


check_sight()
{
	self endon( "death" );
	self endon( "melee_victim" );
	self endon( "alert" );
	
	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			
			stance = players[i] getstance() ;
			dist = distancesquared( players[i].origin,self.origin);

				
			if(dist <= 128*128)					// alert if the player stands up within a 128 unit radius, otherwise no pose is safe if the guard can see the player
			{
				if( stance == "stand" && self can_see_player( players[i] ) )
				{
					wait(1);
					//self thread print3d_group_sight();
					self alert_notify_wrapper();
				}
				else if (self can_see_player(players[i]))
				{
					wait(1);
					//self thread print3d_group_sight();
					self alert_notify_wrapper();
				}
			}	
			else if(dist <= 512*512)		//only alert if the player is NOT proned and the guard has line of sight. If the player is prone, we dont' care if he's with a 512 unit radius
			{
				if(stance != "prone" && self can_see_player(players[i]))
				{
					wait(1);
					//self thread print3d_group_sight();
					self alert_notify_wrapper();
				}
			}			
		 	else if(dist <= 1024*1024)	//only alert if the player is standing within 1024 units and the guard has line of sight
			{
				if( stance == "stand" && self can_see_player(players[i]))
				{
					wait(1);
					//self thread print3d_group_sight();
					self alert_notify_wrapper();
				}
			}			
			
		}
		wait(.1);
	}
	
}


delete_patrol()
{
	self endon( "death" );
	self endon( "end_delete_patrol" );
	
	trigger = getent( "trigger_delete_patrol", "targetname" );
		
	while( 1 )
	{
		if ( self isTouching( trigger ) )
		{
			if ( isdefined( self ) )
			{
				self delete();
			}
		}
		wait( 0.1 );	
	}
}


spawn_patrol_pursuit()
{
	level endon("clear_rappel");
	
	flag_wait("go_hot");
	
	wait(2.0);
	
	spawn_manager_enable("manager_patrol_pursuit");
}


rappel_prepare()
{
	flag_set( "obj_insertion_b" );
		
	level thread weather_rotate();
	level thread anemometer();
	
	player = get_players()[0];
		
	align_node = ent_get("ambush_align");
	align_aim = ent_get("align_aim_over");
	
	level.harris enable_ai_color();
	
	trigger_use("triggercolor_harris_tower");
	
	level.harris thread cover_hill();
	
	guys = getaiarray( "allies" );
	for( i=0; i<guys.size; i++ )
	{
		guys[i] allowedstances("stand", "crouch", "prone");
		guys[i] gun_switchto("aug_arctic_acog_silencer_sp", "right");
	}	
	level.weaver gun_switchto("ak12_zm", "right");

	align_aim thread brooks_provides_cover();
	
	level.weaver.animname = "weaver";
	level.weaver allowedstances("stand");
		
	align_node anim_reach_aligned( level.weaver, "rappel_approach" );
	
	align_node anim_single_aligned( level.weaver, "rappel_approach" );
	
	align_node thread anim_loop_aligned( level.weaver, "rappel_railing_look", undefined, "stop_looking");
	
	cliff_glow = getent("rappelrail_cliff_glow", "targetname");
	cliff_rail = getent("rappelrail_cliff_normal", "targetname");
	
	cliff_rail hide();
	cliff_glow show();
	
	while( DistanceSquared( player.origin, level.weaver.origin ) > 256 * 256 )
	{
		wait(.05);
	}
	
	trig = ent_get("rappel_hookup");
	trig trigger_on();
	
	wait( 0.5 );
		
	align_node thread weaver_rappel_down();		
	
	flag_set("weaver_hookup");
	
	level notify("breach_ready");	
}


brooks_provides_cover()  //self=align_aim
{
	level.brooks.animname = "brooks";
	level.brooks allowedstances("stand");
	
	self anim_reach_aligned( level.brooks, "leadin_aim" );
	self anim_single_aligned( level.brooks, "leadin_aim" );
	self thread anim_loop_aligned( level.brooks, "aim_idle", undefined, "stop_covering" );
	
	flag_wait("go_breach");
	
	self notify("stop_covering");
}


weaver_rappel_down()	//self = anim align node
{
	rope = spawn_anim_model("weaver_rope");
	rope hide();
	
	wait(0.05);
	
	rope show();
	
	anim_ents = array(level.weaver, rope);
	
	level.rate = 1.0;
	
	//level.weaver thread create_weaver_rope(rope);
	
	self anim_single_aligned(anim_ents, "rappel_hookup");
		
	//level.weaver anim_set_blend_in_time(.2);
	
	rope delete();
	rope = spawn_anim_model("weaver_rope");
	anim_ents = array(level.weaver, rope);
	
	self thread anim_loop_aligned(anim_ents, "rappel_idle_a");
	weaver_wait_for_player();
	
	level thread monitor_rappel_gap();
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_a"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_a"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_a"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_a"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_a");
	}

	self thread anim_loop_aligned(anim_ents, "rappel_idle_b");
	weaver_wait_for_player();
	
	player_height = get_players()[0].origin[2];
	weaver_height = level.weaver.origin[2];
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_b"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_b"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_b"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_b"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_b");
	}

	self thread anim_loop_aligned(anim_ents, "rappel_idle_c");
	weaver_wait_for_player();
	
	player_height = get_players()[0].origin[2];
	weaver_height = level.weaver.origin[2];
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_c"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_c"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_c"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_c"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_c");
	}

	self thread anim_loop_aligned(anim_ents, "rappel_idle_d");
	weaver_wait_for_player();
	
	player_height = get_players()[0].origin[2];
	weaver_height = level.weaver.origin[2];
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_d"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_d"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_d"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_d"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_d");
	}

	self thread anim_loop_aligned(anim_ents, "rappel_idle_e");
	weaver_wait_for_player();
	
	player_height = get_players()[0].origin[2];
	weaver_height = level.weaver.origin[2];
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_e"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_e"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_e"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_e"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_e");
	}

	self thread anim_loop_aligned(anim_ents, "rappel_idle_f");
	weaver_wait_for_player();
	
	player_height = get_players()[0].origin[2];
	weaver_height = level.weaver.origin[2];
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_f"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_f"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_f"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_f"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_f");
	}

	self thread anim_loop_aligned(anim_ents, "rappel_idle_g");
	weaver_wait_for_player();
	
	player_height = get_players()[0].origin[2];
	weaver_height = level.weaver.origin[2];
	
	gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
	
	if (gap > 64)
	{
		anim_length = GetAnimLength(level.scr_anim["weaver"]["rappel_bounce_g"]) / level.rate;
		level.weaver AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver"]["rappel_bounce_g"], "normal", undefined, level.rate );
		//rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["rappel_rope"]["rappel_bounce_g"], "normal", undefined, level.rate );
		rope AnimScripted("fast_rappel", self.origin, self.angles, level.scr_anim["weaver_rope"]["rappel_bounce_g"], "normal", undefined, level.rate );
		wait(anim_length);
	}
	else
	{
		self anim_single_aligned(anim_ents, "rappel_bounce_g");
	}
	
	self thread anim_loop_aligned(anim_ents, "rappel_idle_h");
	weaver_wait_for_player();
	
	self anim_single_aligned(anim_ents, "rappel_bounce_h");
	
	level.weaver thread weaver_breach();
	
	flag_wait("hookup");
	
	rope delete();
}


monitor_rappel_gap()
{
	while(!flag("player_on_roof"))
	{
		gap = (level.weaver.origin[2] - get_players()[0].origin[2]);
		
		if (gap > 64 && gap < 100)
		{
			level.rate = 1.5;
		}
		else if (gap > 100 && gap < 150)
		{
			level.rate = 8.0;
		}
		else if (gap > 150)
		{
			level.rate = 16.0;
		}
		
		wait(0.05);
	}
	
	level.rate = 1.25;
}


create_weaver_rope(rope)
{
	ROPE_LENGTH = 1500;
	org = rope GetTagOrigin("Jnt_rope_120");
	self.rope = CreateRope(org, (0, 0, 0), ROPE_LENGTH, self, "tag_weapon_right");
	RopeRemoveAnchor(self.rope, 0);
	RopeSetFlag( self.rope, "collide", 1 );
	rope Delete();
}


weaver_wait_for_player()
{
	while (true)
	{
		player_height = get_players()[0].origin[2];
		weaver_height = level.weaver.origin[2];

		if ((player_height - weaver_height) < 100)
		{
			break;
		}

		wait .05;
	}
}


rappel_player_hookup()
{
	cliff_glow = getent("rappelrail_cliff_glow", "targetname");
	cliff_rail = getent("rappelrail_cliff_normal", "targetname");
	
	trig = ent_get("rappel_hookup");
	
	//client notify for sounds in power housebelow
	//	clientnotify("base_sounds_upper");
	level notify("base_sounds_upper");

	flag_set( "obj_insertion_c" );
	
	player = get_players()[0];
	
	while(1)
	{
		trig waittill("trigger");
		
		get_players()[0] SetScriptHintString(&"WMD_USE_HOOKUP");
		
		while((player isTouching(trig)) && (!player use_button_held()))
		{
			wait(0.05);
		}
		
		get_players()[0] SetScriptHintString("");
		
		if (player use_button_held())
		{
			break;
		}
	}
	
	cracked_backup = getent( "breach_window_cracked_backup", "targetname" );
	level.streamhintwindow = createStreamerHint(cracked_backup.origin, 1);
		
	cliff_glow delete();
	cliff_rail show();
	
	playsoundatposition("evt_rappel_plr_hookup_1", (0,0,0));
	
	align_node = ent_get("ambush_align");
	align_node notify("stop_looking");
	
	flag_set( "obj_substation" );
	
	trig delete();
}


breach_power_building()
{
	player = get_players()[0];	
	player maps\wmd_player_rappel::player_controllable_rappel("align_rappel");
	
	flag_wait("power_bld_guards_clear");
	
	victim = simple_spawn_single("overrail_victim", ::setup_victim);
	door = ent_get("pwr_door");

	door_clip = ent_get("pwr_door_clip");
	
	rope1 = spawn_anim_model("rope1");
	rope2 = spawn_anim_model("rope2");
	
	anim_ents = array(level.weaver, level.harris, level.brooks, victim, rope1, rope2);
	
	level.harris.animname = "harris";
	level.brooks.animname = "brooks";
	level.weaver.animname = "weaver";
	
	align_node = ent_get("align_reunited");
	
	guys = getaiarray( "allies" );
	// array_func( guys, ::disable_ai_color );
	
	align_node anim_reach_aligned( level.weaver, "reunited" );
	align_node thread anim_single_aligned( anim_ents, "reunited" );
	door thread breach_power_building_door(align_node);
	
	get_players()[0] SetLowReady(true);
	
	victim thread turn_off_invulnerability();
	
	wait(2.25);
	
	door_clip connectpaths();
	door_clip delete();
	
	exploder(60);
	
	align_node waittill( "reunited" );
	
	get_players()[0] SetLowReady(false);
	
	//align_node thread anim_loop_aligned(victim, "overrail_dead");
	
	flag_set("victim_dead");
	
	guys = getaiarray( "allies" );
	for( i=0; i<guys.size; i++ )
	{
		guys[i].ignoreall = true;
		// guys[i] enable_ai_color();
	}
	
	//wait(1.0);
	
	//victim stopanimscripted();
	
	//victim thread bloody_death(); 
}


#using_animtree("wmd");
breach_power_building_door(align_node)
{//self is door
	//self.animname = "pwr_door";
	//self UseAnimtree(#animtree);
	self init_anim_model("pwr_door", true);
	align_node thread anim_single_aligned( array(self), "reunited" );
	
	self connectpaths();
}
#using_animtree("generic_human");


setup_victim()
{
	self endon("death");
	self.goalradius = 16;
	self setcandamage(false);
	self.ignoreall = true;
	self.animname = "victim";
}


turn_off_invulnerability()
{
	self endon("death");
	wait(9.0);
	self setcandamage(true);
}


weaver_breach()  //self=level.weaver
{
	//HACK to fix Magic bullet shield looping anim
	self setcandamage(false);
	
	node = ent_get("align_window_breach");
	
	node anim_reach_aligned(self, "leadin_breach");
	
	player = get_players()[0];
	player thread player_breach_into_room();
	
	shack_glow = getent("rappelrail_powershack_glow", "targetname");
	shack_normal = getent("rappelrail_powershack_normal", "targetname");
	
	shack_glow show();
	shack_normal hide();
	
	node anim_single_aligned(self, "leadin_breach");
	node thread anim_loop_aligned(self, "ready_hookup_idle");
	
	//self thread cold_breath("guy");
	
	flag_wait("hookup");
	
	level.weaver playsound ("evt_rappel_npc_hookup_2");
	
	rope = spawn_anim_model("weaver_rope");
	
	anim_ents = array(self, rope);
	
	node anim_single_aligned(anim_ents, "window_hookup");
	node thread anim_loop_aligned(anim_ents, "ready_breach_idle");
	
	flag_set("breach_ago");
	
	flag_wait("go_breach");
	
	level thread kill_substation_guard();
		
	node anim_single_aligned(anim_ents, "window_breach");
	
	self.ignoreall = false;
	
	waittill_ai_group_cleared("power_bld_guards");
	
	self.ignoreall = true;
	
	self allowedstances("stand", "crouch", "prone");
	
	//self notify("stop_breath");
	
	flag_set( "power_bld_guards_clear" );
	//self setcandamage(true);
}


kill_substation_guard()
{
	wait(4.0);
	
	guy = getai_by_noteworthy("breach_guard");
	
	if (isAlive(guy))
	{
		guy thread bloody_death(true, 0);
	}
}


player_breach_into_room()
{
	trig = ent_get("power_breach");
	
	player = get_players()[0];
	
	cracked1 = getent("breach_window_cracked_1", "targetname");
	cracked1 ForceTexturesToLoad(true);
		
	while(1)
	{
		trig waittill("trigger");
		
		get_players()[0] SetScriptHintString(&"WMD_USE_HOOKUP");
		
		while((player isTouching(trig)) && (!player use_button_held()))
		{
			wait(0.05);
		}
		
		get_players()[0] SetScriptHintString("");
		
		if (player use_button_held())
		{
			break;
		}
	}
	
	player AllowMelee(false);
	
	flag_set("hookup");
	
	node = ent_get( "ambush_align" );
	align_node = ent_get("align_window_breach");
	
	self HideViewModel();
	self DisableWeapons();
	self setstance("stand");
	
	self.body hide();
	
	anim_length = GetAnimLength(level.scr_anim["player_body"]["player_window_hookup"]);
	
	align_node thread anim_single_aligned(self.body,"player_window_hookup");
	
	wait(0.05);
	
	self StartCameraTween(0.2);
	
	self playerlinktoabsolute(self.body,"tag_player");
	
	shack_glow = getent("rappelrail_powershack_glow", "targetname");
	shack_normal = getent("rappelrail_powershack_normal", "targetname");
	
	shack_glow delete();
	shack_normal show();
	
	playsoundatposition("evt_rappel_plr_hookup_2", (0,0,0));
	
	self AllowAds( false );
	
	//self.body.origin = self.origin;
		
	DeleteRope(self.rope);
	
	wait(0.3);
	
	self.body show();
	
	wait(anim_length - .35);
	
	self StartCameraTween(0.6);
	
	self PlayerLinktoDelta(self.body,"tag_player",1, 45, 25, 15, 0);
	
	align_node thread anim_loop_aligned(self.body,"player_window_idle",undefined,"stop_player_idle");
	
	simple_spawn("power_bld_guards",::setup_breach_guards_react);
	
	flag_wait("breach_ago");
	
	screen_message_create( &"WMD_RAPPEL_LT" );
	
	while ( !self ThrowButtonPressed() )
	{
		wait(0.05);
	}
	
	self PlayRumbleOnEntity("damage_light");
	
	//TUEY setting music to NONE (which has the breech state in it)
	setmusicstate("NONE");
	
	ClientNotify ("wbr"); //Change the Reverb here
	
	playsoundatposition ("evt_time_slow_start", (0,0,0));
	
	playsoundatposition ("vox_breech_yell", (0,0,0));

	level thread window_swap();
	
	screen_message_delete();
	
	flag_set("go_breach");
	
	node notify("stop_player_idle");

	align_node thread anim_single_aligned(self.body,"player_window_breach");
	
	level thread vo_post_breach();
	self thread enable_breach_weapon();
	level thread alert_station_guards();
	level thread power_stations_guards();
	level thread vo_window_breach();
		
	clientnotify ("breach_sound_go");
	
	self StartCameraTween( 0.7 );
	self SetPlayerAngles((0, 200, 0));

	//timescale_tween(start, end, time, delay, step_time)
	wait( 0.5 );
	level timescale_tween( 1.0, 0.3, 0.3 );
	
	flag_wait("window_breached");
	
	get_players()[0].ignoreme = false;
	
	self thread breach_rumble();
		
	self thread player_window_unlink();
	level thread breach_timer();
	level thread check_breach_reload();
	
	self SetClientDvar("r_enablePlayerShadow", 1);
	VisionSetNaked( "wmd_power_station" );
	
	wait( 0.1 );
	
	level timescale_tween( 0.06, 0.3, 0.4 );
	
	flag_wait("restore_time");
	playsoundatposition ("evt_time_slow_stop", (0,0,0));
	
	timescale_tween( 0.3, 1.0, 2.0 );
	
	//client notify for sound snapshot
	clientnotify ("Breach_sound_stop");
	
	level notify("set_relay_station_fog");
}


setup_foreshadow_victim()
{
	self endon("death");
	self.ignoreall = true;
	self.goalradius = 16;
	self waittill("goal");
	self delete();
}


breach_rumble()
{
	self PlayRumbleOnEntity("damage_light");
	
	wait(0.3);
	
	self PlayRumbleOnEntity("damage_heavy");
}


enable_breach_weapon()
{
	wait( 0.1 );
	
	currentweapon = self GetCurrentWeapon();
	
	primaryWeapons = self GetWeaponsListPrimaries();
	
	if (currentweapon == "crossbow_vzoom_alt_sp" || currentweapon == "crossbow_explosive_alt_sp" || currentweapon == "gl_famas_sp")
	{
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			if (primaryWeapons[0] ==  "crossbow_vzoom_alt_sp")
			{
				self SwitchToWeapon(primaryWeapons[1]);
				self SetWeaponAmmoClip(primaryWeapons[1], 30);
			}
			else
			{
				self SwitchToWeapon(primaryWeapons[0]);
				self SetWeaponAmmoClip(primaryWeapons[0], 30);
			}
		}
	}
	
	if (currentweapon == "aug_arctic_acog_silencer_sp")
	{
		self SetWeaponAmmoClip("aug_arctic_acog_silencer_sp", 30);
	}
	
	if (currentweapon == "famas_sp" || currentweapon == "famas_acog_sp" || currentweapon == "famas_dualclip_sp" || currentweapon == "famas_elbit_sp" || 
		currentweapon == "famas_gl_sp" || currentweapon == "famas_reflex_sp" || currentweapon == "gl_famas_sp")
	{
		self SetWeaponAmmoClip("famas_sp", 30);
	}
	
	if (currentweapon == "ks23_sp")
	{
		self SetWeaponAmmoClip("ks23_sp", 7);
	}
	
	if (currentweapon == "hk21_sp")
	{
		self SetWeaponAmmoClip("hk21_sp", 30);
	}
			
	wait(0.05);
	
	// so that it looks like the player is firing with one hand while breaching ;)
	self setviewmodel("viewmodel_hands_no_model");
	self ShowViewModel();
	self enableweapons();
}


// threaded from wmd_anim.gsc
papers_please()
{
	dmg = getstruct( "dmg_papers", "targetname" );
	glass = getent( "tag_glass_break", "targetname" );
	phy_blast = getstruct( "window_physics_blast", "targetname" );
	papers = GetEnt( "relay_station_fx", "targetname" );
	sparks1 = getent( "cable_sparks", "targetname" );
	sparks2 = getent( "monitor_sparks", "targetname" );
	sparks3 = getent( "power_sparks", "targetname" );
	sparks4 = getent( "power_sparks", "targetname" );
	blowup1 = getstruct( "blowup_console", "targetname" );
	con_sparks1 = getent( "console_sparks1", "targetname" );
	con_sparks2 = getent( "console_sparks2", "targetname" );
	con_sparks3 = getent( "console_sparks3", "targetname" );
	cotton1 = getent( "cotton1", "targetname" );
	water1 = getent( "water1", "targetname" );
	phy_lamp = getstruct( "phy_lamp", "targetname" );
	
	radiusdamage( dmg.origin, 64, 150, 150 );
	
	PhysicsExplosionSphere( phy_blast.origin, 240, 240, 0.6 );
		
	playfxontag( level._effect["glass_break"], glass, "tag_origin" );
	playfxontag( level._effect["wire_sparks"], sparks1, "tag_origin" );
	playfxontag( level._effect["breach_water"], water1, "tag_origin" );
	
	wait( 0.05 );
	
	playfxontag( level._effect["breach_cotton"], cotton1, "tag_origin" );
	playfxontag( level._effect["wire_sparks"], sparks3, "tag_origin" );
	
	wait( 0.15 );
	
	playfxontag( level._effect["wire_sparks"], sparks2, "tag_origin" );
	playfxontag( level._effect["breach_sparks"], con_sparks1, "tag_origin" );
	
	wait( 0.15 );
	
	radiusdamage( blowup1.origin, 32, 1000, 1000 );
	playfxontag( level._effect["breach_sparks"], con_sparks2, "tag_origin" );
	PhysicsExplosionSphere( phy_lamp.origin, 240, 240, 0.6 );
	
	wait( 0.5 );
	
	radiusdamage( con_sparks3.origin, 32, 1000, 1000 );
	playfxontag( level._effect["breach_sparks"], con_sparks3, "tag_origin" );
		
	wait( 1.0 );
	
	playfxontag( level._effect["swirling_amb"], papers, "tag_origin" );
	playfxontag( level._effect["debris_papers_windy"], papers, "tag_origin" );
}


power_stations_guards()
{
	waittill_ai_group_cleared("power_bld_guards");
	
	flag_set( "restore_time" );
}


breach_timer()
{
	wait( 2.0 );
	
	flag_set( "restore_time" );
}


check_breach_reload()
{
	player = get_players()[0];
	
	while( 1 )
	{
		if ( player isplayerreloading() )
		{
			flag_set( "restore_time" );
			break;
		}
		wait( 0.05 );
	}
}


window_swap()
{
	level thread window1_damaged();
		
	solid1 = getent( "breach_window_solid_1", "targetname" );
	cracked1 = getent( "breach_window_cracked_1", "targetname" );
	cracked_backup = getent( "breach_window_cracked_backup", "targetname" );
	damaged1 = getent( "breach_window_damaged_1", "targetname" );
	
	flag_wait( "window_breached" );
	
	level notify("end_window");
	
	if (isdefined(solid1))
	{
		solid1 delete();
	}
	
	cracked1 show();
	
	//wait(0.05);
	
	cracked1 ForceTexturesToLoad(false);
	
	cracked1 delete();
	cracked_backup delete();
	level.streamhintwindow delete();
	
	damaged1 show();
}


window1_damaged()
{
	level endon( "end_window" );
	
	solid1 = getent( "breach_window_solid_1", "targetname" );
	cracked1 = getent( "breach_window_cracked_1", "targetname" );
	
	solid1 setcandamage( true );
	
	solid1 waittill( "damage" );
	
	solid1 delete();
	
	cracked1 show();
}


player_window_unlink()
{
	//align_node = ent_get("align_window_breach");
	
	//align_node waittill("player_window_breach");
	
	wait(1.0);
	
	self unlink();
	self.body delete();
	
	self AllowMelee(true);
}


alert_station_guards()
{
	//the guards "wake up" as the player is breaching
	guards = get_ai_group_ai("power_bld_guards");
	for(i=0;i<guards.size;i++)
	{
		guards[i] alert_notify_wrapper();
	}
}


setup_breach_guards_react()
{
	self endon("death");	
	
	self.goalradius = 16;
	self.ignoreall = true;
	self.health = 1;
	self.allowdeath = true;
	
	flag_wait("go_breach");
	
	node = ent_get("align_window_breach");
	node anim_single_aligned(self,"window_react");
	
	self.goalradius = 200;
	self.ignoreall = false;
}


weather_rotate()
{
	//level endon("jump_down");
	
	spinner = getentarray("weather_meter_spinner", "targetname");
	while (1)
	{	
		for(i=0; i<spinner.size; i++)
		{
			spinner[i] rotateyaw(-60, 0.1);	
			//spinner[i] waittill("rotatedone");
			wait(0.05);
		}
	}
}


anemometer()
{
	//level endon("jump_down");
	
	meter2 = getentarray( "weather_meter_pointer", "targetname" );
	
	while( 1 )
	{
		for(i=0; i < meter2.size; i++)
		{
			meter2[i] BypassSledgehammer();
		
			time = RandomFloatRange( 0.5, 2.0 );
			
			meter2[i] rotateyaw( 10, time );
			//meter2[i] waittill( "rotatedone" );
			
			wait(0.1);	
			
			meter2[i] rotateyaw( -10, time );
			//meter2[i] waittill( "rotatedone" );
		}	
	}
}


vo_snow_hide()	//self = player
{
	self.animname = "hudson";
	
	wait(9.0);
	
	self anim_single(self, "stay_low");		//Stay low... Here they come�
	
	wait(0.5);
	
	self anim_single(self, "hold");	//Hold position... Hold position�
	
	flag_wait("patrol_done");
	
	self anim_single(self, "guardhouse");	//Clear. More soldiers are on their way. Get to that guard house. GO!
}

	
vo_hide_guard()	//self = weaver
{
	self.animname = "weaver";
	
	//SOUND - Shawn J
	playsoundatposition("fly_guard_door_o",(11603, -38964, 43042));
	
	self anim_single(self, "halt"); //halt
	
	wait(0.5);
	
	self anim_single(self, "dont_move"); //Don't move�
	
	flag_wait("dog_gone");
	
	wait(1.0);
	
	flag_wait("dog_dead");
	flag_wait("clear_rappel");
	
	self anim_single(self, "clear"); //Clear
		
	wait(0.5);
		
	player = get_players()[0];
	player.animname = "hudson";
	
	if (!flag("weaver_hookup"))
	{
		player anim_single(player, "bigeye");  //BigEye this is Kilo One, over. You still have us on Tac?
			
		wait(0.5);
	}
	
	if (!flag("weaver_hookup"))
	{
		player anim_single(player, "affirmative");  //Affirmative Kilo One.
	
		wait(0.3);
	}
	
	if (!flag("weaver_hookup"))
	{
		player anim_single(player, "visibility"); //Visibility has improved. We're starting our insertion. Moving to the substation.
		
		wait(0.3);
	}
	
	if (!flag("weaver_hookup"))
	{
		player anim_single(player, "tracking"); //Tracking... Bigeye sees four combatants entering the structure, over.
	
		wait(0.3);
	}
	
	if (!flag("weaver_hookup"))
	{
		player anim_single(player, "going_in");	//Copy that BigEye, we're going in.
	}
}


vo_window_breach()
{
	guy = getai_by_noteworthy("breach_guard");
	
	flag_wait("window_breached");
	
	wait(0.2);
	
	if (isAlive(guy))
	{
		guy anim_single(guy, "soviet2");  //Sound the alarm!  We're under attack!
	}
	
	if (isAlive(guy))
	{
		guy anim_single(guy, "soviet3");  ////Move it!  Move it!
	}
}


vo_post_breach()	//self = player
{
	level endon("approach_choppers");
	
	get_players()[0].animname = "hudson";
	
	flag_wait("victim_dead");
	
	get_players()[0] anim_single(get_players()[0], "substation");	//BigEye, this is Kilo One. We have taken substation.
	
	//TUEy set music to 
	setmusicstate ("WINDOW_BREACH");
		
	wait(0.5);
	
	get_players()[0] anim_single(get_players()[0], "focal_spread");	//Understood.  Re-calibrating Focal spread. Okay - We have Comstat on Tac. Proceed to next objective.
	
	wait(0.5);
	
	flag_wait("vo_facility");
	
	get_players()[0] anim_single(get_players()[0], "main_facility");		//Main facility is located at the base of the ridge.  
	
	wait(0.5);
	
	get_players()[0] anim_single(get_players()[0], "find_evidence");	//If we're gonna find evidence that Nova six has been weaponized, it'll be there.
	
	wait(0.5);
	
	get_players()[0] anim_single(get_players()[0], "knock_out");	//Once we knock out the external comms, they'll realize something's wrong.
	
	wait(0.5);
	
	get_players()[0] anim_single(get_players()[0], "destroy_intel");	//We'll need to move fast - before they can destroy any intel.
	
	wait(0.5);
	
	get_players()[0] anim_single(get_players()[0], "stay_sharp");	//Stay sharp.
}
 