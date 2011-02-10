@interface ClassAnalyzer : NSObject {}

+ (NSDictionary*) propertiesOf: (Class) classObject;
+ (NSDictionary*) dependenciesOf: (Class) classObject;

@end
