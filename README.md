# Esmorga
Esmorga is a SwiftUI based application ussing MVVM pattern and Clean Architecture principles. This is app is created to manage the Accenture Coruña Mobile Studio events.

# Architecture
## MVVM (Model-View-ViewModel)
* **Model:** Represents the data and business logic of the application.
* **View:** The UI components that display data and interact with the user.
* **ViewModel:** Acts as a mediator between the Model and the View, handling the presentation logic.

## Clean Architecture
* **Use Cases:** Application-specific business rules.
* **Repositories:** Abstractions for data access.
* **Data Sources:** Concrete implementations for data access (e.g., network, database).

![MVVM+Clean](https://github.com/user-attachments/assets/0a08ff82-058c-41ba-b1a2-7c752ca6b3c0)

### Data Flow
1. **View** calls method from **ViewModel**.
2. **ViewModel** executes **Use Case**
3. **Use Case** request and combines data from **Repository** or **Repositories**
4. **Repository** returns data from Local or Remote **Datasources**
5. Data flows back across all the layers to the **View** where data is displayed.

### Dependency Direction
* **Presentation Layer (MVVM)**: ViewModels + Views
* **Domain Layer**: Use Cases
* **Data Layer**: Repositories + Datasources (DAO, Service)  

Presentation Layer -> Domain Layer <- Data Layer

# Navigation
TO DO

# Testing strategic
TO DO



This project is tested with BrowserStack