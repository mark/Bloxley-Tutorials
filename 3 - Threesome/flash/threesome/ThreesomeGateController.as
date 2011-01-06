package threesome {
    
    import bloxley.model.data.BXColor;
    import bloxley.model.game.*;
    import bloxley.model.collection.BXRegion;
    import bloxley.controller.game.BXActorController;
    import bloxley.controller.event.BXMoveAction;
    import bloxley.view.sprite.*;
    
    public class ThreesomeGateController extends BXActorController {
        
        public function ThreesomeGateController(game) {
            super("Game", game);
            
            attributes({ left: "Color", right: "Color", orientation: "Number" });
        }
        
        /***************
        *              *
        * Game Methods *
        *              *
        ***************/
        
        override public function key(options = null):String {
            return "Gate";
        }

        override public function initializeActor(gate:BXActor) {
            gate.set("leftOpen",  false);
            gate.set("rightOpen", false);
        }
        
    	override public function regionForActorAtLocation(actor:BXActor, location:BXPatch):BXRegion {
    	    if (actor.get("leftOpen") && actor.get("rightOpen"))
    	        return new BXRegion([]);
    	    else
    		    return new BXRegion([ actor.location() ]);
    	}

        /********************
        *                   *
        * Animation Methods *
        *                   *
        ********************/
        
        override public function graphicsName(actor:BXActor):String { return null; }

    	override public function registrationAtCenter(actor:BXActor):Boolean {
    	    return true;
    	}
    	
        override public function dimensions(actor:BXActor):Array { return [ 0.5, 1.0 ]; }
        
        override public function initializeSprite(actor:BXActor, sprite:BXSprite) {
            var c:BXCompositeSprite = sprite as BXCompositeSprite;
            c.rotate( actor.get("orientation") );
            
            var left = c.addSpriteLayer("LeftDoor",  { depth: 0 });
            left.color( actor.get("left") );
            left.goto( [-0.5, 0.0] );
            
            var right = c.addSpriteLayer("RightDoor", { depth: 1 });
            right.color( actor.get("right") );
            left.goto( [0.5, 0.0] );
        }
        
        public function animateGateChange(gate:BXActor, action:ThreesomeGateChangeAction) {
            var sprite = spriteForActor(gate);
            return [ sprite.layer(0).resize( [gate.get("leftOpen" ) ? 0.0 : 0.5, 1.0], { seconds: 0.5 } ),
                     sprite.layer(1).resize( [gate.get("rightOpen") ? 0.0 : 0.5, 1.0], { seconds: 0.5 } ) ];
        }

        public function animateUndoGateChange(gate:BXActor, action:ThreesomeGateChangeAction) {
            var sprite = spriteForActor(gate);
            return [ sprite.layer(0).resize( [gate.get("leftOpen" ) ? 0.0 : 0.5, 1.0]),
                     sprite.layer(1).resize( [gate.get("rightOpen") ? 0.0 : 0.5, 1.0]) ];
        }

    }

}
