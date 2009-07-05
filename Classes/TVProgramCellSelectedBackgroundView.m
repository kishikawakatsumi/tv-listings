//
//  TVProgramCellSelectedBackgroundView.m
//  TVListings
//
//  Created by KISHIKAWA Katsumi on 09/07/06.
//  Copyright 2009 KISHIKAWA Katsumi. All rights reserved.
//

#import "TVProgramCellSelectedBackgroundView.h"
#import "TVProgramCell.h"

@implementation TVProgramCellSelectedBackgroundView

@synthesize cell;

- (void)drawRect:(CGRect)rect {
    [cell drawSelectedBackgroundRect:rect];
}

- (void)dealloc {
    [super dealloc];
}

@end
