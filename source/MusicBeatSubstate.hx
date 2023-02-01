package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxSubState;

class MusicBeatSubstate extends FlxSubState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public function new()
	{
		super();
	}

	override function update(elapsed:Float)
	{
		var oldStep:Int = curStep;
		updateCurStep();
		curBeat = Math.floor(curStep / 4);
		if (oldStep != curStep && curStep >= 0)
		{
			stepHit();
		}
		super.update(elapsed);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		};
		for (bpmChange in Conductor.bpmChangeMap)
		{
			if (Conductor.songPosition >= bpmChange.songTime)
			{
				lastChange = bpmChange;
			}
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	private function stepHit():Void
	{
		if (curStep % 4 == 0)
		{
			beatHit();
		}
	}

	private function beatHit():Void
	{
		// don't do shit here
	}
}
