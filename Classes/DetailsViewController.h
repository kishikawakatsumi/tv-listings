#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *detailsView;
	NSString *detailPageURL;
}

@property (nonatomic, retain) UIWebView *detailsView;
@property (nonatomic, retain) NSString *detailPageURL;

@end
