package com.abliblablobla.AdMob;

import org.haxe.extension.Extension;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.view.Gravity;
import android.view.animation.Animation;
import android.view.animation.AlphaAnimation;
import android.util.Log;

import com.google.android.gms.ads.*;

import dalvik.system.DexClassLoader;

public class MyAdmob extends Extension
{
	private static LinearLayout layout;
    
    private static boolean initialized = false;
    private static String deviceID;
    
    private static boolean adOpened = false;
    private static boolean adClosed = false;
    private static boolean adLoaded = false;
    private static boolean adFailedToLoad = false;
    private static boolean adClicked = false;
    
    private static boolean intDidLoad = false;
    private static boolean intDidFailToLoad = false;

	static AdView adView;
    static InterstitialAd interstitial;
    
    /// --- Banners --- ///

	static public void initBanner(final String adUnitID, final String deviceID, final int position, final int smartBanner)
	{
		mainActivity.runOnUiThread(new Runnable()
		{
        	public void run()
			{
                adView = new AdView(mainActivity);
                
                if (smartBanner == 0)
                {
                    adView.setAdSize(AdSize.BANNER);
                }
                else
                {
                    adView.setAdSize(AdSize.SMART_BANNER);
                }
                
                adView.setAdUnitId(adUnitID);
                
				layout = new LinearLayout(mainActivity);
                
                setBannerPosition(position);
                
                AdRequest adRequest = new AdRequest.Builder().addTestDevice(deviceID).build();
                
    			adView.loadAd(adRequest);
                
                adView.setAdListener(new AdListener()
                {
                    @Override
                    public void onAdLoaded()
                    {
                        if (!initialized)
                        {
                            initialized = true;
                            
                            layout.addView(adView);
                            mainActivity.addContentView(layout, new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
                            
                            Animation animation1 = new AlphaAnimation(0.0f, 1.0f);
                            animation1.setDuration(1000);
                            layout.startAnimation(animation1);
                        }
                        
                        adLoaded = true;
                        adFailedToLoad = false;
                    }
                    
                    @Override
                    public void onAdFailedToLoad(int errorCode)
                    {
                        adLoaded = false;
                        adFailedToLoad = true;
                    }
                    
                    @Override
                    public void onAdOpened()
                    {
                        adOpened = true;
                    }
                    
                    @Override
                    public void onAdClosed()
                    {
                        adClosed = true;
                    }
                    
                    @Override
                    public void onAdLeftApplication()
                    {
                        adClicked = true;
                    }
                });
            }
        });
	}

	static public void showBanner()
	{
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run() 
			{
				if(adView != null && adView.getVisibility() == AdView.GONE)
				{
     				adView.setVisibility(AdView.VISIBLE);
                    
                    Animation animation1 = new AlphaAnimation(0.0f, 1.0f);
                    animation1.setDuration(1000);
                    layout.startAnimation(animation1);
				}
            }
        });
    }

	static public void hideBanner()
	{
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run() 
        	{
				if(adView != null && adView.getVisibility() == AdView.VISIBLE)
				{
                    Animation animation1 = new AlphaAnimation(1.0f, 0.0f);
                    animation1.setDuration(1000);
                    layout.startAnimation(animation1);
                    
                    final Handler handler = new Handler();
                    handler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            adView.setVisibility(AdView.GONE);
                        }
                    }, 1000);
				}
            }
        });
	}
    
    static public void setBannerPosition(final int position)
    {
        mainActivity.runOnUiThread(new Runnable()
                                   {
        	public void run()
        	{
                if(position == 0) //Bottom-Center
                {
                    layout.setGravity(Gravity.CENTER_HORIZONTAL|Gravity.BOTTOM);
                }
                else if (position == 1) //Top-Center
                {
                    layout.setGravity(Gravity.CENTER_HORIZONTAL);
                }
                else if (position == 2)
                {
                    layout.setGravity(Gravity.BOTTOM|Gravity.LEFT);
                }
                else if (position == 3)
                {
                    layout.setGravity(Gravity.BOTTOM|Gravity.RIGHT);
                }
                else if (position == 4)
                {
                    layout.setGravity(Gravity.TOP|Gravity.LEFT);
                }
                else if (position == 5)
                {
                    layout.setGravity(Gravity.TOP|Gravity.RIGHT);
                }
            }
        });
    }
    
    static public boolean bannerIsLoaded()
    {
        if (adLoaded)
        {
            adLoaded = false;
            return true;
        }
        return false;
    }
    
    static public boolean bannerFailedToLoad()
    {
        if (adFailedToLoad)
        {
            adFailedToLoad = false;
            return true;
        }
        return false;
    }
    
    static public boolean bannerWasOpened()
    {
        if (adOpened)
        {
            adOpened = false;
            return true;
        }
        return false;
    }
    
    static public boolean bannerWasClosed()
    {
        if (adClosed)
        {
            adClosed = false;
            return true;
        }
        return false;
    }
    
    static public boolean bannerWasClicked()
    {
        if (adClicked)
        {
            adClicked = false;
            return true;
        }
        return false;
    }
    
    
    /// --- Interstitials --- ///
    
    static public void initInterstitial(final String adUnitID, final String testDeviceID)
    {
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run()
        	{
                interstitial = new InterstitialAd(mainActivity);
                interstitial.setAdUnitId(adUnitID);
                
                interstitial.setAdListener(new AdListener()
                {
                    @Override
                    public void onAdLoaded()
                    {
                        intDidLoad = true;
                        intDidFailToLoad = false;
                    }
                    
                    @Override
                    public void onAdFailedToLoad(int errorCode)
                    {
                        intDidLoad = false;
                        intDidFailToLoad = true;
                    }
                });
                
                deviceID = testDeviceID;
            }
        });
    }
    
    static public void loadInterstitial()
    {
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run()
        	{
				AdRequest adRequest = new AdRequest.Builder().addTestDevice(deviceID).build();
                interstitial.loadAd(adRequest);
            }
        });
    }
    
    static public void showInterstitial()
    {
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run()
        	{
				if (interstitial.isLoaded()) {
                    interstitial.show();
                }
            }
        });
    }
    
    static public boolean isInterstitialLoaded()
    {
        return intDidLoad;
    }
    
    static public boolean isInterstitialFailed()
    {
        return intDidFailToLoad;
    }
    
    /// --- Other(Banners) --- ///
    
    @Override
    public void onPause() {
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run()
        	{
                if (adView != null) {
                    adView.pause();
                }
            }
        });
        
        super.onPause();
    }
    
    @Override
    public void onResume() {
        super.onResume();
        
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run()
        	{
                if (adView != null) {
                    adView.resume();
                }
            }
        });
    }
    
    @Override
    public void onDestroy() {
        mainActivity.runOnUiThread(new Runnable()
        {
        	public void run()
        	{
                if (adView != null) {
                    adView.destroy();
                }
            }
        });
        
        super.onDestroy();
    }
}