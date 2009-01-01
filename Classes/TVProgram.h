#import <UIKit/UIKit.h>

@interface TVProgram : NSObject {
	NSString *date;
	NSString *time;
	NSString *pubDate;
	NSString *category;
	NSString *title;
	NSString *details;
	NSString *link;
}

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *pubDate;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *details;
@property (nonatomic, retain) NSString *link;

@end
