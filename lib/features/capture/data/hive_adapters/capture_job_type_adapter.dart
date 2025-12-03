import 'package:hive/hive.dart';

import 'package:qkomo_ui/features/capture/domain/capture_job_type.dart';

class CaptureJobTypeAdapter extends TypeAdapter<CaptureJobType> {
  @override
  final int typeId = 4;

  @override
  CaptureJobType read(BinaryReader reader) {
    return CaptureJobType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, CaptureJobType obj) {
    writer.writeByte(obj.index);
  }
}
