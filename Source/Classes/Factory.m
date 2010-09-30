#import "Factory.h"
#import "MARTNSObject.h"
#import "RTProperty.h"
#import "Engine.h"

@implementation Factory

- (id) init
{
    [super init];
    components = [[NSMutableSet alloc] init];
    singletons = [[NSMutableSet alloc] init];
    return self;
}

- (void) dealloc
{
    [singletons release];
    [components release];
    [super dealloc];
}

- (void) addComponent: (Class) component
{
    [components addObject:component];
}

- (void) addSingleton: (id) singleton
{
    [singletons addObject:singleton];
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
    // The factory is a special kind of dependency, too.
    if ([self isMemberOfClass:compType])
        return self;

    // Try to find a singleton first.
    for (id singleton in singletons)
        if ([singleton isMemberOfClass:compType])
            return singleton;

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
