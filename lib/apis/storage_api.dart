import 'dart:io';

import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:budget_app/localization/app_localizations_provider.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final storageAPIProvider = Provider((ref) {
  return StorageApi(
    storage: ref.watch(storageProvider),
    ref: ref
  );
});

abstract class IStorageAPI {
  FutureEither<String> uploadFile(File file, {required String filePath});
  FutureEither<List<String>> uploadFiles(List<File> files,
      {required String filePath});
}

class StorageApi extends IStorageAPI {
  final FirebaseStorage _storage;
  final ProviderRef<Object?> _ref;
  StorageApi(
      {required FirebaseStorage storage, required ProviderRef<Object?> ref})
      : _storage = storage,
        _ref = ref;

  @override
  FutureEither<String> uploadFile(File file, {required String filePath}) async {
    try {
      String fileName = file.path.split('/').last;
      String path =
          '$filePath/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      UploadTask uploadTask = _storage.ref().child(path).putFile(file);
      String url = await (await uploadTask).ref.getDownloadURL();
      return right(url);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  @override
  FutureEither<List<String>> uploadFiles(List<File> files,
      {required String filePath}) async {
    List<Either<Failure, String>> imageUrls =
        await Future.wait(files.map((e) => uploadFile(e, filePath: filePath)));
    Either<Failure, String>? failured =
        imageUrls.firstWhereOrNull((element) => element.isLeft());
    if (failured != null) {
      return left(failured
          .getLeft()
          .getOrElse(() => Failure(error: _ref.read(appLocalizationsProvider).errorUploadFiles)));
    }
    List<String> urls = [];
    for (final imageUrl in imageUrls) {
      List<String> urls = [];
      imageUrl.fold(
        (_) {},
        (url) {
          urls.add(url);
        },
      );
    }
    return right(urls);
  }
}
