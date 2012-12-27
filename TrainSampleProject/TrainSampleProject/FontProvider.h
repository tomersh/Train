//
//  FontProvider.h
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/26/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FontProviderProtocol

-(UIFont*) buttonFont;

@end

@interface FontProvider : NSObject<FontProviderProtocol>

@end
