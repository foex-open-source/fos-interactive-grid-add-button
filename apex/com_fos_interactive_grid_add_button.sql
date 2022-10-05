prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 1039471776506160903
--     PLUGIN: 547902228942303344
--     PLUGIN: 217651153971039957
--     PLUGIN: 412155278231616931
--     PLUGIN: 1389837954374630576
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 216426771609128043
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 183507938916453268
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
--     PLUGIN: 212503470416800524
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_fos_interactive_grid_add_button
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(8354320589762683)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.FOS.INTERACTIVE_GRID_ADD_BUTTON'
,p_display_name=>'FOS - Interactive Grid - Add Button'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/script#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  This plug-in lets you easily add buttons to the interactive grid.',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-interactive-grid-add-button',
'--',
'-- =============================================================================',
'',
'function render',
'  ( p_dynamic_action apex_plugin.t_dynamic_action',
'  , p_plugin         apex_plugin.t_plugin',
'  )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result                  apex_plugin.t_dynamic_action_render_result;',
'    l_app_id                  apex_applications.application_id%type := nv(''APP_ID'');',
'    ',
'    l_add_button_to           p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_alignment               p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'',
'    l_add_at_index            number := case p_dynamic_action.attribute_02',
'                                            when ''first'' then 0',
'                                            when ''last''  then -1',
'                                            else p_dynamic_action.attribute_03',
'                                        end;',
'    ',
'    l_separator_before        boolean                            := p_dynamic_action.attribute_04 like ''%before%'';',
'    l_separator_after         boolean                            := p_dynamic_action.attribute_04 like ''%after%'';',
'',
'    l_label                   p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    l_icon                    p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_action_name             p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_07;',
'    l_condition_column        p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_08;',
'    ',
'    l_on_click                p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_09;',
'    l_pk_item                 p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_10;',
'    l_javascript_code         p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_11;',
'    l_event_name              p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_12;',
'    ',
'    l_extras                  apex_t_varchar2                    := apex_string.split(p_dynamic_action.attribute_15, '':'');',
'    ',
'    l_disable_on_no_selection boolean                            := ''disable-if-no-rows'' member of l_extras;',
'    l_disable_on_no_data      boolean                            := ''disable-if-no-data'' member of l_extras;',
'    l_hide_on_no_selection    boolean                            := ''hide-if-no-rows''    member of l_extras;',
'    l_hide_on_no_data         boolean                            := ''hide-if-no-data''    member of l_extras;',
'',
'    l_icon_only               boolean                            := ''icon-only''          member of l_extras;',
'    l_is_hot                  boolean                            := ''is-hot''             member of l_extras;',
'    l_right_aligned_icon      boolean                            := ''right-aligned-icon'' member of l_extras;',
'    l_init_js_fn              varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), ''undefined'');',
'    ',
'    function get_font_icon_prefix',
'    return varchar2',
'    is',
'        l_icon_prefix varchar2(255);',
'    begin',
'    ',
'        select /*+ result_cache */ nvl(custom_icon_prefix_class, ''fa'') prefix',
'          into l_icon_prefix',
'          from apex_application_themes',
'         where application_id = l_app_id',
'           and theme_number   = apex_application.g_flow_theme_id;',
'        ',
'        return l_icon_prefix;',
'    exception',
'        when no_data_found then',
'            return ''fa'';',
'    end get_font_icon_prefix;',
'    ',
'begin',
'    -- standard debugging intro, but only if necessary',
'    if apex_application.g_debug and substr(:DEBUG,6) >= 6',
'    then',
'        apex_plugin_util.debug_dynamic_action',
'          ( p_plugin         => p_plugin',
'          , p_dynamic_action => p_dynamic_action',
'          );',
'    end if;',
'',
'    -- create a JS function call passing all settings as a JSON object',
'    --',
'    -- example:',
'    -- FOS.interactiveGrid.addButton(this, {',
'    --    "addToMenu": true,',
'    --    "menuId": "row-actions",',
'    --    "addAtIndex": -1,',
'    --    "addSeparatorBefore": false,',
'    --    "addSeparatorAfter": false,',
'    --    "label": "Lemon",',
'    --    "icon": "fa-lemon-o",',
'    --    "eventName": "lemon-clicked",',
'    --    "disableOnNoSelection": true',
'    --    "disableOnNoData": true',
'    --    "hideOnNoSelection": true',
'    --    "hideOnNoData": true',
'    --    "iconOnly": false',
'    -- });',
'',
'    -- building the json object',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    if l_add_button_to like ''toolbar-%'' ',
'    then',
'        apex_json.write(''addToToolbar''    , true);',
'        apex_json.write(''toolbarGroupId''  , substr(l_add_button_to, 9)); -- stripping away "toolbar-"',
'    elsif l_add_button_to like ''menu-%'' ',
'    then',
'        apex_json.write(''addToMenu''       , true);',
'        apex_json.write(''menuId''          , substr(l_add_button_to, 6)); -- stripping away "menu-"              ',
'    end if;',
'',
'    apex_json.write(''addAtIndex''          , l_add_at_index);',
'',
'    apex_json.write(''addSeparatorBefore''  , l_separator_before);',
'    apex_json.write(''addSeparatorAfter''   , l_separator_after);',
'',
'    apex_json.write(''label''               , l_label);',
'    apex_json.write(''icon''                , l_icon);',
'    apex_json.write(''isHot''               , l_is_hot);',
'    apex_json.write(''disableOnNoSelection'', l_disable_on_no_selection);',
'    apex_json.write(''disableOnNoData''     , l_disable_on_no_data);',
'    apex_json.write(''hideOnNoSelection''   , l_hide_on_no_selection);',
'    apex_json.write(''hideOnNoData''        , l_hide_on_no_data);',
'    apex_json.write(''iconOnly''            , l_icon_only);',
'    apex_json.write(''iconRightAligned''    , l_right_aligned_icon);',
'    apex_json.write(''iconPrefix''          , get_font_icon_prefix);',
'    ',
'    apex_json.write(''conditionColumn''     , l_condition_column);',
'    ',
'    apex_json.write(''actionName''          , l_action_name);',
'    ',
'    case l_on_click',
'        when ''return-pks-into-item'' then',
'            apex_json.write(''primaryKeyItem'', l_pk_item);',
'        when ''execute-javascript-code'' then',
'            apex_json.write_raw(''callback'', ''function(){'' || l_javascript_code || ''}'');',
'        when ''trigger-event'' then',
'            apex_json.write(''eventName''   , l_event_name);',
'        else',
'            null;',
'    end case;',
'    ',
'    apex_json.close_object;',
'    ',
'    l_result.javascript_function := ''function(){FOS.interactiveGrid.addButton(this, '' || apex_json.get_clob_output|| '', ''|| l_init_js_fn || '');}'';',
'    ',
'    apex_json.free_output;',
'    ',
'    -- all done, return l_result now containing the javascript function',
'    return l_result;',
'end render;'))
,p_api_version=>1
,p_render_function=>'render'
,p_standard_attributes=>'REGION:REQUIRED:INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'    The <strong>FOS - Interactive Grid - Add Button</strong> plug-in is a simple way for adding buttons to the Interactive Grid. Whether it''s the toolbar, the actions menu, the row actions menu or the row selection menu, this plug-in allows you to ex'
||'tend all of these components with your own, highly customizable buttons, declaratively.',
'</p>',
'<p>',
'    The plug-in''s settings give you fine control over the buttons position (first, last, index), look, icon, and which action should be executed when that button is clicked. You can execute a predefined action (ie. delete row), execute some JavaScrip'
||'t code, trigger an event, put the currently selected row(s) pk value into a page item, or even provide your own actions.',
'</p>'))
,p_version_identifier=>'22.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>956
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8354523139762685)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Add Button To'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'toolbar-actions4'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The element to which the button should be added.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8354962247762687)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>10
,p_display_value=>'Toolbar - Search Box Group'
,p_return_value=>'toolbar-search'
,p_help_text=>'<p>Search Box Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8355480171762688)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>20
,p_display_value=>'Toolbar - Saved Reports Group'
,p_return_value=>'toolbar-reports'
,p_help_text=>'<p>Saved Reports Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8355921400762688)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>30
,p_display_value=>'Toolbar - View Switch Group'
,p_return_value=>'toolbar-views'
,p_help_text=>'<p>View Switch Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8356498617762689)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>40
,p_display_value=>'Toolbar - Actions Menu Group'
,p_return_value=>'toolbar-actions1'
,p_help_text=>'<p>Actions Menu Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8356971130762689)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>50
,p_display_value=>'Toolbar - Edit & Save Group'
,p_return_value=>'toolbar-actions2'
,p_help_text=>'<p>Edit & Save Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8357420905762689)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>60
,p_display_value=>'Toolbar - Add Row Group'
,p_return_value=>'toolbar-actions3'
,p_help_text=>'<p>Add Row Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8357991207762689)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>70
,p_display_value=>'Toolbar - Reset Group'
,p_return_value=>'toolbar-actions4'
,p_help_text=>'<p>Reset Group</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8973655859182797)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>80
,p_display_value=>'Menu - Actions'
,p_return_value=>'menu-actions'
,p_help_text=>'<p>The Actions menu in the Interactive Grid toolbar</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8358475656762689)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>90
,p_display_value=>'Menu - Row Actions'
,p_return_value=>'menu-row-actions'
,p_help_text=>'<p>The Row Actions menu. The Interactive Grid must have an Actions Menu column defined.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8358955587762690)
,p_plugin_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_display_sequence=>100
,p_display_value=>'Menu - Selection Actions'
,p_return_value=>'menu-selection-actions'
,p_help_text=>'<p>The Selection Actions menu. The Interactive Grid must have an Actions Menu column defined.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8359416432762690)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Alignment'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'last'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Choose how to align the button.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8359872019762690)
,p_plugin_attribute_id=>wwv_flow_api.id(8359416432762690)
,p_display_sequence=>10
,p_display_value=>'First'
,p_return_value=>'first'
,p_help_text=>'<p>First in the list</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8360314858762690)
,p_plugin_attribute_id=>wwv_flow_api.id(8359416432762690)
,p_display_sequence=>20
,p_display_value=>'Last'
,p_return_value=>'last'
,p_help_text=>'<p>Last in the list</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8360886131762691)
,p_plugin_attribute_id=>wwv_flow_api.id(8359416432762690)
,p_display_sequence=>30
,p_display_value=>'Custom'
,p_return_value=>'custom'
,p_help_text=>'<p>At a specific index</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8361363404762691)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Add at Index'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8359416432762690)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'custom'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The index at which the button should be added.</p>',
'<p>This is a 0 based index, which means that 0 corresponds to the first item in the list, 1 to the second, and so on.</p>',
'<p>When adding a button to a popup menu, separators have to be kept in mind, as they also count to the list entries.</p>',
'<p>For example, in the list [button, separator, button], adding a newButton at index 2 will result in [button, separator, newButton, button].</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8361757871762691)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Separator'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'none'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'menu-row-actions,menu-selection-actions,menu-actions'
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Choose whether to add a separator, a horizontal delimiter, together with the button.</p>',
'<p>Note that a separator will not be added if there already exists a separator in that place.</p>',
'<p>Similarly, separators will not be added if they are the first or last item in the list.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8362148153762691)
,p_plugin_attribute_id=>wwv_flow_api.id(8361757871762691)
,p_display_sequence=>10
,p_display_value=>'None'
,p_return_value=>'none'
,p_help_text=>'<p>Do not add a separator</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8362673360762692)
,p_plugin_attribute_id=>wwv_flow_api.id(8361757871762691)
,p_display_sequence=>20
,p_display_value=>'Before'
,p_return_value=>'before'
,p_help_text=>'<p>Add a separator above the button</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8363120501762692)
,p_plugin_attribute_id=>wwv_flow_api.id(8361757871762691)
,p_display_sequence=>30
,p_display_value=>'After'
,p_return_value=>'after'
,p_help_text=>'<p>Add a separator below the button</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8363606409762693)
,p_plugin_attribute_id=>wwv_flow_api.id(8361757871762691)
,p_display_sequence=>40
,p_display_value=>'Before & After'
,p_return_value=>'before,after'
,p_help_text=>'<p>Add a separator both above and below the button</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8364120235762693)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Label'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>true
,p_help_text=>'<p>The label of the button.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8364528714762693)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>'<p>The icon of the button.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8366917855762694)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Action Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'<li><code>row-add-row</code> - Insert a row straight after the current row</li>',
'<li><code>row-duplicate</code> - Duplicate the current row</li>	',
'<li><code>row-delete</code> - Delete the current row</li>',
'<li><code>row-refresh</code> - Refresh the current row</li>',
'<li><code>row-revert</code> - Revert the current row to its original state when the Interactive Grid region was refreshed</li>',
'<li><code>edit</code> - Toggle the current edit mode</li>',
'<li><code>refresh</code> - Refresh the Interactive Grid region</li>',
'<li><code>save</code> - Save the current data changes. Note: Interactive Grid must be editable</li>',
'<li><code>show-download-dialog</code> - Show the download dialog</li>',
'<li><code>my-custom-action</code> - the name/id of your own custom action</li>',
'</ul>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This attribute is <b>optional</b>.</p>',
'',
'<p>If you wish for the button to trigger a built-in function of the Interactive Grid, such as saving changes or opening the downloads dialog, pass its corresponding "Action Name". You can find a list of all options under: <a href="https://apex.oracle'
||'.com/jsapi" target="_blank">https://apex.oracle.com/jsapi</a> > Widgets > interactiveGrid > Actions. <b>Then set the "On Click" attribute to "Do Nothing - Action is handled externally"</b></p>',
'',
'<p>If you wish to later control the button (disable, hide, change label, etc) pass a unique identifier here. You can then use it to get a reference to the action via the <code>apex.actions</code> namespace.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8365798831762694)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Condition Column'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'menu-row-actions'
,p_help_text=>'<p>The button can be hidden or be displayed as disabled on a row-by-row basis. This functionality can be acieved by providing the name of the column that holds this information. If the value of this column is <code>hidden</code>, the button will not '
||'show. If it''s <code>disabled</code>, it will show but be displayed as disabled. If the value is anything else, the button will appear normally.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8870272332251703)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'On Click'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'execute-javascript-code'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Defines the type of action that will be performed on click of the button.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8870555899257211)
,p_plugin_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_display_sequence=>10
,p_display_value=>'Do nothing - Action is handled externally'
,p_return_value=>'do-nothing'
,p_help_text=>'<p>Choose this option if the action is already defined and handled by the Interactive Grid</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8870947456263343)
,p_plugin_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_display_sequence=>20
,p_display_value=>'Return Primary Key(s) into Item'
,p_return_value=>'return-pks-into-item'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option is only valid if the button location is in the Row Actions Menu or the Row Selection Menu.</p>',
'<p>On button click, the primary key(s) of the selected row(s) will be stringified and populated into a page item. One can then listen on change of that item, and proceed from there.</p>',
'<h4>A note on the form of the primary key</h4>',
'<p>If the Interactive Grid has exactly 1 primary key column the values will be an Array of ID''s returned in JSON encoded string ["7839","7698"].</p>',
'<p>If the Interactive Grid has more than 1 primary key column the values will be a multi-dimensional Array of ID''s returned in JSON encoded string , e.g <code>[["7839","KING"],["7698","BLAKE"]]</code>. You can convert this string back to JSON either '
||'in JavaScript via <code>JSON.parse</code> or in PL/SQL via <code>APEX_JSON.PARSE</code>.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8871354046265530)
,p_plugin_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_display_sequence=>30
,p_display_value=>'Execute JavaScript Code'
,p_return_value=>'execute-javascript-code'
,p_help_text=>'<p>Execute JavaScript code. The code will be executed with a different context (<code>this</code>) depending on the type of button configured.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(8871721785266321)
,p_plugin_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_display_sequence=>40
,p_display_value=>'Trigger Event'
,p_return_value=>'trigger-event'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Triggers a custom event on the Interactive Grid element.</p>',
'<p>The event will be triggered with an object of extra parameters. Consult the JavaScript Code attribute help text for more information.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8365324271762693)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Page Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'return-pks-into-item'
,p_help_text=>'<p>The Page Item to be populated with the values of the primary key(s) of the affected row(s).</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8366502310762694)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'JavaScript Code'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'execute-javascript-code'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The JavaScript Code to be executed on button click. Depending on the button location, the code will have access to different attributes.</p>',
'<p>Buttons in any location will have access to:</p>',
'<ul>',
'<li><code>this.data.event</code> - Browser event that caused the action to be invoked</li>',
'<li><code>this.data.focusElement</code> - The element that had focus when the action was invoked</li>',
'<li><code>this.data.region</code> - Interactive Grid region object</li>',
'<li><code>this.data.model</code> - Model object of the current view</li>',
'<li><code>this.data.actionsContext</code> - The actionsContext object of the current view</li>',
'</ul>',
'<br>',
'<p>Additionally for Row Action buttons:</p>',
'<ul>',
'<li><code>this.data.record</code> - The record for which the action was invoked</li>',
'</ul>',
'<br>',
'<p>Additionally for Selection Action buttons:</p>',
'<ul>',
'<li><code>this.data.selectedRecords</code> - An array of the selected records</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8366192079762694)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Event Name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8870272332251703)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'trigger-event'
,p_help_text=>'<p>The name of the event to be triggered on the Interactive Grid.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(15873180667092386)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Extra Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Extra button options. Note that some of these only apply to toolbar buttons.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(15875452450100378)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)
,p_display_sequence=>10
,p_display_value=>'Disable On No Selection'
,p_return_value=>'disable-if-no-rows'
,p_help_text=>'Disable the button if no rows are selected in the Interactive Grid.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(33642256685800892)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)
,p_display_sequence=>20
,p_display_value=>'Disable On No Data'
,p_return_value=>'disable-if-no-data'
,p_help_text=>'Disable the button if the grid contains no data.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(100909284884621979)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)
,p_display_sequence=>30
,p_display_value=>'Hide On No Selection'
,p_return_value=>'hide-if-no-rows'
,p_help_text=>'Hide the button if no rows are selected in the Interactive Grid.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16851853135938672)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)

,p_display_sequence=>40
,p_display_value=>'[Toolbar Only] Hot'
,p_return_value=>'is-hot'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option only applies to toolbar buttons.</p>',
'<p>Choose if the button is styled "Hot", that is, if the button takes the primary color of the application.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(100909670336624705)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)
,p_display_sequence=>40
,p_display_value=>'Hide On No Data'
,p_return_value=>'hide-if-no-data'
,p_help_text=>'Hide the button if the grid contains no data.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(30104401008923039)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)
,p_display_sequence=>50
,p_display_value=>'[Toolbar Only] Right-aligned Icon'
,p_return_value=>'right-aligned-icon'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option only applies to toolbar buttons that have an icon defined.</p>',
'<p>By default, toolbar button icons are left-aligned. Choose this option if you wish to right-align the icon.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(16450317324294272)
,p_plugin_attribute_id=>wwv_flow_api.id(15873180667092386)
,p_display_sequence=>60
,p_display_value=>'[Toolbar Only] Icon Only'
,p_return_value=>'icon-only'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This option only applies to toolbar buttons.</p>',
'<p>Toggle this option if you only want the button to have an icon and no label.</p>'))
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(36755761007723289)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function(config){',
'    config.label = ''New Label'';',
'}',
'</pre>'))
,p_help_text=>'Javascript initialization function which allows you to override any settings right before the button is created'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C7320617065782C24202A2F0A0A76617220464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E696E74657261637469766547726964203D20464F532E696E74657261637469766547726964207C7C207B7D3B0A0A';
wwv_flow_api.g_varchar2_table(2) := '2F2A2A0A202A20546869732066756E6374696F6E2061646473206120627574746F6E20746F20616E20496E7465726163746976652047726964277320766172696F757320746F6F6C6261722067726F757073206F72206D656E75732E0A202A0A202A2040';
wwv_flow_api.g_varchar2_table(3) := '706172616D207B6F626A6563747D2020206461436F6E746578742020202020202020202020202020202020202020202044796E616D696320416374696F6E20636F6E746578742061732070617373656420696E20627920415045580A202A204070617261';
wwv_flow_api.g_varchar2_table(4) := '6D207B6F626A6563747D202020636F6E66696720202020202020202020202020202020202020202020202020436F6E66696775726174696F6E206F626A65637420686F6C64696E672074686520627574746F6E2073657474696E67730A202A2040706172';
wwv_flow_api.g_varchar2_table(5) := '616D207B626F6F6C65616E7D20205B636F6E6669672E616464546F546F6F6C6261725D20202020202020202020576865746865722074686520627574746F6E2077696C6C20626520616464656420746F207468652067726964277320746F6F6C6261720A';
wwv_flow_api.g_varchar2_table(6) := '202A2040706172616D207B737472696E677D2020205B636F6E6669672E746F6F6C62617247726F757049645D20202020202020204F6E6C7920666F7220746F6F6C62617220627574746F6E732E204F6E65206F663A207365617263687C7265706F727473';
wwv_flow_api.g_varchar2_table(7) := '7C76696577737C616374696F6E73317C616374696F6E73327C616374696F6E73337C616374696F6E73340A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E616464546F4D656E755D202020202020202020202020205768657468';
wwv_flow_api.g_varchar2_table(8) := '65722074686520627574746F6E2077696C6C20626520616464656420746F206120677269642773206D656E750A202A2040706172616D207B737472696E677D2020205B636F6E6669672E6D656E7549645D202020202020202020202020202020204F6E6C';
wwv_flow_api.g_varchar2_table(9) := '7920666F72206D656E7520627574746F6E732E204F6E65206F663A20616374696F6E737C726F772D616374696F6E737C73656C656374696F6E2D616374696F6E730A202A2040706172616D207B6E756D6265727D2020205B636F6E6669672E6164644174';
wwv_flow_api.g_varchar2_table(10) := '496E6465785D202020202020202020202020302D626173656420696E64657820666F722077686572652074686520627574746F6E2073686F756C642062652061646465642E2050726F76696465202D3120666F7220746865206C61737420706F73697469';
wwv_flow_api.g_varchar2_table(11) := '6F6E0A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E616464536570617261746F724265666F72655D202020205768657468657220746F20616464206120736570617261746F72206265666F72652074686520627574746F6E2E';
wwv_flow_api.g_varchar2_table(12) := '204E6F746520746861742069662074686520627574746F6E20636F6D65732066697273742C206E6F20736570617261746F722077696C6C206265206164646564206265666F72652069740A202A2040706172616D207B626F6F6C65616E7D20205B636F6E';
wwv_flow_api.g_varchar2_table(13) := '6669672E616464536570617261746F7241667465725D20202020205768657468657220746F20616464206120736570617261746F722061667465722074686520627574746F6E2E204E6F746520746861742069662074686520627574746F6E20636F6D65';
wwv_flow_api.g_varchar2_table(14) := '73206C6173742C206E6F20736570617261746F722077696C6C2062652061646465642061667465722069740A202A2040706172616D207B737472696E677D2020205B636F6E6669672E6C6162656C5D202020202020202020202020202020202054686520';
wwv_flow_api.g_varchar2_table(15) := '6C6162656C206F662074686520627574746F6E2E204966206C65667420656D7074792C20746865206C6162656C2077696C6C2062652074616B656E2066726F6D20746865206173736F63696174656420616374696F6E0A202A2040706172616D207B7374';
wwv_flow_api.g_varchar2_table(16) := '72696E677D2020205B636F6E6669672E69636F6E5D2020202020202020202020202020202020204120466F6E7420415045582049636F6E20746F20626520616464656420746F2074686520627574746F6E0A202A2040706172616D207B626F6F6C65616E';
wwv_flow_api.g_varchar2_table(17) := '7D20205B636F6E6669672E6973486F745D20202020202020202020202020202020204F6E6C7920666F7220746F6F6C62617220627574746F6E732E20576865746865722074686520746F6F6C62617220627574746F6E2073686F756C6420626520737479';
wwv_flow_api.g_varchar2_table(18) := '6C65642061732022486F74220A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E69636F6E4F6E6C795D20202020202020202020202020204F6E6C7920666F7220746F6F6C62617220627574746F6E732E204576656E206966206E';
wwv_flow_api.g_varchar2_table(19) := '6F2069636F6E207761732070726F76696465642C20796F752073686F756C64207374696C6C2073657420746869732061747472696275746520746F207965732C206A75737420696E206361736520616E2069636F6E2077617320646566696E656420696E';
wwv_flow_api.g_varchar2_table(20) := '2074686520616374696F6E0A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E69636F6E5269676874416C69676E65645D2020202020204F6E6C7920666F7220746F6F6C62617220627574746F6E732E2054727565206966207468';
wwv_flow_api.g_varchar2_table(21) := '6520627574746F6E27732069636F6E2073686F756C642062652072696768742D616C69676E65642E0A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E64697361626C654F6E4E6F53656C656374696F6E5D202044697361626C65';
wwv_flow_api.g_varchar2_table(22) := '2074686520627574746F6E206966206E6F20726F7773206172652073656C656374656420696E2074686520677269640A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E64697361626C654F6E4E6F446174615D20202020202020';
wwv_flow_api.g_varchar2_table(23) := '44697361626C652074686520627574746F6E20696620746865206772696420636F6E7461696E73206E6F20646174610A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E686964654F6E4E6F53656C656374696F6E5D2020202020';
wwv_flow_api.g_varchar2_table(24) := '486964652074686520627574746F6E206966206E6F20726F7773206172652073656C656374656420696E2074686520677269640A202A2040706172616D207B626F6F6C65616E7D20205B636F6E6669672E686964654F6E4E6F446174615D202020202020';
wwv_flow_api.g_varchar2_table(25) := '20202020486964652074686520627574746F6E20696620746865206772696420636F6E7461696E73206E6F20646174610A202A2040706172616D207B737472696E677D2020205B636F6E6669672E636F6E646974696F6E436F6C756D6E5D202020202020';
wwv_flow_api.g_varchar2_table(26) := '204F6E6C7920666F7220526F7720416374696F6E73204D656E7520627574746F6E732E2050726F76696465206120636F6C756D6E20746861742064657465726D696E65732069662074686520627574746F6E20666F72206120737065636966696320726F';
wwv_flow_api.g_varchar2_table(27) := '772069732068696464656E206F722064697361626C65642E2056616C756573206F66207468617420636F6C756D6E2073686F756C64206265206E756C6C2C202268696464656E22206F72202264697361626C6564220A202A20406F6172616D207B737472';
wwv_flow_api.g_varchar2_table(28) := '696E677D2020205B636F6E6669672E616374696F6E4E616D655D2020202020202020202020204F7074696F6E616C2E2049662074686520627574746F6E206973206173736F636961746564207769746820616E20616C7265616479206578697374696E67';
wwv_flow_api.g_varchar2_table(29) := '20616374696F6E2C2070726F76696465207468617420616374696F6E206E616D652E20546865206C6162656C2C2069636F6E2C207469746C652C2064697361626C65642073746174652C2061726520696E686572697465642066726F6D20746861742061';
wwv_flow_api.g_varchar2_table(30) := '6374696F6E20756E6C657373206F76657272696464656E2E0A202A202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202050726F76696465206120637573746F6D20737472696E67';
wwv_flow_api.g_varchar2_table(31) := '2C207375636820617320226D792D66616E63792D616374696F6E222C20696620796F75207769736820746F206C6174657220636F6E74726F6C2074686520627574746F6E2E20452E672075706461746520746865206C6162656C2E0A202A202020202020';
wwv_flow_api.g_varchar2_table(32) := '20202020202020202020202020202020202020202020202020202020202020202020202020202020202020204966206E756C6C2C20616E20616374696F6E207769746820612072616E646F6D20616374696F6E206E616D652077696C6C20626520637265';
wwv_flow_api.g_varchar2_table(33) := '617465642E0A202A2040706172616D207B737472696E677D2020205B636F6E6669672E7072696D6172794B65794974656D5D20202020202020204F7074696F6E616C2E204F6E6C7920666F7220526F77206F722053656C656374696F6E204D656E752062';
wwv_flow_api.g_varchar2_table(34) := '7574746F6E732E20416E206974656D20746861742077696C6C20626520706F70756C61746564207769746820746865207072696D617279206B6579287329206F662074686520726F772F73656C656374656420726F7773207768656E2074686520627574';
wwv_flow_api.g_varchar2_table(35) := '746F6E20697320636C69636B65640A202A2040706172616D207B66756E6374696F6E7D205B636F6E6669672E63616C6C6261636B5D20202020202020202020202020204F7074696F6E616C2E20412063616C6C6261636B2066756E6374696F6E20746F20';
wwv_flow_api.g_varchar2_table(36) := '62652063616C6C6564207768656E2074686520627574746F6E20697320636C69636B65642E0A202A2040706172616D207B737472696E677D2020205B636F6E6669672E6576656E744E616D655D202020202020202020202020204F7074696F6E616C2E20';
wwv_flow_api.g_varchar2_table(37) := '546865206576656E74206E616D6520746F20626520747269676765726564206F6E20746865206772696420726567696F6E207768656E2074686520627574746F6E20697320636C69636B65642E0A202A2040706172616D207B66756E6374696F6E7D205B';
wwv_flow_api.g_varchar2_table(38) := '696E6974466E5D20202020202020202020202020202020202020202020204A61766173637269707420696E697469616C697A6174696F6E2066756E6374696F6E20776869636820616C6C6F777320796F7520746F206F7665727269646520616E79207365';
wwv_flow_api.g_varchar2_table(39) := '7474696E6773207269676874206265666F72652074686520627574746F6E20697320637265617465640A202A2F0A464F532E696E746572616374697665477269642E616464427574746F6E203D2066756E6374696F6E20286461436F6E746578742C2063';
wwv_flow_api.g_varchar2_table(40) := '6F6E6669672C20696E6974466E29207B0A0A2020202076617220706C7567696E4E616D65203D2027464F53202D20496E7465726163746976652047726964202D2041646420427574746F6E273B0A20202020617065782E64656275672E696E666F28706C';
wwv_flow_api.g_varchar2_table(41) := '7567696E4E616D652C20636F6E6669672C20696E6974466E293B0A0A202020202F2F20416C6C6F772074686520646576656C6F70657220746F20706572666F726D20616E79206C617374202863656E7472616C697A656429206368616E67657320757369';
wwv_flow_api.g_varchar2_table(42) := '6E67204A61766173637269707420496E697469616C697A6174696F6E20436F64650A2020202069662028696E6974466E20696E7374616E63656F662046756E6374696F6E29207B0A2020202020202020696E6974466E2E63616C6C286461436F6E746578';
wwv_flow_api.g_varchar2_table(43) := '742C20636F6E666967293B0A202020207D0A0A202020202F2F2074686520496E746572616374697665204772696420726567696F6E2069732070726F7669646564206279204150455820696E206461436F6E746578742C20616E64206F726967696E6174';
wwv_flow_api.g_varchar2_table(44) := '657320696E2074686520416666656374656420456C656D656E747320617474726962757465730A20202020766172206166666563746564456C656D656E7473203D206461436F6E746578742E6166666563746564456C656D656E74733B0A202020207661';
wwv_flow_api.g_varchar2_table(45) := '7220726567696F6E4964203D206166666563746564456C656D656E74735B305D2E69643B0A2020202076617220726567696F6E53656C6563746F72203D20272327202B20726567696F6E49643B0A2020202076617220726567696F6E203D20617065782E';
wwv_flow_api.g_varchar2_table(46) := '726567696F6E28726567696F6E4964293B0A20202020766172206D6F64656C3B0A2020202076617220677269643B0A0A202020206966202821726567696F6E207C7C20726567696F6E2E7479706520213D2027496E746572616374697665477269642729';
wwv_flow_api.g_varchar2_table(47) := '207B0A20202020202020207468726F77206E6577204572726F7228275468652073706563696669656420656C656D656E74206973206E6F7420616E20496E746572616374697665204772696427293B0A202020207D0A0A2020202076617220616374696F';
wwv_flow_api.g_varchar2_table(48) := '6E73436F6E74657874203D20726567696F6E2E63616C6C2827676574416374696F6E7327293B0A2020202076617220616464546F546F6F6C626172203D20636F6E6669672E616464546F546F6F6C6261723B0A2020202076617220746F6F6C6261724772';
wwv_flow_api.g_varchar2_table(49) := '6F75704964203D20636F6E6669672E746F6F6C62617247726F757049643B0A2020202076617220616464546F4D656E75203D20636F6E6669672E616464546F4D656E753B0A20202020766172206D656E754964203D20636F6E6669672E6D656E7549643B';
wwv_flow_api.g_varchar2_table(50) := '0A2020202076617220706F736974696F6E203D20636F6E6669672E6164644174496E6465783B2020202F2F202D3120666F7220746865206C6173742074696D6520696E20746865206C6973740A20202020766172206C6162656C203D20636F6E6669672E';
wwv_flow_api.g_varchar2_table(51) := '6C6162656C3B0A202020207661722069636F6E203D20636F6E6669672E69636F6E3B0A20202020766172206973486F74203D20636F6E6669672E6973486F743B0A2020202076617220706B4974656D203D20636F6E6669672E7072696D6172794B657949';
wwv_flow_api.g_varchar2_table(52) := '74656D3B0A2020202076617220636F6E646974696F6E436F6C756D6E203D20636F6E6669672E636F6E646974696F6E436F6C756D6E3B0A20202020766172206576656E744E616D65203D20636F6E6669672E6576656E744E616D653B0A20202020766172';
wwv_flow_api.g_varchar2_table(53) := '2063616C6C6261636B203D20636F6E6669672E63616C6C6261636B3B0A202020207661722064697361626C654F6E4E6F53656C656374696F6E203D20636F6E6669672E64697361626C654F6E4E6F53656C656374696F6E3B0A2020202076617220646973';
wwv_flow_api.g_varchar2_table(54) := '61626C654F6E4E6F44617461203D20636F6E6669672E64697361626C654F6E4E6F446174613B0A2020202076617220686964654F6E4E6F53656C656374696F6E203D20636F6E6669672E686964654F6E4E6F53656C656374696F6E3B0A20202020766172';
wwv_flow_api.g_varchar2_table(55) := '20686964654F6E4E6F44617461203D20636F6E6669672E686964654F6E4E6F446174613B0A202020207661722069636F6E4F6E6C79203D20636F6E6669672E69636F6E4F6E6C793B0A202020207661722069636F6E5269676874416C69676E6564203D20';
wwv_flow_api.g_varchar2_table(56) := '636F6E6669672E69636F6E5269676874416C69676E65643B0A202020207661722069636F6E507265666978203D20636F6E6669672E69636F6E5072656669783B0A0A202020202F2F206966206E6F20616374696F6E206E616D65207761732070726F7669';
wwv_flow_api.g_varchar2_table(57) := '6465642C207765206D757374206372656174652061206E65772C20756E69717565206F6E650A2020202076617220616374696F6E4E616D65203D20636F6E6669672E616374696F6E4E616D65207C7C2027666F732D69672D627574746F6E2D27202B2073';
wwv_flow_api.g_varchar2_table(58) := '657454696D656F75742866756E6374696F6E202829207B207D293B0A0A202020202F2F2063726561746520616E20616374696F6E206F626A6563742C2062757420776974686F757420616E20616374696F6E2066756E6374696F6E20666F72206E6F770A';
wwv_flow_api.g_varchar2_table(59) := '2020202076617220616374696F6E203D207B0A2020202020202020747970653A2027616374696F6E272C0A20202020202020206E616D653A20616374696F6E4E616D652C0A20202020202020206C6162656C3A206C6162656C2C0A202020202020202069';
wwv_flow_api.g_varchar2_table(60) := '636F6E3A2069636F6E2C0A202020202020202069636F6E547970653A2069636F6E5072656669780A202020207D3B0A0A202020202F2F205374657020312E2043726561746520746865206F6E436C69636B206576656E740A202020202F2F20646570656E';
wwv_flow_api.g_varchar2_table(61) := '64696E67206F6E207468652074797065206F6620627574746F6E2C2074686520616374696F6E2E616374696F6E2066756E6374696F6E2077696C6C20626520736C696768746C7920646966666572656E740A2020202069662028616464546F4D656E7520';
wwv_flow_api.g_varchar2_table(62) := '2626205B27726F772D616374696F6E73272C202773656C656374696F6E2D616374696F6E73275D2E696E6465784F66286D656E75496429203E202D3129207B0A20202020202020202F2F666F7220726F7720616E642073656C656374696F6E206D656E75';
wwv_flow_api.g_varchar2_table(63) := '730A0A202020202020202067726964203D20726567696F6E2E63616C6C28276765745669657773272C20276772696427293B0A20202020202020206D6F64656C203D20677269642E6D6F64656C3B0A0A2020202020202020696620286D656E754964203D';
wwv_flow_api.g_varchar2_table(64) := '3D2027726F772D616374696F6E732729207B0A2020202020202020202020202F2F20746869732066756E6374696F6E20646566696E657320776861742068617070656E73206F6E20627574746F6E20636C69636B0A202020202020202020202020616374';
wwv_flow_api.g_varchar2_table(65) := '696F6E2E616374696F6E203D2066756E6374696F6E20286576656E742C20666F637573456C656D656E7429207B0A0A202020202020202020202020202020202F2F2067657420746865207265636F7264206173736F636961746564207769746820627574';
wwv_flow_api.g_varchar2_table(66) := '746F6E0A20202020202020202020202020202020766172207265636F7264203D20677269642E676574436F6E746578745265636F726428666F637573456C656D656E74295B305D3B0A0A202020202020202020202020202020202F2F2061737369676E69';
wwv_flow_api.g_varchar2_table(67) := '6E6720746865207072696D617279206B65792076616C756520746F207468652070726F76696465642070616765206974656D0A2020202020202020202020202020202069662028706B4974656D29207B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(68) := '20617065782E6974656D28706B4974656D292E73657456616C7565286D6F64656C2E6765745265636F72644964287265636F726429293B0A202020202020202020202020202020207D0A0A202020202020202020202020202020202F2F20612064617461';
wwv_flow_api.g_varchar2_table(69) := '206F626A65637420746861742077696C6C20626520706173736564206F6E20746F20626F746820746865206576656E7420616E64207468652063616C6C6261636B0A202020202020202020202020202020207661722064617461203D207B0A2020202020';
wwv_flow_api.g_varchar2_table(70) := '2020202020202020202020202020206576656E743A206576656E742C0A2020202020202020202020202020202020202020666F637573456C656D656E743A20666F637573456C656D656E742C0A2020202020202020202020202020202020202020726567';
wwv_flow_api.g_varchar2_table(71) := '696F6E3A20726567696F6E2C0A20202020202020202020202020202020202020206D6F64656C3A206D6F64656C2C0A2020202020202020202020202020202020202020616374696F6E73436F6E746578743A20616374696F6E73436F6E746578742C0A20';
wwv_flow_api.g_varchar2_table(72) := '202020202020202020202020202020202020207265636F72643A207265636F72640A202020202020202020202020202020207D3B0A0A20202020202020202020202020202020696620286576656E744E616D6529207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(73) := '202020202020202F2F2070617373696E67207468652064617461206F626A65637420617320616E20657874726120706172616D657465720A20202020202020202020202020202020202020202F2F20746869732077696C6C20626520617661696C61626C';
wwv_flow_api.g_varchar2_table(74) := '652076696120746869732E6461746120696E207468652064796E616D696320616374696F6E206C697374656E65720A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228726567696F6E53656C6563746F72';
wwv_flow_api.g_varchar2_table(75) := '2C206576656E744E616D652C2064617461293B0A202020202020202020202020202020207D0A0A202020202020202020202020202020206966202863616C6C6261636B29207B0A20202020202020202020202020202020202020202F2F20696E766F6B69';
wwv_flow_api.g_varchar2_table(76) := '6E67207468652063616C6C6261636B20776974682074686520617070726F70726961746520636F6E746578740A20202020202020202020202020202020202020202F2F2074686520646174612077696C6C20626520617661696C61626C65207669612074';
wwv_flow_api.g_varchar2_table(77) := '6869732E646174610A202020202020202020202020202020202020202063616C6C6261636B2E63616C6C287B20646174613A2064617461207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D3B0A20202020202020';
wwv_flow_api.g_varchar2_table(78) := '207D20656C736520696620286D656E754964203D3D202773656C656374696F6E2D616374696F6E732729207B0A202020202020202020202020616374696F6E2E616374696F6E203D2066756E6374696F6E20286576656E742C20666F637573456C656D65';
wwv_flow_api.g_varchar2_table(79) := '6E7429207B0A0A202020202020202020202020202020202F2F2067657474696E67207468652073656C6563746564207265636F7264730A202020202020202020202020202020207661722073656C65637465645265636F726473203D20726567696F6E2E';
wwv_flow_api.g_varchar2_table(80) := '63616C6C282767657453656C65637465645265636F72647327293B0A0A202020202020202020202020202020202F2F20746865206461746120746F2062652070617373656420746F20626F746820746865206576656E7420616E642063616C6C6261636B';
wwv_flow_api.g_varchar2_table(81) := '0A202020202020202020202020202020207661722064617461203D207B0A20202020202020202020202020202020202020206576656E743A206576656E742C0A2020202020202020202020202020202020202020666F637573456C656D656E743A20666F';
wwv_flow_api.g_varchar2_table(82) := '637573456C656D656E742C0A2020202020202020202020202020202020202020726567696F6E3A20726567696F6E2C0A20202020202020202020202020202020202020206D6F64656C3A206D6F64656C2C0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(83) := '2020616374696F6E73436F6E746578743A20616374696F6E73436F6E746578742C0A202020202020202020202020202020202020202073656C65637465645265636F7264733A2073656C65637465645265636F7264730A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(84) := '2020207D3B0A0A202020202020202020202020202020202F2F207768656E2073657474696E6720612070616765206974656D2077697468206D756C7469706C65207072696D617279206B6579732C20776520636F6E636174696E61746520616E64207374';
wwv_flow_api.g_varchar2_table(85) := '72696E67696679207468656D0A202020202020202020202020202020202F2F20696620746865726520697320612073696E676C65207072696D617279206B657920636F6C756D6E2C207468652076616C75652077696C6C20626520696E2074686520666F';
wwv_flow_api.g_varchar2_table(86) := '726D206F66205B2238303130222C2238303131222C2238303230225D0A202020202020202020202020202020202F2F20696620746865726520617265206D756C74706C65207072696D617279206B657920636F6C756D6E732C207468652076616C756520';
wwv_flow_api.g_varchar2_table(87) := '77696C6C20626520696E2074686520666F726D206F6620225B5B2238303130222C20224B494E47225D2C205B2238303131222C2022424C414B45225D2C205B2238303230222C20224A4F4E4553225D5D220A202020202020202020202020202020206966';
wwv_flow_api.g_varchar2_table(88) := '2028706B4974656D29207B0A202020202020202020202020202020202020202076617220706B56616C756573203D2073656C65637465645265636F7264732E6D61702866756E6374696F6E20287265636F726429207B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(89) := '202020202020202020202076617220706B56616C7565203D206D6F64656C2E6765745265636F72644964287265636F7264293B0A2020202020202020202020202020202020202020202020202F2F204C65747320736565206966206F7572207265747572';
wwv_flow_api.g_varchar2_table(90) := '6E65642076616C75652069732061637475616C6C7920616E206172726179206F662076616C7565730A202020202020202020202020202020202020202020202020747279207B0A2020202020202020202020202020202020202020202020202020202076';
wwv_flow_api.g_varchar2_table(91) := '6172207061727365526573756C74203D204A534F4E2E706172736528706B56616C7565293B0A202020202020202020202020202020202020202020202020202020202F2F2069662074686520726573756C7420697320616E206172726179207765207769';
wwv_flow_api.g_varchar2_table(92) := '6C6C2072657475726E2069742C206F74686572776973652077652077696C6C2072657475726E20746865206F726967696E616C2076616C75650A202020202020202020202020202020202020202020202020202020202F2F20746F20656E737572652063';
wwv_flow_api.g_varchar2_table(93) := '6F6E73697374656E6379207468617420616C6C2076616C756573206172652072657475726E656420617320737472696E677320692E652E204A534F4E2E7061727365282231323322292072657475726E73203132330A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(94) := '202020202020202020202020202072657475726E202841727261792E69734172726179287061727365526573756C742929203F207061727365526573756C74203A20706B56616C75653B0A2020202020202020202020202020202020202020202020207D';
wwv_flow_api.g_varchar2_table(95) := '20636174636820286529207B0A202020202020202020202020202020202020202020202020202020202F2F207765206172652068657265206966206F7572207072696D617279206B65792076616C756520697320612073696D706C6520737472696E670A';
wwv_flow_api.g_varchar2_table(96) := '2020202020202020202020202020202020202020202020202020202072657475726E20706B56616C75653B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D293B0A202020202020';
wwv_flow_api.g_varchar2_table(97) := '2020202020202020202020202020617065782E6974656D28706B4974656D292E73657456616C7565284A534F4E2E737472696E6769667928706B56616C75657329293B0A202020202020202020202020202020207D0A0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(98) := '202020696620286576656E744E616D6529207B0A20202020202020202020202020202020202020202F2F2070617373696E67207468652064617461206F626A65637420617320616E20657874726120706172616D657465720A2020202020202020202020';
wwv_flow_api.g_varchar2_table(99) := '2020202020202020202F2F20746869732077696C6C20626520617661696C61626C652076696120746869732E6461746120696E207468652064796E616D696320616374696F6E206C697374656E65720A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(100) := '617065782E6576656E742E7472696767657228726567696F6E53656C6563746F722C206576656E744E616D652C2064617461293B0A202020202020202020202020202020207D0A202020202020202020202020202020206966202863616C6C6261636B29';
wwv_flow_api.g_varchar2_table(101) := '207B0A20202020202020202020202020202020202020202F2F20696E766F6B696E67207468652063616C6C6261636B20776974682074686520617070726F70726961746520636F6E746578740A20202020202020202020202020202020202020202F2F20';
wwv_flow_api.g_varchar2_table(102) := '74686520646174612077696C6C20626520617661696C61626C652076696120746869732E646174610A202020202020202020202020202020202020202063616C6C6261636B2E63616C6C287B20646174613A2064617461207D293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(103) := '20202020202020207D0A2020202020202020202020207D3B0A20202020202020207D0A202020207D20656C7365207B0A20202020202020202F2F20666F722074686520746F6F6C62617220616E6420616374696F6E73206D656E750A2020202020202020';
wwv_flow_api.g_varchar2_table(104) := '696620286576656E744E616D6529207B0A202020202020202020202020616374696F6E2E616374696F6E203D2066756E6374696F6E20286576656E742C20666F637573456C656D656E7429207B0A202020202020202020202020202020206D6F64656C20';
wwv_flow_api.g_varchar2_table(105) := '3D20726567696F6E2E63616C6C282767657443757272656E745669657727292E6D6F64656C3B0A20202020202020202020202020202020617065782E6576656E742E7472696767657228726567696F6E53656C6563746F722C206576656E744E616D652C';
wwv_flow_api.g_varchar2_table(106) := '207B0A20202020202020202020202020202020202020206576656E743A206576656E742C0A2020202020202020202020202020202020202020666F637573456C656D656E743A20666F637573456C656D656E742C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(107) := '2020202020726567696F6E3A20726567696F6E2C0A20202020202020202020202020202020202020206D6F64656C3A206D6F64656C2C0A2020202020202020202020202020202020202020616374696F6E73436F6E746578743A20616374696F6E73436F';
wwv_flow_api.g_varchar2_table(108) := '6E746578742C0A202020202020202020202020202020202020202073656C65637465645265636F7264733A20726567696F6E2E63616C6C282767657453656C65637465645265636F72647327290A202020202020202020202020202020207D293B0A2020';
wwv_flow_api.g_varchar2_table(109) := '202020202020202020207D3B0A0A20202020202020207D20656C7365206966202863616C6C6261636B29207B0A202020202020202020202020616374696F6E2E616374696F6E203D2066756E6374696F6E20286576656E742C20666F637573456C656D65';
wwv_flow_api.g_varchar2_table(110) := '6E7429207B0A202020202020202020202020202020206D6F64656C203D20726567696F6E2E63616C6C282767657443757272656E745669657727292E6D6F64656C3B0A2020202020202020202020202020202063616C6C6261636B2E63616C6C287B0A20';
wwv_flow_api.g_varchar2_table(111) := '20202020202020202020202020202020202020646174613A207B0A2020202020202020202020202020202020202020202020206576656E743A206576656E742C0A202020202020202020202020202020202020202020202020666F637573456C656D656E';
wwv_flow_api.g_varchar2_table(112) := '743A20666F637573456C656D656E742C0A202020202020202020202020202020202020202020202020726567696F6E3A20726567696F6E2C0A2020202020202020202020202020202020202020202020206D6F64656C3A206D6F64656C2C0A2020202020';
wwv_flow_api.g_varchar2_table(113) := '20202020202020202020202020202020202020616374696F6E73436F6E746578743A20616374696F6E73436F6E746578742C0A20202020202020202020202020202020202020202020202073656C65637465645265636F7264733A20726567696F6E2E63';
wwv_flow_api.g_varchar2_table(114) := '616C6C282767657453656C65637465645265636F72647327290A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A2020202020202020202020207D3B0A20202020202020207D0A202020207D0A0A';
wwv_flow_api.g_varchar2_table(115) := '202020202F2F205374657020322E204164642074686520616374696F6E20746F20746865204947277320616374696F6E7320636F6E7465787420696620697420646F65736E277420616C72656164792065786973740A202020206966202821616374696F';

wwv_flow_api.g_varchar2_table(116) := '6E73436F6E746578742E6C6F6F6B757028616374696F6E4E616D652929207B0A2020202020202020616374696F6E73436F6E746578742E61646428616374696F6E293B0A202020207D0A0A202020202F2F205374657020332E2041646420746865206275';
wwv_flow_api.g_varchar2_table(117) := '74746F6E20746F2074686520746172676574206C6F636174696F6E0A2020202069662028616464546F4D656E7529207B0A0A2020202020202020766172206D656E75243B0A2020202020202020766172206D656E754974656D733B0A2020202020202020';
wwv_flow_api.g_varchar2_table(118) := '76617220746F6F6C6261724D656E753B0A0A2020202020202020696620286D656E754964203D3D2027726F772D616374696F6E732729207B0A2020202020202020202020206D656E7524203D20677269642E726F77416374696F6E4D656E75243B0A2020';
wwv_flow_api.g_varchar2_table(119) := '202020202020202020206D656E754974656D73203D206D656E75242E6D656E7528276F7074696F6E272C20276974656D7327293B0A20202020202020207D20656C736520696620286D656E754964203D3D202773656C656374696F6E2D616374696F6E73';
wwv_flow_api.g_varchar2_table(120) := '2729207B0A2020202020202020202020206D656E7524203D20677269642E73656C416374696F6E4D656E75243B0A2020202020202020202020206D656E754974656D73203D206D656E75242E6D656E7528276F7074696F6E272C20276974656D7327293B';
wwv_flow_api.g_varchar2_table(121) := '0A20202020202020207D20656C736520696620286D656E754964203D3D2027616374696F6E732729207B0A202020202020202020202020746F6F6C6261724D656E75203D20726567696F6E2E63616C6C2827676574546F6F6C62617227292E746F6F6C62';
wwv_flow_api.g_varchar2_table(122) := '6172282766696E64272C2027616374696F6E735F627574746F6E27292E6D656E753B0A2020202020202020202020206D656E754974656D73203D20746F6F6C6261724D656E752E6974656D733B0A20202020202020207D0A0A20202020202020202F2F73';
wwv_flow_api.g_varchar2_table(123) := '616E6174697A696E672074686520706F736974696F6E0A202020202020202069662028706F736974696F6E203C2030207C7C20706F736974696F6E203E206D656E754974656D732E6C656E67746829207B0A202020202020202020202020706F73697469';
wwv_flow_api.g_varchar2_table(124) := '6F6E203D206D656E754974656D732E6C656E6774683B0A20202020202020207D0A0A20202020202020202F2F20746865206974656D7320746F2062652061646465640A2020202020202020766172206E65774974656D73203D205B7B0A20202020202020';
wwv_flow_api.g_varchar2_table(125) := '2020202020747970653A2027616374696F6E272C0A202020202020202020202020616374696F6E3A20616374696F6E4E616D652C0A2020202020202020202020206C6162656C3A206C6162656C2C0A20202020202020202020202069636F6E3A2069636F';
wwv_flow_api.g_varchar2_table(126) := '6E203F20282766612027202B2069636F6E29203A2027270A20202020202020207D5D3B0A0A20202020202020202F2F206D616B696E67207375726520776520646F6E277420656E64207570207769746820636F6E73656375746976652073657061726174';
wwv_flow_api.g_varchar2_table(127) := '6F72730A202020202020202069662028636F6E6669672E616464536570617261746F724265666F7265202626206D656E754974656D735B706F736974696F6E202D20315D202626206D656E754974656D735B706F736974696F6E202D20315D2E74797065';
wwv_flow_api.g_varchar2_table(128) := '20213D2027736570617261746F722729207B0A2020202020202020202020206E65774974656D732E756E7368696674287B20747970653A2027736570617261746F7227207D293B0A20202020202020207D0A0A20202020202020202F2F206D616B696E67';
wwv_flow_api.g_varchar2_table(129) := '207375726520776520646F6E277420656E64207570207769746820636F6E736563757469766520736570617261746F72730A202020202020202069662028636F6E6669672E616464536570617261746F724166746572202626206D656E754974656D735B';
wwv_flow_api.g_varchar2_table(130) := '706F736974696F6E5D202626206D656E754974656D735B706F736974696F6E5D2E7479706520213D2027736570617261746F722729207B0A2020202020202020202020206E65774974656D732E70757368287B20747970653A2027736570617261746F72';
wwv_flow_api.g_varchar2_table(131) := '27207D293B0A20202020202020207D0A0A20202020202020202F2F20696E73657274696E6720746865206974656D73206174206120737065636966696320706F736974696F6E0A20202020202020206D656E754974656D73203D206D656E754974656D73';
wwv_flow_api.g_varchar2_table(132) := '2E736C69636528302C20706F736974696F6E292E636F6E636174286E65774974656D73292E636F6E636174286D656E754974656D732E736C69636528706F736974696F6E29293B0A0A2020202020202020696620286D656E752429207B0A202020202020';
wwv_flow_api.g_varchar2_table(133) := '2020202020202F2F20666F7220726567756C6172206D656E75732C20697420697320656E6F75676820746F20757064617465207468656D207669612073657474696E6720746865206F7074696F6E0A2020202020202020202020206D656E75242E6D656E';
wwv_flow_api.g_varchar2_table(134) := '7528276F7074696F6E272C20276974656D73272C206D656E754974656D73293B0A20202020202020207D20656C73652069662028746F6F6C6261724D656E7529207B0A2020202020202020202020202F2F20666F7220746F6F6C626172206D656E75732C';
wwv_flow_api.g_varchar2_table(135) := '20612072656672657368206D757374206265206578706C696369746C7920747269676765726564200A202020202020202020202020746F6F6C6261724D656E752E6974656D73203D206D656E754974656D733B0A20202020202020202020202072656769';
wwv_flow_api.g_varchar2_table(136) := '6F6E2E63616C6C2827676574546F6F6C62617227292E746F6F6C62617228277265667265736827293B0A20202020202020207D0A0A202020207D20656C73652069662028616464546F546F6F6C62617229207B0A202020202020202076617220746F6F6C';
wwv_flow_api.g_varchar2_table(137) := '62617224203D20726567696F6E2E63616C6C2827676574546F6F6C62617227293B0A202020202020202076617220746F6F6C62617244617461203D20746F6F6C626172242E746F6F6C62617228276F7074696F6E272C20276461746127293B0A20202020';
wwv_flow_api.g_varchar2_table(138) := '2020202076617220746F6F6C62617247726F7570203D20746F6F6C626172242E746F6F6C626172282766696E6447726F7570272C20746F6F6C62617247726F75704964293B0A202020202020202076617220746F6F6C626172436F6E74726F6C73203D20';
wwv_flow_api.g_varchar2_table(139) := '746F6F6C62617247726F75702E636F6E74726F6C733B0A0A20202020202020202F2F73616E6174697A696E672074686520706F736974696F6E0A202020202020202069662028706F736974696F6E203C2030207C7C20706F736974696F6E203E20746F6F';
wwv_flow_api.g_varchar2_table(140) := '6C626172436F6E74726F6C732E6C656E67746829207B0A202020202020202020202020706F736974696F6E203D20746F6F6C626172436F6E74726F6C732E6C656E6774683B0A20202020202020207D0A0A2020202020202020746F6F6C626172436F6E74';
wwv_flow_api.g_varchar2_table(141) := '726F6C732E73706C69636528706F736974696F6E2C20302C207B0A202020202020202020202020747970653A2027425554544F4E272C0A2020202020202020202020206C6162656C3A206C6162656C2C0A2020202020202020202020202F2F7469746C65';
wwv_flow_api.g_varchar2_table(142) := '3A206C6162656C2C2020202F2F20697320696E686572697465642066726F6D20616374696F6E0A202020202020202020202020616374696F6E3A20616374696F6E4E616D652C0A202020202020202020202020686F743A206973486F742C0A2020202020';
wwv_flow_api.g_varchar2_table(143) := '2020202020202069636F6E4F6E6C793A2069636F6E4F6E6C792C0A20202020202020202020202069636F6E4265666F72654C6162656C3A202169636F6E5269676874416C69676E65642C0A20202020202020202020202069636F6E3A2069636F6E203F20';
wwv_flow_api.g_varchar2_table(144) := '282766612027202B2069636F6E29203A2027270A20202020202020207D293B0A2020202020202020746F6F6C626172242E746F6F6C62617228276F7074696F6E272C202764617461272C20746F6F6C62617244617461293B0A0A20202020202020202F2F';
wwv_flow_api.g_varchar2_table(145) := '2068747470733A2F2F6769746875622E636F6D2F666F65782D6F70656E2D736F757263652F666F732D696E7465726163746976652D677269642D6164642D627574746F6E2F6973737565732F350A20202020202020202F2F205570646174696E67207468';
wwv_flow_api.g_varchar2_table(146) := '6520746F6F6C626172206973206E6F742061732073696D706C6520617320726573657474696E67207468652064617461206F722072656672657368696E672069742E0A20202020202020202F2F204365727461696E20636F6E74726F6C73207768696368';
wwv_flow_api.g_varchar2_table(147) := '20636F756C642062652068696464656E20696E20506167652044657369676E6572206C696B6520536561726368204669656C64206F7220416374696F6E73204D656E750A20202020202020202F2F20202020202077696C6C206E6F742072656D656D6265';
wwv_flow_api.g_varchar2_table(148) := '722074686569722068696464656E20737461746520616674657220726566726573682E0A20202020202020202F2F2054686520666F6C6C6F77696E672077696C6C2070726F6475636520616E6420657874726120666C6173682C2062757420616C6C2063';
wwv_flow_api.g_varchar2_table(149) := '6F6E74726F6C732077696C6C2072656D656D6265722074686569722073746174652E0A20202020202020202F2F20497420697320696E20657373656E636520686F77207468652049472068616E646C65732069742061732077656C6C2E0A202020202020';
wwv_flow_api.g_varchar2_table(150) := '20200A20202020202020202F2F206669727374206869646520616C6C20636F6E74726F6C7320776869636820646F206E6F74206861766520616E206173736F63696174656420616374696F6E0A2020202020202020746F6F6C626172242E746F6F6C6261';
wwv_flow_api.g_varchar2_table(151) := '72282766696E64456C656D656E74272C2027636F6C756D6E5F66696C7465725F627574746F6E27292E6869646528293B0A2020202020202020746F6F6C626172242E746F6F6C626172282766696E64456C656D656E74272C20277365617263685F666965';
wwv_flow_api.g_varchar2_table(152) := '6C6427292E6869646528293B0A2020202020202020746F6F6C626172242E746F6F6C626172282766696E64456C656D656E74272C2027616374696F6E735F627574746F6E27292E6869646528293B0A0A20202020202020202F2F207468656E20636F6E64';
wwv_flow_api.g_varchar2_table(153) := '6974696F6E616C6C792072652D73686F77207468656D0A2020202020202020726567696F6E2E63616C6C2827696E7374616E636527292E5F757064617465546F6F6C626172456C656D656E747328293B0A202020207D0A0A202020202F2F20696E207468';
wwv_flow_api.g_varchar2_table(154) := '652063617365206F66206120636F6E646974696F6E616C20526F7720416374696F6E7320627574746F6E2C2068696465206F722064697361626C65206265666F72652065616368206D656E75206F70656E0A2020202069662028616464546F4D656E7520';
wwv_flow_api.g_varchar2_table(155) := '2626206D656E754964203D3D2027726F772D616374696F6E732720262620636F6E646974696F6E436F6C756D6E29207B0A2020202020202020677269642E726F77416374696F6E4D656E75242E6F6E28276D656E756265666F72656F70656E272C206675';
wwv_flow_api.g_varchar2_table(156) := '6E6374696F6E20286576656E742C20756929207B0A20202020202020202020202067726964203D20726567696F6E2E63616C6C28276765745669657773272C20276772696427293B0A2020202020202020202020206D6F64656C203D20677269642E6D6F';
wwv_flow_api.g_varchar2_table(157) := '64656C3B0A0A2020202020202020202020202F2F207468697320697320686F772077652067657420746865207265636F7264206173736F63696174656420746F207468652063757272656E746C79206F70656E656420726F7720616374696F6E73206D65';
wwv_flow_api.g_varchar2_table(158) := '6E750A202020202020202020202020766172207265636F7264203D20677269642E676574436F6E746578745265636F726428677269642E76696577242E66696E642827627574746F6E5B646174612D6D656E755D2E69732D6163746976652729295B305D';
wwv_flow_api.g_varchar2_table(159) := '3B0A20202020202020202020202076617220636F6E646974696F6E56616C7565203D206D6F64656C2E67657456616C7565287265636F72642C20636F6E646974696F6E436F6C756D6E2E746F5570706572436173652829293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(160) := '2020636F6E646974696F6E56616C7565203D2028636F6E646974696F6E56616C756520262620636F6E646974696F6E56616C75652E746F4C6F7765724361736529203F20636F6E646974696F6E56616C75652E746F4C6F776572436173652829203A2063';
wwv_flow_api.g_varchar2_table(161) := '6F6E646974696F6E56616C75653B0A2020202020202020202020202F2F20616C776179732073686F7720616E6420656E61626C65206265666F7265206D656E75206F70656E0A202020202020202020202020616374696F6E73436F6E746578742E73686F';
wwv_flow_api.g_varchar2_table(162) := '7728616374696F6E4E616D65293B0A202020202020202020202020616374696F6E73436F6E746578742E656E61626C6528616374696F6E4E616D65293B0A0A2020202020202020202020202F2F207468656E206569746865722068696465206F72206469';
wwv_flow_api.g_varchar2_table(163) := '7361626C650A20202020202020202020202069662028636F6E646974696F6E56616C7565203D3D202768696464656E2729207B0A20202020202020202020202020202020616374696F6E73436F6E746578742E6869646528616374696F6E4E616D65293B';
wwv_flow_api.g_varchar2_table(164) := '0A2020202020202020202020207D20656C73652069662028636F6E646974696F6E56616C7565203D3D202764697361626C65642729207B0A20202020202020202020202020202020616374696F6E73436F6E746578742E64697361626C6528616374696F';
wwv_flow_api.g_varchar2_table(165) := '6E4E616D65293B0A2020202020202020202020207D0A20202020202020207D293B0A202020207D0A0A202020202F2F2044697361626C652F48696465204F6E204E6F2053656C656374696F6E0A202020206966202864697361626C654F6E4E6F53656C65';
wwv_flow_api.g_varchar2_table(166) := '6374696F6E207C7C20686964654F6E4E6F53656C656374696F6E29207B0A20202020202020202F2F2064697361626C696E672F656E61626C696E672074686520627574746F6E2068617070656E73207468726F7567682074686520616374696F6E20696E';
wwv_flow_api.g_varchar2_table(167) := '746572666163650A2020202020202020766172206F6E53656C656374696F6E4368616E6765203D2066756E6374696F6E202829207B0A20202020202020202020202076617220616374696F6E203D20616374696F6E73436F6E746578742E6C6F6F6B7570';
wwv_flow_api.g_varchar2_table(168) := '28616374696F6E4E616D65293B0A202020202020202020202020766172207265636F7264436F756E74203D20726567696F6E2E63616C6C282767657453656C65637465645265636F72647327292E6C656E6774683B0A2020202020202020202020206966';
wwv_flow_api.g_varchar2_table(169) := '202864697361626C654F6E4E6F53656C656374696F6E29207B0A20202020202020202020202020202020696620287265636F7264436F756E74203E203020262620616374696F6E2E64697361626C656429207B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(170) := '20202020616374696F6E73436F6E746578742E656E61626C6528616374696F6E4E616D65293B0A202020202020202020202020202020207D20656C736520696620287265636F7264436F756E74203D3D20302026262021616374696F6E2E64697361626C';
wwv_flow_api.g_varchar2_table(171) := '656429207B0A2020202020202020202020202020202020202020616374696F6E73436F6E746578742E64697361626C6528616374696F6E4E616D65293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A202020202020';
wwv_flow_api.g_varchar2_table(172) := '20202020202069662028686964654F6E4E6F53656C656374696F6E29207B0A20202020202020202020202020202020696620287265636F7264436F756E74203E203020262620616374696F6E2E6869646529207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(173) := '2020202020616374696F6E73436F6E746578742E73686F7728616374696F6E4E616D65293B0A202020202020202020202020202020207D20656C736520696620287265636F7264436F756E74203D3D20302026262021616374696F6E2E6869646529207B';
wwv_flow_api.g_varchar2_table(174) := '0A2020202020202020202020202020202020202020616374696F6E73436F6E746578742E6869646528616374696F6E4E616D65293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D3B0A202020';
wwv_flow_api.g_varchar2_table(175) := '20202020202F2F2072756E206F6E6365206F6E2070616765206C6F61640A20202020202020206F6E53656C656374696F6E4368616E676528293B0A20202020202020202F2F2073756273657175656E746C792072756E207768656E657665722074686520';
wwv_flow_api.g_varchar2_table(176) := '73656C656374696F6E206368616E6765730A20202020202020202F2F2073656C656374696F6E6368616E676520646F6573206E6F742066697265206F6E207265706F72746368616E67652C0A20202020202020202F2F20736F20776520696E636C756465';
wwv_flow_api.g_varchar2_table(177) := '20626F74680A20202020202020202428726567696F6E53656C6563746F72292E6F6E2827696E7465726163746976656772696473656C656374696F6E6368616E676520696E746572616374697665677269647265706F72746368616E6765272C206F6E53';
wwv_flow_api.g_varchar2_table(178) := '656C656374696F6E4368616E6765293B0A202020207D0A0A202020202F2F2044697361626C652F48696465204F6E204E6F20446174610A202020206966202864697361626C654F6E4E6F44617461207C7C20686964654F6E4E6F4461746129207B0A2020';
wwv_flow_api.g_varchar2_table(179) := '2020202020202F2F2064697361626C696E672F656E61626C696E672074686520627574746F6E2068617070656E73207468726F7567682074686520616374696F6E20696E746572666163650A2020202020202020766172206F6E446174614368616E6765';
wwv_flow_api.g_varchar2_table(180) := '203D2066756E6374696F6E202829207B0A202020202020202020202020766172206D6F64656C203D20726567696F6E2E63616C6C28276765745669657773272C20276772696427292E6D6F64656C3B0A2020202020202020202020207661722061637469';
wwv_flow_api.g_varchar2_table(181) := '6F6E203D20616374696F6E73436F6E746578742E6C6F6F6B757028616374696F6E4E616D65293B0A202020202020202020202020766172207265636F7264436F756E74203D206D6F64656C2E5F646174612E6C656E6774683B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(182) := '20206966202864697361626C654F6E4E6F4461746129207B0A20202020202020202020202020202020696620287265636F7264436F756E74203E203020262620616374696F6E2E64697361626C656429207B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(183) := '202020616374696F6E73436F6E746578742E656E61626C6528616374696F6E4E616D65293B0A202020202020202020202020202020207D20656C736520696620287265636F7264436F756E74203D3D20302026262021616374696F6E2E64697361626C65';
wwv_flow_api.g_varchar2_table(184) := '6429207B0A2020202020202020202020202020202020202020616374696F6E73436F6E746578742E64697361626C6528616374696F6E4E616D65293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020';
wwv_flow_api.g_varchar2_table(185) := '202020202069662028686964654F6E4E6F4461746129207B0A20202020202020202020202020202020696620287265636F7264436F756E74203E203020262620616374696F6E2E6869646529207B0A202020202020202020202020202020202020202061';
wwv_flow_api.g_varchar2_table(186) := '6374696F6E73436F6E746578742E73686F7728616374696F6E4E616D65293B0A202020202020202020202020202020207D20656C736520696620287265636F7264436F756E74203D3D20302026262021616374696F6E2E6869646529207B0A2020202020';
wwv_flow_api.g_varchar2_table(187) := '202020202020202020202020202020616374696F6E73436F6E746578742E6869646528616374696F6E4E616D65293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D3B0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(188) := '2F2F2072756E207768656E657665722074686520677269642064617461206368616E6765730A2020202020202020766172206D6F64656C2C207669657749643B0A0A202020202020202066756E6374696F6E206F6E4D6F64656C4368616E676528297B0A';
wwv_flow_api.g_varchar2_table(189) := '2020202020202020202020206966286D6F64656C20262620766965774964297B0A202020202020202020202020202020202F2F206F6E6C79206B65657020746865206D6F737420726563656E74206F627365727665720A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(190) := '2020206D6F64656C2E756E53756273637269626528766965774964293B0A2020202020202020202020207D0A2020202020202020202020206D6F64656C203D20726567696F6E2E63616C6C28276765745669657773272C20276772696427292E6D6F6465';
wwv_flow_api.g_varchar2_table(191) := '6C3B0A202020202020202020202020766965774964203D206D6F64656C2E737562736372696265287B0A202020202020202020202020202020206F6E4368616E67653A206F6E446174614368616E67650A2020202020202020202020207D293B0A202020';
wwv_flow_api.g_varchar2_table(192) := '2020202020202020206F6E446174614368616E676528293B0A20202020202020207D3B0A0A20202020202020202F2F20746865206D6F64656C206F6E4368616E6765206576656E74206973206E6F74206669726564206F6E207265706F7274206368616E';
wwv_flow_api.g_varchar2_table(193) := '67650A20202020202020202F2F20736F20776520696E636C75646520616E2065787472612068616E646C65720A20202020202020202428726567696F6E53656C6563746F72292E6F6E2827696E746572616374697665677269647265706F72746368616E';
wwv_flow_api.g_varchar2_table(194) := '6765272C2066756E6374696F6E28297B0A2020202020202020202020206F6E4D6F64656C4368616E676528293B0A20202020202020207D293B0A0A20202020202020202F2F2072756E206F6E6365206F6E2070616765206C6F61640A2020202020202020';
wwv_flow_api.g_varchar2_table(195) := '6F6E4D6F64656C4368616E676528293B0A202020207D0A0A7D3B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(8368510717762699)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B22464F53222C2277696E646F77222C22696E74657261637469766547726964222C22616464427574746F6E222C226461436F6E746578';
wwv_flow_api.g_varchar2_table(2) := '74222C22636F6E666967222C22696E6974466E222C2261706578222C226465627567222C22696E666F222C2246756E6374696F6E222C2263616C6C222C2267726964222C22726567696F6E4964222C226166666563746564456C656D656E7473222C2269';
wwv_flow_api.g_varchar2_table(3) := '64222C22726567696F6E53656C6563746F72222C22726567696F6E222C2274797065222C224572726F72222C22616374696F6E73436F6E74657874222C22616464546F546F6F6C626172222C22746F6F6C62617247726F75704964222C22616464546F4D';
wwv_flow_api.g_varchar2_table(4) := '656E75222C226D656E754964222C22706F736974696F6E222C226164644174496E646578222C226C6162656C222C2269636F6E222C226973486F74222C22706B4974656D222C227072696D6172794B65794974656D222C22636F6E646974696F6E436F6C';
wwv_flow_api.g_varchar2_table(5) := '756D6E222C226576656E744E616D65222C2263616C6C6261636B222C2264697361626C654F6E4E6F53656C656374696F6E222C2264697361626C654F6E4E6F44617461222C22686964654F6E4E6F53656C656374696F6E222C22686964654F6E4E6F4461';
wwv_flow_api.g_varchar2_table(6) := '7461222C2269636F6E4F6E6C79222C2269636F6E5269676874416C69676E6564222C2269636F6E507265666978222C22616374696F6E4E616D65222C2273657454696D656F7574222C22616374696F6E222C226E616D65222C2269636F6E54797065222C';
wwv_flow_api.g_varchar2_table(7) := '22696E6465784F66222C226D6F64656C222C226576656E74222C22666F637573456C656D656E74222C227265636F7264222C22676574436F6E746578745265636F7264222C226974656D222C2273657456616C7565222C226765745265636F7264496422';
wwv_flow_api.g_varchar2_table(8) := '2C2264617461222C2274726967676572222C2273656C65637465645265636F726473222C22706B56616C756573222C226D6170222C22706B56616C7565222C227061727365526573756C74222C224A534F4E222C227061727365222C224172726179222C';
wwv_flow_api.g_varchar2_table(9) := '2269734172726179222C2265222C22737472696E67696679222C226C6F6F6B7570222C22616464222C226D656E7524222C226D656E754974656D73222C22746F6F6C6261724D656E75222C22726F77416374696F6E4D656E7524222C226D656E75222C22';
wwv_flow_api.g_varchar2_table(10) := '73656C416374696F6E4D656E7524222C22746F6F6C626172222C226974656D73222C226C656E677468222C226E65774974656D73222C22616464536570617261746F724265666F7265222C22756E7368696674222C22616464536570617261746F724166';
wwv_flow_api.g_varchar2_table(11) := '746572222C2270757368222C22736C696365222C22636F6E636174222C22746F6F6C62617224222C22746F6F6C62617244617461222C22746F6F6C626172436F6E74726F6C73222C22636F6E74726F6C73222C2273706C696365222C22686F74222C2269';
wwv_flow_api.g_varchar2_table(12) := '636F6E4265666F72654C6162656C222C2268696465222C225F757064617465546F6F6C626172456C656D656E7473222C226F6E222C227569222C227669657724222C2266696E64222C22636F6E646974696F6E56616C7565222C2267657456616C756522';
wwv_flow_api.g_varchar2_table(13) := '2C22746F557070657243617365222C22746F4C6F77657243617365222C2273686F77222C22656E61626C65222C2264697361626C65222C226F6E53656C656374696F6E4368616E6765222C227265636F7264436F756E74222C2264697361626C6564222C';
wwv_flow_api.g_varchar2_table(14) := '2224222C22766965774964222C226F6E446174614368616E6765222C225F64617461222C226F6E4D6F64656C4368616E6765222C22756E537562736372696265222C22737562736372696265222C226F6E4368616E6765225D2C226D617070696E677322';
wwv_flow_api.g_varchar2_table(15) := '3A22414145412C49414149412C4941414D432C4F41414F442C4B41414F2C4741437842412C49414149452C674241416B42462C49414149452C694241416D422C474167433743462C49414149452C674241416742432C554141592C53414155432C454141';
wwv_flow_api.g_varchar2_table(16) := '57432C45414151432C4741477A44432C4B41414B432C4D41414D432C4B41444D2C73434143574A2C45414151432C4741476843412C6141416B42492C5541436C424A2C4541414F4B2C4B41414B502C45414157432C47414933422C49414B494F2C45414A';
wwv_flow_api.g_varchar2_table(17) := '41432C4541446D42542C45414155552C69424143442C47414147432C4741432F42432C45414169422C4941414D482C4541437642492C45414153562C4B41414B552C4F41414F4A2C4741497A422C4941414B492C47414179422C6D42414166412C454141';
wwv_flow_api.g_varchar2_table(18) := '4F432C4B41436C422C4D41414D2C49414149432C4D41414D2C6F44414770422C49414149432C4541416942482C4541414F4E2C4B41414B2C6341433742552C4541416568422C4541414F67422C6141437442432C45414169426A422C4541414F69422C65';
wwv_flow_api.g_varchar2_table(19) := '41437842432C454141596C422C4541414F6B422C5541436E42432C454141536E422C4541414F6D422C4F41436842432C4541415770422C4541414F71422C5741436C42432C4541415174422C4541414F73422C4D414366432C4541414F76422C4541414F';
wwv_flow_api.g_varchar2_table(20) := '75422C4B414364432C4541415178422C4541414F77422C4D414366432C454141537A422C4541414F30422C6541436842432C4541416B4233422C4541414F32422C674241437A42432C4541415935422C4541414F34422C5541436E42432C454141573742';
wwv_flow_api.g_varchar2_table(21) := '2C4541414F36422C5341436C42432C454141754239422C4541414F38422C714241433942432C4541416B422F422C4541414F2B422C674241437A42432C4541416F4268432C4541414F67432C6B4241433342432C454141656A432C4541414F69432C6141';
wwv_flow_api.g_varchar2_table(22) := '437442432C454141576C432C4541414F6B432C5341436C42432C4541416D426E432C4541414F6D432C694241433142432C4541416170432C4541414F6F432C5741477042432C4541416172432C4541414F71432C594141632C694241416D42432C594141';
wwv_flow_api.g_varchar2_table(23) := '572C6541476845432C454141532C4341435431422C4B41414D2C5341434E32422C4B41414D482C4541434E662C4D41414F412C45414350432C4B41414D412C4541434E6B422C534141554C2C47416D49642C47413948496C422C474141612C434141432C';
wwv_flow_api.g_varchar2_table(24) := '634141652C71424141714277422C5141415176422C494141572C47414772455A2C4541414F4B2C4541414F4E2C4B41414B2C574141592C5141432F4271432C4541415170432C4541414B6F432C4D4145432C6541415678422C454145416F422C4541414F';
wwv_flow_api.g_varchar2_table(25) := '412C4F4141532C534141554B2C4541414F432C47414737422C49414149432C4541415376432C4541414B77432C694241416942462C474141632C474147374370422C4741434176422C4B41414B38432C4B41414B76422C4741415177422C534141534E2C';
wwv_flow_api.g_varchar2_table(26) := '4541414D4F2C594141594A2C4941496A442C494141494B2C4541414F2C43414350502C4D41414F412C45414350432C61414163412C454143646A432C4F414151412C454143522B422C4D41414F412C4541435035422C6541416742412C45414368422B42';
wwv_flow_api.g_varchar2_table(27) := '2C4F414151412C474147526C422C4741474131422C4B41414B30432C4D41414D512C514141517A432C454141674269422C4541415775422C474147394374422C47414741412C4541415376422C4B41414B2C4341414536432C4B41414D412C4B4147622C';
wwv_flow_api.g_varchar2_table(28) := '714241415668432C494143506F422C4541414F412C4F4141532C534141554B2C4541414F432C47414737422C49414149512C4541416B427A432C4541414F4E2C4B41414B2C73424147394236432C4541414F2C43414350502C4D41414F412C4541435043';
wwv_flow_api.g_varchar2_table(29) := '2C61414163412C454143646A432C4F414151412C454143522B422C4D41414F412C4541435035422C6541416742412C454143684273432C674241416942412C47414D72422C4741414935422C454141512C434143522C4941414936422C45414157442C45';
wwv_flow_api.g_varchar2_table(30) := '41416742452C4B4141492C53414155542C4741437A432C49414149552C45414155622C4541414D4F2C594141594A2C47414568432C494143492C49414149572C45414163432C4B41414B432C4D41414D482C47414737422C4F414151492C4D41414D432C';
wwv_flow_api.g_varchar2_table(31) := '514141514A2C4741416742412C45414163442C45414374442C4D41414F4D2C4741454C2C4F41414F4E2C4D41476674442C4B41414B38432C4B41414B76422C4741415177422C53414153532C4B41414B4B2C55414155542C494147314331422C47414741';
wwv_flow_api.g_varchar2_table(32) := '31422C4B41414B30432C4D41414D512C514141517A432C454141674269422C4541415775422C474145394374422C47414741412C4541415376422C4B41414B2C4341414536432C4B41414D412C4F414D394276422C45414341572C4541414F412C4F4141';
wwv_flow_api.g_varchar2_table(33) := '532C534141554B2C4541414F432C4741433742462C454141512F422C4541414F4E2C4B41414B2C6B4241416B4271432C4D414374437A432C4B41414B30432C4D41414D512C514141517A432C454141674269422C454141572C434143314367422C4D4141';
wwv_flow_api.g_varchar2_table(34) := '4F412C45414350432C61414163412C454143646A432C4F414151412C454143522B422C4D41414F412C4541435035422C6541416742412C454143684273432C6742414169427A432C4541414F4E2C4B41414B2C79424149394275422C49414350552C4541';
wwv_flow_api.g_varchar2_table(35) := '414F412C4F4141532C534141554B2C4541414F432C4741433742462C454141512F422C4541414F4E2C4B41414B2C6B4241416B4271432C4D41437443642C4541415376422C4B41414B2C4341435636432C4B41414D2C43414346502C4D41414F412C4541';
wwv_flow_api.g_varchar2_table(36) := '4350432C61414163412C454143646A432C4F414151412C454143522B422C4D41414F412C4541435035422C6541416742412C454143684273432C6742414169427A432C4541414F4E2C4B41414B2C324241513543532C4541416569442C4F41414F33422C';
wwv_flow_api.g_varchar2_table(37) := '494143764274422C454141656B442C4941414931422C4741496E4272422C454141572C434145582C4941414967442C45414341432C45414341432C454145552C654141566A442C4541454167442C47414441442C4541415133442C4541414B38442C6742';
wwv_flow_api.g_varchar2_table(38) := '41434B432C4B41414B2C534141552C53414368422C71424141566E442C4541455067442C47414441442C4541415133442C4541414B67452C674241434B442C4B41414B2C534141552C53414368422C574141566E442C4941455067442C47414441432C45';
wwv_flow_api.g_varchar2_table(39) := '41416378442C4541414F4E2C4B41414B2C634141636B452C514141512C4F4141512C6B4241416B42462C4D41436C44472C514149784272442C454141572C4741414B412C454141572B432C454141554F2C554143724374442C454141572B432C45414155';
wwv_flow_api.g_varchar2_table(40) := '4F2C5141497A422C49414149432C454141572C434141432C4341435A39442C4B41414D2C5341434E30422C4F414151462C45414352662C4D41414F412C45414350432C4B41414D412C454141512C4D414151412C454141512C4B4149394276422C454141';
wwv_flow_api.g_varchar2_table(41) := '4F34452C6F4241417342542C454141552F432C454141572C49414173432C61414168432B432C454141552F432C454141572C47414147502C4D4143684638442C45414153452C514141512C4341414568452C4B41414D2C6341497A42622C4541414F3845';
wwv_flow_api.g_varchar2_table(42) := '2C6D4241417142582C454141552F432C49414179432C61414135422B432C454141552F432C47414155502C4D4143764538442C45414153492C4B41414B2C434141456C452C4B41414D2C634149314273442C45414159412C45414155612C4D41414D2C45';
wwv_flow_api.g_varchar2_table(43) := '41414735442C4741415536442C4F41414F4E2C474141554D2C4F41414F642C45414155612C4D41414D35442C494145374538432C45414541412C4541414D492C4B41414B2C534141552C51414153482C4741437642432C49414550412C454141594B2C4D';

wwv_flow_api.g_varchar2_table(44) := '4141514E2C454143704276442C4541414F4E2C4B41414B2C634141636B452C514141512C694241476E432C4741414978442C454141632C43414372422C494141496B452C4541415774452C4541414F4E2C4B41414B2C634143764236452C45414163442C';
wwv_flow_api.g_varchar2_table(45) := '45414153562C514141512C534141552C5141457A43592C45414465462C45414153562C514141512C5941416176442C474143646F452C5541472F426A452C454141572C4741414B412C4541415767452C4541416742562C554143334374442C4541415767';
wwv_flow_api.g_varchar2_table(46) := '452C4541416742562C5141472F42552C4541416742452C4F41414F6C452C454141552C454141472C4341436843502C4B41414D2C5341434E532C4D41414F412C4541455069422C4F414151462C454143526B442C4941414B2F442C4541434C552C534141';
wwv_flow_api.g_varchar2_table(47) := '55412C4541435673442C694241416B4272442C4541436C425A2C4B41414D412C454141512C4D414151412C454141512C4B41456C4332442C45414153562C514141512C534141552C4F414151572C4741556E43442C45414153562C514141512C63414165';
wwv_flow_api.g_varchar2_table(48) := '2C77424141774269422C4F41437844502C45414153562C514141512C634141652C67424141674269422C4F41436844502C45414153562C514141512C634141652C6B4241416B4269422C4F41476C4437452C4541414F4E2C4B41414B2C594141596F462C';
wwv_flow_api.g_varchar2_table(49) := '794241324235422C474176424978452C47414175422C65414156432C4741413242512C474143784370422C4541414B38442C6541416573422C474141472C6B4241416B422C534141552F432C4541414F67442C474143744472462C4541414F4B2C454141';
wwv_flow_api.g_varchar2_table(50) := '4F4E2C4B41414B2C574141592C5141432F4271432C4541415170432C4541414B6F432C4D4147622C49414149472C4541415376432C4541414B77432C69424141694278432C4541414B73462C4D41414D432C4B41414B2C6743414167432C4741432F4543';
wwv_flow_api.g_varchar2_table(51) := '2C454141694270442C4541414D71442C534141536C442C454141516E422C454141674273452C6541433544462C4541416B42412C4741416B42412C45414165472C59414165482C45414165472C6341416742482C4541456A4768462C454141656F462C4B';
wwv_flow_api.g_varchar2_table(52) := '41414B39442C474143704274422C4541416571462C4F41414F2F442C474147412C5541416C4230442C4541434168462C4541416530452C4B41414B70442C4741434B2C5941416C4230442C4741435068462C4541416573462C5141415168452C4D414D2F';
wwv_flow_api.g_varchar2_table(53) := '42502C4741417742452C4541416D422C43414533432C4941414973452C4541416F422C57414370422C494141492F442C4541415378422C4541416569442C4F41414F33422C4741432F426B452C4541416333462C4541414F4E2C4B41414B2C7342414173';
wwv_flow_api.g_varchar2_table(54) := '426F452C4F4143684435432C4941434979452C454141632C4741414B68452C4541414F69452C53414331427A462C4541416571462C4F41414F2F442C474143412C474141666B452C474141714268452C4541414F69452C5541436E437A462C4541416573';
wwv_flow_api.g_varchar2_table(55) := '462C5141415168452C49414733424C2C4941434975452C454141632C4741414B68452C4541414F6B442C4B4143314231452C454141656F462C4B41414B39442C474143452C474141666B452C474141714268452C4541414F6B442C4D41436E4331452C45';
wwv_flow_api.g_varchar2_table(56) := '41416530452C4B41414B70442C4B414B684369452C49414941472C4541414539462C474141674267462C474141472C364441413844572C47414976462C4741414976452C4741416D42452C454141632C4341456A432C4941714249552C4541414F2B442C';
wwv_flow_api.g_varchar2_table(57) := '4541724250432C454141652C574143662C4941414968452C454141512F422C4541414F4E2C4B41414B2C574141592C5141415171432C4D414378434A2C4541415378422C4541416569442C4F41414F33422C4741432F426B452C4541416335442C454141';
wwv_flow_api.g_varchar2_table(58) := '4D69452C4D41414D6C432C4F4143314233432C4941434977452C454141632C4741414B68452C4541414F69452C53414331427A462C4541416571462C4F41414F2F442C474143412C474141666B452C474141714268452C4541414F69452C5541436E437A';
wwv_flow_api.g_varchar2_table(59) := '462C4541416573462C5141415168452C49414733424A2C4941434973452C454141632C4741414B68452C4541414F6B442C4B4143314231452C454141656F462C4B41414B39442C474143452C474141666B452C474141714268452C4541414F6B442C4D41';
wwv_flow_api.g_varchar2_table(60) := '436E4331452C4541416530452C4B41414B70442C4B415168432C5341415377452C494143466C452C474141532B442C474145522F442C4541414D6D452C594141594A2C47414574422F442C454141512F422C4541414F4E2C4B41414B2C574141592C5141';
wwv_flow_api.g_varchar2_table(61) := '415171432C4D414378432B442C454141532F442C4541414D6F452C554141552C4341437242432C534141554C2C49414564412C49414B4A462C4541414539462C474141674267462C474141472C2B4241412B422C57414368446B422C4F41494A41222C22';
wwv_flow_api.g_varchar2_table(62) := '66696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(8368950689762700)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '76617220464F533D77696E646F772E464F537C7C7B7D3B464F532E696E746572616374697665477269643D464F532E696E746572616374697665477269647C7C7B7D2C464F532E696E746572616374697665477269642E616464427574746F6E3D66756E';
wwv_flow_api.g_varchar2_table(2) := '6374696F6E28652C742C6F297B617065782E64656275672E696E666F2822464F53202D20496E7465726163746976652047726964202D2041646420427574746F6E222C742C6F292C6F20696E7374616E63656F662046756E6374696F6E26266F2E63616C';
wwv_flow_api.g_varchar2_table(3) := '6C28652C74293B766172206E2C693D652E6166666563746564456C656D656E74735B305D2E69642C613D2223222B692C723D617065782E726567696F6E2869293B69662821727C7C22496E7465726163746976654772696422213D722E74797065297468';
wwv_flow_api.g_varchar2_table(4) := '726F77206E6577204572726F7228225468652073706563696669656420656C656D656E74206973206E6F7420616E20496E746572616374697665204772696422293B766172206C3D722E63616C6C2822676574416374696F6E7322292C633D742E616464';
wwv_flow_api.g_varchar2_table(5) := '546F546F6F6C6261722C643D742E746F6F6C62617247726F757049642C733D742E616464546F4D656E752C753D742E6D656E7549642C673D742E6164644174496E6465782C663D742E6C6162656C2C623D742E69636F6E2C703D742E6973486F742C6D3D';
wwv_flow_api.g_varchar2_table(6) := '742E7072696D6172794B65794974656D2C763D742E636F6E646974696F6E436F6C756D6E2C683D742E6576656E744E616D652C773D742E63616C6C6261636B2C793D742E64697361626C654F6E4E6F53656C656374696F6E2C533D742E64697361626C65';
wwv_flow_api.g_varchar2_table(7) := '4F6E4E6F446174612C783D742E686964654F6E4E6F53656C656374696F6E2C4F3D742E686964654F6E4E6F446174612C433D742E69636F6E4F6E6C792C523D742E69636F6E5269676874416C69676E65642C543D742E69636F6E5072656669782C413D74';
wwv_flow_api.g_varchar2_table(8) := '2E616374696F6E4E616D657C7C22666F732D69672D627574746F6E2D222B73657454696D656F7574282866756E6374696F6E28297B7D29292C453D7B747970653A22616374696F6E222C6E616D653A412C6C6162656C3A662C69636F6E3A622C69636F6E';
wwv_flow_api.g_varchar2_table(9) := '547970653A547D3B6966287326265B22726F772D616374696F6E73222C2273656C656374696F6E2D616374696F6E73225D2E696E6465784F662875293E2D313F286E3D722E63616C6C28226765745669657773222C226772696422292C4D3D6E2E6D6F64';
wwv_flow_api.g_varchar2_table(10) := '656C2C22726F772D616374696F6E73223D3D753F452E616374696F6E3D66756E6374696F6E28652C74297B766172206F3D6E2E676574436F6E746578745265636F72642874295B305D3B6D2626617065782E6974656D286D292E73657456616C7565284D';
wwv_flow_api.g_varchar2_table(11) := '2E6765745265636F72644964286F29293B76617220693D7B6576656E743A652C666F637573456C656D656E743A742C726567696F6E3A722C6D6F64656C3A4D2C616374696F6E73436F6E746578743A6C2C7265636F72643A6F7D3B682626617065782E65';
wwv_flow_api.g_varchar2_table(12) := '76656E742E7472696767657228612C682C69292C772626772E63616C6C287B646174613A697D297D3A2273656C656374696F6E2D616374696F6E73223D3D75262628452E616374696F6E3D66756E6374696F6E28652C74297B766172206F3D722E63616C';
wwv_flow_api.g_varchar2_table(13) := '6C282267657453656C65637465645265636F72647322292C6E3D7B6576656E743A652C666F637573456C656D656E743A742C726567696F6E3A722C6D6F64656C3A4D2C616374696F6E73436F6E746578743A6C2C73656C65637465645265636F7264733A';
wwv_flow_api.g_varchar2_table(14) := '6F7D3B6966286D297B76617220693D6F2E6D6170282866756E6374696F6E2865297B76617220743D4D2E6765745265636F726449642865293B7472797B766172206F3D4A534F4E2E70617273652874293B72657475726E2041727261792E697341727261';
wwv_flow_api.g_varchar2_table(15) := '79286F293F6F3A747D63617463682865297B72657475726E20747D7D29293B617065782E6974656D286D292E73657456616C7565284A534F4E2E737472696E67696679286929297D682626617065782E6576656E742E7472696767657228612C682C6E29';
wwv_flow_api.g_varchar2_table(16) := '2C772626772E63616C6C287B646174613A6E7D297D29293A683F452E616374696F6E3D66756E6374696F6E28652C74297B4D3D722E63616C6C282267657443757272656E745669657722292E6D6F64656C2C617065782E6576656E742E74726967676572';
wwv_flow_api.g_varchar2_table(17) := '28612C682C7B6576656E743A652C666F637573456C656D656E743A742C726567696F6E3A722C6D6F64656C3A4D2C616374696F6E73436F6E746578743A6C2C73656C65637465645265636F7264733A722E63616C6C282267657453656C65637465645265';
wwv_flow_api.g_varchar2_table(18) := '636F72647322297D297D3A77262628452E616374696F6E3D66756E6374696F6E28652C74297B4D3D722E63616C6C282267657443757272656E745669657722292E6D6F64656C2C772E63616C6C287B646174613A7B6576656E743A652C666F637573456C';
wwv_flow_api.g_varchar2_table(19) := '656D656E743A742C726567696F6E3A722C6D6F64656C3A4D2C616374696F6E73436F6E746578743A6C2C73656C65637465645265636F7264733A722E63616C6C282267657453656C65637465645265636F72647322297D7D297D292C6C2E6C6F6F6B7570';
wwv_flow_api.g_varchar2_table(20) := '2841297C7C6C2E6164642845292C73297B76617220492C4E2C563B22726F772D616374696F6E73223D3D753F4E3D28493D6E2E726F77416374696F6E4D656E7524292E6D656E7528226F7074696F6E222C226974656D7322293A2273656C656374696F6E';
wwv_flow_api.g_varchar2_table(21) := '2D616374696F6E73223D3D753F4E3D28493D6E2E73656C416374696F6E4D656E7524292E6D656E7528226F7074696F6E222C226974656D7322293A22616374696F6E73223D3D752626284E3D28563D722E63616C6C2822676574546F6F6C62617222292E';
wwv_flow_api.g_varchar2_table(22) := '746F6F6C626172282266696E64222C22616374696F6E735F627574746F6E22292E6D656E75292E6974656D73292C28673C307C7C673E4E2E6C656E67746829262628673D4E2E6C656E677468293B76617220473D5B7B747970653A22616374696F6E222C';
wwv_flow_api.g_varchar2_table(23) := '616374696F6E3A412C6C6162656C3A662C69636F6E3A623F22666120222B623A22227D5D3B742E616464536570617261746F724265666F726526264E5B672D315D262622736570617261746F7222213D4E5B672D315D2E747970652626472E756E736869';
wwv_flow_api.g_varchar2_table(24) := '6674287B747970653A22736570617261746F72227D292C742E616464536570617261746F72416674657226264E5B675D262622736570617261746F7222213D4E5B675D2E747970652626472E70757368287B747970653A22736570617261746F72227D29';
wwv_flow_api.g_varchar2_table(25) := '2C4E3D4E2E736C69636528302C67292E636F6E6361742847292E636F6E636174284E2E736C696365286729292C493F492E6D656E7528226F7074696F6E222C226974656D73222C4E293A56262628562E6974656D733D4E2C722E63616C6C282267657454';
wwv_flow_api.g_varchar2_table(26) := '6F6F6C62617222292E746F6F6C6261722822726566726573682229297D656C73652069662863297B76617220463D722E63616C6C2822676574546F6F6C62617222292C5F3D462E746F6F6C62617228226F7074696F6E222C226461746122292C423D462E';
wwv_flow_api.g_varchar2_table(27) := '746F6F6C626172282266696E6447726F7570222C64292E636F6E74726F6C733B28673C307C7C673E422E6C656E67746829262628673D422E6C656E677468292C422E73706C69636528672C302C7B747970653A22425554544F4E222C6C6162656C3A662C';
wwv_flow_api.g_varchar2_table(28) := '616374696F6E3A412C686F743A702C69636F6E4F6E6C793A432C69636F6E4265666F72654C6162656C3A21522C69636F6E3A623F22666120222B623A22227D292C462E746F6F6C62617228226F7074696F6E222C2264617461222C5F292C462E746F6F6C';
wwv_flow_api.g_varchar2_table(29) := '626172282266696E64456C656D656E74222C22636F6C756D6E5F66696C7465725F627574746F6E22292E6869646528292C462E746F6F6C626172282266696E64456C656D656E74222C227365617263685F6669656C6422292E6869646528292C462E746F';
wwv_flow_api.g_varchar2_table(30) := '6F6C626172282266696E64456C656D656E74222C22616374696F6E735F627574746F6E22292E6869646528292C722E63616C6C2822696E7374616E636522292E5F757064617465546F6F6C626172456C656D656E747328297D69662873262622726F772D';
wwv_flow_api.g_varchar2_table(31) := '616374696F6E73223D3D7526267626266E2E726F77416374696F6E4D656E75242E6F6E28226D656E756265666F72656F70656E222C2866756E6374696F6E28652C74297B6E3D722E63616C6C28226765745669657773222C226772696422292C4D3D6E2E';
wwv_flow_api.g_varchar2_table(32) := '6D6F64656C3B766172206F3D6E2E676574436F6E746578745265636F7264286E2E76696577242E66696E642822627574746F6E5B646174612D6D656E755D2E69732D6163746976652229295B305D2C693D4D2E67657456616C7565286F2C762E746F5570';
wwv_flow_api.g_varchar2_table(33) := '706572436173652829293B693D692626692E746F4C6F776572436173653F692E746F4C6F7765724361736528293A692C6C2E73686F772841292C6C2E656E61626C652841292C2268696464656E223D3D693F6C2E686964652841293A2264697361626C65';
wwv_flow_api.g_varchar2_table(34) := '64223D3D6926266C2E64697361626C652841297D29292C797C7C78297B766172206B3D66756E6374696F6E28297B76617220653D6C2E6C6F6F6B75702841292C743D722E63616C6C282267657453656C65637465645265636F72647322292E6C656E6774';
wwv_flow_api.g_varchar2_table(35) := '683B79262628743E302626652E64697361626C65643F6C2E656E61626C652841293A30213D747C7C652E64697361626C65647C7C6C2E64697361626C65284129292C78262628743E302626652E686964653F6C2E73686F772841293A30213D747C7C652E';
wwv_flow_api.g_varchar2_table(36) := '686964657C7C6C2E68696465284129297D3B6B28292C242861292E6F6E2822696E7465726163746976656772696473656C656374696F6E6368616E676520696E746572616374697665677269647265706F72746368616E6765222C6B297D696628537C7C';
wwv_flow_api.g_varchar2_table(37) := '4F297B766172204D2C4C2C443D66756E6374696F6E28297B76617220653D722E63616C6C28226765745669657773222C226772696422292E6D6F64656C2C743D6C2E6C6F6F6B75702841292C6F3D652E5F646174612E6C656E6774683B532626286F3E30';
wwv_flow_api.g_varchar2_table(38) := '2626742E64697361626C65643F6C2E656E61626C652841293A30213D6F7C7C742E64697361626C65647C7C6C2E64697361626C65284129292C4F2626286F3E302626742E686964653F6C2E73686F772841293A30213D6F7C7C742E686964657C7C6C2E68';
wwv_flow_api.g_varchar2_table(39) := '696465284129297D3B66756E6374696F6E204A28297B4D26264C26264D2E756E537562736372696265284C292C4D3D722E63616C6C28226765745669657773222C226772696422292E6D6F64656C2C4C3D4D2E737562736372696265287B6F6E4368616E';
wwv_flow_api.g_varchar2_table(40) := '67653A447D292C4428297D242861292E6F6E2822696E746572616374697665677269647265706F72746368616E6765222C2866756E6374696F6E28297B4A28297D29292C4A28297D7D3B0A2F2F2320736F757263654D617070696E6755524C3D73637269';
wwv_flow_api.g_varchar2_table(41) := '70742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(8369358085762700)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done


