package tilox {
    
    import bloxley.model.game.BXActor;
    import bloxley.controller.game.BXActorController;
    import bloxley.controller.event.BXMoveAction;
    import bloxley.view.sprite.*;
    
    public class TiloxPlayerController extends BXActorController {

        public function TiloxPlayerController(name, game) {
            super(name, game);
            
            setBoardString("@+!");
        }
        
        override public function key(options = null):String {
            return "Player";
        }
        
        override public function canBePlayer(actor:BXActor):Boolean {
            return true;
        }
        
        override public function initializeSprite(actor:BXActor, sprite:BXSprite) {
            var comp:BXCompositeSprite = sprite as BXCompositeSprite;
            
            comp.layer(0).goto([0, 0]);
            
            comp.addSpriteLayer("Shadow", { depth: 1 });
            comp.swapLayers(0, 1);
        }
        
        override public function defaultSpeed():Number {
            return 5.0;
        }
        
        override public function animateMove(actor:BXActor, action:BXMoveAction) {
            var sprite = spriteForActor(actor);
            var body = sprite.layer(1);
            
            var anims = [
                sprite.goto(action.newPosition, { speed: defaultSpeed() }),
                body.frame(action.direction().toString(), { wait: true })
            ];
            
            if (action.oldPosition.isntA("Ice")) {
                anims.push( body.shift([0, -8.0 * action.steps()], { seconds: action.steps() / defaultSpeed(), blend: "bounce" }) );
            }

            return anims;
        }
        
    }

}
