
Cairo Data Structures Playground
Exploring Cairo for implementing basic data structures and experimenting with the language's syntax.
Motivati
Project serves as a hands-on exploration of Cairo, aiming not only to enhance personal understanding of the language but also to contribute examples of Cairo syntax for others in the community. While prioritizing simplicity, I attempt to encapsulate functionality that might complicate users, even if t involves a trade-off, such as aintaining a length variable in a dictionary, potentially being slightly more expensive than a conventional Cairo implementation.

Implemented Data Structures
Lis

Methods:
new_list()
add(val: felt)
get(idx: felt)
remove(idx: felt)
replace(idx: felt, val: felt
contains(val: felt)
size()
Set
Methods:
new_set()
add(val: felt)
get(idx: felt)
remove(idx: felt)
replace(idx: felt, val: felt)
contains(val: felt)
size()
Queue
Methods:
new_queue()
add(val: felt)
peek()
poll()
size()
Minimum Heap
Methods
new_heap()
add(val: felt)
peek()
poll()
contains(val: felt)
size()
Examples

Explore usage examples in the respective test files: set_test.cairo, queue_test.cairo, and min_heap_test.cairo (Using Protostar).

Feel free to contribute, provide feedback, or leverage these data structures for your Cairo projects!
