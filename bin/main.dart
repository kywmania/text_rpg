import 'package:text_rpg/game.dart';

void main() async {
  Game game = Game();
  await game.loadMonsterStats();
  await game.loadCharacterStats();
  game.startGame();
}
