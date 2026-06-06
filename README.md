# Fish

##### A game where you are a fish just trynna live it out. But its not very easy being a fish '

---

### Contents

-[Access](#access)
-[Description](#description)
-[How to play?](#how-to-play)
-[Features](#features)
-[Ai Useage](#ai-useage)
-[Learning](#learning)
-[Credits](#credits)

## ACCESS

---
* **Github Repo:**


* **Itch.io:**
	
## DESCRIPTION
#### Creation Details
---
* by: **jyoshitanair** (github)


* name: **fish** 


* made in: **Godot** Version 4.6.1 Stable gd script



#### Quick Overview
---
This game was super inspired by Genshin Impact and in the future I would love to add more of those cool elements into my game
You are roleplaying as a fish who was abandoned by their terrible owner and just dumped into the ocean. 
You are determined to find your human again and set out on a mission in the huge ocean
Along the way you meet many new friends until you eventually make it back.
But in the end things are not the way that they seem and you head back to the ocean!



## HOW TO PLAY
* follow the hints at the top to know what to do
* attack with l to create a bubble and launch it
* boost with b!
* move with WASD/Arrow Keys
* zoom in and out on the map with the keypad/mouse wheel
* right click on the map once to reset position and twice to reset the zoom
* when in the mini game click q to make a shell
* enter to skip dialog



## FEATURES
* **Map:**
---
1) Shows the player's current position in the open world
2) Zoom in and out using the mouse wheel (clamped at 0.1 minimum - 3.0 maximum)
3) 1 Right click to reset the position and another to reset the zoom settings
4) Shows the NPCS and sharks even as they move! 
5) Clamped to not show extra world :D
6) Utilizes a subviewport and switching between a player camera and mouse camera to keep accurate positioning
* **Player:**
---
1) Movement using WASD/Arrow Keys
2) Interact with NPCs using Enter, skip dialog using enter
3) boost using the B key and there is a cooldown of 3 sec. 
	

	- red when you can't boost, green when you can! 
	- you can not boost when you are not moving. 
	- you will boost in the direction that you were going (works with diagonal movement too) 
4) Fire a Bubble using the L key
	- the bar remains green as long as you can shoot/if there is a bubble in the world
	- when the bubble gets freed a cooldown of 3 secs starts and you can only attack again when it's over
	- it will move in the last 4 way direction you were going in(up,down.left,right) - not diagonal compatible
	- if you are attacking and get attacked the attack will stop and you will have to wait for the cooldown to end again
5) In the minigame use Q to create a shell
	- You can only have one shell at a time
6) Attacks deal 'randi_range(10,30)*area.get_parent().boostbar' damage
	- random int from 10-30 * how long you held the boost bar for (0.1-3.0)
* **NPCS:**	
---
1) 4 unique NPCs - and return back to one
2) all the same code but different paths to return to at the end/unique dialog situations/variables/sprites
3) sorted into unique cutscene scenes
4) enter to skip/fastforward dialog
5) can not pause during this time (you will listen to them yap)
6) Trails to guide you to them!
* **Shark:**	
---
1) Handles movement through 4 states: Normal, Chasing, Attacking and Retreating
	-	Normal means that they don't see a player in their collision shape range so they just wander picking a 
	random direction with match. There are also timers to switch directions randomly every once in a while when the shark is in the 
	normal state! 
	-	Chasing means that the player is now detected but not close enough to attack yet. the shark will get closer using lerp to 
	speed up.
	-	Attacking means that the player is close enough to attack and it will lunge forward again with the beloved lerp
	and it will deal damage if it hits that's a random in from 5-20 (randi_range(5,20))
	-	Retreating means that it has just finished attacking and will return back to the position it was at before the attack. 
	This is to prevent spam attacks that essentially kill you in a few seconds. 
2) Attacks and swims smoothly using lerp
	-Has a start Range and an end range
3) They are also limited by a world boundary collision shape that only affects shark nodes
and prevents them from leaving the designated shark area!
	- 	this means that if you swim out far enough they will not be able to chase you again and it makes
	them really easy to kill! (if you want to take the easy way o|._.|o)
4) Their death is handled in the start file and on pause they store if they are alive in an array and their position
* **Tiles:**
---
- Isometric Design and randomly generated using probability: 
	- I drew the tiles yaya :D and this was my first time making isometric tiles - SO much guess and check
	- i used probabilities and collisions and matching corners and sides to create a terrain set!
* **Health Bar:**
---
1) displays as a Bar and Number
2) if you are out of the sharks hitbox then you will begin to progressively
heal! don't die!
3) Once you've been hit once though it will never go back up to 100 :O
* **Attack Bar:**
---
1) Displays as a rectangular cool down for your attack ! 
2)The cool down timer starts once the projectile (i call it a bubble gun!)
has despawned (which it does automatically after a cooldown period (3 sec) or after it hits the shark)
3)This is a Texture Progress Bar
4) Shows up as green if there is a bubblegun in effect or if you can use the bubble gun
5) Shows up as grey during the cooldown period. 
* **Boost Bar:**
---
1)Shows up as red if you can boost and green if you can't! 
2)A boost makes you lunge forward smoothly and there is a cooldown(3 sec) so you can't abuse it. 
* **Start Menu:**
---
* Its such a beautiful UI I know. UwU
* It has a super cool fish video on it
* If you hover over the buttons they bold
* If you click start, you start
* If you click settings, you are redirected to settings(see settings section)
* If you click rage quit...you just instantly die lol
* **Pause Menu:**
---
* This took forever!
* You can pause as long as you are not inside dialog (including in the mini game!)
* It records the states of what sharks were alive, the player's position, the current NPC, the shell position, and the players health
(does not save the boost bar, attacks, ect though)
* Then it pauses the game and when you click to continue you will return to the same position that you were in before
* If you click continue, you continue
* If you click settings, you are redirected to settings(see settings section)
* If you click rage quit...you just instantly die lol
* **Settings Menu:**
---
There are three tabs here: 
1) Return (back to the pause/main menu)
2) Lore (to learn about the amazing lore behind these little fish goobers :D)
3) The actual settings
	- here you can change your name! if not your just the honored one (gasp jjk reference?)
	- change the volume
	- change the song
	- annddd toggle the trail hints on and off (although i will say without the trail hints on it's going to take forever to find anything)
* **Mini Game:**
1) A very simple minigame that I implemented
2) Sharks
	- Same attack/retreat/normal/chasing states. 
	- Have an additional state of chasing after the shell and will return to states after a cooldown of 5 sec
3) Player
	- move with WASD/ARROW
	- create a shell (max one) and 
4) The goal is to apply pressure onto the two blue plates (by using yourself, the sharks, or the shell) to escape!
5) New music for this scene and if you are close to the shells you will hear bubbling!


## AI USAGE: 
* ChatGPT and Gemini for debugging, for example:
	- to learn about keyboard ghosting
	- helping to switch organize the shark attack states
	- helping to learn about efficently camera switch
	- helping to learn the scaling algorithm used in the dialog and npc files
	- and just general debugging!
* But in the end all code and concepts are written authentically by me!
* All the art is done by me (<3 i hope you likee itt) and the music is not Ai generated lol
* And of course this read me is written by the one and only me :D

## LEARNING:
	
#### *After all after literally spending 70+ hours on this I must have learned something right?*

---

### Learned:
---
1) I learned more about formatting md files and honestly this might be my best one yet!
2) I learned how to switch between music - and I definetly used it a lot in my project!
3) More about using a Global file - such as the getter and setter functions when trying to find by variables
4) Adding videos to godot? I didn't know that was possible and its super cool!
5) Attack states! :D if I ever make more enemies I love how my sharks have four states and it made it sooo much easier to code than checking by distance every time!
6) Strengthened knowledge on switching scenes, finding nodes, and dynamically deleting and storing information (for the pause menu so that when you return everything is the same)
7) How to use the Texture Progress Bar! (the attack cooldown at the bottom)
8) Using a subviewport/subview for the first time! (for the mini-map)
9) Creating reusable files for things like dialog, npcs, sharks, ect that heavily relied on export vars :D
10) Making/setting up Isometric tiles (I really want to try true isometric tiles in the future too!)

#### Struggles :
	
---
1) **The shark.** This took forever and every time something worked the other wouldn't! I really had to get
organized with this one for it to work. It would spam attack, delete on spawn, or just respawn after pausing! 
This took days to get right and was a struggle from the start to the end. It was also very difficult to connect the 7 sharks
to trail :(
2) **The map.** Switching between cameras was very difficult for me because I needed one on the player and one on the mouse
but Godot only allows one current camera! I also struggled to get the map to scale the same as in the real world or even actually
display the npcs/sharks/player! And most of all I struggled to restrict the camera's view so it only showed the world! With two cameras and
scaled down/up nodes everywhere this was a guess and check process! 
3) **The Pause Menu** Because why doesn't Godot have a pause scene (not tree) function! I had to manually store the positions, and data
of the nodes and dynamically connect multiple files (mainly fish,shark,and start) to return to how it was at the start
4) **The NPCS...** They had a bunch of stuff in common but also so much *not* in common (a paradox...) and multiple unique situations.
I struggled to have the order working with the trails and returning to bobu at the end! I also struggled to get the nodes to all become the
same size and the little circle with their sprite in it to show up!

*...and more but those are the big ones*


## CREDITS

####*because I didn't do everything myself!*

---
1) Fonts
* Untitled Font by luzwick, https://www.fontspace.com/untitled-font-f30368
* Handwriting Font by princess, https://www.fontspace.com/handwriting-font-f10680
* Battle Bingo by zeenesia studio, https://www.fontspace.com/battle-bingo-font-f67643
* Touch of Nature by Unauthorized Type, https://www.fontspace.com/touch-of-nature-font-f9784
2) Music
* Underwater - Audiopanther by igorovsyannykov, https://pixabay.com/music/upbeat-underwater-audiopanther-311437/
* Underwater symphony_1 by bernivoyage, https://pixabay.com/music/pop-underwater-symphony-1-291195/
* Vocaloid Electroswing Noir -- Creepy Alt-Pop by ChrisDjYogi, https://pixabay.com/music/pop-vocaloid-electroswing-noir-creepy-alt-pop-439236/
* Water | Afro-pop Music by kontraa, https://pixabay.com/music/afrobeat-water-afro-pop-music-445661/
*Bubbling by Infernus2(freesound), https://pixabay.com/sound-effects/nature-bubbling-6184/
*Underwater Cavern by Purrple Cat, https://pixabay.com/music/beats-underwater-cavern-482364/ 
3) Videos
* Boyan Minchev on pexels.com, https://www.pexels.com/video/fishes-and-plants-in-aquarium-13320467/

*Made with 💖 by jyoshita!*
