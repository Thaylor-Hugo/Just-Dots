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

power_mode_changed = False

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("BatteryUI")
        self.setGeometry(10, 10, 300, 100)

        # Main layout
        main_layout = QVBoxLayout()

        # Power profile for AC
        ac_power_profile_layout = QHBoxLayout()
        ac_label = QLabel("AC Power profile:")
        ac_label.setStyleSheet("font-weight: bold; color: white;")
        ac_button = PowerButton(power_source="AC")
        ac_power_profile_layout.addWidget(ac_label)
        ac_power_profile_layout.addWidget(ac_button)

        # Power profile for BAT
        bat_power_profile_layout = QHBoxLayout()
        bat_label = QLabel("BAT Power profile:")
        bat_label.setStyleSheet("font-weight: bold; color: white;")
        bat_button = PowerButton(power_source="BAT")
        bat_power_profile_layout.addWidget(bat_label)
        bat_power_profile_layout.addWidget(bat_button)

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
        main_layout.addLayout(ac_power_profile_layout)
        main_layout.addLayout(bat_power_profile_layout)
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
    
    def closeEvent(self, *args, **kwargs):
        super().closeEvent(*args, **kwargs)
        if power_mode_changed:
            subprocess.run("sudo /usr/local/bin/restart_tlp.sh", shell=True, capture_output=True, text=True)


class PowerButton(QPushButton):
    def __init__(self, parent=None, power_source="AC"):
        super().__init__(parent)
        
        self.power_profiles = ["performance", "balance_performance", "default", "balance_power", "power"]
        self.power_profiles_formatted = {
            "performance": "Performance", 
            "balance_performance": "Balance Performance", 
            "default": "Balanced", 
            "balance_power": "Balance Power Saver", 
            "power": "Power Saver"
        }
        self.profile_colors = {
            "performance": "background-color: red; color: black;",
            "balance_performance": "background-color: orange; color: black;",
            "default": "background-color: blue; color: black;",
            "balance_power": "background-color: yellow; color: black;",
            "power": "background-color: green; color: black;"
        }

        self.power_source = power_source
        self.current_power_profile = self.get_power_profile()
        self.setText(self.power_profiles_formatted[self.current_power_profile])
        self.setStyleSheet(self.profile_colors[self.current_power_profile])
        self.clicked.connect(self.button_clicked)
    
    def get_power_profile(self):
        with open("/etc/tlp.conf", "r") as file:
            for line in file:
                if line.startswith("CPU_ENERGY_PERF_POLICY_ON_"+self.power_source):
                    return line.split("=")[1].strip()
        return "default"
    
    def button_clicked(self):
        global power_mode_changed
        power_mode_changed = True

        index = self.power_profiles.index(self.current_power_profile)
        index = (index + 1) % len(self.power_profiles)
        last_power_profile = self.current_power_profile
        self.current_power_profile = self.power_profiles[index]
        self.setText(self.power_profiles_formatted[self.current_power_profile])
        self.setStyleSheet(self.profile_colors[self.current_power_profile])
        subprocess.run("sudo /usr/local/bin/change_power_mode.sh "+self.power_source+" "+last_power_profile+" "+self.current_power_profile, shell=True, capture_output=True, text=True)


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

