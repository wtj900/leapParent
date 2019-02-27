//
//  OWXBookRoomViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/8.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXBookRoomViewController.h"
#import "OWXBookShelfCollectionViewLayout.h"
#import "OWXBookShelfCollectionViewCell.h"
#import "OWXBookShelfFooterView.h"
#import "OWXBookShelfModel.h"

@interface OWXBookRoomViewController ()<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<NSArray<OWXBookShelfModel *> *> *books;
@property (nonatomic, strong) NSMutableArray<OWXBookShelfModel *> *totalBooks;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation OWXBookRoomViewController

static NSString * const cellReuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildSubViews];
    
    [self loadData];
    
}

- (void)buildSubViews {
    
    [self.view addSubview:self.backButton];
    
    OWXBookShelfCollectionViewLayout *flowLayout = [[OWXBookShelfCollectionViewLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.offset(75);
    }];
    
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[OWXBookShelfCollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    [collectionView registerClass:[OWXBookShelfFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([OWXBookShelfFooterView class])];
    self.collectionView.backgroundColor = RGBColor(6, 85, 159);
}

- (void)loadData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"books.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSArray *serializationData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSArray *dataList = [NSArray modelArrayWithClass:[OWXBookShelfModel class] json:serializationData];
    
    [self.books removeAllObjects];
    
    NSInteger i = 0;
    while (YES) {
        
        NSInteger remainder = dataList.count - i * kBookShelfItemCountOfRow;
        
        if (remainder <= 0) {
            break;
        }
        
        NSInteger length = remainder < kBookShelfItemCountOfRow ? remainder : kBookShelfItemCountOfRow;
        NSArray *tempArray = [dataList subarrayWithRange:NSMakeRange(i * kBookShelfItemCountOfRow, length)];
        
        [self.books addObject:tempArray];
        
        i++;
        
    };
    
    [self.collectionView reloadData];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.books.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.books[section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

        OWXBookShelfFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([OWXBookShelfFooterView class]) forIndexPath:indexPath];
        return view;
    }

    return nil;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(collectionView.width, kBookShelfFooterViewHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OWXBookShelfCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.books[indexPath.section][indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    FWBookCategoryViewController *vc = [[FWBookCategoryViewController alloc] initWithUrlString:[[FWDataManager getDataForPoetry] objectForKey:self.books[indexPath.item]]];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSMutableArray<NSArray<OWXBookShelfModel *> *> *)books {
    if (!_books) {
        _books = [[NSMutableArray alloc] init];
    }
    return _books;
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
