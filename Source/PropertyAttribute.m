#import "PropertyAttribute.h"

@interface PropertyAttribute ()
@property(retain) NSString *encodedForm;
@end

@implementation PropertyAttribute
@synthesize encodedForm;

#pragma mark Initialization

+ (id) attributeWithString: (NSString*) str
{
    return [[[self alloc] initWithString:str] autorelease];
}

- (id) initWithString: (NSString*) str
{
    [super init];
    [self setEncodedForm:str];
    return self;
}

- (void) dealloc
{
    [encodedForm release];
    [super dealloc];
}

#pragma mark Predicates

- (BOOL) isReadOnly
{
    return [encodedForm rangeOfString:@",R,"].location != NSNotFound ||
        [encodedForm hasSuffix:@",R"];
}

- (BOOL) isObject
{
    return [encodedForm hasPrefix:@"T@"];
}

- (BOOL) isPureIdType
{
    return [self isObject]
        && [self classType] == Nil
        && [self protocolNames] == nil;
}

- (BOOL) isBlock
{
    return [encodedForm hasPrefix:@"T@?"];
}

#pragma mark Properties

// T@"Car<NSObject><Clock>",&,Vcar
- (Class) classType
{
    if (![encodedForm hasPrefix:@"T@\""])
        return Nil;

    // Car<NSObject><Clock>",&,Vcar
    NSString *suffix = [encodedForm substringFromIndex:3];
    NSCharacterSet *stopChars = [NSCharacterSet characterSetWithCharactersInString:@"\"<"];
    NSRange stopRange = [suffix rangeOfCharacterFromSet:stopChars];
    NSString *className = [suffix substringToIndex:stopRange.location];
    return NSClassFromString(className);
}

// T@"Car<NSObject><Clock>",&,Vcar
- (NSSet*) protocolNames
{
    if (![encodedForm hasPrefix:@"T@\""])
        return nil;

    // Car<NSObject><Clock>",&,Vcar
    NSString *suffix = [encodedForm substringFromIndex:3];

    // Bail out early if there are no protocols in the type string
    NSString *body = [suffix substringToIndex:[suffix rangeOfString:@"\""].location];
    if ([body rangeOfString:@"<"].location == NSNotFound)
        return nil;

    NSMutableSet *results = [NSMutableSet set];
    NSMutableString *str = [NSMutableString stringWithString:body];

    // Skip to the first protocol name, <NSObject><Clock>
    NSRange firstBracket = [str rangeOfString:@"<"];
    [str deleteCharactersInRange:NSMakeRange(0, firstBracket.location)];
    while ([str hasPrefix:@"<"]) {
        // Skip over opening “<”
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
        NSRange closeBracket = [str rangeOfString:@">"];
        [results addObject:[str substringToIndex:closeBracket.location]];
        [str deleteCharactersInRange:NSMakeRange(0, closeBracket.location+1)];
    }

    return results;
}

#pragma mark Housekeeping

- (BOOL) isEqual: (id) object
{
    return ([object class] == [self class]) ?
        [encodedForm isEqualToString:[object encodedForm]] : NO;
}

- (NSUInteger) hash
{
    return [encodedForm hash];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@ 0x%x: %@>",
        [self class], self, encodedForm];
}

@end
