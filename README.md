# Employee Management App

A Flutter-based application for managing employee records with local storage capabilities and a modern, responsive UI.

## 🚀 Features

- Add new employees with detailed information
- Update existing employee records
- Delete employees with undo functionality
- View employees categorized as Current or Previous
- Offline-first with local data persistence
- Responsive and intuitive user interface

## 🛠️ Technical Stack

- **Flutter** - UI framework
- **BLoC** - State management
- **ObjectBox** - Local database

## 📁 Project Structure

```
lib/
├── bloc/                     
│   ├── employee_bloc.dart    # Business logic
│   ├── employee_event.dart   # Event definitions
│   └── employee_state.dart   # State definitions
├── models/                   
│   └── employee.dart         # Data models
├── screens/                  
│   ├── employee_list_screen.dart
│   └── add_edit_employee_screen.dart
├── widgets/                  
└── objectbox.dart            # Database configuration
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (2.10.0 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/employee-management-app.git
cd employee-management-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate ObjectBox code
```bash
flutter pub run build_runner build
```

4. Run the app
```bash
flutter run
```

## 💡 Usage

### Managing Employees

- **View**: Employees are automatically categorized as Current or Previous
- **Add**: Tap the + button and fill in the employee details
- **Edit**: Tap any employee card to modify their information
- **Delete**: Swipe left on an employee card (includes undo option)

### State Management

The app uses BLoC pattern with the following main components:

#### Events
- `LoadEmployees`: Fetch all records
- `AddEmployee`: Create new record
- `UpdateEmployee`: Modify existing record
- `DeleteEmployee`: Remove record

#### States
- `EmployeeInitial`: Starting state
- `EmployeeLoading`: Processing state
- `EmployeesLoaded`: Success state
- `EmployeeError`: Error state

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
```bash
git checkout -b feature/amazing-feature
```
3. Commit your changes
```bash
git commit -m "Add amazing feature"
```
4. Push to the branch
```bash
git push origin feature/amazing-feature
```
5. Open a Pull Request



## 👏 Acknowledgments

- [Flutter](https://flutter.dev) - UI framework
- [ObjectBox](https://objectbox.io) - Database solution
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
