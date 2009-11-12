#import "WaitingView.h"
#import "Debug.h"

@implementation WaitingView

@synthesize tvSearchviewController;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[tvSearchviewController.tvSearchBar resignFirstResponder];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[self setAlpha:0.0];
	[UIView commitAnimations];
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[tvSearchviewController release];
    [super dealloc];
}

@end
