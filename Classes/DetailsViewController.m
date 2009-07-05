#import "DetailsViewController.h"
#import "NSString+XMLExtensions.h"
#import "Debug.h"
#import <objc/runtime.h>

@implementation DetailsViewController

@synthesize detailsView;
@synthesize detailPageURL;

static NSObject *webViewcreateWebViewWithRequestIMP(id self, SEL _cmd, NSObject* sender, NSObject* request) {
	return [sender retain];
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[detailPageURL release];
	[detailsView setDelegate:nil];
	[detailsView release];
    [super dealloc];
}

#pragma mark <UIWebViewDelegate> Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webView stringByEvaluatingJavaScriptFromString:@"window.open = function(url){window.location.href=url;};"];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webView stringByEvaluatingJavaScriptFromString:@"window.open = function(url){window.location.href=url;};"];

}

#pragma mark <UIViewController> Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	Class UIWebViewWebViewDelegate = objc_getClass("UIWebViewWebViewDelegate");
	class_addMethod(UIWebViewWebViewDelegate, @selector(webView:createWebViewWithRequest:), 
					(IMP)webViewcreateWebViewWithRequestIMP, "@@:@@");
}

- (void)viewWillDisappear:(BOOL)animated {
	[detailsView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated {
	[detailsView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailPageURL]]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if (fromInterfaceOrientation == UIDeviceOrientationIsPortrait(fromInterfaceOrientation)) {
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	} else {
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
