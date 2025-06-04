import 'person.dart';
import 'role.dart';

class TeacherRole implements Role {
  @override
  void displayRole() {
    print("Role: Teacher");
  }
}

class Teacher extends Person {
  final String teacherID;
  final List<String> coursesTaught;

  Teacher(String name, int age, String address, String teacherID,
      List<String> coursesTaught)
      : this.teacherID = teacherID,
        this.coursesTaught = coursesTaught,
        super(name, age, address, TeacherRole());

  void displayCoursesTaught() {
    print("Courses Taught:");
    for (var course in coursesTaught) {
      print("- $course");
    }
  }

  void displayTeacherInfo() {
    print("Teacher Information:");
    displayRole();
    print("Name: $name");
    print("Age: $age");
    print("Address: $address");
    print("Teacher ID: $teacherID");
    displayCoursesTaught();
  }
}
