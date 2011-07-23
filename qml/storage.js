/**************************************************************************
 *    Butaca
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

.pragma library

/* Adapted from: http://www.developer.nokia.com/Community/Wiki/How-to_create_a_persistent_settings_database_in_Qt_Quick_%28QML%29 */

/**
 * Get the application's database connection
 */
function getDatabase() {
    return openDatabaseSync("Butaca", "0.1", "StorageDatabase", 100000)
}

/**
 * Initialize the tables if needed
 */
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites' +
                          '(favoriteId TEXT, title TEXT, iconSource TEXT, favoriteType TINYINT)')
        })
}

/**
 * Saves a favorite into the database
 * @param favorite The favorite to save: (id, title, icon, type)
 *
 * @return The insertion index
 */
function saveFavorite(favorite) {
    var db = getDatabase()
    var insertIndex = -1
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO favorites VALUES (?,?,?,?);',
                               [favorite.id,favorite.title,favorite.icon,favorite.type])
        insertIndex = rs.insertId
    })
    return insertIndex
}

/**
 * Removes a favorite from the database
 * @param index The index to remove
 *
 * @return true if the operation is successful, Error if it failed
 */
function removeFavorite(index) {
    var db = getDatabase()
    var success = false
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM favorites WHERE ROWID = ?;',
                               [index])
        success = rs.rowsAffected > 0
    })
    return success
}

/**
 * Gets the favorites from the database
 *
 * @return The collection of favorites stored or an empty list
 */
function getFavorites() {
    var db = getDatabase()
    var res= []
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT rowid,favoriteId,title,iconSource,favoriteType FROM favorites;')
        if (rs.rows.length > 0) {
            for(var i = 0; i < rs.rows.length; i++) {
                var currentItem = rs.rows.item(i)
                res.push({'id': currentItem.favoriteId,
                          'title': currentItem.title,
                          'icon': currentItem.iconSource,
                          'type': currentItem.favoriteType,
                          'rowId': currentItem.rowid})
            }
        }
    })
    return res
}
