# Translating Butaca into your language #

The easiest way to translate Butaca is by using [Transifex][1]. The process
should be straight-forward:

 * You will need a transifex account in order to collaborate:
   create one at [https://www.transifex.net/plans/signup/free/][2].
 * After that, you need to request the creation of a translation
   team by going to [https://www.transifex.net/projects/p/butaca/teams/][3]
   and clicking on *"Request a new team"*
   * Alternatively, if a translation team for your language is already there,
     you can request to join the team
 * You will see that there are two *"resources"*. One of them contains all the
   translatable strings used in the application, and the other one contains
   the strings used in the description in the *Nokia Store*.
 * After clicking on the resource, you will be able to start translating it
   by clicking on the *"Translate now"* button.

All strings should have the original source, in English, and a comment explaining
in which content they are used (also warning you if there's a limited room for the
string). Anyway, if you are unsure about how to translate a string and the comment
doesn't help, file a bug in our [bug tracker][4], ensuring you use the *l10n* label
on it.

# Testing your translations #

If you want to test the translations you've provided, feel free to [contact me][5]
and request me a *deb* package. Or, if you prefer, you can do it yourself, as
explained in the next section.

## Testing your translations. The DIY way ##

If you want to test the translations you've provided:

 * Download the translation clicking on *"Download for use"*
 * If it already exists, and you're modifying it, simply replace
   the file `butaca.CODE.ts` (where `CODE` represents your language) with
   the one you just downloaded from *Transifex*.
 * If it didn't exist, you'll have to copy it following the same name convention,
   and then instruct `qmake` to load it, by:
   * Open `src.pro`, go to the `TRANSLATIONS` section, and add your language
   * Run `lrelease` on it to get the `butaca.CODE.qm` file
   * Open `res.qrc` and add `butaca.CODE.qm` (it will be updated by `qmake`)
 * To manually test it on a device, build a package (as instructed in [HACKING](HACKING.md)),
   and run Butaca with `$LANG=CODE /path/to/butaca`
 * To test it under *Qt Creator*, go to the *Projects* tab, and in the *run* configuration
   (either *Harmattan* or *Qt Simulator* targets), go to the *System Environment* section,
   and set the *LANG* environment variable to your language.

### Example: Testing an Italian translation ###

Download the translated `butaca.ts` resource. The suggested name is *for_use_butaca_butacats_it.ts*,
and move that file into `src/l10n/butaca.it.ts`, in the directory where you downloaded Butaca.
Run

    $lrelease src/l10n/butaca.it.ts -qm src/l10n/butaca.it.qm

Add `butaca.it.ts` to `src.pro`. The patch would look like:

      <file>l10n/butaca.pt.qm</file>
    + <file>l10n/butaca.it.qm</file>
      <file>qml/MovieView.qml</file>

Add `butaca.it.qm` to `res.qrc`. The patch for would look like:

    -    l10n/butaca.pt.ts
    +    l10n/butaca.pt.ts \
    +    l10n/butaca.it.ts

If you created the package manually, copy it to the device and install it, and then launch Butaca from the command line:

    $LANG=it /path/to/butaca

If you are using *Qt Creator*, set the *LANG* environment to *it* before running the app.

[1]: https://www.transifex.net
[2]: https://www.transifex.net/plans/signup/free/
[3]: https://www.transifex.net/projects/p/butaca/teams/
[4]: https://github.com/spenap/butaca/issues
[5]: mailto:spena@igalia.com
