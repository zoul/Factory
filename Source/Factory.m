#import "Factory.h"
#import "ClassAnalyzer.h"
#import "PropertyAttribute.h"
#import "SingletonComponent.h"
#import "ClassComponent.h"
#import <objc/runtime.h>

@interface Factory ()
@property(retain) ClassAnalyzer *analyzer;
@property(retain) NSMutableSet *components;
@end

@implementation Factory
@synthesize analyzer, components;

#pragma mark Initialization

- (id) init
{
    [super init];
    analyzer = [[ClassAnalyzer alloc] init];
    components = [[NSMutableArray alloc] init];
    // TODO: This is a circular reference, the Factory will never get released
    [components addObject:[SingletonComponent componentWithObject:self]];
    return self;
}

- (void) dealloc
{
    [analyzer release];
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

- (BOOL) canWireAttribute: (PropertyAttribute*) att
{
    return [att isObject]
       && ![att isReadOnly]
       && ![att isBlock]
       && ![att isPureIdType];
}

- (BOOL) matchAttribute: (PropertyAttribute*) att withClass: (Class) someClass
{
    // Check class name
    if ([att classType] && [att classType] != someClass)
        return NO;
    // Chech implemented protocols
    for (NSString *protoName in [att protocolNames])
        if (!class_conformsToProtocol(someClass, NSProtocolFromString(protoName)))
            return NO;
    return YES;
}

- (id<Component>) componentForAttribute: (PropertyAttribute*) attribute
{
    for (id<Component> candidate in components)
        if ([self matchAttribute:attribute withClass:[candidate classType]])
            return candidate;
    return nil;
}

#pragma mark Wiring, Assembling

- (id) wire: (id) instance
{
    // Fill dependencies
    NSDictionary *properties = [analyzer propertiesOf:[instance class]];
    [properties enumerateKeysAndObjectsUsingBlock:^(id name, id attributes, BOOL *stop)
    {
        // Skip early if we cannot wire this property
        if (![self canWireAttribute:attributes])
            return;
        // Skip if property already set
        if ([instance valueForKey:name] != nil)
            return;
        // TODO: We’re wiring the singletons here, too
        id dependency = [self wire:[[self componentForAttribute:attributes] instance]];
        [instance setValue:dependency forKey:name];
    }];

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
            return [self wire:[candidate instance]];
    return nil;
}

@end
