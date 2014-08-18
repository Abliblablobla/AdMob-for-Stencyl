package;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#else
import nme.Lib;
#end

#if android
import openfl.utils.JNI;
#end

class MyAdmob
{
    private static var initializeBanner:Bool = true;

    #if android
    private static var initializeInterstitial:Bool = true;
    private static var _init_banner_func:Dynamic;
    private static var _show_banner_func:Dynamic;
    private static var _hide_banner_func:Dynamic;
    private static var _change_banner_position_func:Dynamic;
    private static var _banner_loaded_func:Dynamic;
    private static var _banner_failed_to_load_func:Dynamic;
    private static var _banner_was_opened_func:Dynamic;
    private static var _banner_was_closed_func:Dynamic;
    private static var _banner_was_clicked_func:Dynamic;
    private static var _init_int_func:Dynamic;
    private static var _load_int_func:Dynamic;
    private static var _show_int_func:Dynamic;
    private static var _interstitial_did_load_func:Dynamic;
    private static var _interstitial_did_fail_func:Dynamic;
    #end

    public static function initBanner(adUnitID:String, position:Int, smartBanner:Int, deviceID:String = ""):Void
    {
        #if ios
        if(initializeBanner)
        {
            initAdmobBanner(adUnitID, position, smartBanner);
            initializeBanner = false;
        }
        else
        {
            showAdmobBanner();
        }
        #end
        
        #if android
        if(initializeBanner)
        {
            initializeBanner = false;

            if(_init_banner_func == null)
            {
                _init_banner_func = JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "initBanner", "(Ljava/lang/String;Ljava/lang/String;II)V", true);
            }
            var args = new Array<Dynamic>();
            args.push(adUnitID);
            args.push(deviceID);
            args.push(position);
            args.push(smartBanner);
            _init_banner_func(args);
        }
        else
        {
            if(_show_banner_func == null)
            {
                _show_banner_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "showBanner", "()V", true);
            }
            var args = new Array<Dynamic>();
            _show_banner_func(args);
        }
        #end
    }
    
    public static function showBanner():Void
    {
        #if ios
        showAdmobBanner();
        #end

        #if android
        if(_show_banner_func == null)
        {
            _show_banner_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "showBanner", "()V", true);
        }
        var args = new Array<Dynamic>();
        _show_banner_func(args);
        #end
    }
    
    public static function hideBanner():Void
    {
        #if ios
        hideAdmobBanner();
        #end
        
        #if android
        if(_hide_banner_func == null)
        {
            _hide_banner_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "hideBanner", "()V", true);
        }
        var args = new Array<Dynamic>();
        _hide_banner_func(args);
        #end
    }

    public static function getBannerInfo(info:Int):Bool
    {
        if (info == 0)
        {
            #if ios
            return admobDidLoadAd();
            #end

            #if android
            if (_banner_loaded_func == null)
            {
                _banner_loaded_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "bannerIsLoaded", "()Z", true);
            }
            
            return _banner_loaded_func();
            #end
        }
        else if (info == 1)
        {
            #if ios
            return admobDidFailToLoadAd();
            #end

            #if android
            if (_banner_failed_to_load_func == null)
            {
                _banner_failed_to_load_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "bannerFailedToLoad", "()Z", true);
            }
            
            return _banner_failed_to_load_func();
            #end
        }
        else if (info == 2)
        {
            #if ios
            return admobBannerWasOpened();
            #end

            #if android
            if (_banner_was_opened_func == null)
            {
                _banner_was_opened_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "bannerWasOpened", "()Z", true);
            }
            
            return _banner_was_opened_func();
            #end
        }
        else if (info == 3)
        {
            #if ios
            return admobBannerWasClosed();
            #end

            #if android
            if (_banner_was_closed_func == null)
            {
                _banner_was_closed_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "bannerWasClosed", "()Z", true);
            }
            
            return _banner_was_closed_func();
            #end
        }
        else
        {
            #if ios
            return admobWillLeaveGame();
            #end

            #if android
            if (_banner_was_clicked_func == null)
            {
                _banner_was_clicked_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "bannerWasClicked", "()Z", true);
            }
            
            return _banner_was_clicked_func();
            #end
        }
        
        return false;
    }
    
    public static function changeBannerPosition(position:Int):Void
    {
        #if ios
        changeAdmobPosition(position);
        #end

        #if android
        if(_change_banner_position_func == null)
        {
            _change_banner_position_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "setBannerPosition", "(I)V", true);
        }
        var args = new Array<Dynamic>();
        args.push(position);
        _change_banner_position_func(args);
        #end
    }

    public static function initInterstitial(adUnitID:String, deviceID: String = ""):Void
    {
        #if ios
        initAdmobInterstitial(adUnitID);
        #end
        
        #if android
        if(initializeInterstitial)
        {
            initializeInterstitial = false;

            if(_init_int_func == null)
            {
                _init_int_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "initInterstitial", "(Ljava/lang/String;Ljava/lang/String;)V", true);
            }
            var args = new Array<Dynamic>();
            args.push(adUnitID);
            args.push(deviceID);
            _init_int_func(args);
        }
        #end
    }
    
    public static function loadInterstitial():Void
    {
        #if ios
        loadAdmobInterstitial();
        #end
        
        #if android
        if(_load_int_func == null)
        {
            _load_int_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "loadInterstitial", "()V", true);
        }
        var args = new Array<Dynamic>();
        _load_int_func(args);
        #end
    }
    
    public static function showInterstitial():Void
    {
        #if ios
        showAdmobInterstitial();
        #end
        
        #if android
        if(_show_int_func == null)
        {
            _show_int_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "showInterstitial", "()V", true);
        }
        var args = new Array<Dynamic>();
        _show_int_func(args);
        #end
    }

    public static function getInterstitialInfo(info:Int):Bool
    {
        if (info == 0)
        {
            #if ios
            return admobIntDidLoad();
            #end

            #if android
            if(_interstitial_did_load_func == null)
            {
                _interstitial_did_load_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "isInterstitialLoaded", "()Z", true);
            }
            var args = new Array<Dynamic>();
            return _interstitial_did_load_func(args);
            #end
        }
        else
        {
            #if ios
            return admobIntDidFailToLoad();
            #end
            
            #if android
            if(_interstitial_did_fail_func == null)
            {
                _interstitial_did_fail_func = openfl.utils.JNI.createStaticMethod("com/abliblablobla/AdMob/MyAdmob", "isInterstitialFailed", "()Z", true);
            }
            var args = new Array<Dynamic>();
            return _interstitial_did_fail_func(args);
            #end
        }
        
        return false;
    }

    #if ios
    private static var initAdmobBanner = nme.Loader.load("init_admob",3);
    private static var showAdmobBanner = nme.Loader.load("show_admob",0);
    private static var hideAdmobBanner = nme.Loader.load("hide_admob",0);
    private static var admobDidLoadAd = nme.Loader.load("get_banner_loaded",0);
    private static var admobDidFailToLoadAd = nme.Loader.load("get_banner_failed",0);
    private static var admobBannerWasOpened = nme.Loader.load("get_banner_opened",0);
    private static var admobBannerWasClosed = nme.Loader.load("get_banner_closed",0);
    private static var admobWillLeaveGame = nme.Loader.load("get_banner_leave_game",0);
    private static var changeAdmobPosition = nme.Loader.load("set_admob_position",1);
    private static var initAdmobInterstitial = nme.Loader.load("init_admob_int",1);
    private static var loadAdmobInterstitial = nme.Loader.load("load_admob_int",0);
    private static var showAdmobInterstitial = nme.Loader.load("show_admob_int",0);
    private static var admobIntDidLoad = nme.Loader.load("get_interstitial_loaded",0);
    private static var admobIntDidFailToLoad = nme.Loader.load("get_interstitial_failed",0);
    #end
}