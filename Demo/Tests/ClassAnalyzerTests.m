#import <SenTestingKit/SenTestingKit.h>
#import "ClassAnalyzer.h"
#import "Porsche.h"
#import "Car.h"

@interface ClassAnalyzerTests : SenTestCase
{
    ClassAnalyzer *analyzer;
}
@end

@implementation ClassAnalyzerTests

- (void) setUp
{
    [super setUp];
    analyzer = [[ClassAnalyzer alloc] init];
}

- (void) tearDown
{
    [analyzer release];
    [super tearDown];
}

- (void) testDependencySniffing
{
    NSDictionary *deps = [analyzer dependenciesOf:[Car class]];
    STAssertEqualObjects([deps allKeys],
        ([NSArray arrayWithObjects:@"engine", @"transmission", nil]),
        @"Detect all dependencies.");
}

- (void) testInheritedPropertySniffing
{
    NSDictionary *deps = [analyzer dependenciesOf:[Porsche class]];
    STAssertEqualObjects([deps allKeys],
        ([NSArray arrayWithObjects:@"engine", @"type", @"transmission", nil]),
        @"Detect inherited deps.");
}

@end
