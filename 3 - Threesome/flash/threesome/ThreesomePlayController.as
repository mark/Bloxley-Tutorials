package threesome {
    
    import bloxley.base.BXSystem;
    import bloxley.model.data.BXColor;
    import bloxley.model.game.BXActor;
    import bloxley.controller.game.*;
    import bloxley.controller.pen.*;
    import bloxley.controller.event.*;
    import bloxley.view.gui.BXImage;
    
    public class ThreesomePlayController extends BXPlayController {
        
        public function ThreesomePlayController(name: String, game:BXGame) {
            super(name, game);
        }

        override public function createInterface() {
            super.createInterface();
            
            var screen = BXSystem.screenDimensions();
            
            setBank("Beat Level");
                var image = new BXImage(this, "BeatLevel", { centered: true, depth: 1 });
                image.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
                register( image );
        }

        /*************
        *            *
        * Game Logic *
        *            *
        *************/
        
        override public function startGame() {
            heartbeat();
            super.startGame();
        }
        
        override public function didBeatLevel():Boolean {
            return board().allActors().ofType("Player").areAllGood();
        }
        
        function cleanTriggers():Object {
            var triggers = new Object();
            
            for (var i = 0; i < BXColor.Colors.length; i++) {
                triggers[BXColor.Colors[i].name] = 0;
            }
            
            return triggers;
        }
        
        function setTriggers(triggers:Object) {
            board().allActors().ofType("Player").each( function(actor:BXActor) {
                var color = actor.location().get("color");
                
                if (color) triggers[color.name]++;
            });
        }

        override public function heartbeat() {
            var triggers = cleanTriggers();
            setTriggers(triggers);
            
            var actions = [];
            
            board().allActors().ofType("Gate").each( function(gate:BXActor) {
                actions.push( new ThreesomeGateChangeAction(gate, triggers) );
            });
            
            minorEvent( actions );
        }

        
    }
}