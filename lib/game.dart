import 'dart:io';
import 'dart:math';
import 'package:text_rpg/character.dart';
import 'package:text_rpg/monster.dart';

class Game {
  late Character character = Character(createPlayer());
  late int randomMonster;
  List<Monster> monsters = [];
  Random random = Random();

  Future<void> loadCharacterStats() async {
    File characterStats = File('assets/character.txt');
    String contents = await characterStats.readAsString();
    List<String> characterData = contents.split(',');

    character.hp = int.tryParse(characterData[0]) ?? 0;
    character.atk = int.tryParse(characterData[1]) ?? 0;
    character.def = int.tryParse(characterData[2]) ?? 0;
  }

  Future<void> loadMonsterStats() async {
    File monsterStats = File('assets/monsters.txt');
    String contents = await monsterStats.readAsString();
    List<String> monsterData = contents.split(',');

    for (int i = 0; i + 2 < monsterData.length; i += 3) {
      monsters.add(Monster(
        monsterData[i].trim(),
        int.tryParse(monsterData[i + 1].trim()) ?? 0,
        random.nextInt(int.tryParse(monsterData[i + 2].trim()) ?? 0), //공격력 랜덤덤
      ));
    }
  }

  String createPlayer() {
    String playerName = '';
    RegExp regex = RegExp(r'^[a-zA-Z]+$'); //영문만 허용

    do {
      stdout.write('캐릭터의 이름을 입력하세요(영문): ');
      playerName = stdin.readLineSync() ?? '';
    } while (!regex.hasMatch(playerName));

    print('게임을 시작합니다!');
    return playerName;
  }

  void startGame() {
    character.showStatus();
    getRandomMonster();
    battle();
  }

  //monster[0] random값으로 바꾸기
  void battle() async {
    bool playerTurn = true;
    bool isDef = false;

    while (character.hp > 0 && monsters[randomMonster].hp > 0) {
      if (playerTurn == true) {
        String choice = action();
        isDef = false;
        switch (choice) {
          case '1':
            character.attackMonster(monsters[randomMonster]);
            break;
          case '2':
            character.defend();
            isDef = true;
            break;
        }
        playerTurn = !playerTurn; //턴 넘기기
      } else {
        monsters[randomMonster].attackCharacter(character, isDef);
        playerTurn = !playerTurn;
      }
    }

    if (character.hp <= 0) {
      print('플레이어가 사망했습니다.');
    } else if (monsters[randomMonster].hp <= 0) {
      print('${monsters[randomMonster].name}을(를) 물리쳤습니다!');
      stdout.write('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? choice = stdin.readLineSync() ?? '';
      if (choice == 'y') {
        await loadMonsterStats();
        startGame();
      }
    }
  }

  String action() {
    print('${character.name}님의 턴');
    stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
    String? action = stdin.readLineSync() ?? '';
    return action;
  }

  void getRandomMonster() {
    randomMonster = random.nextInt(monsters.length);
    print('새로운 몬스터가 나왔습니다!');
    monsters[randomMonster].showStatus();
  }
}
