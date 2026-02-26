plugins {
    id("com.android.application") apply false
    id("com.android.library") apply false
    kotlin("android") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
