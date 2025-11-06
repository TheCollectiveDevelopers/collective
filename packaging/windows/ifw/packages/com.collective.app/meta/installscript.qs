function Component()
{
    // Constructor
}

Component.prototype.createOperations = function()
{
    // Call default implementation to actually install the application
    component.createOperations();

    if (systemInfo.productType === "windows") {
        // Create Start Menu shortcut
        component.addOperation("CreateShortcut", 
            "@TargetDir@/appcollective.exe", 
            "@StartMenuDir@/Collective.lnk",
            "workingDirectory=@TargetDir@",
            "iconPath=@TargetDir@/appcollective.exe",
            "description=Launch Collective");

        // Create Desktop shortcut
        component.addOperation("CreateShortcut", 
            "@TargetDir@/appcollective.exe", 
            "@DesktopDir@/Collective.lnk",
            "workingDirectory=@TargetDir@",
            "iconPath=@TargetDir@/appcollective.exe",
            "description=Launch Collective");
    }
}

Component.prototype.createOperationsForArchive = function(archive)
{
    component.createOperationsForArchive(archive);
}