#import "Settings.h"
#import "Debug.h"

@implementation Settings

@synthesize version;
@synthesize area;
@synthesize lhour;
@synthesize primeTimeFrom;
@synthesize primeTimeTo;
@synthesize fontSize;
@synthesize keywordHistory;
@synthesize orderOfViewControllers;

- (id)init {
	if (self = [super init]) {
		version = CURRENT_VERSION;
		self.area = @"008";
		self.lhour = 2;
		self.primeTimeFrom = @"19:00";
		self.primeTimeTo = @"23:00";
		fontSize = SettingsFontSizeSmall;
		keywordHistory = [[NSMutableArray alloc] initWithCapacity:10];
		orderOfViewControllers = nil;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	version = [coder decodeIntForKey:@"version"];
	area = [[coder decodeObjectForKey:@"area"] retain];
	if (!area) {
		self.area = @"008";
	}
	lhour = [coder decodeIntForKey:@"lhour"];
	if (!lhour) {
		self.lhour = 2;
	}
	primeTimeFrom = [[coder decodeObjectForKey:@"primeTimeFrom"] retain];
	if (!primeTimeFrom) {
		self.primeTimeFrom = @"19:00";
	}
	primeTimeTo = [[coder decodeObjectForKey:@"primeTimeTo"] retain];
	if (!primeTimeTo) {
		self.primeTimeTo = @"23:00";
	}
	fontSize = [coder decodeIntForKey:@"fontSize"];
	keywordHistory = [[coder decodeObjectForKey:@"keywordHistory"] retain];
	orderOfViewControllers = [[coder decodeObjectForKey:@"orderOfViewControllers"] retain];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeInt:version forKey:@"version"];
	[encoder encodeObject:area forKey:@"area"];
	[encoder encodeInt:lhour forKey:@"lhour"];
	[encoder encodeObject:primeTimeFrom forKey:@"primeTimeFrom"];
	[encoder encodeObject:primeTimeTo forKey:@"primeTimeTo"];
	[encoder encodeInt:fontSize forKey:@"fontSize"];
	[encoder encodeObject:keywordHistory forKey:@"keywordHistory"];
	[encoder encodeObject:orderOfViewControllers forKey:@"orderOfViewControllers"];
}

- (void)dealloc {
	LOG_CURRENT_METHOD;
	[orderOfViewControllers release];
	[keywordHistory release];
	[primeTimeTo release];
	[primeTimeFrom release];
	[area release];
	[super dealloc];
}

@end
