//
//  TucaoPublishController.h
//  FBAuto
//
//  Created by lichaowei on 14/12/26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

@interface TucaoPublishController : FBBaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *inputView;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) IBOutlet UILabel *placeHolder;

- (IBAction)clickToPhoto:(id)sender;

- (IBAction)tapToHiddenKeyboard:(id)sender;

@end
