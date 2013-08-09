//
//  JDFlipNumberViewImageFactory.m
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import "JDFlipNumberViewImageFactory.h"

static JDFlipNumberViewImageFactory *sharedInstance;

@interface JDFlipNumberViewImageFactory ()
@property (nonatomic, strong) NSMutableDictionary *numberImages;
- (void)setup;
@end

@implementation JDFlipNumberViewImageFactory

+ (JDFlipNumberViewImageFactory*)sharedInstance;
{
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    return [[self alloc] init];
}

- (id)init
{
    @synchronized(self)
    {
        if (sharedInstance != nil) {
            return sharedInstance;
        }
        
        self = [super init];
        if (self) {
            sharedInstance = self;
            _numberImages = [NSMutableDictionary dictionary];
            [self setup];
        }
        return self;
    }
}

- (void)setup;
{
    // create default images
    [self generateImagesFromBundleNamed:DEFAULT_BUNDLE_NAME];
    
    // register for memory warnings
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

+ (id)allocWithZone:(NSZone *)zone;
{
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    return [super allocWithZone:zone];
}

#pragma mark -
#pragma mark getter

- (NSArray *)topImages:(NSString*)bundleName {
    NSDictionary* numberImages = (NSDictionary*)[_numberImages objectForKey:bundleName];
    if (numberImages) {
        NSArray* tempImages = [numberImages objectForKey:TOP_IMAGES_IDENTIFIER];
        if (tempImages && tempImages.count <= 0) {
            [self generateImagesFromBundleNamed:bundleName];
        }
        return tempImages;
    } else {
        [self generateImagesFromBundleNamed:bundleName];
        return [self topImages:bundleName];
    }
    return [self topImages:DEFAULT_BUNDLE_NAME];
}

- (NSArray *)bottomImages:(NSString*)bundleName {
    NSDictionary* numberImages = (NSDictionary*)[_numberImages objectForKey:bundleName];
    if (numberImages) {
        NSArray* tempImages = [numberImages objectForKey:BOTTOM_IMAGES_IDENTIFIER];
        if (tempImages && tempImages.count <= 0) {
            [self generateImagesFromBundleNamed:bundleName];
        }
        return tempImages;
    } else {
        [self generateImagesFromBundleNamed:bundleName];
        return [self bottomImages:bundleName];
    }
    return [self topImages:DEFAULT_BUNDLE_NAME];
}

- (CGSize)imageSize
{
    NSDictionary* numberImages = (NSDictionary*)[_numberImages objectForKey:DEFAULT_BUNDLE_NAME];
    if (numberImages) {
        NSArray* tempImages = [numberImages objectForKey:TOP_IMAGES_IDENTIFIER];
        return ((UIImage*)[tempImages objectAtIndex:0]).size;
    }
    return CGSizeZero;
}

#pragma mark -
#pragma mark image generation
- (void)generateImagesFromBundleNamed:(NSString*)bundleName;
{
    // create image array
	NSMutableArray* topImages = [NSMutableArray arrayWithCapacity:10];
	NSMutableArray* bottomImages = [NSMutableArray arrayWithCapacity:10];
    NSMutableDictionary* numberTempImages = [NSMutableDictionary dictionary];
    
	// create bottom and top images
    for (NSInteger j=0; j<10; j++) {
        for (int i=0; i<2; i++) {
            NSString *imageName = [NSString stringWithFormat: @"%d.png", j];
            NSString *bundleImageName = [NSString stringWithFormat: @"%@.bundle/%@", bundleName, imageName];
            NSString *path = [[NSBundle mainBundle] pathForResource:bundleImageName ofType:nil];
			UIImage *sourceImage = [[UIImage alloc] initWithContentsOfFile:path];
			CGSize size		= CGSizeMake(sourceImage.size.width, sourceImage.size.height/2);
			CGFloat yPoint	= (i==0) ? 0 : -size.height;
			
            NSAssert(sourceImage != nil, @"Did not find image %@.png in bundle %@.bundle", imageName, bundleName);
            
            // draw half of image and create new image
			UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
			[sourceImage drawAtPoint:CGPointMake(0,yPoint)];
			UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
            
            // save image
            if (i==0) {
                [topImages addObject:image];
            } else {
                [bottomImages addObject:image];
            }
		}
	}
    [numberTempImages setValue:[NSArray arrayWithArray:topImages] forKey:TOP_IMAGES_IDENTIFIER];
    [numberTempImages setValue:[NSArray arrayWithArray:bottomImages] forKey:BOTTOM_IMAGES_IDENTIFIER];
    [_numberImages setValue:[NSDictionary dictionaryWithDictionary:numberTempImages] forKey:bundleName];
}

#pragma mark -
#pragma mark memory

// clear memory
- (void)didReceiveMemoryWarning:(NSNotification*)notification;
{
_numberImages = nil;
}

@end
