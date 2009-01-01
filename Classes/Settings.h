#import <UIKit/UIKit.h>

#define CURRENT_VERSION 120

typedef enum {
    SettingsFontSizeSmall = 0,
    SettingsFontSizeMedium = 1,
    SettingsFontSizeLarge = 2,
    SettingsFontSizeExtraLarge = 3,
} SettingsFontSize;

@interface Settings : NSObject <NSCoding> {
	NSInteger version;
	NSString *area;
	NSInteger lhour;
	NSString *primeTimeFrom;
	NSString *primeTimeTo;
	SettingsFontSize fontSize;
	NSMutableArray *keywordHistory;
	NSMutableArray *orderOfViewControllers;
}

@property (nonatomic) NSInteger version;
@property (nonatomic, retain) NSString *area;
@property (nonatomic) NSInteger lhour;
@property (nonatomic, retain) NSString *primeTimeFrom;
@property (nonatomic, retain) NSString *primeTimeTo;
@property (nonatomic) SettingsFontSize fontSize;
@property (nonatomic, retain) NSMutableArray *keywordHistory;
@property (nonatomic, retain) NSMutableArray *orderOfViewControllers;

@end
