
main()
{
	self setModel("c_usa_pent_warroom_worker_body");
	self.headModel = "c_usa_pent_warroomworker_head3";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_pent_warroom_worker_body");
	precacheModel("c_usa_pent_warroomworker_head3");
}  
