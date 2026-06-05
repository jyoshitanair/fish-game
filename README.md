# fish-game
A game where you are a fish just trynna live it out. But its not very easy being a fish '
======================================================================================
FEATURES
	Map: 
		- Shows the player's current position in the open world
		- Zoom in and out using the mouse wheel (clamped at 0.1 minimum - 3.0 maximum)
		- 1 Right click to reset the position and another to reset the zoom settings
		- Shows the NPCS and sharks even as they move!
	Player: 
		- Movement using WASD/Arrow Keys
		- Interact with NPCs using Enter, skip dialog using enter
		- boost using space bar
		-fire a bubble using the E key
		-in the minigame use Q to create a shell
	Tiles:
		- Isometric Design and randomly generated using probability: 
			I drew the tiles yaya :D and this was my first time making isometric tiles - SO much guess and check
			i learned about probabilities and collisions and matching corners and sides to create a terrain set!
	Enemy:
		- Attacks and swims smoothly using lerp
		- Has a start Range and an end range
		- Deals 5-20 damage per hit and take int(randi_range(10,30)*area.get_parent().boostbar) damage per hit :D meaning the 
		amount of damage you do is directly related to how long you charge the attack for! (0.1- 3 seconds)
		- They have 4 states: Normal, Chasing, Attacking and Retreating
		Normal means that the don't see a player in their collision shape range so they just wander picking a 
		random direction with match 
		Chasing means that the player is now detected but not close enough to attack yet. the shark will get closer using lerp to 
		speed up.
		attacking means that the player is close enough to attack and it will lunge forward again with the beloved lerp
		and it will deal damage if it hits
		after it attacks it returns to its original position and retreats
		there are also timers to switch directions randomly every once in a while when the shark is in the 
		normal state!
		They are also limited by a world boundary collision shape that only affects shark nodes
		and prevents them from leaving the designated shark area!
		this means that if you swim out far enough they will not be able to chase you again and it makes
		them really easy to kill!
		
		[TO PATCH!!! STACKING ON TOP :(]
	Health Bar:
		- displays as a ui bar and number
		- if you are out of the sharks hitbox then you will begin to progressively
		heal! don't die guys lol
	Attack Bar: 
		Displays as a rectangular cool down for your attack ! 
		The cool down timer starts once the projectile (i call it a bubble gun!)
		has despawned (which it does automatically after a cooldown period or after it hits the shark)
	BoostBar:
		This one shows up as red if you can boost and green if you can't! A boost makes you lunge forward smoothly 
		and there is a cooldown so you can't abuse it. 
	Menus: 
		Start Menu:
			Its such a beautiful UI I know. UwU
			If you hover over the buttons they grow and depending on what menu you are on they might also 
			gain a blue border :D
			If you click start, you start
			If you click settings, you are redirected to settings(see other section)
			If you click rage quit...you just instantly die lol
		Pause Menu:
			This took forever!
			It records the states of what sharks were alive, the player's position, the current NPC, and the players health
			(does not save the boost bar and attack cooldown though...)
			Then it pauses the game and when you click to continue you will return to the same position that you were in before
			again...
			If you click continue, you continue
			If you click settings, you are redirected to settings(see other section)
			If you click rage quit...you just instantly die lol
		Settings Menu: 
			There are three tabs here: 
				1) Return (back to the pause/main menu)
				2) Lore (to learn about the amazing lore behind these little fish goobers :D)
				3) The actual settings
					- here you can change your name! if not your just the honored one (gasp jjk reference?)
					- change the volume
					- change the song
					- annddd toggle the trail hints on and off (although i will say without the trail hints on it's going to take forever to find anything)
		
				
			
======================================================================================
AI USAGE: 
   - ChatGPT for debugging
   - All code and logic written in concept authentically by me
   - All art done by me (Well not YET - rn credits to Kenny from itch io!)

video credit:
	Boyan Minchev on pexels.com
music: underwater symphony_1 by bernivoyage https://pixabay.com/music/pop-underwater-symphony-1-291195/
