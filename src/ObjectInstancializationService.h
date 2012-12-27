//
//  ObjectInstancializationService.h
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectInstancializationService : NSObject


+(id) instantialize:(Class) clazz;

+(id) instantializeWithProtocol:(Protocol*) protocol;
+(NSArray*) instantializeAllWithProtocol:(Protocol*) protocol;
@end
