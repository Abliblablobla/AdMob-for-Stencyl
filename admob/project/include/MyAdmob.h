#ifndef MyAdmob
#define MyAdmob

namespace myadmob
{
    // Banners
    void initAdmob(const char* publisherID, int position, int smartBanner);
    void showAdmob();
    void hideAdmob();
    bool admobDidLoadBanner();
    bool admobDidFailToLoadBanner();
    bool admobBannerWasOpened();
    bool admobBannerWasClosed();
    bool admobWillLeaveGame();
    
    // Interstitials
    void setAdmobPosition(int position);
    void initInt(const char* unitID);
    void loadInt();
    void showInt();
    bool admobDidLoadInterstitial();
    bool admobDidFailToLoadInterstitial();
}

#endif
