//
//  DailyCoverView.h
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/30/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "DailyDataCache.h"


@interface DailyCoverView : UIView
{
// Current state support
double offset;

NSTimer *timer;
double startTime;
double startOff;
double startPos;
double startSpeed;
double runDelta;
BOOL touchFlag;
CGPoint startTouch;

double lastPos;

DailyDataCache *cache;

// OpenGL ES support
GLint backingWidth;
GLint backingHeight;
EAGLContext *context;
GLuint viewRenderbuffer, viewFramebuffer;
GLuint depthRenderbuffer;
}

-(UIImage*) drawText:(NSString*) text inImage:(UIImage*)  image ;
- (void)draw;					// Draw the FlowCover view with current state
- (int)flowCoverNumberImages:(DailyCoverView *)view;
- (UIImage *)flowCover:(DailyCoverView *)view cover:(int)cover;
- (void)flowCover:(DailyCoverView *)view didSelect:(int)cover;

@end
