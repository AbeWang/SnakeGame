#import "AWGameGridView.h"
#import "AWSnake.h"
#import "AWFood.h"

@implementation AWGameGridView
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
 
        // Draw grid image view
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
	[[UIColor redColor] set];
	AWPositionItem *foodPosition = [AWFood foodInstance].position;
    UIBezierPath *foodPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(foodPosition.column * gridWidth, foodPosition.row * gridWidth, gridWidth, gridWidth)];
	[foodPath fill];
	// Draw snake body
    [[UIColor greenColor] set];
    for (AWPositionItem *item in [AWSnake snakeInstance].bodyItems) {
        UIBezierPath *bodyPath = [UIBezierPath bezierPathWithRect:CGRectMake(item.column * gridWidth, item.row * gridWidth, gridWidth, gridWidth)];
        [bodyPath fill];
    }
}

@end
