About
=====

Factory is a very simple dependency injection container for Objective-C.
It can assemble objects graphs for you so that you don’t have to mess with
the dependency management yourself:

    [factory addComponent:[Engine class]];
    [factory addComponent:[Car class]];
    Car *car = [factory assemble:[Car class]];
    STAssertNotNil(car.engine, @"Engine automatically built in.");

For more examples see the [Tests].

[Tests]: http://github.com/zoul/Factory/tree/master/Source/Tests/