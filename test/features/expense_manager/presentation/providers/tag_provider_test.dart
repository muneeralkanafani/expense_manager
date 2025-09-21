import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:expense_manager/features/expense_manager/domain/usecases/delete_tag.dart';
import 'package:expense_manager/features/expense_manager/domain/entites/tag.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/add_tag.dart';
import 'package:expense_manager/features/expense_manager/domain/usecases/get_tags.dart';
import 'package:expense_manager/features/expense_manager/presentation/providers/tag_provider.dart';

import 'tag_provider_test.mocks.dart';

@GenerateMocks([GetTags, AddTag, DeleteTag])
void main() {
  late MockGetTags mockGetTags;
  late MockAddTag mockAddTag;
  late MockDeleteTag mockDeleteTag;
  late TagProvider provider;

  final testTag1 = Tag(id: '1', name: 'Work');
  final testTag2 = Tag(id: '2', name: 'Personal');
  final testTagList = [testTag1, testTag2];

  setUp(() {
    mockGetTags = MockGetTags();
    mockAddTag = MockAddTag();
    mockDeleteTag = MockDeleteTag();

    when(mockGetTags.call()).thenAnswer((_) async => testTagList);

    provider = TagProvider(
      getTagsUC: mockGetTags,
      addTagUC: mockAddTag,
      deleteTagUC: mockDeleteTag,
    );
  });

  test('should load tags on initialization', () async {
    // arrange
    await Future.delayed(Duration.zero);
    // act
    final tags = provider.tags;
    // assert
    expect(tags, testTagList);
    verify(mockGetTags.call()).called(1);
  });

  test('should add a new tag if not exists', () async {
    // arrange
    final newTag = Tag(id: '3', name: 'Urgent');
    when(mockAddTag.call(newTag)).thenAnswer((_) async => Future.value());
    when(mockGetTags.call()).thenAnswer((_) async => [...testTagList, newTag]);
    // act
    await provider.addTag(newTag);
    // assert
    expect(provider.tags, contains(newTag));
    verify(mockAddTag.call(newTag)).called(1);
    verify(mockGetTags.call()).called(2);
  });

  test('should not add a tag if name already exists', () async {
    // arrange
    final duplicateTag = Tag(id: '4', name: 'Work');
    // act
    await provider.addTag(duplicateTag);
    // assert
    expect(provider.tags, testTagList);
    verifyNever(mockAddTag.call(duplicateTag));
  });

  test('should delete a tag', () async {
    // arrange
    when(mockDeleteTag.call('1')).thenAnswer((_) async => Future.value());
    when(mockGetTags.call()).thenAnswer((_) async => [testTag2]);
    // act
    await provider.deleteTag('1');
    // assert
    expect(provider.tags, [testTag2]);
    verify(mockDeleteTag.call('1')).called(1);
    verify(mockGetTags.call()).called(2); // one for _load, one after delete
  });
}
