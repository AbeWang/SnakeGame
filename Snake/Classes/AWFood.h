#import "AWPositionItem.h"

@interface AWFood : NSObject

+ (AWFood *)foodInstance;

@property (strong, nonatomic) AWPositionItem *position;
@end
