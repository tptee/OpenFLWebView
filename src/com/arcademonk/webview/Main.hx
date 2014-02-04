package com.arcademonk.webview;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;

import haxe.Timer;
/**
 * @author Suat Eyrice
 */

class Main extends Sprite 
{
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		stage.align = flash.display.StageAlign.TOP_LEFT;
		
		WebView.init(false);
		WebView.navigate("http://google.com");

		haxe.Timer.delay(function() { WebView.destroy(); }, 7000);

		Lib.current.addChild(new Main());
	}
	
	/*
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
		
		WebView.onURLChanging.add(function(url:String):Void {
			trace("onURLChanging: " + url);
			if (url.indexOf("google.com") != -1) WebView.navigate("http://www.facebook.com");
		});
		
		WebView.onDestroyed.add(function():Void {
			trace("onDestroyed");
		});
		
		WebView.init(true);
		WebView.navigate("http://www.google.com");
	}
	*/
}
