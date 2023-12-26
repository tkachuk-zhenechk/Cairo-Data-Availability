%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.dict_access import DictAccess

from src.min_heap import new_heap, poll, add, size, contains, peek
from src.utils.constants import UNDEFINED

@external
func test_add{range_check_ptr}() {
    alloc_locals;
    let heap: DictAccess* = new_heap();
    add{heap=heap}(5);
    add{heap=heap}(7);
    add{heap=heap}(4);
    add{heap=heap}(12);
    add{heap=heap}(1);
    
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 5;

    return();
}

@external
func test_poll{range_check_ptr}() {
    alloc_locals;
    let heap: DictAccess* = new_heap();
    add{heap=heap}(5);
    add{heap=heap}(7);
    add{heap=heap}(4);
    add{heap=heap}(12);
    add{heap=heap}(1);

    let val = poll{heap=heap}();
    assert val = 1;
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 4;

    let val = poll{heap=heap}();
    assert val = 4;
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 3;

    let val = poll{heap=heap}();
    assert val = 5;
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 2;

    let val = poll{heap=heap}();
    assert val = 7;
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 1;

    let val = poll{heap=heap}();
    assert val = 12;
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 0;
    
    let val = poll{heap=heap}();
    assert val = UNDEFINED;
    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 0;

    return ();
}

@external
func test_contains{range_check_ptr}() {
    alloc_locals;
    let heap: DictAccess* = new_heap();
    add{heap=heap}(5);
    add{heap=heap}(7);
    add{heap=heap}(1);

    let contains_result = contains{heap=heap}(5);
    assert contains_result = TRUE;

    let contains_result = contains{heap=heap}(1);
    assert contains_result = TRUE;

    let contains_result = contains{heap=heap}(7);
    assert contains_result = TRUE;

    let contains_result = contains{heap=heap}(2);
    assert contains_result = FALSE;

    return ();
}


@external
func test_peek{range_check_ptr}() {
    alloc_locals;
    let heap: DictAccess* = new_heap();
    add{heap=heap}(5);
    add{heap=heap}(7);
    add{heap=heap}(1);

    let peek_result = peek{heap=heap}();
    assert peek_result = 1;

    let heap_size_result = size{heap=heap}();
    assert heap_size_result = 3;

    return ();
}
