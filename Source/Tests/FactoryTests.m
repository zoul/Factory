#import <SenTestingKit/SenTestingKit.h>
#import "Factory.h"
#import "Engine.h"
#import "Worker.h"
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
    STAssertEquals(car.engine, engine, @"Filled dependency is the original instance.");
    [engine release];
}

- (void) testDependencyOnFactory
{
    [factory addComponent:[Worker class]];
    Worker *worker = [factory assemble:[Worker class]];
    STAssertNotNil(worker.factory, @"Factory found as a dependency.");
    STAssertEquals(worker.factory, factory, @"And is the original instance.");
}

@end
