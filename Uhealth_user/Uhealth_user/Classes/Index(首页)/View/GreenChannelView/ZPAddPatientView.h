//
//  ZPAddPatientView.h
//  Uhealth
//
//  Created by Biao Geng on 2018/4/24.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAddPatientView : UIView
+ (instancetype)addPatientView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (strong, nonatomic) IBOutlet UITextField *codeTextfield;

@property (strong, nonatomic) IBOutlet UIButton *sfzBtn;
@property (strong, nonatomic) IBOutlet UIButton *jrBtn;
@property (strong, nonatomic) IBOutlet UIButton *hzBtn;

@property (strong, nonatomic) IBOutlet UIButton *staffBtn;
@property (strong, nonatomic) IBOutlet UIButton *familyBtn;
@end
