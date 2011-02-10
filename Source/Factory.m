#import "Factory.h"
#import "TypeSignature.h"
#import "SingletonComponent.h"
#import "FactoryComponent.h"
#import "ClassComponent.h"
#import "Component.h"

@interface Factory ()
@property(retain) NSMutableSet *components;
@end

@implementation Factory
@synthesize components;

#pragma mark Initialization

- (id) init
{
    [super init];
    components = [[NSMutableArray alloc] init];
    [components addObject:[FactoryComponent componentWithFactory:self]];
    return self;
}

- (void) dealloc
{
    [components release];
    [super dealloc];
}

#pragma mark Component Management

- (ClassComponent*) addComponent: (Class) componentType
{
    id component = [ClassComponent componentWithClass:componentType];
    [components addObject:component];
    return component;
}

- (void) addSingleton: (id) singleton
{
    [components addObject:[SingletonComponent componentWithObject:singleton]];
}

#pragma mark Dependency Matching

- (BOOL) canWireSignature: (TypeSignature*) sig
{
    return [sig isObject]
       && ![sig isReadOnly]
       && ![sig isBlock]
       && ![sig isPureIdType];
}

- (id<Component>) componentForSignature: (TypeSignature*) sig
{
    for (id<Component> candidate in components)
        if ([sig matchesClass:[candidate classType]])
            return candidate;
    return nil;
}

#pragma mark Wiring, Assembling

- (id) wire: (id<Component>) component
{
    // Get an instance of the component
    id instance = [component instance];
    NSDictionary *deps = [component properties];
    
    // Wire component dependencies
    for (NSString *name in [deps allKeys]) {
        TypeSignature *signature = [deps objectForKey:name];
        if ([self canWireSignature:signature]) {
            id dependency = [self wire:[self componentForSignature:signature]];
            [instance setValue:dependency forKey:name];
        }
    }

    // Call the post-assembly hook if component supports it
    SEL postAssemblyHook = @selector(afterAssembling);
    if ([instance respondsToSelector:postAssemblyHook])
        [instance performSelector:postAssemblyHook];
    
    return instance;
}

- (id) assemble: (Class) compType
{
    for (id<Component> candidate in components)
        if ([candidate classType] == compType)
            return [self wire:candidate];
    return nil;
}

@end
