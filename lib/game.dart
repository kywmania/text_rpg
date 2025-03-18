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
    //캐릭터 스탯 불러오기
    final File characterStats = File('assets/character.txt');
    String contents = await characterStats.readAsString();
    List<String> characterData = contents.split(',');

    character.hp = int.tryParse(characterData[0]) ?? 0;
    character.atk = int.tryParse(characterData[1]) ?? 0;
    character.def = int.tryParse(characterData[2]) ?? 0;

    bonus();
  }

  Future<void> loadMonsterStats() async {
    //몬스터 스탯 불러오기
    final File monsterStats = File('assets/monsters.txt');
    String contents = await monsterStats.readAsString();
    List<String> monsterData = contents.split(',');

    monsters.clear(); //리스트 초기화
    for (int i = 0; i + 2 < monsterData.length; i += 3) {
      monsters.add(Monster(
        monsterData[i].trim(),
        int.tryParse(monsterData[i + 1].trim()) ?? 0,
        random.nextInt(int.tryParse(monsterData[i + 2].trim()) ?? 0), //공격력 랜덤
      ));
    }
  }

  void bonus() {
    //캐릭터 로드 시 30%확률로 보너스 체력 10 증가
    int bonus = random.nextInt(10);
    if (bonus >= 0 && bonus <= 2) {
      character.hp += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.hp}');
    }
  }

  String createPlayer() {
    //캐릭터 이름 생성
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
    int itemEffect = 2; //아이템 효과(공격력 2배) - atk = atk*item

    while (character.hp > 0 && monsters[randomMonster].hp > 0) {
      if (playerTurn == true) {
        String choice = action();
        isDef = false;
        switch (choice) {
          case '1': //공격
            character.attackMonster(monsters[randomMonster], 1);
            break;
          case '2': //방어
            character.defend();
            isDef = true;
            break;
          case '3': //아이템 사용 - 공격력 2배인 상태로 공격
            character.attackMonster(monsters[randomMonster], itemEffect);
            break;
        }
        playerTurn = !playerTurn; //턴 넘기기
      } else {
        monsters[randomMonster].attackCharacter(character, isDef);
        playerTurn = !playerTurn;
      }
      itemEffect = 1;
    }

    if (character.hp <= 0) {
      print('플레이어가 사망했습니다.');
      result('lose');
    } else if (monsters[randomMonster].hp <= 0) {
      print('${monsters[randomMonster].name}을(를) 물리쳤습니다!');
      result('win');
      stdout.write('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
      String? choice = stdin.readLineSync() ?? '';
      if (choice == 'y') {
        await loadCharacterStats();
        await loadMonsterStats();
        startGame();
      }
    }
  }

  void result(String gameResult) async {
    File result = File('assets/result.txt');
    await result.writeAsString(
        '${character.name}, ${character.hp}, ${gameResult}\n',
        mode: FileMode.append);
  }

  String action() {
    print('${character.name}님의 턴');
    stdout.write('행동을 선택하세요 (1: 공격, 2: 방어, 3:아이템 사용): ');
    String? action = stdin.readLineSync() ?? '';
    return action;
  }

  void getRandomMonster() {
    randomMonster = random.nextInt(monsters.length);
    print('새로운 몬스터가 나왔습니다!');
    monsters[randomMonster].showStatus();
  }
}
