import 'package:hive/hive.dart';

import '../../domain/capture_job_status.dart';

class CaptureJobStatusAdapter extends TypeAdapter<CaptureJobStatus> {
  @override
  final int typeId = 3;

  @override
  CaptureJobStatus read(BinaryReader reader) {
    return CaptureJobStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, CaptureJobStatus obj) {
    writer.writeByte(obj.index);
  }
}
