//
//  ProtocolLocatorTests.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 1/1/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "ProtocolLocatorTests.h"
#import "ProtocolLocator.h"

@protocol ProtocolWithNoImplementation <NSObject>
@end
@protocol ProtocolWithOneImplementation <NSObject>
@end
@protocol ProtocolWithTwoImplementations <NSObject>
@end
@protocol ProtocolWithInheritingProtocol <NSObject>
@end
@protocol ProtocolWithClassInharitation <NSObject>
@end

@protocol InheritingProtocol <ProtocolWithInheritingProtocol>
@end

@interface  ProtocolWithOneImplementationImplementation  :  NSObject<ProtocolWithOneImplementation>
@end
@implementation ProtocolWithOneImplementationImplementation
@end

@interface  ProtocolWithTwoImplementationsFirstImplementation  :  NSObject<ProtocolWithTwoImplementations>
@end
@implementation ProtocolWithTwoImplementationsFirstImplementation
@end

@interface  ProtocolWithTwoImplementationsSecondImplementation  :  NSObject<ProtocolWithTwoImplementations>
@end
@implementation ProtocolWithTwoImplementationsSecondImplementation
@end

@interface  InheritingProtocolImplementation  :  NSObject<InheritingProtocol>
@end
@implementation InheritingProtocolImplementation
@end

@interface  ProtocolWithInheritingProtocolImplementation  :  NSObject<ProtocolWithInheritingProtocol>
@end
@implementation ProtocolWithInheritingProtocolImplementation
@end

@interface  ProtocolWithClassInharitationImplementation  :  NSObject<ProtocolWithClassInharitation>
@end
@implementation ProtocolWithClassInharitationImplementation
@end

@interface  ImplementingClassInharitor :  ProtocolWithClassInharitationImplementation
@end
@implementation ImplementingClassInharitor
@end

@implementation ProtocolLocatorTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_getAllClassesByProtocolType_nilProtocol_emptyResponse
{
    [self assertThatRequestingClassesImplementingProtocol:nil returns:nil];
}

- (void)test_getAllClassesByProtocolType_nonExistingProtocol_emptyResponse
{
    [self assertThatRequestingClassesImplementingProtocol:NSProtocolFromString(@"NonExistingProtocol") returns:nil];
}

- (void)test_getAllClassesByProtocolType_protocolWithNoImplementation_emptyResponse
{
    [self assertThatRequestingClassesImplementingProtocol:@protocol(ProtocolWithNoImplementation) returns:nil];
}

- (void)test_getAllClassesByProtocolType_protocolWithOneImplementation_ShouldReturnOneImplementation
{
    [self assertThatRequestingClassesImplementingProtocol:@protocol(ProtocolWithOneImplementation) returns:@[ [ProtocolWithOneImplementationImplementation class] ]];
}

- (void)test_getAllClassesByProtocolType_protocolWithTwoImplementations_ShouldReturnTwoImplementations
{
    [self assertThatRequestingClassesImplementingProtocol:@protocol(ProtocolWithTwoImplementations) returns:@[ [ProtocolWithTwoImplementationsFirstImplementation class], [ProtocolWithTwoImplementationsSecondImplementation class] ]];
}

- (void)test_getAllClassesByProtocolType_protocolWithInharitance_ShouldReturnBaseProtocolAndChildProtocolImplementors
{    
    [self assertThatRequestingClassesImplementingProtocol:@protocol(ProtocolWithInheritingProtocol) returns:@[ [ProtocolWithInheritingProtocolImplementation class], [InheritingProtocolImplementation class] ]];
}

- (void)test_getAllClassesByProtocolType_classesWithInharitance_ShouldReturnAllClassesThatConformsToProtocol
{
    [self assertThatRequestingClassesImplementingProtocol:@protocol(ProtocolWithClassInharitation) returns:@[ [ProtocolWithClassInharitationImplementation class], [ImplementingClassInharitor class] ]];
}

-(void) assertThatRequestingClassesImplementingProtocol:(Protocol*) protocol returns:(NSArray*) expectedResponse {
    NSArray* actualResponse = [ProtocolLocator getAllClassesByProtocolType:protocol];
    [self assertThatAllObjectsInResponse:actualResponse ConformsToProtocol:protocol];
    [self assertThatResponse:actualResponse ContainsImplementations:expectedResponse];
}

-(void) assertResultObject:(NSArray*) resultObject hasElements:(int) count {
    STAssertNotNil(resultObject, @"A response should always be returned");
    int numberOfClasses = [resultObject count];
    STAssertEquals(numberOfClasses, count, @"number of returned elements");
}

-(void) assertThatAllObjectsInResponse:(NSArray*) response ConformsToProtocol:(Protocol*) protocol {
    for (Class clazz in response) {
        STAssertTrue([clazz conformsToProtocol:protocol], @"%@ must conform to protocol %@",NSStringFromClass(clazz),NSStringFromProtocol(protocol));
    }
}

-(void) assertThatResponse:(NSArray*) response ContainsImplementations:(NSArray*) implementations {
    for (Class clazz in implementations) {
        STAssertTrue([response containsObject:clazz], @"response must contain the class %@",NSStringFromClass(clazz));
    }
    int expectedresultCount = implementations ? [implementations count] : 0;
    [self assertResultObject:response hasElements:expectedresultCount];
}

@end
