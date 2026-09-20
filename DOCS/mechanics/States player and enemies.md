#player
Idle - defult state

Moving - move towards the target hex within max move distance. Obsticals and pits block movement for most characters unless they have something to prevent it.

Shooting

Melee - roll the melee die if an enemy is in range 1

Mining - same as melee but checks if a wall or breakable obsitcal is in range 1. 

Knocked down- knocked down animation

Unconscious - health = 0

Taking damage - reduce health to new value

#enemy
Dead - dead state when health drops to 0

Moving - when pc not in attack range, move within max move distance to closest player. It there is a tie attack the one that activated most reciently. The enemy should always move within the range to attack but prefer the max distance. This allows melee units to move infront of ranged units

Bitting - when in melee range roll the number of dice associated with the creature and deal damage and effects.

Shooting - very similar to bitting so could combine. When in range deal damage equal to the associated number of die and effects  

Taking damage - taking damage

Advantage - when ever attacked the attacker my rerole any number of attack die and pick the higher value.

