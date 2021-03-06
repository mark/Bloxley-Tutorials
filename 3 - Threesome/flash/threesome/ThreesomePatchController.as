package threesome {
    
    import bloxley.model.game.*;
    import bloxley.model.data.BXColor;
    import bloxley.controller.game.*;
    import bloxley.controller.event.BXMoveAction;
    import bloxley.view.sprite.*;
    
    public class ThreesomePatchController extends BXPatchController {
        
        public function ThreesomePatchController(game:BXGame) {
            super(game);
            
            tiles({ Floor: ".@", Wall: "#", Trigger: BXColor.bothCases(), Goal: "!" });
        }
        
        override public function initializePatch(patch:BXPatch) {
            if (patch.isA("Trigger")) {
                var colorString = patch.get("tile");
                var color = BXColor.getColor(colorString);
                
                patch.set("color", color);
            }
        }
        
        override public function initializeSprite(patch:BXPatch, sprite:BXSprite) {
            if (patch.isA("Trigger")) {
                var triggerLayer = (sprite as BXCompositeSprite).addSpriteLayer("Trigger");
                triggerLayer.color( patch.get("color") );
            }
    	}

        public function canEnterWall(action:BXMoveAction, source:BXActor, target:BXPatch) {
            action.fail();
        }
        
    }

}
