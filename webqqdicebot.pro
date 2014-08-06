#-------------------------------------------------
#
# Project created by QtCreator 2014-07-05T23:59:35
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = webqqdicebot
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += main.cpp

HEADERS +=

INCLUDEPATH += src/lwqq/lib
INCLUDEPATH += src/lwqq-build

LIBS += -L../webqqdicebot/src/lwqq-build/lib \
        -llwqq
