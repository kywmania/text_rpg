import 'package:text_rpg/character.dart';

class Monster {
  String name;
  int hp;
  int atk;

  Monster(this.name, this.hp, this.atk);

  void attackCharacter(Character character, bool isDef) {
    print('$name의 턴');
    if (isDef == true) {
      int damage = (atk - character.def > 0) ? (atk - character.def) : 0;
      character.hp -= (atk - character.def > 0) ? (atk - character.def) : 0;
      print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다.');
    } else {
      character.hp -= atk;
      print('$name이(가) ${character.name}에게 $atk의 데미지를 입혔습니다.');
    }
    character.showStatus();
    showStatus();
  }

  void showStatus() {
    print('$name - 체력: ${hp > 0 ? hp : 0}, 공격력: $atk');
  }
}
