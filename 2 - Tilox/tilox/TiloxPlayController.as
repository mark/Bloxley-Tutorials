package tilox {
    
    import bloxley.controller.game.*;
    import bloxley.controller.pen.*;
    
    public class TiloxPlayController extends BXPlayController {
        
        public function TiloxPlayController(name: String, game:BXGame) {
            super(name, game);
        }

        override public function createPens() {
            var pen = new TiloxPlayPen(this);
            pen.setName("Play");
            
            var pen1 = new BXGameOverPen(this);
            pen1.setName("GameOver");
            
        }
        
        override public function didLoseLevel():Boolean {
            trace(board().allActors().ofType("Player").howMany());
            trace(board().allActors().ofType("Player").thatAre( function(actor) { return actor.isActive(); }).howMany());

            return board().allActors().ofType("Player").areAnyDisabled();
        }
        
        override public function lostLevel() {
            trace("YOU LOSE")
        }
    }
}