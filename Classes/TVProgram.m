#import "TVProgram.h"
#import "Debug.h"

@implementation TVProgram

@synthesize date;
@synthesize time;
@synthesize pubDate;
@synthesize category;
@synthesize title;
@synthesize details;
@synthesize link;

- (id)init {
	if (self = [super init]) {
		date = nil;
		time = nil;
		pubDate = nil;
		category = nil;
		title = nil;
		details = nil;
		link = nil;
	}
	return self;
}

- (void)dealloc {
	[link release];
	[details release];
	[title release];
	[category release];
	[pubDate release];
	[time release];
	[date release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:
			@"date = %@, time = %@, pubDate = %@, category = %@, title = %@, details = %@, link = %@",
			date, time, pubDate, category, title, details, link];
}

@end
