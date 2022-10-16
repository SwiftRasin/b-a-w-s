package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

import UI.TextBox;

class DialogueState extends ExtendedState
{
    public var image:FlxSprite;
    public var dialogue:TextBox;
    public var img:String;
    public var dia:Array<String>;
    public var index:Int = 0;
    public var dest:String = '';
    public var speaker:String = 'You';
    var line:Array<String> = [];

    override public function create()
    {
        image = new FlxSprite(0,0).loadGraphic(img);
        add(image);

        line = dia[0].split(':');
        dialogue = new TextBox(300,450,line[0] + ':\n' + line[1],'dialogue', line[0],true);
        add(dialogue);
        super.create();
    }
    override public function update(elapsed:Float)
    {
        if (dialogue != null && (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE))
        {
            if (dialogue.isFinished == true)
            {
                index++;
                if (dia.length > index)
                {
                    remove(dialogue);
                    new FlxTimer().start(0.2,function(tmr:FlxTimer)
                    {
                        line = dia[index].split(':');
                        dialogue = new TextBox(300,450,line[0] + ':\n' + line[1],'dialogue', line[0],true);
                        add(dialogue);
                    });
                }
                else
                {
                    TitleState.travel(dest);
                }
            }
        }
        super.update(elapsed);
    }

    public function setDialogue(img:String, dia:Array<String>, dest:String, speaker:String)
    {
        this.dest = dest;
        this.dia = dia;
        this.img = 'assets/images/cutscene/' + img + '.png';
        this.speaker = speaker;
    }
}