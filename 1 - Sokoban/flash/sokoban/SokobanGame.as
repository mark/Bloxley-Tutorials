package sokoban {
    
    import flash.display.Stage;
    
    import bloxley.controller.game.BXGame;
    
    public class SokobanGame extends BXGame {
        
        public function SokobanGame(stage:Stage) {
            super(stage);
            
            controllers( SokobanPatchController, SokobanWorkerController,
						 SokobanPlayController,  SokobanBlockController );
        }
        
        override public function defaultGridSize():Number {
            return 20.0;
        }

    }
 
}
