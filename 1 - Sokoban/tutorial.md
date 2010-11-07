# Bloxley

Bloxley is a game framework designed for creating 2D, grid-based puzzle games like Sokoban, Tetris, and Bejewelled.  By allowing you to describe the game at a high level, you can focus on what makes your game unique.  Bloxley is an MVC framework, meaning that the code is broken into three main layers--Model classes describe the state of the game, View classes display the game, and Controller classes handle the game logic.

Bloxley is designed to make it so advanced features like undo and animation come free (or mostly free), and make it easier to create level editors, and loading from and saving to XML on servers. Currently, Bloxley is only implemented in ActionScript 3, although an older version exists in ActionScript 2, and hopefully I'll eventually create an Objective-C port.

Parts of this tutorial will seem like hand-waving--many of the complexities are handled by the framework.  How all of the pieces work, and how to take advantage of them, will be covered in more detail in later tutorials.  Until then, just sit back and relax; it'll all make sense eventually.

## The Game

The game we're implementing for this tutorial is Sokoban, the classic game of pushing around boxes in a warehouse.  For those unfamiliar with the game, you can check out our stopping point below.  Click on the game to begin:

<object width="640" height="384">
  <param name="movie" value="http://bloxley.net/wp-content/uploads/2010/11/Sokoban.swf"></param>
  <embed src="http://bloxley.net/wp-content/uploads/2010/11/Sokoban.swf"
  type="application/x-shockwave-flash" allowfullscreen="false"
  width="640" height="384"></embed>
</object>

The basic rules to Sokoban are as follows:

1. You can move workers around a grid, one square at a time.
2. Only one worker moves at a time.
3. Workers can push one block.
4. The goal is to get all of the blocks onto special target squares.

## Games in Bloxley

Before we get started, let's go over the basic structure of Bloxley games.  You'll notice that every class in Bloxley is prefixed with BX.  Bloxley games all take place on a 2-dimensional grid, which has 2 separate layers, patches and actors:

### Patches

The bottom layer is made up of patches.  Every grid square corresponds to single patch, which stays fixed.  Patches can be in different states corresponding to what kind of square it is.  In our Sokoban example, the three possible states are:

1. Floor, for empty floor squares that can be walked upon.
2. Wall, for squares that cannot be walked upon.
3. Target, they behave like Floors and are the squares that you are trying to push boxes onto.

In the framework, each patch is an instance of BXPatch, and the behavior for patches is contained in a subclass of BXPatchController which you will need to implement.

### Actors

The top layer of the grid is made up of actors.  Actors are the parts of the game that moves around the board during play.  Actors can be any shape or size, and can overlap as well.  In Sokoban, there are two different kinds of actors:

1. Worker, which can move around and push blocks
2. Block, which can't move on its own, and only get pushed by Workers.

In Bloxley, each actor is an instance of BXActor, but since their behavior can be much more complicated, each kind of actor must have its own subclass of BXActorController to contain its logic.

### Controllers

In addition to the actor and patch controllers, you will have to define a game controller--which handles top level information about the game, and possibly one or more interaction controllers--which handle the game flow logic and how the user interacts with the game.  The game controller will be a subclass of BXGame, and the interaction controllers will be subclasses of BXController.

### Keys

The last major concept to understand are **keys**.  A key is a string that represents what type an object or action is.  For instance, every patch has a key that indicates what kind of patch it is--we'll use "Floor" for floor patches, "Wall" for wall patches, and "Target" for target patches.  Actors also have keys, as do other kinds of objects that we'll discuss in later tutorials.

## Implementing Sokoban

Okay, so now we have a basic idea of the pieces, let's get started.  Our plan of attack is as follows:

1. Setting up the project
2. Get the board to appear.
3. Get the workers to appear.
4. Getting workers to move around.
5. Get the blocks to appear, and get pushed around.
6. Implementing the winning condition.

### Step 1: Setting up the project

Let's get started. Start by downloading Bloxley from github here: [Bloxley's page on GitHub](http://github.com/mark/Bloxley), or from [the downloads page]( http://bloxley.net/downloads/), and download the Sokoban graphics we'll use here: [Sokoban Graphics](https://s3.amazonaws.com/bloxley_tutorials/1/SokobanGraphics.fla).

Next in Flash create a new ActionScript 3 project called Sokoban, and add `$LOCALDATA` and the location of your `bloxley` directory to the classpath.
  ![Go to the Publish Settings window](https://s3.amazonaws.com/bloxley_tutorials/1/PublishSettings.jpg)
  ![Setting the classpath](https://s3.amazonaws.com/bloxley_tutorials/1/ActionScriptSettings.jpg)

Then copy the resources from the library provided into your project library.

Also, adjust the size of the .swf file so that it's 608px x 352px, and the frame rate so that it's 30 fps.
  ![Adjusting the flash size](https://s3.amazonaws.com/bloxley_tutorials/1/AdjustSize.jpg)

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

That seems simple enough.  Our game controller is a subclass of `BXGame`, and that requires the flash `Stage` object (which is the root of all movie clips in a flash program).

Next we need to define a patch controller, which will know how to create and display patches as they are needed.  So in your `sokoban` directory, create a new file called `SokobanPatchController.as` and insert the following code:

    package sokoban {
    
        import bloxley.controller.game.*;
        import bloxley.model.game.*;
        
        public class SokobanPatchController extends BXPatchController {
            
            public function SokobanPatchController(name:String, game:BXGame) {
                super(name, game);
                
                tiles({ Floor: " @$", Wall: "#", Target: ".+*" });
            }
    
        }
    
    }

This does something a little more interesting--it defines several tiles.  In Bloxley, a tile is a way to map the kind of patch (its **key**) to the characters that represent it in a level file.  So this means, when loading a level a ' ', '@', or '$' will all create a Floor patch.  (The '@' and '$' will represent a floor patch with a worker, and floor patch with a block, respectively).

Next we need to make sure that the Flash graphics will properly link to the code.  This has 2 parts:

1. In the Linkage Properties panel for the movie clip named "Patch", ensure that the Class is set to `game.Patch`
  ![Setting the clip class](https://s3.amazonaws.com/bloxley_tutorials/1/LinkageProperties.jpg)
  
2. In the Patch movie clip itself, make sure that there is a frame called "Floor", a frame called "Wall", and a frame called "Target"
  ![Setting the frame name to match with the Patch keys](https://s3.amazonaws.com/bloxley_tutorials/1/FrameName.jpg)

Bloxley knows to look for a movie clip with class `game.Patch` when creating movie clips for Patches, and it looks for the frame with the same name as the patch clip.  By setting those up, Bloxley can properly render the Patches.  This will be set in the provided graphics pack, but will need to be set if you use your own graphics.

Now that we've created a controller, we need to tell the Sokoban game about it.  Insert the following line into the BXGame constructor at the end:

    controllers({ Patch: SokobanPatchController });

This tells Bloxley that we want a patch controller which is an instance of `SokobanPatchController`.

So now we need to instantiate a Sokoban game, and give it a sample level to render.  Insert the following code into the Frame Actions for `Sokoban.fla`

    import sokoban.*;
    
    var game = new SokobanGame(stage);
    
    game.loadLevel([
      "    #####          ",
      "    #   #          ",
      "    #$  #          ",
      "  ###  $##         ",
      "  #  $ $ #         ",
      "### # ## #   ######",
      "#   # ## #####  ..#",
      "# $  $          ..#",
      "##### ### #@##  ..#",
      "    #     #########",
      "    #######        "
    ]);
    
    game.showBank("Main");

This tells Flash that we're creating a new instance of SokobanGame, our top level game controller, and telling that game to load the level we provide.  The level is given as an array of strings--each string represents one row of the level, and each character in the string represents one patch (and possibly some actors).  The call to `showBank()` is because we don't have an interaction controller yet.

When you run the Flash file, assuming everything has been entered correctly, you should get something that looks as follows:
![The game board with patches](https://s3.amazonaws.com/bloxley_tutorials/1/SokobanWithPatches.jpg)

Excellent!  Our board now shows up.

### Step 3: Workers

Now we want to get workers to show up.  The level we've created includes a single worker, although multiple workers are possible.

Like we had to for the patches, we need to define a new controller--but in this case, we're defining a subclass of `BXActorController`.  Create a new file in the `sokoban` directory called `SokobanWorkerController.as` and include the following code:

    package sokoban {
        
        import bloxley.controller.game.BXActorController;
        import bloxley.model.game.BXActor;
        
        public class SokobanWorkerController extends BXActorController {
    
            public function SokobanWorkerController(name, game) {
                super(name, game);
                
                setBoardString("@+");
            }
            
            override public function key(options = null):String {
                return "Worker";
            }
            
        }
    
    }

So what does this code do?  Well, there are three things to notice.

First, we're calling `setBoardString()`.  This function works similar to `tiles()`--it defines what characters on the level will generate a worker.  In this case (as we discussed above), '@' and '+' characters will generate workers.

Next, we define the `key():String` method.  This determines what **key** will be used for workers.  It can take a hash of options, but we don't need that right now.

Now we need to tell the game controller about `SokobanWorkerController`; change the relevant line in `SokobanGameController` to:

    controllers({ Patch: SokobanPatchController, Worker: SokobanWorkerController });
    
Similar to what we did with the patches, ensure the Linkage Class of the 'Worker' movie clip is set to `game.Worker`.  Now when we run our flash file, we see:

![The game with a worker](https://s3.amazonaws.com/bloxley_tutorials/1/SokobanWithWorker.jpg)

### Step 4: Making Workers Move

So now we have a worker. However, it just sits there, not doing anything.  Now we need to turn it into an actual game.

To make a game out of our code, we need to allow user interaction--that requires an interaction controller.  Bloxley includes `BXPlayController`, which is designed to be the starting point for implementing game play.  Right now it's sufficient for our purposes.  So first, let's tell our game controller about it--change the `controllers()` line in `SokobanGameController` to:

    controllers({ Patch: SokobanPatchController, Worker: SokobanWorkerController, Play: BXPlayController });

Now that we have a game controller, we need to enable it.  After the controller line, insert:

    setCurrentGameController("Play");

And since we don't need it any longer, remove the `game.showBank()` line from the Frame Actions in Flash.
    
This will enable us to move units around, but we need to tell Bloxley what units can be moved.  So in `SokobanWorkerController`, add the following method:

    override public function canBePlayer(actor:BXActor):Boolean {
        return true;
    }

This determines whether an actor can be selected to be directly controlled by the user.

Now when we run Sokoban, we can move our worker around using the arrow keys!  Notice that its movement is fully animated.  For another neat trick, if you hit Backspace, then you'll undo your last move.  And if you hit Shift+Backspace, you'll restart the board!  Like animation, undo is something that is very easy to do with Bloxley.

However, we have a slight problem.  Our worker can walk straight through walls.  This is really not what we want.

To get around this, we need to tell the patch controller about movement through walls.  When a Worker tries to walk into a patch of type Wall, the function `canWorkerEnterWall()` is called on the patch controller.  This method can be implemented to define what should happen.  Insert the following method into the `SokobanPatchController` class:

    public function canWorkerEnterWall(action, source:BXActor, target:BXPatch) {
        action.fail();
    }

In this method, `action` is the worker's attempt to walk onto a wall.  By telling Bloxley that that attempt should fail, we prevent workers from walking on walls.  Re-run the flash file and have the worker move around.  You'll notice that it cannot step onto the wall patches.

### Step 5: Blocks

In this step, we're introducing another type of actor--blocks.  Since the process is similar to what we did for workers, I'll go through the steps more quickly:

1. Create a file in the `sokoban` directory called `SokobanBlockController.as` and insert the following code:

    package sokoban {
    
      import bloxley.controller.game.*;
      import bloxley.model.game.*;
      import bloxley.controller.event.BXMoveAction;
      
      public class SokobanBlockController extends BXActorController {
      
        public function SokobanBlockController(name, game) {
            super(name, game);
            
            setBoardString("$*");
        }
        
        override public function key(options = null):String {
            return "Block";
        }
          
      }
    
    }

2. Make sure that the movie clip in the flash library named "Block" has its Linkage Class set to `game.Block`.
3. Update the `controllers()` line in the `SokobanGameController` to read:

    controllers({ Patch: SokobanPatchController, Worker: SokobanWorkerController, Play: BXPlayController, Block: SokobanBlockController });

Now when you run the flash file, it should look like this:

![Board with Blocks](https://s3.amazonaws.com/bloxley_tutorials/1/SokobanWithBlocks.jpg)

And by playing around with it, you'll notice the next problem: our worker can't interact with the blocks in any way.  Luckily, this is easy to remedy.  When a worker tries to step onto a block, the method `canBeSteppedOnByWorker()` gets called on the block controller.  By implementing this method, we can tell Bloxley what should happen in this situation.  Insert the following code into `SokobanBlockController`:

    public function canBeSteppedOnByWorker(action:BXMoveAction, block:BXActor, player:BXActor) {
      action.causes(new BXMoveAction(block, action.direction()));
    }

Now when we re-run the flash file, our worker can move around and push blocks--but only 1 block at a time!  Excellent!

In Bloxley, all changes to the state of the game are handled through actions--subclasses of `BXAction`.  By telling Bloxley one action is _caused_ by another, then they succeed or fail together.  So stepping onto a block causes that block to move in the same direction--in other words, the worker pushes the block.  If that push is impossible (like trying to push onto a wall or another block), then the worker's move fails as well.  We'll get into a lot more depth on actions in later tutorials.

Once more a problem presents itself.  Our worker can push the blocks too well--the blocks can be pushed right onto the walls!  There's two ways to remedy this situation.  We could define a method named `canBlockEnterWall()` in the `SokobanPatchController`, like we did for the workers.  However, there is an easier way--instead of defining a second method, we can make our existing method more general.  By changing the name of the method from `canWorkerEnterWall()` to `canEnterWall()` (leaving out the **key** of the object trying to enter the wall), this method will handle _any_ actor trying to step onto a wall.

Now re-run the flash file.  Play around with it--you'll see that you can move the worker around, and have him push the blocks.  Notice that when you undo an action (Backspace or Shift+Backspace), it properly replaces the blocks as well!  Even if you move everything around, completely changing the board, one quick tap of Shift+Backspace will completely restart the board to its initial position.

### Step 6: Completing a Level

Now that we can play the game, we need to tell Bloxley how the game is won.  First, look back on the code that's in place.  While we've had a long discussion to get here, we really didn't need to implement very much code--but we got a lot of behavior out of it.  Our last step is: we need bloxley to recognize when we've won.

Luckily for us, this won't really require more work that anything else we've done has, but I have to admit, it does involve a slight bit of cheating.  See, Bloxley can handle pretty much any grid-based game, but its primary focus is games like Sokoban--games that involve player characters moving around the grid and interacting with the patches and actors.  So while the game flow can be changed to handle real-time games like Tetris, and games with no clear player characters like Bejeweled, you get Sokoban-like behavior for free out of the box!

So how does this work?  There's a series of 7 methods that get called on the play controller, to walk the game through the gameplay.  Here's a list:

1. `startGame()`--this gets called when the game begins.
2. `validUserActions()`--this returns a list of methods that indicate that the player has made a move.
3. `heartbeat()`--this gets called after the player makes a move.
4. `didBeatLevel()`--this is used to test whether the player has beat the level.
5. `didLoseLevel()`--this is used to test whether the player has lost the level.
6. `beatLevel()`--this get called when the player does beat the level.
7. `lostLevel()`--this get called when the player does lose the level.

That's a lot of methods!  However, we don't have to implement all of them--most have built-in behavior that will be good enough for us, and some games (like Sokoban!) can't be explicitly lost.  So let's get started!

First, since we're going to be defining custom behavior, we need a place to define it.  That means just using an instance of `BXPlayController` isn't good enough anymore--we need our own subclass.  Create a file in the `sokoban` directory called `SokobanPlayController`, and insert the following code:

    package sokoban {
        
        import bloxley.controller.game.*;
        
        public class SokobanPlayController extends BXPlayController {
            
            public function SokobanPlayController(name: String, game:BXGame) {
                super(name, game);
            }
            
    	    override public function didBeatLevel():Boolean {
                return board().allActors().ofType("Block").areAllGood();
        	}
        	
        }
    }
    
Yes, we really only did need to implement one of the methods listed above.  Phew!  Let's run through the list and discuss why we skipped them:

1. `startGame()`--the default behavior is to select the first actor that can be a player, which is what we want.
2. `validUserActions()`--the default behavior is to return just "moveCharacter", which is the only kind of user action that we care about.
3. `heartbeat()`--by default this does nothing, which is okay.
4. `didBeatLevel()`--by default this just return false, which is why we needed to override it.
5. `didLoseLevel()`--this also defaults to returning false.  Since Sokoban can't be "lost", we never need it to return anything else.
6. `beatLevel()`--this performs a game over animation, which we'll discuss below.  Good enough.
7. `lostLevel()`--since Sokoban can't be lost, this will never get called.

We also need to tell our game controller about our new class.  So in `SokobanGame.as` replace the call to `controllers()` with:

    controllers({ Patch: SokobanPatchController, Worker: SokobanWorkerController, Play: SokobanPlayController,
      Block: SokobanBlockController });

Now let's look a little closer at the implementation of the `didBeatLevel()` method; it should be readable as to what it's doing.  First, it gets the `gameboard()`.  Then it gets all of the actors on the board of type **Block**.  Finally, it checks to see if they're all "good", whatever that is.

What is "good", you ask?  Really, "good" can be anything.  It's just a placeholder that bloxley allows, to make it easier for actors to indicate when the think the level is over.  Right now, it doesn't mean anything, since we haven't told Bloxley anything yet.  So let's talk about what it _should_ mean.

What does it mean to beat a level in Sokoban?  The goal is to get all of the blocks onto target squares.  So it would make sense to implement "good" for a block to mean that it is standing on a target patch.  Since it is part of the game logic, it needs to be placed in a controller; the actor controller `SokobanBlockController` seems like the obvious place it belongs.  Open up `SokobanBlockController` and insert the following method into the class:

    override public function isGood(actor:BXActor):Boolean {
        return actor.amIStandingOn("Target");
    }

As you can see, the `isGood()` method takes in a single parameter--the actor in question--and returns true or false.  As we discussed above, a block is "good" if it is on top of a target patch, and `amIStandingOn()` takes care of that.

Well, that was pretty easy.  Sure, it involves a shortcut--but there's a huge list of games that this basic gameflow will cover.

One final thing to discuss--what happens when we win the game?  As I said above, the method `beatLevel()` gets called, which shows a "You Won" image.  While (as always) this behavior can be overridden, it's good enough for now.

Now to actually generate the "You Won" image, insert the following method into `SokobanPlayController`:

    override public function createInterface() {
        super.createInterface();
        
        var screen = BXSystem.screenDimensions();
        
        setBank("Beat Level");
            var image = new BXImage(this, "BeatLevel", { centered: true, depth: 1 });
            image.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
            register( image );
        
    }

We'll hold off on discussing the details of this method until a later tutorial, but if you read it, you should be able to tell that it generates an image, and places it into the center of the screen.  A _bank_ ("Beat Level" in this case) is just a group of interface elements like buttons, images, and the game grid itself.  Make sure that the Linkage Class for your winning banner is set to `game.BeatLevel`.  Again, it's already set in the provided graphics, but if you decide to change them, you'll have to make sure that this is set.

Now run our game.  When you get all of the blocks onto the target squares (remove some of the blocks from the level if you want to make things easier), you should get a banner to appear that looks like this:

![You beat the level!](http://s3.amazonaws.com/bloxley_tutorials/1/BeatLevel.jpg)

Congrats!  You have now programmed a complete game!  It has animation, unlimited undo, and lets you know when the game has been won.  Not too bad for a day's work.

## What's Next?

While our implementation of Sokoban is playable, it's pretty bare-bones.  The player is a single, static image.  In our next tutorial, we'll tackle a different game, called Tilox--and we'll talk about how to polish the graphics so it looks more professional.  We'll also talk about some other parts of the Bloxley framework.