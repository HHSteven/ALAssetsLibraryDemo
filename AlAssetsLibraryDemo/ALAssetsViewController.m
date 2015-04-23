//
//  ViewController.m
//  AlAssetsLibraryDemo
//
//  Created by HeHui on 15/4/22.
//  Copyright (c) 2015年 HeHui. All rights reserved.
//

#import "ALAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetsViewController.h"

@interface ALAssetsViewController () <UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) ALAssetsLibrary *library;

@end

@implementation ALAssetsViewController

#pragma mark --- Properties ---

- (NSMutableArray *)dataArray
{
    if (_dataArray==nil) {
        _dataArray  =[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (ALAssetsLibrary *)library
{
    if (_library==nil) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 5);
    
    _tableView  = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor cyanColor];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];

    [self generateData];
    
    
   
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark --- initlization ---

- (void) generateData
{
   _library = [[ALAssetsLibrary alloc] init];
    
   _dataArray = [[NSMutableArray alloc] init];
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [_dataArray addObject:group];
            [_tableView reloadData];
        }
    
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark ---TableViewDelegate/DataSource ---

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup *group = self.dataArray[indexPath.row];
    
    NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];
    
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"我的相册";
    }
    
    UIImage *img = [UIImage imageWithCGImage:[group posterImage]];
    
    NSInteger count = [group numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%ld)",groupName,(long)count];
    
    cell.imageView.image = img;
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AssetsViewController *assetsVc = [[AssetsViewController alloc] init];
    
    ALAssetsGroup *group = self.dataArray[indexPath.row];
    assetsVc.group = group;
    [self.navigationController pushViewController:assetsVc animated:YES];
}



@end
