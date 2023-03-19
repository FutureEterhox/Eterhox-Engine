package;

import flixel.util.FlxStringUtil;

using StringTools;

class ChartParser
{
	static public function parse(songName:String, section:Int):Array<Dynamic>
	{
		var IMG_WIDTH:Int = 8;
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");

		var csvData = FlxStringUtil.imageToCSV(Paths.file('data/' + songName + '/' + songName + '_section' + section + '.png'));

		var lines:Array<String> = regex.split(csvData);
		var rows:Array<String> = lines.filter(function(line) return line != "");
		csvData.replace("\n", ',');

		var heightInTiles:Int = rows.length;
		var widthInTiles:Int = 0;

		var dopeArray:Array<Int> = [];
		for (row in 0...heightInTiles)
		{
			var rowString:String = rows[row];
			if (rowString.endsWith(","))
				rowString = rowString.substr(0, rowString.length - 1);
			var columns:Array<String> = rowString.split(",");

			if (columns.length == 0)
			{
				heightInTiles--;
				continue;
			}
			if (widthInTiles == 0)
			{
				widthInTiles = columns.length;
			}

			for (column in 0...widthInTiles)
			{
				var columnString:String = columns[column];
				var curTile:Int;
				try {
					curTile = Std.parseInt(columnString);
				} catch (e:Dynamic) {
					trace('Error parsing integer in row $row, column $column: "$columnString"');
					curTile = 0;
				}

				if (curTile == 1)
				{
					var tileVal:Int = (column < 4) ? column + 1 : (column + 1) * -1 + 4;
					dopeArray.push(tileVal);
				}
			}

			if (columns.length < widthInTiles)
			{
				for (i in 0...(widthInTiles - columns.length))
				{
					dopeArray.push(0);
				}
			}
		}
		return dopeArray;
	}
}