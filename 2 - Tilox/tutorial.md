# Tilox

Okay, now we know how to make a basic game using Bloxley.  But, the game that we made... isn't very impressive looking.  Our workers are animated, but they just slide from place to place, with the same static image.  That's not cool.  So for our second tutorial, we're going to work on polishing the game.

Since our focus is on improving the animations, we're going to implement a pretty simple game.  Simple, but still interesting.  I've seen it called "Hock", and "Tilox", and has at least two implementations on the web: [Tilox by Lightforce Games](http://www.andkon.com/arcade/lightforce/tilox.php), and [Hock by Lutz Tautenhahn](http://www.lutanho.net/).  It seems Hock is the original name, but I first saw it as Tilox, so that's what we'll call it here.

In Tilox, you have player characters that can either (a) move from one square to an adjacent square, or (b) jump over an adjacent square to land on the next square over.  When a character leaves a square, that square disappears.  When there's only one square left, you win--but if you jump off into nothingness, you lose.

You can see our implementation below.  The arrow keys will move the character, and holding down Shift while hitting the arrow keys will cause the character to jump.  Like with Sokoban, Delete will undo and Shift+Delete will reset the board.  Also, Space will switch between characters; none of the original levels include that feature, but it's pretty easy to do with Bloxley, so we'll include it a bit later.

<object width="256" height="256">
  <param name="movie" value="flash/tilox.swf"></param>
  <embed src="flash/tilox.swf"
  type="application/x-shockwave-flash" allowfullscreen="false"
  width="256" height="256"></embed>
</object>

Let's break this up into three parts:

1. Setting the game structure up.
2. Implementing the game.
3. Improving the graphics.

## Implementing Tilox

### Step 1: Setting up the game structure

We'll start by creating a folder called `Tutorial 2`, and inside create three folders: `flash` and `tilox`.  Inside the `flash` folder, create a new flash file called `tilox.fla`.  You can download the graphics we'll use here: [Tilox Graphics]().  In the final result above, I set the flash dimensions to 256px x 256px, and the frame rate up to 30fps, but neither are strictly necessary.

Make sure that you include the root directory for this project (I called it `Tutorial 2` above) and the directory that contains your `bloxley` directory into the classpath of `tilox.fla`

![Editing the Classpath for tilox.fla]()

So now we need to figure out what classes we're going to create.  Put all of these files in the `tilox` directory.  First, we know we'll need a Game controller, so create `TiloxGame.as` and insert the following code:

    package tilox {
        
        import flash.display.Stage;
        
        import bloxley.controller.game.*;
        
        public class TiloxGame extends BXGame {
            
            public function TiloxGame(stage:Stage) {
                super(stage);
                
                controllers({ Patch: TiloxPatchController, Play: TiloxPlayController, Player: TiloxPlayerController });
            }
    
        }
     
    }

We know we'll need a patch controller, so create `TiloxPatchController.as` and insert the following code:

    package tilox {
    
        import bloxley.model.game.*;
        import bloxley.controller.game.*;
        import bloxley.controller.event.*;
        import bloxley.view.sprite.*;
        import bloxley.view.animation.BXFreeAnimation;
        
        public class TiloxPatchController extends BXPatchController {
            
            public function TiloxPatchController(name:String, game:BXGame) {
                super(name, game);
                
                tiles({ Floor: ".@", Pit: "#" });
            }
        	    	
        }
    
    }

We'll also need an actor controller--only one in this case, since there's only one kind of object moving around.  Create `TiloxPlayerController.as` and insert the following code:

    package tilox {
        
        import bloxley.model.game.BXActor;
        import bloxley.controller.game.BXActorController;
        import bloxley.controller.event.*;
        import bloxley.view.sprite.*;
        
        public class TiloxPlayerController extends BXActorController {
    
            public function TiloxPlayerController(name, game) {
                super(name, game);
                
                setBoardString("@");
            }
            
            override public function key(options = null):String {
                return "Player";
            }
            
            override public function canBePlayer(actor:BXActor):Boolean {
                return true;
            }
            
        }
    
    }

And finally we'll need a play controller.  Create `TiloxPlayController.as` and insert the following code:

    package tilox {
        
        import bloxley.controller.game.*;
        import bloxley.controller.pen.*;
        import bloxley.controller.event.BXAction;
        import bloxley.base.BXSystem;
        import bloxley.view.gui.BXImage;
        
        public class TiloxPlayController extends BXPlayController {
            
            public function TiloxPlayController(name: String, game:BXGame) {
                super(name, game);
            }
    
        }
    }

To go along with this, place the following code into the Frame Actions in `tilox.fla`:

    import tilox.*;
    
    var game = new TiloxGame(stage);
    
    game.loadLevel([
    	"........",
    	".###.##.",
    	".#.#.##.",
    	".###....",
    	".######.",
    	".#.##.#.",
    	".######.",
    	"....@...",
    ]);
    
    game.setCurrentGameController("Play");

And that should be enough to get us started.  If you run the flash file, you should get something that looks like this:

![First pass at Tilox]()

If it doesn't, then run through the steps again, making sure you didn't miss anything.  Setting the classpath for both the actionscript code, and the `bloxley` library, is especially important, and easy to forget.

When runnning the game, you'll notice that it's similar to Sokoban before we implemented any behavior.  You can move the player around, and he'll animate his movements, but it will treat all patches the same.

But it's a start.

### Step 2: Implementing Tilox

So in this step, there's really four things we need to implement.  However, they'll take us into parts of Bloxley that we haven't discussed yet.

1. Floor patches break when you step off of them.
2. Jumping.
3. What happens if you end up in a pit.
4. Win and Lose conditions.

Let's start with breaking floor tiles.  As you can see in `TiloxPatchController.as`, we defined two kinds of patches--_floors_, which players can stand on, and _pits_, which players can't.  So we want to change the code so that when a player exists a floor, it becomes a pit.

Luckily, there's an event for that.  Similar to the `enter` event we used in Sokoban, there's an `exit` event that gets called when an actor exits a patch.  Specifically, if an actor with key **`ActorKey`** exits a patch with key **`PatchKey`**, the first method in the following list _that is defined_ gets called on the patch controller:

1. `can<ActorKey>Exit<PatchKey>()`
2. `canExit<PatchKey>()`
3. `can<ActorKey>Exit()`
4. `canExit()` -- this method is defined in the base class `BXPatchController`, so if it gets to this level, this method is always called (and does nothing).

This technique--called _Method Cascading_--allows us to define generic methods for common behavior, and override that with custom behavior defined in specific methods.  Bloxley frequently uses it to allow flexibility in customizing behavior.  In Sokoban, we used it to take `canWorkerEnterWall()`, a method that prevented workers from stepping on walls, and made it more generic by changing the name to `canEnterWall()`, so that blocks couldn't be pushed onto walls, either.

In Tilox's case, we don't really need to worry about the actor key, since we have only one kind of actor.  So simply defining `canExitFloor()` will allow us to define the behavior we want.  Like with the `enter` actions, these event methods will all be given three arguments: the action that caused the event, the source actor, and the target patch.  So inside the `TiloxPatchController` class, define the following method:

    public function canExitFloor(action:BXMoveAction, source:BXActor, target:BXPatch) {
        action.causes( new BXPatchChangeAction(target, "Pit") );
    }

`BXPatchChange`, not too surprisingly, is an action that changes a patch from one type to another.  If you re-run the code now, you'll see that when the player steps off of a floor, it disappears.  Not very exciting, but we can change that later.  Nothing happens when the player steps off of a pit, which it shouldn't yet.  So far, so good.

Next we want to handle jumping.  When you hit one of the arrow keys, the player moves one step in whatever direction was hit.  What we'd like is that, when you hold down Shift and hit an arrow key, the player jumps two steps in that direction.  To implement that, we first need to look into what happens when you hit the arrow key.

### Pens

In any Bloxley game, we have on one hand the **User** who is playing the game, and the **Controller** on the other which handles the game logic.  However, the user communicates with the game through button presses and mouse movements--and the controller communicates through moving the actors, and changing the patches.  So there needs to be some intermediary that can speak to both users and controllers.

![Pen Diagram]()

Bloxley calls this intermediary a _Pen_.  Pens take in user interactions like key presses, and tell the controller what that key press means.  All pens are a subclass of `BXPen`, although there's a special subclass called `BXPlayPen` designed for pens used in gameplay.  The only behavior that `BXPen` directly implements is Delete for undo, and Shift+Delete for resetting the level.  `BXPlayPen`, however, also includes using the arrow keys to move the currently selected actor, Space to change the currently selected actor, and some mouse control as well.

In Tilox, we want to change what the arrow keys do.  So we'll create our own special subclass of `BXPlayPen`, called `TiloxPlayPen`.  Create the file `tilox/TiloxPlayPen.as` and insert the following code:

    package tilox {
    
        import bloxley.controller.game.BXPlayController;
        import bloxley.controller.pen.BXPlayPen;
        import bloxley.model.data.BXDirection;
        
        public class TiloxPlayPen extends BXPlayPen {
        
            public function TiloxPlayPen(controller:BXPlayController) {
                super(controller);
            }
            
            override public function arrow(direction:BXDirection, shift:Boolean, alt:Boolean, ctrl:Boolean) {
                controller.respondTo("moveCharacter", [ direction, shift ? 2 : 1 ]);
            }
            
        }
    }

As you can see, there's a method called `arrow()` which gets called when an arrow key is hit, and the direction of the arrow key is passed in, as well as the state of the modifier keys (Shift, Alt, and Control).

What we're doing when the arrow key gets hit is calling telling the controller to handle a `moveCharacter()` method.  Rather than calling it directly, we're using the indirect "respondTo" method, because that (a) allows hooks around when `moveCharacter()` gets called, and (b) allows the controller to easily pass the call onto another object, in case the controller doesn't handle `moveCharacter()` directly.  In this csae it does, but we should always have the pens speak to the controller through `respondTo()`.

The second argument to `respondTo()` is the array of parameters, so when `moveCharacter()` gets called, the direction and the number of steps will get passed in (2 if shift is being held down, 1 otherwise).  `moveCharacter()` knows how to handle both of those arguments, so we don't need to redefine it--but we do need to tell the play controller about our new pen.

So open up `tilox/TiloxPlayController.as` and insert the following method:

    override public function createPens() {
        var pen = new TiloxPlayPen(this);
        pen.setName("Play");
        
        var pen1 = new BXGameOverPen(this);
        pen1.setName("GameOver");
    }

`createPens()` isn't anything special, it's just a convenient place to define the creation of pens.  As you can see, we're creating two pens: one is our new `TiloxPlayPen`, and the other is a `BXGameOverPen`--that handles the interaction when the game has been won (or lost).  We won't talk too much about it this time.

Now if you run our flash program, you'll be able to make the player jump around by holding down shift.  The only visual difference will be that the cell jumped over won't turn into a pit.

Next thing we want to tackle is falling into a pit.  In Sokoban, you can beat a level--but not lose.  In Tilox, we want to be able to lose as well as win.  So, we want to make the player "go away" when they jump into a pit.  In Bloxley, this is called _disabling_ the actor.  It makes the actor's sprite disappear, and they can't be selected as the currently active actor any more.  For us, this is a bad thing--but in other games, disabling an actor is useful for when they exit a maze.

So, open up `tilox/TiloxPatchController.as`, and insert the following method into the `TiloxPatchController` class:

    public function canEnterPit(action:BXMoveAction, source:BXActor, target:BXPatch) {
        action.causes( new BXDisableAction(source) );
    }

This is pretty easy to understand--it gets called when an actor enters a **Pit** patch, and causes the actor to become disabled.  If you run the flash app, and jump off into nothingness, you'll see the actor fade away.  Now we just need to hook that into ending the game.

As we discussed in the last tutorial, Bloxley's default game flow includes a pair of methods `didBeatLevel()` and `didLoseLevel()` where you can determine if the level was beaten or not.  Bloxley checks to see if a level was lost, before it checks whether a level was beaten--so if both conditions are reached at the same time, the level will be lost.  I'm mentioning this because it's relevant for Tilox.

So, first: winning.  In standard Tilox, you win when the final square left is the one that the player is standing on.  To handle the case where there are multiple players, we'll just check that the number of Floor patches is the same as the number of Player actors.  In the `TiloxPlayController` class, insert the following method:

    override public function didBeatLevel():Boolean {
        return board().allActors().ofType("Player").howMany() == board().allPatches().ofType("Floor").howMany();
    }        

The method there is I think pretty readable.  One one hand, it takes the board, looks at all of the actors, narrows that down to only actors that are **Player**s, and finds out how many of them there are.  Since we have only one kind of actor, the call to `ofType("Player")` is somewhat redundant, but it makes the method more explicit, and symmetric to the patch case.  On the other hand, it takes the board, looks at all of the patches, gets only the patches that are **Floor**s, and looks at how many of those there are.  If those are the same, then the level has been beaten.

Next, losing.  The user loses a game of Tilox if the player jumps into a pit.  Extending that to multiple players could mean (a) any player jumps into a pit, or (b) all players jump into a pit.  I chose the former, but it doesn't matter too much.  In the `TiloxPlayController` class, insert the method:

    override public function didLoseLevel():Boolean {
        return board().allActors().ofType("Player").areAnyDisabled();
    }

The only new method here is `areAnyDisabled()`, which returns true if any actors have been disabled.  It's a useful method for end-of-game conditions, like here.  To see all of those methods, check out `bloxley/model/collection/BXGroup.as`.

Since we want to be able to display when the game is won and lost, also stick the following method into `TiloxPlayController`:

    override public function createInterface() {
        super.createInterface();
        
        var screen = BXSystem.screenDimensions();
        
        setBank("Beat Level");
            var image = new BXImage(this, "BeatLevel", { centered: true, depth: 1 });
            image.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
            register( image );
        
        setBank("Lost Level");
            var image2 = new BXImage(this, "LostLevel", { centered: true, depth: 2 });
            image2.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
            register( image2 );
    }

Make sure that the linkage class for your winning banner is set to `game.BeatLevel`, and the linkage class for your losing banner is set to `game.LostLevel`.  It's already set in the provided graphics, but if you decide to change them, you'll have to make sure that these are set.

Once again, run the flash app.  Now when you beat the level, you'll get a nice message saying so--and when you lose the level, you'll get a message saying you lost.

![Beat the Level]()

![Lost the Level]()

### Step 3: Improving the Graphics

So now we're about where we were at the end of the Sokoban tutorial--we have a playable game with correct end game conditions, but it's not very good looking.  So let's set about improving that.  I can think of four places where the game could use some polish:

1. The player sprite should be a little fancier than just a static image.
2. When the player moves around, jumping instead of sliding would look good
3. And while we're at it, making it face the direction of motion would be good, too.
3. Having the floor disappear instead of just changing.

So let's get started.

First, we want the player sprite to look better.  That means not just a single static image; let's put a slight shadow under the sprite.  That'll definitely look good when we have the actor jump.  Open up `tilox/BXTiloxPlayerController.as`, and insert the following methods:

    override public function frameName(actor:BXActor):String {
        return "Sleeping";
    }
    
    override public function initializeSprite(actor:BXActor, sprite:BXSprite) {
        var comp:BXCompositeSprite = sprite as BXCompositeSprite;
        
        comp.layer(0).goto([0, 0]);
        
        comp.addSpriteLayer("Shadow", { depth: 1 });
        comp.swapLayers(0, 1);
    }
    
    override public function animateSelect(actor:BXActor, oldActor:BXActor, action:BXSelectAction) {
        var sprite = spriteForActor(actor);
        var body = sprite.layer(1);
        
        var anims = [ body.frame("South", { wait: true }) ];
        
        if (oldActor) {
            var sprite2 = spriteForActor(oldActor);
            var body2 = sprite2.layer(1);
        
            anims.push(body2.frame("Sleeping", { wait: true }));
        }
        
        return anims;
    }
    
    override public function animateUndoSelect(actor:BXActor, oldActor:BXActor, action:BXSelectAction) {
        var sprite = spriteForActor(actor);
        var body = sprite.layer(1);
        
        var anims = [ body.frame("Sleeping") ];
        
        if (oldActor) {
            var sprite2 = spriteForActor(oldActor);
            var body2 = sprite2.layer(1);
    
            anims.push(body2.frame("South"));
        }
        
        return anims;
    }

So this is a good chunk of code.  What does it all do?

Well, the first method, `frameName()`, simply tells Bloxley that all players should default to the 'Sleeping' frame--this way, we can have only the currently selected player look different.  That'll allow us to distinguish which player is active.  That's nice.

Next we're defining `initializeSprite()`.  This method gets called when an actor's sprite is first created.  It allows you to set up the sprite in whatever way you want it.  In our case, we're using it to add another image into the sprite, and then calling `swapLayers()` to place it below the main sprite image (which defaults to depth 0).

After that we're defining `animateSelect()`.  This method gets called to generate the animation for selecting a new player.