# HisabPro — ব্যবহারকারীর করণীয় (শুধু যেগুলো অ্যাকাউন্ট/ডিভাইসের কারণে নিজে করতে হবে)

## ১) Cloud Backup চালু করা
1. https://supabase.com/dashboard এ নিজের অ্যাকাউন্টে প্রবেশ করুন।
2. New project তৈরি করুন; শক্তিশালী database password দিন এবং নিরাপদে রাখুন।
3. Project চালু হলে Project Settings → API থেকে Project URL এবং `anon`/Publishable key কপি করুন। `service_role` বা Secret key কখনো মোবাইল অ্যাপে দেবেন না, কাউকে পাঠাবেন না।
4. SQL Editor খুলে এই ZIP-এর `supabase/schema.sql` সম্পূর্ণ রান করুন।
5. App build-এ URL ও Publishable/anon key build secrets হিসেবে দিন। GitHub Actions ব্যবহার করলে repository Settings → Secrets and variables → Actions-এ `SUPABASE_URL` এবং `SUPABASE_ANON_KEY` secret তৈরি করতে হবে। Android workflow secrets থেকে build-এ URL ও key pass করে।
6. Supabase Authentication → Providers-এ Email provider চালু রাখুন। Email confirmation চালু থাকলে signup-এর পর ইমেইল confirm করুন।

## ২) Android APK build
সবচেয়ে সহজ পথ: GitHub-এ source repository তৈরি করে এই ZIP-এর ফাইল push করুন। Actions tab-এ `Flutter Android CI` workflow চালান। Build সফল হলে `hisabpro-android-apk` artifact download করুন। প্রথমবার install করার আগে নিজের ফোনে unknown-app install অনুমতি দিতে হতে পারে। এটি Play Store release নয়।

## ৩) iPhone build
iOS build/sign করতে macOS, Xcode, Apple Developer account, Bundle ID, signing certificate ও provisioning profile প্রয়োজন। `Flutter iOS unsigned build check` শুধু unsigned app compile check করে; TestFlight/App Store-এ আপলোডযোগ্য signed IPA তৈরি করে না। Apple signing ও App Store Connect upload অ্যাকাউন্ট মালিককেই অনুমোদন করতে হবে।

## ৪) প্রথমবার ব্যবহার
- প্রথমে একটি test account-এ app খুলে কয়েকটি test entry যোগ করুন।
- পূর্ণাঙ্গ JSON backup নিন। JSON backup encrypted নয়—নিরাপদে রাখুন।
- Cloud account-এ login করে Sync করুন; Supabase Table Editor-এ শুধু নিজের user-এর record এসেছে কি না যাচাই করুন।
- দ্বিতীয় ডিভাইসে একই account দিয়ে login/sync করে data check করুন। একই রেকর্ড দুই ডিভাইসে একসঙ্গে edit করে conflict পরীক্ষা না করা পর্যন্ত গুরুত্বপূর্ণ একক হিসাবের জন্য cloud sync-কে একমাত্র backup হিসেবে ধরবেন না।
- প্রাথমিক ঋণের seed শুধু একবার import করুন। ইতিমধ্যে যোগ করে থাকলে আবার করবেন না।

## ৫) Release-এর আগে বাধ্যতামূলক
- Flutter CI-তে analyze/test/build সফল হতে হবে।
- Android ও iOS বাস্তব ডিভাইসে QA, offline mode, backup/restore এবং দুই-ডিভাইস sync পরীক্ষা করতে হবে।
- Privacy Policy-তে বাস্তব data handling, support email, developer identity ও retention policy পূরণ করতে হবে।
- Android signing key এবং Apple signing credentials নিরাপদে configure করতে হবে।
- Phone-wise stock, purchase/sale matching, প্রকৃত profit/cost, installment reminders এবং full conflict resolution এখনো সম্পূর্ণ product features নয়। এগুলো না হওয়া পর্যন্ত ব্যবসার লাভের রিপোর্টকে final accounting হিসেবে ব্যবহার করবেন না।


## তোমার Supabase project যুক্ত করা হয়েছে (v1.3.1)
তোমার দেওয়া Project URL এবং Publishable Key অ্যাপের `lib/config.dart`-এ বসানো হয়েছে। এগুলো public client configuration; Service Role/Secret key নয়।

### এখন শুধু Supabase schema চালাও
1. https://supabase.com/dashboard/project/dcqmkhvyqkdvtbczggfc/sql/new খোলো।
2. ZIP-এর `supabase/schema.sql` ফাইলের সম্পূর্ণ SQL কপি করে SQL Editor-এ paste করো।
3. Run চাপো।
4. Authentication → Providers → Email enabled আছে নিশ্চিত করো।
5. Authentication → URL Configuration-এ নিজের app/web redirect পরে configure করা যাবে; email confirmation চালু থাকলে signup-এর পর inbox থেকে confirm করতে হবে।

**সতর্কতা:** SQL সফলভাবে run না হওয়া পর্যন্ত Cloud Sync কাজ করবে না। আমি তোমার dashboard-এ login করে SQL execute করতে পারি না।
