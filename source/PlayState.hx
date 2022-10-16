package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class PlayState extends ExtendedState
{
	public var player:Player;

	var clouds:FlxSprite;

	var shopDoor:FlxSprite;

	var stageIsLoaded:Bool = false;

	public var quickload:String = '';

	public var loadTime:Float = 0;

	public var inUI:Bool = false;

	public var stageRestrictions:Array<Dynamic> = [
		/**(Walking Area) min X, max X, (Cameral Scroll Bounds) minX, maxX, minY, maxY**/
	]; 
	//The area you're able to walk, how far the camera scrolls, etc.

	public var bubble:UI.TextBox;

	public static var staticStage:String;

	public var shop:UI.Shop;

	public var item:UI.StaticItem;

	public var overriddenPositionX:Float = 0;
	public var overriddenPositionY:Float = 0;

	public var stageSong:FlxSound;

	public var lastStageName:String = '';

	public var gui:UI.StaticGUI;

	public var animationLastFrame:Int = 0;

	public var steps:UI.StaticUI;

	public var cash:UI.StaticUI;

	public var sellButton:FlxSprite;

	var mirror:FlxSprite;

	var reflection:Player;

	public var chaser:Reflection;

	public var unableToMove:Bool = false;

	public var isChasing:Bool = false;

	public var inCutscene:Bool = false;

	public var task:String = '';

	public var boughtSpeedShoes:Bool = false;

/*	public function new(quickload:String = 'shop')
	{
		super();
		if (quickload != null)
			this.quickload = quickload;
		else
		{
			trace('NULL STAGE, LOADING "grassland"...');
			this.quickload = 'grassland';
		}
	}
*/	

	override public function create()
	{
		super.create();

		for (i in 0...FlxG.save.data.bought.length)
		{
			if (FlxG.save.data.bought[i] == 'Speed Shoes')
				boughtSpeedShoes = true;
		}

		if (quickload != null)
			loadStage(quickload);
		else
		{
			trace('NULL STAGE, LOADING "grassland"...');
			loadStage('grassland');
		}

		staticStage = quickload;

		player = new Player(0,400,'suit');
		player.screenCenter(X);
		add(player);
		player.scale.x = 0.8;
		player.scale.y = 0.8;
		player.hasLoaded = true;
		player.money = UniversalData.cash;
		if (overriddenPositionX != 0 && overriddenPositionY != 0)
		{
			player.x = overriddenPositionX;
			player.y = overriddenPositionY;
		}
		if (boughtSpeedShoes)
		{
			player.animation.curAnim.frameRate = 24;
		}

		if (quickload == 'mirrors')
		{
			reflection = new Player(0,400,'suit');
			reflection.screenCenter(X);
			add(reflection);
			reflection.scale.x = 0.8;
			reflection.scale.y = 0.8;
			reflection.hasLoaded = true;
			reflection.money = UniversalData.cash;
			if (overriddenPositionX != 0 && overriddenPositionY != 0)
			{
				reflection.x = overriddenPositionX;
				reflection.y = overriddenPositionY;
			}
			reflection.flipY = true;
			if (boughtSpeedShoes)
			{
				reflection.animation.curAnim.frameRate = 24;
			}
		}

//		gui = new UI.StaticGUI(0,0);
//		super.openSubState(gui);

		cash = new UI.StaticUI(1080, 45, 'cash');
		cash.sprite.scrollFactor.x = 0;
		cash.sprite.scrollFactor.y = 0;
		cash.text.scrollFactor.x = 0;
		cash.text.scrollFactor.y = 0;
		add(cash);
		steps = new UI.StaticUI(960, 12, 'steps');
		steps.sprite.scrollFactor.x = 0;
		steps.sprite.scrollFactor.y = 0;
		steps.text.scrollFactor.x = 0;
		steps.text.scrollFactor.y = 0;
		add(steps);
		if (boughtSpeedShoes == false)
        {
            item = new UI.StaticItem(1080, (45 + cash.sprite.height) + 30, 'Empty');
            add(item);
        }
        else
        {
            item = new UI.StaticItem(1080, (45 + cash.sprite.height) + 30, 'Shoe Equipped');
            add(item);
        }

		cash.value = UniversalData.cash;
		steps.value = UniversalData.steps;

		sellButton = new FlxSprite(880,12).loadGraphic('assets/images/ui/Sell.png');
		sellButton.scrollFactor.x = 0;
		sellButton.scrollFactor.y = 0;
		add(sellButton);

		doTask();
	}

	private function doTask()
	{
		trace("doin' task " + task);
		switch (task)
		{
			case 'breakDoor':
				playCutscene('breakDoor');
			case 'what':
				playCutscene('what');
		}
	}

	private function modifyPlayerPosition(?setX:Float = 0, ?setY:Float = 0, ?modify:Bool = false)
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if (player.hasLoaded == true)
			{
				if (overriddenPositionX == 0 && overriddenPositionY == 0)
				{
					if (modify)
					{
						player.x += setX;
						player.y += setY;
					}
					else
					{
						player.x = setX;
						player.y = setY;
					}
				}
			}
			else
			{
				tmr.reset();
			}
		});
	}

	public function uiButtonClick(option:String)
	{
		if (quickload == 'shop')
		{
			remove(bubble);
			var hasBought:Bool = false;
			for (item in 0...FlxG.save.data.bought.length)
			{
				if (FlxG.save.data.bought[item] == option)
				{
					hasBought = true;
				}
			}
			if (hasBought)
			{
				bubble = new UI.TextBox(460, 400, "You've already bought this.");
				add(bubble);
			}
			else
			{
				bubble = new UI.TextBox(460, 400, "The cost of this item is TESTCURRENCY.");
				add(bubble);
			}
		}
	}

	private function travel(name:String, ?task:String = 'nothing')
	{
		var newState = new PlayState();
		newState.quickload = name;
		newState.lastStageName = quickload;
		newState.task = task;
		TitleState.playState = newState;
		FlxG.switchState(newState);
	}

	public function onShopBuy(shop:UI.Shop, item:UI.ShopItem)
	{
		super.closeSubState();
		if (shop.id == 'grassland-shop')
		{
			switch (item.name)
			{
				case "Speed Shoes":
					remove(bubble);
					bubble = new UI.TextBox(460, 400, "Cool, you can go faster \nnow.");
					bubble.id = 'exit-after-shoes';
					add(bubble);
				case "Key":
					remove(bubble);
					bubble = new UI.TextBox(460, 400, "By the way, this is a \none time ticket to the\nfield.");
					bubble.id = 'field-access';
					add(bubble);
				case "Mirror":
					remove(bubble);
					bubble = new UI.TextBox(460, 400, "Huh, I wonder why we sell these-");
					bubble.id = 'mirror-access';
					add(bubble);
				default:
					remove(bubble);
					bubble = new UI.TextBox(460, 400, "Cool, you actually \nbought something.");
					bubble.id = 'exit-after';
					add(bubble);
			}
		}
	}

	public function onFailShopBuy(shop:UI.Shop, item:UI.ShopItem)
	{
		super.closeSubState();
		if (shop.id == 'grassland-shop')
		{
			switch (item.name)
			{
				case "Speed Shoes":
					remove(bubble);
					bubble = new UI.TextBox(460, 400, "Maybe you should get \nmore steps and money,\nbefore you can walk faster.");
					bubble.id = 'exit-after';
					add(bubble);
				default:
					remove(bubble);
					bubble = new UI.TextBox(460, 400, "You'll need more\nmoney, sir.");
					bubble.id = 'exit-after';
					add(bubble);
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		player.updateFR();

//		clouds.x = player.x;
//		clouds.y = player.y;

		if (FlxG.keys.justPressed.M)
		{
			#if debug
				player.money += 1000;
			#end
		}

		if (quickload == 'mirrors')
		{
			reflection.x = player.x;
			reflection.y = (player.y + player.height) - 40;
			reflection.alpha = 0.6;
		}		

		if ((animationLastFrame != player.animation.curAnim.curFrame) && player.animation.curAnim.curFrame == 2)
		{
			steps.value += 1;
		}

		cash.value = player.money;

		animationLastFrame = player.animation.curAnim.curFrame;

		UniversalData.cash = cash.value;
		UniversalData.steps = steps.value;
		UniversalData.updateVars();

		steps.updateText();
		cash.updateText();

		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(sellButton))
		{
			player.money += steps.value;
			steps.value = 0;
		}

		if (FlxG.mouse.overlaps(sellButton))
		{
			sellButton.scale.x = 1.1;
			sellButton.scale.y = 1.1;
		}
		else
		{
			sellButton.scale.x = 1;
			sellButton.scale.y = 1;
		}

		if (stageIsLoaded && shopDoor != null && player.overlaps(shopDoor) && FlxG.keys.justPressed.ENTER)
		{
			if (quickload == 'grassland')
			{
				travel('shop');
			}
			else if (quickload == 'shop')
			{
				travel('grassland');
			}
			else if (quickload == 'field')
			{
				travel('shop');
			}
		}

		if (stageIsLoaded && player.hasLoaded == true && player.x == 1100 && FlxG.keys.justPressed.ENTER && inUI == false)
		{
			inUI = true;
			bubble = new UI.TextBox(460, 400, "What do you want? \nI've been working a 7 hour\nshift, please don't take a long\ntime.");
			bubble.id = 'what-do-you-want';
			add(bubble);
		}

		if (bubble != null && bubble.isFinished == true && FlxG.keys.justPressed.ENTER && inUI == true && quickload == 'shop' && bubble != null && bubble.id == 'what-do-you-want')
		{
			remove(bubble);
			var item1:UI.ShopItem = new UI.ShopItem(200, 'Speed Shoes', false, function(){}, function(){});
			var item2:UI.ShopItem = new UI.ShopItem(500, 'Key', false, function(){}, function(){});
			var item3:UI.ShopItem = new UI.ShopItem(700, 'Mirror', false, function(){}, function(){});
			shop = new UI.Shop(0,0,[item1,item2,item3]);
//			add(shop);
			super.openSubState(shop);
		}
		if (bubble != null && bubble.isFinished == true && FlxG.keys.justPressed.ENTER && inUI == true && quickload == 'shop' && bubble != null)
		{
			switch (bubble.id)
			{
				case "exit-after":
					remove(bubble);
					inUI = false;
				case "exit-after-shoes":
					remove(bubble);
					inUI = false;
					travel('shop');
				case "field-access":
					travel('field');
				case "mirror-access":
					travel('mirrors');
			}
		}

		if (FlxG.keys.justPressed.P)
		{
			trace('POSITION: ' + player.x + ", " + player.y);
			trace("STAGE NAME: '" + quickload + "'");
//			trace('CLOUDS POSITION: ' + clouds.x + ", " + clouds.y);
		}

		if ((FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT) && inUI == false)
		{
			if (FlxG.keys.pressed.LEFT)
			{
				player.flipX = true;
				if (player.x > stageRestrictions[0])
				{
					if (boughtSpeedShoes)
						move(-10);
					else
						move(-5);
				}
				else
				{
					player.playAnimation('idle');
				}

				if (quickload == 'mirrors')
				{
					reflection.flipX = true;
				}
			}
			else if (FlxG.keys.pressed.RIGHT)
			{
				player.flipX = false;
				if (player.x < stageRestrictions[1])
				{
					if (boughtSpeedShoes)
						move(10);
					else
						move(5);
				}
				else
				{
					player.playAnimation('idle');
				}

				if (quickload == 'mirrors')
				{
					reflection.flipX = false;
				}
			}
		}
		else
		{
			player.flipX = false;
			player.playAnimation('idle');
			if (quickload == 'mirrors')
			{
				reflection.playAnimation('idle');
				reflection.flipX = false;
			}
		}

		if (quickload == 'mirrors')
		{
			mirror.framePixels = FlxG.camera.buffer;
			mirror.visible = false;
		}

		if (player.x == 3320 && quickload == 'mirrors' && unableToMove != true && inCutscene == false)
		{
			unableToMove = true;
			inCutscene = true;
			trace("someone's coming...");
			playCutscene('mirrors1');
		}

		if (player.x == 7940 && isChasing == true && quickload == 'mirrors')
		{
			task = 'breakDoor';
			travel('shop', 'breakDoor');
		}

		if (quickload == 'mirrors' && chaser != null && player.overlaps(chaser))
		{
			travel('shop', 'what');
		}
	}

	private function move(amount:Float)
	{
		if (unableToMove == false)
		{
			player.x += amount;
			
			player.playAnimation('walk');
			if (boughtSpeedShoes)
				player.animation.curAnim.frameRate = 24;
			if (quickload == 'mirrors')
			{
				reflection.playAnimation('walk');
				if (boughtSpeedShoes)
					reflection.animation.curAnim.frameRate = 24;
			}
		}
	}

	private function setStageSong(sound:FlxSound)
	{
		stageSong = sound;
		stageSong.looped = true;
		stageSong.play(true);
	}

	/**(Walking Area) min X, max X, (Cameral Scroll Bounds) minX, maxX, minY, maxY
	 * /****/
	private function setStageRestrictions(minX, maxX, camMinX, camMaxX, camMinY, camMaxY, ?cameraFollowsPlayer:Bool = true)
	{
		stageRestrictions = [minX, maxX, camMinX, camMaxX, camMinY, camMaxY];
		FlxG.camera.setScrollBounds(camMinX, camMaxX, camMinY, camMaxY);

		if (cameraFollowsPlayer)
		{
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if (player.hasLoaded == true)
				{
					FlxG.camera.follow(player);
				}
				else
				{
					tmr.reset();
				}
			});
		}
	}

	public function playCutscene(instance:String)
	{
		trace('PLAYING CUTSCENE INSTANCE ' + instance + '! GET POPCORN NOW!');
		unableToMove = true;
		inCutscene = true;
		switch (instance)
		{
			case "what":
				trace('well that did not work out');
				player.flipX = true;
				new FlxTimer().start(1,function(tmr:FlxTimer)
				{
					bubble = new UI.TextBox(460, 400, "Where were you?");
					add(bubble);
					new FlxTimer().start(2,function(tmr2:FlxTimer)
					{
						travel('shop');
					});
				});
			case 'breakDoor':
				trace('uh oh');
				var loop:Int = 0;
				var sX:Float = shopDoor.x;
				var sY:Float = shopDoor.y + 55;
				remove(shopDoor);
				shopDoor = new FlxSprite(sX,sY).loadGraphic('assets/images/Broken Door.png');
				add(shopDoor);
				player.flipX = true;
				new FlxTimer().start(1,function(tmr:FlxTimer)
				{
					bubble = new UI.TextBox(460, 400, "Well, I'm gonna have \nto replace that \nsoon.");
					bubble.id = 'world2';
					add(bubble);
					new FlxTimer().start(4,function(tmr2:FlxTimer)
					{
						TitleState.playDialogue(['You:What was that thing?',
						'Cashier:Like, in the mirror?',
						'You:My reflection disappeared, \nThen it chased me!',
						"Cashier:What was up \nwith that?",
						"Cashier:I don't get \npaid enough to go out\nof my way to figure \nit out.",
						"You: I can tell.."],'AfterMirror1',quickload);
					});
				});
			case 'mirrors1':
				FlxG.sound.pause();
				var loop:Int = 0;
				new FlxTimer().start(0,function(tmr:FlxTimer)
				{
					trace('loop: ' + loop);
					switch (loop)
					{
						case 0:
							FlxG.sound.play('assets/sounds/Downhill.ogg');
							reflection.visible = false;
							tmr.reset(5);
						case 1:
							chaser = new Reflection(630,400,'suit');
							add(chaser);
							chaser.scale.x = 0.8;
							chaser.scale.y = 0.8;
							tmr.reset(0.1);
						case 2:
							FlxG.camera.follow(chaser);
							tmr.reset(2);
						case 3:
							FlxTween.tween(chaser, {x: 7950}, 10.7);
							chaser.speed = 30;
							chaser.playAnimation('walk');
							tmr.reset(2);
						case 4:
							FlxG.camera.follow(player);
							isChasing = true;
							unableToMove = false;
							setStageSong(FlxG.sound.load('assets/music/Chasing My Reflection.ogg', 1, true));
					}
					loop++;
				});
		}
	}

	public function loadStage(stage:String)
	{
		if (stageIsLoaded == false)
		{
			switch (stage)
			{
				case "grassland":
					var sky:FlxSprite = new FlxSprite(0,-40).loadGraphic('assets/images/grassland/Sky.png');
					sky.scrollFactor.x = 0;
					sky.scrollFactor.y = 0;
					add(sky);
					clouds = new FlxSprite(70,-100).loadGraphic('assets/images/grassland/Clouds.png');
					clouds.scrollFactor.x = 0.1;
					clouds.scrollFactor.y = 0;
					add(clouds);
					var grass:FlxSprite = new FlxSprite(0,-100).loadGraphic('assets/images/grassland/Grass.png');
					add(grass);
					var shopSign:FlxSprite = new FlxSprite(1115,480).loadGraphic('assets/images/grassland/Shop Sign.png');
					shopSign.scrollFactor.x = 0.9;
					shopSign.scrollFactor.y = 0;
					add(shopSign);
					shopDoor = new FlxSprite(1855,330).loadGraphic('assets/images/grassland/Magic Door.png');
					shopDoor.scrollFactor.x = 0.9;
					shopDoor.scrollFactor.y = 0;
					add(shopDoor);
					setStageRestrictions(570, 2180, 570, 2340, 500, 720, true);
					modifyPlayerPosition(500, 0, true);
					setStageSong(FlxG.sound.load('assets/music/Fields.ogg', 1, true));
				case "field":
					var sky:FlxSprite = new FlxSprite(0,-40).loadGraphic('assets/images/grassland/Sky.png');
					sky.scrollFactor.x = 0;
					sky.scrollFactor.y = 0;
					add(sky);
					clouds = new FlxSprite(70,-100).loadGraphic('assets/images/field/Clouds.png');
					clouds.scrollFactor.x = 0.1;
					clouds.scrollFactor.y = 0;
					add(clouds);
					var grass:FlxSprite = new FlxSprite(-30,-100).loadGraphic('assets/images/field/Grass.png');
					add(grass);
					shopDoor = new FlxSprite(1000,330).loadGraphic('assets/images/grassland/Magic Door.png');
					shopDoor.scrollFactor.x = 0.9;
					shopDoor.scrollFactor.y = 0;
					add(shopDoor);
					setStageRestrictions(570, 5850, 570, 6000, 500, 720, true);
					modifyPlayerPosition(600, 0, true);
					setStageSong(FlxG.sound.load('assets/music/Fields.ogg', 1, true));
				case "mirrors":
					var bg:FlxSprite = new FlxSprite(0,0).makeGraphic(1280,720, FlxColor.WHITE);
					bg.scrollFactor.x = 0;
					bg.scrollFactor.y = 0;
					add(bg);
					var islands:FlxSprite = new FlxSprite(-260,-150).loadGraphic('assets/images/mirror/Islands.png');
					add(islands);
					FlxTween.tween(islands, {y: islands.y + 50}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});
					var ground:FlxSprite = new FlxSprite(-25,600).loadGraphic('assets/images/mirror/Floor.png');
					add(ground);
					mirror = new FlxSprite(0,598).makeGraphic(1280,720);
					mirror.scrollFactor.x = 0;
					mirror.scrollFactor.y = 0;
					add(mirror);
					shopDoor = new FlxSprite(1000,330).loadGraphic('assets/images/grassland/Magic Door.png');
					shopDoor.scrollFactor.x = 0.9;
					shopDoor.scrollFactor.y = 0;
					add(shopDoor);
					setStageRestrictions(570, 8000, 570, 7950, 500, 720, true);
					modifyPlayerPosition(600, 0, true);
					setStageSong(FlxG.sound.load('assets/music/Reflection.ogg', 1, true));
				case "shop":
					var main:FlxSprite = new FlxSprite(0,0).loadGraphic('assets/images/shop/Main.png');
//					main.scrollFactor.x = 0;
//					main.scrollFactor.y = 0;
//					main.x = player.x;
//					main.y = player.y;
					add(main);
					setStageRestrictions(5, 1100, 0, 1715, 100, 760, true);
					modifyPlayerPosition(0, 100, true);
					shopDoor = new FlxSprite(240,390).loadGraphic('assets/images/grassland/Magic Door.png');
					shopDoor.scrollFactor.x = 0.9;
					shopDoor.scrollFactor.y = 0;
					add(shopDoor);
					setStageSong(FlxG.sound.load('assets/music/Cash.ogg', 1, true));
//					var sky:FlxSprite = new FlxSprite(0,-40).loadGraphic('assets/images/grassland/Sky.png');
//					sky.scrollFactor.x = 0;
//					sky.scrollFactor.y = 0;
//					add(sky);
			}
			stageIsLoaded = true;
		}
		else
		{
			trace('STAGE ALREADY LOADED! Stage ID: "' + stage + '"');
		}
	}
}
