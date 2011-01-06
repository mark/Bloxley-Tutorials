package sokoban {
    
    import bloxley.base.BXSystem;
    import bloxley.controller.game.*;
    import bloxley.view.gui.BXImage;
    
    public class SokobanPlayController extends BXPlayController {
        
        public function SokobanPlayController(game:BXGame) {
            super(game);
        }
        
        override public function createInterface() {
            super.createInterface();
            
            var screen = BXSystem.screenDimensions();
            
            setBank("Beat Level");
                var image = new BXImage(this, "BeatLevel", { centered: true, depth: 1 });
                image.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
                register( image );
        }

	    override public function didBeatLevel():Boolean {
            return board().allActors().ofType("Block").areAllGood();
    	}
    	
    }
}