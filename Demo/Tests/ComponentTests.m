#import <SenTestingKit/SenTestingKit.h>
#import "Component.h"
#import "Driver.h"

@interface ComponentTests : SenTestCase
{
    Component *comp;
}
@end

@implementation ComponentTests

- (void) testBasicComponentCreation
{
    comp = [Component componentWithClass:[Driver class]];
    id driver = [comp newInstance];
    STAssertNotNil(driver, @"Created component should not be nil.");
    STAssertEquals([driver class], [Driver class], @"Component should be of the requested class.");
}

- (void) testCustomInit
{
    comp = [Component componentWithClass:[Driver class]];
    [comp setCustomInit:^{
        return [[Driver alloc] initWithName:@"Test"];
    }];
    id driver = [comp newInstance];
    STAssertNotNil(driver,
        @"Component created by a valid custom init should not be nil.");
    STAssertEqualObjects([driver name], @"Test",
        @"The component should be created using the custom init.");
}

- (void) testCustomSetup
{
    comp = [Component componentWithClass:[Driver class]];
    [comp setCustomSetup:^(id component) {
        [component setName:@"Test"];
    }];
    id driver = [comp newInstance];
    STAssertEqualObjects([driver name], @"Test",
        @"The custom setup block should run after creation.");
}

@end
