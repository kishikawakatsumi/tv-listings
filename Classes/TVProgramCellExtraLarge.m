#import "TVProgramCellExtraLarge.h"
#import "Debug.h"

@implementation TVProgramCellExtraLarge

@synthesize titleLabel;
@synthesize detailLabel;
@synthesize timeLabel;
@synthesize dateLabel;
@synthesize categoryLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        [self setAccessoryType:UITableViewCellAccessoryNone];
		[self setOpaque:YES];
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f, 4.0f, 98.0f, 18.0f)];
		[timeLabel setOpaque:YES];
		[timeLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[timeLabel setTextColor:[UIColor colorWithRed:0.0f green:0.2f blue:0.8f alpha:1.0f]];
		[timeLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self addSubview:timeLabel];
		
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(108.0f, 2.0f, 212.0f, 22.0f)];
		[titleLabel setOpaque:YES];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
		[titleLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self addSubview:titleLabel];
		
		detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 28.0f, 320.0f, 42.0f)];
		[detailLabel setOpaque:YES];
		[detailLabel setFont:[UIFont systemFontOfSize:18.0f]];
		[detailLabel setNumberOfLines:2];
		[detailLabel setTextColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
		[detailLabel setHighlightedTextColor:[UIColor whiteColor]];
		[self addSubview:detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[categoryLabel release];
	[dateLabel release];
	[timeLabel release];
	[detailLabel release];
	[titleLabel release];
    [super dealloc];
}

@end
