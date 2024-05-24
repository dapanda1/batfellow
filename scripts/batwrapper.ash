#			1 Kudzu salad
#			2 Mansquito Serum
#			3 Miss Graves' vermouth
#			4 The Plumber's mushroom stew
#			5 The Author's ink
#			6 The Mad Liquor
#			7 Doc Clock's thyme cocktail
#			8 Mr. Burnsger
#			9 The Inquisitor's unidentifiable object

void main(int totalattempts)
{

int attempts = 0;
	
//cli_execute("set abortOnChoiceWhenNotInChoice = false");
//cli_execute("refresh all");

while (attempts < totalattempts) {
cli_execute("batfellow.ash 2");
attempts=attempts+1;
}
//cli_execute("set abortOnChoiceWhenNotInChoice = true");
cli_execute("refresh all");

}
