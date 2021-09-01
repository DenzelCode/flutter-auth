import 'package:auth/src/features/auth/logic/models/user.dart';
import 'package:auth/src/features/room/logic/models/room.dart';
import 'package:auth/src/shared/logic/http/api.dart';

class RoomAPIProvider {
  Future<Room<User, User>> getRoom(String roomId) async {
    final response = await api.get('/room/id/$roomId');

    return Room.fromJson(response.data);
  }

  Future<List<Room<String, User>>> getPublicRooms() async {
    final response = await api.get('/room/public');

    return Room.fromList(response.data);
  }

  Future<List<Room<String, User>>> getRoomsByMember() async {
    final response = await api.get('/room/member');

    return Room.fromList(response.data);
  }

  Future<List<Room<String, String>>> getUserRooms() async {
    final response = await api.get('/room');

    return Room.fromList(response.data);
  }

  Future<Room<String, String>> createRoom({
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

  Future<Room<String, User>> updateRoom(
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

  Future<Room<User, User>> joinRoom(String roomId) async {
    final response = await api.post(
      '/room/join',
      data: {
        'roomId': roomId,
      },
    );

    return Room.fromJson(response.data);
  }

  Future<Room<User, User>> leaveRoom(String roomId) async {
    final response = await api.post('/room/leave/$roomId');

    return Room.fromJson(response.data);
  }
}
