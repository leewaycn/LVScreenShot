//
//  TableViewController.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "TableViewController.h"
#import "UIScrollView+LVShot.h"

@interface TableViewController ()
    {

        CGFloat height;
        CGFloat width;

        UIImageView *storeImage;
        UIScrollView *storeScrollView;
        UIActivityIndicatorView *activity;



    }
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;


    self.view.backgroundColor = [UIColor whiteColor];


    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearscreenshotALL)];


    [ self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];



    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                                          UIActivityIndicatorViewStyleWhiteLarge];
    [ self.view addSubview:indicator];
    indicator.frame = CGRectMake(width/2-15, 70, 30, 30);
    indicator.backgroundColor = [UIColor blackColor];
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];

    activity = indicator;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];

    }

    cell.textLabel.text = [NSString stringWithFormat: @"indexPath .row = ==> %ld",indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"indexPath .row = ==> %ld",indexPath.row];

    cell.imageView.image = [UIImage imageNamed:@"logo"];


    return cell;
}

    -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        [self screenshotALL];
        
    }

    -(void)screenshotALL{


        activity .hidden = NO;
        [activity startAnimating];

        __weak typeof(self) weakSelf = self;
        [self.tableView DDGContentScrollScreenShot:^(UIImage *screenShotImage) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            [strongSelf showScreenShot:screenShotImage];
            strongSelf->activity .hidden = YES;
            [strongSelf->activity stopAnimating];

        }];



    }
    -(void)clearscreenshotALL{
        if(storeScrollView!=nil){
            [storeScrollView removeFromSuperview];
            storeScrollView = nil;
        }
    }

    -(void)showScreenShot:(UIImage*)image{

        if(storeScrollView==nil){
            storeScrollView = [UIScrollView new];
        }

        CGFloat imageFakewidth = width/2;
        CGFloat imageFakeHeight = image.size.height*imageFakewidth/image.size.width;

        storeScrollView.contentSize = CGSizeMake(imageFakewidth, imageFakeHeight);
        storeScrollView.frame =CGRectMake(0, 0, width/2, height/2);
        storeScrollView.center = self.view .center;
        storeScrollView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:storeScrollView];

        storeImage = [UIImageView new];
        storeImage.image = image;
        [storeScrollView addSubview:storeImage];
        storeImage.frame = CGRectMake(0, 0, imageFakewidth, imageFakeHeight);



    }
    

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
