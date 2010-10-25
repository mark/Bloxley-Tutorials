package header {

    import flash.geom.ColorTransform;

    import bloxley.model.game.*;
    import bloxley.controller.game.*;
    import bloxley.controller.event.BXMoveAction;

    import bloxley.view.sprite.BXSprite;
    
    public class HeaderBlockController extends BXActorController {

        public function HeaderBlockController(name, game) {
            super(name, game);
            
            setBoardString("$");
        }
        
        override public function key(options = null):String {
            return "Block";
        }
        
        public function canBeSteppedOnByBlock(action, self:BXActor, block:BXActor) {
    		action.causes(new BXMoveAction(self, action.direction()));
    	}

        function randomBlockColor():int {
            var colors = HeaderGame.CurrentColorScheme.Block;
            var index = Math.floor( Math.random() * colors.length );
            
            return colors[ index ];
        }
        
        override public function initializeSprite(actor:BXActor, sprite:BXSprite) {
            var graphics = sprite.getGraphics().getChildAt(0).getChildByName("solid");
            
            var myColor:ColorTransform = graphics.transform.colorTransform;
            myColor.color = randomBlockColor();
            graphics.transform.colorTransform = myColor;
        }

    }

}
