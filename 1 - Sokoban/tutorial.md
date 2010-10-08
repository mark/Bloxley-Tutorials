# Bloxley

Bloxley is a game framework designed for creating 2D, grid-based puzzle games like Sokoban, Tetris, and Bejewelled.  By allowing you to describe the game at a high level, you can get more complicated behavior, quicker.  Bloxley is an MVC framework, meaning that the code is broken into three main sections--Model classes describe the state of the game, View classes display the game, and Controller classes handle the game logic.  **More here.**

Bloxley is designed to make it so advanced features like undo and animation come free (or mostly free), and make it easier to create level editors, and loading from and saving to XML on servers. Currently, Bloxley is only implemented in ActionScript 3, although an older version exists in ActionScript 2, and hopefully I'll eventually crate an Objective-C port.

This tutorial will seem like mostly magic--many of the complexities are hidden inside the framework.  How all of the pieces work, and how to take advantage of them, will be covered in more detail in later tutorials.  Until then, just sit back and relax; it'll all make sense eventually.

## The Game

The game we're implementing for this tutorial is Sokoban, the classic game of pushing around boxes in a warehouse.  For those unfamilar with the game, you can check out our stopping point here: **URL**.  The basic rules are as follows:

1. You can move workers around a grid, one square at a time.
2. Only one worker moves at a time.
3. Workers can push one block.
4. If you get all of the blocks onto special target squares, then you beat the level.

## Games in Bloxley

Before we get started, let's go over the basic structure of Bloxley games.  Every class in Bloxley is prefixed with BX, and are heavily organized into packages and subpackages.

Bloxley games all take place on a 2-dimensional grid, which has 2 separate layers:

### Patches

The bottom layer is made up of patches.  Every grid square corresponds to single patch, which does not move.  Patches can be in different states corresponding to what kind of square it is.  In our Sokoban example, the three possible states are:

1. Floor, for empty floor squares that can be walked upon
2. Wall, for squares that cannot be walked upon
3. Target, the squares that you are trying to push boxes onto--but otherwise behave like Floors

In the framework, each patch is an instance of BXPatch, and the behavior for patches is contained in a subclass of BXPatchController which you will need to implement.

### Actors

The top layer of the grid is made up of actors.  Actors are the parts of the game that moves around the board during play.  Actors can be any shape or size, and can overlap as well.  In Sokoban, there are two different kinds of actors:

1. Worker, which can move around and push blocks
2. Block, which can't move on its own, and only get pushed by Workers.

In Bloxey, each actor is an instance of BXActor, but since their behavior can be much more complicated, each kind of actor must have its own subclass of BXActorController to contain the logic for that kind of actor.

### Controllers

In addition to the actor and patch controllers, you will have to define a game controller, which handles top level information about the game, and possiblly one ore more flow controllers, which handle the game flow logic, and how the user interacts with the game.  The game controller will be a subclass of BXGame, and the interface controllers will be subclasses of BXController.

### Keys

The last key concept to understand is **keys**.  A key is a string that represents what type an object or action is.  For instance, every patch has a key that indicates what kind of patch it is--we'll use "Floor" for floor patches, "Wall" for wall patches, and "Target" for target patches.  Actors also have keys, as do other kinds of objects that we'll discuss in later tutorials.

## Implementing Sokoban

Okay, so now we have a basic idea of the pieces, let's get started.  Our plan of attack is as follows:

1. Setting up the project
2. Get the board to appear.
3. Get the workers to show up, and move around.
4. Get the blocks to show up, and get pushed around.
5. Implementing the winning condition.

### Step 1: Setting up the project

Let's get started. Start by downloading Bloxley from github here: [Bloxley's page on GitHub](http://github.com/mark/Bloxley), and download the Sokoban graphics we'll use here: **URL**.  If you're an artist, and want to provide better sample graphics, please email me at McPhage@gmail.com.

Next in Flash create a new ActionScript 3 project called Sokoban, and add `$LOCALDATA` and the location of your `bloxley` directory to the classpath.
!(Go to the Publish Settings window)[https://s3.amazonaws.com/bloxley_tutorials/1/PublishSettings.jpg]
!(Setting the classpath)[https://s3.amazonaws.com/bloxley_tutorials/1/ActionScriptSettings.jpg]

Then copy the resources from the library provided into your project library.  **SAMPLE IMAGES FOR THESE?**

Also, adjust the size of the .swf file so that it's 650px x 400px. !(Adjusting the flash size)[https://s3.amazonaws.com/bloxley_tutorials/1/AdjustSize.jpg]

Finally, we need a package to contain all our custom code, so in the same directory where you saved your `Sokoban.fla` file, create a new directory called `sokoban`.

Now that the project is set up, let's begin coding.

### Step 2: Creating the board

So now we need a game controller.  In the `sokoban` directory, create a new file called `SokobanGame.as`, and insert the following code:

    package sokoban {
        
        import flash.display.Stage;
        
        import bloxley.controller.game.*;
        
        public class SokobanGame extends BXGame {
            
            public function SokobanGame(stage:Stage) {
                super(stage);
            }
    
        }
     
    }

That seems simple enough.  Our game controller is a subclass of `BXGame`, and that requires the flash `Stage` object (which is the root of all movie clips in a flash program).  Right now that's all we're doing--but that's not doing much.

Next we need to define a patch controller, which will know how to create and display patches as they are needed.  So in your `sokoban` directory, create a new file called `SokobanPatchController.as` and insert the following code:

    package sokoban {
    
        import bloxley.controller.game.*;
        import bloxley.model.game.*;
        
        public class SokobanPatchController extends BXPatchController {
            
            public function SokobanPatchController(name:String, game:BXGame) {
                super(name, game);
                
                tiles({ Floor: ".@&", Wall: "#", Target: "$" });
            }
    
        }
    
    }

This does something a little more interesting--it defines several tiles.  In Boxley, a tile is a way to map the kind of patch (its **key**) to the characters that represent it in a level file.  So this means, when loading a level a '.', a '@', or a '&' will all create a Floor patch.  (The '@' and '&' will represent a floor patch with a worker, and floor patch with a block, respectively).

Next we need to make sure that the Flash graphics will properly link to the code.  This has 2 parts:

1. In the Linkage Properties panel for the movie clip named "Patch", ensure that the Class is set to `game.Patch`
  ![Setting the clip class](https://s3.amazonaws.com/bloxley_tutorials/1/LinkageProperties.jpg)
  
2. In the Patch movie clip itself, make sure that there is a frame called "Floor", a frame called "Wall", and a frame called "Target"
  ![Setting the frame name to match with the Patch keys](https://s3.amazonaws.com/bloxley_tutorials/1/FrameName.jpg)

Bloxley knows to look for a movie clip with class `game.Patch` when creating movie clips for Patches, and it looks for the frame with the same name as the patch clip.  By setting those up, Bloxley can properly render the Patches.

Now that we've created a controller, we need to tell the Sokoban game about it.  Append the following line to the end of the BXGame constructor:

    controllers({ Patch: SokobanPatchController });

This tells Bloxley that we want a patch controller which is an instance of `SokobanPatchController`.

So now we need to instantiate a Sokoban game, and give it a sample level to render.  Insert the following code into the Frame Actions for `Sokoban.fla`

    import sokoban.*;
    
    var game = new SokobanGame(stage);
    
    game.loadLevel([
     "....#####..........",
     "....#...#..........",
     "....#&..#..........",
     "..###..&##.........",
     "..#..&.&.#.........",
     "###.#.##.#...######",
     "#...#.##.#####..$$#",
     "#.&..&..........$$#",
     "#####.###.#@##..$$#",
     "....#.....#########",
     "....#######........"
    ]);
    
    game.showBank("Main");

This tells Flash that we're creating a new instance of SokobanGame, our top level game controller, and telling that game to load the level we provide.  The level is given as an array of strings--each string represents one row of the level, and each character in the string represents one patch (and possibly some actors).

When you run the Flash file, assuming everything has been entered correctly, you should get something that looks as follows: