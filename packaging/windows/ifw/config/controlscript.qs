function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function() {
    gui.currentPageWidget().TargetDirectoryLineEdit.setText(installer.value("TargetDir"));
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.PerformInstallationPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
    var checkBoxForm = gui.currentPageWidget().LaunchCheckBox;
    if (checkBoxForm && installer.isInstaller()) {
        checkBoxForm.checked = true;
    }
    gui.clickButton(buttons.FinishButton);
}

// Update checker function
Controller.prototype.checkForUpdates = function() {
    console.log("Checking for updates...");
    
    if (installer.isUpdater()) {
        console.log("Running in updater mode");
        installer.setMessageBoxAutomaticAnswer("OverwriteTargetDirectory", QMessageBox.Yes);
        installer.setMessageBoxAutomaticAnswer("stopProcessesForUpdates", QMessageBox.Ignore);
    }
}

// Called when installer is started
Controller.prototype.init = function() {
    console.log("Installer initialized");
    console.log("Is Installer: " + installer.isInstaller());
    console.log("Is Uninstaller: " + installer.isUninstaller());
    console.log("Is Updater: " + installer.isUpdater());
    console.log("Is Package Manager: " + installer.isPackageManager());
    
    if (installer.isUpdater()) {
        this.checkForUpdates();
    }
}