#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\cuba_util;
#include maps\_vehicle;
#include maps\_music;

start()
{
	battlechatter_off();

	level.INTRO_FLAME_END		= 4;
	level.INTRO_FLAME_PAUSE		= .25;
	level.INTRO_FLAME_BACK_FADE	= 1.1;

	level.INTRO_PLAYER_CLAMP_RIGHT = 45;
	level.INTRO_PLAYER_CLAMP_LEFT = 30;
	level.INTRO_PLAYER_CLAMP_TOP = 20;
	level.INTRO_PLAYER_CLAMP_BOTTOM = 10;

	event_thread("bar", ::intro_player);
	event_thread("bar", ::intro_flame);
	event_thread("bar", ::bar_scene_main);
	event_thread("bar", ::outside_scene);

	level thread maps\cuba_amb::bar_amb();

	// waittill bar scene is finished and move to streets
	flag_wait("start_exit");

	// save the game
	flag_set("bar_scene_finished"); // turns on triggers
}

setup_bar_flags()
{
	flag_init("start_intro_flame");				// set when player is in place and we can start the flame
	flag_init("flame_end");
	flag_init("player_ready"); 					// set when player is ready to start the bar sequence
	flag_init("map_spawned");
	flag_init("thugs_start");					// set when enemies are supposed to come into the bar
	flag_init("player_picked_up_gun");       	// set when player picks up the gun
	flag_init("bar_door_opened");			    // set when the bar door is opened
	flag_init("knife_in_leader_hand");	   	    // set when knife is stabbed in leaders hand
	flag_init("take_control");
	flag_init("start_exit");
	flag_init("start_exit2");
	flag_init("outside_scene_ready");
}

get_align_pt()
{
	if (!IsDefined(level.bar_align_orgs))
	{
		level.bar_align_orgs = [];
	}

	if (!IsDefined(level.bar_align_orgs[self.animname]))
	{
		node = GetNode("bar_node", "targetname");
		org = Spawn("script_origin", node.origin);
		org.angles = node.angles;
		
		level.bar_align_orgs[self.animname] = org;
	}

	return level.bar_align_orgs[self.animname];
}

delete_align_pts()
{
	array_func(level.bar_align_orgs, ::self_delete);
}

intro_player()
{
	player = get_players()[0];
	player_bar_node = player get_align_pt();

	player TakeAllWeapons();
	player GiveWeapon("asp_sp_bar");

	player DisableWeapons();
	//player DisableWeaponCycling();
	player AllowCrouch(false);
	player AllowProne(false);

	maps\createart\cuba_art::set_cuba_dof( "bar" );

	// slow movement
	player SetPlayerViewRateScale(40);

	level.player_model = spawn_anim_model("player_hands");
	player_bar_node anim_first_frame(level.player_model, "intro");

	wait .05;
	
	player SetPlayerAngles( level.player_model GetTagAngles( "tag_player" ) );
	player PlayerLinkToAbsolute(level.player_model, "tag_player");

	wait 2;

	player play_vo("police_will_be_here_soon");

	flag_set("start_intro_flame");
	level thread maps\cuba_amb::bar_cardoor();	

	flag_wait("flame_end");

	player_bar_node thread anim_single_aligned(level.player_model, "intro");

	wait 2;

	player StartCameraTween( 1 );

	// keep player locked but allow looking now
	player SetPlayerAngles( level.player_model GetTagAngles( "tag_player" ) );
	player PlayerLinkTo( level.player_model, "tag_player", 0, level.INTRO_PLAYER_CLAMP_RIGHT, level.INTRO_PLAYER_CLAMP_LEFT, level.INTRO_PLAYER_CLAMP_TOP, level.INTRO_PLAYER_CLAMP_BOTTOM );

	event_thread("bar", ::player_tracking);

	//player delayThread(7.2, ::play_vo, "sup_carlos");
	//player delayThread(11.5, ::play_vo, "hope_he_did");
	//player delayThread(38, ::play_vo, "be_cool");

	flag_wait("knife_in_leader_hand");

	if (IsAlive(level.thug1))
	{
		level.thug1 gun_remove();
	}

	wait 1;

	player PlayerLinkTo( level.player_model, "tag_player", 0, level.INTRO_PLAYER_CLAMP_RIGHT, level.INTRO_PLAYER_CLAMP_LEFT, level.INTRO_PLAYER_CLAMP_TOP, level.INTRO_PLAYER_CLAMP_BOTTOM );

	player EnableWeapons();
	player SwitchToWeapon("asp_sp_bar");

	level thread show_ads_message();

	wait .2;

	player look_at(level.thug3 get_eye(), .5);

	sticky_org = Spawn("script_origin", player GetOrigin());
	sticky_org.angles = player GetPlayerAngles();

	player PlayerLinkTo(sticky_org, undefined, 0, 15, 15, 20, 20);
	player FreezeControls( false );

	player SetClientDvar("ammoCounterHide", 0);

	player ResetPlayerViewRateScale();

	player setClientDvar( "r_dof_tweak", 0 );

	flag_wait("start_exit");
	hide_ads_message();

	player HideViewModel();
	player DisableWeapons();

	player_bar_node thread anim_single_aligned(level.player_model, "exit");
	wait .05;

	level.player_model Attach(GetWeaponModel(level.player_switchweapon), "tag_weapon", true);
	level.player_model UseWeaponHideTags(level.player_switchweapon);

	player StartCameraTween(.2);
	player PlayerLinkToAbsolute(level.player_model, "tag_player");

	sticky_org Delete();

	wait .3;
	flag_set("start_exit2");

	if (IsAlive(level.leader))
	{
		level.leader gun_remove();
	}
	
	if (IsAlive(level.thug2))
	{
		level.thug2 gun_remove();
	}

	if (IsAlive(level.thug3))
	{
		level.thug3 gun_remove();
	}

	player_bar_node waittill("exit");

	//player delayThread(0, ::play_vo, "gear_up");

	bar_reset(level.carlos);

	//level.carlos delayThread(3, ::play_vo, "weapons_ready");

	player TakeAllWeapons();
	
	player Unlink();
	level.player_model Delete();

	player EnableWeapons();
	player ShowViewModel();

	player GiveWeapon("knife_sp");
	player GiveWeapon(level.player_switchweapon);
	player GiveWeapon("asp_sp");
	player GiveWeapon("frag_grenade_sp");

	player SwitchToWeapon(level.player_switchweapon);

	player SetLowReady(true);
	player AllowCrouch(true);
	player AllowProne(true);

	get_players()[0] SetClientDvar("cg_drawFriendlyNames", 1);

	player thread avoid_gl_message();
}

avoid_gl_message()
{
	level endon ("start_drive");

	while (!flag("player_used_alt_weapon"))
	{
		self waittill( "weapon_change", weapon );

		if( is_weapon_attachment( weapon ) )
		{
			flag_set("player_used_alt_weapon");
		}
	}
}

show_ads_message()
{
	if (!flag("player_used_ads"))
	{
		level endon("hide_ads_message");
		
		screen_message_create(&"CUBA_HINT_ADS");
		
		while (!get_players()[0] AdsButtonPressed())
		{
			wait .05;
		}

		flag_set("player_used_ads");

		level thread hide_ads_message();
	}
}

hide_ads_message()
{
	level notify("hide_ads_message");
	screen_message_delete();
}

intro_flame()
{
 	level thread black_screen();
	flag_wait("start_intro_flame");

	// set flame special vision set
	VisionSetNaked( "cuba_flame", 0.1 );

	// find out where we can play the flame, should be normal to where player is looking
	origin = level.player_model GetTagOrigin( "tag_camera" );
	vec = AnglesToForward( level.player_model GetTagAngles( "tag_camera" ) );
	vec = vector_scale( vec, 15 );

	offset = -2;
	origin = origin + ( 0, 0, offset ) + vec;

	wait(0.5);

	flame = SpawnFx( level._effect["intro_flame"], origin, vec * -1, ( 0, 0, 1 ) );
	TriggerFX( flame, GetTime() / 1000 );

	wait (level.INTRO_FLAME_END);
	flag_set("flame_end");

	level thread maps\_introscreen::introscreen_redact_delay( &"CUBA_INTROSCREEN_TITLE", &"CUBA_INTROSCREEN_PLACE", &"CUBA_INTROSCREEN_TARGET", &"CUBA_INTROSCREEN_TEAM", &"CUBA_INTROSCREEN_DATE", 2, 22, undefined, 1.8, 2 );

	wait (level.INTRO_FLAME_PAUSE);

	wait (level.INTRO_FLAME_BACK_FADE);

	// switch back to cuba vision set
	VisionSetNaked( "cuba", 0.1 );
}

black_screen()
{
	get_players()[0] SetClientDvar("cg_drawFriendlyNames", 0);
	get_players()[0] SetClientDvar("ammoCounterHide", 1);

	black = NewClientHudElem(get_players()[0]);
	black SetShader("black", 640, 480);
	black.x = 0;
	black.y = 0;
	black.horzAlign  = "fullscreen";
	black.vertAlign  = "fullscreen";
	black.sort = 0;
	black.alpha = 1;

	flag_wait("start_intro_flame");

	wait .5;

	black FadeOverTime(.3);
	black.alpha = 0;

	wait .3;

   	black Destroy();
}

// --------------------------------------------------------------------------------
// ---- Bar scene main ----
// --------------------------------------------------------------------------------

bar_scene_main()
{
	// delete extra spawners that were added to include bar character assests
	array_thread( GetEntArray( "friendlies_bar_spawners", "script_noteworthy" ), ::self_delete );

	level.bowman 	 = get_hero_by_name("bowman", ::setup_for_bar, true);
	level.woods 	 = get_hero_by_name("woods", ::setup_for_bar, true);
	level.carlos     = get_hero_by_name("carlos", ::setup_for_bar, true);
	squad = array(level.bowman, level.woods, level.carlos);

	array_func(squad, ::make_casual);

	level.woods Detach(level.woods.headModel);
	level.woods.headModel = "t5_gfl_hk416_v2_head";
	level.woods attach(level.woods.headModel, "", true);

	level.bowman Detach(level.bowman.headModel);
	level.bowman.headModel = "t5_gfl_ump9_head";
	level.bowman attach(level.bowman.headModel, "", true);
	level.bowman attach("t5_gfl_ump9_hair", "", true);

	level.carlos Detach(level.carlos.headModel);
	level.carlos.headModel = "t5_gfl_p90_head";
	level.carlos attach(level.carlos.headModel, "", true);
	level.carlos attach("t5_gfl_p90_hair", "", true);

	woman = simple_spawn_single("woman", ::setup_for_bar, true);
	patrons = simple_spawn("patrons", ::setup_for_bar, true);
	patrons = array_add(patrons, woman);

	level.woods.bottle = GetEnt("whisky_bottle", "targetname");
	
	event_thread("bar", ::bar_door_think);

	level.woods thread animate_woods();
	level.bowman thread animate_bowman();
	level.carlos thread animate_carlos();

	array_thread(patrons, ::animate, "intro", ::self_delete, "flame_end");

	// 	delete_align_pts();
}

animate_woods()
{
	self thread animate_woods_intro();
	self thread animate_woods_exit();

	flag_wait("start_exit");

	gun = spawn_anim_model("woods_gun", undefined, undefined, true);
	gun UseWeaponHideTags("m16_sp");
	gun thread animate_loop("exit_loop");

	self waittill("bar_reset");
	gun Delete();
}

animate_woods_intro()
{
	self animate("intro", undefined, "flame_end");
	self.intro_done = true;
	self animate("exit", undefined, "start_exit2");
}

animate_woods_exit()
{
	flag_wait("start_exit2");
	if (!is_true(self.intro_done))
	{
		self thread animate("exit");
	}

	level.leader Detach("weapon_parabolic_knife", "tag_weapon_right");
	self Attach("weapon_parabolic_knife", "tag_weapon_chest");

	len = GetAnimLength(self get_anim("exit"));
	wait (len - 2);

	self play_vo("clear_them_out");

	//wait 2;

	self play_vo("bowman_take_the_right");
	wait 1;
	level.bowman play_vo("on_it");
}

leader_think()
{
	level.leader = simple_spawn_single("leader", ::setup_for_bar, true);
	level.leader DisableAimAssist();
	level.leader thread animate_leader_intro();
	level.leader animate_leader_exit();
}

animate_leader_intro()
{
	self animate("intro");
	self.intro_done = true;
	level.leader animate("exit", ::ragdoll_death, "start_exit2");
}

animate_leader_exit()
{
	flag_wait("start_exit2");
	if (!is_true(self.intro_done))
	{
		self animate("exit", ::ragdoll_death);
	}
}

animate_bowman()
{
	self thread animate_bowman_intro();
	self thread animate_bowman_exit();
}

animate_bowman_intro()
{
	self animate("intro", undefined, "flame_end");
	self.intro_done = true;
	self thread animate("exit", undefined, "start_exit");
	wait .1;
	self bar_reset();
}

animate_bowman_exit()
{
	flag_wait("start_exit2");
	if (!is_true(self.intro_done))
	{
		self thread animate("exit");
		wait .1;
		self bar_reset();
	}
}

animate_carlos()
{
	self thread animate("intro", undefined, "flame_end");
	flag_wait("start_exit");
	self bar_reset();
	self animate("exit");
	flag_set("police_chatter");
}

animate(scene, func_when_done, wait_for_flag, delay)
{
	self notify("new_animation");
	self endon("new_animation");

	node = self get_align_pt();

	if (IsDefined(wait_for_flag))
	{
		node anim_first_frame(self, scene);
		flag_wait(wait_for_flag);
	}

	if (IsDefined(delay))
	{
		wait delay;
	}

	node anim_single_aligned(self, scene);

	if (IsDefined(func_when_done))
	{
		self [[ func_when_done ]]();
	}
}

animate_loop(scene)
{
	node = self get_align_pt();
	node anim_loop_aligned(self, scene);
}

// player looks at the leader as he tries to grab him
grab_player(guy)
{
	level notify("player_grabbed");
	player = get_players()[0];
	player StartCameraTween(.3);
	player PlayerLinkTo(level.player_model, "tag_player", 1, 0, 0, 0, 0);
	
	//TUEY notifies the ambient scritp to kill the bar sounds over the next 5 seconds.
	level notify ("UH_OH");
}

look_at_door(guy)
{
	flag_set("take_control");
	wait 4;
	flag_clear("take_control");
}

// --------------------------------------------------------------------------------
// ---- Bar door ----
// --------------------------------------------------------------------------------
bar_door_think()
{
	level thread door_idle();
	flag_wait("thugs_start");
	open_door("thugs");
	wait(3);
}

woods_opens_door(woods) // from notetrack
{
	level thread open_door("woods");
	get_players()[0] SetLowReady(false);

	level thread autosave_by_name("bar_end");
	
	//TUEY set music to STREET
	setmusicstate ("STREET");

	wait 2;
	maps\cuba_street::set_street_objective();

	level thread show_ads_message();
}

init_door()
{
	if (!IsDefined(level.init_door))
	{
		level.bar_door = GetEnt("bar_door", "targetname");
		level.bar_door init_anim_model("door", true);
	}

	level.init_door = true;
}

door_idle()
{
	init_door();
	level.bar_door animate_loop("closed_loop");
}

open_door(who)
{
	init_door();

	if (!IsDefined(who) || (who == "woods"))
	{
		GetEnt("bar_door_blocker", "targetname") NotSolid();

		level.bar_door animate("open");
		maps\createart\cuba_art::reset_cuba_dof();
		flag_set( "bar_door_opened" );
	}
	else
	{
		level.bar_door animate("first_open");
	}
}

close_bar_door(thug3)	// from notetrack
{
	init_door();

	flag_clear( "bar_door_opened" );

	//level.bar_door animate_loop("closed_loop");
	level.bar_door animate("intro_close");

	//GetEnt("bar_door_blocker", "targetname") Solid();
}

// --------------------------------------------------------------------------------
// ---- handle props and events ----
// --------------------------------------------------------------------------------
woods_give_knife( guy ) // give knife to woods
{
	level.woods Attach("weapon_parabolic_knife", "tag_weapon_chest");

// 	if( !IsDefined( level.woods.knifed ) )
// 	{
// 		level.woods.knifed = true;
// 
// 		//level.woods.knife = Spawn( "script_model", level.woods GetTagOrigin( "tag_weapon_chest" ) );
// 		//level.woods.knife SetModel( "weapon_parabolic_knife" );
// 	
// 		//level.woods.knife LinkTo( level.woods, "tag_weapon_chest", ( 0,0,0 ), ( 0,0,0 ) );
// 	}
// 	else
// 	{
// 		//level.woods.knife LinkTo( level.woods, "tag_weapon_chest", ( 0,0,0 ), ( 0,0,0 ) );
// 		level.woods Attach("weapon_parabolic_knife", "tag_weapon_chest");
// 	}
}

woods_take_knife( guy ) // take the knife away from woods
{
	//level.woods.knife Delete();	
	level.woods Detach("weapon_parabolic_knife");
}

woods_stick_knife( guy ) // stick the knife in leaders hand
{
	player = get_players()[0];

	player PlayRumbleOnEntity("damage_heavy");

	exploder( 110 );
	setmusicstate ("BAR_FIGHT");

	level.woods Detach("weapon_parabolic_knife", "tag_weapon_chest");
	//level.woods Attach("weapon_parabolic_knife", "tag_weapon_right");

	level.leader Attach("weapon_parabolic_knife", "tag_weapon_right");
	//level.woods.knife LinkTo( level.leader, "tag_weapon_right", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	flag_set( "knife_in_leader_hand" );
}

woods_delete_knife(guy)
{
	wait 1;
	level.woods Detach("weapon_parabolic_knife", "tag_weapon_chest");
}

woods_attach_bottle( guy ) // attach the bottle to woods hand
{
	level.woods.bottle = GetEnt( "whisky_bottle", "targetname" );
	level.woods.bottle LinkTo( level.woods, "tag_weapon_left", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

woods_detach_bottle( guy ) // detach bottle from woods hand
{
	// play hand stab effect
	PlayFXOnTag( level._effect["bottle_break"], level.leader, "tag_eye" );

	level.woods.bottle Unlink();
	level.woods.bottle Delete();
}

friendly_give_gun( guy ) // give gun to woods, guy = woods / bowman
{
	// give asp to woods and bowman
	guy gun_switchto( "asp_sp", "right" );
}

animate_map(carlos)
{
	level.bar_map = spawn_anim_model("map");
	level.bar_map Hide();
	level.bar_map thread animate("intro", ::self_delete);
	wait .1;
	level.bar_map Show();
	flag_set("map_spawned");
}

// --------------------------------------------------------------------------------
// ---- Bar scene enemies - thug1 ----
// --------------------------------------------------------------------------------
thugs_start( guy )
{
	flag_set("thugs_start");

	level thread leader_think();
	level thread thug1_think();
	level thread thug2_think();
	level thread thug3_think();
}

thug1_think()
{
	level.thug1 = simple_spawn_single("thug1", ::setup_for_bar);
	level.thug1 animate("intro", ::ragdoll_death);
}

// --------------------------------------------------------------------------------
// ---- Bar scene enemies - thug2 ----
// --------------------------------------------------------------------------------
thug2_think()
{
	level.thug2 = simple_spawn_single("thug2", ::setup_for_bar);
	level.thug2 animate("intro");

// 	death_anim = level.scr_anim["thug2"]["death"];
// 	thug2 AnimScripted("thug2_death", thug2.origin, thug2.angles, death_anim);
// 	thug2 do_notetracks("thug2_death");
}

thug3_think()
{
	level.thug3 = simple_spawn_single("thug3", ::setup_for_bar);
	
	level.thug3.health = 1;
	level.thug3.allowdeath = 1;

	level.thug3 thread animate("intro");
	level.thug3 waittill("death", attacker);

	if (IsPlayer(attacker))
	{
		level.woods SetAnimRateComplete(0); // doesn't really work, but at least prevent the fire notetrack from firing
	}

	wait .5;

	flag_set("start_exit");
}

outside_scene()
{
	level waittill("player_grabbed");

	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath(0);

	crowd_ents = [];

	num_civs = 10;
	for (i = 1; i <= num_civs; i++)
	{
		civ = simple_spawn_single("outside_bar_civ_spawner");
		civ.animname = "civ" + i;

		crowd_ents = array_add(crowd_ents, civ);
	}

	array_thread(crowd_ents, ::outside_scene_civs);

	num_police = 2;
	for (i = 1; i <= num_police; i++)
	{
		police = simple_spawn_single("outside_bar_police_spawner");
		police.animname = "police" + i;

		crowd_ents = array_add(crowd_ents, police);
	}

	for (i = 0; i < crowd_ents.size; i++)
	{
		crowd_ents[i].allowdeath = true;
		crowd_ents[i] thread animate("exit", ::end_of_crowd_anim, "start_exit", 5);
	}

	police_car = GetEnt("police_car_1", "script_noteworthy");

	car_police_pass = GetEnt("bar_exit_police_pass_ai", "targetname");
	car_police_driver = GetEnt("bar_exit_police_driver_ai", "targetname");
	police_car_guys = array(car_police_pass, car_police_driver);

	array_thread(police_car_guys, ::animate_police_car_guy);
	array_wait(police_car_guys, "jumpedout");
	
// 	police_car init_anim_model("car");
	
	flag_set("outside_scene_ready");
	flag_wait("start_exit");

// 	police_car SetAnim(police_car get_anim("exit"), 1, 0, 1);
	car_police_pass thread pa_dude_talk(car_police_driver);

	wait 18;

	battlechatter_on("allies");
	create_vehicle_from_spawngroup_and_gopath(1);
}

outside_scene_civs()
{
	self endon("death");
	self.goalradius = 30;
	self waittill("reached_path_end");
	self Delete();
}

end_of_crowd_anim()
{
	if (self.animname == "civ9" || self.animname == "civ10")
	{
		self Delete();
	}
}

animate_police_car_guy()
{
	self waittill("jumpedout");

	self.allowdeath = false; // prevent death before the exit animation starts
	self thread animate("exit", ::ragdoll_death, "start_exit");
	flag_wait("start_exit");
	self.allowdeath = true;
}

pa_dude_talk(other_dude)
{
	other_dude endon("death");
	//other_dude endon("enemy");
	other_dude endon("damage");

	self endon("death");
	//self endon("enemy");
	self endon("damage");

	wait 1;
	anim_generic(self, "enemies_of_the_revolution");

	wait 1.5;
	anim_generic(self, "your_only_warning");
}

track_thug(thug)
{
	self endon("lookat_thug_leader");

	move_time = 1.5;

	while (true)
	{
		if (Length(self GetNormalizedCameraMovement()) <= .05)
		{
			self look_at(thug get_eye(), move_time);
		}
		else
		{
			wait 1;
		}
	}
}

player_tracking()
{
	player = get_players()[0];

 	level endon("player_grabbed");

	move_time = 1.5;
	took_control = false;

	while (IsDefined(level.player_model))
	{
		if (flag("take_control") || (Length(player GetNormalizedCameraMovement()) <= .05))
		{
			if (!took_control)
			{
				took_control = true;
				player StartCameraTween(move_time);
				player PlayerLinkTo(level.player_model, "tag_player", 1, 0, 0, 0, 0);
			}
		}
		else if (took_control)
		{
			took_control = false;
			//player StopCameraTween();
			player PlayerLinkTo(level.player_model, "tag_player", 1, level.INTRO_PLAYER_CLAMP_RIGHT, level.INTRO_PLAYER_CLAMP_LEFT, level.INTRO_PLAYER_CLAMP_TOP, level.INTRO_PLAYER_CLAMP_BOTTOM);
			wait 4;
		}

		wait .05;
	}
}

bowman_break_window(bowman)
{
	exploder(120);
	self playsound ("dst_glass_pane");
	GetEnt("bar_window_left", "targetname") Delete();
}

carlos_break_window(carlos)
{
	exploder(130);
	self playsound ("dst_glass_pane");
	GetEnt("bar_window_right", "targetname") Delete();
}

// --------------------------------------------------------------------------------
// ---- Bar scene additional functions ----
// --------------------------------------------------------------------------------
setup_for_bar( remove_gun )
{
	//self SetLookAtText("P", &""); // doesn't work
	
	if( IsDefined( remove_gun ) )
	{
		self gun_remove();
	}
}

bar_reset(guy)
{
	if (!IsDefined(guy))
	{
		guy = self;
	}

	guy gun_switchto( "m16_acog_sp", "right" );
	guy gun_recall();

	guy notify("bar_reset");

	//guy SetLookAtText(self.name, &"");
}
