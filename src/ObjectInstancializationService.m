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


//+(NSSet*) getPropertyNamesForClass:(Class) clazz {
//    unsigned int numberOfProperties = 0;
//    objc_property_t* properties = class_copyPropertyList(clazz, &numberOfProperties);
//    NSMutableSet * propertyNames = [[NSMutableSet alloc] init];
//    for (unsigned int i = 0; i < numberOfProperties; ++i) {
//        objc_property_t property = properties[i];
//        const char * name = property_getName(property);
//        [propertyNames addObject:[NSString stringWithUTF8String:name]];
//    }
//    free(properties);
//    return [propertyNames autorelease];
//}

+(NSString*) getPropertyName:(Ivar) property {
    return [NSString stringWithUTF8String:ivar_getName(property)];
}

+(BOOL) isIOCProperty:(Ivar) property {
    NSString * propertyName = [ObjectInstancializationService getPropertyName:property];
    return [propertyName hasPrefix:STABABLE_PROPERTY_PREFIX];
}

+(void) setValue:(id) propertyValue forProperty:(Ivar) property inObjectInstance:(id) instance {

    NSString * propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(property)];
    NSString * propertyName = [ObjectInstancializationService getPropertyName:property];

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
    Ivar* properties = class_copyIvarList(classInstance, &numberOfProperties);
    for (int i = 0; i < numberOfProperties; ++i) {
        Ivar property = properties[i];

        if (![ObjectInstancializationService isIOCProperty:property]) continue;

        NSString * propertyName = [ObjectInstancializationService getPropertyName:property];

        id propertyValue = [ObjectInstancializationService instantialize:NSClassFromString(propertyName)];

        [ObjectInstancializationService setValue:propertyValue forProperty:property inObjectInstance:classInstance];
    }
    return classInstance;
}


@end
