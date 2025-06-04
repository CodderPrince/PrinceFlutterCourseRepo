import 'person.dart';
import 'role.dart';

class StudentRole implements Role {
  @override
  void displayRole() {
    print("Role: Student");
  }
}

class Student extends Person {
  final String studentID;
  final String grade;
  final List<double> courseScores;

  Student(String name, int age, String address, String studentID, String grade,
      List<double> courseScores)
      : this.studentID = studentID,
        this.grade = grade,
        this.courseScores = courseScores,
        super(name, age, address, StudentRole());

  double calculateAverageScore() {
    if (courseScores.isEmpty) {
      return 0.0;
    }
    double sum = courseScores.reduce((a, b) => a + b);
    return sum / courseScores.length;
  }

  void displayStudentInfo() {
    print("Student Information:");
    displayRole();
    print("Name: $name");
    print("Age: $age");
    print("Address: $address");
    print("Average Score: ${calculateAverageScore().toStringAsFixed(2)}");
  }
}
