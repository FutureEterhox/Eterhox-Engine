package ui;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

#if desktop
import Discord.DiscordClient;
#end

class LatencyState extends FlxState {
    private var offsetText:FlxText;
    private var offsetText2:FlxText;
    private var noteGrp:FlxTypedGroup<Note>;
    private var strumLine:FlxSprite;

    public function new() {
        super();
    }

    override public function create():Void {
        super.create();
        
        offsetText = new FlxText(FlxG.width / 4, 0, FlxG.width);
        offsetText.alignment = FlxTextAlign.LEFT;
        add(offsetText);

        offsetText2 = new FlxText(FlxG.width / 4, 0, FlxG.width);
        offsetText2.alignment = FlxTextAlign.CENTER;
        add(offsetText2);

        noteGrp = new FlxTypedGroup<Note>();
        add(noteGrp);

        for (i in 0...32) {
            var note:Note = new Note(Conductor.crochet * i, 1);
            noteGrp.add(note);
        }

        strumLine = new FlxSprite(FlxG.width / 2, 100);
        strumLine.makeGraphic(FlxG.width, 5);
        add(strumLine);

        #if desktop
        DiscordClient.changePresence("Audio Offset", null);
        #end

        Conductor.changeBPM(120);
        
        FlxG.sound.load(Paths.sound('soundTest'), true, false, true);
        FlxG.sound.playMusic(Paths.sound('soundTest'));
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    
        var multiply:Float = 1;
    
        if (FlxG.keys.pressed.SHIFT) {
            multiply = 10;
        }
    
        if (FlxG.keys.justPressed.RIGHT) {
            Conductor.offset += 1 * multiply;
        }
    
        if (FlxG.keys.justPressed.LEFT) {
            Conductor.offset -= 1 * multiply;
        }
    
        if (FlxG.keys.justPressed.SPACE) {
            FlxG.sound.music.stop();
            FlxG.resetState();
        }
    
        if (FlxG.keys.justPressed.ONE) {
            FlxG.sound.music.stop();
            FlxG.save.flush();
            FlxG.switchState(new MainMenuState());
        }
    
        offsetText.text = "Offset: " + Conductor.offset + "ms";
        offsetText2.text = "Warning! This state is unstable and may not work as intended. To exit, press 1.";
    
        Conductor.songPosition += elapsed * 1000;
    
        noteGrp.forEach(function(note:Note):Void {
            note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * 0.45);
            note.x = strumLine.x + 30;
    
            if (note.y < strumLine.y) {
                note.kill();
            }
        });
    }
}