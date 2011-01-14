#import <SenTestingKit/SenTestingKit.h>
#import "PropertyAttribute.h"
#import "Car.h"

@interface PropertyAttributeTests : SenTestCase {}
@end

@implementation PropertyAttributeTests

- (void) testEquality
{
    PropertyAttribute *attA = [PropertyAttribute attributeWithString:@"foo"];
    PropertyAttribute *attB = [PropertyAttribute attributeWithString:@"foo"];
    PropertyAttribute *attC = [PropertyAttribute attributeWithString:@"bar"];
    STAssertTrue([attA isEqual:attB], @"Attributes with equal encoded form should be equal.");
    STAssertFalse([attA isEqual:attC], @"Attributes with different encoded form should be different.");
}

#pragma mark Class Parsing

- (void) testClassParsing
{
    NSDictionary *suite = [NSDictionary dictionaryWithObjectsAndKeys:
        [Car class], @"T@\"Car\",&,Vcar",
        [Car class], @"T@\"Car<NSObject>\",&,Vcar",
        [Car class], @"T@\"Car<NSObject><Clock>\",&,Vcar",
        nil];
    for (NSString *encoding in [suite allKeys])
        STAssertEqualObjects(
            [suite objectForKey:encoding],
            [[PropertyAttribute attributeWithString:encoding] classType],
            @"Class “%@” should be parsed from “%@”.", [suite objectForKey:encoding], encoding);
}

- (void) testClassParsingOnPrimitiveTypes
{
    STAssertNil([[PropertyAttribute attributeWithString:@"Tc,D,N"] classType],
        @"Class type should be nil on primitive types.");
}

#pragma mark Protocol Parsing

- (void) testProtocolParsing
{
    PropertyAttribute *att = [PropertyAttribute attributeWithString:@"T@\"Car<NSObject><Clock>\",&,Vcar"];
    NSSet *expected = [NSSet setWithObjects:@"NSObject", @"Clock", nil];
    STAssertEqualObjects([att protocolNames], expected,
        @"Both protocol names should be found in the attribute string.");
}

- (void) testProtocolParsingOnPrimitiveTypes
{
    PropertyAttribute *att = [PropertyAttribute attributeWithString:@"Tc,D,N"];
    STAssertEquals([[att protocolNames] count], (NSUInteger) 0,
        @"There should be no protocol names detected on primitive-type properties.");
}

- (void) testProtocolParsingOnObjectTypes
{
    PropertyAttribute *att = [PropertyAttribute attributeWithString:@"T@\"Car\",&,Vcar"];
    STAssertEquals([[att protocolNames] count], (NSUInteger) 0,
        @"There should be no protocol names detected on primitive-type properties.");
}

@end
