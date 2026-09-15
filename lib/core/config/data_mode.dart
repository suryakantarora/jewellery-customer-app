/// Where the app reads its data from.
///
/// `demo` serves bundled JSON with realistic latency; `api` talks to the
/// backend through Dio. Screens never know which is active — the switch lives
/// in `repositoryProviders` alone.
enum DataMode {
  demo,
  api;

  static DataMode fromName(String? name) => values.firstWhere(
    (m) => m.name == name?.toLowerCase(),
    orElse: () => DataMode.demo,
  );
}
