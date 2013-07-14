#import "AWFood.h"

static AWFood *instance = nil;

@implementation AWFood

+ (AWFood *)foodInstance
{
	if (!instance) {
		instance = [[AWFood alloc] init];
	}
	return instance;
}

- (id)init
{
	self = [super init];
	if (self) {
		_position = [[AWPositionItem alloc] initWithRow:0 column:0];
	}
	return self;
}

@end
