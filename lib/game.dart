import 'dart:io';
import 'dart:math';
import 'package:menu_select/menu_select.dart';
import 'package:text_rpg/character.dart';
import 'package:text_rpg/monster.dart';

class Game {
  late Character character = Character(createPlayer());
  late int randomMonster;
  List<Monster> monsters = [];
  Random random = Random();
  int item = 1; //아이탬 개수수
  int turnCount = 0; //진행된 턴 횟수 카운트 기록

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

    monsters.clear(); //리스트 초기화
    final File monsterStats = File('assets/monsters.txt');
    String contents = await monsterStats.readAsString();
    List<String> monsterData =
        contents.split('\n').expand((line) => line.split(',')).toList();

    for (int i = 0; i + 3 < monsterData.length; i += 4) {
      monsters.add(Monster(
        monsterData[i].trim(),
        int.tryParse(monsterData[i + 1].trim()) ?? 0,
        random.nextInt(int.tryParse(monsterData[i + 2].trim()) ?? 0), //공격력 랜덤
        int.tryParse(monsterData[i + 3].trim()) ?? 0,
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

  void increaseMonsterDef() {
    //몬스터 방어력 증가
    monsters[randomMonster].def += 2;
    print('${monsters[randomMonster].name}의 방어력이 증가했습니다!');
    print('현재 방어력: ${monsters[randomMonster].def}');
  }

  void battle() async {
    bool playerTurn = true;
    bool isDef = false;

    while (character.hp > 0 && monsters[randomMonster].hp > 0) {
      if (playerTurn == true) {
        turnCount++;
        print('$turnCount번째 턴!');
        if (turnCount % 3 == 0) {
          //3번째 턴마다 몬스터 방어력 증가
          increaseMonsterDef();
        }
        print('==========');
        print('${character.name}님의 턴');
        print('==========');
        stdout.write('(1: 공격, 2: 방어, 3:아이템 사용)\n');
        String choice = menu(['1', '2', '3']);

        isDef = false;
        switch (choice) {
          case '1': //공격
            character.attackMonster(monsters[randomMonster]);
            break;
          case '2': //방어
            character.defend();
            isDef = true;
            break;
          case '3': //아이템 사용 후 공격
            if (item > 0) {
              character.atk *= 2;
              character.attackMonster(monsters[randomMonster]);
              character.atk ~/= 2;
              item--;
            } else {
              print('아이템이 없습니다.');
              character.attackMonster(monsters[randomMonster]);
            }
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
      result('lose');
    } else if (monsters[randomMonster].hp <= 0) {
      print('${monsters[randomMonster].name}을(를) 물리쳤습니다!');
      result('win');
      stdout.write('\n다음 몬스터와 싸우시겠습니까? (y/n)\n');
      String choice = menu(['y', 'n']);
      switch (choice) {
        case 'y':
          await loadMonsterStats();
          startGame();
          break;
        case 'n':
          print('게임을 종료합니다.');
          exit(0);
      }
    }
  }

  void result(String gameResult) async {
    File result = File('assets/result.txt');
    await result.writeAsString(
        '[${character.name} vs ${monsters[randomMonster].name}] ${gameResult}, ${character.hp}\n',
        mode: FileMode.append);
  }

  void getRandomMonster() {
    //랜덤으로 몬스터 선택
    randomMonster = random.nextInt(monsters.length);
    print('새로운 몬스터가 나왔습니다!');
    monsters[randomMonster].showStatus();
  }
}
