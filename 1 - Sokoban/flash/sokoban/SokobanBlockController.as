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
        
        public function canBeSteppedOnByWorker(action, block:BXActor, player:BXActor) {
    		action.causes(new BXMoveAction(block, action.direction()));
    	}
        
    }

}
