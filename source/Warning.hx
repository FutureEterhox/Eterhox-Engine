import flixel.ui.FlxButton;
import flixel.input.keyboard.FlxKeyboard;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

#if desktop
import Discord.DiscordClient;
#end

class Warning extends FlxState 
{
    private var controls:FlxKeyboard;
    private var warning:FlxText;
    var timer:FlxTimer = new FlxTimer();
    
    override public function create():Void 
    {
        #if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod'], framework: OPENFL});
		#end

        FlxG.sound.play(Paths.sound('soundTest'), 0.7);
        FlxG.mouse.visible = false;
        super.create();
        displayWarning();
        #if desktop
        DiscordClient.initialize();
        DiscordClient.changePresence("Warning State", null);
        #end
    }
    
    private function displayWarning():Void 
    {
        trace("Eterhox Engine has loaded!");

        var message:String = "Warning!\n"
        + "This engine is currently in development \n"
        + "Expect bugs and glitches in this engine.\n"
        + "\n PRESS Enter to ignore this."
        + "\nYou've been warned!";

        warning = new FlxText(0, 0, FlxG.width, message, 35);
        warning.setFormat("VCR OSD Mono", 35, FlxColor.RED, "center");
        warning.screenCenter();
        add(warning);
    }
        
    override public function update(elapsed:Float):Void 
    {
        super.update(elapsed);
        
        controls = FlxG.keys;
        
        if (FlxG.keys.justPressed.ENTER)
        {
            #if desktop
            DiscordClient.changePresence("TitleState.hx time", null);
            #end
            
            timer.start(0.2, function(tmr:FlxTimer):Void {
                FlxG.camera.fade(FlxColor.BLACK, 0.69, true);
                FlxG.switchState(new TitleState());
            });
        }
    } 
}