package;

import openfl.display.Sprite;
import openfl.net.NetStream;
import openfl.media.Video;
import ui.PreferencesMenu;
import shaderslmfao.BuildingShaders;
import shaderslmfao.ColorSwap;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;

using StringTools;

class TitleState extends MusicBeatState
{
	public static var updateVersion:String;
	public static var curVersion:String = '0.4.3';
	public static var initialized:Bool = false;
	
	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	
	var lastBeat:Int = 0;

	var swagShader:ColorSwap;
	var alphaShader:BuildingShaders;

	#if web
	var video:Video;
	var netStream:NetStream;
	var overlay:Sprite;
	#end

	override public function create():Void
	{
		// Some of the code here are either from Psych Engine or Kade Engine (RIP Kade Engine) //
		
		///   ///   //////////
		///  ///    ////
		//////      ///////
		///  ///    ////
		///   ///   ////
		///   ///   //////////
		// ------------------------------------------------------------------------------------///

		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod'], framework: OPENFL});
		#end

		FlxG.game.focusLostFramerate = 60;

		swagShader = new ColorSwap();
		alphaShader = new BuildingShaders();

		FlxG.sound.muteKeys = [ZERO];

		curWacky = FlxG.random.getObject(getIntroTextShit());

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PreferencesMenu.initPrefs();
		PlayerSettings.init();
		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		if (FlxG.save.data.seenVideo != null)
		{
			VideoState.seenVideo = FlxG.save.data.seenVideo;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end

		#if desktop
		DiscordClient.initialize();
		
		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		#end
	}

	#if web
	function client_onMetaData(e)
	{
		video.attachNetStream(netStream);
		video.width = video.videoWidth;
		video.height = video.videoHeight;
	}

	function netStream_onAsyncError(e)
	{
		trace("Error loading video");
	}

	function netConnection_onNetStatus(e)
	{
		if (e.info.code == 'NetStream.Play.Complete')
		{
			startIntro();
		}
		trace(e.toString());
	}

	function overlay_onMouseDown(e)
	{
		netStream.soundTransform.volume = 0.2;
		netStream.soundTransform.pan = -1;
		Lib.current.stage.removeChild(overlay);
	}
	#end

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(-150, 1500); // Kade Engine code
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8), Std.int(ngSpr.height * 0.8));
		ngSpr.antialiasing = true;
		ngSpr.screenCenter(X);
		ngSpr.visible = false;
		credTextShit.visible = false;
		
		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.onComplete = function()
			{
				FlxG.switchState(new VideoState());
			}
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	var isRainbow:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		//if (FlxG.keys.justPressed.F)
		//{                ---------- Yeah let's not do that.
		//	FlxG.fullscreen = !FlxG.fullscreen;
		//}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.onComplete = null;
			}

			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			
			transitioning = true;
			// FlxG.sound.music.stop();

			// time to check if Eterhox Engine is outdated
			trace("Checking Eterhox Engine's Github page");

			var http = new haxe.Http("https://raw.githubusercontent.com/Bloxee/Eterhox-Engine/main/verBuild");

			http.onData = function(data:String) {
				TitleState.updateVersion = data.split('\n')[0].trim();
				
				trace('Version on Github: ' + updateVersion + ', Current Engine version: ' + curVersion);
				if (updateVersion != curVersion) {
					if (updateVersion < curVersion) {
						trace("Hol' up, no update?? That's fucking shit.");
					} else {
						// Send the bozo to OutdatedSubState so they can cry about them having an older version of the engine
						FlxG.switchState(new OutdatedSubState());
						trace("Ahahaha stupid idiot is using an old engine, couldn't be me.");
						#if desktop
						var rpcDetails = "Player is using outdated engine";
						DiscordClient.changePresence("This bitch lives on a rock lmfao", rpcDetails);
						#end
					}
				} else {
					trace('Hold on...wait a minute, some shit just happened here.');
				}
			
			// Prevent game lock?
			FlxG.switchState(new MainMenuState());
		};

		http.onError = function(error) {
			trace('Unable to detect an update - Error Message: $error');
			FlxG.switchState(new MainMenuState());
		};

		http.request();
		}
		
		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		if (controls.UI_LEFT)
		{
			swagShader.update(elapsed * 0.1);
		}
		if (controls.UI_RIGHT)
		{
			swagShader.update(-elapsed * 0.1);
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
		{
		  for (i in 0...textArray.length)
		  {
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		  }
		}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();
		
		if (logoBl != null) {
		  logoBl.animation.play('bump');
		}
		// So these lines below this comment are to prevent the game from crashing. I'll figure out this shit works later in life. 
		danceLeft = !danceLeft;
		if (danceLeft && gfDance != null) { 
		  gfDance.animation.play('danceRight');
		} else if (gfDance != null) { 
		  gfDance.animation.play('danceLeft');
		}

		FlxG.log.add(curBeat);

		if (curBeat > lastBeat)
		{
			for (i in lastBeat...curBeat)
			{
				switch (i + 1)
				{
					case 1:
						createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
					case 3:
						addMoreText('present');
					case 4:
						deleteCoolText();
					case 5:
						createCoolText(['Eterhox Engine ', 'by']);
					case 7:
						addMoreText('Bloxe');
						ngSpr.visible = true;
					case 8:
						deleteCoolText();
						ngSpr.visible = false;
					case 9:
						createCoolText([curWacky[0]]);
					case 11:
						addMoreText(curWacky[1]);
					case 12:
						deleteCoolText();
					case 13:
						addMoreText('Friday');
					case 14:
						addMoreText('Night');
					case 15:
						addMoreText('Funkin');		
					case 16:
						skipIntro();
				}
			}
		}
		
		lastBeat = curBeat;
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
		{
			if (!skippedIntro)
			{	
				remove(ngSpr);
	
				FlxG.camera.flash(FlxColor.WHITE, 4);
				remove(credGroup);
	
				FlxTween.tween(logoBl, {y: -100}, 1.4, {ease: FlxEase.expoInOut});
	
				logoBl.angle = -4;
	
				var timer:FlxTimer = new FlxTimer();

				timer.start(0.01, function(tmr:FlxTimer)
				{
					if (logoBl.angle == -4)
						FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
					else if (logoBl.angle == 4)
						FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
				}, 0);
				
				// Kade Engine code ~ Truly inspiring words from Kade
				// ---------------------------------------------------------
				// It always bugged me that it didn't do this before.
				// Skip ahead in the song to the drop.
				FlxG.sound.music.time = 9400; // 9.4 seconds
	
				skippedIntro = true;
			}
		}
	}
