About
-----

Factory is a very simple dependency injection container for Objective-C.
It can assemble objects graphs for you so that you don’t have to mess with
the dependency management yourself:

    [factory addComponent:[Engine class]];
    [factory addComponent:[Car class]];
    Car *car = [factory assemble:[Car class]];
    STAssertNotNil(car.engine, @"Engine automatically built in.");

For more examples see the [Tests].

[Tests]: http://github.com/zoul/Factory/tree/master/Demo/Tests/

Links
-----

* [Inversion of Control Containers][fowler] by Martin Fowler
* [Dependency Injection][hevery] by Miško Hevery
* [Singletons are Pathological Liars][liars] by Miško Hevery

[fowler]: http://martinfowler.com/articles/injection.html
[hevery]: http://misko.hevery.com/2008/11/11/clean-code-talks-dependency-injection/
[liars]: http://misko.hevery.com/2008/08/17/singletons-are-pathological-liars/