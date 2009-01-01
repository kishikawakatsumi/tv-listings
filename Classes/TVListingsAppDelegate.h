#import <UIKit/UIKit.h>
#import "Settings.h"
#import "DetailsViewController.h"
#import "Reachability.h"

@interface TVListingsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
    IBOutlet UITabBarController *tabBarController;
	Settings *settings;
	DetailsViewController *sharedDetailsViewController;
	NSString *dataFilePath;
	
	NSInteger lhour;
	NSInteger shour;
	NSString *sdate;
	
	NSDate *baseDate;
	
	NetworkStatus remoteHostStatus;
	NetworkStatus internetConnectionStatus;
	NetworkStatus localWiFiConnectionStatus;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) Settings *settings;
@property (nonatomic, retain) DetailsViewController *sharedDetailsViewController;
@property (nonatomic, retain) NSString *dataFilePath;

@property (nonatomic) NSInteger lhour;
@property (nonatomic) NSInteger shour;
@property (nonatomic, retain) NSString *sdate;

@property (nonatomic, retain) NSDate *baseDate;

@property NetworkStatus remoteHostStatus;
@property NetworkStatus internetConnectionStatus;
@property NetworkStatus localWiFiConnectionStatus;

+ (TVListingsAppDelegate *)sharedTVListingsApp;
+ (NSArray *)regionList;
+ (NSArray *)timeList;
- (void)saveSettings;

@end
