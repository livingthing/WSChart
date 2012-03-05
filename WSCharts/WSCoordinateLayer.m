/*
 Copyright (C) 2012, pyanfield  - pyanfield@gmail.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "WSCoordinateLayer.h"
#import "WSGlobalCore.h"
#pragma mark - WSCoordinateLayer

@implementation WSCoordinateLayer

@synthesize yAxisLength = _yAxisLength,originalPoint = _originalPoint,xAxisLength = _xAxisLength;
@synthesize xMarkTitles = _xMarkTitles,xMarkDistance = _xMarkDistance,yMarkTitles = _yMarkTitlest;
@synthesize yMarksCount = _yMarksCount,show3DSubline = _show3DSubline,zeroPoint = _zeroPoin;
@synthesize sublineColor = _sublineColor, axisColor = _axisColor,sublineAngle = _sublineAngle,sublineDistance = _sublineDistance;

- (id)init
{
    self = [super init];
    if (self!= nil) {
        // set the default value of below properties.
        self.sublineColor = [UIColor grayColor];
        self.axisColor = [UIColor whiteColor];
        self.sublineDistance = 15.0;
        self.sublineAngle = M_PI/4.0;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGPoint backOriginalPoint = CreateEndPoint(self.originalPoint, self.sublineAngle, self.sublineDistance);
    CGPoint backZeroPoint = CreateEndPoint(self.zeroPoint, self.sublineAngle, self.sublineDistance);
    CGFloat markLength = self.yAxisLength/self.yMarksCount;
    
    if (self.show3DSubline) {
        // draw back y Axis
        CreateLineWithLengthFromPoint(ctx, NO, backOriginalPoint, self.yAxisLength, YES, self.sublineColor);
        // draw back x Axis
        CreateLineWithLengthFromPoint(ctx, YES, backZeroPoint, self.xAxisLength, YES, self.sublineColor);
        // draw bridge line between front and back original point
        CreateLinePointToPoint(ctx, self.zeroPoint, backZeroPoint, NO, self.sublineColor);
        CGPoint xMaxPoint = CGPointMake(self.zeroPoint.x + self.xAxisLength, self.zeroPoint.y);
        CGPoint xMaxPoint2 = CreateEndPoint(xMaxPoint, self.sublineAngle, self.sublineDistance);
        CreateLinePointToPoint(ctx, xMaxPoint, xMaxPoint2, NO, self.sublineColor);
        //draw assist line 
        for (int i=0; i<= self.yMarksCount; i++) {
            CGPoint p1 = CGPointMake(self.originalPoint.x, self.originalPoint.y-markLength*i);
            CGPoint p2 = CreateEndPoint(p1, self.sublineAngle, self.sublineDistance);
            CreateLinePointToPoint(ctx, p1, p2, NO, self.sublineColor);
            CreateLineWithLengthFromPoint(ctx, YES, p2, self.xAxisLength, YES, self.sublineColor);
            CreateLineWithLengthFromPoint(ctx, YES, p1, -6.0, NO, self.axisColor);
        }
    }else{
        // draw front y Axis
        CreateLineWithLengthFromPoint(ctx, NO, self.originalPoint, self.yAxisLength, NO, self.axisColor);
        // draw front x Axis
        CreateLineWithLengthFromPoint(ctx, YES, self.zeroPoint, self.xAxisLength, NO, self.axisColor);
        //draw y axis mark's title
        for (int i=0; i<=self.yMarksCount; i++) {
            CGPoint p1 = CGPointMake(self.originalPoint.x-6.0, self.originalPoint.y-markLength*i);
            NSString *mark = [NSString stringWithFormat:@"%.1f ",[[self.yMarkTitles objectAtIndex:i] floatValue]];
            CreateTextAtPoint(ctx, mark, p1, self.axisColor, WSLeft);
        }
        //draw x axis mark and title
        for (int i=0; i<[self.xMarkTitles count]; i++) {
            CGPoint p1 = CGPointMake(self.xMarkDistance*(i+1)+self.originalPoint.x, self.originalPoint.y);
            CGPoint p2 = CGPointMake(p1.x, p1.y+4.0);
            CreateLinePointToPoint(ctx, p1, p2, NO, self.axisColor);
            NSString *mark = [NSString stringWithFormat:[self.xMarkTitles objectAtIndex:i]];
            CreateTextAtPoint(ctx, mark, CGPointMake(p1.x-self.xMarkDistance/2, p1.y), self.axisColor, WSTop);
        }
    }
    
}

@end