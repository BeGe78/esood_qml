TEMPLATE = app

QT += qml quick widgets
SOURCES += main.cpp
lupdate_only {
    SOURCES +=  $$PWD/content/*.qml \
    $$PWD/*.qml
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

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
