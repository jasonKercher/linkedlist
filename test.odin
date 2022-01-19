package linkedlist

import "core:testing"

@test
test_linkedlist :: proc(t: ^testing.T) {
	head : ^Node(int)
	push(&head, 1)
	num := pop(&head)

	testing.expect_value(t, num, 1)
}
