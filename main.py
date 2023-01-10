from PyQt.QtWidgets import QApplication, QWidgets


application = QApplication([sys.argv])

mainWindow = QWidget()
mainWindow.setGeometry(0, 0, 350, 400)
mainWindow.setWindowTitle('Hello World')
