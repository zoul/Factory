@class ClassAnalyzer;

@interface Factory : NSObject
{
    ClassAnalyzer *analyzer;
    NSMutableSet *components;
    NSMutableSet *singletons;
}

- (void) addComponent: (Class) component;
- (void) addSingleton: (id) singleton;

- (id) assemble: (Class) compType;
- (void) wire: (id) instance;

@end
