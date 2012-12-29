Train
=====

a simple dependency injection framework for objective c, written while traveling in a train!

## Usage
Add an Ivar to your Class file with the IOC prefix and the service you want to inject.
There are three injection flavours:

```objectivec
// .m
@interface MyClass () {
    MyService* _ioc_MyService; //will create an instance of MyService.
    id<MyProtocol> _ioc_MyProtocol //will create an instance of the first class conforming to MyProtocol.
    NSArray* _ioc_MyProtocol //will return an array containing instances of all classes conforming to MyProtocol
}
    
```

Use the service in your class.

```objectivec
@implementation MyClass

-(NSString*) foo {
    return [_ioc_MyService goo];
}

@end
```

When an instance of MyClass is needed, initialize it with:

```objectivec
MyClass* myClass = [ObjectInstancializationService instantialize:[Myclass class]];
```

### It is recursive!

MyClass will be initialized with the default constractor [MyClass alloc] init]. Every Ivar in it with the IOC prefix will be initialized recursively!

### IOC prefix

The IOC prefix can be set in IOCDefines.h

### Sample project

Check it out!

Thats it, You are ready to go.
