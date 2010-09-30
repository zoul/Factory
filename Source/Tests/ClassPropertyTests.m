#import <SenTestingKit/SenTestingKit.h>
#import "ClassProperty.h"
#import "Car.h"

@interface ClassPropertyTests : SenTestCase {}
@end

@implementation ClassPropertyTests

- (void) testAttributeParsing
{
    ClassProperty *p = [[ClassProperty alloc]
        initWithName:@"Engine" attributes:@"T@\"Engine\",&,Vengine"];
    STAssertEqualObjects(p.className, [Engine class], @"Correctly parse property class.");
    [p release];
}

@end
