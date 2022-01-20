package linkedlist

Node :: struct($T: typeid) {
	data: T,
	prev: ^Node(T),
	next: ^Node(T),
}

new_node :: proc(data: $T) -> ^Node(T) {
	new_node := new(Node(T))
	new_node^ = {
		data = data,
	}
	return new_node
}

front :: top
top :: proc(node: ^Node($T)) -> ^Node(T) {
	if node == nil {
		return nil
	}

	node := node
	for ; node != nil && node.prev != nil; node = node.prev {}
	return node
}

back :: bottom
bottom :: proc(node: ^Node($T)) -> ^Node(T) {
	if node == nil {
		return nil
	}

	node := node
	for ; node != nil && node.next != nil; node = node.next {}
	return node
}

pop_node :: proc(head: ^^Node($T)) -> ^Node(T) {
	if head^ == nil {
		return nil
	}

	old_head := head^
	head^ = old_head.next
	old_head.next = nil
	return old_head
}

pop :: proc(head: ^^Node($T)) -> T {
	if head^ == nil {
		return T{}
	}
	old_head := pop_node(head)
	data := old_head.data
	free(old_head)
	return data
}

push :: proc(head: ^^Node($T), data: T) -> ^Node(T) {
	new_node := new_node(data)
	push_node(head, new_node)
	return new_node
}

push_node :: proc(head: ^^Node($T), new_node: ^Node(T)) {
	new_node.next = head^
	if head^ != nil {
		(head^).prev = new_node
	}
	new_node.prev = nil /* redundance */
	head^ = new_node
}

enqueue :: proc(head: ^^Node($T), data: T) -> ^Node(T) {
	new_node := new_node(data)
	enqueue_node(head, new_node)
	return new_node
}

enqueue_node :: proc(head: ^^Node($T), new_node: ^Node(T)) {
	back := node_back(head^)

	if back != nil {
		new_node.prev = back
		back.next = new_node
	}

	if head^ == nil {
		head^ = new_node
	}

	new_node.next = nil /* redundance */
}

at :: proc(head: ^Node($T), idx: int) -> ^Node(T) {
	iter := head
	for i := 0; iter != nil && i < idx; i += 1 {
		iter = iter.next
	}
	return iter
}

data_at :: proc(head: ^Node($T), idx: int) -> (data: T, ok: bool) {
	node := node_at(head, idx)
	if node == nil {
		return T{}, false
	}
	return node.data, true
}

export_node :: proc(node: ^Node($T)) -> ^Node(T) {
	if node == nil {
		return nil
	}

	if node.next != nil {
		node.next.prev = node.prev
	}
	if node.prev != nil {
		node.prev.next = node.next
	}

	node.next = nil
	node.prev = nil

	return node
}

remove :: proc(head: ^^Node($T), node: ^Node(T)) -> (data: T, ok: bool) {
	if node == nil {
		return T{}, false
	}

	if head^ == node {
		return pop(head), true
	}

	export_node(node)
	data = node.data
	free(node)
	return data, true
}

destroy_all :: proc(head: ^^Node($T)) {
	//head^ = nop(head^)
	for head := head ; node != nil; pop(head) {}
}
