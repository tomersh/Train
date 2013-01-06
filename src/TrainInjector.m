//
//  ObjectInstancializationService.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import "TrainInjector.h"
#import "ProtocolLocator.h"

#import <objc/runtime.h>

@implementation TrainInjector

static NSString* _iocPrefix;


-(id) init {
    return nil;
}

+(void) initialize {
    [TrainInjector setIocPrefix:@"_ioc_"];
}

+(void) setIocPrefix:(NSString*) iocPrefix {
    if (!iocPrefix || [iocPrefix isEqualToString:@""]) return;
    [_iocPrefix release];
    _iocPrefix = nil;
    _iocPrefix = [iocPrefix retain];
}

+(NSString*) getIocPrefix {
    return _iocPrefix;
}

+(NSString*) getIvarName:(Ivar) iVar {
    return [NSString stringWithUTF8String:ivar_getName(iVar)];
}

+(BOOL) isIOCIvar:(Ivar) iVar {
    NSString* ivarName = [TrainInjector getIvarName:iVar];
    return [ivarName hasPrefix:_iocPrefix];
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

+(BOOL) isObject:(NSString*) ivarTypeAsString {
    return ivarTypeAsString && [ivarTypeAsString length] > 2;
}

+(void) setValueForIvar:(Ivar)ivar inObjectInstance:(id) instance {

    NSString* ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    
    NSString* ivarName = [TrainInjector getIvarName:ivar];
    
    if (![TrainInjector isObject:ivarType]) {
        [instance setValue:[NSNumber numberWithFloat:0.0] forKey:ivarName];
        return;
    }
    
    NSString* className = [TrainInjector classNameFromType:ivarType];
    
    id ivarValue;
    
    if ([TrainInjector isProtocol:className]) {
        NSString* protocolName = [TrainInjector protocolNameFromType:className];
        ivarValue = [TrainInjector getObjectWithProtocol:NSProtocolFromString(protocolName)];
    }
    else if ([TrainInjector isArray:className]) {
        NSString* protocolNameFromIvarName = [ivarName substringFromIndex:[_iocPrefix length]];
        ivarValue = [TrainInjector getAllObjectsWithProtocol:NSProtocolFromString(protocolNameFromIvarName)];
    }
    else {
        ivarValue = [TrainInjector getObject:NSClassFromString(className)];
    }

    [instance setValue:ivarValue forKey:ivarName];
}

+(NSArray*)getAllObjectsWithProtocol:(Protocol*) protocol {
    NSArray* classesForProtocol = [ProtocolLocator getAllClassesByProtocolType:protocol];
    if (!classesForProtocol || [classesForProtocol count] == 0) return nil;
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
    if (!classesForProtocol || [classesForProtocol count] == 0) return nil;
    Class clazz = [classesForProtocol objectAtIndex:0];
    return [TrainInjector getObject:clazz];
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
    return [classInstance autorelease];
}


@end
