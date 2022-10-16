package;

import flixel.FlxG;

class SaveData
{
    public static var curGear:String = '';

    public static var boughtItems:Array<UI.ShopItem> = [];

    public static function init()
    {
        #if !html5
        if (FlxG.save.data.gear == null)
        {
            FlxG.save.data.gear = 'none';
            curGear = 'none';
        }
        else
        {
            curGear = FlxG.save.data.gear;
        }
        if (FlxG.save.data.bought == null)
        {
            FlxG.save.data.bought = [];
            boughtItems = [];
        }
        else
        {
            boughtItems = FlxG.save.data.bought;
        }

        if (FlxG.save.data.money == null)
            FlxG.save.data.money = 0;
        if (FlxG.save.data.steps == null)
            FlxG.save.data.steps = 0;
        #end
    }

    public static function update()
    {
        
    }
}
