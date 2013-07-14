#import "AWPositionItem.h"

typedef enum {
    AWSnakeDirectionUp = 0,
    AWSnakeDirectionDown,
    AWSnakeDirectionRight,
    AWSnakeDirectionLeft
}AWSnakeDirection;

typedef enum {
	AWSnakeErrorBodyCollision = -1
}AWSnakeError;

extern NSString *const kSnakeErrorDomain;

@interface AWSnake : NSObject

+ (AWSnake *)snakeInstance;
- (void)reset;
- (void)moveWithDirection:(AWSnakeDirection)inDirection completionHandler:(void (^)(NSError*))inHandler;

@property (strong, nonatomic) AWPositionItem *boundary;
@property (readonly, nonatomic) NSMutableArray *bodyItems;
@property (readonly, nonatomic) AWSnakeDirection currentDirection;
@end
