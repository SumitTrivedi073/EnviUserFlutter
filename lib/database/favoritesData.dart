import 'package:floor/floor.dart';

@entity
class FavoritesData {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String identifier;
final String title;
  final String address;

  final String isFavourite;
final String longitude;
  final String latitude;
  final DateTime timestamp;



  FavoritesData(this.id, this.identifier, this.address, this.isFavourite,this.longitude,this.latitude,this.title, this.timestamp);

  factory FavoritesData.optional({
    int? id,
    String? identifier,
    String? address,
    String? isFavourite,
    String? latitude,
    String? longitude,
    String? title,
    DateTime? timestamp,
  }) =>
      FavoritesData(
        id,
        identifier ?? 'Unidentifier',

        address ?? 'empty',
        isFavourite ?? "N",


        latitude ?? "",
        longitude ?? "",
        title ?? "",
        timestamp ?? DateTime.now(),

      );

  @override
  String toString() {
    return 'FavoritesData{id: $id, identifier: $identifier, address: $address, isFavourite: $isFavourite, latitude: $latitude, longitude:$longitude, title: $title, timestamp: $timestamp}';
  }

  FavoritesData copyWith({
    int? id,
    String? identifier,
    String? address,
    String? isFavourite,
    String? latitude,
    String? longitude,
    String? title,
    DateTime? timestamp,
  }) {
    return FavoritesData(
      id ?? this.id,
      identifier ?? this.identifier,
      address ?? this.address,
      isFavourite ?? this.isFavourite,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      title ?? this.title,
      timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FavoritesData &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              identifier == other.identifier &&
              address == other.address &&
              isFavourite == other.isFavourite && latitude == other.latitude && longitude == other.longitude && title == other.title && timestamp == other.timestamp;

  @override
  int get hashCode =>
      id.hashCode ^
      identifier.hashCode ^
      address.hashCode ^
      isFavourite.hashCode^
      latitude.hashCode^
       longitude.hashCode^
  title.hashCode ^
  timestamp.hashCode;

}