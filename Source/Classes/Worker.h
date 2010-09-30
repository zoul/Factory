#import "Factory.h"

@interface Worker : NSObject
{
    Factory *factory;
}

@property(retain) Factory *factory;

@end
