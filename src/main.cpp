#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include <SFML/Audio.hpp>

#include "timer.h"

int main(int argc, char** argv)
{
	QGuiApplication app(argc, argv);

	qmlRegisterType<Timer>("metronome", 4, 2, "ZTimer");
	qmlRegisterType<Subdiv>("metronome", 4, 2, "Subdiv");

	QQuickStyle::setStyle("Material");
	QQmlApplicationEngine engine("res/main.qml");

	return app.exec();
}
