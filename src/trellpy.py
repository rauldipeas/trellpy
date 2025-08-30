#!/usr/bin/env python3
import sys, os
from PyQt6 import QtWidgets, QtGui, QtCore, QtWebEngineWidgets, QtWebEngineCore
from plyer import notification

URL = "https://trello.com/"

STORAGE_DIR = os.path.join(os.path.expanduser("~"), ".config", "trellpy")
os.makedirs(STORAGE_DIR, exist_ok=True)

class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Trello")
        self.resize(1000, 600)

        # Perfil com cookies persistentes
        profile = QtWebEngineCore.QWebEngineProfile("TrelloProfile", self)
        profile.setPersistentCookiesPolicy(
            QtWebEngineCore.QWebEngineProfile.PersistentCookiesPolicy.ForcePersistentCookies
        )
        profile.setPersistentStoragePath(STORAGE_DIR)

        # WebView
        self.webview = QtWebEngineWidgets.QWebEngineView()
        self.webview.setPage(QtWebEngineCore.QWebEnginePage(profile, self.webview))
        self.setCentralWidget(self.webview)
        self.webview.load(QtCore.QUrl(URL))

        # Atalhos
        QtGui.QShortcut(QtGui.QKeySequence("Ctrl+W"), self, self.close)
        QtGui.QShortcut(QtGui.QKeySequence("Ctrl+R"), self, self.reload)
        QtGui.QShortcut(QtGui.QKeySequence("F5"), self, self.reload)
        QtGui.QShortcut(QtGui.QKeySequence("Ctrl+Q"), self, self.close)

    def reload(self):
        self.webview.reload()

    def notify(self, title="Trello", message="Você tem notificações"):
        notification.notify(title=title, message=message, app_icon=None)

app = QtWidgets.QApplication(sys.argv)
window = MainWindow()
window.show()
sys.exit(app.exec())