package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

class Boyfriend extends Character
{
    public var stunned:Bool = false;
    public var startedDeath:Bool = false;

    public function new(x:Float, y:Float, ?char:String = 'bf')
    {
        super(x, y, char, true);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (!debugMode)
        {
            if (StringTools.startsWith(animation.curAnim.name, 'sing'))
            {
                holdTimer += elapsed;
            }
            else
            {
                holdTimer = 0;
            }

            if (StringTools.endsWith(animation.curAnim.name, 'miss') && animation.curAnim.finished)
            {
                playAnim('idle', true, false, 10);
            }

            if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished && startedDeath)
            {
                playAnim('deathLoop');
            }
        }
    }
}
}
