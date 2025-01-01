import 'role.dart';

//create person class
class Person {
  //attributes
  String name;
  int age;
  String address;

  //reference
  Role role;

  //constructor
  Person(this.name, this.age, this.address, this.role);

//getter methods
  String getName() => name;

  int getAge() => age;

  String getAddress() => address;

//role abstract methods
  void displayRole() {
    role.displayRole();
  }
}
