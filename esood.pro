TEMPLATE = app

QT += qml quick widgets
SOURCES += main.cpp ganalytics.cpp
HEADERS += ganalytics.h
lupdate_only {
    SOURCES +=  $$PWD/content/*.qml \
    $$PWD/*.qml
}
android {  
  ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
  QT += androidextras
  SOURCES += android/androidganalytics.cpp
  HEADERS += android/androidganalytics.h
  OTHER_FILES += \
    android/version.xml \
    android/res/values/strings.xml \
    android/AndroidManifest.xml \
    android/src/com/lasconic/QGoogleAnalytics.java
}
RESOURCES += esood.qrc
OTHER_FILES += *.qml content/*.qml content/images/*.png

target.path = /var/workspace/android/esood
INSTALLS += target
TRANSLATIONS +=  esood_en.ts \
                 esood_fr.ts

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    ../../../../home/workspace/android/esood/android/AndroidManifest.xml \
    ../../../../home/workspace/android/esood/android/gradle/wrapper/gradle-wrapper.jar \
    ../../../../home/workspace/android/esood/android/gradlew \
    ../../../../home/workspace/android/esood/android/res/values/libs.xml \
    ../../../../home/workspace/android/esood/android/build.gradle \
    ../../../../home/workspace/android/esood/android/gradle/wrapper/gradle-wrapper.properties \
    ../../../../home/workspace/android/esood/android/gradlew.bat


