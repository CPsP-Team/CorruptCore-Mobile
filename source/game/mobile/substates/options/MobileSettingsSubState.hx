package game.mobile.substates.options;

import flixel.input.keyboard.FlxKey;
import game.substates.options.BaseOptionsMenu;
import game.substates.backend.Option;

/**
 * Mobile Options For Psych.
**/
class MobileSettingsSubState extends BaseOptionsMenu {
	#if android
	var storageTypes:Array<String> = ["EXTERNAL_DATA", "EXTERNAL_OBB", "EXTERNAL_MEDIA", "EXTERNAL"];
	var customPaths:Array<String> = MobileUtil.getCustomStorageDirectories(false);
	final lastStorageType:String = ClientPrefs.storageType;
	#end

	var option:Option;
	var HitboxTypes:Array<String>;
	public function new() {
		title = 'Mobile Options';
		rpcTitle = 'Mobile Options Menu'; // for Discord Rich Presence, fuck it
		#if android
		storageTypes = storageTypes.concat(customPaths); //Get Custom Paths From File
		#end

		#if MOBILE_CONTROLS
		HitboxTypes = Util.mergeAllTextsNamed('mobile/Hitbox/HitboxModes/hitboxModeList.txt');

		option = new Option('MobilePad Opacity',
			'Selects the opacity for the mobile buttons (careful not to put it at 0 and lose track of your buttons).',
			'mobilePadAlpha',
			'percent',
			0.6
		);
		option.scrollSpeed = 1;
		option.minValue = 0.001;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = () -> {
			mobileManager.mobilePad.alpha = curOption.getValue();
		};
		addOption(option);

		/*
		var option:Option = new Option('Extra Controls',
			'Allow Extra Controls',
			'mobileExtraKeys',
			'int',
			2);
		option.scrollSpeed = 1;
		option.minValue = 0;
		option.maxValue = 4;
		option.changeValue = 1;
		option.decimals = 0;
		addOption(option);

		option = new Option('Extra Control Location',
			'Choose Extra Control Location',
			'hitboxLocation',
			'string',
			'Bottom',
			['Bottom', 'Top', 'Middle']
		);
		addOption(option);
		*/
		
		//HitboxTypes.insert(0, "Classic");
		option = new Option('Hitbox Mode',
			'Choose your Hitbox Style!',
			'hitboxMode',
			'string',
			'Normal (New)',
			HitboxTypes
		);
		addOption(option);
		
		option = new Option('Hitbox Design',
			'Choose how your hitbox should look like.',
			'hitboxType',
			'string',
			'Gradient',
			['Gradient', 'No Gradient' , 'No Gradient (Old)']
		);
		addOption(option);

		option = new Option('Hitbox Hint',
			'Hitbox Hint',
			'hitboxHint',
			'bool',
			false);
		addOption(option);

		option = new Option('Hitbox Opacity',
			'Selects the opacity for the hitbox buttons.',
			'hitboxAlpha',
			'percent',
			0.7
		);
		option.scrollSpeed = 1;
		option.minValue = 0.001;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		#end

		#if mobile
		/* CorruptCore has this thing already, so useless
		option = new Option('Wide Screen Mode',
			'If checked, The game will stetch to fill your whole screen. (WARNING: Can result in bad visuals & break some mods that resizes the game/cameras)',
			'wideScreen',
			'bool',
			false);
		option.onChange = () -> ScreenUtil.wideScreen.enabled = ClientPrefs.wideScreen;
		addOption(option);
		*/
		#end

		#if android
		option = new Option('Storage Type',
			'Which folder CorruptCore should use?',
			'storageType',
			'string',
			'EXTERNAL',
			storageTypes
		);
		addOption(option);
		#end

		super();
	}

	override public function destroy() {
		super.destroy();

		#if android
		if (ClientPrefs.storageType != lastStorageType) {
			File.saveContent(MobileUtil.getStorageTypePath(), ClientPrefs.storageType);
			ClientPrefs.saveSettings();
			MobileUtil.initDirectory();
		}
		#end
	}
}