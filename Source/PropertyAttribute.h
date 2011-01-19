@interface PropertyAttribute : NSObject {}

@property(readonly, retain) NSString *encodedForm;
@property(readonly) NSSet *protocolNames;
@property(readonly) Class classType;

@property(readonly) BOOL isReadOnly;
@property(readonly) BOOL isObject;
@property(readonly) BOOL isBlock;
@property(readonly) BOOL isPureIdType;

+ (id) attributeWithString: (NSString*) str;
- (id) initWithString: (NSString*) str;

@end
