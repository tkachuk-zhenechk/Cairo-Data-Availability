%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write, dict_read, dict_update
from starkware.cairo.common.dict_access import DictAccess

from src.utils.constants import SET_SIZE, UNDEFINED
from src.utils.comparator import is_ge

func new_set{range_check_ptr}() -> DictAccess* {
    alloc_locals;
    let (local set) = default_dict_new(default_value=UNDEFINED);
    // Persist the set size in the same dict so user dont has to worry about it
    dict_write{dict_ptr=set}(key=SET_SIZE, new_value=0);
    default_dict_finalize(dict_accesses_start=set, dict_accesses_end=set, default_value=UNDEFINED);

    return set;
}

func add{range_check_ptr, set: DictAccess*}(value: felt) { 
    alloc_locals;   
    let set_size = size();
    let (contains_value, _) = contains(value);
    if (contains_value == FALSE) {
        dict_write{dict_ptr=set}(key=set_size, new_value=value);
        // update set size
        dict_update{dict_ptr=set}(key=SET_SIZE, prev_value=set_size, new_value=set_size + 1);  
    } else {
        return ();
    }
    return ();
}

func get{range_check_ptr, set: DictAccess*}(idx: felt) -> felt {
    let set_size = size();
    if (set_size == 0) {
        return UNDEFINED;
    }
    
    tempvar idx_out_of_bounds = is_ge(idx, set_size); 
    if (idx_out_of_bounds == TRUE) {
        return UNDEFINED;
    }

    let (value) = dict_read{dict_ptr=set}(key=idx);
    return value;
}  

func remove{range_check_ptr, set: DictAccess*}(idx: felt) -> felt {
    alloc_locals;
    let value = get(idx);
    if (value != UNDEFINED) {
        let set_size = size();
        // update set size and build a set without that value
        _update_set(idx, set_size);
        dict_update{dict_ptr=set}(key=SET_SIZE, prev_value=set_size, new_value=set_size - 1);  
        return value;
    } else {
        return value;
    }
}

func replace{range_check_ptr, set: DictAccess*}(idx: felt, value: felt) {
    alloc_locals;
    let set_size = size();
    tempvar idx_out_of_bounds = is_ge(idx, set_size); 
    if (idx_out_of_bounds == TRUE) {
        return ();
    }

    let (contains_value, idx_value) = contains(value);
    if (contains_value == TRUE) {
        remove(idx_value);
        tempvar range_check_ptr=range_check_ptr;
        tempvar set=set;
    } else {
        tempvar range_check_ptr=range_check_ptr;
        tempvar set=set;
    }
    dict_write{dict_ptr=set}(key=idx, new_value=value);  
    
    return ();
}

func contains{range_check_ptr, set: DictAccess*}(value: felt) -> (contains: felt, idx: felt) {
    let set_size = size();
    return _contains(value, 0, set_size);
}   

func size{range_check_ptr, set: DictAccess*}() -> felt {
    let (set_size) = dict_read{dict_ptr=set}(key=SET_SIZE);
    return set_size;
}

// Aux methods 
func _contains{range_check_ptr, set: DictAccess*}(value: felt, idx: felt, set_size: felt) -> (contains: felt, idx: felt) {
    if (idx == set_size) {
        return (FALSE, UNDEFINED);
    }

    let (set_value) = dict_read{dict_ptr=set}(key=idx);
    if (set_value == value) {
        return (TRUE, idx);    
    }

    return _contains(value, idx + 1, set_size);
}

func _update_set{range_check_ptr, set: DictAccess*}(idx: felt, set_size: felt) {
    if (idx == set_size - 1) {
        return ();
    }
    // update every set value with the next one
    let (next_value) = dict_read{dict_ptr=set}(key=idx + 1);
    dict_write{dict_ptr=set}(key=idx, new_value=next_value);  

    return _update_set(idx + 1, set_size);
}