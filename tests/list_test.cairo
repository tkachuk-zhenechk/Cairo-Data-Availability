%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.dict_access import DictAccess

from src.list import add, contains, get, new_list, remove, replace, size
from src.utils.constants import UNDEFINED

@external
func test_create_list_returns_an_empty_list{range_check_ptr}() {
    let list: DictAccess* = new_list(); 

    let list_size_result = size{list=list}();
    assert list_size_result = 0;

    return();
}

@external
func test_add_value{range_check_ptr}() {
    let list: DictAccess* = new_list(); 
    
    add{list=list}(5);

    let value_result = get{list=list}(0);
    assert value_result = 5;

    let list_size_result = size{list=list}();
    assert list_size_result = 1; 

    add{list=list}(12);

    let value_result = get{list=list}(1);
    assert value_result = 12;

    let list_size_result = size{list=list}();
    assert list_size_result = 2;

    add{list=list}(12);

    let value_result = get{list=list}(2);
    assert value_result = 12;

    let list_size_result = size{list=list}();
    assert list_size_result = 3;

    return();
}

@external
func test_remove_value{range_check_ptr}() {
    let list: DictAccess* = new_list();
    
    add{list=list}(5);
    add{list=list}(12);
    add{list=list}(1);
    let list_size_result = size{list=list}();
    assert list_size_result = 3;

    let removed_value = remove{list=list}(1);
    assert removed_value = 12;

    let value_result = get{list=list}(0);
    assert value_result = 5;

    let value_result = get{list=list}(1);
    assert value_result = 1;

    let list_size_result = size{list=list}();
    assert list_size_result = 2;

    return(); 
}


@external
func test_contains{range_check_ptr}() {
    let list: DictAccess* = new_list();
    
    add{list=list}(5);
    add{list=list}(12);
    add{list=list}(1);

    let contains_result = contains{list=list}(5);
    assert contains_result = TRUE;

    let contains_result = contains{list=list}(1);
    assert contains_result = TRUE;

    let contains_result = contains{list=list}(12);
    assert contains_result = TRUE;

    let contains_result = contains{list=list}(4);
    assert contains_result = FALSE;

    return(); 
}

@external
func test_replace{range_check_ptr}() {
    let list: DictAccess* = new_list();
    
    add{list=list}(5);
    add{list=list}(12);
    add{list=list}(1);

    let result_value = get{list=list}(2);
    assert result_value = 1;

    replace{list=list}(2, 6);
    let result_value = get{list=list}(2);
    assert result_value = 6;

    return();
}

@external
func test_get_out_bounds_value_returns_undefined{range_check_ptr}() {
    let list: DictAccess* = new_list();
    
    add{list=list}(5);

    let result_value = get{list=list}(2);
    assert result_value = UNDEFINED;

    return(); 
}

@external
func test_get_empty_list_returns_undefined{range_check_ptr}() {
    let list: DictAccess* = new_list();
    
    let result_value = get{list=list}(2);
    assert result_value = UNDEFINED;

    return(); 
}