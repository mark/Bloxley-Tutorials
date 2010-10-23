package icyban {

    import bloxley.controller.game.*;
    import bloxley.model.game.*;
    import bloxley.controller.event.BXMoveAction;
    
    public class IcybanPatchController extends BXPatchController {
        
        public function IcybanPatchController(name:String, game:BXGame) {
            super(name, game);
            
            tiles({ Floor: " @$", Wall: "#", Target: ".+*", Ice: "~!&" });
        }

    	public function canEnterWall(action, source:BXActor, target:BXPatch) {
    		action.fail();
    	}

        public function canEnterIce(action:BXMoveAction, source:BXActor, target:BXPatch) {
            action.safelyCauses( new BXMoveAction(source, action.direction() ));
        }
    }

}
