//
//  ObjectInstancializationService.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import "TrainInjector.h"
#import "IOCDefines.h"
#import "ProtocolLocator.h"

#import <objc/runtime.h>

@implementation TrainInjector

+(NSString*) getIvarName:(Ivar) iVar {
    return [NSString stringWithUTF8String:ivar_getName(iVar)];
}

+(BOOL) isIOCIvar:(Ivar) iVar {
    NSString* ivarName = [TrainInjector getIvarName:iVar];
    return [ivarName hasPrefix:IOC_IVAR_PREFIX];
}

+(BOOL) isArray:(NSString*) iVarType {
    return iVarType && [iVarType isEqualToString:@"NSArray"];
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

+(id) iVarDefaultValueForType:(NSString*) iVarType {
    if ([iVarType length] > 2) {
        return nil;
    }
    return [NSNumber numberWithFloat:0.0];
}

+(void) setValueForIvar:(Ivar)ivar inObjectInstance:(id) instance {

    NSString* ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    NSString* className = [TrainInjector classNameFromType:ivarType];
    NSString* ivarName = [TrainInjector getIvarName:ivar];
    
    id ivarValue;
    
    if ([TrainInjector isProtocol:className]) {
        NSString* protocolName = [TrainInjector protocolNameFromType:className];
        ivarValue = [TrainInjector getObjectWithProtocol:NSProtocolFromString(protocolName)];
    }
    else if ([TrainInjector isArray:className]) {
        NSString* protocolNameFromIvarName = [ivarName substringFromIndex:[IOC_IVAR_PREFIX length]];
        ivarValue = [TrainInjector getAllObjectsWithProtocol:NSProtocolFromString(protocolNameFromIvarName)];
    }
    else {
        ivarValue = [TrainInjector getObject:NSClassFromString(className)];
    }

    if (ivarValue == nil) {
        ivarValue = [TrainInjector iVarDefaultValueForType:ivarType];
    }
    [instance setValue:ivarValue forKey:ivarName];
}

+(NSArray*)getAllObjectsWithProtocol:(Protocol*) protocol {
    NSArray* classesForProtocol = [ProtocolLocator getAllClassesByProtocolType:protocol];
    if (!classesForProtocol) return nil;
    NSMutableArray* instances = [[NSMutableArray alloc] initWithCapacity:[classesForProtocol count]];
    
    for (Class clazz in classesForProtocol) {
        id instance = [TrainInjector getObject:clazz];
        
        if (!instance) continue;
        
        [instances addObject:instance];
    }
    return [instances autorelease];
}

+(id)getObjectWithProtocol:(Protocol*) protocol {
    NSArray* classesForProtocol = [ProtocolLocator getAllClassesByProtocolType:protocol];
    if (!classesForProtocol) return nil;
    Class clazz = [classesForProtocol objectAtIndex:0];
    id instance = [[TrainInjector getObject:clazz] retain];
    return [instance autorelease];
}

+(id)getObject:(Class) clazz {
    id classInstance = [[clazz alloc] init];
    if (!classInstance) return classInstance;
    unsigned int numberOfIvars = 0;
    Ivar* iVars = class_copyIvarList(clazz, &numberOfIvars);
    for (int i = 0; i < numberOfIvars; ++i) {
        Ivar ivar = iVars[i];

        if (![TrainInjector isIOCIvar:ivar]) continue;

        [TrainInjector setValueForIvar:ivar inObjectInstance:classInstance];
    }
    return classInstance;
}


@end
