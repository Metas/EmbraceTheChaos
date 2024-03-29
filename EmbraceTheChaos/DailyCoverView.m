//
//  DailyCoverView.m
//  EmbraceTheChaos
//
//  Created by NagrajNaidu on 6/30/13.
//  Copyright (c) 2013 Limning Labs. All rights reserved.
//

#import "DailyCoverView.h"
#import <QuartzCore/QuartzCore.h>
#import "DailyViewController.h"
/************************************************************************/
/*																		*/
/*	Internal Layout Constants											*/
/*																		*/
/************************************************************************/

#define D_TEXTURESIZE			256		// width and height of texture; power of 2, 256 max
#define D_MAXTILES			48		// maximum allocated 256x256 tiles in cache
#define D_VISTILES			6		// # tiles left and right of center tile visible on screen

/*
 *	Parameters to tweak layout and animation behaviors
 */

#define D_SPREADIMAGE			0.1		// spread between images (screen measured from -1 to 1)
#define D_FLANKSPREAD			0.4		// flank spread out; this is how much an image moves way from center
#define D_FRICTION			10.0	// friction
#define D_MAXSPEED			10.0	// throttle speed to this value

/************************************************************************/
/*																		*/
/*	Model Constants														*/
/*																		*/
/************************************************************************/

const GLfloat D_GVertices[] = {
	-1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
	-1.0f,  1.0f, 0.0f,
    1.0f,  1.0f, 0.0f,
};

const GLshort D_GTextures[] = {
	0, 0,
	1, 0,
	0, 1,
	1, 1,
};

/************************************************************************/
/*																		*/
/*	Internal FlowCover Object											*/
/*																		*/
/************************************************************************/

@interface D_FlowCoverRecord : NSObject
{
	GLuint	texture;
}
@property GLuint texture;
- (id)initWithTexture:(GLuint)t;
@end

@implementation D_FlowCoverRecord
@synthesize texture;

- (id)initWithTexture:(GLuint)t
{
	if (nil != (self = [super init])) {
		texture = t;
	}
	return self;
}

- (void)dealloc
{
	if (texture) {
		glDeleteTextures(1,&texture);
	}
	
}

@end


@implementation DailyCoverView



/************************************************************************/
/*																		*/
/*	OpenGL ES Support													*/
/*																		*/
/************************************************************************/

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

- (BOOL)createFrameBuffer
{
	// Create an abstract frame buffer
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    
	// Create a render buffer with color, attach to view and attach to frame buffer
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
#endif
        return NO;
    }
    
    return YES;
}

- (void)destroyFrameBuffer
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    [self destroyFrameBuffer];
    [self createFrameBuffer];
	[self draw];
}

/************************************************************************/
/*																		*/
/*	Construction/Destruction											*/
/*																		*/
/************************************************************************/

/*	internalInit
 *
 *		Handles the common initialization tasks from the initWithFrame
 *	and initWithCoder routines
 */

- (id)internalInit
{
	CAEAGLLayer *eaglLayer;
	
	eaglLayer = (CAEAGLLayer *)self.layer;
	eaglLayer.opaque = YES;
	
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if (!context || ![EAGLContext setCurrentContext:context] || ![self createFrameBuffer]) {
		
		return nil;
	}
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
	
	cache = [[DailyDataCache alloc] initWithCapacity_D:D_MAXTILES];
	offset = 0;
	return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
		self = [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    if (self = [super initWithCoder:coder]) {
		self = [self internalInit];
    }
    return self;
}

- (void)dealloc 
{
    [EAGLContext setCurrentContext:context];
    
	[self destroyFrameBuffer];
	
    
	[EAGLContext setCurrentContext:nil];
    
	
    context = nil;
	
}

- (int)numTiles
{
    return [self flowCoverNumberImages:self];
    
}
- (int)flowCoverNumberImages:(DailyCoverView *)view
{
	return 64;
    
    //return the number of topics
}

- (UIImage *)tileImage:(int)image
{
    return [self flowCover:self cover:image];
    
}

- (void)touchAtIndex:(int)index
{
    [self flowCover:self didSelect:index];
    
}

- (UIImage *)flowCover:(DailyCoverView *)view cover:(int)image
{
	switch (image % 6) {
		case 0:
		default:
            return [self drawText:@"Meditation" inImage:[UIImage imageNamed:@"a.png"] ];
			
		case 1:
            return [self drawText:@"Empowerment" inImage:[UIImage imageNamed:@"b.png"] ];
            
		case 2:
            return [self drawText:@"Leadership" inImage:[UIImage imageNamed:@"c.png"] ];
		case 3:
            return [self drawText:@"ONLY YOU" inImage:[UIImage imageNamed:@"s.png"] ];
            
		case 4:
            return [self drawText:@"HELLO" inImage:[UIImage imageNamed:@"t.png"] ];
            
		case 5:
            return [self drawText:@"WAIT" inImage:[UIImage imageNamed:@"u.png"] ];
            
	}
}


-(UIImage*) drawText:(NSString*) text 
             inImage:(UIImage*)  image 
{
    
    UIFont *font = [UIFont boldSystemFontOfSize:30];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withFont:font]; 
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)flowCover:(DailyCoverView *)view didSelect:(int)image
{
	NSLog(@"Selected Index %d",image);
    
}



/************************************************************************/
/*																		*/
/*	Tile Management														*/
/*																		*/
/************************************************************************/

static void *D_GData = NULL;

- (GLuint)imageToTexture:(UIImage *)image
{
	/*
	 *	Set up off screen drawing
	 */
	
	if (D_GData == NULL) D_GData = malloc(4 * D_TEXTURESIZE * D_TEXTURESIZE);
    //	void *data = malloc(TEXTURESIZE * TEXTURESIZE * 4);
	CGColorSpaceRef cref = CGColorSpaceCreateDeviceRGB();
	CGContextRef gc = CGBitmapContextCreate(D_GData,
                                            D_TEXTURESIZE,D_TEXTURESIZE,
                                            8,D_TEXTURESIZE*4,
                                            cref,kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(cref);
	UIGraphicsPushContext(gc);
	
	/*
	 *	Set to transparent
	 */
	
	[[UIColor colorWithWhite:0 alpha:0] setFill];
	CGRect r = CGRectMake(0, 0, D_TEXTURESIZE, D_TEXTURESIZE);
	UIRectFill(r);
	
	/*
	 *	Draw the image scaled to fit in the texture.
	 */
	
	CGSize size = image.size;
	
	if (size.width > size.height) {
		size.height = 256 * (size.height / size.width);
		size.width = 256;
	} else {
		size.width = 256 * (size.width / size.height);
		size.height = 256;
	}
	
	r.origin.x = (256 - size.width)/2;
	r.origin.y = (256 - size.height)/2;
	r.size = size;
	[image drawInRect:r];
	
	/*
	 *	Create the texture
	 */
	
	UIGraphicsPopContext();
	CGContextRelease(gc);
	
	GLuint texture = 0;
	glGenTextures(1,&texture);
	[EAGLContext setCurrentContext:context];
	glBindTexture(GL_TEXTURE_2D,texture);
	glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,D_TEXTURESIZE,D_TEXTURESIZE,0,GL_RGBA,GL_UNSIGNED_BYTE,D_GData);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
	
	free(D_GData);
	D_GData = NULL;
	
	/*
	 *	Done.
	 */
	
	return texture;
}

- (D_FlowCoverRecord *)getTileAtIndex:(int)index
{
	NSNumber *num = [NSNumber numberWithInt:index];
	D_FlowCoverRecord *fcr = [cache objectForKey_D:num] ;
	if (fcr == nil) {
		/*
		 *	Object at index doesn't exist. Create a new texture
		 */
		
		GLuint texture = [self imageToTexture:[self tileImage:index]];
		fcr = [[D_FlowCoverRecord alloc] initWithTexture:texture];
		[cache setObject_D:fcr forKey:num];
	}
	
	return fcr;
}


/************************************************************************/
/*																		*/
/*	Drawing																*/
/*																		*/
/************************************************************************/

- (void)drawTile:(int)index atOffset:(double)off
{
	D_FlowCoverRecord *fcr = [self getTileAtIndex:index];
	GLfloat m[16];
	memset(m,0,sizeof(m));
	m[10] = 1;
	m[15] = 1;
	m[0] = 1;
	m[5] = 1;
	double trans = off * D_SPREADIMAGE;
	
	double f = off * D_FLANKSPREAD;
	if (f < -D_FLANKSPREAD) {
		f = -D_FLANKSPREAD;
	} else if (f > D_FLANKSPREAD) {
		f = D_FLANKSPREAD;
	}
	m[3] = -f;
	m[0] = 1-fabs(f);
	double sc = 0.45 * (1 - fabs(f));
	trans += f * 1;
	
	glPushMatrix();
	glBindTexture(GL_TEXTURE_2D,fcr.texture);
	glTranslatef(trans, 0, 0);
	glScalef(sc,sc,1.0);
	glMultMatrixf(m);
	glDrawArrays(GL_TRIANGLE_STRIP,0,4);
	
	// reflect
	glTranslatef(0,-2,0);
	glScalef(1,-1,1);
	glColor4f(0.5,0.5,0.5,0.5);
	glDrawArrays(GL_TRIANGLE_STRIP,0,4);
	glColor4f(1,1,1,1);
	
	glPopMatrix();
}

- (void)draw
{
	/*
	 *	Get the current aspect ratio and initialize the viewport
	 */
	
	double aspect = ((double)backingWidth)/backingHeight;
	
	glViewport(0,0,backingWidth,backingHeight);
	glDisable(GL_DEPTH_TEST);				// using painters algorithm
	
	glClearColor(0,0,0,0);
	glVertexPointer(3,GL_FLOAT,0,D_GVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_SHORT, 0, D_GTextures);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glEnable(GL_TEXTURE_2D);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	/*
	 *	Setup for clear
	 */
	
	[EAGLContext setCurrentContext:context];
	
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glClear(GL_COLOR_BUFFER_BIT);
	
	/*
	 *	Set up the basic coordinate system
	 */
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glScalef(1,aspect,1);
    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	/*
	 *	Change from Alesandro Tagliati <alessandro.tagliati@gmail.com>:
	 *	We don't need to draw all the tiles, just the visible ones. We guess
	 *	there are 6 tiles visible; that can be adjusted by altering the 
	 *	constant
	 */
	
	int i,len = [self numTiles];
	int mid = (int)floor(offset + 0.5);
	int iStartPos = mid - D_VISTILES;
	if (iStartPos<0) {
		iStartPos=0;
	}
	for (i = iStartPos; i < mid; ++i) {
		[self drawTile:i atOffset:i-offset];
	}
	
	int iEndPos=mid + D_VISTILES;
	if (iEndPos >= len) {
		iEndPos = len-1;
	}
	for (i = iEndPos; i >= mid; --i) {
		[self drawTile:i atOffset:i-offset];
	}
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

/************************************************************************/
/*																		*/
/*	Animation															*/
/*																		*/
/************************************************************************/

- (void)updateAnimationAtTime:(double)elapsed
{
	int max = [self numTiles] - 1;
	
	if (elapsed > runDelta) elapsed = runDelta;
	double delta = fabs(startSpeed) * elapsed - D_FRICTION * elapsed * elapsed / 2;
	if (startSpeed < 0) delta = -delta;
	offset = startOff + delta;
	
	if (offset > max) offset = max;
	if (offset < 0) offset = 0;
	
	[self draw];
}

- (void)endAnimation
{
	if (timer) {
		int max = [self numTiles] - 1;
		offset = floor(offset + 0.5);
		if (offset > max) offset = max;
		if (offset < 0) offset = 0;
		[self draw];
		
		[timer invalidate];
		timer = nil;
	}
}

- (void)driveAnimation
{
	double elapsed = CACurrentMediaTime() - startTime;
	if (elapsed >= runDelta) {
		[self endAnimation];
	} else {
		[self updateAnimationAtTime:elapsed];
	}
}

- (void)startAnimation:(double)speed
{
	if (timer) [self endAnimation];
	
	/*
	 *	Adjust speed to make this land on an even location
	 */
	
	NSLog(@"speed: %lf",speed);
	double delta = speed * speed / (D_FRICTION * 2);
	if (speed < 0) delta = -delta;
	double nearest = startOff + delta;
	nearest = floor(nearest + 0.5);
	startSpeed = sqrt(fabs(nearest - startOff) * D_FRICTION * 2);
	if (nearest < startOff) startSpeed = -startSpeed;
	
	runDelta = fabs(startSpeed / D_FRICTION);
	startTime = CACurrentMediaTime();
	
	NSLog(@"startSpeed: %lf",startSpeed);
	NSLog(@"runDelta: %lf",runDelta);
	timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                             target:self
                                           selector:@selector(driveAnimation)
                                           userInfo:nil
                                            repeats:YES];
}


/************************************************************************/
/*																		*/
/*	Touch																*/
/*																		*/
/************************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
	startPos = (where.x / r.size.width) * 10 - 5;
	startOff = offset;
	
	touchFlag = YES;
	startTouch = where;
	
	startTime = CACurrentMediaTime();
	lastPos = startPos;
	
	[self endAnimation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
	double pos = (where.x / r.size.width) * 10 - 5;
	
	if (touchFlag == YES) {
		// Touched location; only accept on touching inner 256x256 area
		r.origin.x += (r.size.width - 256)/2;
		r.origin.y += (r.size.height - 256)/2;
		r.size.width = 256;
		r.size.height = 256;
		
		if (CGRectContainsPoint(r, where)) {
			[self touchAtIndex:(int)floor(offset + 0.01)];	// make sure .99 is 1
		}
	} else {
		// Start animation to nearest
		startOff += (startPos - pos);
		offset = startOff;
        
		double time = CACurrentMediaTime();
		double speed = (lastPos - pos)/(time - startTime);
		if (speed > D_MAXSPEED) speed = D_MAXSPEED;
		if (speed < -D_MAXSPEED) speed = -D_MAXSPEED;
		
		[self startAnimation:speed];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect r = self.bounds;
	UITouch *t = [touches anyObject];
	CGPoint where = [t locationInView:self];
	double pos = (where.x / r.size.width) * 10 - 5;
    
	if (touchFlag) {
		// determine if the user is dragging or not
		int dx = fabs(where.x - startTouch.x);
		int dy = fabs(where.y - startTouch.y);
		if ((dx < 3) && (dy < 3)) return;
		touchFlag = NO;
	}
	
	int max = [self numTiles]-1;
	
	offset = startOff + (startPos - pos);
	if (offset > max) offset = max;
	if (offset < 0) offset = 0;
	[self draw];
	
	double time = CACurrentMediaTime();
	if (time - startTime > 0.2) {
		startTime = time;
		lastPos = pos;
	}
}



@end
