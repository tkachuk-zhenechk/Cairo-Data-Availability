%lang starknet

from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.math import unsigned_div_rem
from src.utils.comparator import is_g, is_ge, is_l, _and
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_write, dict_read, dict_update

from src.utils.constants import HEAP_SIZE, UNDEFINED

// Credits: Based on @parketh max heap implementation (cairo-ds)

// Create an empty binary heap.
// @dev Empty dict entries are initialised at 'null'.
// @return heap : Pointer to empty dictionary containing heap
func new_heap{range_check_ptr}() -> DictAccess*{
    alloc_locals;
    let (local heap) = default_dict_new(default_value=UNDEFINED);
    default_dict_finalize(dict_accesses_start=heap, dict_accesses_end=heap, default_value=UNDEFINED);
    // Persist the heap size in the same dict so user dont has to worry about it
    dict_write{dict_ptr=heap}(key=HEAP_SIZE, new_value=0);

    return heap;
}

// Insert new value to min heap.
// @dev Heap must be passed as an implicit argument
// @param val : New value to insert into heap
// @return new_len : New length of heap
func add{range_check_ptr, heap: DictAccess*}(val: felt) {
    alloc_locals;
    let heap_size = size();
    // add value to heap
    dict_write{dict_ptr=heap}(key=heap_size, new_value=val);
    heapifyUp(heap_size, heap_size);

    // update heap size
    dict_write{dict_ptr=heap}(key=HEAP_SIZE, new_value=heap_size + 1);
    return();
}

func peek{range_check_ptr, heap: DictAccess*}() -> felt {
    alloc_locals;
    let heap_size = size();
    if (heap_size == 0) {
        return UNDEFINED;
    } 
    let (root) = dict_read{dict_ptr=heap}(key=0);
    return root;
}

// Delete root value from min heap.
// @dev Heap must be passed as an implicit argument
// @dev tempvars used to handle revoked references for implicit args
// @return root : Root value deleted from tree
func poll{range_check_ptr, heap: DictAccess*}() -> felt {
    alloc_locals; 
    let heap_size = size();
    if (heap_size == 0) {
        return UNDEFINED;
    } 
    let (root) = dict_read{dict_ptr=heap}(key=0);
    let (end) = dict_read{dict_ptr=heap}(key=heap_size - 1);
    dict_update{dict_ptr=heap}(key=heap_size - 1, prev_value=end, new_value= - 1);
    
    let heap_size_pos = is_le(2, heap_size);
    if (heap_size_pos == 1) {
        dict_update{dict_ptr=heap}(key=0, prev_value=root, new_value=end);
        heapifyDown(0, heap_size - 1);
        tempvar range_check_ptr=range_check_ptr;
        tempvar heap=heap;
    } else {
        tempvar range_check_ptr=range_check_ptr;
        tempvar heap=heap;
    }

    // update heap size
    dict_write{dict_ptr=heap}(key=HEAP_SIZE, new_value=heap_size - 1);
    return root;
}

func contains{range_check_ptr, heap: DictAccess*}(val: felt) -> felt {
    let heap_size = size();
    if (heap_size == 0) {
        return FALSE;
    }

    return _contains(val, 0, heap_size);
}

func size{range_check_ptr, heap: DictAccess*}() -> felt {
    let (heap_size) = dict_read{dict_ptr=heap}(key=HEAP_SIZE);
    return heap_size;
}

// Aux methods
func _contains{range_check_ptr, heap: DictAccess*}(val: felt, idx: felt, heap_size: felt) -> felt {
    if (idx == heap_size) {
        return FALSE;
    }

    let (heap_value) = dict_read{dict_ptr=heap}(key=idx);
    if (heap_value == val) {
        return TRUE;    
    }

    return _contains(val, idx + 1, heap_size);
}

func heapifyUp{range_check_ptr, heap: DictAccess*}(idx: felt, heap_size: felt) {
    alloc_locals;

    if (idx == 0) {
        return ();
    }

    let (parent_idx, _) = unsigned_div_rem(idx - 1, 2);
    let (node_value) = dict_read{dict_ptr=heap}(key=idx);
    let (parent_value) = dict_read{dict_ptr=heap}(key=parent_idx);
    let parent_is_greather = is_g(parent_value, node_value);
    
    if (parent_is_greather == FALSE) {
        return();
    }

    dict_update{dict_ptr=heap}(key=idx, prev_value=node_value, new_value=parent_value);
    dict_update{dict_ptr=heap}(key=parent_idx, prev_value=parent_value, new_value=node_value);

    return heapifyUp(parent_idx, heap_size);
}

func heapifyDown{range_check_ptr, heap: DictAccess*}(idx: felt, heap_size: felt) {
    alloc_locals;
    let (node_value) = dict_read{dict_ptr=heap}(key=idx);
    let node_has_left_child = has_left_child(idx, heap_size); 
    if (node_has_left_child == FALSE) {
        return();
    }
    let smallest_child_idx = get_smallest_child_idx(idx, heap_size);

    tempvar range_check_ptr = range_check_ptr;
    tempvar heap = heap;

    let (node_value) = dict_read{dict_ptr=heap}(key=idx);
    let (smallest_child_value) = dict_read{dict_ptr=heap}(key=smallest_child_idx);
    let node_value_is_smallest = is_l(node_value, smallest_child_value); // +1 for <
    
    if (node_value_is_smallest == TRUE) {
        return();
    } else {
        swap(idx, smallest_child_idx);
        tempvar range_check_ptr = range_check_ptr;
        tempvar heap = heap;
    }

    return heapifyDown(smallest_child_idx, heap_size); 
}

func get_smallest_child_idx{range_check_ptr, heap: DictAccess*}(idx: felt, heap_size: felt) -> felt {
    alloc_locals;
    let left_child_idx = get_left_child_idx(idx);
    let left_child_value = left_child(idx);

    let node_has_right_child = has_right_child(idx, heap_size);
    let right_child_value = right_child(idx);
    let right_child_is_smallest = is_l(right_child_value, left_child_value); // <
    
    let has_right_child_and_is_small = _and(node_has_right_child, right_child_is_smallest);
    if (has_right_child_and_is_small == TRUE) {
        let right_child_idx = get_right_child_idx(idx);
        return right_child_idx;
    } else {
        return left_child_idx;
    }
}

// Swap dictionary entries at two indices.
// @dev Heap must be passed as an implicit argument
// @param idx_a : Index of first dictionary entry to be swapped
// @param idx_b : Index of second dictionary entry to be swapped
func swap{range_check_ptr, heap: DictAccess*} (idx_a : felt, idx_b : felt) {
    let (elem_a) = dict_read{dict_ptr=heap}(key=idx_a);
    let (elem_b) = dict_read{dict_ptr=heap}(key=idx_b);
    dict_update{dict_ptr=heap}(key=idx_a, prev_value=elem_a, new_value=elem_b);
    dict_update{dict_ptr=heap}(key=idx_b, prev_value=elem_b, new_value=elem_a);
    return ();
}

func get_left_child_idx(parent_idx: felt) -> felt {
    return 2 * parent_idx + 1;
}

func get_right_child_idx(parent_idx: felt) -> felt {
    return 2 * parent_idx + 2;
}

func get_parent_idx{range_check_ptr}(child_idx: felt) -> felt {
    if (child_idx == 0) {
        return 0;
    }
    let (parent_idx, _) = unsigned_div_rem(child_idx - 1, 2);
    return parent_idx;
}

func has_left_child{range_check_ptr}(idx: felt, heap_size: felt) -> felt {
    let left_child_idx = get_left_child_idx(idx);
    let has_left_child = is_l(left_child_idx, heap_size); // get_right_child(idx) < heap_size
    
    return has_left_child;
}

func has_right_child{range_check_ptr}(idx: felt, heap_size: felt) -> felt {
    let right_child_idx = get_right_child_idx(idx);
    let has_right_child = is_l(right_child_idx, heap_size); // get_right_child(idx) < heap_size
    
    return has_right_child;
}

func has_parent{range_check_ptr}(idx: felt, heap_size: felt) -> felt {
    let parent_idx = get_parent_idx(idx);
    let has_parent = is_ge(parent_idx, 0);

    return has_parent;
}

func left_child{heap : DictAccess*}(parent_idx: felt) -> felt {
    let left_child_idx = get_left_child_idx(parent_idx);
    let (left_child) = dict_read{dict_ptr=heap}(key=left_child_idx);

    return left_child;
}

func right_child{heap : DictAccess*}(parent_idx: felt) -> felt {
    let right_child_idx = get_right_child_idx(parent_idx);
    let (right_child) = dict_read{dict_ptr=heap}(key=right_child_idx);

    return right_child;
}

func parent{range_check_ptr, heap : DictAccess*}(child_idx: felt) -> felt { 
    let parent_idx = get_parent_idx(child_idx);
    let (parent) = dict_read{dict_ptr=heap}(key=parent_idx);

    return parent;
}