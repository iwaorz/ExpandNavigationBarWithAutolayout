//
//  SAPViewController.m
//  ExpandNavigationBarSample
//
//  Created by Iwao SUZUKI on 2015/09/26.
//  Copyright © 2015年 Iwao SUZUKI. All rights reserved.
//

#import "SAPViewController.h"
#import "UIImage+ImageEffects.h"

@interface SAPViewController ()

@property (weak) IBOutlet UIScrollView *scrollView;
@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UIImageView *blurImageView;
@property (weak) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak) IBOutlet NSLayoutConstraint *imageViewBottomConstraint;

@end

@implementation SAPViewController {
    CGFloat initImageViewHeight;
    CGFloat initImageViewBottomConstant;
    CGFloat imageViewContentOffsetHeight;
    CGFloat topBarHeight;
}

const CGFloat kBlurFadeInFactor = 0.01f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Expand
    initImageViewBottomConstant = _imageViewBottomConstraint.constant;
    initImageViewHeight = _imageView.frame.size.height;
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    topBarHeight = statusHeight + navigationBarHeight;
    imageViewContentOffsetHeight = initImageViewHeight - topBarHeight;
    
    // Blur
    _blurImageView.image = [_imageView.image applyBlurWithRadius:30 tintColor:[UIColor colorWithWhite:0.8 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];

}

-(void)viewDidLayoutSubviews{
    //NSLog(@"%@",NSStringFromCGRect(_scrollView.frame));
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"SAP";
    
    // ナビゲーションバーを変更
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    // 文字色を変更
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    // ナビゲーションバーを戻す
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    // 文字色を戻す
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    [super viewWillDisappear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // expand top image on scroll view
    //NSLog(@"%@%f", NSStringFromCGPoint(scrollView.contentOffset), _imageView.alpha);
    
    // Image Top
    _imageViewTopConstraint.constant = scrollView.contentOffset.y;
    
    // Image Bottom
    if (scrollView.contentOffset.y >= imageViewContentOffsetHeight) {
        // Up scroll
        _imageViewBottomConstraint.constant = initImageViewBottomConstant + imageViewContentOffsetHeight - scrollView.contentOffset.y;
    } else {
        // Down scroll
        _imageViewBottomConstraint.constant = initImageViewBottomConstant;
    }
    
    // Blur
    if (scrollView.contentOffset.y  > - topBarHeight) {
        CGFloat delta = scrollView.contentOffset.y + topBarHeight;
        _blurImageView.alpha = MIN(1, delta * kBlurFadeInFactor);
    } else {
        _blurImageView.alpha = 0;
    }

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set same to cell indentifier on StoryBoard
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row % 3) {
        case 0:
            cell.textLabel.text = @"Orange";
            break;
        case 1:
            cell.textLabel.text = @"Grape";
            break;
        case 2:
            cell.textLabel.text = @"Cherry";
            break;
    }
    
    return cell;
}

#pragma mark -

@end
