//
//  YINPhtoPicker.m
//  BL_BaseApp
//
//  Created by bolaa on 2018/3/13.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINPhtoPicker.h"
#import "FounctionChose.h"
#import "TZImagePickerController.h"
#import <Photos/Photos.h>
#import "HUPhotoBrowser.h"
@interface YINPhtoPicker()<UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,copy)YINPhtoPickerBlock       block;
@property(nonatomic,weak)UIViewController       *avc;
@property(nonatomic,assign)NSInteger        maxAllow;
@end

@implementation YINPhtoPicker

+ (instancetype)shareInstance{
    static YINPhtoPicker * shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[YINPhtoPicker alloc]init];
    });
    
    return shareInstance;
}

+ (void)showBrowserWithImage:(NSArray *)images  fromImageView:(UIImageView *)imageView currentIndex:(NSInteger)index deletBlock:(YINPhtoDeletBlock)delet{
  
    if (delet) {
        [HUPhotoBrowser showFromImageView:imageView withAutoImages:images atIndex:index deletBlock:^(UIImage *image, NSInteger index) {
            if (delet) {
                delet(image,index);
            }
        }];
    }else{
        [HUPhotoBrowser showFromImageView:imageView withURLStrings:images atIndex:index];
    }
}

+ (void)choseWithMaxCount:(NSInteger)maxCount allowVideo:(BOOL)allow controller:(UIViewController *)vc getImagesBlock:(YINPhtoPickerBlock)block{
    UIViewController *avc = vc?:[[UIApplication sharedApplication].delegate window].rootViewController;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status==PHAuthorizationStatusAuthorized) {
                
                TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:nil];
                picker.allowTakeVideo = allow;
                picker.sortAscendingByModificationDate = NO;
                picker.allowPickingOriginalPhoto = NO;
                [picker setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
                    if (block) {
                        block(photos);
                    }
                }];
                
                [vc presentViewController:picker animated:YES completion:^{
                    
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
                
                [avc presentViewController:alert animated:YES completion:^{
                    
                }];
                
                
            }
        });
    }];
}

+ (void)choseWithMaxCount:(NSInteger)maxCount controller:(UIViewController *)vc getImagesBlock:(YINPhtoPickerBlock)block{
    
    [self choseWithMaxCount:maxCount allowVideo:NO controller:vc getImagesBlock:block];
    
}


- (void)choseImagesWithType:(NSInteger)type controller:(UIViewController *)vc{
    if (type==0) {//相册
       
    }else{//相机
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate= self;
        [vc presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

#pragma mark 获取到图片
//#pragma mark - <AJPhotoPickerProtocol>
////选择完成
//- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets
//{
//    NSMutableArray *AssetsImageArrat = [NSMutableArray array];
//    
//    
//    for (int i = 0 ; i < assets.count; i++) {
//        ALAsset *asset = assets[i];
//        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//        [AssetsImageArrat addObject:tempImg];
//        
//    }
//    if (self.block) {
//        self.block(AssetsImageArrat);
//    }
//    
//    [picker.navigationController?:picker dismissViewControllerAnimated:YES completion:nil];
//    
//}
//
////超过最大选择项时
//- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker
//{
//    
//    [MBProgressHUD showError:@"超出最大范围"];
//}
//
////取消
//- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker
//{
//    [picker.navigationController?:picker dismissViewControllerAnimated:YES completion:nil];
//}
//
////点击相机按钮相关操作
//- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker
//{
//    [picker.navigationController?:picker dismissViewControllerAnimated:NO completion:^{
//        [self choseImagesWithType:1 controller:[YINPhtoPicker shareInstance].avc];
//    }];
//}
//
//#pragma mark 获取到拍照数据
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    ALAssetsLibrary *library  = [[ALAssetsLibrary alloc] init];
//    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//
////    __weak typeof(self)wself = self;
//    if (self.block) {
//        self.block(@[image]);
//    }
////    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
////        if (error) {
////            // TODO: error handling
////        } else {
////
////        }
////    }];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//



    @end
    
