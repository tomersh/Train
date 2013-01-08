//
//  AutoInjector.m
//
//  Created by Tomer Shiri on 1/8/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "AutoInjector.h"
#import "TrainInjector.h"
#import <objc/runtime.h>


@implementation AutoInjector

static BOOL _wasTriggered;

void (*originalInitImplementation)(id, SEL, ...);

+(void)initialize {
    _wasTriggered = NO;
}


+(void) autoInjectIoc {
    if (_wasTriggered) return;
    _wasTriggered = YES;

    Class targetClass = [NSObject class];
    SEL targetSelector = @selector(init);
    
    Method originalInitMethod = class_getInstanceMethod(targetClass, targetSelector);
    originalInitImplementation = (void *)method_getImplementation(originalInitMethod);

    if(!class_addMethod(targetClass, targetSelector, (IMP)OverrideInit, method_getTypeEncoding(originalInitMethod)))
        method_setImplementation(originalInitMethod, (IMP)OverrideInit);
}

static id OverrideInit(id self, SEL _cmd, ...)
{
    va_list args;
    va_start(args, _cmd);
    originalInitImplementation(self, _cmd, args);
    [TrainInjector injectIocClasses:self];
    return self;
}

@end
