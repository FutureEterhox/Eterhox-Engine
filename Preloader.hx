package;

import openfl.Lib;
import flixel.system.FlxBasePreloader;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

@:bitmap("art/preloaderArt.png") class LogoImage extends BitmapData {}

class Preloader extends FlxBasePreloader {
    var logo:Sprite;

    public function new(minDisplayTime:Float = 3, allowedURLs:Array<String> = null) {
        super(minDisplayTime, allowedURLs);
    }

    override function create():Void {
        _width = Lib.current.stage.stageWidth;
        _height = Lib.current.stage.stageHeight;

        var ratio:Float = _width / 2560;

        logo = new Sprite();
        logo.addChild(new Bitmap(new LogoImage(0, 0)));
        logo.scaleX = logo.scaleY = ratio;
        logo.x = (_width / 2) - (logo.width / 2);
        logo.y = (_height / 2) - (logo.height / 2);
        addChild(logo);

        super.create();
    }

    override function update(percent:Float):Void {
        if (percent < 69) {
            logo.scaleX += percent / 1920;
            logo.scaleY += percent / 1920;
            logo.x -= percent * 0.6;
            logo.y -= percent / 2;
        } else {
            var finalScale:Float = _width / 1280;
            logo.scaleX = logo.scaleY = finalScale;
            logo.x = (_width / 2) - (logo.width / 2);
            logo.y = (_height / 2) - (logo.height / 2);
        }

        super.update(percent);
    }
}