.PHONY: compile_and_link

compile_and_link:
	gcc -o minimalist main.m -lobjc -framework AppKit

test: compile_and_link
	./minimalist
