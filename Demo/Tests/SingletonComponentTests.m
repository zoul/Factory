#import <SenTestingKit/SenTestingKit.h>
#import "SingletonComponent.h"

@interface SingletonComponentTests : SenTestCase {}
@end

@implementation SingletonComponentTests

- (void) testEquality
{
    id testInstance = @"foo";
    SingletonComponent *compA = [SingletonComponent componentWithObject:testInstance];
    SingletonComponent *compB = [SingletonComponent componentWithObject:testInstance];
    STAssertTrue([compA isEqual:compB],
        @"Singleton components wrapping equal instances should be equal.");
    STAssertEquals([compA hash], [compB hash],
        @"Singleton components wrapping equal instances should have the same hash.");
}

@end
