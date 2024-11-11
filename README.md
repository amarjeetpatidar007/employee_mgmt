# Employee Management App

A modern, responsive Flutter-based application for managing employee records with local storage and cloud-based deployment.

## 🚀 Features

1. **Local Data Storage**: The app uses Hive, a fast and lightweight NoSQL database, for offline-first data persistence.
2. **Cloud Deployment**: The app is integrated with Firebase Hosting for easy and reliable cloud-based deployment.
3. **Intuitive UI**: The user interface is built with a clean, modern design using the Flutter framework.
4. **CRUD Operations**: Users can add, update, delete, and view employee records.
5. **Employee Categorization**: Employees are automatically categorized as "Current" or "Previous" based on their employment status.
6. **Responsive Design**: The app adapts to different screen sizes and devices, providing a seamless experience across mobile and web.

## 🛠️ Technical Stack

- **Flutter** - UI framework
- **Hive** - NoSQL database for local data storage
- **Firebase** - Hosting platform for cloud deployment
- **BLoC** - State management solution

## 📁 Project Structure

```
lib/
├── bloc/
│   ├── employee_bloc.dart
│   ├── employee_event.dart
│   └── employee_state.dart
├── models/
│   └── employee.dart
├── repositories/
│   └── employee_repository.dart
├── screens/
│   ├── employee_list_screen.dart
│   └── add_edit_employee_screen.dart
├── widgets/
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (2.10.0 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ)
- Firebase account and project

### Installation

1. Clone the repository:

```bash
git clone https://github.com/amarjeetpatidar007/employee_mgmt.git
cd employee-management-app
```

2. Set up Firebase:
   - Create a new Firebase project in the Firebase console.
   - Enable Firebase Hosting.
   - Obtain the Firebase configuration details and update the `firebase_options.dart` file.

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## 💡 Usage

### Managing Employees

- **View**: Employees are automatically categorized as "Current" or "Previous" on the main screen.
- **Add**: Tap the "+" button to create a new employee record.
- **Edit**: Tap on an employee card to modify their information.
- **Delete**: Swipe left on an employee card to remove the record (includes undo option).

### State Management

The app uses the BLoC pattern for state management, with the following main components:

#### Events

- `LoadEmployees`: Fetch all employee records from the local database.
- `AddEmployee`: Create a new employee record.
- `UpdateEmployee`: Modify an existing employee record.
- `DeleteEmployee`: Remove an employee record.

#### States

- `EmployeeInitial`: Starting state.
- `EmployeeLoading`: Processing state.
- `EmployeesLoaded`: Success state with the list of employees.
- `EmployeeError`: Error state.

## 🤝 Contributing

1. Fork the repository.
2. Create your feature branch: `git checkout -b feature/amazing-feature`.
3. Commit your changes: `git commit -m "Add amazing feature"`.
4. Push to the branch: `git push origin feature/amazing-feature`.
5. Open a pull request.

## 👏 Acknowledgments

- [Flutter](https://flutter.dev) - UI framework
- [Hive](https://docs.hivedb.dev/) - NoSQL database
- [Firebase](https://firebase.google.com/) - Hosting platform
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
