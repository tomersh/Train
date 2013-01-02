//
//  ProtocolLocator.m
//
//  Created by Tomer Shiri on 12/19/11.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProtocolLocator.h"
#import "objc/runtime.h"

@implementation ProtocolLocator

static NSArray* allClasses;

-(id) init {
    return nil; //I'm a static service.
}

+(void) initialize {
    int numClasses = objc_getClassList(NULL, 0);
    Class* allClassesMemoization = NULL;
    allClassesMemoization = malloc(sizeof(Class) * numClasses);
    int allClassCount = objc_getClassList(allClassesMemoization, numClasses);
    NSMutableArray* allClassesList = [NSMutableArray arrayWithCapacity:allClassCount];
    for (int i = 0; i < allClassCount; ++i) {
        Class clazz = allClassesMemoization[i];
        if([ProtocolLocator isClass:clazz descendsFromClass:[NSObject class]])
            [allClassesList addObject:clazz];
    }
    allClasses = [[NSArray alloc] initWithArray:allClassesList];
}


+(NSArray *) getAllClassesByProtocolType:(Protocol*) protocol {
    NSMutableArray* classesConformingToProtocol = [NSMutableArray arrayWithCapacity:[allClasses count]];
    for (Class clazz in allClasses) {
        if ([clazz conformsToProtocol:protocol])
            [classesConformingToProtocol addObject:clazz];
    }
    return [NSArray arrayWithArray:classesConformingToProtocol];
}


+ (BOOL) isClass:(Class) classA descendsFromClass:(Class) classB
{
    while(classA)
    {
        if(classA == classB) return YES;
        classA = class_getSuperclass(classA);
    }
    return NO;
}

@end
