fun RepositoryHandler.enableMirror(projectName: String) {
    all {
        if (this is MavenArtifactRepository) {
            val originalUrl = this.url.toString().removeSuffix("/")
            urlMappings[originalUrl]?.let {
                //logger.lifecycle("Repository[$url] is mirrored to $it")
                println("🔥『$projectName』🔪 $url => $it")
                this.setUrl(it)
            }
        }
    }
}

val urlMappings = mapOf(
    "https://repo.maven.apache.org/maven2" to "https://mirrors.tencent.com/nexus/repository/maven-public/",
    "https://dl.google.com/dl/android/maven2" to "https://mirrors.tencent.com/nexus/repository/maven-public/",
    "https://plugins.gradle.org/m2" to "https://mirrors.tencent.com/nexus/repository/gradle-plugins/"
)


gradle.allprojects {
    //https://github.com/gradle/gradle/issues/20210
    //https://docs.gradle.org/current/userguide/upgrading_version_8.html#deprecations
    println("🔥『${project.name}』🔪 buildDir is relocated to -> \u001B[92m${project.layout.buildDirectory.asFile.get()}\u001B[0m 🥱 [allprojects]")
    //project.layout.buildDirectory.set(File("E:/0buildCache/${rootProject.name}/${project.name}"))
    //buildDir = File("E:/0buildCache/${rootProject.name}/${project.name}")
    repositories.enableMirror(name)
    repositories.all {
        if (this is MavenArtifactRepository) {
            println("🔔『${project.name}』📸 $url")
        }
    }
}

gradle.beforeSettings {
    println("🔪init.gradle.kts-> 📸 📸 📸 📸 📸 『${rootProject.name}』 🔥 🔥 🔥 🔥 [beforeSettings]")
    pluginManagement.repositories.enableMirror(rootProject.name)
    dependencyResolutionManagement.repositories.enableMirror(rootProject.name)
}
