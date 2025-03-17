import 'dart:io';
import 'dart:math';
import 'package:text_rpg/character.dart';
import 'package:text_rpg/monster.dart';

class Game {
  late Character character = Character(createPlayer());

  List<Monster> monster = [
    Monster('spider'),
    Monster('bat'),
  ];
  late int randomMonster;

  String createPlayer() {
    String playerName = '';
    RegExp regex = RegExp(r'^[a-zA-Z]+$'); // 영문만 허용

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
  void battle() {
    bool playerTurn = true;
    bool isDef = false;

    while (character.hp > 0 && monster[randomMonster].hp > 0) {
      if (playerTurn == true) {
        String choice = action();
        isDef = false;
        switch (choice) {
          case '1':
            character.attackMonster(monster[randomMonster]);
            break;
          case '2':
            character.defend();
            isDef = true;
            break;
        }
        playerTurn = !playerTurn; //턴 넘기기
      } else {
        monster[randomMonster].attackCharacter(character, isDef);
        playerTurn = !playerTurn;
      }
    }

    if (character.hp <= 0) {
      print('플레이어가 사망했습니다.');
    } else if (monster[randomMonster].hp <= 0) {
      print('${monster[randomMonster].name}을(를) 물리쳤습니다!');
      print('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
      //y입력
      startGame();
    }
  }

  String action() {
    print('${character.name}님의 턴');
    stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
    String? action = stdin.readLineSync() ?? '';
    return action;
  }

  void getRandomMonster() {
    Random random = Random();
    randomMonster = random.nextInt(monster.length);
    print('새로운 몬스터가 나왔습니다!');
    monster[randomMonster].showStatus();
  }
}
