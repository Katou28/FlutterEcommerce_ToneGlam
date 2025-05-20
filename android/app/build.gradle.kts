plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.toneglam"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.toneglam" // Replace with your app's package name
        minSdk = 23 // Updated to 23
        targetSdk = 34
        versionCode = 1 // Replace with your app's version code
        versionName = "1.0" // Replace with your app's version name
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-auth-ktx:22.0.0") // Ensure correct Firebase Auth version
    implementation("com.google.firebase:firebase-core:21.1.1")
    implementation("androidx.core:core-ktx:1.10.1")
}

flutter {
    source = "../.."
}
