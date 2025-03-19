import 'package:text_rpg/monster.dart';
import 'dart:math';

class Character {
  String name;
  int hp;
  int atk;
  int def;

  Character(this.name, {this.hp = 50, this.atk = 10, this.def = 5});

  void attackMonster(Monster monster) {
    Random random = Random();
    int critical = random.nextInt(10);

    int damage = (atk - monster.def) > 0 ? (atk - monster.def) : 0;
    if (critical == 0) {
      //10%확률로 크리티컬
      print('[크리티컬] 2배의 데미지를 입힙니다.');
      damage *= 2;
    }
    monster.hp -= damage;
    print('$name이(가) ${monster.name}에게 ${damage}의 데미지를 입혔습니다.');
    monster.showStatus();
  }

  void defend() {
    print('$name이(가) 방어 태세를 취하였습니다.');
  }

  void showStatus() {
    //체력이 0보다 작으면 0으로 표시
    print('$name - 체력: ${hp > 0 ? hp : 0}, 공격력: $atk, 방어력: $def');
  }
}
