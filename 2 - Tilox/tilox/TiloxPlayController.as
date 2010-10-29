package tilox {
    
    import bloxley.controller.game.*;
    import bloxley.controller.pen.*;
    import bloxley.controller.event.BXAction;
    import bloxley.base.BXSystem;
    import bloxley.view.gui.BXImage;
    
    public class TiloxPlayController extends BXPlayController {
        
        public function TiloxPlayController(name: String, game:BXGame) {
            super(name, game);
        }

        override public function createInterface() {
            super.createInterface();
            
            var screen = BXSystem.screenDimensions();
            
            setBank("Beat Level");
                var image = new BXImage(this, "BeatLevel", { centered: true, depth: 1 });
                image.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
                register( image );
            
            setBank("Lost Level");
                var image2 = new BXImage(this, "LostLevel", { centered: true, depth: 2 });
                image2.goto([ screen[0] * 0.5, screen[1] * 0.5 ]);
                register( image2 );
        }

        override public function createPens() {
            var pen = new TiloxPlayPen(this);
            pen.setName("Play");
            
            var pen1 = new BXGameOverPen(this);
            pen1.setName("GameOver");
            
        }

        /*************
        *            *
        * Game Logic *
        *            *
        *************/
        
        override public function didBeatLevel():Boolean {
            return board().allActors().ofType("Player").howMany() == board().allPatches().ofType("Floor").howMany();
        }        
        
        override public function didLoseLevel():Boolean {
            return board().allActors().ofType("Player").areAnyDisabled();
        }

        /*************
        *            *
        * Animations *
        *            *
        *************/
        
        override public function animateBeatLevel(action:BXAction) {
    	    return showBank("Beat Level", { seconds: 0.5 });
        }

        override public function animateUndoBeatLevel(action:BXAction) {
    	    return hideBank("Beat Level");
        }

        override public function animateLostLevel(action:BXAction) {
    	    return showBank("Lost Level", { seconds: 0.5 });
        }

        override public function animateUndoLostLevel(action:BXAction) {
    	    return hideBank("Lost Level");
        }

    }
}