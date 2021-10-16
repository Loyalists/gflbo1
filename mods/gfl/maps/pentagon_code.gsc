//[ceng]

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;

//**************************************
//DEBUG
//**************************************
DEBUGTEXT( msg )
{
	/#
	IPrintLnBold( "^7" + msg );
	#/
}

DEBUGPAUSE()
{
	player = get_players()[0];

	while( !player UseButtonPressed() )
	{
		wait 0.05;
	}
}

show_tag_pos( tag_name )
{
	self endon( "death" );

	while( true )
	{
		if( IsDefined( self.script_noteworthy ) )
		{
			PrintLn( self.script_noteworthy );
		}
		else if( IsDefined( self.targetname ) )
		{
			PrintLn( self.targetname );
		}
		org = self GetTagOrigin( tag_name );
		ang = self GetTagAngles( tag_name );

		if( !IsDefined( org ) || !IsDefined( ang ) )
		{
			return;
		}

		PrintLn( tag_name+" org: "+org[0]+" "+org[1]+" "+org[2] );
		PrintLn( tag_name+" ang: "+ang[0]+" "+ang[1]+" "+ang[2]+"\n" );
		wait( 0.05 );
	}
}

#using_animtree( "vehicles" );
snap_to_final_pos()
{
	self SetAnim( %v_pentagon_chopper_intro, 1, 0, 0 );
	self SetAnimTime( %v_pentagon_chopper_intro, 1.0 );
}

//**************************************
//EVENT HELPERS
//**************************************
do_glasses_movie()
{
	//Test - Fade our own whitescreen later than usual to hide that pop.
	wait 0.50;
	level hud_utility_hide( "white", 1.0 );

	//gzheng
	//playing movie starting from hudson's glass
	//to fullscreen
	//doing fake triple camera.

	level.playerbody_firstperson waittillmatch( "single anim", "start_glasses" );

	level.hud_utility destroy();

	flag_set("glasses_movie");

	wait(1);
	
	playsoundatposition ("mid_drag_flash_movie", (0,0,0));

	level.hudson setclientflag(level.CLIENT_SWITCH_GLASSES_BINK);

	Start3DCinematic( "hudson_glasses", false, true );
	level thread start_hudson_bloom();


	level.playerbody_firstperson waittillmatch( "single anim", "start_video" );

	level clientnotify("start_glasses_bink");
	//hud_utility_show( "cinematic", 0 );

	wait( 3 );

	flag_set("glasses_done");

	level notify( "glasses_movie_done" );
	level clientnotify("end_glasses_bink");
	//wait( 1 );
	Stop3DCinematic();

	//level.hud_utility destroy();
	level.hudson setclientflag(level.CLIENT_SWITCH_GLASSES);

	//wait(11);
	//level clientnotify("start_triple_cam");
	//level thread insert_fake_splitscreen_here();
}
start_hudson_bloom()
{




}

insert_fake_splitscreen_here()
{
	wait(2);
	Start3DCinematic( "splitscreen", false, true );
	wait 13;
	//hud_utility_hide( "white", 0.25 );
	//Hide the flash and wait through the remainder of the 1 second.
	Stop3DCinematic(); 
}

update_sound_for_tarmac()
{
	level.playerbody_firstperson waittillmatch( "single anim", "on_tarmac" );

	clientnotify ("tarmac_room");
}

start_limo_movie()
{
	wait(5.5);
	bloom_tag = spawn("script_model",level.fakeMotorcade[ "limousine" ] gettagorigin("tag_body"));
	bloom_tag setmodel("tag_origin");
	bloom_tag.angles = level.fakeMotorcade[ "limousine" ]gettagangles("tag_body");
	bloom_tag linkto(level.fakeMotorcade[ "limousine" ],"tag_body");


	playfxontag(level._effect["limo_bloom"],bloom_tag,"tag_origin");

	level.fakeMotorcade[ "limousine" ] setclientflag(level.CLIENT_SWITCH_GLASSES_BINK);
	Start3DCinematic( "temp_macnamara", false, true );
	wait(3);
	bloom_tag delete();
}

limo_flashback( guy ) //self == whatever the anim was played relative to; guy is unused, passed in by addnotetrack_customfunction
{
	//Flash of Dragovich.
	//hud_utility_show( "white", 0.25 );
	playsoundatposition ("evt_shocking_1", (0,0,0));
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "dragovich_flash_1", false, true );
	//	DEBUGTEXT( "DRAGOVICH" );
	wait 0.25;
	//hud_utility_hide( "white", 0.25 );

	//Hide the flash and wait through the remainder of the 1 second.

	hud_utility_hide();
	Stop3DCinematic(); 
	wait 0.75;

	//Flash of Cuba.
	//hud_utility_show( "white", 0.25 );
	playsoundatposition ("evt_shocking_2", (0,0,0));
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "dragovich_flash_2", false, true );
	//	DEBUGTEXT( "IN CUBA" );
	wait 0.25;
	//hud_utility_hide( "white", 0.25 );

	//Hide the flash and wait through the remainder of the 1 second.
	hud_utility_hide();
	Stop3DCinematic(); 
	wait 0.75;

	//Pause for dramatic effect.
	wait 2.0;

	level.bumps = false;

	//TEMP WHEN BOTTOM IS COMMENTED OUT
	//wait 1.0;
	//FLASHBACK SEQUENCE!
	//Start with the game-standard flash-in effect (TBD).
	//kevin needs to add drag mov audio
	hud_utility_show( "white", 1 );
	playsoundatposition ("mid_drag_flash_movie", (0,0,0));
	hud_utility_show( "cinematic", 0 );
	Start3DCinematic( "dragovich_flash_3", true, true );
	//	DEBUGTEXT( "DRAGOVICH CAPTURING MASON IN CUBA." );

	//Stop traffic and the character animations to buy time on the highway! 
	level pause_all_traffic();
	//rearEnts = array( level.heroes[0], level.heroes[1], level.heroes[2], level.limousine.riders[ "general" ], level.dossier ); 
	//array_thread( rearEnts, ::pause_anim, "motorcade_rail_limo" );

	//rearPassengers = array_add( level.heroes, level.limousine.riders[ "general" ] );
	//array_thread( rearPassengers, ::pause_anim, "motorcade_rail_limo" );

	//	DEBUGTEXT( "REZNOV IN VORKUTA." );
	wait 1.0;

	//	DEBUGTEXT( "OPENING SINKING HUEY DOOR, NO REZNOV." );
	wait 1.0;

	//TEMP - Use notetracks instead? (No anim here...)
	//level delaythread( 0.0, ::anim_single, level.limousine.riders[ "passenger" ], "what_the_fuck" );

	//	DEBUGTEXT( "VICTOR CHARLIE RAT HOLE, NO REZNOV." );
	wait 1.0;

	//Make all traffic and animations resume before the flashback ends.
	level resume_all_traffic();
	//array_thread( rearEnts, ::resume_anim, "motorcade_rail_limo" );

	hud_utility_hide( "white", level.FADE_TIME );
	Stop3DCinematic();

	level.bumps = true;

	level thread limo_ride_bumps();
}


limo_ride_bumps()
{
	player = get_players()[0];

	while(level.bumps)
	{
		earthquake(RandomFloatRange(0.07, 0.15), RandomFloatRange(1.0, 1.5), player.origin, 200);

		//player PlayRumbleOnEntity("reload_small");

		wait(RandomFloatRange(1.0, 1.6));
	}
}


move_motorcade_back( restartPrefix )
{
	for( i = 0; i < level.realMotorcade.size; i++ )
	{
		//Get a vehicle.
		vehicle = level.realMotorcade[i];

		//Remove the vehicle from the path it was driving.
		vehicle vehicle_pathdetach();

		//Move the vehicle to its personal teleportNode and have it drive from there.
		//teleportNode = GetVehicleNode( "vnode_motorcade_restart_" + vehicle.script_noteworthy, "targetname" );
		teleportNode = GetVehicleNode( restartPrefix + vehicle.script_noteworthy, "targetname" );
		vehicle thread go_path( teleportNode );
	}
}

move_heroes_to_security()
{
	//Unlink the heroes from the limousine so we may move them to security.
	array_func( level.heroes, ::un_link );

	//Stop animscripts and animations running on the heroes so we can teleport them.
	array_func( level.heroes, ::anim_stopanimscripted );

	//Test - Swap McNamara's model back to the standing version!
	level.mcnamara SetModel( "t5_gfl_m1903_body" );

	//Move the heroes into security.
	level.anim_structs[ "pool_rail" ] thread anim_first_frame( level.heroes, "security_rail_vip" );
}

security_camera_cuts()
{
	player = get_players()[0];

	//player startCameraTween(2.0);

	wait(1.0);

	//maps\pentagon_fx::dof_security_setting( 0.05 );

	move_to_struct = getstruct("security_player_zooming", "targetname");
	move_to_struct_2 = getent("camera_pos_clerk", "targetname");

	player.playerbody_firstperson hide();

	level.fake_mason show();

	clerk = getent("clerk_pos", "targetname");
	clerk_camera_pos = getent("camera_pos_clerk", "targetname");

	camera_pos = spawn("script_model", clerk_camera_pos.origin);
	camera_pos setmodel("tag_origin");

	camera_pos movez(10, 2.0);

	player CameraSetPosition(camera_pos);
	player CameraSetLookAt(clerk.origin);
	player CameraActivate(true);

	wait(1.4);

	//cut away from clerk
	move_to_struct = getstruct("security_player_zooming_2", "targetname");
	move_to_struct_2 = getstruct(move_to_struct.target, "targetname");

	camera_pos = spawn("script_model", move_to_struct.origin);
	camera_pos setmodel("tag_origin");

	mason_lookat = spawn("script_model", level.fake_mason.origin + (0, 0, 40));
	mason_lookat setmodel("tag_origin");
	mason_lookat linkto(level.fake_mason);

	camera_pos moveto(move_to_struct_2.origin, 3.0);
	



	wait(0.1);

	player CameraSetPosition(camera_pos);
	player CameraSetLookAt(mason_lookat);
	old_fov = GetDvarFloat( #"cg_fov" );
	player SetClientDvar( "cg_fov", 35 );
	SetTimeScale(0.5);

	player SetDepthOfField( 0, 115, 1000, 9286, 4, 1.03 );

	wait(2.0);

	player maps\_art::setdefaultdepthoffield();

	player SetClientDvar( "cg_fov", old_fov);
	//cut to metal detector
	move_to_struct = getstruct("security_player_zooming_3", "targetname");
	move_to_struct_2 = getstruct(move_to_struct.target, "targetname");

	camera_pos = spawn("script_model", move_to_struct.origin);
	camera_pos setmodel("tag_origin");

	mason_pos = spawn("script_model", level.fake_mason.origin + (0, 0, 64));
	mason_pos setmodel("tag_origin");
	mason_pos linkto(level.fake_mason);

	camera_pos moveto(move_to_struct_2.origin, 3.0);

	player CameraSetPosition(camera_pos);
	player CameraSetLookAt(mason_pos);

	wait(2.0);

	player CameraActivate(false);

	camera_pos delete();
	mason_pos delete();

	SetTimeScale(1);

	level.fake_mason hide();
	player.playerbody_firstperson show();

	player SetPlayerAngles((0, 112, 0));

	player PlayerLinkToDelta(  player.playerbody_firstperson, "tag_player", 1, 0, 0, 0, 0, false );

	wait(0.5);

	player startCameraTween(1.0);

	player player_linkto_delta( player.playerbody_firstperson, "tag_player" );
}


smoking_girl_camera_cut()
{
	wait(7.2);

	player = get_players()[0];
	move_to_struct = getstruct("smoking_girl_camera_cut_start", "targetname");
	move_to_struct_2 = getstruct(move_to_struct.target, "targetname");
	player_link = spawn("script_model",player.origin);
	player_link setmodel("tag_origin");
	player_link.angles = player.angles;
	player unlink();
	player PlayerLinkToAbsolute(player_link, "tag_origin");
	player_link.angles = move_to_struct.angles;
	
	playsoundatposition( "evt_num_num_04_d" , (0,0,0) );
	player playloopsound( "amb_trippy" , (.5) );
	SetTimeScale(0.5);

	player setblur( 1, 0.1);

	player thread lerp_fov_overtime(0.05, 35);

	player startCameraTween(1.0);

	player_link moveto(move_to_struct.origin, 0.5, 0.1, 0.1);
	//player_link waittill("movedone");
	wait(0.4);

	player_link RotateTo(move_to_struct_2.angles, 3);

	wait(0.1);

	player_link moveto(move_to_struct_2.origin, 3, 0, 0);
	//player_link waittill("movedone");
	wait(2.6);

	player unlink();
	
	player stoploopsound(.1);
	
	SetTimeScale(1);
	//player thread timescale_tween(0.5, 1.0, 1.0);

	player setblur( 0, 0.1);

	player thread lerp_fov_overtime(0.1, 65);
	//player SetPlayerAngles((0, 112, 0));

	player startCameraTween(1.0);

	player PlayerLinkToDelta(  player.playerbody_firstperson, "tag_player", 1, 0, 0, 0, 0, false );
	wait(0.5);
	player player_linkto_delta( player.playerbody_firstperson, "tag_player" );
}


start_warroom_split_screen()
{
	wait(9);
	level clientnotify("start_triple_cam_warroom");

	Start3DCinematic( "split_512x600", false, true );
	level waittill("cine_notify", num);
	
	while(num != 0)
	{
		level waittill("cine_notify", num);
	}
	level clientnotify("kill_warroom_bink");
	Stop3DCinematic();
}

setup_briefing_room()
{
	//NOTE: This was moved from e7_setup() to here since that was too late, allowing the player to
	//see Kennedy, the chairs, and the dossier spawn.

	//Spawn Kennedy and anim_first_frame him into position.
	level.kennedy = simple_spawn_dummy( "spawner_kennedy" );
	level.anim_structs[ "warroom_rail" ] anim_first_frame( level.kennedy, "briefing_rail_entrance" );

	//Spawn the animated chairs and anim_first_frame them into position.
	level.chairMason = spawn_anim_model( "chair_mason" );
	level.chairKennedy = spawn_anim_model( "chair_kennedy" );
	level.anim_structs[ "warroom_rail" ] anim_first_frame( level.chairMason, "briefing_rail_entrance" );
	level.anim_structs[ "warroom_rail" ] anim_first_frame( level.chairKennedy, "briefing_rail_entrance" );

	//Spawn the dossier and anim_first_frame it into position.
	level.dossier = spawn_anim_model( "dossier" );
	level.anim_structs[ "warroom_rail" ] anim_first_frame( level.dossier, "briefing_rail_entrance" );
}

//------------------
//GENERIC UTILITY
//------------------
align_to( object, tagName, useFlatAngles ) //self == an non-player object
{
	if( !isDefined( object ) )
	{
		printLn( "align_to(): object is undefined!" );
		return;
	}

	//If self is linked, it will be unable to move!
	self Unlink();

	if( isDefined( tagName ) )
	{
		self.origin = object getTagOrigin( tagName );
		self.angles = object getTagAngles( tagName );
	}
	else
	{
		self.origin = object.origin;

		if( IsDefined( object.angles ) )
		{
			if( is_true( useFlatAngles ) )
			{
				self.angles = flat_angle( object.angles );
			}
			else
			{
				self.angles = object.angles;
			}
		}
		else
		{
			self.angles = (0,0,0);
		}
	}
}

//NOTE: this returns angles in degrees.
angle_between_vectors( a, b )
{	
	cosine = vectorDot( a, b );

	//Rounding errors may make the dot product out of range for cosine.
	cosine = clamp( cosine, -1, 1 );

	//This is a cross product, though I am getting undefined errors if try to replace it with VectorCross...
	if( (a[0] * b[1] - a[1] * b[0] ) < 0 )
		return -1 * acos( cosine );
	else
		return acos( cosine ); 
}

convert_ips_to_mph( inchesPerSecond )
{
	//60 sec per min, 60 min per hour; 12 in per ft, 5280 ft per mi.
	return (inchesPerSecond * 60 * 60 / 12 / 5280);
}

convert_mph_to_ips( milesPerHour )
{
	//60 min per hour, 60 sec per min, 5280 ft 
	return( milesPerHour / 60 / 60 * 5280 * 12 );
}

clamp_value( value, min, max )
{
	if( !isDefined( value ) )
	{
		return 0; //undefined;
	}

	if( isDefined( min ) && value < min )
	{
		value = min;
	}
	else if( isDefined( max ) && value > max )
	{
		value = max;
	}

	return value;
}

get_kvp_from_tokens( tokens, theKey )
{
	//Prepare a result variable.
	value = undefined;

	//Lower case the key.
	theKey = toLower( theKey );

	//Search the tokens for the key.
	for( i = 0; i < tokens.size; i++ )
	{
		//Grab a token to inspect.
		token = tokens[ i ];

		//If this token matches the specified key...
		if( token == theKey )
		{
			//We found the token, try to take the next token as the value.
			if( isDefined( tokens[ i + 1 ] ) )
			{
				return tokens[ i + 1 ];
			}
		}
		//Else skip to the next token.
	}
}

isNumber( variable )
{
	if( !isDefined( variable ) )
	{
		return false;
	}

	return (isInt( variable ) || isFloat( variable ));
}

link_to( object, tagName, originOffset, anglesOffset )
{
	AssertEx( isDefined( object ), "link_to() called with an undefined object!" );

	if( isDefined( anglesOffset ) )
	{
		self linkTo( object, tagName, originOffset, anglesOffset );
	}
	else if( isDefined( originOffset ) )
	{
		self linkTo( object, tagName, originOffset );
	}
	else if( isDefined( tagName ) )
	{
		self linkTo( object, tagName );
	}
	else
	{
		self linkTo( object );
	}
}

stop_sounds()
{
	self StopSounds();
}

teleport_heroes( destinationName )
{
	if( !isDefined( destinationName ) )
	{
		return;
	}

	structs = getStructArray( destinationName, "targetname" );

	for( i = 0; i < structs.size; i++ )
	{
		struct = structs[ i ];

		switch( toLower( struct.script_noteworthy ) )
		{
		case "mason":		
			get_players()[0] SetOrigin( struct.origin );
			get_players()[0] SetPlayerAngles( struct.angles );
			break;

		case "hudson":
			if( isDefined( level.hudson ) )
			{
				level.hudson.origin = struct.origin;
				level.hudson.angles = struct.angles;
			}
			break;

		case "mcnamara":
			if( isDefined( level.mcnamara ) )
			{
				level.mcnamara.origin = struct.origin;
				level.mcnamara.angles = struct.angles;
			}
			break;
		}
	}
}

un_link()
{
	self Unlink();
}

give_link_ent()
{
	linkEnt = Spawn( "script_model", self.origin );
	linkEnt SetModel( "tag_origin" );
	linkEnt align_to( self );
	self.linkEnt = linkEnt;
}

//**************************************
//ANIMATION
//**************************************
do_cinematic_blending( should_blend )
{
	if( !IsDefined( should_blend ) )
	{
		should_blend = true;
	}

	blendval = 0.0;
	if( should_blend )
	{
		blendval = 0.2;
	}

	for( i = 0; i < level.heroes.size; i++ )
	{
		level.heroes[i]._anim_blend_in_time = blendval;
		level.heroes[i]._anim_blend_out_time = blendval;
	}
}

pause_anim( scene ) //self == an animated ent
{
	self SetAnim( level.scr_anim[ self.animname ][ scene ], 1, 0, 0 );
}

resume_anim( scene ) //self == an animated ent
{
	self SetAnim( level.scr_anim[ self.animname ][ scene ], 1, 0, 1 );
}

clear_anim() //self == animated entity
{
	self anim_stopanimscripted();
	self ClearAnim( level.scr_anim[ self.animname ][ "root" ], 0.0 );
}

//Custom version of _anim::anim_set_time to support animation arrays.
custom_set_time( scene, time, index ) //self == animated entity
{
	self SetAnimTime( self custom_get_anim( scene, index ), time );
}

//Custom version of _utility::getanim to support animation arrays.
custom_get_anim( scene, index ) //self == animated entity
{
	assertEx( IsDefined( self.animname ), "Called getanim on a guy with no animname" ); 
	assertEx( IsDefined( level.scr_anim[ self.animname ][ scene ] ), "Called getanim on an inexistent anim" );

	if( IsArray( level.scr_anim[ self.animname ][ scene ] ) )
	{
		if( IsDefined( index ) )
		{
			assertEx( IsDefined( level.scr_anim[ self.animname ][ scene ][ index ] ), "Called getanim on an inexistent anim array index" );
			return level.scr_anim[ self.animname ][ scene ][ index ];
		}
		else
		{
			total_anims = level.scr_anim[ self.animname ][ scene ].size;
			random_index = RandomInt( total_anims );
			return level.scr_anim[ self.animname ][ scene ][ random_index ];
		}
	}
	else
	{
		return level.scr_anim[ self.animname ][ scene ];
	}
}

//--------
//Door
//--------
//A prepackaged animation via script.
door_slam_open( doClockwiseRotation ) //self == a door entity
{
	if( !isDefined( doClockwiseRotation ) )
	{
		doClockwiseRotation = true;
	}

	//Test - see how a small earthquake feels.
	//Earthquake( <scale>, <duration>, <source>, <radius>, <player> )
	earthquake( 0.5, 0.5, get_players()[0].origin, 100, get_players()[0] );

	//Door flings open then rebounds slightly.
	self door_rotate( 90,  doClockwiseRotation, 1.0, 0.25, 0.0  );
	self door_rotate(  5, !doClockwiseRotation, 0.5, 0.05, 0.45 );
}

door_rotate( degreesToRotate, doClockwiseRotation, seconds, accelSec, decelSec ) //self == a door entity
{	
	deg = 80;
	if( isDefined( degreesToRotate ) )
		deg = degreesToRotate;

	dir = -1;
	if( isDefined( doClockwiseRotation ) && doClockwiseRotation == false )
		dir = 1;

	sec = 0.25;
	if( isDefined( seconds ) && seconds > 0 )
		sec = seconds;

	//TODO: figure out a good way to keep these legit.
	aSec = sec * 0.25;
	if( isDefined( accelSec ) )
		aSec = accelSec;

	dSec = sec * 0.25;
	if( isDefined( decelSec ) )
		dSec = decelSec;

	//Compute the total rotation as a function of degrees and direction.
	rot = deg * dir;

	//Rotate the door.
	self playSound( "evt_door_open_1" );
	self rotateTo( self.angles + ( 0, rot, 0 ), sec, aSec, dSec );
	self waittill( "rotatedone" );

	//If this door has dynamic pathing enabled (otherwise RTE if non-dynamic door)... 
	if( self has_spawnflag( level.SPAWNFLAG_MODEL_DYNAMIC_PATH ) )
	{	
		//Connect newly valid paths, disconnect old invalid paths.
		self connectPaths();
		self disconnectPaths();
	}

	self notify( "door_rotation_done" );
}

//****************************
//DUMMY SYSTEM
//***************************
init_dummies()
{
	level init_dummy_spawners();
	level init_dummy_spawn_triggers();
	level init_dummy_think_triggers();
}

init_dummy_spawners()
{
	//If the dummy character functions have not yet been initialized...
	if( !IsDefined( level.dummy_character_funcs ) )
	{
		level.dummy_character_funcs = [];
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA" ]        	  		  = character\gfl\character_gfl_ppsh41::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_Chopper" ]        	= character\gfl\character_gfl_type97::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_First_Desk" ]       = character\gfl\character_gfl_p90::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_Second_Desk" ]      = character\gfl\character_gfl_rfb::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_Ele_Guard2" ]       = character\gfl\character_gfl_ak74m::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_Ele_Guard1" ]       = character\gfl\character_gfl_9a91::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_Inn_Guard1" ]       = character\gfl\character_gfl_saiga12::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_CIA_Inn_Guard2" ]       = character\gfl\character_gfl_p90::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_General_1" ]						= character\c_usa_pent_general::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_General_2" ]						= character\c_usa_pent_general2::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_General_3" ]						= character\c_usa_pent_general3::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Hudson" ]     	  		  = character\c_usa_pent_Hudson::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_JFK" ] 		    	 			  = character\c_usa_pent_jfk::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_McNamara" ]   	 				= character\c_usa_pent_mcnamara::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_MilitaryPolice_Guard" ] = character\c_usa_militarypolice::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_MilitaryPolice_Moto" ]  = character\c_usa_moto_cop::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Politician" ] 	  			= character\c_usa_pent_politician::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Politician_Security" ] 	  			= character\c_usa_pent_politician2::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Secretary" ]  	  			= character\c_usa_pent_secretary::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Warroom" ] 			  			= character\c_usa_pent_warroom_worker::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Warroom_Security" ] 			  			= character\c_usa_pent_warroom_worker3::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Worker_Female" ]  			= character\c_usa_pent_female_worker::main;
		level.dummy_character_funcs[ "actor_Civilian_Pent_Worker_Female_Security" ]  			= character\c_usa_pent_female_worker5::main;
		level.dummy_character_funcs[ "actor_Civilian_Pentagon_Worker_Male" ] 	  		  = character\c_usa_pent_male_worker::main;
	}

	if( !IsDefined( level.dummy_think_funcs ) )
	{
		level.dummy_think_funcs = [];
		level.dummy_think_funcs[ "anim_single" ] 				 = ::dummy_anim_think;
		level.dummy_think_funcs[ "anim_single_aligned" ] = ::dummy_anim_think;
		level.dummy_think_funcs[ "anim_loop" ]					 = ::dummy_anim_think;
		level.dummy_think_funcs[ "anim_loop_aligned" ]	 = ::dummy_anim_think;
		level.dummy_think_funcs[ "anim_first_frame" ]		 = ::dummy_anim_first_frame_think;
		level.dummy_think_funcs[ "follow_path" ]				 = ::dummy_follow_path_think;
		level.dummy_think_funcs[ "step_aside" ]					 = ::dummy_step_aside_think;
	}

	//Collect all dummy spawners in the level.
	spawners = GetSpawnerArray();
	dummySpawners = [];
	for( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[i];

		//if( IsDefined( spawner.script_drone ) && spawner.script_drone == 1 )
		if( IsDefined( spawner.spawner_id ) && spawner.spawner_id == "dummy" )
		{
			dummySpawners[ dummySpawners.size ] = spawner;
		}
	}

	//Add spawn functions to each dummy spawner according to its KVPs.
	for( i = 0; i < dummySpawners.size; i++ )
	{
		dummySpawner = dummySpawners[i];

		if( IsDefined( dummySpawner.script_parameters ) )
		{
			//Parse the KVP into string tokens.
			funcNames = StrTok( dummySpawner.script_parameters, " " );

			//For each token...
			for( j = 0; j < funcNames.size; j++ )
			{
				//Add a spawn function to the spawner.
				dummySpawner add_spawn_function( level.dummy_think_funcs[ funcNames[j] ] );
			}

			//dummySpawner add_spawn_function( level.dummy_think_funcs[ dummySpawner.script_parameters ] );
		}
	}
}

init_dummy_spawn_triggers()
{
	//Collect all spawn triggers (this is a special case from the usual spawn_manager triggers since we are not spawning AI).
	triggers = GetEntArray( "trigger_dummy_spawner", "script_noteworthy" );

	//Run the dummy spawn manager thread on each trigger.
	array_thread( triggers, ::dummy_spawn_manager, true );
}

init_dummy_think_triggers()
{
	//Collect all of the dummy think triggers.
	triggers = GetEntArray( "trigger_dummy_think", "script_noteworthy" );

	//Run the dummy spawn think thread on each trigger.
	array_thread( triggers, ::dummy_think_manager );
}

dummy_spawn_manager( handleCleanup ) //self == trigger
{
	self endon( "death" );
	self endon( "stop_dummy_spawn_manager" );

	//Wait until someone trips this trigger.
	self waittill( "trigger", who );

	//Spawn dummies at all spawners that this trigger is targeting.
	dummies = simple_spawn_dummy( self.target );

	//If the user wants this trigger to also handle deleting the dummies it spawns...
	if( is_true( handleCleanup ) )
	{
		//Wait until that someone leaves this trigger.
		while( who IsTouching( self ) )
		{
			wait 0.05;
		}

		//If only one dummy was spawned...
		if( !IsArray( dummies ) )
		{
			//Delete the one dummy.
			dummies dummy_delete();
		}
		else
		{
			//Delete all dummies that this trigger spawned.
			dummies = array_removeundefined( dummies ); //Some dummies may have been deleted while we were waiting.
			array_thread( dummies, ::dummy_delete );
		}
	}

	//Delete this trigger!
	self Delete();
}

dummy_think_manager() //self == trigger
{
	AssertEx( IsDefined( level.dummy_think_funcs[ self.script_parameters ] ), "Trigger at " + self.origin + " has an invalid script_parameters value!" ); 

	self endon( "death" );
	self endon( "stop_dummy_think_manager" );

	//Wait until someone trips this trigger.
	self waittill( "trigger", who );

	//If the trigger had a sound on it...
	if( IsDefined( self.script_string ) )
	{
		//Note: this is mostly for triggering clientside sounds!
		level notify( self.script_string );
		ClientNotify( self.script_string );
	}

	//Collect the dummies. The trigger has a script_spawner_targets KVP that specifies the script_noteworthy KVP of the dummies it will affect.
	dummies = get_dummy_character_array( self.script_spawner_targets, "script_noteworthy" );

	//Terminate any previous animations or threads running on them.
	array_notify( dummies, "stop_dummy_think" );
	array_thread( dummies, ::anim_stopanimscripted );

	//If the dummies have a secondary animation to switch to, designate that now.
	for( i = 0; i < dummies.size; i++ )
	{
		dummy = dummies[i];

		if( IsDefined( dummy.script_string ) )
		{
			temp = dummy.script_animation;
			dummy.script_animation = dummy.script_string;
			dummy.script_string = temp;
		}
	}

	//Have all dummies play the new think function.
	array_thread( dummies, level.dummy_think_funcs[ self.script_parameters ] );
}

simple_spawn_dummy( name_or_spawners, spawn_func, param1, param2, param3, param4, param5 )
{
	//Dummies MUST have their model assembly functions (xmodelalias) specified beforehand.
	AssertEX(IsDefined(level.dummy_character_funcs), "Character function for dummy spawners not setup");

	//Prepare to collect all spawners into an array.
	spawners = [];
	if( IsString( name_or_spawners ) )
	{
		spawners = get_dummy_spawner_array( name_or_spawners, "targetname" ); //GetEntArray( name_or_spawners, "targetname" );
		AssertEX( spawners.size, "no spawners with targetname " + name_or_spawners + " found!" );
	}
	else
	{
		if (IsArray(name_or_spawners))
		{
			spawners = name_or_spawners;
		}
		else
		{
			spawners[0] = name_or_spawners;
		}
	}

	//Prepare to collect all spawned dummies into an array.
	dummy_array = [];

	//For each spawner found...
	for( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[i];

		//Wait until we are clear to spawn a dummy.
		level ok_to_spawn( 0.05 );

		//Mark this spawner as in-use.
		spawner.spawning = true;

		//Spawn a blank dummy at the spawner.

	/*	if(IsDefined(spawner.script_int) && spawner.script_int == 1)
		{
			dummy = spawner stalingradspawn();
		}
		else
		{*/

			dummy = Spawn("script_model", spawner.origin);
			dummy.angles = spawner.angles;

			//----------------
			//MODEL
			//----------------
			//Set the dummy model depending on the preexisting character aliases.
			if(IsDefined(level.dummy_character_funcs[spawner.classname]))
			{
				dummy [[level.dummy_character_funcs[spawner.classname]]]();
			}
			else
			{
				AssertEX( false, "Character function for dummy spawner type: " + spawner.classname + " not setup." );
			}
		//}

		//----------------
		//ANIMATION
		//----------------
		if( IsDefined( spawner.script_animname ) )
		{
			dummy.animname = spawner.script_animname;
		}
		else
		{
			dummy.animname = "generic";
		}

		//if(IsDefined(spawner.script_int) && spawner.script_int == 1)
		//{

		//}
		//else
		//{
			dummy assign_animtree();

		//}

			//----------------
			//PROP
			//----------------
		if( IsDefined( spawner.script_animent ) )
		{
			//Parse the KVP into an array of strings.
			propNames = StrTok( spawner.script_animent, " " );

			//For each string...
			for( j = 0; j < propNames.size; j++ )
			{
				propName = propNames[j];

				//Does the string refer to a prop already in the world (e.g., a door)?
				if( IsDefined( GetEnt( propName, "targetname" ) ) )
				{
					//Yes, so retrieve it.
					dummy.prop = GetEnt( propName, "targetname" );

					//Does the prop need an anim_link to animate?
					if( IsDefined( dummy.prop.script_parameters ) && dummy.prop.script_parameters == "init_anim_model" )
					{
						//Yes, so give it one.
						dummy.prop init_anim_model( dummy.prop.script_animname, true );
					}
					else
					{
						//No, so just an animname and animtree will suffice.
						dummy.prop assign_animtree( dummy.prop.script_animname );
					}
				}
				else
				{
					//No, we must spawn the prop.
					dummy.prop = spawn_anim_model( propName, dummy.origin, dummy.angles );
				}

				//Is the prop supposed to be linked to a tag on the dummy?	
				if( IsDefined( spawner.script_linkto ) )
				{
					dummy.prop LinkTo( dummy, spawner.script_linkto, (0,0,0), (0,0,0) );
				}
			}
		}
		//----------------
		//Key-Value Pairs
		//----------------
		//Copy over KVPs that the functions and/or scripts may need.
		dummy.targetname				= spawner.targetname;				 //Use get_dummy_character() or get_dummy_character_array() to collect just dummies, not their spawners!
		dummy.script_noteworthy = spawner.script_noteworthy; //Use get_dummy_character() or get_dummy_character_array() to collect just dummies, not their spawners!
		dummy.target						= spawner.target;						 //Either the node to play an animation aligned to, or the start of a path to walk.
		dummy.script_animation	= spawner.script_animation;	 //The primary animation the dummy will play.
		dummy.script_string			= spawner.script_string;		 //The secondary animation the dummy will play, should it be triggered.
		dummy.a 								= SpawnStruct();						 //Necessary for PlaySpecificDialogue().
		dummy.a.state						= "";												 //Necessary for avoiding self.a.state == "move" RTE in _anim.gsc.
		dummy.script_float			= clamp_value( spawner.script_float,   0 ); //Some anims may be skipped ahead so they do not appear identical to anims nearby.
		dummy.script_maxdist		= spawner.script_maxdist;    //For walking drones, this specifies their lookAhead distance.
	//	dummy.script_int = spawner.script_int;

		//----------------
		//FUNCTIONS
		//----------------
		//If this spawner has spawn functions on it...
		if( IsDefined( spawner.spawn_funcs ) && IsArray( spawner.spawn_funcs ) )
		{
			//For each spawn function on this spawner...
			for( j = 0; j < spawner.spawn_funcs.size; j++ )
			{
				func = spawner.spawn_funcs[ j ];
				single_thread( dummy, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ] );
			}
		}

		//The functions on the spawner (if any) have been addressed. Now, was an
		//additional spawn function given as a parameter?
		if( IsDefined( spawn_func ) )
		{
			single_thread( dummy, spawn_func, param1, param2, param3, param4 );
		}

		//Add the dummy to our collection
		dummy_array = add_to_array( dummy_array, dummy );

		//Mark this spawner as available for use.
		spawner.spawning = undefined;
	}

	//Return the dummy itself if only one was spawned...
	if( dummy_array.size == 1)
	{
		return dummy_array[0];
	}

	//...otherwise return the collection in an array.
	return dummy_array;
}

get_dummy_spawner_array( value, key )
{
	entities = GetEntArray( value, key );

	spawners = [];

	for( i = 0; i < entities.size; i++ )
	{
		entity = entities[i];

		if( IsDefined( entity.spawner_id ) && entity.spawner_id == "dummy" )
		{
			spawners[ spawners.size ] = entity;
		}
	}

	return spawners;
}

get_dummy_character( value, key )
{
	//Use get_dummy_character_array() to do the work for us.
	array = get_dummy_character_array( value, key );

	//Check that only one dummy was found.
	if( array.size > 1 )
	{
		assertMsg( "get_dummy_character() used for more than one dummy of type " + key + " called " + value + "." );
		return undefined;
	}
	else
	{
		return array[0];
	}
}

get_dummy_character_array( value, key )
{
	//Collect all entities with the given KVP. This probably will include spawners.
	entities = GetEntArray( value, key );

	//We need to filter out any spawners that were collected.
	dummies = [];
	for( i = 0; i < entities.size; i++ )
	{
		entity = entities[i];

		if( !entity is_spawner() )
		{
			dummies[ dummies.size ] = entity;
		}
	}

	//All dummies should have been found and placed into this array.
	return dummies;
}

dummy_delete() //self == dummy
{
	if( IsDefined( self.prop ) )
	{
		self.prop Delete();
	}

	self Delete();
}

//----------------------------
//DUMMY THINK
//----------------------------
dummy_anim_think() //self == dummy
{
	self endon( "death" );
	self endon( "stop_dummy_think" );
	self endon( "stop_dummy_anim_think" );

	//Begin by assuming the align object will be the dummy.
	alignObject = self;

	//find out the unique secretary smoking model.
	if(self.script_animation == "pool_rail_marvel")
	{
		self Attach("p_glo_cigarette01", "TAG_WEAPON_LEFT");
		wait(1);
		PlayFXOnTag(level._effect["lady_smoking_tip_light"], self, "J_Head");
		PlayFXOnTag(level._effect["lady_smoking_tip_smoke"], self, "tag_cigarglow");
	}

	if(self.script_animation == "warroom_moonwalk_guyb" || self.script_animation == "warroom_moonwalk_guya")
	{
		wait(3);
	}

	if(self.script_animation == "security_stand_loop_1" || self.script_animation == "security_stand_loop_2" || self.script_animation == "security_stand_loop_3" )
	{
		wait(1);
	}


	//But if the dummy is targeting something, align to that instead.
	if( IsDefined( self.target ) && IsDefined( GetStruct( self.target, "targetname" ) ) )
	{
		alignObject = GetStruct( self.target, "targetname" );
	}

	//If the animation is a loop array...
	if( IsArray( level.scr_anim[ self.animname ][ self.script_animation ] ) )
	{
		alignObject thread anim_loop_aligned( self, self.script_animation );

		//After 0.05, skip the animation ahead for visual interest if script_float is defined.
		self delayThread( 0.05, ::custom_set_time, self.script_animation, self.script_float );

		if( IsDefined( self.prop ) && IsDefined( level.scr_anim[ self.prop.animname ] ) && IsDefined( level.scr_anim[ self.prop.animname ][ self.script_animation ] ) )
		{ 
			alignObject thread anim_loop_aligned( self.prop get_anim_ent(), self.script_animation );

			//After 0.05, skip the animation ahead for visual interest if script_float is defined.
			self.prop get_anim_ent() delayThread( 0.05, ::custom_set_time, self.script_animation, self.script_float );
		}
	}
	//Else the animation is a single...
	else
	{
		alignObject thread anim_single_aligned( self, self.script_animation );

		//After 0.05, skip the animation ahead for visual interest if script_float is defined.
		self delayThread( 0.05, ::custom_set_time, self.script_animation, self.script_float );

		if( IsDefined( self.prop ) && IsDefined( level.scr_anim[ self.prop.animname ] ) && IsDefined( level.scr_anim[ self.prop.animname ][ self.script_animation ] ) )
		{ 
			alignObject thread anim_single_aligned( self.prop get_anim_ent(), self.script_animation );

			//After 0.05, skip the animation ahead for visual interest if script_float is defined.
			self.prop get_anim_ent() delayThread( 0.05, ::custom_set_time, self.script_animation, self.script_float );
		}
	}



}

dummy_anim_first_frame_think() //self == dummy
{
	self endon( "death" );
	self endon( "stop_dummy_think" );
	self endon( "stop_dummy_anim_first_frame_think" );

	//Begin by assuming the align object will be the dummy.
	alignObject = self;

	//But if the dummy is targeting something, align to that instead.
	if( IsDefined( self.target ) && IsDefined( GetStruct( self.target, "targetname" ) ) )
	{
		alignObject = GetStruct( self.target, "targetname" );
	}

	alignObject thread anim_first_frame( self, self.script_animation );

	if( IsDefined( self.prop ) && IsDefined( level.scr_anim[ self.prop.animname ] ) && IsDefined( level.scr_anim[ self.prop.animname ][ self.script_animation ] ) )
	{
		//self.prop init_anim_model();

		alignObject thread anim_first_frame( self.prop get_anim_ent(), self.script_animation );
	}


}

dummy_follow_path_think()	//self == dummy
{
	self endon( "death" );
	self endon( "stop_dummy_think" );
	self endon( "stop_dummy_follow_path_think" );

	self follow_path_drone( GetStruct( self.target, "targetname" ) );
}

dummy_step_aside_think() //self == dummy
{
	self endon( "death" );
	self endon( "stop_dummy_think" );
	self endon( "stop_dummy_step_aside_think" );

	if( !isDefined( self.radius ) || self.radius < 0 )
	{
		self.radius = 250;
	}

	//Wait for Mason to enter this drone's radius.
	while( distanceSquared( get_players()[0].origin, self.origin ) >= self.radius * self.radius )
	{
		wait 0.05;
	}

	//End other drone functions. Their anims will be overriden with anim_single().
	self notify( "stop_dummy_follow_path_think" );
	self notify( "stop_follow_path" );
	self notify( "stop_drone_walk_anim_loop" );	

	//Set goal stuff to override walking AI.
	if( isAI( self ) )
	{
		self set_goal_pos( self.origin );
	}

	//Calculate this drone's direction and the direction toward Mason.
	dirOfDrone = anglesToForward( self.angles );
	dirToMason = VectorNormalize( get_players()[0].origin - self.origin );

	//Calculate the angle this drone would need to turn to face the player.
	//Ranges from -180 to 180, where negative means left, and positive right.
	angle = angle_between_vectors( dirToMason, dirOfDrone );

	//Define the "zones" that delineate which animation to play.
	endOfAhead   = 60;  //degrees
	endOfSide		 = 120; //degrees
	endOfBehind  = 180; //degrees

	//angle == 0 or == 180 means straight ahead or behind, though we just use 
	//gawk_front_left and gawk_behind_right for these, below.

	anime = undefined;
	if( -1 * endOfAhead <= angle && angle <= 0 )
	{
		//Left, ahead.
		anime = "stepaside_forward_left";
	}
	else if( -1 * endOfSide <= angle && angle < -1 * endOfAhead )
	{
		//Left, side.
		anime = "stepaside_side_left";
	}
	else if( -1 * endOfBehind <= angle && angle < -1 * endOfSide )
	{
		//Left, behind.
		anime = "stepaside_behind_left";
	}
	else if( 0 < angle && angle <= endOfAhead )
	{
		//Right, ahead.
		anime = "stepaside_forward_right";
	}
	else if( endOfAhead < angle && angle <= endOfSide )
	{
		//Right, side.
		anime = "stepaside_side_right";
	}
	else //endOfSide < angle && angle <= endOfBehind
	{
		//Right, behind.
		anime = "stepaside_behind_right";
	}

	//Terminate any other drone think functions.
	self anim_single( self, anime, "generic" );
}

//******************
//Elevator
//******************
elevator_system_init()
{
	//If the elevator has not yet been initialized...
	if( !isDefined( level.elevator ) )
	{
		level.elevator = spawnStruct();

		//Constants!
		level.elevator.DOOR_TRAVEL_DIST  = 36.0; //50.0; //inches
		level.elevator.DOOR_TRAVEL_TIME	 = 3.00; //seconds
		level.elevator.DOOR_TRAVEL_ACCEL = level.elevator.DOOR_TRAVEL_TIME / 3; //seconds
		level.elevator.DOOR_TRAVEL_DECEL = level.elevator.DOOR_TRAVEL_TIME / 3;	//seconds
		level.elevator.DOOR_TRAVEL_DELAY = 0.25; //seconds

		level.elevator.CAB_TRAVEL_TIME  = 10; //seconds
		level.elevator.CAB_TRAVEL_ACCEL = level.elevator.CAB_TRAVEL_TIME / 5; //seconds
		level.elevator.CAB_TRAVEL_DECEL = level.elevator.CAB_TRAVEL_TIME / 5; //seconds

		//Get the cab.	
		level.elevator.cab = getEnt( "bmodel_elevator_cab", "targetname" );

		//Get the interior doors.
		level.elevator.cab_door_l = getEnt( "smodel_elevator_cab_door_left", "targetname" );
		level.elevator.cab_door_r = getEnt( "smodel_elevator_cab_door_right", "targetname" );

		//Get the floor struct. It informs the doors how to slide open/close plus targets the exterior doors for each particular floor.
		level.elevator.floor_struct = getStruct( "struct_pool_elevator_align", "targetname" );

		//Light the cabin so the player can see.
		lightStructs = GetStructArray( "struct_pool_elevator_light", "script_noteworthy" );
		level.elevator.interiorLights = [];
		for( i = 0; i < lightStructs.size; i++ )
		{
			//Get a struct. It will tell us where to place a light.
			struct = lightStructs[i];

			//Create an entity that we can link to the cab, and play the light FX on the entity.
			light = Spawn( "script_model", struct.origin );
			light SetModel( "tag_origin" );
			PlayFXOnTag( level._effect[ "elevator_interior_light" ], light, "tag_origin" );
			light LinkTo( level.elevator.cab );

			//For cleanup purposes, store each light.
			level.elevator.interiorLights = array_add( level.elevator.interiorLights, light );
		} 	

		//Link the script_model components of the elevator to the cab, since they cannot be grouped together with the script_brushmodel cab.
		models = getEntArray( "smodel_elevator_component", "targetname" );
		array_thread( models, ::link_to, level.elevator.cab );
	}
}

elevator_open_doors_top( guy ) //self == whatever the anim was played relative to; guy is unused, passed in by addnotetrack_customfunction
{
	//Swap the exterior floor indicator model with one with "down" and "SB" lit.
	indicator = GetEnt( "smodel_pool_indicator_large", "script_noteworthy" );
	indicator SetModel( "p_pent_elevator_indicator_lit_large" );

	level ClientNotify( "open_door" );
	level elevator_open_doors();
}

elevator_close_doors_top( guy ) //self == whatever the anim was played relative to; guy is unused, passed in by addnotetrack_customfunction
{
	level ClientNotify( "close_door" );
	level elevator_close_doors();
}

elevator_open_doors()
{
	if( !isDefined( level.elevator ) )
	{
		printLn( "elevator_open_doors() - level.elevator is undefined!" );
		return;
	}

	//Retrieve the exterior doors of the current floor.
	ext_doors = GetEntArray( level.elevator.floor_struct.target, "targetname" );
	ext_door_l = undefined;
	ext_door_r = undefined;
	for( i = 0; i < ext_doors.size; i++ )
	{
		door = ext_doors[i];
		if( door.script_noteworthy == "left" )
		{
			ext_door_l = door;
		}
		else if( door.script_noteworthy == "right" )
		{
			ext_door_r = door;
		}
	}

	right_vec = AnglesToRight( level.elevator.floor_struct.angles );
	offset = vector_scale( right_vec, level.elevator.DOOR_TRAVEL_DIST );

	//Calculate the final position for each door.
	pos_int_l = level.elevator.cab_door_l.origin - offset;
	pos_ext_l = ext_door_l.origin - offset;
	pos_int_r = level.elevator.cab_door_r.origin + offset;
	pos_ext_r = ext_door_r.origin + offset;

	//Unlink (if necessary) the doors so they can move.
	level.elevator.cab_door_l unlink();
	level.elevator.cab_door_r unlink();
	ext_door_l unlink();
	ext_door_r unlink();

	//Move the doors to their open positions (with a brief pause between the pairs for visual interest).
	ext_door_l MoveTo( pos_ext_l, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );
	ext_door_r MoveTo( pos_ext_r, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );
	wait level.elevator.DOOR_TRAVEL_DELAY;
	level.elevator.cab_door_l moveTo( pos_int_l, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );
	level.elevator.cab_door_r moveTo( pos_int_r, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );

	//Wait for all of them to open completely.	
	waittill_multiple_ents( level.elevator.cab_door_l, "movedone",
		level.elevator.cab_door_r, "movedone",
		ext_door_l, "movedone", 
		ext_door_r, "movedone" );

	//All done.
	level notify( "elevator_doors_open" );
}

elevator_close_doors()
{
	if( !isDefined( level.elevator ) )
	{
		printLn( "elevator_close_doors() - level.elevator is undefined!" );
		return;
	}

	//Retrieve the exterior doors of the current floor.
	ext_doors = GetEntArray( level.elevator.floor_struct.target, "targetname" );
	ext_door_l = undefined;
	ext_door_r = undefined;
	for( i = 0; i < ext_doors.size; i++ )
	{
		door = ext_doors[i];
		if( door.script_noteworthy == "left" )
		{
			ext_door_l = door;
		}
		else if( door.script_noteworthy == "right" )
		{
			ext_door_r = door;
		}
	}

	right_vec = AnglesToRight( level.elevator.floor_struct.angles );
	offset = vector_scale( right_vec, level.elevator.DOOR_TRAVEL_DIST );

	//Calculate the final position for each door.
	pos_int_l = level.elevator.cab_door_l.origin + offset;
	pos_ext_l = ext_door_l.origin + offset;
	pos_int_r = level.elevator.cab_door_r.origin - offset;
	pos_ext_r = ext_door_r.origin - offset;

	//Unlink (if necessary) the doors so they can move.
	level.elevator.cab_door_l unlink();
	level.elevator.cab_door_r unlink();
	ext_door_l unlink();
	ext_door_r unlink();

	//Move the doors to their open positions (with a brief pause between the pairs for visual interest).
	ext_door_l moveTo( pos_ext_l, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );
	ext_door_r moveTo( pos_ext_r, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );
	wait level.elevator.DOOR_TRAVEL_DELAY;
	level.elevator.cab_door_l moveTo( pos_int_l, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );
	level.elevator.cab_door_r moveTo( pos_int_r, level.elevator.DOOR_TRAVEL_TIME, level.elevator.DOOR_TRAVEL_ACCEL, level.elevator.DOOR_TRAVEL_DECEL );

	//Wait for all of them to open completely.	
	waittill_multiple_ents( level.elevator.cab_door_l, "movedone",
		level.elevator.cab_door_r, "movedone",
		ext_door_l, "movedone", 
		ext_door_r, "movedone" );

	//All done.
	level notify( "elevator_doors_closed" );
}

elevator_move( floorStruct, travelTime )
{
	if( !isDefined( level.elevator ) )
	{
		printLn( "elevator_move() - level.elevator is undefined!" );
		return;
	}
	if( !isDefined( floorStruct ) )
	{
		printLn( "elevator_move() - floorStruct is undefined!" );
		return;
	}

	time = level.elevator.CAB_TRAVEL_TIME;
	accel = level.elevator.CAB_TRAVEL_ACCEL;
	decel = level.elevator.CAB_TRAVEL_DECEL;
	if( isDefined( travelTime ) && travelTime > 0 )
	{
		time  = travelTime;
		accel = time / 10;
		decel = time / 10;
	}

	//Link the doors to the cab (whether they are closed or not).
	level.elevator.cab_door_l linkTo( level.elevator.cab );
	level.elevator.cab_door_r linkTo( level.elevator.cab );

	//Send the cab the difference between the z-value of the current floor struct and the given one.
	zDisplacement = floorStruct.origin[ 2 ] - level.elevator.floor_struct.origin[ 2 ];
	level.elevator.cab MoveZ( zDisplacement, time, accel, decel );

	//TEST TEST TEST
	//level.hudson MoveZ( zDisplacement, time, accel, decel );
	//level.mcnamara MoveZ( zDisplacement, time, accel, decel );
	//get_players()[0].playerbody MoveZ( zDisplacement, time, accel, decel );

	//Wait for it to arrive.
	level.elevator.cab waittill( "movedone" );

	//Update the align struct.
	level.elevator.floor_struct = floorStruct;

	level notify( "elevator_arrived" );
}

//****************************
//FAST FORWARD
//****************************
//New, more generalized fast-forward function.
fast_forward_begin()
{
	currentTimescale = GetTimescale( "timescale" );
	targetTimescale	 = 4.00;
	lerpTime				 = 0.75;

	level thread timescale_tween( currentTimescale, targetTimescale, lerpTime );
}

//New, more generalized fast-forward function.
fast_forward_end()
{
	currentTimescale = GetTimescale( "timescale" );
	targetTimescale	 = 1.00;
	lerpTime				 = 2.00;

	level thread timescale_tween( currentTimescale, targetTimescale, lerpTime );
}
//****************************
//HUD UTILITY
//****************************
hud_utility_init()
{
	//Create a fullscreen element that we can use for fades and flashbacks.
	level.hud_utility 					 = NewHudElem();
	level.hud_utility.x 				 = 0;
	level.hud_utility.y 			   = 0;
	level.hud_utility.horzAlign  = "fullscreen";
	level.hud_utility.vertAlign  = "fullscreen";
	level.hud_utility.foreground = false; //Arcade Mode compatible
	level.hud_utility.sort			 = 3;
	//NOTE: billboard uses layers 0, 1, and 2!

	//Set the default shader.
	level.hud_utility setShader( "black", 640, 480 );

	//Hide the element until needed.
	level.hud_utility.alpha = 0;
}


hud_utility_show( shader, fadeSeconds )
{
	//If the hud utility does not yet exist...
	if( !isDefined( level.hud_utility ) )
	{
		//Create one now.
		hud_utility_init();
	}

	//If a shader was given, switch to it.
	if( IsDefined( shader ) )
	{
		level.hud_utility SetShader( shader, 640, 480 );
	}

	//If no seconds were specified or are not positive...
	if( !isDefined( fadeSeconds ) || fadeSeconds <= 0 )
	{
		level.hud_utility.alpha = 1;
	}
	else
	{
		//Fade into the color over the specified amount of time.
		level.hud_utility FadeOverTime( fadeSeconds );
		level.hud_utility.alpha = 1;
		wait( fadeSeconds );
	}

	//All done! Notify whoever called this.
	self notify( "fade_complete" );
}

hud_utility_hide( shader, fadeSeconds )
{
	//If the hud utility does not yet exist...
	if( !isDefined( level.hud_utility ) )
	{
		//Create one now.
		hud_utility_init();
	}

	//If a shader was given, switch to it.
	if( isDefined( fadeSeconds ) )
	{
		level.hud_utility setShader( shader, 640, 480 );
	}

	//If no seconds were specified or are not positive...
	if( !isDefined( fadeSeconds ) || fadeSeconds <= 0 )
	{
		level.hud_utility.alpha = 0;
	}
	else
	{
		//Fade into the color over the specified amount of time.
		level.hud_utility fadeOverTime( fadeSeconds );
		level.hud_utility.alpha = 0;
		wait( fadeSeconds );
	}

	//All done! Notify whoever called this.
	self notify( "fade_complete" );
}

//****************************
//Look Trigger
//****************************
look_trigger_think( triggerFunction ) //self == a trigger_lookat
{
	if( !isDefined( triggerFunction ) )
	{
		printLn( "Error: look_trigger_think() - triggerFunction is undefined!" );
		return;
	}

	self endon( "death" );
	self endon( "stop_look_trigger_think" );

	STARE_THRESHOLD    = 1000; //ms, default time required to stare at a trigger before it activates.
	STARE_GRACE_PERIOD =  100; //ms, default time allowed between trigger notifcations before the stare resets.
	TRIGGER_RADIUS_DEFAULT = 400; //in, default for triggers that have not specified a radius.

	stareTotal = 0;
	prevNotify = undefined;

	while( true )
	{
		self waittill( "trigger", who );

		break;

		/*
		if( !isDefined( prevNotify ) )
		{
		prevNotify = getTime();
		}

		nowNotify = getTime();
		deltaTime = nowNotify - prevNotify;

		//If too much time passed since the last notification...
		if( deltaTime > STARE_GRACE_PERIOD )
		{
		//The player probably stopped looking at the trigger at some point. Reset the stare.
		stareTotal = 0;
		prevNotify = undefined;
		}
		//Else the notify occurred soon after the previous notification...
		else
		{
		//The player has probably been looking at the trigger continuously. Increment the stare.
		stareTotal += deltaTime;
		prevNotify = getTime();
		}

		//If the player has been looking at the trigger continuously for long enough...
		if( stareTotal >= STARE_THRESHOLD ) //msec
		{
		//Success!
		break;
		}
		//Else relinquish thread priority, loop to top.
		wait 0.05;
		*/
	}

	//Deactivate this trigger.
	self trigger_off();

	//Call the function.
	self [[triggerFunction]]();

	//Delete the trigger (self!).
	self Delete();
}

//****************************
//Pathing
//****************************
follow_path_drone( startStruct ) //self == drone
{
	//Terminate any other follow_path threads already on this guy.
	self notify( "stop_follow_path" );

	//Setup termination cases.
	self endon( "death" );
	self endon( "stop_follow_path" );

	//Use the startStruct as the drone's first goalStruct.
	goalStruct = startStruct;

	//To prevent skating, calculate the run speed needed for this specific animation.
	self drone_set_run_cycle( level.scr_anim[ self.animname ][ self.script_animation ] );

	//Some structs in the path may specify an animation to play when the drone
	//arrives. If an animation is specified, the walk animation/thread is
	//terminated. If there is more path afterward, though, this boolean will 
	//signify that the walk animation/thread needs to be restarted.
	isWalking = false;

	//These variables enable drones to cut and round corners smoothly (like a spline) rather than abruptly rotate when arriving at a goalStruct.
	goalForgiveness 	=  10.00; //GoalStruct is considered reached if currentPointOnPath is within this distance to goalStruct.
	updateTime 				=   0.25; //To reduce script stress, we only update the drone's target this often (in seconds).
	lookAheadDist 		= 150.00; //The drone will "look ahead" of its currentPointOnPath by this distance, allowing it to anticipate and round corners.
	prevStructOrigin 	= self.origin; //We need to remember where the previous struct in the path was to form a line from it to goalStruct. We remember only the origin so we need not spawn a dummy struct for the first leg of the path.
	distancePerUpdate = self.drone_run_cycle_speed * updateTime; //Calculate the distance the drone, given the walk animation it has, can travel over one update period.

	//The drone may have a specialized lookAheadDist. Use it if it is defined.
	if( IsDefined( self.script_maxdist ) && self.script_maxdist > 0 )
	{
		lookAheadDist = self.script_maxdist;
	}

	//Calculate the drone's progress along the path.
	currentPointOnPath = PointOnSegmentNearestToPoint( prevStructOrigin, goalStruct.origin, self.origin );

	//While there is still another goalStruct in the path...
	while( IsDefined( goalStruct ) )
	{
		//----------------------------
		//PART1: WALK TO GOAL
		//----------------------------

		//If the drone is not already walking...
		if( !isWalking )
		{
			//Have this drone play its walk anim.
			self thread drone_walk_anim_loop();
			isWalking = true;
		}

		//While the drone has not yet reached the goalStruct...
		while( Distance2D( currentPointOnPath, goalStruct.origin ) > goalForgiveness )
		{
			//We need to calculate where the drone should head. Our first step is to find where that is along
			//the segments formed between the prevStruct, the goalStruct, and possibly the struct after that.
			targetPointOnPath = undefined;

			//Determine if lookAheadDist ahead of currentPointOnPath would overshoot goalStruct.
			overshootDist = lookAheadDist - Distance2D( currentPointOnPath, goalStruct.origin );

			//If there is no portion that overshoots the goalStruct...
			if( overshootDist <= 0 )
			{
				//Simply spot targetPointOnPath a lookAheadDist ahead of currentPointOnPath.
				directionOnPath = VectorNormalize( goalStruct.origin - currentPointOnPath );
				targetPointOnPath = currentPointOnPath + vector_scale( directionOnPath, lookAheadDist );
			}
			//Else some portion overshoots the goalStruct...
			else
			{
				//Spot targetPointOnPath an overshootDist ahead of goalStruct, toward the struct after goalStruct (if any; if not, place at goalStruct).
				directionToNext = get_direction_to_struct_after( goalStruct );
				targetPointOnPath = goalStruct.origin + vector_scale( directionToNext, overshootDist );
			}

			//We now have a target point that is somewhere on the path. Where is the point the drone will reach if it headed toward it over one update?
			targetPoint = self.origin + vector_scale( VectorNormalize( targetPointOnPath - self.origin ), distancePerUpdate ); 

			//Move and rotate the drone toward our targetPoint.
			self MoveTo( targetPoint, updateTime, 0.0, 0.0 );
			self RotateTo( VectorToAngles( VectorNormalize( targetPoint - self.origin ) ), updateTime, 0.0, 0.0 );
			//self waittill( "movedone" );
			wait( updateTime );

			//Update our currentPointOnPath to reflect our progress.
			currentPointOnPath = PointOnSegmentNearestToPoint( prevStructOrigin, goalStruct.origin, self.origin );

			//DEV
			//duration = 20 * updateTime;
			//Circle( currentPointOnPath, lookAheadDist, (0,0,0), false, true, Int( duration ) );
			//Circle( currentPointOnPath, 					 10, (0,0,0), false, true, Int( duration ) );
			//Circle(  targetPointOnPath,  					 10, (0,0,1), false, true, Int( duration ) );
			//Circle( 			 targetPoint, 					 10, (0,1,0), false, true, Int( duration ) );
		}

		//----------------------------
		//PART2: GOAL REACHED
		//----------------------------

		//The drone reached the goalStruct; notify them both of each other.
		self notify( goalStruct.targetname );
		goalStruct notify( "trigger", self );

		//If the goalStruct specifies an animation...
		if( isDefined( goalStruct.script_animation ) )
		{
			//Terminate the walk loop and clear the isWalking boolean.
			self notify( "stop_drone_walk_anim_loop" );
			self anim_stopanimscripted( 0.2 );
			isWalking = false;

			//Play the goalStruct's animation.
			goalStruct anim_single_aligned( self, goalStruct.script_animation );

			//Pause to let the animation fully complete, otherwise MoveTo() to
			//the next struct in the path will fail (the call will be ignored if
			//anim_single_aligned() is still running).
			wait 0.05;

			//Clear the anim from the tree, otherwise it will muddy the walk animation that follows.
			self ClearAnim( level.scr_anim[ self.animname ][ goalStruct.script_animation ], 0 );
		}

		//----------------------------
		//PART3: FIND NEXT GOAL
		//----------------------------

		//If that was the last struct in the path...
		if( !IsDefined( goalStruct.target ) )
		{
			//This drone has completed the path; terminate the walk loop then break.
			self notify( "stop_drone_walk_anim_loop" );
			self anim_stopanimscripted();
			break;
		}
		//Else there are more structs ahead...
		else
		{
			//Update our previous struct.
			prevStructOrigin = goalStruct.origin;

			//There may be more structs ahead in the path (the target could be
			//bogus, though). Attempt to update the goalStruct to the next.
			goalStruct = GetStruct( goalStruct.target, "targetname" );
		}

		//Loop to top.
	}

	//This drone has reached the end of the path.
	self notify( "path_end_reached" );	
}

//Helper for follow_path_drone().
drone_set_run_cycle( runAnim ) //self == drone
{
	run_cycle_delta		= GetMoveDelta( runAnim, 0, 1 );
	run_cycle_dist		= Length( run_cycle_delta );
	run_cycle_length	= GetAnimLength( runAnim );
	run_cycle_speed		= run_cycle_dist / run_cycle_length;

	self.drone_run_cycle 			 = runAnim;
	self.drone_run_cycle_speed = run_cycle_speed;
}

//Helper for follow_path_drone().
drone_walk_anim_loop() //self == drone
{
	self endon( "death" );
	self endon( "stop_drone_think" );
	self endon( "stop_drone_walk_anim_loop" );

	while( true )
	{
		//NOTE: anim_single() caused problems, including briefly popping back to the
		//start origin when the animation completes, and preventing angles to be 
		//adjusted mid-animation. SetFlaggedAnimKnobRestart() avoids both!
		self SetFlaggedAnimKnobRestart( "drone_run_anim", level.scr_anim[ self.animname ][ self.script_animation ], 1.0, 0.2, 1.0 );
		self waittillmatch( "drone_run_anim", "end" );
	}
}

get_direction_to_struct_after( struct )
{
	direction = (0,0,0);

	if( IsDefined( struct.target ) && IsDefined( GetStruct( struct.target, "targetname" ) ) )
	{
		nextStruct = GetStruct( struct.target, "targetname" );
		direction = VectorNormalize( nextStruct.origin - struct.origin );
	}
	return direction;
}

//****************************
//Player
//****************************
//Wrapper function that includes default parameters for the Pentagon.
player_linkto_delta( entity, tag, turnStrength, rightArc, leftArc, topArc, bottomArc, useTagAngles ) //self == player
{
	AssertEx( IsDefined( entity ), "player_linkto_delta() - linkToEntity is undefined!" );

	//Define the default values for linking.
	defaultTurnStrength =  1.00; //factor
	defaultRightArc 		= 35.00; //degrees
	defaultLeftArc 		  = 35.00; //degrees
	defaultTopArc			  = 15.00; //degrees
	defaultBottomArc		= 15.00; //degrees
	defaultUseTagAngles =  true;

	//Use the default values if some parameters are missing.
	if( !IsDefined( turnStrength ) )
	{
		turnStrength = defaultTurnStrength;
	}
	if( !IsDefined( rightArc ) )
	{
		rightArc = defaultRightArc;
	}
	if( !IsDefined( leftArc ) )
	{
		leftArc = defaultLeftArc;
	}
	if( !IsDefined( topArc ) )
	{
		topArc = defaultTopArc;
	}
	if( !IsDefined( bottomArc ) )
	{
		bottomArc = defaultBottomArc;
	}
	if( !IsDefined( useTagAngles ) )
	{
		useTagAngles = defaultUseTagAngles;
	}

	//self PlayerLinkToAbsolute(entity, tag);
	self PlayerLinkToDelta( entity, tag, turnStrength, rightArc, leftArc, topArc, bottomArc, useTagAngles );
}  

player_face_forward( timeToEnforce ) //self == player LinkedTo to the playerbody's tag_player bone
{
	//Allow the currently playing animation to "settle" so GetTagAngles is correct.
	wait 0.05;

	//Freeze the player's controls and turn the camera forward.
	self FreezeControls( true );
	//self SetPlayerAngles( self.playerBody GetTagAngles( "tag_player" ) );
	self SetPlayerAngles( self.playerBody_firstPerson GetTagAngles( "tag_player" ) );

	//If we need to keep the player looking forward for awhile...
	if( IsDefined( timeToEnforce ) && timeToEnforce > 0.05 )
	{
		//Refrain from unfreezing the controls until the time passes.
		wait timeToEnforce;
	}

	//Allow the player to rotate the camera again.
	self FreezeControls( false ); 
}

player_show_first_person() //self == player
{
	self.playerbody_firstperson Show();
	self.playerbody_thirdperson Hide();
}

player_show_third_person() //self == player
{
	self.playerbody_thirdperson Show();
	self.playerbody_firstperson Hide();
}

//****************************
//Sound
//****************************
sound_dummy(soundalias)
{
	sound_dummy_2 = spawn( "script_origin" , (0,0,0));
	sound_dummy_2 playsound( soundalias , "sound_done");
	sound_dummy_2 waittill ("sound_done");
	sound_dummy_2 delete();
}

//****************************
//Vehicles
//****************************
vehicle_traffic_think( vehicleToAvoid, radius ) //self == vehicle
{
	self endon( "death" );
	self endon( "stop_vehicle_traffic_think" );

	//Attach lights to this vehicle.
	self maps\pentagon_fx::vehicle_lights_on();

	//Drive!
	self thread go_path( GetVehicleNode( self.target, "targetname" ) );

	//If this vehicle should pull over when vehicleToAvoid approaches...
	if( IsDefined( vehicleToAvoid ) )
	{
		//Eyeballed radius for when it would be a good time to pull over.
		if( !IsDefined( radius ) || radius <= 0 )
		{
			radius = 1000;
		}

		//Wait for the vehicleToAvoid to draw near.
		while( DistanceSquared( self.origin, vehicleToAvoid.origin ) > radius * radius )
		{
			//Circle( self.origin, radius, (1,1,1), false, true, 2 );
			wait 0.05;
		}

		//Pull over!
		self vehicle_pullover_think( vehicleToAvoid, radius );
	}
}

vehicle_pullover_think( vehicleToAvoid, radius ) //self == a vehicle running a go_path() thread.
{
	//Begin searching from the node the vehicle is currently "at".
	node = self.currentNode; //Set by go_path()-->vehicle_paths().

	//While there are still nodes in the path to inspect...
	while( IsDefined( node ) )
	{
		//Does this node have a target2, and is that target a vehicle node?
		if( IsDefined( node.target2 ) && IsDefined( GetVehicleNode( node.target2, "targetname" ) ) )
		{
			//TEST
			level.pulloverCount++;

			//Yes, so we have found some switchnodes.
			self set_switch_node( node, GetVehicleNode( node.target2, "targetname" ) );
			break; 
		}
		else
		{
			if( IsDefined( node.target ) )
			{
				//No, move on to the next node in the path.
				node = GetVehicleNode( node.target, "targetname" );
			}
			else
			{
				//This is the end of the path!
				break;
			}
		}
	}
	//TODO: Assert that a switchnode was found?

	if( IsDefined( vehicleToAvoid ) )
	{
		//Wait for this vehicle to stop.
		self waittill( "vehicle_flag_arrived", flagString );

		//Keep the radius value legit.
		if( !IsDefined( radius ) || radius <= 0 )
		{
			radius = 1000;
		}

		//Wait until the vehicle to avoid leaves.
		while( DistanceSquared( self.origin, vehicleToAvoid.origin ) < radius * radius )
		{
			//Circle( self.origin, radius, (0,0,0), false, true, 2 );
			wait 0.05;
		}

		//TEST - Make each successive car wait a little longer before it resumes driving,
		//otherwise all of the cars resume into the same spot!
		wait( (level.pulloverCount - 1) * level.pulloverWait );

		//Resume driving!
		self flag_set( flagString );
	}
}

pause_all_traffic()
{
	level.northboundVehicles = array_removeundefined( level.northboundVehicles );
	level.southboundVehicles = array_removeundefined( level.southboundVehicles );

	//Stop the northbound vehicles.
	for( i = 0; i < level.northboundVehicles.size; i++ )
	{
		vehicle = level.northboundVehicles[i];
		vehicle.oldSpeed = vehicle GetSpeedMPH();
		vehicle.goalSpeed = vehicle GetGoalSpeedMPH();
		vehicle SetSpeedImmediate( 0, 1000, 1000 );

		/*
		//Test
		vehicle.oldNode = vehicle.currentNode;
		vehicle SetSpeedImmediate( 1, 1, 1 );
		vehicle vehicle_pathdetach();
		vehicle SetSpeedImmediate( 0, 1000, 1000 );
		*/
	}

	//Stop the southbound vehicles.
	for( j = 0; j < level.southboundVehicles.size; j++ )
	{
		vehicle = level.southboundVehicles[j];
		vehicle.oldSpeed = vehicle GetSpeedMPH();
		vehicle.goalSpeed = vehicle GetGoalSpeedMPH();
		vehicle SetSpeedImmediate( 0, 1000, 1000 );

		/*
		//Test
		vehicle.oldNode = vehicle.currentNode;
		vehicle SetSpeedImmediate( 1, 1, 1 );
		vehicle vehicle_pathdetach();
		vehicle SetSpeedImmediate( 0, 1000, 1000 );
		*/
	}

	//Stop the motorcade.
	for( k = 0; k < level.realMotorcade.size; k++ )
	{
		vehicle = level.realMotorcade[k];
		vehicle.oldSpeed = vehicle GetSpeedMPH();
		vehicle.goalSpeed = vehicle GetGoalSpeedMPH();
		vehicle SetSpeedImmediate( 0, 1000, 1000 );

		/*
		//Test
		vehicle.oldNode = vehicle.currentNode;
		vehicle SetSpeedImmediate( 1, 1, 1 );
		vehicle vehicle_pathdetach();
		vehicle SetSpeedImmediate( 0, 1000, 1000 );
		*/
	}
}

resume_all_traffic()
{
	//Somehow some cars died?
	level.northboundVehicles = array_removeundefined( level.northboundVehicles );
	level.southboundVehicles = array_removeundefined( level.southboundVehicles );

	/*//TEST!
	//Resume the northbound vehicles.
	for( i = 0; i < level.northboundVehicles.size; i++ )
	{
	vehicle = level.northboundVehicles[i];
	vehicle SetSpeedImmediate( vehicle.oldSpeed, 1000, 1000 );

	//Test
	vehicle thread go_path( vehicle.oldNode );
	}

	//Resume the southbound vehicles.
	for( j = 0; j < level.southboundVehicles.size; j++ )
	{
	vehicle = level.southboundVehicles[j];
	vehicle SetSpeedImmediate( vehicle.oldSpeed, 1000, 1000 );

	vehicle thread go_path( vehicle.oldNode );
	}

	//Resume the motorcade.
	for( k = 0; k < level.realMotorcade.size; k++ )
	{
	vehicle = level.realMotorcade[k];
	vehicle SetSpeedImmediate( vehicle.oldSpeed, 1000, 1000 );

	vehicle thread go_path( vehicle.oldNode );
	}
	*/

	//KEEP IT SIMPLE FOR NOW.
	//Resume the northbound vehicles.
	for( i = 0; i < level.northboundVehicles.size; i++ )
	{
		vehicle = level.northboundVehicles[i];
		vehicle SetSpeedImmediate( vehicle.oldSpeed, 1000, 1000 );
	}

	//Resume the southbound vehicles.
	for( j = 0; j < level.southboundVehicles.size; j++ )
	{
		vehicle = level.southboundVehicles[j];
		vehicle SetSpeedImmediate( vehicle.oldSpeed, 1000, 1000 );
	}

	//Resume the motorcade.
	for( k = 0; k < level.realMotorcade.size; k++ )
	{
		vehicle = level.realMotorcade[k];
		vehicle SetSpeedImmediate( vehicle.oldSpeed, 1000, 1000 );
	}
}

set_speed_immediate( speed, accel, decel ) //self == a vehicle
{
	self SetSpeedImmediate( speed, accel, decel );
}

fade_to_black()
{
	fadeToBlack = NewHudElem(); 
	fadeToBlack.x = 0; 
	fadeToBlack.y = 0;
	fadeToBlack.alpha = 1;
	fadeToBlack.horzAlign = "fullscreen"; 
	fadeToBlack.vertAlign = "fullscreen"; 
	fadeToBlack.foreground = false; 
	fadeToBlack.sort = 50; 
	fadeToBlack SetShader( "black", 640, 480 );        
	fadeToBlack FadeOverTime( 0.05 );
	fadeToBlack.alpha = 1;
	wait(0.1);
	fadetoblack destroy();

}


lights_police_car()
{
	playfxontag(level._effect["headlight_cheap"], self, "tag_light_left_front");
	playfxontag(level._effect["headlight_cheap"], self, "tag_light_right_front");
	playfxontag(level._effect["taillight_cheap"], self, "tag_light_left_back");
	playfxontag(level._effect["taillight_cheap"], self, "tag_light_right_back");
}


lights_limo()
{
	playfxontag(level._effect["headlight_limo"], self, "tag_headlight_left");
	playfxontag(level._effect["headlight_limo"], self, "tag_headlight_right");
	playfxontag(level._effect["taillight_l_limo"], self, "tag_brakelight_left");
	playfxontag(level._effect["taillight_r_limo"], self, "tag_brakelight_right");
}


lights_motorcycle()
{
	playfxontag(level._effect["bike_head_light"], self, "tag_headlight_left");
	playfxontag(level._effect["bike_tail_light"], self, "tag_taillight_left");
}


dof_motorcade_start()
{
	//SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )
	near_start = 0;
	near_end = 90;
	far_start = 300;
	far_end = 2000;
	near_blur = 7;
	far_blur = 2;

	get_players()[0] SetDepthOfField(near_start, near_end, far_start, far_end, near_blur, far_blur);
}


dof_convoy()
{
	//SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )
	near_start = 0;
	near_end = 15;
	far_start = 450;
	far_end = 2500;
	near_blur = 4;
	far_blur = 1.5;

	get_players()[0] SetDepthOfField(near_start, near_end, far_start, far_end, near_blur, far_blur);
}


flash_pentagon_numbers()
{
	wait(6.0);

	//after "distinguished heroes"
	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_1", false, true);
	playsoundatposition ("evt_shocking_1", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(2.75);

	//after "distinguished leaders"
	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_4", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(0.25);

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_3", false, true);
	playsoundatposition ("evt_shocking_1", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(2.0);

	//after "out of my head"
	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_2", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(0.25);

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_4", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(10.25);

	//"he's waiting"
	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_1", false, true);
	playsoundatposition ("evt_shocking_1", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(0.25);

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_2", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();
}


flash_warroom_numbers()
{
	////exit elevator
	//hud_utility_show("cinematic", 0);
	//Start3DCinematic("int_shocking_3", false, true);
	//wait 0.5;
	//hud_utility_hide();
	//Stop3DCinematic();

	//wait(0.25);

	//hud_utility_show("cinematic", 0);
	//Start3DCinematic("int_shocking_1", false, true);
	//wait 0.5;
	//hud_utility_hide();
	//Stop3DCinematic();

	flag_wait("warroom");
	//IPrintLnBold( "last shock" );

	hud_utility_show("cinematic", 0);
	
	//-- GLocke - enable this all the time for the PC as well
	//if ( level.ps3 )
	//{
	
		// S.Crowe - for 3-D PS3, this ends up cutting in on the splitscreen movie, killing our script notify
		level clientnotify("kill_warroom_bink");
	//}
	Start3DCinematic("int_shocking_2", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(0.25);

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_3", false, true);
	playsoundatposition ("evt_shocking_1", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(1.0);

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_4", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();

	wait(24.0);

	hud_utility_show("cinematic", 0);
	Start3DCinematic("int_shocking_2", false, true);
	playsoundatposition ("evt_shocking_2", (0,0,0));
	wait 0.5;
	hud_utility_hide();
	Stop3DCinematic();
}
