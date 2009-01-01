#import <UIKit/UIKit.h>

@interface TVProgramCellExtraLarge : UITableViewCell {
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *detailLabel;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *categoryLabel;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *categoryLabel;

@end
