//
//  OWXBookShelfCollectionViewLayout.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/8.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXBookShelfCollectionViewLayout.h"
#import "OWXBookShelfDecarationView.h"

NSInteger const kBookShelfCellHeight = 100;
NSInteger const kBookShelfItemCountOfRow = 4;
NSInteger const kBookShelfFooterViewHeight = 35;
NSString * const OWXBookShelfCollectionViewLayoutDecorationViewKind = @"OWXBookShelfCollectionViewLayoutDecorationViewKind";

@interface OWXBookShelfCollectionViewLayout ()

@property (nonatomic, strong) NSDictionary *bookShelfRectanges;

@end

@implementation OWXBookShelfCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width / kBookShelfItemCountOfRow, kBookShelfCellHeight);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    [self registerClass:[OWXBookShelfDecarationView class] forDecorationViewOfKind:OWXBookShelfCollectionViewLayoutDecorationViewKind];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    CGFloat kBookShelfDecorationViewHeight = kBookShelfCellHeight + kBookShelfFooterViewHeight;
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++) {
        dictionary[[NSIndexPath indexPathForItem:0 inSection:section]] = [NSValue valueWithCGRect:CGRectMake(0, kBookShelfDecorationViewHeight * section, self.collectionView.frame.size.width, kBookShelfDecorationViewHeight)];
    }
    
    self.bookShelfRectanges = [NSDictionary dictionaryWithDictionary:dictionary];
}

#pragma mark Runtime Layout Calculations
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // call super so flow layout can return default attributes for all cells, headers, and footers
    // NOTE: Flow layout has already taken care of the Cell view layout attributes! :)
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // create a mutable copy so we can add layout attributes for any shelfs that
    // have frames that intersect the rect the CollectionView is interested in
    NSMutableArray *newArray = [array mutableCopy];
    //    NSLog(@"in rect:%@",NSStringFromCGRect(rect));
    // Add any decoration views (shelves) who's rect intersects with the
    // CGRect passed to the layout by the CollectionView
    [self.bookShelfRectanges enumerateKeysAndObjectsUsingBlock:^(id key, id shelfRect, BOOL *stop) {
        //        NSLog(@"[shelfRect CGRectValue]:%@",NSStringFromCGRect([shelfRect CGRectValue]));
        
        if (CGRectIntersectsRect([shelfRect CGRectValue], rect)) {
            
            UICollectionViewLayoutAttributes *shelfAttributes =
            [self layoutAttributesForDecorationViewOfKind:OWXBookShelfCollectionViewLayoutDecorationViewKind
                                              atIndexPath:key];
            [newArray addObject:shelfAttributes];
        }
    }];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (int section = 0; section < sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < itemCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            
            [newArray addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    
    return [newArray copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"%@", NSStringFromCGSize([self screenSize]));375 667
    
    NSLog(@"%ld--------%ld",indexPath.section, indexPath.item);
    UICollectionViewLayoutAttributes *attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat kBookShelfDecorationViewHeight = kBookShelfCellHeight + kBookShelfFooterViewHeight;
    NSInteger currentRow = indexPath.item / kBookShelfItemCountOfRow;
    CGRect frame = CGRectMake((indexPath.item % kBookShelfItemCountOfRow) * self.itemSize.width, indexPath.section * kBookShelfDecorationViewHeight + currentRow * kBookShelfCellHeight, self.itemSize.width, kBookShelfCellHeight);
    attris.frame = frame;
    attris.zIndex = 1;
    
    return attris;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    
    id shelfRect = self.bookShelfRectanges[indexPath];
    
    // this should never happen, but just in case...
    if (!shelfRect) {
        return nil;
    }
    
    UICollectionViewLayoutAttributes *attributes =
    [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                withIndexPath:indexPath];
    attributes.frame = [shelfRect CGRectValue];
    //    NSLog(@"UICollectionViewLayoutAttributes :.%@", NSStringFromCGRect([shelfRect CGRectValue]));
    
    attributes.zIndex = -1; // shelves go behind other views
    
    return attributes;
}

- (CGSize)collectionViewContentSize {
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    CGFloat kBookShelfDecorationViewHeight = kBookShelfCellHeight + kBookShelfFooterViewHeight;
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, sectionCount * kBookShelfDecorationViewHeight);
    
    return contentSize;
}

@end
