# Z Maker

A Flutter app scaffold for **sleep management** focused on **shift workers / night workers**.

## Features (current)

- Analog clock (hour/min/sec hands) in a circular header
- Simple grid Calendar section below
- Clean routing & screens scaffold (Home, Planner, Insights, Settings)
- GetIt DI ready (minimal for now)

## Run

```bash
flutter pub get
flutter run
```

> If you add code-generation or platform-specific plugins later, you may need:
>
> - `flutter create .` (to regenerate platform folders if you started from lib-only)
> - `dart run build_runner build --delete-conflicting-outputs`

## Next

- Add Drift database (sleep sessions, shifts, goals)
- Add notification scheduling for bedtime reminders
- Add charts for insights
