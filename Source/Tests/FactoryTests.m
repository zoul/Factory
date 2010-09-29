#import <SenTestingKit/SenTestingKit.h>
#import "Factory.h"
#import "Engine.h"
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
    STAssertNil(anObject, @"Factory will not assemble an unknown component.");
}

- (void) testSimpleDepsAssembly
{
    [factory addComponent:[Engine class]];
    [factory addComponent:[Car class]];
    Car *car = [factory assemble:[Car class]];
    STAssertNotNil(car, @"Factory can build a registered object.");
    STAssertNotNil(car.engine, @"Engine automatically built in.");
}

@end
