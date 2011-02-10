#import <SenTestingKit/SenTestingKit.h>
#import "ClassComponent.h"
#import "AssemblyTest.h"
#import "Factory.h"
#import "Worker.h"
#import "Driver.h"
#import "Clock.h"
#import "Car.h"

@interface FactoryTests : SenTestCase
{
    Factory *factory;
}
@end

@implementation FactoryTests

- (void) setUp
{
    [super setUp];
    factory = [[Factory alloc] init];
}

- (void) tearDown
{
    [factory release];
    [super tearDown];
}

- (void) testMemoryManagement
{
    STAssertEquals([factory retainCount], (NSUInteger) 1,
        @"Fresh Factory should have retain count == 1.");
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

#pragma mark Post-Assembly Hook

/*
    Sometimes you want to perform some init code in the component after
    its dependencies have been set, like setting up KVO notifications.
    If you have a method called “afterAssembling”, Factory will call
    that method after it fills the dependencies. For details see the
    following tests.
*/

- (void) testPostAssemblyHook
{
    [factory addComponent:[AssemblyTest class]];
    AssemblyTest *test = [factory assemble:[AssemblyTest class]];
    STAssertTrue([test assembled],
        @"Post-assembly hook should be called after the component is created.");
}

- (void) testPostAssemblyHookOnSingletons
{
    AssemblyTest *test = [[AssemblyTest alloc] init];
    [factory addSingleton:test];
    STAssertFalse([test assembled],
        @"The post-assembly hook should not be called on registered singletons.");
    [test release];
}

#pragma mark Protocol Deps

- (void) testProtocolDependencies
{
    [factory addComponent:[RealTimeClock class]];
    [factory addComponent:[Driver class]];
    Driver *driver = [factory assemble:[Driver class]];
    STAssertNotNil([driver clock], @"Should satisfy deps with protocol type.");
}

#pragma mark Property Ignoring

- (void) testPropertyIgnoring
{
    [[factory addComponent:[Car class]]
        setIgnoredProperties:[NSArray arrayWithObject:@"transmission"]];
    [factory addComponent:[Engine class]];
    [factory addComponent:[Transmission class]];
    STAssertNil([[factory assemble:[Car class]] transmission],
        @"Ignored properties should not get wired.");
}

@end
