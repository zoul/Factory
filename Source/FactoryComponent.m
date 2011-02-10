#import "FactoryComponent.h"

@interface FactoryComponent ()
@property(assign/*sic*/) Factory *factory;
@end

@implementation FactoryComponent
@synthesize factory;

+ (id) componentWithFactory: (Factory*) f
{
    return [[[self alloc] initWithFactory:f] autorelease];
}

- (id) initWithFactory: (Factory*) f
{
    [super init];
    [self setFactory:f];
    return self;
}

#pragma mark Component

- (Class) classType
{
    return [Factory class];
}

- (id) instance
{
    return factory;
}

- (NSDictionary*) properties
{
    return nil;
}

@end
