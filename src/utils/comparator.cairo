%lang starknet
from starkware.cairo.common.bool import TRUE, FALSE

from starkware.cairo.common.math_cmp import is_le

// a > b
func is_g{range_check_ptr}(a: felt, b: felt) -> felt {
    return is_le(b + 1 , a);
}

// a >= b
func is_ge{range_check_ptr}(a: felt, b: felt) -> felt {
    return is_le(b, a);
}

// a < b
func is_l{range_check_ptr}(a: felt, b: felt) -> felt {
    return is_le(a + 1, b);
}

func _and(x, y) -> felt {
    if (x * y == 1){
        return TRUE;
    }
    return FALSE;
}