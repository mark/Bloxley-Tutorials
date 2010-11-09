package threesome {

    import bloxley.model.game.BXActor;
    import bloxley.controller.event.BXBehavior;
    
    public class ThreesomeGateChangeAction extends BXBehavior {
        
        var triggers:Object;
        
        var oldLeftOpen:Boolean;
        var oldRightOpen:Boolean;
        
        public function ThreesomeGateChangeAction(gate:BXActor, triggers:Object) {
            super(gate);
            setKey("GateChange");
            
            this.triggers = triggers;
        }
        
        override public function act() {
            oldLeftOpen  = actor().get("leftOpen" );
            oldRightOpen = actor().get("rightOpen");
            
            var matching  = actor().get("left") == actor().get("right");
            var leftDown  = triggers[ actor().get("left").name  ];
            var rightDown = triggers[ actor().get("right").name ];
            
            actor().set("leftOpen", leftDown   > 0);
            actor().set("rightOpen", rightDown > (matching ? 1 : 0));
            
            if (leftChanged() || rightChanged() ) {
                actor().regionChanged();
            } else {
                fail();
            }
        }
        
        override public function undo() {
            actor().set("leftOpen",  oldLeftOpen );
            actor().set("rightOpen", oldRightOpen);
            
            actor().regionChanged();
        }
        
        public function leftChanged():Boolean {
            return actor().get("leftOpen") != oldLeftOpen;
        }

        public function rightChanged():Boolean {
            return actor().get("rightOpen") != oldRightOpen;
        }

    }
}