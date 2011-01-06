package sokoban {

    import bloxley.controller.game.*;
    import bloxley.model.game.*;
    import bloxley.controller.event.BXMoveAction;
    
    public class SokobanBlockController extends BXActorController {

        public function SokobanBlockController(game) {
            super("Block", game);
            
            setBoardString("$*");
        }
        
        override public function key(options = null):String {
            return "Block";
        }
        
        public function canBeSteppedOnByWorker(action:BXMoveAction, block:BXActor, player:BXActor) {
    		action.causes(new BXMoveAction(block, action.direction()));
    	}

        override public function isGood(actor:BXActor):Boolean {
            return actor.amIStandingOn("Target");
        }
    }

}
