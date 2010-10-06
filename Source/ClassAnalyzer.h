@interface ClassAnalyzer : NSObject {}

- (NSArray*) propertiesOf: (Class) classObject;
- (NSArray*) dependenciesOf: (Class) classObject;

@end
