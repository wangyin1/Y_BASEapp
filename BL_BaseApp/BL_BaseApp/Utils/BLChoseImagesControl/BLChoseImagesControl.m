//
//  BLChoseImagesControl.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/24.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "BLChoseImagesControl.h"
#import "FounctionChose.h"
#import "HUImagePickerViewController.h"

@interface BLChoseImagesControl ()<UINavigationControllerDelegate,HUImagePickerViewControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,copy)BLGetImagesBlock       block;

@end

@implementation BLChoseImagesControl

+ (instancetype)shareInstance{
    static BLChoseImagesControl * shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[BLChoseImagesControl alloc]init];
    });
    return shareInstance;
}

+ (void)showChoseImagesAlertWithMaxCount:(NSInteger)maxCount GetImagesBlock:(BLGetImagesBlock)block DissmissBlock:(void (^)())dismiss{
    [BLChoseImagesControl shareInstance].block = block;
    [BLChoseImagesControl shareInstance].maxAllow = maxCount;
    [FounctionChose showWithDataList:@[@"相册",@"拍照",@"取消"] choseBlock:^(NSString *buttonTitle, NSInteger index) {
        
        switch (index) {
            case 0:{
                [[BLChoseImagesControl shareInstance] choseImagesWithType:0];
                
            }
                break;
                
            case 1:{
                [[BLChoseImagesControl shareInstance] choseImagesWithType:1];
            }
                break;
            default:
                break;
        }
        if (dismiss) {
            dismiss();
        }
    }];
    
}


- (void)choseImagesWithType:(NSInteger)type{
    if (type==0) {//相册
        HUImagePickerViewController *picker = [[HUImagePickerViewController alloc]init];
        picker.maxAllowedCount = self.maxAllow>0?self.maxAllow:9;
        picker.delegate = self;
        picker.originalImageAllowed = YES;
        [[[MYAPP window] rootViewController]presentViewController:picker animated:YES completion:^{
            
        }];
    }else{//相机
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate= self;
        [[[MYAPP window] rootViewController]presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark 获取到图片
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    if (self.block) {
        self.block(info[@"kHUImagePickerOriginalImage"]);
    }
}

#pragma mark 获取到拍照数据
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.block) {
        self.block(@[[UIImage imageWithData:[ (UIImage *)info[@"UIImagePickerControllerOriginalImage"] compressToSize:1024]]]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
