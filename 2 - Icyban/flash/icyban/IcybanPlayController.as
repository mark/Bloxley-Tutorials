package icyban {
    
    import bloxley.controller.game.*;
    
    public class IcybanPlayController extends BXPlayController {
        
        public function IcybanPlayController(name: String, game:BXGame) {
            super(name, game);
        }
        
	    override public function didBeatLevel():Boolean {
            return board().allActors().ofType("Block").areAllGood();
    	}
    	
    }
}