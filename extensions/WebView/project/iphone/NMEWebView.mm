#import <UIKit/UIKit.h>
#include <hx/Macros.h>
#include <hx/CFFI.h>
#include <NMEWebView.h>

typedef void (*OnUrlChangingFunctionType)(NSString *);
typedef void (*OnCloseClickedFunctionType)();

@interface WebViewDelegate : NSObject <UIWebViewDelegate>
@property (nonatomic) OnUrlChangingFunctionType onUrlChanging;
@property (nonatomic) OnCloseClickedFunctionType onCloseClicked;
@end

@implementation WebViewDelegate
@synthesize onUrlChanging;
@synthesize onCloseClicked;
- (BOOL)webView:(UIWebView *)instance shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	onUrlChanging([[request URL] absoluteString]);
    
    return YES;
}
- (void) onCloseButtonClicked:(UIButton *)closeButton {
    onCloseClicked();
}
@end

namespace arcademonk {
	UIWebView *instance;
    UIButton *closeButton;
	WebViewDelegate *webViewDelegate;
	AutoGCRoot *onDestroyedCallback = 0;
	AutoGCRoot *onURLChangingCallback = 0;
	void init(value, value, bool);
    void navigate(const char *);
    void destroy();
    void onUrlChanging(NSString *);
    
	void init(value _onDestroyedCallback, value _onURLChangingCallback, bool withPopup) {
		if(instance != nil) destroy();
		
		onDestroyedCallback = new AutoGCRoot(_onDestroyedCallback);
		onURLChangingCallback = new AutoGCRoot(_onURLChangingCallback);
		
		webViewDelegate = [[WebViewDelegate alloc] init];
		webViewDelegate.onUrlChanging = &onUrlChanging;
		webViewDelegate.onCloseClicked = &destroy;
		
		CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        
        NSString *dpi = @"mdpi";
        int padding = 29;
        
        if(screenScale > 1.0) {
            dpi = @"xhdpi";
            padding = 59;
        }
        
        padding /= 2;
        if(!withPopup) padding = 20;
        
		instance = [[UIWebView alloc] initWithFrame:CGRectMake(padding, padding, screen.size.width - (padding * 2), screen.size.height - 100)];
		instance.delegate = webViewDelegate;
        
		[[[UIApplication sharedApplication] keyWindow] addSubview:instance];
		
        if (withPopup) {
            UIImage *closeImage = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"assets/extensions_webview_assets_close_%@_png", dpi] ofType: nil]];
            
            closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton setImage:closeImage forState:UIControlStateNormal];
            closeButton.adjustsImageWhenHighlighted = NO;
            closeButton.frame = CGRectMake(0, 0, padding * 2, padding * 2);
            [closeButton addTarget:webViewDelegate action:@selector(onCloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [[[UIApplication sharedApplication] keyWindow] addSubview:closeButton];
        }
	}
    
	void navigate (const char *url) {
		NSURL *_url = [[NSURL alloc] initWithString: [[NSString alloc] initWithUTF8String:url]];
		NSURLRequest *req = [[NSURLRequest alloc] initWithURL:_url];
		[instance loadRequest:req];
	}
	
	void destroy () {
        val_call0(onDestroyedCallback->get());
		
		[instance stopLoading];
		[instance removeFromSuperview];
		[instance release];
		instance = nil;
		[webViewDelegate release];
		webViewDelegate = nil;
        
        if(closeButton != nil) {
            [closeButton release];
            closeButton = nil;
        }
	}
	
	void onUrlChanging (NSString *url) {
		val_call1(onURLChangingCallback->get(), alloc_string([url cStringUsingEncoding:NSUTF8StringEncoding]));
	}
}