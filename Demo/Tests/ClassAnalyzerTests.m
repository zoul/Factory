#import <SenTestingKit/SenTestingKit.h>
#import "ClassAnalyzer.h"
#import "Porsche.h"
#import "Driver.h"
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
    STAssertEquals([[deps allKeys] count], (NSUInteger)2, @"Detect all dependencies.");
}

- (void) testInheritedPropertySniffing
{
    NSDictionary *deps = [analyzer dependenciesOf:[Porsche class]];
    STAssertEquals([[deps allKeys] count], (NSUInteger)3, @"Detect inherited deps.");
}

@end
