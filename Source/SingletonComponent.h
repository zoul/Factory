#import "Component.h"

@interface SingletonComponent : NSObject <Component> {}

+ (id) componentWithObject: (id) anObject;
- (id) initWithObject: (id) anObject;

@end
