typedef id (^ComponentInitBlock)(void);
typedef void (^ComponentSetupBlock)(id);

@interface Component : NSObject {}

@property(readonly, retain) Class type;
@property(copy) ComponentInitBlock customInit;
@property(copy) ComponentSetupBlock customSetup;

+ (id) componentWithClass: (Class) newType;
- (id) initWithClass: (Class) newType;
- (id) newInstance;

@end
