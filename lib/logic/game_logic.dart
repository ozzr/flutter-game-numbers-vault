import 'dart:math';

class RandomNumberStore {
  late List<int> _storedNumbers;
  int length;

  RandomNumberStore(this.length) {
    _storedNumbers = _generateRandomNumbers(length);
  }

  /// Genera una lista de números aleatorios de un dígito (0-9)
  List<int> _generateRandomNumbers(int length) {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10));
  }

  /// Devuelve los números almacenados
  List<int> get storedNumbers => _storedNumbers;

  /// Valida una lista de números contra los almacenados
  bool validate(List<int> numbers) {
    for (var num in numbers) {
      if (!_storedNumbers.contains(num)) {
        return false;
      }
    }
    return true;
  }

  /// Proporciona hints:
  /// - correctPosition: cuántos dígitos están en la posición correcta
  /// - wrongPosition: cuántos dígitos existen en la lista pero en otra posición
  Map<String, int> hints(List<int> guess) {
    int correctPosition = 0;
    int wrongPosition = 0;

    for (int i = 0; i < length && i < guess.length; i++) {
      if (guess[i] == _storedNumbers[i]) {
        correctPosition++;
      } else if (_storedNumbers.contains(guess[i])) {
        wrongPosition++;
      }
    }

    return {
      "correctPosition": correctPosition,
      "wrongPosition": wrongPosition,
    };
  }
}

// void main() {
//   var store = RandomNumberStore(4);
//   print("Números generados: ${store.storedNumbers}");

//   var guess = [store.storedNumbers[0], 9, store.storedNumbers[2], 8, 7];
//   var result = store.hints(guess);
//   print("Guess: $guess");
//   print("Hints: $result");
// }