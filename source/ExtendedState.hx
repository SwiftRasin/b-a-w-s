package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.FlxState;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;

import flixel.util.FlxTimer;

class ExtendedState extends FlxUIState
{
    public var bpm:Int = 130;
    public var curBeat:Float = 0;

    public function onStep()
    {
            
    }

    public function new()
    {
        super();
    }
}