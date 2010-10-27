package icyban {

    import bloxley.controller.game.*;
    import bloxley.model.game.*;
    import bloxley.controller.event.BXMoveAction;
    
    public class IcybanBlockController extends BXActorController {

        public function IcybanBlockController(name, game) {
            super(name, game);
            
            setBoardString("$*&");
        }
        
        override public function key(options = null):String {
            return "Block";
        }
        
        public function canBeSteppedOnByWorker(action, block:BXActor, player:BXActor) {
    		action.causes(new BXMoveAction(block, action.direction()));
    	}

        override public function defaultSpeed():Number {
            return 5.0;
        }
        
        override public function isGood(actor:BXActor):Boolean {
            return actor.amIStandingOn("Target");
        }
        
    }

}
