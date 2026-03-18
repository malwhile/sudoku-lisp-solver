.PHONY: help build run-tests run-repl run-full-test clean run-breadth run-depth run-best

# Default target
help:
	@echo "Sudoku Lisp Solver - Available Targets:"
	@echo ""
	@echo "Docker Targets:"
	@echo "  make build              - Build the Docker image"
	@echo "  make run-repl           - Run interactive REPL in Docker"
	@echo ""
	@echo "Test Targets:"
	@echo "  make run-full-test      - Run all tests (all 3 algorithms on all 9 test cases)"
	@echo "  make run-breadth        - Run only breadth-first search tests"
	@echo "  make run-depth          - Run only depth-first search tests"
	@echo "  make run-best           - Run only best-first search tests"
	@echo ""
	@echo "Utility Targets:"
	@echo "  make clean              - Remove Docker image and clean up"

# Build the Docker image
build:
	@echo "Building Docker image..."
	docker build -t sudoku-lisp-solver:latest .
	@echo "Docker image built successfully!"

# Run interactive REPL
run-repl: build
	@echo "Starting Lisp REPL..."
	docker run -it --rm -v $(PWD):/app sudoku-lisp-solver:latest \
		--eval "(progn (format t \"~%Welcome to Sudoku Lisp Solver!~%\") (format t \"Loading files...~%\") (load \"/app/testmacros.lisp\") (format t \"Type (run-full-test) to run all tests~%\") (format t \"Type (run-individual-tests #'generic-breadth-first-queueing) for breadth-first~%\") (format t \"Type (quit) to exit~%~%\"))"

# Run full test suite
run-full-test: build
	@echo "Running full test suite (all algorithms on all test cases)..."
	docker run --rm -v $(PWD):/app sudoku-lisp-solver:latest \
		--eval "(progn (load \"/app/testmacros.lisp\") (run-full-test) (quit))"

# Run only breadth-first search tests
run-breadth: build
	@echo "Running breadth-first search tests..."
	docker run --rm -v $(PWD):/app sudoku-lisp-solver:latest \
		--eval "(progn (load \"/app/testmacros.lisp\") (format t \"Breadth First Search~%\") (run-individual-tests #'generic-breadth-first-queueing) (quit))"

# Run only depth-first search tests
run-depth: build
	@echo "Running depth-first search tests..."
	docker run --rm -v $(PWD):/app sudoku-lisp-solver:latest \
		--eval "(progn (load \"/app/testmacros.lisp\") (format t \"Depth First Search~%\") (run-individual-tests #'generic-depth-first-queueing) (quit))"

# Run only best-first search tests
run-best: build
	@echo "Running best-first search tests..."
	docker run --rm -v $(PWD):/app sudoku-lisp-solver:latest \
		--eval "(progn (load \"/app/testmacros.lisp\") (format t \"Best First Search~%\") (run-individual-tests #'generic-best-first-queueing) (quit))"

# Clean up
clean:
	@echo "Cleaning up Docker image..."
	docker rmi sudoku-lisp-solver:latest
	@echo "Cleanup complete!"
