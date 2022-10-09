import 'package:freezed_annotation/freezed_annotation.dart';

import 'gear_type.dart';

part 'gear.freezed.dart';

/// A piece of gear usable by the user.
@freezed
class Gear with _$Gear {
  const factory Gear({
    /// Datetime of creation of this piece of gear.
    required DateTime creationTime,

    /// Type of gear.
    required GearType gearType,

    /// Name of this piece of gear.
    required String name,
  }) = _Gear;
}
