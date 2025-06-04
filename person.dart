import 'role.dart';

class Person {
  final String name;
  final int age;
  final String address;
  final Role role;

  Person(this.name, this.age, this.address, this.role);

  String getName() => name;
  int getAge() => age;
  String getAddress() => address;

  void displayRole() {
    role.displayRole();
  }
}
