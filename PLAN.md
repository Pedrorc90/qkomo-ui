# qkomo-ui Plan

Mirror of UI/mobile tasks from `/PLAN.md`. Update this list (and the root plan) together.

- [x] **M1 – Firebase auth & profile gating:** Configure Apple/Google/email sign-in, persist ID tokens, and guard app access.
- [x] **M2 – Capture surfaces:** Build camera, gallery import, and barcode scanner flows with Spanish-first messaging.
- [x] **M3 – Offline queue & storage:** Queue analyze jobs locally (Hive) and persist drafts/results for offline use.
- [x] **M4 – Analyze flow wiring:** Call backend `/v1/analyze` and `/v1/analyze/barcode`, show progress, and reconcile queued items.
  - Pendiente: probar contra backend real con token Firebase y correr `flutter analyze`/`flutter test`.
- [ ] **M5 – Review & edit UI:** Let users edit ingredient/allergen lists and confirm before saving.
- [ ] **M6 – Today & History tabs:** Implement log views backed by local storage, ready for future sync.
- [ ] **M7 – Sync-ready architecture:** Abstract data layer for easy switch to online/offline hybrid when backend exposes entry APIs.
- [ ] **M8 – Mobile QA:** Add widget/state tests plus smoke tests for capture → review → save.
- [ ] **Infra – Flutter tooling:** Instalar `unzip`, regenerar Dart/Flutter SDK, ejecutar `flutter pub get`, `dart format`, `flutter analyze` y `flutter test`.
- [ ] **UI – Historial real:** Completar pantalla Historial con feed de capturas y filtros (hoy + histórico).

Keep this plan file aligned with `/PLAN.md` whenever task status changes.
