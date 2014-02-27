//
//  SPTexture.m
//  Sparrow
//
//  Created by Daniel Sperl on 19.06.09.
//  Copyright 2011 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import "SPTexture.h"
#import "SPMacros.h"
#import "SPUtils.h"
#import "SPRectangle.h"
#import "SPGLTexture.h"
#import "SPSubTexture.h"
#import "SPNSExtensions.h"
#import "SPVertexData.h"
#import "SPStage.h"
#import "SparrowClass.h"

// --- class implementation ------------------------------------------------------------------------

@implementation SPTexture

- (id)init
{    
    if ([self isMemberOfClass:[SPTexture class]]) 
    {
        return [self initWithWidth:32 height:32];
    }
    
    return [super init];
}

- (id)initWithContentsOfFile:(NSString *)path
{
    return [self initWithContentsOfFile:path generateMipmaps:NO];
}

- (id)initWithContentsOfFile:(NSString *)path generateMipmaps:(BOOL)mipmaps
{
    BOOL pma = [SPTexture expectedPmaValueForFile:path];
    return [self initWithContentsOfFile:path generateMipmaps:mipmaps premultipliedAlpha:pma];
}

- (id)initWithContentsOfFile:(NSString *)path generateMipmaps:(BOOL)mipmaps
          premultipliedAlpha:(BOOL)pma
{
    NSString *fullPath = [SPUtils absolutePathToFile:path];
    
    if (!fullPath)
        [NSException raise:SP_EXC_FILE_NOT_FOUND format:@"File '%@' not found", path];
    
    NSError *error = NULL;
    NSData *data = [NSData dataWithUncompressedContentsOfFile:fullPath];
    NSDictionary *options = [SPTexture optionsForPath:path mipmaps:mipmaps pma:pma];
    
    [SPTexture checkForOpenGLError];
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfData:data
                                                               options:options error:&error];
    
    if (!info)
    {
        [NSException raise:SP_EXC_FILE_INVALID
                    format:@"Error loading texture: %@", [error localizedDescription]];
        return nil;
    }
    else if (mipmaps && (![SPUtils isPowerOfTwo:info.width] || ![SPUtils isPowerOfTwo:info.height])
             && glGetError() == GL_INVALID_OPERATION)
    {
        [NSException raise:SP_EXC_INVALID_OPERATION
                    format:@"Mipmapping is only supported for textures with sidelengths that "
                           @"are powers of two."];
    }
    
    return [[SPGLTexture alloc] initWithTextureInfo:info scale:[fullPath contentScaleFactor]
                                 premultipliedAlpha:pma];
}

- (id)initWithWidth:(float)width height:(float)height
{
    return [self initWithWidth:width height:height draw:NULL];
}

- (id)initWithWidth:(float)width height:(float)height draw:(SPTextureDrawingBlock)drawingBlock
{
    return [self initWithWidth:width height:height generateMipmaps:NO draw:drawingBlock];
}

- (id)initWithWidth:(float)width height:(float)height generateMipmaps:(BOOL)mipmaps
               draw:(SPTextureDrawingBlock)drawingBlock
{
    return [self initWithWidth:width height:height generateMipmaps:mipmaps
                         scale:Sparrow.contentScaleFactor draw:drawingBlock];
}

- (id)initWithWidth:(float)width height:(float)height generateMipmaps:(BOOL)mipmaps
              scale:(float)scale draw:(SPTextureDrawingBlock)drawingBlock
{
    // only textures with sidelengths that are powers of 2 support all OpenGL ES features.
    int legalWidth  = [SPUtils nextPowerOfTwo:width  * scale];
    int legalHeight = [SPUtils nextPowerOfTwo:height * scale];
    
    CGColorSpaceRef cgColorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    BOOL premultipliedAlpha = YES;
    int bytesPerPixel = 4;
    
    void *imageData = calloc(legalWidth * legalHeight * bytesPerPixel, 1);
    CGContextRef context = CGBitmapContextCreate(imageData, legalWidth, legalHeight, 8, 
                                                 bytesPerPixel * legalWidth, cgColorSpace, 
                                                 bitmapInfo);
    CGColorSpaceRelease(cgColorSpace);
    
    // UIKit referential is upside down - we flip it and apply the scale factor
    CGContextTranslateCTM(context, 0.0f, legalHeight);
	CGContextScaleCTM(context, scale, -scale);
   
    if (drawingBlock)
    {
        UIGraphicsPushContext(context);
        drawingBlock(context);
        UIGraphicsPopContext();        
    }
    
    SPGLTexture *glTexture = [[SPGLTexture alloc] initWithData:imageData
                                                         width:legalWidth
                                                        height:legalHeight
                                               generateMipmaps:mipmaps
                                                         scale:scale
                                            premultipliedAlpha:premultipliedAlpha];
    
    CGContextRelease(context);
    free(imageData);
    
    SPRectangle *region = [SPRectangle rectangleWithX:0 y:0 width:width height:height];
    return [[SPTexture alloc] initWithRegion:region ofTexture:glTexture];
}

- (id)initWithContentsOfImage:(UIImage *)image
{
    return [self initWithContentsOfImage:image generateMipmaps:NO];
}

- (id)initWithContentsOfImage:(UIImage *)image generateMipmaps:(BOOL)mipmaps
{
    return [self initWithWidth:image.size.width height:image.size.height generateMipmaps:mipmaps
                         scale:image.scale draw:^(CGContextRef context)
            {
                [image drawAtPoint:CGPointMake(0, 0)];
            }];
}

- (id)initWithRegion:(SPRectangle*)region ofTexture:(SPTexture*)texture
{
    return [self initWithRegion:region frame:nil ofTexture:texture];
}

- (id)initWithRegion:(SPRectangle*)region frame:(SPRectangle *)frame ofTexture:(SPTexture*)texture
{
    if (frame || region.x != 0.0f || region.width  != texture.width
              || region.y != 0.0f || region.height != texture.height)
    {
        return [[SPSubTexture alloc] initWithRegion:region frame:frame ofTexture:texture];
    }
    else
    {
        return texture;
    }
}

+ (id)textureWithContentsOfFile:(NSString *)path
{
    return [[self alloc] initWithContentsOfFile:path];
}

+ (id)textureWithContentsOfFile:(NSString*)path generateMipmaps:(BOOL)mipmaps
{
    return [[self alloc] initWithContentsOfFile:path generateMipmaps:mipmaps];
}

+ (id)textureWithRegion:(SPRectangle *)region ofTexture:(SPTexture *)texture
{
    return [[self alloc] initWithRegion:region ofTexture:texture];
}

+ (id)textureWithWidth:(float)width height:(float)height draw:(SPTextureDrawingBlock)drawingBlock
{
    return [[self alloc] initWithWidth:width height:height draw:drawingBlock];
}

+ (id)emptyTexture
{
    return [[self alloc] init];
}

- (void)adjustVertexData:(SPVertexData *)vertexData atIndex:(int)index numVertices:(int)count
{
    // override in subclasses
}

- (float)width
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'width' in subclasses."];
    return 0;
}

- (float)height
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'height' in subclasses."];
    return 0;
}

- (uint)name
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'name' in subclasses."];
    return 0;    
}

- (void)setRepeat:(BOOL)value
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'setRepeat:' in subclasses."];    
}

- (BOOL)repeat
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'repeat' in subclasses."];
    return NO;
}

- (SPTextureSmoothing)smoothing
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'smoothing' in subclasses."];
    return SPTextureSmoothingBilinear;
}

- (void)setSmoothing:(SPTextureSmoothing)filter
{
    [NSException raise:SP_EXC_ABSTRACT_METHOD format:@"Override 'setSmoothing' in subclasses."];
}

- (BOOL)premultipliedAlpha
{
    return NO;
}

- (float)scale
{
    return 1.0f;
}

- (SPRectangle *)frame
{
    return nil;
}

+ (NSDictionary *)optionsForPath:(NSString *)path mipmaps:(BOOL)mipmaps pma:(BOOL)pma
{
    // This is a workaround for a nasty inconsistency between different iOS versions :|
    
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                             @(mipmaps), GLKTextureLoaderGenerateMipmaps, nil];
    
    #if TARGET_IPHONE_SIMULATOR
    BOOL applyPma = [osVersion compare:@"5.9"] == NSOrderedDescending;
    #else
    BOOL applyPma = [osVersion compare:@"6.9"] == NSOrderedDescending;
    #endif
    
    if (applyPma)
    {
        BOOL usePma = pma && [self expectedPmaValueForFile:path];
        [options setValue:@(usePma) forKey:GLKTextureLoaderApplyPremultiplication];
    }
    
    return options;
}

+ (BOOL)isPVRFile:(NSString *)path
{
    path = [path lowercaseString];
    return [path hasSuffix:@".pvr"] || [path hasSuffix:@".pvr.gz"];
}

+ (BOOL)isPNGFile:(NSString *)path
{
    path = [path lowercaseString];
    return [path hasSuffix:@".png"] || [path hasSuffix:@".png.gz"];
}

+ (BOOL)isCompressedFile:(NSString *)path
{
    return [[path lowercaseString] hasSuffix:@".gz"];
}

+ (BOOL)expectedPmaValueForFile:(NSString *)path
{
    // PVR files typically don't use PMA.
    // PNG files in the root are preprocessed by Xcode, others are not.
    
    if ([self isPNGFile:path])
    {
        if ([path isAbsolutePath])
        {
            NSString *resourcePath = [[NSBundle appBundle] resourcePath];
            return [[path stringByDeletingLastPathComponent] isEqualToString:resourcePath];
        }
        else return [path rangeOfString:@"/"].location == NSNotFound;
    }
    else return NO;
}

+ (void)checkForOpenGLError
{
    // GLKTextureLoader always fails if 'glGetError()' is not clean -- even though the error
    // actually happened somewhere else. So we better remove any pending error.
    
    GLenum error = glGetError();
    if (error != GL_NO_ERROR)
        NSLog(@"Texture loading was initiated while OpenGL error flag was set to: 0x%x", error);
}

#pragma mark - Asynchronous Texture Loading

+ (void)loadFromFile:(NSString *)path onComplete:(SPTextureLoadingBlock)callback
{
    [self loadFromFile:path generateMipmaps:NO onComplete:callback];
}

+ (void)loadFromFile:(NSString *)path generateMipmaps:(BOOL)mipmaps
          onComplete:(SPTextureLoadingBlock)callback
{
    BOOL pma = [SPTexture expectedPmaValueForFile:path];
    [self loadFromFile:path generateMipmaps:mipmaps premultipliedAlpha:pma onComplete:callback];
}

+ (void)loadFromFile:(NSString *)path generateMipmaps:(BOOL)mipmaps premultipliedAlpha:(BOOL)pma
          onComplete:(SPTextureLoadingBlock)callback;
{
    NSString *fullPath = [SPUtils absolutePathToFile:path];
    float actualScaleFactor = [fullPath contentScaleFactor];
    
    if ([self isCompressedFile:path])
        [NSException raise:SP_EXC_INVALID_OPERATION
                    format:@"Async loading of gzip-compressed files is not supported"];
    
    if (!fullPath)
        [NSException raise:SP_EXC_FILE_NOT_FOUND format:@"File '%@' not found", path];
    
    NSDictionary *options = [SPTexture optionsForPath:path mipmaps:mipmaps pma:pma];
    GLKTextureLoader *loader = Sparrow.currentController.textureLoader;

    [self checkForOpenGLError];
    [loader textureWithContentsOfFile:fullPath options:options queue:NULL
                    completionHandler:^(GLKTextureInfo *info, NSError *outError)
     {
         SPTexture *texture = nil;
         
         if (!outError)
             texture = [[SPGLTexture alloc] initWithTextureInfo:info scale:actualScaleFactor
                                             premultipliedAlpha:pma];
         
         callback(texture, outError);
     }];
}

+ (void)loadFromURL:(NSURL *)url onComplete:(SPTextureLoadingBlock)callback
{
    [self loadFromURL:url generateMipmaps:NO onComplete:callback];
}

+ (void)loadFromURL:(NSURL *)url generateMipmaps:(BOOL)mipmaps
         onComplete:(SPTextureLoadingBlock)callback
{
    float scale = [[url path] contentScaleFactor];
    [self loadFromURL:url generateMipmaps:mipmaps scale:scale onComplete:callback];
}

+ (void)loadFromURL:(NSURL *)url generateMipmaps:(BOOL)mipmaps scale:(float)scale
         onComplete:(SPTextureLoadingBlock)callback
{
    if ([self isCompressedFile:url.path])
        [NSException raise:SP_EXC_INVALID_OPERATION
                    format:@"Async loading of gzip-compressed files is not supported"];
    
    NSDictionary *options = @{ GLKTextureLoaderGenerateMipmaps: @(mipmaps) };
    GLKTextureLoader *loader = Sparrow.currentController.textureLoader;
    
    [self checkForOpenGLError];
    [loader textureWithContentsOfURL:url options:options queue:NULL
                   completionHandler:^(GLKTextureInfo *info, NSError *outError)
     {
         SPTexture *texture = nil;
         
         if (!outError)
             texture = [[SPGLTexture alloc] initWithTextureInfo:info scale:scale];
         
         callback(texture, outError);
     }];
}

+ (void)loadFromSuffixedURL:(NSURL *)url onComplete:(SPTextureLoadingBlock)callback
{
    [self loadFromSuffixedURL:url generateMipmaps:NO onComplete:callback];
}

+ (void)loadFromSuffixedURL:(NSURL *)url generateMipmaps:(BOOL)mipmaps
                 onComplete:(SPTextureLoadingBlock)callback
{
    float scale = Sparrow.contentScaleFactor;
    NSString *suffixedString = [[url absoluteString] stringByAppendingScaleSuffixToFilename:scale];
    NSURL *suffixedURL = [NSURL URLWithString:suffixedString];
    [self loadFromURL:suffixedURL generateMipmaps:mipmaps scale:scale onComplete:callback];
}

@end
