//
//  TrainInjectorTests.m
//  TrainSampleProject
//
//  Created by Tomer Shiri on 1/4/13.
//  Copyright (c) 2013 Tomer Shiri. All rights reserved.
//

#import "TrainInjectorTests.h"
#import "TrainInjector.h"
#import "ProtocolLocator.h"

#import <OBJC/runtime.h>

#define injectableIvarName(name) _ioc_##name

@protocol InjectedClassProtocol <NSObject>

@end
@interface InjectedClass : NSObject
@end
@implementation InjectedClass {
}
@end

@interface TestResponseClass : NSObject {
    @public
        int injectableIvarName(primitive);
        InjectedClass*  injectableIvarName(shouldInjectObject);
        InjectedClass*  shouldNotInjectObject;
        id<InjectedClassProtocol> injectableIvarName(shouldInjectImplementation);
        NSArray* injectableIvarName(InjectedClassProtocol);
}

@end
@implementation TestResponseClass
@end

@interface AnotherTestResponseClass : NSObject
@end
@implementation AnotherTestResponseClass
@end

@interface NillingClass : NSObject
@end
@implementation NillingClass
-(id) init { return nil; }
@end


@implementation TrainInjectorTests {
    Method originalMethod;
    Method lastStub;
}

- (void)setUp
{
    [super setUp];
    originalMethod = class_getClassMethod([ProtocolLocator class], @selector(getAllClassesByProtocolType:));
}

- (void)tearDown
{
    if (lastStub && originalMethod)
        method_exchangeImplementations(lastStub, originalMethod);
    [super tearDown];
}


-(void) test_getObject_nilClass_shouldReturnNil {
    id resultObject = [TrainInjector getObject:nil];
    STAssertNil(resultObject, @"nil initialization should return nil");
}

-(void) test_getObject_nonExistingClass_shouldReturnNil {
    id resultObject = [TrainInjector getObject:NSClassFromString(@"NonExistingClass")];
    STAssertNil(resultObject, @"non existing class initialization should return nil");
}

-(void) test_getObject_existingClass_shouldReturnInstance {
    TestResponseClass* resultObject = [TrainInjector getObject:[TestResponseClass class]];
    [self assertResultObjectIsValid:resultObject expectedClass:[TestResponseClass class]];
}

-(void) test_getObject_primitiveIvarWithIocPrefix_shouldBeSetToDefaultValue {
    TestResponseClass* resultObject = [TrainInjector getObject:[TestResponseClass class]];
    int resultIvar = resultObject->injectableIvarName(primitive);
    STAssertEquals(resultIvar, 0, @"ioc primitive should be set to 0");
}

-(void) test_getObject_ivarWithIocPrefix_shouldinjectObject {
    TestResponseClass* resultObject = [TrainInjector getObject:[TestResponseClass class]];
    id resultIvar = resultObject->injectableIvarName(shouldInjectObject);
    [self assertInnerResultObjectIsValid:resultIvar expectedClass:[InjectedClass class]];
}

-(void) test_getObject_ivarWithProtocol_shouldinjectProtocolImplementation {
    [self StubProtocolLocator:@selector(oneImplementationResult:)];
    TestResponseClass* resultObject = [TrainInjector getObject:[TestResponseClass class]];
    id resultIvar = resultObject->injectableIvarName(shouldInjectImplementation);
    [self assertInnerResultObjectIsValid:resultIvar expectedClass:[InjectedClass class]];
}

-(void) test_getObject_ivarWithProtocolArray_shouldinjectArrayOfImplementations {
    [self StubProtocolLocator:@selector(multipleImplementationsResult:)];
    TestResponseClass* resultObject = [TrainInjector getObject:[TestResponseClass class]];
    id resultIvar = resultObject->injectableIvarName(InjectedClassProtocol);
    [self assertInnerResultObjectIsValid:resultIvar expectedClass:[NSArray class]];
    STAssertEquals([resultIvar count], (NSUInteger)2, @"2 implementations in stub");
    [self assertInnerResultObjectIsValid:[resultIvar objectAtIndex:0] expectedClass:[InjectedClass class]];
    [self assertInnerResultObjectIsValid:[resultIvar objectAtIndex:1] expectedClass:[AnotherTestResponseClass class]];
}

-(void) test_getObject_ivarWithNoPrefix_shouldnotInjectObject {
    TestResponseClass* resultObject = [TrainInjector getObject:[TestResponseClass class]];
    id resultIvar = resultObject->shouldNotInjectObject;
    STAssertNil(resultIvar, @"ivar without ioc prefix should not be injected");
}


//getObjectWithProtocol

-(void) test_getObjectWithProtocol_nilProtocolImplementation_shouldReturnNil {
    [self StubProtocolLocator:@selector(nilResult:)];
    id resultObject = [TrainInjector getObjectWithProtocol:nil];
    STAssertNil(resultObject, @"non existing protocol initialization should return nil");
}

-(void) test_getObjectWithProtocol_noProtocolImplementationd_shouldReturnNil {
    [self StubProtocolLocator:@selector(noImplementationsResult:)];
    id resultObject = [TrainInjector getObjectWithProtocol:nil];
    STAssertNil(resultObject, @"non existing protocol initialization should return nil");
}

-(void) test_getObjectWithProtocol_singleProtocolImplementation_shouldReturnInstance {
    [self StubProtocolLocator:@selector(oneImplementationResult:)];
    TestResponseClass* resultObject = [TrainInjector getObjectWithProtocol:nil];
    [self assertResultObjectIsValid:resultObject expectedClass:[InjectedClass class]];
}

-(void) test_getObjectWithProtocol_multipleProtocolImplementations_shouldReturnInstanceOfFirstImplementation {
    [self StubProtocolLocator:@selector(multipleImplementationsResult:)];
    TestResponseClass* resultObject = [TrainInjector getObjectWithProtocol:nil];
    [self assertResultObjectIsValid:resultObject expectedClass:[InjectedClass class]];
}


//getAllObjectsWithProtocol

-(void) test_getAllObjectsWithProtocol_nilProtocolImplementation_shouldReturnNil {
    [self StubProtocolLocator:@selector(nilResult:)];
    id resultObject = [TrainInjector getAllObjectsWithProtocol:nil];
    STAssertNil(resultObject, @"non existing protocol initialization should return nil");
}

-(void) test_getAllObjectsWithProtocol_noProtocolImplementationd_shouldReturnNil {
    [self StubProtocolLocator:@selector(noImplementationsResult:)];
    id resultObject = [TrainInjector getAllObjectsWithProtocol:nil];
    STAssertNil(resultObject, @"non existing protocol initialization should return nil");
}

-(void) test_getAllObjectsWithProtocol_singleProtocolImplementation_shouldReturnInstance {
    [self StubProtocolLocator:@selector(oneImplementationResult:)];
    NSArray* resultObject = [TrainInjector getAllObjectsWithProtocol:nil];
    [self assertResultObjectIsValid:resultObject expectedClass:[NSArray class]];
    STAssertEquals([resultObject count], (NSUInteger)1, @"one implementation == one instance");
    TestResponseClass* innerResultObject = [resultObject objectAtIndex:0];
    [self assertInnerResultObjectIsValid:innerResultObject expectedClass:[InjectedClass class]];
}

-(void) test_getAllClassesByProtocolType_multipleProtocolImplementations_shouldReturnInstanceOfFirstImplementation {
    [self StubProtocolLocator:@selector(multipleImplementationsResult:)];
    NSArray* resultObject = [TrainInjector getAllObjectsWithProtocol:nil];
    [self assertResultObjectIsValid:resultObject expectedClass:[NSArray class]];
    STAssertEquals([resultObject count], (NSUInteger)2, @"2 implementations in stub");
    [self assertInnerResultObjectIsValid:[resultObject objectAtIndex:0] expectedClass:[InjectedClass class]];
    [self assertInnerResultObjectIsValid:[resultObject objectAtIndex:1] expectedClass:[AnotherTestResponseClass class]];
}

//asserts

-(void) assertInnerResultObjectIsValid:(id) resultObject expectedClass:(Class) clazz {
    [self assertResultObjectIsValid:resultObject expectedClass:clazz expectedretainCount:2];
}

-(void) assertResultObjectIsValid:(id) resultObject expectedClass:(Class) clazz {
    [self assertResultObjectIsValid:resultObject expectedClass:clazz expectedretainCount:1];
}

-(void) assertResultObjectIsValid:(id) resultObject expectedClass:(Class) clazz expectedretainCount:(NSUInteger) expectedRetainCount {
    STAssertNotNil(resultObject, @"object should be initialized");
    STAssertTrue([resultObject isKindOfClass:clazz], @"instance type mismatch. expeced %@ but was %@", NSStringFromClass(clazz),NSStringFromClass([resultObject class]));
    STAssertEquals([resultObject retainCount], expectedRetainCount, @"object should be returned autoreleased");
}

//ProtocolLocator stubs

+ (NSArray*) nilResult:(Protocol*) protocol {
    return nil;
}

+ (NSArray*) noImplementationsResult:(Protocol*) protocol {
    return [NSArray arrayWithObjects: nil];
}

+ (NSArray*) oneImplementationResult:(Protocol*) protocol {
    return [NSArray arrayWithObjects:[InjectedClass class], nil];
}

+ (NSArray*) multipleImplementationsResult:(Protocol*) protocol {
    return [NSArray arrayWithObjects:[InjectedClass class], [NillingClass class], [AnotherTestResponseClass class], nil];
}

- (void) StubProtocolLocator:(SEL) stub
{
    Method newMethod = class_getClassMethod([TrainInjectorTests class], stub);
    
    if (lastStub) {
        method_exchangeImplementations(lastStub, newMethod);
    }
    else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
    lastStub = class_getClassMethod([TrainInjectorTests class], stub);
}

@end
