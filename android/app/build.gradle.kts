plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.autoscan.obd2scanner"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.autoscan.obd2scanner"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Configure these in ~/.gradle/gradle.properties or local CI secrets:
            // RELEASE_STORE_FILE, RELEASE_STORE_PASSWORD, RELEASE_KEY_ALIAS, RELEASE_KEY_PASSWORD
            val storeFilePath = project.findProperty("RELEASE_STORE_FILE") as String?
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
                storePassword = project.findProperty("RELEASE_STORE_PASSWORD") as String?
                keyAlias = project.findProperty("RELEASE_KEY_ALIAS") as String?
                keyPassword = project.findProperty("RELEASE_KEY_PASSWORD") as String?
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            val releaseConfig = signingConfigs.findByName("release")
            signingConfig = if (releaseConfig?.storeFile != null) {
                releaseConfig
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
