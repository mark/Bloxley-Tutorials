package sokoban {
    
    import flash.display.Stage;
    
    import bloxley.controller.game.*;
    
    public class SokobanGame extends BXGame {
        
        public function SokobanGame(stage:Stage) {
            super(stage);
            
            controllers({ Patch: SokobanPatchController })
        }

    }
 
}
