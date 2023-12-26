%lang starknet

from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write, dict_read, dict_update
from starkware.cairo.common.dict_access import DictAccess

from src.utils.constants import QUEUE_SIZE, UNDEFINED

func new_queue{range_check_ptr}() -> DictAccess* {
    alloc_locals;
    let (local queue) = default_dict_new(default_value=UNDEFINED);
    // Persist the list size in the same dict so user dont has to worry about it
    dict_write{dict_ptr=queue}(key=QUEUE_SIZE, new_value=0);
    default_dict_finalize(dict_accesses_start=queue, dict_accesses_end=queue, default_value=UNDEFINED);

    return queue;
}

func add{range_check_ptr, queue: DictAccess*}(value: felt) {    
    let queue_size = size();
    dict_write{dict_ptr=queue}(key=queue_size, new_value=value);
    // update list size
    dict_update{dict_ptr=queue}(key=QUEUE_SIZE, prev_value=queue_size, new_value=queue_size + 1);  
      
    return ();
}

// Retrieves, but does not remove, the head of this queue, or returns null if this queue is empty.
func peek{range_check_ptr, queue: DictAccess*}() -> felt {
    let queue_size = size();
    if (queue_size == 0) {
        return UNDEFINED;
    }
    
    let (value) = dict_read{dict_ptr=queue}(key=0);
    return value;
}  

// Retrieves and removes the head of this queue, or returns null if this queue is empty.
func poll{range_check_ptr, queue: DictAccess*}() -> felt {
    alloc_locals;
    let queue_size = size();
    if (queue_size == 0) {
        return UNDEFINED;
    }
    
    let (value) = dict_read{dict_ptr=queue}(key=0);
    _update_queue(0, queue_size);
    dict_update{dict_ptr=queue}(key=QUEUE_SIZE, prev_value=queue_size, new_value=queue_size - 1);  
    return value;
}

func size{range_check_ptr, queue: DictAccess*}() -> felt {
    let (queue_size) = dict_read{dict_ptr=queue}(key=QUEUE_SIZE);
    return queue_size;
}


func _update_queue{range_check_ptr, queue: DictAccess*}(idx: felt, queue_size: felt) {
    if (idx == queue_size - 1) {
        return ();
    }
    // update every list value with the next one
    let (next_value) = dict_read{dict_ptr=queue}(key=idx + 1);
    dict_write{dict_ptr=queue}(key=idx, new_value=next_value);  

    return _update_queue(idx + 1, queue_size);
}