#import <UIKit/UIKit.h>
#include <hx/Macros.h>
#include <hx/CFFI.h>
#include <NMEWebView.h>

typedef void (*FunctionType)();

@interface WebViewDelegate : NSObject <UIWebViewDelegate>
@property (nonatomic) FunctionType loadFinished;
@end
@implementation WebViewDelegate
@synthesize loadFinished;
- (void)webViewDidFinishLoad:(UIWebView *)instance {
	loadFinished();
}
@end


namespace arcademonk {
	UIWebView *instance;
	WebViewDelegate *webViewDelegate;
	AutoGCRoot *onDestroyedCallback = 0;
	AutoGCRoot *onURLChangingCallback = 0;
	void init();
    void navigate();
    void destroy();
    void onLoadFinished();
    
	void init(value _onDestroyedCallback, value _onURLChangingCallback) {
		if(instance != nil) destroy();
		
		onDestroyedCallback = new AutoGCRoot(_onDestroyedCallback);
		onURLChangingCallback = new AutoGCRoot(_onURLChangingCallback);
		
		webViewDelegate = [[WebViewDelegate alloc] init];
		webViewDelegate.loadFinished = &onLoadFinished;
		
		CGRect screen = [[UIScreen mainScreen] bounds];
		instance = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
		instance.delegate = webViewDelegate;
		
		[[[UIApplication sharedApplication] keyWindow] addSubview:instance];
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
	}
	
	void onLoadFinished () {
		val_call1(onURLChangingCallback->get(), alloc_string([instance.request.URL.absoluteString cStringUsingEncoding:NSUTF8StringEncoding]));
	}
}