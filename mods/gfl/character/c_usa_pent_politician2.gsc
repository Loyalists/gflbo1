
main()
{
	self setModel("c_usa_pent_politician_body");
	self.headModel = "c_usa_pent_politician_head2";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_pent_politician_body");
	precacheModel("c_usa_pent_politician_head2");
}  
