@interface Factory : NSObject
{
    NSMutableSet *components;
}

- (void) addComponent: (id) component;
- (id) assemble: (Class) compType;

@end
