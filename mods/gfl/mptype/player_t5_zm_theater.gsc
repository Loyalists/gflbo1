
main()
{
	switch( codescripts\character::get_random_character(4) )
	{
	case 0:
		character\c_ger_richtofen_zt::main();
		break;
	case 1:
		character\c_jap_takeo_zt::main();
		break;
	case 2:
		character\c_rus_nikolai_zt::main();
		break;
	case 3:
		character\c_usa_dempsey_zt::main();
		break;
	}
}
precache()
{
	character\c_ger_richtofen_zt::precache();
	character\c_jap_takeo_zt::precache();
	character\c_rus_nikolai_zt::precache();
	character\c_usa_dempsey_zt::precache();
} 
