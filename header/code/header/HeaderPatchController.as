package header {

    import flash.geom.ColorTransform;
    
    import bloxley.controller.game.*;
    import bloxley.model.game.*;
    import bloxley.view.sprite.BXSprite;
    
    public class HeaderPatchController extends BXPatchController {
        
        public function HeaderPatchController(name:String, game:BXGame) {
            super(name, game);
            
            tiles({ Floor: " $" });
        }

        override public function initializeSprite(actor:BXPatch, sprite:BXSprite) {
            var graphics = sprite.getGraphics();
            
            var myColor:ColorTransform = graphics.transform.colorTransform;
            myColor.color = HeaderGame.CurrentColorScheme.Patch;
            graphics.transform.colorTransform = myColor;
        }
    }

}
