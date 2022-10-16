package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;

class DemoFinish extends ExtendedState
{
    override public function create()
    {
        var thanksForPlaying:FlxSprite = new FlxSprite(0,0).loadGraphic('assets/images/demoFinished.png');
        add(thanksForPlaying);
        FlxG.sound.playMusic('assets/music/Credito.ogg');
        super.create();
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.pressed.ENTER)
        {
            FlxG.switchState(new TitleState());
        }
        super.update(elapsed);
    }
}