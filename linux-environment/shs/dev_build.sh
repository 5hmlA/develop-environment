echo "~/code/dev/My"
cd ~/code/dev/My
./gradlew --stop
if [ "$1" = "clean" ]; then
    kill $(ps ax -o pid,comm,rss | awk '$2=="java" && $3>2*1024*1024 {print $1}')
    echo "./gradlew app:clean pp:assembleRelease"
    ./gradlew app:clean app:assembleRelease
elif [ "$1" = "publish" ]; then
    kill $(ps ax -o pid,comm,rss | awk '$2=="java" && $3>2*1024*1024 {print $1}')
    echo " ./gradlew clean publishSparkPublicationToAarRepository"
    ./gradlew clean publishSparkPublicationToAarRepository
else
    kill $(ps ax -o pid,comm,rss | awk '$2=="java" && $3>2*1024*1024 {print $1}')
    echo "./gradlew app:installDebug"
    ./gradlew app:installDebug
fi	