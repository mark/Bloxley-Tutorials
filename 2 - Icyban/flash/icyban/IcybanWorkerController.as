package icyban {
    
    import bloxley.model.game.BXActor;
    import bloxley.controller.game.BXActorController;
    import bloxley.controller.event.BXMoveAction;
    import bloxley.view.sprite.*;
    
    public class IcybanWorkerController extends BXActorController {

        public function IcybanWorkerController(name, game) {
            super(name, game);
            
            setBoardString("@+!");
        }
        
        override public function key(options = null):String {
            return "Worker";
        }
        
        override public function canBePlayer(actor:BXActor):Boolean {
            return true;
        }
        
        override public function initializeSprite(actor:BXActor, sprite:BXSprite) {
            var comp:BXCompositeSprite = sprite as BXCompositeSprite;
            
            comp.addSpriteLayer("Shadow", { depth: 1 });
            comp.swapLayers(0, 1);
        }

        override public function animateMove(actor:BXActor, action:BXMoveAction, instant:Boolean = false) {
            var sprite = spriteForActor(actor);
            var options = new Object();
            options.speed = instant ? NaN : defaultSpeed();
            
    	    return [ sprite.goto(action.newPosition, options), sprite.shift([0, -10], options) ];
            
        }
        
    }

}
