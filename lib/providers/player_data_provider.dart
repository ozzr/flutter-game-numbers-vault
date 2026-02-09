import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/player_data_service.dart';

/// ChangeNotifier para manejar datos del jugador
class PlayerDataNotifier extends ChangeNotifier {
  PlayerData? _playerData;

  PlayerData? get playerData => _playerData;

  Future<void> loadPlayerData(
    String playerName,
    PlayerDataService service,
  ) async {
    _playerData = await service.loadPlayerData(playerName);
    notifyListeners();
  }

  void updatePlayerData(PlayerData newData) {
    _playerData = newData;
    notifyListeners();
  }

  void addGameSession(
    PlayerData playerData,
    GameSession session,
    PlayerDataService service,
  ) {
    service.addGameSession(playerData, session);
    _playerData = playerData;
    notifyListeners();
  }
}
