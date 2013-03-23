#Train has evolved!

Train has grew up and it is now [AppleGuice](https://github.com/tomersh/AppleGuice).
AppleGuice is a fully featured, high performance dependency injection framework. 
It is based on Train's core feature and concept but 10x better.

Train
=====

A simple dependency injection framework for objective c, written while traveling in a train!

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

Use the service in your class. It is already initialized!


### How to install

Copy the src folder to your project directory 

-OR-

```
pod 'Train'
```

In your AppDelegate, add the following:

```objectivec
#import "AutoInjector.h"

+(void)initialize {
    [AutoInjector autoInjectIoc];
}
```
Thats its, your all set and ready to go.


### Sample project

Check it out!
