package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OutdatedSubState extends MusicBeatState
{
    public static var leftState:Bool = false;
    var state:FlxState = null;

    override function create() 
    {
        super.create();
        
        var bg: FlxSprite = new FlxSprite();
        bg.loadGraphic("assets/images/week54prototype.png");
        bg.scale.x *= 1.35;
        bg.scale.y *= 1.35;
        bg.screenCenter();
        add(bg);
        
        var txt: FlxText = new FlxText(0, 0, FlxG.width, 
        "Hey there! You're running an older version of Eterhox Engine! \n"
        + "Your current version is v" + TitleState.curVersion
        + " while the most recent version is v" + TitleState.updateVersion 
        + "\n Click the SPACEBAR or ENTER to head to Github or click Backspace/ESC to ignore this message.", 32);
        txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        txt.screenCenter();
        add(txt);
    }
        
    override function update(elapsed:Float) 
    { 
        if (controls != null && controls.ACCEPT == true) 
        { 
            FlxG.openURL("https://github.com/bloxee/Eterhox-Engine"); 
        } 
        if (controls != null && controls.BACK == true && leftState == false) 
        { 
            FlxG.switchState(new MainMenuState()); 
        } 
        super.update(elapsed);
    } 
} 
