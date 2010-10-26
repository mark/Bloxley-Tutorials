package header {
    
    import flash.display.Stage;
    
    import bloxley.controller.game.*;
    
    public class HeaderGame extends BXGame {

        static var ColorSchemes = [
            { Patch: 0xfdffba, Block: [ 0xa1172d, 0xa7db9e, 0x275c57, 0x1f1b19 ] },
            { Patch: 0xf2dc9b, Block: [ 0x213155, 0x95bf9b, 0x546f76, 0xd8785f ] },
            { Patch: 0xc4f2ff, Block: [ 0xfc5b00, 0xffcc00, 0x51c1ff, 0x0078bd ] },
            { Patch: 0xfeffb7, Block: [ 0xa4152a, 0xa6dc9c, 0x225c57, 0x1e1a18 ] },
            { Patch: 0xfff2ab, Block: [ 0x1f0055, 0x290217, 0x505210, 0xffd46b ] },
            { Patch: 0xedb393, Block: [ 0x939eb7, 0x313b54, 0x805060, 0xee796f ] },
            { Patch: 0xbbb3df, Block: [ 0x572778, 0x75585b, 0x8d7e5c, 0xa59990 ] },
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