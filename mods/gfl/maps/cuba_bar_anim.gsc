#include maps\_utility;
#include maps\_anim;

// --------------------------------------------------------------------------------
// ---- Bar scene animations main ----
// --------------------------------------------------------------------------------

main()
{
	setup_player_anims();

	setup_bowman_anims();
	
	setup_woods_anims();

	setup_carlos_anims();

	setup_woman_anims();

	setup_thug_anims();
	
	setup_leader_anims();

	setup_patrons_anims();

	setup_prop_anims();

	setup_outside_anims();
}

#using_animtree("generic_human");

// --------------------------------------------------------------------------------
// ---- Bowman ----
// --------------------------------------------------------------------------------
setup_bowman_anims()
{
	level.scr_anim["bowman"]["intro"]			= %ch_cub_barscene_bowman;
	addnotetrack_customfunction( "bowman", "gun_attach",    maps\cuba_bar::friendly_give_gun, "intro" ); 

	level.scr_anim["bowman"]["exit"]			= %ch_cub_b01_bar_exit_bowman;
	addnotetrack_customfunction( "bowman", "break_window", maps\cuba_bar::bowman_break_window, "exit" );
}

// --------------------------------------------------------------------------------
// ---- Woods ----
// --------------------------------------------------------------------------------
setup_woods_anims()	
{
	level.scr_anim["woods"]["intro"] = %ch_cub_barscene_woods;
	addnotetrack_customfunction( "woods", "start_thugs",    maps\cuba_bar::thugs_start, "intro" );
	addnotetrack_customfunction( "woods", "knife_attach",   maps\cuba_bar::woods_give_knife, "intro" );
	addnotetrack_customfunction( "woods", "knife_stick",    maps\cuba_bar::woods_stick_knife, "intro" );
	
	addnotetrack_customfunction( "woods", "bottle_attach",  maps\cuba_bar::woods_attach_bottle, "intro" );
	addnotetrack_customfunction( "woods", "bottle_detach",  maps\cuba_bar::woods_detach_bottle, "intro" );
	
	addnotetrack_customfunction( "woods", "knife_detach",   maps\cuba_bar::woods_take_knife, "intro" );
	addnotetrack_customfunction( "woods", "gun_attach",     maps\cuba_bar::friendly_give_gun, "intro" );

	level.scr_anim["woods"]["exit"] = %ch_cub_b01_bar_exit_woods;
	addnotetrack_customfunction( "woods", "open_door", maps\cuba_bar::woods_opens_door, "exit" );
	addnotetrack_customfunction( "woods", "riffle_attach", maps\cuba_bar::bar_reset, "exit" );
	addnotetrack_customfunction( "woods", "knife_detach", maps\cuba_bar::woods_delete_knife, "exit" );
}

// --------------------------------------------------------------------------------
// ---- Carlos ----
// --------------------------------------------------------------------------------
setup_carlos_anims()
{
	level.scr_anim["carlos"]["intro"] = %ch_cub_barscene_carlos;
	addnotetrack_customfunction( "carlos", "start_map_anim", maps\cuba_bar::animate_map, "intro" );

	level.scr_anim["carlos"]["exit"]			= %ch_cub_b01_bar_exit_carlos;
	addnotetrack_customfunction( "carlos", "break_window", maps\cuba_bar::carlos_break_window, "exit" );
}

// --------------------------------------------------------------------------------
// ---- Woman ----
// --------------------------------------------------------------------------------
setup_woman_anims()
{
	level.scr_anim["woman"]["intro"]	= %ch_cub_barscene_woman;
}

// --------------------------------------------------------------------------------
// ---- thugs ----
// --------------------------------------------------------------------------------
setup_thug_anims()
{
	level.scr_anim["thug1"]["intro"]	= %ch_cub_barscene_thug1;
	
	level.scr_anim["thug2"]["intro"]	= %ch_cub_barscene_thug2;
	level.scr_anim["thug2"]["death"]	= %ai_pillar_crouch_death_right_02;

	level.scr_anim["thug3"]["intro"]	= %ch_cub_barscene_thug3;
	addnotetrack_customfunction( "thug3", "door_close", maps\cuba_bar::close_bar_door, "intro" ); 
	
	level.scr_anim["thug3"]["shoot"][0]	= %ch_cub_barscene_thug3_shoot;
}

// --------------------------------------------------------------------------------
// ---- leader ----
// --------------------------------------------------------------------------------
setup_leader_anims()
{
	level.scr_anim["leader"]["intro"] = %ch_cub_barscene_leader;
	addnotetrack_customfunction( "leader", "grab_player",	 maps\cuba_bar::grab_player, "intro" );
	addnotetrack_customfunction( "leader", "look_at_door", maps\cuba_bar::look_at_door, "intro" );

	level.scr_anim["leader"]["exit"] = %ch_cub_b01_bar_exit_leader;
}

// --------------------------------------------------------------------------------
// ---- patrons ----
// --------------------------------------------------------------------------------
setup_patrons_anims()
{
	level.scr_anim["patron1"]["intro"]		= %ch_cub_barscene_patron_1;
	level.scr_anim["patron2"]["intro"]		= %ch_cub_barscene_patron_2;
	level.scr_anim["patron_pee"]["intro"]	= %ch_cub_barscene_patron_pee;
	level.scr_anim["patron_chest"]["intro"]	= %ch_cub_barscene_patron_chest;
}

setup_outside_anims()
{
	level.scr_anim["civ1"]["exit"] = %ch_cub_b01_bar_exit_civ1;
	level.scr_anim["civ2"]["exit"] = %ch_cub_b01_bar_exit_civ2;
	level.scr_anim["civ3"]["exit"] = %ch_cub_b01_bar_exit_civ3;
	level.scr_anim["civ4"]["exit"] = %ch_cub_b01_bar_exit_civ4;
	level.scr_anim["civ5"]["exit"] = %ch_cub_b01_bar_exit_civ5;
	level.scr_anim["civ6"]["exit"] = %ch_cub_b01_bar_exit_civ6;
	level.scr_anim["civ7"]["exit"] = %ch_cub_b01_bar_exit_civ7;
	level.scr_anim["civ8"]["exit"] = %ch_cub_b01_bar_exit_civ8;
	level.scr_anim["civ9"]["exit"] = %ch_cub_b01_bar_exit_civ9;
	level.scr_anim["civ10"]["exit"] = %ch_cub_b01_bar_exit_civ10;

	level.scr_anim["bar_exit_police_pass"]["exit"] = %ch_cub_b01_bar_exit_policecar_police1;
	level.scr_anim["bar_exit_police_driver"]["exit"] = %ch_cub_b01_bar_exit_policecar_police2;

	level.scr_anim["police1"]["exit"] = %ch_cub_b01_bar_exit_police1;
	level.scr_anim["police2"]["exit"] = %ch_cub_b01_bar_exit_police2;
}

#using_animtree("cuba");

// --------------------------------------------------------------------------------
// ---- Player ----
// --------------------------------------------------------------------------------
setup_player_anims()
{
	level.scr_sound["mason"]["police_will_be_here_soon"] = "vox_cub1_s01_500A_wood"; //Police will be here soon... Let's make this quick.

	level.scr_sound["mason"]["sup_carlos"] = "vox_cub1_s01_501A_maso_m"; //What's up, Carlos?

	level.scr_sound["mason"]["hope_he_did"] = "vox_cub1_s01_502A_maso_m"; //Fuckin' hope he did.

	level.scr_sound["mason"]["be_cool"] = "vox_cub1_s01_503A_maso_m"; //Just be cool, Woods. Wait.

	level.scr_sound["mason"]["gear_up"] = "vox_cub1_s01_504A_maso_m"; //Gear up, boys.

	// player full animated body
	level.scr_animtree["player_hands"]		= #animtree;
	level.scr_model["player_hands"]			= "t5_gfl_ump45_viewbody";

	level.scr_anim["player_hands"]["intro"]	= %int_cub_barscene_player_grab;
	level.scr_anim["player_hands"]["exit"]	= %ch_cub_b01_bar_exit_player;
}

// --------------------------------------------------------------------------------
// ---- Props ----
// --------------------------------------------------------------------------------
setup_prop_anims()
{
	level.scr_anim["map"]["intro"] = %o_cub_barscene_map;

	level.scr_animtree["map"] = #animtree;
	level.scr_model["map"] = "anim_cub_map01";

	level.scr_anim["woods_gun"]["exit_loop"][0] = %o_cub_b01_bar_exit_woods_gun;

	level.scr_animtree["woods_gun"] = #animtree;
	level.scr_model["woods_gun"] = "t5_weapon_M16A1_world";

	level.scr_animtree["door"] = #animtree;

	level.scr_anim["door"]["first_open"] = %o_cub_barscene_door_burst_open;

	level.scr_anim["door"]["closed_loop"][0] = %p_cub_b01_bar_exit_door_closed;
	level.scr_anim["door"]["open_loop"][0] = %p_cub_b01_bar_exit_door_open;
	level.scr_anim["door"]["open"] = %p_cub_b01_bar_exit_door;

	level.scr_anim["door"]["intro_close"] = %o_cub_barscene_door_close_end;

	level.scr_animtree["car"] = #animtree;
 	level.scr_anim["car"]["exit"] = %v_cub_b01_bar_exit_policecar_car;
// 	level.scr_anim["car"]["intro"] = %v_cub_b01_bar_exit_policecar_idle_car;
}