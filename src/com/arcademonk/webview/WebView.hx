package com.arcademonk.webview;

/**
 * @author Suat Eyrice
 */

#if openfl
	import msignal.Signal;
	import flash.errors.Error;
	import flash.Lib;
	
	class WebView 
	{
		private static var APIInit:Dynamic;
		private static var APINavigate:Dynamic;
		private static var APIDestroy:Dynamic;
		
		private static var listener:WebViewListener;
		
		public static var onDestroyed:Signal0 = new Signal0();
		public static var onURLChanging:Signal1<String> = new Signal1<String>();
		
		private static function checkAPI():Void
		{
			#if android
				if (APIInit == null) APIInit = openfl.utils.JNI.createStaticMethod("com.arcademonk.haxe.NMEWebView", "APIInit", "(Lorg/haxe/openfl/HaxeObject;Z)V");
				if (APINavigate == null) APINavigate = openfl.utils.JNI.createStaticMethod("com.arcademonk.haxe.NMEWebView", "APINavigate", "(Ljava/lang/String;)V");
				if (APIDestroy == null) APIDestroy = openfl.utils.JNI.createStaticMethod("com.arcademonk.haxe.NMEWebView", "APIDestroy", "()V");
			#elseif iphone
                if (APIInit == null) APIInit = Lib.load("openfl","webviewAPIInit", 3);
				if (APINavigate == null) APINavigate = Lib.load("openfl", "webviewAPINavigate", 1);
				if (APIDestroy == null) APIDestroy = Lib.load("openfl", "webviewAPIDestroy", 0);
			#end
		}
		
		private static function APICall(method:String, args:Array<Dynamic> = null):Void
		{
			checkAPI();
			
			#if android
                if (method == "init") nme.Lib.postUICallback(function() { APIInit(args[0], args[1] == true); });
                if (method == "navigate") nme.Lib.postUICallback(function() { APINavigate(args[0]); });
                if (method == "destroy") nme.Lib.postUICallback(function() { APIDestroy(); });
			#elseif iphone
				if (method == "init") APIInit(args[0].onDestroyed, args[0].onURLChanging, args[1]);
                if (method == "navigate") APINavigate(args[0]);
                if (method == "destroy") APIDestroy();
			#end
		}
		
		public static function init(withPopup:Bool = false):Void
		{
			if (listener == null)
			{
				listener = new WebViewListener();
				listener.onDestroyedSignal.add(function ():Void
				{
					listener = null;
				});
				
				listener.onDestroyedSignal.add(onDestroyed.dispatch);
				listener.onURLChangingSignal.add(onURLChanging.dispatch);
				
				APICall("init", [listener, withPopup]);
			}
		}
		
		public static function navigate(url:String):Void
		{
			if (listener == null) init();
			APICall("navigate", [url]);
		}
		
		public static function destroy():Void
		{
			if (listener != null) APICall("destroy");
		}
	}

	class WebViewListener
	{
		public var onDestroyedSignal:Signal0;
		public var onURLChangingSignal:Signal1<String>;
		
		public function new() 
		{
			onDestroyedSignal = new Signal0();
			onURLChangingSignal = new Signal1<String>();
		}
		
		public function onDestroyed():Void
		{
			onDestroyedSignal.dispatch();
		}
		
		public function onURLChanging(url:String):Void
		{
			onURLChangingSignal.dispatch(url);
		}
	}
#end