
main()
{
	self setModel("c_usa_pent_female_head5");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_usa_pent_female_upper::main());
	self attach(self.headModel, "", true);
	self.hatModel = codescripts\character::randomElement(xmodelalias\c_usa_pent_female_lower::main());
	self attach(self.hatModel, "", true);
	self.gearModel = codescripts\character::randomElement(xmodelalias\c_usa_pent_female_jewelry::main());
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}
precache()
{
	precacheModel("c_usa_pent_female_head5");
	codescripts\character::precacheModelArray(xmodelalias\c_usa_pent_female_upper::main());
	codescripts\character::precacheModelArray(xmodelalias\c_usa_pent_female_lower::main());
	codescripts\character::precacheModelArray(xmodelalias\c_usa_pent_female_jewelry::main());
}  
