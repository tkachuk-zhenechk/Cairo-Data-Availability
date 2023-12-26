%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.dict_access import DictAccess

from src.queue import new_queue, add, size, peek, poll
from src.utils.constants import UNDEFINED

@external
func test_add{range_check_ptr}() {
    alloc_locals;
    let queue: DictAccess* = new_queue();
    add{queue=queue}(5);
    add{queue=queue}(7);
    add{queue=queue}(4);
    add{queue=queue}(12);
    add{queue=queue}(1);
    
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 5;

    return();
}

@external
func test_poll{range_check_ptr}() {
    alloc_locals;
    let queue: DictAccess* = new_queue();
    add{queue=queue}(5);
    add{queue=queue}(7);
    add{queue=queue}(4);
    add{queue=queue}(12);
    add{queue=queue}(1);
    
    let val = poll{queue=queue}();
    assert val = 5;
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 4;

    let val = poll{queue=queue}();
    assert val = 7;
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 3;

    let val = poll{queue=queue}();
    assert val = 4;
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 2;
    
    let val = poll{queue=queue}();
    assert val = 12;
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 1;

    let val = poll{queue=queue}();
    assert val = 1;
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 0;

    let val = poll{queue=queue}();
    assert val = UNDEFINED;
    let queue_size_result = size{queue=queue}();
    assert queue_size_result = 0;

    return();
}