#import "TVProgramCellExtraLarge.h"
#import "Debug.h"

@implementation TVProgramCellExtraLarge

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
		[self setOpaque:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	[[UIColor colorWithRed:0.0f green:0.2f blue:0.8f alpha:1.0f] set];
	[time drawInRect:CGRectMake(2.0f, 3.0f, 98.0f, 18.0f) withFont:[UIFont boldSystemFontOfSize:16.0f]];
	[[UIColor blackColor] set];
	[title drawInRect:CGRectMake(108.0f, 2.0f, 212.0f, 22.0f) withFont:[UIFont boldSystemFontOfSize:18.0f] lineBreakMode:UILineBreakModeTailTruncation];
	[[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f] set];
	[detail drawInRect:CGRectMake(2.0f, 27.0f, 318.0f, 42.0f) withFont:[UIFont systemFontOfSize:18.0f] lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)drawSelectedBackgroundRect:(CGRect)rect {
	CGGradientRef gradientForSelected = createTwoColorsGradient(5, 140, 245, 1, 93, 230);
	drawRoundedRectBackgroundGradient(rect, gradientForSelected, NO, NO, NO);
	CGGradientRelease(gradientForSelected);
	[[UIColor whiteColor] set];
	[time drawInRect:CGRectMake(2.0f, 3.0f, 98.0f, 18.0f) withFont:[UIFont boldSystemFontOfSize:16.0f]];
	[title drawInRect:CGRectMake(108.0f, 2.0f, 212.0f, 22.0f) withFont:[UIFont boldSystemFontOfSize:18.0f] lineBreakMode:UILineBreakModeTailTruncation];
	[detail drawInRect:CGRectMake(2.0f, 27.0f, 318.0f, 42.0f) withFont:[UIFont systemFontOfSize:18.0f] lineBreakMode:UILineBreakModeTailTruncation];
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
    [super dealloc];
}

@end
