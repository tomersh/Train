//
//  ColorProviderProtocol.h
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/27/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ColorProviderProtocol<NSObject>

-(UIColor*) backgroundColor;

-(UIColor*) textColor;

-(UIColor*) buttonColor;

@end
