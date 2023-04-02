package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class GitarooPause extends MusicBeatState {
  var replayButton:FlxSprite;
  var cancelButton:FlxSprite;
  var replaySelect:Bool = false;

  public function new():Void {
    super();
  }

  override function create():Void {
    super.create();

    if (FlxG.sound.music != null && FlxG.sound.music.active) {
      FlxG.sound.music.stop();
    }

    var bg = new FlxSprite().loadGraphic(Paths.image('pauseAlt/pauseBG'));
    bg.antialiasing = true;
    add(bg);

    var bf = new FlxSprite(0, 30);
    bf.frames = Paths.getSparrowAtlas('pauseAlt/bfLol');
    bf.animation.addByPrefix('lol', "funnyThing", 13);
    bf.animation.play('lol');
    bf.screenCenter(X);
    bf.antialiasing = true;
    add(bf);

    replayButton = new FlxSprite(FlxG.width * 0.28, FlxG.height * 0.7);
    replayButton.frames = Paths.getSparrowAtlas('pauseAlt/pauseUI');
    replayButton.animation.addByPrefix('selected', 'bluereplay', 0, false);
    replayButton.animation.appendByPrefix('selected', 'yellowreplay');
    replayButton.animation.play('selected');
    replayButton.antialiasing = true;
    add(replayButton);

    cancelButton = new FlxSprite(FlxG.width * 0.58, replayButton.y);
    cancelButton.frames = Paths.getSparrowAtlas('pauseAlt/pauseUI');
    cancelButton.animation.addByPrefix('selected', 'bluecancel', 0, false);
    cancelButton.animation.appendByPrefix('selected', 'cancelyellow');
    cancelButton.animation.play('selected');
    cancelButton.antialiasing = true;
    add(cancelButton);

    changeThing();
  }

  override function update(elapsed:Float) {
    super.update(elapsed);

    if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
      changeThing();
    }

    if (controls.ACCEPT) {
      FlxG.switchState(replaySelect ? new PlayState() : new MainMenuState());
    }
  }

  function changeThing():Void {
    replaySelect = !replaySelect;

    cancelButton.animation.curAnim.curFrame = replaySelect ? 0 : 1;
    replayButton.animation.curAnim.curFrame = replaySelect ? 1 : 0;
  }
}