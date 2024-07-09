module infinite_sea_nft::sorted_u8_vector_util {

    use std::option;
    use std::option::Option;
    use std::vector;

    const EItemAlreadyExists: u64 = 1;
    const EItemNotFound: u64 = 3;
    //const EEmptyList: u64 = 4;
    //const EIncorrectListLength: u64 = 5;

    public fun sort_and_merge_u8_vectors(v1: &vector<u8>, v2: &vector<u8>): vector<u8> {
        let r = vector::empty<u8>();
        merge_u8_vector(&mut r, v1);
        merge_u8_vector(&mut r, v2);
        r
    }

    public fun new_u8_vector(o: &vector<u8>): vector<u8> {
        let r = vector::empty<u8>();
        merge_u8_vector(&mut r, o);
        r
    }

    public fun merge_u8_vector(v: &mut vector<u8>, v2: &vector<u8>) {
        let i = 0;
        let l = vector::length(v2);
        while (i < l) {
            let id = vector::borrow(v2, i);
            add_u8_if_not_exists(v, *id);
            i = i + 1;
        }
    }

    public fun add_u8_if_not_exists(v: &mut vector<u8>, id: u8) {
        let (idx, low) = binary_search_u8(v, id);
        if (option::is_none(&idx)) {
            vector::insert(v, id, low);
        };
    }

    public fun add_u8(v: &mut vector<u8>, id: u8) {
        let (idx, low) = binary_search_u8(v, id);
        if (option::is_some(&idx)) {
            abort EItemAlreadyExists
        };
        vector::insert(v, id, low);
    }

    public fun remove_u8(v: &mut vector<u8>, id: u8) {
        let (idx, _low) = binary_search_u8(v, id);
        assert!(option::is_some(&idx), EItemNotFound);
        let i = option::extract(&mut idx);
        vector::remove(v, i);
    }

    public fun find_u8(v: &vector<u8>, id: u8): Option<u64> {
        let (idx, _low) = binary_search_u8(v, id);
        idx
    }

    fun binary_search_u8(v: &vector<u8>, id: u8): (Option<u64>, u64) {
        let low = 0;
        let high = vector::length(v);
        while (low < high) {
            let mid = low + (high - low) / 2;
            let mid_value = vector::borrow(v, mid);
            //let c = compare::cmp_bcs_bytes(&object::id_to_bytes(mid_value), &object::id_to_bytes(&id));
            if (*mid_value == id) {
                //(c == EQUAL) {
                return (option::some(mid), low)
            } else if (*mid_value < id) {
                //(c == LESS_THAN) {
                low = mid + 1;
            } else {
                high = mid;
            };
        };
        (option::none<u64>(), low)
    }
}