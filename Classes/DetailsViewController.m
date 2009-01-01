#import "DetailsViewController.h"
#import "NSString+XMLExtensions.h"
#import "Debug.h"

@implementation DetailsViewController

@synthesize detailsView;
@synthesize detailPageURL;

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[detailPageURL release];
	[detailsView setDelegate:nil];
	[detailsView release];
    [super dealloc];
}

#pragma mark <UIWebViewDelegate> Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *aURL = [[request URL] absoluteString];
	NSString *mainDocumentURL = [request.mainDocumentURL absoluteString];
	if (mainDocumentURL == nil || ![mainDocumentURL isEqualToString:aURL]) {
		return NO;
	}
	
	LOG(@"<%@>", [request URL]);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[webView stringByEvaluatingJavaScriptFromString:
	 @"try {var a = document.getElementsByTagName('a'); for (var i = 0; i < a.length; ++i) { a[i].setAttribute('target', '');}}catch (e){}; document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark <UIViewController> Methods

- (void)viewDidLoad {
    [super viewDidLoad];
	[detailsView setBackgroundColor:[UIColor whiteColor]];
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
