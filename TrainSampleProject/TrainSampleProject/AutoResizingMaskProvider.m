//
//  AutoresizingMaskProvider.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/26/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import "AutoresizingMaskProvider.h"

@implementation AutoresizingMaskProvider

-(UIViewAutoresizing) centeredAutoresizingMask {
    return (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
}

@end
