package tilox {

    import bloxley.controller.game.BXPlayController;
    import bloxley.controller.pen.BXPen;
    import bloxley.model.data.BXDirection;
    
    public class TiloxPlayPen extends BXPen {
    
        public function TiloxPlayPen(controller:BXPlayController) {
            super(controller);
        }
        
        override public function arrow(direction:BXDirection, shift:Boolean, alt:Boolean, ctrl:Boolean) {
            controller.respondTo("moveCharacter", [ direction, shift ? 2 : 1 ]);
        }
        
    }
}
