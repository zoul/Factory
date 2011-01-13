#import "Factory.h"
#import "ClassAnalyzer.h"
#import "ClassProperty.h"

@interface Factory ()
@property(retain) ClassAnalyzer *analyzer;
@property(retain) NSMutableSet *components;
@property(retain) NSMutableSet *singletons;
@end

@implementation Factory
@synthesize analyzer, components, singletons;

- (id) init
{
    [super init];
    analyzer = [[ClassAnalyzer alloc] init];
    components = [[NSMutableSet alloc] init];
    singletons = [[NSMutableSet alloc] init];
    return self;
}

- (void) dealloc
{
    [analyzer release];
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

- (void) wire: (id) instance
{
    NSArray *properties = [analyzer propertiesOf:[instance class]];
    for (ClassProperty *property in properties)
    {
        // Skip RO properties.
        if ([property readOnly])
            continue;
        // Skip property if already connected.
        if ([instance valueForKey:[property name]] != nil)
            continue;
        id dependency = [self assemble:[property classType]];
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
