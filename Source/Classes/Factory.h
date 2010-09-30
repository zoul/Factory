@interface Factory : NSObject
{
    NSMutableSet *components;
    NSMutableSet *singletons;
}

- (void) addComponent: (Class) component;
- (void) addSingleton: (id) singleton;

- (id) assemble: (Class) compType;

@end
