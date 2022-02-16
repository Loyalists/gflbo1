
main()
{
	self setModel("c_usa_jungmar_body_drab");
	self.headModel = "c_usa_jungmar_head5_nc";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_jungmar_gear5";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_jungmar_body_drab");
	precacheModel("c_usa_jungmar_head5_nc");
	precacheModel("c_usa_jungmar_gear5");
}  
