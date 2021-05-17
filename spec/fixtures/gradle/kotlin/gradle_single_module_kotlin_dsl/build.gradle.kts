plugins {
  kotlin("jvm") version "1.4.32" 
	id("application")
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.jetbrains.kotlin:kotlin-stdlib")
	testImplementation("junit:junit:4.12")
}
