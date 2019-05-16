#ifndef UTILS_H
#define UTILS_H

#include <QtCore>
#include <QRegExp>

bool fileExists(QString path);
QString getAccountName();
const static QRegExp reURI = QRegExp("^\\w+:\\/\\/([\\w+\\-?\\-_\\-=\\-&]+)");
QString randomUserAgent();

#endif // UTILS_H
