@interface PropertyAttribute : NSObject {}

@property(readonly, retain) NSString *encodedForm;
@property(readonly) BOOL isReadOnly;
@property(readonly) BOOL isObject;
@property(readonly) NSSet *protocolNames;
@property(readonly) Class classType;

+ (id) attributeWithString: (NSString*) str;
- (id) initWithString: (NSString*) str;

@end
