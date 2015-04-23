//
//  ImageCollectionViewCell.m
//  AlAssetsLibraryDemo
//
//  Created by HeHui on 15/4/22.
//  Copyright (c) 2015年 HeHui. All rights reserved.
//

#import "ImageCollectionViewCell.h"



@implementation ImageCollectionViewCell
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        CGFloat w = frame.size.width;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, w)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, frame.size.width, 30)];
        [self addSubview:_nameLabel];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:12];
       
        
    }
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    
    _imageView.image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    _nameLabel.text = [rep filename];
}



@end
