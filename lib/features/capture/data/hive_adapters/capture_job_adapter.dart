import 'package:hive/hive.dart';

import '../../domain/capture_job.dart';
import '../../domain/capture_job_status.dart';
import '../../domain/capture_job_type.dart';

class CaptureJobAdapter extends TypeAdapter<CaptureJob> {
  @override
  final int typeId = 1;

  @override
  CaptureJob read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaptureJob(
      id: fields[0] as String,
      type: CaptureJobType.values[fields[1] as int],
      imagePath: fields[2] as String?,
      barcode: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime?,
      status: CaptureJobStatus.values[fields[6] as int],
      attempts: fields[7] as int,
      lastError: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CaptureJob obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type.index)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.barcode)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.status.index)
      ..writeByte(7)
      ..write(obj.attempts)
      ..writeByte(8)
      ..write(obj.lastError);
  }
}
