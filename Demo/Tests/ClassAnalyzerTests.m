#import <SenTestingKit/SenTestingKit.h>
#import "ClassAnalyzer.h"
#import "Porsche.h"
#import "Car.h"

@interface ClassAnalyzerTests : SenTestCase {}
@end

@implementation ClassAnalyzerTests

- (void) testDependencySniffing
{
    NSDictionary *deps = [ClassAnalyzer dependenciesOf:[Car class]];
    STAssertEqualObjects([deps allKeys],
        ([NSArray arrayWithObjects:@"engine", @"transmission", nil]),
        @"Detect all dependencies.");
}

- (void) testInheritedPropertySniffing
{
    NSDictionary *deps = [ClassAnalyzer dependenciesOf:[Porsche class]];
    STAssertEqualObjects([deps allKeys],
        ([NSArray arrayWithObjects:@"engine", @"type", @"transmission", nil]),
        @"Detect inherited deps.");
}

@end
