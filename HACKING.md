# Hacking Butaca #

## Getting Butaca ##

The best way to get Butaca is by cloning its git repository. Butaca is
currently available in both [Gitorious](https://gitorious.org/butaca/butaca/)
and [GitHub](https://github.com/spenap/butaca/), so you can choose any of them,
at your convenience.

    $git clone git://gitorious.org/butaca/butaca.git butaca

or

	$git clone git://github.com/spenap/butaca.git butaca

You can also download a *tar.gz* for any of the already released tags.

## The project Layout ##

Butaca is a [Qt Quick](http://qt.nokia.com/qtquick/) application.
The project layout was created using the `create-project` script
from the `project-templates` package, in [Harmattan](http://swipe.nokia.com/).

    .
    |-- data
    |-- debian
    |-- qtc_packaging
    |   `-- debian_harmattan
    `-- src
        |-- l10n
        |-- qml
        `-- resources

    8 directories

### data/ ###

This contains the icons and graphics used in the package:

 * **butaca-splash.jpg**: The splash screen used when the application is launched
 * **icon-l-butaca.png**: The 80x80 icon used in the application grid
 * **icon-m-butaca.png**: The 64x64 icon used in the *debian/control* file, which
   appears in the *Application Manager*
 * **icon-xl-butaca.png**: The 256x256 icon used in the Nokia Store

### debian/ ###

This contains all the package related information:

 * **butaca.aegis**: The aegis manifest instructing the installer to use *USER* credentials
   during the installation, so it can interact with the user home directory.
 * **changelog**, **compat** and **copyright**: are exactly the same as any
   other *Debian package*
 * **control**: Contains an encoded version of the 64x64 icon, so it appears in
   the *Application Manager*. It also contains some links (homepage, bugtracker)
   specific of *Maemo-like* distributions.
 * **postinst**: Since the initial version of Butaca saved its database in a wrong
   location, the *postinst* file copies it to the right one, if it is found in the
   old location. Currently, it only **copies** the old database, so in case any
   non-handled issue happens, old settings aren't lost.
 * **postrm**: Removes the databases when the application is uninstalled (it removes it
   on **remove and on purge**!). This is a requirement from the *Nokia Store*.
 * **rules**: They use *debhelper* and honor existing *qmake* configurations.

### qtc\_packaging/debian\_harmattan ###

*Qt Creator* adds its own packaging the *Harmattan* target is added to a project, so
it can automate all the packaging process. However, only the *rules* file is different
from the one found under the *debian/* directory: the rest of the files are simply linked.

 * **rules**: This version has been generated by the *Qt Creator*



### src/ ###

All the sources can be found here. Although the application has been written using *Qt Quick*,
several functionalities are provided from *C++* code.

#### src/l10n ####

All the translations are available under this directory. To generate them, it is currently necessary to run

    $lupdate src/*.{cpp,h} src/qml/*.qml -ts src/l10n/*.ts

When a package is built, `lrelease` gets called, updating the *.qm* files so the new translations are used.

#### src/qml ####

All the *QML* and *JS* sources can be found here.

#### src/resources ####

All the resources to be used from within the application are here (currently they are just graphic
resources). Butaca uses the [Qt Resource System](http://qt-project.org/doc/qt-4.8/resources.html)
for compiled translation files (*.qm*), *JavaScript* files, *QML* and *images*.

If you add new files from any of those categories, make sure you add it to the resources file (*res.qrc*).

## Building Butaca ##

I started developing Butaca using *scratchbox*. That should still work: all its dependencies should be marked
in the *debian/control* file, and it should build *out of the box* by doing

    > dpkg-buildpackage -I -rfakeroot -us -uc

This should create a *Debian* package and place it on *../butaca_0.9.0_armel.deb* (on *ARMEL* target).
Then, you would simply copy it to your device and install it.

However, I've been lately using *Qt Creator* almost for everything. After cloning the project, and assuming
you have a recent version of *Qt Creator*, you just need to open the *butaca.pro* project file. Then, in the
*Projects* tab, add the targets you need (*Qt Simulator*, *Harmattan*), and you're good to go.

With the *Harmattan* target, you can build, deploy and run with just one click (it will do it under
the *developer* user). With the *Qt Simulator*, it will open the integrated simulator. That second approach
currently has issues with the *SQLite Database*, so you can't save / load anything to it.

## Getting around the code ##

Most of the existing *C++* code is well commented, so once that *doxygen* support has been added,
the documentation will be made available here. With regards to *QML* code, documentation is still *work in progress*.