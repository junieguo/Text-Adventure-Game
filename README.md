# *The Shattered Kingdom*

*For instructions, consult the [CIS 1951 website](https://www.seas.upenn.edu/~cis1951/25sp/assignments/hw/hw1).*

## Explanations

**What locations/rooms does your game have?**

1. **Ruined Village**  
   - Description: A village in ruins, home to an old merchant.  
   - Exits: East to *Enchanted Forest*, South to *Crystal Caverns*, West to *Dark Tower*.

2. **Enchanted Forest**  
   - Description: A mystical forest with gnarled trees and ancient symbols. A forest guardian guards one of the fragments.  
   - Exits: West to *Ruined Village*.

3. **Crystal Caverns**  
   - Description: A shimmering cavern where the second fragment of the Heartstone is hidden.  
   - Exits: North to *Ruined Village*.

4. **Dark Tower**  
   - Description: A stormy tower where the Dark Sorcerer awaits.  
   - Exits: West to *Heartstone Chamber* only if the Dark Sorcerer is defeated.

5. **Heartstone Chamber**  
   - Description: The final chamber, where the Heartstone can be restored using both fragments.  
   - Exits: None.

**What items does your game have?**

1. **Left Fragment**  
   - Located in: Enchanted Forest  
   - Description: One half of the shattered Heartstone.

2. **Right Fragment**  
   - Located in: Crystal Caverns  
   - Description: The other half of the shattered Heartstone.

**Explain how your code is designed. In particular, describe how you used structs or enums, as well as protocols.**

- **Structs:**  
  - `Location`: Defines the characteristics of a location, such as its name, description, exits, items, and NPCs.
  - `TheShatteredKingdom`: This is the main game structure that implements the `AdventureGame` protocol and contains the game logic.
  
- **Enums:**  
  - `GameState`: Tracks the state of the game (whether the player is playing, has won, or lost).
  
- **Protocols:**  
  - `Item': Defines the common properties and methods that any in-game item must have. It ensures that every item has a name, description, and two key behaviors:

    1. take(context: AdventureGameContext) – Action for picking up the item.
    
    2. use(context: AdventureGameContext) – Action for using the item (though in the case of some items like Fragment, the behavior is predefined and context-specific).


**How do you use optionals in your program?**

Optionals are used to handle cases where an item or NPC might not exist in a particular location. For instance:
- `Location` has optional properties such as `item` and `npc`, because not all locations will have an item or NPC to interact with.


**What extra credit features did you implement, if any?**

N/A

## Endings

### Ending 1

east

take

west

south

take

north

west

talk

west

use

### Ending 2
south

take

north

west

talk
