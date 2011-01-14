#import "Factory.h"
#import "ClassAnalyzer.h"
#import "PropertyAttribute.h"

@interface Factory ()
@property(retain) ClassAnalyzer *analyzer;
@property(retain) NSMutableDictionary *components;
@property(retain) NSMutableSet *singletons;
@end

@implementation Factory
@synthesize analyzer, components, singletons;

- (id) init
{
    [super init];
    analyzer = [[ClassAnalyzer alloc] init];
    components = [[NSMutableDictionary alloc] init];
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

- (Component*) addComponent: (Class) componentType
{
    id component = [Component componentWithClass:componentType];
    [components setObject:component forKey:componentType];
    return component;
}

- (void) addSingleton: (id) singleton
{
    [singletons addObject:singleton];
}

- (Class) componentClassForAttribute: (PropertyAttribute*) attribute
{
    for (NSObject *s in singletons)
        if ([attribute isCompatibleWithClass:[s class]])
            return [s class];
    for (Component *c in [components allValues])
        if ([attribute isCompatibleWithClass:[c type]])
            return [c type];
    if ([attribute isCompatibleWithClass:[self class]])
        return [self class];
    return Nil;
}

- (void) wire: (id) instance
{
    // Fill dependencies
    NSDictionary *properties = [analyzer propertiesOf:[instance class]];
    [properties enumerateKeysAndObjectsUsingBlock:^(id name, id attributes, BOOL *stop)
    {
        // Skip primitive properties
        if (![attributes isObject])
            return;
        // Skip RO properties
        if ([attributes isReadOnly])
            return;
        // Skip property if already connected
        if ([instance valueForKey:name] != nil)
            return;
        id dependency = [self assemble:[self componentClassForAttribute:attributes]];
        [instance setValue:dependency forKey:name];
    }];

    // Call the post-assembly hook if component supports it
    SEL postAssemblyHook = @selector(afterAssembling);
    if ([instance respondsToSelector:postAssemblyHook])
        [instance performSelector:postAssemblyHook];
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

    // Create and wire new component instance.
    // Will return nil for unknown components.
    id instance = [[components objectForKey:compType] newInstance];
    [self wire:instance];
    return instance;
}

@end
