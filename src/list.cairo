%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write, dict_read, dict_update
from starkware.cairo.common.dict_access import DictAccess

from src.utils.constants import LIST_SIZE, UNDEFINED
from src.utils.comparator import is_ge

func new_list{range_check_ptr}() -> DictAccess* {
    alloc_locals;
    let (local list) = default_dict_new(default_value=UNDEFINED);
    // Persist the list size in the same dict so user dont has to worry about it
    dict_write{dict_ptr=list}(key=LIST_SIZE, new_value=0);
    default_dict_finalize(dict_accesses_start=list, dict_accesses_end=list, default_value=UNDEFINED);

    return list;
}

func add{range_check_ptr, list: DictAccess*}(value: felt) {    
    let list_size = size();
    dict_write{dict_ptr=list}(key=list_size, new_value=value);
    // update list size
    dict_update{dict_ptr=list}(key=LIST_SIZE, prev_value=list_size, new_value=list_size + 1);  
      
    return ();
}

func get{range_check_ptr, list: DictAccess*}(idx: felt) -> felt {
    let list_size = size();
    if (list_size == 0) {
        return UNDEFINED;
    }
    
    tempvar idx_out_of_bounds = is_ge(idx, list_size); 
    if (idx_out_of_bounds == TRUE) {
        return UNDEFINED;
    }

    let (value) = dict_read{dict_ptr=list}(key=idx);
    return value;
}  

// Remove an item it costs O(N) since we have to rebuild the list :( 
func remove{range_check_ptr, list: DictAccess*}(idx: felt) -> felt {
    alloc_locals;
    let value = get(idx);
    if (value != UNDEFINED) {
        let list_size = size();
        // update list size and build a list without that value
        _update_list(idx, list_size);
        dict_update{dict_ptr=list}(key=LIST_SIZE, prev_value=list_size, new_value=list_size - 1);  
        return value;
    } else {
        return value;
    }
}

func replace{range_check_ptr, list: DictAccess*}(idx: felt, value: felt) {
    let list_size = size();
    tempvar idx_out_of_bounds = is_ge(idx, list_size); 
    if (idx_out_of_bounds == TRUE) {
        return ();
    }

    dict_write{dict_ptr=list}(key=idx, new_value=value);  
    return ();
}

func contains{range_check_ptr, list: DictAccess*}(value: felt) -> felt {
    let list_size = size();
    return _contains(value, 0, list_size);
}   

func size{range_check_ptr, list: DictAccess*}() -> felt {
    let (list_size) = dict_read{dict_ptr=list}(key=LIST_SIZE);
    return list_size;
}

// Aux methods 
func _contains{range_check_ptr, list: DictAccess*}(value: felt, idx: felt, list_size: felt) -> felt {
    if (idx == list_size) {
        return FALSE;
    }

    let (list_value) = dict_read{dict_ptr=list}(key=idx);
    if (list_value == value) {
        return TRUE;    
    }

    return _contains(value, idx + 1, list_size);
}

func _update_list{range_check_ptr, list: DictAccess*}(idx: felt, list_size: felt) {
    if (idx == list_size - 1) {
        return ();
    }
    // update every list value with the next one
    let (next_value) = dict_read{dict_ptr=list}(key=idx + 1);
    dict_write{dict_ptr=list}(key=idx, new_value=next_value);  

    return _update_list(idx + 1, list_size);
}