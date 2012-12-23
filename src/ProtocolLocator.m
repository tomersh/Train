//
//  ProtocolLocator.m
//
//  Created by Tomer Shiri on 12/19/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProtocolLocator.h"
#import "objc/runtime.h"

@implementation ProtocolLocator

static Class* allClassesMemoization = NULL; 
static int allClassCount;

-(id) init {
    return nil; //I'm a static service.
}

+(void) initialize {
    int numClasses = objc_getClassList(NULL, 0);
    allClassesMemoization = NULL;
    allClassesMemoization = malloc(sizeof(Class) * numClasses);
    allClassCount = objc_getClassList(allClassesMemoization, numClasses);
}

+(NSArray *) getAllClassesByProtocolType:(Protocol*) protocol {
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < allClassCount; i++) {
        if (class_conformsToProtocol(allClassesMemoization[i],protocol))
            [result addObject:allClassesMemoization[i]];
    }
    return result;
}

@end
