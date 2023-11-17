package states;

import flixel.input.FlxAccelerometer;
import backend.Song;
import backend.WeekData;
import backend.Achievements;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import flash.system.System;

import backend.WeekData;
import backend.WeekData.WeekFile;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED 
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var start:FlxSprite;
	var startMenu:FlxSprite;
	var turnDown:FlxSprite;
	var bg:FlxSprite;
	var taskbar:FlxSprite;

	//menu opciones
	var paint:FlxSprite;
	var optionsF:FlxSprite;
	var freeplayF:FlxSprite;
	var creditsF:FlxSprite;

	//explorer
	var explorer:FlxSprite;
	var closeExplorer:FlxSprite;
	var curExplorer:Bool = false;

	var iconCinos:FlxSprite;
	var iconSans2:FlxSprite;

	var cinosText:FlxText;
	var sans2Text:FlxText;

	//VENTANAS
	var ventanacreditos:FlxSprite;
	var closeCredistos:FlxSprite;
	var benja:FlxSprite;
	var srwhite:FlxSprite;
	var dore:FlxSprite;
	var jp13xd:FlxSprite;
	var launi:FlxSprite;
	var roberto:FlxSprite;
	var pando:FlxSprite;
	var fb:FlxSprite;

	var curCredits:Bool = false;

	var hora:FlxText;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic(Paths.image('windows/Bliss'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('windows/Bliss'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		//add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			//menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		paint = new FlxSprite(40, 30).loadGraphic(Paths.image('windows/PAINT'));
		paint.scrollFactor.set(0, 0);
		paint.scale.x = 2.5;
		paint.scale.y = 2.5;
		paint.updateHitbox();
		add(paint);
		
		optionsF = new FlxSprite(40, 200).loadGraphic(Paths.image('windows/OPTIONS'));
		optionsF.scrollFactor.set(0, 0);
		optionsF.scale.x = 2.5;
		optionsF.scale.y = 2.5;
		optionsF.updateHitbox();
		add(optionsF);
		
		freeplayF = new FlxSprite(40, 360).loadGraphic(Paths.image('windows/FREEPLAY'));
		freeplayF.scrollFactor.set(0, 0);
		freeplayF.scale.x = 2.5;
		freeplayF.scale.y = 2.5;
		freeplayF.updateHitbox();
		add(freeplayF);

		creditsF = new FlxSprite(40, 500).loadGraphic(Paths.image('windows/CREDITS'));
		creditsF.scrollFactor.set(0, 0);
		creditsF.scale.x = 2.5;
		creditsF.scale.y = 2.5;
		creditsF.updateHitbox();
		add(creditsF);
		
		startMenu = new FlxSprite(0, FlxG.height - 20 - 490).loadGraphic(Paths.image('windows/startMenu'));
		startMenu.scrollFactor.set(0, 0);
		startMenu.scale.x = 1.0;
		startMenu.scale.y = 1.0;
		startMenu.visible = false;
		add(startMenu);
				
		turnDown = new FlxSprite(250, FlxG.height - 20 - 50).loadGraphic(Paths.image('windows/turnDown'));
		turnDown.scrollFactor.set(0, 0);
		turnDown.scale.x = 1.0;
		turnDown.scale.y = 1.0;
		turnDown.visible = false;
		add(turnDown);

		taskbar = new FlxSprite(400, FlxG.height - 20).loadGraphic(Paths.image('windows/taskbar'));
		taskbar.scrollFactor.set(0, 0);
		taskbar.scale.x = 3.0;
		taskbar.scale.y = 3.0;
		add(taskbar);

		start = new FlxSprite(30, taskbar.y).loadGraphic(Paths.image('windows/startButton'));
		start.scrollFactor.set(0, 0);
		start.scale.x = 3.0;
		start.scale.y = 3.0;
		add(start);

		var horatiempo = Date.now();
		hora = new FlxText(1150, taskbar.y - 10, 0, ""+horatiempo.getHours()+":"+horatiempo.getMinutes(), 45);
		hora.scrollFactor.set(0,0);
		hora.setFormat("VCR OSD Mono", 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(hora);

		ventanacreditos = new FlxSprite(500, 100).loadGraphic(Paths.image('windows/creditos/ventana'));
		ventanacreditos.scrollFactor.set(0,0);
		ventanacreditos.scale.x = 1.5;
		ventanacreditos.scale.y = 1.5;
		ventanacreditos.visible = false;
		add(ventanacreditos);

		explorer = new FlxSprite(500, 100).loadGraphic(Paths.image('windows/explorer'));
		explorer.scrollFactor.set(0,0);
		explorer.scale.x = 1.0;
		explorer.scale.y = 1.0;
		explorer.visible = false;
		add(explorer);

		iconCinos = new FlxSprite(670, 230).loadGraphic(Paths.image("windows/freeplay/cinos"));
		iconCinos.scrollFactor.set(0,0);
		iconCinos.scale.x = 0.5;
		iconCinos.scale.y = 0.5;
		iconCinos.visible = false;
		add(iconCinos);

		iconSans2 = new FlxSprite(iconCinos.x + 150, iconCinos.y).loadGraphic(Paths.image("windows/freeplay/sans2"));
		iconSans2.scrollFactor.set(0,0);
		iconSans2.scale.x = 0.5;
		iconSans2.scale.y = 0.5;
		iconSans2.visible = false;
		add(iconSans2);
		
		sans2Text = new FlxText(iconSans2.x + 20 ,iconSans2.y + 80 ,FlxG.width, "RECOLORS", 15);
		sans2Text.setFormat("VCR OSD Mono", 15, FlxColor.BLACK);
		sans2Text.scrollFactor.set(0,0);
		sans2Text.visible = false;
		add(sans2Text);
		
		cinosText = new FlxText(iconCinos.x + 65, iconCinos.y + 95, FlxG.width, "MIEDO", 15);
		cinosText.setFormat("VCR OSD Mono", 15, FlxColor.BLACK);
		cinosText.scrollFactor.set(0,0);
		cinosText.visible = false;
		add(cinosText);

		roberto = new FlxSprite(450, 135).loadGraphic(Paths.image('windows/creditos/roberto'));
		roberto.scrollFactor.set(0,0);
		roberto.scale.x = 1.5;
		roberto.scale.y = 1.5;
		roberto.visible = false;
		add(roberto);

		pando = new FlxSprite(450, 155).loadGraphic(Paths.image('windows/creditos/pando'));
		pando.scrollFactor.set(0,0);
		pando.scale.x = 1.5;
		pando.scale.y = 1.5;
		pando.visible = false;
		add(pando);

		launi = new FlxSprite(450, 175).loadGraphic(Paths.image('windows/creditos/launi'));
		launi.scrollFactor.set(0,0);
		launi.scale.x = 1.5;
		launi.scale.y = 1.5;
		launi.visible = false;
		add(launi);

		jp13xd = new FlxSprite(450, 195).loadGraphic(Paths.image('windows/creditos/jp13xd'));
		jp13xd.scrollFactor.set(0,0);
		jp13xd.scale.x = 1.5;
		jp13xd.scale.y = 1.5;
		jp13xd.visible = false;
		add(jp13xd);

		dore = new FlxSprite(450, 235).loadGraphic(Paths.image('windows/creditos/dore'));
		dore.scrollFactor.set(0,0);
		dore.scale.x = 1.5;
		dore.scale.y = 1.5;
		dore.visible = false;
		add(dore);

		benja = new FlxSprite(450, 257).loadGraphic(Paths.image('windows/creditos/benja'));
		benja.scrollFactor.set(0,0);
		benja.scale.x = 1.5;
		benja.scale.y = 1.5;
		benja.visible = false;
		add(benja);

		srwhite = new FlxSprite(450, 277).loadGraphic(Paths.image('windows/creditos/srwhite'));
		srwhite.scrollFactor.set(0,0);
		srwhite.scale.x = 1.5;
		srwhite.scale.y = 1.5;
		srwhite.visible = false;
		add(srwhite);

		fb = new FlxSprite(450, 297).loadGraphic(Paths.image('windows/creditos/fb'));
		fb.scrollFactor.set(0,0);
		fb.scale.x = 1.5;
		fb.scale.y = 1.5;
		fb.visible = false;
		add(fb);

		closeCredistos = new FlxSprite(910, 57).loadGraphic(Paths.image('windows/creditos/close'));
		closeCredistos.scrollFactor.set(0,0);
		closeCredistos.scale.x = 1.5;
		closeCredistos.scale.y = 1.5;
		closeCredistos.visible = false;
		add(closeCredistos);

		closeExplorer = new FlxSprite(1100, 101).loadGraphic(Paths.image('windows/close'));
		closeExplorer.scrollFactor.set(0,0);
		closeExplorer.scale.x = 1.0;
		closeExplorer.scale.y = 1.0;
		closeExplorer.visible = false;
		add(closeExplorer);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementPopup('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	public function startVideo()
		{
			#if VIDEOS_ALLOWED
	
			var filepath:String = Paths.video("INTRO_CINOS");
			#if sys
			if(!FileSystem.exists(filepath))
			#else
			if(!OpenFlAssets.exists(filepath))
			#end

			{
				FlxG.log.warn('Couldnt find video file: ');
				startAndEnd();
				return;
			}
	
			var video:VideoHandler = new VideoHandler();
				#if (hxCodec >= "3.0.0")
				// Recent versions
				video.play(filepath);
				FlxG.sound.music.stop();
				video.onEndReached.add(function()
				{
					video.dispose();
					startAndEnd();
					return;
				}, true);
				#else
				// Older versions
				video.playVideo(filepath);
				FlxG.sound.music.stop();
				video.finishCallback = function()
				{
					startAndEnd();
					return;
				}
				#end
			#else
			FlxG.log.warn('Platform not supported!');
			startAndEnd();
			return;
			#end
		}
	
		function startAndEnd()
		{
			bg.visible = false;
			startMenu.visible = false;
			taskbar.visible = false;
			creditsF.visible = false;
			freeplayF.visible = false;
			optionsF.visible = false;
			paint.visible = false;
			start.visible = false;
			hora.visible = false;

			var leSongs:Array<String> = ["cinosrealnofake"];

			for (i in 0...WeekData.weeksList.length) {
				var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
	
				for (j in 0...leWeek.songs.length)
				{
					leSongs.push(leWeek.songs[j][0]);
				}
	
				WeekData.setDirectoryFromWeek(leWeek);
			}

			PlayState.storyPlaylist = ["cinosrealnofake"];
			PlayState.isStoryMode = true;

			PlayState.storyWeek = 0;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var horatiempo = Date.now();
		hora.text = ""+horatiempo.getHours()+":"+horatiempo.getMinutes();

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		FlxG.mouse.visible = true;

		if (FlxG.mouse.overlaps(roberto) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/RobertoTheCoder");
			}

		if (FlxG.mouse.overlaps(srwhite) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/Srwhiteoficial");
			}

		if (FlxG.mouse.overlaps(jp13xd) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/XdJp13");
			}
		if (FlxG.mouse.overlaps(dore) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/DoorDorei");
			}	
			
		if (FlxG.mouse.overlaps(fb) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/elfb344");
			}	
		if (FlxG.mouse.overlaps(launi) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/Launixio");
			}
		if (FlxG.mouse.overlaps(pando) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://x.com/_Elpando_?t=FXBKtFCmYITScj7gYCmzDw&s=09");
			}
		if (FlxG.mouse.overlaps(benja) && FlxG.mouse.justPressed && curCredits)
			{
				CoolUtil.browserLoad("https://twitter.com/CuliaoBen?t=-BZljy5zOkXBdy666kjV_A&s=09");
			}

		if (FlxG.mouse.overlaps(start)) 
		{
			startMenu.visible = true;
			turnDown.visible = true;
		}
	
		if (FlxG.mouse.overlaps(bg) && FlxG.mouse.justPressed && !FlxG.mouse.overlaps(startMenu)) 
			{
				startMenu.visible = false;
				turnDown.visible = false;
			}

		if (FlxG.mouse.overlaps(closeCredistos) && FlxG.mouse.justPressed && curCredits) 
			{
				curCredits = false;
			}

		if (FlxG.mouse.overlaps(closeExplorer) && FlxG.mouse.justPressed && curExplorer) 
			{
				curExplorer = false;
			}

		if (FlxG.mouse.overlaps(creditsF) && FlxG.mouse.justPressed && !startMenu.visible) 
			{
				curCredits = true;
			}

		if (FlxG.mouse.overlaps(optionsF) && FlxG.mouse.justPressed && !startMenu.visible) 
			{
				LoadingState.loadAndSwitchState(new OptionsState());
				OptionsState.onPlayState = false;
				if (PlayState.SONG != null)
				{
					PlayState.SONG.arrowSkin = null;
					PlayState.SONG.splashSkin = null;
				}
			}
		if (FlxG.mouse.overlaps(freeplayF) && FlxG.mouse.justPressed && !startMenu.visible) 
			{
				curExplorer = true;
			}

		if (FlxG.mouse.overlaps(turnDown) && FlxG.mouse.justPressed && startMenu.visible) 
			{
				System.exit(0);
			}

		if (FlxG.mouse.overlaps(paint) && FlxG.mouse.justPressed) 
			{
				startVideo();
			}

		if (curExplorer)
			{
				curCredits = false;
			}
		if (curCredits)
			{
				curExplorer = false;
			}

		if (curExplorer)
			{
				explorer.visible = true;
				closeExplorer.visible = true;
				iconCinos.visible = true;
				iconSans2.visible = true;
				sans2Text.visible = true;
				cinosText.visible = true;

				if (FlxG.mouse.overlaps(iconCinos) && FlxG.mouse.justPressed) 
					{
						var leSongs:Array<String> = ["cinosrealnofake"];

						for (i in 0...WeekData.weeksList.length) {
							var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
				
							for (j in 0...leWeek.songs.length)
							{
								leSongs.push(leWeek.songs[j][0]);
							}
				
							WeekData.setDirectoryFromWeek(leWeek);
						}
		
						PlayState.storyPlaylist = ["cinosrealnofake"];
						PlayState.isStoryMode = true;
		
						PlayState.storyWeek = 0;
		
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;
						LoadingState.loadAndSwitchState(new PlayState(), true);
						FreeplayState.destroyFreeplayVocals();
					}

				if (FlxG.mouse.overlaps(iconSans2) && FlxG.mouse.justPressed) 
					{
						var leSongs:Array<String> = ["recolors"];
	
						for (i in 0...WeekData.weeksList.length) {
							var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
				
							for (j in 0...leWeek.songs.length)
							{
								leSongs.push(leWeek.songs[j][0]);
							}
					
							WeekData.setDirectoryFromWeek(leWeek);
						}
			
						PlayState.storyPlaylist = ["recolors"];
						PlayState.isStoryMode = true;
			
						PlayState.storyWeek = 0;
			
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;
						LoadingState.loadAndSwitchState(new PlayState(), true);
						FreeplayState.destroyFreeplayVocals();
					}
			}
		else
			{
				explorer.visible = false;
				closeExplorer.visible = false;
				iconCinos.visible = false;
				iconSans2.visible = false;
				sans2Text.visible = false;
				cinosText.visible = false;

			}

		if (curCredits)
			{
				ventanacreditos.visible = true;
				closeCredistos.visible = true;

				roberto.visible = true;
				pando.visible = true;
				launi.visible = true;
				jp13xd.visible = true;
				dore.visible = true;
				benja.visible = true;
				srwhite.visible = true;
				fb.visible = true;
			}
		else
			{
				ventanacreditos.visible = false;
				closeCredistos.visible = false;

				
				roberto.visible = false;
				pando.visible = false;
				launi.visible = false;
				jp13xd.visible = false;
				dore.visible = false;
				benja.visible = false;
				srwhite.visible = false;
				fb.visible = false;
			}

		/*if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.data.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}
		}*/
		#if desktop
		if (controls.justPressed('debug_1'))
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new MasterEditorMenu());
		}
		#end

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
