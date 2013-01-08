//
//  TrainInjector.h
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import <Foundation/Foundation.h>

#define injectClass(className) ([TrainInjector getObject:[className class]])
#define injectProtocol(protocol) ([TrainInjector getObjectWithProtocol:protocol])
#define injectProtocols(protocol) ([TrainInjector getAllObjectsWithProtocol:protocol])

@interface TrainInjector : NSObject

+(id) getObject:(Class) clazz;

+(id) getObjectWithProtocol:(Protocol*) protocol;

+(NSArray*) getAllObjectsWithProtocol:(Protocol*) protocol;


+(void) injectIocClasses:(id) classInstance;


+(void) setIocPrefix:(NSString*) iocPrefix;
+(NSString*) getIocPrefix;

@end
