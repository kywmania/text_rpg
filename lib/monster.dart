import 'package:text_rpg/character.dart';

class Monster {
  String name;
  int hp;
  int atk;
  int def;

  Monster(this.name, this.hp, this.atk, this.def);

  void attackCharacter(Character character, bool isDef) {
    print('$name의 턴');
    if (isDef == true) {
      int damage = (atk - character.def > 0) ? (atk - character.def) : 0;
      character.hp -= damage;
      print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
    } else {
      character.hp -= atk;
      print('$name이(가) ${character.name}에게 $atk의 데미지를 입혔습니다.');
    }
    character.showStatus();
    showStatus();
  }

  void showStatus() {
    //체력이 0보다 작으면 0으로 표시
    print('$name - 체력: ${hp > 0 ? hp : 0}, 공격력: $atk, 방어력: $def');
  }
}
