# reactive_domain_playground

Sandbox for practicing non-contact combat skills in a reactive Domain layer.

## Getting Started

The project presents different ways of organizing the domain layer. The prerequisites for realizing your example:
- clear division into domain and ui layer
- one example architecture - one file
- notifier should be able to restore data from storage at first startup. Use `AppStorage` class.
- your `Variation123` widget should use the `ExperimentPage` widget and provide the required fields
- interface should be updated based on the state of your notifier
- achieve a targeted interface update

Pull requests are welcome!

## How to run

```shell
flutter run
```

Guaranteed to work under Windows

## Variations

1. `AutoDisposeNotifier` + `SettingsModel`. Reactive state update and wiretap attachment using `Watcher.attach`. The widget is updated using `Consumer` and calls `ref.watch` + `select` for spot updates.
2. `Settings` class with `late final` providers of type `Provider.autoDispose`. Reactive state update and wiretap attachment using `Watcher.attach`. Perhaps this method is presented purposefully and is an **anti-pattern**, although it works as expected. The widget is updated with `Consumer` and `ref.watch` calls.
3. `AutoDisposeNotifier` and split into two notifiers: `ThemeModeNotifier` and `ThemeColorNotifier`. Reactive state update and wiretap attachment using `Watcher.attach`. Preferred method because of the strict division of responsibilities. The widget is updated with `Consumer` and `ref.watch` calls.
4. `ChangeNotifier` with a mutable data update scheme using the `notifyListeners` call. Initial retrieval of data from storage using `AppStorage.get`, state update is imperative. Injecting notifier as an instance variable. The widget is updated with `ListenableBuilder`. There is no point update.
5. `ValueNotifier` and split into two notifiers: `ThemeModeNotifier` and `ThemeColorNotifier`. Initial retrieval of data from storage using `AppStorage.get`, state update is reactive in terms of `ValueNotifier`. Implement notifier as an instance variable + create a shared notifier using `Listenable.merge`. The widget can be updated point-by-point with `ValueListenableBuilder`.
