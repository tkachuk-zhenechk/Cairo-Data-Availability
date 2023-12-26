%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.dict_access import DictAccess

from src.set import add, contains, get, new_set, remove, replace, size
from src.utils.constants import UNDEFINED

@external
func test_create_set_returns_an_empty_set{range_check_ptr}() {
    let set: DictAccess* = new_set();

    let set_size_result = size{set=set}();
    assert set_size_result = 0;

    return();
}

@external
func test_add_value{range_check_ptr}() {
    let set: DictAccess* = new_set(); 
    
    add{set=set}(5);

    let value_result = get{set=set}(0);
    assert value_result = 5;

    let set_size_result = size{set=set}();
    assert set_size_result = 1; 

    add{set=set}(12);

    let value_result = get{set=set}(1);
    assert value_result = 12;

    let set_size_result = size{set=set}();
    assert set_size_result = 2;

    // adding existing value 
    add{set=set}(12);
    let set_size_result = size{set=set}();
    assert set_size_result = 2;

    return();
}

@external
func test_remove_value{range_check_ptr}() {
    let set: DictAccess* = new_set();
    
    add{set=set}(5);
    add{set=set}(12);
    add{set=set}(1);
    let set_size_result = size{set=set}();
    assert set_size_result = 3;

    let removed_value = remove{set=set}(1);
    assert removed_value = 12;

    let value_result = get{set=set}(0);
    assert value_result = 5;

    let value_result = get{set=set}(1);
    assert value_result = 1;

    let set_size_result = size{set=set}();
    assert set_size_result = 2;

    return(); 
}


@external
func test_contains{range_check_ptr}() {
    let set: DictAccess* = new_set();
    
    add{set=set}(5);
    add{set=set}(12);
    add{set=set}(1);

    let (contains_result, _) = contains{set=set}(5);
    assert contains_result = TRUE;

    let (contains_result, _) = contains{set=set}(1);
    assert contains_result = TRUE;

    let (contains_result, _) = contains{set=set}(12);
    assert contains_result = TRUE;

    let (contains_result, _) = contains{set=set}(4);
    assert contains_result = FALSE;

    return(); 
}

@external
func test_replace{range_check_ptr}() {
    let set: DictAccess* = new_set();
    
    add{set=set}(5);
    add{set=set}(12);
    add{set=set}(1);

    let result_value = get{set=set}(2);
    assert result_value = 1;

    replace{set=set}(2, 6);
    let result_value = get{set=set}(2);
    assert result_value = 6;

    return();
}

@external
func test_replace_an_existing_value{range_check_ptr}() {
    let set: DictAccess* = new_set();
    
    add{set=set}(5);
    add{set=set}(12);
    add{set=set}(1);
    add{set=set}(4);

    let result_value = get{set=set}(1);
    assert result_value = 12;

    replace{set=set}(1, 4);
    let result_value = get{set=set}(1);
    assert result_value = 4;

    let result_size = size{set=set}();
    assert result_size = 3;

    return();
}

@external
func test_get_out_bounds_value_returns_undefined{range_check_ptr}() {
    let set: DictAccess* = new_set();
    
    add{set=set}(5);

    let result_value = get{set=set}(2);
    assert result_value = UNDEFINED;

    return();
}

@external
func test_get_empty_set_returns_undefined{range_check_ptr}() {
    let set: DictAccess* = new_set();
    
    let result_value = get{set=set}(2);
    assert result_value = UNDEFINED;

    return();
}