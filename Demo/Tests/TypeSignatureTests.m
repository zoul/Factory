#import <SenTestingKit/SenTestingKit.h>
#import "TypeSignature.h"
#import "Car.h"

@interface TypeSignatureTests : SenTestCase {}
@end

@implementation TypeSignatureTests

- (void) testEquality
{
    TypeSignature *sigA = [TypeSignature signatureWithString:@"foo"];
    TypeSignature *sigB = [TypeSignature signatureWithString:@"foo"];
    TypeSignature *sigC = [TypeSignature signatureWithString:@"bar"];
    STAssertTrue([sigA isEqual:sigB], @"Signatures with equal encoded form should be equal.");
    STAssertFalse([sigA isEqual:sigC], @"Signatures with different encoded form should be different.");
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
            [[TypeSignature signatureWithString:encoding] classType],
            @"Class “%@” should be parsed from “%@”.", [suite objectForKey:encoding], encoding);
}

- (void) testClassParsingOnPrimitiveTypes
{
    STAssertNil([[TypeSignature signatureWithString:@"Tc,D,N"] classType],
        @"Class type should be nil on primitive types.");
}

#pragma mark Protocol Parsing

- (void) testProtocolParsing
{
    TypeSignature *sig = [TypeSignature signatureWithString:@"T@\"Car<NSObject><Clock>\",&,Vcar"];
    NSSet *expected = [NSSet setWithObjects:@"NSObject", @"Clock", nil];
    STAssertEqualObjects([sig protocolNames], expected,
        @"Both protocol names should be found in the signature string.");
}

- (void) testProtocolParsingOnPrimitiveTypes
{
    TypeSignature *sig = [TypeSignature signatureWithString:@"Tc,D,N"];
    STAssertEquals([[sig protocolNames] count], (NSUInteger) 0,
        @"There should be no protocol names detected on primitive-type properties.");
}

- (void) testProtocolParsingOnObjectTypes
{
    TypeSignature *sig = [TypeSignature signatureWithString:@"T@\"Car\",&,Vcar"];
    STAssertEquals([[sig protocolNames] count], (NSUInteger) 0,
        @"There should be no protocol names detected on primitive-type properties.");
}

@end
