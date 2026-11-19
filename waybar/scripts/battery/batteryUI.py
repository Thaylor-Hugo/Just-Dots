# Necessary to give the battery scripts execution permission without sudo
# check for details: https://askubuntu.com/questions/155791/how-do-i-sudo-a-command-in-a-script-without-being-asked-for-a-password
# Note: There might be a file /etc/sudoers.d/10-installer that overwrite the NOPASSWD option, so you might need to remove it
#Note2: It might be safer to install the battery scripts in /usr/local/bin and give them the necessary permissions and ownership to root

import sys
import subprocess
from PyQt6.QtWidgets import QApplication, QMainWindow, QPushButton, QVBoxLayout, QHBoxLayout, QWidget, QLabel, QSlider
from PyQt6.QtCore import QEvent, Qt, QRect
from PyQt6 import QtGui
from multiprocessing import Process

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("BatteryUI")
        self.setGeometry(10, 10, 300, 100)

        # Main layout
        main_layout = QVBoxLayout()

        # Power profile
        power_profile_layout = QHBoxLayout()
        power_label = QLabel("Power profile:")
        power_label.setStyleSheet("font-weight: bold; color: white;")
        power_button = PowerButton()
        power_profile_layout.addWidget(power_label)
        power_profile_layout.addWidget(power_button)

        # Conservation mode switch
        conservation_mode_layout = QHBoxLayout()
        switch_label = QLabel("Conservation Mode:")
        switch_label.setStyleSheet("font-weight: bold; color: white;")
        switch = ConservativeModeSwitch()
        conservation_mode_layout.addWidget(switch_label)
        conservation_mode_layout.addWidget(switch)

        # Brightness slider
        brightness_slider = BrightnessSlider()
        brightness_label = QLabel("Brightness:")
        brightness_label.setStyleSheet("font-weight: bold; color: white;")
        brightness_layout = QHBoxLayout()
        brightness_layout.addWidget(brightness_label)
        brightness_layout.addWidget(brightness_slider)

        # Add layouts to main layout
        main_layout.addLayout(power_profile_layout)
        main_layout.addLayout(conservation_mode_layout)
        main_layout.addLayout(brightness_layout)

        # Set central widget
        central_widget = QWidget()
        central_widget.setLayout(main_layout)
        central_widget.setStyleSheet("background-color: rgba(40, 39, 39, 1);")
        self.setCentralWidget(central_widget)

        # Install an event filter on the application
        self.installEventFilter(self)

    def eventFilter(self, obj, event):
        # Detect mouse clicks
        if event.type() == QEvent.Type.MouseButtonPress:
            # Check if the click is outside the main window
            if not self.geometry().contains(event.globalPosition().toPoint()):
                # Does'not seem to work (maybe hyprland is blocking the event)
                self.close()

        if event.type() == QEvent.Type.KeyPress:
            if event.key() == Qt.Key.Key_Escape:
                self.close()

        return super().eventFilter(obj, event)


class PowerButton(QPushButton):
    def __init__(self, parent=None):
        super().__init__(parent)

        self.power_profiles = ["performance", "balanced", "power-saver"]
        self.power_profiles_formatted = {
            "performance": "Performance",
            "balanced": "Balanced",
            "power-saver": "Power Saver",
        }
        self.profile_colors = {
            "performance": "background-color: red; color: black;",
            "balanced": "background-color: blue; color: black;",
            "power-saver": "background-color: green; color: black;",
        }

        self.current_power_profile = self.get_power_profile()
        self.setText(self.power_profiles_formatted[self.current_power_profile])
        self.setStyleSheet(self.profile_colors[self.current_power_profile])
        self.clicked.connect(self.button_clicked)

    def get_power_profile(self):
        result = subprocess.run(["powerprofilesctl", "get"], capture_output=True, text=True)
        profile = result.stdout.strip()
        if profile in self.power_profiles:
            return profile
        return "balanced"

    def button_clicked(self):
        index = self.power_profiles.index(self.current_power_profile)
        index = (index + 1) % len(self.power_profiles)
        self.current_power_profile = self.power_profiles[index]
        self.setText(self.power_profiles_formatted[self.current_power_profile])
        self.setStyleSheet(self.profile_colors[self.current_power_profile])
        subprocess.run(["powerprofilesctl", "set", self.current_power_profile], capture_output=True, text=True)


class ConservativeModeSwitch(QPushButton):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setCheckable(True)
        self.setChecked(self.get_conservation_mode())
        self.toggled.connect(self.switch_toggled)

    def paintEvent(self, event):
        label = "ON" if self.isChecked() else "OFF"
        radius = 10
        width = 32
        center = self.rect().center()

        painter = QtGui.QPainter(self)
        painter.setRenderHint(QtGui.QPainter.RenderHint.Antialiasing)
        painter.translate(center)
        painter.setBrush(QtGui.QColor(0,0,0))

        pen = QtGui.QPen()
        pen.setColor(QtGui.QColor(0,0,0))
        pen.setWidth(2)
        painter.setPen(pen)

        painter.drawRoundedRect(QRect(-width, -radius, 2*width, 2*radius), radius, radius)
        if self.isChecked():
            painter.setBrush(QtGui.QColor(0, 255, 0))
        else:
            painter.setBrush(QtGui.QColor(255, 0, 0))

        sw_rect = QRect(-radius, -radius, width + radius, 2*radius)
        if not self.isChecked():
            sw_rect.moveLeft(-width)
        painter.drawRoundedRect(sw_rect, radius, radius)
        painter.drawText(sw_rect, Qt.AlignmentFlag.AlignCenter, label)

    def get_conservation_mode(self):
        conservation_path = "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
        conservation_mode = subprocess.run("cat " + conservation_path, shell=True, capture_output=True, text=True).stdout
        return conservation_mode == "1\n"
    
    def switch_toggled(self, checked):
        if checked:
            subprocess.run("sudo /usr/local/bin/battery_life.sh", shell=True, capture_output=True, text=True)
        else:
            subprocess.run("sudo /usr/local/bin/full_charge.sh", shell=True, capture_output=True, text=True)


class BrightnessSlider(QSlider):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setOrientation(Qt.Orientation.Horizontal)
        self.setRange(0, self.get_max_brightness())
        self.setValue(self.get_brightness())
        self.valueChanged.connect(self.slider_changed)
    
    def get_max_brightness(self):
        return int(subprocess.run("brightnessctl max", shell=True, capture_output=True, text=True).stdout.strip())

    def get_brightness(self):
        return int(subprocess.run("brightnessctl get", shell=True, capture_output=True, text=True).stdout.strip())
    
    def slider_changed(self, value):
        subprocess.run("brightnessctl set "+str(value), shell=True, capture_output=True, text=True)

if __name__ == "__main__":
    # print(Process.name)
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())

