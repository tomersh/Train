//
//  ObjectInstancializationService.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import "ObjectInstancializationService.h"
#import "IOCDefines.h"
#import "ProtocolLocator.h"

#import <objc/runtime.h>

@implementation ObjectInstancializationService


+(NSString*) getIvarName:(Ivar) iVar {
    return [NSString stringWithUTF8String:ivar_getName(iVar)];
}

+(BOOL) isIOCIvar:(Ivar) iVar {
    NSString* ivarName = [ObjectInstancializationService getIvarName:iVar];
    return [ivarName hasPrefix:STABABLE_PROPERTY_PREFIX];
}

+(BOOL) isProtocol:(NSString*) iVarType {
    return iVarType && [iVarType hasPrefix:@"<"] && [iVarType hasSuffix:@">"];
}

+(NSString*) protocolNameFromType:(NSString*) iVarType {
    //<xxx>
    return [[iVarType substringFromIndex:1] substringToIndex:[iVarType length] - 2];
}

+(NSString*) classNameFromType:(NSString*) iVarType {
    //@"xxx"
    return [[iVarType substringFromIndex:2] substringToIndex:[iVarType length] - 3];
}


+(void) setValueForIvar:(Ivar)ivar inObjectInstance:(id) instance {

    NSString* ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];

    id ivarValue;
    
    NSString* className = [ObjectInstancializationService classNameFromType:ivarType];
    
    if ([ObjectInstancializationService isProtocol:className]) {
        NSString* protocolName = [ObjectInstancializationService protocolNameFromType:className];
        ivarValue = [ObjectInstancializationService instantializeWithProtocol:NSProtocolFromString(protocolName)];
    }
    else {
        ivarValue = [ObjectInstancializationService instantialize:NSClassFromString(className)];
    }

    if (ivarValue == nil) {
        if ([ivarType length] > 2) {
            ivarValue = nil;
        }
        else {
            ivarValue = [NSNumber numberWithFloat:0.0];
        }
    }
    
    NSString* ivarName = [ObjectInstancializationService getIvarName:ivar];
    [instance setValue:ivarValue forKey:ivarName];
}

+(NSArray*) instantializeAllWithProtocol:(Protocol*) protocol {
    NSArray* classesForProtocol = [ProtocolLocator getAllClassesByProtocolType:protocol];
    if (!classesForProtocol) return nil;
    NSMutableArray* instances = [[NSMutableArray alloc] initWithCapacity:[classesForProtocol count]];
    for (int i = 0; i < [classesForProtocol count]; ++i) {
        Class clazz = [classesForProtocol objectAtIndex:(NSUInteger) i];
        id instance = [ObjectInstancializationService instantialize:clazz];
        
        if (!instance) continue;
        
        [instances addObject:instance];
    }
    return [instances autorelease];
}

+(id) instantializeWithProtocol:(Protocol*) protocol {
    NSArray* classesForProtocol = [ProtocolLocator getAllClassesByProtocolType:protocol];
    if (!classesForProtocol) return nil;
    Class clazz = [classesForProtocol objectAtIndex:0];
    id instance = [[ObjectInstancializationService instantialize:clazz] retain];
    return [instance autorelease];
}

+(id) instantialize:(Class) clazz {
    id classInstance = [[clazz alloc] init];
    if (!classInstance) return classInstance;
    unsigned int numberOfProperties = 0;
    Ivar* properties = class_copyIvarList(clazz, &numberOfProperties);
    for (int i = 0; i < numberOfProperties; ++i) {
        Ivar ivar = properties[i];

        if (![ObjectInstancializationService isIOCIvar:ivar]) continue;

        [ObjectInstancializationService setValueForIvar:ivar inObjectInstance:classInstance];
    }
    return classInstance;
}


@end
