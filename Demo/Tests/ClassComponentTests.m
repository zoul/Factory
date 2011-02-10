#import <SenTestingKit/SenTestingKit.h>
#import "ClassComponent.h"
#import "Driver.h"

@interface ClassComponentTests : SenTestCase
{
    ClassComponent *comp;
}
@end

@implementation ClassComponentTests

- (void) testBasicComponentCreation
{
    comp = [ClassComponent componentWithClass:[Driver class]];
    id driver = [comp instance];
    STAssertNotNil(driver, @"Created component should not be nil.");
    STAssertEquals([driver class], [Driver class], @"Component should be of the requested class.");
}

- (void) testCustomInit
{
    comp = [ClassComponent componentWithClass:[Driver class]];
    [comp setCustomInit:^{
        return [[Driver alloc] initWithName:@"Test"];
    }];
    id driver = [comp instance];
    STAssertNotNil(driver,
        @"Component created by a valid custom init should not be nil.");
    STAssertEqualObjects([driver name], @"Test",
        @"The component should be created using the custom init.");
}

- (void) testCustomSetup
{
    comp = [ClassComponent componentWithClass:[Driver class]];
    [comp setCustomSetup:^(id component) {
        [component setName:@"Test"];
    }];
    id driver = [comp instance];
    STAssertEqualObjects([driver name], @"Test",
        @"The custom setup block should run after creation.");
}

- (void) testPropertyIgnoring
{
    comp = [ClassComponent componentWithClass:[Car class]];
    [comp setIgnoredProperties:[NSArray arrayWithObject:@"transmission"]];
    STAssertFalse(!![[comp properties] objectForKey:@"transmission"],
        @"Ignored properties should be filtered out of the property list.");
}

@end
