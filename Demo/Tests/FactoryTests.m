#import <SenTestingKit/SenTestingKit.h>
#import "Factory.h"
#import "Worker.h"
#import "Driver.h"
#import "Car.h"

@interface FactoryTests : SenTestCase
{
    Factory *factory;
}
@end

@implementation FactoryTests

- (void) setUp
{
    factory = [[Factory alloc] init];
}

- (void) tearDown
{
    [factory release];
}

#pragma mark Assembling New Objects

- (void) testUnknownClassAssembly
{
    id anObject = [factory assemble:[NSObject class]];
    STAssertNil(anObject, @"Will not assemble an unknown component.");
}

- (void) testSimpleDepsAssembly
{
    [factory addComponent:[Engine class]];
    [factory addComponent:[Car class]];
    Car *car = [factory assemble:[Car class]];
    STAssertNotNil(car, @"Can build a registered object.");
    STAssertNotNil(car.engine, @"Engine automatically built in.");
}

- (void) testSingletonAssembly
{
    Engine *engine = [[Engine alloc] init];
    [factory addSingleton:engine];
    Engine *assembled = [factory assemble:[Engine class]];
    STAssertNotNil(assembled, @"Can assemble component added as singleton.");
    STAssertEquals(assembled, engine, @"Returns the registered instance.");
    [engine release];
}

- (void) testSingletonsAsDependencies
{
    Engine *engine = [[Engine alloc] init];
    [factory addSingleton:engine];
    [factory addComponent:[Car class]];
    Car *car = [factory assemble:[Car class]];
    STAssertNotNil(car.engine, @"Can find singleton dependency.");
    STAssertEquals(car.engine, engine, @"And is the original instance.");
    [engine release];
}

- (void) testDependencyOnFactory
{
    [factory addComponent:[Worker class]];
    Worker *worker = [factory assemble:[Worker class]];
    STAssertNotNil(worker.factory, @"Factory found as a dependency.");
    STAssertEquals(worker.factory, factory, @"And is the original instance.");
}

- (void) testReadOnlyProperties
{
    [factory addComponent:[Car class]];
    [factory addComponent:[Driver class]];
    STAssertNoThrow([factory assemble:[Driver class]],
        @"Does not attempt to wire read-only properties.");
}

#pragma mark Wiring Existing Objects

- (void) testTrivialWiring
{
    Car *car = [[Car alloc] init];
    STAssertNoThrow([factory wire:car], @"Can wire unknown objects.");
}

- (void) testBasicWiring
{
    [factory addComponent:[Engine class]];
    Car *car = [[Car alloc] init];
    [factory wire:car];
    STAssertNotNil(car.engine, @"Wired the engine property.");
}

- (void) testPropertyOverwriting
{
    [factory addComponent:[Engine class]];
    Car *car = [[Car alloc] init];
    [car setTransmission:[[[Transmission alloc] init] autorelease]];
    [factory wire:car];
    STAssertNotNil(car.transmission, @"Wiring a car will not erase existing deps.");
}

@end
