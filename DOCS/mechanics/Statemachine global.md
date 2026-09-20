

#Player turn
Check player turn order - this is assigned before the level loads and is stored as a string. This is looped till the level ends.
Player takes actions equal to number of action points
Player ends turn for pc
End phase and move to event


#Enemy turn
Only occurs if the enemies are activated by the event deck or by a swarm encounter

Order enemies - order enemies by priority of movement. Generally weaker enemies move first. 

Execute enemy actions - either shoot or move

End phase

#Event turn
These occur after the end of every pc turn.
Draw event card
Trigger event
Move Swarm tracker accordingly (can be 0)
Activate enemies if needed. 
End phase and return to player phase.

I dont know how to do this but the game should globally check for if the objective is complete. 