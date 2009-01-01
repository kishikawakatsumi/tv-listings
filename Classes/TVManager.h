#import <UIKit/UIKit.h>

@interface TVManager : NSObject

- (NSDictionary *)getTVList:(NSString *)feedURL;
- (NSDictionary *)getTVList:(NSString *)feedURL dateIndexed:(BOOL)dateIndexed;

@end
