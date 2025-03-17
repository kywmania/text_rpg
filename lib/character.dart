import 'package:text_rpg/monster.dart';

class Character {
  String name;
  int hp;
  int atk;
  int def;

  Character(this.name, {this.hp = 50, this.atk = 10, this.def = 5});

  void attackMonster(Monster monster) {
    monster.hp -= atk;
    print('$name이(가) ${monster.name}에게 $atk의 데미지를 입혔습니다.');
    monster.showStatus();
  }

  void defend() {
    print('$name이(가) 방어 태세를 취하였습니다.');
  }

  void showStatus() {
    print('$name - 체력: ${hp > 0 ? hp : 0}, 공격력: $atk, 방어력: $def');
  }
}
