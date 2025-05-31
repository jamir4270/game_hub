plugins {
    id("kotlin-android")
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    // id("com.google.gms.google-services")
}

android {
    namespace = "com.nietzchan.game_hub"
    ndkVersion = "25.1.8937393"
    compileSdk = 35

    kotlinOptions {
        jvmTarget = "17"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.nietzchan.game_hub"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "GH.010.001"
    }

    signingConfigs {
        create("release") {
            keyAlias = "key"
            keyPassword = "ederlezi"
            storeFile = file("key.jks")
            storePassword = "ederlezi"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }
        }
    }
}

dependencies {
    // implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
    // implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}
