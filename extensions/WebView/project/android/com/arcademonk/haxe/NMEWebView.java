package com.arcademonk.haxe;

import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.view.View;
import android.view.KeyEvent;
import android.content.Context;
import android.graphics.Bitmap;
import org.haxe.nme.GameActivity;
import org.haxe.nme.HaxeObject;

class NMEWebView extends WebView
{
	public static NMEWebView Instance;
	public static HaxeObject HaxeListenerClass;
	
	// BEGIN API -------------------------------------------------
	public static void APIInit(HaxeObject _haxeListenerClass)
	{
		if(NMEWebView.Instance != null) NMEWebView.APIDestroy();
		
		NMEWebView.HaxeListenerClass = _haxeListenerClass;
		NMEWebView.Instance = new NMEWebView(GameActivity.getContext());
		
		GameActivity.pushView(NMEWebView.Instance);
	}
	
	public static void APINavigate(String url)
	{
		if(NMEWebView.Instance != null) NMEWebView.Instance.loadUrl(url);
	}
	
	public static void APIDestroy()
	{
		NMEWebView.HaxeListenerClass.call0("onDestroyed");
		
		if(NMEWebView.Instance != null) GameActivity.popView();
		NMEWebView.Instance = null;
		NMEWebView.HaxeListenerClass = null;
	}
	// ENDOF API -------------------------------------------------
	
	public NMEWebView(Context inContext)
	{
		super(inContext);
		
		WebSettings webSettings = getSettings();
		webSettings.setSavePassword(false);
		webSettings.setSaveFormData(false);
		webSettings.setJavaScriptEnabled(true);
		webSettings.setSupportZoom(false);
		
		setWebViewClient(new NMEWebViewClient());
	}
	
	@Override
	public boolean onKeyDown(final int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK) && !canGoBack()) NMEWebView.APINavigate();
		
		return super.onKeyDown(keyCode, event);
	}
	
	private class NMEWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			NMEWebView.HaxeListenerClass.call1("onURLChanging", url);
			view.loadUrl(url);
			
			return true;
		}
	}
}