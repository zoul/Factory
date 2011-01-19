#import "Component.h"
#import "Factory.h"

@interface FactoryComponent : NSObject <Component> {}

+ (id) componentWithFactory: (Factory*) f;
- (id) initWithFactory: (Factory*) f;

@end
