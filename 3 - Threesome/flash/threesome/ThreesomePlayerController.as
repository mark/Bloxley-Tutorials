package threesome {
    
    import bloxley.model.data.BXColor;
    import bloxley.model.game.BXActor;
    import bloxley.controller.game.BXActorController;
    import bloxley.controller.event.*;
    import bloxley.view.sprite.*;
    
    public class ThreesomePlayerController extends BXActorController {
        
        public function ThreesomePlayerController(name, game) {
            super(name, game);
            
            setBoardString("@" + BXColor.upperCases());
        }
        
        /***************
        *              *
        * Game Methods *
        *              *
        ***************/
        
        override public function key(options = null):String {
            return "Player";
        }
        
        override public function canBePlayer(actor:BXActor):Boolean {
            return true;
        }

        override public function isGood(actor:BXActor):Boolean {
            return actor.amIStandingOn("Goal");
        }

        /********************
        *                   *
        * Animation Methods *
        *                   *
        ********************/
        
        override public function frameName(actor:BXActor):String {
            return "Sleeping";
        }
        
        override public function initializeSprite(actor:BXActor, sprite:BXSprite) {
            var comp:BXCompositeSprite = sprite as BXCompositeSprite;
            
            comp.addSpriteLayer("Shadow", { depth: 1 });
            comp.swapLayers(0, 1);
        }
        
        override public function defaultSpeed():Number {
            return 5.0;
        }

        override public function animateSelect(actor:BXActor, oldActor:BXActor, action:BXSelectAction) {
            var sprite = spriteForActor(actor);
            var body = sprite.layer(1);
        
            var anims = [ body.frame("South", { wait: true }) ];
        
            if (oldActor) {
                var sprite2 = spriteForActor(oldActor);
                var body2 = sprite2.layer(1);
        
                anims.push(body2.frame("Sleeping", { wait: true }));
            }
        
            return anims;
        }
                    
        override public function animateMove(actor:BXActor, action:BXMoveAction) {
            var sprite = spriteForActor(actor);
            var body = sprite.layer(1);
            
            return [
                sprite.goto(action.newPosition, { speed: defaultSpeed() }),
                body.shift([0, -8.0 * action.steps()], { seconds: action.steps() / defaultSpeed(), blend: "bounce" }),
                body.frame(action.direction().toString(), { wait: true })
            ];
        }

    }

}
