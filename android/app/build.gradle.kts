import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    throw GradleException("❌ ERROR: Cannot find key.properties file! Please make sure it is exactly at: ${keystorePropertiesFile.absolutePath}")
}

android {
    namespace = "com.almlkawi.cvision.cvision"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias") ?: throw GradleException("❌ ERROR: 'keyAlias' is missing or empty in key.properties!")
            keyPassword = keystoreProperties.getProperty("keyPassword") ?: throw GradleException("❌ ERROR: 'keyPassword' is missing or empty in key.properties!")
            val storeFilePath = keystoreProperties.getProperty("storeFile") ?: throw GradleException("❌ ERROR: 'storeFile' is missing or empty in key.properties!")
            storePassword = keystoreProperties.getProperty("storePassword") ?: throw GradleException("❌ ERROR: 'storePassword' is missing or empty in key.properties!")

            storeFile = file(storeFilePath)
        }
    }

    defaultConfig {
        applicationId = "com.almlkawi.cvision.cvision"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}