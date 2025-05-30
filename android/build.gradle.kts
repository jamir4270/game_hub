// plugins block (commented-out plugin example)
plugins {
    // id("com.google.gms.google-services") version "4.4.2" apply false
}

// repository setup for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Kotlin DSL equivalent of: rootProject.buildDir = "../build"
rootProject.buildDir = File(rootDir.parentFile, "build")

// Set each subproject's build dir
subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
}

// Make sure all subprojects evaluate after :app
subprojects {
    project.evaluationDependsOn(":app")
}

// Register the clean task
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
