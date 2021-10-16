#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_music;
#include maps\flamer_util;
#include maps\_hud_util;
#include maps\hue_city;
#include maps\_color_manager;
#include maps\hue_city_anim;


// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - New default start ----
// -------------------------------------------------------------------------------------
#using_animtree ("generic_human");
event1_main()
{
	// setup intro fog
	level notify("set_intro_fog");

	// disable rambo for inside buildings, just set undefined to turn the behavior back on
	disable_rambo();

	// set spotlight values
	set_standard_spotlight_values();

	// give commando to the player
	//player = level.player;
	//player GiveWeapon("commando_sp");
	

	level thread color_manager_think();
	level thread event1_dialogue_setup();
	level thread squad_run_to_safe_room();
	level thread maps\hue_city_amb::play_bullet_impacts();
	level thread intro_dof();

	if( !IsDefined( level.skipto ) )
	{
		// get the chopper, and setup for the scene
		level.spirit = event1_setup_repel_spirit();

		// setup the player in the chopper seat
		level thread event1_setup_repel_player();
	}
	
	if( !IsDefined( level.skipto ) )
	{
		// handle introscreen
		level.introscreen_shader = "white";
		level thread maps\_introscreen::introscreen_redact_delay( &"HUE_CITY_INTROSCREEN_LINE1", &"HUE_CITY_INTROSCREEN_LINE2", &"HUE_CITY_INTROSCREEN_LINE3", &"HUE_CITY_INTROSCREEN_LINE4", &"HUE_CITY_INTROSCREEN_LINE5" );
		level thread intro_flashback_dialogue();
		
		level.spirit thread event1_woods_repel(); // TODO: only moved here to spawn woods earlier to play dialogue on him
	
		// wait until the intro screen begins to fade up before starting the sequence. 
		flag_wait( "starting final intro screen fadeout" ); 
		level thread temp_introscreen_fix();
		
		level thread intro_guys_move();
	}

	if( !IsDefined( level.skipto ) )
	{
		// repel sequence
		event1_repel();
	}


	level notify("set_macv_fog");
	

	
	level thread objective_control(1);
	
	// inside macv
	event1_macv();
}

intro_flashback_dialogue()
{
	ClientNotify ("ind");
	wait(2);
	player = level.player;	
	ent = spawn("script_origin",player.origin);
	player playsound("vox_hue1_s01_700A_inte");
	wait(4);
	player playsound("vox_hue1_s01_701A_maso");
	
}




// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence ----
// -------------------------------------------------------------------------------------
event1_repel()
{	
	// start battlechatter
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );
	
	
	// SUMEET - Added this to make sure 
	level.player EnableInvulnerability();
	hud_hide();


	level thread maps\hue_city_amb::evt_1_screams();

	// handle spirit
	level.spirit thread event1_spirit_repel(); 

	// animate the pilot 
	level.spirit thread event1_repel_pilot();

	// animate player
	level.spirit thread event1_player_repel();

	// animate woods
	//level.spirit thread event1_woods_repel();

	// animate redshirt
	level.spirit thread event1_redshirt_repel();
	
	// nva
	level thread event1_nva_repel();

	// ambiant friendlies repeling down
	level thread event1_additional_repellers();

	// napalm bombing run
	level thread event1_napalm_bombing_run();

	// start the AA gun fire
	level thread event1_intro_aa_guns();

	// deal with RPG guys
	level thread event1_nva_rpg_guys();
	
	// wait for repel scene to be over
	flag_wait("repel_done");

	level thread macv_fire_locations();

	// SUMEET - Added this to make sure 
	level.player DisableInvulnerability();
	
	//TUEY - PLACEHOLDER
	level notify ("radio_off");

	// start battlechatter
	battlechatter_on();

	hud_show();
}


// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - Chopper ----
// -------------------------------------------------------------------------------------
event1_setup_repel_spirit()
{
	spirit = getent("spirit", "targetname");
	spirit.ignoreme = true;

	// Why are we doing this? We might not need this anymore
	level notify ("level.spirit_defined");

	// setup special interior model

	// play internal Dlight from Dale
	PlayFXOnTag( level._effect["heli_interior_light"], spirit, "tag_origin" );
	
	spirit.takedamage = 0;
	spirit setcandamage(false);
	
	return spirit;
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - Setup Player ----
// -------------------------------------------------------------------------------------
event1_setup_repel_player()
{
	// spawn player hands
	level.player_hands = spawn_anim_model( "repel_hands" );
	level.player_hands.animname = "repel_hands";

	// thread a function that plays effects once wods breaks into the glass
	level thread event1_player_breaks_window();
	
	//Kevin threading cb chatter function
	level thread maps\hue_city_amb::play_cb_chatter();
	level thread maps\hue_city_amb::fake_intro_helis_flyby();
	level thread maps\hue_city_amb::fake_huey_loops();

	wait .1;

	// calculate player starting position
	offset = calculate_player_position_offset();	

	// link the player hands to the helicopter
	level.player_hands LinkTo( level.spirit, "tag_origin", offset );
	
	// disable player weapons 
	level.player DisableWeapons();

	// link the player to the hand model 
	level.player PlayerLinkToDelta( level.player_hands, "tag_player", 1, 15, 15, 20, 20 );
	level.player SetPlayerAngles(level.spirit.angles);
	level.player._view_restore_angles = level.player GetPlayerAngles();
}

event1_spirit_repel() // self = spirit heli
{
	// get the start node
	startnode = getvehiclenode( "event4_startnode", "script_noteworthy" );
	
	// start moving along the path
	self attachpath( startnode );
	self startpath();

	// fire at aa guns
	self thread event1_spirit_think();

	// waittill reached to the end of the path, this is where we start repel animation
	self waittill("reached_end_node");


	// setup repel animation reference
	level.repel_anim_node = getstruct("rapel_ref", "script_noteworthy");
	level.repel_anim_node.origin = self.origin;
	
	// tell everyone to start respective animations
	flag_set("repel_is_on");

	//TUEY - PLACEHOLDER
	//setmusicstate("REPEL_TO_HELL");

	// Delete the "real" vehicle
	self Hide();

	// start animating fake spirit as the animation is setup to animate script model
	level thread event1_animate_fake_spirit();
	
	wait 3;
	self notify ("delete_pilot");
	wait 1;
	self Delete();

	// wait for repel to over and do clean Up
	flag_wait("repel_done");

	// Do cleanup here
}

#using_animtree("vehicles");
event1_animate_fake_spirit() // self = spirit heli
{
	spot = level.repel_anim_node;
	
	// spawn a fake model
	fakespirit = spawn_a_model("t5_veh_helo_huey", spot.origin, spot.angles);
	
	// link sound source
	fakespirit thread fake_huey_sounds();
	
	// setup interior
	fakespirit Attach ( "t5_veh_helo_huey_att_interior", "tag_body");
	
	// setup gear model
	//fakespirit Attach ( "t5_veh_helo_huey_att_rockets", "tag_body");

	// play the rotor effect
	PlayFXOnTag( level._effect["chopper_rotor"], fakespirit, "main_rotor_jnt" );

	// Dynamic light for interior of Huey
	PlayFXOnTag( level._effect["heli_interior_light"], fakespirit, "tag_origin" );

	// setup animation 
	fakespirit.animname = "spirit";
	fakespirit UseAnimTree( #animtree );

	// start a burning effect thread 
	fakespirit thread burning_effect();

	// setup the ropes here
	fakespirit thread event1_ropes_repel();

	// play animation
	spot anim_single(fakespirit, "spirit_shotdown");
	
	// delete fake spirit
	fakespirit 				  Delete();
}

burning_effect()
{
	wait(11.0);
	
	//Kevin adding sound to chopper hit
	player = level.player;
	player playsound( "evt_chopper_hit" );
	

	playfxontag( level._effect["chopper_bullet_impact"], self, "tag_origin" );

	flag_set("chopper_hit");

	wait(0.75);

	playfxontag( level._effect["chopper_hit"], self, "tag_origin" );
	playfxontag( level._effect["chopper_burning"], self, "tag_origin" );
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 -  Repel sequence - Ropes ----
// -------------------------------------------------------------------------------------
#using_animtree ("generic_human");
event1_ropes_repel() // self = fake spirit chopper
{
	// Spawn a script origin at the ref point to link the ropes to
	rapel_ref_node = getstruct("rapel_ref", "script_noteworthy");

	link_origin = spawn("script_model", rapel_ref_node.origin);
	link_origin SetModel("tag_origin");
	link_origin.angles = rapel_ref_node.angles;
	link_origin thread wait_and_delete(60);

	ent1 = getent( "fxanim_quag_rappelcrash01_mod", "targetname" );
	ent1 LinkTo( link_origin, "tag_origin" );

	ent2 = getent( "fxanim_quag_rappelcrash02_mod", "targetname" );
	ent2 LinkTo( link_origin, "tag_origin" );

	// start Jess's effect rope animation
	level notify("rappelcrash_start");
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 -  Repel sequence - Pilot ----
// -------------------------------------------------------------------------------------
event1_repel_pilot() // self = spirit heli
{
	pilot = spawn( "script_model", level.spirit gettagorigin( "tag_player" ) );
	pilot character\c_usa_jungmar_tanker::main();
	
	// link the pilot to the heli
	pilot LinkTo( level.spirit, "tag_driver", (0,0,0) );

	// setup animname
	pilot UseAnimTree(#animtree);
	pilot.animname = "hueyspot0";
	
	// animate the pilot until this scene is over 
	level.spirit thread anim_loop_aligned( pilot, "idle", "tag_driver", "delete_pilot" );

	// wait for the repel to start 
	flag_wait("repel_is_on");	
	

	// delete the model here
	level.spirit waittill ("delete_pilot");
	pilot StopAnimScripted();
	pilot Delete();
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - Woods ----
// -------------------------------------------------------------------------------------
event1_woods_repel() // self = spirit heli
{
	level.squad["woods"] = simple_spawn_single( "woods_struct_spawner" );

	// link woods to heli
	level.squad["woods"] linkto ( level.spirit, "tag_passenger3", ( 0,0,0 ) );
	level.squad["woods"].pacifist = true;
	level.squad["woods"].name = "Woods";
	level.squad["woods"].targetname = "woods_spirit";
	level.squad["woods"].ignoreme = true;

	// wait for repel to start
	flag_wait("repel_is_on");

	// unlink woods
	level.squad["woods"] Unlink();

	// play repel animation
	level.squad["woods"].animname = "woods";
	level.repel_anim_node anim_single_aligned( level.squad["woods"], "repel" );

	level.squad["woods"].pacifist = false;
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - Redshirt ----
// -------------------------------------------------------------------------------------
event1_redshirt_repel() // self = spirit heli
{
	// wait for repel to start
	flag_wait("repel_is_on");

	// spawn this readshirt
	redshirt = simple_spawn_single( "repel_redshirt" );
	
	// start AA gun firing
	flag_set("redshirt_repelling");

	// play repel animation
	redshirt.animname = "repel_redshirt";
	level.repel_anim_node anim_single_aligned( redshirt, "repel" );

	// kill redshirt here 
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - Player ----
// -------------------------------------------------------------------------------------
event1_player_repel()
{
	// wait for the repel animation to start 
	flag_wait( "repel_is_on" );

	// restore the players view to the original angles to avoid a snap
	level.player thread restore_player_view_angles();

	// get the repel animation reference
	spot = level.repel_anim_node;

	// unlink player hands
	level.player_hands Unlink();

	// attach some model to the player hand
	level.player_hands attach("anim_jun_carabiner", "tag_weapon");
	
	// wait to set DOF
	level.player thread set_rappel_dof();

	level.player thread magic_bullet_shield();

	// start repeling animation

	level thread repel_rumbles();

	spot thread anim_single_aligned( level.player_hands, "player_repel" );
	
	//Kevin adding notify to shut off cb chatter
	level notify("cb_chatter_off");

	// wait for animation to be almost over
	time = GetAnimLength( level.scr_anim[level.player_hands.animname]["player_repel"] ); 
	wait time - 1.2;
	
	clip = getent("crash_phys_clip","targetname");
	if(isDefined(clip))
	{
		clip delete();
	}

	// unlink the player
	level.player Unlink();
	level.player SetPlayerAngles( level.player_hands.angles);

	// setup player for macv
	level.player allowcrouch(true);
	level.player GiveWeapon("spas_db_sp");
	level.player GiveWeapon("commando_gl_sp");
	
	//level.player_switchweapon = ("spas_db_sp");
	
	level.player SetWeaponAmmoClip("spas_db_sp", 6);
	//level.player SetWeaponAmmoClip("spas_db_sp", 6);
	
	level.player thread stop_magic_bullet_shield();
	level.player SetWeaponAmmoStock("spas_db_sp", 80);
	//level.player thread sog_spas_guaranteed();

	// delete player hands model...wait 1 frame to correct a strange
	// lerping problem after hands are deleted
	level.player_hands Hide();
	wait(0.05);
	level.player_hands Delete();

	// this event is finished
	flag_set("repel_done");
	
	//level.player SwitchToWeapon("spas_sog_sp");

	//wait( 0.1 );

	level.player SwitchToWeapon("spas_db_sp");
	
	wait(1);

	level.player EnableWeapons();
		
	SetCullDist(3500);
	
		// save a checkpoint
	wait(0.1);
	autosave_by_name( "event1_start" );
}

set_rappel_dof()
{
	// always reliable wait call
	wait(4.5);

	// notify for art
	level notify("set_rappel_dof");
}

event1_player_breaks_window()
{
	// this notify is sent on a notetrack in woods animation
	level waittill("woods_broke_window");

	level thread macv_chopper_explosion_effect();

	// Earthquake at player position 
	Earthquake( 0.5, 2, level.player.origin, 500 );

	// SUMEET - fake blood overlay on the player
	level.player thread blood_hud();
	
	// glass breaking effect
	structs = getstructarray("macv_intro_glass_spot", "targetname");
	for( i=0; i < structs.size; i++ )
	{
		playfx( level._effect["macv_intro_glass"], structs[i].origin, anglestoforward(structs[i].angles) );
	}
 
	// not sure why we are doing this? 
	GetEnt( "repel_window", "targetname") delete();

	//TUEY - Play a 2D glass breaking sound and switch to MACV music
	PlaySoundAtPosition( "evt_4_glass_shatter", structs[0].origin );

	wait(2);


}

blood_hud()
{
	wait(0.4);

	self.blood_hud = NewClientHudElem( self );
	self.blood_hud.horzAlign = "fullscreen";
	self.blood_hud.vertAlign = "fullscreen";
	self.blood_hud SetShader( "overlay_low_health_splat", 640, 480 );
	self.blood_hud.alpha = 4;

	self thread blood_hud_destroy();
}

blood_hud_destroy()
{
	FADE_TIME = 4;
	self.blood_hud FadeOverTime( FADE_TIME );
	self.blood_hud.alpha = 0;
	wait( FADE_TIME );

	self.blood_hud Destroy();
}


macv_chopper_explosion_effect()
{
	wait 4.5;
	exploder(21);
	clientnotify("huey_explode");
	
	// play Jess's benches effect
	level notify( "benches_start");
	level.player PlayRumbleOnEntity("explosion_generic");
}

calculate_player_position_offset()
{
	// store the current origin
	anim_node = Spawn( "script_origin", level.player_hands GetTagOrigin( "tag_player" ) );
	anim_node SetModel( "tag_origin" );
	
	// put player hands in first pose
	anim_node anim_first_frame( level.player_hands, "player_repel", "tag_origin" );

	// get the new origin
	new_origin = level.player_hands GetTagOrigin( "tag_player" );

	// get the offset vector
	offset = new_origin - anim_node.origin;

	// push the offset forward a bit
	forward = AnglesToForward(level.player_hands.angles);
	offset = offset + vector_multiply(forward, 5);

	anim_node Delete();
	
	return offset;
}

restore_player_view_angles() // self == player
{
	self UnLink();
	self PlayerLinkToAbsolute( level.player_hands, "tag_player" );

	// restore the view to where the animation will take over
	self FreezeControls( true );
	self StartCameraTween( 0.25 );
	wait(0.05);
	self SetPlayerAngles( self._view_restore_angles );
	wait(0.25);
	self FreezeControls( false );
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - NVA's ----
// -------------------------------------------------------------------------------------
event1_nva_repel()
{
	// wait for the repel animation to start 
	flag_wait( "repel_is_on" );

	// get the repel animation reference
	spot = level.repel_anim_node;

	spawners = [];
	spawners[0] = getent("nva_repel_shotgunner", "script_noteworthy");
	spawners = array_combine(spawners, getentarray("nva_repel_ak47", "script_noteworthy") );
	guys = [];
	
	for( i = 0; i < spawners.size; i++ )
	{
		guys[i] = spawners[i] stalingradspawn();
		guys[i].dropweapon = 0;
		guys[i].animname = ( "macv_repel_nva_" + ( i + 1 ) );
		if( i == 0 )
		{
			level.gun_guy = guys[i];
			level.gun_guy Detach(level.gun_guy.headModel);
			level.gun_guy Detach(level.gun_guy.gearModel);
			level.gun_guy character\gfl\character_gfl_saiga12::main();
		}
		guys[i].ignoreall = true;
		spot thread anim_single_aligned( guys[i], "single_anim" );
	}
	
	level.spas = spawn_anim_model( "spas", level.gun_guy.origin, level.gun_guy.angles, true );
	level.spas UseWeaponHideTags( "spas_sp" );
	level.spas Hide();
	spot thread anim_single_aligned( level.spas, "single_anim" );
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Repel sequence - Additional repelling friendlies ----
// -------------------------------------------------------------------------------------
event1_additional_repellers()
{
	skydemon = getent ("skydemon_repel", "targetname");

	skydemon thread event1_skydemon_repel_think();
	skydemon thread fill_huey_with_script_models("rapelled_in");

	path_node = getvehiclenode("skydemon_repel_entrance", "targetname");
	skydemon attachpath(path_node);
	skydemon startpath();

	skydemon waittill("reached_end_node");
	flag_set("aa_gun_switch_fire");

	spawner = getent("skydemon_repeller", "targetname");

	rope1 = getent("fxanim_gp_distant_rappel_mod_01", "targetname");
	rope2 = getent("fxanim_gp_distant_rappel_mod_02", "targetname");
	dorope1 = true;
	
	for( i=0; i < 4; i++ )
	{
		level thread event1_guy_rappel(spawner, rope1, "distant_rappel_01_start");
		wait randomfloatrange(0.15,0.45);
		level thread event1_guy_rappel(spawner, rope2, "distant_rappel_02_start");
		wait randomfloatrange(2, 2.5);
	}
	
	flag_wait("repel_done");

	level notify("rapelled_in");

	wait(3);

	// delete the skydemon
	skydemon Delete();

}

event1_guy_rappel(spawner, rope, mynotify)
{
	end = getstruct("skydemon_rapelend", "targetname");
	guy = spawner stalingradspawnsafe(1);
	skydemon = getent("skydemon_repel", "targetname");
	guy.animname = "fardude";
	spot = undefined;

	if (mynotify == "distant_rappel_01_start")
	{
		spot = spawn ("script_origin", skydemon gettagorigin("origin_animate_jnt") + (-7,0,0) );
	}
	else
	{
		spot = spawn ("script_origin", skydemon gettagorigin("origin_animate_jnt") + (-37,0,0) );
	}

	spot.angles = skydemon gettagangles("origin_animate_jnt");

	guy notify("stoplooping");

	level notify (mynotify);
	spot anim_single_aligned(guy, "repel");
	guy delete();
	spot delete();
}

event1_skydemon_repel_think()
{
	wait(3);

	target = getent("aa_gun_2", "targetname");
	target_pos = target GetOrigin();
	self SetLookAtEnt(target);
	//kevin getting player to play rocket sounds
	player = level.player;

	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_right"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;
	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_left"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;
	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_right"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;
	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_left"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;

	if (IsDefined(target.loop_ent))
	{
		target.loop_ent stoploopsound(.05);
		target.loop_ent delete();
	}
	target death_notify_wrapper();
}

event1_spirit_think()
{
	wait(1);

	target = getent("aa_gun", "targetname");
	target_pos = target GetOrigin();
	self SetLookAtEnt(target);
	//kevin getting player to play rocket sounds
	player = level.player;

	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_right"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;
	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_left"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;
	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_right"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;
	MagicBullet( "huey_rockets", self GetTagOrigin("tag_rocket_left"), target_pos);
	player playsound( "wpn_flyable_hind_rocket_fire" );
	wait 0.5;

	if (IsDefined(target.loop_ent))
	{
		target.loop_ent stoploopsound(.05);
		target.loop_ent delete();
	}
	target death_notify_wrapper();
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Bombing run during Rappel
// -------------------------------------------------------------------------------------
event1_napalm_bombing_run()
{
	flag_wait("approaching_macv");

	wait 1.5;

	bomber = getent("bomber", "targetname");

	playfxontag(level._effect["jet_contrail"], bomber, "tag_left_wingtip" );
	playfxontag(level._effect["jet_contrail"], bomber, "tag_right_wingtip" );
	playfxontag(level._effect["jet_exhaust"], bomber, "tag_engine_l" );
	playfxontag(level._effect["jet_exhaust"], bomber, "tag_engine_r" );

	node = getvehiclenode("bombing_run", "targetname");
	bomber attachpath(node);
	bomber startpath();
	
	//kevin adding bomber and bomb sound
	bomber playsound( "evt_jet_pass" );
	bomber playsound( "evt_bomb_whistle" );

	wait(0.5);

	bomb_drop_pos = bomber.origin;
	bomb_drop_pos = bomb_drop_pos - (0, 0, 50);
	PlayFX(level._effect["napalm2"], bomb_drop_pos, AnglesToForward(bomber.angles), AnglesToUp(bomber.angles));

	wait(1.0);
	
	//kevin adding audio for napalm
	player = level.player;
	player playsound( "evt_napalm" );

	Exploder(11);
	level.player PlayRumbleOnEntity("artillery_rumble");

	bomber waittill("reached_end_node");
	bomber delete();
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - AA gun hitting repelling guys, spawn function on AA gun ----
// -------------------------------------------------------------------------------------
event1_aa_repel_hit_targets() // self = AA gun
{
	self endon("death");

	// wait until redshirt starts repeling down
	flag_wait("redshirt_repelling");

	// get the animnode	
	spot = level.repel_anim_node;
	
	// get the redshirt to shoot at
	redshirt = GetEnt( "repel_redshirt_ai", "targetname" );

	wait(5.5);

	// find a position around redshirt to shoot
	target = spawn( "script_model" , redshirt.origin);
	target setmodel( "tag_origin" );
	target thread delete_on_ent_notify(self, "death");

	// kill
	self thread kill_aa_gun();
	
	//kevin adding ent for loopsound
	loop_ent = spawn( "script_origin" , (self.origin));
	// kevin adding fire sound
	loop_ent playloopsound( "wpn_gaz_quad50_turret_loop_hue" );
	loop_ent thread kill_aa_gun_sound(self,loop_ent);

	// fire the weapon
	time_fired = 0.0;
	targeting_spirit = false;
	
	while(1)
	{
		offset = ( RandomIntRange(-40, 40), RandomIntRange(-40, 40), RandomIntRange(-40, 40));	
		self SetTurretTargetEnt( target, offset );
		self fireweapon();

		time_fired += 0.05;
		if (time_fired > 4.0 && !targeting_spirit)
		{
			targeting_spirit = true;
			target moveto( spot.origin, 2.0);
		}

		wait(0.05);
	}

}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - AA guns shooting at helis as player enters the level 
// -------------------------------------------------------------------------------------
event1_intro_aa_guns()
{
	skydemon_repel = GetEnt("skydemon_repel", "targetname");

	aa_gun = GetEnt("aa_gun", "targetname");
	aa_gun thread aa_gun_fire_at_ent(skydemon_repel, 60, 1.0, 1.0);

	spirit_fire_offset = vector_multiply(AnglesToForward(level.spirit.angles), 1000);
	spirit_fire_ent = spawn("script_model", level.spirit.origin + spirit_fire_offset);
	spirit_fire_ent LinkTo(level.spirit, "tag_origin");

	aa_gun_2 = GetEnt("aa_gun_2", "targetname");
	aa_gun_2 thread aa_gun_fire_at_ent(spirit_fire_ent, 60, 1.0, 1.0, 1.0);
}

aa_gun_fire_at_ent(ent, accuracy, burst_time, idle_time, delay_time)
{
	self endon("death");

	ent.takedamage = 0;
	ent setcandamage(false);
	//ent thread delete_on_ent_notify(self, "death");
	
	// kill
	self thread kill_aa_gun();
	
	//kevin adding ent for loopsound
	loop_ent = spawn( "script_origin" , (self.origin));
	// kevin adding fire sound
	loop_ent playloopsound( "wpn_gaz_quad50_turret_loop_hue" );
	loop_ent thread kill_aa_gun_sound(self,loop_ent);

	burst_time = 1.0;
	idle_time = 0.0;
	last_fire_pos = (0, 0, 0);

	if (IsDefined(delay_time))
	{
		burst_time = 0.0;
		idle_time = delay_time;
	}

	// Setup a firing loop
	while(1)
	{
		offset = ( RandomIntRange(-160, 160), RandomIntRange(-160, 160), RandomIntRange(-160, 160));

		fire_pos = ent.origin + offset;
		if (last_fire_pos != (0, 0, 0))
		{
			//fire_pos = fire_pos + last_fire_pos;
			fire_pos = vector_multiply(fire_pos, 0.1) + vector_multiply(last_fire_pos, 0.9);
		}
		last_fire_pos = fire_pos;

		self SetTurretTargetVec( fire_pos );
		if (burst_time > 0.0)
		{
			burst_time -= 0.05;

			// Done firing
			if (burst_time <= 0.0)
			{
				idle_time = 1.0;
			}

			self FireWeapon();
		}
		else
		{
			idle_time -= 0.05;

			// about to start firing
			if (idle_time <= 0.0)
			{
	 			burst_time = 1.0;
			}
		}

		wait(0.05);
	}
}

kill_aa_gun()
{
	wait 30;
	self notify("stop_looping_sounds");
	guys = get_ai_array("macv_aa_truck_riders_ai", "targetname");
	array_thread(guys, ::killme);
	wait 1;
	
	self vehicle_delete();
}

kill_aa_gun_sound(aa_gun, loop_ent)
{
	aa_gun waittill("stop_looping_sounds");
	loop_ent stoploopsound(0.05);
	loop_ent delete();

}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - NVA RPGs
// -------------------------------------------------------------------------------------
event1_nva_rpg_guys()
{
	// RPG guys
	rpg_spawners = GetEntArray("roof_rpgs", "targetname");
	guys = [];
	for (i = 0; i < rpg_spawners.size; i++)
	{
		guys[i] = rpg_spawners[i] stalingradspawn();
		guys[i].a.allow_weapon_switch = false;
		guys[i] thread kill_rpg_guy();
	}	

	skydemon = GetEnt("skydemon_repel", "targetname");

	guys[0] thread shoot_at_target(skydemon, "tag_origin", 1.0, 8.0);
	guys[1] thread shoot_at_target(level.spirit, "tag_origin", 2.0, 8.0);

	flag_wait("repel_is_on");

	guys[1] notify("stop_shoot_at_target");
	wait(10.0);
	guys[1] thread shoot_at_target(level.player_hands, "tag_player");
}

kill_rpg_guy()
{
	self endon ("death");
	flag_wait("repel_done");
	self delete();
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Inside Macv ----
// -------------------------------------------------------------------------------------
event1_macv()
{

	
	level thread bowman_repel_after_smallroom_clear();

	// event until skydemon kills everyone - skipto "e1c"
	level thread event1_macv_skydemon_main();

	// event after skydemon - skipto "e1c_a"
	level thread event1_macv_after_skydemon();

	level thread macv_end_of_summeet_section();  
	
	level thread pre_mowdown_cowers();
	
	level thread spawn_commando_marine();
	
	level thread event1_threatbias_management();
	
	level thread reznov_door_breach_trig();
	
	//remove this for now
	level thread event1_player_balcony_fall();
}

// --------------------------------------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Event until skydemon kills everyone ------
// --------------------------------------------------------------------------------------------------------------------
event1_macv_skydemon_main()
{	
	// player is done with the rapel scene and has a gun, start fighting
	level thread event1_macv_fight_think();

	// wait until skydemon has finished killing everyone	
	flag_wait("event1_skydemon_done");
	
	ents = GetEntArray("chopper_room_script_origins", "script_noteworthy");
	for (i=0; i < ents.size; i++)
	{
		ents[i] Delete();
	}
}


event1_macv_fight_think() // self = level
{	
	// handle woods movement
	level.squad["woods"] thread event1_woods_think();

	// start a thread for mowdown sequence look at
	level thread event1_skydemon_player_lookat_think();

	// thread that kills the player if he runs ahead before skydemon is finished firing	
	level thread event1_kill_if_player_skips_skydemon();

	// thread that spawns two guys running at the player when he enters the heli mowdown room
	level thread event1_second_encounters_runners();

	// this thread waits until skydemon is halfway through and spawn couple more guys to be killed
	level thread event1_second_encounter_guys_back_last();

	// tell player to switch to spas dragons breath
	//level thread event1_player_switch_dragon_breath();

	// wait until first encounter is done so that another rusher can come in charging
	flag_wait("first_encounter_done");
}

// handles woods movement
event1_woods_think() // self = woods
{
	self.grenadeawareness = 0; 	 // dont want to move around if grenade is thrown around
	self.ignoreme  = true;

	// CQB transitions in first section
	self enable_cqbwalk();

	// wait until first encounter is done to start CQB walk
	flag_wait( "first_encounter_done" );

	self.ignoreme = false;

	// start thinking on CQB
	self thread cqb_think();
}


//// shows screen message until player switched to dragons breath
//event1_player_switch_dragon_breath() // self = level
//{
//	screen_message_create(&"HUE_CITY_SPAS_SWITCH");
//
//	player = level.player;
//
//	// now wait until player presses this button or the first encounter is done
//	while(1)
//	{
//		if( player GetCurrentWeapon() == "spas_db_sp"|| flag( "first_encounter_done" ) )
//		{
//			break;		
//		}
//	
//		wait(0.1);
//	}
//
//	screen_message_delete();	
//}

// first two AI's in the first encounter, need to be already running when player sees them
event1_setup_rushers()
{
	toggle_transitions( 1, 0, 1 );
	modify_run_rate( RandomFloatRange( 1, 1.2 ) );
}

// --------------------------------------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - handle the skydemon killer chopper, this is the chopper that comes in the second encounter ------
// --------------------------------------------------------------------------------------------------------------------
event1_skydemon_firing_think(use_nose_turret) // self = macv_skydemon
{
	// wait for player to look at the trigger that will kick off the mowdown
	flag_wait("skydemon_firing_start");
	flag_set("override_sumeets_cqbwalk");

	level.macv_skydemon = self;

	// make sure it doesnt take Damage
	self thread veh_magic_bullet_shield( true );

	// let everyone know that level.skydemon is ready to use
	flag_set( "event1_skydemon_ready" );
		
	// start a looping sound
	sound_ent = Spawn( "script_origin", self.origin );
	sound_ent LinkTo( self );
	sound_ent playloopsound ("evt_huey_attack_attack_3_loop");
	//sound_ent playsound ("evt_huey_attack_attack_3");
	level notify ("chopper_shooting");

	// start effects exploder
	exploder(20);

	// Dim the light as Jeanne suggested
	clientnotify("Heli_mowdown_light");

//	first_skydemon = GetEnt("skydemon_flyover_1", "targetname");
//	if (IsDefined(first_skydemon))
//	{
//		first_skydemon event1_spotlight_off_gun();
//		first_skydemon vehicle_delete();
//	}

	// turn spotlight on
	self thread event1_spotlight_on_gun(undefined, use_nose_turret);

	// clear turret target so that it points forward
	self ClearGunnerTarget(2);
	
	// start the Jess's effects animation on the wall that is getting mowed down
	level notify("wallshoot_start");


	self thread e1_mowdown_minigun_rumble();

	// find forward direction of the chopper and shoot in that direction
	while( !flag( "skydemon_firing_stop" ) )
	{
		// get the forward direction and find a spot to shoot at
		forward_dir   = AnglesToForward( self.angles );
			
		tag_flash_pos = self GetTagOrigin( "tag_flash_gunner2" );
		spot = tag_flash_pos + vector_scale( forward_dir, 1000 );
	
		self SetGunnerTargetVec( spot, 0 );
		self SetGunnerTargetVec( spot, 1 );
		self FireGunnerWeapon( 0 ); // actually fire weapon
		self FireGunnerWeapon( 1 ); // actually fire weapon
/#		
		recordLine( tag_flash_pos, spot, ( 1,1,1 ), "Script", self );
#/	

		wait( 0.25 );
	}

	// skydemon is done now, set this flag so that we can start next event
	flag_set("event1_skydemon_done");
	
	setMusicState ("CHOPPER_OWNS");


	autosave_by_name( "event1_skydemon_done" );


	// stop effects exploder
	stop_exploder(20);

	//wait(1);
	
	level notify ("chopper_shooting_end");

	
	// stop the looping sound
	sound_ent StopLoopSound(0.3);
	sound_ent playsound("evt_huey_attack_attack_3_end");
	
	sound_ent Delete();

	// wait until it reaches end on the spline and delete
	flag_wait("skydemon_delete");
	self event1_spotlight_off_gun();
	self notify ("deleting");
	wait 0.1;
	self Delete();
}

// waits for the player to pass in the hallway and then turns on the lookat trigger that 
// starts skydemon firing
event1_skydemon_player_lookat_think() // self = level
{
	trigger_off( "skydemon_firing_start_trig", "targetname" );
	
	// wait for the player to get in the hallway
	flag_wait("player_in_hallway");

	trigger_on( "skydemon_firing_start_trig", "targetname" );
	//Kevin adding a notify for the chopper blades
	level notify( "mowdown_starts" );
}

// thread that kills the player if he runs ahead before skydemon is finished firing	
event1_kill_if_player_skips_skydemon()
{
	player = level.player;
	player endon("death");
	
	// wait until player goes into the hallway
	flag_wait( "event1_skydemon_ready" );
	level.player thread magic_bullet_shield();
	level.player SetCanDamage(false);
	wait 1.5;
	level.player thread stop_magic_bullet_shield();
	level.player SetCanDamage(true);

	
	while( !flag( "event1_skydemon_done" ) )
	{
		if( player.origin[1] < level.macv_skydemon.origin[1]+200 )
		{
			// kill the player
			player DoDamage( 50, level.macv_skydemon.origin );
			
		}
		
		wait(0.1);
	}
}

// --------------------------------------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - First special rusher ------
// --------------------------------------------------------------------------------------------------------------------
event1_first_rusher_kill_think() // self = first rusher ai
{
	//level thread recruit_db_switch();
	//set a special death animation
	self.deathAnim = %ch_hue_b01_shotguntothewall_death;

	self delaythread(8, ::ignore_off);

	self waittill ("death", killer, dtype, killweapon);
	
	if( IsDefined( self.attacker ) && IsPlayer( self.attacker ) )
	{
		if( IsDefined(killweapon) && killweapon == "spas_db_sp" )
		{
			position = "j_spine4";
		
			// play special effect
			PlayFXOnTag( level._effect["spas_death"], self, position );
			PhysicsExplosionSphere( self.origin, 100, 80, 5 );	
			//RadiusDamage( self.origin, 200, 200, 50 );

			// special death effects
			level thread event1_first_rusher_explosive_internal();
		}
	}
		
	return false;
}

event1_first_rusher_explosive_internal()
{
	self thread timescale_tween( 1, 0.3, 0.1 );
	clientNotify( "slow_down" );//kevin adding notifies for time scale
	
	// set the Exploder
	exploder(22);

	wait(0.7);

	// restore timescale
	self thread timescale_tween( 0.3, 1, 0.3 );
	clientNotify( "speed_up" );//kevin adding notifies for time scale
}

// --------------------------------------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - AI thinking for guys getting killed by skydemon ------
// --------------------------------------------------------------------------------------------------------------------
event1_skydemon_ai_think() // self = ai
{
	self endon("death");
	self.allowdeath = true;

	// start a magic bullet shield
	//self thread magic_bullet_shield();

	// this flag tells this AI when to run away from the chopper
	self ent_flag_init( "run_from_here" );

	// decide if this AI is meant to do animated mowdown
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy  == "animated_mowdown" )
	{
		self.animated_mowdown = true;
	}
	else
	{
		self.force_gib = true;
		self.animated_mowdown = false;
	}
	
	// this AI is not going to attack the player, instead going to act that its shooting outside the window
	// animate if this AI was made to animate
	if( self.animated_mowdown == true )
	{
		self thread event1_skydemon_animated_mowdown();
	}
	else
	{
		// just regular shooting
		self thread event1_skydemon_ai_shoot();
	}	
	// do nothing special until skydemon starts firing
	flag_wait( "event1_skydemon_ready" );

	// wait until the chopper comes close to this ai
	while(1)
	{
		launch_dir  = VectorNormalize( self.origin - level.macv_skydemon.origin );

		chopper_yaw = flat_angle( level.macv_skydemon.angles );
		launch_yaw	= flat_angle( VectorToAngles( launch_dir ) );

		if( abs( launch_yaw[1] - chopper_yaw[1] ) < 10 )
		{
			// start running
			self ent_flag_set( "run_from_here" );
			break;
		}	

		wait( 0.05 );
	}
	
	// create a lauch direction if this guy doesnt have an animated mowdown death
	if( !self.animated_mowdown )
	{
		// create a force, using the shoot ent
		launch_spot = getstruct( self.shoot_ent.target, "targetname" );
		launch_dir  = VectorNormalize( launch_spot.origin - self.origin );
		launch_dir  = vector_scale( launch_dir, 50 );
	}
	else
	{
		launch_dir = undefined;
	}

	// wait for a bit
	wait(1);

	// setup special death function for special guys
	//self event1_skydemon_ai_deathfunc( launch_dir );

	position = "j_spine4";

	//only play these blood FX if the game is on mature setting
	if( is_mature() )
	{
		if( cointoss() )
		{
			// more like blood spray
			PlayFXOnTag( level._effect["heli_mowdown_blood_geyser"], self, position );
		}
		else
		{
			// effect that imitates guy getting hit again and again
			PlayFXOnTag( level._effect["heli_mowdown_multihit"] , self, position );
		}
	}	
	
	// delete shoot ent
	if (IsDefined(self.shoot_ent))
	{
		self.shoot_ent Delete();
	}
		
	// kill this guy
	if( IsAlive( self ) )
	{
		self DoDamage( self.health + 100, self.origin );
	}	
	
}


event1_skydemon_animated_mowdown() // self = ai
{
	// start shoot loop and keep looping until time to die
	self anim_loop_aligned( self, "shoot_loop" );
}

event1_skydemon_ai_shoot() // self = ai
{
	self endon("death");
	
	// ignore everyone for now
	self.ignoreall = true;

	// this AI is only allowed to stand
	self AllowedStances( "stand" );
	
	// shoot ent is a script_origin targetted by the node this AI will be at
	self.shoot_ent = Getstructent( GetNode( self.target, "targetname" ).target, "targetname" );
	Assert(IsDefined(self.shoot_ent));
	self thread shoot_at_target_untill_dead( self.shoot_ent );
		
	// get the retreat node
	retreat_node = GetNode( "retreat_node", "targetname" );

	// some guys shoot at the player, once player comes nearby
	if( cointoss() )
	{
		flag_wait("event1_skydemon_ready");
	}

	// run away for life when needed
	self ent_flag_wait( "run_from_here" );

	// run back if not told to stay in place by script noteworthy
	if( !IsDefined( self.script_noteworthy ) )
	{
		// run faster
		modify_run_rate( 1.4 );
		self set_goal_node( retreat_node );
	}
	
}

// thread that spawns two guys running at the player when he enters the heli mowdown room
event1_second_encounters_runners()
{
	// wait for the player to get in the hallway
	flag_wait("start_mowdown_rushers");

	// spawn guys running at the player
	runner_guys = struct_spawn( "second_encounter_runners", ::event1_second_encounters_runners_think );
}


event1_second_encounters_runners_think()
{
	self endon("death");	// these guys are killable by the player
	self SetThreatBiasGroup("ignore_player");

	// this AI is only allowed to stand
	self AllowedStances( "stand" );
	
	// force gib these guys
	self.force_gib = true;

	// these guys are not doing animated mowdown	
	self.animated_mowdown = false;

	self.goalradius = 16;

	// do nothing special until skydemon starts firing
	flag_wait( "event1_skydemon_ready" );

	// wait until the chopper comes close to this ai
	while(1)
	{
		launch_dir  = VectorNormalize( self.origin - level.macv_skydemon.origin );

		chopper_yaw = flat_angle( level.macv_skydemon.angles );
		launch_yaw	= flat_angle( VectorToAngles( launch_dir ) );

		if( abs( launch_yaw[1] - chopper_yaw[1] ) < 10 )
		{
			break;
		}	

		wait( 0.05 );
	}

	// play one of two death effects
	position = "j_spine4";

	if( is_mature() )
	{
		if( cointoss() )
		{
			// more like blood spray
			PlayFXOnTag( level._effect["heli_mowdown_blood_geyser"], self, position );
		}
		else
		{
			// effect that imitates guy getting hit again and again
			PlayFXOnTag( level._effect["heli_mowdown_multihit"] , self, position );
		}
	}
	
	// kill this guy
	if( IsAlive( self ) )
	{
		self DoDamage( self.health + 100, self.origin );
	}

	// these guys only ragdoll
	//launch_dir  = vector_scale( launch_dir, 50 );

	// now kill these guys
	//self event1_skydemon_ai_deathfunc( launch_dir );
}


// this thread waits until skydemon is halfway through and spawn couple more guys to be killed
event1_second_encounter_guys_back_last()
{
	flag_wait( "spawn_guys_back_last" );
	trigger_use( "second_encounter_guys_back_last_trig", "targetname", level.player );
}


// special death for skydemon ai's
event1_skydemon_ai_deathfunc( launch_dir ) // self = skydemon ai
{
	self endon("death"); // ideally this should not happen but in case

	// start ignoring everyone, so that guys dont shoot while they are in ragdoll
	self.ignoreall = true;

	// make this guy ignored so that woods doesnt shoot them
	self.ignoreme  = true;

	// make this guy stop shooting at the entity which they might be shooting at
	self stop_shoot_at_target();

	// ragdoll, if this guy is not going to play an animations
	if( !IsDefined( self.script_noteworthy ) )
	{
		self StartRagdoll();
		self launchragdoll( launch_dir );
	}
	else
	{
		// animate if this AI has animated mowdown
		if( self.animated_mowdown )
		{
			self.a.nodeath = true;
			self.death_scene = "special_death";
			self thread anim_single_aligned( self, "special_death" );
		}
		else
		{
			// There used to be additional animations here, took it out for DEMO, only ragdoll
			self StartRagdoll();
			self launchragdoll( launch_dir );
		
			// SUMEET - bring this back if needed
			//AssertEx( self.a.pose == "stand", "Stance is not allowed." );
		
			//self.animname = "special_death";
	
			//index = RandomInt( level.scr_anim["special_death"].size );
			//self anim_single_aligned( self, "" + index );	
		}
	}

	// play one of two death effects
	position = "j_spine4";

	if( is_mature() )
	{
		if( cointoss() )
		{
			// more like blood spray
			PlayFXOnTag( level._effect["heli_mowdown_blood_geyser"], self, position );
		}
		else
		{
			// effect that imitates guy getting hit again and again
			PlayFXOnTag( level._effect["heli_mowdown_multihit"] , self, position );
		}
	}
	
	// wait for animation to over if these guys are special guys
	if( self.animated_mowdown )
	{
		death_anim_length = GetAnimLength( level.scr_anim[self.animname]["special_death"] );

		// waittill the death animation to be over or waittill 1/2 a sec before the animation and 
		// start ragdoll, this ensures that the AI doesnt pop back for a sec
		self waittill_notify_or_timeout( self.death_scene, death_anim_length - 0.5 );

		if( IsDefined( self.magic_bullet_shield ) )
		{
			self stop_magic_bullet_shield();
		}

		// one of the special deaths dont put the guy in ragdoll, so the guy pops back into ai
		// so put the guy in the ragdoll
		self StartRagdoll();
	}

	// we are killing these guys a little later so that they dont get aggressively DELETED	
	// because of skin verts issue. This prevents them from becoming corpses and getting deleted
	//wait(5);
	
	// stop magic bullet shield if its defined
	if( IsDefined( self.magic_bullet_shield ) )
	{
		self stop_magic_bullet_shield();
	}

	// kill this guy
	if( IsAlive( self ) )
	{
		//Assert( self IsRagdoll() );

		self DoDamage( self.health + 100, self.origin );
	}
}


// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - spotlight helicopter in first encounter ------
// -------------------------------------------------------------------------------------
event1_first_encounter_spotlight() // self = spotlight helicopter
{
	self endon( "death" ); // this shouldn't really happen
	flag_set("skydemon_flyover_1_spawned");
	
	self delete();
	
//	
//	
//	
//	// get positions where chopper should light
//	spotlight_structs = getstructarray( "first_encounter_spotlight_pos", "targetname");
//
//	// add spotlight effect
//	self thread event1_spotlight_on_gun( spotlight_structs ); 
//
//	// this is the position where it ends up and deletes itself
//	end_position_ent = GetstructEnt( "first_encounter_spotlight_hover_pos", "targetname" );
//	
//	// this is the entity where heli stops anf shines the spotlight
//	spotlight_halt_ent1	= GetstructEnt( "first_encounter_spotlight_halt_pos1", "targetname" );
//	spotlight_halt_ent2	= GetstructEnt( "first_encounter_spotlight_halt_pos2", "targetname" );
//	
//	// set very slow speed
//	self SetSpeed( 10 );
//
//	// hovering setup
//	self SetMaxPitchRoll( 10, 10 );
//	self SetHoverParams( 20, 5, 2 );
//		
//	// send the vehicle halt position
//	self SetVehGoalPos( spotlight_halt_ent1.origin );
//	
//	// try to look at this position
//	self SetLookAtEnt( end_position_ent );
//	
//	self.goalradius = 50;
//	self waittill ("goal");
//	
//	self SetSpeed (3);
//	self SetVehGoalPos( spotlight_halt_ent2.origin );
//	
//	//just wait until player moves up and delete this huey
//	waittill_ai_group_cleared( "first_encounter_group");
//
//	self SetSpeed (12, 3, 3);
//
//	// set near goal notify distance
//	self SetNearGoalNotifyDist( 16 );
//
//	// send this heli to the final hover position anf delete it
//	self SetVehGoalPos( end_position_ent.origin );
//
//	// waittill goal
//	self waittill_any( "goal", "near_goal" );
//	
//	// delete the look at and hover entity
//	spotlight_halt_ent1 Delete();
//	spotlight_halt_ent2 Delete();
//	end_position_ent Delete();
//
//	self event1_spotlight_off_gun();
//	// Delete
//	self Delete();
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - common spotlight function used by all helicopters ------
// -------------------------------------------------------------------------------------
event1_spotlight_on_gun( spotlight_structs, use_nose_turret ) // self = heli
{
	level notify( "stop_spotlight_shine" );

	if( IsDefined( level.spotlight ) )
	{
		// delete old spotlight so the effect will stop too
		level.spotlight Delete();
		wait(0.1);
	}
	
	tag = "tag_flash_gunner4";
	if (IsDefined(use_nose_turret))
	{
		tag = "tag_flash_gunner3";
	}
	// spawn a script model
	level.spotlight = spawn_a_model( "tag_origin", self GetTagOrigin( tag ), self GetTagAngles( tag ) );
	// link to the helicopter
	level.spotlight LinkTo( self, tag );

	// play spotlight effect
	//PlayFXOnTag( level._effect["macv_spotlight"], level.spotlight, "tag_origin" );
	
	PlayFXOnTag( level._effect["spotlightd"], level.spotlight, "tag_origin" );

	// now start shining on spotlight positions specified
	if( IsDefined( spotlight_structs ) )
	{
		self thread event1_spotlight_shine_positions( spotlight_structs, use_nose_turret );
	}
}


event1_spotlight_off_gun() // self = heli
{
	level notify( "stop_spotlight_shine" );

	if( IsDefined( level.spotlight ) )
	{
		// delete old spotlight so the effect will stop too
		level.spotlight Delete();
		wait(0.1);
	}
}


event1_spotlight_shine_positions( spotlight_structs, use_nose_turret ) // self = heli
{
	self endon( "death" );
	level endon( "stop_spotlight_shine" );
		
	turret_index = 3;
	if (IsDefined(use_nose_turret))
	{
		turret_index = 2;
	}
		
	while(1)
	{
		if( IsArray( spotlight_structs ) )
		{
			// get a random spotlight position
			spotlight_struct  = spotlight_structs[ RandomIntRange( 0, spotlight_structs.size ) ];
		}
		else
		{
			spotlight_struct = spotlight_structs;
		}
			
		// shine light on position
		self SetGunnerTargetVec( spotlight_struct.origin, turret_index );

		start_time = GetTime();
		buffer = 4 * 1000;

		if( !IsDefined( spotlight_struct.angles ) )
		{
			spotlight_struct.angles = ( 0,0,0 );
		}

		while( GetTime() < start_time + buffer )
		{
			// keep finding a spot around the selected spotlight struct
			index = RandomIntRange( 0, 4 );
			sub_spot = spotlight_struct.origin;
			
			switch ( index )
			{
				case 0:
					// left
					sub_spot_dir = AnglesToRight( spotlight_struct.angles ) * - 1;
					sub_spot = spotlight_struct.origin + vector_scale( sub_spot_dir, RandomIntRange( 50, 100 ) );
				case 1:
					// right
					sub_spot_dir = AnglesToRight( spotlight_struct.angles );
					sub_spot = spotlight_struct.origin + vector_scale( sub_spot_dir, RandomIntRange( 50, 100 ) );

				case 2:
					// forward
					sub_spot_dir = AnglesToForward( spotlight_struct.angles );
					sub_spot = spotlight_struct.origin + vector_scale( sub_spot_dir, RandomIntRange( 50, 100 ) );

				case 3:
					// back
					sub_spot_dir = AnglesToForward( spotlight_struct.angles ) * -1;
					sub_spot = spotlight_struct.origin + vector_scale( sub_spot_dir, RandomIntRange( 50, 100 ) );
			}

			// set the target to the new spot
			self SetGunnerTargetVec( sub_spot, turret_index );
			
			//
			if(!isDefined(self.spot_target))
			{
				self.spot_target = spawn("script_model",sub_spot);
				self.spot_target setmodel("tag_origin");
				playfxontag(level._effect["spotlightd_target"],self.spot_target,"tag_origin");
			}
			
			x = 0;
			while(x < 20 )
			{
				direction = level.spotlight.angles;
				direction_vec = anglesToForward( direction );
				org = level.spotlight.origin;
				
				// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
				trace = bullettrace( org, org + vector_multiply( direction_vec , 10000 ), 0, undefined );
				//trace2 = bullettrace(  trace["position"]+(0,0,2),  trace["position"], 0, level.player );
				
				// debug		
				//thread draw_line_for_time( eye, trace2["position"], 1, 0, 0, 0.05 );
				
				self.spot_target.origin = trace["position"];
				self.spot_target.angles = trace["normal"];
				wait 0.05;
				x++;
			}
			
			//wait(1);
		}

		wait(1);
	}
}

// set spotlight values
set_standard_spotlight_values()
{
	SetSavedDvar( "r_flashLightRange", "1000" );
	SetSavedDvar( "r_flashLightEndRadius", "800" );
	SetSavedDvar( "r_flashLightBrightness", "6" );
	SetSavedDvar( "r_flashLightOffset", "0 0 0" );
		
	SetSavedDvar( "r_flashLightFlickerAmount", "0.03" );
	SetSavedDvar( "r_flashLightFlickerRate", "65" );
	SetSavedDvar( "r_flashLightBobAmount", "4 6 0" );
	SetSavedDvar( "r_flashLightBobRate", "0.17 0.16 0.25" );
	SetSavedDvar( "r_flashLightColor", "0.03 0.2 0.3" );
	
	//SetDvar( "r_heroLightColorTemp", "6500" );
	//SetDvar( "r_heroLightSaturation", "1" );
	//SetDvar( "r_heroLightScale", "1 1 1" );
}

// spotlight values for after the 
set_post_skydemon_spotlight_values()
{
	SetSavedDvar( "r_flashLightRange", "800" );
	SetSavedDvar( "r_flashLightEndRadius", "300" );
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Civilians ----
// -------------------------------------------------------------------------------------

// spawn hallway civs 
event1_trigger_hallway_civs( guy )
{
	// this trigger will spawn civilians and then the spawn function will animate them
	trigger_use( "macv_first_civilians_trig", "targetname", level.player );
}

// civilians in 1st hallway
event1_civs_animate_hallway()
{
	// set the animname, we have to do it here as civilian system sets it to "civilian" when this AI spawns	
	self.animname = self.script_noteworthy;

	// spawn a magic bullet that kills this civilan
	self thread magic_bullet_thread();

	// make sure this civilian doesn die in between the animation
	self thread magic_bullet_shield();

		// for the bullets that kill the civs
	shotspot = getstruct("hallway_civs_shotspot", "targetname").origin;
	shots_delay = 1.6;
	self thread wait_and_fire_shots(shots_delay, shotspot);

	// play run animation
	self anim_single( self, "hallway_civ_run" );

	// stop magic bullet shield
	self stop_magic_bullet_shield();
	
	// no death animation needed
	self.a.nodeath = true;

	// now kill him for real
	self DoDamage( self.health + 100, self.origin );
}

magic_bullet_thread() // self = hallway running civilians
{
	self endon( "death" );

	while(1)
	{
		start_pos = getstruct( "bullet_start", "targetname" ).origin;
		start_pos = vector_scale( start_pos, 400 );

		eye_pos = self get_eye();

		// spawn a magic bullet
		MagicBullet( "fnfal_sp", start_pos, eye_pos );
		BulletTracer( start_pos, eye_pos, 1 );

		wait(0.5);
	}
}

event1_hallway_civ_left_cower()
{
	self.animname = "hallway_civ_left_cower";
	spot = Spawn("script_origin", (-2562, -5060, 7752));
	spot.angles = (0,160,0);
	
	self LookAtEntity(level.player);
	spot anim_single_aligned(self, "hallway_civ_left_cower");
	
	eye_pos = self get_eye();	
	start_point = getstruct( "bullet_start", "targetname" ).origin;

	// spawn a magic bullet
	MagicBullet( "fnfal_sp", start_point, eye_pos );
	self killme();	
}

	
// cowering civilian in the first hallway
event1_civ_animate_hallway_cower()
{
	self endon("death");

	anim_node = getstruct( "hallway_civ_cower_node", "script_noteworthy" );
	anim_node anim_single_aligned( self, "hallway_civ_cower");

	// create a magic bullet that kills this AI
	eye_pos = self get_eye();	
	start_point = getstruct( "bullet_start", "targetname" ).origin;

	// spawn a magic bullet
	MagicBullet( "fnfal_sp", start_point, eye_pos );
	BulletTracer( start_point, eye_pos, 1 );
	BulletTracer( start_point, eye_pos, 1 );

	// kill this civilian now
	anim_node anim_single_aligned( self, "hallway_civ_cower_death");	
		
	// no death animation needed
	self.a.nodeath = true;

	// now kill him for real
	self DoDamage( self.health + 100, self.origin );
}

// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Utility functions ----
// -------------------------------------------------------------------------------------

// This function chooses a random goal radius between min and max
randomize_goalradius( min, max )
{
	self.goalradius = RandomIntRange( min, max + 1 );
}

// modifies the animation playback rate
modify_run_rate( rate )
{
	self.moveplaybackrate = rate;
}

cqb_think() // toggles CQB based on AI has enemy or not
{
	level endon ("on_warroom_floor");
	level endon ("war_room_clear");
	
	self endon("death");

	while(1)
	{
		if ( !IsDefined(self.enemy) )
		{
			self enable_cqbwalk();
		}
		else 
		{
			self disable_cqbwalk();
		}
		
		wait(0.25);
	}
}

// disable exit or arrival parameters, set respective parameter to 1 to toggle
toggle_transitions( only_exit, only_arrival, only_turns ) // self = AI
{	
	// exit
	if( IsDefined( only_exit ) && only_exit )
	{
		if( !IsDefined( self.disableExits ) || !self.disableExits )
		{	
			// turn off exits	
			self.disableExits = true;
		}
		else
		{
			// turn on exits
			self.disableExits = false;
		}
	}

	// arrival
	if( IsDefined( only_arrival ) && only_arrival )
	{
		if( !IsDefined( self.disableArrivals ) || !self.disableArrivals )
		{	
			// turn off arrivals	
			self.disableArrivals = true;
		}
		else
		{
			// turn on arrivals
			self.disableArrivals = false;
		}
	}

	// turn
	if( IsDefined( only_turns ) && only_turns )
	{
		if( !IsDefined( self.disableTurns ) || !self.disableTurns )
		{	
			// turn off	
			self.disableTurns = true;
		}
		else
		{
			// turn on
			self.disableTurns = false;
		}
	}
	
}


// Adds a unsuccessful death function on the enemy spawners that plays a special effect
special_dragons_breath_death()
{
	// set this asa a deathfunction
	self waittill ("death", killer, dtype, killweapon);
	if(isDefined(killweapon) )
	{
		if(killweapon == "huey_pilot_gunner" || killweapon == "huey_rockets"|| killweapon == "huey_side_minigun" || killweapon == "huey_noseturret" )
		{
			level.huey_deaths++;
			if(level.huey_deaths == 20)
			{
				level.player giveachievement_wrapper( "SP_LVL_HUECITY_AIRSUPPORT" );
			}
		}
	}
	
	if( IsDefined( self.attacker ) && IsPlayer( self.attacker ) )
	{
		if( IsDefined(killweapon) && killweapon ==  "spas_db_sp")
		{	
			position = "j_spine4";		
			// play special effect
			PlayFXOnTag( level._effect["spas_death"], self, position );
			level.dragon_deaths++;
			if(level.dragon_deaths == 10)
			{
				level.player giveachievement_wrapper( "SP_LVL_HUECITY_DRAGON" );
			}
			
		}
	}
}



// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Skipto Functions ----
// -------------------------------------------------------------------------------------

event1_new_skipto()
{
	player = level.player;
	level.squad = [];
	level.squad["woods"] = simple_spawn_single( "woods_struct_spawner" );
	tp_to_start("e1d");
	
}


event1_new_skipto_after_skydemon()
{
	// let the level know which skipto it is
	level.skipto = "e1c_after_skydemon";

	// get the player 
	player = level.player;

	// spawn woods
	level.squad = [];
	level.squad["woods"] = simple_spawn_single( "woods_struct_spawner" );

	// Teleport player and ai
	start_teleport_ai( level.skipto, "squad" );
	start_teleport_players( level.skipto );
	
	// give player a weapon
	player skipto_give_player_weapon();

	// send squad to proper color node
	trigger_use( "woods_move_to_repel_room", "targetname", player );

	// call the level Script
	event1_main();
}


event1_new_skipto_mowdown()
{
	// let the level know which skipto it is
	level.skipto = "e1c_mowdown";
	
	// get the player 
	player = level.player;

	// spawn woods
	level.squad = [];
	level.squad["woods"]  = simple_spawn_single( "woods_struct_spawner" );
	
	// spawn friendlies
	friendlies = simple_spawn( "friendly_repel_guys" );

	// setup friendlies
	friendlies_skipto_setup( friendlies );

	// Teleport player and ai
	start_teleport_ai( level.skipto, "squad" );
	start_teleport_players( level.skipto );

	// send squad to proper color node
	trigger_use( "move_to_civ_modown_room_trig", "targetname", player );

	// give player a weapon
	player skipto_give_player_weapon();
	
	pre_mowdown_cowers();

	// call the level Script
	event1_main();
}



// kills unneeded troop for skipto and adds bowman to level squad array
friendlies_skipto_setup( friendlies )
{
	for( i=0; i<friendlies.size; i++ )
	{
		if( IsDefined( friendlies[i].script_noteworthy ) && friendlies[i].script_noteworthy == "troop1" )
		{
			self DoDamage( friendlies[i].health + 100, friendlies[i].origin );
		}
		else	
		{
			// add bowman to squad array
			level.squad["bowman"] = friendlies[i];
		}
	}	
}

skipto_give_player_weapon() // self = player
{
	// give player a weapon
	self GiveWeapon( "spas_db_sp" );
	self GiveWeapon("commando_sp");
	self SwitchToWeapon( "spas_db_sp" );
}

macv_end_of_summeet_section()
{
	level thread maps\hue_city_event1_reznov::event1_reznov();
}

fake_huey_sounds() // self is fakespirit
{
	if (isdefined(level.huey_ent))
	{
		level.huey_ent moveto(self.origin, 8.0);
		wait (8.0);
		level.huey_ent linkto(self);
		//iprintlnbold("LINKED");
		wait (1.5);
		level.huey_ent stoploopsound(2.5);
		wait (2.5);
		//iprintlnbold("STOPPED");
		level.huey_ent delete();
	}
}	



// --------------------------------------------------------------------------------------------
// ---- Called from hue_city_event_1_new.gsc after skydemon sequence is over ----
// --------------------------------------------------------------------------------------------
#using_animtree("generic_human");
event1_macv_after_skydemon()
{
	// SUMEET  - Turning on god ray exploders in the repel room early as Dale suggested
	exploder( 52 );
	exploder( 53 );

	// start a thread that monitors player door breach	
	level.player thread player_door_breack_effects();
		
	// hide the balcony fall destroyed model in the war room
	destroyed_balcony_models = GetEntArray( "balcony_destroyed", "targetname" );
	array_thread( destroyed_balcony_models, ::hide_destroyed_model ); 

	// start waiting until player enters the small room and the change the fog settings
	level thread event1_small_room_fog_monitor();

	// thread that monitors enemies in repel room
	level thread event1_repel_room_enemy_think();

	// civilian mowdown
	level thread event1_civilian_mowdown();

	level thread morse_code_room_think();
	
		// spawn this scene at appropriate time
	level thread stair_runaway_scene_guys_spawn();
}



// ------------------------------------------------------------------------------
// ---- Fog setting change for small room after skydemon ------
// ------------------------------------------------------------------------------
event1_small_room_fog_monitor()
{
	flag_wait("player_in_small_room");
	flag_clear("override_sumeets_cqbwalk");

	// send a notify to art file to change to small room fog.
	level notify("set_war_room_fog");
}

bowman_repel_after_smallroom_clear()
{
	waittill_ai_group_cleared("small_room_guys");
	trig = GetEnt("start_bowman_repel_trig", "targetname");
	wait 1;
	while(!flag("bowman_repel_go"))
	{
		if ( DistanceSquared(level.player.origin, trig.origin) < (60*60) )
		{
			trigger_use("start_bowman_repel_trig");
		}
		wait 0.05;
	}
}
	
	
// ------------------------------------------------------------------------------
// ---- Repel guys after skydemon event, these are spawn functions ------
// ------------------------------------------------------------------------------



event1_repel_guys() // self = repel heli
{
	//level thread close_to_lewrepel_trig();
	repel_node = GetVehicleNode( "repel_node", "script_noteworthy" );
	//repel_node waittill("trigger");
	flag_set("bowman_repel_go");

	// get the animation node
	anim_node = GetNode( "room5", "targetname" );	

	//anim_node = getstruct( "friendly_repel_anim_node", "targetname" );

	// spawn troop1 and bowman and animate repel
	level.friendlies = simple_spawn( "friendly_repel_guys", ::event1_repel_guys_internal, anim_node );
	morefriendlies =   simple_spawn( "bowman_struct_spawner", ::event1_repel_guys_internal, anim_node );
	level.friendlies = array_combine(morefriendlies, level.friendlies);

	// spawn the NVA's, 
	repel_enemies = struct_spawn( "nva_repel_guys_bowman");
	
	guys = get_ai_group_ai("small_room_guys");
	for (i=0; i < guys.size; i++)
	{
		guys[i] thread wait_and_kill(RandomFloatRange(1, 2) );
	}
}

event1_repel_guys_internal( anim_node) // self =  repel AI's ( NVA's and Redshirts with bowman )
{
	self endon("death");
	
	// animate the rope if this guy is part friendly squad
	if( IsDefined( self.script_noteworthy ) && (self.script_noteworthy == "squad" || self.script_noteworthy == "macv_bowman_ai") )
	{
		self thread event1_repel_guys_animate_rope( anim_node );	
	}

	// no repel AI is killable until the animation is over
	if( IsDefined( self.script_string ) && self.script_string == "kill_me" )
	{		
		self thread magic_bullet_shield();
	}

	// start animation right away if this is bowman, troop one will start based on notetrak in rope animation
	if( self.script_animname == "bowman" ) // bowman
	{
		// this is bowman, add him to squad array
		level.squad["bowman"] = self;
		level.bowman = self;
		
		self thread cqb_think();

		// wait for few and break the glass
		level thread event1_repel_bowman_breaks_glass();

		// actual repel animation		
		anim_node anim_single_aligned( self, "repel_in" );
		
		// tell the level that the repel is finished
		flag_set( "bowman_repel_done" );
	}
	else if( self.script_animname == "troop1" ) // troop 1
	{
		// wait until the rope is ready before starting to repel
		flag_wait("repel_troop_start");
		
		// actual repel animation
		
		time = GetAnimLength(level.scr_anim[self.animname]["repel_in"] );
		self enable_cqbwalk();
		
		anim_node thread anim_single_aligned( self, "repel_in" );
		wait time - 3.5;
		
		//level.bowman MagicGrenade( self.origin+ (100,0,50), self.origin, 0.1);
		self enable_cqbwalk();
		self StopAnimScripted();
		wait 3;
		self.allowdeath = 1;
		self stop_magic_bullet_shield();
		wait 4;
		self killme();

	}
	else
	{
		// NVA's
		anim_node anim_single_aligned( self, "repel_in" );
	}


	// this AI is not needed anymore, kill him now that the animation is finished
	if( ( IsDefined( self.script_string ) && self.script_string == "kill_me" ) ) 
	{
		self stop_magic_bullet_shield();
			
		// just kill, no death animation as the animation has death in it.
		self.a.nodeath = true;
				
		self DoDamage( self.health + 100, self.origin );
	}
}

event1_repel_bowman_breaks_glass()
{
	wait(1);

	// bowman breaks the glass
	break_glass_struct = getstruct( "glass_break","targetname" );
	RadiusDamage( break_glass_struct.origin, 200, 300, 200 );
	PhysicsExplosionSphere( break_glass_struct.origin, 100, 80, 5 );	
	exploder(51);
	wait 0.05;
	RadiusDamage( break_glass_struct.origin, 200, 300, 200 );
	wait 0.05;
	RadiusDamage( break_glass_struct.origin, 200, 300, 200 );
}

#using_animtree("animated_props");
event1_repel_guys_animate_rope( anim_node ) // self = repeling AI
{
	// spawn a rope
	repel_rope 		     = spawn_anim_model( "repel_rope" );
	repel_rope UseAnimTree(#animtree);
	repel_rope.animname  = "rope";

	// spawn additional anim reference
	new_anim_node = Spawn( "script_model", anim_node.origin );
	new_anim_node.angles = anim_node.angles;

	// rope animation is divided into two parts play one after another
	if( self.script_animname == "bowman" )
	{
		// bowman
		new_anim_node anim_single_aligned( repel_rope, "bowman_A" );
		new_anim_node anim_single_aligned( repel_rope, "bowman_B" );
	}
	else
	{
		// troop
		new_anim_node anim_single_aligned( repel_rope, "troop_A" );
		new_anim_node anim_single_aligned( repel_rope, "troop_B" );	
	}
	new_anim_node Delete();
	repel_rope Delete();
}

#using_animtree("generic_human");
event1_repel_troop_ready( guy )
{
	// set the flag so that troop 1 can start repelling down
	flag_set("repel_troop_start");
}

// ------------------------------------------------------------------------------
// ---- Repel helicopter ------
// ------------------------------------------------------------------------------
event1_repel_heli_think() // self = repel heli
{
	flag_set("bowman_repel_started");
	
	// get the current spotlight target position
	spotlight_structs = getstruct( "repel_down_spotlight", "targetname" );

	// set new helicopter spotlight values
	set_post_skydemon_spotlight_values();

	// turn spotlight on
	self thread event1_spotlight_on_gun( spotlight_structs );

	flag_wait( "bowman_repel_done" );

	// turn off spotlight before moving on
	//self event1_spotlight_off_gun();

	// set very slow speed
	self SetSpeed( 12 );

	// hovering setup
	self SetMaxPitchRoll( 10, 10 );
	self SetHoverParams( 20, 5, 2 );
		
	// set near goal notify distance
	self SetNearGoalNotifyDist( 16 );

	enemy_spotlight_pos = getstruct( "repel_enemy_heli_position", "script_noteworthy" );
	enemy_spotlight_pos.origin = (-3415.7, -6423.2, 8380);
	// set vehicle yaw
	self SetGoalYaw( enemy_spotlight_pos.angles[1] );

	// send the vehicle halt position
	self SetVehGoalPos( enemy_spotlight_pos.origin, 1 );
	
	// waittill goal
	self waittill_any( "goal", "near_goal" ); 
	self event1_spotlight_off_gun();	
	self Delete();
	
//	// get the current spotlight target position
//	//spotlight_structs = getstructarray( "repel_end_spotlights", "targetname" );
//
//	// turn spotlight on
//	//self thread event1_spotlight_on_gun( spotlight_structs );	
//
//	flag_wait("repel_room_clear");
//	
//	self SetSpeed(2,10,10);
//	wait 0.2;
//	enemy_spotlight_pos = getstruct( "repel_enemy_heli_position_2", "script_noteworthy" );
//	self SetGoalYaw( enemy_spotlight_pos.angles[1] );
//	self SetVehGoalPos( enemy_spotlight_pos.origin, 1 );
//	self SetSpeed(15,3,3);
//	
//	// wait until mowdown starts, and delete this heli
//	self waittill_any( "goal", "near_goal" ); 

	

	
}


// ------------------------------------------------------------------------------
// ---- Guy running back into rooms ------
// ------------------------------------------------------------------------------
room_runners_think() // self = runner
{
	self endon ("death");
	// start a magic bullet shield
	self thread magic_bullet_shield();

	// find the node to retreat 
	self set_goal_node( GetNode( self.targetname + "_node" , "targetname" ) );
	self waittill_notify_or_timeout( "goal", 5 );

	// stop magic bullet shield and kill
	self stop_magic_bullet_shield();
	self DoDamage( self.health + 100, self.origin );
}


// ------------------------------------------------------------------------------
// ---- Civilians ------
// ------------------------------------------------------------------------------

// civilians in the room after skydemon
event1_civs_animate_corner_surprise() // self = civilian
{
	self endon("death");
	clips = GetEntArray("scared_civ_clips", "targetname");
	array_thread(clips, ::wait_and_delete, 8, 1);

	self.animname = self.script_animname;

	// if this is the civilian who comes around the door, then woods need to know as he is going to aim him
	if( self.animname == "macv_civ_corner_surprise_2" )
	{
		flag_set("macv_civ_corner_surprise_2_spawned" );
	}

	node = getstruct("macv_civ_corner_surprise_anim_node", "targetname");
	
	// look at the player
	self LookAtEntity(level.player);
	
	level thread delaythread(6, ::restore_ik_headtracking_limits);
	relax_ik_headtracking_limits();

	
	node anim_single_aligned( self, "cower_come_in" );
	//node anim_loop_aligned( self, "cower_loop",undefined,"stop_cower" );
	newnode = GetNode("civ_runner_targetnode", "targetname");
	self LookAtEntity();	
	
	self.goalradius = 16;
	self SetGoalNode(newnode);
	self waittill ("goal");
	level.woods MagicGrenade(self.origin + (40,40,100), self.origin + (40,40,0), 0.1 );

	// stop looking at the player


	// kill this guy after player moves ahead
	wait 0.2;
	self DoDamage( self.health + 100, self.origin );
}


passage_beatdown_earlyout()
{
	self waittill_any("death","damage","grenade_danger");
	flag_set( "alert_beatdown_nva" );
}

// passage beatdown scene
event1_animate_passage_beatdown() // self = NVA or civ
{
	self endon("death");

	// get animation reference node
	anim_node = getstruct( "macv_passage_beatdown_node", "targetname" );

	// animate accordigly based on its a civ or nva
	if( self.script_noteworthy == "passage_beatdown_nva" )
	{
		// NVA
		self.ignoreme  = true;	
		self.ignoreall = true;		
		self.allowdeath = true;
		
		//handle killing him prematurely
		self thread passage_beatdown_earlyout();
		
		// looping animation of beating 
		anim_node thread anim_loop_aligned( self, "macv_nav_beatdown_loop",undefined,"stop_beatdown" );
	
		// wait until player comes around 
		flag_wait( "alert_beatdown_nva" );

		//wait(.25);
		
		// alerted because of player coming into the room
		anim_node anim_single_aligned( self, "macv_nav_beatdown_alert" );
		
		self.pathenemyfightdist = 64;
		self.pathenemylookahead = 64;
		self.goalradius = 32;
		self setgoalentity(level.player);
				
		// dont ignore anymore
		self.ignoreall = false;
		self.ignoreme = false;
		self thread wait_and_kill(30);
	}
	else
	{
		self thread passage_beatdown_earlyout();
		// Civilian

		// beating loop
		anim_node thread anim_loop_aligned( self, "macv_civ_beatdown_loop" ,undefined,"stop_beatdown");
	
		// wait until player comes around 
		flag_wait( "alert_beatdown_nva" );

		wait(2);

		// alereted
		anim_node anim_single_aligned( self, "macv_civ_beatdown_alert" );

		// idle animation
		anim_node thread anim_loop_aligned( self, "macv_civ_beatdown_idle" );

		// wait for player to move ahead and kill this civilian
	}
}


// ------------------------------------------------------------------------------
// ---- flyin civilian mowdown sequence ------
// ------------------------------------------------------------------------------
flyin_intro_civilian_mowdown()
{

	// get the animation reference node
	anim_node = getstruct("running_civ_encounter_ref2", "script_noteworthy");
	
	// spawn civilians first
	mowdown_civs = struct_spawn( "scared_civilians", ::event1_animate_civ_mowdown, anim_node );

	// spawn NVA's
	mowdown_nvas = struct_spawn( "nva_jerkholes", ::event1_animate_nva_mowdown, anim_node );
	array_thread(mowdown_nvas, ::wait_and_kill, 8);
}


// ------------------------------------------------------------------------------
// ---- civilian mowdown sequence ------
// ------------------------------------------------------------------------------
event1_civilian_mowdown()
{
	// wait until the flag is set to start this event, set by the trigger
	flag_wait("civ_mowdown_room");

	level thread event1_monitor_civilian_mowdown();

	// get the animation reference node
	anim_node = getstruct("running_civ_encounter_ref", "script_noteworthy");
	
	//kevin adding notify for the fleeing civs
	playsoundatposition( "evt_1_civs_loud" , anim_node.origin);

	// spawn civilians first
	mowdown_civs = struct_spawn( "scared_civilians", ::event1_animate_civ_mowdown, anim_node );

	cowering_civilian = simple_spawn( GetEnt( "crawling_civilian", "targetname" ), ::event1_animate_civ_mowdown, anim_node );

	// spawn NVA's
	mowdown_nvas = struct_spawn( "nva_jerkholes", ::event1_animate_nva_mowdown, anim_node );
}


event1_monitor_civilian_mowdown()
{
	// wait until all the enemies in the mowdown scene are killed
	flag_wait("civilian_modown_finished");
	
	// save a checkpoint
	autosave_by_name( "mowdown_finished" );
	SetCullDist(0);
}


// single civ mowdown animation
event1_animate_civ_mowdown( anim_node ) // self = mowdown scared civilian
{
	self endon ("death");
	// start magic bullet shield ...  TFlame 5/7/2010 - excent not anymore now that it asserts when ragdol in mbs
	//self thread magic_bullet_shield();
	self.allowdeath = 1;
	
	// SUMEET - This animation doesnt work with current anim node somehow, trying the 
	// animnode baked in to the geo by Jason, this is how we should be doing this anyway
	if( self.targetname == "crawling_civilian_ai" )
	{
		anim_node = GetNode( "room8","targetname" );
	}

	// animaname is already setup in radiant on the spawner properly
	time = GetAnimLength(level.scr_anim[self.animname]["macv_fleeing_civ_mowdown"]);
	anim_node thread anim_single_aligned( self, "macv_fleeing_civ_mowdown" );

	wait time - 0.2;
	// stop magic bullet shield
	//self stop_magic_bullet_shield();

	// no death animation. TODO - get death animations? or the main animation should have start_ragdoll
	self.a.nodeath = true;
	self.allowdeath = 1;
	
	// kill this civ
	self ragdoll_death();
}

event1_animate_nva_mowdown( anim_node ) // self = mowdown nva
{
	self endon("death");

	// these guys are now killable
	self.allowdeath = true;
	//self.health = 999999;
	self disable_pain();

	if (!flag("civ_mowdown_room"))
	{
		self thread wait_and_delete(10);
	}
	// animaname is already setup in radiant on the spawner properly
	
	anim_node thread anim_single_aligned( self, "macv_chasing_nva_mowdown" );
	
//	while(1)
//	{
//		self waittill ("damage", amount, attacker);
//		if (isplayer(attacker) )
//		{
//			break;
//		}
//	}
//	
//	self.health = 1;
//	self killme();
}

// waits until repel scene is done and then starts flodding guys in repel room
event1_repel_room_enemy_think()
{
	// waittill all the enemies in repel room are cleared
	waittill_ai_group_cleared( "repel_room_main_guys" );

	// tell everyone is that repel room is cleared
	flag_set( "repel_room_clear" );

	autosave_by_name("repel_room_clearead");
}


// ------------------------------------------------------------------------------
// ---- NVA's shooting civilians on stairs ------
// ------------------------------------------------------------------------------
event1_stairs_civilian_shooters()
{
	self endon ("death");
	// get a target to shoot at, this is targeted by the node this AI targeting in radiant
	shoot_ent = GetstructEnt( GetNode( self.target, "targetname" ).target, "targetname" );

	shoot_ent thread delete_on_delete(self);

	// tell this AI to shoot at this now
	self thread shoot_at_target( shoot_ent, undefined, 1, 4 );
	flag_wait("spawn_stair_mowdown");
	
	for (i=0; i < 6; i++)
	{
		if (DistanceSquared(level.player.origin, self.origin) < (300*300) )
		{
			break;
		}
		wait 0.5;
	}
	self stop_shoot_at_target();
	self SetGoalNode(GetNode("wdjghn", "targetname") );
}

stair_runaway_scene_guys_spawn()
{
		// wait until player is closer to see this event
	flag_wait( "start_stair_scenes" );
	flag_wait("start_stair_scenes_lookat");

	// wait for player to look at these guys
	//flag_wait("start_stair_scenes_lookat");
	trigger_use("stair_runaway_scene_guys", "target");
}

// ------------------------------------------------------------------------------
// ---- Staircase mowdown scene ------
// ------------------------------------------------------------------------------
event1_animate_stairs_mowdown_ent() // self =NVA or the civilian
{
	self endon("death");
	
	// ignore everyone
	self.ignoreall    = true;
	self.disableExits = true;	

	// they are all kilable in the animations
	self.allowdeath = true;

	// if this guy is civilian then we need to kill him
	// get the animation node, this is the node that Jason has in the geo, THANKS JASON and KEVIN
	anim_node = GetNode( "room10", "targetname" );
	new_anim_node = getstruct( "room10", "targetname" );
	
	// spawn a new animnode so that if there is anyone else playing animation using anim_node will not have issues
	//new_anim_node = Spawn( "script_origin", anim_node.origin );
	//new_anim_node.angles = anim_node.angles;

	// play the scene out
	time = GetAnimLength(level.scr_anim[self.animname]["stair_mowdown"]);

	
	if (self.animname == "stair_mowdown_CIV1")
	{
		new_anim_node thread anim_single_aligned( self, "stair_mowdown" );
		wait time - 2.3;
		self ragdoll_death();
	}
	else if (self.animname == "stair_mowdown_CIV2")
	{
		new_anim_node thread anim_single_aligned( self, "stair_mowdown" );
		wait time - 1.7;
		self ragdoll_death();
	}
	else if (self.animname == "stair_mowdown_CIV3")
	{
		new_anim_node thread anim_single_aligned( self, "stair_mowdown" );
		wait time - 2.8;
		self ragdoll_death();
	}
	else
	{
		new_anim_node anim_single_aligned( self, "stair_mowdown" );
	}

	// kill this AI if this is the civilian AI
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "stair_civs" )
	{
		self.a.nodeath = true;
		self DoDamage( self.health + 100, self.origin );
	}
	else
	{
		// this is a nva, set ignore all off
		self.ignoreall = false;
	}		
}

// ------------------------------------------------------------------------------
// ---- Stair case guy who dies on the back ------
// ------------------------------------------------------------------------------
event1_stair_guy_back_think() // self = stair AI
{
	self endon("death");
	// set the goalradius
	self.goalradius = 8;
	self.ignoresuppression = 1;

	// a thread that monitors the event, if player goes far then we need to kill this dude
	self thread event1_stair_guy_back_die_if_not_killed();

	// this guy die specially
	//self magic_bullet_shield();

	// track health and kill this guy
	self thread event1_stair_guy_back_special_death();

	// get the animation node, this is the node that Jason has in the geo, THANKS JASON and KEVIN
	anim_node = GetNode( "room10", "targetname" );	

	// spawn a new animnode so that if there is anyone else playing animation using anim_node will not have issues
	new_anim_node = Spawn( "script_model", anim_node.origin );
	new_anim_node.angles = anim_node.angles;
	
	// there is some issue about this guy sinking into the ground, fixing it by moving the align node a littl bit
	new_anim_node.origin = new_anim_node.origin + ( 0, 0, 15 );

	// save this on this guy for later reference, delete on his death
	self.anim_node = new_anim_node;
	self.anim_node thread delete_on_ent_notify(self, "death");

	// make the guy run to the starting position of the animation, and leave him there
	go_pos = GetStartOrigin( new_anim_node.origin, new_anim_node.angles, level.scr_anim["stair_nva"]["tumble_back_death"] );
	
	// go to this position
	self set_goal_pos( go_pos );
	self waittill( "goal" );
	self notify("do_death");

	// If there is anything that needs to be done after this guy reaches here, do it here
}

squad_run_to_safe_room()
{
	flag_wait("stair_enemies_2_dead");
	//level.bowman thread out_of_cqb_until_near_goal();
	//level.woods thread out_of_cqb_until_near_goal();
}

event1_stair_guy_back_die_if_not_killed()
{
	self endon("death");

	flag_wait("stair_enemies_2_dead");
	wait 2;
	// stop magic bullet shield
	self stop_magic_bullet_shield();	
}


event1_stair_guy_back_special_death()
{
	self endon("death");
	self waittill("do_death");

	while(1)
	{
		self waittill( "damage", value, attacker );
		
		if( IsPlayer( attacker ) )
		{
			break;
		}
	}

	// stop magic bullet shield
	self stop_magic_bullet_shield();
	self.allowdeath = 0;
	
	// trying to play death animation
	self.anim_node anim_single_aligned( self, "tumble_back_death" );

	// delete the anim node
	self.anim_node Delete();

	

	// no death animation
	self.a.nodeath = true;	

	self DoDamage( self.health + 100, self.origin );
	level notify ("tiles_stairs_start");
	
	return true;
}


// ------------------------------------------------------------------------------
// ---- Stair case guy who dies on the front ------
// ------------------------------------------------------------------------------
event1_stair_guy_front_think() // self = stair AI
{
	// set the goalradius
	self.goalradius = 8;
	self.ignoresuppression = 1;

	// a thread that monitors the event, if player goes far then we need to kill this dude
	self thread event1_stair_guy_front_die_if_not_killed();

	// this guy die specially
	self magic_bullet_shield();

	/*

	// get the animation node, this is the node that Jason has in the geo, THANKS JASON and KEVIN
	anim_node = getstruct( "war_room_anim_ref", "targetname" );	

	// spawn a new animnode so that if there is anyone else playing animation using anim_node will not have issues
	new_anim_node = Spawn( "script_model", anim_node.origin );
	new_anim_node.angles = anim_node.angles;
	
	// there is some issue about this guy sinking into the ground, fixing it by moving the align node a littl bit
	new_anim_node.origin = new_anim_node.origin + ( 0, 0, 15 );

	// save this on this guy for later reference
	self.anim_node = new_anim_node;

	// make the guy run to the starting position of the animation, and leave him there
	go_pos = GetStartOrigin( new_anim_node.origin, new_anim_node.angles, level.scr_anim["stair_nva"]["tumble_back_death"] );
	
	// go to this position
	self set_goal_pos( go_pos );
*/

	// wait until this guys gets to the goal	
	self waittill( "goal" );

	// track health and kill this guy
	self thread event1_stair_guy_front_special_death();

}

event1_stair_guy_front_die_if_not_killed()
{
	self endon("death");

	flag_wait("end_macv_scripting");

	// stop magic bullet shield
	self stop_magic_bullet_shield();	

	// stop ignoring me
	self.ignoreme = false;

	// just in case no one kills him
	self DoDamage( self.health + 100, self.origin );
}


event1_stair_guy_front_special_death()
{
	self endon("death");

	while(1)
	{
		self waittill( "damage", value, attacker );
		
		if( IsPlayer( attacker ) )
		{
			break;
		}
	}
	
	// trying to play death animation
	self anim_single_aligned( self, "tumble_front_death" );
	
	// stop magic bullet shield
	self stop_magic_bullet_shield();	

	// no death animation
	self.a.nodeath = true;	

	self DoDamage( self.health + 100, self.origin );
	
	return true;
}

// ------------------------------------------------------------------------------
// ---- Molotov thrower in staircase area ------
// ------------------------------------------------------------------------------

event1_staircase_molotov_thrower_think() // self = molotov thrower
{
	
	//turn off the hurt trigger where the molotov gets thrown
	molotov_hurt_trig = getent("molotov_hurt_trig","targetname");
	
	// get the position at where molotv thrower needs to take cover
	thrower_node = GetNode( "molotov_thrower_node", "targetname" );

	// this AI will not be killable until he throws the molotov
	self thread magic_bullet_shield();

	// go to throw position
	self set_goal_node( thrower_node );
	self waittill( "goal" );
	
	//flag_wait("start_stair_scenes");
	
	// play the animation and exploders
	self staircase_molotov_thrower_think_internal();
	
	molotov_hurt_trig trigger_on();

	// start the fire exploder from Dale
	exploder( 101 );

	// stop magic bullet shield
	self stop_magic_bullet_shield();
	
	// make this AI killable now in one shot
	self DoDamage( self.health - 10, self.origin );
}

// actually plays the throw animation
staircase_molotov_thrower_think_internal() // self = molotov thrower
{
	// get the start and land position for the molotov
	self.grenade_start_pos = getstruct( "molotov_start_pos", "targetname" );
	self.grenade_land_pos  = getstruct( "molotov_land_pos", "targetname" );
	
	// give this AI Molotov
	self.grenadeWeapon = "molotov_sp";

	// tell everyone that the molotov being thrown
	flag_set("molotov_being_thrown");

	// setup animname
	self.animname = "grenade_throw";
	
	//kevin threading molotov_throw_sound()
	self thread molotov_throw_sound();

	if( self.a.pose == "stand")
	{
		// play the animation
		self anim_single_aligned( self, "stand_throw" );
	}
	else // if (self.a.pose == "crouch")
	{
		self anim_single_aligned( self, "crouch_throw" );
	}

	// set the flag that the grenade thrower done
	flag_set("molotov_thrower_done");
}

//kevin adding a function that waits for anim throw
molotov_throw_sound()
{
	wait 1.5;
	self playsound( "wpn_molotov_throw" );
}

// called by fire notetrack from the throw animation
event1_grenade_throw( guy )
{
	start_origin = guy.grenade_start_pos.origin;
	land_origin  = guy.grenade_land_pos.origin;

	guy MagicGrenade( start_origin, land_origin, 10 );

	// wait for 4 sec for molotov to blow 
	wait(5);

	// then if there is any AI within the molotov fire volume kill them
	array_thread( get_ai_touching_volume( "axis", "molotove_fire_volume" ) , ::molotov_kill_ai, land_origin );
	volume = GetEnt("molotove_fire_volume", "targetname");
	volume thread trig_burn_u();
	volume thread delete_on_notify("player_breaching");

	// move this brushmodel to the explosion area, right now its outside the playable area	
	molotov_brush = GetEnt( "molotov_brush", "targetname" );
	molotov_brush.origin =  land_origin;

	// AI will not path through fire
	molotov_brush DisconnectPaths();
	molotov_brush thread wait_and_delete(10);
}

// SUMEET_TODO - Special death here?
molotov_kill_ai( explosion_position ) // self = AI withing the molotov explosion volume
{
	self DoDamage( self.health + 100, self.origin );
}	

// ------------------------------------------------------------------------------
// ---- Morse code room ------
// ------------------------------------------------------------------------------

morse_code_room_think()
{
	// morse code guy
	level thread morse_code_guy_think(); // self = level

	// additional enemies in the morse code room
	level thread morse_code_additional_enemies_think();
}

// Spawn a additinal enemy when door breach is finished
morse_code_additional_enemies_think()
{
	// first wait for player to start the breach
	flag_wait("player_breaching");

	// now wait for him to finish it
	flag_waitopen("player_breaching");

	// now spawn the morse code helper
	morse_code_helper = simple_spawn("morse_code_guy_helper");
}

#using_animtree ("generic_human");
morse_code_guy_think() // self = level
{
	trig = GetEnt("macv2_r_doortrig", "targetname");
	trig waittill ("door_opening");
	
	GetNode("saferoom_breach_door", "targetname").script_onlyidle = undefined;

	//TUEY Set Music State to WAR_ROOM
	setmusicstate ("WAR_ROOM");
	
	// spawn the guy
	morse_code_guy = simple_spawn_single( "morse_code_guy" );

	// get the animation reference
	anim_node = getstruct("morse_code_animate_node", "targetname"); 

	// start animating chair
	morse_code_guy thread morse_code_guy_animate_chair( anim_node );
	
	// notify sound function 
	level notify ("morse_interrupted");
				
	// set a flag when this AI dies
	morse_code_guy.deathFunction = ::morse_guy_track_death;

	// animate the dude
	anim_node anim_single_aligned( morse_code_guy, "guy3_react"); 
}

morse_guy_track_death()
{
	// tell everyone once this animation is done
	flag_set("morse_code_guy_dead");

	//autosave_by_name("morse_guy_dead");
		
	return false;
}

#using_animtree("animated_props");
morse_code_guy_animate_chair( anim_node )	// self = morse code guy
{
	new_anim_node = Spawn( "script_model", anim_node.origin );
	new_anim_node.angles = anim_node.angles;

	// spawn the chair
	tag_animate = spawn("script_model", (0, 0, 0) );
	tag_animate setmodel("tag_origin_animate");

	tag_animate UseAnimTree(#animtree);
	tag_animate.animname = "chair";
	tag_animate attach("p_glo_metal_chair", "origin_animate_jnt");

	// animate the chair
	new_anim_node anim_single_aligned( tag_animate, "chair_react" );
	
	// delete the animation reference
	new_anim_node Delete();
	
	tag_animate thread delete_on_notify ("event2_start_go");
}

// ------------------------------------------------------------------------------
// ---- Balcony Rpg guy ------
// ------------------------------------------------------------------------------
event1_balcony_rpg_guy_think()
{
	//level thread event1_player_balcony_fall();
}


event1_player_balcony_fall()
{
	// get rpg path
	rpg_shoot_pos = getstruct( "balcony_fall_rpg_start", "targetname" );
	rpg_end_pos = getstruct( "balcony_fall_end", "targetname" );
	
	trigs = getentarray("macv_Triggers","script_noteworthy");
	for(i=0;i<trigs.size;i++)
	{
		if(isDefined(trigs[i].target) && trigs[i].target == "war_room_downstair_guys")
		{
			trigs[i] waittill("trigger");
			flag_set("rpg_event_start");
		}
	}
	
	// wait for player to enter into the balcony trigger
	flag_wait( "rpg_event_start" );
	
	if(!flag("war_room_clear"))
	{
		
		wait RandomFloatRange(0.5,2);
	
		// get the vector between the player and guy
		player = level.player;
		dir_to_rpg = rpg_shoot_pos.origin - player.origin;
		
		// now fire a RPG magic
		MagicBullet("rpg_sp", rpg_shoot_pos.origin, rpg_end_pos.origin );
		
		wait(0.5);
	
		// play the explosion effect
		PlayFX( level._effect["war_room_explosion"], rpg_end_pos.origin );
			
		//balcony sounds
		level.balcony_crash = spawn("script_origin", rpg_end_pos.origin);
		level thread balcony_sounds();		
	
		// play the earthquake at this point	
		Earthquake( 0.6, 1, rpg_end_pos.origin, 800, level.player );
		PhysicsExplosionSphere( rpg_end_pos.origin, 100, 80, 5 );
	
		// swap the area model to the destroyed one
		good_balcony = GetEntArray( "balcony_good", "targetname" );
		array_thread( good_balcony, ::delete_good_model );
	
		// show the destoyed balcony
		destroyed_balcony_models = GetEntArray( "balcony_destroyed", "targetname" );
			
		// start teleporting the player the destoyed position
		array_thread( destroyed_balcony_models, ::show_destoyed_model );
	
	
		// play effects on balcony fall remains for few sec
		array_thread( getstructarray( "balcony_fall_effects_pos", "targetname" ), ::event1_balcony_fall_remains_fx );
	}
}

// play effects on balcony fall remains for few sec
event1_balcony_fall_remains_fx() // self = script origin to play effects on
{
	start_time = GetTime();
	buffer = 10 * 1000;
	
	
	while( GetTime() < start_time + buffer )
	{
		PlayFX( level._effect["fx_dest_hue_balcony_collapse"], self.origin, AnglesToForward( self.angles ) );
		wait(1);
	}

	// stop the effect, and delete the script origin
	//self Delete();
}


event1_player_balcony_fall_think( rpg_end_pos ) // self = player
{
	// we dont want the player to die while falling down
	self EnableInvulnerability();
	self FreezeControls( true );
	
	// get the player fall position 	
	fall_pos = getstruct( rpg_end_pos.target, "targetname" );

	// lerp the timescale
	self thread timescale_tween( 1, 0.5, 0.5 );
	
	level.player ShellShock ("explosion", 4);
	level.player SetStance("prone");

	// blink player eye
	//self thread balcony_event1_player_blink_eye();

	// blood overlay
	self thread balcony_blood_hud();

	// move the player to the fall position
	self SetOrigin( fall_pos.origin );
	
	// rumble effect
	self PlayRumbleOnEntity( "damage_heavy" );

	// wait till eye blinking is done
	//flag_wait( "player_eye_blinked");

	// lerp the timescale again
	level notify("timescale_tween");
	self thread timescale_tween( 0.5, 1, 1 );
	
	// player can take damage now
	self DisableInvulnerability();
	self FreezeControls( false );
}


balcony_blood_hud() // self = player
{
	self.blood_hud = NewClientHudElem( self );
	self.blood_hud.horzAlign = "fullscreen";
	self.blood_hud.vertAlign = "fullscreen";
	self.blood_hud SetShader( "overlay_low_health", 640, 480 );
	self.blood_hud.alpha = 4;

	self thread blood_hud_destroy();
}

balcony_blood_hud_destroy()
{
	FADE_TIME = 4;
	self.blood_hud FadeOverTime( FADE_TIME );
	self.blood_hud.alpha = 0;
	wait( FADE_TIME );

	self.blood_hud Destroy();
}

balcony_event1_player_blink_eye()
{
	level.blinkeye = NewHudElem(); 
	level.blinkeye.x = 0; 
	level.blinkeye.y = 0; 
	level.blinkeye.horzAlign = "fullscreen"; 
	level.blinkeye.vertAlign = "fullscreen"; 
	level.blinkeye.foreground = true;
	level.blinkeye SetShader( "black", 640, 480 );

	// slower blink
	level.blinkeye FadeOverTime( 0.1 ); 
	level.blinkeye.alpha = 1;

	wait( 0.3 );
	
	level.blinkeye FadeOverTime( 0.1 ); 
	level.blinkeye.alpha = 0;
	
	// eye blink is done
	flag_set( "player_eye_blinked");
	
	// wait a bit and destroy the hud
	wait(5);
	level.blinkeye Destroy();
}

delete_good_model()
{
	self Delete();
}

hide_destroyed_model() // self = model
{
	self Hide();
}

show_destoyed_model() // self = model
{
	self Show();
}


// ------------------------------------------------------------------------------
// ---- Additional effects for door breach - Jess's animation ------
// ------------------------------------------------------------------------------
player_door_breack_effects()
{
	// wait until player
	flag_wait("player_breaching");

	wait 0.4;
	// play Jess's effects
	level notify("door_office_01_start");
}


balcony_sounds()
{
	if (isdefined(level.balcony_crash))
	{
		wait(0.2);
		playsoundatposition("evt_balcony_collapse_1", level.balcony_crash.origin);
		wait(8.0);
		level.balcony_crash delete();
	}	
}




// -------------------------------------------------------------------------------------
// ---- NEW EVENT 1 - Dialogue Functions ----
// -------------------------------------------------------------------------------------

event1_dialogue_setup()
{
	level._lines_being_spoken = 0;
	
	wait 0.05;
	
	woods = level.woods;
	woods.animname = "woods";
	
	player = level.player;
	player.animname = "generic";

	
	level._extra = Spawn("script_origin", level.player.origin );
	extra = level._extra;
	extra LinkTo (level.player);
	extra.animname = "generic";
	extra.targetname = "extra_voiceover";
	
	intro_dialogue(woods, player, extra);
}


intro_dialogue(woods, player, extra)
{

	wait .05; // wait for woods to spawn
	
	setmusicstate ("INTRO");
	level thread maps\_audio::switch_music_wait ("MAC_V", 3.2);	
	

	
	woods line_please ("major_shit", 7.5);
	player line_please("here_to_extract");
	
	//ClientNotify for audio
	clientNotify ("fdeu");
	
	player line_please("lost_contact");
	

	
	woods line_please("well_find_him");
	extra line_please("hook_up");
	
	woods line_please("look_out", 13.9, "repel_is_on");
	
	
	event1_macv_dialogue(woods, player, extra);
}

// All bowmans dialgues are played on woods until he is spawned
event1_macv_dialogue(woods, player, extra)
{
	extra line_please( "visual_conf", 1.5, "skydemon_flyover_1_spawned" );		
	woods line_please( "got_nva_northwing");			
	woods line_please( "light_em_up" );																
	extra line_please( "lima9_inbound" );																	

	if (!flag("event1_skydemon_ready"))
	{
		extra line_please( "heads_down", 0, "player_in_hallway" );																		
	}
	
	woods line_please( "xray_clear", 0, "event1_skydemon_done" );						
	level notify( "mowdown_stops" );										//Kevin adding a notify for the chopper blades
	
	woods line_please( "move_up" );																				
	woods line_please( "out_of_way", 0.8, "macv_civ_corner_surprise_2_spawned" );	
	woods line_please( "ne_corner", 1 );	
	extra line_please( "on_our_way" );					
		
	if (!flag("bowman_repel_go"))
	{		
		extra line_please( "breaching_roof", 0, "bowman_repel_go" );			
	}

	flag_wait("bowman_repel_done");
	bowman = level.bowman;

	bowman line_please( "overrun");
	woods line_please( "dispatch_next_floor" );																				
	bowman line_please( "defec_survive");																				
	woods line_please( "tough_sonb" );																				
				
	nva_loudspeaker = GetEnt("stair_enemies_1_trig", "targetname");
	extra Unlink();
	extra.origin = (-3514, -7400, 7979);

	extra line_please("viet_squak1");																			
	woods line_please( "b_translate", undefined, undefined, "alert_beatdown_nva" );																				
	bowman line_please( "roundup", undefined, undefined, "alert_beatdown_nva"  );																	

	extra thread line_please( "collaboration_with", 0, "alert_beatdown_nva", "civilian_modown_finished" );		
			 
	bowman line_please( "get_down", 1.5, "civ_mowdown_room" );
	woods line_please( "anyone_doesnt_wont", 0, "civilian_modown_finished", "molotov_being_thrown");			
	woods line_please( "moving_on", undefined, undefined, "molotov_being_thrown" );																			

	player line_please( "safe_room_ahead", undefined, undefined, "molotov_being_thrown" );															
	woods line_please( "molotov", 0, "molotov_being_thrown" );						
	woods line_please( "at_the_window" );																		

	woods line_please( "safe_room_down", 3 );													
	bowman line_please( "clear", 0, "stair_enemies_2_dead" );					

	extra.origin = level.player GetEye();
	extra LinkTo(level.player);

	event1_saferoom_dialogue(woods, player, extra, bowman);
}

event1_saferoom_dialogue(woods, player, extra, bowman)
{
	player line_please("safe_room_compramised", 0, "outside_safe_room");
	
	waittill_ai_group_cleared("stair_enemies_3");
	autosave_by_name("safe_room");
	
	//TUEY set music state to Safe Room
	setmusicstate ("SAFE_ROOM");
	
	
	woods line_please("wheres_contact", 1); 
	player line_please("chance_nva"); 
	player line_please("move_on_me");
	
	woods line_please( "other_side_of_war_room", 5, "morse_code_guy_dead" );

	event1_warroom_dialogue_early(woods, player, extra, bowman);
	
	

}


//-- GLocke: fix for dialog not playing if the RPG event does not happen
event1_warroom_dialogue_early(woods, player, extra, bowman)
{
	flag_wait_any("rpg_event_start", "war_room_clear");
	if(flag("rpg_event_start"))
	{
		woods line_please("rpg");
	}
	
	event1_warroom_dialogue(woods, player, extra, bowman);
}


event1_warroom_dialogue(woods, player, extra, bowman)
{
	
	flag_wait("war_room_clear");
	bowman line_please("clear", 0, "war_room_clear");
	woods line_please("lima9_sitrep"); 
	extra line_please("nva_retaken_south");
	woods line_please("shit", undefined, undefined, "woods_breaching_reznov_hall"); 
	bowman line_please("yeah_copy_l9", undefined, undefined, "woods_breaching_reznov_hall");
	extra line_please("move_your_asses", undefined, undefined, "woods_breaching_reznov_hall");  
	player line_please("lets_move2", undefined, undefined, "woods_breaching_reznov_hall"); 
	
	
	woods line_please("should_be_in_rooms", 0, "woods_breaching_reznov_hall");

	woods line_please("door_at_end", 1.7, "doing_rezhall_quickanim");
	woods line_please("bowman_on_me", 1.7, undefined, "in_reznov_room");	
	flag_wait("in_reznov_room");
	//iprintlnbold("should be saying dialogue");
	
	//woods line_please("get_what_came_for");
	//player line_please("good_2_go");
	//player line_please("drago_havent_seen_last");
	
	reznov = level.reznov;
	//reznov line_please("influence_like_cancer");
	//reznov line_please("must_b_stopped");
	wait(2);
	reznov line_please("dsk_all_must_die");
	
	flag_wait("out_of_macv");
	wait(3.5);
	reznov line_please("these_ur_men");
	
	player line_please("woods_bow");
	reznov line_please("im_reznov");
	woods line_please("your_intel");
	//reznov line_please("see_no_chopper");
	woods line_please("wheres_our_lz", 0, "crossing_e1b_street");
	extra line_please("marine_force_engaged");
	extra line_please("push_through");
	woods line_please("find_way_through");
	
	extra Delete();
}

// -------------------------------------------------------------------------------------
// ---- END DIALOGUE FUNCTIONS ----
// -------------------------------------------------------------------------------------




// -------------------------------------------------------------------------------------
// ---- Civilian Vignettes in mowdown room before mowdown ----
// -------------------------------------------------------------------------------------


pre_mowdown_cowers()
{
	trigger_wait("first_pre_civ_mowdown_trig", "script_noteworthy");
	
	level thread cower2();
	
	guy = struct_spawn("pre_civ_mowdown_civ2")[0];
	
	spot = Spawn("script_origin", (-3920, -5750, 7752) );
	spot.angles = (0,180,0);
	
	guy thread wait_and_kill( 5, getstruct("pre_civ_mowdown_shotspot", "targetname").origin, 1);
	spot anim_single_aligned(guy, "cower");
	spot Delete();
}

cower2()
{
	level thread cower3();
	
	guy = struct_spawn("pre_civ_mowdown_civ3")[0];
	
	spot = Spawn("script_origin", (-3810, -5780, 7752) );
	spot.angles = (0,292,0);
	
	guy thread wait_and_kill( 5, getstruct("pre_civ_mowdown_shotspot", "targetname").origin, 1);
	spot anim_single_aligned(guy, "cower");
	spot Delete();

}

cower3(guy)
{
	trigger_wait("pre_civ_mowdown_trig");
	guy = struct_spawn("pre_civ_mowdown_civ1")[0];
	
	spot = Spawn("script_origin", (-3800, -6375, 7752) );
	spot.angles = (0,180,0);
	//flag_wait("civ_mowdown_room");
	guy thread magic_bullet_shield();
	spot anim_reach_aligned(guy, "cower");
	
	guy thread wait_and_kill( 5, getstruct("pre_civ_mowdown_shotspot", "targetname").origin, 1);
	spot thread anim_single_aligned(guy, "cower");
	wait 1;
	guy stop_magic_bullet_shield();
	wait 5;
	spot Delete();
}


sog_spas_guaranteed()
{
	self endon ("death");
	self endon ("disconnect");
	while(1)
	{
		weaps =  self GetWeaponsList();
		cur_weap = self getcurrentweapon();
		for( i = 0; i < weaps.size; i++ )
		{
			weapon = weaps[i];
			if(weapon == "spas_sp")
			{	
				//weaps[weapon]["clip"] = self GetWeaponAmmoClip( weapon );
				//	weaps[weapon]["stock"] = self GetWeaponAmmoStock( weapon );
				self takeweapon("spas_sp");
				self giveweapon("spas_sog_sp");				
				if(cur_weap == "spas_sog_sp" )
				{
					self switchtoweapon("spas_sog_sp");
				}
				else //if( cur_weap == "spas_db_sp")
				{
					wait(.05);
					self switchtoweapon("spas_db_sp");
				}
//				else
//				{
//					self switchtoweapon(cur_weap);
//				}
			}
		}
		wait(.05);
	}
}

temp_introscreen_fix()
{
	flag_wait( "starting final intro screen fadeout" ); 
	level._temp_introscreen_fixhud =	NewClientHudElem(level.player);
	level._temp_introscreen_fixhud.x = 0;
	level._temp_introscreen_fixhud.y = 0;
	level._temp_introscreen_fixhud setshader( "white", 640, 480 );
	level._temp_introscreen_fixhud.alignX = "left";
	level._temp_introscreen_fixhud.alignY = "top";
	level._temp_introscreen_fixhud.horzAlign = "fullscreen";
	level._temp_introscreen_fixhud.vertAlign = "fullscreen";
	level._temp_introscreen_fixhud.alpha = 1;
	//level._temp_introscreen_fixhud.sort = 1;
	
	wait 1.9;
	level._temp_introscreen_fixhud FadeOverTime(0.9);
	level._temp_introscreen_fixhud.alpha = 0;
}

macv_fire_locations()
{
	structs = getstructarray("macv_fire_locations", "targetname");
	for (i=0; i < structs.size; i++)
	{
		trig = Spawn("trigger_radius", structs[i].origin, 0, Int(structs[i].radius*0.8), 128);
		trig.targetname = structs[i].targetname;
		trig.script_noteworthy = structs[i].script_noteworthy;
		trig thread trig_burn_u();
	}
}

warroom_difficulty_adjustment()
{
	level endon ("war_room_clear");
	wait 20;
	set_generic_threatbias(2500);
	wait 35;
	level.woods.perfectaim = 1;
	level.bowman.perfectaim = 1;
	set_generic_threatbias(3500);
}
	

event1_threatbias_management()
{
	if ( is_hard_mode() )
	{
		return;
	}
	
	waittill_ai_group_cleared("first_encounter_group");
	waittill_ai_group_cleared("second_rusher_group");
	level.player SetThreatBiasGroup("player_ignored");
	flag_wait("event1_skydemon_done");
	level.player SetThreatBiasGroup("player");
	
	flag_wait("bowman_repel_done");
	set_generic_threatbias(1000);
	flag_wait("spawn_stair_mowdown");
	set_generic_threatbias(1500);
	GetEnt("macv2_r_doortrig", "targetname") waittill ("door_opening");
	level thread warroom_difficulty_adjustment();
}

close_to_lewrepel_trig()
{
	counter = 0;
	trig = GetEnt("close_to_lewrepel_trig", "targetname");
	struct = Spawn("script_origin", (-3429, -7558, 7958)); 
	struct2 = Spawn("script_origin", (-3481, -7665, 7820)); 
	
	while(!level.player IsTouching(trig))
	{
		wait 0.05;
		counter += 0.05;
	}
	
	time = 1.8-counter;
	if (time > 0)
	{
		origspeed = Int(GetDvar("g_speed"));
		SetSavedDvar("g_speed", 20);
		struct thread player_look_at_me(0.4,1);
		wait time;
		SetTimeScale (0.3);
		wait 0.4;
		timescale_fadeup(1);
		SetSavedDvar("g_speed",origspeed );
	}
	
	wait 1;
	struct Delete();
	struct2 Delete();
}

//recruit_db_switch()
//{
//	switched = 0;
//	if (level.gameskill == 0 && level.player GetCurrentWeapon() != "spas_db_sp" )
//	{
//		switched = 1;
//		level.player SwitchToWeapon("spas_db_sp");
//		wait 3;
//	}
//	
//	if (switched == 0)
//	{
//		return;
//	}
//	
//	while(switched == 1  && level.player GetCurrentWeapon() == "spas_db_sp" )
//	{
//		wait 1;
//	}
//	
//	
//	wait 3;
//	screen_message_create(&"HUE_CITY_SPAS_SWITCH");
//	counter = 0;
//	while(counter < 5 && level.player GetCurrentWeapon() != "spas_db_sp")
//	{
//		counter += 0.1;
//		wait(0.1);
//	}
//	screen_message_delete();	
//}
	
intro_dof()
{
	level waittill ("broke_through_macv_window");
	wait 1;
	level.player SetDepthOfField(0, 121, 145, 1279, 6, 1.8);
	wait 15;
	level.player SetDepthOfField(0, 1, 8000, 10000, 6, 0);
}

spawn_commando_marine()
{
	flag_wait("outside_safe_room");
	struct_spawn("dead_marine_leaving_commando", ::killme);
}

intro_guys_move()
{
	dronetrig3 = GetEnt("macv_intro_drones3", "target");
	wait 0.5;
	trigger_use("macv_intro_drones3", "target");
	
	delaythread(0.15, ::flyin_intro_civilian_mowdown);
	
	wait 1;
	//dronetrig1 = GetEnt("macv_intro_drones2", "target");
	dronetrig = GetEnt("macv_intro_drones", "target");

	
	guys = struct_spawn("intro_enemies_1a");
	array_thread(guys, ::wait_and_kill,5);
	
	wait 1.5; // 5  
	
	
	dronetrig3 Delete();
	
	wait 1;
	trigger_use("macv_intro_drones", "target");
	
	guys = struct_spawn("intro_enemies_3a", maps\hue_city_ai_spawnfuncs::intro_enemies_2a_setup);
	array_thread(guys, ::wait_and_delete,10);
	wait 4;
	
	wait 4.5; // 14
	
	trigger_use("intro_truck_go");
	
	wait 3; // 17
		
	wait 2;
	
	guys = struct_spawn("intro_enemies_6a", maps\hue_city_ai_spawnfuncs::cqb_and_ignore);
	array_thread(guys, ::wait_and_delete,10);
	
	wait 5;
	
	dronetrig Delete();
	
	GetEnt("intro_truck_go", "targetname") Delete();
}

repel_rumbles()
{
	thread wait_and_rumble(3.95, "damage_heavy"); // carabiner
	
	
	thread wait_and_rumble(11.2, "grenade_rumble");
	
	thread wait_and_rumble(11.4, "grenade_rumble");
	
	thread wait_and_rumble(11.6, "explosion_generic");
	
	thread wait_and_rumble( 33, "assault_fire");

}


e1_mowdown_minigun_rumble()
{
	level endon ("event1_skydemon_done");
	self endon ("death");
	counter = 0;
	
	player = level.player;
	player endon("death");
	
	while(1)
	{
		if (counter == 4)
		{
			Earthquake(0.1, 1, self.origin, 3000);
			counter = 0;
		}
		counter++;
		level.player PlayRumbleOnEntity("pistol_fire");
		wait 0.25;
	}
}



reznov_door_breach_trig()
{
	
	door = getent("reznov_breach_door","targetname");
	door connectpaths();
	trig = getent("reznov_door_breach_trig","targetname");
	trig waittill("door_opening");
	
	clip = getent("reznov_breach_clip","targetname");	
	clip connectpaths();
	clip delete();
}


event1_rushers()
{
	self.pathenemyfightdist = 64;
	self.pathenemylookahead = 64;
	self.goalradius = 32;
	self setgoalentity(level.player);
}