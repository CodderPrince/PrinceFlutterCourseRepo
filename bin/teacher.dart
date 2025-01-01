import 'person.dart';
import 'role.dart';

//override displayRole
class TeacherRole implements Role {
  @override
  void displayRole() {
    print("Role: Teacher");
  }
}

//create teacher class
class Teacher extends Person {
  //attributes
  final int teacherID; //assume for numeric numbers only
  final List<String> coursesTaught;

//constructor
  Teacher(String name, int age, String address, int teacherID,
      List<String> coursesTaught)
      : this.teacherID = teacherID,
        this.coursesTaught = coursesTaught,
        super(name, age, address, TeacherRole());

  //display courses taught
  void disCT() {
    print("Courses Taught:");
    for (var course in coursesTaught) {
      print("- $course");
    }
  }

//teacher info
  void disTI() {
    print("Teacher Information:");
    displayRole();
    print("Name: $name");
    print("Age: $age");
    print("Address: $address");
    //print("Teacher ID: $teacherID");
    disCT();
  }
}
