#import "AWGridView.h"
#import "AWSnake.h"
#import "AWFood.h"

@implementation AWGridView
{
    NSUInteger gridWidth;
}

- (id)initWithFrame:(CGRect)frame gridWidth:(NSUInteger)width
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        gridWidth = width;
        NSInteger rowCount = ceilf(self.bounds.size.height / width);
        NSInteger columnCount = ceilf(self.bounds.size.width / width);
        _boundary = [[AWPositionItem alloc] initWithRow:rowCount column:columnCount];
 
        // Draw grid background view
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIColor blackColor] set];
        for (NSUInteger rowOffset = gridWidth; rowOffset < self.bounds.size.height; rowOffset += gridWidth) {
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGPathMoveToPoint(pathRef, nil, 0.0, rowOffset);
            CGPathAddLineToPoint(pathRef, nil, self.bounds.size.width, rowOffset);
            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
            [path stroke];
            CGPathRelease(pathRef);
        }
        for (NSUInteger columnOffset = gridWidth; columnOffset < self.bounds.size.width; columnOffset += gridWidth) {
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGPathMoveToPoint(pathRef, nil, columnOffset, 0.0);
            CGPathAddLineToPoint(pathRef, nil, columnOffset, self.bounds.size.height);
            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:pathRef];
            [path stroke];
            CGPathRelease(pathRef);
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [self addSubview:imageView];
        UIGraphicsEndImageContext();
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

	// Draw food
	[[UIColor greenColor] set];
	AWPositionItem *foodPosition = [AWFood foodInstance].position;
	UIBezierPath *foodPath = [UIBezierPath bezierPathWithRect:CGRectMake(foodPosition.column * gridWidth, foodPosition.row * gridWidth, gridWidth, gridWidth)];
	[foodPath fill];

	// Draw snake
    [[UIColor purpleColor] set];
    for (AWPositionItem *item in [AWSnake snakeInstance].bodyItems) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(item.column * gridWidth, item.row * gridWidth, gridWidth, gridWidth)];
        [path fill];
    }
}

@end
