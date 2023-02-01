import flixel.FlxState;
import flixel.FlxG;

class Swaglikeohio extends FlxState
{
	private var _visitedOutdatedSubState:Bool;

	public function new()
	{
		super();
		_visitedOutdatedSubState = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check if the current state is OutdatedSubState
		if (Std.is(FlxG.state, OutdatedSubState))
		{
			if (!_visitedOutdatedSubState)
			{
				_visitedOutdatedSubState = true;
				trace("You already visited OutdatedSubState")
			}
			else
			{
				// Reset _visitedOutdatedSubState to false when switching to TitleState
				_visitedOutdatedSubState = false;
				trace("This won't work.")
				// Switch to TitleState if the user has already visited OutdatedSubState
				FlxG.switchState(new TitleState());
				trace("This won't work.")
			}
		}
		else if (Std.is(FlxG.state, TitleState))
		{
			// Reset _visitedOutdatedSubState to false when switching to TitleState
			_visitedOutdatedSubState = false;
		}
	}
}
