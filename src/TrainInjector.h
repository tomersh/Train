//
//  TrainInjector.h
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainInjector : NSObject


+(id)getObject:(Class) clazz;

+(id)getObjectWithProtocol:(Protocol*) protocol;
+(NSArray*)getAllObjectsWithProtocol:(Protocol*) protocol;
@end
