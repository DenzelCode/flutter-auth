import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/features/room/logic/provider/room_api_provider.dart';

class RoomRepository {
  final _provider = RoomAPIProvider();

  Future<Room> getRoom(String roomId) async {
    return _provider.getRoom(roomId);
  }

  Future<List<Room>> getPublicRooms() async {
    return _provider.getPublicRooms();
  }

  Future<List<Room>> getRoomsByMember() async {
    return _provider.getRoomsByMember();
  }

  Future<List<Room>> getUserRooms() async {
    return _provider.getUserRooms();
  }

  Future<Room> createRoom({
    required String title,
    required bool isPublic,
  }) async {
    return _provider.createRoom(
      title: title,
      isPublic: isPublic,
    );
  }

  deleteRoom(String roomId) {
    return _provider.deleteRoom(roomId);
  }

  Future<Room> updateRoom(
    String roomId, {
    required String title,
    required bool isPublic,
  }) async {
    return _provider.updateRoom(
      roomId,
      title: title,
      isPublic: isPublic,
    );
  }

  Future<Room> joinRoom(String roomId) async {
    return _provider.joinRoom(roomId);
  }

  Future<Room> leaveRoom(String roomId) async {
    return _provider.leaveRoom(roomId);
  }
}
