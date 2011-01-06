package threesome {

    import bloxley.model.game.*;
    import bloxley.model.collection.*;
    import bloxley.controller.game.*;
    import bloxley.controller.pen.*;
    import bloxley.controller.event.*;
    import bloxley.view.gui.*;
    
    public class ThreesomeEditorController extends BXEditorController {
        
        public function ThreesomeEditorController(game:BXGame) {
            super(game);
        }
        
        override public function animatePatchKeyChange(action:BXAction, patch:BXPatch, attribute:String, oldValue, newValue) {
            var frameChange = super.animatePatchKeyChange(action, patch, attribute, oldValue, newValue);
            
            if (oldValue == "Trigger") {
                var sprite = patch.patchController().spriteForPatch( patch );
                
                return [ frameChange, sprite.layer(1).hide({ wait: true }) ];
            } else {
                return frameChange;
            }
        }

        override public function animateUndoPatchKeyChange(action:BXAction, patch:BXPatch, attribute:String, oldValue, newValue) {
            var frameChange = super.animateUndoPatchKeyChange(action, patch, attribute, oldValue, newValue);
            
            if (oldValue == "Trigger") {
                var sprite = patch.patchController().spriteForPatch( patch );
                
                return [ frameChange, sprite.layer(1).show() ];
            } else {
                return frameChange;
            }
        }
        
    }

}