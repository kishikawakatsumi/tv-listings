#import <UIKit/UIKit.h>
#import "TableCellDrawing.h"

@interface TVProgramCell : UITableViewCell {
	NSString *title;
	NSString *detail;
	NSString *time;
	NSString *date;
	NSString *category;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *category;

- (void)drawSelectedBackgroundRect:(CGRect)rect;

@end
