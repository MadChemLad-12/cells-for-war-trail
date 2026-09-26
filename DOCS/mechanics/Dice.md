Start with a simple roll die function and assign a attack value to sides 1-6.


For the project I want basically to roll die and the play is able to drag and drop those die to any hex within range. If they have multiple die they drag and drop multiple die but it must be adjacent to another die. The idea ks that you cant have 2 damage amounts on two different enemies if they are not adjacent. You could hit the same tile twice though. 

Hex hex hex
1ap none 1ap not allowed

Hex hex hex
1ap 1ap 1bullet allowed

# upgrades
The dice should be customisable through the run. For example the sides of the die could be manipulated or the dice type could be changed depending on the weapon. 

I am thinking the die is rolled using a random number between 1 and dice face amount
The dice face amounts then connect to a array of strings which hold the players effects. For example a player may append 1 ap damage to the side 3 of a d6 so now it does 2 ap damage instead of 1 as on the original dice. 