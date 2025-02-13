struct Location {
    let name: String
    let description: String
    var exits: [String: String] // Direction: Location Name
    var item: String?
    var npc: String?
}

enum GameState {
    case playing
    case won
    case lost
}

protocol Interactable {
    func interact(with item: String?, context: AdventureGameContext)
}

struct TheShatteredKingdom: AdventureGame, Interactable {
    var title: String {
        return "The Shattered Kingdom"
    }

    private var currentLocation: String = "Ruined Village"
    private var inventory: [String] = []
    private var gameState: GameState = .playing

    private var locations: [String: Location] = [
        "Ruined Village": Location(
            name: "Ruined Village",
            description: """
            You stand amidst the remnants of a once-thriving village. Collapsed rooftops, scorched beams, and a whispering wind make it clear that time has long forgotten this place.
            A hooded merchant sits beside a crumbling stone wall, his rickety cart filled with relics from a lost age.
            """,
            exits: ["east": "Enchanted Forest", "south": "Crystal Caverns", "west": "Dark Tower"],
            item: nil,
            npc: "Merchant"
        ),
        "Enchanted Forest": Location(
            name: "Enchanted Forest",
            description: """
            The forest is dense, almost unnatural. The gnarled trees twist towards the sky, their bark etched with ancient symbols. A thick mist swirls at your feet, and silence grips the air.
            In the clearing ahead, a massive stone guardian stands before a pedestal. Upon it rests a fragment, glowing with a pale silver light.
            """,
            exits: ["west": "Ruined Village"],
            item: nil,
            npc: "Forest Guardian"
        ),
        "Crystal Caverns": Location(
            name: "Crystal Caverns",
            description: """
            You descend into a cavern of breathtaking beauty. The walls shimmer with an eerie blue glow, illuminating the jagged formations of crystal that stretch into the darkness.
            At the cavern’s center, a glowing crystal pillar holds the second fragment. Shadows flicker at the edges of your vision.
            """,
            exits: ["north": "Ruined Village"],
            item: "Right Fragment",
            npc: "Shadow Beasts"
        ),
        "Dark Tower": Location(
            name: "Dark Tower",
            description: """
            A storm rages above as you ascend the spiral staircase of the Dark Tower. Torches flicker, casting long shadows on the stone walls.
            At the summit, the Dark Sorcerer waits. His eyes burn like embers beneath his hood, and his presence fills the air with an oppressive weight blocking your path to the Heartstone Chamber.
            """,
            exits: [:],
            item: nil,
            npc: "Dark Sorcerer"
        ),
        "Heartstone Chamber": Location(
            name: "Heartstone Chamber",
            description: """
            A dark, pulsating chamber lies before you, the walls lined with shattered stone and remnants of a once-glorious kingdom. In the center, a massive pedestal holds the Heartstone, waiting to be restored.
            The fragments you carry hum with energy, eager to be united.
            """,
            exits: [:],
            item: nil,
            npc: nil
        )
    ]

    // Game Logic

    mutating func start(context: AdventureGameContext) {
        context.write("""
        You wake up in the ruins of Eldor, a kingdom lost to time and shadow. A note in your hand reads:
        "The Heartstone was shattered. Two fragments remain—one hidden in the earth, the other in the cursed woods. Find them before darkness consumes all."
        """)
        describeLocation(context: context)
    }

    mutating func handle(input: String, context: AdventureGameContext) {
        guard gameState == .playing else {
            context.write("The game is over. Please reset to play again.")
            return
        }

        let arguments = input.split(separator: " ")
        guard !arguments.isEmpty else {
            context.write("Please enter a command.")
            return
        }

        switch arguments[0] {
        case "help":
            helpCommand(context: context)
        case "north", "south", "east", "west":
            move(direction: String(arguments[0]), context: context)
        case "take":
            takeItem(context: context)
        case "use":
            useItem(context: context)
        case "talk":
            talkToNPC(input: String(arguments.dropFirst().joined(separator: " ")), context: context)
        default:
            context.write("Invalid command. Type 'help' for a list of commands.")
        }
    }

    // Helper Methods

    private mutating func describeLocation(context: AdventureGameContext) {
        guard let location = locations[currentLocation] else { return }
        context.write(location.description)
        if let item = location.item {
            context.write("A \(item) lies here.")
        }
        if let npc = location.npc {
            context.write("You see \(npc) here.")
        }
    }

    private mutating func move(direction: String, context: AdventureGameContext) {
        guard let location = locations[currentLocation] else { return }
        
        if let nextLocationName = location.exits[direction] {
            currentLocation = nextLocationName
            describeLocation(context: context)
        } else {
            context.write("You can't go that way.")
        }
    }

    private mutating func takeItem(context: AdventureGameContext) {
        guard let location = locations[currentLocation], let item = location.item else {
            context.write("There's nothing to take here.")
            return
        }
        inventory.append(item)
        context.write("You take the \(item).")
    }

    private mutating func useItem(context: AdventureGameContext) {
        if currentLocation == "Heartstone Chamber" {
            if inventory.contains("Left Fragment") && inventory.contains("Right Fragment") {
                context.write("You place the fragments on the pedestal. The Heartstone comes together, radiating pure light.")
                context.write("The darkness lifts, and the kingdom is restored!")
                context.write("✨ You have won! ✨")
                gameState = .won
                context.endGame()
            } else {
                context.write("The Heartstone requires both fragments to be restored. The darkness consumes you. Game Over.")
                gameState = .lost
                context.endGame()
            }
        } else {
            context.write("There is nothing to use here.")
        }
    }

    private mutating func talkToNPC(input: String, context: AdventureGameContext) {
        guard let location = locations[currentLocation], let npc = location.npc else {
            context.write("There is no one to talk to here.")
            return
        }

        switch npc {
        case "Merchant":
            if inventory.contains("Left Fragment") && inventory.contains("Right Fragment") {
                context.write("""
                🧔🏻 Merchant: "You have both fragments! Go west to the Dark Tower to find the Heartstone Chamber and restore the Heartstone. The kingdom's fate rests in your hands."
                """)
            } else if inventory.contains("Left Fragment") {
                context.write("""
                🧔🏻 Merchant: "You have the Left Fragment. The Right Fragment lies south, in the Crystal Caverns. Be cautious, the Sorcerer’s power grows stronger."
                """)
            } else if inventory.contains("Right Fragment") {
                context.write("""
                🧔🏻 Merchant: "You have the Right Fragment. The Left Fragment is in the Enchanted Forest to the east. Be brave, the guardian awaits."
                """)
            } else {
                context.write("""
                🧔🏻 Merchant: "Two fragments remain. Seek the Forest Guardian in the east, and the Caverns to the south. But beware—the Sorcerer still waits."
                """)
            }
        case "Forest Guardian":
            if inventory.contains("Left Fragment") {
                context.write("🦊 Guardian: You have what you need. Go now.")
            } else {
                context.write("""
                🦊 Guardian: "I see you seek the fragments. Take the Left Fragment and be on your way."
                """)
                locations["Enchanted Forest"]?.item = "Left Fragment"
                context.write("You see the Left Fragment.")
            }
        case "Shadow Beasts":
            context.write("The shadows hiss and lunge at you. You barely escape with your life.")
        case "Dark Sorcerer":
            if inventory.contains("Left Fragment") && inventory.contains("Right Fragment") {
                context.write("""
                🧙🏻‍♂️ Sorcerer: "You have both fragments... but it’s still too late!"
                """)
                context.write("""
                The Dark Sorcerer glares at you, confident that his power is still too great to be defeated. But the fragments in your possession glow with an intense light. 
                The light grows, overwhelming him with its pure energy.
                """)
                context.write("""
                The Sorcerer is consumed by the light and vanishes in a burst of shadows.
                The path to the Heartstone Chamber is now open.
                """)
                locations["Dark Tower"]?.exits["west"] = "Heartstone Chamber"
            } else {
                context.write("🧙🏻‍♂️ Sorcerer: \"You are too late. The darkness is eternal.\"")
                gameState = .lost
                context.endGame()
            }
        default:
            break
        }
    }

    private func helpCommand(context: AdventureGameContext) {
        context.write("Available commands: north, south, east, west, take, use, talk, help")
    }

    func interact(with item: String?, context: AdventureGameContext) {}
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
TheShatteredKingdom.run()

