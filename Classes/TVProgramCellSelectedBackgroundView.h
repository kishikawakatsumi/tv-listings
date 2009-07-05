//
//  TVProgramCellSelectedBackgroundView.h
//  TVListings
//
//  Created by KISHIKAWA Katsumi on 09/07/06.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TVProgramCell;

@interface TVProgramCellSelectedBackgroundView : UITableViewCell {
	TVProgramCell *cell;
}

@property (nonatomic, assign) TVProgramCell *cell;

@end
