//
//  UIViewController+HRAlertViewController.h
//  HireRussians
//
//  Created by Ivan Shevelev on 10/11/15.
//  Copyright © 2015 Sibers. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Category for easy showing UIAlertController with AlertStyle and handle actions if needed.
 *
 *  @warning Category in implementation use a "Error!", "Cancel", "OK", "Success!" NSLocalizedStrings. Please implement translate of the words in your Localizable.strings file.
 */
@interface UIViewController (HRAlertView)

/**
 *  Method for creating UIAlertController with AlertStyle.
 *
 *  @param title        Title property in alert.
 *  @param message      Description property in alert.
 *  @param buttonTitles NSArray<NSString *> * with titles of buttons.
 *  @param handler      Block, which called if buttons in alert is tapped. 2 params: action of button and index of button.
 *
 *  @return UIAlertController instance.
 *
 */
-(nonnull UIAlertController *)hrAlertWithTitle:(nullable NSString *)title
                                       message:(nullable NSString *)message
                                 buttonsTitles:(nullable NSArray<NSString *> *)buttonTitles
                                    andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action, NSInteger indexOfAction))handler;

/**
 *  Method for showing UIAlertController with AlertStyle.
 *
 *  @param title        Title property in alert.
 *  @param message      Description property in alert.
 *  @param buttonTitles NSArray<NSString *> * with titles of buttons.
 *  @param handler      Block, which called if buttons in alert is tapped. 2 params: action of button and index of button.
 */
-(void)hrShowAlertWithTitle:(nullable NSString *)title
                    message:(nullable NSString *)message
              buttonsTitles:(nullable NSArray<NSString *> *)buttonTitles
                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action, NSInteger indexOfAction))handler;

/**
 *  Method for showing UIAlertController with AlertStyle with one default "OK" button.
 *
 *  @param title   Title property in alert.
 *  @param message Description property in alert.
 *  @param handler Block, which called if buttons in alert is tapped. 2 params: action of button and index of button.
 *
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *
 */
-(void)hrShowAlertWithTitle:(nullable NSString *)title
                    message:(nullable NSString *)message
                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

/**
 *  Method for showing UIAlertController with AlertStyle with one default "OK" button without handle button tap.
 *
 *  @param title   Title property in alert.
 *  @param message Description property in alert.
 *
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *  @waring Alert without handle button tap.
 *
 */
-(void)hrShowAlertWithTitle:(nullable NSString *)title
                    message:(nullable NSString *)message;

/**
 *  Method for showing UIAlertController with AlertStyle with "Error!" title and message, one default "OK" button without handle button tap and title.
 *
 *  @param message Description property in alert.
 *
 *  @warning Method in implementation use a @"Error!" NSLocalizedString. Please implement translate of "Error!" in your Localizable.strings file.
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 */
-(void)hrShowErrorAlertWithMessage:(nullable NSString *)message;

/**
 *  Method for showing UIAlertController with AlertStyle with "Error!" title and message and one default "OK" button.
 *
 *  @param message Description property in alert.
 *  @param handler Block, which called if buttons in alert is tapped. 2 params: action of button and index of button.
 *
 *  @warning Method in implementation use a @"Error!" NSLocalizedString. Please implement translate of "Error!" in your Localizable.strings file.
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *
 */
-(void)hrShowErrorAlertWithMessage:(nullable NSString *)message
                        andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

/**
 *  Method for showing UIAlertController with AlertStyle with "Success!" title and message and one default "OK" button without handle button tap.
 *
 *  @param message Description property in alert.
 *
 *  @warning Method in implementation use a @"Success!" NSLocalizedString. Please implement translate of "Success!" in your Localizable.strings file.
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *  @warning Alert without handle button tap.
 *
 */
-(void)hrShowSuccessAlertWithMessage:(nullable NSString *)message;

/**
 *  Method for showing UIAlertController with AlertStyle with "Success!" title and message and one default "OK" button.
 *
 *  @param message Description property in alert.
 *  @param handler Block, which called if buttons in alert is tapped. 2 params: action of button and index of button.
 *
 *  @warning Method in implementation use a @"Success!" NSLocalizedString. Please implement translate of "Success!" in your Localizable.strings file.
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *
 */
-(void)hrShowSuccessAlertWithMessage:(nullable NSString *)message
                          andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

/**
 *  Method for showing UIAlertController with AlertStyle with localized description of error and one default "OK" button.
 *
 *  @param error error, whose localized description will be displayed on alert message.
 *
 *  @warning Method in implementation use a @"Error!" NSLocalizedString. Please implement translate of "Error" in your Localizable.strings file.
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *  @warning Alert without handle button tap.
 *
 */
-(void)hrShowAlertWithError:(nullable NSError *)error;

/**
 *  Method for showing UIAlertController with AlertStyle with localized description of error and one default "OK" button.
 *
 *  @param error error, whose localized description will be displayed on alert message.
 *
 *  @warning Method in implementation use a @"Error!" NSLocalizedString. Please implement translate of "Error" in your Localizable.strings file.
 *  @warning Method in implementation use a @"OK" NSLocalizedString. Please implement translate of "OK" in your Localizable.strings file.
 *
 */
-(void)hrShowAlertWithError:(nullable NSError *)error
                 andHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

@end

/**
 *  Category for easy showing UIAlertController with SheetStyle and handle.
 *
 *  @warning Category in implementation use a "Cancel" NSLocalizedString. Please implement translate of the word in your Localizable.strings file.
 *
 */
@interface UIViewController (HRActionSheet)

/**
 *  Method for showing UIAlertController with SheetStyle with default "Cancel" button.
 *
 *  @param title               Title property in alert.
 *  @param message             Desription property in alert.
 *  @param titles              NSArray<NSString *> * with titles of buttons.
 *  @param handler             Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *  @param cancelActionHandler Block, which called if cancel button in action sheet is tapped.
 *
 *  @warning Category in implementation use a "Cancel" NSLocalizedString. Please implement translate of the word in your Localizable.strings file.
 *
 */
-(void)hrShowActionSheetWithTitle:(nullable NSString *)title
                          message:(nullable NSString *)message
                     buttonTitles:(nullable NSArray<NSString *> *)titles
                    actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
           andCancelActionHandler:(nullable void(^)())cancelActionHandler;

/**
 *  Method for showing UIAlertController with SheetStyle with default "Cancel" button.
 *
 *  @param title               Title property in alert.
 *  @param titles              NSArray<NSString *> * with titles of buttons.
 *  @param handler             Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *  @param cancelActionHandler Block, which called if cancel button in action sheet is tapped.
 *
 *  @warning Category in implementation use a "Cancel" NSLocalizedString. Please implement translate of the word in your Localizable.strings file.
 *
 */
-(void)hrShowActionSheetWithTitle:(nullable NSString *)title
                     buttonTitles:(nullable NSArray<NSString *> *)titles
                    actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
           andCancelActionHandler:(nullable void(^)())cancelActionHandler;

/**
 *  Method for showing UIAlertController with SheetStyle with default "Cancel" button.
 *
 *  @param message             Desription property in alert.
 *  @param titles              NSArray<NSString *> * with titles of buttons.
 *  @param handler             Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *  @param cancelActionHandler Block, which called if cancel button in action sheet is tapped.
 *
 *  @warning Category in implementation use a "Cancel" NSLocalizedString. Please implement translate of the word in your Localizable.strings file.
 *
 */
-(void)hrShowActionSheetWithMessage:(nullable NSString *)message
                       buttonTitles:(nullable NSArray<NSString *> *)titles
                      actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
             andCancelActionHandler:(nullable void(^)())cancelActionHandler;

/**
 *  Method for showing UIAlertController with SheetStyle with default "Cancel" button.
 *
 *  @param titles              NSArray<NSString *> * with titles of buttons.
 *  @param handler             Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *  @param cancelActionHandler Block, which called if cancel button in action sheet is tapped.
 *
 *  @warning Category in implementation use a "Cancel" NSLocalizedString. Please implement translate of the word in your Localizable.strings file.
 *
 */
-(void)hrShowActionSheetWithTitles:(nullable NSArray<NSString *> *)titles
                     actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler
            andCancelActionHandler:(nullable void(^)())cancelActionHandler;

/**
 *  Method for showing UIAlertController with SheetStyle with default "Cancel" button without cancel button tap handling.
 *
 *  @param titles              NSArray<NSString *> * with titles of buttons.
 *  @param handler             Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *
 *  @warning Category in implementation use a "Cancel" NSLocalizedString. Please implement translate of the word in your Localizable.strings file.
 *
 */
-(void)hrShowActionSheetWithTitles:(nullable NSArray<NSString *> *)titles
                     actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler;

/**
 *  Method for showing UIAlertController with SheetStyle without default "Cancel" button.
 *
 *  @param titles              NSArray<NSString *> * with titles of buttons.
 *  @param handler             Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *
 *
 */
-(void)hrShowActionSheetWithoutCancelWithTitles:(nullable NSArray<NSString *> *)titles
                                  actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler;

/**
 *  Method for showing UIAlertController with SheetStyle without default "Cancel" button. Method created specialy for iPad.
 *
 *  @param titles     NSArray<NSString *> * with titles of buttons.
 *  @param direction  Arrow Direction in popover.
 *  @param sourceView Source View in popover.
 *  @param sourceView Source Rect in popover.
 *  @param handler    Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 */
-(void)hrShowActionSheetWithoutCancelWithTitles:(nullable NSArray<NSString *> *)titles
                          popoverArrowDirection:(UIPopoverArrowDirection)direction
                                     sourceView:(nullable UIView *)sourceView
                                     sourceRect:(CGRect)rect
                                  actionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler;

/**
 *  Method for creating UIAlertController with SheetStyle without default "Cancel" button. Method created specialy for iPad.
 *
 *  @param title      Title property in alert.
 *  @param message    Desription property in alert.
 *  @param titles     NSArray<NSString *> * with titles of buttons.
 *  @param direction  Arrow Direction in popover.
 *  @param sourceView Source View in popover.
 *  @param sourceRect Source Rect in popover.
 *  @param handler    Block, which called if buttons in action sheet is tapped. 2 params: action of button and index of button.
 *
 *  @return UIAlertController instance.
 */
-(nonnull UIAlertController *)hrAlertControllerWithTitle:(nullable NSString *)title
                                                 message:(nullable NSString *)message
                                           buttonsTitles:(nullable NSArray *)titles
                                   popoverArrowDirection:(UIPopoverArrowDirection)direction
                                              sourceView:(nullable UIView *)sourceView
                                              sourceRect:(CGRect)rect
                                        andActionHandler:(nullable void(^)(NSInteger indexOfAction, NSString * _Nonnull title))handler;

@end
