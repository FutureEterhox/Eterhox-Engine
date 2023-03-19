package;

import openfl.utils.Object;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import openfl.media.Video;
import flixel.FlxBasic;
import flixel.FlxG;

using StringTools;

class FlxVideo extends FlxBasic {
    
    private var _video:Video;
    private var _netStream:NetStream;
    public var finishCallback:Dynamic;

    public function new(videoAsset:String) {
        super();

        // Initialize video and add it to the FlxG's display list
        _video = new Video();
        _video.x = 0;
        _video.y = 0;
        FlxG.stage.addChild(_video);

        // Initialize NetConnection and NetStream to play the video
        var netConnection:NetConnection = new NetConnection();
        netConnection.connect(null);
        _netStream = new NetStream(netConnection);
        _netStream.client = { onMetaData: onMetaData };
        netConnection.addEventListener("netStatus", onNetStatus);
        _netStream.play(Paths.file(videoAsset));
    }

    public function finishVideo():Void {
        _netStream.dispose();
        if (_video.parent != null) {
            _video.parent.removeChild(_video);
        }
        if (finishCallback != null) {
            finishCallback();
        }
    }

    private function onMetaData(metadata:Object):Void {
        _video.attachNetStream(_netStream);
        _video.width = FlxG.width;
        _video.height = FlxG.height;
    }

    private function onNetStatus(event:Object):Void {
        if (event.info.code == "NetStream.Play.Complete") {
            finishVideo();
        }
    }

    override public function destroy():Void {
        _netStream.close();
        super.destroy();
    }
}