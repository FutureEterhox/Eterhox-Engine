package;

import flixel.FlxG;

class Highscore {
    #if (haxe >= "4.0.0")
    public static var songScores:Map<String, Int> = new Map();
    #else
    public static var songScores:Map<String, Int> = new Map<String, Int>();
    #end

    public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void {
        var daSong:String = formatSong(song, diff);

        if (songScores.exists(daSong)) {
            if (songScores.get(daSong) < score) {
                setScore(daSong, score);
            }
        } else {
            setScore(daSong, score);
        }
    }

    public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void {
        var daWeek:String = formatSong('week' + week, diff);

        if (songScores.exists(daWeek)) {
            if (songScores.get(daWeek) < score) {
                setScore(daWeek, score);
            }
        } else {
            setScore(daWeek, score);
        }
    }

    /**
     * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
     */
    static function setScore(song:String, score:Int):Void {
        // Reminder that I don't need to format this song, it should come formatted!
        songScores.set(song, score);
        FlxG.save.data.songScores = songScores;
        FlxG.save.flush();
    }

    public static function formatSong(song:String, diff:Int):String {
        var daSong:String = song;

        if (diff == 0) {
            daSong += '-easy';
        } else if (diff == 2) {
            daSong += '-hard';
        }

        return daSong;
    }

    public static function getScore(song:String, diff:Int):Int {
        var formattedSong:String = formatSong(song, diff);

        if (!songScores.exists(formattedSong)) {
            setScore(formattedSong, 0);
        }

        return songScores.get(formattedSong);
    }

    public static function getWeekScore(week:Int, diff:Int):Int {
        var formattedWeek:String = formatSong('week' + week, diff);

        if (!songScores.exists(formattedWeek)) {
            setScore(formattedWeek, 0);
        }

        return songScores.get(formattedWeek);
    }

    public static function load():Void {
        if (FlxG.save.data.songScores != null) {
            songScores = FlxG.save.data.songScores;
        }
    }
}