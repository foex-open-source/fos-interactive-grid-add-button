window.FOS = window.FOS || {};
window.FOS.interactiveGrid = FOS.interactiveGrid || {};

FOS.interactiveGrid.addButton = function (daContext, config) {

    apex.debug.info('FOS - Interactive Grid - Add Button', config);

    var affectedElements = daContext.affectedElements;
    var regionId = affectedElements[0].id;
    var regionSelector = '#' + regionId;
    var region = apex.region(regionId);

    if(!region || !region.type == 'InteractiveGrid'){
        throw new Error('The specified element is not an Interactive Grid');
    }

    var actionsContext = region.call('getActions');

    var addToToolbar = config.addToToolbar;
    var toolbarGroupId = config.toolbarGroupId;
    var addToMenu = config.addToMenu;
    var menuId = config.menuId;
    var position = config.addAtIndex;   // -1 for the last time in the list
    var label = config.label;
    var icon = config.icon;
    var isHot = config.isHot;
    var pkItem = config.primaryKeyItem;
    var conditionColumn = config.conditionColumn;
    var eventName = config.eventName;
    var callback = config.callback;

    // if no action name was provided, we must create a new, unique one
    var actionName = config.actionName || 'fos-ig-button-' + setTimeout(new Function());

    // create an action object, but without an action function for now
    var action = {
        type: 'action',
        name: actionName,
        label: label,
        icon: icon,
        iconType: 'fa',
    };

    // depending on the type of button, the action.action function will be slightly different
    if (addToMenu && ['row-actions', 'selection-actions'].indexOf(menuId) > -1) {
        //for row and selection menus

        var grid = region.call('getViews', 'grid');
        var model = grid.model;

        if (menuId == 'row-actions') {
            action.action = function (event, focusElement) {

                var record = grid.getContextRecord(focusElement)[0];

                if (pkItem) {
                    apex.item(pkItem).setValue(model.getRecordId(record));
                }

                var data = {
                    event: event,
                    focusElement: focusElement,
                    region: region,
                    model: model,
                    record: record
                };

                if (eventName) {
                    apex.event.trigger(regionSelector, eventName, data);
                }

                if (callback) {
                    callback.call({data: data});
                }
            };
        } else if (menuId == 'selection-actions') {
            action.action = function (event, focusElement) {

                var selectedRecords = region.call('getSelectedRecords');

                var data = {
                    event: event,
                    focusElement: focusElement,
                    region: region,
                    model: model,
                    selectedRecords: selectedRecords
                };

                if (pkItem) {
                    var pkValues = selectedRecords.map(function (record) {
                        return model.getRecordId(record);
                    });
                    apex.item(pkItem).setValue(JSON.stringify(pkValues));
                }

                if (eventName) {
                    apex.event.trigger(regionSelector, eventName, data);
                }
                if (callback) {
                    callback.call({data: data});
                }
            };
        }
    } else {
        // for the toolbar and actions menu
        if (eventName) {
            action.action = function (event, focusElement) {
                var model = region.call('getCurrentView').model;
                apex.event.trigger(regionSelector, eventName, {
                    data: {
                        event: event,
                        focusElement: focusElement,
                        region: region,
                        model: model
                    }
                });
            };
        } else if (callback) {
            action.action = function (event, focusElement) {
                var model = region.call('getCurrentView').model;
                callback.call({
                    data: {
                        event: event,
                        focusElement: focusElement,
                        region: region,
                        model: model
                    }
                });
            }
        }
    }

    // add the action to the IG's actions context if it doesn't already exist
    if (!actionsContext.lookup(actionName)) {
        actionsContext.add(action);
    }

    // adding the button to a list
    if (addToMenu) {
        var menu$;
        var menuItems;
        var toolbarMenu;

        if (menuId == 'row-actions') {
            menu$ = grid.rowActionMenu$;
            menuItems = menu$.menu('option', 'items');
        } else if (menuId == 'selection-actions') {
            menu$ = grid.selActionMenu$;
            menuItems = menu$.menu('option', 'items');
        } else if (menuId == 'actions') {
            toolbarMenu = region.call('getToolbar').toolbar('find', 'actions_button').menu;
            menuItems = toolbarMenu.items;
        }

        //sanatizing the position
        if (position < 0 || position > menuItems.length) {
            position = menuItems.length;
        }

        // the items to be added
        var newItems = [{
            type: 'action',
            action: actionName
        }];

        // making sure we don't end up with consecutive separators
        if (config.addSeparatorBefore && menuItems[position - 1] && menuItems[position - 1].type != 'separator') {
            newItems.unshift({ type: 'separator' });
        }

        // making sure we don't end up with consecutive separators
        if (config.addSeparatorAfter && menuItems[position] && menuItems[position].type != 'separator') {
            newItems.push({ type: 'separator' });
        }

        // inserting the items at a specific position
        menuItems = menuItems.slice(0, position).concat(newItems).concat(menuItems.slice(position));

        if (menu$) {
            menu$.menu('option', 'items', menuItems);
        } else if (toolbarMenu) {
            toolbarMenu.items = menuItems;
        }

    } else if (addToToolbar) {
        var toolbar$ = region.call('getToolbar');
        var toolbarData = toolbar$.toolbar('option', 'data');
        var toolbarGroup = toolbar$.toolbar('findGroup', toolbarGroupId);
        var toolbarControls = toolbarGroup.controls;

        //sanatizing the position
        if (position < 0 || position > toolbarControls.length) {
            position = toolbarControls.length;
        }

        toolbarControls.splice(position, 0, {
            type: 'BUTTON',
            //label: label,     // is inherited from action
            //title: label,
            action: actionName,
            hot: isHot,
            iconOnly: !label,
            iconBeforeLabel: true,
            icon: icon ? ('fa ' + icon) : ''
        });
        toolbar$.toolbar('option', 'data', toolbarData);
    }

    // in the case of a conditional Row Actions button, hide or disable before each menu open
    if (addToMenu && menuId == 'row-actions' && conditionColumn) {
        grid.rowActionMenu$.on('menubeforeopen', function (event, ui) {
            var grid = region.call('getViews', 'grid');
            var model = grid.model;
            var record = grid.getContextRecord(grid.view$.find('.js-menuButton.is-active'))[0];
            var conditionValue = model.getValue(record, conditionColumn.toUpperCase());

            actionsContext.show(actionName);
            actionsContext.enable(actionName);

            if (conditionValue == 'hidden') {
                actionsContext.hide(actionName);
            }
            if (conditionValue == 'disabled') {
                actionsContext.disable(actionName);
            }
        });
    }
};


