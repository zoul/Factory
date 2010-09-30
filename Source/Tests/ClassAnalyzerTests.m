#import <SenTestingKit/SenTestingKit.h>
#import "ClassAnalyzer.h"
#import "ClassProperty.h"
#import "Car.h"

@interface ClassAnalyzerTests : SenTestCase
{
    ClassAnalyzer *analyzer;
}
@end

@implementation ClassAnalyzerTests

- (void) setUp
{
    analyzer = [[ClassAnalyzer alloc] init];
}

- (void) tearDown
{
    [analyzer release];
}

- (void) testPropertySniffing
{
    NSArray *props = [analyzer propertiesOf:[Car class]];
    STAssertEquals([props count], (NSUInteger)2, @"Detect all properties.");
}

@end
