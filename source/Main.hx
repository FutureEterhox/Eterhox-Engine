package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.Lib;

class Main extends Sprite {
    var gameWidth:Int = 1280;
    var gameHeight:Int = 720;
    var initialState:Class<FlxState> = TitleState;
    var zoom:Float = -1;
    var framerate:Int = 60;
    var skipSplash:Bool = true;
    var startFullscreen:Bool = false;

    public static var fpsCounter:openfl.display.FPS;

    public static function main():Void {
        Lib.current.addChild(new Main());
    }

    public function new() {
        super();
        addEventListener(openfl.events.Event.ADDED_TO_STAGE, init);
    }

    private function init(e:openfl.events.Event):Void {
        removeEventListener(openfl.events.Event.ADDED_TO_STAGE, init);
        setupGame();
    }

    private function setupGame():Void {
        var stageWidth:Int = Lib.current.stage.stageWidth;
        var stageHeight:Int = Lib.current.stage.stageHeight;
        if (zoom == -1) {
            var ratioX:Float = stageWidth / gameWidth;
            var ratioY:Float = stageHeight / gameHeight;
            zoom = Math.min(ratioX, ratioY);
            gameWidth = Math.ceil(stageWidth / zoom);
            gameHeight = Math.ceil(stageHeight / zoom);
        }
        
		addChild(new FlxGame(gameWidth, gameHeight, initialState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash, startFullscreen));                      
        
        #if !debug
        initialState = TitleState;
        #end

        #if !mobile
        fpsCounter = new openfl.display.FPS();                  
        addChild(fpsCounter);
        #end
    }
}
