package com.arcademonk.webview;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * @author Suat Eyrice
 */

class Main extends Sprite 
{
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	public function new() 
	{
		super();
		
		#if iphone
			Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
			addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e:Event):Void
	{
		#if iphone
			Lib.current.stage.removeEventListener(Event.RESIZE, init);
		#else
			removeEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
        try
        {
            WebView.onURLChanging.add(function(url:String):Void {
                trace("onURLChanging: " + url);
                if (url.indexOf("google.com") != -1) WebView.navigate("http://www.facebook.com");
            });
		
            WebView.navigate("http://www.google.com");
        } catch (e:Dynamic) {
            trace(e);
        }
	}
}
