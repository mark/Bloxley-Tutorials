package sokoban {

    import bloxley.controller.game.*;
    import bloxley.model.game.*;
    
    public class SokobanPatchController extends BXPatchController {
        
        public function SokobanPatchController(game:BXGame) {
            super(game);
            
            tiles({ Floor: " @$", Wall: "#", Target: ".+*" });
        }

    	public function canEnterWall(action, source:BXActor, target:BXPatch) {
    		action.fail();
    	}

    }

}
