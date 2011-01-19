#import "Component.h"

typedef id (^ComponentInitBlock)(void);
typedef void (^ComponentSetupBlock)(id);

@interface ClassComponent : NSObject <Component> {}

@property(copy) ComponentInitBlock customInit;
@property(copy) ComponentSetupBlock customSetup;

+ (id) componentWithClass: (Class) newType;
- (id) initWithClass: (Class) newType;

@end
