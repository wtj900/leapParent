//
//  OWXWordSpellViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXWordSpellViewController.h"

#import "OWXWordModel.h"
#import "OWXWordSpellView.h"

#import <iflyMSC/iflyMSC.h>
#import "ISEParams.h"
#import "ISEResult.h"
#import "ISEResultXmlParser.h"

#import <TFHpple/TFHpple.h>

@interface OWXWordSpellViewController ()<IFlySpeechEvaluatorDelegate, ISEResultXmlParserDelegate, IFlyPcmRecorderDelegate>

@property (nonatomic, strong) NSArray<OWXWordModel *> *wordList;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) ISEParams *iseParams;
@property (nonatomic, strong) IFlySpeechEvaluator *iFlySpeechEvaluator;
@property (nonatomic, strong) IFlyPcmRecorder *pcmRecorder;

@property (nonatomic, strong) NSString* resultText;

@end

@implementation OWXWordSpellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.backButton];
    
    __weak __typeof(self) weakSelf = self;
    OWXWordSpellView *wordSpellView = [[OWXWordSpellView alloc] initWithFrame:CGRectMake(10, 60, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 70)];
    [self.view addSubview:wordSpellView];
    wordSpellView.spellIndex = ^(NSInteger index) {
        weakSelf.currentIndex = index;
    };
    
    NSArray *wordListArray = @[@{@"word" : @"cat",
                                 @"wordid" : @"82",
                                 @"structs" : @"3|1|20"},
                               @{@"word" : @"cake",
                                 @"wordid" : @"84",
                                 @"structs" : @"3|48|11|5"},
                               @{@"word" : @"car",
                                 @"wordid" : @"86",
                                 @"structs" : @"3|81"},
                               @{@"word" : @"clock",
                                 @"wordid" : @"125",
                                 @"structs" : @"3|12|15|126"},
                               @{@"word" : @"candy",
                                 @"wordid" : @"127",
                                 @"structs" : @"3|1|14|4|127"}];
    self.wordList = [NSArray modelArrayWithClass:[OWXWordModel class] json:wordListArray];
    wordSpellView.wordList = self.wordList;
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.equalTo(self.backButton);
    }];
    
    label.text = @"单词拼写";
    label.textColor = [UIColor redColor];
    label.font = FontMediumSize(20);
    
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.right.offset(-50);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    [button setTitle:@"单词测评开始" forState:UIControlStateNormal];
    [button setTitle:@"单词测评停止" forState:UIControlStateSelected];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setSpeechEvaluator];
}

- (void)setSpeechEvaluator {
    
    if (!self.iFlySpeechEvaluator) {
        self.iFlySpeechEvaluator = [IFlySpeechEvaluator sharedInstance];
    }
    self.iFlySpeechEvaluator.delegate = self;
    [self reloadCategoryText];
    
    //Initialize recorder
    if (_pcmRecorder == nil) {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    [_pcmRecorder setSample:@"16000"];
    [_pcmRecorder setSaveAudioPath:nil];    //not save the audio file
    
}

-(void)reloadCategoryText {
    
    //empty params
    [self.iFlySpeechEvaluator setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    self.iseParams = [[ISEParams alloc] init];
    [self.iseParams setDefaultParams];
    
    [self.iFlySpeechEvaluator setParameter:self.iseParams.bos forKey:[IFlySpeechConstant VAD_BOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.eos forKey:[IFlySpeechConstant VAD_EOS]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.category forKey:[IFlySpeechConstant ISE_CATEGORY]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.language forKey:[IFlySpeechConstant LANGUAGE]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.rstLevel forKey:[IFlySpeechConstant ISE_RESULT_LEVEL]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.timeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    [self.iFlySpeechEvaluator setParameter:self.iseParams.audioSource forKey:[IFlySpeechConstant AUDIO_SOURCE]];
    
}

- (void)buttonAction:(UIButton *)button {
    
    button.selected = !button.isSelected;
    
    if (button.isSelected) {
        [self.view showMessage:@"请大声读出单词"];
        [self onBtnStart:button];
    }
    else {
        [self onBtnParse:button];
    }
    
}

/*!
 *  start recorder
 */
- (void)onBtnStart:(id)sender {
    
    NSLog(@"%s[IN]",__func__);
    
    [self.iFlySpeechEvaluator setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    [self.iFlySpeechEvaluator setParameter:@"utf-8" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    [self.iFlySpeechEvaluator setParameter:@"xml" forKey:[IFlySpeechConstant ISE_RESULT_TYPE]];
    
    [self.iFlySpeechEvaluator setParameter:@"eva.pcm" forKey:[IFlySpeechConstant ISE_AUDIO_PATH]];
    
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

//    NSLog(@"text encoding:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]]);
//    NSLog(@"language:%@",[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]]);
//
//    BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant TEXT_ENCODING]] isEqualToString:@"utf-8"];
//    BOOL isZhCN=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant LANGUAGE]] isEqualToString:KCLanguageZHCN];
//
//    BOOL needAddTextBom=isUTF8&&isZhCN;
    
    OWXWordModel *model = self.wordList[self.currentIndex];
    NSString *contnet = [NSString stringWithFormat:@"[word]\n%@",model.word];
    NSMutableData *buffer = [NSMutableData dataWithData:[contnet dataUsingEncoding:encoding]];
    
//    buffer= [NSMutableData dataWithData:[self.textView.text dataUsingEncoding:encoding]];
//    if(needAddTextBom){
//
//
//
//        Byte bomHeader[] = { 0xEF, 0xBB, 0xBF };
//        buffer = [NSMutableData dataWithBytes:bomHeader length:sizeof(bomHeader)];
//        [buffer appendData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@" \ncn buffer length: %lu",(unsigned long)[buffer length]);
//
//
//        if(self.textView.text && [self.textView.text length]>0){
//        }
//    }else{
//        NSLog(@" \nen buffer length: %lu",(unsigned long)[buffer length]);
//    }
//    self.resultView.text = NSLocalizedString(@"M_ISE_Noti2", nil);
//    self.resultText=@"";
    
    BOOL ret = [self.iFlySpeechEvaluator startListening:buffer params:nil];
    if(ret){
//        self.isSessionResultAppear=NO;
//        self.isSessionEnd=NO;
//        self.startBtn.enabled=NO;
        
        //Set audio stream as audio source,which requires the developer import audio data into the recognition control by self through "writeAudio:".
        if ([self.iseParams.audioSource isEqualToString:IFLY_AUDIO_SOURCE_STREAM]){
            
//            _isBeginOfSpeech = NO;
            //set the category of AVAudioSession
            [IFlyAudioSession initRecordingAudioSession];
            
            _pcmRecorder.delegate = self;
            
            //start recording
            BOOL ret = [_pcmRecorder start];
            
            NSLog(@"%s[OUT],Success,Recorder ret=%d",__func__,ret);
        }
    }
}

/*!
 *  stop recording
 */
- (void)onBtnStop:(id)sender {
    
//    if(!self.isSessionResultAppear &&  !self.isSessionEnd){
//        self.resultView.text = NSLocalizedString(@"M_ISE_Noti3", nil);
//        self.resultText=@"";
//    }
//
//    if ([self.iseParams.audioSource isEqualToString:IFLY_AUDIO_SOURCE_STREAM] && !_isBeginOfSpeech){
//        NSLog(@"%s,stop recording",__func__);
//    }
    [_pcmRecorder stop];
    
    [self.iFlySpeechEvaluator stopListening];
//    [self.resultView resignFirstResponder];
//    [self.textView resignFirstResponder];
//    self.startBtn.enabled=YES;
}

- (void)onBtnParse:(id)sendr {
    ISEResultXmlParser* parser=[[ISEResultXmlParser alloc] init];
    parser.delegate=self;
    [parser parserXml:self.resultText];
}

#pragma mark - IFlySpeechEvaluatorDelegate
/*!
 *  音量和数据回调
 *
 *  @param volume 音量
 *  @param buffer 音频数据
 */
- (void)onVolumeChanged:(int)volume buffer:(NSData *)buffer {
    NSLog(@"volume:%d",volume);
}

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。如果发生错误则回调onCompleted:函数
 */
- (void)onBeginOfSpeech {
    NSLog(@"onBeginOfSpeech");
}

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onCompleted:函数
 */
- (void)onEndOfSpeech {
    if ([self.iseParams.audioSource isEqualToString:IFLY_AUDIO_SOURCE_STREAM]){
        [_pcmRecorder stop];
    }
    NSLog(@"onEndOfSpeech");
}

/*!
 *  正在取消
 */
- (void)onCancel {
    NSLog(@"onCancel");
}

/*!
 *  评测错误回调
 *
 *  在进行语音评测过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理.当errorCode没有错误时，表示此次会话正常结束，否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
 *
 *  @param errorCode 错误描述类
 */
- (void)onCompleted:(IFlySpeechError *)errorCode {
    NSLog(@"onCompleted--error:%@", errorCode);
}

/*!
 *  评测结果回调<br>
 *  在评测过程中可能会多次回调此函数，你最好不要在此回调函数中进行界面的更改等操作，只需要将回调的结果保存起来。
 *
 *  @param results -[out] 评测结果。
 *  @param isLast  -[out] 是否最后一条结果
 */
- (void)onResults:(NSData *)results isLast:(BOOL)isLast {
    
    if (results) {
        
        NSString *encoding = [self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]];
        TFHpple *element = [[TFHpple alloc] initWithXMLData:results encoding:encoding];
        
        NSArray *elements1 = [element searchWithXPathQuery:@"//rec_paper"];
        TFHppleElement *hppleElement = [elements1 objectOrNilAtIndex:0];
        TFHppleElement *read_word = [hppleElement firstChildWithTagName:@"read_word"];
        NSString *total_score = [read_word objectForKey:@"total_score"];
        
        if (!IS_EMPTY_STRING(total_score)) {
            [self.view showMessage:[NSString stringWithFormat:@"得分:%@",total_score]];
        }
        
        NSString *showText = @"";

        const char* chResult=[results bytes];

        BOOL isUTF8=[[self.iFlySpeechEvaluator parameterForKey:[IFlySpeechConstant RESULT_ENCODING]]isEqualToString:@"utf-8"];
        NSString* strResults=nil;
        if(isUTF8){
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:NSUTF8StringEncoding];
        }else{
            NSLog(@"result encoding: gb2312");
            NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            strResults=[[NSString alloc] initWithBytes:chResult length:[results length] encoding:encoding];
        }
        
        if(strResults){
            showText = [showText stringByAppendingString:strResults];
        }
        
        NSLog(@"%@",showText);

        self.resultText=showText;
//        self.resultView.text = showText;
//        self.isSessionResultAppear=YES;
//        self.isSessionEnd=YES;
//        if(isLast){
//            [self.popupView setText: NSLocalizedString(@"T_ISE_End", nil)];
//            [self.view addSubview:self.popupView];
//        }

    }
    else{
//        if(isLast){
//            [self.popupView setText: NSLocalizedString(@"M_ISE_Msg", nil)];
//            [self.view addSubview:self.popupView];
//        }
//        self.isSessionEnd=YES;
    }
//    self.startBtn.enabled=YES;
}

#pragma mark - IFlyPcmRecorderDelegate
/*!
 *  回调音频数据
 *
 *  @param buffer 音频数据
 *  @param size   表示音频的长度
 */
- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size {
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechEvaluator writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechEvaluator stopListening];
    }
}

/*!
 *  回调音频的错误码
 *
 *  @param recoder 录音器
 *  @param error   错误码
 */
- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error {
    
}

/*!
 *  回调录音音量
 *
 *  @param power 音量值
 */
- (void) onIFlyRecorderVolumeChanged:(int) power {
    
}

#pragma mark - ISEResultXmlParserDelegate
-(void)onISEResultXmlParser:(NSXMLParser *)parser Error:(NSError*)error{
    
}

-(void)onISEResultXmlParserResult:(ISEResult*)result{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
