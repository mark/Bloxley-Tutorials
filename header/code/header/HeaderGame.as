package header {
    
    import flash.display.Stage;
    
    import bloxley.controller.game.*;
    
    public class HeaderGame extends BXGame {

        static var ColorSchemes = [
            { Patch: 0x9c9965, Block: [ 0xffe3a6, 0xd4c37b, 0x697055, 0x45473f ] },
            { Patch: 0xa7db9e, Block: [ 0xa1172d, 0xfdffba, 0x275c57, 0x1f1b19 ] },
            { Patch: 0x4c7f5e, Block: [ 0x4c998c, 0x526647, 0x4c4c3d, 0x33322e ] },
            { Patch: 0x546f76, Block: [ 0x213155, 0x95bf9b, 0xf2dc9b, 0xd8785f ] },
            { Patch: 0xc4f2ff, Block: [ 0xfc5b00, 0xffcc00, 0x51c1ff, 0x0078bd ] }
        ]
        
        static var CurrentColorScheme:Object;
        
        public function HeaderGame(stage:Stage) {
            super(stage);
         
            chooseRandomColorScheme();
            
            controllers({ Patch: HeaderPatchController, Block: HeaderBlockController, Attract: HeaderAttractController });
        }
        
        override public function defaultGridSize():Number {
            return 20.0;
        }
        
        function chooseRandomColorScheme() {
            var index = Math.floor( Math.random() * ColorSchemes.length );
            CurrentColorScheme = ColorSchemes[ index ];
        }
    }
    
}