TEMPLATE = app

QT += qml quick widgets
SOURCES += main.cpp
RESOURCES += esood.qrc
OTHER_FILES += *.qml content/*.qml content/images/*.png

target.path = /var/workspace/android/esood
INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
