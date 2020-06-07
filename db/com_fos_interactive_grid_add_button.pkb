CREATE OR REPLACE PACKAGE BODY COM_FOS_INTERACTIVE_GRID_ADD_BUTTON
IS
function render
    ( p_dynamic_action apex_plugin.t_dynamic_action
    , p_plugin         apex_plugin.t_plugin
    )
return apex_plugin.t_dynamic_action_render_result
as
    l_result           apex_plugin.t_dynamic_action_render_result;

    l_add_button_to    p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_alignment        p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;

    l_add_at_index     number :=
        case p_dynamic_action.attribute_02
            when 'first' then 0
            when 'last'  then -1
            else p_dynamic_action.attribute_03
        end;

    l_separator_before boolean := p_dynamic_action.attribute_04 like '%before%';
    l_separator_after  boolean := p_dynamic_action.attribute_04 like '%after%';

    l_label            p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;
    l_icon             p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    l_is_hot           boolean                            := p_dynamic_action.attribute_07 = 'Y';
    l_action_name      p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;
    l_condition_column p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;

    l_on_click         p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;
    l_pk_item          p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;
    l_javascript_code  p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;
    l_event_name       p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_13;
begin

    if apex_application.g_debug then
        apex_plugin_util.debug_dynamic_action
            ( p_plugin         => p_plugin
            , p_dynamic_action => p_dynamic_action
            );
    end if;

    apex_json.initialize_clob_output;
    apex_json.open_object;

    if l_add_button_to like 'toolbar-%' then
        apex_json.write('addToToolbar', true);
        apex_json.write('toolbarGroupId', substr(l_add_button_to, 9));
    elsif l_add_button_to like 'menu-%' then
        apex_json.write('addToMenu', true);
        apex_json.write('menuId', substr(l_add_button_to, 6));
    end if;

    apex_json.write('addAtIndex', l_add_at_index);

    apex_json.write('addSeparatorBefore', l_separator_before);
    apex_json.write('addSeparatorAfter', l_separator_after);

    apex_json.write('label', l_label);
    apex_json.write('icon', l_icon);
    apex_json.write('isHot', l_is_hot);

    apex_json.write('conditionColumn', l_condition_column);

    apex_json.write('actionName', l_action_name);

    case l_on_click
        when 'return-pks-into-item' then
            apex_json.write('primaryKeyItem', l_pk_item);
        when 'execute-javascript-code' then
            apex_json.write_raw('callback', 'function(){' || l_javascript_code || '}');
        when 'trigger-event' then
            apex_json.write('eventName', l_event_name);
        else
            null;
    end case;

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.interactiveGrid.addButton(this, ' || apex_json.get_clob_output || ');}';

    apex_json.free_output;

    return l_result;
end;
END COM_FOS_INTERACTIVE_GRID_ADD_BUTTON;
/


