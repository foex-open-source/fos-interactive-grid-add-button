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

prompt APPLICATION 102 - FOS Dev
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 34175298479606152
--     PLUGIN: 35822631205839510
--     PLUGIN: 14934236679644451
--     PLUGIN: 2657630155025963
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
'function render',
'    ( p_dynamic_action apex_plugin.t_dynamic_action',
'    , p_plugin         apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result           apex_plugin.t_dynamic_action_render_result;',
'    ',
'    l_add_button_to    p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_alignment        p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'',
'    l_add_at_index     number := ',
'        case p_dynamic_action.attribute_02',
'            when ''first'' then 0',
'            when ''last''  then -1',
'            else p_dynamic_action.attribute_03',
'        end;',
'    ',
'    l_separator_before boolean := p_dynamic_action.attribute_04 like ''%before%'';',
'    l_separator_after  boolean := p_dynamic_action.attribute_04 like ''%after%'';',
'',
'    l_label            p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    l_icon             p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_is_hot           boolean                            := p_dynamic_action.attribute_07 = ''Y'';',
'    l_action_name      p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;',
'    l_condition_column p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'    ',
'    l_on_click         p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;',
'    l_pk_item          p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;',
'    l_javascript_code  p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;',
'    l_event_name       p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_13;',
'begin',
'',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action',
'            ( p_plugin         => p_plugin',
'            , p_dynamic_action => p_dynamic_action',
'            );',
'    end if;',
'    ',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    ',
'    if l_add_button_to like ''toolbar-%'' then',
'        apex_json.write(''addToToolbar'', true);',
'        apex_json.write(''toolbarGroupId'', substr(l_add_button_to, 9));',
'    elsif l_add_button_to like ''menu-%'' then',
'        apex_json.write(''addToMenu'', true);',
'        apex_json.write(''menuId'', substr(l_add_button_to, 6));                ',
'    end if;',
'',
'    apex_json.write(''addAtIndex'', l_add_at_index);',
'',
'    apex_json.write(''addSeparatorBefore'', l_separator_before);',
'    apex_json.write(''addSeparatorAfter'', l_separator_after);',
'',
'    apex_json.write(''label'', l_label);',
'    apex_json.write(''icon'', l_icon);',
'    apex_json.write(''isHot'', l_is_hot);',
'    ',
'    apex_json.write(''conditionColumn'', l_condition_column);',
'    ',
'    apex_json.write(''actionName'', l_action_name);',
'    ',
'    case l_on_click',
'        when ''return-pks-into-item'' then',
'            apex_json.write(''primaryKeyItem'', l_pk_item);',
'        when ''execute-javascript-code'' then',
'            apex_json.write_raw(''callback'', ''function(){'' || l_javascript_code || ''}'');',
'        when ''trigger-event'' then',
'            apex_json.write(''eventName'', l_event_name);',
'        else',
'            null;',
'    end case;',
'    ',
'    apex_json.close_object;',
'    ',
'    l_result.javascript_function := ''function(){FOS.interactiveGrid.addButton(this, '' || apex_json.get_clob_output || '');}'';',
'    ',
'    apex_json.free_output;',
'    ',
'    return l_result;',
'end;'))
,p_api_version=>1
,p_render_function=>'render'
,p_standard_attributes=>'REGION:REQUIRED'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>Adds a button to an Interactive Grid''s toolbar or popup menus.</p>'
,p_version_identifier=>'20.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Settings for the FOS browser extension',
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>547
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
,p_default_value=>'toolbar-actions2'
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
 p_id=>wwv_flow_api.id(8364963681762693)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Hot'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(8354523139762685)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'toolbar-search,toolbar-reports,toolbar-views,toolbar-actions1,toolbar-actions2,toolbar-actions3,toolbar-actions4'
,p_help_text=>'<p>Choose if the button is styled "hot", that is, if the button takes the primary color of the application.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8366917855762694)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Action Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<ul>',
'    <li><code>show-downloads-dialog</code></li>',
'    <li><code>my-custom-action</code></li>',
'</ul>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This attribute is <b>optional</b>.</p>',
'',
'<p>If you wish for the button to trigger a built-in function of the Interactive Grid, such as saving changes or opening the downloads dialog, pass its corresponding "Action Name". You can find a list of all options under: <a href="https://apex.oracle'
||'.com/jsapi">https://apex.oracle.com/jsapi</a> > Widgets > interactiveGrid > Actions. Then set the "On Click" attribute to "Do Nothing - Action is handled externally"</p>',
'',
'<p>If you wish to later control the button (disable, hide, change label, etc) pass a unique identifier here. You can then use it to get a reference to the action via the <code>apex.actions</code> namespace.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(8365798831762694)
,p_plugin_id=>wwv_flow_api.id(8354320589762683)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
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
,p_attribute_sequence=>10
,p_display_sequence=>100
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
'<p>This option is only valid if the button location is the Row Actions Menu or the Row Selection Menu.</p>',
'<p>On button click, the primary key(s) of the selected row(s) will be stringified and populated into a page item. One can then listen on change of that item, and proceed from there.</p>',
'<h4>A note on the form of the primary key</h4>',
'<p>If the Interactive Grid has exactly 1 primary key column, a button in the row actions menu will return the primary key as a simple string. A button in the selection actions menu will return a list of primary key values separated by a comma.</p>',
'<p>If the Interactive Grid has more than 1 primary key column, a button in the row actions menu will return a string like <code>["7839","KING"]</code>. A button in the selection actions menu will return a stringified array of such strings, e.g <code>'
||'["[\"7839\",\"KING\"]","[\"7698\",\"BLAKE\"]"]</code>. To be usable, this string has to then be parsed either in JavaScript via <code>JSON.parse</code> or in PL/SQL via <code>APEX_JSON.PARSE</code>.</p>'))
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
,p_attribute_sequence=>11
,p_display_sequence=>110
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
,p_attribute_sequence=>12
,p_display_sequence=>120
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
,p_attribute_sequence=>13
,p_display_sequence=>130
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
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F53203D2077696E646F772E464F53207C7C207B7D3B0A77696E646F772E464F532E696E74657261637469766547726964203D20464F532E696E74657261637469766547726964207C7C207B7D3B0A0A464F532E696E746572616374';
wwv_flow_api.g_varchar2_table(2) := '697665477269642E616464427574746F6E203D2066756E6374696F6E20286461436F6E746578742C20636F6E66696729207B0A0A20202020617065782E64656275672E696E666F2827464F53202D20496E7465726163746976652047726964202D204164';
wwv_flow_api.g_varchar2_table(3) := '6420427574746F6E272C20636F6E666967293B0A0A20202020766172206166666563746564456C656D656E7473203D206461436F6E746578742E6166666563746564456C656D656E74733B0A2020202076617220726567696F6E4964203D206166666563';
wwv_flow_api.g_varchar2_table(4) := '746564456C656D656E74735B305D2E69643B0A2020202076617220726567696F6E53656C6563746F72203D20272327202B20726567696F6E49643B0A2020202076617220726567696F6E203D20617065782E726567696F6E28726567696F6E4964293B0A';
wwv_flow_api.g_varchar2_table(5) := '0A2020202069662821726567696F6E207C7C2021726567696F6E2E74797065203D3D2027496E7465726163746976654772696427297B0A20202020202020207468726F77206E6577204572726F7228275468652073706563696669656420656C656D656E';
wwv_flow_api.g_varchar2_table(6) := '74206973206E6F7420616E20496E746572616374697665204772696427293B0A202020207D0A0A2020202076617220616374696F6E73436F6E74657874203D20726567696F6E2E63616C6C2827676574416374696F6E7327293B0A0A2020202076617220';
wwv_flow_api.g_varchar2_table(7) := '616464546F546F6F6C626172203D20636F6E6669672E616464546F546F6F6C6261723B0A2020202076617220746F6F6C62617247726F75704964203D20636F6E6669672E746F6F6C62617247726F757049643B0A2020202076617220616464546F4D656E';
wwv_flow_api.g_varchar2_table(8) := '75203D20636F6E6669672E616464546F4D656E753B0A20202020766172206D656E754964203D20636F6E6669672E6D656E7549643B0A2020202076617220706F736974696F6E203D20636F6E6669672E6164644174496E6465783B2020202F2F202D3120';
wwv_flow_api.g_varchar2_table(9) := '666F7220746865206C6173742074696D6520696E20746865206C6973740A20202020766172206C6162656C203D20636F6E6669672E6C6162656C3B0A202020207661722069636F6E203D20636F6E6669672E69636F6E3B0A20202020766172206973486F';
wwv_flow_api.g_varchar2_table(10) := '74203D20636F6E6669672E6973486F743B0A2020202076617220706B4974656D203D20636F6E6669672E7072696D6172794B65794974656D3B0A2020202076617220636F6E646974696F6E436F6C756D6E203D20636F6E6669672E636F6E646974696F6E';
wwv_flow_api.g_varchar2_table(11) := '436F6C756D6E3B0A20202020766172206576656E744E616D65203D20636F6E6669672E6576656E744E616D653B0A202020207661722063616C6C6261636B203D20636F6E6669672E63616C6C6261636B3B0A0A202020202F2F206966206E6F2061637469';
wwv_flow_api.g_varchar2_table(12) := '6F6E206E616D65207761732070726F76696465642C207765206D757374206372656174652061206E65772C20756E69717565206F6E650A2020202076617220616374696F6E4E616D65203D20636F6E6669672E616374696F6E4E616D65207C7C2027666F';
wwv_flow_api.g_varchar2_table(13) := '732D69672D627574746F6E2D27202B2073657454696D656F7574286E65772046756E6374696F6E2829293B0A0A202020202F2F2063726561746520616E20616374696F6E206F626A6563742C2062757420776974686F757420616E20616374696F6E2066';
wwv_flow_api.g_varchar2_table(14) := '756E6374696F6E20666F72206E6F770A2020202076617220616374696F6E203D207B0A2020202020202020747970653A2027616374696F6E272C0A20202020202020206E616D653A20616374696F6E4E616D652C0A20202020202020206C6162656C3A20';
wwv_flow_api.g_varchar2_table(15) := '6C6162656C2C0A202020202020202069636F6E3A2069636F6E2C0A202020202020202069636F6E547970653A20276661272C0A202020207D3B0A0A202020202F2F20646570656E64696E67206F6E207468652074797065206F6620627574746F6E2C2074';
wwv_flow_api.g_varchar2_table(16) := '686520616374696F6E2E616374696F6E2066756E6374696F6E2077696C6C20626520736C696768746C7920646966666572656E740A2020202069662028616464546F4D656E75202626205B27726F772D616374696F6E73272C202773656C656374696F6E';
wwv_flow_api.g_varchar2_table(17) := '2D616374696F6E73275D2E696E6465784F66286D656E75496429203E202D3129207B0A20202020202020202F2F666F7220726F7720616E642073656C656374696F6E206D656E75730A0A20202020202020207661722067726964203D20726567696F6E2E';
wwv_flow_api.g_varchar2_table(18) := '63616C6C28276765745669657773272C20276772696427293B0A2020202020202020766172206D6F64656C203D20677269642E6D6F64656C3B0A0A2020202020202020696620286D656E754964203D3D2027726F772D616374696F6E732729207B0A2020';
wwv_flow_api.g_varchar2_table(19) := '20202020202020202020616374696F6E2E616374696F6E203D2066756E6374696F6E20286576656E742C20666F637573456C656D656E7429207B0A0A20202020202020202020202020202020766172207265636F7264203D20677269642E676574436F6E';
wwv_flow_api.g_varchar2_table(20) := '746578745265636F726428666F637573456C656D656E74295B305D3B0A0A2020202020202020202020202020202069662028706B4974656D29207B0A2020202020202020202020202020202020202020617065782E6974656D28706B4974656D292E7365';
wwv_flow_api.g_varchar2_table(21) := '7456616C7565286D6F64656C2E6765745265636F72644964287265636F726429293B0A202020202020202020202020202020207D0A0A202020202020202020202020202020207661722064617461203D207B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(22) := '2020206576656E743A206576656E742C0A2020202020202020202020202020202020202020666F637573456C656D656E743A20666F637573456C656D656E742C0A2020202020202020202020202020202020202020726567696F6E3A20726567696F6E2C';
wwv_flow_api.g_varchar2_table(23) := '0A20202020202020202020202020202020202020206D6F64656C3A206D6F64656C2C0A20202020202020202020202020202020202020207265636F72643A207265636F72640A202020202020202020202020202020207D3B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(24) := '202020202020696620286576656E744E616D6529207B0A2020202020202020202020202020202020202020617065782E6576656E742E7472696767657228726567696F6E53656C6563746F722C206576656E744E616D652C2064617461293B0A20202020';
wwv_flow_api.g_varchar2_table(25) := '2020202020202020202020207D0A0A202020202020202020202020202020206966202863616C6C6261636B29207B0A202020202020202020202020202020202020202063616C6C6261636B2E63616C6C287B646174613A20646174617D293B0A20202020';
wwv_flow_api.g_varchar2_table(26) := '2020202020202020202020207D0A2020202020202020202020207D3B0A20202020202020207D20656C736520696620286D656E754964203D3D202773656C656374696F6E2D616374696F6E732729207B0A202020202020202020202020616374696F6E2E';
wwv_flow_api.g_varchar2_table(27) := '616374696F6E203D2066756E6374696F6E20286576656E742C20666F637573456C656D656E7429207B0A0A202020202020202020202020202020207661722073656C65637465645265636F726473203D20726567696F6E2E63616C6C282767657453656C';
wwv_flow_api.g_varchar2_table(28) := '65637465645265636F72647327293B0A0A202020202020202020202020202020207661722064617461203D207B0A20202020202020202020202020202020202020206576656E743A206576656E742C0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(29) := '666F637573456C656D656E743A20666F637573456C656D656E742C0A2020202020202020202020202020202020202020726567696F6E3A20726567696F6E2C0A20202020202020202020202020202020202020206D6F64656C3A206D6F64656C2C0A2020';
wwv_flow_api.g_varchar2_table(30) := '20202020202020202020202020202020202073656C65637465645265636F7264733A2073656C65637465645265636F7264730A202020202020202020202020202020207D3B0A0A2020202020202020202020202020202069662028706B4974656D29207B';
wwv_flow_api.g_varchar2_table(31) := '0A202020202020202020202020202020202020202076617220706B56616C756573203D2073656C65637465645265636F7264732E6D61702866756E6374696F6E20287265636F726429207B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(32) := '72657475726E206D6F64656C2E6765745265636F72644964287265636F7264293B0A20202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020617065782E6974656D28706B4974656D292E73657456';
wwv_flow_api.g_varchar2_table(33) := '616C7565284A534F4E2E737472696E6769667928706B56616C75657329293B0A202020202020202020202020202020207D0A0A20202020202020202020202020202020696620286576656E744E616D6529207B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(34) := '20202020617065782E6576656E742E7472696767657228726567696F6E53656C6563746F722C206576656E744E616D652C2064617461293B0A202020202020202020202020202020207D0A202020202020202020202020202020206966202863616C6C62';
wwv_flow_api.g_varchar2_table(35) := '61636B29207B0A202020202020202020202020202020202020202063616C6C6261636B2E63616C6C287B646174613A20646174617D293B0A202020202020202020202020202020207D0A2020202020202020202020207D3B0A20202020202020207D0A20';
wwv_flow_api.g_varchar2_table(36) := '2020207D20656C7365207B0A20202020202020202F2F20666F722074686520746F6F6C62617220616E6420616374696F6E73206D656E750A2020202020202020696620286576656E744E616D6529207B0A202020202020202020202020616374696F6E2E';
wwv_flow_api.g_varchar2_table(37) := '616374696F6E203D2066756E6374696F6E20286576656E742C2
0666F637573456C656D656E7429207B0A20202020202020202020202020202020766172206D6F64656C203D20726567696F6E2E63616C6C282767657443757272656E745669657727292E';
wwv_flow_api.g_varchar2_table(38) := '6D6F64656C3B0A20202020202020202020202020202020617065782E6576656E742E7472696767657228726567696F6E53656C6563746F722C206576656E744E616D652C207B0A2020202020202020202020202020202020202020646174613A207B0A20';
wwv_flow_api.g_varchar2_table(39) := '20202020202020202020202020202020202020202020206576656E743A206576656E742C0A202020202020202020202020202020202020202020202020666F637573456C656D656E743A20666F637573456C656D656E742C0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '20202020202020202020202020726567696F6E3A20726567696F6E2C0A2020202020202020202020202020202020202020202020206D6F64656C3A206D6F64656C0A20202020202020202020202020202020202020207D0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(41) := '202020207D293B0A2020202020202020202020207D3B0A20202020202020207D20656C7365206966202863616C6C6261636B29207B0A202020202020202020202020616374696F6E2E616374696F6E203D2066756E6374696F6E20286576656E742C2066';
wwv_flow_api.g_varchar2_table(42) := '6F637573456C656D656E7429207B0A20202020202020202020202020202020766172206D6F64656C203D20726567696F6E2E63616C6C282767657443757272656E745669657727292E6D6F64656C3B0A2020202020202020202020202020202063616C6C';
wwv_flow_api.g_varchar2_table(43) := '6261636B2E63616C6C287B0A2020202020202020202020202020202020202020646174613A207B0A2020202020202020202020202020202020202020202020206576656E743A206576656E742C0A20202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(44) := '2020666F637573456C656D656E743A20666F637573456C656D656E742C0A202020202020202020202020202020202020202020202020726567696F6E3A20726567696F6E2C0A2020202020202020202020202020202020202020202020206D6F64656C3A';
wwv_flow_api.g_varchar2_table(45) := '206D6F64656C0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B0A2020202020202020202020207D0A20202020202020207D0A202020207D0A0A202020202F2F206164642074686520616374696F';
wwv_flow_api.g_varchar2_table(46) := '6E20746F20746865204947277320616374696F6E7320636F6E7465787420696620697420646F65736E277420616C72656164792065786973740A202020206966202821616374696F6E73436F6E746578742E6C6F6F6B757028616374696F6E4E616D6529';
wwv_flow_api.g_varchar2_table(47) := '29207B0A2020202020202020616374696F6E73436F6E746578742E61646428616374696F6E293B0A202020207D0A0A202020202F2F20616464696E672074686520627574746F6E20746F2061206C6973740A2020202069662028616464546F4D656E7529';
wwv_flow_api.g_varchar2_table(48) := '207B0A2020202020202020766172206D656E75243B0A2020202020202020766172206D656E754974656D733B0A202020202020202076617220746F6F6C6261724D656E753B0A0A2020202020202020696620286D656E754964203D3D2027726F772D6163';
wwv_flow_api.g_varchar2_table(49) := '74696F6E732729207B0A2020202020202020202020206D656E7524203D20677269642E726F77416374696F6E4D656E75243B0A2020202020202020202020206D656E754974656D73203D206D656E75242E6D656E7528276F7074696F6E272C2027697465';
wwv_flow_api.g_varchar2_table(50) := '6D7327293B0A20202020202020207D20656C736520696620286D656E754964203D3D202773656C656374696F6E2D616374696F6E732729207B0A2020202020202020202020206D656E7524203D20677269642E73656C416374696F6E4D656E75243B0A20';
wwv_flow_api.g_varchar2_table(51) := '20202020202020202020206D656E754974656D73203D206D656E75242E6D656E7528276F7074696F6E272C20276974656D7327293B0A20202020202020207D20656C736520696620286D656E754964203D3D2027616374696F6E732729207B0A20202020';
wwv_flow_api.g_varchar2_table(52) := '2020202020202020746F6F6C6261724D656E75203D20726567696F6E2E63616C6C2827676574546F6F6C62617227292E746F6F6C626172282766696E64272C2027616374696F6E735F627574746F6E27292E6D656E753B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(53) := '6D656E754974656D73203D20746F6F6C6261724D656E752E6974656D733B0A20202020202020207D0A0A20202020202020202F2F73616E6174697A696E672074686520706F736974696F6E0A202020202020202069662028706F736974696F6E203C2030';
wwv_flow_api.g_varchar2_table(54) := '207C7C20706F736974696F6E203E206D656E754974656D732E6C656E67746829207B0A202020202020202020202020706F736974696F6E203D206D656E754974656D732E6C656E6774683B0A20202020202020207D0A0A20202020202020202F2F207468';
wwv_flow_api.g_varchar2_table(55) := '65206974656D7320746F2062652061646465640A2020202020202020766172206E65774974656D73203D205B7B0A202020202020202020202020747970653A2027616374696F6E272C0A202020202020202020202020616374696F6E3A20616374696F6E';
wwv_flow_api.g_varchar2_table(56) := '4E616D650A20202020202020207D5D3B0A0A20202020202020202F2F206D616B696E67207375726520776520646F6E277420656E64207570207769746820636F6E736563757469766520736570617261746F72730A202020202020202069662028636F6E';
wwv_flow_api.g_varchar2_table(57) := '6669672E616464536570617261746F724265666F7265202626206D656E754974656D735B706F736974696F6E202D20315D202626206D656E754974656D735B706F736974696F6E202D20315D2E7479706520213D2027736570617261746F722729207B0A';
wwv_flow_api.g_varchar2_table(58) := '2020202020202020202020206E65774974656D732E756E7368696674287B20747970653A2027736570617261746F7227207D293B0A20202020202020207D0A0A20202020202020202F2F206D616B696E67207375726520776520646F6E277420656E6420';
wwv_flow_api.g_varchar2_table(59) := '7570207769746820636F6E736563757469766520736570617261746F72730A202020202020202069662028636F6E6669672E616464536570617261746F724166746572202626206D656E754974656D735B706F736974696F6E5D202626206D656E754974';
wwv_flow_api.g_varchar2_table(60) := '656D735B706F736974696F6E5D2E7479706520213D2027736570617261746F722729207B0A2020202020202020202020206E65774974656D732E70757368287B20747970653A2027736570617261746F7227207D293B0A20202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(61) := '2020202020202F2F20696E73657274696E6720746865206974656D73206174206120737065636966696320706F736974696F6E0A20202020202020206D656E754974656D73203D206D656E754974656D732E736C69636528302C20706F736974696F6E29';
wwv_flow_api.g_varchar2_table(62) := '2E636F6E636174286E65774974656D73292E636F6E636174286D656E754974656D732E736C69636528706F736974696F6E29293B0A0A2020202020202020696620286D656E752429207B0A2020202020202020202020206D656E75242E6D656E7528276F';
wwv_flow_api.g_varchar2_table(63) := '7074696F6E272C20276974656D73272C206D656E754974656D73293B0A20202020202020207D20656C73652069662028746F6F6C6261724D656E7529207B0A202020202020202020202020746F6F6C6261724D656E752E6974656D73203D206D656E7549';
wwv_flow_api.g_varchar2_table(64) := '74656D733B0A20202020202020207D0A0A202020207D20656C73652069662028616464546F546F6F6C62617229207B0A202020202020202076617220746F6F6C62617224203D20726567696F6E2E63616C6C2827676574546F6F6C62617227293B0A2020';
wwv_flow_api.g_varchar2_table(65) := '20202020202076617220746F6F6C62617244617461203D20746F6F6C626172242E746F6F6C62617228276F7074696F6E272C20276461746127293B0A202020202020202076617220746F6F6C62617247726F7570203D20746F6F6C626172242E746F6F6C';
wwv_flow_api.g_varchar2_table(66) := '626172282766696E6447726F7570272C20746F6F6C62617247726F75704964293B0A202020202020202076617220746F6F6C626172436F6E74726F6C73203D20746F6F6C62617247726F75702E636F6E74726F6C733B0A0A20202020202020202F2F7361';
wwv_flow_api.g_varchar2_table(67) := '6E6174697A696E672074686520706F736974696F6E0A202020202020202069662028706F736974696F6E203C2030207C7C20706F736974696F6E203E20746F6F6C626172436F6E74726F6C732E6C656E67746829207B0A20202020202020202020202070';
wwv_flow_api.g_varchar2_table(68) := '6F736974696F6E203D20746F6F6C626172436F6E74726F6C732E6C656E6774683B0A20202020202020207D0A0A2020202020202020746F6F6C626172436F6E74726F6C732E73706C69636528706F736974696F6E2C20302C207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(69) := '202020747970653A2027425554544F4E272C0A2020202020202020202020202F2F6C6162656C3A206C6162656C2C20202020202F2F20697320696E686572697465642066726F6D20616374696F6E0A2020202020202020202020202F2F7469746C653A20';
wwv_flow_api.g_varchar2_table(70) := '6C6162656C2C0A202020202020202020202020616374696F6E3A20616374696F6E4E616D652C0A202020202020202020202020686F743A206973486F742C0A20202020202020202020202069636F6E4F6E6C793A20216C6162656C2C0A20202020202020';
wwv_flow_api.g_varchar2_table(71) := '202020202069636F6E4265666F72654C6162656C3A20747275652C0A20202020202020202020202069636F6E3A2069636F6E203F20282766612027202B2069636F6E29203A2027270A20202020202020207D293B0A2020202020202020746F6F6C626172';
wwv_flow_api.g_varchar2_table(72) := '242E746F6F6C62617228276F7074696F6E272C202764617461272C20746F6F6C62617244617461293B0A202020207D0A0A202020202F2F20696E207468652063617365206F66206120636F6E646974696F6E616C20526F7720416374696F6E7320627574';
wwv_flow_api.g_varchar2_table(73) := '746F6E2C2068696465206F722064697361626C65206265666F72652065616368206D656E75206F70656E0A2020202069662028616464546F4D656E75202626206D656E754964203D3D2027726F772D616374696F6E732720262620636F6E646974696F6E';
wwv_flow_api.g_varchar2_table(74) := '436F6C756D6E29207B0A2020202020202020677269642E726F77416374696F6E4D656E75242E6F6E28276D656E756265666F72656F70656E272C2066756E6374696F6E20286576656E742C20756929207B0A202020202020202020202020766172206772';
wwv_flow_api.g_varchar2_table(75) := '6964203D20726567696F6E2E63616C6C28276765745669657773272C20276772696427293B0A202020202020202020202020766172206D6F64656C203D20677269642E6D6F64656C3B0A202020202020202020202020766172207265636F7264203D2067';
wwv_flow_api.g_varchar2_table(76) := '7269642E676574436F6E746578745265636F726428677269642E76696577242E66696E6428272E6A732D6D656E75427574746F6E2E69732D6163746976652729295B305D3B0A20202020202020202020202076617220636F6E646974696F6E56616C7565';
wwv_flow_api.g_varchar2_table(77) := '203D206D6F64656C2E67657456616C7565287265636F72642C20636F6E646974696F6E436F6C756D6E2E746F5570706572436173652829293B0A0A202020202020202020202020616374696F6E73436F6E746578742E73686F7728616374696F6E4E616D';
wwv_flow_api.g_varchar2_table(78) := '65293B0A202020202020202020202020616374696F6E73436F6E746578742E656E61626C6528616374696F6E4E616D65293B0A0A20202020202020202020202069662028636F6E646974696F6E56616C7565203D3D202768696464656E2729207B0A2020';
wwv_flow_api.g_varchar2_table(79) := '2020202020202020202020202020616374696F6E73436F6E746578742E6869646528616374696F6E4E616D65293B0A2020202020202020202020207D0A20202020202020202020202069662028636F6E646974696F6E56616C7565203D3D202764697361';
wwv_flow_api.g_varchar2_table(80) := '626C65642729207B0A20202020202020202020202020202020616374696F6E73436F6E746578742E64697361626C6528616374696F6E4E616D65293B0A2020202020202020202020207D0A20202020202020207D293B0A202020207D0A7D3B0A';
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
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363726970742E6A73225D2C226E616D6573223A5B2277696E646F77222C22464F53222C22696E74657261637469766547726964222C22616464427574746F6E222C226461436F6E746578';
wwv_flow_api.g_varchar2_table(2) := '74222C22636F6E666967222C2261706578222C226465627567222C22696E666F222C22726567696F6E4964222C226166666563746564456C656D656E7473222C226964222C22726567696F6E53656C6563746F72222C22726567696F6E222C2274797065';
wwv_flow_api.g_varchar2_table(3) := '222C224572726F72222C22616374696F6E73436F6E74657874222C2263616C6C222C22616464546F546F6F6C626172222C22746F6F6C62617247726F75704964222C22616464546F4D656E75222C226D656E754964222C22706F736974696F6E222C2261';
wwv_flow_api.g_varchar2_table(4) := '64644174496E646578222C226C6162656C222C2269636F6E222C226973486F74222C22706B4974656D222C227072696D6172794B65794974656D222C22636F6E646974696F6E436F6C756D6E222C226576656E744E616D65222C2263616C6C6261636B22';
wwv_flow_api.g_varchar2_table(5) := '2C22616374696F6E4E616D65222C2273657454696D656F7574222C2246756E6374696F6E222C22616374696F6E222C226E616D65222C2269636F6E54797065222C22696E6465784F66222C2267726964222C226D6F64656C222C226576656E74222C2266';
wwv_flow_api.g_varchar2_table(6) := '6F637573456C656D656E74222C227265636F7264222C22676574436F6E746578745265636F7264222C226974656D222C2273657456616C7565222C226765745265636F72644964222C2264617461222C2274726967676572222C2273656C656374656452';
wwv_flow_api.g_varchar2_table(7) := '65636F726473222C22706B56616C756573222C226D6170222C224A534F4E222C22737472696E67696679222C226C6F6F6B7570222C22616464222C226D656E7524222C226D656E754974656D73222C22746F6F6C6261724D656E75222C22726F77416374';
wwv_flow_api.g_varchar2_table(8) := '696F6E4D656E7524222C226D656E75222C2273656C416374696F6E4D656E7524222C22746F6F6C626172222C226974656D73222C226C656E677468222C226E65774974656D73222C22616464536570617261746F724265666F7265222C22756E73686966';
wwv_flow_api.g_varchar2_table(9) := '74222C22616464536570617261746F724166746572222C2270757368222C22736C696365222C22636F6E636174222C22746F6F6C62617224222C22746F6F6C62617244617461222C22746F6F6C626172436F6E74726F6C73222C22636F6E74726F6C7322';
wwv_flow_api.g_varchar2_table(10) := '2C2273706C696365222C22686F74222C2269636F6E4F6E6C79222C2269636F6E4265666F72654C6162656C222C226F6E222C227569222C227669657724222C2266696E64222C22636F6E646974696F6E56616C7565222C2267657456616C7565222C2274';
wwv_flow_api.g_varchar2_table(11) := '6F557070657243617365222C2273686F77222C22656E61626C65222C2268696465222C2264697361626C65225D2C226D617070696E6773223A2241414141412C4F41414F432C4941414D442C4F41414F432C4B41414F2C4741433342442C4F41414F432C';
wwv_flow_api.g_varchar2_table(12) := '49414149432C674241416B42442C49414149432C694241416D422C4741457044442C49414149432C674241416742432C554141592C53414155432C45414157432C4741456A44432C4B41414B432C4D41414D432C4B41414B2C734341417543482C474145';
wwv_flow_api.g_varchar2_table(13) := '76442C49414349492C4541446D424C2C454141554D2C69424143442C47414147432C4741432F42432C45414169422C4941414D482C4541437642492C45414153502C4B41414B4F2C4F41414F4A2C4741457A422C49414149492C47414130422C6F424141';
wwv_flow_api.g_varchar2_table(14) := '66412C4541414F432C4B41436C422C4D41414D2C49414149432C4D41414D2C6F44414770422C49414149432C4541416942482C4541414F492C4B41414B2C6341453742432C45414165622C4541414F612C6141437442432C4541416942642C4541414F63';
wwv_flow_api.g_varchar2_table(15) := '2C6541437842432C45414159662C4541414F652C5541436E42432C4541415368422C4541414F67422C4F41436842432C454141576A422C4541414F6B422C5741436C42432C454141516E422C4541414F6D422C4D414366432C4541414F70422C4541414F';
wwv_flow_api.g_varchar2_table(16) := '6F422C4B414364432C4541415172422C4541414F71422C4D414366432C4541415374422C4541414F75422C6541436842432C4541416B4278422C4541414F77422C674241437A42432C454141597A422C4541414F79422C5541436E42432C454141573142';
wwv_flow_api.g_varchar2_table(17) := '2C4541414F30422C5341476C42432C4541416133422C4541414F32422C594141632C694241416D42432C574141572C49414149432C5541477045432C454141532C4341435472422C4B41414D2C5341434E73422C4B41414D4A2C4541434E522C4D41414F';
wwv_flow_api.g_varchar2_table(18) := '412C45414350432C4B41414D412C4541434E592C534141552C4D4149642C474141496A422C474141612C434141432C634141652C7142414171426B422C514141516A422C494141572C454141472C43414778452C494141496B422C4541414F31422C4541';
wwv_flow_api.g_varchar2_table(19) := '414F492C4B41414B2C574141592C5141432F4275422C45414151442C4541414B432C4D4145482C654141566E422C45414341632C4541414F412C4F4141532C534141554D2C4541414F432C47414537422C49414149432C454141534A2C4541414B4B2C69';
wwv_flow_api.g_varchar2_table(20) := '4241416942462C474141632C4741453743662C4741434172422C4B41414B75432C4B41414B6C422C474141516D422C534141534E2C4541414D4F2C594141594A2C4941476A442C494141494B2C4541414F2C43414350502C4D41414F412C45414350432C';
wwv_flow_api.g_varchar2_table(21) := '61414163412C4541436437422C4F414151412C4541435232422C4D41414F412C45414350472C4F414151412C47414752622C4741434178422C4B41414B6D432C4D41414D512C5141415172432C45414167426B422C454141576B422C47414739436A422C';
wwv_flow_api.g_varchar2_table(22) := '47414341412C45414153642C4B41414B2C434141432B422C4B41414D412C4B41475A2C714241415633422C49414350632C4541414F412C4F4141532C534141554D2C4541414F432C47414537422C49414149512C4541416B4272432C4541414F492C4B41';
wwv_flow_api.g_varchar2_table(23) := '414B2C7342414539422B422C4541414F2C43414350502C4D41414F412C45414350432C61414163412C4541436437422C4F414151412C4541435232422C4D41414F412C45414350552C674241416942412C47414772422C4741414976422C454141512C43';
wwv_flow_api.g_varchar2_table(24) := '4143522C4941414977422C45414157442C4541416742452C4B4141492C53414155542C4741437A432C4F41414F482C4541414D4F2C594141594A2C4D4145374272432C4B41414B75432C4B41414B6C422C474141516D422C534141534F2C4B41414B432C';
wwv_flow_api.g_varchar2_table(25) := '55414155482C494147314372422C4741434178422C4B41414B6D432C4D41414D512C5141415172432C45414167426B422C454141576B422C47414539436A422C47414341412C45414153642C4B41414B2C434141432B422C4B41414D412C57414D37426C';
wwv_flow_api.g_varchar2_table(26) := '422C454143414B2C4541414F412C4F4141532C534141554D2C4541414F432C47414337422C49414149462C4541415133422C4541414F492C4B41414B2C6B4241416B4275422C4D414331436C432C4B41414B6D432C4D41414D512C5141415172432C4541';
wwv_flow_api.g_varchar2_table(27) := '4167426B422C454141572C43414331436B422C4B41414D2C43414346502C4D41414F412C45414350432C61414163412C4541436437422C4F414151412C4541435232422C4D41414F412C4D41495A542C49414350492C4541414F412C4F4141532C534141';
wwv_flow_api.g_varchar2_table(28) := '554D2C4541414F432C47414337422C49414149462C4541415133422C4541414F492C4B41414B2C6B4241416B4275422C4D41433143542C45414153642C4B41414B2C434143562B422C4B41414D2C43414346502C4D41414F412C45414350432C61414163';
wwv_flow_api.g_varchar2_table(29) := '412C4541436437422C4F414151412C4541435232422C4D41414F412C4F416133422C47414C4B78422C4541416575432C4F41414F76422C494143764268422C4541416577432C4941414972422C4741496E42662C454141572C434143582C494141497143';
wwv_flow_api.g_varchar2_table(30) := '2C45414341432C45414341432C454145552C6541415674432C4541454171432C47414441442C454141516C422C4541414B71422C674241434B432C4B41414B2C534141552C53414368422C714241415678432C4541455071432C47414441442C45414151';
wwv_flow_api.g_varchar2_table(31) := '6C422C4541414B75422C674241434B442C4B41414B2C534141552C53414368422C5741415678432C4941455071432C47414441432C4541416339432C4541414F492C4B41414B2C6341416338432C514141512C4F4141512C6B4241416B42462C4D41436C';
wwv_flow_api.g_varchar2_table(32) := '44472C514149784231432C454141572C4741414B412C454141576F432C454141554F2C554143724333432C454141576F432C454141554F2C5141497A422C49414149432C454141572C434141432C4341435A70442C4B41414D2C5341434E71422C4F4141';
wwv_flow_api.g_varchar2_table(33) := '51482C4941495233422C4541414F38442C6F4241417342542C4541415570432C454141572C49414173432C61414168436F432C4541415570432C454141572C47414147522C4D414368466F442C45414153452C514141512C4341414574442C4B41414D2C';
wwv_flow_api.g_varchar2_table(34) := '6341497A42542C4541414F67452C6D4241417142582C4541415570432C49414179432C61414135426F432C4541415570432C47414155522C4D414376456F442C45414153492C4B41414B2C4341414578442C4B41414D2C634149314234432C4541415941';
wwv_flow_api.g_varchar2_table(35) := '2C45414155612C4D41414D2C454141476A442C474141556B442C4F41414F4E2C474141554D2C4F41414F642C45414155612C4D41414D6A442C49414537456D432C45414341412C4541414D492C4B41414B2C534141552C51414153482C4741437642432C';
wwv_flow_api.g_varchar2_table(36) := '49414350412C454141594B2C4D4141514E2C51414772422C4741414978432C454141632C43414372422C4941414975442C4541415735442C4541414F492C4B41414B2C634143764279442C45414163442C45414153562C514141512C534141552C514145';
wwv_flow_api.g_varchar2_table(37) := '7A43592C45414465462C45414153562C514141512C5941416135432C4741436479442C5541472F4274442C454141572C4741414B412C4541415771442C4541416742562C554143334333432C4541415771442C4541416742562C5141472F42552C454141';
wwv_flow_api.g_varchar2_table(38) := '6742452C4F41414F76442C454141552C454141472C4341436843522C4B41414D2C5341474E71422C4F414151482C4541435238432C4941414B70442C4541434C71442C5541415776442C4541435877442C6942414169422C4541436A4276442C4B41414D';
wwv_flow_api.g_varchar2_table(39) := '412C454141512C4D414151412C454141512C4B41456C4367442C45414153562C514141512C534141552C4F414151572C4741496E4374442C47414175422C65414156432C4741413242512C4741437843552C4541414B71422C6541416571422C47414147';
wwv_flow_api.g_varchar2_table(40) := '2C6B4241416B422C5341415578432C4541414F79432C47414374442C4941414933432C4541414F31422C4541414F492C4B41414B2C574141592C5141432F4275422C45414151442C4541414B432C4D414362472C454141534A2C4541414B4B2C69424141';
wwv_flow_api.g_varchar2_table(41) := '69424C2C4541414B34432C4D41414D432C4B41414B2C3642414136422C4741433545432C454141694237432C4541414D38432C5341415333432C45414151642C454141674230442C654145354476452C4541416577452C4B41414B78442C474143704268';
wwv_flow_api.g_varchar2_table(42) := '422C4541416579452C4F41414F7A442C474145412C5541416C4271442C4741434172452C4541416530452C4B41414B31442C474145462C5941416C4271442C4741434172452C4541416532452C514141513344222C2266696C65223A227363726970742E';
wwv_flow_api.g_varchar2_table(43) := '6A73227D';
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
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F533D77696E646F772E464F537C7C7B7D2C77696E646F772E464F532E696E746572616374697665477269643D464F532E696E746572616374697665477269647C7C7B7D2C464F532E696E746572616374697665477269642E616464';
wwv_flow_api.g_varchar2_table(2) := '427574746F6E3D66756E6374696F6E28652C74297B617065782E64656275672E696E666F2822464F53202D20496E7465726163746976652047726964202D2041646420427574746F6E222C74293B766172206F3D652E6166666563746564456C656D656E';
wwv_flow_api.g_varchar2_table(3) := '74735B305D2E69642C6E3D2223222B6F2C613D617065782E726567696F6E286F293B69662821617C7C22496E74657261637469766547726964223D3D21612E74797065297468726F77206E6577204572726F722822546865207370656369666965642065';
wwv_flow_api.g_varchar2_table(4) := '6C656D656E74206973206E6F7420616E20496E746572616374697665204772696422293B76617220693D612E63616C6C2822676574416374696F6E7322292C723D742E616464546F546F6F6C6261722C633D742E746F6F6C62617247726F757049642C6C';
wwv_flow_api.g_varchar2_table(5) := '3D742E616464546F4D656E752C643D742E6D656E7549642C733D742E6164644174496E6465782C753D742E6C6162656C2C703D742E69636F6E2C6D3D742E6973486F742C663D742E7072696D6172794B65794974656D2C673D742E636F6E646974696F6E';
wwv_flow_api.g_varchar2_table(6) := '436F6C756D6E2C763D742E6576656E744E616D652C773D742E63616C6C6261636B2C623D742E616374696F6E4E616D657C7C22666F732D69672D627574746F6E2D222B73657454696D656F7574286E65772046756E6374696F6E292C793D7B747970653A';
wwv_flow_api.g_varchar2_table(7) := '22616374696F6E222C6E616D653A622C6C6162656C3A752C69636F6E3A702C69636F6E547970653A226661227D3B6966286C26265B22726F772D616374696F6E73222C2273656C656374696F6E2D616374696F6E73225D2E696E6465784F662864293E2D';
wwv_flow_api.g_varchar2_table(8) := '31297B76617220683D612E63616C6C28226765745669657773222C226772696422292C783D682E6D6F64656C3B22726F772D616374696F6E73223D3D643F792E616374696F6E3D66756E6374696F6E28652C74297B766172206F3D682E676574436F6E74';
wwv_flow_api.g_varchar2_table(9) := '6578745265636F72642874295B305D3B662626617065782E6974656D2866292E73657456616C756528782E6765745265636F72644964286F29293B76617220693D7B6576656E743A652C666F637573456C656D656E743A742C726567696F6E3A612C6D6F';
wwv_flow_api.g_varchar2_table(10) := '64656C3A782C7265636F72643A6F7D3B762626617065782E6576656E742E74726967676572286E2C762C69292C772626772E63616C6C287B646174613A697D297D3A2273656C656374696F6E2D616374696F6E73223D3D64262628792E616374696F6E3D';
wwv_flow_api.g_varchar2_table(11) := '66756E6374696F6E28652C74297B766172206F3D612E63616C6C282267657453656C65637465645265636F72647322292C693D7B6576656E743A652C666F637573456C656D656E743A742C726567696F6E3A612C6D6F64656C3A782C73656C6563746564';
wwv_flow_api.g_varchar2_table(12) := '5265636F7264733A6F7D3B69662866297B76617220723D6F2E6D6170282866756E6374696F6E2865297B72657475726E20782E6765745265636F726449642865297D29293B617065782E6974656D2866292E73657456616C7565284A534F4E2E73747269';
wwv_flow_api.g_varchar2_table(13) := '6E67696679287229297D762626617065782E6576656E742E74726967676572286E2C762C69292C772626772E63616C6C287B646174613A697D297D297D656C736520763F792E616374696F6E3D66756E6374696F6E28652C74297B766172206F3D612E63';
wwv_flow_api.g_varchar2_table(14) := '616C6C282267657443757272656E745669657722292E6D6F64656C3B617065782E6576656E742E74726967676572286E2C762C7B646174613A7B6576656E743A652C666F637573456C656D656E743A742C726567696F6E3A612C6D6F64656C3A6F7D7D29';
wwv_flow_api.g_varchar2_table(15) := '7D3A77262628792E616374696F6E3D66756E6374696F6E28652C74297B766172206F3D612E63616C6C282267657443757272656E745669657722292E6D6F64656C3B772E63616C6C287B646174613A7B6576656E743A652C666F637573456C656D656E74';
wwv_flow_api.g_varchar2_table(16) := '3A742C726567696F6E3A612C6D6F64656C3A6F7D7D297D293B696628692E6C6F6F6B75702862297C7C692E6164642879292C6C297B766172204F2C532C543B22726F772D616374696F6E73223D3D643F533D284F3D682E726F77416374696F6E4D656E75';
wwv_flow_api.g_varchar2_table(17) := '24292E6D656E7528226F7074696F6E222C226974656D7322293A2273656C656374696F6E2D616374696F6E73223D3D643F533D284F3D682E73656C416374696F6E4D656E7524292E6D656E7528226F7074696F6E222C226974656D7322293A2261637469';
wwv_flow_api.g_varchar2_table(18) := '6F6E73223D3D64262628533D28543D612E63616C6C2822676574546F6F6C62617222292E746F6F6C626172282266696E64222C22616374696F6E735F627574746F6E22292E6D656E75292E6974656D73292C28733C307C7C733E532E6C656E6774682926';
wwv_flow_api.g_varchar2_table(19) := '2628733D532E6C656E677468293B76617220493D5B7B747970653A22616374696F6E222C616374696F6E3A627D5D3B742E616464536570617261746F724265666F72652626535B732D315D262622736570617261746F7222213D535B732D315D2E747970';
wwv_flow_api.g_varchar2_table(20) := '652626492E756E7368696674287B747970653A22736570617261746F72227D292C742E616464536570617261746F7241667465722626535B735D262622736570617261746F7222213D535B735D2E747970652626492E70757368287B747970653A227365';
wwv_flow_api.g_varchar2_table(21) := '70617261746F72227D292C533D532E736C69636528302C73292E636F6E6361742849292E636F6E63617428532E736C696365287329292C4F3F4F2E6D656E7528226F7074696F6E222C226974656D73222C53293A54262628542E6974656D733D53297D65';
wwv_flow_api.g_varchar2_table(22) := '6C73652069662872297B76617220473D612E63616C6C2822676574546F6F6C62617222292C413D472E746F6F6C62617228226F7074696F6E222C226461746122292C463D472E746F6F6C626172282266696E6447726F7570222C63292E636F6E74726F6C';
wwv_flow_api.g_varchar2_table(23) := '733B28733C307C7C733E462E6C656E67746829262628733D462E6C656E677468292C462E73706C69636528732C302C7B747970653A22425554544F4E222C616374696F6E3A622C686F743A6D2C69636F6E4F6E6C793A21752C69636F6E4265666F72654C';
wwv_flow_api.g_varchar2_table(24) := '6162656C3A21302C69636F6E3A703F22666120222B703A22227D292C472E746F6F6C62617228226F7074696F6E222C2264617461222C41297D6C262622726F772D616374696F6E73223D3D642626672626682E726F77416374696F6E4D656E75242E6F6E';
wwv_flow_api.g_varchar2_table(25) := '28226D656E756265666F72656F70656E222C2866756E6374696F6E28652C74297B766172206F3D612E63616C6C28226765745669657773222C226772696422292C6E3D6F2E6D6F64656C2C723D6F2E676574436F6E746578745265636F7264286F2E7669';
wwv_flow_api.g_varchar2_table(26) := '6577242E66696E6428222E6A732D6D656E75427574746F6E2E69732D6163746976652229295B305D2C633D6E2E67657456616C756528722C672E746F5570706572436173652829293B692E73686F772862292C692E656E61626C652862292C2268696464';
wwv_flow_api.g_varchar2_table(27) := '656E223D3D632626692E686964652862292C2264697361626C6564223D3D632626692E64697361626C652862297D29297D3B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
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


