#import <UIKit/UIKit.h>
#import "Settings.h"
#import "TableCellDrawing.h"

@interface TVProgramCell : UITableViewCell {
	NSString *title;
	NSString *detail;
	NSString *time;
	NSString *date;
	NSString *category;
    SettingsFontSize fontSize;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, assign) SettingsFontSize fontSize;

- (void)drawSelectedBackgroundRect:(CGRect)rect;

@end
