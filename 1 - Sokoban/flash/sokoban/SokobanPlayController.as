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