package threesome {

    import flash.display.Stage;
    
    import bloxley.controller.game.*;
    
    public class ThreesomeGame extends BXGame {
        
        public function ThreesomeGame(stage:Stage) {
            super(stage);

            controllers( ThreesomePatchController,
                         ThreesomePlayerController, ThreesomeGateController,
                         ThreesomePlayController,   ThreesomeEditorController );
        }
    }

}
