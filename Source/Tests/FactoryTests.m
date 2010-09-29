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

- (void) testSimpleWiring
{
    [factory addComponent:[Engine class]];
    Car *car = [factory getComponent:[Car class]];
    STAssertNotNil(car, @"Factory can build a car.");
    STAssertNotNil(car.engine, @"Engine automatically built in.");
}

@end
