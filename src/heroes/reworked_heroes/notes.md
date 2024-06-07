# Reworked Hero Notes

## Combat Concepts:
### Scratch / Grey Health:
When the player takes damage, most damage subtracted from health is retained as "grey health" (all but 1, to start). Grey health is recoverable through combat actions and will automatically be restored to real HP at the end of battle.

IMPORTANT: Grey health does not protect the player from getting knocked out.

The goal for including this is to eliminate the incentive / benefit for drawing out fights when the player has healing tools.

Example: 
Player with 20 HP is hit for 5 damage. Remaining HP is 15, with 4 points of "grey health"

When the player takes damage while having grey health, existing grey health is reduced in addition to normal life loss.

See "Grey Health Loss" below for some ideas about how this might work.

### Under Consideration
#### Grey Health Loss
Options:
- Player loses half of grey health on each hit
- Player loses grey health equivalent to normal damage taken
- Player loses grey health proportional to damage taken (could be scaled up or down)

I think I like the idea of losing grey health scaling up as your amount increases, but I worry how it'll work with multi-enemy fights, since there's no chance to interrupt enemies as they do their thing. Would be a weaker system if you went from 50/50 to 20/50 with only 5 points of grey health because you took hits from multiple enemies.

That might also end up being okay, though - puts more pressure on the player to find ways to mitigate incoming damage.

Might also work well if every (damaging) hit reduced grey health by 20% (minimum 1-point reduction, round fractionals up). If the player has 6 health, they lose 2, if they have 11 health, they lose 3. I guess numbers need testing and tweaking, but the concept is okay.

#### Hero-specific Health
Make your heroes take damage instead of the player. The heroes you use in a word are viable targets for enemies (maybe ordering impacts likelihood of being targeted? This would give more meaning to the sequencing of the turn, and help with the fact that you're probably likely to distribute leader effects across the team for a certain turn.)

This helps give enemies more exciting, varied behavior and gives new ways for support effects to impact the field (priests heal heroes within their party when word fires, knight has built-in defense and has support abilities to force taunts / attention)

It also increases the complexity of combat, though, maybe too much. Keeping things simpler may help avoid diluting the interesting parts of gameplay.

#### Hero LP & Revives
If we do the Hero-specific health option, maybe we have a SaGa-esque "hearts" / LP system for handling revives during quests. A hero knocked out cannot be used for the rest of the battle, but will return in the next battle with reduced LP. 

Maybe you could have LP persist between quests, and have some permanent decrease as they're defeated. I think fully eliminating character that's out of LP would be too harsh, instead we set a minimum value. Burning through LP just means there's not much margin for error in later quests (only 1 or 2 hearts = need to keep them healthy through the whole quest)

If characters have health and can revive, need to consider concept of minimum HP. Wouldn't be great to be incentivized to get a character killed to get more health via revive afterward.

#### Game Over / Lives System
Maybe game should operate under a "lives" system? Get 1 (or a few) retries per playthrough? On retry screen you can choose to re-attempt the combat you just played, retreat from the quest entirely, or retire the character.

Upside: gives the player time to recognize a character's weakness before forcing them to start over.

Downside: makes actually losing for real feel worse, gets players too attached to a particular attempt.

Radically different idea: can save the game completely normally outside of quests, let players re-attempt stuff as much as they want. We still want the looping gameplay, but it doesn't have to be tied to the players' defeat. Just completing a capstone adventure (or choosing to retire) will lock in all of the cool stuff you've earned in your adventure.

## Hero Types:
### Warrior
Physical multi-hit, scales well with external buffs

#### Leader Effects
Base:
2 hits for 1 damage

Scaling:
+1 hit

Notes:
Hits automatically target onto random enemies after targeted enemy dies

#### Triple Support
Overkill damage is converted to a damage buff for next turn. For now, just do 1-for-1 scaling
May be better to make the overkill required to increase damage scale - 1 overkill for first point of strength, 2 overkill for second point of strength, 3 overkill for fourth point of strength.

#### Quint Special
Ideas:
- Every attack hits an additional random enemy (better multi-target coverage)
- +1 damage (self-synergy to beef up damage, but not always optimal if you're playing for max. hits)


### Knight
Support character that can incrementally boost power within a fight or cash in a persisting resource to mitigate damage.

#### Leader Effects
Base:
1 hit for 1 damage

Scaling:
+1 damage

Notes:
Better against enemies that soak damage points with defense. Doesn't scale great with buffs, meant to be a mediocre offensive choice.

#### Triple Support

Alternative idea: Just give the player +1 defense for the turn. Mitigates damage from all incoming hits. 

Could also play around with grey health concepts - make everything scratch damage that is recoverable.

#### Quint Special
Heroic Intervention: Every enemy damaged by this action will target the knights with their current action.

Attacks spent striking knights remove one of their shield counters, but have no other effect.

If all shield counters are gone, the knights cannot absorb any more hits - this ability is disabled (needs to be greyed out or something).


### Wizard
Multi-target specialist that reward explosive, high-aggresion play

#### Leader Effects
Base:
0 damage

Scaling:
+Level damage

Notes: starts weak, but scales very well with large point totals.

#### Triple Support
Every hit of the attack deals 1 damage to every enemy. Maybe armor-piercing, maybe not. Need to test it to see how it plays.

#### Quint Special
Effects of attack are applied to every enemy.

Great effect in multi-target fights, but requires the player to come up with words that feature hefty letters and many mages (not so explosive if you're reliant on blank tiles to get through)


### Priest

#### Leader Effect
Base:
2 holy damage (extra effective against undead)

Scaling:
Recover some grey health

#### Triple Support
Rallying Cry: applies a persisting (non-expiring) buff to the player for the duration of current combat. Increases 'point value' of all blank tiles by 1.

May need a boost in power, but the idea is that using priests consistently across the fight will make your free blank tiles actually contribute to others' scaling power.

#### Quint Special
Recovery from leader effect is repeated for the next 2 turns. 

Alt. idea: a defensive effect that protects your grey health? Maybe can be done in addition to the regen.


### Alchemist
Double effects of gold / silver tiles?

Accrue more points when using their special

Base action applies debuff or something, not so good for raw damage.


### Mime / Troubadour
Mimicry - extends all buffs & effects from this turn into the next turn