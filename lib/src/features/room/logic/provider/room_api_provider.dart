import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/shared/logic/http/api.dart';

class RoomAPIProvider {
  Future<Room> getRoom(String roomId) async {
    final response = await api.get('/room/id/$roomId');

    return Room.fromJson(response.data);
  }

  Future<List<Room>> getPublicRooms() async {
    final response = await api.get('/room/public');

    return Room.fromList(response.data);
  }

  Future<List<Room>> getRoomsByMember() async {
    final response = await api.get('/room/member');

    return Room.fromList(response.data);
  }

  Future<List<Room>> getUserRooms() async {
    final response = await api.get('/room');

    return Room.fromList(response.data);
  }

  Future<Room> createRoom({
    required String title,
    required bool isPublic,
  }) async {
    final response = await api.post(
      '/room',
      data: {
        'title': title,
        'isPublic': isPublic,
      },
    );

    return Room.fromJson(response.data);
  }

  deleteRoom(String roomId) {
    return api.delete('/room/delete/$roomId');
  }

  Future<Room> updateRoom(
    String roomId, {
    required String title,
    required bool isPublic,
  }) async {
    final response = await api.put(
      '/room/$roomId',
      data: {
        'title': title,
        'isPublic': isPublic,
      },
    );

    return Room.fromJson(response.data);
  }

  Future<Room> joinRoom(String roomId) async {
    final response = await api.post(
      '/room/join',
      data: {
        'roomId': roomId,
      },
    );

    return Room.fromJson(response.data);
  }

  Future<Room> leaveRoom(String roomId) async {
    final response = await api.post('/room/leave/$roomId');

    return Room.fromJson(response.data);
  }
}
