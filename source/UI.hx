package;

import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup as FlxGroup;
import flixel.util.FlxColor;

class UI
{

}

class StaticGUI extends FlxSubState
{
    public var steps:StaticUI;
    public var cash:StaticUI;

    public var item:StaticItem;
    public function new(x:Float, y:Float, ?item:String = '')
    {
        super();
    }

    override public function create()
    {
        cash = new StaticUI(1080, 45, 'cash');
        add(cash);
        steps = new StaticUI(960, 12, 'steps');
        add(steps);
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}

class StaticItem extends FlxSprite
{
    public function new(x:Float,y:Float, type:String)
    {
        super();
        loadGraphic('assets/images/ui/' + type + '.png');
    }
}

class StaticUI extends FlxSubState
{
    public var type:String = '';
    public var value:Float = 0;

    public var text:FlxText;

    public var sprite:FlxSprite;

    public var xS:Float;
    public var yS:Float;

    public function new(xS:Float, yS:Float, type:String, x:Float = 0, y:Float = 0)
    {
        super();
        this.type = type;
        this.xS = xS;
        this.yS = yS;

        loadSprite();
    }

    public function updateText()
    {
        text.text = Std.string(value);
        text.alignment = 'center';
    }

    private function loadSprite()
    {

        remove(sprite);
        sprite = new FlxSprite(xS,yS);
        add(sprite);

        text = new FlxText(xS,yS, '222', 12, false);
        add(text);
        text.y = yS;
        text.x = xS;

        text.size = 32;

        switch (type)
        {
            case "cash":
                sprite.loadGraphic('assets/images/ui/Cash.png');
                value = 0;
                text.y += 72;
                text.x += 60;
            case 'steps':
                sprite.loadGraphic('assets/images/ui/Steps.png');
                value = 0;
                text.y += 45;
                text.x += 32;
        }
    }
}

class ShopItem extends FlxButton
{
    public var cost:Float = 0;
    public var name:String = '';
    public var hasBeenBought:Bool = false;

    public var onBuy:Void -> Void;
    public var onFailBuy:Void -> Void;

    public var hasBeenPressed:Bool = false;

    public var linkedShop:Shop;

    public var lighted:Bool = false;

    public function new(cost:Float, name:String, hasBeenBought:Bool, ?onBuy:Void -> Void, ?onFailBuy:Void -> Void, ?x:Float = 0, ?y:Float = 0)
    {
        super();
        this.cost = cost;
        this.name = name;
        this.hasBeenBought = hasBeenBought;
        this.onBuy = onBuy;
        for (item in 0...FlxG.save.data.bought.length)
        {
            if (FlxG.save.data.bought[item].name == name)
                this.hasBeenBought = true;
        }
        text = name;
        label.size = 18;
        label.y += 50;
        scale.x = 2;
        scale.y = 2.5;
        updateHitbox();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.mouse.overlaps(this))
        {
            lighted = true;
        }
        else
        {
            lighted = false;
        }
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed)
        {
            buy();
            hasBeenPressed = true;
        }
    }

    public function buy()
    {
        TitleState.playState.shop.updateSideBar(this);
    }
}

class Shop extends FlxSubState
{
    public var id:String;

    public var selectedItem:String;
    public var selectedItemID:Int;

    public var litItem:ShopItem;

    public var items:Array<ShopItem>;

    public var overlayName:FlxText;
    public var overlayIcon:FlxSprite;
    public var overlayCost:FlxText;
    public var hasBought:FlxText;

    public var shopItems:FlxGroup<ShopItem>;

    public var buyButton:FlxButton;

    override public function new(x:Float,y:Float,items:Array<ShopItem>,?id:String = 'grassland-shop')
    {
        this.items = items;
        this.id = id;
        super();
    }

    override public function create()
    {
        var bg = new FlxSprite(0,0).makeGraphic(1280,720,0x7B3392FF);
        bg.scrollFactor.x = 0;
        bg.scrollFactor.y = 0;
        add(bg);

        shopItems = new FlxGroup<ShopItem>(100);
        add(shopItems);

        for (item in 0...items.length)
        {
            var shopItem = items[item];
            shopItems.add(shopItem);
            shopItem.x = 500 * item;
            shopItem.label.fieldWidth = shopItem.width;
            shopItem.label.y += 100;
            if (item == 0)
                shopItem.x = 150;
            shopItem.y += 150;
            shopItem.linkedShop = this;
            if (shopItem.x > 950)
            {
                shopItem.x = 150;
                shopItem.y += 150;
            }
        }

        var overlay:FlxSprite = new FlxSprite(0,0).loadGraphic('assets/images/shopOverlay.png');
        add(overlay);
        overlay.scrollFactor.x = 0;
        overlay.scrollFactor.y = 0;

        overlayName = new FlxText(980,30,'',32);
        add(overlayName);
        overlayName.alignment = 'center';
        overlayName.scrollFactor.x = 0;
        overlayName.scrollFactor.y = 0;

        overlayIcon = new FlxSprite(947,100).makeGraphic(300,300,FlxColor.WHITE);
        add(overlayIcon);
        overlayIcon.scrollFactor.x = 0;
        overlayIcon.scrollFactor.y = 0;

        var wrap:FlxSprite = new FlxSprite(947,94.55).loadGraphic('assets/images/items/Wrap Around.png');
        add(wrap);
        wrap.scrollFactor.x = 0;
        wrap.scrollFactor.y = 0;

        overlayCost = new FlxText(1000,450,'',25);
        add(overlayCost);
        overlayCost.alignment = 'center';
        overlayCost.scrollFactor.x = 0;
        overlayCost.scrollFactor.y = 0;

        hasBought = new FlxText(1020,540,'',20);
        add(hasBought);
        hasBought.alignment = 'center';
        hasBought.scrollFactor.x = 0;
        hasBought.scrollFactor.y = 0;

        buyButton = new FlxButton(1000, 610, '     Buy', function()
        {
            if (litItem != null)
            {
                if (TitleState.playState.player.money > litItem.cost)
                {
                    TitleState.playState.player.money -= litItem.cost;
                    litItem.hasBeenBought = true;
                    FlxG.save.data.bought.push(litItem.name);
                    litItem.onBuy();
                    TitleState.playState.onShopBuy(this, litItem);
                    trace('Player has successfully bought ' + litItem.name + '! PLAYER MONEY: ' + TitleState.playState.player.money);
                }
                else
                {
                    trace('Player has insufficient money for ' +  litItem.name + '! PLAYER MONEY: ' + TitleState.playState.player.money + ', ITEM COST: ' + litItem.cost);
                    TitleState.playState.onFailShopBuy(this, litItem);
                }
            }
        });
        buyButton.label.size = 18;
        buyButton.label.alignment = 'center';
        buyButton.label.y += 50;
        buyButton.scale.x = 1.5;
        buyButton.scale.y = 2;
        buyButton.updateHitbox();
        add(buyButton);

/*        overlay.x += 420;
        overlayIcon.x += 420;
        overlayCost.x += 420;
        hasBought.x += 420;
        overlayName.x += 420;

        overlay.y += 30;
        overlayIcon.y += 30;
        overlayCost.y += 30;
        hasBought.y += 30;
        overlayName.y += 30;
*/
        super.create();
    }

    public function updateSideBar(item:ShopItem)
    {
        litItem = item;
        overlayName.text = litItem.name;
        overlayIcon.loadGraphic('assets/images/items/' + litItem.name + '.png');
        overlayCost.text = '' + litItem.cost + '$';
        var hasB:Bool = false;
        for(i in 0...FlxG.save.data.bought.length) {
            if(FlxG.save.data.bought[i] == litItem.name)
                hasB = true;
        }
        if(hasB)
            hasBought.text = 'Already\nBought';
        else
            hasBought.text = 'Has not\nBought';
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
        {
            TitleState.playState.inUI = false;
            close();
        }
        super.update(elapsed);
    }
}

class Options extends FlxSubState
{
    public var button:FlxSprite;
    public var button2:FlxSprite;
    public var button3:FlxSprite;
    public var button4:FlxSprite;
    public var button5:FlxSprite;
    public var button6:FlxSprite;
    public var button7:FlxSprite;
    public var button8:FlxSprite;

    public var label:FlxText;
    public var label2:FlxText;
    public var label3:FlxText;
    public var label4:FlxText;

    public var options:Array<String> = [];
    public function new(x:Float, y:Float, options:Array<String>)
    {
        this.options = options;
        super();
        button = new FlxSprite(x, y).loadGraphic('assets/images/ui/Button.png');
        add(button);
        label = new FlxText(x + 5, y + 5, 0, options[0], 8);
        add(label);

        button2 = new FlxSprite(x + 200, y).loadGraphic('assets/images/ui/Button.png');
        add(button2);
        label2 = new FlxText(x + 205, y + 5, 0, options[1], 8);
        add(label2);

        button3 = new FlxSprite(x, y + 100).loadGraphic('assets/images/ui/Button.png');
        add(button3);
        label3 = new FlxText(x + 5, y + 105, 0, options[2], 8);
        add(label3);

        button4 = new FlxSprite(x + 200, y + 100).loadGraphic('assets/images/ui/Button.png');
        add(button4);
        label4 = new FlxText(x + 205, y + 105, 0, options[3], 8);
        add(label4);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.justPressed)
        {
            if (FlxG.mouse.overlaps(button))
            {
                TitleState.playState.uiButtonClick(options[0]);
            }
            else if (FlxG.mouse.overlaps(button2))
            {
                TitleState.playState.uiButtonClick(options[1]);
            }
            else if (FlxG.mouse.overlaps(button3))
            {
                TitleState.playState.uiButtonClick(options[2]);
            }
            else if (FlxG.mouse.overlaps(button4))
            {
                TitleState.playState.uiButtonClick(options[3]);
            }
        }
    }
}

class TextBox extends FlxSubState
{
    var text:String;

    public var id:String;

    var typeText:FlxTypeText;

    var bubble:FlxSprite;

    public var talker:String = 'Cashier';

    public var isFinished:Bool = false;

    public var hasNoPrefix:Bool = false;

    public function new(x:Float, y:Float, text:String, ?id:String = 'testShop1', ?talker:String = 'Cashier', ?noPrefix:Bool = false)
    {
        this.talker = talker;
        this.id = id;
        super();
        bubble = new FlxSprite(x,y).loadGraphic('assets/images/ui/Speech Bubble.png');
        add(bubble);

        typeText = new FlxTypeText(x + 50, y + 60, 10000, text, 20, false);
        add(typeText);
        if (noPrefix == false)
            typeText.prefix = talker + ":\n";
        switch (talker)
        {
            case 'Cashier':
                typeText.sounds = [FlxG.sound.load('assets/sounds/Cashier.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier2.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier3.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier4.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier5.ogg', 1)];
            case 'You'|'Player':
                typeText.sounds = [FlxG.sound.load('assets/sounds/Player.ogg', 1),
                FlxG.sound.load('assets/sounds/Player2.ogg', 1),
                FlxG.sound.load('assets/sounds/Player3.ogg', 1),
                FlxG.sound.load('assets/sounds/Player4.ogg', 1),
                FlxG.sound.load('assets/sounds/Player5.ogg', 1)];
            default:
                typeText.sounds = [FlxG.sound.load('assets/sounds/Cashier.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier2.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier3.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier4.ogg', 1),
                FlxG.sound.load('assets/sounds/Cashier5.ogg', 1)];
        }
        typeText.skipKeys = [FlxKey.SPACE, FlxKey.ENTER];


        typeText.start(0.04615, false, false, [FlxKey.SPACE, FlxKey.ENTER], onFinish);
    }

    private function onFinish()
    {
        trace('finished playing dialogue');
        isFinished = true;
    }
}
