package sokoban {
    
    import bloxley.controller.game.BXActorController;
    import bloxley.model.game.BXActor;
    
    public class SokobanWorkerController extends BXActorController {

        public function SokobanWorkerController(game) {
            super("Worker", game);
            
            setBoardString("@+");
        }
        
        override public function key(options = null):String {
            return "Worker";
        }
        
        override public function canBePlayer(actor:BXActor):Boolean {
            return true;
        }
    }

}
