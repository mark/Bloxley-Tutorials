package tilox {
    
    import flash.display.Stage;
    
    import bloxley.controller.game.*;
    
    public class TiloxGame extends BXGame {
        
        public function TiloxGame(stage:Stage) {
            super(stage);
            
            controllers({ Patch: TiloxPatchController, Play: TiloxPlayController, Player: TiloxPlayerController });
        }

    }
 
}
