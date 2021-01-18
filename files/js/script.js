/* globals apex,$ */

var FOS = window.FOS || {};
FOS.interactiveGrid = FOS.interactiveGrid || {};

/**
 * This function adds a button to an Interactive Grid's various toolbar groups or menus.
 *
 * @param {object}   daContext                      Dynamic Action context as passed in by APEX
 * @param {object}   config                         Configuration object holding the button settings
 * @param {boolean}  [config.addToToolbar]          Whether the button will be added to the grid's toolbar
 * @param {string}   [config.toolbarGroupId]        Only for toolbar buttons. One of: search|reports|views|actions1|actions2|actions3|actions4
 * @param {boolean}  [config.addToMenu]             Whether the button will be added to a grid's menu
 * @param {string}   [config.menuId]                Only for menu buttons. One of: actions|row-actions|selection-actions
 * @param {number}   [config.addAtIndex]            0-based index for where the button should be added. Provide -1 for the last position
 * @param {boolean}  [config.addSeparatorBefore]    Whether to add a separator before the button. Note that if the button comes first, no separator will be added before it
 * @param {boolean}  [config.addSeparatorAfter]     Whether to add a separator after the button. Note that if the button comes last, no separator will be added after it
 * @param {string}   [config.label]                 The label of the button. If left empty, the label will be taken from the associated action
 * @param {string}   [config.icon]                  A Font APEX Icon to be added to the button
 * @param {boolean}  [config.isHot]                 Only for toolbar buttons. Whether the toolbar button should be styled as "Hot"
 * @param {boolean}  [config.iconOnly]              Only for toolbar buttons. Even if no icon was provided, you should still set this attribute to yes, just in case an icon was defined in the action
 * @param {boolean}  [config.iconRightAligned]      Only for toolbar buttons. True if the button's icon should be right-aligned.
 * @param {boolean}  [config.disableOnNoSelection]  Disable the button if no rows are selected in the grid
 * @param {boolean}  [config.disableOnNoData]       Disable the button if the grid contains no data
 * @param {boolean}  [config.hideOnNoSelection]     Hide the button if no rows are selected in the grid
 * @param {boolean}  [config.hideOnNoData]          Hide the button if the grid contains no data
 * @param {string}   [config.conditionColumn]       Only for Row Actions Menu buttons. Provide a column that determines if the button for a specific row is hidden or disabled. Values of that column should be null, "hidden" or "disabled"
 * @oaram {string}   [config.actionName]            Optional. If the button is associated with an already existing action, provide that action name. The label, icon, title, disabled state, are inherited from that action unless overridden.
 *                                                  Provide a custom string, such as "my-fancy-action", if you wish to later control the button. E.g update the label.
 *                                                  If null, an action with a random action name will be created.
 * @param {string}   [config.primaryKeyItem]        Optional. Only for Row or Selection Menu buttons. An item that will be populated with the primary key(s) of the row/selected rows when the button is clicked
 * @param {function} [config.callback]              Optional. A callback function to be called when the button is clicked.
 * @param {string}   [config.eventName]             Optional. The event name to be triggered on the grid region when the button is clicked.
 * @param {function} [initFn]                       Javascript initialization function which allows you to override any settings right before the button is created
 */
FOS.interactiveGrid.addButton = function (daContext, config, initFn) {

    var pluginName = 'FOS - Interactive Grid - Add Button';
    apex.debug.info(pluginName, config, initFn);

    // Allow the developer to perform any last (centralized) changes using Javascript Initialization Code
    if (initFn instanceof Function) {
        initFn.call(daContext, config);
    }

    // the Interactive Grid region is provided by APEX in daContext, and originates in the Affected Elements attributes
    var affectedElements = daContext.affectedElements;
    var regionId = affectedElements[0].id;
    var regionSelector = '#' + regionId;
    var region = apex.region(regionId);
    var model;
    var grid;

    if (!region || region.type != 'InteractiveGrid') {
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
    var disableOnNoSelection = config.disableOnNoSelection;
    var disableOnNoData = config.disableOnNoData;
    var hideOnNoSelection = config.hideOnNoSelection;
    var hideOnNoData = config.hideOnNoData;
    var iconOnly = config.iconOnly;
    var iconRightAligned = config.iconRightAligned;

    // if no action name was provided, we must create a new, unique one
    var actionName = config.actionName || 'fos-ig-button-' + setTimeout(function () { });

    // create an action object, but without an action function for now
    var action = {
        type: 'action',
        name: actionName,
        label: label,
        icon: icon,
        iconType: 'fa'
    };

    // Step 1. Create the onClick event
    // depending on the type of button, the action.action function will be slightly different
    if (addToMenu && ['row-actions', 'selection-actions'].indexOf(menuId) > -1) {
        //for row and selection menus

        grid = region.call('getViews', 'grid');
        model = grid.model;

        if (menuId == 'row-actions') {
            // this function defines what happens on button click
            action.action = function (event, focusElement) {

                // get the record associated with button
                var record = grid.getContextRecord(focusElement)[0];

                // assigning the primary key value to the provided page item
                if (pkItem) {
                    apex.item(pkItem).setValue(model.getRecordId(record));
                }

                // a data object that will be passed on to both the event and the callback
                var data = {
                    event: event,
                    focusElement: focusElement,
                    region: region,
                    model: model,
                    actionsContext: actionsContext,
                    record: record
                };

                if (eventName) {
                    // passing the data object as an extra parameter
                    // this will be available via this.data in the dynamic action listener
                    apex.event.trigger(regionSelector, eventName, data);
                }

                if (callback) {
                    // invoking the callback with the appropriate context
                    // the data will be available via this.data
                    callback.call({ data: data });
                }
            };
        } else if (menuId == 'selection-actions') {
            action.action = function (event, focusElement) {

                // getting the selected records
                var selectedRecords = region.call('getSelectedRecords');

                // the data to be passed to both the event and callback
                var data = {
                    event: event,
                    focusElement: focusElement,
                    region: region,
                    model: model,
                    actionsContext: actionsContext,
                    selectedRecords: selectedRecords
                };

                // when setting a page item with multiple primary keys, we concatinate and stringify them
                // if there is a single primary key column, the value will be in the form of ["8010","8011","8020"]
                // if there are multple primary key columns, the value will be in the form of "[["8010", "KING"], ["8011", "BLAKE"], ["8020", "JONES"]]"
                if (pkItem) {
                    var pkValues = selectedRecords.map(function (record) {
                        var pkValue = model.getRecordId(record);
                        // Lets see if our returned value is actually an array of values
                        try {
                            var parseResult = JSON.parse(pkValue);
                            // if the result is an array we will return it, otherwise we will return the original value
                            // to ensure consistency that all values are returned as strings i.e. JSON.parse("123") returns 123
                            return (Array.isArray(parseResult)) ? parseResult : pkValue;
                        } catch (e) {
                            // we are here if our primary key value is a simple string
                            return pkValue;
                        }
                    });
                    apex.item(pkItem).setValue(JSON.stringify(pkValues));
                }

                if (eventName) {
                    // passing the data object as an extra parameter
                    // this will be available via this.data in the dynamic action listener
                    apex.event.trigger(regionSelector, eventName, data);
                }
                if (callback) {
                    // invoking the callback with the appropriate context
                    // the data will be available via this.data
                    callback.call({ data: data });
                }
            };
        }
    } else {
        // for the toolbar and actions menu
        if (eventName) {
            action.action = function (event, focusElement) {
                model = region.call('getCurrentView').model;
                apex.event.trigger(regionSelector, eventName, {
                    event: event,
                    focusElement: focusElement,
                    region: region,
                    model: model,
                    actionsContext: actionsContext
                });
            };

        } else if (callback) {
            action.action = function (event, focusElement) {
                model = region.call('getCurrentView').model;
                callback.call({
                    data: {
                        event: event,
                        focusElement: focusElement,
                        region: region,
                        model: model,
                        actionsContext: actionsContext
                    }
                });
            };
        }
    }

    // Step 2. Add the action to the IG's actions context if it doesn't already exist
    if (!actionsContext.lookup(actionName)) {
        actionsContext.add(action);
    }

    // Step 3. Add the button to the target location
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
            action: actionName,
            label: label,
            icon: icon ? ('fa ' + icon) : ''
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
            // for regular menus, it is enough to update them via setting the option
            menu$.menu('option', 'items', menuItems);
        } else if (toolbarMenu) {
            // for toolbar menus, a refresh must be explicitly triggered
            toolbarMenu.items = menuItems;
            region.call('getToolbar').toolbar('refresh');
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
            label: label,
            //title: label,   // is inherited from action
            action: actionName,
            hot: isHot,
            iconOnly: iconOnly,
            iconBeforeLabel: !iconRightAligned,
            icon: icon ? ('fa ' + icon) : ''
        });
        toolbar$.toolbar('option', 'data', toolbarData);

        // https://github.com/foex-open-source/fos-interactive-grid-add-button/issues/5
        // Updating the toolbar is not as simple as resetting the data or refreshing it.
        // Certain controls which could be hidden in Page Designer like Search Field or Actions Menu
        //      will not remember their hidden state after refresh.
        // The following will produce and extra flash, but all controls will remember their state.
        // It is in essence how the IG handles it as well.

        // first hide all controls which do not have an associated action
        toolbar$.toolbar('findElement', 'column_filter_button').hide();
        toolbar$.toolbar('findElement', 'search_field').hide();
        toolbar$.toolbar('findElement', 'actions_button').hide();

        // then conditionally re-show them
        region.call('instance')._updateToolbarElements();
    }

    // in the case of a conditional Row Actions button, hide or disable before each menu open
    if (addToMenu && menuId == 'row-actions' && conditionColumn) {
        grid.rowActionMenu$.on('menubeforeopen', function (event, ui) {
            grid = region.call('getViews', 'grid');
            model = grid.model;

            // this is how we get the record associated to the currently opened row actions menu
            var record = grid.getContextRecord(grid.view$.find('.js-menuButton.is-active'))[0];
            var conditionValue = model.getValue(record, conditionColumn.toUpperCase());
            conditionValue = (conditionValue && conditionValue.toLowerCase) ? conditionValue.toLowerCase() : conditionValue;
            // always show and enable before menu open
            actionsContext.show(actionName);
            actionsContext.enable(actionName);

            // then either hide or disable
            if (conditionValue == 'hidden') {
                actionsContext.hide(actionName);
            } else if (conditionValue == 'disabled') {
                actionsContext.disable(actionName);
            }
        });
    }

    // Disable/Hide On No Selection
    if (disableOnNoSelection || hideOnNoSelection) {
        // disabling/enabling the button happens through the action interface
        var onSelectionChange = function () {
            var action = actionsContext.lookup(actionName);
            var recordCount = region.call('getSelectedRecords').length;
            if (disableOnNoSelection) {
                if (recordCount > 0 && action.disabled) {
                    actionsContext.enable(actionName);
                } else if (recordCount == 0 && !action.disabled) {
                    actionsContext.disable(actionName);
                }
            }
            if (hideOnNoSelection) {
                if (recordCount > 0 && action.hide) {
                    actionsContext.show(actionName);
                } else if (recordCount == 0 && !action.hide) {
                    actionsContext.hide(actionName);
                }
            }
        };
        // run once on page load
        onSelectionChange();
        // subsequently run whenever the selection changes
        // selectionchange does not fire on reportchange,
        // so we include both
        $(regionSelector).on('interactivegridselectionchange interactivegridreportchange', onSelectionChange);
    }

    // Disable/Hide On No Data
    if (disableOnNoData || hideOnNoData) {
        // disabling/enabling the button happens through the action interface
        var onDataChange = function () {
            var model = region.call('getViews', 'grid').model;
            var action = actionsContext.lookup(actionName);
            var recordCount = model._data.length;
            if (disableOnNoData) {
                if (recordCount > 0 && action.disabled) {
                    actionsContext.enable(actionName);
                } else if (recordCount == 0 && !action.disabled) {
                    actionsContext.disable(actionName);
                }
            }
            if (hideOnNoData) {
                if (recordCount > 0 && action.hide) {
                    actionsContext.show(actionName);
                } else if (recordCount == 0 && !action.hide) {
                    actionsContext.hide(actionName);
                }
            }
        };

        // run whenever the grid data changes
        var model, viewId;

        function onModelChange(){
            if(model && viewId){
                // only keep the most recent observer
                model.unSubscribe(viewId);
            }
            model = region.call('getViews', 'grid').model;
            viewId = model.subscribe({
                onChange: onDataChange
            });
            onDataChange();
        };

        // the model onChange event is not fired on report change
        // so we include an extra handler
        $(regionSelector).on('interactivegridreportchange', function(){
            onModelChange();
        });

        // run once on page load
        onModelChange();
    }

};


