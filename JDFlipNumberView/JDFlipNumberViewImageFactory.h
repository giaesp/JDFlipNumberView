//
//  JDFlipNumberViewImageFactory.h
//  FlipNumberViewExample
//
//  Created by Markus Emrich on 05.12.12.
//  Copyright (c) 2012 markusemrich. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TOP_IMAGES_IDENTIFIER @"topImages"
#define BOTTOM_IMAGES_IDENTIFIER @"bottomImages"
#define NUMBER_IMAGES_IDENTIFIER @"numberImages"
#define DEFAULT_BUNDLE_NAME @"JDFlipNumberView"

#define JD_IMG_FACTORY [JDFlipNumberViewImageFactory sharedInstance]

@interface JDFlipNumberViewImageFactory : NSObject

@property (nonatomic, strong, readonly) NSDictionary *numberImages;

@property (nonatomic, readonly) CGSize imageSize;

+ (JDFlipNumberViewImageFactory*)sharedInstance;
- (void)generateImagesFromBundleNamed:(NSString*)bundleName;
- (NSArray *)topImages:(NSString*)bundleName;
- (NSArray *)bottomImages:(NSString*)bundleName;

@end
