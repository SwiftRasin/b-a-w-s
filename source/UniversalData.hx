package;

import flixel.FlxG;

class UniversalData
{
    public static var cash:Float;
    public static var steps:Float;

    public static var boughtItems:Array<String>;

    public static function updateVars()
    {
        FlxG.save.data.steps = steps;
        FlxG.save.data.cash = cash;
    }

    public static function init()
    {
        if (FlxG.save.data.steps == null)
            FlxG.save.data.steps = 0;
        if (FlxG.save.data.bought == null)
            FlxG.save.data.bought = [];
        if (FlxG.save.data.cash == null || Math.isNaN(FlxG.save.data.cash))
            FlxG.save.data.cash = 0;
        cash = FlxG.save.data.cash;
        steps = FlxG.save.data.steps;
        boughtItems = FlxG.save.data.bought;
    }
}