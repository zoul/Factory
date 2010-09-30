#import "Factory.h"
#import "MARTNSObject.h"
#import "RTProperty.h"

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

- (void) wire: (id) instance
{
    NSArray *properties = [[instance class] rt_properties];
    for (RTProperty *property in properties)
    {
        // Skip property if already connected.
        if ([instance valueForKey:[property name]] != nil)
            continue;
        Class propertyClass = [self classForEncoding:[property typeEncoding]];
        id dependency = [self assemble:propertyClass];
        [instance setValue:dependency forKey:[property name]];
    }
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
    id instance = [[[compType alloc] init] autorelease];
    [self wire:instance];
    return instance;
}

@end
