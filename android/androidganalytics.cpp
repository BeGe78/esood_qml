//=============================================================================
// Copyright (c) 2014 Nicolas Froment

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//=============================================================================

#include "androidganalytics.h"

#include <QtAndroidExtras/QAndroidJniObject>

AndroidGoogleAnalytics::AndroidGoogleAnalytics()
{

}

void AndroidGoogleAnalytics::sendHit(const QString &screenName)
{
    QAndroidJniObject jsScreenName = QAndroidJniObject::fromString(screenName);
    QAndroidJniObject::callStaticMethod<void>("com/lasconic/QGoogleAnalytics",
                                       "sendHit",
                                       "(Ljava/lang/String;)V",
                                       jsScreenName.object<jstring>());
}


void AndroidGoogleAnalytics::sendEvent(const QString &category, const QString &action, const QString &label, long value)
{
    QAndroidJniObject jsCategory = QAndroidJniObject::fromString(category);
    QAndroidJniObject jsAction = QAndroidJniObject::fromString(action);
    QAndroidJniObject jsLabel = QAndroidJniObject::fromString(label);
    QAndroidJniObject::callStaticMethod<void>("com/lasconic/QGoogleAnalytics",
                                       "sendEvent",
                                       "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V",
                                       jsCategory.object<jstring>(), jsAction.object<jstring>(), jsLabel.object<jstring>(), (jlong)value);
}
