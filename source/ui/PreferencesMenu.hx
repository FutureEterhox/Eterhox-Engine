package ui;

import openfl.events.Event;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import haxe.ds.StringMap;

class PreferencesMenu extends Page {

    public static var showFPS(default, null):Bool;
    public static var preferences:StringMap<Dynamic> = new StringMap<Dynamic>();

    var checkboxes:Array<CheckboxThingie> = [];
    var menuCamera:FlxCamera;
    var items:TextMenuList;
    var camFollow:FlxObject;

    public function new() {
        super();
        menuCamera = new FlxCamera();
        FlxG.cameras.add(menuCamera, false);
        menuCamera.bgColor = FlxColor.TRANSPARENT;
        camera = menuCamera;
        add(items = new TextMenuList());
        createPrefItem('Profanity', 'censor-naughty', true);
        createPrefItem('downscroll', 'downscroll', false);
        createPrefItem('flashing menu', 'flashing-menu', true);
        createPrefItem('Zoom on Beat', 'camera-zoom', true);
        createPrefItem('FPS Counter', 'fps-counter', false);
        createPrefItem('Auto Pause', 'auto-pause', false);
        camFollow = new FlxObject(FlxG.width / 2, 0, 140, 70);
        if (items != null) {
            camFollow.y = items.members[items.selectedIndex].y;
        }
        menuCamera.follow(camFollow, null, 0.06);
        menuCamera.deadzone.set(0, 160, menuCamera.width, 40);
        menuCamera.minScrollY = 0;
        items.onChange.add(function(item:TextMenuItem) {
            camFollow.y = item.y;
        });
    }

    public static function getPref(pref:String):Dynamic {
        return preferences.get(pref);
    }

    public static function initPrefs() {
        preferenceCheck('censor-naughty', true);
        preferenceCheck('downscroll', false);
        preferenceCheck('flashing-menu', true);
        preferenceCheck('camera-zoom', true);
        preferenceCheck('fps-counter', true);
        preferenceCheck('auto-pause', true);
        if (getPref('fps-counter')) {
            Lib.current.stage.addChild(Main.fpsCounter);
        }
        FlxG.autoPause = getPref('auto-pause');
    }

    public static function preferenceCheck(identifier:String, defaultValue:Dynamic) {
        if (!preferences.exists(identifier)) {
            preferences.set(identifier, defaultValue);
            trace('set preference!');
        } else {
            trace('found preference: ' + Std.string(preferences.get(identifier)));
        }
    }

    public function createPrefItem(label:String, identifier:String, value:Dynamic) {
        var isBool = (Type.typeof(value) == TBool);
        items.createItem(120, 120 * items.length + 30, label, Bold, function() {
            preferenceCheck(identifier, value);
            if (isBool) prefToggle(identifier);
            else trace('swag');
        });
        if (isBool) createCheckbox(identifier);
        trace(Type.typeof(value));
    }

	public function createCheckbox(identifier:String):Void {
		var box:CheckboxThingie = new CheckboxThingie(0, 120 * (items.length - 1), preferences.get(identifier));
		checkboxes.push(box);
		add(box);
	}

	public function prefToggle(identifier:String):Void {
		var value:Bool = preferences.get(identifier);
		value = !value;
		preferences.set(identifier, value);
		checkboxes[items.selectedIndex].daValue = value;
		trace('toggled? ' + Std.string(preferences.get(identifier)));
		switch (identifier) {
			case 'auto-pause':
				FlxG.autoPause = preferences.get('auto-pause');
				return;
			case 'fps-counter':
				var prefValue:Bool = preferences.get('fps-counter');
				if (value != prefValue) {
					preferences.set(identifier, value);
					checkboxes[items.selectedIndex].daValue = value;
					trace('toggled? ' + Std.string(preferences.get(identifier)));
					if (value) {
						Lib.current.dispatchEvent(new Event("showFpsCounter"));
					} else {
						Lib.current.dispatchEvent(new Event("hideFpsCounter"));
					}
				}
				return;								
		}
	}		
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		menuCamera.followLerp = CoolUtil.camLerpShit(0.05);
		items.forEach(function(item:MenuItem):Void {
			if (item == items.members[items.selectedIndex]) {
				item.x = 150;
			} else {
				item.x = 120;
			}
		});
	}

	public function setArg(arg0:String, isFalse:Bool):Void {}

	public function set(arg0:String, isfalse:Bool):Void {}

	public function getBool(arg0:String, isfalse:Bool):Bool {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get(arg0:String) {
		throw new haxe.exceptions.NotImplementedException();
	}
<<<<<<< HEAD
}
=======
}
>>>>>>> 5ca245dee3d35516523cfe6336374930698a0c96
