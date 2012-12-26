//
//  ObjectInstancializationService.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 12/19/12.
//  Copyright (c) 2012 Tomer Shiri. All rights reserved.
//

#import "ObjectInstancializationService.h"
#import "IOCDefines.h"

#import <objc/runtime.h>

@implementation ObjectInstancializationService


+(NSString*) getPropertyName:(Ivar) property {
    return [NSString stringWithUTF8String:ivar_getName(property)];
}

+(BOOL) isIOCProperty:(Ivar) property {
    NSString* propertyName = [ObjectInstancializationService getPropertyName:property];
    return [propertyName hasPrefix:STABABLE_PROPERTY_PREFIX];
}

+(void) setValueForProperty:(Ivar) property inObjectInstance:(id) instance {

    NSString* propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(property)];
    NSString* propertyName = [ObjectInstancializationService getPropertyName:property];

    NSString* className = [propertyName substringFromIndex:[STABABLE_PROPERTY_PREFIX length]];
    
    id propertyValue = [ObjectInstancializationService instantialize:NSClassFromString(className)];

    if (propertyValue == nil) {
        if ([propertyType length] > 2) {
            propertyValue = nil;
        }
        else {
            propertyValue = [NSNumber numberWithFloat:0.0];
        }
    }
    
    [instance setValue:propertyValue forKey:propertyName];
}

+(id) instantialize:(Class) clazz {
    id classInstance = [[clazz alloc] init];
    if (!classInstance) return classInstance;
    unsigned int numberOfProperties = 0;
    Ivar* properties = class_copyIvarList(clazz, &numberOfProperties);
    for (int i = 0; i < numberOfProperties; ++i) {
        Ivar property = properties[i];

        if (![ObjectInstancializationService isIOCProperty:property]) continue;

        [ObjectInstancializationService setValueForProperty:property inObjectInstance:classInstance];
    }
    return classInstance;
}


@end
