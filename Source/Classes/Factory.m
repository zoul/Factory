#import "Factory.h"
#import "MARTNSObject.h"
#import "RTProperty.h"
#import "Engine.h"

@implementation Factory

- (id) init
{
    [super init];
    components = [[NSMutableSet alloc] init];
    return self;
}

- (void) dealloc
{
    [components release];
    [super dealloc];
}

- (void) addComponent: (id) component
{
    [components addObject:component];
}

- (id) classForEncoding: (NSString*) encoding
{
    if (![encoding hasPrefix:@"@"])
        return nil;
    NSString *suffix = [encoding substringFromIndex:2];
    NSString *className = [suffix substringToIndex:[suffix length]-1];
    return NSClassFromString(className);
}

- (id) assemble: (Class) compType
{
    // Do not assemble unknown components.
    if (![components containsObject:compType])
        return nil;

    // Create component.
    id instance = [[compType alloc] init];

    // Connect dependencies.
    for (RTProperty *property in [compType rt_properties]) {
        Class propertyClass = [self classForEncoding:[property typeEncoding]];
        id dependency = [self assemble:propertyClass];
        [instance setValue:dependency forKey:[property name]];
    }

    return [instance autorelease];
}

@end
