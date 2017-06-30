//
//  BLChoseImagesControl.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/24.
//  Copyright © 2016年 王印. All rights reserved.
//
#import <Photos/Photos.h>
#import "BLChoseImagesControl.h"
#import "FounctionChose.h"
#import "AJPhotoBrowserViewController.h"
#import "AJPhotoPickerViewController.h"




@interface BLChoseImagesControl ()<UINavigationControllerDelegate,AJPhotoPickerProtocol,UIImagePickerControllerDelegate,AJPhotoBrowserDelegate>
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
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status==PHAuthorizationStatusAuthorized) {
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
                
            }else{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请开启相册访问权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction *setting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    
                }];
                
                [alert addAction:cancel];
                [alert addAction:setting];
                
                [[[MYAPP window] rootViewController]presentViewController:alert animated:YES completion:^{
                    
                }];
                
                
            }
        });
    }];
    
    
}


- (void)choseImagesWithType:(NSInteger)type{
    if (type==0) {//相册
        AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
        //最大可选项
        picker.maximumNumberOfSelection = 1;
        //是否多选
        picker.multipleSelection = YES;
        //资源过滤
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        //是否显示空的相册
        picker.showEmptyGroups = YES;
        //委托（必须）
        picker.delegate = self;
        //可选过滤
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return YES;
        }];
        
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
#pragma mark - <AJPhotoPickerProtocol>
//选择完成
- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets
{
    NSMutableArray *AssetsImageArrat = [NSMutableArray array];
    
    
    for (int i = 0 ; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [AssetsImageArrat addObject:tempImg];
        
    }
    if (self.block) {
        self.block(AssetsImageArrat);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker
{
    
    [MBProgressHUD showError:@"超出最大范围"];
}

//取消
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击相机按钮相关操作
- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self choseImagesWithType:1];
}

#pragma mark 获取到拍照数据
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (self.block) {
        self.block(@[info[@"UIImagePickerControllerOriginalImage"]]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
