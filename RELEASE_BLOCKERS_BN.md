# HisabPro Production Release Blockers

বর্তমান source package-কে production-ready বলা যাচ্ছে না। নিচের কাজগুলো বাস্তব পরিবেশে সম্পন্ন ও প্রমাণসহ যাচাই করতে হবে:

1. Flutter stable SDK দিয়ে `dart format`, `flutter analyze`, `flutter test` এবং Android release build চালানো। CI workflow যোগ করা হয়েছে, কিন্তু এই পরিবেশে SDK নেই বলে চালানো হয়নি।
2. Supabase project-এ `supabase/schema.sql` চালিয়ে RLS policy, email auth, password reset, user deletion এবং backup restore বাস্তব দুইটি test account-এ যাচাই করা।
3. Sync এখন timestamp-ভিত্তিক last-write-wins; একই রেকর্ড দুই ডিভাইসে একসঙ্গে edit হলে এটি পূর্ণাঙ্গ conflict resolution নয়। Production-এর আগে revision/version-based conflict UI দরকার।
4. App-level account registration, password reset ও account deletion UI সম্পূর্ণ করা।
5. JSON full backup + validated restore, encrypted local export এবং restore drill করা। CSV কেবল export; পূর্ণ backup নয়।
6. Mobile inventory: প্রতিটি ফোনের unique stock ID/IMEI (ব্যবহারকারী চাইলে), purchase cost, sale price, supplier settlement, partial payment ও per-device gross profit ledger তৈরি ও পরীক্ষা করা।
7. Recurring installment reminder/notification permission ও timezone আচরণ Android/iOS-এ পরীক্ষা করা।
8. Automated tests: debt balance, partial repayment, overpayment, duplicate import, deleted-row sync, offline queue, multi-device conflict, migration এবং restore।
9. Android app icon, adaptive icon, splash, package ID, signing keystore, versioning এবং release APK/AAB। Keystore নিরাপদে ব্যবহারকারীর নিয়ন্ত্রণে রাখতে হবে।
10. iOS bundle ID, signing certificate, provisioning profile, Xcode build ও TestFlight device testing (macOS প্রয়োজন)।
11. পূরণ করা privacy policy, support email, data safety disclosures, screenshots, store listing এবং Google Play/App Store submission review।
12. Real-device QA: low-storage, app-kill during sync, network loss, clock skew, large ledger, Bengali text, accessibility ও backup restore।

## গুরুত্বপূর্ণ হিসাবনীতি
- ঋণের বকেয়া = debt + loan - payment - installment; ঋণাত্মক ফল হলে অতিরিক্ত পরিশোধ আলাদা করে দেখাতে হবে, শূন্যে clamp করে তথ্য লুকানো যাবে না।
- মোবাইল ব্যবসার প্রকৃত লাভ per-device cost matching ছাড়া নির্ণয় করা যাবে না। Aggregate sale minus aggregate purchase কেবল cashflow difference।
- Seed import তারিখটি historical data date হিসেবে নির্ধারণ করা হয়েছে; ব্যবহারকারী নিশ্চিত না করলে এটি import করা উচিত নয়।
