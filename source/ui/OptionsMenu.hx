package ui;

import flixel.FlxG;

class OptionsMenu extends Page {
    var items:TextMenuList;

    public function new(showDonate:Bool) {
        super();
        items = new TextMenuList();
        add(items);
        createItem('preferences', switchToPage(PageName.Preferences));
        createItem('controls', switchToPage(PageName.Controls));
        if (showDonate) createItem('donate', openDonatePage, true);
        createItem('exit', exit);
    }

    private function createItem(label:String, callback:Dynamic, fireInstantly:Bool = false):TextMenuItem {
        var item:TextMenuItem = items.createItem(0, 100 + 100 * items.length, label, Bold, callback);
        item.fireInstantly = fireInstantly;
        item.screenCenter(X);
        return item;
    }

    override function set_enabled(state:Bool):Bool {
        items.enabled = state;
        return super.set_enabled(state);
    }

    public function hasMultipleOptions():Bool {
        return items.length > 2;
    }

    private function switchToPage(pageName:PageName):Dynamic {
        return function() {
            onSwitch.dispatch(pageName);
        };
    }

    private function openDonatePage():Void {
        #if linux
        Sys.command('/usr/bin/xdg-open', ["https://github.com/bloxee/Eterhox-Engine", "&"]);
        #else
        FlxG.openURL('https://github.com/bloxee/Eterhox-Engine');
        #end
    }
}
