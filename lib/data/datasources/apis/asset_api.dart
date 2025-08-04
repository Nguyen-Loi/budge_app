import 'package:budget_app/core/providers.dart';
import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/data/models/asset_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetApiProvider = Provider((ref) {
  final db = ref.watch(dbProvider);
  return AssetApi(db: db);
});

class AssetApi {
  final FirebaseFirestore _db;
  AssetApi({
    required FirebaseFirestore db,
  }) : _db = db;

  Future<List<AssetModel>> fetch() async {
    final snapshot = await _db.collection(FirestorePath.assets).get();
    return snapshot.docs.map((doc) => AssetModel.fromMap(doc.data())).toList()
      ..sort((a, b) => a.index?.compareTo(b.index ?? 0) ?? 0);
  }

  
}
