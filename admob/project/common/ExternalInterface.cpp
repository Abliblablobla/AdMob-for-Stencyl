#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "MyAdmob.h"
#include <stdio.h>

//--------------------------------------------------
// Change this to match your extension's ID
//--------------------------------------------------

using namespace myadmob;


#ifdef IPHONE

//--------------------------------------------------
// Glues Haxe to native code.
//--------------------------------------------------

void init_admob(value adUnitID, value position, value smartBanner)
{
	initAdmob(val_string(adUnitID), val_int(position), val_int(smartBanner));
}
DEFINE_PRIM(init_admob, 3);

void show_admob()
{
	showAdmob();
}
DEFINE_PRIM(show_admob, 0);

void hide_admob()
{
    hideAdmob();
}
DEFINE_PRIM(hide_admob, 0);

static value get_banner_loaded()
{
    if (myadmob::admobDidLoadBanner())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_banner_loaded, 0);

static value get_banner_failed()
{
    if (myadmob::admobDidFailToLoadBanner())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_banner_failed, 0);

static value get_banner_opened()
{
    if (myadmob::admobBannerWasOpened())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_banner_opened, 0);

static value get_banner_closed()
{
    if (myadmob::admobBannerWasClosed())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_banner_closed, 0);

static value get_banner_leave_game()
{
    if (myadmob::admobWillLeaveGame())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_banner_leave_game, 0);

void set_admob_position(value position)
{
    setAdmobPosition(val_int(position));
}
DEFINE_PRIM(set_admob_position, 1);

void init_admob_int(value adUnitID)
{
    initInt(val_string(adUnitID));
}
DEFINE_PRIM(init_admob_int, 1);

void load_admob_int()
{
    loadInt();
}
DEFINE_PRIM(load_admob_int, 0);

void show_admob_int()
{
    showInt();
}
DEFINE_PRIM(show_admob_int, 0);

static value get_interstitial_loaded()
{
    if (myadmob::admobDidLoadInterstitial())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_interstitial_loaded, 0);

static value get_interstitial_failed()
{
    if (myadmob::admobDidFailToLoadInterstitial())
        return val_true;
    return val_false;
}
DEFINE_PRIM(get_interstitial_failed, 0);

#endif



//--------------------------------------------------
// IGNORE STUFF BELOW THIS LINE
//--------------------------------------------------

extern "C" void myadmob_main()
{	
}
DEFINE_ENTRY_POINT(myadmob_main);

extern "C" int myadmob_register_prims()
{ 
    return 0; 
}