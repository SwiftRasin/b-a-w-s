import flixel.FlxSprite;

import flixel.FlxG;

class Player extends FlxSprite
{
    public var type:String; // 'normal', 'suit', etc.

    public var acceptedTypes:Array<String> = ['normal','suit'];

    public var speed:Float = 12; //basically frame rate but you can control it.

    public var hasLoaded:Bool = false;

    public var money:Float = 0;

    public function new(x:Float, y:Float, type:String)
    {
        this.type = type;
        super();
        loadSprite();
        this.x = x;
        this.y = y;
    }

    private function fixNaming(type:String):String
    {
        var accepted:Bool = false;
        for (i in 0...acceptedTypes.length)
        {
            if (acceptedTypes[i] == type)
                accepted = true;
        }
        if (!accepted)
            return 'Main';
        else
        {
            var output:String = '';
            switch (type)
            {
                case 'normal':
                    output = 'Main';
                case 'suit':
                    output = 'Suit';
            }
            return output;
        }
    }

    private function loadSprite()
    {
        loadGraphic('assets/images/Player_' + fixNaming(type) + '.png', true, 160, 280);
        animation.add('idle', [0], 0);
        animation.add('walk', [1,2,3], speed);
        playAnimation('idle');
    }

    public function playAnimation(anim:String)
    {
        animation.play(anim);
    }

    public function updateFR()
    {
        //animation.curAnim.frameRate = speed;
    }
}