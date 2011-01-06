package {
    
    import bloxley.controller.game.BXGame;
    import bloxley.controller.io.BXServer;
    
    public class BloxleyServer extends BXServer {
        
        var gameId:int;
        
        public function BloxleyServer(game:BXGame, gameId:int) {
            super(game);
            this.gameId = gameId;
        }

        override public function url(info):String {
            return "http://192.168.1.5:3000/games/" + gameId + "/levels/" + info + ".xml";
        }

    }
    
}