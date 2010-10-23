package icyban {
    
    import flash.display.Stage;
    
    import bloxley.controller.game.*;
    
    public class IcybanGame extends BXGame {
        
        public function IcybanGame(stage:Stage) {
            super(stage);
            
            controllers({ Patch: IcybanPatchController, Worker: IcybanWorkerController, Play: IcybanPlayController,
                          Block: IcybanBlockController });
        }

    }
 
}
