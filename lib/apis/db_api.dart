// import 'package:budget_app/constants/field_constants.dart';
// import 'package:budget_app/core/core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fpdart/fpdart.dart';

// abstract class IDbApi {
//   FutureEither<List<Map<String, dynamic>>> getData(String tableName);
//   StreamEither<List<Map<String, dynamic>>> streamGetData(String tableName);
//   FutureEither<Map<String, dynamic>> getDocumentById(String tableName,
//       {required Object value});
//   FutureEither<Map<String, dynamic>> getDocumentByIdWithField(String tableName,
//       {required Object value, required String fieldName});
//   FutureEitherVoid removeDocument(String tableName, {required String id});
//   FutureEitherVoid addDocument(String tableName,
//       {required String id,
//       required Map data,
//       String? customID,
//       String? fieldWriteID});
//   FutureEitherVoid updateDocument(String tableName,
//       {required String id, required Map data});
//   FutureEither<bool> isDocumentExits(String tableName, {required String id});
// }

// class DbApi implements IDbApi {
//   final FirebaseFirestore _firestore;
//   DbApi(
//       {required FirebaseFirestore firestore, required FirebaseStorage storage})
//       : _firestore = firestore;

//   @override
//   FutureEitherVoid addDocument(String tableName,
//       {required String id,
//       required Map data,
//       String? customID,
//       String? fieldWriteID}) async {
//     try {
//       Map<String, Object> newData = Map.from({
//         ...data,
//         ...{FieldConstants.createdDate: DateTime.now()},
//         ...{FieldConstants.updatedAt: DateTime.now()}
//       });

//       if (customID == null) {
//         _firestore.collection(tableName).add(newData).then((value) {
//           if (fieldWriteID != null) {
//             updateDocument(tableName,
//                 data: {fieldWriteID: value.id}, id: value.id);
//           }
//         });
//       } else {
//         _firestore
//             .collection(tableName)
//             .doc(customID)
//             .set(newData)
//             .then((value) {
//           if (fieldWriteID != null) {
//             updateDocument(tableName,
//                 data: {fieldWriteID: customID}, id: customID);
//           }
//         });
//       }
//       return right(null);
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   FutureEither<List<Map<String, dynamic>>> getData(String tableName) async {
//     try {
//       QuerySnapshot<Object?> data =
//           await _firestore.collection(tableName).get();
//       return right(data.toListMap());
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   FutureEither<Map<String, dynamic>> getDocumentById(String tableName,
//       {required Object value}) async {
//     try {
//       var queryData =
//           await _firestore.collection(tableName).doc(value.toString()).get();
//       return right(queryData.toMap());
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   FutureEither<Map<String, dynamic>> getDocumentByIdWithField(String tableName,
//       {required Object value, required String fieldName}) async {
//     try {
//       Map<String, dynamic> data;
//       var queryData = await _firestore
//           .collection(tableName)
//           .where(fieldName, isEqualTo: value)
//           .get();
//       data = queryData.toListMap().first;

//       return right(data);
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   FutureEither<bool> isDocumentExits(String tableName,
//       {required String id}) async {
//     bool exists = false;
//     try {
//       var documentSnapshot = await _firestore.doc(id).get();
//       exists = documentSnapshot.exists;
//       return right(exists);
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   FutureEitherVoid removeDocument(String tableName,
//       {required String id}) async {
//     try {
//       await _firestore.collection(tableName).doc(id).delete();
//       return right(null);
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }

//   @override
//   StreamEither<List<Map<String, dynamic>>> streamGetData(String tableName) {
//     return (_firestore.collection(tableName).snapshots().map((querySnapshot) {
//       try {
//         return right(querySnapshot.toListMap()); 
//       } catch (e) {
//         return left(const Failure(
//             error:
//                 "Failed to retrieve data")); 
//       }
//     }));
//   }

//   @override
//   FutureEitherVoid updateDocument(String tableName,
//       {required String id, required Map data}) async {
//     try {
//       data[FieldConstants.updatedAt] = DateTime.now();
//       await _firestore.collection(tableName).doc(id).update(Map.from(data));
//       return right(null);
//     } catch (e) {
//       return left(Failure(error: e.toString()));
//     }
//   }
// }

// extension ConvertDocument on DocumentSnapshot<Object?> {
//   Map<String, dynamic> toMap() {
//     Map<String, dynamic> temp = {};
//     temp[FieldConstants.id] = id;
//     temp.addAll(data() as Map<String, dynamic>);
//     return temp;
//   }
// }

// extension ConvertDocumentRe on DocumentReference<Object?> {
//   Future<Map<String, dynamic>> toMap() async {
//     final snapshot = await get();
//     Map<String, dynamic> temp = {};
//     temp[FieldConstants.id] = snapshot.id;
//     temp.addAll(snapshot.data() as Map<String, dynamic>);
//     return temp;
//   }
// }

// extension QuerySnapshotToList on QuerySnapshot<Object?> {
//   List<Map<String, dynamic>> toListMapCustom() {
//     List<Map<String, dynamic>> temp = [];
//     for (var e in docs) {
//       Map<String, dynamic> currentValue = e.data() as Map<String, dynamic>;
//       currentValue[FieldConstants.id] = e.id;
//       //UserID
//       currentValue[FieldConstants.refId] = e.reference.parent.parent!.id;
//       temp.add(currentValue);
//     }
//     return temp;
//   }

//   List<Map<String, dynamic>> toListMap() {
//     List<Map<String, dynamic>> temp = [];
//     for (var e in docs) {
//       Map<String, dynamic> currentValue = e.data() as Map<String, dynamic>;
//       currentValue[FieldConstants.id] = e.id;
//       temp.add(currentValue);
//     }
//     return temp;
//   }
// }
