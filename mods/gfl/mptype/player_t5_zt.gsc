
main()
{
	switch( codescripts\character::get_random_character(4) )
	{
	case 0:
		character\c_usa_sog2_zt::main();
		break;
	case 1:
		character\c_zom_blue_guy_zt::main();
		break;
	case 2:
		character\c_zom_red_guy_zt::main();
		break;
	case 3:
		character\c_zom_yellow_guy_zt::main();
		break;
	}
}
precache()
{
	character\c_usa_sog2_zt::precache();
	character\c_zom_blue_guy_zt::precache();
	character\c_zom_red_guy_zt::precache();
	character\c_zom_yellow_guy_zt::precache();
} 
