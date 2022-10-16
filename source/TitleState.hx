package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxRandom;

class TitleState extends ExtendedState
{
    var title:FlxSprite;

    var index:Int = 1;

    public static var playState:PlayState;

    var bg:FlxSprite;

    var text:FlxText;

    var haxe:FlxSprite;

    public static var diaState:DialogueState;

    var wack:Array<String> = 
    [
        "Procrastination.\nThis was written on \nOctober 7th 2022",
        "I'm a bad dev",
        "Am I really that lazy?\nI used FlxText's \ndefault font",
        "assets/data/wack.txt\n#EmptyForLife",
        "Sub to \nFunkyFanta :)"
    ];

    override public function create()
    {

        SaveData.init();
        UniversalData.init();

        #if !html5
        var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(TILES, 0xFF111111, 1.5, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(TILES, 0xFF111111, 1.5, new FlxPoint(0, -1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
        #end

        title = new FlxSprite(0,0).loadGraphic('assets/images/title/Title Screen0001.png');
        add(title);

        FlxG.sound.playMusic('assets/music/Welcome.ogg');

        SaveData.init();

        new FlxTimer().start(0.04, function(tmr:FlxTimer)
        {
            index++;
            if (index > 220)
                index = 1;
            var sIndex:String = '$index';
            var finalPath:String = '';
            switch (sIndex.length)
            {
                case 1:
                    finalPath = 'assets/images/title/Title Screen000' + sIndex + '.png';
                case 2:
                    finalPath = 'assets/images/title/Title Screen00' + sIndex + '.png';
                case 3:
                    finalPath = 'assets/images/title/Title Screen0' + sIndex + '.png';
            }
            title.loadGraphic(finalPath);
            tmr.reset();
        });

        bg = new FlxSprite(0,0).makeGraphic(1280,720,0xFF111111);
        add(bg);

        haxe = new FlxSprite(0,0).loadGraphic('assets/images/Haxe.png');
        haxe.visible = false;
        add(haxe);

        text = new FlxText(0, 0, 'A game made by:', 32, false);
        text.screenCenter();
        add(text);

        new FlxTimer().start(0.23075, function(tmr:FlxTimer)
        {
            curBeat += 0.5;
            onStep();
            tmr.reset();
        });

    }

    override public function onStep()
    {
        switch (curBeat)
        {
            case 2:
                text.text += '\nProgrammer: Cartoon_64';
            case 3:
                text.text += '\nTemporary Musician: Cartoon_64';
            case 4:
                text.text += '\nDirector: Cartoon_64';
            case 5:
                text.text += '\nArtist: Cartoon_64';
            case 6:
                text.text = '';
            case 8:
                text.text = 'A game for:';
            case 10:
                text.text += '\nThe Haxe Community';
                haxe.visible = true;
            case 12:
                var randomInt:FlxRandom = new FlxRandom();
                var int:Int = randomInt.int(0, wack.length);
                text.text = wack[int];
                haxe.visible = false;
            case 15.5:
                bg.visible = false;
                text.visible = false;
        }
        text.alignment = 'center';
        text.screenCenter();
    }

    public static function travel(dest:String)
    {
        playState = new PlayState();
		playState.quickload = dest;
        FlxG.sound.pause();
		FlxG.switchState(playState);
    }

    public static function playDialogue(dia:Array<String>, img:String, dest:String, speaker:String = 'You')
    {
        var diaState = new DialogueState();
        FlxG.sound.pause();
        diaState.setDialogue(img, dia, dest, speaker);
        FlxG.switchState(diaState);
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
        {
            playState = new PlayState();
			playState.quickload = 'grassland';
            FlxG.sound.pause();
			FlxG.switchState(playState);
        }
        if (FlxG.keys.justPressed.ZERO)
        {
            FlxG.save.data.bought = null;
            FlxG.save.data.cash = null;
            FlxG.save.data.steps = null;
            UniversalData.init();
            SaveData.init();
        }
        super.update(elapsed);
    }
}