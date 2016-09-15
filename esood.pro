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
    android/gradlew.bat


