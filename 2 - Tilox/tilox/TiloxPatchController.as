package tilox {

    import bloxley.model.game.*;
    import bloxley.controller.game.*;
    import bloxley.controller.event.*;
    import bloxley.view.sprite.*;
    
    public class TiloxPatchController extends BXPatchController {
        
        public function TiloxPatchController(name:String, game:BXGame) {
            super(name, game);
            
            tiles({ Floor: ".@", Pit: "#" });
        }

    	function frameName(patch:BXPatch):String { return null; }
    	
    	override public function initializeSprite(patch:BXPatch, sprite:BXSprite) {
    	    if (patch.isA("Floor")) {
    	        var comp:BXCompositeSprite = sprite as BXCompositeSprite;
    	        
    	        var floor = comp.addSpriteLayer("WeakFloor", { depth: 1, centered: true });
    	        floor.goto([ 16, 16 ]);
    	    }
    	}
    	
    	public function canExitFloor(action:BXMoveAction, source:BXActor, target:BXPatch) {
    	    action.causes( new BXPatchChangeAction(target, "Pit") );
    	}
    	
    	public function canEnterPit(action:BXMoveAction, source:BXActor, target:BXPatch) {
    	    action.causes( new BXDisableAction(source) );
    	}
    	
    	override public function animatePatchChange(patch:BXPatch, action:BXPatchChangeAction) {
            var layer = (spriteForPatch(patch) as BXCompositeSprite).layer(1);
            
            return [
                layer.hide({ seconds: 0.5, blend: "snap" }),
                layer.resize([0.0, 0.0], { seconds: 0.5, blend: "accel" })
            ];
        }
        
    }

}
