defineTest(qtcAddDeployment) {
for(deploymentfolder, DEPLOYMENTFOLDERS) {
    item = item$${deploymentfolder}
    itemsources = $${item}.sources
    $$itemsources = $$eval($${deploymentfolder}.source)
    itempath = $${item}.path
    $$itempath= $$eval($${deploymentfolder}.target)
    export($$itemsources)
    export($$itempath)
    DEPLOYMENT += $$item
}

MAINPROFILEPWD = $$PWD

unix {
    desktopfile.path = /usr/share/applications
    copyCommand =
    for(deploymentfolder, DEPLOYMENTFOLDERS) {
        source = $$MAINPROFILEPWD/$$eval($${deploymentfolder}.source)
        source = $$replace(source, \\\\, /)
        macx {
            target = $$OUT_PWD/$${TARGET}.app/Contents/Resources/$$eval($${deploymentfolder}.target)
        } else {
            target = $$OUT_PWD/$$eval($${deploymentfolder}.target)
        }
        target = $$replace(target, \\\\, /)
        sourcePathSegments = $$split(source, /)
        targetFullPath = $$target/$$last(sourcePathSegments)
        !isEqual(source,$$targetFullPath) {
            !isEmpty(copyCommand):copyCommand += &&
            copyCommand += $(MKDIR) \"$$target\"
            copyCommand += && $(COPY_DIR) \"$$source\" \"$$target\"
        }
    }
    !isEmpty(copyCommand) {
        copyCommand = @echo Copying application data... && $$copyCommand
        copydeploymentfolders.commands = $$copyCommand
        first.depends = $(first) copydeploymentfolders
        export(first.depends)
        export(copydeploymentfolders.commands)
        QMAKE_EXTRA_TARGETS += first copydeploymentfolders
    }

    installPrefix = /usr

    for(deploymentfolder, DEPLOYMENTFOLDERS) {
        item = item$${deploymentfolder}
        itemfiles = $${item}.files
        $$itemfiles = $$eval($${deploymentfolder}.source)
        itempath = $${item}.path
        $$itempath = $${installPrefix}/$$eval($${deploymentfolder}.target)
        export($$itemfiles)
        export($$itempath)
        INSTALLS += $$item
    }
    contains(MEEGO_EDITION,harmattan) {
        installPrefix = /opt/$${TARGET}
        desktopfile.files = $${TARGET}.desktop
        desktopfile.path = /usr/share/applications
        icon.files = ../data/icon-l-$${TARGET}.png
        icon.path = $${installPrefix}/share/icons/
        splash.files = ../data/$${TARGET}-splash.jpg
        splash.path = $${installPrefix}/share/data
        export(splash.files)
        export(splash.path)
        INSTALLS += splash
    } else:exists("/usr/include/sailfishapp/sailfishapp.h") {
        desktopfile.files = $${TARGET}.desktop
        desktopfile.path = /usr/share/applications
        icon.files = ../data/$${TARGET}.png
        icon.path = /usr/share/icons/hicolor/86x86/apps
    }

    target.path = $${installPrefix}/bin
    export(icon.files)
    export(icon.path)
    export(desktopfile.files)
    export(desktopfile.path)
    export(target.path)
    INSTALLS += desktopfile icon target
}

export (ICON)
export (INSTALLS)
export (DEPLOYMENT)
export (TARGET.EPOCHEAPSIZE)
export (TARGET.CAPABILITY)
export (LIBS)
export (QMAKE_EXTRA_TARGETS)
}
