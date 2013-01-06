//
//  TrainInjectorIocPrefixTests.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 1/6/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "TrainInjectorIocPrefixTests.h"
#import "TrainInjector.h"

@implementation TrainInjectorIocPrefixTests

static NSString* defaultIocPrefix = @"_ioc_";

- (void)setUp
{
    [super setUp];
    [self assertIocPrefixValueEquals:defaultIocPrefix]; // test default value;
}

- (void)tearDown
{
    [TrainInjector setIocPrefix:defaultIocPrefix];
    [super tearDown];
}

-(void) test_setIocPrefix_changesPrefixValue {
    NSString* newPrefix = @"newPrefix";
    [TrainInjector setIocPrefix:newPrefix];
    [self assertIocPrefixValueEquals:newPrefix];
}

-(void) test_setIocPrefix_willNotExceptNil {
    NSString* newPrefix = @"newPrefix";
    [TrainInjector setIocPrefix:newPrefix];
     [TrainInjector setIocPrefix:nil];
    [self assertIocPrefixValueEquals:newPrefix];
}

-(void) test_setIocPrefix_willNotExceptEmptyString {
    NSString* newPrefix = @"newPrefix";
    [TrainInjector setIocPrefix:newPrefix];
    [TrainInjector setIocPrefix:@""];
    [self assertIocPrefixValueEquals:newPrefix];
}

-(void) test_getIocPrefix_doesNotExposeSetter {
    [TrainInjector setIocPrefix:defaultIocPrefix];
    NSString* iocPrefix = [TrainInjector getIocPrefix];
    iocPrefix = @"otherPrefix";
    [self assertIocPrefixValueEquals:defaultIocPrefix];
}

-(void) assertIocPrefixValueEquals:(NSString*) expectedValue {
    id actualValue = [TrainInjector getIocPrefix];
    STAssertNotNil(actualValue, @"ioc prefix cant be nil");
    STAssertTrue([actualValue isKindOfClass:[NSString class]], @"ioc prefix must be a s tring");
    STAssertEquals(actualValue, expectedValue, @"expected ioc prefix to be %@ but was %@", expectedValue, actualValue);
}


@end
