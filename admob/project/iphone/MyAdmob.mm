#import "MyAdmob.h"
#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitial.h"

// ---------- // ---------- // ---------- // ---------- // ---------- // ---------- //


using namespace myadmob;

// ---------- // ---------- // ---------- // ---------- // ---------- // ---------- //


@interface AdmobController : UIViewController <GADBannerViewDelegate, GADInterstitialDelegate> {
    
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
    
    BOOL showBanner;
    BOOL didLoadBanner;
    BOOL didFailToLoadBanner;
    BOOL willOpenBanner;
    BOOL willCloseBanner;
    BOOL willLeaveGameBanner;
    BOOL didLoadInterstitial;
    BOOL didFailToLoadInterstitial;
    NSString* intAdUnitID;
}

@property (nonatomic, assign) BOOL showBanner;
@property (nonatomic, assign) BOOL didLoadBanner;
@property (nonatomic, assign) BOOL didFailToLoadBanner;
@property (nonatomic, assign) BOOL willOpenBanner;
@property (nonatomic, assign) BOOL willCloseBanner;
@property (nonatomic, assign) BOOL willLeaveGameBanner;
@property (nonatomic, assign) BOOL didLoadInterstitial;
@property (nonatomic, assign) BOOL didFailToLoadInterstitial;

@end

// ---------- // ---------- // ---------- // ---------- // ---------- // ---------- //


@implementation AdmobController

@synthesize showBanner;
@synthesize didLoadBanner;
@synthesize didFailToLoadBanner;
@synthesize willOpenBanner;
@synthesize willCloseBanner;
@synthesize willLeaveGameBanner;
@synthesize didLoadInterstitial;
@synthesize didFailToLoadInterstitial;


// AdMob Interstitials

- (void)initInterstitial:(NSString*)adUnitID
{
    intAdUnitID = adUnitID;
}

- (void)loadInterstitial
{
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = intAdUnitID;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [interstitial_ setDelegate:self];
    [interstitial_ loadRequest: request];
}

- (void)showInterstitial
{
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [interstitial_ presentFromRootViewController:root];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    didLoadInterstitial = YES;
    didFailToLoadInterstitial = NO;
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    didLoadInterstitial = NO;
    didFailToLoadInterstitial = YES;
}


// AdMob Banners

- (void) initAdmob:(NSString*)adUnitID withPosition:(int)position withSmartBanner:(BOOL)smartBanner
{
    showBanner = NO;
    
    CGSize screenSize = [self getCorrectedSize];
    
    if (smartBanner)
    {
        if (screenSize.width > screenSize.height)
        {
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
        }
        else
        {
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        }
    }
    else
    {
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    
    bannerView_.adUnitID = adUnitID;
    
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    bannerView_.rootViewController = root;
    [root.view addSubview:bannerView_];
    
    [bannerView_ setDelegate:self];
    
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [bannerView_ loadRequest:request];
    
    [self setBannerPosition:position];
    
    showBanner = YES;
}

- (void) setBannerPosition:(int)position
{
    CGSize screenSize = [self getCorrectedSize];
    
    if (position == 1) // Top - Center Banner
    {
        [bannerView_ setFrame:CGRectMake(screenSize.width/2 - bannerView_.bounds.size.width/2,
                                         -bannerView_.bounds.size.height,
                                         bannerView_.bounds.size.width,
                                         bannerView_.bounds.size.height)];
    }
    else if (position == 0) // Bottom - Center Banner
    {
        [bannerView_ setFrame:CGRectMake(screenSize.width/2 - bannerView_.bounds.size.width/2,
                                         screenSize.height + bannerView_.frame.size.height,
                                         bannerView_.bounds.size.width,
                                         bannerView_.bounds.size.height)];
    }
    else if (position == 4) // Top - Left Banner
    {
        [bannerView_ setFrame:CGRectMake(0,
                                         -bannerView_.bounds.size.height,
                                         bannerView_.bounds.size.width,
                                         bannerView_.bounds.size.height)];
    }
    else if (position == 5) // Top - Right Banner
    {
        [bannerView_ setFrame:CGRectMake(screenSize.width - bannerView_.bounds.size.width,
                                         -bannerView_.bounds.size.height,
                                         bannerView_.bounds.size.width,
                                         bannerView_.bounds.size.height)];
    }
    else if (position == 2) // Bottom - Left Banner
    {
        [bannerView_ setFrame:CGRectMake(0,
                                         screenSize.height + bannerView_.frame.size.height,
                                         bannerView_.bounds.size.width,
                                         bannerView_.bounds.size.height)];
    }
    else // Bottom - Right Banner
    {
        [bannerView_ setFrame:CGRectMake(screenSize.width - bannerView_.bounds.size.width,
                                         screenSize.height + bannerView_.frame.size.height,
                                         bannerView_.bounds.size.width,
                                         bannerView_.bounds.size.height)];
    }
    
    if (showBanner)
    {
        [self showAnimation];
    }
}

- (void) showAnimation
{
    CGSize screenSize = [self getCorrectedSize];
    CGRect bannerFrame = bannerView_.frame;
    
    if (bannerFrame.origin.y <= 0)
    {
        bannerFrame.origin.y = 0;
    }
    else
    {
        bannerFrame.origin.y = screenSize.height - bannerView_.frame.size.height;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        bannerView_.frame = bannerFrame;
    }];
}

- (void) hideAnimation
{
    CGSize screenSize = [self getCorrectedSize];
    CGRect bannerFrame = bannerView_.frame;
    
    if (bannerFrame.origin.y <= 0)
    {
        bannerFrame.origin.y = -bannerView_.bounds.size.height;
    }
    else
    {
        bannerFrame.origin.y = screenSize.height + bannerView_.frame.size.height;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
    bannerView_.frame = bannerFrame;
    }];

}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    if (showBanner)
    {
        [self showAnimation];
    }
    
    didLoadBanner = YES;
    NSLog(@"AdMob: banner ad successfully loaded!");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self hideAnimation];
    
    didFailToLoadBanner = YES;
    NSLog(@"AdMob: banner failed to load...");
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    willOpenBanner = YES;
    NSLog(@"AdMob: banner was opened.");
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    willCloseBanner = YES;
    NSLog(@"AdMob: banner was closed.");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    willLeaveGameBanner = YES;
    NSLog(@"AdMob: banner made the user leave the game.");
}


// Other

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (CGSize)getCorrectedSize
{
	CGSize correctSize;
	UIInterfaceOrientation toOrientation = [UIApplication sharedApplication].statusBarOrientation;
	correctSize = [[UIScreen mainScreen] bounds].size;
	if(UIInterfaceOrientationIsLandscape(toOrientation))
	{
		correctSize.height = [[UIScreen mainScreen] bounds].size.width;
		correctSize.width = [[UIScreen mainScreen] bounds].size.height;
	}
	
	return correctSize;
}

// ---------- // ---------- // ---------- // ---------- // ---------- // ---------- //

namespace myadmob
{
    static AdmobController *adController;
    
    // AdMob Interstitials
    
    void initInt(const char* adUnitID)
    {
        if(adController == NULL)
        {
            adController = [[AdmobController alloc] init];
        }
        
        NSString* newAdUnitID = [[NSString alloc] initWithUTF8String:adUnitID];
        [adController initInterstitial:newAdUnitID];
    }
    
    void loadInt()
    {
        [adController loadInterstitial];
    }
    
    void showInt()
    {
        [adController showInterstitial];
    }
    
    bool admobDidLoadInterstitial()
    {
        if(adController != NULL)
        {
            if (adController.didLoadInterstitial)
            {
                adController.didLoadInterstitial = NO;
                return true;
            }
        }
        return false;
    }
    
    bool admobDidFailToLoadInterstitial()
    {
        if(adController != NULL)
        {
            if (adController.didFailToLoadInterstitial)
            {
                adController.didFailToLoadInterstitial = NO;
                return 1;
            }
        }
        return 0;
    }
    
    // AdMob Banners
    
    void initAdmob(const char* adUnitID, int position, int smartBanner)
    {
        if(adController == NULL)
        {
            adController = [[AdmobController alloc] init];
        }
        
        NSString* newAdUnitID = [[NSString alloc] initWithUTF8String:adUnitID];
        [adController initAdmob:newAdUnitID withPosition:position withSmartBanner:smartBanner];
    }
    
    void showAdmob()
    {
        if(adController != NULL)
        {
            adController.showBanner = YES;
            [adController showAnimation];
        }
    }
    
    void hideAdmob()
    {
        if(adController != NULL)
        {
            adController.showBanner = NO;
            [adController hideAnimation];
        }
    }
    
    void setAdmobPosition(int position)
    {
        if(adController != NULL)
        {
            [adController setBannerPosition:position];
        }
    }
    
    bool admobDidLoadBanner()
    {
        if(adController != NULL)
        {
            if (adController.didLoadBanner)
            {
                adController.didLoadBanner = NO;
                return true;
            }
        }
        return false;
    }
    
    bool admobDidFailToLoadBanner()
    {
        if(adController != NULL)
        {
            if (adController.didFailToLoadBanner)
            {
                adController.didFailToLoadBanner = NO;
                return true;
            }
        }
        return false;
    }
    
    bool admobBannerWasOpened()
    {
        if(adController != NULL)
        {
            if (adController.willOpenBanner)
            {
                adController.willOpenBanner = NO;
                return true;
            }
        }
        return false;
    }
    
    bool admobBannerWasClosed()
    {
        if(adController != NULL)
        {
            if (adController.willCloseBanner)
            {
                adController.willCloseBanner = NO;
                return true;
            }
        }
        return false;
    }
    
    bool admobWillLeaveGame()
    {
        if(adController != NULL)
        {
            if (adController.willLeaveGameBanner)
            {
                adController.willLeaveGameBanner = NO;
                return true;
            }
        }
        return false;
    }
}

@end

// ---------- // ---------- // ---------- // ---------- // ---------- // ---------- //

