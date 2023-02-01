package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
var gameWidth:Int = 1280;
var gameHeight:Int = 720;
var initialState:Class<FlxState> = TitleState;
var zoom:Float = -1;
var framerate:Int = 60;
var skipSplash:Bool = true;
var startFullscreen:Bool = false;

public static var fpsCounter:FPS;

public static function main():Void
{
	Lib.current.addChild(new Main());
}

public function new()
{
	super();

	addEventListener(Event.ADDED_TO_STAGE, init);
}

private function init(e:Event):Void
{
	removeEventListener(Event.ADDED_TO_STAGE, init);

	setupGame();
}

private function setupGame():Void
{
	var stageWidth:Int = Lib.current.stage.stageWidth;
	var stageHeight:Int = Lib.current.stage.stageHeight;

	if (zoom == -1)
	{
		var ratioX:Float = stageWidth / gameWidth;
		var ratioY:Float = stageHeight / gameHeight;
		zoom = Math.min(ratioX, ratioY);
		gameWidth = Math.ceil(stageWidth / zoom);
		gameHeight = Math.ceil(stageHeight / zoom);
	}

	addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

	#if !debug
	initialState = TitleState;
	#end

	#if !mobile
	fpsCounter = new FPS(10, 3, 0xFFFFFF);
	addChild(fpsCounter);
	#end
}
}

