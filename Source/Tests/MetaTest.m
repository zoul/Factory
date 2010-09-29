#import <SenTestingKit/SenTestingKit.h>

@interface MetaTest : SenTestCase {}
@end

@implementation MetaTest

- (void) testTesting
{
    STAssertTrue(1, @"Something fishy going on.");
}

@end
