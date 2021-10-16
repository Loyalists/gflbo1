
main()
{
	self setModel("c_usa_pent_general_body");
	self.headModel = "c_usa_pent_general_head";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_pent_general_body");
	precacheModel("c_usa_pent_general_head");
}  
