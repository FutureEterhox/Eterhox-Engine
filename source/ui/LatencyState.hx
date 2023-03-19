package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
#if desktop
import Discord.DiscordClient;
#end

class LatencyState extends FlxState
{
    var offsetText:FlxText;
	var offsetText2:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
    var strumLine:FlxSprite;

    #if desktop
    var discordClient:DiscordClient;
    #end

    override function create()
    {
        offsetText = new FlxText(FlxG.width/4, 0, FlxG.width);
        offsetText.alignment = "left";
        add(offsetText);

		offsetText2 = new FlxText(FlxG.width/4, 0, FlxG.width);
        offsetText2.alignment = "center";
        add(offsetText2);

        noteGrp = new FlxTypedGroup<Note>();
        add(noteGrp);

        for (i in 0...32)
        {
            var note:Note = new Note(Conductor.crochet * i, 1);
            noteGrp.add(note);
        }

        strumLine = new FlxSprite(FlxG.width / 2, 100).makeGraphic(FlxG.width, 5);
        add(strumLine);

        #if desktop
        discordClient = new DiscordClient();
        discordClient.changePresence("Audio Offset", null);
        #end
        /**
			Lines 54-55 may not work as intended. Same goes for the Strumline.
		**/
        FlxG.sound.music.stop(); 
        FlxG.sound.load(Paths.sound('soundTest'), true, false, true);
        if (!FlxG.sound.music.active)
            FlxG.sound.playMusic(Paths.sound('soundTest'));

        Conductor.changeBPM(120);

        super.create();
    }

    override function update(elapsed:Float)
    {
        var multiply:Float = 1;

        if (FlxG.keys.pressed.SHIFT)
            multiply = 10;

        if (FlxG.keys.justPressed.RIGHT)
            Conductor.offset += 1 * multiply;
        if (FlxG.keys.justPressed.LEFT)
            Conductor.offset -= 1 * multiply;

        if (FlxG.keys.justPressed.SPACE)
        {
            FlxG.sound.music.stop();

            FlxG.resetState();
        }

		// Your escape path :)
        if (FlxG.keys.justPressed.ONE)
        {
            FlxG.sound.music.stop();
            FlxG.save.flush();
            FlxG.switchState(new MainMenuState());
        }

        offsetText.text = "Offset: " + Conductor.offset + "ms";
		offsetText2.text = "-------Warning This state is undergoing development. It's best if you don't use this state.";

        Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

        noteGrp.forEach(function(daNote:Note)
        {
            daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
            daNote.x = strumLine.x + 30;

            if (daNote.y < strumLine.y)
                daNote.kill();
        });

        super.update(elapsed);
    }
}