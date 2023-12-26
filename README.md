# Data Structures in Cairo
Just me playing with Cairo while learning about the language and implementing basic data structures.

## Motivation
Mainly to learn more about the language, but also to contribute so that there are more examples of the Cairo syntax (who knows, maybe someone uses this and finds it useful).

**Notes**: 
I'm aiming to try to encapsulate functionality that complicates the user, for example always taking into account the length of the data structure. The trade-off is that we're constantly updating that variable in a dict and it's maybe a bit more expensive than a conventional implementation in Cairo, but I wanted to give you that approach.

## What have we done so far?
## - [List](https://github.com/sdgalvan/data-structures-cairo/blob/master/src/list.cairo) 

#### Methods
```
- new_list()
- add(val: felt)
- get(idx: felt)
- remove(idx: felt)
- replace(idx: felt, val: felt)
- contains(val: felt)
- size()
```

## - [Set](https://github.com/sdgalvan/data-structures-cairo/blob/master/src/set.cairo) 

#### Methods
```
- new_set()
- add(val: felt)
- get(idx: felt)
- remove(idx: felt)
- replace(idx: felt, val: felt)
- contains(val: felt)
- size()
```

Can see examples of use on the [set_test.cairo](https://github.com/sdgalvan/data-structures-cairo/blob/master/tests/set_test.cairo) (Using Protostar)

## - [Queue](https://github.com/sdgalvan/data-structures-cairo/blob/master/src/queue.cairo) 

#### Methods
```
- new_queue()
- add(val: felt)
- peek()
- poll()
- size()
```

Can see examples of use on the [queue_test.cairo](https://github.com/sdgalvan/data-structures-cairo/blob/master/tests/queue_test.cairo) (Using Protostar)

## - [Minimun Heap](https://github.com/sdgalvan/data-structures-cairo/blob/master/src/min_heap.cairo) 

#### Methods
```
- new_heap()
- add(val: felt)
- peek()
- poll()
- contains(val: felt)
- size()
```

Can see examples of use on the [min_heap_test.cairo](https://github.com/sdgalvan/data-structures-cairo/blob/master/tests/min_heap_test.cairo) (Using Protostar)
