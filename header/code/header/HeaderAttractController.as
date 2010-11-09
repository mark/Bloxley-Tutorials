package header {
    
    import bloxley.model.data.BXDirection;
    import bloxley.controller.event.BXMoveAction;
    import bloxley.controller.game.*;    
    
    public class HeaderAttractController extends BXPlayController {
        
        static var Directions = [ BXDirection.North, BXDirection.South, BXDirection.East, BXDirection.West ];
        
        public function HeaderAttractController(name: String, game:BXGame) {
            super(name, game);
            
            this.queue = null;
        }

        override public function createPhases() {
            phase("Move Block", { call: "moveBlock" }).pass("Wait").fail("Move Block", "immediate");
            phase("Wait").after("Move Block", "delay", 0.5);
            
            setInitialPhase("Wait");
        }

        override public function onStart() {
            loop().run();
        }
        
        public function randomDirection():BXDirection {
            var index = Math.floor( Math.random() * 4.0 );
            
            return Directions[ index ];
        }
        
        public function moveBlock():Boolean {
            var block = board().allActors().ofType("Block").random();
            
            var e = event( new BXMoveAction(block, randomDirection()) );
            
            return e.didSucceed();
        }
    }
}