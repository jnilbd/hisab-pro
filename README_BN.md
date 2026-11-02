# HisabPro — Offline-first Flutter App

## ফিচার
- বাংলা UI, BDT, Dark/Light theme
- SQLite local ledger: ধার, ঋণ, পরিশোধ, কিস্তি, আয়, খরচ, মোবাইল ক্রয়/বিক্রয়
- Search/filter, dashboard, reports
- CSV export/share
- Confirmed initial debt list import button (26 records, total ৳৩,৪২,৮২০; optional one-time action)
- Supabase email/password auth, RLS, pending upload এবং cloud থেকে local pull
- Soft-delete tombstone যাতে sync-এর পর delete cloud-এও প্রতিফলিত হয়

## Run / Build
```bash
flutter pub get
flutter run
flutter build apk --release
```
iOS build: macOS + Xcode দরকার: `flutter build ios --release`।

## Supabase setup
1. Supabase project তৈরি করুন।
2. SQL Editor-এ `supabase/schema.sql` সম্পূর্ণ চালান।
3. এই project-এর URL ও publishable key `lib/config.dart`-এ configure করা আছে। অন্য Supabase project ব্যবহার করলে সেখানে বদলান। `service_role` key কখনো অ্যাপে দেবেন না।
4. Auth settings-এ Email provider চালু রাখুন।

## Data rules
- সব amount পূর্ণ BDT integer।
- `debt` ও `loan` দায় বাড়ায়; `payment` ও `installment` দায় কমায়।
- `income/expense` ব্যক্তিগত cashflow। `phonePurchase/phoneSale` ব্যবসার cashflow।
- CSV export-এ শুধু active entries যায়; deleted rows বাদ।

## গুরুত্বপূর্ণ QA সীমা
এই পরিবেশে Flutter/Dart SDK, Supabase project credentials এবং Android/iOS build environment নেই। তাই compile, real-device, cloud auth/sync, app signing, push notifications ও store submission যাচাই করা যায়নি। Sync-এর বর্তমান conflict policy: pending local rows আগে upload, এরপর অন্য cloud rows local-এ merge; একই UUID-তে একযোগে দুই ডিভাইসের edit হলে robust per-field conflict resolution নেই। প্রথমবার ব্যবহার করার আগে test account-এ পরীক্ষা করুন এবং export নিন।

## পরবর্তী release-এর আগে
- Flutter analyze/test এবং Android/iOS device QA
- Two-device conflict-resolution testing
- Cloud backup restore drill
- App icon, splash, privacy policy, store metadata ও signing
- Phone-wise inventory matching/profit ledger এবং recurring installment notifications


## Version 1.2 hardening update
- Sync initialization state is checked before exposing Supabase client.
- Local sync acknowledgement is conditional on the exact row timestamp, preventing a concurrent local edit from being marked synced accidentally.
- Cloud merge preserves pending local edits and applies timestamp-based last-write-wins only to already-synced rows.
- Added basic model tests and GitHub Actions Android CI workflow.
- Added Bengali privacy-policy draft and production release blocker checklist.

**এই আপডেটও production certification নয়।** CI-তে Flutter SDK দিয়ে analyze/test/build চালাতে হবে এবং Supabase ও বাস্তব Android/iOS ডিভাইসে QA করতে হবে।


## Version 1.3 backup / restore
- পূর্ণাঙ্গ JSON backup: entries (deleted tombstone সহ) ও app settings export হয়।
- Restore নির্বাচিত backup দিয়ে বর্তমান local database প্রতিস্থাপন করে; confirmation dialog আছে।
- JSON backup encrypted নয়; নিরাপদ স্থানে রাখতে হবে। Restore শেষে cloud sync-এর আগে ডেটা যাচাই করুন।
- Settings-এ email signup/login, logout, sync, JSON backup/restore এবং CSV export রয়েছে।
- `USER_ACTIONS_BN.md`-এ Supabase, GitHub Actions, Android ও iOS build-এর ধাপে ধাপে নির্দেশনা আছে।

**Release সীমা:** এই source-এ phone-wise stock/profit, scheduled installment reminders, encrypted backup, robust concurrent edit conflict resolution, store signing/submission সম্পূর্ণ নয়। SDK ও account access ছাড়া production certification দাবি করা হচ্ছে না।


## Version 1.3.1 — project connection
- User-provided Supabase Project URL এবং publishable key client configuration-এ বসানো হয়েছে। Publishable key client-side ব্যবহারের জন্য; নিরাপত্তা অবশ্যই RLS policy-র ওপর নির্ভরশীল।
- Android CI workflow এখন আলাদা GitHub secrets ছাড়াই build চালাতে পারে।
- **এখনো আবশ্যক:** Supabase Dashboard → SQL Editor-এ `supabase/schema.sql` চালাতে হবে; এরপর Authentication → Providers-এ Email enabled আছে নিশ্চিত করতে হবে। আমি এখানে তোমার project-এর SQL Editor-এ সরাসরি প্রবেশ বা schema execute করতে পারি না।
