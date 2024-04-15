import 'dart:io';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(storageProvider),
  );
});

abstract class IStorageAPI {
  FutureEither<String> uploadFile(File file, {required String filePath});
  FutureEither<List<String>> uploadFiles(List<File> files,
      {required String filePath});
}

class StorageAPI extends IStorageAPI {
  final FirebaseStorage _storage;
  StorageAPI({required FirebaseStorage storage}) : _storage = storage;

  @override
  FutureEither<String> uploadFile(File file, {required String filePath}) async {
    try {
      String fileName = '$filePath/${DateTime.now()}-${file.path}';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(file);
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
      return left(failured.getLeft().getOrElse(() => const Failure(error: 'Error when upload multiple file')));
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
