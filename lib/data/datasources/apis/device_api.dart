import 'package:budget_app/data/datasources/apis/firestore_path.dart';
import 'package:budget_app/core/devices/devices.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/data/models/device_model/device_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceAPIProvider = Provider((ref) {
  return DeviceApi(db: ref.watch(dbProvider));
});

abstract class IDeviceApi {
  Future<List<DeviceModel>> getAllByUserId(String uid);
  Future<void> writeDeviceInfo(String uid);
}

class DeviceApi implements IDeviceApi {
  final FirebaseFirestore db;
  DeviceApi({
    required this.db,
  });

  @override
  Future<List<DeviceModel>> getAllByUserId(String uid) async {
    final data = await db
        .collection(FirestorePath.devices(uid: uid))
        .mapModel<DeviceModel>(
            modelFrom: DeviceModel.fromMap, modelTo: (model) => model.toMap())
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  @override
  Future<void> writeDeviceInfo(String uid) async {
    Devices device = Devices();
    final currentDevice = await device.infoDevice(uid);
    final allDeviceOfSignIn = await getAllByUserId(uid);
    if (currentDevice.infoDeviceIsExist(allDeviceOfSignIn) == false) {
       db
          .collection(FirestorePath.devices(uid: uid))
          .doc(GenId.device())
          .set(currentDevice.toMap());
    }
  }
}
