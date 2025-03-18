import 'dart:io';

void main() async {
  try {
    File file = File('assets/test.txt'); // 상위 폴더로 이동 후 assets 폴더 접근
    String contents = await file.readAsString();
    print(contents);
  } catch (e) {
    print('파일을 읽는 중 오류 발생: $e');
  }
}
