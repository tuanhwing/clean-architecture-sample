# Clean Architecture & Flutter

Flutter template project to explore the `Clean architecture` and manage the Flutter project to make scalable with a `modularization` approach.

## Getting Started

This project is a starting point for a Flutter application.

-  Use [th_core](https://github.com/tuanhwing/th_core) packages to implement `BLoC pattern`.
   -  Use [th_network](https://github.com/tuanhwing/th_core) to perform all network requests in application.
      - Using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) to store `access_token` and `refresh_token`.
      - Auto refresh token and retry when `access_token` expired.
      - Present dialog notify session expired when `refresh_token` expired.
      - Should be format of response [My_Simple_BE](https://github.com/tuanhwing/go_server) (feel free to change it to fit your needs)
          ```
          {
              "status": true,
              "message": "Successful",
              "errors": null,
              "data": {
                  "id": "43eca605-7ba7-4253-9cac-c642157efa56",
                  "phone": {
                      "dial_code": "+84",
                      "phone_number": "383703710",
                      "full_phone_number": "+84383703710"
                  },
                  "name": "Tuấn Hwing"
              }
          }
          ```

-  Dividing a project into different modules (`modularization`)

#### What is Modularization
***Modular programming*** is a software design technique to separate functionality into independent, interchangeable module, so that each contains everything necessary to execute a specific functionality.

#### Why we should care about Modular approach?
![image](https://i.imgur.com/9EI9Lwg.png)
For example, on the left, we can only split the work for two developers or more. But on the right side, we can split the work for five developers or more, and also this is very suitable for a large team because we split the project as a module. So the developer can focus on their module.

**Introduction**

It is architecture based on the blog by [Reso Coder's Flutter Clean Architecture ](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/). The main focus of the architecture is separation of concerns and scalability.  I will apply this diagram to my application.

![alt text](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?w=556&ssl=1)

Every "feature" of the app, like sign in with email and password, will be divided into 3 layers - `presentation`, `domain` and `data`.

**The Dependency Rule**

`Source code dependencies only point inwards`. This means inward modules are neither aware of nor dependent on outer modules. However, outer modules are both aware of and dependent on inner modules. The more you move inward, the more abstraction is present. The outer you move the more concrete implementations are present.

> IMPORTANT : Domain represents the inner-most layer. Therefore, it the most abstract layer in the architecture.

**Layers**

1. Domain
   It will contain only the core business logic (use cases) and business objects (entities). It should be totally independent of every other layer.

   ![alt text](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/domain-layer-diagram.png?w=141&ssl=1)
   - `UseCase`: Classes which encapsulate all the business logic of a particular use case of the app (e.g. FetchProfile or UpdateProfile).
   - `Entities`: Business objects of the application
   - `Repositories`: Abstract classes that define the expected functionality of outer layers (`data` layer).

   We create an abstract Repository class defining a contract of what the Repository must do - this goes into the domain layer. We then depend on the Repository "contract" defined in `domain`, knowing that the actual implementation of the Repository in the `data` layer will fullfill this contract.
   >NOTE: Dependency inversion principle is the last of the SOLID principles. It basically states that the boundaries between layers should be handled with interfaces (abstract classes in Dart).

2. Data:
   Consists of a **Repository implementation** (the contract comes from the `domain` layer) and data sources - one is usually for getting remote (API) data and the other for caching that data.

   ![alt text](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/data-layer-diagram.png?w=329&ssl=1)
   - `Repositories`: Every Repository should implement Repository from the `domain` layer.
   - `Datasources`:
      - *remote* : responsible for any API call.
      - *local* : reposible for caching data in local database (e.g SQLite, shared_preferences)
   - `Models`: Extensions of `Entities` with the addition of extra members that might be platform-dependent. For example, in the case of parse json Oject from reponse's server, this can be add some specific functionality (toJson, fromJson) or additional fields database.
   > NOTE: You may notice that data sources don't return `Entities` but rather `Models`.
3. Presentation:
   Contains the UI and the event handlers of the UI.

   ![alt text](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/presentation-layer-diagram.png?w=287&ssl=1)
