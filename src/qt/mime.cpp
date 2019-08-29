#include <QtCore>
#include <QApplication>
#include <QFile>
#include <QTextStream>

#include "mime.h"
#include "utils.h"

void registerXdgMime(QApplication &app){
    // MacOS handled via Info.plist
    // Windows handled in the installer by rbrunner7

    QString xdg = QString(
            "[Desktop Entry]\n"
            "Name=Oscillate GUI\n"
            "GenericName=Oscillate-GUI\n"
            "X-GNOME-FullName=Oscillate-GUI\n"
            "Comment=Oscillate GUI\n"
            "Keywords=Oscillate;\n"
            "Exec=%1 %u\n"
            "Terminal=false\n"
            "Type=Application\n"
            "Icon=oscillate\n"
            "Categories=Network;GNOME;Qt;\n"
            "MimeType=x-scheme-handler/oscillate;x-scheme-handler/oscillateseed\n"
            "StartupNotify=true\n"
            "X-GNOME-Bugzilla-Bugzilla=GNOME\n"
            "X-GNOME-UsesNotifications=true\n"
    ).arg(app.applicationFilePath());

    QString appPath = QStandardPaths::writableLocation(QStandardPaths::ApplicationsLocation);
    QString filePath = QString("%1/oscillate-gui.desktop").arg(appPath);

    qDebug() << QString("Writing %1").arg(filePath);
    QFile file(filePath);
    if(file.open(QIODevice::WriteOnly)){
        QTextStream out(&file); out << xdg << endl;
        file.close();
    }
    else
        file.close();
}
