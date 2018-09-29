//
//  BLCarController.m
//  BL_BaseApp
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 王印. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLCarController.h"
#import "LSRockingBarView.h"

@interface BLCarController ()<LSRockingBarViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    
    NSString *_shopName;
    NSString *_header;
    NSString *_open;
    NSString *_upDown;
    NSString *_leftRight;
    NSString *_leftRgihtLight;
    NSString *_highBeam;
    NSString *_sound;
    NSString *_selfShow;
    NSString *_change;
    
    BOOL     timerCanWrite;
}


 @property (nonatomic, strong) CBCentralManager *cMgr;

@property(nonatomic,strong)NSString       *UUID;

@property(nonatomic,strong)CBCharacteristic  *wirteCharacter;


 @property (nonatomic, strong) CBPeripheral *peripheral;
 

@property(nonatomic,)LSRockingBarView   *controllerBar;

@property(nonatomic,strong)NSTimer      *timer;

@end

@implementation BLCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UUID = @"49535343-8841-43F4-A8D4-ECBE34729BB3";
    [self.cMgr scanForPeripheralsWithServices:nil options:nil];
    [self controllerBar];
    [self timer];
    self.navagationBarColor = [UIColor whiteColor];
    self.navLargeTitleMode = YES;
    self.navagationBarShadowLineHiden = YES;
    self.navagationBarTextColor = [UIColor redColor];
    self.title = @"蓝牙控制";
    _open = @"1";
}

-(void)dealloc{
    
    [self.timer invalidate];
}


-(CBCentralManager *)cMgr
{
    if (!_cMgr) {
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _cMgr;
}

//只要中心管理者初始化 就会触发此代理方法 判断手机蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
        }
            break;
        case 5:
        {
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
    
            [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                              options:nil]; // dict,条件
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 在中心管理者成功开启后再进行一些操作
                // 搜索外设
                NSArray<CBPeripheral *> *arr = [self.cMgr retrieveConnectedPeripheralsWithServices:@[]];
                
                if (arr&&arr.count>0) {
                    [arr enumerateObjectsUsingBlock:^(CBPeripheral * _Nonnull peripheral, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([peripheral.name hasPrefix:@"MZ_"]) {
                            
                            self.peripheral = peripheral;
                            
                            [self.cMgr connectPeripheral:peripheral options:nil];
                            NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
                        }
                    }];
                }
            });
            // 搜索成功之后,会调用我们找到外设的代理方法
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
        }
            break;
        default:
            break;
    }
}

// 发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral // 外设
     advertisementData:(NSDictionary *)advertisementData // 外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    if (![peripheral.name containsString:@"BrightBeacon"]) {
    NSLog(@"%s, line = %d, cetral = %@,peripheral = %@, advertisementData = %@, RSSI = %@", __FUNCTION__, __LINE__, central, peripheral, advertisementData, RSSI);
    }
    if ([peripheral.name hasPrefix:@"MZ_"]) {
    
        self.peripheral = peripheral;
       
        [self.cMgr connectPeripheral:self.peripheral options:nil];
        NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    }
}

// 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central // 中心管理者
  didConnectPeripheral:(CBPeripheral *)peripheral // 外设
{
    
    
    
    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    // 连接成功之后,可以进行服务和特征的发现
    
    //  设置外设的代理
    self.peripheral.delegate = self;
    
    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.peripheral discoverServices:nil];
    
    [self.cMgr stopScan];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        NSLog(@"%@",service.UUID);
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
    
  
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
}

// 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接断开" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show ];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    self.peripheral = nil;
    self.wirteCharacter = nil;
    timerCanWrite = NO;
    [self.cMgr scanForPeripheralsWithServices:nil options:nil];
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
}

// 发现外设服务里的特征的时候调用的代理方法(这个是比较重要的方法，你在这里可以通过事先知道UUID找到你需要的特征，订阅特征，或者这里写入数据给特征也可以)
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    for (CBCharacteristic *cha in service.characteristics) {
        NSLog(@"%s, line = %d, char = %@", __FUNCTION__, __LINE__, cha);
        if ([cha.UUID.UUIDString isEqualToString:self.UUID]) {
            self.wirteCharacter = cha;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
              [alert show ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
            });
            
        }else{
//            [self.peripheral discoverDescriptorsForCharacteristic:cha];
            [self.peripheral readValueForCharacteristic:cha];
        }
    }
}

// 更新特征的value的时候会调用 （凡是从蓝牙传过来的数据都要经过这个回调，简单的说这个方法就是你拿数据的唯一方法） 你可以判断是否
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    if (characteristic == @"你要的特征的UUID或者是你已经找到的特征") {
        //characteristic.value就是你要的数据
    }
}


// 需要注意的是特征的属性是否支持写数据
- (void)yf_peripheral:(CBPeripheral *)peripheral didWriteData:(NSData *)data forCharacteristic:(nonnull CBCharacteristic *)characteristic
{
  
}

- (IBAction)test:(id)sender {
    timerCanWrite = YES;
    [self open:YES];
    timerCanWrite = NO;
}


- (void)open:(BOOL)is{
    _open = @"0";
    _leftRight = @"-1";
    _upDown = @"-100";
    _leftRgihtLight = @"0";
    _highBeam = @"0";
    _sound = @"0";
    _selfShow = @"0";
    _change = @"0";
    if (is) {
        _open = @"1";
    }
    [self write];
}


- (void)write{
    if (!timerCanWrite) {
        return;
    }
    Byte value[17] = {};
    value[0] = 165;
    value[1] = 0x0d;
    value[2] = 0x6d;
    value[3] = 0x61;
    value[4] = 0x6d;
    value[5] = 0x61;
    value[6] = 1;
    value[7] = [_open integerValue];
    value[8] = _upDown.integerValue;
    value[9] =_leftRight.integerValue;
    value[10] =_leftRgihtLight.integerValue;
    value[11] = [_highBeam integerValue];
    value[12]= [_sound integerValue];
    value[13] = [_selfShow integerValue];
    value[14] = [_change integerValue];
    int inta = value[1]^value[2]^value[3]^value[4]^value[5]^value[6]^value[7]^value[8]^value[9]^value[10]^value[11]^value[12]^value[13]^value[14];
    value[15] = inta;
    value[16] = 90;
    NSData * data = [NSData dataWithBytes:&value length:sizeof(value)];
    //发送数据
    [self.peripheral writeValue:data forCharacteristic:self.wirteCharacter type:CBCharacteristicWriteWithResponse];
}

- (void)LSRockingBarViewOffsetX:(CGFloat)x offsetY:(CGFloat)y{
    _leftRight = [NSString stringWithFormat:@"%.0f",100*x];
    _upDown = [NSString stringWithFormat:@"%.0f",-100*y];
    timerCanWrite = YES;
}

- (void)LSRockingBarViewWillBackToOriginalPoint{
    
}

- (void)LSRockingBarViewDidBackToOriginalPoint{
    timerCanWrite = NO;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(write) userInfo:nil repeats:YES];
        _timer.fireDate = [NSDate distantPast];
    }
    return _timer;
}

- (LSRockingBarView *)controllerBar{
    if(!_controllerBar ){
        _controllerBar = [[LSRockingBarView alloc] initWithFrame:CGRectMake((ScreenWith-150)/2.f, (ScreenHight-150)/2.f, 150, 150) AndDirection:LSRockingBarMoveDirectionAll];
        _controllerBar.delegate =self;
        [self.view addSubview:_controllerBar];
    }
    return _controllerBar;
}
@end
