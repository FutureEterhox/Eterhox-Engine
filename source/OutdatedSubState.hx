package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Http; // Need to import the haxe.Http library
import TitleState;

class OutdatedSubState extends MusicBeatState 
{
    public static var leftState:Bool = false;
    private var state:FlxState;
    public static var miniUpdateLog:String;
    public static var updateVersion:String; // Add a missing variable declaration

    override function create():Void 
    {
        super.create();
        
        // Create a new Http instance to fetch the miniUpdateLog from Github
        var http = new Http("https://raw.githubusercontent.com/Bloxee/Eterhox-Engine/main/miniUpdateLog"); 
        http.onData = function(data:String) 
        {
            miniUpdateLog = data; // Store the fetched data in the miniUpdateLog variable
            displayMessage(); // Call the displayMessage function after fetching the data
        };
        http.onError = function(error:Dynamic) 
        {
            trace(error); // Handle errors while fetching the data
        };
        http.request();

    }
    
    // Move the message display code to a separate function
    private function displayMessage():Void 
    {
        var bg:FlxSprite = new FlxSprite();
        bg.loadGraphic("assets/images/week54prototype.png");
        bg.scale.x *= 1.5;
        bg.scale.y *= 1.5;
        bg.screenCenter();
        add(bg);
        
        var message:String = "Your Eterhox Engine is outdated!\n"
        + "You are on v" + TitleState.curVersion
        + "\nwhile the most recent version is v" + TitleState.updateVersion 
        + "."
        + "\n\nWhat's new:\n\n"
        + miniUpdateLog
        + "\nSee Eterhox's Github for the full changelog!"
        + "\nPress SPACE or ENTER to head to Github or click Backspace/ESC to ignore this";
    
        var txt:FlxText = new FlxText(0, 0, FlxG.width, message, 32);
        txt.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, CENTER);
        txt.screenCenter();
        add(txt);
    }
        
    override function update(elapsed:Float):Void 
    {
        if (controls != null && controls.ACCEPT) 
        {
            FlxG.openURL("https://github.com/bloxee/Eterhox-Engine"); 
        }
        
        if (controls != null && controls.BACK && !leftState) 
        {
            FlxG.switchState(new MainMenuState()); 
        }
        
        super.update(elapsed);
    } 
}
