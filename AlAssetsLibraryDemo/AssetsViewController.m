//
//  AssetsViewController.m
//  AlAssetsLibraryDemo
//
//  Created by HeHui on 15/4/22.
//  Copyright (c) 2015年 HeHui. All rights reserved.
//

#import "AssetsViewController.h"
#import "ImageCollectionViewCell.h"

static NSString *collectionCellID = @"collectionCellID";

@interface AssetsViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    CGRect _cellRect;
    
    UIBarButtonItem *_leftItem;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation AssetsViewController

#pragma mark --- Properties ---

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:[_group numberOfAssets]];
    }
    return _dataArray;
}

- (void)setGroup:(ALAssetsGroup *)group
{
    _group = nil;
    _group = group;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftItem  = self.navigationItem.leftBarButtonItem;
    
    
    self.view.backgroundColor  = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (self.view.frame.size.width - 40)/4.0;
    
    CGSize size = CGSizeMake(w, w+30);

    layout.itemSize = size;
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 5);
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    [self generateData];
    
    // Do any additional setup after loading the view.
}

- (void)generateData
{
    [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            
            [self.dataArray addObject:result];
        }
        
        if (index == [_group numberOfAssets] - 1) {
            [_collectionView reloadData];
        }
        
    }];
}


#pragma mark --- CollectionViewDelegate/DataSource/FlowLayoutDelegate ---

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    ALAsset *asset = self.dataArray[indexPath.row];
    
    
    cell.asset = asset;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
//    NSLog(@"cell.frame = %@",NSStringFromCGRect(cell.frame));
    
    CGRect rect = cell.frame;
    _cellRect = rect;
    
    ALAsset *asset = self.dataArray[indexPath.row];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 65)];
    view.backgroundColor = [UIColor orangeColor];
    view.alpha = 0;
    [self.view addSubview:view];
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_cellRect];
    [view addSubview:imageView];

    view.tag = 100;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.tag = 200;
    UIImage *img = [UIImage imageWithCGImage:[representation fullResolutionImage]];
    
//    UIImage *showImg = [self changeSizeOfImg:img andWidth:imageView.frame.size.width andHeight:imageView.frame.size.height];
    
    imageView.image = img;
    
    [UIView animateWithDuration:0.3f animations:^{
        view.alpha = 1;
        imageView.frame = view.bounds;
    } completion:^(BOOL finished) {
        
    }];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 25);
    [button setTitle:@"BACK" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItem:leftBarBtnItem animated:YES];
    
}

- (void)buttonPressed:(UIButton *)btn
{
//    [btn removeFromSuperview];
    
    UIView *view = [self.view viewWithTag:100];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:200];
    
    [UIView animateWithDuration:0.3f animations:^{

        imgView.frame = _cellRect;
        imgView.alpha = 0.4;
    } completion:^(BOOL finished) {

        [self.navigationItem setLeftBarButtonItem:_leftItem animated:YES];
        
        [view removeFromSuperview];
        

    }];
    

}



- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
    
}



/*
- (UIImage*)changeSizeOfImgKeepScale:(UIImage*)sourceImg andMaxLength:(CGFloat)maxWidth andMaxHeight:(CGFloat)maxheight
{
    float width=sourceImg.size.width;
    float height=sourceImg.size.height;
    
    if (width<=maxWidth && height<=maxheight) {
        return sourceImg;
    }
    
    if (width/height<=maxWidth/maxheight) {
        return [self changeSizeOfImg:sourceImg andWidth:maxheight/height*width andHeight:maxheight];
    }
    if (width/height>=maxWidth/maxheight) {
        return [self changeSizeOfImg:sourceImg andWidth:maxWidth andHeight:maxWidth/width*height];
    }
    return nil;
}

- (UIImage*)changeSizeOfImg:(UIImage*)sourceImg andWidth:(CGFloat)width andHeight:(CGFloat)height
{
    CGSize size=CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), sourceImg.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}
*/
@end
