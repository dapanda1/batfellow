script "batfellow.ash";
notify cheesecookie;
since r16936;


#	Thanks to ungawa (#404576) for providing a starting point for this script!
#	Thanss to lightwolf (#61661) for the layout of Kickball Fellow (http://alliancefromhell.com/viewtopic.php?f=1&p=91032)
#
#	Methods to run the script:
#	Read comic, skip Intro NC, run batfellow.ash: You will be prompted to enter a goal:
#		Either enter the number or type out the item name:
#			1 Kudzu salad
#			2 Mansquito Serum
#			3 Miss Graves' vermouth
#			4 The Plumber's mushroom stew
#			5 The Author's ink
#			6 The Mad Liquor
#			7 Doc Clock's thyme cocktail
#			8 Mr. Burnsger
#			9 The Inquisitor's unidentifiable object
#		This method requires that you start Batfellow yourself to avoid accidents
#
#	The following command will complete an entire Batfellow set (this opens it as well, just won't buy it).
#	ash import<batfellow.ash> batfellow(item);
#
#	Alternatively, you can add it to a script by importing and then using the function directly.
#
#
#	Warnings: The script may not be able to defeat the Jokester without enough starting $.
#	It will still try to do so. Good luck!
#	DO NOT use an Intergnat or any other thing that alters combats before this....
#
#	Warranty not valid in Fartland.
#
#	A lead-in of 3 is required to be able to defeat the Jokester while collecting your goal.
#



boolean batfellow(item goal);
item convertBatfellow(string goal);
void batfellowHUD();
int getBatStat(string what);
int batfellowUpgrade();
int batProgress(int snarfblat, string page);
int batProgress(item goal, string page);
int batProgressIndex(int index, string page);
string batVenture(location loc, string combat, string page);
void batfellowSpeech(int zone);
void batInvestigation();
int batGoalIndex(item goal);
void endBatFellow();

void batInvestigation()
{
	int progress = getBatStat("Bat-Investigation Progress") - 3;
	if(contains_text(get_property("batmanUpgrades"), "Street Sweeper"))
	{
		progress -= 1;
	}
	if(contains_text(get_property("batmanUpgrades"), "Spotlight"))
	{
		progress -= 1;
	}
	if(progress > 0)
	{
		if(!contains_text(get_property("batmanStats"), "Inquisitee"))
		{
			set_property("batmanStats", get_property("batmanStats") + ";Bat-Inquisitee=1");
		}
	}
}

string batVenture(location loc, string combat, string charpage)
{
	string page = visit_url(to_url(loc));
	int isDone = 1;

	if(my_hp() == 0)
	{
		abort("Batfellow has fallen...");
	}

	matcher choiceMatcher = create_matcher("whichchoice(?:\\s+)value=(\\d+)", page);
	if(choiceMatcher.find())
	{
		int choice = choiceMatcher.group(1).to_int();
		print("BatChoice: " + choice, "green");
		int option = 0;

		int left = 900;
		int i=0;
		while(i<9)
		{
			left -= batProgressIndex(i, charpage);
			i += 1;
		}

		if(left > 890)
		{
			switch(choice)
			{
			case 1146:		option = 3;			break;
			case 1148:		option = 3;			break;
			}
			page = visit_url("choice.php?whichchoice=" + choice + "&option=" + option + "&pwd=");
		}
		else
		{
			switch(choice)
			{
			case 1140:		option = 5;			break;
			case 1141:		option = 5;			break;
			case 1142:		option = 5;			break;
			case 1143:		option = 4;			break;
			case 1144:		option = 4;			break;
			case 1145:		option = 4;			break;
			case 1146:		option = 4;			break;
			case 1147:		option = 4;			break;
			case 1148:		option = 4;			break;

			case 1150:		option = 1;			break;
			case 1151:		option = 1;			break;
			case 1152:		option = 1;			break;
			case 1153:		option = 1;			break;
			case 1154:		option = 1;			break;
			case 1155:		option = 1;			break;
			case 1156:		option = 1;			break;
			case 1157:		option = 1;			break;
			case 1158:		option = 1;			break;
			}
			while(option > 0)
			{
				if((choice >= 1150) && (choice <= 1158))
				{
					page = visit_url("choice.php?whichchoice=" + choice + "&option=" + option + "&pwd=");
					isDone = 0;
				}
				page = visit_url("choice.php?whichchoice=" + choice + "&option=" + option + "&pwd=");
				option -= 1;
			}
		}
		if(isDone == 1)
		{
			return "";
		}
	}

	string encounter = get_property("lastEncounter");
	int startTime = get_property("batmanTimeLeft").to_int();
	string[int] batCombat = split_string(combat, ";");

	while(monster_hp() > 0)
	{
		if(my_hp() == 0)
		{
			abort("Batfellow has fallen...");
		}

		int allow = 0;
		int lasthp = monster_hp();
		foreach index, batAction in batCombat
		{
			print("Bat action:::: " + "fight.php?action=skill&whichskill=" + to_int(to_skill(batAction)), "green");
			if((batAction == "kickball") && (item_amount($item[Exploding Kickball]) == 0))
			{
				batAction = "bat-o-mite";
			}
			if((my_maxhp() - my_hp()) > 40)
			{
				if(item_amount($item[Ultracoagulator]) > 0)
				{
					batAction = "Ultracoagulator";
				}
				if(item_amount($item[Bat-Aid&trade; Bandage]) > 0)
				{
					batAction = "Use Bat-Aid";
				}
			}
			if((batAction == "bat-o-mite") && (item_amount($item[Bat-o-mite]) == 0))
			{
				batAction = "Bat-Punch";
				if(item_amount($item[Bat-oomerang]) > 0)
				{
					batAction = "Bat-oomerang";
				}
				if(item_amount($item[Bat-Bearing]) > 0)
				{
					batAction = "Bat-Bearing";
				}
			}
			if((batAction != "kickball") && (monster_hp() <= 10) && (item_amount($item[Bat-Jute]) > 0))
			{
				batAction = "bat-jute";
			}
			print("Batction! " + batAction, "green");
			if(batAction == "bat-jute")
			{
				print("NANANANANANA BAT-JUTE!!!!!", "green");
			}
			string temp = visit_url("fight.php?action=skill&whichskill=" + to_int(to_skill(batAction)));
			if(!contains_text(temp, "Bat-Punch"))
			{
				return "";
			}
			if(monster_hp() == lasthp)
			{
				matcher choiceMatcher = create_matcher("whichchoice(?:\\s+)value=(\\d+)", visit_url("main.php"));
				if(choiceMatcher.find())
				{
					int choice = choiceMatcher.group(1).to_int();
					page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
				}
				else
				{
					allow += 1;
					if(allow >= 3)
					{
						if(startTime != get_property("batmanTimeLeft").to_int())
						{
							return "";
						}
						if(my_location().turns_spent == 0)
						{
							return "";
						}
						if(encounter != get_property("lastEncounter"))
						{
							return "";
						}
						abort("Monster HP did not batChange...");
					}
				}
			}
			else
			{
				allow = 0;
			}
			lasthp = monster_hp();
		}
	}
	return "";
}


void batfellowSpeech(int zone)
{
	boolean[string] text = $strings[Who\'s the man with the plan\, not a friend of master hand? Batfellow! Batfellow Batfellow!, Yo-Yo Ma nanana\, nanananananan! Batfellow! Batfellow! Batfellow!!, He\'s so mellow like a color maybe it is red! Batfellow! Batfellow! Batfellow!!, Nanananananananana Batfellow!!!, Boris had a mighty bellow but he is not Batfellow. Batfellow!!!, He could even play a cello\, Batfellow!!!, Can afford a bath in jello\, Batfellow! Batfellow!!, Gonna save Gotpork\, bork bork bork bork! Batfellow!!];

	int i = 0;
	int which = random(count(text));
	foreach it in text
	{
		if(i == which)
		{
			print(it, "green");
		}
		i += 1;
	}

}



boolean batfellow(item goal)
{
	if((goal == $item[none]) || (goal != convertBatfellow(to_string(goal))))
	{
		print("Can not attempt to acquire " + goal + " via Batfellow. Sorry.", "red");
		return false;
	}

	if(limit_mode() == "")
	{
		item toUse = $item[Special Edition Batfellow Comic];
		if(item_amount($item[Special Edition Batfellow Comic]) == 0)
		{
			toUse = $item[Batfellow Comic];
			if(item_amount($item[Batfellow Comic]) == 0)
			{
				print("Can't be a superhero with a comic to fuel your limited imagination!", "red");
				return false;
			}
		}
		use_familiar($familiar[none]);
		int oldSetting = get_property("choiceAdventure1133").to_int();
		set_property("choiceAdventure1133", 1);
		//open batfellow comic and start it.
		use(1, toUse);
		set_property("choiceAdventure1133", oldSetting);
		set_property("choiceAdventure1168", 1);
		print("Entering Gotpork!", "blue");
	}

	if(limit_mode() != "batman")
	{
		print("We are not in batfellow, you can not be a hero today!", "red");
		return false;
	}

	while(get_property("batmanTimeLeft").to_int() > 0)
	{
		string page = visit_url("charpane.php");
		batInvestigation();

		int left = 900;
		int i=0;
		while(i<9)
		{
			left -= batProgressIndex(i, page);
			i += 1;
		}
		int kickballs = 40;
		int evidence = 50;
		if(left < 800)
		{
			kickballs = 500 / 20;
			evidence = 500 / 16;
		}
		#print("Want " + kickballs + " kickballs", "green");
		#print("Want " + evidence + " evidence", "green");


		//Primary functioning loop.
		wait(1);
		if(get_property("batmanZone") == "Bat-Cavern")
		{
			int fundsAvailable = get_property("batmanFundsAvailable").to_int();
			while(fundsAvailable > 0)
			{
				string temp = visit_url("place.php?whichplace=batman_cave&action=batman_cave_rnd");
				int upgradeChoice = batfellowUpgrade();
				if(upgradeChoice == 0)
				{
					print("No upgrades left but we have money!", "red");
					break;
				}
				int type = upgradeChoice / 16;
				int choice = upgradeChoice % 16;
				run_choice(type);
				run_choice(choice);

				//buy skills
				run_choice(11);
				fundsAvailable -= 1;
			}

			int materialNeed = 3;
			if(contains_text(get_property("batmanUpgrades"), "Improved 3-D Bat-Printer"))
			{
				materialNeed = 2;
			}

			while((item_amount($item[High-Grade Metal]) >= materialNeed) || (item_amount($item[High-Tensile-Strength Fibers]) >= materialNeed) || (item_amount($item[High-Grade Explosives]) >= materialNeed))
			{
				string temp = visit_url("shop.php?whichshop=batman_cave");
				if(item_amount($item[High-Grade Metal]) >= materialNeed)
				{
					//Bat-oomerang
					int quantity = item_amount($item[High-Grade Metal]) / materialNeed;
					temp = visit_url("shop.php?whichshop=batman_cave&action=buyitem&quantity=" + quantity + "&whichrow=782");
				}
				if(item_amount($item[High-Tensile-Strength Fibers]) >= materialNeed)
				{
					//Bat-jute
					int quantity = item_amount($item[High-Tensile-Strength Fibers]) / materialNeed;
					temp = visit_url("shop.php?whichshop=batman_cave&action=buyitem&quantity=" + quantity + "&whichrow=783");
				}
				if(item_amount($item[High-Grade Explosives]) >= materialNeed)
				{
					//Bat-o-mite
					int quantity = item_amount($item[High-Grade Explosives]) / materialNeed;
					temp = visit_url("shop.php?whichshop=batman_cave&action=buyitem&quantity=" + quantity + "&whichrow=784");
				}
			}
			print("Time to camp it up! Out of this cavern!", "blue");
			string temp = visit_url("place.php?whichplace=batman_cave&action=batman_cave_car");
			if((item_amount($item[Exploding Kickball]) > kickballs) && (item_amount($item[Fingerprint Dusting Kit]) > evidence) && (batProgressIndex(batGoalIndex(goal), page) < 100))
			{
				int index = batGoalIndex(goal);
				print("batTime for mah goal: " + goal + " (" + index + ")", "green");
				if(index <= 2)
				{
					string temp = visit_url("choice.php?whichchoice=1135&option=5&pwd=");
				}
				else if(index <= 5)
				{
					string temp = visit_url("choice.php?whichchoice=1135&option=3&pwd=");
				}
				else
				{
					string temp = visit_url("choice.php?whichchoice=1135&option=4&pwd=");
				}
				while((batProgressIndex(index, page) < 100) && (get_property("batmanTimeLeft").to_int() > 0))
				{
					batVenture(to_location(index+464), "bat-o-mite", page);
					page = visit_url("charpane.php");
				}
				if(get_property("batmanTimeLeft").to_int() == 0)
				{
					endBatFellow();
					return false;
				}
				print("BatBoss BatItem BatTime!", "green");
				batVenture(to_location(index+464), "kickball", page);
				matcher choiceMatcher = create_matcher("whichchoice(?:\\s+)value=(\\d+)", visit_url("main.php"));
				if(choiceMatcher.find())
				{
					int choice = choiceMatcher.group(1).to_int();
					print("BatChoice: " + choice, "green");
					page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
					page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
					page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
				}
				print("Returning to batBase", "green");

				if(index <= 2)
				{
					string temp = visit_url("place.php?whichplace=batman_park&action=batman_park_car");
				}
				else if(index <= 5)
				{
					string temp = visit_url("place.php?whichplace=batman_slums&action=batman_slums_car");
				}
				else
				{
					string temp = visit_url("place.php?whichplace=batman_industrial&action=batman_industrial_car");
				}


				string temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
				temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
			}
			else if(left > 800)
			{
				string temp = visit_url("choice.php?whichchoice=1135&option=4&pwd=");
			}
			else if(left == 0)
			{
				print("In the batCavern, need to batimate the batJokester!", "green");
				string temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
			}
			else if((item_amount($item[Exploding Kickball]) > kickballs) && (item_amount($item[Fingerprint Dusting Kit]) > evidence))
			{
				int index = 8;
				while(index >= 0)
				{					
					if(batProgressIndex(index, page) < 100)
					{
						string combat = "bat-o-mite";
						if(index <= 2)
						{
							string temp = visit_url("choice.php?whichchoice=1135&option=5&pwd=");
							combat = "kickball";
						}
						else if(index <= 5)
						{
							string temp = visit_url("choice.php?whichchoice=1135&option=3&pwd=");
						}
						else
						{
							string temp = visit_url("choice.php?whichchoice=1135&option=4&pwd=");
						}

						

						while((batProgressIndex(index, page) < 100) && (get_property("batmanTimeLeft").to_int() > 0))
						{
							batVenture(to_location(index+464), combat, page);
							page = visit_url("charpane.php");
						}
						if(get_property("batmanTimeLeft").to_int() == 0)
						{
							endBatFellow();
							return false;
						}
						print("BatBoss batTime!", "green");
						batVenture(to_location(index+464), "kickball", page);
						matcher choiceMatcher = create_matcher("whichchoice(?:\\s+)value=(\\d+)", visit_url("main.php"));
						if(choiceMatcher.find())
						{
							int choice = choiceMatcher.group(1).to_int();
							print("BatChoice: " + choice, "green");
							page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
							page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
							page = visit_url("choice.php?whichchoice=" + choice + "&option=" + 1 + "&pwd=");
						}
						print("Returning to batBase", "green");

						if(index <= 2)
						{
							string temp = visit_url("place.php?whichplace=batman_park&action=batman_park_car");
						}
						else if(index <= 5)
						{
							string temp = visit_url("place.php?whichplace=batman_slums&action=batman_slums_car");
						}
						else
						{
							string temp = visit_url("place.php?whichplace=batman_industrial&action=batman_industrial_car");
						}


						string temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
						index = -2;
					}
					index -= 1;
				}
				if(index == -2)
				{
					print("In the batCavern, need to batimate the batJokester!", "green");
					string temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
				}
			}
			else
			{
				string temp = visit_url("choice.php?whichchoice=1135&option=4&pwd=");
			}
		}

		if(get_property("batmanZone") == "Downtown")
		{
			string temp = visit_url("place.php?whichplace=batman_downtown&action=batman_downtown_hospital");
			if(item_amount($item[Kidnapped Orphan]) > 0)
			{
				temp = visit_url("shop.php?whichshop=batman_orphanage");
				temp = visit_url("shop.php?whichshop=batman_orphanage&action=buyitem&quantity=" + item_amount($item[Kidnapped Orphan]) + "&whichrow=791&pwd=");
				temp = visit_url("place.php?whichplace=batman_downtown");
			}

			if(item_amount($item[Incriminating Evidence]) > 0)
			{
				temp = visit_url("shop.php?whichshop=batman_pd");
				temp = visit_url("shop.php?whichshop=batman_pd&action=buyitem&quantity=" + item_amount($item[Incriminating Evidence]) + "&whichrow=789&pwd=");
				temp = visit_url("place.php?whichplace=batman_downtown");
			}

			if(item_amount($item[Dangerous Chemicals]) > 0)
			{
				int coagulator = max(0, 8 - item_amount($item[Ultracoagulator]));
				temp = visit_url("shop.php?whichshop=batman_chemicorp");
				if(coagulator > 0)
				{
					temp = visit_url("shop.php?whichshop=batman_chemicorp&action=buyitem&quantity=" + coagulator + "&whichrow=787&pwd=");
				}
				int curHealth = (getBatStat("Maximum Bat-Health")-20) / 10;
				if(item_amount($item[Dangerous Chemicals]) > (3*curHealth))
				{
					temp = visit_url("shop.php?whichshop=batman_chemicorp&action=buyitem&quantity=" + 1 + "&whichrow=785&pwd=");
				}
				temp = visit_url("place.php?whichplace=batman_downtown");
			}




			if(left == 0)
			{
				temp = visit_url(to_url(to_location(473)));
				temp = visit_url(to_url(to_location(473)));
				temp = visit_url("choice.php?forceoption=0");
				temp = visit_url("choice.php?whichchoice=1149&option=1&pwd=");
				temp = visit_url("choice.php?whichchoice=1169&option=1&pwd=");
				temp = visit_url("choice.php?whichchoice=1169&option=1&pwd=");
				batVenture(to_location(473), "kickball", page);

				temp = visit_url("choice.php?whichchoice=1170&option=1&pwd=");
				temp = visit_url("choice.php?whichchoice=1170&option=1&pwd=");
				temp = visit_url("choice.php?whichchoice=1170&option=1&pwd=");
				temp = visit_url("choice.php?whichchoice=1168&option=1&pwd=");
				print("BatDone, Batastic.", "blue");
				return true;
			}
			temp = visit_url("place.php?whichplace=batman_downtown&action=batman_downtown_car");
			if((item_amount($item[Exploding Kickball]) > kickballs) && (item_amount($item[Fingerprint Dusting Kit]) > evidence))
			{
				temp = visit_url("choice.php?whichchoice=1135&option=1&pwd=");
			}
			else
			{
				temp = visit_url("choice.php?whichchoice=1135&option=4&pwd=");
			}
		}

		if(get_property("batmanZone") == "Industrial District (High Crime)")
		{
			if(left == 0)
			{
				string temp = visit_url("place.php?whichplace=batman_industrial&action=batman_industrial_car");
				temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
			}
			batfellowSpeech(3);
			if(!contains_text(get_property("batmanStats"), "Inquisitee"))
			{
				if(item_amount($item[Bat-o-mite]) > 0)
				{
					batVenture($location[Trivial Pursuits\, LLC], "bat-o-mite", page);
				}
			}
#			if(left > 800)
#			{
				if((item_amount($item[Exploding Kickball]) + item_amount($item[Kidnapped Orphan])) < kickballs)
				{
					if(item_amount($item[Exploding Kickball]) > 0)
					{
						batVenture($location[Gotpork Clock\, Inc.], "kickball", page);
					}
					else
					{
						string temp = visit_url("place.php?whichplace=batman_industrial&action=batman_industrial_car");
						temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
						
					}
				}
				else if((item_amount($item[Incriminating Evidence]) + item_amount($item[Fingerprint Dusting Kit])) < evidence)
				{
					if((item_amount($item[Exploding Kickball]) > 0) && (batProgressIndex(8,page) < 100))
					{
						batVenture($location[Trivial Pursuits\, LLC], "kickball", page);
					}
				}
				else
				{
					string temp = visit_url("place.php?whichplace=batman_industrial&action=batman_industrial_car");
					temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
				}
#			}
		}

		if(get_property("batmanZone") == "Slums (Moderate Crime)")
		{
			string temp = visit_url("place.php?whichplace=batman_slums&action=batman_slums_car");
			temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
		}


		if(get_property("batmanZone") == "Center Park (Low Crime)")
		{
			string temp = visit_url("place.php?whichplace=batman_park&action=batman_park_car");
			temp = visit_url("choice.php?whichchoice=1135&option=2&pwd=");
		}
		wait(1);
		//abort("Incomplete Beep.");
	}

	return true;
}


int getBatStat(string what)
{
	if(limit_mode() != "batman")
	{
		abort("You are only are just a sad adventurer, you have no bat stats.");
	}

	string[int] batStats = split_string(get_property("batmanStats"), ";");
	foreach index, batStat in batStats
	{
		string[int] thisStat = split_string(batStat, "=");
		if(thisStat[0] == what)
		{
			return to_int(thisStat[1]);
		}
	}
	return -1;
}

int batfellowUpgrade()
{
	if(!contains_text(get_property("batmanUpgrades"), "Extra-Swishy Cloak"))
	{
		return 16 + 3;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Orphan Scoop"))
	{
		return 32 + 5;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Improved Cowl Optics"))
	{
		return 16 + 6;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Rocket Booster"))
	{
		return 32 + 1;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Street Sweeper"))
	{
		return 32 + 3;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Advanced Air Filter"))
	{
		return 32 + 4;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Improved 3-D Bat-Printer"))
	{
		return 48 + 2;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Really Long Winch"))
	{
		return 48 + 1;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Spotlight"))
	{
		return 32 + 6;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Surveillance Network"))
	{
		return 48 + 4;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Blueprints Database"))
	{
		return 48 + 5;
	}

	if(!contains_text(get_property("batmanUpgrades"), "Utility Belt First Aid Kit"))
	{
		return 16 + 8;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Pec-Guards"))
	{
		return 16 + 4;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Transfusion Satellite"))
	{
		return 48 + 3;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Glue Factory"))
	{
		return 48 + 8;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Loose Bearings"))
	{
		return 32 + 8;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Hardened Knuckles"))
	{
		return 16 + 1;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Steel-Toed Bat-Boots"))
	{
		return 16 + 2;
	}

	if(!contains_text(get_property("batmanUpgrades"), "Kevlar Undergarments"))
	{
		return 16 + 5;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Asbestos Lining"))
	{
		return 16 + 7;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Snugglybear Nightlight"))
	{
		return 48 + 7;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Bat-Freshener"))
	{
		return 32 + 7;
	}
	if(!contains_text(get_property("batmanUpgrades"), "Glove Compartment First-Aid Kit"))
	{
		return 32 + 2;
	}

	return 0;
}


void batfellowHUD()
{
	if(limit_mode() != "batman")
	{
		abort("Only true heroes have a representation of their statistics.");
	}


	string page = visit_url("charpane.php");
	batInvestigation();


	print_html("<table border=1><tr><td colspan=2>BAT STATS: So awesome!</td></tr>");
	print_html("<tr><td>BatTime:</td><td>" + get_property("batmanTimeLeft") + "</td></tr>");
	print_html("<tr><td>BatBucks:</td><td>" + get_property("batmanFundsAvailable") + " (Bonus:" + (get_property("batmanBonusInitialFunds")) + ")</td></tr>");
	print_html("<tr><td>BatZone:</td><td>" + get_property("batmanZone") + "</td></tr>");
	print_html("<tr><td>BatHealth:</td><td>" + getBatStat("Bat-Health") + "/" + getBatStat("Maximum Bat-Health") + "</td></tr>");
	print_html("<tr><td>BatPunch:</td><td>" + getBatStat("Bat-Punch") + "(+" + getBatStat("Bat-Punch Modifier") + ",*" + getBatStat("Bat-Punch Multiplier") + ")</td></tr>");
	print_html("<tr><td>BatKick:</td><td>" + getBatStat("Bat-Kick") + "(+" + getBatStat("Bat-Kick Modifier") + ",*" + getBatStat("Bat-Kick Multiplier") + ")</td></tr>");
	print_html("<tr><td>BatResistance:</td><td> Heat:" + getBatStat("Bat-Heat Resistance") + " Spooky:" + getBatStat("Bat-Spooky Resistance") + " Stench:" + getBatStat("Bat-Stench Resistance") + "</td></tr>");



	foreach batStat in $strings[Bat-Health Regeneration, Bat-Armor, Bat-Bulletproofing, Bat-Investigation Progress]
	{
		print_html("<tr><td>" + batStat + "</td><td>" + getBatStat(batStat) + "</td></tr>");
	}

	int index = 0;

	foreach it in $items[Kudzu Salad, Mansquito Serum, Miss Graves\' Vermouth, The Plumber\'s Mushroom Stew, The Author\'s Ink, The Mad Liquor, Doc Clock\'s Thyme Cocktail, Mr. Burnsger, The Inquisitor\'s Unidentifiable Object]
	{
		print_html("<tr><td> " + to_location(464+index) + " </td><td> " + batProgressIndex(index,page) + " </td></tr>");
		index += 1;
	}


	print_html("</table>");
}

int batGoalIndex(item goal)
{
	switch(goal)
	{
	case $item[Kudzu Salad]:								return 0;
	case $item[Mansquito Serum]:							return 1;
	case $item[Miss Graves\' Vermouth]:						return 2;
	case $item[The Plumber\'s Mushroom Stew]:				return 3;
	case $item[The Author\'s Ink]:							return 4;
	case $item[The Mad Liquor]:								return 5;
	case $item[Doc Clock\'s Thyme Cocktail]:				return 6;
	case $item[Mr. Burnsger]:								return 7;
	case $item[The Inquisitor\'s Unidentifiable Object]:	return 8;
	}
	return -1;
}

item convertBatfellow(string goal)
{
	item retval = to_item(goal);
	if($items[Kudzu Salad, Mansquito Serum, Miss Graves\' Vermouth, The Plumber\'s Mushroom Stew, The Author\'s Ink, The Mad Liquor, Doc Clock\'s Thyme Cocktail, Mr. Burnsger, The Inquisitor\'s Unidentifiable Object] contains retval)
	{
		return retval;
	}
	switch(goal.to_int())
	{
	case 1:		retval = $item[Kudzu Salad];									break;
	case 2:		retval = $item[Mansquito Serum];								break;
	case 3:		retval = $item[Miss Graves\' Vermouth];							break;
	case 4:		retval = $item[The Plumber\'s Mushroom Stew];					break;
	case 5:		retval = $item[The Author\'s Ink];								break;
	case 6:		retval = $item[The Mad Liquor];									break;
	case 7:		retval = $item[Doc Clock\'s Thyme Cocktail];					break;
	case 8:		retval = $item[Mr. Burnsger];									break;
	case 9:		retval = $item[The Inquisitor\'s Unidentifiable Object];		break;
	}

	if($items[Kudzu Salad, Mansquito Serum, Miss Graves\' Vermouth, The Plumber\'s Mushroom Stew, The Author\'s Ink, The Mad Liquor, Doc Clock\'s Thyme Cocktail, Mr. Burnsger, The Inquisitor\'s Unidentifiable Object] contains retval)
	{
		return retval;
	}
	return $item[none];
}

void endBatFellow()
{
	string page = visit_url("choice.php?whichchoice=1168&option=1&pwd=");

}


boolean main(string goal)
{
	item toGet = convertBatfellow(goal);
	if(toGet == $item[none])
	{
		abort("Desired Item could not be solved for. Please try again.");
	}

	if(limit_mode() != "batman")
	{
		abort("Batfellow not started, must be started in this mode of operation.");
	}

	return batfellow(toGet);
}



int batProgress(int snarfblat, string page)
{
	return batProgressIndex(snarfblat - 464, page);
}
int batProgress(item goal, string page)
{
	int index = 0;
	foreach it in $items[Kudzu Salad, Mansquito Serum, Miss Graves\' Vermouth, The Plumber\'s Mushroom Stew, The Author\'s Ink, The Mad Liquor, Doc Clock\'s Thyme Cocktail, Mr. Burnsger, The Inquisitor\'s Unidentifiable Object]
	{
		if(it == goal)
		{
			return batProgressIndex(index, page);
		}
	}
	return -1;
}
int batProgressIndex(int index, string page)
{
	if((index < 0) || (index >= 9))
	{
		return -1;
	}

	string goal = "";
	switch(index)
	{
	case 0:		goal = "Kudzu";				break;
	case 1:		goal = "Mansquito";			break;
	case 2:		goal = "Miss Graves";		break;
	case 3:		goal = "The Plumber";		break;
	case 4:		goal = "The Author";		break;
	case 5:		goal = "The Mad-Libber";	break;
	case 6:		goal = "Doc Clock";			break;
	case 7:		goal = "Mr. Burns";			break;
	case 8:		goal = "The Inquisitor";	break;
	}

	if(page == "")
	{
		page = visit_url("charpane.php");
	}
	matcher goalMatchNormal = create_matcher("Track down " + goal + "(?:.*?)(\\d+)% progress", page);
	if(goalMatchNormal.find())
	{
		return to_int(goalMatchNormal.group(1));
	}
	matcher goalMatchEnd = create_matcher("Defeat " + goal, page);
	if(goalMatchEnd.find())
	{
		return 100;
	}
	return 100;
}

/*

Snarfblat: 461/462/463 are the dead zones
473: Jokester

*/
